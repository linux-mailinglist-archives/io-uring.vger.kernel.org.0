Return-Path: <io-uring+bounces-7984-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DE5ABAB8676
	for <lists+io-uring@lfdr.de>; Thu, 15 May 2025 14:35:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8622E1B632F1
	for <lists+io-uring@lfdr.de>; Thu, 15 May 2025 12:35:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2E7E2989BD;
	Thu, 15 May 2025 12:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FkRKlyU0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFEE205AA8
	for <io-uring@vger.kernel.org>; Thu, 15 May 2025 12:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747312532; cv=none; b=ZlHONRJ64Sfbr7ocBmPUlybi8Y1mpNSwwuQM+IF/s81N5DROYXp6jRqzDhg+Ku2/14iPiDIg0dWqlfJ7Md5T46BvzfCW/Bv6FXTVityfBX5//iMLaEXVFKY+vKGYtqnB4qN7ASmXbqFt8Rl3jmIGr3KDzLRC1LdAgez5t7W8zHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747312532; c=relaxed/simple;
	bh=+OkSMuSmzLmA7Sqpz6YUT6rCWBXnHQLtzFGq+Mn5OGY=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=lqKiAwtQt4AP1CfsXl8mJcAQSAFFy7W+2PN7Zihpmi+9i4heLHCBg2tnV/ncGMYTkPFjkdBdCWjlIcG1oyCYsV9chP3xsAJTTk31cnCBIQuSSja79CAL6S0CX6UWBcgVBMK1fEccdH1hhElye8eJNc9J5n6ZMgNyf6kI09/MYCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FkRKlyU0; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-8613f456960so23382439f.1
        for <io-uring@vger.kernel.org>; Thu, 15 May 2025 05:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747312529; x=1747917329; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dw7zxqsvpwt4hREXcavRIJ76WP5cmZ9v5DKndNqykmo=;
        b=FkRKlyU0Ouk1L3FFFwspL5EqGDygUAIOeASx6CmuVGkh4ccvilnRiX+adTgdEw0PvJ
         Grsx3lUVHTy4fz/cAkHWzKe53fx5omaosT1s8EWKM3/M+a76bu9w/I60pMgtHfEDuzDi
         BeN4NCkI1qLPLMxg5OAB8/k1PGPoXU6CO6NYfyH77DfTUaX3CTaU8Zn6umB7MK0ycZb7
         my4OFxjAR+OCJ+rP+5WQPxoDZXzDb1Cx4hQ4yOsW7j04h0YsACa+tcT1ak30V+LyZBZm
         Dtp8tVny5Hnj+G+urE3XdEYwQYxohkmn0bBFNk1LIIeUqUd5kZfUruCLXtxq+5kPZTJN
         9Erg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747312529; x=1747917329;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dw7zxqsvpwt4hREXcavRIJ76WP5cmZ9v5DKndNqykmo=;
        b=dUbYCol/7k1rD/H3LQHpp9Ltu5xwBT0TDMKTj9UkciARMmvRlC+ucZzvidWPbZdrTT
         wHPQG7CeztO5966Ar/OA7scVEHRI47j4Yh88hO2W7fxKK9wvVg2htMKMvP78T2nmN0fZ
         tKbZCcjMbs28ddx8fojdzMjjcK55L6en8a5YVyqkUbj022FjySzu1/Bnhaz7NBDM9YQ3
         fhlGL9YSRHX2DcyHHYN52TuPm+00PtDKQvTFpVquUxMkk1EPPzpEDz1UoSkmPfbToT1x
         FQcGLIVyVV9XiGPat04rOZb2x3bJIlAQ3IrmdIF9iHUerva2UwoVdkvu/yGk28SKnRLX
         jP1A==
X-Gm-Message-State: AOJu0YwiVD5p7kNyqaQtSS80V3DZWt8Q7MOFeKiDOQ8qCY5cudE/ytw5
	kButAQH1+pi8LfyG9O2r3djv4qS3AILnpaMFbMxpYuZlbeW5eP/Ebi4SZ5brVq6Yec7w0LLuAow
	U
X-Gm-Gg: ASbGnctghyQesqb8iDRwuH60XPFS4gHVy7Vt1hbk3THJi541EzUHPa4E/jZsV/rgM5j
	CflCZyX5VKYWBQvEzKapbineYrQfwWVpkW2Y6e9Xe51M4olVk7saC+Any6HojNkFHKDpLDcuXxL
	8vOUFctLpqklUSKDVGsG9pvePgFEnCmWWvWrcMSJaOFMDUxEITRB23TA7AMhRKNRdDiwfT79jeM
	pzGpkBagyB/6vkhe/51xks3vfeQOiiY75QL5ROmEirp/14wu25svihDQOu2YngavXTOQ2saqg15
	RrSJ7t//hAQtQUSNjLAqwwe4+hdOwvhItYbtsQSiDIDGaXUT
X-Google-Smtp-Source: AGHT+IGOAjqT+NNludePwbIAG7xInbE89neWGGRMO1V9f/5qEcqFjb0wFub20zTt2z4a3v7Vmwl7nA==
X-Received: by 2002:a05:6602:751a:b0:864:3335:d580 with SMTP id ca18e2360f4ac-86a08ce4870mr870837239f.0.1747312529010;
        Thu, 15 May 2025 05:35:29 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fa22659f9asm2987617173.128.2025.05.15.05.35.28
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 May 2025 05:35:28 -0700 (PDT)
Message-ID: <7eea65f2-f5c1-4a18-95eb-89982c42fa68@kernel.dk>
Date: Thu, 15 May 2025 06:35:27 -0600
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
Subject: [PATCH] io_uring/fdinfo: grab ctx->uring_lock around
 io_uring_show_fdinfo()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Not everything requires locking in there, which is why the 'has_lock'
variable exists. But enough does that it's a bit unwieldy to manage.
Wrap the whole thing in a ->uring_lock trylock, and just return
with no output if we fail to grab it. The existing trylock() will
already have greatly diminished utility/output for the failure case.

This fixes an issue with reading the SQE fields, if the ring is being
actively resized at the same time.

Reported-by: Jann Horn <jannh@google.com>
Fixes: 79cfe9e59c2a ("io_uring/register: add IORING_REGISTER_RESIZE_RINGS")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 9414ca6d101c..e0d6a59a89fa 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -86,13 +86,8 @@ static inline void napi_show_fdinfo(struct io_ring_ctx *ctx,
 }
 #endif
 
-/*
- * Caller holds a reference to the file already, we don't need to do
- * anything else to get an extra reference.
- */
-__cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
+static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 {
-	struct io_ring_ctx *ctx = file->private_data;
 	struct io_overflow_cqe *ocqe;
 	struct io_rings *r = ctx->rings;
 	struct rusage sq_usage;
@@ -106,7 +101,6 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 	unsigned int sq_entries, cq_entries;
 	int sq_pid = -1, sq_cpu = -1;
 	u64 sq_total_time = 0, sq_work_time = 0;
-	bool has_lock;
 	unsigned int i;
 
 	if (ctx->flags & IORING_SETUP_CQE32)
@@ -176,15 +170,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 		seq_printf(m, "\n");
 	}
 
-	/*
-	 * Avoid ABBA deadlock between the seq lock and the io_uring mutex,
-	 * since fdinfo case grabs it in the opposite direction of normal use
-	 * cases. If we fail to get the lock, we just don't iterate any
-	 * structures that could be going away outside the io_uring mutex.
-	 */
-	has_lock = mutex_trylock(&ctx->uring_lock);
-
-	if (has_lock && (ctx->flags & IORING_SETUP_SQPOLL)) {
+	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		struct io_sq_data *sq = ctx->sq_data;
 
 		/*
@@ -206,7 +192,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 	seq_printf(m, "SqTotalTime:\t%llu\n", sq_total_time);
 	seq_printf(m, "SqWorkTime:\t%llu\n", sq_work_time);
 	seq_printf(m, "UserFiles:\t%u\n", ctx->file_table.data.nr);
-	for (i = 0; has_lock && i < ctx->file_table.data.nr; i++) {
+	for (i = 0; i < ctx->file_table.data.nr; i++) {
 		struct file *f = NULL;
 
 		if (ctx->file_table.data.nodes[i])
@@ -218,7 +204,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 		}
 	}
 	seq_printf(m, "UserBufs:\t%u\n", ctx->buf_table.nr);
-	for (i = 0; has_lock && i < ctx->buf_table.nr; i++) {
+	for (i = 0; i < ctx->buf_table.nr; i++) {
 		struct io_mapped_ubuf *buf = NULL;
 
 		if (ctx->buf_table.nodes[i])
@@ -228,7 +214,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 		else
 			seq_printf(m, "%5u: <none>\n", i);
 	}
-	if (has_lock && !xa_empty(&ctx->personalities)) {
+	if (!xa_empty(&ctx->personalities)) {
 		unsigned long index;
 		const struct cred *cred;
 
@@ -238,7 +224,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 	}
 
 	seq_puts(m, "PollList:\n");
-	for (i = 0; has_lock && i < (1U << ctx->cancel_table.hash_bits); i++) {
+	for (i = 0; i < (1U << ctx->cancel_table.hash_bits); i++) {
 		struct io_hash_bucket *hb = &ctx->cancel_table.hbs[i];
 		struct io_kiocb *req;
 
@@ -247,9 +233,6 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 					task_work_pending(req->tctx->task));
 	}
 
-	if (has_lock)
-		mutex_unlock(&ctx->uring_lock);
-
 	seq_puts(m, "CqOverflowList:\n");
 	spin_lock(&ctx->completion_lock);
 	list_for_each_entry(ocqe, &ctx->cq_overflow_list, list) {
@@ -262,4 +245,23 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 	spin_unlock(&ctx->completion_lock);
 	napi_show_fdinfo(ctx, m);
 }
+
+/*
+ * Caller holds a reference to the file already, we don't need to do
+ * anything else to get an extra reference.
+ */
+__cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
+{
+	struct io_ring_ctx *ctx = file->private_data;
+
+	/*
+	 * Avoid ABBA deadlock between the seq lock and the io_uring mutex,
+	 * since fdinfo case grabs it in the opposite direction of normal use
+	 * cases.
+	 */
+	if (mutex_trylock(&ctx->uring_lock)) {
+		__io_uring_show_fdinfo(ctx, m);
+		mutex_unlock(&ctx->uring_lock);
+	}
+}
 #endif

-- 
Jens Axboe


