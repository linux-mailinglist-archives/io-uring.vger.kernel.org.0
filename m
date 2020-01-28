Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD3214AD03
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2020 01:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgA1AQf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 19:16:35 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45842 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgA1AQf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 19:16:35 -0500
Received: by mail-wr1-f66.google.com with SMTP id j42so13893515wrj.12;
        Mon, 27 Jan 2020 16:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=X6SmAvLCHiTWpQkkHRbnIbIeXQO2/7otcQ8yU/pmEwU=;
        b=bnOjNFqpFKIuFy1sbZ2FKaajnuP+hoc05jLczsPmaDtcl1nva2IsuKi3hFDmsdljYK
         FeaOw8MKv2HXVvW7HieQPGXPhNHOiH+42x6xdE6kFOgp6gAm15r/N2kJ2DBhSb66NO8R
         44vhN+NJi0hhePYLa6kVticnzy6rgXBuCycjh7dpmDoUQtEDoNq4kLPpAN74vSweJgNf
         yuB94TF0FCA7tRg7aQA2DliSQz5VuuXYNnm/KS1bWOluSDaxffgeS82oWpGuWh4KHg/t
         zj+QNIAcdcTJb0Jj/RlXIJBVGfM7bpfN9iMTTVb9kLUfCWlpws9B3/y40YWTYd0uw0Gp
         NU/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X6SmAvLCHiTWpQkkHRbnIbIeXQO2/7otcQ8yU/pmEwU=;
        b=e1aCBLswJZ40k+tZTnYkjhpWr+IvvA+HM7ZXCFkL/f22fz1iBN1YVm3w5xDVdHcoPq
         s+rgyeFagFIk5i2e3vwpxMOBuo5ZzKKfJ2t0F8mIIJDJ84mTjOcw8wybfoDGKi1gNaIa
         oj5I57i9fR3a6FJAoLnQzZqVRvMgt5tO73qBE8jkSlFKRV3T75peIrdc1d5T6cHSQG2v
         hs5MHNjhXgLgr6K39jTrWKawUL0Tniqwn3ZSaqcXy6QUB0BkKFiCD5+lvyOu5Xn4jGUJ
         pyHs/oAVUi4KgP8tVHY+tU49MBZjUhP3SHppK3KuIeEPkSXCRNSR+iVSnAKgeeihe+k5
         xrWQ==
X-Gm-Message-State: APjAAAUOmzcULa1cGUyRnFwH4DLhlm0PISYQd8/LHlLBp04eCBQU74TX
        0vRZWDCxzRBOIoj8zCHqzQc=
X-Google-Smtp-Source: APXvYqwJn9SPD243lszL9inEZQ51trQ7U5RYtGhiOxIt5/YzVNsgX9IxpoBl3GfF199HpEoDPKt77w==
X-Received: by 2002:a5d:6652:: with SMTP id f18mr25453877wrw.246.1580170592786;
        Mon, 27 Jan 2020 16:16:32 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id z21sm638426wml.5.2020.01.27.16.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 16:16:32 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] io-wq: allow grabbing existing io-wq
Date:   Tue, 28 Jan 2020 03:15:47 +0300
Message-Id: <af01e0ca2dcab907bc865a5ecdc0317c00bb059a.1580170474.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1580170474.git.asml.silence@gmail.com>
References: <cover.1580170474.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If the id and user/creds match, return an existing io_wq if we can safely
grab a reference to it.

Reported-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 8 ++++++++
 fs/io-wq.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index b45d585cdcc8..ee49e8852d39 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1110,6 +1110,14 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	return ERR_PTR(ret);
 }
 
+bool io_wq_get(struct io_wq *wq, struct io_wq_data *data)
+{
+	if (data->get_work != wq->get_work || data->put_work != wq->put_work)
+		return false;
+
+	return refcount_inc_not_zero(&wq->use_refs);
+}
+
 static bool io_wq_worker_wake(struct io_worker *worker, void *data)
 {
 	wake_up_process(worker->task);
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 167316ad447e..c42602c58c56 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -99,6 +99,7 @@ struct io_wq_data {
 };
 
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data);
+bool io_wq_get(struct io_wq *wq, struct io_wq_data *data);
 void io_wq_destroy(struct io_wq *wq);
 
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work);
-- 
2.24.0

