Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD4A314902A
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2020 22:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbgAXVbo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jan 2020 16:31:44 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:36142 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgAXVbn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jan 2020 16:31:43 -0500
Received: by mail-io1-f68.google.com with SMTP id d15so3451440iog.3
        for <io-uring@vger.kernel.org>; Fri, 24 Jan 2020 13:31:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0+MB13SxPrtkY53fvbOmF6I1m2+FPYNrDl1sdTj+ZD4=;
        b=zkvV+2urpJhePZ5GJFM6PMjnwb/NJxNBXBXT7o5vAla0aCD4qdHNO5eWHsCzVkURvA
         vauVaQOH+zlSm7LN7fXphJVX5uh/McHEGuUmTvPQ8NkHzKmW9aQjkuPBeYkUGMt9IAew
         yu9euS/vLosslfjv2Yjf7ipX5Hl2pmvc+LEp/5iPHmuXWJ2dQBeUd5YlpYys26398/10
         lOl6brhPYBxBnQxfkWxPGAUY3U0aBU3vbEsWMiBiUw+vHjwgEb6vbksokzZhhoJUnFY6
         +J490e/a7RDf/MJM627CdjeLI34/rFgAo8cW9ds13j/lw5DFKV0ThLe2PtPB+ObjPaVT
         d0zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0+MB13SxPrtkY53fvbOmF6I1m2+FPYNrDl1sdTj+ZD4=;
        b=jxxzk1RhvZ9vr9rgS3XEZMKYd8zi0OzP4Q5shTEXP8pTnoGyaQlyO45mb2tt08mUOP
         4kP3Na3yJDLKHQ3VtorkxCEDiR0NhzChwPPS1YWhA54cWfw5nqadLfA/NggENc9Cq/tk
         5BNDQ9f0dZ3ThLk6ZCCksQ8vfwSjxn43m6WgHZ8jiIzZTPqd5EMMMHaKxqq3pTruPsW8
         qHAFhj02tlzk6lMa/ajglk3/mSOirWGMjnZmtTImMGOlyGIb3HctAxa0Mp1LFaKZl5ME
         AszqeypEYzyYipvK+1TQYkXnxlIa0z9hCeYAtakBxRRfPsAegr3UmUqQGeaJorASoNFd
         k28g==
X-Gm-Message-State: APjAAAVSYUeEEStE3mSdWcHXkBHdWC7cnKsNABWqDtdx6KQzQsqfHQkx
        kI30h1fuJgCQQU1QoZeHIl6p+DGyx7c=
X-Google-Smtp-Source: APXvYqyqmJvNw/aEPwwqWRAuq3nqwguC+8dHg5zaXyYLtlQVLESQO77hRYjDEu7sdremVeVg11h82w==
X-Received: by 2002:a02:742:: with SMTP id f63mr4117800jaf.138.1579901503141;
        Fri, 24 Jan 2020 13:31:43 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 190sm1322705iou.60.2020.01.24.13.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 13:31:42 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io-wq: make the io_wq ref counted
Date:   Fri, 24 Jan 2020 14:31:38 -0700
Message-Id: <20200124213141.22108-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124213141.22108-1-axboe@kernel.dk>
References: <20200124213141.22108-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In preparation for sharing an io-wq across different users, add a
reference count that manages destruction of it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 4d902c19ee5f..54e270ae12ab 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -113,6 +113,8 @@ struct io_wq {
 	struct mm_struct *mm;
 	refcount_t refs;
 	struct completion done;
+
+	refcount_t use_refs;
 };
 
 static bool io_worker_get(struct io_worker *worker)
@@ -1073,6 +1075,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 			ret = -ENOMEM;
 			goto err;
 		}
+		refcount_set(&wq->use_refs, 1);
 		reinit_completion(&wq->done);
 		return wq;
 	}
@@ -1093,7 +1096,7 @@ static bool io_wq_worker_wake(struct io_worker *worker, void *data)
 	return false;
 }
 
-void io_wq_destroy(struct io_wq *wq)
+static void __io_wq_destroy(struct io_wq *wq)
 {
 	int node;
 
@@ -1113,3 +1116,9 @@ void io_wq_destroy(struct io_wq *wq)
 	kfree(wq->wqes);
 	kfree(wq);
 }
+
+void io_wq_destroy(struct io_wq *wq)
+{
+	if (refcount_dec_and_test(&wq->use_refs))
+		__io_wq_destroy(wq);
+}
-- 
2.25.0

