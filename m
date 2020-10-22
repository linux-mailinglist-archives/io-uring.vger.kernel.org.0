Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892D22961DB
	for <lists+io-uring@lfdr.de>; Thu, 22 Oct 2020 17:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368717AbgJVPqY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 11:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S368712AbgJVPqY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 11:46:24 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4687C0613CE
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 08:46:23 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id h7so3044109wre.4
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 08:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=s4H45xF5rP3W1ct2v7jOLUs8A4VhkTbpoOcvDeutMrw=;
        b=nreLm5oYBUOwCkwUkF348hGZn0ttKhwMcZ4pcL5TnSfsSrDPI1nhSBvAqBeVhD/1VJ
         jIz1bZCu6K2Qp2Lm6XXKg7GVdXkl1+DBOpYxMhH7TRSoCZPjMeF8lijnSk2V50IpHzci
         6nQKhoXntiyaK8psRZn1b4GkVDfIGXtwORN8WNbG1YTG2XQFGnb0ld/vlMZddIHc2bJ+
         E2fNe7F+XwIOUTYipktxzFwIAa6WS0TnoiL+EqKk+51+iV+Z+qFz1urzSBK/bB4JQKMd
         22lIB2cKCf1+cg4lBlOpiZepGsqtOuB8aTTIqw8ohdM1yl42rB58xfTbMxBb61ql4VlD
         7rug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s4H45xF5rP3W1ct2v7jOLUs8A4VhkTbpoOcvDeutMrw=;
        b=i6aeX8HPk79qHmX3rOwowmnFl9IzbyDYIkXxkl0PJSfR2k9N0gGsv3atrZ0L/jSavz
         LMSBkafLRCPxHsZHOfJL8pmWgPCoOORxmP0FZ2+AGej423UTIgApA43JlUzJB5j+/GQn
         ZEvPFlevSzE80910OqpWDgiF0m+SJMzGuQf9eygBGtQbh0VAPKDmcY+ccEqVOZfnRhfi
         3/YSsHDBPqg9JLrZMc+p13NZFocY3EYQo6kuJPeTP7eE56h2pnj9nUri3SCl/s8b8cDT
         AubwfBuFLCQuZNpdAXT7DWkwrzgPcHJ3kSkI5z1xRHxZwMK2vx9TNyeeT1OrjvWrr/Pm
         Aedw==
X-Gm-Message-State: AOAM533PdbqMbMnF6Uh0YYoFSty7HGrvFN1Wbsqu7vOLmrvjg1QGZO7+
        yJOcFydCr+BEDc9nC5Ep65I=
X-Google-Smtp-Source: ABdhPJzezVpNLvc9Mj5Kg62avI3kgGTBUJ0y7ymDZrMf8SuxfEnun5x9u3vek18bdEv9L+sSgGt8vQ==
X-Received: by 2002:a5d:6591:: with SMTP id q17mr3388525wru.173.1603381582429;
        Thu, 22 Oct 2020 08:46:22 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id s11sm4329536wrm.56.2020.10.22.08.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 08:46:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/4] io_uring: don't defer put of cancelled ltimeout
Date:   Thu, 22 Oct 2020 16:43:11 +0100
Message-Id: <e85a094f581e1802d85e3700be8413d9d2a80f19.1603381140.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1603381140.git.asml.silence@gmail.com>
References: <cover.1603381140.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Inline io_link_cancel_timeout() and __io_kill_linked_timeout() into
io_kill_linked_timeout(). That allows to easily move a put of a cancelled
linked timeout out of completion_lock and to not deferring it. It is also
much more readable when not scattered across three different functions.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 58 ++++++++++++++++++---------------------------------
 1 file changed, 20 insertions(+), 38 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d9ac45f850be..5a0fa2889fcb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1846,57 +1846,39 @@ static void __io_free_req(struct io_kiocb *req)
 	percpu_ref_put(&ctx->refs);
 }
 
-static bool io_link_cancel_timeout(struct io_kiocb *req)
+static void io_kill_linked_timeout(struct io_kiocb *req)
 {
-	struct io_timeout_data *io = req->async_data;
 	struct io_ring_ctx *ctx = req->ctx;
-	int ret;
-
-	ret = hrtimer_try_to_cancel(&io->timer);
-	if (ret != -1) {
-		io_cqring_fill_event(req, -ECANCELED);
-		io_commit_cqring(ctx);
-		io_put_req_deferred(req, 1);
-		return true;
-	}
-
-	return false;
-}
-
-static bool __io_kill_linked_timeout(struct io_kiocb *req)
-{
 	struct io_kiocb *link;
-	bool wake_ev;
-
-	if (list_empty(&req->link_list))
-		return false;
-	link = list_first_entry(&req->link_list, struct io_kiocb, link_list);
+	bool cancelled = false;
+	unsigned long flags;
 
+	spin_lock_irqsave(&ctx->completion_lock, flags);
+	link = list_first_entry_or_null(&req->link_list, struct io_kiocb,
+					link_list);
 	/*
 	 * Can happen if a linked timeout fired and link had been like
 	 * req -> link t-out -> link t-out [-> ...]
 	 */
-	if (!(link->flags & REQ_F_LTIMEOUT_ACTIVE))
-		return false;
-
-	list_del_init(&link->link_list);
-	wake_ev = io_link_cancel_timeout(link);
-	return wake_ev;
-}
-
-static void io_kill_linked_timeout(struct io_kiocb *req)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	unsigned long flags;
-	bool wake_ev;
+	if (link && (link->flags & REQ_F_LTIMEOUT_ACTIVE)) {
+		struct io_timeout_data *io = link->async_data;
+		int ret;
 
-	spin_lock_irqsave(&ctx->completion_lock, flags);
-	wake_ev = __io_kill_linked_timeout(req);
+		list_del_init(&link->link_list);
+		ret = hrtimer_try_to_cancel(&io->timer);
+		if (ret != -1) {
+			io_cqring_fill_event(link, -ECANCELED);
+			io_commit_cqring(ctx);
+			cancelled = true;
+		}
+	}
 	req->flags &= ~REQ_F_LINK_TIMEOUT;
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
-	if (wake_ev)
+	if (cancelled) {
 		io_cqring_ev_posted(ctx);
+		io_put_req(link);
+	}
 }
 
 static struct io_kiocb *io_req_link_next(struct io_kiocb *req)
-- 
2.24.0

