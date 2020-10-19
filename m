Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8CE292A9E
	for <lists+io-uring@lfdr.de>; Mon, 19 Oct 2020 17:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730215AbgJSPmY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Oct 2020 11:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729075AbgJSPmX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Oct 2020 11:42:23 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF72C0613CE
        for <io-uring@vger.kernel.org>; Mon, 19 Oct 2020 08:42:23 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id x7so274218wrl.3
        for <io-uring@vger.kernel.org>; Mon, 19 Oct 2020 08:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=euWFuYw4uoBvsCiW58vehvpNihWvBj/8cIK2DeSugP0=;
        b=YAcsrFk6BaDvueZyWZAlXuvG9scY/RYDAiW7Hnf9tUW9Hi7xaMtjvS4g4lVfo5AWrY
         hrNNWE5e6/aoBjGO2ooWCdjjL6IM2dEZ5aJKqPuuBzTWet5aNlCRiUYaNCmsuofgsCoQ
         MoAI459YzgABh1zpaa2fAO5QxoL5nkkZ0LSjCYrBAAt/9sWCZioBpCMPYwLoGz2r59D5
         Y9SrD2WcYAcBkpnwg1yCw5Xf667uaeb7AinNo2/A5gdhxbNSMh5f1/HNJqvU7wZ8Tvc1
         8sh/i1o15lEDWCVrQTnMoHD5e7Xa8T9RtWQ40I9+wnNjgMH0Z5YnYinfYqy8ywK3q7S6
         mnbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=euWFuYw4uoBvsCiW58vehvpNihWvBj/8cIK2DeSugP0=;
        b=haUQhN7TIRuZkc0QHGKN0+3gHK1A1H7BE1b6dYkug6LtYQobWmHb012pn3S3OAZrtn
         NqkuZBly+xVTFxhEGANLf12tcyngkXFmnAZ9dPYBB9wHwULHzcWb4xQQv/V+ivsnXCaN
         Z+wd72ZMQ88ZUUKqKs1weQuyDgQ4CEx0p3O9IppMO3d8JteErn3Y8Xzo9gcLdVANjXHd
         Mu2wicVcvk/1uWYLfw5cIUd23qsL1S8KZtrkaNOst21xRCWiVDccjXpZtbDLid41orjR
         kQvktobqkObpNz6zCtRrXSTPgKrWabmqU/+O4kSq1kQ2Gfn0OOrIEbjG9bLiaQjWR5UG
         SP9Q==
X-Gm-Message-State: AOAM5307W5VUqTaVEvPPkryo5PJ2dgObvqn2QrFxfU3yiz5SG4wrlWJY
        u9lpF0hHBuM6XGWOmRDkqPz8BKlDpGgTvg==
X-Google-Smtp-Source: ABdhPJyguZl479FGkSSwiGpRmhEjgbZFlp4htcWYv9hSn/aCnkIIlbv4CudoOXmYh2lCDPFcu7mk/A==
X-Received: by 2002:adf:f103:: with SMTP id r3mr136165wro.153.1603122142440;
        Mon, 19 Oct 2020 08:42:22 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id d30sm172113wrc.19.2020.10.19.08.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 08:42:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/1] io_uring: fix racy REQ_F_LINK_TIMEOUT clearing
Date:   Mon, 19 Oct 2020 16:39:16 +0100
Message-Id: <5a8d5c3e3445a2f06070d827f15b4a04fac82076.1603120597.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_link_timeout_fn() removes REQ_F_LINK_TIMEOUT from the link head's
flags, it's not atomic and may race with what the head is doing.

If io_link_timeout_fn() doesn't clear the flag, as forced by this patch,
then it may happen that for "req -> link_timeout1 -> link_timeout2",
__io_kill_linked_timeout() would find link_timeout2 and try to cancel
it, so miscounting references. Teach it to ignore such double timeouts
by marking the active one with a new flag in io_prep_linked_timeout().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5651b9d701e0..c5a00e06be52 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -585,6 +585,7 @@ enum {
 	REQ_F_BUFFER_SELECTED_BIT,
 	REQ_F_NO_FILE_TABLE_BIT,
 	REQ_F_WORK_INITIALIZED_BIT,
+	REQ_F_LTIMEOUT_ACTIVE_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -614,7 +615,7 @@ enum {
 	REQ_F_CUR_POS		= BIT(REQ_F_CUR_POS_BIT),
 	/* must not punt to workers */
 	REQ_F_NOWAIT		= BIT(REQ_F_NOWAIT_BIT),
-	/* has linked timeout */
+	/* has or had linked timeout */
 	REQ_F_LINK_TIMEOUT	= BIT(REQ_F_LINK_TIMEOUT_BIT),
 	/* regular file */
 	REQ_F_ISREG		= BIT(REQ_F_ISREG_BIT),
@@ -628,6 +629,8 @@ enum {
 	REQ_F_NO_FILE_TABLE	= BIT(REQ_F_NO_FILE_TABLE_BIT),
 	/* io_wq_work is initialized */
 	REQ_F_WORK_INITIALIZED	= BIT(REQ_F_WORK_INITIALIZED_BIT),
+	/* linked timeout is active, i.e. prepared by link's head */
+	REQ_F_LTIMEOUT_ACTIVE	= BIT(REQ_F_LTIMEOUT_ACTIVE_BIT),
 };
 
 struct async_poll {
@@ -1865,6 +1868,12 @@ static bool __io_kill_linked_timeout(struct io_kiocb *req)
 	link = list_first_entry(&req->link_list, struct io_kiocb, link_list);
 	if (link->opcode != IORING_OP_LINK_TIMEOUT)
 		return false;
+	/*
+	 * Can happen if a linked timeout fired and link had been like
+	 * req -> link t-out -> link t-out [-> ...]
+	 */
+	if (!(link->flags & REQ_F_LTIMEOUT_ACTIVE))
+		return false;
 
 	list_del_init(&link->link_list);
 	wake_ev = io_link_cancel_timeout(link);
@@ -6110,10 +6119,9 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	if (!list_empty(&req->link_list)) {
 		prev = list_entry(req->link_list.prev, struct io_kiocb,
 				  link_list);
-		if (refcount_inc_not_zero(&prev->refs)) {
+		if (refcount_inc_not_zero(&prev->refs))
 			list_del_init(&req->link_list);
-			prev->flags &= ~REQ_F_LINK_TIMEOUT;
-		} else
+		else
 			prev = NULL;
 	}
 
@@ -6170,6 +6178,7 @@ static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
 	if (!nxt || nxt->opcode != IORING_OP_LINK_TIMEOUT)
 		return NULL;
 
+	nxt->flags |= REQ_F_LTIMEOUT_ACTIVE;
 	req->flags |= REQ_F_LINK_TIMEOUT;
 	return nxt;
 }
-- 
2.24.0

