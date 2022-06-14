Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6843A54B145
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 14:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233873AbiFNMeg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 08:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244298AbiFNMeM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 08:34:12 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C3E4BB97
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:59 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id x17so11078046wrg.6
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n/nGsucu9f3Io3BE8Nz2zIpgpyCeUl8M+4ygHEUZXIc=;
        b=l9higdNwgRRofLokarXDlvp/3N5y/qtPuH06WpDzWUDGy+sJkl9HhbthUTpUUSkaMI
         /B9LPjGDphXBIdOdQNehk20Z8MATYCdfKPRTf4/+b1l22mMpFSh6zW3C9vR2UCtLfJxx
         qF63+fa0yFo3M7sgspwWqqqoLoe/Kb+9Wk4JYzcgPa7yZOYyYZVcSY9CJ2KyIeYMxm5h
         dwvR8SNNGTN+pa2I92vu6QzDKcIPJgWXPkdZxx8exmsGYZZCSA1zUIBuFQeeL/e6JtQG
         d4ePRFsPMEIgW/9p9h9CWUYMoZxiHaOHc7lucJvRguNM7DAP78VEWOhIRBpCG0DUEkRh
         I87w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n/nGsucu9f3Io3BE8Nz2zIpgpyCeUl8M+4ygHEUZXIc=;
        b=t0UgF3Y4vP+eRybYJwkZv+HTyKAh+sCKdskeLizDa+sJB6RlFWQPNl7uNcr2YR4b6v
         LSIv0z0w1osAw6ksgS+j8u1Zmc+4lhoP2dy4StI7ofaseqayjjmV1QByx+/DY/Wmx1Km
         NocdcepbmFX3e5WE+Ib1izaWXcc8QdnkqKUyHPa5NqwObEHfhAApB77mKDLrZSWfdRmq
         LclWRehgpa4T0Mt5S/7VMhxu3wR+b0ND21nGtBsiyl+NUSGaenFmO7civJZxeZsSvKud
         0ac36M8FRZGTb2EhqwauTLtuMHknyTOx2CMTDG0l8ToA1TJL+SsgrpaBpDLuaJI02YPh
         9KAg==
X-Gm-Message-State: AJIora/OazvWGdoPblL1Nqxmyljq+3LeqjQA+yiIRITFhIAIM6R+t/p7
        InjV2WNh71K60nV6gRc844+dM9ZN43izFA==
X-Google-Smtp-Source: AGRyM1u9ErXwsBlL91PbQaWhZuTkz5uF26xrdrpO+ABRRQK1RICnDv6MSD8Bq79jdLPX+86KOwWnAg==
X-Received: by 2002:a05:6000:156d:b0:210:3125:6012 with SMTP id 13-20020a056000156d00b0021031256012mr4526682wrz.357.1655209857888;
        Tue, 14 Jun 2022 05:30:57 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600c198700b0039c5fb1f592sm12410651wmq.14.2022.06.14.05.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:30:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 18/25] io_uring: limit number hash buckets
Date:   Tue, 14 Jun 2022 13:29:56 +0100
Message-Id: <94334f242fa236c77e1f2c32a9b0108931e285a2.1655209709.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655209709.git.asml.silence@gmail.com>
References: <cover.1655209709.git.asml.silence@gmail.com>
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

Don't allocate to many hash/cancellation buckets, there might be too
many, clamp it to 8 bits, or 256 * 64B = 16KB. We don't usually have too
many requests, and 256 buckets should be enough, especially since we
do hash search only in the cancellation path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4e0f60ffc975..a203943f3d71 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -710,12 +710,12 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 
 	/*
 	 * Use 5 bits less than the max cq entries, that should give us around
-	 * 32 entries per hash list if totally full and uniformly spread.
+	 * 32 entries per hash list if totally full and uniformly spread, but
+	 * don't keep too many buckets to not overconsume memory.
 	 */
-	hash_bits = ilog2(p->cq_entries);
-	hash_bits -= 5;
-	if (hash_bits <= 0)
-		hash_bits = 1;
+	hash_bits = ilog2(p->cq_entries) - 5;
+	hash_bits = clamp(hash_bits, 1, 8);
+
 	ctx->cancel_hash_bits = hash_bits;
 	ctx->cancel_hash =
 		kmalloc((1U << hash_bits) * sizeof(struct io_hash_bucket),
-- 
2.36.1

