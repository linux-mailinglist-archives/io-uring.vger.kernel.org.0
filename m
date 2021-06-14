Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0433A7227
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 00:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbhFNWlL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Jun 2021 18:41:11 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:52871 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbhFNWlK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Jun 2021 18:41:10 -0400
Received: by mail-wm1-f44.google.com with SMTP id f17so12982236wmf.2
        for <io-uring@vger.kernel.org>; Mon, 14 Jun 2021 15:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=95YptSG/EzMk62Vrc2sCEroQIOJEC/LxZ8ikcLRWfj4=;
        b=jbesLy1oXi9Uk3XWOgIVkE8BY1cwibflcZ3sdBQBlugWQfbAODE5yK4esBZtATG5jL
         4+zShpuqNQEbY04pj/70RoilYhC9WE0PKcbvm5Agy3+QOL2c82jM3EO+xn1HEMES6MT1
         Jir83EuDNTTLkr+OOE1wJVGkgBP6fPy2qIw0vkYK7PqN+0iFmIi+K141SXFBUJSc+V8s
         n+W5iV/NFXG95CY3Caqn8gX8A6mrB3sjiyPLLj+FT59RMafMZvOBXA2qG95cSH89h+NC
         bHcbEcCR0PaQt93UET3jSoT3UxMW/Pt5QN26EGcskhawzDGO/e0NP8obMxrY1qJP2JMO
         QFtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=95YptSG/EzMk62Vrc2sCEroQIOJEC/LxZ8ikcLRWfj4=;
        b=Soe9CNkdIBXwrRqz3UzIWRPUnDiWex1RLEoEbrGJX5Sj57h/LUTo5841zUIM/d96Ku
         LZPslzz809B7sDAjXR1KjhZ+xDQylU9PbBcfYSGYiqfFi/r1p/WiLbk0fwVAYk64oyju
         Y3TPz5Kqad2HH8RJZx8TTaayTeN4UzqDUsAEZdLzaZ0jxzdMHuWOJMZkgnfE12EsLb6J
         wmocj19XqNColwT9q7votFm0DTWUx3QIomsEVwtoBl5ng2wU3tF0brzSYNZ3VjxvubLS
         sS1HawHx/mia8+BBtUjiAFzFpCWGMK6u7E3dBInROmlx0WslxFRhHQuBzQZBQU9iOvyr
         NF2Q==
X-Gm-Message-State: AOAM531KGT0UnIo57peSARHD0NHzU0MLh8WttpQCBJFRHBOOcB5LScEX
        UtvBXGjpurMrIwenUTDEcMA=
X-Google-Smtp-Source: ABdhPJxnU78dH2pIoWj1wD55Oivw3SpqLB/WPuHGd7WFgxNBC6jwhe6qchhVvh98VjWfEeJCfimFxg==
X-Received: by 2002:a1c:9a45:: with SMTP id c66mr18537982wme.43.1623710273770;
        Mon, 14 Jun 2021 15:37:53 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id x3sm621074wmj.30.2021.06.14.15.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 15:37:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 03/12] io_uring: shuffle more fields into SQ ctx section
Date:   Mon, 14 Jun 2021 23:37:22 +0100
Message-Id: <8a5899a50afc6ccca63249e716f580b246f3dec6.1623709150.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623709150.git.asml.silence@gmail.com>
References: <cover.1623709150.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since moving locked_free_* out of struct io_submit_state
ctx->submit_state is accessed on submission side only, so move it into
the submission section. Same goes for rsrc table pointers/nodes/etc.,
they must be taken and checked during submission because sync'ed by
uring_lock, so move them there as well.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a4460383bd25..5cc0c4dd2709 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -353,6 +353,7 @@ struct io_ring_ctx {
 		unsigned int		restricted: 1;
 	} ____cacheline_aligned_in_smp;
 
+	/* submission data */
 	struct {
 		/*
 		 * Ring buffer of indices into array of io_uring_sqe, which is
@@ -369,13 +370,27 @@ struct io_ring_ctx {
 		struct io_uring_sqe	*sq_sqes;
 		unsigned		cached_sq_head;
 		unsigned		sq_entries;
-		unsigned		sq_thread_idle;
 		unsigned		cached_sq_dropped;
 		unsigned long		sq_check_overflow;
-
 		struct list_head	defer_list;
+
+		/*
+		 * Fixed resources fast path, should be accessed only under
+		 * uring_lock, and updated through io_uring_register(2)
+		 */
+		struct io_rsrc_node	*rsrc_node;
+		struct io_file_table	file_table;
+		unsigned		nr_user_files;
+		unsigned		nr_user_bufs;
+		struct io_mapped_ubuf	**user_bufs;
+
+		struct io_submit_state	submit_state;
 		struct list_head	timeout_list;
 		struct list_head	cq_overflow_list;
+		struct xarray		io_buffers;
+		struct xarray		personalities;
+		u32			pers_next;
+		unsigned		sq_thread_idle;
 	} ____cacheline_aligned_in_smp;
 
 	struct {
@@ -383,7 +398,6 @@ struct io_ring_ctx {
 		wait_queue_head_t	wait;
 	} ____cacheline_aligned_in_smp;
 
-	struct io_submit_state		submit_state;
 	/* IRQ completion list, under ->completion_lock */
 	struct list_head	locked_free_list;
 	unsigned int		locked_free_nr;
@@ -394,21 +408,6 @@ struct io_ring_ctx {
 	struct wait_queue_head	sqo_sq_wait;
 	struct list_head	sqd_list;
 
-	/*
-	 * Fixed resources fast path, should be accessed only under uring_lock,
-	 * and updated through io_uring_register(2)
-	 */
-	struct io_rsrc_node	*rsrc_node;
-
-	struct io_file_table	file_table;
-	unsigned		nr_user_files;
-	unsigned		nr_user_bufs;
-	struct io_mapped_ubuf	**user_bufs;
-
-	struct xarray		io_buffers;
-	struct xarray		personalities;
-	u32			pers_next;
-
 	struct {
 		unsigned		cached_cq_tail;
 		unsigned		cq_entries;
-- 
2.31.1

