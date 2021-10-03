Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA6D420144
	for <lists+io-uring@lfdr.de>; Sun,  3 Oct 2021 13:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbhJCLNg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Oct 2021 07:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbhJCLNg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Oct 2021 07:13:36 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C34AAC0613EC
        for <io-uring@vger.kernel.org>; Sun,  3 Oct 2021 04:11:48 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id v10so53350226edj.10
        for <io-uring@vger.kernel.org>; Sun, 03 Oct 2021 04:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B4mSs8hTFOaVA7VL5QH4uW+rcX1nasKw43hZGIx8Gck=;
        b=YY26IPktpUY615lOoPNAXYt258s2dXOnSlz1bnvt9ozqEEY8R9rdReTTdY+zscsMen
         UB6vsQW+sgqSbzZhvQifNvdnUx66PyEpxHFmunbrOfL6mPXLRJlYc06dfpfzRg/BikFS
         2NSsC4FTAr7gcj2ekhgBA5bEPh1gPmLzjJMT/037gYtK9gSDadlwbjjvoFsy0PbxC1Dn
         o3T2Z22gO0Yl8+8AaUgBVRjueK3rAduosrRiCa3fUTbMVkT6mKFjm2MEX5RWXvi/u3lM
         4//fibAo2saDSweEXHrRiw2CTKQguuQAdIumVurb3au1T5kN9dU39LjgMfej/WZ8MWcP
         xzPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B4mSs8hTFOaVA7VL5QH4uW+rcX1nasKw43hZGIx8Gck=;
        b=wykGq6cMyCZpdHiLBjxhzOxT7xXIFtZDZFq7ECvZZ/iPcCUqZoI24UoTozuZpT+GBN
         178VkOJ9PiLFTfd4FcaxuHA7i4j897LR97S9xLAVPi/MyDSjUDgnA7VmkB/0eRtq6OZD
         9VdHjrgztwN/Z/ye4bM/9X7GrePMeyes6UynF94SgKhmT8x7QARCZAWqLUBFhbZrYKwH
         UKlUd45CNefZjvpQcc38PIT9DGWx9eJw3rVl83Kbrjq1i8mCICvVbNo1CZwTD2W2RKmy
         1mq+MjbL4lxXERKVRhVHhBprKHKdfmCapPgORPl+s59kRUQHrkUqJjgbmPdmQespH0Kt
         ff8g==
X-Gm-Message-State: AOAM533b709leksZ+NI0V/UlKnzGQYBkH9y8xGRAZx6rEoWJBeCWTU5Z
        Y1q4HmxWXz4eJILv2g7uxySk0CxScvc=
X-Google-Smtp-Source: ABdhPJxbT1LnmnPSf7qIqC5NHW+WGOcTC/6iX6F7hXtPV5Z+f1DMlZuaRn3Ya0W6ywGJxOoOI/8j5g==
X-Received: by 2002:a05:6402:26d1:: with SMTP id x17mr6143715edd.300.1633259507235;
        Sun, 03 Oct 2021 04:11:47 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.39])
        by smtp.gmail.com with ESMTPSA id r6sm210492edd.89.2021.10.03.04.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 04:11:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 2/2] io_uring: fix SQPOLL timeout-new test
Date:   Sun,  3 Oct 2021 12:11:00 +0100
Message-Id: <5faf8ade7e161931d76a47b809650e68a1b361ba.1633259449.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1633259449.git.asml.silence@gmail.com>
References: <cover.1633259449.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Happens pretty rarely, but there were cases when CQE waitinig in
test_return_before_timeout() time outs before the SQPOLL thread kicks in
and executes submitted requests, give SQPOLL a little bit more time.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/timeout-new.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/test/timeout-new.c b/test/timeout-new.c
index 19c5ac3..6efcfb4 100644
--- a/test/timeout-new.c
+++ b/test/timeout-new.c
@@ -53,14 +53,12 @@ static int test_return_before_timeout(struct io_uring *ring)
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
 	int ret;
+	bool retried = false;
 	struct __kernel_timespec ts;
 
-	sqe = io_uring_get_sqe(ring);
-	if (!sqe) {
-		fprintf(stderr, "%s: get sqe failed\n", __FUNCTION__);
-		return 1;
-	}
+	msec_to_ts(&ts, TIMEOUT_MSEC);
 
+	sqe = io_uring_get_sqe(ring);
 	io_uring_prep_nop(sqe);
 
 	ret = io_uring_submit(ring);
@@ -69,13 +67,21 @@ static int test_return_before_timeout(struct io_uring *ring)
 		return 1;
 	}
 
-	msec_to_ts(&ts, TIMEOUT_MSEC);
+again:
 	ret = io_uring_wait_cqe_timeout(ring, &cqe, &ts);
-	if (ret < 0) {
+	if (ret == -ETIME && (ring->flags & IORING_SETUP_SQPOLL) && !retried) {
+		/*
+		 * there is a small chance SQPOLL hasn't been waked up yet,
+		 * give it one more try.
+		 */
+		printf("warning: funky SQPOLL timing\n");
+		sleep(1);
+		retried = true;
+		goto again;
+	} else if (ret < 0) {
 		fprintf(stderr, "%s: timeout error: %d\n", __FUNCTION__, ret);
 		return 1;
 	}
-
 	io_uring_cqe_seen(ring, cqe);
 	return 0;
 }
-- 
2.33.0

