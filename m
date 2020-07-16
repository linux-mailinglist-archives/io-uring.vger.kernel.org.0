Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5B5222CD5
	for <lists+io-uring@lfdr.de>; Thu, 16 Jul 2020 22:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgGPUaL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jul 2020 16:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgGPUaL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jul 2020 16:30:11 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5AEFC061755
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 13:30:10 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id f139so12887796wmf.5
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 13:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=/JkyFhaOKnlFUzQDk0THElW5UuNKZQhzmy3W/GZhOYc=;
        b=UWeJI1eR1IrWnpNVpn3f+q53QtvOtLZezxCtzw6wicGVgjuFir1yOUGww1vYt2Gxy8
         u5G0TU2o8XSZoV2Lmk1Ca22u+uax9HYvdBFNUjNZRJfEm6u24hrIYrdozG9PRP+W+pLf
         3TKhuCw4js0AgWVlss0TYoIxiHZgmt222sEr2FAlDaxhhMTLxCxVrtPC7nF5a7U3OlP2
         mh5CnGuLVRkLWVBWPu14zplYNe9ySCJdMxwD1B9PWyhBFcSWkCA6BoTey8bWMkiHfxfT
         N/xe8J5w2PgNCwJl1x8dI/aqMWwYptNybJQl/U2DD8q0FYxm2YrM4exkpCCRUZC2mTkc
         3xsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/JkyFhaOKnlFUzQDk0THElW5UuNKZQhzmy3W/GZhOYc=;
        b=tx2FwWRTaH83jlUwuByGF6ylOX9LKW78uU57U5vfyPTP0+fvLxKBT2sYW+p3sJOI57
         px54SVfxPL5ma6dYgC3Htt3DqqXrVBgsEgiZQWwAEVothyyfA1dsSYrRwjBgJKDMxC3p
         aCJwQamtEicsriirN5Ahl88ryBbeNW1P+BxSU4923+5NCxwCsusI/6rKxPpaf2yxv3pG
         4Z4G/EZdRt8c4F/nKuXmnu9uuxRTbbUWXODLqbCsfrM3P13eUobjtcEa1OjxkO6xN3gh
         ClJGCjP6sP5uyTzI71XjChQToaFG+xBgKHqxcOY50Hmz0XfrgemBS7Q2IgMJV9UIA2+X
         9APg==
X-Gm-Message-State: AOAM53234d4pdNEb1ZvYBYZwZlrbGe0Dmh3oylYzNYztbiSgP18o4nKG
        4XJdUwJ3ZMId9plTm8u2Y8Y=
X-Google-Smtp-Source: ABdhPJz2D+fRNoHM0A6W0qTc3EM9VrFVuakCSZIBmaIND7uZpkfZaZArxF3k+B7eYt68byENmYSDIg==
X-Received: by 2002:a1c:6706:: with SMTP id b6mr5554829wmc.167.1594931409641;
        Thu, 16 Jul 2020 13:30:09 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id v5sm9939823wmh.12.2020.07.16.13.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 13:30:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 6/7] io_uring: extract io_put_kbuf() helper
Date:   Thu, 16 Jul 2020 23:28:04 +0300
Message-Id: <5b452eed4f84cecb61fce77ab9d06cd3a9d9574b.1594930020.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594930020.git.asml.silence@gmail.com>
References: <cover.1594930020.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Extract a common helper for cleaning up a selected buffer, this will be
used shortly. By the way, correct cflags types to unsigned and, as kbufs
are anyway tracked by a flag, remove useless zeroing req->rw.addr.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index eabc03320901..c723f15c5463 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1922,20 +1922,25 @@ static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
 	return smp_load_acquire(&rings->sq.tail) - ctx->cached_sq_head;
 }
 
-static int io_put_kbuf(struct io_kiocb *req)
+static unsigned int io_put_kbuf(struct io_kiocb *req, struct io_buffer *kbuf)
 {
-	struct io_buffer *kbuf;
-	int cflags;
+	unsigned int cflags;
 
-	kbuf = (struct io_buffer *) (unsigned long) req->rw.addr;
 	cflags = kbuf->bid << IORING_CQE_BUFFER_SHIFT;
 	cflags |= IORING_CQE_F_BUFFER;
-	req->rw.addr = 0;
 	req->flags &= ~REQ_F_BUFFER_SELECTED;
 	kfree(kbuf);
 	return cflags;
 }
 
+static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
+{
+	struct io_buffer *kbuf;
+
+	kbuf = (struct io_buffer *) (unsigned long) req->rw.addr;
+	return io_put_kbuf(req, kbuf);
+}
+
 static inline bool io_run_task_work(void)
 {
 	if (current->task_works) {
@@ -1985,7 +1990,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		list_del(&req->inflight_entry);
 
 		if (req->flags & REQ_F_BUFFER_SELECTED)
-			cflags = io_put_kbuf(req);
+			cflags = io_put_rw_kbuf(req);
 
 		__io_cqring_fill_event(req, req->result, cflags);
 		(*nr_events)++;
@@ -2177,7 +2182,7 @@ static void io_complete_rw_common(struct kiocb *kiocb, long res,
 	if (res != req->result)
 		req_set_fail_links(req);
 	if (req->flags & REQ_F_BUFFER_SELECTED)
-		cflags = io_put_kbuf(req);
+		cflags = io_put_rw_kbuf(req);
 	__io_req_complete(req, res, cflags, cs);
 }
 
-- 
2.24.0

