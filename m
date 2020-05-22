Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B9B1DF09D
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2020 22:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731033AbgEVUYP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 May 2020 16:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731021AbgEVUXU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 May 2020 16:23:20 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7908C08C5C2
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 13:23:19 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id b12so4815001plz.13
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 13:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DT9kV8IQxC/D+uhFJsefv+iJT3TxYB4ReZ7s4ZFOil0=;
        b=oluJiB9kWUp1jQn6GyLmG8WAT4m3lKYyoaZWl/EYudmvX4dpan5EUM8v9K2zM1/sA7
         O3g1BfDhqlwNJGIPOYmdgugrSlOXilKAkvTeGRZUAyg+ubdWg9R3UvtbrB8ako657CER
         OJig952C9v1iZGI2ZOQhlCVH6ErL4Ubx1gxOzYooasGRhDU0/Dt65urTRTAMtn67pdgQ
         gEFv59qa47MpUvtQ+b2fWdA5BKzUAJwUSiYvK2yAGfBa9QmyVAXuxxZeZrInMJdae2Zk
         mY5mg1VVp8HXmhTWFTyUwV1HXJ8c3ncMAaK9kqA0E1p1Xbei/hD9gc3x5raO9d4lvh4l
         JTXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DT9kV8IQxC/D+uhFJsefv+iJT3TxYB4ReZ7s4ZFOil0=;
        b=DRwEZxIgXTsZsrMnRLVN4Avm4rCVIDjMoDzsPA3R6Wi+NERJEKM9UuItthruwZ+cOA
         fS2Cn85X3PVZkupuM4a+XSNqVhAqo4D0LiVdYD45lxMoivJHrBPHWQRufHIBJeX1aH3O
         XwyFmvuWg4rzev6yytckLP3d1195sDqZGYjz8hl5X+6WZ6W1oXiPl/yzM+7JOx12EPfU
         Gceq8dF4a7PIPN9hScZ7UIt25dxVzcrJCRgK35LDDB2Xlb01+miG3KEwdhygpeOkVIWf
         F1rylNeWseKBOG7yP4OSxGHgXoJwx9XSzv7u6uDyS+irqbz80m/KaiEr2aOo/yy6KaTk
         oh2w==
X-Gm-Message-State: AOAM533w6aZ0UNOh4OoAKlkIBofYhqdoJOfO1jCddHHwaJ8LZpg/7EGH
        gVCUiaagUnJFQGt+dX8OlgzYCCwS6/s=
X-Google-Smtp-Source: ABdhPJwRmiBEyWg7pdyhPoLxCIRWXwfGbwz6AlixTjtFq9I6DrZDtT63kPMRKd8YJFJc1xW8WultIQ==
X-Received: by 2002:a17:90a:d3ce:: with SMTP id d14mr6342767pjw.46.1590178999200;
        Fri, 22 May 2020 13:23:19 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:e0db:da55:b0a4:601])
        by smtp.gmail.com with ESMTPSA id e19sm7295561pfn.17.2020.05.22.13.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 13:23:18 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/11] block: read-ahead submission should imply no-wait as well
Date:   Fri, 22 May 2020 14:23:01 -0600
Message-Id: <20200522202311.10959-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522202311.10959-1-axboe@kernel.dk>
References: <20200522202311.10959-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As read-ahead is opportunistic, don't block for request allocation.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/blk_types.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index ccb895f911b1..c296463c15eb 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -374,7 +374,8 @@ enum req_flag_bits {
 #define REQ_INTEGRITY		(1ULL << __REQ_INTEGRITY)
 #define REQ_FUA			(1ULL << __REQ_FUA)
 #define REQ_PREFLUSH		(1ULL << __REQ_PREFLUSH)
-#define REQ_RAHEAD		(1ULL << __REQ_RAHEAD)
+#define REQ_RAHEAD		\
+	((1ULL << __REQ_RAHEAD) | (1ULL << __REQ_NOWAIT))
 #define REQ_BACKGROUND		(1ULL << __REQ_BACKGROUND)
 #define REQ_NOWAIT		(1ULL << __REQ_NOWAIT)
 #define REQ_CGROUP_PUNT		(1ULL << __REQ_CGROUP_PUNT)
-- 
2.26.2

