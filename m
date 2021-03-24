Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA758348503
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 00:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbhCXXDn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Mar 2021 19:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhCXXDM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Mar 2021 19:03:12 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBEDC06174A
        for <io-uring@vger.kernel.org>; Wed, 24 Mar 2021 16:03:11 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id v4so378204wrp.13
        for <io-uring@vger.kernel.org>; Wed, 24 Mar 2021 16:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/qnlzAlid6Ap+3QMMUIhZRppwElSwx6SKGNWsCYA650=;
        b=Ssf0AvWZ3U0tK6bzymZRwlSi6SwmvXBvfW3iqGZmJj2vzcw7X1mWxWtdY6pEGeqB0j
         zt1ktadX0s1ybaar/K9m0/AMgyXWQe1Pi8+rW7cIsWdkm9G0NGtYUfpv/SuGrpR8QnK3
         OYxABkatG4hxaGNhl9y2eop+ahK9M8NQo/9onOS+2fJt6BOgkfzY6R7sySctZjB3qMdg
         OBCgKPHiZkevOFyJrVT0XGFUiywUHUW1tcUSBxz3/d7oM5Rlfpx9wpK/mYRr3SnClPEI
         LTeLVl67B5WqOzMyPE9BoqN1iYKfaFlueqgsSA00u+F9hekl3X4oJdQv9oVf2dlukteN
         BhCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/qnlzAlid6Ap+3QMMUIhZRppwElSwx6SKGNWsCYA650=;
        b=YwPyZ85a4JdMdRQU6harOsCiLpbdI1YCmDLaNunRnPRjUJ3ssHp7oTXHjw/MDYYbuj
         B2NMVHioHFGJqAVTz4OCVJ+WwtJmybxZQs8QbEyEkMbydkv/b9iJUnUY2u5AgjRVhxfM
         B1NyZ8XayDiep7n7Iv/DT7LM2cfxQNKZDLQlcNV/mYu7V2E2Nflb3krvrnyKJuoiCsH8
         S3RzuHvgDF5g7NUM7SW2hbATg8MVx6yDUlPKV9AYsO81jIS6X9m3yfHF0NMZ5Uv0FHxm
         H1wyGNPIiWpp2Kacob++eu5QC/UyPSmc5QPHMsHVSrn/2i9qxAMDV5gaTS8+WCg556ya
         YPeA==
X-Gm-Message-State: AOAM533p56yLtZl1WAteq9I1+PfhWpUjgrIFQcXONrfKxM8OFOyY9RaF
        bMHciJPRXzx7mH2dCQqa4/nuVbOeqvfoEQ==
X-Google-Smtp-Source: ABdhPJwy4p2I2H2i/ey/WCx01aW+Ow7vSvSk+SJZVvt2f4ONk3uKCEYyjA6zVg30l7mpqP2gJuBbaQ==
X-Received: by 2002:adf:8b4e:: with SMTP id v14mr5649702wra.103.1616626990416;
        Wed, 24 Mar 2021 16:03:10 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.168])
        by smtp.gmail.com with ESMTPSA id 135sm4111165wma.44.2021.03.24.16.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 16:03:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2] io_uring: reg buffer overflow checks hardening
Date:   Wed, 24 Mar 2021 22:59:01 +0000
Message-Id: <2b0625551be3d97b80a5fd21c8cd79dc1c91f0b5.1616624589.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We are safe with overflows in io_sqe_buffer_register() because it will
just yield alloc failure, but it's nicer to check explicitly.

v2: replace u64 with ulong to handle 32 bit and match
    io_sqe_buffer_register() math. (Jens)

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f3ae83a2d7bc..f1a3dea05221 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8306,6 +8306,8 @@ static int io_buffers_map_alloc(struct io_ring_ctx *ctx, unsigned int nr_args)
 
 static int io_buffer_validate(struct iovec *iov)
 {
+	unsigned long tmp, acct_len = iov->iov_len + (PAGE_SIZE - 1);
+
 	/*
 	 * Don't impose further limits on the size and buffer
 	 * constraints here, we'll -EINVAL later when IO is
@@ -8318,6 +8320,9 @@ static int io_buffer_validate(struct iovec *iov)
 	if (iov->iov_len > SZ_1G)
 		return -EFAULT;
 
+	if (check_add_overflow((unsigned long)iov->iov_base, acct_len, &tmp))
+		return -EOVERFLOW;
+
 	return 0;
 }
 
-- 
2.24.0

