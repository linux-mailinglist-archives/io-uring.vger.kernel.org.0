Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6102FA6F6
	for <lists+io-uring@lfdr.de>; Mon, 18 Jan 2021 18:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405593AbhARRBy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Jan 2021 12:01:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405598AbhARRBR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Jan 2021 12:01:17 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 255AFC061573
        for <io-uring@vger.kernel.org>; Mon, 18 Jan 2021 09:00:37 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id 19so19246905qkm.8
        for <io-uring@vger.kernel.org>; Mon, 18 Jan 2021 09:00:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6wVZ1BD3+JwRQLMeJJNiqw6Kt3sygGRXA8rEGOaBmRo=;
        b=c7QSKVUAEG2RR1HAWOx65Kb8SBxm+sahkxz03uKpIh97YRgOdkBj4rQJgyxC+27TUs
         cJOkhiH7AZUSifKqyBZNkNgGkkNMGF7Dirv+OIyS4+hLGdBbyGQHtDo6tHm6g+VVoxIj
         s9fXnyLECnZvactzqC3tDpCNuIvpatSdtMXDAjTDF5ksehuHhGaLoosIda/2Kpqn6FB2
         Yy0/5176EIZ9K9Qpvq9vlxc4dTzo1vY/ORT2NfqqyrAbez3+nJL6JetOplHttgB3jv+c
         /CRnXh0svOLQ1Gx3qn48+ihIAETHEUtTVjjLislJKqQUBRy8jYnfQBbFbaMcmpz0veJf
         +GlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6wVZ1BD3+JwRQLMeJJNiqw6Kt3sygGRXA8rEGOaBmRo=;
        b=P4Dx3W1N2nFbNfiHSG7GmrOQHuECM2tQkZVfzMBnPytmaL7zgt7q4/FBx1Wlhvpz9Y
         FoKv11WghKXAmOCpHH04Bcgn/fZFjf7rbF6sPaQjR/khhwHLXIYlJbYhwXxcSjhV/Tvo
         Y3ST5vKaqPcDds05RMn3SnwB2aU93kb6TuO4bw2bTaDwShbCvXvWxrZ5PQaXmAbct/fI
         e4Uy7eIW1GILavLXxULP4UA6gfWmpvH7pfXVqkMasQcIo0mxbvCx+dkdNzQiUprzT+oP
         YuP+Mgwv/Cuc27EbJkdwEqAmHqgmp16+oBSyYVfFDY/2iaEKAq8fyeHBqRbf5RHhptec
         pu3g==
X-Gm-Message-State: AOAM533b3CnaN6Lx2tM+n3azLZ/BlwaZ6oAscGRLfC8swkFGCUG7n/qw
        EZHisgYh3G2wYWhebMjAM4Q=
X-Google-Smtp-Source: ABdhPJyQk6nOg+BBze0NEdlzQvi6QWcHzo36TfAyi5Cth4LeeyBTWF0dMV5+JeEACzF0BNAac8tu4w==
X-Received: by 2002:a05:620a:1392:: with SMTP id k18mr486607qki.225.1610989236452;
        Mon, 18 Jan 2021 09:00:36 -0800 (PST)
Received: from marcelo-debian.domain (cpe-184-152-69-119.nyc.res.rr.com. [184.152.69.119])
        by smtp.gmail.com with ESMTPSA id d140sm11182889qkc.111.2021.01.18.09.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 09:00:35 -0800 (PST)
From:   Marcelo Diop-Gonzalez <marcelo827@gmail.com>
To:     axboe@kernel.dk
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        Marcelo Diop-Gonzalez <marcelo827@gmail.com>
Subject: [PATCH liburing] tests: add another timeout sequence test case
Date:   Mon, 18 Jan 2021 12:00:29 -0500
Message-Id: <20210118170029.107274-1-marcelo827@gmail.com>
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
 test/timeout.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/test/timeout.c b/test/timeout.c
index 9c8211c..d46d93d 100644
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
@@ -149,6 +149,8 @@ static int test_single_timeout_nr(struct io_uring *ring)
 			goto err;
 		}
 
+		ret = cqe->res;
+
 		/*
 		 * NOP commands have user_data as 1. Check that we get the
 		 * two NOPs first, then the successfully removed timout as
@@ -167,15 +169,16 @@ static int test_single_timeout_nr(struct io_uring *ring)
 				fprintf(stderr, "%s: timeout not last\n", __FUNCTION__);
 				goto err;
 			}
+			if (ret) {
+				fprintf(stderr, "%s: timeout triggered by passage of"
+					" time, not by events completed\n", __FUNCTION__);
+				goto err;
+			}
 			break;
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
@@ -1224,9 +1227,14 @@ int main(int argc, char *argv[])
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

