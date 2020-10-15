Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0B828FA82
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 23:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732800AbgJOVO1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 17:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732725AbgJOVO1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 17:14:27 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43911C061755
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 14:14:27 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id a72so377466wme.5
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 14:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=8MWp5d3WIVqnRM4gAomzV2WjhIfhxkOMXek2iBdv9Nk=;
        b=dQO/1jMiUWonZhwTFxeFq08WxQ2T2uyhiVayQVvy+4D+hU8nOlZ1XIM7K0lalnWPdm
         e1OACZOI1Q9XDCtcmlJlcuvBQUOHue7OPuSNyWLHqny5zOAewpHndDyjfWltVxD5O/Px
         bylrhrX7X8HL5/7PzP4Aof6qi+T2DRsolchPNk1zVx6pA+ngNJ5c/F1/4WRYwsYrJ7S1
         XHkkKPVBrwPp429RSF35Tk8IYtjtpZlL3+AFivPPS237WsI9TL4gyt8i3NuxtLqyyYJF
         envyNQbaS8QJLyRB+nZ1KYn/QYYT6apNG/sU+09he6aowX57O6QS8tWPB8sJQtuY5SsG
         HP6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8MWp5d3WIVqnRM4gAomzV2WjhIfhxkOMXek2iBdv9Nk=;
        b=QJJSUUgMf2NQpqjVeikNqHJsy3Q2vnu8BYSo3A9LWTkez+LEXn6Zh9Of8X6yqCJXoa
         KT378NDjUxkQnEc2Sg5Oyw7tTkwaFntCbl9onXsXzjaWWVpio7FtQYkNbNAa0IZ+nLkw
         FYHENFzLku03jnExCQROItDPcFQA0nYTOCXL0uhObUQo7jRw6dDupK/nl+G+Dg4mHBPh
         OWitww1IgP5uvI6Vjcook1M5tnlS0W/8rAdtpkoo4rjEAeWccmsXJbRJpMfUlWGNMHys
         VM4iN+B4aKy5cN3g5L71mssZ142aoX8s+JIVWjJJL/SoR+lFJ5J85psyJKLwRqkWJCkm
         IiLg==
X-Gm-Message-State: AOAM5305yd9Kmfr94RJZx8Zl42S7Cn75DcfFsrARtQOkD+GeWHN5JcWb
        ThnDsSAKe/BkFupqndTycaCXtRTFztpfVw==
X-Google-Smtp-Source: ABdhPJy+9qTg8NXdU0BFyVMtqQyWv4aKpNEfDrDX7BbklLW+dOnGAQUVMvfG/jbGzGGP2LTJkln6Gw==
X-Received: by 2002:a7b:c453:: with SMTP id l19mr558316wmi.50.1602796465994;
        Thu, 15 Oct 2020 14:14:25 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id x3sm320865wmi.45.2020.10.15.14.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 14:14:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/4] io_uring: simplify linked timeout cancel
Date:   Thu, 15 Oct 2020 22:11:22 +0100
Message-Id: <bb1b37e62c1441048b6e3d16e359b758006905b2.1602795685.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1602795685.git.asml.silence@gmail.com>
References: <cover.1602795685.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As was done with general timeouts, don't remove linked timeouts from
link_list in io_link_cancel_timeout() unless they were successefully
cancelled with hrtimer_try_to_cancel(). With that it's not needed to
check if there was a race and the timeout got removed before getting
into io_link_timeout_fn().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 32 +++++++++++---------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 373b67a252df..8065df90ce98 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1732,6 +1732,7 @@ static bool io_link_cancel_timeout(struct io_kiocb *req)
 
 	ret = hrtimer_try_to_cancel(&io->timer);
 	if (ret != -1) {
+		list_del_init(&req->link_list);
 		io_cqring_fill_event(req, -ECANCELED);
 		io_commit_cqring(ctx);
 		req->flags &= ~REQ_F_LINK_HEAD;
@@ -1747,13 +1748,11 @@ static bool __io_kill_linked_timeout(struct io_kiocb *req)
 	struct io_kiocb *link;
 	bool wake_ev;
 
-	if (list_empty(&req->link_list))
-		return false;
-	link = list_first_entry(&req->link_list, struct io_kiocb, link_list);
-	if (link->opcode != IORING_OP_LINK_TIMEOUT)
+	link = list_first_entry_or_null(&req->link_list, struct io_kiocb,
+					link_list);
+	if (!link || link->opcode != IORING_OP_LINK_TIMEOUT)
 		return false;
 
-	list_del_init(&link->link_list);
 	wake_ev = io_link_cancel_timeout(link);
 	req->flags &= ~REQ_F_LINK_TIMEOUT;
 	return wake_ev;
@@ -5970,27 +5969,18 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 {
 	struct io_timeout_data *data = container_of(timer,
 						struct io_timeout_data, timer);
-	struct io_kiocb *req = data->req;
+	struct io_kiocb *prev, *req = data->req;
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_kiocb *prev = NULL;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ctx->completion_lock, flags);
+	prev = list_entry(req->link_list.prev, struct io_kiocb, link_list);
 
-	/*
-	 * We don't expect the list to be empty, that will only happen if we
-	 * race with the completion of the linked work.
-	 */
-	if (!list_empty(&req->link_list)) {
-		prev = list_entry(req->link_list.prev, struct io_kiocb,
-				  link_list);
-		if (refcount_inc_not_zero(&prev->refs)) {
-			list_del_init(&req->link_list);
-			prev->flags &= ~REQ_F_LINK_TIMEOUT;
-		} else
-			prev = NULL;
-	}
-
+	if (refcount_inc_not_zero(&prev->refs)) {
+		list_del_init(&req->link_list);
+		prev->flags &= ~REQ_F_LINK_TIMEOUT;
+	} else
+		prev = NULL;
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	if (prev) {
-- 
2.24.0

