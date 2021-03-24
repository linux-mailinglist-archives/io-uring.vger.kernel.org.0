Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D4D347AFD
	for <lists+io-uring@lfdr.de>; Wed, 24 Mar 2021 15:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236247AbhCXOoj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Mar 2021 10:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236115AbhCXOob (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Mar 2021 10:44:31 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9812AC061763
        for <io-uring@vger.kernel.org>; Wed, 24 Mar 2021 07:44:29 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id z2so24744487wrl.5
        for <io-uring@vger.kernel.org>; Wed, 24 Mar 2021 07:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pLCZen4uMh8bBYSnr2qHObZtlu/T6kvlU/ukP9PT6/M=;
        b=P1dMjD4m42QcraQenk3tY/GGv9XMl6yi+q3IHFM6LH9/eVtN6oQ/Cd5Nozx/3AUrwC
         YxNBXTjQF6P/PWB7492ubrRP38HmCukh6SXHBdy0a/5wRZKevahZudM4ie11aoREQ6vG
         cQyLwtORu+LxMRJ3fonReIEMytKJvf3xH2hS/HoV46tQ5c0MEBoQPXzM5sATrlTJPOwY
         phgWhNMml2aL5gm0ciXmKKZed06RTZB9Xd7mhX7XY54g8euQJOhgnvugeoBoRS+p1JRT
         6szu9d9YQFY/2WMgKhufAt63jXaJSpUqwY3QH7nIAdy8Lo1hR2BfzmJOMDpVdR1vYkcy
         uRyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pLCZen4uMh8bBYSnr2qHObZtlu/T6kvlU/ukP9PT6/M=;
        b=h+lo/ZyC3FF6ZVbvNEbrglhnMMlMK30nrHXjmzB6gCwOIt8uwLFC8teZA8GyYPuN7l
         UIfv+E/C6gZGYRUEmL7jcJEwge6VoPK+HYoafKEsmW3fA7mHhvR0wA0Wye40nW9seBp6
         iREczfweXyl6XIAO88PMG+b5qAU2IR/PCloMP31QXH4FabopX5wM11vOvqcIKbnqP+2Y
         5qU/4gYVKykc2yJcTVzUsdqM4k+1WboaDbz+oFKRQ28sdSRJGlfXlfhjPt5BGrxtgz5z
         LHszd6ZerG3tqzHuftZSwUiuz7/zWcwFPb05hp6b7qZt3rDYChf6VnBJ9meNZfcJfgyv
         SA6g==
X-Gm-Message-State: AOAM533o7eQo9A0sh5JUAwQbgtc3UdySQcoX7dY9yjundRhLBt7By9Bo
        clAXH7hKzZjxfRJKZRKmVes=
X-Google-Smtp-Source: ABdhPJw5f73qKsK1Z8ELqL+C7k8lAOmK7KJnrDd5JacdxF4BgoIubJg0bWQigoyYKlygczllaIFCDw==
X-Received: by 2002:adf:fb87:: with SMTP id a7mr3963561wrr.58.1616597068348;
        Wed, 24 Mar 2021 07:44:28 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.168])
        by smtp.gmail.com with ESMTPSA id q15sm3368278wrr.58.2021.03.24.07.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 07:44:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.12] io_uring: reg buffer overflow checks hardening
Date:   Wed, 24 Mar 2021 14:40:21 +0000
Message-Id: <41c8fce27c696171e845a6304f87ec06d853c5a6.1616596655.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We are safe with overflows in io_sqe_buffer_register() because it will
only yield allocation failure, but it's nicer to check explicitly.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f3ae83a2d7bc..c33c2eb2a131 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8306,6 +8306,8 @@ static int io_buffers_map_alloc(struct io_ring_ctx *ctx, unsigned int nr_args)
 
 static int io_buffer_validate(struct iovec *iov)
 {
+	u64 tmp, acct_len = iov->iov_len + (PAGE_SIZE - 1);
+
 	/*
 	 * Don't impose further limits on the size and buffer
 	 * constraints here, we'll -EINVAL later when IO is
@@ -8318,6 +8320,9 @@ static int io_buffer_validate(struct iovec *iov)
 	if (iov->iov_len > SZ_1G)
 		return -EFAULT;
 
+	if (check_add_overflow((u64)iov->iov_base, acct_len, &tmp))
+		return -EOVERFLOW;
+
 	return 0;
 }
 
-- 
2.24.0

