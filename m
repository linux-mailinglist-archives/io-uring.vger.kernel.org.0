Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42BD11563EF
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2020 12:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbgBHLFi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 8 Feb 2020 06:05:38 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34197 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbgBHLFi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 8 Feb 2020 06:05:38 -0500
Received: by mail-ed1-f68.google.com with SMTP id r18so2519273edl.1;
        Sat, 08 Feb 2020 03:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yh/uyeitSR5SJlo6CAAtps2m8rKm/nPDM0/76PHBJzY=;
        b=rSzL+NmPg3EJG4QVCxm+hdFUGzOkgBRLCe/w6OI0Q+iqQ2LVpYA33ppCCD/XSkRF0Q
         IgAkeC0A0fKSWAZIo1VjmbbfTWZFhPXKs8eypozqV3EOSfB0Dqt4hcJs7aiwdHPJRXhc
         jtFIqsYQGBGoPIx1A3DthUD8THjZYatpxHI6zyVT8x6FAsJRpyVdnoAIlAfFRALAp/mW
         CIXWKZtZB+Hx5ONIlOoQl3ceShoV5YFYCBfwBdTEIsDjaBoYBidqrS11mfhV7HthbzAM
         eURyiTNjX2ybR97HMwbWZYTklnFMHUa2QWm2oxpGe1r2Rk72T6TD1eAYvXHv5NnYEHq9
         7fMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yh/uyeitSR5SJlo6CAAtps2m8rKm/nPDM0/76PHBJzY=;
        b=K33vMa3SajYJn4pc023NZfaMFZy/hmc/pi9qsihiq5QDi7xpi7SxnABChdhPrZjI+L
         wLphsXnihzzmCoxp009dwWp2lTErR62ewmoin8FByanhimD4gjI8DKNTiuLdYAn0gQsF
         eXrFpsl4Auj+VrSqUuBsTKWUpgkiKOmZQp3sW3hMigD+pDHqMbcxM2+LoEDZHC6OriGn
         vj6wFuU9EiPx34w+z78Qy8E0F67i3GfPi/QPrm6TGdlco1lDqFzFwWe7aGs464i/pGk/
         zOCMjqj8LL7nf8ca0jda/wnpuxXZZ3d36q4KK62/rVWulgIssWievfF/M0kmlstOBxuE
         pvWw==
X-Gm-Message-State: APjAAAUARXNQHveDiyiQ8DVg9bObuSddm50/jLLmkeU0F8IUYiNsZUrU
        7ypPz4Xi4IDNb+V+sl2XL8k=
X-Google-Smtp-Source: APXvYqxNsTZTtT29QJ3i4wsKuvIcjtF1Kkl6ce0zGXzYza/qwQa2uY9a49H8/NSqxM0wprKRPbVP4A==
X-Received: by 2002:a05:6402:12d1:: with SMTP id k17mr2852184edx.291.1581159936289;
        Sat, 08 Feb 2020 03:05:36 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id qk16sm617058ejb.71.2020.02.08.03.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Feb 2020 03:05:35 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] io_uring: fix async close()
Date:   Sat,  8 Feb 2020 14:04:34 +0300
Message-Id: <6ab2ba6d202439323571ab6536025df0dd8b167e.1581159868.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

First, io_close() misses filp_close() and io_cqring_add_event(), when
f_op->flush is defined. That's because in this case it will
io_queue_async_work() itself not grabbing files, so the corresponding
chunk in io_close_finish() won't be executed.

Second, when submitted through io_wq_submit_work(), it will do
filp_close() and *_add_event() twice: first inline in io_close(),
and the second one in call to io_close_finish() from io_close().
The second one will also fire, because it was submitted async through
generic path, and so have grabbed files.

And the last nice thing is to remove this weird pilgrimage with checking
work/old_work and casting it to nxt. Just use a helper instead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 44 ++++++++++++++++----------------------------
 1 file changed, 16 insertions(+), 28 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c3bac9d850a5..b18022b0c273 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2854,23 +2854,25 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
+/* only called when __close_fd_get_file() is done */
+static void __io_close_finish(struct io_kiocb *req, struct io_kiocb **nxt)
+{
+	int ret;
+
+	ret = filp_close(req->close.put_file, req->work.files);
+	if (ret < 0)
+		req_set_fail_links(req);
+	io_cqring_add_event(req, ret);
+	fput(req->close.put_file);
+	io_put_req_find_next(req, nxt);
+}
+
 static void io_close_finish(struct io_wq_work **workptr)
 {
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
 	struct io_kiocb *nxt = NULL;
 
-	/* Invoked with files, we need to do the close */
-	if (req->work.files) {
-		int ret;
-
-		ret = filp_close(req->close.put_file, req->work.files);
-		if (ret < 0)
-			req_set_fail_links(req);
-		io_cqring_add_event(req, ret);
-	}
-
-	fput(req->close.put_file);
-	io_put_req_find_next(req, &nxt);
+	__io_close_finish(req, &nxt);
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
 }
@@ -2893,22 +2895,8 @@ static int io_close(struct io_kiocb *req, struct io_kiocb **nxt,
 	 * No ->flush(), safely close from here and just punt the
 	 * fput() to async context.
 	 */
-	ret = filp_close(req->close.put_file, current->files);
-
-	if (ret < 0)
-		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-
-	if (io_wq_current_is_worker()) {
-		struct io_wq_work *old_work, *work;
-
-		old_work = work = &req->work;
-		io_close_finish(&work);
-		if (work && work != old_work)
-			*nxt = container_of(work, struct io_kiocb, work);
-		return 0;
-	}
-
+	__io_close_finish(req, nxt);
+	return 0;
 eagain:
 	req->work.func = io_close_finish;
 	/*
-- 
2.24.0

