Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 045D729CD38
	for <lists+io-uring@lfdr.de>; Wed, 28 Oct 2020 02:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgJ1Bie (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Oct 2020 21:38:34 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40709 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1833005AbgJ0X2p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Oct 2020 19:28:45 -0400
Received: by mail-wm1-f67.google.com with SMTP id k18so3077470wmj.5
        for <io-uring@vger.kernel.org>; Tue, 27 Oct 2020 16:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=WygRRE9LqGQls6VN8n+uTO9nLrmULEP19L6yWVTmF8w=;
        b=kd1QC9ILHpGGEY5hGvt8nIYeW5ikQ6pmpns0lRv4qZyoiaaZlRX8wrYcAhfmXpSF1q
         DjlgNilo4tnC7y/dcnMKyk9AUdS7C/+Nr4brn6C8YzOeQ2+I2TlQ0gB7UikvFHav/Wca
         cL1l/M7ka9LOHxBPbUzqPmGM4l9OYRxncscfuigAzco0q2ivCWRfH7ujgi8GSZlKrVpG
         A1VOm/8lUnyZWd5wmFyQ5Iz/b2PIPdczZeqwCzV50gTouBYC9He5thBkN6zPUfcz3Ex6
         DiPq/InKCXGO1ONulgwj7cVKW8W5sd80XLKfmckrQ+jik5zMuDIhcGYSekU2OVXyEqQr
         8qWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WygRRE9LqGQls6VN8n+uTO9nLrmULEP19L6yWVTmF8w=;
        b=a3JjfCdTnu/I7vJOZamCmU6SmjdggvOqQP6z/3GX0sOEtid8LrHT6lRsPBFwln8STe
         kO/dJ7TwE9EyGPfJeuXY8DQgMzzEednlS+5ALt6A+8Pq9vm+7Av4sCBbzCfb0A0xysvd
         2f5r2AGM1sedRZJttDJ7GAJxvPMHVQPfKciR2SdiUZfpZZRimi+cWsHvBPtriqTcmGfX
         bfuCbHhbav9F+ByYi7L/nIwcltHUYIiRWCgAS5RM0DKZBNASnbHFlk5tqUFOD84dXgJn
         Dn8tbq11tPXVrSnMkWy5VvvaXfeKB1xgKNE9TXgP0IBZatkS8DE5pQS6jKi2VsXiUP1b
         e8fA==
X-Gm-Message-State: AOAM531k/gDBm3WM+2spZuAFQxjbtUxW2BGkcsMJQ4zyMPv4lfIsHFYz
        q+8q3OimXHPvRTYHu4jFrHnJP4heFWmvyA==
X-Google-Smtp-Source: ABdhPJwrVxIIFlw4K2pYaDSjyoyTO+pu7PCmaRYYHDA/hB4jq2/qwpBfkRzlnuVUG2v+qRskdpIVbQ==
X-Received: by 2002:a7b:ce85:: with SMTP id q5mr4987361wmj.35.1603841323170;
        Tue, 27 Oct 2020 16:28:43 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id a15sm4336990wrp.90.2020.10.27.16.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 16:28:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/4] io_uring: track link timeout's master explicitly
Date:   Tue, 27 Oct 2020 23:25:36 +0000
Message-Id: <cf4f525fd7717775a8fd230205dd15d248dc557a.1603840701.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1603840701.git.asml.silence@gmail.com>
References: <cover.1603840701.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In preparation for converting singly linked lists for chaining requests,
make linked timeouts save requests that they're responsible for and not
count on doubly linked list for back referencing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ce092d6cab73..4eb1cb8a8bf8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -445,6 +445,8 @@ struct io_timeout {
 	u32				off;
 	u32				target_seq;
 	struct list_head		list;
+	/* head of the link, used by linked timeouts only */
+	struct io_kiocb			*head;
 };
 
 struct io_timeout_rem {
@@ -1871,6 +1873,7 @@ static void io_kill_linked_timeout(struct io_kiocb *req)
 		int ret;
 
 		list_del_init(&link->link_list);
+		link->timeout.head = NULL;
 		ret = hrtimer_try_to_cancel(&io->timer);
 		if (ret != -1) {
 			io_cqring_fill_event(link, -ECANCELED);
@@ -6084,26 +6087,22 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 {
 	struct io_timeout_data *data = container_of(timer,
 						struct io_timeout_data, timer);
-	struct io_kiocb *req = data->req;
+	struct io_kiocb *prev, *req = data->req;
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_kiocb *prev = NULL;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ctx->completion_lock, flags);
+	prev = req->timeout.head;
+	req->timeout.head = NULL;
 
 	/*
 	 * We don't expect the list to be empty, that will only happen if we
 	 * race with the completion of the linked work.
 	 */
-	if (!list_empty(&req->link_list)) {
-		prev = list_entry(req->link_list.prev, struct io_kiocb,
-				  link_list);
-		if (refcount_inc_not_zero(&prev->refs))
-			list_del_init(&req->link_list);
-		else
-			prev = NULL;
-	}
-
+	if (prev && refcount_inc_not_zero(&prev->refs))
+		list_del_init(&req->link_list);
+	else
+		prev = NULL;
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	if (prev) {
@@ -6122,7 +6121,7 @@ static void __io_queue_linked_timeout(struct io_kiocb *req)
 	 * If the list is now empty, then our linked request finished before
 	 * we got a chance to setup the timer
 	 */
-	if (!list_empty(&req->link_list)) {
+	if (req->timeout.head) {
 		struct io_timeout_data *data = req->async_data;
 
 		data->timer.function = io_link_timeout_fn;
@@ -6157,6 +6156,7 @@ static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
 	if (!nxt || nxt->opcode != IORING_OP_LINK_TIMEOUT)
 		return NULL;
 
+	nxt->timeout.head = req;
 	nxt->flags |= REQ_F_LTIMEOUT_ACTIVE;
 	req->flags |= REQ_F_LINK_TIMEOUT;
 	return nxt;
-- 
2.24.0

