Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6447231EEFE
	for <lists+io-uring@lfdr.de>; Thu, 18 Feb 2021 19:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbhBRSwf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Feb 2021 13:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232725AbhBRSgh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Feb 2021 13:36:37 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D346C061A2E
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 10:34:14 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id o24so4810125wmh.5
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 10:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FcRDUdaUu0FgLE0H9Ma8fWRbKfFuiYxozqwzcx3w0i4=;
        b=f8a2ECM26F8jv+dBsPWEV8ZvaC1i9fWa9c+tRFTlVLgiXyoZEvYAqjsd7zRbxfVm/n
         xcs9BoTf26YJ6+R2UG+3lyo3rkznm18xLeXQaL6vSf88tcBKHCOrwfVHMiuLyNg9yGF8
         BENMnSvp9UQKCUc//XnWZNUOIfbrMI8y3OU5rjGe9tDgt2dMeNzVKld5jqpuEYfayoGh
         8l4u91p0WC2xOi21HRPgNdlvciomqzPkn74O2E3fLThvZ/2xLu+aJ0hu7VR5O7fyp7XL
         PTGtAAU1OwCst80FsMRtS9zsG/MofY1++dcS2rd89wCLjnzTs9w66azqMWimyMZtSfnn
         SYRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FcRDUdaUu0FgLE0H9Ma8fWRbKfFuiYxozqwzcx3w0i4=;
        b=rrssYzax33wvioLfInFU990Ns5B3WVxSS6Jkg5gEFVSe8smfVW/PQ5lS9QAjm18a2G
         ifnlX8WiPY7RLmSTXKXU3tzW3DHySoxbwhXjv84EY+N5gEsEekZMS7LreLor9TMS84Jb
         zFN9SG0hSaNDzZvIbT1HM1F0gb/4qJHU4oK0pHtMWL+UO4IHu+aDwVC+6AiqnnNorv3X
         P5IiRjVUlPU/XeMLLJPXo99kcILyENZKpaGL9ccg/uH4pERDMSZ/IcGdu79YQQzLP3mG
         w5C4FMEstnHuIh716kQhNXsYwSId5EPEsTBs1YccpFVAyyr1l3015YEWz+D4s0vVkwqS
         EfjA==
X-Gm-Message-State: AOAM53292/wcADhpoLvik03SZFdAwf4pE3L8+eQelq2lVDaP1OjLDmbf
        VSFJSVrIwN/sZlIwriFeKbY4pBGbh4u93g==
X-Google-Smtp-Source: ABdhPJzgkcBfGarqVGwZLl/XRf3CDC5cgNmDLP+ZnzncHDPMTLmbF5BmiGXWcnt4XpSOolZR3vjZKA==
X-Received: by 2002:a05:600c:21c1:: with SMTP id x1mr1465243wmj.185.1613673252889;
        Thu, 18 Feb 2021 10:34:12 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id z2sm8658647wml.30.2021.02.18.10.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 10:34:12 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing] test: don't expect links to be partially executed
Date:   Thu, 18 Feb 2021 18:30:17 +0000
Message-Id: <0b73a72d85384612118173d0a26609a728316b63.1613672934.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When we link a buggy request, the whole link collected by that moment
may be cancelled even before it got issued. Don't expect it to be
partially executed.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/register-restrictions.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/test/register-restrictions.c b/test/register-restrictions.c
index 04a0ed9..bcae67c 100644
--- a/test/register-restrictions.c
+++ b/test/register-restrictions.c
@@ -351,13 +351,19 @@ static int test_restrictions_flags(void)
 	io_uring_sqe_set_flags(sqe, IOSQE_FIXED_FILE | IOSQE_IO_LINK);
 	sqe->user_data = 3;
 
+	ret = io_uring_submit(&ring);
+	if (ret != 3) {
+		fprintf(stderr, "submit: %d\n", ret);
+		return TEST_FAILED;
+	}
+
 	sqe = io_uring_get_sqe(&ring);
 	io_uring_prep_writev(sqe, 1, &vec, 1, 0);
 	io_uring_sqe_set_flags(sqe, IOSQE_FIXED_FILE | IOSQE_IO_DRAIN);
 	sqe->user_data = 4;
 
 	ret = io_uring_submit(&ring);
-	if (ret != 4) {
+	if (ret != 1) {
 		fprintf(stderr, "submit: %d\n", ret);
 		return TEST_FAILED;
 	}
-- 
2.24.0

