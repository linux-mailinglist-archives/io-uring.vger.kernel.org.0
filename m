Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52398671E99
	for <lists+io-uring@lfdr.de>; Wed, 18 Jan 2023 14:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjARN4p (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Jan 2023 08:56:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjARN4Z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Jan 2023 08:56:25 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9EE829B5;
        Wed, 18 Jan 2023 05:27:49 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id s21so5388995edi.12;
        Wed, 18 Jan 2023 05:27:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jybypSNIQFGtir++JrTgFgAxnk7anuuDiecwkvSCew8=;
        b=FDGWDrtaXz6YVQxdYKOPXlrN4C3d6gy0IXYvwhvYKLzWcrqmSZq3l7S9MammGPQRRC
         vOsSlQT6Bp4P7KfI4sfcr9WxwdvEUesy+79Da8poSdkzoV9EPb0mqBnpZExK5pSOYKP/
         s2AKYKoB7jW62OsH5Rs6FUbAldPxgjsolxhearsGRZqKdn+ip7NoR0KpW9z4G0D0IuMf
         1zrA1YLkfy6ROojhfkyHeoB8c3ajaGP0GjjuhklUt1tSffGZL1tsUmXbTjsMUTpyzGLe
         jFBfbepCM6TJiqjZkiTag3KCq2mKxBINHpqtv7tCfwmZgfMW7ZYGPrpSBpZFfHMxw96x
         4b6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jybypSNIQFGtir++JrTgFgAxnk7anuuDiecwkvSCew8=;
        b=fiA5ObhmHLveVAZ8+UUQQUDu7cWuwVHUxODq+u8hn6y7c/+XZEM/MfBNm8XNSYf5uE
         ogq3X5wT96PLYmPK/nYWNHO1GcLjuD2aKmTAtZxTUzGgLKUrorSlqpBSdG7Q3fXpq4Nx
         M3PjMUBuejHRwWgnoid9HU2sc4DoSSVioOUMZNvYJ7IchfsFVCTSwAE4hmH+hM60vIn9
         Z7vjxFb0ur/0dl0H6r//s9iLeTdhuw+xnLiSjjkaFAp+HH+7dqXAHSFtV0hTdExuwX/D
         kNl44q0T8baz0WYQgNRNJNwi+1Yep4G/2ew2gFb5uf/bsLRDqaH1+O/6S/qtmyV7jy06
         2e1w==
X-Gm-Message-State: AFqh2kre0k681XiMMil12r4lHOzcgoZ6+3VXYOaZEpct25i3hhM3DSJb
        uB5Cs7bbQ9A+QjP1nwt6vR+qoL/WJes=
X-Google-Smtp-Source: AMrXdXsFE6cMbgU77YxtBkoPYaPh7J/tACcj538LSK+yPDA3m8kE7wTdOfuffHyvXYgz+4kKlnmEFQ==
X-Received: by 2002:a05:6402:3214:b0:49d:bc8c:c3eb with SMTP id g20-20020a056402321400b0049dbc8cc3ebmr8449612eda.15.1674048467911;
        Wed, 18 Jan 2023 05:27:47 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:fa37])
        by smtp.gmail.com with ESMTPSA id x13-20020aa7cd8d000000b0047e6fdbf81csm14239347edv.82.2023.01.18.05.27.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 05:27:47 -0800 (PST)
Message-ID: <a7d3e3e2-47a6-1d52-338b-fe68b85e00e0@gmail.com>
Date:   Wed, 18 Jan 2023 13:26:57 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 1/2] io_uring: Rename struct io_op_def
To:     Breno Leitao <leitao@debian.org>, dylany@meta.com, axboe@kernel.dk,
        io-uring@vger.kernel.org
Cc:     leit@fb.com, linux-kernel@vger.kernel.org
References: <20230112144411.2624698-1-leitao@debian.org>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230112144411.2624698-1-leitao@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/12/23 14:44, Breno Leitao wrote:
> The current io_op_def struct is becoming huge and the name is a bit
> generic.
> 
> The goal of this patch is to rename this struct to `io_issue_def`. This
> struct will contain the hot functions associated with the issue code
> path.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>


  
> For now, this patch only renames the structure, and an upcoming patch
> will break up the structure in two, moving the non-issue fields to a
> secondary struct.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>   io_uring/io_uring.c | 26 +++++++++++++-------------
>   io_uring/opdef.c    | 16 ++++++++--------
>   io_uring/opdef.h    |  4 ++--
>   io_uring/poll.c     |  2 +-
>   io_uring/rw.c       |  2 +-
>   5 files changed, 25 insertions(+), 25 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 2ac1cd8d23ea..ac7868ec9be2 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -407,7 +407,7 @@ static inline void io_arm_ltimeout(struct io_kiocb *req)
>   
>   static void io_prep_async_work(struct io_kiocb *req)
>   {
> -	const struct io_op_def *def = &io_op_defs[req->opcode];
> +	const struct io_issue_def *def = &io_issue_defs[req->opcode];
>   	struct io_ring_ctx *ctx = req->ctx;
>   
>   	if (!(req->flags & REQ_F_CREDS)) {
> @@ -980,7 +980,7 @@ void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
>   void io_req_defer_failed(struct io_kiocb *req, s32 res)
>   	__must_hold(&ctx->uring_lock)
>   {
> -	const struct io_op_def *def = &io_op_defs[req->opcode];
> +	const struct io_issue_def *def = &io_issue_defs[req->opcode];
>   
>   	lockdep_assert_held(&req->ctx->uring_lock);
>   
> @@ -1708,8 +1708,8 @@ unsigned int io_file_get_flags(struct file *file)
>   
>   bool io_alloc_async_data(struct io_kiocb *req)
>   {
> -	WARN_ON_ONCE(!io_op_defs[req->opcode].async_size);
> -	req->async_data = kmalloc(io_op_defs[req->opcode].async_size, GFP_KERNEL);
> +	WARN_ON_ONCE(!io_issue_defs[req->opcode].async_size);
> +	req->async_data = kmalloc(io_issue_defs[req->opcode].async_size, GFP_KERNEL);
>   	if (req->async_data) {
>   		req->flags |= REQ_F_ASYNC_DATA;
>   		return false;
> @@ -1719,7 +1719,7 @@ bool io_alloc_async_data(struct io_kiocb *req)
>   
>   int io_req_prep_async(struct io_kiocb *req)
>   {
> -	const struct io_op_def *def = &io_op_defs[req->opcode];
> +	const struct io_issue_def *def = &io_issue_defs[req->opcode];
>   
>   	/* assign early for deferred execution for non-fixed file */
>   	if (def->needs_file && !(req->flags & REQ_F_FIXED_FILE))
> @@ -1728,7 +1728,7 @@ int io_req_prep_async(struct io_kiocb *req)
>   		return 0;
>   	if (WARN_ON_ONCE(req_has_async_data(req)))
>   		return -EFAULT;
> -	if (!io_op_defs[req->opcode].manual_alloc) {
> +	if (!io_issue_defs[req->opcode].manual_alloc) {
>   		if (io_alloc_async_data(req))
>   			return -EAGAIN;
>   	}
> @@ -1801,7 +1801,7 @@ static void io_clean_op(struct io_kiocb *req)
>   	}
>   
>   	if (req->flags & REQ_F_NEED_CLEANUP) {
> -		const struct io_op_def *def = &io_op_defs[req->opcode];
> +		const struct io_issue_def *def = &io_issue_defs[req->opcode];
>   
>   		if (def->cleanup)
>   			def->cleanup(req);
> @@ -1827,7 +1827,7 @@ static void io_clean_op(struct io_kiocb *req)
>   
>   static bool io_assign_file(struct io_kiocb *req, unsigned int issue_flags)
>   {
> -	if (req->file || !io_op_defs[req->opcode].needs_file)
> +	if (req->file || !io_issue_defs[req->opcode].needs_file)
>   		return true;
>   
>   	if (req->flags & REQ_F_FIXED_FILE)
> @@ -1840,7 +1840,7 @@ static bool io_assign_file(struct io_kiocb *req, unsigned int issue_flags)
>   
>   static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>   {
> -	const struct io_op_def *def = &io_op_defs[req->opcode];
> +	const struct io_issue_def *def = &io_issue_defs[req->opcode];
>   	const struct cred *creds = NULL;
>   	int ret;
>   
> @@ -1894,7 +1894,7 @@ struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
>   void io_wq_submit_work(struct io_wq_work *work)
>   {
>   	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
> -	const struct io_op_def *def = &io_op_defs[req->opcode];
> +	const struct io_issue_def *def = &io_issue_defs[req->opcode];
>   	unsigned int issue_flags = IO_URING_F_UNLOCKED | IO_URING_F_IOWQ;
>   	bool needs_poll = false;
>   	int ret = 0, err = -ECANCELED;
> @@ -2106,7 +2106,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>   		       const struct io_uring_sqe *sqe)
>   	__must_hold(&ctx->uring_lock)
>   {
> -	const struct io_op_def *def;
> +	const struct io_issue_def *def;
>   	unsigned int sqe_flags;
>   	int personality;
>   	u8 opcode;
> @@ -2124,7 +2124,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>   		req->opcode = 0;
>   		return -EINVAL;
>   	}
> -	def = &io_op_defs[opcode];
> +	def = &io_issue_defs[opcode];
>   	if (unlikely(sqe_flags & ~SQE_COMMON_FLAGS)) {
>   		/* enforce forwards compatibility on users */
>   		if (sqe_flags & ~SQE_VALID_FLAGS)
> @@ -3762,7 +3762,7 @@ static __cold int io_probe(struct io_ring_ctx *ctx, void __user *arg,
>   
>   	for (i = 0; i < nr_args; i++) {
>   		p->ops[i].op = i;
> -		if (!io_op_defs[i].not_supported)
> +		if (!io_issue_defs[i].not_supported)
>   			p->ops[i].flags = IO_URING_OP_SUPPORTED;
>   	}
>   	p->ops_len = i;
> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> index 3aa0d65c50e3..3c95e70a625e 100644
> --- a/io_uring/opdef.c
> +++ b/io_uring/opdef.c
> @@ -46,7 +46,7 @@ static __maybe_unused int io_eopnotsupp_prep(struct io_kiocb *kiocb,
>   	return -EOPNOTSUPP;
>   }
>   
> -const struct io_op_def io_op_defs[] = {
> +const struct io_issue_def io_issue_defs[] = {
>   	[IORING_OP_NOP] = {
>   		.audit_skip		= 1,
>   		.iopoll			= 1,
> @@ -536,7 +536,7 @@ const struct io_op_def io_op_defs[] = {
>   const char *io_uring_get_opcode(u8 opcode)
>   {
>   	if (opcode < IORING_OP_LAST)
> -		return io_op_defs[opcode].name;
> +		return io_issue_defs[opcode].name;
>   	return "INVALID";
>   }
>   
> @@ -544,12 +544,12 @@ void __init io_uring_optable_init(void)
>   {
>   	int i;
>   
> -	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
> +	BUILD_BUG_ON(ARRAY_SIZE(io_issue_defs) != IORING_OP_LAST);
>   
> -	for (i = 0; i < ARRAY_SIZE(io_op_defs); i++) {
> -		BUG_ON(!io_op_defs[i].prep);
> -		if (io_op_defs[i].prep != io_eopnotsupp_prep)
> -			BUG_ON(!io_op_defs[i].issue);
> -		WARN_ON_ONCE(!io_op_defs[i].name);
> +	for (i = 0; i < ARRAY_SIZE(io_issue_defs); i++) {
> +		BUG_ON(!io_issue_defs[i].prep);
> +		if (io_issue_defs[i].prep != io_eopnotsupp_prep)
> +			BUG_ON(!io_issue_defs[i].issue);
> +		WARN_ON_ONCE(!io_issue_defs[i].name);
>   	}
>   }
> diff --git a/io_uring/opdef.h b/io_uring/opdef.h
> index df7e13d9bfba..d718e2ab1ff7 100644
> --- a/io_uring/opdef.h
> +++ b/io_uring/opdef.h
> @@ -2,7 +2,7 @@
>   #ifndef IOU_OP_DEF_H
>   #define IOU_OP_DEF_H
>   
> -struct io_op_def {
> +struct io_issue_def {
>   	/* needs req->file assigned */
>   	unsigned		needs_file : 1;
>   	/* should block plug */
> @@ -41,7 +41,7 @@ struct io_op_def {
>   	void (*fail)(struct io_kiocb *);
>   };
>   
> -extern const struct io_op_def io_op_defs[];
> +extern const struct io_issue_def io_issue_defs[];
>   
>   void io_uring_optable_init(void);
>   #endif
> diff --git a/io_uring/poll.c b/io_uring/poll.c
> index ee7da6150ec4..7a6d5d0da966 100644
> --- a/io_uring/poll.c
> +++ b/io_uring/poll.c
> @@ -658,7 +658,7 @@ static struct async_poll *io_req_alloc_apoll(struct io_kiocb *req,
>   
>   int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
>   {
> -	const struct io_op_def *def = &io_op_defs[req->opcode];
> +	const struct io_issue_def *def = &io_issue_defs[req->opcode];
>   	struct async_poll *apoll;
>   	struct io_poll_table ipt;
>   	__poll_t mask = POLLPRI | POLLERR | EPOLLET;
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 8227af2e1c0f..54b44b9b736c 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -516,7 +516,7 @@ static void io_req_map_rw(struct io_kiocb *req, const struct iovec *iovec,
>   static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
>   			     struct io_rw_state *s, bool force)
>   {
> -	if (!force && !io_op_defs[req->opcode].prep_async)
> +	if (!force && !io_issue_defs[req->opcode].prep_async)
>   		return 0;
>   	if (!req_has_async_data(req)) {
>   		struct io_async_rw *iorw;

-- 
Pavel Begunkov
