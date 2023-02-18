Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD8269BB73
	for <lists+io-uring@lfdr.de>; Sat, 18 Feb 2023 19:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjBRSrL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Feb 2023 13:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjBRSrK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Feb 2023 13:47:10 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4117D12F2B
        for <io-uring@vger.kernel.org>; Sat, 18 Feb 2023 10:47:09 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id m6so900202wmq.2
        for <io-uring@vger.kernel.org>; Sat, 18 Feb 2023 10:47:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=t/nLfYiq63DAjj3bL3juIeKOW9KFjTA4xqZ/Gu32Kac=;
        b=RqAA2ltKB3jG1fB9x20QVilJycbRLWfkZhj3ZJeIgLwHRt6RDrMNPuMX0e3ng1ahdj
         RH2M8Uw3bLes/hHA/v37jFtj0J9eHIx4R5vDv8x8HbubrUJMRij7ci9EcOTg5BORVwL/
         ErVJpHoR1MyuFxjTqOWaff2HK2msVMDoovU7Xm2kAf3Z5rytQA8UfhfFHHA68xdEDHSh
         B1fc90RByvdQAZa4dDmWo89CCMfjVhffAfujoyNmjQTtZoERwL27Msqzwxw1tFI++Arm
         /iaGGepJgKqbUdKaGRhRnLx/WxPqFSrpCeVSSftFyJcK0ctBC6UIGZRuJPqWwDZTeI0Z
         jjbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t/nLfYiq63DAjj3bL3juIeKOW9KFjTA4xqZ/Gu32Kac=;
        b=gE/22JVvyM83/G6kAkDkj9RknbXAn4qkWayLMd9xTNwwaAXz6uMacce17N2edI2R5u
         NrywKO8jH79AMJyTvXHtne7Xk3iqYQvLB2dgZdKG0kVwfUu+xZFleALDpskQHkvJpU+H
         /3dD+MRuhmw/GT+1ixpyPovlKgb8NNgWygEiVGWYWIBcTOIKeWp8L+MBBZpXW+44EABZ
         ZvJmzIlUw4y7loBp5bWndK9iuWTxLALGKDkRyje6ou4058t1oukSJAs9tAxYCmSe5K10
         XltSz2fvO3pUwpQ0if7rE8D83e2WxJcZCK6yldkSmbmchIQqMbaeF/EyTo+PazNRMzxP
         nzyg==
X-Gm-Message-State: AO0yUKUzsKJc7s5KnTvQN//1jWX59IuUBd0zuRrUigged541Fbc1Xjqk
        y3rdkJjPitqP0eIPf65vMD0=
X-Google-Smtp-Source: AK7set8AGdD2iYNEzgzRhbqLPqjWdnKH6Rk4Wg2ZF6TldCAtwgBFv8emP0CR7KkI4jiPPsTXzgsZhQ==
X-Received: by 2002:a05:600c:44c9:b0:3e2:185d:7d1e with SMTP id f9-20020a05600c44c900b003e2185d7d1emr6211718wmo.11.1676746027629;
        Sat, 18 Feb 2023 10:47:07 -0800 (PST)
Received: from localhost.localdomain ([152.37.82.41])
        by smtp.gmail.com with ESMTPSA id e23-20020a7bc2f7000000b003e215a796fasm9123628wmk.34.2023.02.18.10.47.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Feb 2023 10:47:07 -0800 (PST)
From:   Wojciech Lukowicz <wlukowicz01@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Wojciech Lukowicz <wlukowicz01@gmail.com>
Subject: [PATCH liburing] test/buf-ring: add test for buf ring occupying exactly one page
Date:   Sat, 18 Feb 2023 18:46:18 +0000
Message-Id: <20230218184618.70966-1-wlukowicz01@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This shows an issue with how the kernel calculates buffer ring sizes
during their registration.

Allocate two pages, register a buf ring fully occupying the first one,
while protecting the second one to make sure it's not used. The
registration should succeed.

mmapping a single page would be a more practical example, but wouldn't
guarantee the issue gets triggered in case the following page happens
to be accessible.

Signed-off-by: Wojciech Lukowicz <wlukowicz01@gmail.com>
---
This is a failing test, needs the patch I sent earlier.

 test/buf-ring.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/test/buf-ring.c b/test/buf-ring.c
index 9d507ac21e32..7615ddad56a9 100644
--- a/test/buf-ring.c
+++ b/test/buf-ring.c
@@ -9,11 +9,13 @@
 #include <stdlib.h>
 #include <string.h>
 #include <fcntl.h>
+#include <sys/mman.h>
 
 #include "liburing.h"
 #include "helpers.h"
 
 static int no_buf_ring;
+static int pagesize;
 
 /* test trying to register classic group when ring group exists */
 static int test_mixed_reg2(int bgid)
@@ -230,6 +232,50 @@ static int test_bad_reg(int bgid)
 	return !ret;
 }
 
+static int test_full_page_reg(int bgid)
+{
+	struct io_uring ring;
+	int ret;
+	void *ptr;
+	struct io_uring_buf_reg reg = { };
+	int entries = pagesize / sizeof(struct io_uring_buf);
+
+	ret = io_uring_queue_init(1, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "queue init failed %d\n", ret);
+		return 1;
+	}
+
+	ret = posix_memalign(&ptr, pagesize, pagesize * 2);
+	if (ret) {
+		fprintf(stderr, "posix_memalign failed %d\n", ret);
+		goto err;
+	}
+
+	ret = mprotect(ptr + pagesize, pagesize, PROT_NONE);
+	if (ret) {
+		fprintf(stderr, "mprotect failed %d\n", errno);
+		goto err1;
+	}
+
+	reg.ring_addr = (unsigned long) ptr;
+	reg.ring_entries = entries;
+	reg.bgid = bgid;
+
+	ret = io_uring_register_buf_ring(&ring, &reg, 0);
+	if (ret)
+		fprintf(stderr, "register buf ring failed %d\n", ret);
+
+	if (mprotect(ptr + pagesize, pagesize, PROT_READ | PROT_WRITE))
+		fprintf(stderr, "reverting mprotect failed %d\n", errno);
+
+err1:
+	free(ptr);
+err:
+	io_uring_queue_exit(&ring);
+	return ret;
+}
+
 static int test_one_read(int fd, int bgid, struct io_uring *ring)
 {
 	int ret;
@@ -374,6 +420,8 @@ int main(int argc, char *argv[])
 	if (argc > 1)
 		return T_EXIT_SKIP;
 
+	pagesize = getpagesize();
+
 	for (i = 0; bgids[i] != -1; i++) {
 		ret = test_reg_unreg(bgids[i]);
 		if (ret) {
@@ -406,6 +454,12 @@ int main(int argc, char *argv[])
 			fprintf(stderr, "test_mixed_reg2 failed\n");
 			return T_EXIT_FAIL;
 		}
+
+		ret = test_full_page_reg(bgids[i]);
+		if (ret) {
+			fprintf(stderr, "test_full_page_reg failed\n");
+			return T_EXIT_FAIL;
+		}
 	}
 
 	for (i = 0; !no_buf_ring && entries[i] != -1; i++) {
-- 
2.30.2

