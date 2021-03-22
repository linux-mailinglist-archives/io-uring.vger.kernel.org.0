Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBAEB34367D
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 03:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhCVCDU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Mar 2021 22:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbhCVCCr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Mar 2021 22:02:47 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F648C061574
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 19:02:47 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id z6-20020a1c4c060000b029010f13694ba2so8336629wmf.5
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 19:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=fzGqPv7pyLJoz0l7v7UEGNA2fEh2yiZC2RebX94r6Y8=;
        b=qD76Is64gtE0aqTyG+gJTs3ExI9SI7Jw+e5yMproWDkoMbhq4ETaGRW/B7ACRJW6cA
         mJ1AT2jr+rqYVTIByzRltRN21eUtRK53mre74bgbcJN84vz5GhSMJJILpipNbAJTAxDF
         ZG77jpLqZ7U9dcxcwvOilZCsCXVLU8UPPdkQ5AKgtaTychVA0ZX7SW8IprBeQcYxIVw7
         HGPelBqsVz0Mn3r4DjamhJvDOW6txgFq/Ob3uRXXMqFzZhwdWYA/2WYx68NtxfXce+cZ
         85SIZqGdzaLeVdYhP+2xFYIrMfeSjMp8h0kNzod0boDfE/BKB63HZN+X+TYe7Vw/GBgv
         ztvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fzGqPv7pyLJoz0l7v7UEGNA2fEh2yiZC2RebX94r6Y8=;
        b=i+ek3Uep2ZSc+zLaxdKVn85RwEB5k2BYSK35cMh3PPfFlFS/HoKSzsJ2A1rixsbJ2l
         uA8q7M1kU6JNIREJ5MyHYA+/swhF8767C2oUKBhDNjNQ31dfNx49IER0SPdhKhYuCfrv
         RLVI3Udge39VCb/Gi3P5RlFaZT3Sz5P1yPfwtHTzp2wZjwcb2RszNueSRfVgO5tvCtZK
         XdvF2PdzMkLWsmS9svLSu2GuMcgdiHbT6oFLomvcRJUUhi/cTSWYGX7iwkeKAMtaXjiG
         2zZyhBpQ0vnVU+MXGpv8yPXCiRYILWyYdjIBlAo/U22L4VEpXe3abcjHOCysbjpsUc7m
         +ryQ==
X-Gm-Message-State: AOAM5316qJISaUj6ZD2tZcvGjIaDWk8j6m0/Cg+uiM5z5KRKphBJ4Ge7
        Je1lHZschx2Rc/VGVNh7Lik=
X-Google-Smtp-Source: ABdhPJwhCA3EEzfHKcoJWjw5+0zCjt3p8HzQXu/muWIlFBvR1X4wopqoM5yzAh2qoKM2Dxbwir+SyA==
X-Received: by 2002:a05:600c:4a18:: with SMTP id c24mr13205454wmp.173.1616378566427;
        Sun, 21 Mar 2021 19:02:46 -0700 (PDT)
Received: from localhost.localdomain ([85.255.234.202])
        by smtp.gmail.com with ESMTPSA id i8sm15066695wmi.6.2021.03.21.19.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 19:02:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 05/11] io-wq: refactor *_get_acct()
Date:   Mon, 22 Mar 2021 01:58:28 +0000
Message-Id: <bc0d0c19eea02c0261f78e3c20d01407267e2ed7.1616378197.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616378197.git.asml.silence@gmail.com>
References: <cover.1616378197.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Extract a helper for io_work_get_acct() and io_wqe_get_acct() to avoid
duplication.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index e05f996d088f..ba4e0ece3894 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -148,23 +148,20 @@ static void io_worker_release(struct io_worker *worker)
 		complete(&worker->ref_done);
 }
 
+static inline struct io_wqe_acct *io_get_acct(struct io_wqe *wqe, bool bound)
+{
+	return &wqe->acct[bound ? IO_WQ_ACCT_BOUND : IO_WQ_ACCT_UNBOUND];
+}
+
 static inline struct io_wqe_acct *io_work_get_acct(struct io_wqe *wqe,
 						   struct io_wq_work *work)
 {
-	if (work->flags & IO_WQ_WORK_UNBOUND)
-		return &wqe->acct[IO_WQ_ACCT_UNBOUND];
-
-	return &wqe->acct[IO_WQ_ACCT_BOUND];
+	return io_get_acct(wqe, !(work->flags & IO_WQ_WORK_UNBOUND));
 }
 
 static inline struct io_wqe_acct *io_wqe_get_acct(struct io_worker *worker)
 {
-	struct io_wqe *wqe = worker->wqe;
-
-	if (worker->flags & IO_WORKER_F_BOUND)
-		return &wqe->acct[IO_WQ_ACCT_BOUND];
-
-	return &wqe->acct[IO_WQ_ACCT_UNBOUND];
+	return io_get_acct(worker->wqe, worker->flags & IO_WORKER_F_BOUND);
 }
 
 static void io_worker_exit(struct io_worker *worker)
-- 
2.24.0

