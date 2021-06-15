Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628FD3A7E17
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 14:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhFOMWk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 08:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbhFOMWj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 08:22:39 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE79C061574
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 05:20:34 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id a11so18084929wrt.13
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 05:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aIBJx9zJ53OGehHYSfIu7yhMODqIxYAvpGurIIueLBE=;
        b=UgCdESv2+0Jg+pJaAtrb191u99b0aMRnu0GjjqgNXLrBnsunijsMdLqWOju20c4cCp
         QCVvD0lipS9SXYO1w1O/nYbHJwJrXQWYld+C3kEt2tAOiPSId/faMEnff/dMzdFeP0pA
         ysH3L0z6GOPdUr4pemPs1J1qoL2Hi8dH1Vx80i1omGjwOnGjKJB/cR8y/6Mdvo7UIBLy
         8HEPX+pMKK99v9owmvubh7RMPzEL/iGC4FepEi2jbDMDCM0W/NIE8n03Er1vpWv7Nahr
         Ec6zrvXQHunmm4t4kakLX5vVqX2/8mCqFb2BMWf+iDghN0VtLzIN7Lr8r2vd7fEIJoJh
         sMww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aIBJx9zJ53OGehHYSfIu7yhMODqIxYAvpGurIIueLBE=;
        b=a60VyskO2oStnNjOcQ9hvsxLamC319kIv0JlO54spl5jjusCHc1Pj7bL06+uNgcRYe
         BQR+xzEa5ei5xnYYwp0uuo0RBVRYGJ/ANHJWd0M55LvJETSKuV9ht4MBAMDyDyI9mgjE
         J65kINy9ViZfR3wOoXKkBESVfA1xMbursRbD5Q1+GUbdlByKZ99S+MNOUr36Q7GcoAJt
         F6yt1T2I62LCA/eQe2qTl/TcbEhpdaiMJ82uFv/X9RhFAm3HDFznQfBL2LDcQfy8+NuQ
         4GFKy0RXvxdprbWkmDhp81UvsvEdzgZ+umLsCY4DmEV1HP91N/D3mVRov1REQus/ur5X
         tCfQ==
X-Gm-Message-State: AOAM530KTIMeehXpXDH3nH23k+3U1251ZnJ53qVCbq4aiiawvVWPPikG
        p4qL41IQqmgU83ZcBr11UvGDwCtCaq3qr5Xt
X-Google-Smtp-Source: ABdhPJxUOmCgf1xcojP5IL5+WlWNDEgTjDjjaKvaJO8rY26MzscTtB3cVMtLhsfaYinUU/MDvsEidA==
X-Received: by 2002:a5d:664c:: with SMTP id f12mr24309345wrw.206.1623759632924;
        Tue, 15 Jun 2021 05:20:32 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id y20sm1305758wma.45.2021.06.15.05.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 05:20:32 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH for-next] io_uring: fix min types mismatch in table alloc
Date:   Tue, 15 Jun 2021 13:20:13 +0100
Message-Id: <50f420a956bca070a43810d4a805293ed54f39d8.1623759527.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

fs/io_uring.c: In function 'io_alloc_page_table':
include/linux/minmax.h:20:28: warning: comparison of distinct pointer
	types lacks a cast

Cast everything to size_t using min_t.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: 9123c8ffce16 ("io_uring: add helpers for 2 level table alloc")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 315fb5df5054..a06c07210696 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7089,7 +7089,7 @@ static void **io_alloc_page_table(size_t size)
 		return NULL;
 
 	for (i = 0; i < nr_tables; i++) {
-		unsigned int this_size = min(size, PAGE_SIZE);
+		unsigned int this_size = min_t(size_t, size, PAGE_SIZE);
 
 		table[i] = kzalloc(this_size, GFP_KERNEL);
 		if (!table[i]) {
-- 
2.31.1

