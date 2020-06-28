Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E3F20C756
	for <lists+io-uring@lfdr.de>; Sun, 28 Jun 2020 11:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbgF1Jy3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Jun 2020 05:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgF1Jy3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Jun 2020 05:54:29 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AEF0C061794
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 02:54:29 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id e22so10181556edq.8
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 02:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=lTU34dLQcG3OreF9+qdcFRUnBM860KdKLk4e1qaBBRw=;
        b=Z473i5zr7U6h5qVU06aod3jbphqls01WknED5v1boYnsSLoUSqwdNO0QkfiXdZRfb9
         3ghaZNg7DirC+mUQRYnIzB++3DTYtq7yFKstC3UXDIL1BsF0/RhAwWbzQIq3rJ8ztR7M
         tUGg3v8adYs69gAZYAWxOtPK4RqUXg4WQslvT8x4+Civp3oZIKQUTMUVnPOqTRXSC+sB
         +WsjLZytP993yYbgbdcJhr+wVVeo4tqcCo0ukGsqBBrGnEE8NMpN1pfd+o05Y843bJp7
         NKJDQ7WNpY6yhWk8LKuduMaWeii75TYkSLJkxiFLeLPR9p918EFuRrqgpsoNlH6328yg
         Yyjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lTU34dLQcG3OreF9+qdcFRUnBM860KdKLk4e1qaBBRw=;
        b=p9H+ue2WqockIPVnk7yIcwk+eVwGXgJcpxxfShORPyBF+rFXzGNstiPvjBInjmggET
         SZeSWgvorlFjyUjvQf6D/UYmH5ZU+98vzO0lI3U4xzXohmWP8tDe3VbGcR3g4ropQmml
         ooYVM5A1Jdciy2NzMooDeT6tRGnDTQdcZ0Jox2arc7LuTTYRccZatTYpdFOZyiRLFjps
         kcbQmUp1CqqImK4Q31vaFZo9qO80FvkmrpstbNTi5FvLgCu82gGoeBxcaRDs+1q1Xi4T
         AsGJGZqwBUXOgL4AujDQE79exGcWswc2NBOmdwZHWh10UdC572J5XmslO9msWTaC6ndh
         cCEA==
X-Gm-Message-State: AOAM533ZBjXRHaUIJn/6oqgewo04PofD0pcxaDQW1l+scCLsIy7+EfCg
        5p64CJKQgEaEykGdF3DhzS8=
X-Google-Smtp-Source: ABdhPJxHSVKef1HChLv9oZBtkD7TTdLAjYaiXC3fMqc4sFA46G/JxfrS0DVBrqEhPjDgkiJ/yDiewQ==
X-Received: by 2002:a50:afe1:: with SMTP id h88mr12011809edd.295.1593338067891;
        Sun, 28 Jun 2020 02:54:27 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id w15sm10089490ejk.103.2020.06.28.02.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 02:54:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 10/10] io_uring: fix iopoll -EAGAIN handling
Date:   Sun, 28 Jun 2020 12:52:38 +0300
Message-Id: <0925fe2fa3c9b4486ca5c24b4838c0bb44602041.1593337097.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593337097.git.asml.silence@gmail.com>
References: <cover.1593337097.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

req->iopoll() is not necessarily called by a task that submitted a
request. Because of that, it's dangerous to grab_env() and punt async
on -EGAIN, potentially grabbinf another task's mm and corrupting its
memory.

Do resubmit from the submitter task context.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 75ec0d952cb5..f4b1ebc81949 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -892,6 +892,7 @@ enum io_mem_account {
 	ACCT_PINNED,
 };
 
+static bool io_rw_reissue(struct io_kiocb *req, long res);
 static void io_cqring_fill_event(struct io_kiocb *req, long res);
 static void io_put_req(struct io_kiocb *req);
 static void io_double_put_req(struct io_kiocb *req);
@@ -1873,14 +1874,9 @@ static void io_iopoll_queue(struct list_head *again)
 		req = list_first_entry(again, struct io_kiocb, list);
 		list_del(&req->list);
 
-		/* shouldn't happen unless io_uring is dying, cancel reqs */
-		if (unlikely(!current->mm)) {
+		/* should have ->mm unless io_uring is dying, kill reqs then */
+		if (unlikely(!current->mm) || !io_rw_reissue(req, -EAGAIN))
 			io_complete_rw_common(&req->rw.kiocb, -EAGAIN, NULL);
-			continue;
-		}
-
-		refcount_inc(&req->refs);
-		io_queue_async_work(req);
 	} while (!list_empty(again));
 }
 
@@ -2388,6 +2384,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		kiocb->ki_flags |= IOCB_HIPRI;
 		kiocb->ki_complete = io_complete_rw_iopoll;
 		req->iopoll_completed = 0;
+		io_get_req_task(req);
 	} else {
 		if (kiocb->ki_flags & IOCB_HIPRI)
 			return -EINVAL;
-- 
2.24.0

