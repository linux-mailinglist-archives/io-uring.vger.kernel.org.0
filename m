Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE5459F916
	for <lists+io-uring@lfdr.de>; Wed, 24 Aug 2022 14:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237268AbiHXMKd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Aug 2022 08:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237262AbiHXMK2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Aug 2022 08:10:28 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A003AB30
        for <io-uring@vger.kernel.org>; Wed, 24 Aug 2022 05:10:26 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id y3so6743472ejc.1
        for <io-uring@vger.kernel.org>; Wed, 24 Aug 2022 05:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=53NZJ58ZuojeGaGvbnjakOC5xmXKAG4gfl0fQbTWQPA=;
        b=h4Wei7FE2fKcj/Yq/rbfD+wW+nKUwkOfY+o84FieLhD4ZQieYDGBTfSjOMwHQ/R/yS
         ZBk0TbOMWjTk/z5HFjmU0KWtBDkbglrxnF713ICuuMlSBU+4KVDHIbEzuP08q9V31q2V
         PEyB5mzaljXiHpYs3/PGXMkUyWcMof/7Qv3lw2BnVZkGrliT0IcK0pOC4Yiqoqna3KGy
         njBiw8E1bgxYNOLptAkryLTSAusqeYKktjvh+9+GpM5l/qo0AnL94phBLkr8fX9LzShg
         gN0ld57Gm103BexBWhonj2p0QmZ6UQFCMwi6jUC+s3hu4QenhPNm9OTICHCmErN6Zmua
         W4pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=53NZJ58ZuojeGaGvbnjakOC5xmXKAG4gfl0fQbTWQPA=;
        b=C96Zd8+IpmzsbdREHZ+Bj8Axfl06rQ5NcvJ08iKCGjok2l83MjCmvZsR6dxUvE12o/
         L8mSgacRcNMUxUjzlth8zCr0PxVb24lu7uRoH55pRTAsMeN1fm/C3AjzivMwROCuyYCo
         +Gp7R+CneCU91VluJ3riYvo++VlGXTpN2y+1LbyJsfPR2tEvkissId53WoZmhtBB21g4
         ZjU8R6ncLhRn8Dv+HfzeQNXEXBZLnyRxQUfmQA2OnEDZ57/erF+atXlEcxbveaDih8BK
         jyhTkgopHbmTYq65yH4p+6FZ/liG+jYcYS7ILVEdkg31XD/NQ6GmpgjUZ8iXFjdsXdwn
         rstw==
X-Gm-Message-State: ACgBeo1cGSgkCOepmXYqbWFpJjkiN4UNNTTFklyehtqH2QFp8ZwNMQ/f
        vAgpruALC8azPDU94DUXWhFUaNf6BMyxcg==
X-Google-Smtp-Source: AA6agR62MB20F/aGE51dHVCXFP1MtM7myn8zwwtQelNPnKh09AX6Myldyd8SFH8NTbVyMg/vgW2vhA==
X-Received: by 2002:a17:907:6818:b0:730:d99f:7b91 with SMTP id qz24-20020a170907681800b00730d99f7b91mr2638275ejc.496.1661343024944;
        Wed, 24 Aug 2022 05:10:24 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:7067])
        by smtp.gmail.com with ESMTPSA id j2-20020a170906410200b007308bdef04bsm1094626ejk.103.2022.08.24.05.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 05:10:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 4/6] io_uring/notif: order notif vs send CQEs
Date:   Wed, 24 Aug 2022 13:07:41 +0100
Message-Id: <cddfd1c2bf91f22b9fe08e13b7dffdd8f858a151.1661342812.git.asml.silence@gmail.com>
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

Currently, there is no ordering between notification CQEs and
completions of the send flushing it, this quite complicates the
userspace, especially since we don't flush notification when the
send(+flush) request fails, i.e. there will be only one CQE. What we
can do is to make sure that notification completions come only after
sends.

The easiest way to achieve this is to not try to complete a notification
inline from io_sendzc() but defer it to task_work, considering that
io-wq sendzc is disallowed CQEs will be naturally ordered because
task_works will only be executed after we're done with submission and so
inline completion.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/notif.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/io_uring/notif.c b/io_uring/notif.c
index 568ff17dc552..96f076b175e0 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -81,8 +81,10 @@ void io_notif_slot_flush(struct io_notif_slot *slot)
 	slot->notif = NULL;
 
 	/* drop slot's master ref */
-	if (refcount_dec_and_test(&nd->uarg.refcnt))
-		io_notif_complete(notif);
+	if (refcount_dec_and_test(&nd->uarg.refcnt)) {
+		notif->io_task_work.func = __io_notif_complete_tw;
+		io_req_task_work_add(notif);
+	}
 }
 
 __cold int io_notif_unregister(struct io_ring_ctx *ctx)
-- 
2.37.2

