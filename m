Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E062C431908
	for <lists+io-uring@lfdr.de>; Mon, 18 Oct 2021 14:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbhJRM26 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Oct 2021 08:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbhJRM26 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Oct 2021 08:28:58 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0BDC06161C
        for <io-uring@vger.kernel.org>; Mon, 18 Oct 2021 05:26:47 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id g25so40935831wrb.2
        for <io-uring@vger.kernel.org>; Mon, 18 Oct 2021 05:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=m50YxGVRI+XoQKVDMSJMyh6MhZFSrJU2gQSLzuX+yww=;
        b=OBNmcoF17s8wfLYNNTNTU9rXB1008NRra/tTmxnl99LkWEYnQEu7RRqjaRuzxtIX+x
         V6vC9WHFj+t8GosjKq8CfTR5e9xUxhAMUOx58kzq+R9/icR82rX0hLUVCOySpwNPbrAv
         lFCFSS3K5DwmayGefZroiPFRXEN63hHGHjg5gd8DLC8DTPoNsaMgHPqQSh/Q3Am6k7xF
         rCNo/iYg22ZMbqzswbRmp73JQn3Ry0L9SA2K/Xlpoy72pCK1hnCltIXJznLlCR9UkgcP
         urMz2AmYmJihe9egn7mivUL2Jc6DUHfkhiRU0cF4SfPN8iVjKS4y3G1FUKnrKlK/nAOX
         lfTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=m50YxGVRI+XoQKVDMSJMyh6MhZFSrJU2gQSLzuX+yww=;
        b=YEm9U/EV33N1b5y0khFTM6aHFhIlDwaq8AAiFbjnLkT/obqzz1FAi19aN9L2COFbaz
         RLGs8g/f8xzJNQf7VvQwQaNO6nCk930nNLX+Zy46Ab7yDDnvJiQ3EfMBW/1tvALZ2tVW
         Rxnlrepkc9xo/qH3zcEhs4MzLdJav4jOKL/BGuiek6OOkvSmjD2CyzCVW8Ghnhz73BG3
         MHdGZdFXLoc3S2OhZSoZr+CoyV3oK+56adagvgO6uiJalTQvSvD2juGt2ZMmkW907Fjl
         b6blw0vd8ZqGSQkF8f8YsREP/WuFUp/xSAMbS2246DsM8942pb4r0v9D6IRYtF7JVGSY
         /T1w==
X-Gm-Message-State: AOAM5329sIBl08zoCO4xpU3HDSAko4/hP9k68+wU4VvrvyJKzSpTELgb
        Q7RdVRA21NUUSbNqp6/aeoRwfzR11Pc=
X-Google-Smtp-Source: ABdhPJyaBfXEer3DtnzkojT3ZBHLWn3h1psRgW2KxUEFnguF4SRN3xrRFMy3Ur29Ov4nUBnEODYYzA==
X-Received: by 2002:a5d:6d81:: with SMTP id l1mr34861922wrs.110.1634560005676;
        Mon, 18 Oct 2021 05:26:45 -0700 (PDT)
Received: from [192.168.43.77] (82-132-230-135.dab.02.net. [82.132.230.135])
        by smtp.gmail.com with ESMTPSA id q17sm12117764wrm.6.2021.10.18.05.26.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 05:26:45 -0700 (PDT)
Message-ID: <eadf11e3-18d1-0cfa-cf03-9a540da3693c@gmail.com>
Date:   Mon, 18 Oct 2021 12:27:00 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/2] io_uring: split logic of force_nonblock
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211018112923.16874-1-haoxu@linux.alibaba.com>
 <20211018112923.16874-2-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211018112923.16874-2-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/18/21 11:29, Hao Xu wrote:
> Currently force_nonblock stands for three meanings:
>   - nowait or not
>   - in an io-worker or not(hold uring_lock or not)
> 
> Let's split the logic to two flags, IO_URING_F_NONBLOCK and
> IO_URING_F_UNLOCKED for convenience of the next patch.
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>   fs/io_uring.c | 50 ++++++++++++++++++++++++++++----------------------
>   1 file changed, 28 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index b6da03c26122..727cad6c36fc 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -199,6 +199,7 @@ struct io_rings {
>   
>   enum io_uring_cmd_flags {
>   	IO_URING_F_COMPLETE_DEFER	= 1,
> +	IO_URING_F_UNLOCKED		= 2,
>   	/* int's last bit, sign checks are usually faster than a bit test */
>   	IO_URING_F_NONBLOCK		= INT_MIN,
>   };
> @@ -2926,7 +2927,7 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
>   			struct io_ring_ctx *ctx = req->ctx;
>   
>   			req_set_fail(req);
> -			if (!(issue_flags & IO_URING_F_NONBLOCK)) {
> +			if (issue_flags & IO_URING_F_UNLOCKED) {
>   				mutex_lock(&ctx->uring_lock);
>   				__io_req_complete(req, issue_flags, ret, cflags);
>   				mutex_unlock(&ctx->uring_lock);
> @@ -3036,7 +3037,7 @@ static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
>   {
>   	struct io_buffer *kbuf = req->kbuf;
>   	struct io_buffer *head;
> -	bool needs_lock = !(issue_flags & IO_URING_F_NONBLOCK);
> +	bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
>   
>   	if (req->flags & REQ_F_BUFFER_SELECTED)
>   		return kbuf;
> @@ -3341,7 +3342,7 @@ static inline int io_rw_prep_async(struct io_kiocb *req, int rw)
>   	int ret;
>   
>   	/* submission path, ->uring_lock should already be taken */
> -	ret = io_import_iovec(rw, req, &iov, &iorw->s, IO_URING_F_NONBLOCK);
> +	ret = io_import_iovec(rw, req, &iov, &iorw->s, 0);
>   	if (unlikely(ret < 0))
>   		return ret;
>   
> @@ -3452,6 +3453,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
>   	struct iovec *iovec;
>   	struct kiocb *kiocb = &req->rw.kiocb;
>   	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
> +	bool in_worker = issue_flags & IO_URING_F_UNLOCKED;

io_read shouldn't have notion of worker or whatever. I'd say let's
leave only force_nonblock here.

I assume 2/2 relies ot it, but if so you can make sure it ends up
in sync (!force_nonblock) at some point if all other ways fail.


>   	struct io_async_rw *rw;
>   	ssize_t ret, ret2;
>   
> @@ -3495,7 +3497,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
>   	if (ret == -EAGAIN || (req->flags & REQ_F_REISSUE)) {
>   		req->flags &= ~REQ_F_REISSUE;
>   		/* IOPOLL retry should happen for io-wq threads */
> -		if (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL))
> +		if (in_worker && !(req->ctx->flags & IORING_SETUP_IOPOLL))
>   			goto done;
>   		/* no retry on NONBLOCK nor RWF_NOWAIT */
>   		if (req->flags & REQ_F_NOWAIT)
> @@ -3503,7 +3505,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
>   		ret = 0;
>   	} else if (ret == -EIOCBQUEUED) {
>   		goto out_free;
> -	} else if (ret == req->result || ret <= 0 || !force_nonblock ||
> +	} else if (ret == req->result || ret <= 0 || in_worker ||
>   		   (req->flags & REQ_F_NOWAIT) || !need_read_all(req)) {
>   		/* read all, failed, already did sync or don't want to retry */
>   		goto done;
> @@ -3581,6 +3583,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
>   	struct iovec *iovec;
>   	struct kiocb *kiocb = &req->rw.kiocb;
>   	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
> +	bool in_worker = issue_flags & IO_URING_F_UNLOCKED;
>   	ssize_t ret, ret2;
>   
>   	if (!req_has_async_data(req)) {
> @@ -3651,7 +3654,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
>   	/* no retry on NONBLOCK nor RWF_NOWAIT */
>   	if (ret2 == -EAGAIN && (req->flags & REQ_F_NOWAIT))
>   		goto done;
> -	if (!force_nonblock || ret2 != -EAGAIN) {
> +	if (in_worker || ret2 != -EAGAIN) {
>   		/* IOPOLL retry should happen for io-wq threads */
>   		if ((req->ctx->flags & IORING_SETUP_IOPOLL) && ret2 == -EAGAIN)
>   			goto copy_iov;
> @@ -4314,9 +4317,9 @@ static int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
>   	struct io_ring_ctx *ctx = req->ctx;
>   	struct io_buffer *head;
>   	int ret = 0;
> -	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
> +	bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
>   
> -	io_ring_submit_lock(ctx, !force_nonblock);
> +	io_ring_submit_lock(ctx, needs_lock);
>   
>   	lockdep_assert_held(&ctx->uring_lock);
>   
> @@ -4329,7 +4332,7 @@ static int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
>   
>   	/* complete before unlock, IOPOLL may need the lock */
>   	__io_req_complete(req, issue_flags, ret, 0);
> -	io_ring_submit_unlock(ctx, !force_nonblock);
> +	io_ring_submit_unlock(ctx, needs_lock);
>   	return 0;
>   }
>   
> @@ -4401,9 +4404,9 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
>   	struct io_ring_ctx *ctx = req->ctx;
>   	struct io_buffer *head, *list;
>   	int ret = 0;
> -	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
> +	bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
>   
> -	io_ring_submit_lock(ctx, !force_nonblock);
> +	io_ring_submit_lock(ctx, needs_lock);
>   
>   	lockdep_assert_held(&ctx->uring_lock);
>   
> @@ -4419,7 +4422,7 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
>   		req_set_fail(req);
>   	/* complete before unlock, IOPOLL may need the lock */
>   	__io_req_complete(req, issue_flags, ret, 0);
> -	io_ring_submit_unlock(ctx, !force_nonblock);
> +	io_ring_submit_unlock(ctx, needs_lock);
>   	return 0;
>   }
>   
> @@ -6279,6 +6282,7 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
>   {
>   	struct io_ring_ctx *ctx = req->ctx;
>   	u64 sqe_addr = req->cancel.addr;
> +	bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
>   	struct io_tctx_node *node;
>   	int ret;
>   
> @@ -6287,7 +6291,7 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
>   		goto done;
>   
>   	/* slow path, try all io-wq's */
> -	io_ring_submit_lock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
> +	io_ring_submit_lock(ctx, needs_lock);
>   	ret = -ENOENT;
>   	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
>   		struct io_uring_task *tctx = node->task->io_uring;
> @@ -6296,7 +6300,7 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
>   		if (ret != -ENOENT)
>   			break;
>   	}
> -	io_ring_submit_unlock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
> +	io_ring_submit_unlock(ctx, needs_lock);
>   done:
>   	if (ret < 0)
>   		req_set_fail(req);
> @@ -6323,6 +6327,7 @@ static int io_rsrc_update_prep(struct io_kiocb *req,
>   static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
>   {
>   	struct io_ring_ctx *ctx = req->ctx;
> +	bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
>   	struct io_uring_rsrc_update2 up;
>   	int ret;
>   
> @@ -6332,10 +6337,10 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
>   	up.tags = 0;
>   	up.resv = 0;
>   
> -	io_ring_submit_lock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
> +	io_ring_submit_lock(ctx, needs_lock);
>   	ret = __io_register_rsrc_update(ctx, IORING_RSRC_FILE,
>   					&up, req->rsrc_update.nr_args);
> -	io_ring_submit_unlock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
> +	io_ring_submit_unlock(ctx, needs_lock);
>   
>   	if (ret < 0)
>   		req_set_fail(req);
> @@ -6745,7 +6750,7 @@ static void io_wq_submit_work(struct io_wq_work *work)
>   
>   	if (!ret) {
>   		do {
> -			ret = io_issue_sqe(req, 0);
> +			ret = io_issue_sqe(req, IO_URING_F_UNLOCKED);
>   			/*
>   			 * We can get EAGAIN for polled IO even though we're
>   			 * forcing a sync submission from here, since we can't
> @@ -8333,12 +8338,12 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
>   				 unsigned int issue_flags, u32 slot_index)
>   {
>   	struct io_ring_ctx *ctx = req->ctx;
> -	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
> +	bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
>   	bool needs_switch = false;
>   	struct io_fixed_file *file_slot;
>   	int ret = -EBADF;
>   
> -	io_ring_submit_lock(ctx, !force_nonblock);
> +	io_ring_submit_lock(ctx, needs_lock);
>   	if (file->f_op == &io_uring_fops)
>   		goto err;
>   	ret = -ENXIO;
> @@ -8379,7 +8384,7 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
>   err:
>   	if (needs_switch)
>   		io_rsrc_node_switch(ctx, ctx->file_data);
> -	io_ring_submit_unlock(ctx, !force_nonblock);
> +	io_ring_submit_unlock(ctx, needs_lock);
>   	if (ret)
>   		fput(file);
>   	return ret;
> @@ -8389,11 +8394,12 @@ static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
>   {
>   	unsigned int offset = req->close.file_slot - 1;
>   	struct io_ring_ctx *ctx = req->ctx;
> +	bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
>   	struct io_fixed_file *file_slot;
>   	struct file *file;
>   	int ret, i;
>   
> -	io_ring_submit_lock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
> +	io_ring_submit_lock(ctx, needs_lock);
>   	ret = -ENXIO;
>   	if (unlikely(!ctx->file_data))
>   		goto out;
> @@ -8419,7 +8425,7 @@ static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
>   	io_rsrc_node_switch(ctx, ctx->file_data);
>   	ret = 0;
>   out:
> -	io_ring_submit_unlock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
> +	io_ring_submit_unlock(ctx, needs_lock);
>   	return ret;
>   }
>   
> 

-- 
Pavel Begunkov
