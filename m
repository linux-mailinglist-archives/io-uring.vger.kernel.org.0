Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A71835D51A
	for <lists+io-uring@lfdr.de>; Tue, 13 Apr 2021 04:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241556AbhDMCD1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Apr 2021 22:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241515AbhDMCD1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Apr 2021 22:03:27 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFF0C061574
        for <io-uring@vger.kernel.org>; Mon, 12 Apr 2021 19:03:08 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id r7so2798515wrm.1
        for <io-uring@vger.kernel.org>; Mon, 12 Apr 2021 19:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=y1em+y19+ZjAJB1ADk1ACSLWpAbTHIWAagFxhBAIHgI=;
        b=BLqibXT06jX7nGYNdK4ore+41ULSqh1Lpul6hdosQUHcl/FsyBPiyd5s9L/J5nhbPA
         N1JAJlCtbq4IIVn+t6lQ7mGnxzO9DF4skga0NdpJPgDqyFkhiT7eWlrS4V9+SAMDwOt9
         N/Mw7e0ssX0SWJxdHBQtwXqeuLv6WfXO+3kc4DML5iAMH+DsRB9Hjdt+ahOol4TSOD6A
         +595ELdZPT/f6dh6cuWK6gLlfu561mngbPwleY0CxfWMer2Eai3n/b3OY4E3c0XLsSlO
         OIpnHmrH2rjqUgdd7pBpEbUtMJRgsoAPqCRPeRwZPK5gbwp9maFa/BNYbYZtD6wDfBnf
         OXew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y1em+y19+ZjAJB1ADk1ACSLWpAbTHIWAagFxhBAIHgI=;
        b=G+keyG374OGc7RUK+pLjjutR36Dgk9LBmjDkq4Qc9QLsIFOoHVuQ1Oqj+mYJ8BLpK2
         FE0fPr9VZHCA1h4UbidQE8SMwTtuyvQzFu21Wc29ZFN3lvlxYYOekmyrHaZKok/b4UiB
         Fn8/rXFmhEysEC96tgP6NJVkH2A8bO+/S7xhMklJitituNuf/PCC1WsccpX/u0zSukFZ
         oIW9HbYsc2PlVBu1Fv+T7gPTBEo85/4mwe9sclygKAKNdgS0Pc39KQ2j1jQ2sqPs8nJr
         2jsm8t0Wdn+PIy4zM6zzXCakt96+QgQ7JpxdYJHyrvqo6ljK3MIGYf9+5j/WeVjo1/c6
         8JOQ==
X-Gm-Message-State: AOAM532Mqz/FuB4k2iBaCH2DRZRLEOl6DLNb2MXQfZYY5mMcrcuYiMBY
        nxU4L5VZahGqIsVxO4hvNwE=
X-Google-Smtp-Source: ABdhPJwX4FFgiP1SGROaISJSVkKLb+gXgLbXvqkLBI6cxldUZgT1B1VwN09ybp0A/3YN/MqZEu0NlA==
X-Received: by 2002:adf:e58f:: with SMTP id l15mr3372715wrm.175.1618279387275;
        Mon, 12 Apr 2021 19:03:07 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.208])
        by smtp.gmail.com with ESMTPSA id k7sm18771331wrw.64.2021.04.12.19.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 19:03:06 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5/9] io_uring: refactor hrtimer_try_to_cancel uses
Date:   Tue, 13 Apr 2021 02:58:42 +0100
Message-Id: <d2566ef7ce632e6882dc13e022a26249b3fd30b5.1618278933.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618278933.git.asml.silence@gmail.com>
References: <cover.1618278933.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't save return values of hrtimer_try_to_cancel() in a variable, but
use right away. It's in general safer to not have an intermediate
variable, which may be reused and passed out wrongly, but it be
contracted out. Also clean io_timeout_extract().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index eaa8f1af29cc..4f4b4f4bff2d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1272,10 +1272,8 @@ static void io_kill_timeout(struct io_kiocb *req, int status)
 	__must_hold(&req->ctx->completion_lock)
 {
 	struct io_timeout_data *io = req->async_data;
-	int ret;
 
-	ret = hrtimer_try_to_cancel(&io->timer);
-	if (ret != -1) {
+	if (hrtimer_try_to_cancel(&io->timer) != -1) {
 		atomic_set(&req->ctx->cq_timeouts,
 			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&req->timeout.list);
@@ -1792,12 +1790,10 @@ static bool io_kill_linked_timeout(struct io_kiocb *req)
 	 */
 	if (link && (link->flags & REQ_F_LTIMEOUT_ACTIVE)) {
 		struct io_timeout_data *io = link->async_data;
-		int ret;
 
 		io_remove_next_linked(req);
 		link->timeout.head = NULL;
-		ret = hrtimer_try_to_cancel(&io->timer);
-		if (ret != -1) {
+		if (hrtimer_try_to_cancel(&io->timer) != -1) {
 			io_cqring_fill_event(link, -ECANCELED, 0);
 			io_put_req_deferred(link, 1);
 			return true;
@@ -5533,21 +5529,18 @@ static struct io_kiocb *io_timeout_extract(struct io_ring_ctx *ctx,
 {
 	struct io_timeout_data *io;
 	struct io_kiocb *req;
-	int ret = -ENOENT;
+	bool found = false;
 
 	list_for_each_entry(req, &ctx->timeout_list, timeout.list) {
-		if (user_data == req->user_data) {
-			ret = 0;
+		found = user_data == req->user_data;
+		if (found)
 			break;
-		}
 	}
-
-	if (ret == -ENOENT)
-		return ERR_PTR(ret);
+	if (!found)
+		return ERR_PTR(-ENOENT);
 
 	io = req->async_data;
-	ret = hrtimer_try_to_cancel(&io->timer);
-	if (ret == -1)
+	if (hrtimer_try_to_cancel(&io->timer) == -1)
 		return ERR_PTR(-EALREADY);
 	list_del_init(&req->timeout.list);
 	return req;
-- 
2.24.0

