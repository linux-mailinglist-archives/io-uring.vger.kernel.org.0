Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3F059F914
	for <lists+io-uring@lfdr.de>; Wed, 24 Aug 2022 14:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237241AbiHXMKf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Aug 2022 08:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237230AbiHXMK0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Aug 2022 08:10:26 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF833FA26
        for <io-uring@vger.kernel.org>; Wed, 24 Aug 2022 05:10:24 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id n7so14948242ejh.2
        for <io-uring@vger.kernel.org>; Wed, 24 Aug 2022 05:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=ce5/ubV4JELaaR3vDudEhMmzRHtnYRw2aHkc66qf1mA=;
        b=M0p935OtryPrFypp1boj49PbiHEA8oxepnlQ0NWB9pp363fD6LN6iLdnuRucEF1Vah
         wizrRqdMtxkaJ7PttyymfCXyifeMP0tSBUEVTxien27PSaDw3RLKjbI3X4/l5BloFfAw
         1B+5tmznAJ6Q/V3ng/WqU2ldBG00uUD1w59zMFnIBtPBYUSlJ/yHSkd4dRp6gPOwC3wi
         5tAeH7WzxlVu0vrs6hIStE7sY0CRI6kwyiGTzsO5+WkTrDg02+lxcqCtChSC8kGdgfNS
         0S5QtoDIK0wEkrsc9NUKu94Owrc6l2Xx+d9tuBJL8krrC8nIygv9iQIJd9xAB7wb2bUu
         u8ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=ce5/ubV4JELaaR3vDudEhMmzRHtnYRw2aHkc66qf1mA=;
        b=iO12mvMN/iKjhnXYe5Vbit7C+w6zIO+fr7ZjF3eWPag2lF6F6ibfllNDegbShG81+9
         9fOXaLE8Y7w7Cf5T7HpZrLl71k3jTtzOYYOwM1palR3CcSMauKc45YkKuHplSgrbONoZ
         56UYbR7C6kPE2030HhVJzj8ZIhOMM+P3WLPI4/MNwmFS/RGr1OJTMtmq0aznsp1+2cIC
         XEJtcivxfnCTPatfVM5hokT7P6fypSb7538T5vhD2BJgAQmrCfwXWN22hYV0MgFTtDaV
         9KA7TpMl6fS5CTw5rVXP1PccJ9qg7SR/k8qX9H+mDoWYXFY+A0KRA+x100wqBB1x/FnP
         yULw==
X-Gm-Message-State: ACgBeo2UnSCQHnIEmWiKDbuyJVDLZF5VKNaSvJXy69DnvUgYP2RJeg6B
        pM+KXs5cN21t+sqPj987Ici0/PFBYtkWOw==
X-Google-Smtp-Source: AA6agR7PRntyC7yomtGca141ex0cm0203vySe20sxgk/RUO6B41agskQ/sHtg230Xya6v1hfYI5/qA==
X-Received: by 2002:a17:907:da0:b0:730:d0ba:7b13 with SMTP id go32-20020a1709070da000b00730d0ba7b13mr2866249ejc.332.1661343022183;
        Wed, 24 Aug 2022 05:10:22 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:7067])
        by smtp.gmail.com with ESMTPSA id j2-20020a170906410200b007308bdef04bsm1094626ejk.103.2022.08.24.05.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 05:10:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Stefan Metzmacher <metze@samba.org>
Subject: [PATCH 1/6] io_uring/net: fix must_hold annotation
Date:   Wed, 24 Aug 2022 13:07:38 +0100
Message-Id: <cbb0a920f18e0aed590bf58300af817b9befb8a3.1661342812.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1661342812.git.asml.silence@gmail.com>
References: <cover.1661342812.git.asml.silence@gmail.com>
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

Fix up the io_alloc_notif()'s __must_hold as we don't have a ctx
argument there but should get it from the slot instead.

Reported-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/notif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/notif.c b/io_uring/notif.c
index 977736e82c1a..568ff17dc552 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -73,7 +73,7 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx,
 }
 
 void io_notif_slot_flush(struct io_notif_slot *slot)
-	__must_hold(&ctx->uring_lock)
+	__must_hold(&slot->notif->ctx->uring_lock)
 {
 	struct io_kiocb *notif = slot->notif;
 	struct io_notif_data *nd = io_notif_to_data(notif);
-- 
2.37.2

