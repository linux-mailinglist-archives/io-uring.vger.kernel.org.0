Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A05B14902C
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2020 22:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgAXVbq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jan 2020 16:31:46 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:45065 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgAXVbp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jan 2020 16:31:45 -0500
Received: by mail-io1-f68.google.com with SMTP id i11so3411887ioi.12
        for <io-uring@vger.kernel.org>; Fri, 24 Jan 2020 13:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S/7B1heQ9F5sCRETyaCW+4R53+86Po75J52yQE8zWb0=;
        b=mfYNiD8bY/sS1A32OvhE2KXH7iCrkZUgY7gKyhqBYYNDUFcm7muh6IdYnjpK3MGrEu
         oxSGyE1xFH0Q1gJKvbkLIjrqVm2Qz6pV8Jols2xWU2H3QkuS9wn9uYQsw9iuuOVGdycL
         gVSzGzOj2DEAuTar3+ppKH5ChZBz+g6NTDV4buotTgd5txA9BKspMHjsVRK+rQSO0DSO
         +60CiAg+gKPXYFU6fuRF+AihBh6ek1rwOhTZTj6SqmQSHlg/EEZye2qjhUXi+/Afvyzj
         CgIM7035tz3Xt6jE7pp3vv0tx+jdrv3CGu9JcWcDl8Q3WDTYtIP6q8J4gOJMGse9xeRn
         8hmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S/7B1heQ9F5sCRETyaCW+4R53+86Po75J52yQE8zWb0=;
        b=YkE6p4i0T8Z+R4vHq6XdHhUqCGvUCCUVGQPIcTOfzySMbsCsAhd+Yv+rdsyC7S52LG
         W9Dc8108frCn8Q0kQS4frn/AUUhAR+RcecuBC9QXKB2dD/JHiIG7ATtAbuzLRo8OTP/n
         V2KjOxwKItLSirmAkezGSv/qPoMEsWA19j38PjS+PEBO0050sGmzfD0KKZ5kJ34nSi00
         1qm/vWk/aRQg1a9Vo74rifujENaLgZ25YQbEnVj4RI2o8xGPB//iXlkdhwR/mKmhb2PD
         hMhKm0g53ISu3fg07yTEIq7tq5Te/c2wFKnYqOWvU7Z5eFOkzMotldl7qcG51XbrFm9N
         FtqQ==
X-Gm-Message-State: APjAAAX6rtO130BPZORHFqh5f9qABn0rjNyXN7ksgyFEvvZUv13S3aKZ
        WeKfXCKPgQYgDCaDuYk1Wna3po3TrP0=
X-Google-Smtp-Source: APXvYqw5leYPVZJ0LUtU/8LkGNxpcHV3S7vvMg0eD0rfV0AlWuqqS4Bw9yDwUFc73vYPiWLJZ4pC5A==
X-Received: by 2002:a6b:e601:: with SMTP id g1mr3768543ioh.55.1579901504898;
        Fri, 24 Jan 2020 13:31:44 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 190sm1322705iou.60.2020.01.24.13.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 13:31:44 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io-wq: allow lookup of existing io_wq with given id
Date:   Fri, 24 Jan 2020 14:31:40 -0700
Message-Id: <20200124213141.22108-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124213141.22108-1-axboe@kernel.dk>
References: <20200124213141.22108-1-axboe@kernel.dk>
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
 fs/io-wq.c | 37 ++++++++++++++++++++++++++++++++++++-
 fs/io-wq.h | 11 ++++++++++-
 2 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 51b3677d6fbd..08ef69b498f6 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1024,7 +1024,7 @@ void io_wq_flush(struct io_wq *wq)
 	}
 }
 
-struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
+static struct io_wq *__io_wq_create(unsigned bounded, struct io_wq_data *data)
 {
 	int ret = -ENOMEM, node;
 	struct io_wq *wq;
@@ -1106,6 +1106,36 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	return ERR_PTR(ret);
 }
 
+static bool io_wq_match(struct io_wq *wq, struct io_wq_data *data)
+{
+	if (data->creds != wq->creds || data->user != wq->user)
+		return false;
+	if (data->get_work != wq->get_work || data->put_work != wq->put_work)
+		return false;
+	return refcount_inc_not_zero(&wq->use_refs);
+}
+
+/*
+ * Find and return io_wq with given id and grab a reference to it.
+ */
+struct io_wq *io_wq_create_id(unsigned bounded, struct io_wq_data *data,
+			      unsigned int id)
+{
+	if (id) {
+		struct io_wq *wq;
+
+		mutex_lock(&wq_lock);
+		wq = idr_find(&wq_idr, id);
+		if (wq && io_wq_match(wq, data)) {
+			mutex_unlock(&wq_lock);
+			return wq;
+		}
+		mutex_unlock(&wq_lock);
+	}
+
+	return __io_wq_create(bounded, data);
+}
+
 static bool io_wq_worker_wake(struct io_worker *worker, void *data)
 {
 	wake_up_process(worker->task);
@@ -1145,3 +1175,8 @@ void io_wq_destroy(struct io_wq *wq)
 		__io_wq_destroy(wq);
 	}
 }
+
+unsigned int io_wq_id(struct io_wq *wq)
+{
+	return wq->id;
+}
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 1cd039af8813..dee7bb3b7cd4 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -97,8 +97,17 @@ struct io_wq_data {
 	put_work_fn *put_work;
 };
 
-struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data);
+struct io_wq *io_wq_create_id(unsigned bounded, struct io_wq_data *data,
+				unsigned int id);
+
+static inline struct io_wq *io_wq_create(unsigned bounded,
+					 struct io_wq_data *data)
+{
+	return io_wq_create_id(bounded, data, 0);
+}
+
 void io_wq_destroy(struct io_wq *wq);
+unsigned int io_wq_id(struct io_wq *wq);
 
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work);
 void io_wq_enqueue_hashed(struct io_wq *wq, struct io_wq_work *work, void *val);
-- 
2.25.0

