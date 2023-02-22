Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3318769F6B6
	for <lists+io-uring@lfdr.de>; Wed, 22 Feb 2023 15:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbjBVOjW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Feb 2023 09:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbjBVOjU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Feb 2023 09:39:20 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A060F37B65;
        Wed, 22 Feb 2023 06:39:19 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id j19-20020a05600c1c1300b003e9b564fae9so664333wms.2;
        Wed, 22 Feb 2023 06:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aLlCzWw1AssfjgBXmFlk8NMc2CPaZuoh5Bi4Ozm/gs0=;
        b=l/ttigjxsKa3YvoIQjINVBOoNPeK2/2BaOf/7PSu4DdWgzHhBKsJ+2ouhN4H2YXXqX
         LF475KPpC6+x1VOtBOjoUhvEsX5sOpizb4nSzJKBP1DK4Rq/ZQSaQ8Gio2IkjZD3svXP
         kzdzDQlDePQKDlDzrsyY0EwMiZKmconuJ464dYSKlomNQmuGfwCtLgM2y1jhP4CAvejq
         cGuk5kKw10CVAXzevFhF9wMm6ykyxMuXacliu6YH4Emh9K7PNmbntQNkMwGchde7Ymyf
         vmJMvN0FUNqzAqBe2rbeS7mt04v+uXAXBcYtBDVk2kcTmj2V0walKtKGtiZopb98lX1f
         GBHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aLlCzWw1AssfjgBXmFlk8NMc2CPaZuoh5Bi4Ozm/gs0=;
        b=65piNaVGrBTes1XJDzoRz7hPvIeW9a6t7cXbcFs4q4cH0u+ibfoLyDVy9srDkRn4fI
         gJRDfCICKTyUOWbGlymLKK94Va7oGkt9ohGWS324Uie7bhblU+HR+DwMwB1G5vtsok7N
         zhCk6HiUyzidHsLBhQAYwkta6En65dIqOG1dL8vJsqC7yD2B6iWmK+jagiJL8cSdyoSl
         TbBIh6xmuEEyerbfmbh/AZFiVIVcCRtPDtG/g1JAf2dCJX8G2EYTXZqHNgRZYLSC+SsZ
         UBF9OSu7GqFKPsxmj2Uluq0Wfl6+uddlysZh2QFjhQDpl+v8AUSpE7Jj5pg286cED+v+
         ntZg==
X-Gm-Message-State: AO0yUKVDTOxtQcAEdcFyjZvmn9y59Mb8bJ52aMYXmJdKc/GN7xQgINbB
        n832jbIa7HOgqpafpqnufIUok88cLd0=
X-Google-Smtp-Source: AK7set/klMhFR2GKixgOumpNP1VKA96VGfmzhrDYK+ETWl3gEHalFbrv6ebC9dthswmQBpa7aIx8mA==
X-Received: by 2002:a05:600c:3d8c:b0:3e0:c5e:ad78 with SMTP id bi12-20020a05600c3d8c00b003e00c5ead78mr6031015wmb.7.1677076758017;
        Wed, 22 Feb 2023 06:39:18 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.95.64.threembb.co.uk. [94.196.95.64])
        by smtp.gmail.com with ESMTPSA id o2-20020a5d4742000000b002c59c6abc10sm8151735wrs.115.2023.02.22.06.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 06:39:17 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH for-next 2/4] io_uring/rsrc: fix a comment in io_import_fixed()
Date:   Wed, 22 Feb 2023 14:36:49 +0000
Message-Id: <1445461129902f506c46645d8659f78bd5b35008.1677041932.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1677041932.git.asml.silence@gmail.com>
References: <cover.1677041932.git.asml.silence@gmail.com>
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

io_import_fixed() supports offsets, but "may not" means the opposite.
Replace it with "might not" so the comments rather speaks about
possible cases.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 8d7eb1548a04..53845e496881 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1338,7 +1338,7 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 		return -EFAULT;
 
 	/*
-	 * May not be a start of buffer, set size appropriately
+	 * Might not be a start of buffer, set size appropriately
 	 * and advance us to the beginning.
 	 */
 	offset = buf_addr - imu->ubuf;
-- 
2.39.1

