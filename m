Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30B0F18EAE3
	for <lists+io-uring@lfdr.de>; Sun, 22 Mar 2020 18:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbgCVReW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Mar 2020 13:34:22 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42487 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbgCVReW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Mar 2020 13:34:22 -0400
Received: by mail-wr1-f67.google.com with SMTP id h15so1637871wrx.9;
        Sun, 22 Mar 2020 10:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=cQ7HYMFbbKAuDCMOfbn6HqKEoBXsMZuFfeRp8Yh61Ok=;
        b=UustbaFUhoIub2rOK6HQ+QJ3QiUqiOPp4lEhc11koY0aJfLjlS9hNdXf4IoGv/ID9m
         wtC7boPwQvl5NlI+CB1IelqUUiL/3AX4bCSKsQgZ+W5J9a/LXxJI8h3rtOyGGBE554H9
         1rZ7abibNGBYKHhCbx6dt4jMdbnchwmTUpFTdHVxVvlsNbIQ6JVJK9sy8V7F2laxU7tx
         J++nNIZwuxTwrbQ9TaR/AVEgRe2celCLlfoMnvNJ4l+ILzw8i3YtgLonvJrC2APyZ8SC
         0WzoH6MECDTiiJxOx7J4fVz7+aWgqZS4kI/2Jku74H2jYRVcRHsGbgvBNEKubDxMw+IJ
         xELg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cQ7HYMFbbKAuDCMOfbn6HqKEoBXsMZuFfeRp8Yh61Ok=;
        b=WI7cadNz7wyu8BK/HdG11UPfDPsOiklKNyz1nQ1EYsZTUwjgcw1VMjj5DrDACFFmHQ
         klTnsmEYwHj5XNfDusjxa6J3BBTFtXfP1QkQSUleKuLFp8n5oMSp9+EkRCWC54I2dGtk
         ENEFIKf4Z4lWakr7rrmd043iopD7OD+D9/Orgwd3Do+S1p4cgmj+NHJSC1mMhbOvccj2
         rWjA3/ByG2JpvyVlq7yny5DyTnO2eXN/kTG39h2p6Cgpmus+HQQ0BoGXXP1KxrfUKplr
         LCtXkd36v9D4bDci0v5bBl/r4JF5LmrSTDIFEJNAF46xjEA61AWVn9BQscbTSIt0EnL1
         CapA==
X-Gm-Message-State: ANhLgQ11UDWSVggbqyJIdyZ+CLBsJrTbbU+gJx2HH++kXw8lXkXFxjg+
        GnFd4eEmVF+5bVHZCvKDb3Q=
X-Google-Smtp-Source: ADFU+vs6xFWgxOsPlZz4IW1uYgigFjNLcWueKdt7J01toef8xawT7hnF+aF+CIipF1uCl3oKBPTHRw==
X-Received: by 2002:a05:6000:1184:: with SMTP id g4mr24816792wrx.396.1584898459650;
        Sun, 22 Mar 2020 10:34:19 -0700 (PDT)
Received: from localhost.localdomain ([109.126.140.227])
        by smtp.gmail.com with ESMTPSA id t21sm5245948wmt.43.2020.03.22.10.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2020 10:34:17 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] io-wq: close cancel gap for hashed linked work
Date:   Sun, 22 Mar 2020 20:33:16 +0300
Message-Id: <c38a2421e15e3aaa5c55e3e0d7ddca4c77d178e1.1584898199.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <c7f352b4-0255-d87a-1fb4-0b55984df137@kernel.dk>
References: <c7f352b4-0255-d87a-1fb4-0b55984df137@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After io_assign_current_work() of a linked work, it can be decided to
offloaded to another thread so doing io_wqe_enqueue(). However, until
next io_assign_current_work() it can be cancelled, that isn't handled.

Don't assign it, if it's not going to be executed.

Fixes: 60cf46ae605446feb0c43c472c0 ("io-wq: hash dependent work")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 9541df2729de..b3fb61ec0870 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -485,7 +485,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 	struct io_wq *wq = wqe->wq;
 
 	do {
-		struct io_wq_work *work;
+		struct io_wq_work *work, *assign_work;
 		unsigned int hash;
 get_next:
 		/*
@@ -522,10 +522,14 @@ static void io_worker_handle_work(struct io_worker *worker)
 			hash = io_get_work_hash(work);
 			work->func(&work);
 			work = (old_work == work) ? NULL : work;
-			io_assign_current_work(worker, work);
+
+			assign_work = work;
+			if (work && io_wq_is_hashed(work))
+				assign_work = NULL;
+			io_assign_current_work(worker, assign_work);
 			wq->free_work(old_work);
 
-			if (work && io_wq_is_hashed(work)) {
+			if (work && !assign_work) {
 				io_wqe_enqueue(wqe, work);
 				work = NULL;
 			}
-- 
2.24.0

