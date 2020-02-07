Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20D20156065
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2020 22:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgBGVA4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Feb 2020 16:00:56 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:34778 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727541AbgBGVA4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Feb 2020 16:00:56 -0500
Received: by mail-ed1-f67.google.com with SMTP id r18so1032707edl.1;
        Fri, 07 Feb 2020 13:00:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TH30XcDljbb3cc4G8ZH3TIkpU0Am5B5uRjuKrS3D0PQ=;
        b=AdTy/8DU0CcwUdMQgXqwbpHBEmxsWq3AU6st3q2hlteJ1w1gNSjzXb7p1uB+1fScz5
         8pxRgk1ekYv+mEUi/+WOaNd3zabhgHG9WhurZpu48CwXOKeekb8YriZWonQQE8NPUVCJ
         wF8z+BLrDmAkn7CSw8ygZnIUOemOP3BrFAvvryliHlzhVV0cITZKH90LduwlLr4ZzuT2
         lgCUdLHJ0TrpcbhFel3hmmCuFUwV9RgWarcL2VwYztTGLiZFOx01Mim7dnTk+Sz9uSr1
         0a17xs3dqZVOQa+daJY1aGRZkjx/uNjKPZqcluFmwykH5d2tTeGWNFe3K5zKuhm0zedD
         VUBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TH30XcDljbb3cc4G8ZH3TIkpU0Am5B5uRjuKrS3D0PQ=;
        b=cPqAjIiRy56uyjtnGEvPed7GlIm/wY8ERxzvnaOOpjGJVfMdp6ArPThC0BHLODt+bN
         4+CAQVFz91fF6vL55FJn7Wd2E5AxQfdj5CxAm3AZV9nUtwVhTTD/EZEpE0sDGwhXIByD
         MXtJuIsCWhZTrzRP8xBDRHNlD2fm6Gr7I/ISMMGOx7zWAsOdnQQSlHbkfAzXDtB4fPTq
         uXSqOjfhsWBYnVD9b0/Tr20XH+I91I+atxvOraUG4xgkor0KtTy7GpYLsQUQaBybZ7M/
         cbrjrgxm7xH8EsSr6OrcEOaHtP9ijhhkF56k2kfHCcqiytEkJH0BuL2+NO6IkIIeljW6
         C/ig==
X-Gm-Message-State: APjAAAVJbBYlrIujL/aNUXqrr8dO7SjUltkzdD8RcPTwsqq/rqZbuyGc
        kM9omtwVcaaTDtaxV9fyeuVtWwcI
X-Google-Smtp-Source: APXvYqxuRp0/fSgBOh8sKtSt8CM5eM0zrEiVCXcC0QVf825aZA7OXRAB8/3VQmpvQhYIp2OXWIGZbg==
X-Received: by 2002:a05:6402:1a25:: with SMTP id be5mr767954edb.220.1581109254175;
        Fri, 07 Feb 2020 13:00:54 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id a12sm479011eje.70.2020.02.07.13.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 13:00:53 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] io_uring: add cleanup for openat()/statx()
Date:   Fri,  7 Feb 2020 23:59:53 +0300
Message-Id: <b55d447204244baca5a99c53fb443c20b36b8c0e.1581109120.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

openat() and statx() may have allocated ->open.filename, which should be
be put. Add cleanup handlers for them.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: add handler for statx (Jens)

 fs/io_uring.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b0e6b3bc1aec..1698b4950366 100644
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
@@ -2775,6 +2778,7 @@ static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return ret;
 	}
 
+	req->flags |= REQ_F_NEED_CLEANUP;
 	return 0;
 }
 
@@ -2812,6 +2816,7 @@ static int io_statx(struct io_kiocb *req, struct io_kiocb **nxt,
 		ret = cp_statx(&stat, ctx->buffer);
 err:
 	putname(ctx->filename);
+	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
@@ -2857,7 +2862,6 @@ static void io_close_finish(struct io_wq_work **workptr)
 	}
 
 	fput(req->close.put_file);
-
 	io_put_req_find_next(req, &nxt);
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
@@ -4233,6 +4237,11 @@ static void io_cleanup_req(struct io_kiocb *req)
 		if (io->msg.iov != io->msg.fast_iov)
 			kfree(io->msg.iov);
 		break;
+	case IORING_OP_OPENAT:
+	case IORING_OP_OPENAT2:
+	case IORING_OP_STATX:
+		putname(req->open.filename);
+		break;
 	}
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-- 
2.24.0

