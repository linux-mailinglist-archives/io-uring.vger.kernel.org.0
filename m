Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325EA43AABB
	for <lists+io-uring@lfdr.de>; Tue, 26 Oct 2021 05:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233411AbhJZDZe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Oct 2021 23:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbhJZDZd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Oct 2021 23:25:33 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66612C061745;
        Mon, 25 Oct 2021 20:23:10 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id k2-20020a17090ac50200b001a218b956aaso549237pjt.2;
        Mon, 25 Oct 2021 20:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=cnWuWjh4H1UhOaUxI2972kvo6MATwr45G4u1Pjq/WSo=;
        b=SyND6e5bMhlPf6FlcwC+gAg7JqoOy6a4sUKXTLo0KpPNyWN9QEBP9APKv72NZu+GTz
         b+HWcripM2Vjz0maJpyG1A5bv/b1yWXixC726M0EYpjh13u7ASNp2aSX0cE7zqzBgY73
         xDYfZrGYOCukJxTmtprrC26kyjG6sIN6iFhwXasTKM/fTwJZINcDnjBNRkVcu1Jqx3DB
         oi0AWD8CpGK+g8zKADp+kNWeALXBq54ruJLbbFpbC1YJ/rKgAzrTdT2SOypD7ap+s1s6
         XjIW1ETQwZnSQQpRL6xJbtBspq6yGmRqvuTnD5Gmz6G0nujBjB1jKIYfyFpTl8ZpcTvC
         sc6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cnWuWjh4H1UhOaUxI2972kvo6MATwr45G4u1Pjq/WSo=;
        b=K56VgARottZeNiAo8sqcBUlfxqmNtyNcrLpMAL28XIewC7FFor/6dWQ6gJmGpf/qck
         d2y0g8gUSCNuB3LSVwT5G4IPVadqxjQmubllRCFvzYk490QoU2z6P/6QaP6brOD+Nkg8
         dwrzUDl8yc1bpPZPnljPBzBgQUlh0ABgOWaU9axlUhlZFWs+yeV8mLe55NNcMKyk5PK/
         0OW6OWtnwDeB5Xa9062zgJE1d4Fgjz6Buvj0327RhY6DmX0+yEc3+n8vnRmHkYzhwFY3
         5vutkskpEVIFaX2GXHjUvM2icip1WgX08p/k3CFN0YF0TGMRsYEh2uQ+F2fF3w43RtnQ
         MVlQ==
X-Gm-Message-State: AOAM533FgEqNSaV7aQuJkkJV6WwTM22KvELqtPDeh0fbalDP7lFYai2b
        ArWTyqxVNw3yga+4pVyUl54=
X-Google-Smtp-Source: ABdhPJwWHzFBGLo02ybfFN/mQDYSViqeQz6b5rI37t6V2ZOhwCGZwUTmfU2O9zmlYYdsSZhSzIDmHg==
X-Received: by 2002:a17:902:d885:b0:13f:c50f:9ac with SMTP id b5-20020a170902d88500b0013fc50f09acmr19669265plz.53.1635218589890;
        Mon, 25 Oct 2021 20:23:09 -0700 (PDT)
Received: from BJ-zhangqiang.qcraft.lan ([137.59.101.13])
        by smtp.gmail.com with ESMTPSA id j16sm618777pfj.16.2021.10.25.20.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 20:23:09 -0700 (PDT)
From:   Zqiang <qiang.zhang1211@gmail.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Zqiang <qiang.zhang1211@gmail.com>
Subject: [PATCH] io-wq: Remove unnecessary rcu_read_lock/unlock() in raw spinlock critical section
Date:   Tue, 26 Oct 2021 11:23:04 +0800
Message-Id: <20211026032304.30323-1-qiang.zhang1211@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Due to raw_spin_lock/unlock() contains preempt_disable/enable() action,
already regarded as RCU critical region, so remove unnecessary
rcu_read_lock/unlock().

Signed-off-by: Zqiang <qiang.zhang1211@gmail.com>
---
 fs/io-wq.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index cd88602e2e81..401be005d089 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -855,9 +855,7 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 	io_wqe_insert_work(wqe, work);
 	clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
 
-	rcu_read_lock();
 	do_create = !io_wqe_activate_free_worker(wqe, acct);
-	rcu_read_unlock();
 
 	raw_spin_unlock(&wqe->lock);
 
-- 
2.17.1

