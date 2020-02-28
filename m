Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD7217434D
	for <lists+io-uring@lfdr.de>; Sat, 29 Feb 2020 00:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgB1Xij (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 18:38:39 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40191 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbgB1Xii (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 18:38:38 -0500
Received: by mail-wr1-f65.google.com with SMTP id r17so5063242wrj.7;
        Fri, 28 Feb 2020 15:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=+Glx8OEy4WN7rEwyGGSI/EOqZCDmmoWs4N7V708Yku8=;
        b=alEksy9KLC4+bvVBJPx/uf7o9pA0YjfFQP/uwTuzvIof7YR6PpiaHtG3F9kYYRUih6
         MRc7Am/ijV8cqfjjLpN3CigZNltCHe1SBT13XjJ9SV3MRWuVig4wIpMgyq62KugkRSU2
         kbbR9Kd+jxODuxFjcvkKM48pAJkf4Wmp+yo1So09eQLPs5hp4V8jOrJzMuO2rpeVA6bn
         TkQgQE6Ms68kbXcJUHnguGQHNEEIRM4awGoHmluAgjn+7aAJkEb2pDx7o/YSED9APa2t
         S6esP7A78LnG43n/fNPmRxOgP6aBH50tIt/Z5fN0eS+0U4ul5jDHUygAvIRUYJ5qQAJx
         2TWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Glx8OEy4WN7rEwyGGSI/EOqZCDmmoWs4N7V708Yku8=;
        b=HcdmRnCUsEt30QiY/+VIHSd90gN5XjAKNM9vAH1CI+Rj+7ib88lWtrjLaNmA13Hw6e
         MOlIerIKQo9eO8/Hyl3uWkubmgMPPbRbFAnLm/6E7jNLoc7RFTs5yw0b3/s1t0v4I+41
         WD/cwQ0fQGnwJIm0uXK78nR5U8FrNm90+GhuJ50PCpFBiHFuAzG5NoKorKJjUJi//mju
         eMOvDCu5N6/ZymmrflPlpQ0bZm2UCZcgzjN2wC35fa9J2nKwGdvpFERsS3f7YzT7pZrD
         F9afR3HeRalAv6O/GzD3yEbn0Rr0VRl8tY8l9TNrT5pESusZJDoDrRN2++SbjJe60cng
         pI8w==
X-Gm-Message-State: APjAAAU6IcWkt/J1zls19q891FuVZSOdxLSe9a92Wto2pnF9saePFS0a
        p7U6wMqBcKwhjIGebo82kKwRsZKa
X-Google-Smtp-Source: APXvYqxR0cbRX72MDR23tKnss/LIKG6Xxe9920IjN7jhgZtfy/vexD03bsT0QxqkH4ULkplWNehLOg==
X-Received: by 2002:adf:ed42:: with SMTP id u2mr6990818wro.345.1582933116810;
        Fri, 28 Feb 2020 15:38:36 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id q1sm13762512wrw.5.2020.02.28.15.38.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 15:38:36 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/5] io_uring: remove extra nxt check after punt
Date:   Sat, 29 Feb 2020 02:37:28 +0300
Message-Id: <bd29d6761e2520e1da7a1446c62d7e52f25aa653.1582932860.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1582932860.git.asml.silence@gmail.com>
References: <cover.1582932860.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After __io_queue_sqe() ended up in io_queue_async_work(), it's already
known that there is no @nxt req, so skip the check and return from the
function.

Also, @nxt initialisation now can be done just before
io_put_req_find_next(), as there is no jumping until it's checked.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5a579f686f9e..cefbae582b5f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4857,7 +4857,7 @@ static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
 static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_kiocb *linked_timeout;
-	struct io_kiocb *nxt = NULL;
+	struct io_kiocb *nxt;
 	const struct cred *old_creds = NULL;
 	int ret;
 
@@ -4884,7 +4884,7 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		if (io_arm_poll_handler(req)) {
 			if (linked_timeout)
 				io_queue_linked_timeout(linked_timeout);
-			goto done_req;
+			goto exit;
 		}
 punt:
 		if (io_op_defs[req->opcode].file_table) {
@@ -4898,10 +4898,11 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		 * submit reference when the iocb is actually submitted.
 		 */
 		io_queue_async_work(req);
-		goto done_req;
+		goto exit;
 	}
 
 err:
+	nxt = NULL;
 	/* drop submission reference */
 	io_put_req_find_next(req, &nxt);
 
@@ -4918,15 +4919,14 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		req_set_fail_links(req);
 		io_put_req(req);
 	}
-done_req:
 	if (nxt) {
 		req = nxt;
-		nxt = NULL;
 
 		if (req->flags & REQ_F_FORCE_ASYNC)
 			goto punt;
 		goto again;
 	}
+exit:
 	if (old_creds)
 		revert_creds(old_creds);
 }
-- 
2.24.0

