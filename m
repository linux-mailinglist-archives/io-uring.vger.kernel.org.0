Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF803EA7CE
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 17:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238232AbhHLPmV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 11:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238249AbhHLPmV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 11:42:21 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE74C0617A8
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 08:41:55 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id d10-20020a9d4f0a0000b02904f51c5004e3so8235951otl.9
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 08:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gzAcF0zizY0wVeW39ScMbIL+yu4HjhIlQYH8a7v47yo=;
        b=TihX5YMJv+Ds4lQ0p4PiRHGk8oWXtLun1JbOkDn9HgtJB+KVVPNtgcEJqWHN7MtssK
         zPaHp9eZvCzPqmb8Xn5Ht5kPNW67wAp/VeMnxecLfD70hI1QdMfxXKhI8NjgsXNppzR9
         IKM7yLkipYJauHpX6/tUBptEh+8XR+eNFblYE2oLiwofyHXRBZzdxNiUvcVxHPHrdLaw
         kPFZr2tLL4Eiid5AL4qWeha7+227TtjYSFfdvN4Me5ktN16iHpMsdhsI3zuT6ijwBnYy
         Ech6E+Xxu2DQ755Q3I78ma4wJ5dcrmDnmHPPQ4Zu07gGsrv0pHGJyi92gJlr/ZiDbViT
         gkcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gzAcF0zizY0wVeW39ScMbIL+yu4HjhIlQYH8a7v47yo=;
        b=m/ccujt9e14gQ0PwIEEUwvrbN00JQgr4dST5au0XKrkETrSm7ge1YoFIeLX3pIX4x5
         Orh+fYeW1qeC5Ovse8KZTCuk9SkrBkKHKNfUbP9F74hp/u3cmgyfxvcUrzXoIU18kCnS
         52PE41fh44XK75/X3rYQQTBmYX5USyG5+7fOWw49WIMaCCgAoatvca1PfXyItawm5Sbd
         kXNtE5Lhxast5kaLjlhTv0dB+PIQj28QD4mqStVmHRKRXMwTvzcy8eVEFgKOoRBgZzVE
         cXe8n+iPRiGEgHA+1ul88CODPcNyJIKFn78dhwq3prkW5xMJZWovGctBqVJd85V5ywfM
         UnXw==
X-Gm-Message-State: AOAM532/QQI+SNNtfNpzuqDUsqZKtiAi61R4C+cSJ5YPz4QvTEQJK7L7
        oRPwBZGcTgXnbwUbHkO9cbWGyPBn9YHjiS4T
X-Google-Smtp-Source: ABdhPJw0Sl3w155IOnkFB5DmHVe92pvQEqfNjekV4IPmKjJ6R84Q/0+3dhjbz7vUG5w9NDS9EG6vBg==
X-Received: by 2002:a05:6830:4429:: with SMTP id q41mr4022053otv.284.1628782915057;
        Thu, 12 Aug 2021 08:41:55 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id w16sm690973oih.19.2021.08.12.08.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 08:41:54 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, hch@infradead.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/6] block: clear BIO_PERCPU_CACHE flag if polling isn't supported
Date:   Thu, 12 Aug 2021 09:41:47 -0600
Message-Id: <20210812154149.1061502-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210812154149.1061502-1-axboe@kernel.dk>
References: <20210812154149.1061502-1-axboe@kernel.dk>
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

