Return-Path: <io-uring+bounces-3069-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3908096F813
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 17:19:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB89D286D87
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 15:18:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EED81D04B6;
	Fri,  6 Sep 2024 15:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dG+lby7R"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6F21C86E4;
	Fri,  6 Sep 2024 15:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725635937; cv=none; b=r0FTt6TbK+7EVzKVsrRDk9oos0rnd8oELOYwUTKVhLn9HQeKlDJclOi1rFADBjMZCE9iEXapvnoFBrADAEqL0ScuqiFRSkP9eZEwYREjefIKiEzxPb6yt03I23a+5jJwnfQHUgCVCgzHUPFnkfpWJt/ewUVyigtEQA2QBJd2Vb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725635937; c=relaxed/simple;
	bh=CSsGUZSg5JQRrnYw+/ix+EK5hOvHoyLnn2NcYjjdY0Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TKp0G1qfuH9UHAgzS53mUof02DB2iUMH8U41vSZPFYOz3+uyf0rxRECs05RK4v913ga2mio8J9KFUUwVoNTT6LO2gwALsx/MC+oiiNSNfQqkPxPNyShnlDfWSu/BRjGukvqF4MjhlDgBPqdpqubcUsyLyBtuBUYe1m9cV78hqks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dG+lby7R; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a8692bbec79so291143166b.3;
        Fri, 06 Sep 2024 08:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725635933; x=1726240733; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ocvxIXeTIR1tFSZY86p+l9qmzqDlov2tIbfSxaQF/DM=;
        b=dG+lby7RAlIlwAARlGA5gs79pBkURdf5V3G2DTUfYE9pIxg4fW0bvOdjxQi03LYOKk
         QzsFAbow6E1LovjZWbQG6MBoymfL0ZUKcLbD2XkDBHTL7y6MxZJyVbE2XzAugMB02m2s
         RI6eNG+ZaHHnDs9XGKjKUbvKnvmiy3Ttx/SJxhZsf1geX757Hnr9elz/jVVp3Lb3h5Ts
         ucRzQKUobcy/c6WjH7vQzVTtBmXgWfn9rZwGsxycxxpkkiTn3ywRcqau03ad/2r7AEuB
         kfqIGjKAsKE3b9qEu7+TMCzfMo1MWH27ur2IqdwvaGsOe0y0wIsGX7T2EfC2rdQt3bxa
         4RPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725635933; x=1726240733;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ocvxIXeTIR1tFSZY86p+l9qmzqDlov2tIbfSxaQF/DM=;
        b=lse15Yc1S+Ah6cwiHJkJHML+raGQJC/SyESJ/L/w9yA9mQzohkMQkDa+t+NK3jPohG
         ML49DUJNWkSz71LAR9V5UmvkDvm0/S/bLzeZXUB1QOYcL3QdPYwk91EUxi6Qb8WlU5ls
         nJV95rRuso+89tJHK8QcAjbi9SMyHPFGxsJWbKNhETgzoIVB+RCI+fkqiYDrgN6ssQg/
         8adktZMN0EKD5gWbiyswLt6Kq89ZM+yEwatoL7TmvWxnBY4wXzvLOqaL8oIlelzpzKsB
         VhP0i9VLB8H1ac4NtINTZc6H88vIMACDACIp4hUvBqKVhydpyQW/bzl2cfuQ1DtuIulM
         OCzQ==
X-Forwarded-Encrypted: i=1; AJvYcCUav2KD2URvcr8dkCErnS7W0sFW+RVZ1eZZ3vGXEALCMdDp/YrItXWBJt8Za0e4KFMixbZZdebXXMeYSy4=@vger.kernel.org, AJvYcCXKdruoZ2oJs7/kdMJBiEmnue/fpyC5/tw+yBI7Sgfq78KbrbiFdI45mFLRueG68IlUweAdXD5whQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwENruEqXPo0ljijyXanDF9YH89kKE1FmJlBNN+yPX7Bgd1yPSY
	KuS4gRrUAShyIkTq3rRQxt8KpokXL6ih7htTsbhtka7NKCmMxgqvjzMN5h/z
X-Google-Smtp-Source: AGHT+IGP+5ktwRh+JjQFKsI2jJxsEOW4daTN2WwnsSkUrq5VC2Enn5xQCTSax75iUNuWV++V6bBaFg==
X-Received: by 2002:a17:907:961e:b0:a8a:af0c:dba9 with SMTP id a640c23a62f3a-a8aaf0cdf7fmr161646566b.16.1725635932736;
        Fri, 06 Sep 2024 08:18:52 -0700 (PDT)
Received: from [192.168.42.120] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d137af385sm4509066b.23.2024.09.06.08.18.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Sep 2024 08:18:52 -0700 (PDT)
Message-ID: <66518e84-1ea2-447e-a047-cd2e152417d1@gmail.com>
Date: Fri, 6 Sep 2024 16:19:25 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] btrfs: store encoded read state in struct
 btrfs_encoded_read_private
To: Mark Harmstone <maharmstone@fb.com>, io-uring@vger.kernel.org,
 linux-btrfs@vger.kernel.org
References: <20240823162810.1668399-1-maharmstone@fb.com>
 <20240823162810.1668399-3-maharmstone@fb.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240823162810.1668399-3-maharmstone@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/23/24 17:27, Mark Harmstone wrote:
> Move the various stack variables needed for encoded reads into struct
> btrfs_encoded_read_private, so that we can split it into several
> functions.
> 
> Signed-off-by: Mark Harmstone <maharmstone@fb.com>
> ---
>   fs/btrfs/btrfs_inode.h |  20 ++++-
>   fs/btrfs/inode.c       | 170 +++++++++++++++++++++--------------------
>   fs/btrfs/ioctl.c       |  60 ++++++++-------
>   3 files changed, 135 insertions(+), 115 deletions(-)
> 
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index affe70929234..5cd4308bd337 100644
...
>   
> -ssize_t btrfs_encoded_read(struct file *file, loff_t offset,
> -			   struct iov_iter *iter,
> -			   struct btrfs_ioctl_encoded_io_args *encoded)
> +ssize_t btrfs_encoded_read(struct btrfs_encoded_read_private *priv)
>   {
> -	struct btrfs_inode *inode = BTRFS_I(file_inode(file));
> +	struct btrfs_inode *inode = BTRFS_I(file_inode(priv->file));
>   	struct btrfs_fs_info *fs_info = inode->root->fs_info;
>   	struct extent_io_tree *io_tree = &inode->io_tree;
>   	ssize_t ret;
> -	size_t count = iov_iter_count(iter);
>   	u64 start, lockend, disk_bytenr, disk_io_size;
> -	struct extent_state *cached_state = NULL;
>   	struct extent_map *em;
>   	bool unlocked = false;
>   
> -	file_accessed(file);
> +	priv->count = iov_iter_count(&priv->iter);
> +
> +	file_accessed(priv->file);
>   
>   	btrfs_inode_lock(inode, BTRFS_ILOCK_SHARED);

Request submission should usually be short and not block
on IO or any locks that might wait for IO.

bool nowait = issue_flags & IO_URING_F_NONBLOCK;

btrfs_encoded_read(..., nowait) {
	f = BTRFS_ILOCK_SHARED;
	if (nowait)
		f |= BTRFS_ILOCK_TRY;
	if (btrfs_inode_lock(inode, f))
		return -EAGAIN; // io_uring will retry from a blocking context
}

so it might need sth like this here as well as for
filemap waiting and possibly other places.

>   
> -	if (offset >= inode->vfs_inode.i_size) {
> +	if (priv->args.offset >= inode->vfs_inode.i_size) {
>   		btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
>   		return 0;
>   	}
> -	start = ALIGN_DOWN(offset, fs_info->sectorsize);
> +	start = ALIGN_DOWN(priv->args.offset, fs_info->sectorsize);
>   	/*
> -	 * We don't know how long the extent containing offset is, but if
> -	 * it's compressed we know that it won't be longer than this.
> +	 * We don't know how long the extent containing priv->args.offset is,
> +	 * but if it's compressed we know that it won't be longer than this.
>   	 */
>   	lockend = start + BTRFS_MAX_UNCOMPRESSED - 1;
>   
...

-- 
Pavel Begunkov

