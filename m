Return-Path: <io-uring+bounces-43-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 099AC7E2E4B
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 21:39:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 876D0B209F6
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 20:39:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0015D29D19;
	Mon,  6 Nov 2023 20:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jDNanTss"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8374FFBEC
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 20:39:24 +0000 (UTC)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2815D77
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 12:39:20 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-408002b5b9fso36531115e9.3
        for <io-uring@vger.kernel.org>; Mon, 06 Nov 2023 12:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699303158; x=1699907958; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4r5RNx+iWl0YVuLpZ48Y3ajdphLrPBCmIog9HxXCQ98=;
        b=jDNanTssLC3iF8MptZXiiRDp3ua6O0RiwKytOscqGYVrUWY3EKskHCIjfQJxTNelwJ
         XDu/XP9svis9H9b/+RiM7yVSQpbNnyqjSjVDAeAnCmVocrRi3krirtg624EtB3m9G9b/
         iWBSE/7WGEbrOhV0qlrsNHHvI/JO4WiiwkE0J5fxuv4mXtU8wtDIthSbyPDFT6c26ra0
         OfNbBQjydJvTM070BvI9BybcSzu3FoYFD+jO1tvt6DEegMb6xbCAeYbwZ3ZeW8A0kXmG
         LzKQ7HTwGFj53entRuBqgSQn2RrZWb+/UHMmxDJvfjz/ZbQn4RPB5PQtNfLnAydiDi+P
         MrOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699303158; x=1699907958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4r5RNx+iWl0YVuLpZ48Y3ajdphLrPBCmIog9HxXCQ98=;
        b=jhT2XZ8Yu0gba2MA/ZEnMs/JQ37owXRNIw8moVVgAUmRBHVHD2yPy4yuXzTClKEt42
         b8XIgjeLyQjhlkP1v7lwPAHNhLDkMjgi6ETYXy0EE4vRPczpjzlhjgOUtax1PK9jOy8X
         O0ViZ5jRqjR9pp7FhMV1mwcWdjVlyxg5WbdFKgoZttT1Wqfd8NWrSHEtqffbY5OXzeuD
         y3c1oX2AmgehzZMXE8x6ASuuDrCUTyTt+kDWzG4gSk49hzHQ1ZKyzFPGCOBXhvVQVB5E
         wFhLNBRSJ34KXF8+whhTUnKmeMXwO/ihBP/VzouDNpjskqBdV9NDg0J8QhAH7XElYeek
         LF7w==
X-Gm-Message-State: AOJu0YzIJCM/QF1xmjlh61iBVguAT1BfVht1s9G8mB4HddEpOPKqNH5L
	U2/rlyp4HOsbrV/Jy3DSMeSeFJFSjPc=
X-Google-Smtp-Source: AGHT+IHIuDHCLqGJ0AxBc+8esbz8Pau2672prVI89iuDUziXYDrG4LqUkwewpIEcsSKfSUabyVEeJw==
X-Received: by 2002:a05:600c:3b12:b0:406:44e6:c00d with SMTP id m18-20020a05600c3b1200b0040644e6c00dmr806176wms.2.1699303158122;
        Mon, 06 Nov 2023 12:39:18 -0800 (PST)
Received: from puck.. (finc-22-b2-v4wan-160991-cust114.vm7.cable.virginm.net. [82.17.76.115])
        by smtp.gmail.com with ESMTPSA id s7-20020a05600c45c700b003fc16ee2864sm13349062wmo.48.2023.11.06.12.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 12:39:17 -0800 (PST)
From: Dylan Yudaken <dyudaken@gmail.com>
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk,
	asml.silence@gmail.com,
	Dylan Yudaken <dyudaken@gmail.com>
Subject: [PATCH v2 2/3] io_uring: do not allow multishot read to set addr or len
Date: Mon,  6 Nov 2023 20:39:08 +0000
Message-ID: <20231106203909.197089-3-dyudaken@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231106203909.197089-1-dyudaken@gmail.com>
References: <20231106203909.197089-1-dyudaken@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For addr: this field is not used, since buffer select is forced.
But by forcing it to be zero it leaves open future uses of the field.

len is actually usable, you could imagine that you want to receive
multishot up to a certain length.
However right now this is not how it is implemented, and it seems
safer to force this to be zero.

Fixes: fc68fcda0491 ("io_uring/rw: add support for IORING_OP_READ_MULTISHOT")
Signed-off-by: Dylan Yudaken <dyudaken@gmail.com>
---
 io_uring/rw.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 9e3e56b74e35..8321e004ab13 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -143,6 +143,7 @@ int io_prep_rw_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe)
  */
 int io_read_mshot_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	int ret;
 
 	/* must be used with provided buffers */
@@ -153,6 +154,9 @@ int io_read_mshot_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (unlikely(ret))
 		return ret;
 
+	if (rw->addr || rw->len)
+		return -EINVAL;
+
 	req->flags |= REQ_F_APOLL_MULTISHOT;
 	return 0;
 }
-- 
2.41.0


