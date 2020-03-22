Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11C9418EA18
	for <lists+io-uring@lfdr.de>; Sun, 22 Mar 2020 17:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbgCVQPi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Mar 2020 12:15:38 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33512 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbgCVQPi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Mar 2020 12:15:38 -0400
Received: by mail-wr1-f68.google.com with SMTP id a25so13648072wrd.0;
        Sun, 22 Mar 2020 09:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dYEAGywc3sKy6VK1CPH4F8NN5656DQLq2EzqYJV/ulM=;
        b=NBTufxsrCQO6z8iFuT8T18U3zVogZEW3K7OOaCf+fufNvIZrRLjH8OMMoF2OOO4RWx
         DlpcPNDYv1/mjlBgkalGHhMyYTnBmsMU9OnMEkUWoXQZdlw9r2XzibRzjO9FObFGLEOL
         jed+rGOO5x5pVSpzOf0bx5gnZI+3NBvkwpwZRbnhp9FKcWgbDBmehEQD2uz4oHt/4tvk
         f1pxdKaCSjzpOr7+J51T4yYbyIHArtpppokNe0ie2kD5PBleOkSUBRGI6emzleoCCE+1
         kv22QGiutxsed9+yvgnr07nwjdlCniazvLpxHGgpYd8vHzLCr6K1k3+BALFvXpqfqioe
         Fs4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dYEAGywc3sKy6VK1CPH4F8NN5656DQLq2EzqYJV/ulM=;
        b=kEvSO5+53Jw582Vd6ClHvLja5IXxY5Dp3c/alMrl/gPnGsXXU6m5bhjTkJBqzjEO/X
         PF7UVqe7SM0pSfPn7MMw6JdD4K1VjbessfEZrAuhBB/XEgaRi2DEiSXnLHTl4rCqBZ0a
         YojSQGu2SHFGdODIxV+7KYzmzRYwhjvWsvA6wfijnN9nLApmpVL2kRo9Ia503QJq6oO0
         Hy9upmDX2A8dMlmh0/gbNbcTqi5BytkVem4uzqtW+waE8voAmIFBY/PdY0+ursaZ/60h
         mLZY/ktbhB8Eod1h0ek+QaCQwW1Bt6TZCZiMWNz9HV7z9ukGs8myu1ebbNZvQ4c0QI0L
         g9Wg==
X-Gm-Message-State: ANhLgQ0sS7FjT+slrLscMtGSLX8LamgvTtER7FoDWrreA9OemSSw6dQD
        dhKlwx1Mv0rTDm2AN2FnsLcizXS3
X-Google-Smtp-Source: ADFU+vsRcBwWTYsRdZEsYv42CXHuGjwd0bF7Rin9njyUTNdGbJcV8kcAmciAsTxz7p2kZkaHbu73Fw==
X-Received: by 2002:a5d:4091:: with SMTP id o17mr8991126wrp.254.1584893735117;
        Sun, 22 Mar 2020 09:15:35 -0700 (PDT)
Received: from localhost.localdomain ([109.126.140.227])
        by smtp.gmail.com with ESMTPSA id 71sm3229317wrc.53.2020.03.22.09.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2020 09:15:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] io-wq: close cancel gap for hashed linked work
Date:   Sun, 22 Mar 2020 19:14:26 +0300
Message-Id: <b9bc821a0ff3bc52a60281d8a9005dff93f6dcc3.1584893591.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
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

