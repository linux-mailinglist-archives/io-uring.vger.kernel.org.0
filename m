Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB3E35F427
	for <lists+io-uring@lfdr.de>; Wed, 14 Apr 2021 14:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbhDNMnT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Apr 2021 08:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233505AbhDNMnR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Apr 2021 08:43:17 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D11C061574
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 05:42:55 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id a4so19755346wrr.2
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 05:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=r2rUyVx69NtQe/JuEWNbtS17jy4jnwfRvpUBRCF96P0=;
        b=W+yXFWa1ZLo/T6DEAmJVRVaso9XQYirf+xV0xPJ7heZNJNpE1lZmqvoxXwtEyRBAMP
         hZSqeGicN5jwgWa/qgnFEiBk61nkhzwo8fermFQyNq6oHHmeUYkcrydSVoM0tWg6Ck8t
         y/lDOZfWpPzEAdAT0swR434mFmpAo4fKkil+8b04eWErDVcTT/oy5uImMapMparQOOco
         5OLdydBdNhclMYV46O9N8Dr255rwRrlGiaiQqK1BdOkZJeWJHrRpW0RPQUXYr2EcI+hL
         nDn8JUEfO05OKAeklP+JeCzBL8y5Z2LK5j8AF2X0AJ7nWDlrUuZiErU4iKhCyGqjgdLm
         rjgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r2rUyVx69NtQe/JuEWNbtS17jy4jnwfRvpUBRCF96P0=;
        b=Sf4J8XmOQ39aPCPo8rHbKPXaXmwROrBmWuXh8c6sbfP/Sj5MMbX7ODrDk2+YvSmNCQ
         rhiKLO9w4cH7CmyYSGK+WrkkwLfhh6Ft7O/0FkHKdCnQ9NhYNvNhMU0hnLdM3wBdgmWr
         byxobZz6a/p61bdE1j1z+aGIZ2BQthyiaQ+sQpzW7j5BXEqs0YNxeY5p1zD77MhsCIzq
         R2WI2y2FJgmfERG9UCG3yU6ir1qAcsrBmQIjMhu3wS5yvv4/OU7HXMBEjcvQ/HOejNLs
         Ng91z1VIRPkRuXRB41YMiKVVTHs3wE7b5BXxh8UU1/iAdGl5/Us+8oG0xCRUUBmkN2Dt
         +ilQ==
X-Gm-Message-State: AOAM5330aJqTKlnZjeXHtcxYaro16CHdveoKTcR5qhGmCqLGRIcQ7KoI
        laoJ8cO/Z98NjFSJuX+CTSXwsZIMfisofA==
X-Google-Smtp-Source: ABdhPJwwbxTqKFk0fdYXja7DD6Y4xZlwx9byq4UQegdFdw4zFahcGwhCOvXeVDqwt8B3NjfryMp1FQ==
X-Received: by 2002:adf:f844:: with SMTP id d4mr24362867wrq.203.1618404174099;
        Wed, 14 Apr 2021 05:42:54 -0700 (PDT)
Received: from localhost.localdomain ([185.69.144.37])
        by smtp.gmail.com with ESMTPSA id f2sm5179912wmp.20.2021.04.14.05.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 05:42:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 1/5] io_uring: improve sqpoll event/state handling
Date:   Wed, 14 Apr 2021 13:38:33 +0100
Message-Id: <2c8c6e0710653bf6396ea011be106dcb57e175fc.1618403742.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618403742.git.asml.silence@gmail.com>
References: <cover.1618403742.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As sqd->state changes rarely, don't check every event one by one but
look them all at once. Add a helper function. Also don't go into event
waiting sleeping with STOP flag set.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 45 ++++++++++++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e3b679c5547e..693fb5c5e58c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6742,6 +6742,11 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	return submitted;
 }
 
+static inline bool io_sqd_events_pending(struct io_sq_data *sqd)
+{
+	return READ_ONCE(sqd->state);
+}
+
 static inline void io_ring_set_wakeup_flag(struct io_ring_ctx *ctx)
 {
 	/* Tell userspace we may need a wakeup call */
@@ -6796,6 +6801,24 @@ static void io_sqd_update_thread_idle(struct io_sq_data *sqd)
 	sqd->sq_thread_idle = sq_thread_idle;
 }
 
+static bool io_sqd_handle_event(struct io_sq_data *sqd)
+{
+	bool did_sig = false;
+	struct ksignal ksig;
+
+	if (test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state) ||
+	    signal_pending(current)) {
+		mutex_unlock(&sqd->lock);
+		if (signal_pending(current))
+			did_sig = get_signal(&ksig);
+		cond_resched();
+		mutex_lock(&sqd->lock);
+	}
+	io_run_task_work();
+	io_run_task_work_head(&sqd->park_task_work);
+	return did_sig || test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
+}
+
 static int io_sq_thread(void *data)
 {
 	struct io_sq_data *sqd = data;
@@ -6818,29 +6841,17 @@ static int io_sq_thread(void *data)
 	/* a user may had exited before the thread wstarted */
 	io_run_task_work_head(&sqd->park_task_work);
 
-	while (!test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state)) {
+	while (1) {
 		int ret;
 		bool cap_entries, sqt_spin, needs_sched;
 
-		if (test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state) ||
-		    signal_pending(current)) {
-			bool did_sig = false;
-
-			mutex_unlock(&sqd->lock);
-			if (signal_pending(current)) {
-				struct ksignal ksig;
-
-				did_sig = get_signal(&ksig);
-			}
-			cond_resched();
-			mutex_lock(&sqd->lock);
-			io_run_task_work();
-			io_run_task_work_head(&sqd->park_task_work);
-			if (did_sig)
+		if (io_sqd_events_pending(sqd) || signal_pending(current)) {
+			if (io_sqd_handle_event(sqd))
 				break;
 			timeout = jiffies + sqd->sq_thread_idle;
 			continue;
 		}
+
 		sqt_spin = false;
 		cap_entries = !list_is_singular(&sqd->ctx_list);
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
@@ -6877,7 +6888,7 @@ static int io_sq_thread(void *data)
 			}
 		}
 
-		if (needs_sched && !test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state)) {
+		if (needs_sched && !io_sqd_events_pending(sqd)) {
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 				io_ring_set_wakeup_flag(ctx);
 
-- 
2.24.0

