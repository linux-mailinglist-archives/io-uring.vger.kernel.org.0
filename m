Return-Path: <io-uring+bounces-8497-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 471D0AEA54A
	for <lists+io-uring@lfdr.de>; Thu, 26 Jun 2025 20:23:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C28F21C426D8
	for <lists+io-uring@lfdr.de>; Thu, 26 Jun 2025 18:23:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A68C6339A8;
	Thu, 26 Jun 2025 18:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="a9CVkWZq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4502EB5D4
	for <io-uring@vger.kernel.org>; Thu, 26 Jun 2025 18:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750962201; cv=none; b=t/7XSlpueoRpzwd83wodP9AFln9AuaM3CvV8Qf+yELAml86Uan3UoIUuQ7l/KF47Eejne/n9AdTahPqxm1tmNvLvNOYp42XXC7JWCI2gYDVF9MlAo0i4lnn1fKFcPajxfiQJokfEGqzUMz87AhVwM9f/dkC7YNBslkL0nt+550c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750962201; c=relaxed/simple;
	bh=jy6skKJQCD+W1JHn0SX8iCqUgnCVC6mBcrf6IuPUx/k=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=KhJHKf2cOED3UaXSpMf63uWVFV1lLkej6jGRpQDvR0IzdwU/sXJJbRa4k7a8ci6mAPJdse89rtddsor21Z9PfECnGFubXtddpjFf68gfANaOwdZgrgdE9+6Ef6Ezx1qBBIH6/7f3fZlmJJfzjUhkHph1xuwozrK3h8lNKNrBcIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=a9CVkWZq; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-748da522e79so853656b3a.1
        for <io-uring@vger.kernel.org>; Thu, 26 Jun 2025 11:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750962196; x=1751566996; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yU6KCb6gH2iEobn3syosBLPH/46eGlSMbuBLZ+mOMlM=;
        b=a9CVkWZqEDLdV1uSusenEk8He+A2oN8MEihJmoeL4RW4hvvQ10sqIXPpPWsnIlI2tH
         izKP2sz5/kKIG74/67bLm0BEo2y7olsPg4f3qqAw9v0OXngEZlAqEFtxDBQZ9LEggOaP
         xw/IGGlZhERHSdsJx1LCcglaqf+8EpZFKiQM0PmDvS0H/MnpDcREA0pLfEtYxm0A5fZm
         9q/zUbaUE4G+JBZJelFB+b33laexT7cNhsIdn6Hf165d+Ab4RYU4ywV1v0OwgMuFPfjM
         7Ei22RWv4QwzahfV5arcMHvKwq/Ah5e+OiyGSMMOIgut16XAgEQ6X3TRm05BxZPLbJ5F
         amGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750962196; x=1751566996;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yU6KCb6gH2iEobn3syosBLPH/46eGlSMbuBLZ+mOMlM=;
        b=nkm6hOGZX7LnqPHfTSiOs06N4duYTyz9I2YtYrd47fXnY5rOnLVGbvXODQ/pxRICtj
         TiCavs1Z2OzhnvnEBNjgBODCzmxUBHN+PLQ9dKubQAb8Moe6Yy19O4NUBiF76j7FzPAF
         V7+3ASWSfGWBb+lpBu7caGQPG+wERjULp0Aq7yOWdbhDOWGuk9FU/D030eViKDAeJKw4
         LU7qesOy5rIcv2NyP1RSdbMu6Nzda/cV2mn/3HU+kXucXHeD+ZkiyPP9pkHKimQ75xF0
         iwpTqLyIS8nR9iMAs0cUw97yrLcRNhMlJPnyuIpg0uYBAr/2HuC5P6KRDhtB71h6qnlB
         ZaHg==
X-Gm-Message-State: AOJu0YxIAKVw/fRUOPmmUF3gu+i/sN5AgdqWw9zwAvOVdcwjw8Nwe4B7
	TSpW4SYXid2fCaG83UH5ED3o1kAV8VBLxndIG2tmYmhU/npivWVzEfvO2XWuwV7Y6OUkJQMgvtK
	locgD
X-Gm-Gg: ASbGncuUaRApFZj/K+FiDLbgistmPfd7Mh5vVqWbVAAzD1U93rsWO6hJHjrEVzTDTrQ
	YH5/udW5g7wBn1H7vsnrXnH8vr/YNieiM7gpMizH/ORMXCpv49dj/UZ84mOFqm6eNljF+cckQe8
	yxK33oedsPkVHXaDDYSBWK8bmDslv+jhJBZOB6zX5jkYQXfw7TjPp7EXep1/SWm6zBtXRg9podP
	MeEqnWM7mjwRGNq2tybQaf8gttbZLO8COj4Wsdt1ZmpAuJIQDApxFfRZmpqw7vlQaw6KzgykKee
	PFa3CQy5gcyglIqZ8zi9nkNkHjS4YwLmoM611qwi3Esnmkf2ozj1MEW8Rw==
X-Google-Smtp-Source: AGHT+IFDPHYJxILveBGpvUqeYKqk/IUaTmHnHLj1uuIf57NqZzUdXszh83FOllrNhatFMF42Bhy8EQ==
X-Received: by 2002:a05:6a00:17a8:b0:742:a91d:b2f6 with SMTP id d2e1a72fcca58-74af6f73a9bmr239203b3a.13.1750962196427;
        Thu, 26 Jun 2025 11:23:16 -0700 (PDT)
Received: from [172.20.0.228] ([12.48.65.201])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b34c429b51bsm2254012a12.9.2025.06.26.11.23.15
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Jun 2025 11:23:15 -0700 (PDT)
Message-ID: <5b8c6ace-8403-41d7-8350-d9367b54b1cf@kernel.dk>
Date: Thu, 26 Jun 2025 12:23:14 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/kbuf: flag partial buffer mappings
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

A previous commit aborted mapping more for a non-incremental ring for
bundle peeking, but depending on where in the process this peeking
happened, it would not necessarily prevent a retry by the user. That can
create gaps in the received/read data.

Add struct buf_sel_arg->partial_map, which can pass this information
back. The networking side can then map that to internal state and use it
to gate retry as well.

Since this necessitates a new flag, change io_sr_msg->retry to a
retry_flags member, and store both the retry and partial map condition
in there.

Cc: stable@vger.kernel.org
Fixes: 26ec15e4b0c1 ("io_uring/kbuf: don't truncate end buffer for multiple buffer peeks")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index ce95e3af44a9..f2d2cc319faa 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -271,6 +271,7 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 		if (len > arg->max_len) {
 			len = arg->max_len;
 			if (!(bl->flags & IOBL_INC)) {
+				arg->partial_map = 1;
 				if (iov != arg->iovs)
 					break;
 				buf->len = len;
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 5d83c7adc739..723d0361898e 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -58,7 +58,8 @@ struct buf_sel_arg {
 	size_t max_len;
 	unsigned short nr_iovs;
 	unsigned short mode;
-	unsigned buf_group;
+	unsigned short buf_group;
+	unsigned short partial_map;
 };
 
 void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
diff --git a/io_uring/net.c b/io_uring/net.c
index 5c1e8c4ba468..43a43522f406 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -75,12 +75,17 @@ struct io_sr_msg {
 	u16				flags;
 	/* initialised and used only by !msg send variants */
 	u16				buf_group;
-	bool				retry;
+	unsigned short			retry_flags;
 	void __user			*msg_control;
 	/* used only for send zerocopy */
 	struct io_kiocb 		*notif;
 };
 
+enum sr_retry_flags {
+	IO_SR_MSG_RETRY		= 1,
+	IO_SR_MSG_PARTIAL_MAP	= 2,
+};
+
 /*
  * Number of times we'll try and do receives if there's more data. If we
  * exceed this limit, then add us to the back of the queue and retry from
@@ -187,7 +192,7 @@ static inline void io_mshot_prep_retry(struct io_kiocb *req,
 
 	req->flags &= ~REQ_F_BL_EMPTY;
 	sr->done_io = 0;
-	sr->retry = false;
+	sr->retry_flags = 0;
 	sr->len = 0; /* get from the provided buffer */
 }
 
@@ -397,7 +402,7 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
 	sr->done_io = 0;
-	sr->retry = false;
+	sr->retry_flags = 0;
 	sr->len = READ_ONCE(sqe->len);
 	sr->flags = READ_ONCE(sqe->ioprio);
 	if (sr->flags & ~SENDMSG_FLAGS)
@@ -751,7 +756,7 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
 	sr->done_io = 0;
-	sr->retry = false;
+	sr->retry_flags = 0;
 
 	if (unlikely(sqe->file_index || sqe->addr2))
 		return -EINVAL;
@@ -823,7 +828,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 
 		cflags |= io_put_kbufs(req, this_ret, io_bundle_nbufs(kmsg, this_ret),
 				      issue_flags);
-		if (sr->retry)
+		if (sr->retry_flags & IO_SR_MSG_RETRY)
 			cflags = req->cqe.flags | (cflags & CQE_F_MASK);
 		/* bundle with no more immediate buffers, we're done */
 		if (req->flags & REQ_F_BL_EMPTY)
@@ -832,12 +837,12 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 		 * If more is available AND it was a full transfer, retry and
 		 * append to this one
 		 */
-		if (!sr->retry && kmsg->msg.msg_inq > 1 && this_ret > 0 &&
+		if (!sr->retry_flags && kmsg->msg.msg_inq > 1 && this_ret > 0 &&
 		    !iov_iter_count(&kmsg->msg.msg_iter)) {
 			req->cqe.flags = cflags & ~CQE_F_MASK;
 			sr->len = kmsg->msg.msg_inq;
 			sr->done_io += this_ret;
-			sr->retry = true;
+			sr->retry_flags |= IO_SR_MSG_RETRY;
 			return false;
 		}
 	} else {
@@ -1082,6 +1087,8 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 			kmsg->vec.iovec = arg.iovs;
 			req->flags |= REQ_F_NEED_CLEANUP;
 		}
+		if (arg.partial_map)
+			sr->retry_flags |= IO_SR_MSG_PARTIAL_MAP;
 
 		/* special case 1 vec, can be a fast path */
 		if (ret == 1) {
@@ -1276,7 +1283,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	int ret;
 
 	zc->done_io = 0;
-	zc->retry = false;
+	zc->retry_flags = 0;
 
 	if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
 		return -EINVAL;

-- 
Jens Axboe


