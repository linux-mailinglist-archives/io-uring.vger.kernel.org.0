Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2CAD174904
	for <lists+io-uring@lfdr.de>; Sat, 29 Feb 2020 20:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgB2TtT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Feb 2020 14:49:19 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39696 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbgB2TtT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Feb 2020 14:49:19 -0500
Received: by mail-wr1-f68.google.com with SMTP id y17so7535102wrn.6;
        Sat, 29 Feb 2020 11:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hYAMEXGO5cVVYedHxQ0SqxqcBi3GOauYjlJCDMcLs4U=;
        b=LwI0UQ8nur42CPV2gJ/rv6TexA/7yx2qlhzF6hdCoV4wCMhgGeXdSkCSTmz5CjbN3+
         gsw2w0FdAfu+Jodcb6FMl8mYVJ7nycYYDd88fUCDwjyQ/nWskKlbrZ6nXGYZknWJtIgu
         i1596rMXypskETUi//u6EoMCQOphC1mhQf1hh4O69lGKjm9FSZZKfMv3gBb5j8NMSlkI
         ECxAzvbph5dRC1EQqCdqGILdv3IKZ/W76Jp65O4/fbdolF25WX6RoR26MCTW/DIPF8gy
         PewkENq/UjSRGuX0b0wyvt73YwKOXPplHFqktzjGt9pQs0usdBMEoeT93VuQlqEtUmrq
         78CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hYAMEXGO5cVVYedHxQ0SqxqcBi3GOauYjlJCDMcLs4U=;
        b=Y29YTdOyZFbstbqV0VnGLUQ+QDAdmWRocyAz6HBUSQKQMWmsJQiWDBKVYWgw55i+sL
         //mi+dk9kdZNxK6NoABo7mWKu09ZJiWznUH0jhwZBmb71hbIDbtEkWBwkHW0iLstWvzE
         F/FGOmPc+nI5Bwm3WTcwA+D3Q36R908DC4Vkudwk0D0+hjJ7thak+dUo8sqRrUjLl2pO
         JRnQg7DpftJHd2Pb+Xm/mAJjF9vzeibqPLgIfblB/eHss4sgI4oCst1ogLKP30GCzIb1
         /EJhz9veMn3DfnzoCTIXU4u2daVU0ZHt1KlkaxIIkthJukH/V84D+Q/HTPjhMIQjGzXv
         qXoQ==
X-Gm-Message-State: APjAAAUWe47c3rfAJv+O3bJp7W1uYi1juGI6ztFLtow0SKbONErKHiKP
        v9qzl+MRrnAAXWRgyOgmsp3fnCWs
X-Google-Smtp-Source: APXvYqyA7aioZ9rx7j0tootssFvt9Uv8fQXvFET2nxu9RNdjPr78OFNhc4ec5vri+OgyGZjTSDh2SA==
X-Received: by 2002:adf:a4c4:: with SMTP id h4mr11756313wrb.112.1583005757386;
        Sat, 29 Feb 2020 11:49:17 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id j15sm19246297wrp.9.2020.02.29.11.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Feb 2020 11:49:16 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] io_uring: remove extra nxt check after punt
Date:   Sat, 29 Feb 2020 22:48:24 +0300
Message-Id: <29e9f945f8aa6646186065469ba00c0a4ef5b210.1583005578.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
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
index 8d8d93adb9c2..74498c9cd023 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4931,7 +4931,7 @@ static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
 static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_kiocb *linked_timeout;
-	struct io_kiocb *nxt = NULL;
+	struct io_kiocb *nxt;
 	const struct cred *old_creds = NULL;
 	int ret;
 
@@ -4958,7 +4958,7 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		if (io_arm_poll_handler(req)) {
 			if (linked_timeout)
 				io_queue_linked_timeout(linked_timeout);
-			goto done_req;
+			goto exit;
 		}
 punt:
 		if (io_op_defs[req->opcode].file_table) {
@@ -4972,10 +4972,11 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
 
@@ -4992,15 +4993,14 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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

