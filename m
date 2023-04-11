Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047796DD918
	for <lists+io-uring@lfdr.de>; Tue, 11 Apr 2023 13:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbjDKLNO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Apr 2023 07:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbjDKLNE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Apr 2023 07:13:04 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624D349CF
        for <io-uring@vger.kernel.org>; Tue, 11 Apr 2023 04:12:51 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id dm2so19441318ejc.8
        for <io-uring@vger.kernel.org>; Tue, 11 Apr 2023 04:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681211569;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yxiL8PVEsvMZ46+33d/I7dT556QvqnSwSgDcmN6Pf6s=;
        b=Vu0v7qdFDVMjkEdRqRZBJruZUKVCqwOaZpIVV0bhmEMBxBYzFeIWj+7/rSftv1SYL7
         aKgSkng5UyJJYN1uEEKGlgEPm0fy4nkarLh3s/auE7UsDE6osOWlzILya6+aCyTw4+7b
         UB3L18aQVuZMvgNwCT98FA3U6waEmCD5T59dvecQtgVjLBbMI0AMCUZAvUmANv8sw4yM
         cdVFxeOIFPNWm0g/USx10ISxslfG18F5E0Nw2MaXRfpFxXQl+A2r4/4y3Q037ZbpTlUM
         QbIqhs7dlZ4r9pC924tJjqFmu+iVDskK7f3f1kSUHV/oSkqOEbT1Iz8dubCt7pHGaURc
         7Jaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681211569;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yxiL8PVEsvMZ46+33d/I7dT556QvqnSwSgDcmN6Pf6s=;
        b=cHVGmHj5CrCTC/dUTnx0To7ut0jemVBnVUBsvfG51UNS75Ps1lVaSqeHelBQt4Cs+g
         PDPLtduUbiC336fEaneZb5U0HeIa1WycUhZSu0i3uhTOmu/tmIC7Ytq9YGVs2Y4bOssy
         hgMZKkAJCKmcn+icmXSb2lIjFTGAbRxRKgHi1q8k1tgZx8JplbwiBWoppobNvSveGFMe
         H+uxz1o/W2clEl85FYLVrVnIHV2VduhwetWPchcvLZoWoi6egZ/0qlphGeeaP4fdTeMd
         FNNsI4A/II4GUVeD1O4uDhaQpUM8WH0aLLcvjgTTiVzSDYrUH/wvZVVqxxGwnzrTWNVl
         ArFw==
X-Gm-Message-State: AAQBX9cLMFuOjFDXp3O//29sPlAk91MvvSfP0weaa8HIBBRoVlIss1W4
        uEzwJ/g5j5drW9RmLC02pP0iqRPtj0M=
X-Google-Smtp-Source: AKy350bKMhBq5/80+9DZD3MpscV99MvhRalK7nRfZxNbjqHIQ6r+zzGt+QF/IASdPkOTml83FGBJsw==
X-Received: by 2002:a17:907:742:b0:930:60ba:d4b with SMTP id xc2-20020a170907074200b0093060ba0d4bmr13853807ejb.37.1681211569215;
        Tue, 11 Apr 2023 04:12:49 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:ddc3])
        by smtp.gmail.com with ESMTPSA id ww7-20020a170907084700b00947a40ded80sm6006787ejb.104.2023.04.11.04.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 04:12:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 4/8] io_uring/rsrc: add lockdep checks
Date:   Tue, 11 Apr 2023 12:06:04 +0100
Message-Id: <961bbe6e433ec9bc0375127f23468b37b729df99.1681210788.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681210788.git.asml.silence@gmail.com>
References: <cover.1681210788.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a lockdep chek to make sure that file and buffer updates hold
->uring_lock.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 603a783a0383..24e4e2109549 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -534,6 +534,8 @@ static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
 	__u32 tmp;
 	int err;
 
+	lockdep_assert_held(&ctx->uring_lock);
+
 	if (check_add_overflow(up->offset, nr_args, &tmp))
 		return -EOVERFLOW;
 	err = io_rsrc_node_switch_start(ctx);
-- 
2.40.0

