Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABBFC3274E9
	for <lists+io-uring@lfdr.de>; Sun, 28 Feb 2021 23:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbhB1WkF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Feb 2021 17:40:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbhB1WkC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Feb 2021 17:40:02 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF157C061786
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:39:21 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id w7so11853088wmb.5
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:39:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=fa6rq6wIJPH9APrmlCdd1zs3c9pGT5faco8+W2pa9F0=;
        b=Q7hhWysjMlb1GrQwKKnu3GtD7AAj6MgvkykHIWBcbgB4SrRYTUxa+sb1vuDNcDod4Y
         6CdOTKVyW9DoAfbNzmZdDDIjbEWtAbrim3r/v2Sn268e2gmsKo+GFnIagyG1bIYH+aMq
         i8/mWP8r5Dviiz79HVCzEIr8tANBW4w9Zg6YGMJlFJS++ZJ4EzYBkp31b16WfoLnCe9R
         OIPrNvIFeyTGPHRBBNjNoLA/UF5qYF80VGQMJiwrIy3t1HdcIlRO2UlriAQCG0OpR/RN
         3DgxsOuw6IrhU3e9sGGjLrZ3Ga4Z5FTh7/9GHqaKhYa9G2qXZB7SXZVLGvoswcS6/dgP
         SNvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fa6rq6wIJPH9APrmlCdd1zs3c9pGT5faco8+W2pa9F0=;
        b=LvKSX/kt1EIn1OQ1q8j5tPolOW8RQWQpPUQtuUWfAMC9RAmEVnVlJG300B5zKi++BP
         VT8grFEeI7tb7NpgRQL0dtyqdr2zrLl7qzTV50YPBDJTXvw1cwXsFwjxbtfLMudhJAoX
         zBRgc+mDBOpCEJfYbhQ7uP6/Jno1GGJDWPfcsGRKmVYSUYEP0NSeCYLgJ5AzwnmxBLun
         zbczY/j1h5wg6s1sgzTjSASx2bScBlSK2EPwhvKtyK+MqE9d12wXHcNSN6FL30jmT+4Z
         ZF50INlImCyjGsRuZPy4cKAl47jg8gER7fqetsASgjlHo67NcE3hQE5pg3W738UFJOXR
         aZiA==
X-Gm-Message-State: AOAM531zEI8uUINpQzzvNdVE6j3Pm4iG+dhjX09UkGlzQDDL5Z7WJyUf
        qhSa8VMsl/hR/Ffgy2g/AU4=
X-Google-Smtp-Source: ABdhPJxZvANIj8IQPK93Cpyz8wrOFfTNOTJOLnhrHxllmIup2nR9juP0XlKBTBh8f38jpk7I5LEk6w==
X-Received: by 2002:a1c:9a47:: with SMTP id c68mr12616133wme.63.1614551960497;
        Sun, 28 Feb 2021 14:39:20 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.38])
        by smtp.gmail.com with ESMTPSA id y62sm22832576wmy.9.2021.02.28.14.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 14:39:20 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 02/12] io_uring: reuse io_req_task_queue_fail()
Date:   Sun, 28 Feb 2021 22:35:10 +0000
Message-Id: <10157dd835235e2face0f660b705d1867f16778e.1614551467.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614551467.git.asml.silence@gmail.com>
References: <cover.1614551467.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Use io_req_task_queue_fail() on the fail path of io_req_task_queue().
It's unlikely to happen, so don't care about additional overhead, but
allows to keep all the req->result invariant in a single function.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ad2ddbd22d62..528ab1666eb5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1986,25 +1986,21 @@ static void io_req_task_submit(struct callback_head *cb)
 	__io_req_task_submit(req);
 }
 
-static void io_req_task_queue(struct io_kiocb *req)
+static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
 {
-	int ret;
+	req->result = ret;
+	req->task_work.func = io_req_task_cancel;
 
-	req->task_work.func = io_req_task_submit;
-	ret = io_req_task_work_add(req);
-	if (unlikely(ret)) {
-		req->result = -ECANCELED;
+	if (unlikely(io_req_task_work_add(req)))
 		io_req_task_work_add_fallback(req, io_req_task_cancel);
-	}
 }
 
-static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
+static void io_req_task_queue(struct io_kiocb *req)
 {
-	req->result = ret;
-	req->task_work.func = io_req_task_cancel;
+	req->task_work.func = io_req_task_submit;
 
 	if (unlikely(io_req_task_work_add(req)))
-		io_req_task_work_add_fallback(req, io_req_task_cancel);
+		io_req_task_queue_fail(req, -ECANCELED);
 }
 
 static inline void io_queue_next(struct io_kiocb *req)
-- 
2.24.0

