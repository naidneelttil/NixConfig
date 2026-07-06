# disko-config.nix
# Declarative disk layout for a single-disk NixOS AI workstation.
# WARNING: applying this ERASES the target disk.
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        # Change this to YOUR disk. NVMe drives are /dev/nvme0n1,
        # SATA/SSD drives are /dev/sda. Confirm with `lsblk` first.
        device = "/dev/nvme0n1";

        content = {
          type = "gpt";          # GPT partition table (modern, UEFI)
          partitions = {

            # ---- EFI system partition -> /boot ----
            ESP = {
              size = "1G";
              type = "EF00";      # GPT type code for an EFI System Partition
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];  # keep boot files private
              };
            };

            # ---- swap partition (overflow safety net) ----
            # For HIBERNATION: bump size to >= your RAM (>= 64G) and add
            # `resumeDevice = true;` inside the content block below.
            swap = {
              size = "16G";
              content = {
                type = "swap";
                discardPolicy = "both";  # TRIM, good for SSDs
              };
            };

            # ---- everything else -> one btrfs filesystem ----
            root = {
              size = "100%";       # take all remaining space
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];  # force mkfs even if a signature exists

                subvolumes = {
                  "@" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  # Models: NO compression (weights don't compress).
                  # To put models under home instead, change the
                  # mountpoint to "/home/youruser/models".
                  "@models" = {
                    mountpoint = "/var/lib/models";
                    mountOptions = [ "noatime" ];
                  };
                  "@snapshots" = {
                    mountpoint = "/.snapshots";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "@log" = {
                    mountpoint = "/var/log";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
