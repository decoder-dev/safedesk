import os
import sys

def rename_in_files(root_dir):
    for root, dirs, files in os.walk(root_dir):
        if '.git' in root:
            continue
        for file in files:
            file_path = os.path.join(root, file)
            # Skip python script itself
            if file == 'rename.py':
                continue
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                if 'safedesk' in content or 'SafeDesk' in content or 'SAFEDESK' in content:
                    content = content.replace('safedesk', 'safedesk')
                    content = content.replace('SafeDesk', 'SafeDesk')
                    content = content.replace('SAFEDESK', 'SAFEDESK')
                    with open(file_path, 'w', encoding='utf-8') as f:
                        f.write(content)
            except UnicodeDecodeError:
                pass # Binary file, skip

def rename_files_and_dirs(root_dir):
    # Rename from bottom up to avoid path breaking
    for root, dirs, files in os.walk(root_dir, topdown=False):
        if '.git' in root:
            continue
        for name in files + dirs:
            if 'safedesk' in name or 'SafeDesk' in name or 'SAFEDESK' in name:
                new_name = name.replace('safedesk', 'safedesk').replace('SafeDesk', 'SafeDesk').replace('SAFEDESK', 'SAFEDESK')
                old_path = os.path.join(root, name)
                new_path = os.path.join(root, new_name)
                os.rename(old_path, new_path)

if __name__ == '__main__':
    root_dir = os.path.abspath(os.path.dirname(__file__))
    print("Renaming contents...")
    rename_in_files(root_dir)
    print("Renaming files and directories...")
    rename_files_and_dirs(root_dir)
    print("Renaming completed.")
