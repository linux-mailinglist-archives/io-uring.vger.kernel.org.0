Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D48619517
	for <lists+io-uring@lfdr.de>; Fri,  4 Nov 2022 12:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbiKDLDR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Nov 2022 07:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbiKDLCe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Nov 2022 07:02:34 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A7E2C653
        for <io-uring@vger.kernel.org>; Fri,  4 Nov 2022 04:02:33 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id l11so7060757edb.4
        for <io-uring@vger.kernel.org>; Fri, 04 Nov 2022 04:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X/FFWQ0jqit+tHnoCmQVZSk0lg7We50/psae2QKn1MA=;
        b=UJ3Fni1z+4x+OfRraIdR9tGY7UwVCsoM+k04yL6sewiC3Tdki3vQ/VEGCpI7KE//eT
         07wKUWfkX8PgdCBbyhFjgTQIojEh7umj454vky2GN4JqLp98OT1+RmuIwp/ijA+YwQuR
         rES54sRShTC8P4hTQ08hA5m6EPkfMqqSxgF9CNmcWdo3CdoBLJc9obngT4lNchikWj4G
         PXETskHo80q7MD0KJo9ST3bpyYzL0jbJTW4xGq9QuTiglW9RsD/kJ5yqywOZqpTHMfHU
         7mhNkAzf+YzSD10ed0qIftQKXVGm0DqOfrGxzPKgiyzXkKY1JHIUL06eLxUZ5WfNyY99
         7i6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X/FFWQ0jqit+tHnoCmQVZSk0lg7We50/psae2QKn1MA=;
        b=0a5J6b+7X39u0158/nHgbw2h799otI5VX3AK+4z2ZfqhaVCrNeSkG04YN/aRb/iCzz
         RRpLetkOp8hagto4Pd394E3YhO/Y4CkXnBrmKdFtHf1Dj3jrnihSCdKs5FppmJRYEKlT
         TaLdkpZIdfqJRPgMrInB7nsVdyclKCk5AlKXfrXWcR14pk05UOlc9NvOVB90njYHt8JI
         j+bHBIoPEEXVL/PTXR9Nbwi2aSlCHzurpR4+kn9lKvhRSXZTnBPSbdxQjciafB9ERepz
         UUh0lJL2w8IzYefrvkFT1PoPjXmvxjRAXGFTijP+QwoeT6WpLG3Mw2Zm/kxECCer5B+v
         Be8g==
X-Gm-Message-State: ACrzQf0y19ErpmW2F7Q0T12kKgrzQRGbLj5KkGS1IsvR+Xkr1f3Lre2d
        54mqaP2L2ZJixq/fLhiXTdpFijRP+UI=
X-Google-Smtp-Source: AMsMyM6FY+jYrDJ4KQwegUwgCsomVjKVoZeOwbpGiyOywa7yrKnBgSCB6TqKz03I0NysoKC+92Ud5w==
X-Received: by 2002:aa7:c417:0:b0:463:3f0c:be12 with SMTP id j23-20020aa7c417000000b004633f0cbe12mr28232877edq.35.1667559751837;
        Fri, 04 Nov 2022 04:02:31 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:4173])
        by smtp.gmail.com with ESMTPSA id u25-20020aa7db99000000b00458947539desm1757768edt.78.2022.11.04.04.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 04:02:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 4/7] io_uring/net: rename io_uring_tx_zerocopy_callback
Date:   Fri,  4 Nov 2022 10:59:43 +0000
Message-Id: <24d78325403ca6dcb1ec4bced1e33cacc9b832a5.1667557923.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1667557923.git.asml.silence@gmail.com>
References: <cover.1667557923.git.asml.silence@gmail.com>
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

Just a simple renaming patch, io_uring_tx_zerocopy_callback() is too
bulky and doesn't follow usual naming style.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/notif.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/io_uring/notif.c b/io_uring/notif.c
index 6afb58b94297..5b0e7bb1198f 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -25,9 +25,8 @@ static void __io_notif_complete_tw(struct io_kiocb *notif, bool *locked)
 	io_req_task_complete(notif, locked);
 }
 
-static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
-					  struct ubuf_info *uarg,
-					  bool success)
+static void io_tx_ubuf_callback(struct sk_buff *skb, struct ubuf_info *uarg,
+				bool success)
 {
 	struct io_notif_data *nd = container_of(uarg, struct io_notif_data, uarg);
 	struct io_kiocb *notif = cmd_to_io_kiocb(nd);
@@ -63,7 +62,7 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
 	nd = io_notif_to_data(notif);
 	nd->account_pages = 0;
 	nd->uarg.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
-	nd->uarg.callback = io_uring_tx_zerocopy_callback;
+	nd->uarg.callback = io_tx_ubuf_callback;
 	nd->zc_report = nd->zc_used = nd->zc_copied = false;
 	refcount_set(&nd->uarg.refcnt, 1);
 	return notif;
-- 
2.38.0

