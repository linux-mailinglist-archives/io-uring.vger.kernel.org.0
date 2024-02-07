Return-Path: <io-uring+bounces-563-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 66D5B84C19D
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 02:01:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1EF5B24190
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 01:01:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 710E0D2EE;
	Wed,  7 Feb 2024 01:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GB5KsEMh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961E0D27A
	for <io-uring@vger.kernel.org>; Wed,  7 Feb 2024 01:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707267671; cv=none; b=hzYyjIwtf8QuczKeSGW3HmUah8WBy2i9qDyR/s4BpXzZRMLGt+rOzIvnVJygLSMqbamytjv2xtRDVgwybD9RqiPNEiEu+vJp+PgxlUKCpNvlUC91/f8ouPaAuVFj26KLCokt7PiV4wDYdyUOyb3nAIMfcBsbeC+yjcER+Vojz84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707267671; c=relaxed/simple;
	bh=lsET8Bab0Yx5uv4DoxfYX/+q7mYJhIcxd3i6n1wbJrA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=AvCgD5qJ0T6NDNNisu21YV/xYREy7XEETUwLyyFeDqe7W0tC7BFqLvsSHQbK/MN0VwHgEFMR4el+aIFOkNqU2zRut9ylDKucA/kVTbg9XWWbP+7bGi8EOO6H34Jx+MmPAkdaKnGq0tcm+0Yg8VXbsxzYHU4KaWVgRJkQQDD3Qhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GB5KsEMh; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-40fe03cd1caso515585e9.0
        for <io-uring@vger.kernel.org>; Tue, 06 Feb 2024 17:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707267668; x=1707872468; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g9Pt2eA2YOkzC/MCX309Ky7I2RWMcQdcwQoyx4kQvg8=;
        b=GB5KsEMhq7hzap6ljveiAkrvavwLUZcyPdXL6L0DF0VF5IT4/7IXASJG9/bUNJmB8s
         BblRjSw/eIdvLd54NqXxtkhzXE7/CM7tIniz4X0DexjlwnpTfbhCy5LT+z140tw6yzIm
         vLbeG6EpjvI33QG5ohDqJQef/du/S6aLj5tIg3xW6WW2avF+dAnRR+wnUjwBVYetYRe0
         ISZ3aS8oPmX3IVI5ToY+ULIfv3D0/Ji49Z6wS5N98aJyCyImT52WOs3jOAOrYtsSyrWP
         Gu6ddDZ3hXRbTCPovKk+xIB/vVD2UHOzHepJte4ZWrmrHFLWIbOjExny+mImo2qdohA4
         VPGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707267668; x=1707872468;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g9Pt2eA2YOkzC/MCX309Ky7I2RWMcQdcwQoyx4kQvg8=;
        b=QWPXZEkZiZRLjVz1TsqHXlX2zSbnuoYr080GwY2GziAeXgqTHqbvPMvYdP4Yd+AtR2
         aZK5ANXod0gPEL7FR3ZKcHg5FDm31fFkdcrJu5jsA1D+w5kuDsggbWWsKKXFXKJdMoXq
         6+XtjZ+vngOi697E9K8cdHYwRWMoCjgnNBpRy4uOGIkQR2Tqg+un7tI5Thc8WXCehSlV
         tasQt7ojAjZjWcdPxwRLfQpLnzHneTNaJuuk39rPdfxm4rE3dz4j4QGi0lWpvpu0ym5n
         ysYcyuryBWxAtGOd1A5lraoFxrdncW4DxB9UgbSsqX4QKJVNkoVhNQ1UVXyHz1qn8HLM
         OirQ==
X-Forwarded-Encrypted: i=1; AJvYcCX7dzh8OYLkRlO7AVCeP8Vnqho+ARkXYVZQw354NCizlX2ULfAP70/o9Kf0gnideb6PLdXlxCLOuraKRHvQRgeHlZcwvVZsjP0=
X-Gm-Message-State: AOJu0YxMNARSG75azxvQHBxWF0ODiFnn4bE75WI72vLRbsdD8kaEDNPU
	bF8wcBWMmbdd7A2Se0h92a7laveMAGRKRTXWk2/AwYNIajjRGdgXkkDdx11F
X-Google-Smtp-Source: AGHT+IHBxlgEX5PzkDTCXkrtWCovkVYy1d0BYj9hnqPouNJ+62bqYcHjCj7miUD1MKWebNOb4nivVw==
X-Received: by 2002:a5d:5f4c:0:b0:33a:e739:28bd with SMTP id cm12-20020a5d5f4c000000b0033ae73928bdmr2760833wrb.59.1707267667709;
        Tue, 06 Feb 2024 17:01:07 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV5w6Jjg1QdHCR7H1nOyXAV5xbA1gxJ05Y99k1LOZ2iz7+WtLNsz/TI4jdTquPwaVaiUYa3itjPJcNUHzoiKfrEwa1spVGOnPM=
Received: from [192.168.8.100] ([85.255.236.54])
        by smtp.gmail.com with ESMTPSA id e3-20020a5d5303000000b0033afe816977sm192884wrv.66.2024.02.06.17.01.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Feb 2024 17:01:07 -0800 (PST)
Message-ID: <a0dce2ae-a41b-4fbb-961c-db69d8f1f17f@gmail.com>
Date: Wed, 7 Feb 2024 00:57:34 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] io_uring: add io_file_can_poll() helper
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240206162402.643507-1-axboe@kernel.dk>
 <20240206162402.643507-3-axboe@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240206162402.643507-3-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/6/24 16:22, Jens Axboe wrote:
> This adds a flag to avoid dipping dereferencing file and then f_op
> to figure out if the file has a poll handler defined or not. We
> generally call this at least twice for networked workloads.

Sends are not using poll every time. For recv, we touch it
in io_arm_poll_handler(), which is done only once, and so
ammortised to 0 for multishots.

Looking at the patch, the second time we might care about is
in io_ring_buffer_select(), but I'd argue that it shouldn't
be there in the first place. It's fragile, and I don't see
why selected buffers would care specifically about polling
but not asking more generally "can it go true async"? For
reads you might want to also test FMODE_BUF_RASYNC.

Also note that when called from recv we already know that
it's pollable, it might be much easier to pass it in as an
argument.


> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   include/linux/io_uring_types.h |  3 +++
>   io_uring/io_uring.c            |  2 +-
>   io_uring/io_uring.h            | 12 ++++++++++++
>   io_uring/kbuf.c                |  2 +-
>   io_uring/poll.c                |  2 +-
>   io_uring/rw.c                  |  6 +++---
>   6 files changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 5ac18b05d4ee..7f06cee02b58 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -463,6 +463,7 @@ enum io_req_flags {
>   	REQ_F_SUPPORT_NOWAIT_BIT,
>   	REQ_F_ISREG_BIT,
>   	REQ_F_POLL_NO_LAZY_BIT,
> +	REQ_F_CAN_POLL_BIT,
>   
>   	/* not a real bit, just to check we're not overflowing the space */
>   	__REQ_F_LAST_BIT,
> @@ -535,6 +536,8 @@ enum {
>   	REQ_F_HASH_LOCKED	= IO_REQ_FLAG(REQ_F_HASH_LOCKED_BIT),
>   	/* don't use lazy poll wake for this request */
>   	REQ_F_POLL_NO_LAZY	= IO_REQ_FLAG(REQ_F_POLL_NO_LAZY_BIT),
> +	/* file is pollable */
> +	REQ_F_CAN_POLL		= IO_REQ_FLAG(REQ_F_CAN_POLL_BIT),
>   };
>   
>   typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 360a7ee41d3a..d0e06784926f 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1969,7 +1969,7 @@ void io_wq_submit_work(struct io_wq_work *work)
>   	if (req->flags & REQ_F_FORCE_ASYNC) {
>   		bool opcode_poll = def->pollin || def->pollout;
>   
> -		if (opcode_poll && file_can_poll(req->file)) {
> +		if (opcode_poll && io_file_can_poll(req)) {
>   			needs_poll = true;
>   			issue_flags |= IO_URING_F_NONBLOCK;
>   		}
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index d5495710c178..2952551fe345 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -5,6 +5,7 @@
>   #include <linux/lockdep.h>
>   #include <linux/resume_user_mode.h>
>   #include <linux/kasan.h>
> +#include <linux/poll.h>
>   #include <linux/io_uring_types.h>
>   #include <uapi/linux/eventpoll.h>
>   #include "io-wq.h"
> @@ -398,4 +399,15 @@ static inline size_t uring_sqe_size(struct io_ring_ctx *ctx)
>   		return 2 * sizeof(struct io_uring_sqe);
>   	return sizeof(struct io_uring_sqe);
>   }
> +
> +static inline bool io_file_can_poll(struct io_kiocb *req)
> +{
> +	if (req->flags & REQ_F_CAN_POLL)
> +		return true;
> +	if (file_can_poll(req->file)) {
> +		req->flags |= REQ_F_CAN_POLL;
> +		return true;
> +	}
> +	return false;
> +}
>   #endif
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index 18df5a9d2f5e..71880615bb78 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -180,7 +180,7 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
>   	req->buf_list = bl;
>   	req->buf_index = buf->bid;
>   
> -	if (issue_flags & IO_URING_F_UNLOCKED || !file_can_poll(req->file)) {
> +	if (issue_flags & IO_URING_F_UNLOCKED || !io_file_can_poll(req)) {
>   		/*
>   		 * If we came in unlocked, we have no choice but to consume the
>   		 * buffer here, otherwise nothing ensures that the buffer won't
> diff --git a/io_uring/poll.c b/io_uring/poll.c
> index 7513afc7b702..4afec733fef6 100644
> --- a/io_uring/poll.c
> +++ b/io_uring/poll.c
> @@ -727,7 +727,7 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
>   
>   	if (!def->pollin && !def->pollout)
>   		return IO_APOLL_ABORTED;
> -	if (!file_can_poll(req->file))
> +	if (!io_file_can_poll(req))
>   		return IO_APOLL_ABORTED;
>   	if (!(req->flags & REQ_F_APOLL_MULTISHOT))
>   		mask |= EPOLLONESHOT;
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index d5e79d9bdc71..0fb7a045163a 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -682,7 +682,7 @@ static bool io_rw_should_retry(struct io_kiocb *req)
>   	 * just use poll if we can, and don't attempt if the fs doesn't
>   	 * support callback based unlocks
>   	 */
> -	if (file_can_poll(req->file) || !(req->file->f_mode & FMODE_BUF_RASYNC))
> +	if (io_file_can_poll(req) || !(req->file->f_mode & FMODE_BUF_RASYNC))
>   		return false;
>   
>   	wait->wait.func = io_async_buf_func;
> @@ -831,7 +831,7 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
>   		 * If we can poll, just do that. For a vectored read, we'll
>   		 * need to copy state first.
>   		 */
> -		if (file_can_poll(req->file) && !io_issue_defs[req->opcode].vectored)
> +		if (io_file_can_poll(req) && !io_issue_defs[req->opcode].vectored)
>   			return -EAGAIN;
>   		/* IOPOLL retry should happen for io-wq threads */
>   		if (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL))
> @@ -930,7 +930,7 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
>   	/*
>   	 * Multishot MUST be used on a pollable file
>   	 */
> -	if (!file_can_poll(req->file))
> +	if (!io_file_can_poll(req))
>   		return -EBADFD;
>   
>   	ret = __io_read(req, issue_flags);

-- 
Pavel Begunkov

