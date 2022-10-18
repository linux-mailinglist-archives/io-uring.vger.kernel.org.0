Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6DC603382
	for <lists+io-uring@lfdr.de>; Tue, 18 Oct 2022 21:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiJRTwl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Oct 2022 15:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiJRTwk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Oct 2022 15:52:40 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565ED876B5;
        Tue, 18 Oct 2022 12:52:29 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id a67so22060917edf.12;
        Tue, 18 Oct 2022 12:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lFeaHcw3WNcJNFaRay0No0wm3D4s1Mkz5fJGwkqsY20=;
        b=IMsZVcTie6W3CPtJzjN94pHSJC7XL+ENcaX4GcL0mtRZO8MtB/L1yhDZPpaVpBmUYK
         bs8KSCL+9M7/KhxBu9kwXv0EVYqh0iCdwdXLW9Ye0em6U8KaCMyiRmJQwJMlkA6ZLtFO
         +8sfPDSDC6kLilqDoyEHDQpnSoIZnDUK3Ctb35lhI6NamtWM10UnUukWx8A9zecNKMCu
         Q/NcC55LR1UvKSpzU+SF0fFZ0cCjPUTXADVinblmu5Ha4okPjQlhic/ZVnHZcc4YjTZO
         Q1bXlXtNVTWbDg+KVPFNW6ue6x0kajLHT9TDmRmUeQBBCmymCS2UU5Uq4r62CFLGgVT/
         Rp9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lFeaHcw3WNcJNFaRay0No0wm3D4s1Mkz5fJGwkqsY20=;
        b=78X7igW5b8BtM7vkgQz5rLuZk8pmnC/THLZ1D0HhhmA7owzceKqBen2JvZ7RZ1Fpwg
         hMcPOAgEnE90eBnjYjc6FdZUSRgRr9HRZpPLy2T4NCIN0dRNiLJphCV0cS5P7T3yTG8O
         /qqbKimZzsau9bme0ow4z1Tn4u79bc37+7zpf27mGGqba38+/Ji6et2VPxjbf0shb/9G
         HADrM5vZxVmgO+aIkVd49yHRw8pflAUJw1obays7UCbHruFDDzqPruWvSN4L7zg9pVCJ
         WEnyf4x8RM+IDmVdTC/Lb3Jg2a/+VbosTr6sf4FiR07zeHl+LNuPkDmu4aCJ5K430rvR
         c/8A==
X-Gm-Message-State: ACrzQf37n5Lg53+Tyq6I9Gh0rhRKaRRLvlMFxPWYJYQBx/fDU1qUCZme
        r5LLw9cQjo4Xar7be/z1RYZjU68ApaE=
X-Google-Smtp-Source: AMsMyM7Om/5baYXatwtjMC2RIaTufoS8gp9s/C1nCrq9n/XhR7fzEmVLzLiwsm85yNB/ocCqEWQDjg==
X-Received: by 2002:a05:6402:1c1c:b0:45c:35b2:2a98 with SMTP id ck28-20020a0564021c1c00b0045c35b22a98mr4220710edb.182.1666122725252;
        Tue, 18 Oct 2022 12:52:05 -0700 (PDT)
Received: from 127.0.0.1localhost (94.197.72.2.threembb.co.uk. [94.197.72.2])
        by smtp.gmail.com with ESMTPSA id r1-20020a1709061ba100b0072a881b21d8sm7945858ejg.119.2022.10.18.12.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 12:52:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC for-next v2 1/4] bio: safeguard REQ_ALLOC_CACHE bio put
Date:   Tue, 18 Oct 2022 20:50:55 +0100
Message-Id: <558d78313476c4e9c233902efa0092644c3d420a.1666122465.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1666122465.git.asml.silence@gmail.com>
References: <cover.1666122465.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

bio_put() with REQ_ALLOC_CACHE assumes that it's executed not from
an irq context. Let's add a warning if the invariant is not respected,
especially since there is a couple of places removing REQ_POLLED by hand
without also clearing REQ_ALLOC_CACHE.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index 7cb7d2ff139b..5b4594daa259 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -741,7 +741,7 @@ void bio_put(struct bio *bio)
 			return;
 	}
 
-	if (bio->bi_opf & REQ_ALLOC_CACHE) {
+	if ((bio->bi_opf & REQ_ALLOC_CACHE) && !WARN_ON_ONCE(in_interrupt())) {
 		struct bio_alloc_cache *cache;
 
 		bio_uninit(bio);
-- 
2.38.0

