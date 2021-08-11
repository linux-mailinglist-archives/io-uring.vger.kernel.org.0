Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF3CE3E98E4
	for <lists+io-uring@lfdr.de>; Wed, 11 Aug 2021 21:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbhHKTgK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Aug 2021 15:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbhHKTgI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Aug 2021 15:36:08 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5A9C0613D3
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 12:35:44 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id n12so3380751plf.4
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 12:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oEanWYqex9JuH3iGdmfjQ00rfPxW60wGQ1NzD9wjGSo=;
        b=o2n0uXw2A1dkovhZfrRJwk7J04SXPUMV78vc0FOMnSsnuVtqCj2WcPC/Iqmc7x5FwX
         oann7w01bIooqFyKR1mliZ2wecJ5eTq9TTgSZtiz9Q7oiyIqPG99Hwfl96nNiaONwI4G
         A+7KOq2RIGqH3RNu30ppI/lDnVw/TQW6olt0IclIfRXmgnVa1xiESGUfpjTBIhjasuLi
         wS9nLuibcY/fgmtX3wTgsJ0pwhgHwHqU12cySJgucpQkYJzCIsGyCvwbUtr+ipid3t2t
         DI0GoM/p4Xh9FibPXdpBn0UIYejaoBS+SFQ7OF2Yzdf01y1fGKM/tlkaQXCB/i2bLI5U
         XxiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oEanWYqex9JuH3iGdmfjQ00rfPxW60wGQ1NzD9wjGSo=;
        b=omwJWS6GZTKEqFPrROOk2rRVRaW6pBV/2YzkH0JAy+tK31Ydvq0NPtgddugI+sBF1S
         HTaXxZz5ntvCVtqNAr1WR0h+WZoXdmAYA2uxCzaPw9rZpfmEQBCDX4OJSlfsETsJQeZr
         RW7CmcxlYLmynsgDOvlG/Vxdkt6uWs+n4Dq/wKZ9N/YaHqb0YND4iUyNhYteg3VVwVwa
         oOn29oQIIGYqavajEYEj+LrJWwbR5Rvw72VQfe1jdhZiGjdiwX4Anpa+v1eA8mNjiwXV
         XLsFIUoFYhPdZ+uO7cWP5FASOFiyAZLaqFh7qRikObZCbZBEx5KDivEOt9CMwKuMIA3i
         3UlQ==
X-Gm-Message-State: AOAM532LLI3gMZ07FWBKVD9LVxHVfp0Btfz3d2SG8dEoExc88snmJs6E
        nM3xaiCCSAcYtBFgKY7zKBnPfm7nPDqLgWzF
X-Google-Smtp-Source: ABdhPJwNzpEpb02gfUBt/Jh6uj4oiG5Hz4tPIqqmCtxgyRm82dQwWXlf5CU0LGyPf3PYJFQf4b8e8w==
X-Received: by 2002:a05:6a00:1596:b029:3c7:998a:709 with SMTP id u22-20020a056a001596b02903c7998a0709mr399865pfk.68.1628710543569;
        Wed, 11 Aug 2021 12:35:43 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id u20sm286487pgm.4.2021.08.11.12.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 12:35:43 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, hch@infradead.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/6] io_uring: enable use of bio alloc cache
Date:   Wed, 11 Aug 2021 13:35:32 -0600
Message-Id: <20210811193533.766613-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210811193533.766613-1-axboe@kernel.dk>
References: <20210811193533.766613-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Mark polled IO as being safe for dipping into the bio allocation
cache, in case the targeted bio_set has it enabled.

This brings an IOPOLL gen2 Optane QD=128 workload from ~3.0M IOPS to
~3.3M IOPS.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bd3f8529fe6f..00da7bdd2b53 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2667,7 +2667,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		    !kiocb->ki_filp->f_op->iopoll)
 			return -EOPNOTSUPP;
 
-		kiocb->ki_flags |= IOCB_HIPRI;
+		kiocb->ki_flags |= IOCB_HIPRI | IOCB_ALLOC_CACHE;
 		kiocb->ki_complete = io_complete_rw_iopoll;
 		req->iopoll_completed = 0;
 	} else {
-- 
2.32.0

