Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D69743189B
	for <lists+io-uring@lfdr.de>; Mon, 18 Oct 2021 14:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhJRMPz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Oct 2021 08:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbhJRMPy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Oct 2021 08:15:54 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374D5C06161C
        for <io-uring@vger.kernel.org>; Mon, 18 Oct 2021 05:13:43 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id y74-20020a1c7d4d000000b00322f53b9bbfso4629843wmc.3
        for <io-uring@vger.kernel.org>; Mon, 18 Oct 2021 05:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=T9Fb8ga6MTlDR4hd/4P/R2+0tNdgoEz0LJyqz3KF2Ts=;
        b=PP/hHfNoihHV3ddM1kuSPw7rX2YSQnhRRvP8zlMabTqhwZiP2uR5b6FChJteaL0QVV
         9V8nRYLZ0loNX0BEv9qyKb3CNcWGEJKw5FSxi4ttbDSz9FfEPCbmWyA8iPIJnsw2qdtR
         cqz7tkzpu063vXDQV8hYCFVuCp3FQzwtX00M9OqR6rnix4NcxS3/qYCxZoIZF+1rEou9
         rJfK1G4VUbDPJiuPqlNYFtrdAILlIkvcpvDNSZSlH/lJDoN3BcICcONBNLIQS0z8D4qC
         uRzEAfUFYvUpXb0HAO/3Gf4JdQ5XqbnUz1PbnrB6C++2EJ6ClhpZ7+SDdjDksJQOyl5N
         uJnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=T9Fb8ga6MTlDR4hd/4P/R2+0tNdgoEz0LJyqz3KF2Ts=;
        b=RKV1C+IBK9UU0urhsBKh+0u4qabVhJObqPIh7wBcwtIX4Uqx80XG4wQkj8omzWRWul
         CSfhWwjff2uPsbEdZGDPIjrr+MHKd62qe6smvSK+L6KGGg2Arbx7WJxB/+4Mp9/nD+rj
         pFZIfbl1t5k7C07SebK2sIqtheDjOGPYEt87dbGgr4G0x+siwajHXWbEY3jqS5sAWwRo
         1hz0S1nMCkKN8sXPeVSQZTWqzVvhgM1waCsSjQHKzu8BRGf8eTrVRW44jp8P3eJQUl/C
         z1Av79F1B/Vqjde4tIMKe/CGTPlJBDYv2dth8cMP70VCe0J0xsFcX+o4HKVT2cJOaBCP
         hyGQ==
X-Gm-Message-State: AOAM532JqlG/6A2/NYJE2ErVCfT7kF5AkeUQeZ7vo1ymhJmYZyrwVYco
        GuJbpJjvglZdSM9Y06MxZyM=
X-Google-Smtp-Source: ABdhPJzikOGoSuwkfXMyvX6aROp2MZBnvnxJ5u7RC+gtWaFAvbcz2ahbdi8+pYNaG80cI2lYlcuXhA==
X-Received: by 2002:a05:600c:3b99:: with SMTP id n25mr30422299wms.50.1634559221807;
        Mon, 18 Oct 2021 05:13:41 -0700 (PDT)
Received: from [192.168.43.77] (82-132-230-135.dab.02.net. [82.132.230.135])
        by smtp.gmail.com with ESMTPSA id 196sm12393743wme.20.2021.10.18.05.13.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 05:13:41 -0700 (PDT)
Message-ID: <76a8f0aa-28c2-18e6-94e1-9c4911cb16f8@gmail.com>
Date:   Mon, 18 Oct 2021 12:13:55 +0000
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

We should have done it long ago. You can send it separately if
it'd help.

One more recently added spot is missing: io_iopoll_req_issued()


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
