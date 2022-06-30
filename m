Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81B7A561606
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 11:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234104AbiF3JRe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 05:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234230AbiF3JQ4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 05:16:56 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDF82317A
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:15:47 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id pk21so37787459ejb.2
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dMzrJltt3Iz1UQO1HIChWcMGE5HPP4FS9fPwzQNrQwY=;
        b=SGAL+LN/L3JR8BXM7p3OAcInVNg4Qc1jCESDnbDFZ5CNRjvvl6rpNo7F9eTTIL1aMN
         Qpi0Fv1oMjIMKTaP+CDFp/cn0U2YeCB5BB0eap8Z55aH7UWq0swBHN0xwB7yPlcs7QYI
         nshwE+NlLHRyr05iXT/LaEmxcb2mQStbl25q5gAsnacb2Nsh3F3GlnNUK2i7+YtzJRwr
         h6l4jS9oQyDqifXHWW3CBc39S+7PW/BQyR6wQ+MTPu3r3OkiWly+ssLF79bj24LslWvm
         lMLT8K1kov18j9VD+8Rgp1exJ/yoE5kU/+/rACuxS3iI2WxwT3UFLOHU4s4X1oVJ3KvO
         p75A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dMzrJltt3Iz1UQO1HIChWcMGE5HPP4FS9fPwzQNrQwY=;
        b=WE5hcGaVvuzMYuyc6v/DTQTEfoAARuIzPd8913H2MsPZ/KkU0/CwOiF76mIXBpo44k
         c3JVLNU7wckU6k1tFhg76s/iLb6RvaehjpnpoeQAsJEzeZKNmwbzn1QSBwMrcny+KjjM
         0gJVge1uyCFzxz0NKE4LMmk1j0c+gwByiVqJmIWLsm9xuzEvIrzU1oRvxLm07t3gye+N
         wr2Snnu+pOZFOMj6Pr1asAFzEGBIea/bkcIF0jXPQJUUPBQsZq1jnc+oVUDmGqgBiOeb
         +G4einj3R2OWuDbQC8RB8C0YWZQ1DyD4davEQsHdU7zkQcXet68nufrAOpmB9RMtZUJN
         M49w==
X-Gm-Message-State: AJIora+bJXaRZO10xP9INfgHZokC74skwlikxfDftaowoi1FMneCWrlF
        CXnFkD3/vPQESl7q99QUYW9kIOHcrbmu1A==
X-Google-Smtp-Source: AGRyM1v/x5wi6H1wjEEkbJmqa93I2UtLoIDvDNqBaJIPdJ32Nf/Dj7c5OL0RKYbUCDKTXSXD2BdxjA==
X-Received: by 2002:a17:907:86a7:b0:726:317f:aee0 with SMTP id qa39-20020a17090786a700b00726317faee0mr7887996ejc.229.1656580545645;
        Thu, 30 Jun 2022 02:15:45 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:a3ae])
        by smtp.gmail.com with ESMTPSA id s10-20020a1709060c0a00b0070beb9401d9sm8884925ejf.171.2022.06.30.02.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 02:15:45 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 3/3] test range file alloc
Date:   Thu, 30 Jun 2022 10:13:39 +0100
Message-Id: <decaf87bd125ad0e77261985e521926aff66ff34.1656580293.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656580293.git.asml.silence@gmail.com>
References: <cover.1656580293.git.asml.silence@gmail.com>
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
index cd00a90..dc4e685 100644
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
 		return ret;
 	}
 
+	ret = test_file_alloc_ranges();
+	if (ret) {
+		printf("test_partial_register_fail failed\n");
+		return ret;
+	}
+
 	return T_EXIT_PASS;
 }
-- 
2.36.1

