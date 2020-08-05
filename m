Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DF723C40A
	for <lists+io-uring@lfdr.de>; Wed,  5 Aug 2020 05:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgHEDkw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Aug 2020 23:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgHEDkt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Aug 2020 23:40:49 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF37C061756;
        Tue,  4 Aug 2020 20:40:49 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id y206so11613163pfb.10;
        Tue, 04 Aug 2020 20:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=54CoK74xt78Kbjv87QKgXMN4+9I745UqhzPk9txnYXQ=;
        b=JkHOH4J1iC82XFFrlO6lyea3j6etqLrDGju86LedD0HVhqQwqAEK+pUKZR3IT1lNdT
         RhQMOXVvE9FZQbc58TBCnE/VIGuMNYdjPMTC18UC9eWhaKN57sExN8pMkLY15lz/vGt1
         Vb3T1Oa+H3fdSsohXdxPBowTsRuex7uaxzLpB2AW21Oe9IrMiqPmOMH/bduDfmSvbF1s
         ZwTHLSXYTMczuJ4uzGLOViN2YUfDIapqGpOZUfPYeJPigAcB9ue5O8L9G7vvKhvr+eey
         jn7FVJaJ+Z7LEKiSURgChE6bnzkKI+ga6k9TzHXU7CHJsbVVxHD6wYn2NyTQ567ZkAQC
         N7KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=54CoK74xt78Kbjv87QKgXMN4+9I745UqhzPk9txnYXQ=;
        b=HFsRBF8944Y4utoM7gD6XaI8zxERlMH+rOuwWYfd1MnlopkAmHvlQIM7E3Vummc5m7
         s3o4F4FglQGneB8hF4OcWJcK3/N+yr1mhZwQUHdDL1AXM6w2vISMepVXMxiraQyoXlDX
         zGPNgRF6u/W4tRC7rMv+eFTS+U6+UwKddoo3PukZEvn88uRUd77i/t+PIcBMQoaxbjoL
         Ut/Lu+tQT7kB5yKx8XRxdLy3znX5y+63//0fJ22sryMsnsLGsTs8Xmt4lF5aVgLHkRm9
         bOQ9BzqO89gZUxluThNQQuw9Viwm4hBj65bbQGblVyqHyl3wU85nQClrkmRvWNxXLMdb
         /AvQ==
X-Gm-Message-State: AOAM530lJg33bKSMPUBVy7JfA/zNdb69cB7YgeqJHQ6ohvsbm+EEaCEM
        RwVGYAYbX1jjufsXLnRZa7M=
X-Google-Smtp-Source: ABdhPJx7JJHctqwSZdDWEv74xw5fxDVZabZamDMOjnVF80+DFAhpCKnop1TQCeaXADt2+7Vzeuelmg==
X-Received: by 2002:aa7:95b8:: with SMTP id a24mr1351933pfk.219.1596598848645;
        Tue, 04 Aug 2020 20:40:48 -0700 (PDT)
Received: from localhost ([104.192.108.9])
        by smtp.gmail.com with ESMTPSA id mp1sm829927pjb.27.2020.08.04.20.40.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Aug 2020 20:40:48 -0700 (PDT)
Date:   Tue, 4 Aug 2020 20:40:44 -0700
From:   Liu Yong <pkfxxxing@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        =?utf-8?Q?=E3=80=81_linux-block=40vger=2Ekernel=2Eorg?= 
        <linux-block@vger.kernel.org>,
        =?utf-8?B?44CBaW8tdXJpbmc=?= <io-uring@vger.kernel.org>
Subject: Re: [PATCH] fs/io_uring.c: fix null ptr deference in
 io_send_recvmsg()
Message-ID: <20200805034044.GB24925@ubuntu>
References: <20200804125637.GA22088@ubuntu>
 <701640d6-fa20-0b38-f86b-b1eff07597dd@gmail.com>
 <0350a653-8a3e-2e09-c7fc-15fcea727d8a@kernel.dk>
 <CAGAoTxzadSphnE2aLsFKS04TjTKYVq2uLFgH9dvLPwWiyqEGEQ@mail.gmail.com>
 <c7194bbc-06ed-30d1-704a-cb0d9f9e2b8d@kernel.dk>
 <f099f7cd-4be8-7bd3-d8af-52257d8e88f1@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f099f7cd-4be8-7bd3-d8af-52257d8e88f1@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 04, 2020 at 03:55:16PM -0600, Jens Axboe wrote:
> On 8/4/20 11:15 AM, Jens Axboe wrote:
> > On 8/4/20 11:02 AM, xiao lin wrote:
> >> 在 2020年8月4日星期二，Jens Axboe <axboe@kernel.dk <mailto:axboe@kernel.dk>> 写道：
> >>
> >>     On 8/4/20 7:18 AM, Pavel Begunkov wrote:
> >>     > On 04/08/2020 15:56, Liu Yong wrote:
> >>     >> In io_send_recvmsg(), there is no check for the req->file.
> >>     >> User can change the opcode from IORING_OP_NOP to IORING_OP_SENDMSG
> >>     >> through competition after the io_req_set_file().
> >>     >
> >>     > After sqe->opcode is read and copied in io_init_req(), it only uses
> >>     > in-kernel req->opcode. Also, io_init_req() should check for req->file
> >>     > NULL, so shouldn't happen after.
> >>     >
> >>     > Do you have a reproducer? What kernel version did you use?
> >>
> >>     Was looking at this too, and I'm guessing this is some 5.4 based kernel.
> >>     Unfortunately the oops doesn't include that information.
> > 
> >> Sorry, I forgot to mention that the kernel version I am using is 5.4.55.
> > 
> > I think there are two options here:
> > 
> > 1) Backport the series that ensured we only read those important bits once
> > 2) Make s->sqe a full sqe, and memcpy it in
> 
> Something like this should close the ->opcode re-read for 5.4-stable.
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e0200406765c..8bb5e19b7c3c 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -279,6 +279,7 @@ struct sqe_submit {
>  	bool				has_user;
>  	bool				needs_lock;
>  	bool				needs_fixed_file;
> +	u8				opcode;
>  };
>  
>  /*
> @@ -505,7 +506,7 @@ static inline void io_queue_async_work(struct io_ring_ctx *ctx,
>  	int rw = 0;
>  
>  	if (req->submit.sqe) {
> -		switch (req->submit.sqe->opcode) {
> +		switch (req->submit.opcode) {
>  		case IORING_OP_WRITEV:
>  		case IORING_OP_WRITE_FIXED:
>  			rw = !(req->rw.ki_flags & IOCB_DIRECT);
> @@ -1254,23 +1255,15 @@ static int io_import_fixed(struct io_ring_ctx *ctx, int rw,
>  }
>  
>  static ssize_t io_import_iovec(struct io_ring_ctx *ctx, int rw,
> -			       const struct sqe_submit *s, struct iovec **iovec,
> +			       struct io_kiocb *req, struct iovec **iovec,
>  			       struct iov_iter *iter)
>  {
> -	const struct io_uring_sqe *sqe = s->sqe;
> +	const struct io_uring_sqe *sqe = req->submit.sqe;
>  	void __user *buf = u64_to_user_ptr(READ_ONCE(sqe->addr));
>  	size_t sqe_len = READ_ONCE(sqe->len);
>  	u8 opcode;
>  
> -	/*
> -	 * We're reading ->opcode for the second time, but the first read
> -	 * doesn't care whether it's _FIXED or not, so it doesn't matter
> -	 * whether ->opcode changes concurrently. The first read does care
> -	 * about whether it is a READ or a WRITE, so we don't trust this read
> -	 * for that purpose and instead let the caller pass in the read/write
> -	 * flag.
> -	 */
> -	opcode = READ_ONCE(sqe->opcode);
> +	opcode = req->submit.opcode;
>  	if (opcode == IORING_OP_READ_FIXED ||
>  	    opcode == IORING_OP_WRITE_FIXED) {
>  		ssize_t ret = io_import_fixed(ctx, rw, sqe, iter);
> @@ -1278,7 +1271,7 @@ static ssize_t io_import_iovec(struct io_ring_ctx *ctx, int rw,
>  		return ret;
>  	}
>  
> -	if (!s->has_user)
> +	if (!req->submit.has_user)
>  		return -EFAULT;
>  
>  #ifdef CONFIG_COMPAT
> @@ -1425,7 +1418,7 @@ static int io_read(struct io_kiocb *req, const struct sqe_submit *s,
>  	if (unlikely(!(file->f_mode & FMODE_READ)))
>  		return -EBADF;
>  
> -	ret = io_import_iovec(req->ctx, READ, s, &iovec, &iter);
> +	ret = io_import_iovec(req->ctx, READ, req, &iovec, &iter);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -1490,7 +1483,7 @@ static int io_write(struct io_kiocb *req, const struct sqe_submit *s,
>  	if (unlikely(!(file->f_mode & FMODE_WRITE)))
>  		return -EBADF;
>  
> -	ret = io_import_iovec(req->ctx, WRITE, s, &iovec, &iter);
> +	ret = io_import_iovec(req->ctx, WRITE, req, &iovec, &iter);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -2109,15 +2102,14 @@ static int io_req_defer(struct io_ring_ctx *ctx, struct io_kiocb *req,
>  static int __io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>  			   const struct sqe_submit *s, bool force_nonblock)
>  {
> -	int ret, opcode;
> +	int ret;
>  
>  	req->user_data = READ_ONCE(s->sqe->user_data);
>  
>  	if (unlikely(s->index >= ctx->sq_entries))
>  		return -EINVAL;
>  
> -	opcode = READ_ONCE(s->sqe->opcode);
> -	switch (opcode) {
> +	switch (req->submit.opcode) {
>  	case IORING_OP_NOP:
>  		ret = io_nop(req, req->user_data);
>  		break;
> @@ -2181,10 +2173,10 @@ static int __io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>  	return 0;
>  }
>  
> -static struct async_list *io_async_list_from_sqe(struct io_ring_ctx *ctx,
> -						 const struct io_uring_sqe *sqe)
> +static struct async_list *io_async_list_from_req(struct io_ring_ctx *ctx,
> +						 struct io_kiocb *req)
>  {
> -	switch (sqe->opcode) {
> +	switch (req->submit.opcode) {
>  	case IORING_OP_READV:
>  	case IORING_OP_READ_FIXED:
>  		return &ctx->pending_async[READ];
> @@ -2196,12 +2188,10 @@ static struct async_list *io_async_list_from_sqe(struct io_ring_ctx *ctx,
>  	}
>  }
>  
> -static inline bool io_sqe_needs_user(const struct io_uring_sqe *sqe)
> +static inline bool io_req_needs_user(struct io_kiocb *req)
>  {
> -	u8 opcode = READ_ONCE(sqe->opcode);
> -
> -	return !(opcode == IORING_OP_READ_FIXED ||
> -		 opcode == IORING_OP_WRITE_FIXED);
> +	return !(req->submit.opcode == IORING_OP_READ_FIXED ||
> +		req->submit.opcode == IORING_OP_WRITE_FIXED);
>  }
>  
>  static void io_sq_wq_submit_work(struct work_struct *work)
> @@ -2217,7 +2207,7 @@ static void io_sq_wq_submit_work(struct work_struct *work)
>  	int ret;
>  
>  	old_cred = override_creds(ctx->creds);
> -	async_list = io_async_list_from_sqe(ctx, req->submit.sqe);
> +	async_list = io_async_list_from_req(ctx, req);
>  
>  	allow_kernel_signal(SIGINT);
>  restart:
> @@ -2239,7 +2229,7 @@ static void io_sq_wq_submit_work(struct work_struct *work)
>  		}
>  
>  		ret = 0;
> -		if (io_sqe_needs_user(sqe) && !cur_mm) {
> +		if (io_req_needs_user(req) && !cur_mm) {
>  			if (!mmget_not_zero(ctx->sqo_mm)) {
>  				ret = -EFAULT;
>  			} else {
> @@ -2387,11 +2377,9 @@ static bool io_add_to_prev_work(struct async_list *list, struct io_kiocb *req)
>  	return ret;
>  }
>  
> -static bool io_op_needs_file(const struct io_uring_sqe *sqe)
> +static bool io_op_needs_file(struct io_kiocb *req)
>  {
> -	int op = READ_ONCE(sqe->opcode);
> -
> -	switch (op) {
> +	switch (req->submit.opcode) {
>  	case IORING_OP_NOP:
>  	case IORING_OP_POLL_REMOVE:
>  	case IORING_OP_TIMEOUT:
> @@ -2419,7 +2407,7 @@ static int io_req_set_file(struct io_ring_ctx *ctx, const struct sqe_submit *s,
>  	 */
>  	req->sequence = s->sequence;
>  
> -	if (!io_op_needs_file(s->sqe))
> +	if (!io_op_needs_file(req))
>  		return 0;
>  
>  	if (flags & IOSQE_FIXED_FILE) {
> @@ -2460,7 +2448,7 @@ static int __io_queue_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>  
>  			s->sqe = sqe_copy;
>  			memcpy(&req->submit, s, sizeof(*s));
> -			list = io_async_list_from_sqe(ctx, s->sqe);
> +			list = io_async_list_from_req(ctx, req);
>  			if (!io_add_to_prev_work(list, req)) {
>  				if (list)
>  					atomic_inc(&list->cnt);
> @@ -2582,7 +2570,7 @@ static void io_submit_sqe(struct io_ring_ctx *ctx, struct sqe_submit *s,
>  	req->user_data = s->sqe->user_data;
>  
>  #if defined(CONFIG_NET)
> -	switch (READ_ONCE(s->sqe->opcode)) {
> +	switch (req->submit.opcode) {
>  	case IORING_OP_SENDMSG:
>  	case IORING_OP_RECVMSG:
>  		spin_lock(&current->fs->lock);
> @@ -2697,6 +2685,7 @@ static bool io_get_sqring(struct io_ring_ctx *ctx, struct sqe_submit *s)
>  	if (head < ctx->sq_entries) {
>  		s->index = head;
>  		s->sqe = &ctx->sq_sqes[head];
> +		s->opcode = READ_ONCE(s->sqe->opcode);
>  		s->sequence = ctx->cached_sq_head;
>  		ctx->cached_sq_head++;
>  		return true;
> 
> -- 
> Jens Axboe
> 

I think this patch solves similar problems from the root cause.
So, Should I submit this commit, or you?

