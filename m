Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4AA415601A
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2020 21:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgBGUp7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Feb 2020 15:45:59 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:46699 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbgBGUp7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Feb 2020 15:45:59 -0500
Received: by mail-ed1-f65.google.com with SMTP id m8so908083edi.13;
        Fri, 07 Feb 2020 12:45:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8t2yj5q9EDmyV/PzS9w+E0Devlu4sNU8OEv1fCxi7Ls=;
        b=kmKPQJqJX4byy1zPbV1JgfB2AeqYwq1EFSvW5fWZM20dpllWfsEKynlT5MWhtRx+cB
         RLHF6uuzoMgg9yNuvGlydqz7dOWyzVplMZecpCDFEPYV6Gp/GI1s/qdvh2XZWAtvimz8
         7dbhJ9rE+lV4u3ZLWdQfnb2mk82nrxWrpv0UlkLNnUDk++tmdtnw9MDQQZtIvfvxlSHV
         3cv7qbfvPGqR3foKK66tXg3mWY5hwmAdNbksoGWe15GUDbsSDBdC+xtMOH4WKdMeqNh7
         +zdpTQMReoqyMNWUR8nwDM3+tgi1U9Hr/TcLoZ3F+UpZabuVKG6W0OkJWhtgyr70LINq
         BQVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8t2yj5q9EDmyV/PzS9w+E0Devlu4sNU8OEv1fCxi7Ls=;
        b=PKHkKsA1buaIyYROkaY/imdqxgdFCRVF88/goJEGcu9bQqSyiGvMwVAAQnirEwOI7Z
         dCyBAp5SHZqagr8//Twh7k4vtbZ8d070ptn29krOcV2qd0mbdDU4JvGkaO4bLYA3QoRU
         o71TFwTLtq8xvYVt5tDjOtcA1T3wjEcVh5BParjBX8rpnA7m9fQliUoNdmgeO+BDamo5
         45he6RgZ5KFB97JL/S8v8bYwMu8/XFCW4EeeKL2mu6W9M7XW7ZF6P1TN95l/kzS72Ny5
         6EZEOpgyVMxeebVC7PRnfB+ACqKZghsWHFjF7I6ptEyKce6Hl7xHOYi3codyeLPX4vBk
         1Wjg==
X-Gm-Message-State: APjAAAVku042LF6UF1dvu7VzYDNQsTjkTjXc/YQ8HMiqPdxJSyMc5Nyt
        tZu4m9lxEwyw3vRJtBsgUWk=
X-Google-Smtp-Source: APXvYqwivHFX7DYKN3rWREP4pNkqIrojBHCV4maxCQqS5WyyHxgJrSH9NB/ebFTzvsckogv57SREqA==
X-Received: by 2002:a17:906:1356:: with SMTP id x22mr1078263ejb.55.1581108357533;
        Fri, 07 Feb 2020 12:45:57 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id n3sm467138ejh.74.2020.02.07.12.45.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 12:45:57 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: add cleanup for openat()
Date:   Fri,  7 Feb 2020 23:45:12 +0300
Message-Id: <d3916b5d2c04e7c0387b9dce0453f762317dd412.1581108147.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

openat() have allocated ->open.filename, which need to be put.
Add cleanup handlers for it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b0e6b3bc1aec..42b7861b534c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2547,6 +2547,7 @@ static int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return ret;
 	}
 
+	req->flags |= REQ_F_NEED_CLEANUP;
 	return 0;
 }
 
@@ -2585,6 +2586,7 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return ret;
 	}
 
+	req->flags |= REQ_F_NEED_CLEANUP;
 	return 0;
 }
 
@@ -2616,6 +2618,7 @@ static int io_openat2(struct io_kiocb *req, struct io_kiocb **nxt,
 	}
 err:
 	putname(req->open.filename);
+	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
@@ -2857,7 +2860,6 @@ static void io_close_finish(struct io_wq_work **workptr)
 	}
 
 	fput(req->close.put_file);
-
 	io_put_req_find_next(req, &nxt);
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
@@ -4233,6 +4235,10 @@ static void io_cleanup_req(struct io_kiocb *req)
 		if (io->msg.iov != io->msg.fast_iov)
 			kfree(io->msg.iov);
 		break;
+	case IORING_OP_OPENAT:
+	case IORING_OP_OPENAT2:
+		putname(req->open.filename);
+		break;
 	}
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-- 
2.24.0

