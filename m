Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE2E14748C
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2020 00:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729546AbgAWXQW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jan 2020 18:16:22 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33999 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbgAWXQV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jan 2020 18:16:21 -0500
Received: by mail-pf1-f196.google.com with SMTP id i6so154998pfc.1
        for <io-uring@vger.kernel.org>; Thu, 23 Jan 2020 15:16:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w0W6G0SkCIswMzZbfdf+Tu0VPCRecU2QAsn6LDDO5to=;
        b=oDrZRTIjRYB/2WL7Kf+oGQBD3xwVpHf7lWFrHeoLtyQ/w6AUNZCLMgciNI/Qrl6v4X
         46IxexRm/F6ocRVgAmacSbBIkQrdFVNQYAt426G4TRSAmqMhRriWcHTKd9y1M8Aq7/wM
         DCoXwZAfZhbD04Qj+7vYh0CRFnZinOkE4QLJbD1aLuDosCiXoFWMwfFrO+iW8hL5BxPK
         fEZGjX+SoOrPGvT8nI5k/9HtjKA0gOx9Tqneo4wGBxQy6LtdcbRSGeMEtEBDRX20/ic0
         ULe1ilmYL/6Ul/UjfkA1OcBpEV2X4AB5HCyqzg12tau8bbRfEeD6N/wA/TTr1Jfr7i2r
         aIVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w0W6G0SkCIswMzZbfdf+Tu0VPCRecU2QAsn6LDDO5to=;
        b=ewzLHqt6Yz238YLRXsShTg5Al4+prxgwZu7LaRJFDvqnseSgAFxFiGzFLsds/EercW
         DFgF9xf7KH+CP8qY6gXhEDGV3gRr0r/Ux5+mv6c2aiHeVln/MCVpdvS9AcWyo4pVoJ19
         WhmR6a9MZWVCDDEC0pgbbAhqKipZJgyveg7h73gge40wWrrZstkvFbRpM4+bEAse1N+6
         1T4ctJWJ0ew1P5jTm2nSAFtNCq4oT2n8IqFA/tH/76ZRaKzY0QSNDIe4JniOgq2OWALe
         YD/eN9zlF4t/KOy3LKAOYz20p/yijmkAPrHblB/HPTd7xCE3UWVUgiNsaRIlJqN3XANQ
         8Y7g==
X-Gm-Message-State: APjAAAXLePaoKWL0FyUJUb93U84ofnET8yyZY3nuF1Xtszps6dBEshGn
        8JgHNOS9RA1GFoCryIbCNWgIUxR35yIFMQ==
X-Google-Smtp-Source: APXvYqzgKkzyrVg2ulP8B3qnYYeroBnEAJJnMLpxiIFgzNc1MidHG0k8hL6kaFhaWxQ8TVo2QWHDbg==
X-Received: by 2002:a63:48d:: with SMTP id 135mr846140pge.66.1579821380990;
        Thu, 23 Jan 2020 15:16:20 -0800 (PST)
Received: from x1.thefacebook.com ([2600:380:4513:6598:c1f4:7b05:f444:ef97])
        by smtp.gmail.com with ESMTPSA id u127sm3766627pfc.95.2020.01.23.15.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 15:16:20 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io-wq: allow lookup of existing io_wq with given id
Date:   Thu, 23 Jan 2020 16:16:13 -0700
Message-Id: <20200123231614.10850-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200123231614.10850-1-axboe@kernel.dk>
References: <20200123231614.10850-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If the id and user/creds match, return an existing io_wq if we can safely
grab a reference to it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 fs/io-wq.h |  3 +++
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 8cb0cff5f15c..a9985856033d 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1024,7 +1024,7 @@ void io_wq_flush(struct io_wq *wq)
 	}
 }
 
-struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
+static struct io_wq *__io_wq_create(unsigned bounded, struct io_wq_data *data)
 {
 	int ret = -ENOMEM, node, id;
 	struct io_wq *wq;
@@ -1107,6 +1107,41 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	return ERR_PTR(ret);
 }
 
+struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
+{
+	return __io_wq_create(bounded, data);
+}
+
+/*
+ * Find and return io_wq with given id and grab a reference to it.
+ */
+struct io_wq *io_wq_create_id(unsigned bounded, struct io_wq_data *data,
+			      unsigned int id)
+{
+	struct io_wq *wq, *ret = NULL;
+
+	mutex_lock(&wq_lock);
+	list_for_each_entry(wq, &wq_list, wq_list) {
+		if (id != wq->id)
+			continue;
+		if (data->creds != wq->creds || data->user != wq->user)
+			continue;
+		if (data->get_work != wq->get_work ||
+		    data->put_work != wq->put_work)
+			continue;
+		if (!refcount_inc_not_zero(&wq->use_refs))
+			continue;
+		ret = wq;
+		break;
+	}
+	mutex_unlock(&wq_lock);
+
+	if (!ret)
+		ret = io_wq_create(bounded, data);
+
+	return ret;
+}
+
 static bool io_wq_worker_wake(struct io_worker *worker, void *data)
 {
 	wake_up_process(worker->task);
@@ -1145,3 +1180,8 @@ void io_wq_destroy(struct io_wq *wq)
 		__io_wq_destroy(wq);
 	}
 }
+
+unsigned int io_wq_id(struct io_wq *wq)
+{
+	return wq->id;
+}
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 1cd039af8813..7abe2c56b535 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -98,7 +98,10 @@ struct io_wq_data {
 };
 
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data);
+struct io_wq *io_wq_create_id(unsigned bounded, struct io_wq_data *data,
+				unsigned int id);
 void io_wq_destroy(struct io_wq *wq);
+unsigned int io_wq_id(struct io_wq *wq);
 
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work);
 void io_wq_enqueue_hashed(struct io_wq *wq, struct io_wq_work *work, void *val);
-- 
2.25.0

