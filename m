Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 129B617428F
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2020 23:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgB1WyQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 17:54:16 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50180 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbgB1WyO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 17:54:14 -0500
Received: by mail-wm1-f67.google.com with SMTP id a5so5104417wmb.0;
        Fri, 28 Feb 2020 14:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=82z5Vm/880IAwHFGSxJnDkRQbbXkss7yfdi6YjXeO9A=;
        b=KJ7MypaKdDDqW43rvxipHinIYYvrd0/DABtltZN4t7DBHs8qyy5PgdqlnlCf8hIqXd
         19q8znthyNOYwX3aBTD7BLkzaOlUjDkMmO7p1UeDgFnAEAlZjSREhqxdnOdivZvSP1qK
         0QwXohrxANdoIUWt/hbddzvRvmvTZWgRRQBDqBe8OBp8TmNr4LjjGIwnlMN/DVC4VZqd
         FGPLT6HU4CaI1wG4pl/fPfeMKJL/2SkNs+pB7Pinjj1sMTqRwM/lwXVLYjirjB/CzOIl
         LS8/5AjEJcwdQTmNp8uv+TfDwDED31bi9tl49w6EKKfSyGJppGbSY+24uoAgzZRKWU4c
         w7jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=82z5Vm/880IAwHFGSxJnDkRQbbXkss7yfdi6YjXeO9A=;
        b=oS6wu+7aU53w3hpea4yYFEzUEtRCyBhbqw0F868YCcYfsMIRyv6CsSiJKoaLF66Gqq
         ORdXJ5qOdMTyaTuKy8joHo6stgWn0bb0Nt7Pe8MDVFboMKsdnOE3tc4XJSwMN0mVQRSI
         oEnY7060nN4h5/EMmnDKaoCrvRmQeZLMDp1SSWITAwSYrqrmfnzB866A+GabPsRugmgU
         01fWhHTpGzxYHXY6wr9a57v9pucfyGN2VB1bbckamb3Q7NqsGsRTHKGenP7tR8Q8LxKn
         xvbLFE7V6QdTNN/hESb5xfmqy+7R7HyjBH+itK4n6HYr2b2Hv3vXly+rChzUSDRuAqGt
         9KXw==
X-Gm-Message-State: APjAAAUgeH7WBw+t2K0FaStQ1+wNzfK7oLNGxJ/QH6kynbJ6V8Vyjp50
        zVD7VJlU2SwmZ3wZlso3HzFL733C
X-Google-Smtp-Source: APXvYqyQqcqAwNEtEdQy2snNtdXmfhQZJM95YkLo4IP3NrlWR7om7zN5DxGgOJQHZAVFzSm1ZOLlxg==
X-Received: by 2002:a1c:1d90:: with SMTP id d138mr6472940wmd.163.1582930452760;
        Fri, 28 Feb 2020 14:54:12 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id f1sm14603773wro.85.2020.02.28.14.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 14:54:12 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] io_uring: remove extra nxt check after punt
Date:   Sat, 29 Feb 2020 01:53:10 +0300
Message-Id: <1a53cab54012aee6d015e411b30363c50c2725bc.1582929017.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1582929017.git.asml.silence@gmail.com>
References: <cover.1582929017.git.asml.silence@gmail.com>
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
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9b220044b608..3017db9088cd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4751,7 +4751,7 @@ static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
 static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_kiocb *linked_timeout;
-	struct io_kiocb *nxt = NULL;
+	struct io_kiocb *nxt;
 	const struct cred *old_creds = NULL;
 	int ret;
 
@@ -4787,10 +4787,11 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
 
@@ -4807,15 +4808,14 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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

