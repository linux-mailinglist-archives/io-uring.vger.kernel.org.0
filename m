Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96914576645
	for <lists+io-uring@lfdr.de>; Fri, 15 Jul 2022 19:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiGORpN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jul 2022 13:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiGORpK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jul 2022 13:45:10 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C496A2F3B6;
        Fri, 15 Jul 2022 10:45:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 68A301FA60;
        Fri, 15 Jul 2022 17:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1657907108; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZSHoQpScjMUzWiSKG0olhRxQb1JkMonLtUYiuDkfb4M=;
        b=U3AZUrNSgwy7DUCVJYyAITp2ZfBei/B/ktxAG/snKJgOhteOF5+tkPKXsOwZ6ekWnnOEwF
        2efyWw2j3/HHJdjK49dMX4TZ5LZrCpCiNtwaB2gNCnSPIWp8lbBgQbooSKaPUH+kH8wJ4n
        MGHHawrABmMUTjNg5b3LknkJu/IG2ic=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3C3D913AC3;
        Fri, 15 Jul 2022 17:45:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6rOtDaSn0WKPDAAAMHmgww
        (envelope-from <mkoutny@suse.com>); Fri, 15 Jul 2022 17:45:08 +0000
From:   =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
To:     axboe@kernel.dk
Cc:     asml.silence@gmail.com, fam.zheng@bytedance.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        roman.gushchin@linux.dev, usama.arif@bytedance.com
Subject: [PATCH] io_uring: Don't require reinitable percpu_ref
Date:   Fri, 15 Jul 2022 19:45:01 +0200
Message-Id: <20220715174501.25216-1-mkoutny@suse.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <8a9adb78-d9bb-a511-e4c1-c94cca392c9b@kernel.dk>
References: <8a9adb78-d9bb-a511-e4c1-c94cca392c9b@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The commit 8bb649ee1da3 ("io_uring: remove ring quiesce for
io_uring_register") removed the worklow relying on reinit/resurrection
of the percpu_ref, hence, initialization with that requested is a relic.

This is based on code review, this causes no real bug (and theoretically
can't). Technically it's a revert of commit 214828962dea ("io_uring:
initialize percpu refcounters using PERCU_REF_ALLOW_REINIT") but since
the flag omission is now justified, I'm not making this a revert.

Fixes: 8bb649ee1da3 ("io_uring: remove ring quiesce for io_uring_register")
Signed-off-by: Michal Koutný <mkoutny@suse.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a01ea49f3017..563f2266c674 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1911,7 +1911,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	ctx->dummy_ubuf->ubuf = -1UL;
 
 	if (percpu_ref_init(&ctx->refs, io_ring_ctx_ref_free,
-			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
+			    0, GFP_KERNEL))
 		goto err;
 
 	ctx->flags = p->flags;
-- 
2.37.0

