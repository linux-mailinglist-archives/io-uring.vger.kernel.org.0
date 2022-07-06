Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A12F567C97
	for <lists+io-uring@lfdr.de>; Wed,  6 Jul 2022 05:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiGFDlg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jul 2022 23:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiGFDle (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jul 2022 23:41:34 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3881D0E6
        for <io-uring@vger.kernel.org>; Tue,  5 Jul 2022 20:41:33 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id d3so12907605ioi.9
        for <io-uring@vger.kernel.org>; Tue, 05 Jul 2022 20:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=xfD3SbcGC6vDn5t/EKU5Z6UJ22begM4XJyyDYZSUc2U=;
        b=VpmL2ptLoaKkm7kvQQ6PjzcTCKUz8+XBguPBg56VYfEG69aK8YTIa0OkgQ47Qe5E1m
         rbwXh0XZiV0rZ6/E5YRezr5ZRS6WaJmOODdrS8PpeSwwp/8VsDsM4i8hJUh+ord+v+oR
         b7RTgsGLVrgdVeVZTZu/AwSAUBTwN25hH/4vpw3PQNGZNO+Yay2P9zW7Tr3I4jKYDWyx
         OhDHzepDiv3BHC/Ezi4wMo04XeYLz/ZUExe9wdNGjIvnEjs6Vds28JZmQ55+KDHVN+h3
         Gfde+JaYP/pBmPGt9KXo/BBZLAuev1qH538Dh8swApQOeaToWFnnpq74MZqrcCGqa76+
         pttg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xfD3SbcGC6vDn5t/EKU5Z6UJ22begM4XJyyDYZSUc2U=;
        b=7D3wq7mmFuwMWdMjUvWrF/b2xkUvyoSWmcNFy1YA1QIq2Jl2SiEuZDSLYkcGzTryuc
         Xu/NhmR67u337bIm3aGCg91NosZtG5zjBx9C8wVJ8OZ4LQdV8nVJ53X+ylYCxPNek72+
         fpZDPBGJ4neGtuPUL8A27ql6bll7ejMpTctP3Nn2+kBEvcafO/7CdX499NCdChO5SQCU
         vW6Mtau58Ote/Yl+5gofFo0VLFaD/XVkDR62a4TOGvmX72EzLVTovieSOW9OOzePuoxS
         XOU4Ob1Kp/1WzQQk1IXVviCvE0RbRtwpTGWAwZupBGdIk8TPRy4xmxIdITCxOtoWFWqa
         unCg==
X-Gm-Message-State: AJIora+QCXxYZRNgcvRDFTp+5yDrb/bZZTk7UKl4O8VEDs/9FB8DRHj8
        UXCJb7c2NuleH5ueyC04+A0EvFDPA2d1rfYC
X-Google-Smtp-Source: AGRyM1uOHUHxiqoZ5M1FxY9UL5o0mlByKFdIZ2vzVGFcJbBrX1oxeK0yHg6H36LRE8Xk1t3f9Z9b9w==
X-Received: by 2002:a05:6602:15d1:b0:678:60ee:88bc with SMTP id f17-20020a05660215d100b0067860ee88bcmr11524997iow.73.1657078892351;
        Tue, 05 Jul 2022 20:41:32 -0700 (PDT)
Received: from didactylos.localdomain ([2600:1700:57f0:ca20:763a:c795:fcf6:91ea])
        by smtp.gmail.com with ESMTPSA id z6-20020a05660217c600b006692192baf7sm16427854iox.25.2022.07.05.20.41.31
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 20:41:31 -0700 (PDT)
From:   Eli Schwartz <eschwartz93@gmail.com>
To:     io-uring@vger.kernel.org
Subject: [PATCH liburing 2/6] tests: handle some skips that used a goto to enter cleanup
Date:   Tue,  5 Jul 2022 23:40:54 -0400
Message-Id: <20220706034059.2817423-3-eschwartz93@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220706034059.2817423-1-eschwartz93@gmail.com>
References: <20220706034059.2817423-1-eschwartz93@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We cannot use the general cleanup-and-succeed here. These were
improperly ported to the exitcode reporting.

Signed-off-by: Eli Schwartz <eschwartz93@gmail.com>
---
 test/accept-test.c             |  7 +++++--
 test/fallocate.c               | 10 ++++++----
 test/files-exit-hang-poll.c    |  6 ++++--
 test/files-exit-hang-timeout.c |  6 ++++--
 test/hardlink.c                |  9 ++++++---
 5 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/test/accept-test.c b/test/accept-test.c
index a898360..99f6080 100644
--- a/test/accept-test.c
+++ b/test/accept-test.c
@@ -61,7 +61,7 @@ int main(int argc, char *argv[])
 	if (!ret) {
 		if (cqe->res == -EBADF || cqe->res == -EINVAL) {
 			fprintf(stdout, "Accept not supported, skipping\n");
-			goto out;
+			goto skip;
 		} else if (cqe->res < 0) {
 			fprintf(stderr, "cqe error %d\n", cqe->res);
 			goto err;
@@ -71,9 +71,12 @@ int main(int argc, char *argv[])
 		return T_EXIT_FAIL;
 	}
 
-out:
 	io_uring_queue_exit(&ring);
 	return T_EXIT_PASS;
+
+skip:
+	io_uring_queue_exit(&ring);
+	return T_EXIT_SKIP;
 err:
 	io_uring_queue_exit(&ring);
 	return T_EXIT_FAIL;
diff --git a/test/fallocate.c b/test/fallocate.c
index a9bf6fd..e804ca5 100644
--- a/test/fallocate.c
+++ b/test/fallocate.c
@@ -67,14 +67,15 @@ static int test_fallocate_rlimit(struct io_uring *ring)
 	if (cqe->res == -EINVAL) {
 		fprintf(stdout, "Fallocate not supported, skipping\n");
 		no_fallocate = 1;
-		goto out;
+		goto skip;
 	} else if (cqe->res != -EFBIG) {
 		fprintf(stderr, "Expected -EFBIG: %d\n", cqe->res);
 		goto err;
 	}
 	io_uring_cqe_seen(ring, cqe);
-out:
 	return 0;
+skip:
+	return T_EXIT_SKIP;
 err:
 	return 1;
 }
@@ -117,7 +118,7 @@ static int test_fallocate(struct io_uring *ring)
 	if (cqe->res == -EINVAL) {
 		fprintf(stdout, "Fallocate not supported, skipping\n");
 		no_fallocate = 1;
-		goto out;
+		goto skip;
 	}
 	if (cqe->res) {
 		fprintf(stderr, "cqe->res=%d\n", cqe->res);
@@ -136,8 +137,9 @@ static int test_fallocate(struct io_uring *ring)
 		goto err;
 	}
 
-out:
 	return 0;
+skip:
+	return T_EXIT_SKIP;
 err:
 	return 1;
 }
diff --git a/test/files-exit-hang-poll.c b/test/files-exit-hang-poll.c
index 432d89f..0c609f1 100644
--- a/test/files-exit-hang-poll.c
+++ b/test/files-exit-hang-poll.c
@@ -93,7 +93,7 @@ int main(int argc, char *argv[])
 		}
 		if (i == 99) {
 			printf("Gave up on finding a port, skipping\n");
-			goto out;
+			goto skip;
 		}
 	}
 
@@ -123,7 +123,9 @@ int main(int argc, char *argv[])
 		return T_EXIT_FAIL;
 	}
 
-out:
 	io_uring_queue_exit(&ring);
 	return T_EXIT_PASS;
+skip:
+	io_uring_queue_exit(&ring);
+	return T_EXIT_SKIP;
 }
diff --git a/test/files-exit-hang-timeout.c b/test/files-exit-hang-timeout.c
index a19afc6..318f0e1 100644
--- a/test/files-exit-hang-timeout.c
+++ b/test/files-exit-hang-timeout.c
@@ -99,7 +99,7 @@ int main(int argc, char *argv[])
 		}
 		if (i == 99) {
 			printf("Gave up on finding a port, skipping\n");
-			goto out;
+			goto skip;
 		}
 	}
 
@@ -129,7 +129,9 @@ int main(int argc, char *argv[])
 		return T_EXIT_FAIL;
 	}
 
-out:
 	io_uring_queue_exit(&ring);
 	return T_EXIT_PASS;
+skip:
+	io_uring_queue_exit(&ring);
+	return T_EXIT_SKIP;
 }
diff --git a/test/hardlink.c b/test/hardlink.c
index f2b8182..29395c3 100644
--- a/test/hardlink.c
+++ b/test/hardlink.c
@@ -98,7 +98,7 @@ int main(int argc, char *argv[])
 	if (ret < 0) {
 		if (ret == -EBADF || ret == -EINVAL) {
 			fprintf(stdout, "linkat not supported, skipping\n");
-			goto out;
+			goto skip;
 		}
 		fprintf(stderr, "linkat: %s\n", strerror(-ret));
 		goto err1;
@@ -121,7 +121,11 @@ int main(int argc, char *argv[])
 		goto err2;
 	}
 
-out:
+	unlinkat(AT_FDCWD, linkname, 0);
+	unlinkat(AT_FDCWD, target, 0);
+	io_uring_queue_exit(&ring);
+	return T_EXIT_SKIP;
+skip:
 	unlinkat(AT_FDCWD, linkname, 0);
 	unlinkat(AT_FDCWD, target, 0);
 	io_uring_queue_exit(&ring);
@@ -134,4 +138,3 @@ err:
 	io_uring_queue_exit(&ring);
 	return T_EXIT_FAIL;
 }
-
-- 
2.35.1

