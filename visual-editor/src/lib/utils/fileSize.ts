const cache = new Map<string, Promise<number>>();

export function getFileSize(value: string, fileType: string): Promise<number> {
    const cached = cache.get(value || '');
    if (cached) {
        return cached;
    }

    if (fileType === 'image_preview' || !value) {
        return Promise.resolve(String(value || '').length);
    }

    const res = fetch(value)
        .then(res => res.blob())
        .then(blob => {
            return blob.size;
        });

    cache.set(value, res);

    return res;
}
