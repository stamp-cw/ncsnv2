# t10k-images-idx3-ubyte.gz https://ai-studio-online.bj.bcebos.com/v1/4b21c83e22484caf8946f4e16ff2e32b41a915ff45cf47b990dff168b10879f6?responseContentDisposition=attachment%3Bfilename%3Dt10k-images-idx3-ubyte.gz&authorization=bce-auth-v1%2F5cfe9a5e1454405eb2a975c43eace6ec%2F2025-07-28T09%3A22%3A52Z%2F60%2F%2F7fc265bd0c5640d5d6fbf1710de2b83275cd751a8c87e556e8bc2513436ed976
# t10k-labels-idx1-ubyte.gz https://ai-studio-online.bj.bcebos.com/v1/6dd640149c014b838dc8f514b75be173ae89b1f14a7142d79d4c7b1a7dc3b059?responseContentDisposition=attachment%3Bfilename%3Dt10k-labels-idx1-ubyte.gz&authorization=bce-auth-v1%2F5cfe9a5e1454405eb2a975c43eace6ec%2F2025-07-28T09%3A23%3A19Z%2F60%2F%2F9886c737ebcc1e0d4e11dd616a27049eba2be2794e2638d3592afbf690926ce1
# train-images-idx3-ubyte.gz https://ai-studio-online.bj.bcebos.com/v1/464084bfc97447519ef63ec32eb81506ffda4d0ff37f42b7adf179ad648f2799?responseContentDisposition=attachment%3Bfilename%3Dtrain-images-idx3-ubyte.gz&authorization=bce-auth-v1%2F5cfe9a5e1454405eb2a975c43eace6ec%2F2025-07-28T09%3A23%3A33Z%2F60%2F%2F3aade13e4fb4acfd80e8e2ed5711b58e56e4558180d8c552cd0395d813eb2629
# train-labels-idx1-ubyte.gz https://ai-studio-online.bj.bcebos.com/v1/5bcb8b807ff0467b8d8404779e72135de1a3a69e9d374028b59301bf51ac75d2?responseContentDisposition=attachment%3Bfilename%3Dtrain-labels-idx1-ubyte.gz&authorization=bce-auth-v1%2F5cfe9a5e1454405eb2a975c43eace6ec%2F2025-07-28T09%3A23%3A49Z%2F60%2F%2Fdd52fd5bbbff21e2e4230f319eed99e46ffa98a59e368f43959a14b2a08ef228

#!/bin/bash

# 设置目标目录变量，用户可以修改这个值
TARGET_DIR="./mnist_data"

# 创建目标目录（如果不存在）
mkdir -p "$TARGET_DIR"

# 检查目录是否创建成功
if [ ! -d "$TARGET_DIR" ]; then
    echo "无法创建目录: $TARGET_DIR"
    exit 1
fi

# 下载文件列表（格式：文件名|URL）
DOWNLOAD_LIST=(
    "t10k-images-idx3-ubyte.gz|https://ai-studio-online.bj.bcebos.com/v1/4b21c83e22484caf8946f4e16ff2e32b41a915ff45cf47b990dff168b10879f6?responseContentDisposition=attachment%3Bfilename%3Dt10k-images-idx3-ubyte.gz&authorization=bce-auth-v1%2F5cfe9a5e1454405eb2a975c43eace6ec%2F2025-07-28T09%3A22%3A52Z%2F60%2F%2F7fc265bd0c5640d5d6fbf1710de2b83275cd751a8c87e556e8bc2513436ed976"
    "t10k-labels-idx1-ubyte.gz|https://ai-studio-online.bj.bcebos.com/v1/6dd640149c014b838dc8f514b75be173ae89b1f14a7142d79d4c7b1a7dc3b059?responseContentDisposition=attachment%3Bfilename%3Dt10k-labels-idx1-ubyte.gz&authorization=bce-auth-v1%2F5cfe9a5e1454405eb2a975c43eace6ec%2F2025-07-28T09%3A23%3A19Z%2F60%2F%2F9886c737ebcc1e0d4e11dd616a27049eba2be2794e2638d3592afbf690926ce1"
    "train-images-idx3-ubyte.gz|https://ai-studio-online.bj.bcebos.com/v1/464084bfc97447519ef63ec32eb81506ffda4d0ff37f42b7adf179ad648f2799?responseContentDisposition=attachment%3Bfilename%3Dtrain-images-idx3-ubyte.gz&authorization=bce-auth-v1%2F5cfe9a5e1454405eb2a975c43eace6ec%2F2025-07-28T09%3A23%3A33Z%2F60%2F%2F3aade13e4fb4acfd80e8e2ed5711b58e56e4558180d8c552cd0395d813eb2629"
    "train-labels-idx1-ubyte.gz|https://ai-studio-online.bj.bcebos.com/v1/5bcb8b807ff0467b8d8404779e72135de1a3a69e9d374028b59301bf51ac75d2?responseContentDisposition=attachment%3Bfilename%3Dtrain-labels-idx1-ubyte.gz&authorization=bce-auth-v1%2F5cfe9a5e1454405eb2a975c43eace6ec%2F2025-07-28T09%3A23%3A49Z%2F60%2F%2Fdd52fd5bbbff21e2e4230f319eed99e46ffa98a59e368f43959a14b2a08ef228"
)

# 下载并重命名文件
for item in "${DOWNLOAD_LIST[@]}"; do
    # 分割文件名和URL
    filename=$(echo "$item" | cut -d'|' -f1)
    url=$(echo "$item" | cut -d'|' -f2)

    echo "正在下载: $filename"

    # 下载到临时文件
    temp_file=$(mktemp -p "$TARGET_DIR")
    wget -O "$temp_file" "$url"

    # 检查下载是否成功
    if [ $? -eq 0 ]; then
        # 重命名为目标文件名
        mv "$temp_file" "$TARGET_DIR/$filename"
        echo "下载成功: $filename"
    else
        echo "下载失败: $filename"
        rm -f "$temp_file"
    fi
done

echo "所有文件已下载到: $TARGET_DIR"
echo "下载完成，文件列表:"
ls -lh "$TARGET_DIR"
