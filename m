Return-Path: <io-uring+bounces-45-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB54E7E2E4A
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 21:39:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D34411C20850
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 20:39:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86E7928DC6;
	Mon,  6 Nov 2023 20:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pyn6QsqO"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B705529D11
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 20:39:25 +0000 (UTC)
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC065D51
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 12:39:22 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-4083f613275so36526045e9.2
        for <io-uring@vger.kernel.org>; Mon, 06 Nov 2023 12:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699303160; x=1699907960; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=shEMrHKv3bMNF4Fl2Y8B64E5+9a0oPf8G8ISdUBcYxk=;
        b=Pyn6QsqOVa2tCxtcZ5TCKkg8ohNY19RrHoq2oQINE45P1F5EPp12rmwMRPLHcV6EZK
         JDmrLjr06y5xXEE94QdT6zTgfpUc7C1Rd6H7bFVIPE2LitWfN83HSYKViRH8nP/gwaL3
         hq0t1krOv8LfQzxBOWEiMauqPMwU53umAhJtTfNPpSn6Ku9zCPbqI+0S/BoRoVsr4quB
         MQ3EOOlqAf7q6tNOeNxPEE6c/556ngS1ez+9qdbGPqdVV5FifW36MwODjwZHJl6Cdjb3
         vaTczz44lcABQ1f3hu4uDqQ0zawFyE/Pc5+kRpdJmIt3y9Qjlo3QnoJRj4Lja5fYfBzX
         +ATw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699303160; x=1699907960;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=shEMrHKv3bMNF4Fl2Y8B64E5+9a0oPf8G8ISdUBcYxk=;
        b=E5dD4U9J3K/qjzcgUmkjj+QK3xSdSGvyXTpT8+SRQAuBR7XAngnqqM5GmQqJV85Eiw
         SqYDmmvgZ2n5cFRlgfuq/Y0ZxLQ3BLyv61huJonkDGD6pHrdy5c7lfdrU23dN0a/2ZYG
         pZmJDwD5kijfsovafghBJ9Nug1jg1rZWdk0hgpclmMLlDqT3dbluLOqCrXoAerJb4mG3
         kyYQ+//w4vE6stF0vqUK8ZjFCQUF1ZMfi2ZLcsvRyWP/4kv87TzjGtMNDsS81O3Q8UTQ
         RXnNpRlYsD0+AYgl7lC+uVRDDi4NN+Ata9bvlK+pwLLcXahsRiWYovz8kBgeFIEpIAhE
         jZdw==
X-Gm-Message-State: AOJu0Yw+GjsRYnsLLKdxqzJPMqkKNYSDWEin8qZmyAn2+Cq6Go5KfeKm
	mwCo0laDgounF810y7biSucyzXFgbys=
X-Google-Smtp-Source: AGHT+IHZUJFwekKXdSoqdAQMj+BGEnQ5yFxQCaBim1iIqMKgCfD1YNzD4OOKIj7znyp/jU/LK/bLSg==
X-Received: by 2002:a05:600c:9:b0:408:cd96:7164 with SMTP id g9-20020a05600c000900b00408cd967164mr737490wmc.9.1699303160080;
        Mon, 06 Nov 2023 12:39:20 -0800 (PST)
Received: from puck.. (finc-22-b2-v4wan-160991-cust114.vm7.cable.virginm.net. [82.17.76.115])
        by smtp.gmail.com with ESMTPSA id s7-20020a05600c45c700b003fc16ee2864sm13349062wmo.48.2023.11.06.12.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 12:39:18 -0800 (PST)
From: Dylan Yudaken <dyudaken@gmail.com>
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk,
	asml.silence@gmail.com,
	Dylan Yudaken <dyudaken@gmail.com>
Subject: [PATCH v2 3/3] io_uring: do not clamp read length for multishot read
Date: Mon,  6 Nov 2023 20:39:09 +0000
Message-ID: <20231106203909.197089-4-dyudaken@gmail.com>
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

When doing a multishot read, the code path reuses the old read
paths. However this breaks an assumption built into those paths,
namely that struct io_rw::len is available for reuse by __io_import_iovec.

For multishot this results in len being set for the first receive
call, and then subsequent calls are clamped to that buffer length
incorrectly.

Instead keep len as zero after recycling buffers, to reuse the full
buffer size of the next selected buffer.

Fixes: fc68fcda0491 ("io_uring/rw: add support for IORING_OP_READ_MULTISHOT")
Signed-off-by: Dylan Yudaken <dyudaken@gmail.com>
---
 io_uring/rw.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 8321e004ab13..64390d4e20c1 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -912,6 +912,7 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
 
 int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 {
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	unsigned int cflags = 0;
 	int ret;
 
@@ -928,7 +929,12 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 	 * handling arm it.
 	 */
 	if (ret == -EAGAIN) {
-		io_kbuf_recycle(req, issue_flags);
+		/*
+		 * Reset rw->len to 0 again to avoid clamping future mshot
+		 * reads, in case the buffer size varies.
+		 */
+		if (io_kbuf_recycle(req, issue_flags))
+			rw->len = 0;
 		return -EAGAIN;
 	}
 
@@ -941,6 +947,7 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 		 * jump to the termination path. This request is then done.
 		 */
 		cflags = io_put_kbuf(req, issue_flags);
+		rw->len = 0; /* similarly to above, reset len to 0 */
 
 		if (io_fill_cqe_req_aux(req,
 					issue_flags & IO_URING_F_COMPLETE_DEFER,
-- 
2.41.0


