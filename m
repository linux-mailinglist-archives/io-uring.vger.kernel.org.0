Return-Path: <io-uring+bounces-8175-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55104AC9CC5
	for <lists+io-uring@lfdr.de>; Sat, 31 May 2025 22:52:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13F4117AB95
	for <lists+io-uring@lfdr.de>; Sat, 31 May 2025 20:52:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC0A0149E13;
	Sat, 31 May 2025 20:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oOmSsfzs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6458072608
	for <io-uring@vger.kernel.org>; Sat, 31 May 2025 20:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748724751; cv=none; b=X9CNLOCnM9MqPURQJvLivYNPGgTGO+3VWvGEOqmZkzyOj5gYuL422EXIwQ0/WyvH05iiKB4OpN57e/IucI6lXeso1e/KqRedEXC/J5UEYgyYX/n8UCjau2EKUNXE9gJsbpPYsQvKbQjgxLpV4DzxhC0LM/V/j9Vs5XyZclzOYac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748724751; c=relaxed/simple;
	bh=ZwNWW+Es36UkCacvPREwvLOLWyecsOnvSgUa7+jX2Cc=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=M5xAfnLHCtmRrvkA70kybaH8YlstCCcCatX9HPmhPJQ4bq18zBW8THZXT0iXnx1JEU/tftK3sZ1TitMWz/nAcbYkKIZUcIr4KqVPJIDO0zO3WfvHG078hiCJnGBzX6U1nGNfpGfpI8e1JVGPq/8PAUegg97E62LneXTmfw8qTdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oOmSsfzs; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-85d9a87660fso304707139f.1
        for <io-uring@vger.kernel.org>; Sat, 31 May 2025 13:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748724745; x=1749329545; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LZPrAVs7NGoNJCdSVVVWiZySq4LQkSUunv2ptiZNXhI=;
        b=oOmSsfzsbTdrABIawExcjGjdMFQYralfOkbsMucFe6lfaAePUqO6o0s5q1XlTYQTxK
         QlFqWXSPIutGPkCSS4US7ZTLbc+A8YaBctfKxml2PBsvWvUw4t2YJjlSHBXA7DTqrahA
         V6nIt2mvFPvt33JlJjMFphfTb9563gQb0O7uFcy5mCJhKnA+QeV/tLBi9vGgTBQs0WlZ
         YCX55tQblF7MotpUf3Lgxj/X1zroeaK0e8VwgQCYtVsm7kg9YFLls5d/dxLsWlKl7/Sr
         lNzJNrQ8nfHBXrzkEqywpqJzHS8WbvbatVv1CesQqoBFLQeB8oBnjbkN7J+yfUldnTNo
         GqVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748724745; x=1749329545;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LZPrAVs7NGoNJCdSVVVWiZySq4LQkSUunv2ptiZNXhI=;
        b=Ci6tZ1NYcg2ZRrmN3cbzod49vmUu70T0E0JQrSIqFVYUYmKG64QfAmDVZ0mkBWpLul
         Zniaspw/5W38c0v1n1K1zE6vuh6I5lDsUZeMOOG0X7ZcR/yTKQtMkET4cSATQRxbnwVH
         7GjdaxsJtx6vPDl3O6YVJu9cqxvTXN2L4stvIgjODm/Tg2wXPFDfjVFiu0NrymKz1LSa
         Eyp6otSxtvdsW36cAkhqgTXt2UlSu8u8b0pzTOVnusxPbk03QFbH7IsYf5k5g6MCfqp5
         g4f3y4LJDHXf2N2FaEHfJW3N1ya4CfJj4yAFmN4nlqhNXvnJuXvJI46Dzfxz9CE/6McQ
         NkMA==
X-Gm-Message-State: AOJu0Yzn21TyA/G7w8Cgai/YphxDYtsqC4ZTCM6WdlnjpbLExzMiMe1R
	P/s2WHwuQHJRA9SvKKwOjakbdp7n0OewU5ejofaqGQMHbWAEkI2Y+dB42e/pn03Swp/LQl9D+mf
	yRM5W
X-Gm-Gg: ASbGncvlgWrT/uZrUXzODLWr1Zhq7P0zp0d+ndERQK/EGblSg3VirKaCaFBkyprfsOj
	/CMZ0SOQI/Fj7syDSz6qz/Tod5sBqOpEpaYPlZmQwqt+b/Sch3cATiOU8t5r2JfDEXB6xdTUn1G
	k0gPDnWUq/JUTlDezqq6kNYJDKpUCHOgwdxc68z6k1NxRNcxsIshqmJaxkXz5i8eiNCWPTMhG/V
	wOF4GbPFhhAtUd79Fdwo4vKBbDpv3s3WKKrh13iiZb8HH7PZqqZfvKnBg3Q7utHlGWmWFgYpM7v
	O3la1RzwVWQe4u4I9I+Mv7+EwgP8YoEK1FFLSRm1w75yxu9C
X-Google-Smtp-Source: AGHT+IHD8VZSNwoUrLTASnUNKiItZSjk3cgNhb+fmHj50fT1FFdot994SU9sTNp2LlVfwBDND8xCag==
X-Received: by 2002:a05:6e02:258e:b0:3dc:8b68:8b10 with SMTP id e9e14a558f8ab-3dd9c9887aamr79924345ab.2.1748724745237;
        Sat, 31 May 2025 13:52:25 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdd7efc8e0sm1016143173.122.2025.05.31.13.52.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 May 2025 13:52:24 -0700 (PDT)
Message-ID: <5d03de61-1419-443f-b3a4-e1f2ac2fe137@kernel.dk>
Date: Sat, 31 May 2025 14:52:23 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: Caleb Sander Mateos <csander@purestorage.com>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/uring_cmd: be smarter about SQE copying
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

uring_cmd currently copies the SQE unconditionally, which was introduced
as a work-around in commit:

d6211ebbdaa5 ("io_uring/uring_cmd: unconditionally copy SQEs at prep time")

because the checking for whether or not this command may have ->issue()
called from io-wq wasn't complete. Rectify that, ensuring that if the
request is marked explicitly async via REQ_F_FORCE_ASYNC or if it's
part of a link chain, then the SQE is copied upfront.

Always copying can be costly, particularly when dealing with SQE128
rings. But even a normal 64b SQE copy is noticeable at high enough
rates.

Reported-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 929cad6ee326..cb4b867a2656 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -181,29 +181,42 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, u64 res2,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 
+static void io_uring_sqe_copy(struct io_kiocb *req, struct io_uring_cmd *ioucmd)
+{
+	struct io_async_cmd *ac = req->async_data;
+
+	if (ioucmd->sqe != ac->sqes) {
+		memcpy(ac->sqes, ioucmd->sqe, uring_sqe_size(req->ctx));
+		ioucmd->sqe = ac->sqes;
+	}
+}
+
 static int io_uring_cmd_prep_setup(struct io_kiocb *req,
 				   const struct io_uring_sqe *sqe)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+	struct io_ring_ctx *ctx = req->ctx;
 	struct io_async_cmd *ac;
 
 	/* see io_uring_cmd_get_async_data() */
 	BUILD_BUG_ON(offsetof(struct io_async_cmd, data) != 0);
 
-	ac = io_uring_alloc_async_data(&req->ctx->cmd_cache, req);
+	ac = io_uring_alloc_async_data(&ctx->cmd_cache, req);
 	if (!ac)
 		return -ENOMEM;
 	ac->data.op_data = NULL;
 
 	/*
-	 * Unconditionally cache the SQE for now - this is only needed for
-	 * requests that go async, but prep handlers must ensure that any
-	 * sqe data is stable beyond prep. Since uring_cmd is special in
-	 * that it doesn't read in per-op data, play it safe and ensure that
-	 * any SQE data is stable beyond prep. This can later get relaxed.
+	 * Copy SQE now, if we know we're going async. Drain will set
+	 * FORCE_ASYNC, and assume links may cause it to go async. If not,
+	 * copy is deferred until issue time, if the request doesn't issue
+	 * or queue inline.
 	 */
-	memcpy(ac->sqes, sqe, uring_sqe_size(req->ctx));
-	ioucmd->sqe = ac->sqes;
+	ioucmd->sqe = sqe;
+	if (req->flags & (REQ_F_FORCE_ASYNC| REQ_F_LINK | REQ_F_HARDLINK) ||
+	    ctx->submit_state.link.head)
+		io_uring_sqe_copy(req, ioucmd);
+
 	return 0;
 }
 
@@ -259,6 +272,12 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
+	if (ret == -EAGAIN) {
+		io_uring_sqe_copy(req, ioucmd);
+		return ret;
+	} else if (ret == -EIOCBQUEUED) {
+		return ret;
+	}
 	if (ret == -EAGAIN || ret == -EIOCBQUEUED)
 		return ret;
 	if (ret < 0)

-- 
Jens Axboe


