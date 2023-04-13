Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E44E36E1000
	for <lists+io-uring@lfdr.de>; Thu, 13 Apr 2023 16:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbjDMO3E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Apr 2023 10:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbjDMO3A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Apr 2023 10:29:00 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87056A5DE
        for <io-uring@vger.kernel.org>; Thu, 13 Apr 2023 07:28:59 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id s12so5902448wrb.1
        for <io-uring@vger.kernel.org>; Thu, 13 Apr 2023 07:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681396138; x=1683988138;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tkCeEcQcb1IucFaxfE9F99eQAeingWPXd5XsekzkgXA=;
        b=Tg6Hvvk1KarNAxnPOOPs4Ez029pXZTvWVY77j9a8knpFBgXfSunLeBB5n5XbpxWl0s
         QFldZO5Sz9Q07trMGOLJlBUJC8qvmMdNHFrH9cX+4kjG2bwumBwvgVgGkcjKmomef96A
         saAJnNH0qfDVMp2o5VCeFaO8uqkEsSm3kJj1wBfDuTrg1Yw+SrkRqj6WaFMkO0HLULQ6
         YFxCvZe9JLrQEDFmvPhKaJJ6sFWEE/ZWNWS7HZHtarjJrtU8Rb5S7igx3r1JMbhFdV4S
         AkL12upRu6ZcaucT0jdqDfnq0ZczAbq9cUXS1JgpOhMBYllFPS489dsJeUVOY/8WECOG
         MsHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681396138; x=1683988138;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tkCeEcQcb1IucFaxfE9F99eQAeingWPXd5XsekzkgXA=;
        b=fYCggoGMyOcnDaq7oyGecRkn2McKUjxs3t3lk/lnr5bSm7EvmwgwYlx3q2g8E1nr71
         hd8cweCzINjlU8ixuSl28WDBTgYmua2U4WGEB3wHqWXNBCFrlHGG+RvZv5EIAHmbgnys
         NWoDvv1L1GPZym4jf7vd+W4qWtFwERIa4WyFNpoHUZq/PvmO7/SUbNB9LpBJzOPB3l7w
         U4bIk8xeNPszZC1DJtBGON4lIP24yE9Fy+KfDR0r2nbAHF49Y4qQ1TVV9EeqPsw4uiXZ
         V6BYuJU5Y1869KMtSMhHMR5B0MAKivIZcHWtz2J3d2VFF3zsmVm/JK9MNlI5Yih1ivE+
         09ZQ==
X-Gm-Message-State: AAQBX9ewdgnm2vl6XDoMzx2Kxy6jFLJ+SfXKGn6EUFjY/OPAoJ+S5tvx
        cH0H/l7yNtVE5bvR7kiLRRYvGx+s/Gk=
X-Google-Smtp-Source: AKy350a8MFYJbJMyMUyUyVnoeSI0Gdh0aZPnNKDIDNcTDAsavzt+sEY8RBC1huGFNFieEgI4FBNtew==
X-Received: by 2002:a5d:5290:0:b0:2cf:efc7:19ad with SMTP id c16-20020a5d5290000000b002cfefc719admr1425979wrv.53.1681396137877;
        Thu, 13 Apr 2023 07:28:57 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.97.186.threembb.co.uk. [94.196.97.186])
        by smtp.gmail.com with ESMTPSA id z14-20020adff1ce000000b002f28de9f73bsm1387391wro.55.2023.04.13.07.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 07:28:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 05/10] io_uring/rsrc: fix DEFER_TASKRUN rsrc quiesce
Date:   Thu, 13 Apr 2023 15:28:09 +0100
Message-Id: <f1a90d1bc5ebf096475b018fed52e54f3b89d4af.1681395792.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681395792.git.asml.silence@gmail.com>
References: <cover.1681395792.git.asml.silence@gmail.com>
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

For io_rsrc_ref_quiesce() to progress it should execute all task_work
items, including deferred ones. However, currently nobody would wake us,
and so let's set ctx->cq_wait_nr, so io_req_local_work_add() would wake
us up.

Fixes: c0e0d6ba25f18 ("io_uring: add IORING_SETUP_DEFER_TASKRUN")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index f9ce4076c73d..e634ef384724 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -273,6 +273,11 @@ __cold static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 	if (io_put_rsrc_data_ref(data))
 		return 0;
 
+	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
+		atomic_set(&ctx->cq_wait_nr, 1);
+		smp_mb();
+	}
+
 	data->quiesce = true;
 	do {
 		prepare_to_wait(&ctx->rsrc_quiesce_wq, &we, TASK_INTERRUPTIBLE);
@@ -298,6 +303,10 @@ __cold static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 
 	finish_wait(&ctx->rsrc_quiesce_wq, &we);
 	data->quiesce = false;
+	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
+		atomic_set(&ctx->cq_wait_nr, 0);
+		smp_mb();
+	}
 	return ret;
 }
 
-- 
2.40.0

