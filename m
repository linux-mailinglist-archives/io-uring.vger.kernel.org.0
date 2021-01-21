Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 069A52FF34F
	for <lists+io-uring@lfdr.de>; Thu, 21 Jan 2021 19:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbhAUS0j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jan 2021 13:26:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389586AbhAUSQo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jan 2021 13:16:44 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E28C061756
        for <io-uring@vger.kernel.org>; Thu, 21 Jan 2021 10:16:00 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id h22so2591240qkk.4
        for <io-uring@vger.kernel.org>; Thu, 21 Jan 2021 10:16:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pbcd4r/7X/qpoEr8CdX/LKjS0/5sGCMvQ7pmg1qlCs8=;
        b=TStbAP7E9cZyMzJhxhuJSfsQb2Di5a7UNzG23uLxjDhNDXD13DodcQZRtQd6cs4dtD
         h7UrteVI810IvTfI3cqp8ofSyPLJKzUdXzRQUGAUFrx9uJcJBMRHNc7Csi8xOUHIwvCw
         e6ZM4Gd1g+N7Q83hxPTOKi9PqTlE+HXJDTK4o/RmwCwAbje4HYspvBoDegqrpUvijMLP
         cH7iLIYLI9hOx1vJpBG05Lk2SqCfX46uE8senjXzYrfqVzGIbx+ExaxNn6u9KkIwTYr+
         9oarE1CjCrLiJCsuDJJ3hePyORTcS+AYND6c0dICu0dmphJ6H03G8U797PIweacwAB2+
         99LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pbcd4r/7X/qpoEr8CdX/LKjS0/5sGCMvQ7pmg1qlCs8=;
        b=eNKzOFgk8yrcs4zFi+aCPeVzMahG4GBP/mT+8uz4U9DoMQKbJHZp7J0skE/oeuEWlL
         QWPLLcFx6zy953DPGtJZDdmfY3rLbndEAC5DEME55D8ShXabVmneDec/4yr/xpPndsbX
         3+zPclTZGxlbOwyCK5G98nfw3VIvP3oN6Svu6XZZo/7pY/hxNQIlhEXMKdWDCnEA/1Qu
         s5r6OyV7TpU+yP6Dw3apQMT3NACGEMCaGAljZyr3oVwaYN63rsS52C9V9URPUfC2aYx4
         Dclf5K5qFQNGv/7zNQmCwsOvgcFHrGKIyipGHseIfLM6Gag0YQi0i3CV46zmMkuDfwdp
         8cGQ==
X-Gm-Message-State: AOAM532c+9REox2PBTvx7/BTSCkSp1EKQs1zkUg2BVUXrUvq6fg7sy0p
        EQEWfG9C3tqqSnqmJjTPdPc=
X-Google-Smtp-Source: ABdhPJwtz6hfFWGj5m5JKKegpMHhj0IIXlcnXF99wXq8hUh71sl9cs9xk6IxlqENOx41Whz7U8y1gQ==
X-Received: by 2002:a05:620a:783:: with SMTP id 3mr1025782qka.368.1611252959796;
        Thu, 21 Jan 2021 10:15:59 -0800 (PST)
Received: from marcelo-debian.domain (cpe-184-152-69-119.nyc.res.rr.com. [184.152.69.119])
        by smtp.gmail.com with ESMTPSA id x25sm4210325qkx.88.2021.01.21.10.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 10:15:58 -0800 (PST)
From:   Marcelo Diop-Gonzalez <marcelo827@gmail.com>
To:     axboe@kernel.dk
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        Marcelo Diop-Gonzalez <marcelo827@gmail.com>
Subject: [PATCH liburing v2] tests: add another timeout sequence test case
Date:   Thu, 21 Jan 2021 13:15:55 -0500
Message-Id: <20210121181555.110707-1-marcelo827@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This test case catches an issue where timeouts may not be flushed
if the number of new events is greater (not equal) to the number
of events requested in the timeout.

Signed-off-by: Marcelo Diop-Gonzalez <marcelo827@gmail.com>
---

v2: Don't assume the timeout should be last when nr < 2.

 test/timeout.c | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/test/timeout.c b/test/timeout.c
index 9c8211c..a28d599 100644
--- a/test/timeout.c
+++ b/test/timeout.c
@@ -112,7 +112,7 @@ err:
 /*
  * Test numbered trigger of timeout
  */
-static int test_single_timeout_nr(struct io_uring *ring)
+static int test_single_timeout_nr(struct io_uring *ring, int nr)
 {
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
@@ -126,7 +126,7 @@ static int test_single_timeout_nr(struct io_uring *ring)
 	}
 
 	msec_to_ts(&ts, TIMEOUT_MSEC);
-	io_uring_prep_timeout(sqe, &ts, 2, 0);
+	io_uring_prep_timeout(sqe, &ts, nr, 0);
 
 	sqe = io_uring_get_sqe(ring);
 	io_uring_prep_nop(sqe);
@@ -149,33 +149,26 @@ static int test_single_timeout_nr(struct io_uring *ring)
 			goto err;
 		}
 
+		ret = cqe->res;
+
 		/*
 		 * NOP commands have user_data as 1. Check that we get the
-		 * two NOPs first, then the successfully removed timout as
-		 * the last one.
+		 * at least 'nr' NOPs first, then the successfully removed timout.
 		 */
-		switch (i) {
-		case 0:
-		case 1:
-			if (io_uring_cqe_get_data(cqe) != (void *) 1) {
-				fprintf(stderr, "%s: nop not seen as 1 or 2\n", __FUNCTION__);
+		if (io_uring_cqe_get_data(cqe) == NULL) {
+			if (i < nr) {
+				fprintf(stderr, "%s: timeout received too early\n", __FUNCTION__);
 				goto err;
 			}
-			break;
-		case 2:
-			if (io_uring_cqe_get_data(cqe) != NULL) {
-				fprintf(stderr, "%s: timeout not last\n", __FUNCTION__);
+			if (ret) {
+				fprintf(stderr, "%s: timeout triggered by passage of"
+					" time, not by events completed\n", __FUNCTION__);
 				goto err;
 			}
-			break;
 		}
 
-		ret = cqe->res;
 		io_uring_cqe_seen(ring, cqe);
-		if (ret < 0) {
-			fprintf(stderr, "Timeout: %s\n", strerror(-ret));
-			goto err;
-		} else if (ret) {
+		if (ret) {
 			fprintf(stderr, "res: %d\n", ret);
 			goto err;
 		}
@@ -1224,9 +1217,14 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
-	ret = test_single_timeout_nr(&ring);
+	ret = test_single_timeout_nr(&ring, 1);
+	if (ret) {
+		fprintf(stderr, "test_single_timeout_nr(1) failed\n");
+		return ret;
+	}
+	ret = test_single_timeout_nr(&ring, 2);
 	if (ret) {
-		fprintf(stderr, "test_single_timeout_nr failed\n");
+		fprintf(stderr, "test_single_timeout_nr(2) failed\n");
 		return ret;
 	}
 
-- 
2.20.1

