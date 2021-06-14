Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3BEF3A7221
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 00:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbhFNWkW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Jun 2021 18:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbhFNWkW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Jun 2021 18:40:22 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4148AC0613A4
        for <io-uring@vger.kernel.org>; Mon, 14 Jun 2021 15:38:02 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id t4-20020a1c77040000b029019d22d84ebdso406724wmi.3
        for <io-uring@vger.kernel.org>; Mon, 14 Jun 2021 15:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=BiqBzGuRv/KawRjuVbj3aLZOGLkOJAksbtO2Vr1j8Ac=;
        b=CxDMRXKvXoCAGwQR3Jg5dYM1zE2UhM5Mg7tXxYua5YNuDc+y1ZNBdUEWwzSyYsPDeg
         lty0BlV010KdK9syPd1m6U6WZMUquaNaC4bU2PuXhqIZBFb0SuCz365CX4Co/A1mAh3l
         aqXnwJ60zJfncDlRImcEoRATDaXupT9o2aLXP5z3oyY2lza32peJH1vJJZMO5fK4VlhH
         KNvr0MOfIDlI9kGM4I/U+u5dusvinL6vcXn+NI9u7jvrbSLCgfgEd1aS67dyecaV3HnR
         BCC5ee8e/IRzeSD0+5LniFLCFxtVDuAT4k2w4Ak5Wt1lNpUd5CDNK18mJ2JBwQ78nHMa
         8UgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BiqBzGuRv/KawRjuVbj3aLZOGLkOJAksbtO2Vr1j8Ac=;
        b=p12sZcaeifeonzHjpVWpIFVXzizB8sk2e633fTYOSh3mshMfgh86aMpA3mW40dJptI
         tLO3j3YSx6Ttu399XcaJ1E8ZCgsN34wChtIMOdJSeiyTOHtrxqMiSdD4M1T1kvxEud6A
         r+QwB8QfiAtrjzN/LFLf7btpMS04roolklMPC3dKhjt+jcTK2BFc5cOkmJwMPd2sLshe
         SSJccgtvQ0TUlXKoYEAcc3PqqmfkWD6N+e33uNFslBI3GfvDAccOP5mvptkPZsBk63KH
         Ih0WTz11AVt3cl1lLnZBy0Wp5gRwVoODqc43j+UD8pU0h8kHoRanty1Smpxn6zv3BjHq
         calg==
X-Gm-Message-State: AOAM5324/u5achjhVtVOmTtbNDUzwb+CTwzoZhfGVbf4FjyiF1cc0AEJ
        TAg97nAqgTxe+e4krZCoorc=
X-Google-Smtp-Source: ABdhPJy/fLYUHvkOjMJEmVL+oFuBDKoUtKsTJc3QZr1ZltEFBWJpo/bC4+mDoFNpuSN2Dt1xmtW02A==
X-Received: by 2002:a1c:2015:: with SMTP id g21mr1483667wmg.87.1623710280924;
        Mon, 14 Jun 2021 15:38:00 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id x3sm621074wmj.30.2021.06.14.15.38.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 15:38:00 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 10/12] io_uring: move uring_lock location
Date:   Mon, 14 Jun 2021 23:37:29 +0100
Message-Id: <dea5e845caee4c98aa0922b46d713154d81f7bd8.1623709150.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623709150.git.asml.silence@gmail.com>
References: <cover.1623709150.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

->uring_lock is prevalently used for submission, even though it protects
many other things like iopoll, registeration, selected bufs, and more.
And it's placed together with ->cq_wait poked on completion and CQ
waiting sides. Move them apart, ->uring_lock goes to the submission
data, and cq_wait to completion related chunk. The last one requires
some reshuffling so everything needed by io_cqring_ev_posted*() is in
one cacheline.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e9bf26fbf65d..1b6cfc6b79c5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -356,6 +356,8 @@ struct io_ring_ctx {
 
 	/* submission data */
 	struct {
+		struct mutex		uring_lock;
+
 		/*
 		 * Ring buffer of indices into array of io_uring_sqe, which is
 		 * mmapped by the application using the IORING_OFF_SQES offset.
@@ -392,11 +394,6 @@ struct io_ring_ctx {
 		unsigned		sq_thread_idle;
 	} ____cacheline_aligned_in_smp;
 
-	struct {
-		struct mutex		uring_lock;
-		wait_queue_head_t	cq_wait;
-	} ____cacheline_aligned_in_smp;
-
 	/* IRQ completion list, under ->completion_lock */
 	struct list_head	locked_free_list;
 	unsigned int		locked_free_nr;
@@ -412,12 +409,13 @@ struct io_ring_ctx {
 	struct {
 		unsigned		cached_cq_tail;
 		unsigned		cq_entries;
-		atomic_t		cq_timeouts;
-		unsigned		cq_last_tm_flush;
-		unsigned		cq_extra;
+		struct eventfd_ctx	*cq_ev_fd;
 		struct wait_queue_head	poll_wait;
+		struct wait_queue_head	cq_wait;
+		unsigned		cq_extra;
+		atomic_t		cq_timeouts;
 		struct fasync_struct	*cq_fasync;
-		struct eventfd_ctx	*cq_ev_fd;
+		unsigned		cq_last_tm_flush;
 	} ____cacheline_aligned_in_smp;
 
 	struct {
-- 
2.31.1

