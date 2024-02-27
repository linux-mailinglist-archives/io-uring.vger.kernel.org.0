Return-Path: <io-uring+bounces-787-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AEEF869F8A
	for <lists+io-uring@lfdr.de>; Tue, 27 Feb 2024 19:52:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F5801C22EE3
	for <lists+io-uring@lfdr.de>; Tue, 27 Feb 2024 18:52:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 048515027B;
	Tue, 27 Feb 2024 18:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LRXhzDQo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1716F4D59F
	for <io-uring@vger.kernel.org>; Tue, 27 Feb 2024 18:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709059935; cv=none; b=Qr0FkYeJu+xBYyACaJm8EUFf3cUNEMMu0fxYDe12PW27QgfzQ2bxqf+3QNdbbBhHxzM/EQXIKKf786pD/pljhF2AH+jeM0drcpS3CTLBkKnrFbyOnMCihypq/hLd7XIZ1F7/LyCFH2/nwLLsLCl78Imvi0Ycr7dnLOaI38170Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709059935; c=relaxed/simple;
	bh=Bwz1XCGG8sAa4hB/q27XYGr3ZK5UY47pzg7bfBwJ80o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8i9N0ERL/JX6gG6v0elU1bYmE9x/X7XHs8pV9QXOyM0U7KXsTebPnvK0iuZuirv5kByvTm4Pg6EgrKtc5dCT9kY+bwRImawXjW3IhHZ04/TiRAhgCf/DdF2i8SjnwskLO1rz+iXWYGWpuuj1tLb87KuFOFgzRycyG6O6SLOG+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LRXhzDQo; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6e555d6adafso40349b3a.0
        for <io-uring@vger.kernel.org>; Tue, 27 Feb 2024 10:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709059933; x=1709664733; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qke7VBOcxahFVWc17Wbuzh6Bf+gTJGXU/ImftE7zCJs=;
        b=LRXhzDQodJ6uGAGTuwDk3aCyZwnr+x0MkE0s632oc9O+huRJhWnf/qKbOpD7PNqIKD
         gqr1Tnrv7FMlhYNzZe5NbeAB5Q8PU8AF223jHKgFxWcOGNzZ6e91KMFwXAsG5tvHgw+S
         Fb1xWLgrsSDhFmX4T0bCICo6Pap5/mXQYFNjsejIv4gVuoidfo18JQzlEt/wptFc2KVw
         vCuJrnh6GWV7wn+3AofEBZ1vM6ssieZzWxMCpW3MUXZJsDx2o4QRPIYGr+roddT1ArOo
         BjdnKJkn0kh363lGALGHTb9AZb8RGC1yy/nJV38gpQ7NanTev0AYiLLnsOLFTsYe2/J3
         QCfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709059933; x=1709664733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qke7VBOcxahFVWc17Wbuzh6Bf+gTJGXU/ImftE7zCJs=;
        b=vL/4kvByKYxJvBcRi3k12ALVb8NwM5O0KFa08U4fmDJf4g5ZVb2QCcYpH8k6i0vU/E
         svP/p66KF6o2qu6gQs+Y0fRZPPX5831RKOQO/e6gD94CIpyPodf9kF7aeogipMUBkbQs
         tLs2qixiq5LtS3i0k/OyOYPnbvmBQfEpxGWuif8GP4sxE+7xniCDcw8O0xWf/YzJBDgW
         oRJIF/KjNtD6aeNO38STTQIU1M1Qoc2IWX3HHlCyX+sApcSsUnEKrYAl9tHY4koUo39V
         9EOLjE7ha8aLe171gMxiwtOg+T7cK66f2Y4xAy1+PoIPF7UjuYwdA25Dugh5GW1vmp3k
         qgmw==
X-Gm-Message-State: AOJu0YwkK1QKfzcVQu9xsihSLb8iGPCr+fD+8oZwq7FcfJOH24EaGeng
	zBls1HoLLMS++93R0SV19VcuDLMoqWtZJB11GgjLL7yLeLRtrI/uDJluSaMZXr9qAZpk0t6S60+
	W
X-Google-Smtp-Source: AGHT+IGfLs7gmo4dg1oRtZgKnsm3S57tNQsCx6JleJ8kywUWPxvkG1bUtplCOUyd/WBnoKZhFxu6HA==
X-Received: by 2002:a05:6a20:1595:b0:1a1:3e2:dcc5 with SMTP id h21-20020a056a20159500b001a103e2dcc5mr5234751pzj.6.1709059932934;
        Tue, 27 Feb 2024 10:52:12 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id l5-20020a170902eb0500b001dc1e53ca32sm1860721plb.38.2024.02.27.10.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 10:52:11 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring/kbuf: flag request if buffer pool is empty after buffer pick
Date: Tue, 27 Feb 2024 11:51:09 -0700
Message-ID: <20240227185208.986844-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240227185208.986844-1-axboe@kernel.dk>
References: <20240227185208.986844-1-axboe@kernel.dk>
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


