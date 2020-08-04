Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 064B423C1BF
	for <lists+io-uring@lfdr.de>; Tue,  4 Aug 2020 23:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgHDV5f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Aug 2020 17:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728277AbgHDV5f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Aug 2020 17:57:35 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C10C06174A
        for <io-uring@vger.kernel.org>; Tue,  4 Aug 2020 14:57:35 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id k18so14235861pfp.7
        for <io-uring@vger.kernel.org>; Tue, 04 Aug 2020 14:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Xy+3NszqDm1xAmBR4U/4lOhhfNoJIyxtpkgMKWfCnj4=;
        b=XfjAcfDJOz8o7ngtMXeU4YGfo9gyv2FU6EqF7b0MuKaeNf3jm0ZOZKdYnTCvN7ojBW
         zDHLWB7Hck3C3+gNPNLhtqhWe9j5dW1AyYltjWeLgHFTgQEyD4xUvceNOlIbIh0VD9+D
         J+1fdKssxffERua23ZRKO2LOQX24S3gsHmTxwUuZn7b1KQ3Ds1I/Woj0zrUX1L8kxyYU
         B111GfUWHG3vx/YrkrfMVd3ETda3GcEsorAdKiultAF4g0GQTu8MvJw3tqL5uvKt6Hsu
         crAUbAfBfob5+hQ2Fir/cJ86E83icm849CReeBBYIGHMkynyv1xDLfeMb1Riwyc1vbY+
         LXPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xy+3NszqDm1xAmBR4U/4lOhhfNoJIyxtpkgMKWfCnj4=;
        b=KFNCyOFIz2rdWFQfxypZpkXXq4LPCN+TvIJP0u3y+QOoKZPKWAvv6Z06v24J+948hV
         FP4uUzSJgwuYBQyNsz72m3leIPUHM2zLzkys+mpzRZJIKptW8Sqj1+40u2ukW5wAka9O
         GDadnGXfbfI4jTsxnrXlpGAKCyramQtNeORooczFe4/CmtoxKuMpfMDi6BnJiH2JJtqZ
         GvDKBxy0ShZmYwMw4nsPSutG9+OaAZe2HJPk+iRm5v9JxWWkxyzOotbiY2JWAnymNSBu
         mr/zncEIPs3w+FEJ7HFCxiYiCzdDtPLywpoEhItjMj85cjvsCwNDOL0dJpIVciQaKhMr
         6s+w==
X-Gm-Message-State: AOAM5327aMtGaZK9GmrQsJ0h8yr+0I7c0CRzTvg3fHhIKYTwUs4fdcFj
        wgzs2b7VT6cA+bwNrLteZCHlTrQ6sOc=
X-Google-Smtp-Source: ABdhPJzYv6KoBV5XvdTTpslktXxvcPGsb+uJsuHj0PdM0TpqxAeoMlIzeHSgIumPMxYm94l3tFjzcA==
X-Received: by 2002:a63:d74c:: with SMTP id w12mr426746pgi.260.1596578254242;
        Tue, 04 Aug 2020 14:57:34 -0700 (PDT)
Received: from [172.20.10.2] ([107.72.97.226])
        by smtp.gmail.com with ESMTPSA id o10sm24323pjo.55.2020.08.04.14.57.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 14:57:33 -0700 (PDT)
Subject: Re: [PATCH] fs/io_uring.c: fix null ptr deference in
 io_send_recvmsg()
From:   Jens Axboe <axboe@kernel.dk>
To:     xiao lin <pkfxxxing@gmail.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
References: <20200804125637.GA22088@ubuntu>
 <701640d6-fa20-0b38-f86b-b1eff07597dd@gmail.com>
 <0350a653-8a3e-2e09-c7fc-15fcea727d8a@kernel.dk>
 <CAGAoTxzadSphnE2aLsFKS04TjTKYVq2uLFgH9dvLPwWiyqEGEQ@mail.gmail.com>
 <c7194bbc-06ed-30d1-704a-cb0d9f9e2b8d@kernel.dk>
Message-ID: <f099f7cd-4be8-7bd3-d8af-52257d8e88f1@kernel.dk>
Date:   Tue, 4 Aug 2020 15:55:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c7194bbc-06ed-30d1-704a-cb0d9f9e2b8d@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/4/20 11:15 AM, Jens Axboe wrote:
> On 8/4/20 11:02 AM, xiao lin wrote:
>> 在 2020年8月4日星期二，Jens Axboe <axboe@kernel.dk <mailto:axboe@kernel.dk>> 写道：
>>
>>     On 8/4/20 7:18 AM, Pavel Begunkov wrote:
>>     > On 04/08/2020 15:56, Liu Yong wrote:
>>     >> In io_send_recvmsg(), there is no check for the req->file.
>>     >> User can change the opcode from IORING_OP_NOP to IORING_OP_SENDMSG
>>     >> through competition after the io_req_set_file().
>>     >
>>     > After sqe->opcode is read and copied in io_init_req(), it only uses
>>     > in-kernel req->opcode. Also, io_init_req() should check for req->file
>>     > NULL, so shouldn't happen after.
>>     >
>>     > Do you have a reproducer? What kernel version did you use?
>>
>>     Was looking at this too, and I'm guessing this is some 5.4 based kernel.
>>     Unfortunately the oops doesn't include that information.
> 
>> Sorry, I forgot to mention that the kernel version I am using is 5.4.55.
> 
> I think there are two options here:
> 
> 1) Backport the series that ensured we only read those important bits once
> 2) Make s->sqe a full sqe, and memcpy it in

Something like this should close the ->opcode re-read for 5.4-stable.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e0200406765c..8bb5e19b7c3c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -279,6 +279,7 @@ struct sqe_submit {
 	bool				has_user;
 	bool				needs_lock;
 	bool				needs_fixed_file;
+	u8				opcode;
 };
 
 /*
@@ -505,7 +506,7 @@ static inline void io_queue_async_work(struct io_ring_ctx *ctx,
 	int rw = 0;
 
 	if (req->submit.sqe) {
-		switch (req->submit.sqe->opcode) {
+		switch (req->submit.opcode) {
 		case IORING_OP_WRITEV:
 		case IORING_OP_WRITE_FIXED:
 			rw = !(req->rw.ki_flags & IOCB_DIRECT);
@@ -1254,23 +1255,15 @@ static int io_import_fixed(struct io_ring_ctx *ctx, int rw,
 }
 
 static ssize_t io_import_iovec(struct io_ring_ctx *ctx, int rw,
-			       const struct sqe_submit *s, struct iovec **iovec,
+			       struct io_kiocb *req, struct iovec **iovec,
 			       struct iov_iter *iter)
 {
-	const struct io_uring_sqe *sqe = s->sqe;
+	const struct io_uring_sqe *sqe = req->submit.sqe;
 	void __user *buf = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	size_t sqe_len = READ_ONCE(sqe->len);
 	u8 opcode;
 
-	/*
-	 * We're reading ->opcode for the second time, but the first read
-	 * doesn't care whether it's _FIXED or not, so it doesn't matter
-	 * whether ->opcode changes concurrently. The first read does care
-	 * about whether it is a READ or a WRITE, so we don't trust this read
-	 * for that purpose and instead let the caller pass in the read/write
-	 * flag.
-	 */
-	opcode = READ_ONCE(sqe->opcode);
+	opcode = req->submit.opcode;
 	if (opcode == IORING_OP_READ_FIXED ||
 	    opcode == IORING_OP_WRITE_FIXED) {
 		ssize_t ret = io_import_fixed(ctx, rw, sqe, iter);
@@ -1278,7 +1271,7 @@ static ssize_t io_import_iovec(struct io_ring_ctx *ctx, int rw,
 		return ret;
 	}
 
-	if (!s->has_user)
+	if (!req->submit.has_user)
 		return -EFAULT;
 
 #ifdef CONFIG_COMPAT
@@ -1425,7 +1418,7 @@ static int io_read(struct io_kiocb *req, const struct sqe_submit *s,
 	if (unlikely(!(file->f_mode & FMODE_READ)))
 		return -EBADF;
 
-	ret = io_import_iovec(req->ctx, READ, s, &iovec, &iter);
+	ret = io_import_iovec(req->ctx, READ, req, &iovec, &iter);
 	if (ret < 0)
 		return ret;
 
@@ -1490,7 +1483,7 @@ static int io_write(struct io_kiocb *req, const struct sqe_submit *s,
 	if (unlikely(!(file->f_mode & FMODE_WRITE)))
 		return -EBADF;
 
-	ret = io_import_iovec(req->ctx, WRITE, s, &iovec, &iter);
+	ret = io_import_iovec(req->ctx, WRITE, req, &iovec, &iter);
 	if (ret < 0)
 		return ret;
 
@@ -2109,15 +2102,14 @@ static int io_req_defer(struct io_ring_ctx *ctx, struct io_kiocb *req,
 static int __io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			   const struct sqe_submit *s, bool force_nonblock)
 {
-	int ret, opcode;
+	int ret;
 
 	req->user_data = READ_ONCE(s->sqe->user_data);
 
 	if (unlikely(s->index >= ctx->sq_entries))
 		return -EINVAL;
 
-	opcode = READ_ONCE(s->sqe->opcode);
-	switch (opcode) {
+	switch (req->submit.opcode) {
 	case IORING_OP_NOP:
 		ret = io_nop(req, req->user_data);
 		break;
@@ -2181,10 +2173,10 @@ static int __io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	return 0;
 }
 
-static struct async_list *io_async_list_from_sqe(struct io_ring_ctx *ctx,
-						 const struct io_uring_sqe *sqe)
+static struct async_list *io_async_list_from_req(struct io_ring_ctx *ctx,
+						 struct io_kiocb *req)
 {
-	switch (sqe->opcode) {
+	switch (req->submit.opcode) {
 	case IORING_OP_READV:
 	case IORING_OP_READ_FIXED:
 		return &ctx->pending_async[READ];
@@ -2196,12 +2188,10 @@ static struct async_list *io_async_list_from_sqe(struct io_ring_ctx *ctx,
 	}
 }
 
-static inline bool io_sqe_needs_user(const struct io_uring_sqe *sqe)
+static inline bool io_req_needs_user(struct io_kiocb *req)
 {
-	u8 opcode = READ_ONCE(sqe->opcode);
-
-	return !(opcode == IORING_OP_READ_FIXED ||
-		 opcode == IORING_OP_WRITE_FIXED);
+	return !(req->submit.opcode == IORING_OP_READ_FIXED ||
+		req->submit.opcode == IORING_OP_WRITE_FIXED);
 }
 
 static void io_sq_wq_submit_work(struct work_struct *work)
@@ -2217,7 +2207,7 @@ static void io_sq_wq_submit_work(struct work_struct *work)
 	int ret;
 
 	old_cred = override_creds(ctx->creds);
-	async_list = io_async_list_from_sqe(ctx, req->submit.sqe);
+	async_list = io_async_list_from_req(ctx, req);
 
 	allow_kernel_signal(SIGINT);
 restart:
@@ -2239,7 +2229,7 @@ static void io_sq_wq_submit_work(struct work_struct *work)
 		}
 
 		ret = 0;
-		if (io_sqe_needs_user(sqe) && !cur_mm) {
+		if (io_req_needs_user(req) && !cur_mm) {
 			if (!mmget_not_zero(ctx->sqo_mm)) {
 				ret = -EFAULT;
 			} else {
@@ -2387,11 +2377,9 @@ static bool io_add_to_prev_work(struct async_list *list, struct io_kiocb *req)
 	return ret;
 }
 
-static bool io_op_needs_file(const struct io_uring_sqe *sqe)
+static bool io_op_needs_file(struct io_kiocb *req)
 {
-	int op = READ_ONCE(sqe->opcode);
-
-	switch (op) {
+	switch (req->submit.opcode) {
 	case IORING_OP_NOP:
 	case IORING_OP_POLL_REMOVE:
 	case IORING_OP_TIMEOUT:
@@ -2419,7 +2407,7 @@ static int io_req_set_file(struct io_ring_ctx *ctx, const struct sqe_submit *s,
 	 */
 	req->sequence = s->sequence;
 
-	if (!io_op_needs_file(s->sqe))
+	if (!io_op_needs_file(req))
 		return 0;
 
 	if (flags & IOSQE_FIXED_FILE) {
@@ -2460,7 +2448,7 @@ static int __io_queue_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 			s->sqe = sqe_copy;
 			memcpy(&req->submit, s, sizeof(*s));
-			list = io_async_list_from_sqe(ctx, s->sqe);
+			list = io_async_list_from_req(ctx, req);
 			if (!io_add_to_prev_work(list, req)) {
 				if (list)
 					atomic_inc(&list->cnt);
@@ -2582,7 +2570,7 @@ static void io_submit_sqe(struct io_ring_ctx *ctx, struct sqe_submit *s,
 	req->user_data = s->sqe->user_data;
 
 #if defined(CONFIG_NET)
-	switch (READ_ONCE(s->sqe->opcode)) {
+	switch (req->submit.opcode) {
 	case IORING_OP_SENDMSG:
 	case IORING_OP_RECVMSG:
 		spin_lock(&current->fs->lock);
@@ -2697,6 +2685,7 @@ static bool io_get_sqring(struct io_ring_ctx *ctx, struct sqe_submit *s)
 	if (head < ctx->sq_entries) {
 		s->index = head;
 		s->sqe = &ctx->sq_sqes[head];
+		s->opcode = READ_ONCE(s->sqe->opcode);
 		s->sequence = ctx->cached_sq_head;
 		ctx->cached_sq_head++;
 		return true;

-- 
Jens Axboe

