Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F0F3F6112
	for <lists+io-uring@lfdr.de>; Tue, 24 Aug 2021 16:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237875AbhHXO5t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Aug 2021 10:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237731AbhHXO5s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Aug 2021 10:57:48 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA91C061757
        for <io-uring@vger.kernel.org>; Tue, 24 Aug 2021 07:57:04 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id h4so1570297wro.7
        for <io-uring@vger.kernel.org>; Tue, 24 Aug 2021 07:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+YZuYSDh4GWxpKufaAZWZ3dCOlFm/h51UCckpVhnSIQ=;
        b=MzQg7wQquPXZGpR2w4YAmlusKzTO0fvqH+9XKaLZW6t83nNeJJpRmkMBEF0YGQ/otd
         HpkiE7ij6QxzSrxyy30NwpaFThaZHIs+LCNCH3cztMfxRwRBp+uehtdcxXGmPDFabMXe
         3wnvG2yH2sk3sDz1whQzi0XtGu+pBgDUJ+lXw1PrZ13OJ4rj76XsGim+SuGbrCQdVcFb
         cAVlMHem+XjOo/qKIH3P6QrTtVSCZeegUtwjpdecN/HGJiUMcrMw37bpLjM6wjQ3HNcF
         uz9VBn9MCOyYiCQWuXIfhgVYK289i2a6zEPmYSaY/3NuV/skX4SfBeUEwjW11QllKMji
         FIEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+YZuYSDh4GWxpKufaAZWZ3dCOlFm/h51UCckpVhnSIQ=;
        b=lMrNhmiIU1O9CX+k1I7tTikBeJ/izd7uiZpRevVhI/3folae1+hiwttBGVVGZTT8bC
         enXz+x60CkGZ4OGHzgx8L/d6Fv+Mxcm3VOoAWPG+vQDaCvyjyA6V6tI3TOXS6JT4N0CO
         OmGjRgQOOzBwpLc1Fl9dFRgqu/4gGZ7RPcUSICTBhUSX9+Q/mVQRUb0hN75cXmwBSWbo
         H0O8QWgF81ZkoAggiO+SY+z7QIUwBRVOBfJ2HG1Cumy4wNcoYX6NUioDLAx8jpwV/hFE
         85EWcigyguTiWpa4obxZVdOwAzoMHlXnZjmQUoyyMR2jjS9ZlFW3aSBlBbrcSYfcNWW/
         t+4g==
X-Gm-Message-State: AOAM531a5B9I8rhVxtK+xg+B4ZMkCjHxk2UHa5GhmW3vI5WTyjQh4HyF
        /4dS27/zKqGA4w1O3NofkUU=
X-Google-Smtp-Source: ABdhPJw8CtcZ0kdtV4xIluOVz5QGrFVLw8btBs2rS+86+d79m21Mb4PDv0AbJftEbVsbZc5q4i+O+Q==
X-Received: by 2002:adf:ed8d:: with SMTP id c13mr20028614wro.405.1629817023051;
        Tue, 24 Aug 2021 07:57:03 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.113])
        by smtp.gmail.com with ESMTPSA id h11sm2937941wmc.23.2021.08.24.07.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 07:57:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-next] io_uring: kill off ios_left
Date:   Tue, 24 Aug 2021 15:56:25 +0100
Message-Id: <c0b70819bc1b6e34e63ec59869303a9611596f5e.1629815641.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

->ios_left is only used to decide whether to plug or not, kill it to
avoid this extra accounting, just use the initial submission number.
There is no much difference in regards of enabling plugging, where this
one does it in a few more cases, but all major ones should be covered
well.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 74b606990d7e..54a7868c9c8e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -315,6 +315,7 @@ struct io_submit_state {
 	unsigned int		free_reqs;
 
 	bool			plug_started;
+	bool			need_plug;
 
 	/*
 	 * Batch completion logic
@@ -323,8 +324,6 @@ struct io_submit_state {
 	unsigned int		compl_nr;
 	/* inline/task_work completion list, under ->uring_lock */
 	struct list_head	free_list;
-
-	unsigned int		ios_left;
 };
 
 struct io_ring_ctx {
@@ -6715,10 +6714,10 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	 * Plug now if we have more than 1 IO left after this, and the target
 	 * is potentially a read/write to block based storage.
 	 */
-	if (!state->plug_started && state->ios_left > 1 &&
-	    io_op_defs[req->opcode].plug) {
+	if (state->need_plug && io_op_defs[req->opcode].plug) {
 		blk_start_plug(&state->plug);
 		state->plug_started = true;
+		state->need_plug = false;
 	}
 
 	if (io_op_defs[req->opcode].needs_file) {
@@ -6727,8 +6726,6 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		if (unlikely(!req->file))
 			ret = -EBADF;
 	}
-
-	state->ios_left--;
 	return ret;
 }
 
@@ -6816,7 +6813,7 @@ static void io_submit_state_start(struct io_submit_state *state,
 				  unsigned int max_ios)
 {
 	state->plug_started = false;
-	state->ios_left = max_ios;
+	state->need_plug = max_ios > 2;
 	/* set only head, no need to init link_last in advance */
 	state->link.head = NULL;
 }
-- 
2.32.0

