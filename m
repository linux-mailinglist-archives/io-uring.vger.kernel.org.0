Return-Path: <io-uring+bounces-921-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1AC987AAE5
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 17:06:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C1CBB1C22C76
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 16:06:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9A99482D0;
	Wed, 13 Mar 2024 16:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nVlBgDWE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149A9482C6
	for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 16:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710345981; cv=none; b=EBmAD1kQV3Ppx/dwAsUIQPxge8fuRZZ1v2CCQAsyGVfN22KXGwXVROe+3FFg1xH//1O4qxvPeIACEHRkBcTrjvnHraO8vObLFWleRJM6MBNHdM15PBtOBeQVcwssM+8d46pMtI5Ib+2Q34egF9AQeuu8zp6ExGCrGxb/gaAUuEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710345981; c=relaxed/simple;
	bh=qEJvBqXlKk6/4ag2igLXi/tEQnH/mI1uVdOIK1lcjA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDRCKBOv33vg22Nar8qU6O/bt4Ca5lxMV9WvNIAv4jJeejPXjmJ7fH8uWbkF2H0BqICfX+M8l61hqtKjL2M4d6j3UihO45duygEGqoDO3EklxWJFtMamcIOPj9PSNR+FjCkuX4Kn+YXekxFIp1ClfuiyUDswN83UVCLcHyr/Rh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nVlBgDWE; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a3ddc13bbb3so195544066b.0
        for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 09:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710345978; x=1710950778; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M6P9sTo17wusRH/vBHYP9uaX08In1VpmHa0U9XqM2zQ=;
        b=nVlBgDWEGhtc0aJmce8aoQk1BrFmiAy4qEF51seqQWwWDGTWSrHqU6SCWpeIWgbZCm
         /M+7ZxNJ39g5b4wB9781MLdHp0v9DxinhW7ghni3W2tvTyj570LFGIWJtddK/LDdoATK
         E7bh6z5Wkvn/fYqqC0ahRPFtO8EHiLTLY9L31NS71+qbSTAv1XZaLeUga3J7KkpHCabP
         rhpk7/BLsc6oJBhSYvElr04vT6olQX6vTXIUXwaIPZkM4lUCSxc0F0HJie0ult3ovQyI
         hYi/BC/mkkR79w4v45xMvKEGYn0qvUBq2z1ygOJF5sKZc/tILq2ayRhHFHo9vcntelOY
         VMdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710345978; x=1710950778;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M6P9sTo17wusRH/vBHYP9uaX08In1VpmHa0U9XqM2zQ=;
        b=fWfg2QF9t9h1rqSxBMYANWvQNPy6bt0uDgkAtWFOQkNMzv66NdL7QpoS1Uffgsl5Bf
         ZZiggZM2aRvn9A3K0EYpHQoaAjZdVRTZIPNMMETULCyq1vupnZq9/Tf29fr/tLWqGnPk
         TNEGVE0x6L7e6wVxMWm88uYwv8Dk6ElaPfj5TlrZxYtzEi7UJLwMGjU4Eek6ZRiG2vN+
         EHCwOJou4wwI6buCDwd5V4mM5HQSFYIivKBEd0QY/k91R3TvQT3ButueSraFNdAClGUO
         P/8Jlke0FRU+zFPMe+OFEEJW6t6HrpxJbOMrJhZZBEujhcgsCfHhimIhKwEJsZ8kyPHn
         0F+g==
X-Gm-Message-State: AOJu0YytWOH9q/9+sOrmtaGNyBkIZO6k7x1hW/INocuNIukfbZMQM0nP
	f2Yux8qMREUz6sj/PJbCRxAciN6JERSw1b0nzrc8n/68eN5pYfEOYpLtMVe+
X-Google-Smtp-Source: AGHT+IGSV1+X/XJj5e89nz5MArzBYD8CkSzClfdt+bfTZvwhpevlQUwQXpOGFzT+VP0s05lS16wpLA==
X-Received: by 2002:a17:906:ba84:b0:a46:13a0:2e5c with SMTP id cu4-20020a170906ba8400b00a4613a02e5cmr2920796ejd.25.1710345977767;
        Wed, 13 Mar 2024 09:06:17 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:7461])
        by smtp.gmail.com with ESMTPSA id k16-20020a1709067ad000b00a4655976025sm798328ejo.82.2024.03.13.09.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Mar 2024 09:06:16 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 3/3] io_uring/kbuf: rename is_mapped
Date: Wed, 13 Mar 2024 15:52:41 +0000
Message-ID: <c4838f4d8ad506ad6373f1c305aee2d2c1a89786.1710343154.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1710343154.git.asml.silence@gmail.com>
References: <cover.1710343154.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In buffer lists we have ->is_mapped as well as ->is_mmap, it's
pretty hard to stay sane double checking which one means what,
and in the long run there is a high chance of an eventual bug.
Rename ->is_mapped into ->is_buf_ring.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/kbuf.c | 20 ++++++++++----------
 io_uring/kbuf.h |  2 +-
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 0677eae92e79..4cf742749870 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -199,7 +199,7 @@ void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 
 	bl = io_buffer_get_list(ctx, req->buf_index);
 	if (likely(bl)) {
-		if (bl->is_mapped)
+		if (bl->is_buf_ring)
 			ret = io_ring_buffer_select(req, len, bl, issue_flags);
 		else
 			ret = io_provided_buffer_select(req, len, bl);
@@ -253,7 +253,7 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 	if (!nbufs)
 		return 0;
 
-	if (bl->is_mapped) {
+	if (bl->is_buf_ring) {
 		i = bl->buf_ring->tail - bl->head;
 		if (bl->is_mmap) {
 			/*
@@ -274,7 +274,7 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 		}
 		/* make sure it's seen as empty */
 		INIT_LIST_HEAD(&bl->buf_list);
-		bl->is_mapped = 0;
+		bl->is_buf_ring = 0;
 		return i;
 	}
 
@@ -361,7 +361,7 @@ int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
 	if (bl) {
 		ret = -EINVAL;
 		/* can't use provide/remove buffers command on mapped buffers */
-		if (!bl->is_mapped)
+		if (!bl->is_buf_ring)
 			ret = __io_remove_buffers(ctx, bl, p->nbufs);
 	}
 	io_ring_submit_unlock(ctx, issue_flags);
@@ -519,7 +519,7 @@ int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 		}
 	}
 	/* can't add buffers via this command for a mapped buffer ring */
-	if (bl->is_mapped) {
+	if (bl->is_buf_ring) {
 		ret = -EINVAL;
 		goto err;
 	}
@@ -575,7 +575,7 @@ static int io_pin_pbuf_ring(struct io_uring_buf_reg *reg,
 	bl->buf_pages = pages;
 	bl->buf_nr_pages = nr_pages;
 	bl->buf_ring = br;
-	bl->is_mapped = 1;
+	bl->is_buf_ring = 1;
 	bl->is_mmap = 0;
 	return 0;
 error_unpin:
@@ -642,7 +642,7 @@ static int io_alloc_pbuf_ring(struct io_ring_ctx *ctx,
 	}
 	ibf->inuse = 1;
 	bl->buf_ring = ibf->mem;
-	bl->is_mapped = 1;
+	bl->is_buf_ring = 1;
 	bl->is_mmap = 1;
 	return 0;
 }
@@ -688,7 +688,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	bl = io_buffer_get_list(ctx, reg.bgid);
 	if (bl) {
 		/* if mapped buffer ring OR classic exists, don't allow */
-		if (bl->is_mapped || !list_empty(&bl->buf_list))
+		if (bl->is_buf_ring || !list_empty(&bl->buf_list))
 			return -EEXIST;
 	} else {
 		free_bl = bl = kzalloc(sizeof(*bl), GFP_KERNEL);
@@ -730,7 +730,7 @@ int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	bl = io_buffer_get_list(ctx, reg.bgid);
 	if (!bl)
 		return -ENOENT;
-	if (!bl->is_mapped)
+	if (!bl->is_buf_ring)
 		return -EINVAL;
 
 	__io_remove_buffers(ctx, bl, -1U);
@@ -757,7 +757,7 @@ int io_register_pbuf_status(struct io_ring_ctx *ctx, void __user *arg)
 	bl = io_buffer_get_list(ctx, buf_status.buf_group);
 	if (!bl)
 		return -ENOENT;
-	if (!bl->is_mapped)
+	if (!bl->is_buf_ring)
 		return -EINVAL;
 
 	buf_status.head = bl->head;
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 5218bfd79e87..1c7b654ee726 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -26,7 +26,7 @@ struct io_buffer_list {
 	__u16 mask;
 
 	/* ring mapped provided buffers */
-	__u8 is_mapped;
+	__u8 is_buf_ring;
 	/* ring mapped provided buffers, but mmap'ed by application */
 	__u8 is_mmap;
 	/* bl is visible from an RCU point of view for lookup */
-- 
2.43.0


