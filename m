Return-Path: <io-uring+bounces-3422-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 383C8990816
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 17:55:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 714BB287868
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 15:55:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 072672225C3;
	Fri,  4 Oct 2024 15:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F9n2s60d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2275F1E32A5;
	Fri,  4 Oct 2024 15:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728056667; cv=none; b=UTBzrlax8Ol3fuiUIwzpyAowBQEIrWNgURkVrEQpU8TiLFqElBOTRBBZCyB7tFDfB5xhInwbm93bwldgl/Du8xZlfdD2uQYsuLWRQezaMrnA9tt5csneA9+B9G2nJV9+PkJwXN0JYAY8ixPU3AVT/lPsYSoOAbKOiw+nZsCzHuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728056667; c=relaxed/simple;
	bh=NCRbFchR/UiCwGDYeUZ5WgHfLqVnuUJ38glSDQuvl1w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QhuoIpXszYPOrNG7PmIBbTo43gPDshtdJn+IU5+kuC/UOL+cNsBh0wyAKNkqp7W4knPPrOpEg8gj1bBP1nU79TFwK1k02/zNY5M633HFh+kAqIatDkIo0jYDAn+YmVVzprZViCvr6oMcanm+dNijzeGMy8VrRnBSQUYaUJKR6i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F9n2s60d; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a93b2070e0cso255415966b.3;
        Fri, 04 Oct 2024 08:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728056664; x=1728661464; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dgROqxm/GM2bX7Pu2CBdkr0+nh2zIk2x+3LQPxQ2G+c=;
        b=F9n2s60dFAeIEnhdl/XXA1UlYJAF4v/kwNJX3m9H7z4IQiAy4wKo9Evzt9ObRdEO/a
         WeCtPqvCN2p6p9NW+MUTKyI4QlzCL0DKDw/vZR3aS9R/l1yQOHcSJsgEggc6lS7ADYEY
         omqNfEXjl9WHSRTJhkzf32QLw/UIntyCwy7rN/8uUvI6AIsSCVShQbs8+q6sQ11rAF2M
         7QynYKZRMnTDFl7lv8qIcKecjn4G51hy/jkb1WZ3pgq5d2s+HdA05fWu/zPKJrhhYQi2
         0KPi8LaJDP2NB7sE+vasywBBJPeaEiATCHxldDUkCLx8ue4oF6bMa814Bk+YXhnqr0of
         ysyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728056664; x=1728661464;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dgROqxm/GM2bX7Pu2CBdkr0+nh2zIk2x+3LQPxQ2G+c=;
        b=qQp2t5pOcDXXmOGfD9sIaHEQs/nop4Ng7SRFRzQnibJJd8htZTa3+14l56hzQyylpF
         FnH4PXHU3sTnRo/HQ0D5Z5cfT5Ne6FvDHNWwFZ7HI2QoEdSc5xRv/4o8gMGkm26+Tllh
         Y5g7HU4M8VNeYQBwQlfDuNXLe2c8aUVWnuifNzUTzBjT7nv2FpB1ETE4F47aAkciS0GB
         OAL409xgzHMIrSD/eCPfDOx2EDro/b56VdA28a2MvzBnI6qgK72t/yfrjUCYVUUOmYYk
         4rht2fSmhXN/jar4SXLsa+1dV+ay/Dm8EUxhUSXiM6XoV/NFkHCxXaXH8ZV5BpSW6YLR
         giAg==
X-Forwarded-Encrypted: i=1; AJvYcCXodYiMY5vcL72kB8VKOd3RIJ07xtprMHE4Zd7kVmekaZjhdxIUWlgOTO0jTGKgZzAnyoEdGy5kVA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzhqZjXHcJNMAzMoWrqqSpMEnjZB8UVoKdJZHJen9iBgXhMXuKW
	WIKmT/V5wiUZi8wvnWYh68Bw2/QCzQmqtgiKySogK2wemuAv9Qi7
X-Google-Smtp-Source: AGHT+IGu9zzz95tzmTvytgqZ6lk5aOX5Jip1eg/14hVAScy2A6Y/ctuNc0UfANbgtyVNgJUIGI+Zcg==
X-Received: by 2002:a17:907:3e21:b0:a8a:18f9:269f with SMTP id a640c23a62f3a-a991c077e3dmr325612766b.60.1728056664043;
        Fri, 04 Oct 2024 08:44:24 -0700 (PDT)
Received: from [192.168.42.59] (82-132-213-31.dab.02.net. [82.132.213.31])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a992e7c46e3sm6350466b.180.2024.10.04.08.44.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2024 08:44:23 -0700 (PDT)
Message-ID: <b232fa58-1255-44b2-92c9-f8eb4f70e2c9@gmail.com>
Date: Fri, 4 Oct 2024 16:44:54 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 7/8] io_uring/uring_cmd: support provide group kernel
 buffer
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org
References: <20240912104933.1875409-1-ming.lei@redhat.com>
 <20240912104933.1875409-8-ming.lei@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240912104933.1875409-8-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/12/24 11:49, Ming Lei wrote:
> Allow uring command to be group leader for providing kernel buffer,
> and this way can support generic device zero copy over device buffer.
> 
> The following patch will use the way to support zero copy for ublk.
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   include/linux/io_uring/cmd.h  |  7 +++++++
>   include/uapi/linux/io_uring.h |  7 ++++++-
>   io_uring/uring_cmd.c          | 28 ++++++++++++++++++++++++++++
>   3 files changed, 41 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index 447fbfd32215..fde3a2ec7d9a 100644
> --- a/include/linux/io_uring/cmd.h
> +++ b/include/linux/io_uring/cmd.h
> @@ -48,6 +48,8 @@ void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
>   void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
>   		unsigned int issue_flags);
>   
> +int io_uring_cmd_provide_kbuf(struct io_uring_cmd *ioucmd,
> +		const struct io_uring_kernel_buf *grp_kbuf);
>   #else
>   static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
>   			      struct iov_iter *iter, void *ioucmd)
> @@ -67,6 +69,11 @@ static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
>   		unsigned int issue_flags)
>   {
>   }
> +static inline int io_uring_cmd_provide_kbuf(struct io_uring_cmd *ioucmd,
> +		const struct io_uring_kernel_buf *grp_kbuf)
> +{
> +	return -EOPNOTSUPP;
> +}
>   #endif
>   
>   /*
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 2af32745ebd3..11985eeac10e 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -271,9 +271,14 @@ enum io_uring_op {
>    * sqe->uring_cmd_flags		top 8bits aren't available for userspace
>    * IORING_URING_CMD_FIXED	use registered buffer; pass this flag
>    *				along with setting sqe->buf_index.
> + * IORING_PROVIDE_GROUP_KBUF	this command provides group kernel buffer
> + *				for member requests which can retrieve
> + *				any sub-buffer with offset(sqe->addr) and
> + *				len(sqe->len)

Is there a good reason it needs to be a cmd generic flag instead of
ublk specific?

1. Extra overhead for files / cmds that don't even care about the
feature.

2. As it stands with this patch, the flag is ignored by all other
cmd implementations, which might be quite confusing as an api,
especially so since if we don't set that REQ_F_GROUP_KBUF memeber
requests will silently try to import a buffer the "normal way",
i.e. interpret sqe->addr or such as the target buffer.

3. We can't even put some nice semantics on top since it's
still cmd specific and not generic to all other io_uring
requests.

I'd even think that it'd make sense to implement it as a
new cmd opcode, but that's the business of the file implementing
it, i.e. ublk.

>    */
>   #define IORING_URING_CMD_FIXED	(1U << 0)
> -#define IORING_URING_CMD_MASK	IORING_URING_CMD_FIXED
> +#define IORING_PROVIDE_GROUP_KBUF	(1U << 1)
> +#define IORING_URING_CMD_MASK	(IORING_URING_CMD_FIXED | IORING_PROVIDE_GROUP_KBUF)
>   
>   
>   /*
-- 
Pavel Begunkov

