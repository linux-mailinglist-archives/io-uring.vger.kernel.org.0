Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 883F614902B
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2020 22:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgAXVbp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jan 2020 16:31:45 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:39066 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgAXVbp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jan 2020 16:31:45 -0500
Received: by mail-io1-f65.google.com with SMTP id c16so3440133ioh.6
        for <io-uring@vger.kernel.org>; Fri, 24 Jan 2020 13:31:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6p7BJv/F5TPA6fYQeYzH4I2EeBKpTbJOSKWf/TBlffo=;
        b=zLZHKaQigxXCeF5+9Ek5Hwl8WOIOZSauP69yOr3RagRZg9NrfP+6uV5OyXK3nKv2fT
         UAC+PzqoTKEaFZmxA9W5JQBImIaRoX7TNdyz2ZLm3G34m+AKdKFF9YoKdPXzunB/VTyv
         lZqchwppOW0urk2A8vv4kKCTeolQqPRKKHr1wkCKXkM78PxbVmDcSqd/1aQh3GigIhBi
         Jv9vTpuIKBc5rAXZBy7hma2flieE0byks9idiC9Mtgy0DdkZDyXTGWx+xDgJT+oPjGHK
         OavOHj5yVCRiYQNuNY71XMVr1BXEttMUtm1pf1l+N8luh0W/KgUzbUphsdxF5vudptxi
         CQLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6p7BJv/F5TPA6fYQeYzH4I2EeBKpTbJOSKWf/TBlffo=;
        b=DTbR4BOYfSlTuxmrfC/Juon2YhDqTHfzyCf1sRasy24XhbmS9/naW/L2YYImEbn48T
         MvDtmPmJg+QirinrYijGEVa51/VvO03EfvvDGec7IOOCo9yGfIhAA/Ah2G4qPaXv2o8C
         2xzZR1KiXyvA3I0tmtZgZCxM59XGHtjcte4J6CBMPbJH+xzDo+v/mDHZKmjcKcfC3TwA
         6Xe22ZKdOCtVWEXvbXQXMlJ1TVmB4V9tLDwJsu4TBjNYG9zmHZzLoMcOwr5ZX0Ws58kk
         +HQ5rcU51NafeFPPBpAw3VqlXWDB4Q7KwYuJx1yhl4JjZ4HkAxjYgVo4Y840Dgi4jOp7
         69tg==
X-Gm-Message-State: APjAAAV/VvSFSLWWhyLm9aJG+7Tht/RlJJ/u5aPaAFLC0fBj05UDAxyh
        5d+lGNeKF7JnbgzFFgY2ybn4XDUTdx8=
X-Google-Smtp-Source: APXvYqwlMZzehI02MEn+5jzwvbODyPijyZv5ugoN1UOV+5E39LSNMLihK6V61x0gz8dKmb6fcknVBg==
X-Received: by 2002:a5d:8cce:: with SMTP id k14mr4012677iot.294.1579901503915;
        Fri, 24 Jan 2020 13:31:43 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 190sm1322705iou.60.2020.01.24.13.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 13:31:43 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io-wq: add 'id' to io_wq
Date:   Fri, 24 Jan 2020 14:31:39 -0700
Message-Id: <20200124213141.22108-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124213141.22108-1-axboe@kernel.dk>
References: <20200124213141.22108-1-axboe@kernel.dk>
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
 fs/io-wq.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 54e270ae12ab..51b3677d6fbd 100644
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
+static DEFINE_IDR(wq_idr);
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
@@ -1076,6 +1083,15 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 			goto err;
 		}
 		refcount_set(&wq->use_refs, 1);
+
+		/* if we're out of IDs or fail to get one, use 0 */
+		mutex_lock(&wq_lock);
+		wq->id = idr_alloc(&wq_idr, wq, 1, INT_MAX, GFP_KERNEL);
+		if (wq->id < 0)
+			wq->id = 0;
+
+		list_add(&wq->wq_list, &wq_list);
+		mutex_unlock(&wq_lock);
 		reinit_completion(&wq->done);
 		return wq;
 	}
@@ -1119,6 +1135,13 @@ static void __io_wq_destroy(struct io_wq *wq)
 
 void io_wq_destroy(struct io_wq *wq)
 {
-	if (refcount_dec_and_test(&wq->use_refs))
+	if (refcount_dec_and_test(&wq->use_refs)) {
+		mutex_lock(&wq_lock);
+		if (wq->id)
+			idr_remove(&wq_idr, wq->id);
+		list_del(&wq->wq_list);
+		mutex_unlock(&wq_lock);
+
 		__io_wq_destroy(wq);
+	}
 }
-- 
2.25.0

