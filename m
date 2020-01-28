Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDBC714ACF9
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2020 01:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbgA1AHo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 19:07:44 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51079 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbgA1AHm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 19:07:42 -0500
Received: by mail-wm1-f65.google.com with SMTP id a5so602000wmb.0;
        Mon, 27 Jan 2020 16:07:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=sfAA/qYiT/suGMpN0OHev2EOKZAgTvM9ep4CJoGVYJM=;
        b=e8RbqF86UX+ebryAGa7d9lThi/fLeZpClQT5eJFBy2aYGvMFcNUbLiViGim1CvT7Rq
         NJ2thCe4La5YGqLvTLdxjPp6r1uHnNMETWFxlGFoiQg1mSErlOQ8SO4j4XLwAy9bPt1U
         +ceeYUD94N4f+0GFnuFcM/wiSyt46Fx96XB+hykG4EXjcrwW2Vqub6vl1fEeZKbV+EKa
         TaG8uqjE8Ylq4akWB6UdKl7+MbDZ/gNB2Cquz1D5oxEEX2BODLurvtKgzlKDxXl6ODuF
         dZL2V+IUfWSIi6B6J9cpEAWjRfdf/JFnY978ogYtuI1EvFLEfZ6Uga7GzcRPg9/njwZ5
         hQDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sfAA/qYiT/suGMpN0OHev2EOKZAgTvM9ep4CJoGVYJM=;
        b=eGA44iSk4Jkupe0qJ0F3TjF8ScTuhyvM2/NF4VR+Ru2B5pWZcWA2WIWFzVD9we3m5u
         Vcujw6Rv2jejNL7zB1h47y7q5LiPRBzaL+yfFMC9gbT7toR0wus1oqUlNs6dG8hhW/h9
         XsgE2d1bqCAtiDjXqyqWykBw4B5wz0gPz+tqb3id7AoW6g1q7zy1wkII+mjBCn1Ih9Qm
         I8xA1sHf/qw5ysfZRcDgNoXH4DYOkCRU+xqPGpuAChVibPYZ12DLWgjq2FtCo0qBBsR1
         B/Au46pzPFwlo6bvcLBs3RReyPY3o9WnLvgWD/qAkAXL4VEfRS1qJcCDByo3LSTzS7ev
         Gvmg==
X-Gm-Message-State: APjAAAVV9qkBHCKxMT0lkc1JUB4ZcDi3o53kNYmIwJDdIVlG/WmkmNVl
        y9Qyen8cmjEE89n4jil+fkP+Tp7L
X-Google-Smtp-Source: APXvYqzPU1Orfrko8V+PgN+6ait1X3qIQNIqrFr7R7RB6TT3HjzTqVL/r4SSaTmFSEE1Cg+PDJBdLw==
X-Received: by 2002:a7b:c85a:: with SMTP id c26mr1162479wml.107.1580170060145;
        Mon, 27 Jan 2020 16:07:40 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id y20sm577193wmj.23.2020.01.27.16.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 16:07:39 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] io-wq: allow grabbing existing io-wq
Date:   Tue, 28 Jan 2020 03:06:51 +0300
Message-Id: <404c434402d7a41a80f1e4f6bb7dc3ef9123f493.1580169415.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1580169415.git.asml.silence@gmail.com>
References: <cover.1580169415.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If the id and user/creds match, return an existing io_wq if we can safely
grab a reference to it.

Reported-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 10 ++++++++++
 fs/io-wq.h |  1 +
 2 files changed, 11 insertions(+)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index b45d585cdcc8..36d05503b982 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1110,6 +1110,16 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	return ERR_PTR(ret);
 }
 
+bool io_wq_get(struct io_wq *wq, struct io_wq_data *data)
+{
+	if (data->creds != wq->creds || data->user != wq->user)
+		return false;
+	if (data->get_work != wq->get_work || data->put_work != wq->put_work)
+		return false;
+
+	return refcount_inc_not_zero(&wq->use_refs);
+}
+
 static bool io_wq_worker_wake(struct io_worker *worker, void *data)
 {
 	wake_up_process(worker->task);
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 167316ad447e..c42602c58c56 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -99,6 +99,7 @@ struct io_wq_data {
 };
 
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data);
+bool io_wq_get(struct io_wq *wq, struct io_wq_data *data);
 void io_wq_destroy(struct io_wq *wq);
 
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work);
-- 
2.24.0

