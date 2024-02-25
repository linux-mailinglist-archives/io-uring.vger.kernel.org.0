Return-Path: <io-uring+bounces-706-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CB81A86289A
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 01:40:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5BF49B21502
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 00:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79064EC2;
	Sun, 25 Feb 2024 00:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tF/Iawto"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA10910E4
	for <io-uring@vger.kernel.org>; Sun, 25 Feb 2024 00:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708821596; cv=none; b=g+KZphFXNiwzopHydm8+AuzLcTiIeU70EmM41axWR0qA5CotqwzCRj5Fibh97sPMOznofnkAditwHeoyntI8Ki4FgBaaIQ+FIoSbwdUqhbz8EoGnUovfpIQxZ92PJg6NIgp5Eic/qZcCwJWW/FG/Cr2+cfEZUPAsvGlH2ZzAVk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708821596; c=relaxed/simple;
	bh=Bwz1XCGG8sAa4hB/q27XYGr3ZK5UY47pzg7bfBwJ80o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r03SefJYqNaGlT+6bjYjf4S8RbdGiD9d+En5JfCnSdDXbE8/j9VMxuEU+CLSQgUizT7aDYtQTxfSiixh+gVVBFGffVdjgckj+jDtEGy+R1k2vKI0eQChQjV+hnEavKYCmM7Iv1XlCNO3PlUEUoBilCB8hNsO2UZ0AbLEnhdLuZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tF/Iawto; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1dbff00beceso5517375ad.1
        for <io-uring@vger.kernel.org>; Sat, 24 Feb 2024 16:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708821593; x=1709426393; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qke7VBOcxahFVWc17Wbuzh6Bf+gTJGXU/ImftE7zCJs=;
        b=tF/IawtouPaBKcuuVO0B/tIMyjCFArNiC3ReYv0UT6YUGYBSq3eUU0pcMDa84SBhUu
         YIxgHTsubHmJskGPR4cvjRDKZFhsY0ThJ4NAC/bDADIU6A0QMtUqPfz6pjLT3DsbJm3J
         9NUedxQ66DIki0w6mb7BEsRM21P9x6U/Grasnx3GPsABaBdVNz/puJKliPT+EiYtN3lI
         ekSKh089GdCXyOsJnmshznVZiCOSAJ89ULSWhgraPdP8snUee8sjHX385dbjQNl4mP4Z
         J2U5mg9OA17kUlWkCTRDvF4/b1JKXJHcMp+v/mCFcw4iLf7HmmsQzsVH+gQZrGUlgg/y
         paZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708821593; x=1709426393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qke7VBOcxahFVWc17Wbuzh6Bf+gTJGXU/ImftE7zCJs=;
        b=Zcvqx4FUgieRebZ0tkREuIVSKiUGE734DhaNPlfG1+tUlwdEmsr1V/h4JpRHYsAzic
         cJJZDk9QcQS16ugDiWRZsDi+PQptLLFj7aJjs56Mb/JHESWpxg2l6y9h5ri1mLtu7iKN
         wN78kFNsszp4Q0ALmJdh2Vfe6ee+lQkdRE2BDK2/c5XfTnwbgxeeck5mDne2l455BtJo
         eF1J79J8nNv2+pHzqs/AhK6QBJfQBQyU0lDkwKVZJXWbY18I0bIN43JN7kbJ4PP/p/D+
         7rRl5HCgVoZEZkHVAYGjiMLdRImjTvb+pmK7QqIWAdKhVW2/9sC9RP1hiBWDc/yurxpq
         FHtg==
X-Gm-Message-State: AOJu0YzUohlA1VaBphMUFNg2Xv8NyUSSCYYtRtWnYaKkFLpFlhy2XOrX
	hrUWJv6Cy7nl5shN548qPN2Vohcv0EzAFfe977pJwerkn+YzbgUJKktAHy3f/nX8GYUJAM3mnio
	I
X-Google-Smtp-Source: AGHT+IH893jI7KqrZ/KeccH7Ixf2UWgtIzOlw5ZL4Z/Vm3TEKNcRKgI/mq1dMnpldFsmWIbaTBQ/oQ==
X-Received: by 2002:a05:6a20:158b:b0:1a0:7fa7:52b with SMTP id h11-20020a056a20158b00b001a07fa7052bmr4862131pzj.5.1708821593558;
        Sat, 24 Feb 2024 16:39:53 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id u3-20020a62d443000000b006e24991dd5bsm1716170pfl.98.2024.02.24.16.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Feb 2024 16:39:52 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/8] io_uring/kbuf: flag request if buffer pool is empty after buffer pick
Date: Sat, 24 Feb 2024 17:35:51 -0700
Message-ID: <20240225003941.129030-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240225003941.129030-1-axboe@kernel.dk>
References: <20240225003941.129030-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Normally we do an extra roundtrip for retries even if the buffer pool has
depleted, as we don't check that upfront. Rather than add this check, have
the buffer selection methods mark the request with REQ_F_BL_EMPTY if the
used buffer group is out of buffers after this selection. This is very
cheap to do once we're all the way inside there anyway, and it gives the
caller a chance to make better decisions on how to proceed.

For example, recv/recvmsg multishot could check this flag when it
decides whether to keep receiving or not.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  3 +++
 io_uring/kbuf.c                | 10 ++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index bd7071aeec5d..d8111d64812b 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -480,6 +480,7 @@ enum {
 	REQ_F_POLL_NO_LAZY_BIT,
 	REQ_F_CANCEL_SEQ_BIT,
 	REQ_F_CAN_POLL_BIT,
+	REQ_F_BL_EMPTY_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -556,6 +557,8 @@ enum {
 	REQ_F_CANCEL_SEQ	= IO_REQ_FLAG(REQ_F_CANCEL_SEQ_BIT),
 	/* file is pollable */
 	REQ_F_CAN_POLL		= IO_REQ_FLAG(REQ_F_CAN_POLL_BIT),
+	/* buffer list was empty after selection of buffer */
+	REQ_F_BL_EMPTY		= IO_REQ_FLAG(REQ_F_BL_EMPTY_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index ee866d646997..3d257ed9031b 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -139,6 +139,8 @@ static void __user *io_provided_buffer_select(struct io_kiocb *req, size_t *len,
 		list_del(&kbuf->list);
 		if (*len == 0 || *len > kbuf->len)
 			*len = kbuf->len;
+		if (list_empty(&bl->buf_list))
+			req->flags |= REQ_F_BL_EMPTY;
 		req->flags |= REQ_F_BUFFER_SELECTED;
 		req->kbuf = kbuf;
 		req->buf_index = kbuf->bid;
@@ -152,12 +154,16 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 					  unsigned int issue_flags)
 {
 	struct io_uring_buf_ring *br = bl->buf_ring;
+	__u16 tail, head = bl->head;
 	struct io_uring_buf *buf;
-	__u16 head = bl->head;
 
-	if (unlikely(smp_load_acquire(&br->tail) == head))
+	tail = smp_load_acquire(&br->tail);
+	if (unlikely(tail == head))
 		return NULL;
 
+	if (head + 1 == tail)
+		req->flags |= REQ_F_BL_EMPTY;
+
 	head &= bl->mask;
 	/* mmaped buffers are always contig */
 	if (bl->is_mmap || head < IO_BUFFER_LIST_BUF_PER_PAGE) {
-- 
2.43.0


