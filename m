Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D692B14748B
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2020 00:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbgAWXQV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jan 2020 18:16:21 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41393 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbgAWXQV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jan 2020 18:16:21 -0500
Received: by mail-pl1-f195.google.com with SMTP id t14so2013508plr.8
        for <io-uring@vger.kernel.org>; Thu, 23 Jan 2020 15:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5aSwlQZ5CtqL0+5ZNX0lqdcTD+iBpemv7w2MDplPync=;
        b=y89z+wo/vSUs1bWemRRftldbsk1uPD4YtsfhTGwDcMLexFyebPOOa37IffRyKxnKPd
         brY8VdnvmX9M2VOSrPLysPGoxFy25opzOTHsFjFcMyLkKD0skfa5gY3Ate3p15nD33uK
         ZhUVO7JiN3fEvLdrxhRbNgstU/IGPOR1t1mGj/CsWtIkdUZFgyAmfNQ2NOfv1nkhjky5
         PVCPXaxD8Qkqh4c/nWxIoHSxL+S9OoNMKP2NyCvH15YDB0UiMVpZT9NZrsUiA2rtUdpO
         cwjXV53bAyTM6hVismrmxdKMf455U769PzPHQNRqHOeBB3bvHQ4rQHypPwBvdEYGyP89
         7NvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5aSwlQZ5CtqL0+5ZNX0lqdcTD+iBpemv7w2MDplPync=;
        b=I3fToRjYDGiWRzCcYPalFdAq0jGCXUoELdJXYP5vAdhVd/S35KbzIFRFTgX8jgwJAF
         Z0y1/7zbjl42pO9GhYgJLT9Ya5iIKivBOMfTrPqFZVjnB+o25zGyGgHvYyGU1TtgyM9Y
         Xc01vfDUt9QTRQ90VnIW7D1eL5O/179s26leymqm/jq1XBLMfAMyrMzhx0fEm2bdIOsQ
         6MSwUINfe65wmH3RaBglisJhaxtfFxzeUF0FjEGF3L/IH+gA4sK3/1nBDzjf4Oa0lqUG
         PnG3TIK/3TqrymEdmP+LPTHFFoVX7dFm43RujfJ0afzOKRLKbB3KQ/O0RZ7YZ5lGWmRt
         GUgg==
X-Gm-Message-State: APjAAAWvZaE73FzgkMkQ7YpWKQcVSswUy4VPdj+/uZa2bC7Q/Qfbr5cI
        G8Y4Bcm9VX0Tj6m0u0TkxmO9IkfDSYd16g==
X-Google-Smtp-Source: APXvYqzHVZbalOAAA+aVuKyR4Xvy3iBU+U0gKraCjClKr4ZQmuDl20KD+6tH79eziogcu4G3SNHmUA==
X-Received: by 2002:a17:90a:9bc3:: with SMTP id b3mr100775pjw.76.1579821380040;
        Thu, 23 Jan 2020 15:16:20 -0800 (PST)
Received: from x1.thefacebook.com ([2600:380:4513:6598:c1f4:7b05:f444:ef97])
        by smtp.gmail.com with ESMTPSA id u127sm3766627pfc.95.2020.01.23.15.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 15:16:19 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io-wq: add 'id' to io_wq
Date:   Thu, 23 Jan 2020 16:16:12 -0700
Message-Id: <20200123231614.10850-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200123231614.10850-1-axboe@kernel.dk>
References: <20200123231614.10850-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add each io_wq to a global list, and assign an id for each of them. This
is in preparation for attaching to an existing io_wq, rather than
creating a new one.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 54e270ae12ab..8cb0cff5f15c 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -16,9 +16,14 @@
 #include <linux/slab.h>
 #include <linux/kthread.h>
 #include <linux/rculist_nulls.h>
+#include <linux/idr.h>
 
 #include "io-wq.h"
 
+static LIST_HEAD(wq_list);
+static DEFINE_MUTEX(wq_lock);
+static DEFINE_IDA(wq_ida);
+
 #define WORKER_IDLE_TIMEOUT	(5 * HZ)
 
 enum {
@@ -115,6 +120,8 @@ struct io_wq {
 	struct completion done;
 
 	refcount_t use_refs;
+	struct list_head wq_list;
+	unsigned int id;
 };
 
 static bool io_worker_get(struct io_worker *worker)
@@ -1019,7 +1026,7 @@ void io_wq_flush(struct io_wq *wq)
 
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 {
-	int ret = -ENOMEM, node;
+	int ret = -ENOMEM, node, id;
 	struct io_wq *wq;
 
 	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
@@ -1076,6 +1083,16 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 			goto err;
 		}
 		refcount_set(&wq->use_refs, 1);
+
+		id = ida_simple_get(&wq_ida, 1, INT_MAX, GFP_KERNEL);
+		if (id == -ENOSPC) {
+			ret = -ENOMEM;
+			goto err;
+		}
+		mutex_lock(&wq_lock);
+		wq->id = id;
+		list_add(&wq->wq_list, &wq_list);
+		mutex_unlock(&wq_lock);
 		reinit_completion(&wq->done);
 		return wq;
 	}
@@ -1119,6 +1136,12 @@ static void __io_wq_destroy(struct io_wq *wq)
 
 void io_wq_destroy(struct io_wq *wq)
 {
-	if (refcount_dec_and_test(&wq->use_refs))
+	if (refcount_dec_and_test(&wq->use_refs)) {
+		mutex_lock(&wq_lock);
+		ida_simple_remove(&wq_ida, wq->id);
+		list_del(&wq->wq_list);
+		mutex_unlock(&wq_lock);
+
 		__io_wq_destroy(wq);
+	}
 }
-- 
2.25.0

