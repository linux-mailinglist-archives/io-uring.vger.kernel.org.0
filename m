Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A56C4DC8D6
	for <lists+io-uring@lfdr.de>; Thu, 17 Mar 2022 15:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiCQOiY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Mar 2022 10:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbiCQOiW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Mar 2022 10:38:22 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0611D66CD
        for <io-uring@vger.kernel.org>; Thu, 17 Mar 2022 07:37:05 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id u16so6648336wru.4
        for <io-uring@vger.kernel.org>; Thu, 17 Mar 2022 07:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9Xfu1Khmqex3g8Ibmb+SH5O2jm+fTTl2AXij/DcOm9c=;
        b=QITx/QZ2yzH+WwhWSf1+rrF//8HbLTEsACHoODLEj1Sos/nkFQoWROj+H13Xmi55Sj
         ptXQcu6RjusnMfsvUHpTIqVNIBwPCxgcmn0goq3202sbELXkXqwx5eAqRBFMEs4dfnXs
         6THspQspgoAwBTMo+Xbr57Ia8JDHbOTId11D1QE5GKMm4JzTo0dMpQ+8Ov2Zt6wPKzm6
         AmxZpzOGpzWtCNiO0iJLSiEWBRjOiH3P4J2mWXjYQLPjwhX5X/FMSvKhPlY9fJP5WlkC
         FTtgabK03Hn37mzXetzcBVJU3s/m5ZKmEuKEKhKIxStDZIdDBrdqkIJT7zJTYjx/TsiE
         NBAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9Xfu1Khmqex3g8Ibmb+SH5O2jm+fTTl2AXij/DcOm9c=;
        b=H/gIiIiKZL+BA64GjeXaVPLHoOMG/97fLzsI9S4jpDZ/m345IhVfx7+zL/ZXVcRE/k
         5AmcetpLfhZgU3wREkUj2n5DbAl4sld+m++KjxzDICvkD4JROvahFQ/shh9FCnKYTq/y
         SBIwKmHA/ppv+DCcUxdXqMS/uArRZogTFzCAdgQxkWf373UPH/VwOd463kEDddK9BEMe
         IaNzxDNgfiiKhnrE+FmWfKrIVHTAqD6G7OELsN0WCyKAqgAu/nfviYdEj9r2bRA6KaxO
         5a9NCXIrqsbCPbNs8xRybN+oXlsPFmB5qe0PSfg6+WXzQs9xUbh8uqS3E+JFV4uGfuFn
         69Yg==
X-Gm-Message-State: AOAM5308ssiQhVvCy7F1Q7F3PFXCgzhehYy/ke+vadfT7B5puIWVkrQA
        4f+ujxGfvS5vODQo+BmCWGH4Bqna/cA=
X-Google-Smtp-Source: ABdhPJzvL8wbPA3NwMm9WnAgDT5I+H6LxDHeT7gbSo9o/n3j9f7R0lugnwpPCjHCIl8504u+SzJH/A==
X-Received: by 2002:a5d:61c4:0:b0:203:ee2c:e0aa with SMTP id q4-20020a5d61c4000000b00203ee2ce0aamr2108565wrv.101.1647527823333;
        Thu, 17 Mar 2022 07:37:03 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-228-233.dab.02.net. [82.132.228.233])
        by smtp.gmail.com with ESMTPSA id bg20-20020a05600c3c9400b0037fa5c422c8sm8664700wmb.48.2022.03.17.07.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 07:37:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 1/1] tests: don't sleep too much for rsrc tags
Date:   Thu, 17 Mar 2022 14:35:22 +0000
Message-Id: <16780e103cfd395ad380bab4dbe6cf35cb581d98.1647527537.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

check_cq_empty() sleeps for a second, and it's called many times
throughout the test. It's too much, reduced it to 1ms. Even if there is
a false negative, we don't care and next check_cq_empty() will fail.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/rsrc_tags.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/rsrc_tags.c b/test/rsrc_tags.c
index f441b5c..2d11d2a 100644
--- a/test/rsrc_tags.c
+++ b/test/rsrc_tags.c
@@ -27,7 +27,7 @@ static bool check_cq_empty(struct io_uring *ring)
 	struct io_uring_cqe *cqe = NULL;
 	int ret;
 
-	sleep(1); /* doesn't happen immediately, so wait */
+	usleep(1000); /* doesn't happen immediately, so wait */
 	ret = io_uring_peek_cqe(ring, &cqe); /* nothing should be there */
 	return ret == -EAGAIN;
 }
-- 
2.35.1

