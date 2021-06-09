Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6D33A136B
	for <lists+io-uring@lfdr.de>; Wed,  9 Jun 2021 13:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239535AbhFILux (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Jun 2021 07:50:53 -0400
Received: from mail-ed1-f51.google.com ([209.85.208.51]:47099 "EHLO
        mail-ed1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239485AbhFILuF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Jun 2021 07:50:05 -0400
Received: by mail-ed1-f51.google.com with SMTP id r11so28260039edt.13
        for <io-uring@vger.kernel.org>; Wed, 09 Jun 2021 04:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GJ8mdQKDK9pjvBSIfUUsoLM94xFGvd6gz+K9BFJCB5E=;
        b=DIjDqQabiwbXg4B6dGmkM847y+vKDuMvwjJBON9dQ0jbaqpOkumoITTFnaXz0c/L/k
         ayepR6YtJ6pIH6upSdZYIaOeXLgCmGRjS1+QP9RfXDWJTo+BJPLwnzhjj4h64+Zrd7jE
         hdgRhw2mmCW5ZW+cHdIP8/DfX9kbTcX9Gg74YdZs/gWIqlc6TiSJ5vUjkLhQvyxsgZVF
         187SU0RMKFhm2gipzkqZACjLhRPAMqAwfp51OEQYDCSe2eOmURe8v4mB210SOPVIi+y1
         kR8MS+yIVCZoOi3lRbYr/n5wXIfzjcQimpTLNho739Q16t7Zv/zjLyIY/DtQP8GRMcdH
         qIKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GJ8mdQKDK9pjvBSIfUUsoLM94xFGvd6gz+K9BFJCB5E=;
        b=O1gskR7QGw0Htzuuls2pDjedpQrUiJAi0N2rxIL1TcB5Xk5RPpxQdNVzsMWRaLUcEW
         K0ZTEW+Cjs0DxUjCQp5wgbSVb7BFBBPOKl/stOEfvrg4aERL+9IxWFUBnE2lHLUuoEus
         OpEjVm2Vi9Zhj47jYhoNGvIp+xXcb6Zb19ClyxVElgGv0WDlryv3oEe4clXOkvKFRPqq
         MSo2ExwFkseHcP21kz2HMJ+XraoC0lWGxx9ouHVsDdjKJZL2eZkUAuRE+iVE34cHQNkY
         6Ao90UO2tK5tvNvr66K/SQdFzFGdYc2it+18Hn0kkYB47AEBAmJ+FOLFkbdSSQUBlXer
         7z7A==
X-Gm-Message-State: AOAM532AydepAvssUo27kR6GUcN00ChrSexOvRrkzG7nWU5l5VYfY2sS
        SECE/7Aqdy4dAxch/P6m70g=
X-Google-Smtp-Source: ABdhPJyPKA8uvyvYFtyVzqF0a39XXER+K65XxA9Ya+viPHVnEjgS1kgbFcVPFqNINJJvUMZDKz2UuQ==
X-Received: by 2002:a05:6402:152:: with SMTP id s18mr29560854edu.221.1623239230141;
        Wed, 09 Jun 2021 04:47:10 -0700 (PDT)
Received: from agony.thefacebook.com ([2620:10d:c092:600::2:c753])
        by smtp.gmail.com with ESMTPSA id h9sm1049762edt.18.2021.06.09.04.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 04:47:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 1/1] tests: update reg-buf limits testing
Date:   Wed,  9 Jun 2021 12:46:54 +0100
Message-Id: <947234e13ba32fdc9b8ce45f679d78b9d08cb46a.1623239194.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We now allow more fixed buffers to be registered, update tests from the
previous UIO_MAXIOV limit to something that will definitely fail.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/io_uring_register.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/test/io_uring_register.c b/test/io_uring_register.c
index 7bcb036..1d0981b 100644
--- a/test/io_uring_register.c
+++ b/test/io_uring_register.c
@@ -280,12 +280,16 @@ int
 test_iovec_nr(int fd)
 {
 	int i, ret, status = 0;
-	unsigned int nr = UIO_MAXIOV + 1;
+	unsigned int nr = 1000000;
 	struct iovec *iovs;
 	void *buf;
 
+	iovs = malloc(nr * sizeof(struct iovec));
+	if (!iovs) {
+		fprintf(stdout, "can't allocate iovecs, skip\n");
+		return 0;
+	}
 	buf = t_malloc(pagesize);
-	iovs = t_malloc(nr * sizeof(struct iovec));
 
 	for (i = 0; i < nr; i++) {
 		iovs[i].iov_base = buf;
@@ -295,7 +299,7 @@ test_iovec_nr(int fd)
 	status |= expect_fail(fd, IORING_REGISTER_BUFFERS, iovs, nr, EINVAL);
 
 	/* reduce to UIO_MAXIOV */
-	nr--;
+	nr = UIO_MAXIOV;
 	printf("io_uring_register(%d, %u, %p, %u)\n",
 	       fd, IORING_REGISTER_BUFFERS, iovs, nr);
 	ret = __sys_io_uring_register(fd, IORING_REGISTER_BUFFERS, iovs, nr);
-- 
2.31.1

