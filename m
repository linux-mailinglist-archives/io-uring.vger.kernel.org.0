Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49F9414748A
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2020 00:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729505AbgAWXQU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jan 2020 18:16:20 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45090 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbgAWXQT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jan 2020 18:16:19 -0500
Received: by mail-pf1-f194.google.com with SMTP id 2so125879pfg.12
        for <io-uring@vger.kernel.org>; Thu, 23 Jan 2020 15:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0+MB13SxPrtkY53fvbOmF6I1m2+FPYNrDl1sdTj+ZD4=;
        b=rXObmvLRZ+PvNjfwk4+DOwl73c3HVLV280CShgNYeoiw9RUagu7qJvIQcN3bB8anSk
         5rIKs9rpPVHdlM8VvDsc8xJ2y/Wi9ti+S+lpq61noafmBzbOwDRg50jv6QiPIZClQ+be
         aXg0lANhAYc7RE4tdq8PuC6hzKeT6wFdE3rxV7uMd0tcUtmUpIdrm3RYAEY01I9pHu3q
         6MyTLKtVC6ThCAX+E42FYNc9ZakFvWXEsr+EtA0ggazCfY7jCsv7H9Y9mKdAmBcruwvr
         zNj582m1ZSXSFmQm3mZHBlIHo2gd/92DNw8RUMYdnbPiWvh+TUr+KG615HSaVmwvbzn2
         9srA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0+MB13SxPrtkY53fvbOmF6I1m2+FPYNrDl1sdTj+ZD4=;
        b=H/AiW0MIM4b0+8lxtWuhuG/duAtvun9nHdPWIKmPGcOQQJ/U0azXjWngqwtnUyiWL6
         u0KaMzYR0xNghJegBnbuWMoiDXJmJ3/Yws6DaQrgUzEFevZBQkA0KMuQ+bsGRtkQDF7p
         5yh8kkclbTxjtxxQs/H+Dj3WAdFaBKE6SvXxcIEbK4qG0a8DELWLoV0a9WbhJ7hwx/hM
         xj5NwWHvuO5Kao+49udSp33/5MqyPat/ckuswvsax88i8LndP1uC8RP5Q+fFJdrkbFIQ
         XqHC8yDv7GODBRJaGI3ZdNoM7Ue9kiQNtUewbXBj7+KN0e3FcCyU6WfBB+csFnV+ZkjG
         Z0lQ==
X-Gm-Message-State: APjAAAUJ0yVLL+ld5+UGmhu7cPLSivOz37QnnKMON8VgnqIrlqDtoOqh
        U7vyEZ7Cz+5infNuXEDYHep3ioOgN1qL8A==
X-Google-Smtp-Source: APXvYqzWEzYY7sxfwPa/fG7TMaNzj9Td5tNA6K32Sismv1qcHIUKqAabGBdyCP+kJrEhiR7jqaK66g==
X-Received: by 2002:a65:55cd:: with SMTP id k13mr772772pgs.197.1579821378968;
        Thu, 23 Jan 2020 15:16:18 -0800 (PST)
Received: from x1.thefacebook.com ([2600:380:4513:6598:c1f4:7b05:f444:ef97])
        by smtp.gmail.com with ESMTPSA id u127sm3766627pfc.95.2020.01.23.15.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 15:16:18 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io-wq: make the io_wq ref counted
Date:   Thu, 23 Jan 2020 16:16:11 -0700
Message-Id: <20200123231614.10850-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200123231614.10850-1-axboe@kernel.dk>
References: <20200123231614.10850-1-axboe@kernel.dk>
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

