Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781B71FD0A3
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2020 17:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgFQPPk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Jun 2020 11:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbgFQPPk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Jun 2020 11:15:40 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C800C06174E
        for <io-uring@vger.kernel.org>; Wed, 17 Jun 2020 08:15:39 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id m7so1070932plt.5
        for <io-uring@vger.kernel.org>; Wed, 17 Jun 2020 08:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Gj0SXTnf1HeKVvfHAT4BOOq6vQHD9eB06MSY+NPJwFQ=;
        b=1D998Q3+adANik/yjEQwQQt4NSsDWFsKQqdT9rswgZ51yGNXD9IemDeAiuVV3QuJfX
         LXZvjNgAb+3Gg+E4yPlXRjJKfRxzm+yf7VWo3XUi7u+Wy2IhPAkzCGvhoy5R7OszwX/z
         K7J4NOuiFZCK4XfrtaNWfcLs+Nc3cSHxfGsPqyiY6RjC0rJErsxdezccKKN4AcWdjHJc
         qAkkWOMcnTVtU1oUj+yMG4bG7gH6eVBSMzcTMnQ4XpMgTmZ/zF6BRunEz44acpMvYf2O
         raLUpDrXndjCuuOXEfHNU0FxTQ4LsS4pdZdMbv0pWO6fRlq5HiCHuSSpAvbE9XO2a3kM
         wLTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gj0SXTnf1HeKVvfHAT4BOOq6vQHD9eB06MSY+NPJwFQ=;
        b=oHFvqhl7m4yYniIXRMb2rviwgEhgMijWyVq3ExXm/DQz2Zq0UrnwdtgevpowWPYxoi
         pcgH4VSt9N+u0IXF23XF4BczoxcmHDABQp9O95VhbsM7PWzycCdbgBcZ0Fk48Lww4sWo
         QqRrug7xEenazjWYhRxMzytMDd55WxHasFaWUCLhAge5P1umC+TaH0rafg58bD37xAEe
         CEbfQcvqMtbnj8JdPMFVblFAO1FZ9sOKJc9LM5/TWzVk2+sjYbbbKelfKdc9B9MGqvEy
         y+Z0HT7IWMAOL9QbGLnDjLFLEfbTQwrIj0iNX8JAeKbCCbX3exJXdWAqfvsmVzvFSFCV
         IzRg==
X-Gm-Message-State: AOAM531P2rBvdVYsuBchAm4sxsIL+B3hNHTdrbynCbkQZsPX42VtsXPv
        Qf3+/AKeBG/h31xxK8FBikjw2sgUJE+r0A==
X-Google-Smtp-Source: ABdhPJyRyM5OkZFsyLOK7fny1Bws06ViKgC0tUqMfYaiAhGZg+AiBVqQeo7Hpu1bEdxr7r1cy/uX3A==
X-Received: by 2002:a17:902:7:: with SMTP id 7mr6491830pla.209.1592406938633;
        Wed, 17 Jun 2020 08:15:38 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id i3sm184270pgj.52.2020.06.17.08.15.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 08:15:37 -0700 (PDT)
Subject: Re: [PATCH v4 1/2] io_uring: change the poll type to be 32-bits
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <1592387636-80105-1-git-send-email-jiufei.xue@linux.alibaba.com>
 <1592387636-80105-2-git-send-email-jiufei.xue@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a020475f-a357-9978-fd34-d5e1e006cb4a@kernel.dk>
Date:   Wed, 17 Jun 2020 09:15:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1592387636-80105-2-git-send-email-jiufei.xue@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/17/20 3:53 AM, Jiufei Xue wrote:
> poll events should be 32-bits to cover EPOLLEXCLUSIVE.
> 
> Explicit word-swap the poll32_events for big endian to make sure the ABI
> is not changed.  We call this feature IORING_FEAT_POLL_32BITS,
> applications who want to use EPOLLEXCLUSIVE should check the feature bit
> first.
> 
> Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
> ---
>  fs/io_uring.c                 | 13 +++++++++----
>  include/uapi/linux/io_uring.h |  4 +++-
>  tools/io_uring/liburing.h     |  6 +++++-
>  3 files changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 155f3d8..fe935cf 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4543,7 +4543,7 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
>  static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  {
>  	struct io_poll_iocb *poll = &req->poll;
> -	u16 events;
> +	u32 events;
>  
>  	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>  		return -EINVAL;
> @@ -4552,7 +4552,10 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
>  	if (!poll->file)
>  		return -EBADF;
>  
> -	events = READ_ONCE(sqe->poll_events);
> +	events = READ_ONCE(sqe->poll32_events);
> +#ifdef __BIG_ENDIAN
> +	events = swahw32(events);
> +#endif
>  	poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP;
>  
>  	get_task_struct(current);
> @@ -7865,7 +7868,8 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
>  
>  	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
>  			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
> -			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL;
> +			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL |
> +			IORING_FEAT_POLL_32BITS;
>  
>  	if (copy_to_user(params, p, sizeof(*p))) {
>  		ret = -EFAULT;
> @@ -8154,7 +8158,8 @@ static int __init io_uring_init(void)
>  	BUILD_BUG_SQE_ELEM(28, /* compat */   int, rw_flags);
>  	BUILD_BUG_SQE_ELEM(28, /* compat */ __u32, rw_flags);
>  	BUILD_BUG_SQE_ELEM(28, __u32,  fsync_flags);
> -	BUILD_BUG_SQE_ELEM(28, __u16,  poll_events);
> +	BUILD_BUG_SQE_ELEM(28, /* compat */ __u16,  poll_events);
> +	BUILD_BUG_SQE_ELEM(28, __u32,  poll32_events);
>  	BUILD_BUG_SQE_ELEM(28, __u32,  sync_range_flags);
>  	BUILD_BUG_SQE_ELEM(28, __u32,  msg_flags);
>  	BUILD_BUG_SQE_ELEM(28, __u32,  timeout_flags);
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 92c2269..8d03396 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -31,7 +31,8 @@ struct io_uring_sqe {
>  	union {
>  		__kernel_rwf_t	rw_flags;
>  		__u32		fsync_flags;
> -		__u16		poll_events;
> +		__u16		poll_events;	/* compatibility */
> +		__u32		poll32_events;	/* word-reversed for BE */
>  		__u32		sync_range_flags;
>  		__u32		msg_flags;
>  		__u32		timeout_flags;
> @@ -248,6 +249,7 @@ struct io_uring_params {
>  #define IORING_FEAT_RW_CUR_POS		(1U << 3)
>  #define IORING_FEAT_CUR_PERSONALITY	(1U << 4)
>  #define IORING_FEAT_FAST_POLL		(1U << 5)
> +#define IORING_FEAT_POLL_32BITS 	(1U << 6)
>  
>  /*
>   * io_uring_register(2) opcodes and arguments
> diff --git a/tools/io_uring/liburing.h b/tools/io_uring/liburing.h
> index 5f305c8..28a837b 100644
> --- a/tools/io_uring/liburing.h
> +++ b/tools/io_uring/liburing.h
> @@ -10,6 +10,7 @@
>  #include <string.h>
>  #include "../../include/uapi/linux/io_uring.h"
>  #include <inttypes.h>
> +#include <linux/swab.h>
>  #include "barrier.h"
>  
>  /*
> @@ -145,11 +146,14 @@ static inline void io_uring_prep_write_fixed(struct io_uring_sqe *sqe, int fd,
>  }
>  
>  static inline void io_uring_prep_poll_add(struct io_uring_sqe *sqe, int fd,
> -					  short poll_mask)
> +					  unsigned poll_mask)
>  {
>  	memset(sqe, 0, sizeof(*sqe));
>  	sqe->opcode = IORING_OP_POLL_ADD;
>  	sqe->fd = fd;
> +#if __BYTE_ORDER == __BIG_ENDIAN
> +	poll_mask = __swahw32(poll_mask);
> +#endif
>  	sqe->poll_events = poll_mask;

This looks good to me now, but this one need not use the __ version, it
should just use the regular one as that's the one defined in the
non-uapi header.  But I'll just make that change, won't functionally do
anything.

-- 
Jens Axboe

