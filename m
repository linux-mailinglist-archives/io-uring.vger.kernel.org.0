Return-Path: <io-uring+bounces-3067-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F8F996F71A
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 16:41:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09E4A286310
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 14:41:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 399AA1D1739;
	Fri,  6 Sep 2024 14:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M2Yzqa0R"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555891D04A0;
	Fri,  6 Sep 2024 14:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725633680; cv=none; b=tBvf420jEibDwcXAugfWuoBhhP4lXkhQB7fjLtcCaTWBk0w2vUqYnnUzmnAkFiSgMUDMATjj7NiTOVwNQMNYMfaOmkoVWYKjvV+ISjYr0ZL73SS0YQqtbM0GsDBy8CQxjjM3atI4T7LPmNXaWFhyRfypFfIRnhcYw13Q2lRvDAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725633680; c=relaxed/simple;
	bh=s+77huen4Z7h3vSV/lDW30tHBiNJHGiNdLoHegm/G1I=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nq+I98JDsIq6MASty19kUHrMZCuAfgrBDSDLi2PGtcC8aoDG6B/+q4LSkGPvpPi3+ug7exoh59rsIi3hEITfQBuX3DExjDIqO+rrH67ghvFFmTF8kVjILte0hswnJz47BkPVCMZRK/TQANqc6mQZwSr8mlGbwvIDwXTOwRmDjeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M2Yzqa0R; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a86e9db75b9so264581966b.1;
        Fri, 06 Sep 2024 07:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725633676; x=1726238476; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6gUbhLmuX4st5r7L2akUWLECfiawR4Mef6gecmpxq2o=;
        b=M2Yzqa0RibJccj1cwhzG4NUwRjy5UelwFjdyxB2STz+IYp63booAlDjkYytInqCuGz
         d/4QnarvkZG9fsXK7/BEFt3bZD/9jjqIQcva3yXKQKAmr6QaOYVNktgcGCYhP19Gwtha
         y7VZn7F2VsJ7eMvG+BRA1jo7RJFmf8MH2JFufQzOmQ9gZjRceoCBlsrm4KzatLV/6Evd
         Xzl9vsgJQ8iVfSB6H25Qbirf5pJ/r+SLM3WwExPezWNs9MDwcEj6I6YqrutUEFQx5Tce
         N/Jz240HvBVW2wI1HR1YDjORSg6oyv28j2YoldhmlZhfMbejcnorigtmhhGaIPGNa/b4
         4qYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725633676; x=1726238476;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6gUbhLmuX4st5r7L2akUWLECfiawR4Mef6gecmpxq2o=;
        b=MYioXoULSLvU/bgMfXE0Qx7hwife5mq/x0Ot+nEHbsgzuAWW3kOEILCgwimD4+aHBB
         FL0iBzRA80ibHoIzSHI352GummC2QfddIy/2WIeuZTm+MSP8Qj+IVZ3s90nTjgFncOe6
         2P+SG+RJMu2S8BjJeVQtwBq2iEjWMjGmjFM+Nr2odEHIJ45RmeSRs7jJcBlvntjevseG
         4wIOPo7pP6hjT2DJ2uJa/V7AR230J2VzE+Zd5Y6HsCyvBtVgk+nBxfQK6dr6RYyUpEUv
         OKS3dvm3z+YwPGxtBF103OglPcHA5U2HuCMIIjaM+5jOz9O5gNqNvicqJx7dHm08NzZ2
         7veA==
X-Forwarded-Encrypted: i=1; AJvYcCU9E5ZKmLdXG819NIt08qWyEvurl4AwJCm4SNRFiL9/hFiiE08V4tHTyL/mQgxFnnxe++tHjuRpAg==@vger.kernel.org, AJvYcCV9jQmBLFGdlJKrOIt/hgobIdiI9m2QNBYcLPySWfBzLZWsVOrPbD8qI5pttsRP/mLvPMuVa6mSzUnzX9U=@vger.kernel.org
X-Gm-Message-State: AOJu0YzV3GJVFTFUZqjgxHcNWeV6D+OGx/y0EgUL5lqP74HV0ZyDK73n
	WFspdhE3XrOiMzWdRx4vv3/dpFdEaDOJN2XtygFypaUIduiPafpnykDJkApS
X-Google-Smtp-Source: AGHT+IG6o8xe/vHKbB5TAbtipmkKCzMf+OHTOjk9e5TOXIfeY1toBybB4VmXVAMQzsxINPNoOqO24w==
X-Received: by 2002:a17:907:c06:b0:a77:eb34:3b49 with SMTP id a640c23a62f3a-a8a88669369mr220833966b.37.1725633675667;
        Fri, 06 Sep 2024 07:41:15 -0700 (PDT)
Received: from [192.168.42.120] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8a87564d83sm117069666b.8.2024.09.06.07.41.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Sep 2024 07:41:15 -0700 (PDT)
Message-ID: <7f1765e2-11c4-4e69-b25e-79cf0dd51404@gmail.com>
Date: Fri, 6 Sep 2024 15:41:49 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] btrfs: add io_uring interface for encoded reads
To: Mark Harmstone <maharmstone@fb.com>, io-uring@vger.kernel.org,
 linux-btrfs@vger.kernel.org
References: <20240823162810.1668399-1-maharmstone@fb.com>
 <20240823162810.1668399-7-maharmstone@fb.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240823162810.1668399-7-maharmstone@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/23/24 17:27, Mark Harmstone wrote:
> Adds an io_uring interface for asynchronous encoded reads, using the
> same interface as for the ioctl. To use this you would use an SQE opcode
> of IORING_OP_URING_CMD, the cmd_op would be BTRFS_IOC_ENCODED_READ, and
> addr would point to the userspace address of the
> btrfs_ioctl_encoded_io_args struct. As with the ioctl, you need to have
> CAP_SYS_ADMIN for this to work.
> 
> Signed-off-by: Mark Harmstone <maharmstone@fb.com>
> ---
...
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index a5d786c6d7d4..62e5757d3ba2 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -620,6 +620,8 @@ struct btrfs_encoded_read_private {
>   	struct btrfs_ioctl_encoded_io_args args;
>   	struct file *file;
>   	void __user *copy_out;
> +	struct io_uring_cmd *cmd;
> +	unsigned int issue_flags;
>   };
>   
...
> +static inline struct btrfs_encoded_read_private *btrfs_uring_encoded_read_pdu(
> +		struct io_uring_cmd *cmd)
> +{
> +	return *(struct btrfs_encoded_read_private **)cmd->pdu;
> +}
> +static void btrfs_finish_uring_encoded_read(struct io_uring_cmd *cmd,
> +					    unsigned int issue_flags)
> +{
> +	struct btrfs_encoded_read_private *priv;
> +	ssize_t ret;
> +
> +	priv = btrfs_uring_encoded_read_pdu(cmd);
> +	ret = btrfs_encoded_read_finish(priv, -EIOCBQUEUED);
> +
> +	io_uring_cmd_done(priv->cmd, ret, 0, priv->issue_flags);

s/priv->issue_flags/issue_flags/

You can't use flags that you got somewhere before from a completely
different execution context.

> +
> +	kfree(priv);
> +}
> +
> +static void btrfs_encoded_read_uring_endio(struct btrfs_bio *bbio)
> +{
> +	struct btrfs_encoded_read_private *priv = bbio->private;

Might be cleaner if you combine it with btrfs_encoded_read_ioctl_endio

btrfs_encoded_read_endio()
{
	...
	if (!atomic_dec_return(&priv->pending)) {
		if (priv->cmd)
			io_uring_cmd_complete_in_task();
		else
			wake_up();
	...
}



> +
> +	if (bbio->bio.bi_status) {
> +		/*
> +		 * The memory barrier implied by the atomic_dec_return() here
> +		 * pairs with the memory barrier implied by the
> +		 * atomic_dec_return() or io_wait_event() in
> +		 * btrfs_encoded_read_regular_fill_pages() to ensure that this
> +		 * write is observed before the load of status in
> +		 * btrfs_encoded_read_regular_fill_pages().
> +		 */
> +		WRITE_ONCE(priv->status, bbio->bio.bi_status);
> +	}
> +	if (!atomic_dec_return(&priv->pending)) {
> +		io_uring_cmd_complete_in_task(priv->cmd,
> +					      btrfs_finish_uring_encoded_read);
> +	}
> +	bio_put(&bbio->bio);
> +}
> +
>   static void _btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
>   					u64 file_offset, u64 disk_bytenr,
>   					u64 disk_io_size,
> @@ -9106,11 +9148,16 @@ static void _btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
>   	struct btrfs_fs_info *fs_info = inode->root->fs_info;
>   	unsigned long i = 0;
>   	struct btrfs_bio *bbio;
> +	btrfs_bio_end_io_t cb;
>   
> -	init_waitqueue_head(&priv->wait);
> +	if (priv->cmd) {
> +		cb = btrfs_encoded_read_uring_endio;
> +	} else {
> +		init_waitqueue_head(&priv->wait);
> +		cb = btrfs_encoded_read_ioctl_endio;
> +	}
>   
> -	bbio = btrfs_bio_alloc(BIO_MAX_VECS, REQ_OP_READ, fs_info,
> -			       btrfs_encoded_read_endio, priv);
> +	bbio = btrfs_bio_alloc(BIO_MAX_VECS, REQ_OP_READ, fs_info, cb, priv);
>   	bbio->bio.bi_iter.bi_sector = disk_bytenr >> SECTOR_SHIFT;
>   	bbio->inode = inode;
>   
> @@ -9122,7 +9169,7 @@ static void _btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
>   			btrfs_submit_bio(bbio, 0);
>   
>   			bbio = btrfs_bio_alloc(BIO_MAX_VECS, REQ_OP_READ, fs_info,
> -					       btrfs_encoded_read_endio, priv);
> +					       cb, priv);
>   			bbio->bio.bi_iter.bi_sector = disk_bytenr >> SECTOR_SHIFT;
>   			bbio->inode = inode;
>   			continue;
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index c1886209933a..85a512a9ca64 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
...
> +static void btrfs_uring_encoded_read(struct io_uring_cmd *cmd,
> +				     unsigned int issue_flags)
> +{
> +	ssize_t ret;
> +	void __user *argp = (void __user *)(uintptr_t)cmd->sqe->addr;

u64_to_user_ptr()

> +	struct btrfs_encoded_read_private *priv;
> +	bool compat = issue_flags & IO_URING_F_COMPAT;
> +
> +	priv = kmalloc(sizeof(*priv), GFP_KERNEL);
> +	if (!priv) {
> +		ret = -ENOMEM;
> +		goto out_uring;
> +	}
> +
> +	ret = btrfs_prepare_encoded_read(priv, cmd->file, compat, argp);
> +	if (ret)
> +		goto out_finish;
> +
> +	if (iov_iter_count(&priv->iter) == 0) {
> +		ret = 0;
> +		goto out_finish;
> +	}
> +
> +	*(struct btrfs_encoded_read_private **)cmd->pdu = priv;
> +	priv->cmd = cmd;
> +	priv->issue_flags = issue_flags;

You shouldn't be stashing issue_flags, it almost always wrong.
Looks btrfs_finish_uring_encoded_read() is the only user, and
with my comment above you can kill priv->issue_flags

> +	ret = btrfs_encoded_read(priv);
> +
> +	if (ret == -EIOCBQUEUED && atomic_dec_return(&priv->pending))
> +		return;

Is gating on -EIOCBQUEUED just an optimisation? I.e. it's fine
to swap checks

if (atomic_dec_return(&priv->pending) && ret == -EIOCBQUEUED)

but we know that unless it returned -EIOCBQUEUED nobody
should've touched ->pending.

> +
> +out_finish:
> +	ret = btrfs_encoded_read_finish(priv, ret);
> +	kfree(priv);
> +
> +out_uring:
> +	io_uring_cmd_done(cmd, ret, 0, issue_flags);
> +}
> +

-- 
Pavel Begunkov

