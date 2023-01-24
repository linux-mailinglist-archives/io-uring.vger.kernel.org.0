Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A1A6798D1
	for <lists+io-uring@lfdr.de>; Tue, 24 Jan 2023 13:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbjAXM7e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Jan 2023 07:59:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233537AbjAXM7d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Jan 2023 07:59:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C10142BD0
        for <io-uring@vger.kernel.org>; Tue, 24 Jan 2023 04:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674565098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZSi6S+muZGTgBwtIdsJ5fCvNBIzBTV5J3NQ7wnrMIF8=;
        b=TFmHdcpenNEKi4Fl/mEdv4jzvXsPXciXZ/565PdS4yzowAhlcfKRQgeM/PLgZlXtDpGq0l
        NUyjw3mXTqKoGBVNqUWtxrkpOC4ZWAzY8RR/kAuJi4czk/O3US4DwoI78w/nHD1FOqXHqv
        a8m/vbv5FqDnP/C7aGkxzkSmTE+2RQY=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-653-YUTK-hN8MhmB82N66_ThzQ-1; Tue, 24 Jan 2023 07:58:17 -0500
X-MC-Unique: YUTK-hN8MhmB82N66_ThzQ-1
Received: by mail-qt1-f198.google.com with SMTP id o16-20020ac841d0000000b003b689580725so5982436qtm.22
        for <io-uring@vger.kernel.org>; Tue, 24 Jan 2023 04:58:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZSi6S+muZGTgBwtIdsJ5fCvNBIzBTV5J3NQ7wnrMIF8=;
        b=TJaGVzGvD8a83bNM15NnlcGEdsHpKSm6k7/1kYcd9+Qv/oJn88Fe0hjaaeGl70qG1A
         ps4T6IkSo9lxdk4PYQ29XZy8vdFWaiHUAfRtzzRiOsJjnOmk/OM0XKq4D6QcWrXCuXWc
         2uA53CCvfYyz1UIeuHI0qzIY8B3nuX2T6aBMnslTMbPiuVIbWwfmefOLzZPOu1Rex0l7
         WdiDNJ9oYwpNoi/7wKJlplL6TcLDNhmpThzHaFFbmgdNrzp4HRBHmd9CK+u278VNMzZc
         X+UnqHx/xPIRlu1ly52B1cEcs/DFKBqArW0vZDUeq59tD8gmyQC9/hoQxfbt/SlJJiVd
         qYZA==
X-Gm-Message-State: AFqh2kpRKfx/jWOyB/dPnTbKuOBFaBMMzYd3L5c6sLHbfvMU8IcxLOTq
        brjRz2XGife+Ut2YcoOGcy98thg2LX0Np7s7dZDdpVuraTQGVal9SzPrc6N12sX8MOoASGjDOfr
        m+ndHABhMqSnTMLtm+QE=
X-Received: by 2002:ac8:7350:0:b0:3b6:90c4:b13a with SMTP id q16-20020ac87350000000b003b690c4b13amr27608081qtp.58.1674565096636;
        Tue, 24 Jan 2023 04:58:16 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtLt3U69T2XRyfXT9r14cbZA03RVHPgFC5vWRm+j1Qb42uI3X9erIeuPmuCPjOI5VnlnIACFQ==
X-Received: by 2002:ac8:7350:0:b0:3b6:90c4:b13a with SMTP id q16-20020ac87350000000b003b690c4b13amr27608059qtp.58.1674565096385;
        Tue, 24 Jan 2023 04:58:16 -0800 (PST)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id r22-20020ac87ef6000000b003ab7aee56a0sm1192570qtc.39.2023.01.24.04.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 04:58:16 -0800 (PST)
From:   Tom Rix <trix@redhat.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, nathan@kernel.org,
        ndesaulniers@google.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>
Subject: [PATCH] io_uring: initialize count variable to 0
Date:   Tue, 24 Jan 2023 04:58:05 -0800
Message-Id: <20230124125805.630359-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The clang build fails with
io_uring/io_uring.c:1240:3: error: variable 'count' is uninitialized
  when used here [-Werror,-Wuninitialized]
  count += handle_tw_list(node, &ctx, &uring_locked, &fake);
  ^~~~~

The commit listed in the fixes: removed the initialization of count.

Fixes: b5b57128d0cd ("io_uring: refactor tctx_task_work")
Signed-off-by: Tom Rix <trix@redhat.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 734d074cdd94..4cb409ae9840 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1227,7 +1227,7 @@ void tctx_task_work(struct callback_head *cb)
 	struct llist_node fake = {};
 	struct llist_node *node;
 	unsigned int loops = 0;
-	unsigned int count;
+	unsigned int count = 0;
 
 	if (unlikely(current->flags & PF_EXITING)) {
 		io_fallback_tw(tctx);
-- 
2.26.3

