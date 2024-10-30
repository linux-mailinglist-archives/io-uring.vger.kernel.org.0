Return-Path: <io-uring+bounces-4174-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D07F69B58DE
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 01:59:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F5FA28453C
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 00:59:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C0F929CEF;
	Wed, 30 Oct 2024 00:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XnCAtlVp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A885A282F4;
	Wed, 30 Oct 2024 00:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730249959; cv=none; b=ANIQ2EM/K4cQUK759PSHioAtCpMNlCQkPsX4INohQFNpl0H5Ifbbnr/ZVfju0Fdmq0qZfw2XhuAJleQy2kyKF8r/nFs443fakC6CcUKPgCYw8KjiUGpH89bqfbiSQAeZEJgNXAfGqyjdc2rVl8DBl5wpy0Yx6Ui0ZkZu4a7y5ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730249959; c=relaxed/simple;
	bh=23j3p/pIVZzpLwXm3oJr46ZJTztiveMI7B4CcPfzuh4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UZBaZXvZoTlz2y9nOqOY9GDO+lQ1a8VFWt8DdrT4raOK4+Ml3n3gHXR7G2hkxZoQ7Qd8BVCQktuDLWfygiF+6jxRb2uoqyRZTAbBcsCnXGPsbR6CQ114c+wwZjCKyzVIb5mk2yXEwmV/J9qWWz3maeRWPk4jnmZVlvZIuWxcR68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XnCAtlVp; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4315f24a6bbso57605295e9.1;
        Tue, 29 Oct 2024 17:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730249955; x=1730854755; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xFfQqO0PEPy7BDZYVvfE+jH63zcuQllaI2N88CBZSRA=;
        b=XnCAtlVpaGs5/45gBERVHA9tBoqvJB1LoQqhEp3SFqUUB3l2zYdY2AAE4Cm2oUWj+d
         WdEPKCmC8foRs4Z8pBokgIZG1/2G+/Jf/4wUmQc783uuITcHTNljBZL0mIRQ9z/u5XHw
         NHkLDPqSqDLGwRfArJezKz20DEr8T4c0Q6kKRT/N3IK5cwBc9qKyKlLHGaPU6rxRmLdE
         fGaQpCb89T7Mq5Ok8U7JvwleL1lKb+4Wr80zuIg9fYTiD1E2evTXINL9qsY/EhxcUujY
         9BFE7lSrqb0hBZ0PPgW2/4g5zvafvKao06a39xfHXHbVTq5IrViagZRvkjg1Cv8GP+JQ
         qIWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730249955; x=1730854755;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xFfQqO0PEPy7BDZYVvfE+jH63zcuQllaI2N88CBZSRA=;
        b=CBVxXF1e4e6gHZ2Sk3IV+zdpuQoWmcYveD5ukiR4mP8LmyzTHd9gF0DKJJnhoN2xsE
         DEsKNVv5fHX3kVIA5qk4YdxnbixyrmI+q0biuTWKFuuFwBJojpEflTmbk0fEX5WTwVcO
         SAd0dPtG1wGRvYQZOBR9tR2HAPufnKCuDsBRdeBUp+JxyUbP9v5BJLcG1HuuW/uyRESw
         9BAreAJjJIPjFfXze1xf9b0CagT/49t+ovBLRtyKehG2Lc0NotissCqkz4c+9weihocj
         MB2Lww2x0bcdoGVjL6UIjr5V1MmKXH6Vu79TGtqE/SoKs+upD0+981UUcpstRpRsiIeZ
         1TaQ==
X-Forwarded-Encrypted: i=1; AJvYcCX1fTbmaoeG88LXOmznB1hd5Y/1sXpRHsv1cch2yXKS0XiuDCGbtEQFSsJxxpqyNPXAkW5fI7bgWgGWXw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxKcuPYUsqVn1p5iA3ARhSMk1wGa5g8+6qSg4X1Wu7sqY5uT8Qo
	9AJS+GZY3Qb2RTKjdZ/uaUBA8jgOuszPz+SBz1dhP0S4hu+DB1cCuSFedQ==
X-Google-Smtp-Source: AGHT+IFEHcdv88xPkUrQV0AzWfnSZ2aPkGqIs1jHBfK/8Z5KojLfVJNgwqhHvPcqI6IrtzeHsjhWxw==
X-Received: by 2002:a05:600c:1d01:b0:42c:a6da:a149 with SMTP id 5b1f17b1804b1-4319ad048cdmr124447705e9.25.1730249954564;
        Tue, 29 Oct 2024 17:59:14 -0700 (PDT)
Received: from [192.168.42.216] ([148.252.146.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bd9ca9f1sm4935145e9.46.2024.10.29.17.59.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Oct 2024 17:59:14 -0700 (PDT)
Message-ID: <63db1884-3170-499d-87c8-678923320699@gmail.com>
Date: Wed, 30 Oct 2024 00:59:33 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] btrfs: add io_uring command for encoded reads
To: Mark Harmstone <maharmstone@fb.com>, linux-btrfs@vger.kernel.org
Cc: io-uring@vger.kernel.org
References: <20241022145024.1046883-1-maharmstone@fb.com>
 <20241022145024.1046883-6-maharmstone@fb.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241022145024.1046883-6-maharmstone@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/22/24 15:50, Mark Harmstone wrote:
...
> +static void btrfs_uring_read_finished(struct io_uring_cmd *cmd,
> +				      unsigned int issue_flags)
> +{
> +	struct btrfs_uring_priv *priv =
> +		*io_uring_cmd_to_pdu(cmd, struct btrfs_uring_priv *);
> +	struct btrfs_inode *inode = BTRFS_I(file_inode(priv->iocb.ki_filp));
> +	struct extent_io_tree *io_tree = &inode->io_tree;
> +	unsigned long i;
> +	u64 cur;
> +	size_t page_offset;
> +	ssize_t ret;
> +
> +	if (priv->err) {
> +		ret = priv->err;
> +		goto out;
> +	}
> +
> +	if (priv->compressed) {
> +		i = 0;
> +		page_offset = 0;
> +	} else {
> +		i = (priv->iocb.ki_pos - priv->start) >> PAGE_SHIFT;
> +		page_offset = offset_in_page(priv->iocb.ki_pos - priv->start);
> +	}
> +	cur = 0;
> +	while (cur < priv->count) {
> +		size_t bytes = min_t(size_t, priv->count - cur,
> +				     PAGE_SIZE - page_offset);
> +
> +		if (copy_page_to_iter(priv->pages[i], page_offset, bytes,
> +				      &priv->iter) != bytes) {

If that's an iovec backed iter that might fail, you'd need to
steal this patch

https://lore.kernel.org/all/20241016-fuse-uring-for-6-10-rfc4-v4-12-9739c753666e@ddn.com/

and fail if "issue_flags & IO_URING_F_TASK_DEAD", see

https://lore.kernel.org/all/20241016-fuse-uring-for-6-10-rfc4-v4-13-9739c753666e@ddn.com/


> +			ret = -EFAULT;
> +			goto out;
> +		}
> +
> +		i++;
> +		cur += bytes;
> +		page_offset = 0;
> +	}
> +	ret = priv->count;
> +
> +out:
> +	unlock_extent(io_tree, priv->start, priv->lockend, &priv->cached_state);
> +	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);

When called via io_uring_cmd_complete_in_task() this function might
not get run in any reasonable amount of time. Even worse, a
misbehaving user can block it until the task dies.

I don't remember if rwsem allows unlock being executed in a different
task than the pairing lock, but blocking it for that long could be a
problem. I might not remember it right but I think Boris meantioned
that the O_DIRECT path drops the inode lock right after submission
without waiting for bios to complete. Is that right? Can we do it
here as well?

> +
> +	io_uring_cmd_done(cmd, ret, 0, issue_flags);
> +	add_rchar(current, ret);
> +
> +	for (unsigned long index = 0; index < priv->nr_pages; index++)
> +		__free_page(priv->pages[index]);
> +
> +	kfree(priv->pages);
> +	kfree(priv->iov);
> +	kfree(priv);
> +}
> +
> +void btrfs_uring_read_extent_endio(void *ctx, int err)
> +{
> +	struct btrfs_uring_priv *priv = ctx;
> +
> +	priv->err = err;
> +
> +	*io_uring_cmd_to_pdu(priv->cmd, struct btrfs_uring_priv *) = priv;

a nit, I'd suggest to create a temp var, should be easier to
read. It'd even be nicer if you wrap it into a structure
as suggested last time.

struct io_btrfs_cmd {
	struct btrfs_uring_priv *priv;
};

struct io_btrfs_cmd *bc = io_uring_cmd_to_pdu(cmd, struct io_btrfs_cmd);
bc->priv = priv;

> +	io_uring_cmd_complete_in_task(priv->cmd, btrfs_uring_read_finished);
> +}
> +
> +static int btrfs_uring_read_extent(struct kiocb *iocb, struct iov_iter *iter,
> +				   u64 start, u64 lockend,
> +				   struct extent_state *cached_state,
> +				   u64 disk_bytenr, u64 disk_io_size,
> +				   size_t count, bool compressed,
> +				   struct iovec *iov,
> +				   struct io_uring_cmd *cmd)
> +{
> +	struct btrfs_inode *inode = BTRFS_I(file_inode(iocb->ki_filp));
> +	struct extent_io_tree *io_tree = &inode->io_tree;
> +	struct page **pages;
> +	struct btrfs_uring_priv *priv = NULL;
> +	unsigned long nr_pages;
> +	int ret;
> +
> +	nr_pages = DIV_ROUND_UP(disk_io_size, PAGE_SIZE);
> +	pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
> +	if (!pages)
> +		return -ENOMEM;
> +	ret = btrfs_alloc_page_array(nr_pages, pages, 0);
> +	if (ret) {
> +		ret = -ENOMEM;
> +		goto fail;
> +	}
> +
> +	priv = kmalloc(sizeof(*priv), GFP_NOFS);
> +	if (!priv) {
> +		ret = -ENOMEM;
> +		goto fail;
> +	}
> +
> +	priv->iocb = *iocb;
> +	priv->iov = iov;
> +	priv->iter = *iter;
> +	priv->count = count;
> +	priv->cmd = cmd;
> +	priv->cached_state = cached_state;
> +	priv->compressed = compressed;
> +	priv->nr_pages = nr_pages;
> +	priv->pages = pages;
> +	priv->start = start;
> +	priv->lockend = lockend;
> +	priv->err = 0;
> +
> +	ret = btrfs_encoded_read_regular_fill_pages(inode, disk_bytenr,
> +						    disk_io_size, pages,
> +						    priv);
> +	if (ret && ret != -EIOCBQUEUED)
> +		goto fail;

Turning both into return EIOCBQUEUED is a bit suspicious, but
I lack context to say. Might make sense to return ret and let
the caller handle it.

> +
> +	/*
> +	 * If we return -EIOCBQUEUED, we're deferring the cleanup to
> +	 * btrfs_uring_read_finished, which will handle unlocking the extent
> +	 * and inode and freeing the allocations.
> +	 */
> +
> +	return -EIOCBQUEUED;
> +
> +fail:
> +	unlock_extent(io_tree, start, lockend, &cached_state);
> +	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
> +	kfree(priv);
> +	return ret;
> +}
> +
> +static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd,
> +				    unsigned int issue_flags)
> +{
> +	size_t copy_end_kernel = offsetofend(struct btrfs_ioctl_encoded_io_args,
> +					     flags);
> +	size_t copy_end;
> +	struct btrfs_ioctl_encoded_io_args args = { 0 };
> +	int ret;
> +	u64 disk_bytenr, disk_io_size;
> +	struct file *file = cmd->file;
> +	struct btrfs_inode *inode = BTRFS_I(file->f_inode);
> +	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> +	struct extent_io_tree *io_tree = &inode->io_tree;
> +	struct iovec iovstack[UIO_FASTIOV];
> +	struct iovec *iov = iovstack;
> +	struct iov_iter iter;
> +	loff_t pos;
> +	struct kiocb kiocb;
> +	struct extent_state *cached_state = NULL;
> +	u64 start, lockend;
> +	void __user *sqe_addr = u64_to_user_ptr(READ_ONCE(cmd->sqe->addr));

Let's rename it, I was taken aback for a brief second why
you're copy_from_user() from an SQE / the ring, which turns
out to be a user pointer to a btrfs structure.

...
> +	ret = btrfs_encoded_read(&kiocb, &iter, &args, &cached_state,
> +				 &disk_bytenr, &disk_io_size);
> +	if (ret < 0 && ret != -EIOCBQUEUED)
> +		goto out_free;
> +
> +	file_accessed(file);
> +
> +	if (copy_to_user(sqe_addr + copy_end, (char *)&args + copy_end_kernel,
> +			 sizeof(args) - copy_end_kernel)) {
> +		if (ret == -EIOCBQUEUED) {
> +			unlock_extent(io_tree, start, lockend, &cached_state);
> +			btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
> +		}> +		ret = -EFAULT;
> +		goto out_free;

It seems we're saving iov in the priv structure, who can access the iovec
after the request is submitted? -EIOCBQUEUED in general means that the
request is submitted and will get completed async, e.g. via callback, and
if the bio callback can use the iov maybe via the iter, this goto will be
a use after free.

Also, you're returning -EFAULT back to io_uring, which will kill the
io_uring request / cmd while there might still be in flight bios that
can try to access it.

Can you inject errors into the copy and test please?

> +	}
> +
> +	if (ret == -EIOCBQUEUED) {
> +		u64 count;
> +
> +		/*
> +		 * If we've optimized things by storing the iovecs on the stack,
> +		 * undo this.
> +		 */> +		if (!iov) {
> +			iov = kmalloc(sizeof(struct iovec) * args.iovcnt,
> +				      GFP_NOFS);
> +			if (!iov) {
> +				unlock_extent(io_tree, start, lockend,
> +					      &cached_state);
> +				btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
> +				ret = -ENOMEM;
> +				goto out_acct;
> +			}
> +
> +			memcpy(iov, iovstack,
> +			       sizeof(struct iovec) * args.iovcnt);
> +		}
> +
> +		count = min_t(u64, iov_iter_count(&iter), disk_io_size);
> +
> +		/* Match ioctl by not returning past EOF if uncompressed */
> +		if (!args.compression)
> +			count = min_t(u64, count, args.len);
> +
> +		ret = btrfs_uring_read_extent(&kiocb, &iter, start, lockend,
> +					      cached_state, disk_bytenr,
> +					      disk_io_size, count,
> +					      args.compression, iov, cmd);
> +
> +		goto out_acct;
> +	}
> +
> +out_free:
> +	kfree(iov);
> +
> +out_acct:
> +	if (ret > 0)
> +		add_rchar(current, ret);
> +	inc_syscr(current);
> +
> +	return ret;
> +}

-- 
Pavel Begunkov

