Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2757561DDF
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 16:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235904AbiF3O1v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 10:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237248AbiF3O1e (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 10:27:34 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F30970FA
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 07:11:00 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id d17so21858964wrc.10
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 07:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9CSSBlVA41txnEF4i9iPkjMmXpNWeV/0IRlPML7MZQ8=;
        b=Fd54ukisVzQPnUSLQF+pqPjVBEKaxkDd7xMx9ZB5QSxTQf0J+PeYtnnrSEQOS8Y2mn
         OaE0zVjnzaeOJh/4JRnW0/1jqJ17CwmxGjCa+eCsDMOsRSrlWTJMO06FO36bkkRxa2zE
         bgqhhDyTegtwDuzHSQFU09WT4yTrPoO6hLAKEMerJbd+DNx2XpvC34si0GVaTPI6NrZq
         q7hvMD9wa7p6mwsHzzLUgVug27vKRZdDgF8/xgBJckmwnR8kJwXW9VrC/uIYmpguEgtA
         ycWALfuFsXyhfNuv0DZRCaAhmuqOSAzkFuwVqhQIpk0SjgJ26rLZG4lUZe0pTS6dmxyu
         MF+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9CSSBlVA41txnEF4i9iPkjMmXpNWeV/0IRlPML7MZQ8=;
        b=BsMXPbqncKmd9kEWPFVF2bFLSWixMlWIBubhjmeMLzeafOm/EbRO+GmwhqcqgHpjLk
         dulii3b2YlJ/uwHP8zEfsVl+9wHdmW9GDYXbqFTxqVq9fS9tovX5Cw8VWysyom+letie
         F4eWBPpZ27JfAdAOUk5vj4Ml26gS9NWl8Xjupz+tNMs61wq9LQAoMX7rix2N5al+0WLW
         YpID/vT4I4138mlny/Y+DNYSCRLWmAq4V+41lhGXHz64lTUXr098eLY6NWQuSX64GRKa
         JhM8gInKuk48vaEXGzxLlyr6xIks8FUnSGCfDqHjEbypDqc/MSmUf3hB8FQeX22SBY18
         IdCQ==
X-Gm-Message-State: AJIora9jOOgd4PQC4gGHYGAZbues062lRz39bZ310A5V4uQ+EoaWH5WS
        RZe3p/7e0Kc1+h2bFM49JfSHTGKRgIs4Vw==
X-Google-Smtp-Source: AGRyM1tpje9GIR4K4XYkoO4FXIW+kSrRNnU5qrP0NjSl/n3SYa8+2xzRNXRSCm+ULO+LfsMApDRH4A==
X-Received: by 2002:a5d:47a1:0:b0:21d:34:67b with SMTP id 1-20020a5d47a1000000b0021d0034067bmr8448488wrb.305.1656598243160;
        Thu, 30 Jun 2022 07:10:43 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-232-9.dab.02.net. [82.132.232.9])
        by smtp.gmail.com with ESMTPSA id ay29-20020a05600c1e1d00b003a03be171b1sm3741392wmb.43.2022.06.30.07.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 07:10:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2 5/5] test range file alloc
Date:   Thu, 30 Jun 2022 15:10:17 +0100
Message-Id: <504f4ad22b4eb81f137d6a2208209459122c0fec.1656597976.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656597976.git.asml.silence@gmail.com>
References: <cover.1656597976.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/file-register.c | 171 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 171 insertions(+)

diff --git a/test/file-register.c b/test/file-register.c
index 4004a81..e713233 100644
--- a/test/file-register.c
+++ b/test/file-register.c
@@ -9,6 +9,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <fcntl.h>
+#include <limits.h>
 #include <sys/resource.h>
 
 #include "helpers.h"
@@ -830,6 +831,170 @@ static int test_partial_register_fail(void)
 	return 0;
 }
 
+static int file_update_alloc(struct io_uring *ring, int *fd)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int ret;
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_files_update(sqe, fd, 1, IORING_FILE_INDEX_ALLOC);
+
+	ret = io_uring_submit(ring);
+	if (ret != 1) {
+		fprintf(stderr, "%s: got %d, wanted 1\n", __FUNCTION__, ret);
+		return -1;
+	}
+
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret < 0) {
+		fprintf(stderr, "%s: io_uring_wait_cqe=%d\n", __FUNCTION__, ret);
+		return -1;
+	}
+	ret = cqe->res;
+	io_uring_cqe_seen(ring, cqe);
+	return ret;
+}
+
+static int test_out_of_range_file_ranges(struct io_uring *ring)
+{
+	int ret;
+
+	ret = io_uring_register_file_alloc_range(ring, 8, 3);
+	if (ret != -EINVAL) {
+		fprintf(stderr, "overlapping range %i\n", ret);
+		return 1;
+	}
+
+	ret = io_uring_register_file_alloc_range(ring, 10, 1);
+	if (ret != -EINVAL) {
+		fprintf(stderr, "out of range index %i\n", ret);
+		return 1;
+	}
+
+	ret = io_uring_register_file_alloc_range(ring, 7, ~1U);
+	if (ret != -EOVERFLOW) {
+		fprintf(stderr, "overflow %i\n", ret);
+		return 1;
+	}
+
+	return 0;
+}
+
+static int test_overallocating_file_range(struct io_uring *ring, int fds[2])
+{
+	int roff = 7, rlen = 2;
+	int ret, i, fd;
+
+	ret = io_uring_register_file_alloc_range(ring, roff, rlen);
+	if (ret) {
+		fprintf(stderr, "io_uring_register_file_alloc_range %i\n", ret);
+		return 1;
+	}
+
+	for (i = 0; i < rlen; i++) {
+		fd = fds[0];
+		ret = file_update_alloc(ring, &fd);
+		if (ret != 1) {
+			fprintf(stderr, "file_update_alloc\n");
+			return 1;
+		}
+
+		if (fd < roff || fd >= roff + rlen) {
+			fprintf(stderr, "invalid off result %i\n", fd);
+			return 1;
+		}
+	}
+
+	fd = fds[0];
+	ret = file_update_alloc(ring, &fd);
+	if (ret != -ENFILE) {
+		fprintf(stderr, "overallocated %i, off %i\n", ret, fd);
+		return 1;
+	}
+
+	return 0;
+}
+
+static int test_zero_range_alloc(struct io_uring *ring, int fds[2])
+{
+	int ret, fd;
+
+	ret = io_uring_register_file_alloc_range(ring, 7, 0);
+	if (ret) {
+		fprintf(stderr, "io_uring_register_file_alloc_range failed %i\n", ret);
+		return 1;
+	}
+
+	fd = fds[0];
+	ret = file_update_alloc(ring, &fd);
+	if (ret != -ENFILE) {
+		fprintf(stderr, "zero alloc %i\n", ret);
+		return 1;
+	}
+	return 0;
+}
+
+static int test_file_alloc_ranges(void)
+{
+	struct io_uring ring;
+	int ret, pipe_fds[2];
+
+	if (pipe(pipe_fds)) {
+		fprintf(stderr, "pipes\n");
+		return 1;
+	}
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "queue_init: %d\n", ret);
+		return 1;
+	}
+
+	ret = io_uring_register_files_sparse(&ring, 10);
+	if (ret == -EINVAL) {
+not_supported:
+		close(pipe_fds[0]);
+		close(pipe_fds[1]);
+		io_uring_queue_exit(&ring);
+		printf("file alloc ranges are not supported, skip\n");
+		return 0;
+	} else if (ret) {
+		fprintf(stderr, "io_uring_register_files_sparse %i\n", ret);
+		return ret;
+	}
+
+	ret = io_uring_register_file_alloc_range(&ring, 0, 1);
+	if (ret) {
+		if (ret == -EINVAL)
+			goto not_supported;
+		fprintf(stderr, "io_uring_register_file_alloc_range %i\n", ret);
+		return 1;
+	}
+
+	ret = test_overallocating_file_range(&ring, pipe_fds);
+	if (ret) {
+		fprintf(stderr, "test_overallocating_file_range() failed\n");
+		return 1;
+	}
+
+	ret = test_out_of_range_file_ranges(&ring);
+	if (ret) {
+		fprintf(stderr, "test_out_of_range_file_ranges() failed\n");
+		return 1;
+	}
+
+	ret = test_zero_range_alloc(&ring, pipe_fds);
+	if (ret) {
+		fprintf(stderr, "test_zero_range_alloc() failed\n");
+		return 1;
+	}
+
+	close(pipe_fds[0]);
+	close(pipe_fds[1]);
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
 	struct io_uring ring;
@@ -949,5 +1114,11 @@ int main(int argc, char *argv[])
 		return T_EXIT_FAIL;
 	}
 
+	ret = test_file_alloc_ranges();
+	if (ret) {
+		fprintf(stderr, "test_partial_register_fail failed\n");
+		return T_EXIT_FAIL;
+	}
+
 	return T_EXIT_PASS;
 }
-- 
2.36.1

