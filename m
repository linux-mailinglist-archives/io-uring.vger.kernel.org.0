Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300233F5FA4
	for <lists+io-uring@lfdr.de>; Tue, 24 Aug 2021 15:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234695AbhHXOAN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Aug 2021 10:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237576AbhHXN7P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Aug 2021 09:59:15 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D74C061757
        for <io-uring@vger.kernel.org>; Tue, 24 Aug 2021 06:58:31 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id k8so31485769wrn.3
        for <io-uring@vger.kernel.org>; Tue, 24 Aug 2021 06:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=iqETOLuPXS7xDztJquQayLMcPcdTUSfXhhWKRVHSpWQ=;
        b=UFmPYnvrBGVE4UHQJIKIs88v2e8uWNQcbmEUZtXDRqkA4EpERcHMigoOy6sErVLqSr
         DTpymALlb1L22S/tTijvJhS4N9/t7WEDThOd+crB/A5TDqB+q0SEcjW9YxjtJRt6TEXf
         cNNyPmCUe5pQknOpVmRjmuaLT0gQzhaFZcGffHwT1LqBPjCE9PAAOkbD/ClC/0FFyT6S
         xAWnaGa2uqmnduTshdgNoJ2V9iPQ9ouo1dPhKHW8Ry7HnD4M4dE94n2eUXsaYPKogJnA
         O1tUSPCHG3eat4ZsetbItNkMwkPDzpen0uqUD7GF1NV+nx2lemCkoYBdq8wqtfzooOFd
         J1Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iqETOLuPXS7xDztJquQayLMcPcdTUSfXhhWKRVHSpWQ=;
        b=safkswwYL7X/ftvLW+jr+GcbetZFP1ErHaa2Ek/T6I9NO7sjuwyOdl2ocHua6VYjQO
         zkJAqVLJCNy9d6pJLrfGHcDWIJhc/zIvVAw5Sl6KZWJs6jLcunIerQj2wTRJh5pzIqUb
         QGWQCm2vsWU5EpojoPVQbqAO34yx7h/vfmU9IMNK7V4WmGzT2HtiqAzCrB6gh1O1fCzy
         NdCL56x5hbVulV328YQibW7WL2ury2tyQmsgsKJbu439kq8eG2ml757cF3kP4hLtg6bC
         cUEVWLdyvbU8vr8v/HFCw/KNQOEtP9tSsSbl3VQHYyIJODiJUE9SnT+20Ij4JOaNcJif
         3MDA==
X-Gm-Message-State: AOAM533B6NMrQvUrE/DVXkJhJmHvnCiGH7VeJ5+a47PWfLGnX326EcHK
        QrbSC6mASn0Ug9fI3XVNQlk=
X-Google-Smtp-Source: ABdhPJzwHMnG3V6Id9dMB87Kb3/tbGLy5c9YITWj+ytVCoeXM4HqxYX9xeOP/eXMwE2u1nJhCHrz5A==
X-Received: by 2002:adf:a45b:: with SMTP id e27mr8768203wra.222.1629813510364;
        Tue, 24 Aug 2021 06:58:30 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.113])
        by smtp.gmail.com with ESMTPSA id y21sm2568622wmc.11.2021.08.24.06.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 06:58:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 1/2] tests: rw: don't exit ring when init failed
Date:   Tue, 24 Aug 2021 14:57:51 +0100
Message-Id: <28376af76af7bfb9059b6b9ad3a01eb0b07e7244.1629813328.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629813328.git.asml.silence@gmail.com>
References: <cover.1629813328.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't do io_uring_queue_exit() after t_create_ring() got skipped.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/iopoll.c     | 3 +--
 test/read-write.c | 4 +---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/test/iopoll.c b/test/iopoll.c
index 5273279..7037c31 100644
--- a/test/iopoll.c
+++ b/test/iopoll.c
@@ -278,13 +278,12 @@ static int test_io(const char *file, int write, int sqthread, int fixed,
 
 	ret = t_create_ring(64, &ring, ring_flags);
 	if (ret == T_SETUP_SKIP)
-		goto done;
+		return 0;
 	if (ret != T_SETUP_OK) {
 		fprintf(stderr, "ring create failed: %d\n", ret);
 		return 1;
 	}
 	ret = __test_io(file, &ring, write, sqthread, fixed, buf_select);
-done:
 	io_uring_queue_exit(&ring);
 	return ret;
 }
diff --git a/test/read-write.c b/test/read-write.c
index 93f6803..1cfa2d5 100644
--- a/test/read-write.c
+++ b/test/read-write.c
@@ -242,7 +242,7 @@ static int test_io(const char *file, int write, int buffered, int sqthread,
 
 	ret = t_create_ring(64, &ring, ring_flags);
 	if (ret == T_SETUP_SKIP)
-		goto done;
+		return 0;
 	if (ret != T_SETUP_OK) {
 		fprintf(stderr, "ring create failed: %d\n", ret);
 		return 1;
@@ -250,8 +250,6 @@ static int test_io(const char *file, int write, int buffered, int sqthread,
 
 	ret = __test_io(file, &ring, write, buffered, sqthread, fixed, nonvec,
 			0, 0, exp_len);
-
-done:
 	io_uring_queue_exit(&ring);
 	return ret;
 }
-- 
2.32.0

