Return-Path: <io-uring+bounces-3068-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2D6696F7E2
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 17:10:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DEB661C21521
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 15:10:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B58E1D1F77;
	Fri,  6 Sep 2024 15:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AjYf3UqW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4390B1D1F56;
	Fri,  6 Sep 2024 15:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725635447; cv=none; b=DLfjmuLqrid0bxUMWDCUlfb45ySfSLE6H/w6mbydPPyNqVy75XKJW5gDhap81DX2e+68hXdBIaurjS1jTg7GhOadjLdZ38meV94u+W4+0duxoj1L7FToWolbJyA+cjX8BE/1nB3HJacLaPLBVSsvfNtBYhfoUp44TInVxMth+DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725635447; c=relaxed/simple;
	bh=i+t/fNrw4T10Eus90nnb7VH+5QGi1UY4wE4dcwg5FBQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=m5XP5IIA/3Fr1bqUEl0WKlWP0IukKQJzfQZgfVoFs+S3oGFSY9dl+bptL4ErPhA8S/B+8qKeTAKwm+74IqCv6KS3ML6KFeVd3Ut7d6rN9XmlSFg5YUCsEiS7uzep3hr5gjLS6oS4FZ5/Hpt8jto5lnnJZ7p4luiZ1ZvUp7iQXdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AjYf3UqW; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a868d7f92feso299607866b.2;
        Fri, 06 Sep 2024 08:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725635443; x=1726240243; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BK5K+HQ8FU3skoCuxhX88GuAhU3e+OoqmoVoL7JQIDY=;
        b=AjYf3UqWteA++hZdzm2Wrl1M8TD5mb9stf9qcUhcTYmBpV8R4RnZ5GYI5sE31LLEfX
         dSHEwjmMS9ND0seBpWqQbXf5l0QaVoMEn/rWge4mC6eMOj5l26ts+7vfGGaKTnI5ShDo
         wcbcHeiFh5ctGvqMFizQFzMvY5E9hAk5903qcr0tjCPQ5QICV99p3arRTMEHQ+rZSULu
         mZxSi5gZQ+Ka3HquFPNSVJfxcPxYktWPOjRlEd44e/fdE5FCxVm6irlXBb9f5kyBV7Cz
         L1C11mge3Is35U3TFD3uriGsN2HQD3ZRbsquLAQn11AoCPw/cNMUnIpJr/eAVgI8THrG
         GQWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725635443; x=1726240243;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BK5K+HQ8FU3skoCuxhX88GuAhU3e+OoqmoVoL7JQIDY=;
        b=UpyFY6GRPdNpc9u/dX2rLsM5PeA2o0nZ+YdBWuFEoCAkmunSYW5DloI3S/moiQG0Ev
         JYCleFaEzhjnlrHkQWHm1XSFQ+z6oEN1hz/Y5gf+eiLnAGrHewzWmA1d5aL7RHI80gil
         GbqD/4VRKVwIyEy4/3FoJQm83fKGvNCXs4v+ljJwL+pQ08K/VKS4kS8uz42LDxky3a5R
         aKRYgA++EQ63YYvlsi+r5zjg6suEbBPdn4Zx0eVNwoeb+lrZOqdbCr08UACpcrhXB/fk
         0Rfq/7kmYrHdRQry5Mp+4T2KhX82W2PiLUMaKNFj84n+pwU6eokWoAVIMTSnuhU0rAGs
         N2IA==
X-Forwarded-Encrypted: i=1; AJvYcCX+Bby05QvdIIgCIUSuMPgCGFRBjz1B027M1A351bgx4Eql0eAMx0ER6oEKThaMhNBJxxRtgnZatw==@vger.kernel.org, AJvYcCXZGjbGn+dWrhDfupJj7w5qU8MsQh1HdgspTpEKZ0IhH/iWAxE+gtskzv6mHupF0kY8iHl5Pw6QenUwVis=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6OhHib1bAI9CzzU8DFe2PT2on/leBz3LddSXPtlHn7t7vyIAD
	ETRnSWvfxqGTyGs8rTvs9q0gxp9IzY6vlz2BZCbFbeiLoInThODE
X-Google-Smtp-Source: AGHT+IEHZk4MfYzZ/+9VpZ4SBCKz3jBrA8PAIbC7iVjj7I3vCLdV4duwiVy3beJC8Iupuh/mh7Uwrw==
X-Received: by 2002:a17:906:f59f:b0:a86:7fc3:8620 with SMTP id a640c23a62f3a-a897f8bd0d3mr2143548366b.31.1725635443270;
        Fri, 06 Sep 2024 08:10:43 -0700 (PDT)
Received: from [192.168.42.120] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8a84784cfdsm132329466b.118.2024.09.06.08.10.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Sep 2024 08:10:42 -0700 (PDT)
Message-ID: <61d13795-17ba-4715-bf3a-2d7da0b300c7@gmail.com>
Date: Fri, 6 Sep 2024 16:11:16 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] btrfs: move wait out of btrfs_encoded_read
To: Mark Harmstone <maharmstone@fb.com>, io-uring@vger.kernel.org,
 linux-btrfs@vger.kernel.org
References: <20240823162810.1668399-1-maharmstone@fb.com>
 <20240823162810.1668399-6-maharmstone@fb.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240823162810.1668399-6-maharmstone@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/23/24 17:27, Mark Harmstone wrote:
> Makes it so that if btrfs_encoded_read has launched a bio, rather than
> waiting for it to complete it leaves the extent and inode locked and returns
> -EIOCBQUEUED. The caller is responsible for waiting on the bio, and
> calling the completion code in the new btrfs_encoded_read_regular_end.
> 
> Signed-off-by: Mark Harmstone <maharmstone@fb.com>
> ---
>   fs/btrfs/btrfs_inode.h |  1 +
>   fs/btrfs/inode.c       | 81 +++++++++++++++++++++++-------------------
>   fs/btrfs/ioctl.c       |  8 +++++
>   3 files changed, 54 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index f4d77c3bb544..a5d786c6d7d4 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -623,6 +623,7 @@ struct btrfs_encoded_read_private {
>   };
>   
>   ssize_t btrfs_encoded_read(struct btrfs_encoded_read_private *priv);
> +ssize_t btrfs_encoded_read_regular_end(struct btrfs_encoded_read_private *priv);
>   ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
>   			       const struct btrfs_ioctl_encoded_io_args *encoded);
>   
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 1e53977a4854..1bd4c74e8c51 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8999,7 +8999,7 @@ static ssize_t btrfs_encoded_read_inline(
>   				struct extent_state **cached_state,
>   				u64 extent_start, size_t count,
>   				struct btrfs_ioctl_encoded_io_args *encoded,
> -				bool *unlocked)
> +				bool *need_unlock)
>   {
>   	struct btrfs_root *root = inode->root;
>   	struct btrfs_fs_info *fs_info = root->fs_info;
> @@ -9067,7 +9067,7 @@ static ssize_t btrfs_encoded_read_inline(
>   	btrfs_release_path(path);
>   	unlock_extent(io_tree, start, lockend, cached_state);
>   	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
> -	*unlocked = true;
> +	*need_unlock = false;
>   
>   	ret = copy_to_iter(tmp, count, iter);
>   	if (ret != count)
> @@ -9155,42 +9155,26 @@ int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
>   	return blk_status_to_errno(READ_ONCE(priv.status));
>   }
>   
> -static ssize_t btrfs_encoded_read_regular(struct btrfs_encoded_read_private *priv,
> -					  u64 start, u64 lockend,
> -					  u64 disk_bytenr, u64 disk_io_size,
> -					  bool *unlocked)
> +ssize_t btrfs_encoded_read_regular_end(struct btrfs_encoded_read_private *priv)
> -	struct btrfs_inode *inode = BTRFS_I(file_inode(priv->file));
> -	struct extent_io_tree *io_tree = &inode->io_tree;
> +	u64 cur, start, lockend;
>   	unsigned long i;
> -	u64 cur;
>   	size_t page_offset;
> -	ssize_t ret;
> -
> -	priv->nr_pages = DIV_ROUND_UP(disk_io_size, PAGE_SIZE);
> -	priv->pages = kcalloc(priv->nr_pages, sizeof(struct page *), GFP_NOFS);
> -	if (!priv->pages) {
> -		priv->nr_pages = 0;
> -		return -ENOMEM;
> -	}
> -	ret = btrfs_alloc_page_array(priv->nr_pages, priv->pages, false);
> -	if (ret)
> -		return -ENOMEM;
> +	struct btrfs_inode *inode = BTRFS_I(file_inode(priv->file));
> +	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> +	struct extent_io_tree *io_tree = &inode->io_tree;
> +	int ret;
> -	_btrfs_encoded_read_regular_fill_pages(inode, start, disk_bytenr,
> -					       disk_io_size, priv);
> +	start = ALIGN_DOWN(priv->args.offset, fs_info->sectorsize);
> +	lockend = start + BTRFS_MAX_UNCOMPRESSED - 1;
>   
> -	if (atomic_dec_return(&priv->pending))
> -		io_wait_event(priv->wait, !atomic_read(&priv->pending));
> +	unlock_extent(io_tree, start, lockend, &priv->cached_state);
> +	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);

AFAIS, btrfs_encoded_read_regular_end is here to be used asynchronously
in a later patch, specifically via bio callback -> io_uring tw callback,
and that io_uring tw callback might not get run in any reasonable amount
of time as it's controlled by the user space.

So, it takes the inode lock in one context (task executing the
request) and releases it in another, it's usually is not allowed.
And it also holds the locks potentially semi indefinitely (guaranteed
to be executed when io_uring and/or task die). There is also
unlock_extent() which I'd assume we don't want to hold locked
for too long.

It's in general a bad practice having is_locked variables, especially
when it's not on stack, even more so when it's implicit like

regular_read() {
	(ret == -EIOCBQUEUED)
		need_unlock = false; // delay it
}
btrfs_encoded_read_finish() {
	if (ret == -EIOCBQUEUED)
		unlock();
}

That just too easy to miss when you do anything with the code
afterwards.

I hope Josef and btrfs folks can comment what would be a way
here, does the inode lock has to be held for the entire
duration of IO?

>   
>   	ret = blk_status_to_errno(READ_ONCE(priv->status));
>   	if (ret)
>   		return ret;
>   
> -	unlock_extent(io_tree, start, lockend, &priv->cached_state);
> -	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
> -	*unlocked = true;
> -
>   	if (priv->args.compression) {
>   		i = 0;
>   		page_offset = 0;
> @@ -9215,6 +9199,30 @@ static ssize_t btrfs_encoded_read_regular(struct btrfs_encoded_read_private *pri
>   	return priv->count;
>   }

-- 
Pavel Begunkov

