Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E213E98E0
	for <lists+io-uring@lfdr.de>; Wed, 11 Aug 2021 21:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbhHKTgJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Aug 2021 15:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbhHKTgH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Aug 2021 15:36:07 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BB2C061798
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 12:35:43 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id q2so4017473plr.11
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 12:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gzAcF0zizY0wVeW39ScMbIL+yu4HjhIlQYH8a7v47yo=;
        b=UP4vySG67B3mWmew1yhsxprWgt1py2v7fnkkpmlxAWoNyfd6VwiwQHfDuPyJBCAT9y
         CpW0eU4AV0iEKcg7DA7lLDWAlVS3hCZPLjRJx/hdBaiGn2KKYJ3jMGu5fBeSlT73oeDI
         4Uro6cMsRsvkQZeamniiMreRLD7wwy1ru1ytSfqrZOnxKmlFsrq+O+0TyHopycKoZOaL
         JCSihSz+y22bXA/DJ/kRXPF7qkAWYUHfwv9HY4gjILL+NY1Qy7FpKL9Uaa7GShm6n8+R
         ZzdAY3AMgCLXa3GT/y5g87RcUXs+Onz6aOnsLzBQqwuU/ld5FBkzvCd+V8aGkZGi/XJd
         1Feg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gzAcF0zizY0wVeW39ScMbIL+yu4HjhIlQYH8a7v47yo=;
        b=OS9JiWDGzlpcKKCW4wSSGTJ46NjuK2Jq00goVNqzDAySjezwayhiMH+aPDPdalNjms
         iBMCe4Bh8YDgjkXa+h/lNI4VXVKm76BZ4M0pFHYjzh3OPlin7CHf14HIC1ZjE/iDDdo/
         PteqBGcJtl3Uj2joiP2JpDc+R4pQ57fvlHcPQD5AL7qdmtItujchDx8FweCgsDEQms2B
         KxdHpTBBXGKRPHqONwVuTROUblhDW5wa2HbT/tXsS10HJwHV/LUcZ6jGWSmuQlDcZWHK
         zF+qCauZdMhaEZEYBAi0CPuX/4HV1zED20rv3X0Ia0MOF2aVXweVBfPQfctnT6MQHFmL
         7tlw==
X-Gm-Message-State: AOAM533R8R4MhWPTZ+sCed1NCHObugXYM2GWMwybLHt+5DL3tXrhMNAk
        rGxJ8L/q1bCPmkG3s8qaao5ZgzarN34VVyIj
X-Google-Smtp-Source: ABdhPJyLozS2daFM9HNJ9WFZc7F7zdNlB81nDYSLw4lvsHkDusDtRKe6nUWUP09eLh+8xl4WDH8wZg==
X-Received: by 2002:a05:6a00:18a3:b029:3dd:8ade:9b8c with SMTP id x35-20020a056a0018a3b02903dd8ade9b8cmr309666pfh.63.1628710542623;
        Wed, 11 Aug 2021 12:35:42 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id u20sm286487pgm.4.2021.08.11.12.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 12:35:42 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, hch@infradead.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/6] block: clear BIO_PERCPU_CACHE flag if polling isn't supported
Date:   Wed, 11 Aug 2021 13:35:31 -0600
Message-Id: <20210811193533.766613-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210811193533.766613-1-axboe@kernel.dk>
References: <20210811193533.766613-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The bio alloc cache relies on the fact that a polled bio will complete
in process context, clear the cacheable flag if we disable polling
for a given bio.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 04477697ee4b..c130206e9961 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -833,8 +833,11 @@ static noinline_for_stack bool submit_bio_checks(struct bio *bio)
 		}
 	}
 
-	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
+	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags)) {
+		/* can't support alloc cache if we turn off polling */
+		bio_clear_flag(bio, BIO_PERCPU_CACHE);
 		bio->bi_opf &= ~REQ_HIPRI;
+	}
 
 	switch (bio_op(bio)) {
 	case REQ_OP_DISCARD:
-- 
2.32.0

