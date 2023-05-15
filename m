Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480E0702D45
	for <lists+io-uring@lfdr.de>; Mon, 15 May 2023 14:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242001AbjEOM6I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 May 2023 08:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242088AbjEOM5v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 May 2023 08:57:51 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FA61BEF;
        Mon, 15 May 2023 05:57:41 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-965fc25f009so2060999066b.3;
        Mon, 15 May 2023 05:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684155459; x=1686747459;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A48EUvATFnZh9D6jBlZ8QJ+HRRU2GPVKxJ6T/ClswYY=;
        b=B94E+rYQEFtywvHsGIgQ9mmQaaFbdMyn2sKZp5SXzSvrHpndqya34/Wg256icZ6H/d
         C6i4TBNb/nm9LFRrnldiL5RDBY0qQYgteR/qWCNp3ePZaI9bS+aDrBVGH86FuarHNLh/
         qOdS7lhDJzCWsyL6E4cUVM5SBRoc4A4oZDsG+e/KSeQ8LNU1PasU71B7rd+TFN1kaXlc
         kHu+DujDp3gALaNiGffHF6f52CccQqkVN104W3Adg3ay1TBfsI2XomQ3y22dzIa9Hwji
         RsTMTDVKIRBWhune2y1mIWFfkoxRJqNJhrF7WQpPSYNAzLzVeSUCCkxLtGjCo11EGGUY
         ZVcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684155459; x=1686747459;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A48EUvATFnZh9D6jBlZ8QJ+HRRU2GPVKxJ6T/ClswYY=;
        b=jXmeilTyZYCSuipXun1SzzeTwNPE0rOctspL8kUGzf8BhtZR16jRc9MAQ4EdQ6m89g
         dYvOd91fIXLBp/+TLvIjLQtjQyeYOleGCJbrxnh11i1xhHwSA1IwO5YBfVmGLmDQmJB9
         By2pgBEfm5J3M95EFYNBWSfdFWh9ezSm1p4dBrvY2qDwwAjMuraSp9FEjcJss1whmNbp
         7t9elhDl8Meg87t/+NWM524NJVMR7qK47kRSgYndgmSVggVcS0JCFn0y0j2Aa4WTfYND
         iQTwwz9G2rCtdqR4aRArNjZXZoOYa1WMq/9hl8uipP1fBfKVYYW+OhQXnRLgiEzV1fpE
         jNSw==
X-Gm-Message-State: AC+VfDyWDWSkhtY9VE/Fi5J0UBfQ+2qyokTIiDjSsvxqprGO0CfI04sZ
        HXBZUllu8NYeqVUE+PPrID0=
X-Google-Smtp-Source: ACHHUZ7Ng0cIhxR4lpY4sfifZqKzwQl+W7KvOkOYDWeQBODzPtjKkf8J4RxdtSlK5nvP0gOSrg9eQw==
X-Received: by 2002:a17:907:6088:b0:949:cb6a:b6f7 with SMTP id ht8-20020a170907608800b00949cb6ab6f7mr32952390ejc.56.1684155459464;
        Mon, 15 May 2023 05:57:39 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:6366])
        by smtp.gmail.com with ESMTPSA id m13-20020a17090672cd00b0096ace7ae086sm4003685ejl.174.2023.05.15.05.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 05:57:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, axboe@kernel.dk
Cc:     kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        joshi.k@samsung.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH for-next 2/2] nvme: optimise io_uring passthrough completion
Date:   Mon, 15 May 2023 13:54:43 +0100
Message-Id: <ecdfacd0967a22d88b7779e2efd09e040825d0f8.1684154817.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1684154817.git.asml.silence@gmail.com>
References: <cover.1684154817.git.asml.silence@gmail.com>
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

Use IOU_F_TWQ_LAZY_WAKE via iou_cmd_exec_in_task_lazy() for passthrough
commands completion. It further delays the execution of task_work for
DEFER_TASKRUN until there are enough of task_work items queued to meet
the waiting criteria, which reduces the number of wake ups we issue.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/nvme/host/ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 81c5c9e38477..52ed1094ccbb 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -521,7 +521,7 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
 	if (cookie != NULL && blk_rq_is_poll(req))
 		nvme_uring_task_cb(ioucmd, IO_URING_F_UNLOCKED);
 	else
-		io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_cb);
+		io_uring_cmd_do_in_task_lazy(ioucmd, nvme_uring_task_cb);
 
 	return RQ_END_IO_FREE;
 }
@@ -543,7 +543,7 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io_meta(struct request *req,
 	if (cookie != NULL && blk_rq_is_poll(req))
 		nvme_uring_task_meta_cb(ioucmd, IO_URING_F_UNLOCKED);
 	else
-		io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_meta_cb);
+		io_uring_cmd_do_in_task_lazy(ioucmd, nvme_uring_task_meta_cb);
 
 	return RQ_END_IO_NONE;
 }
-- 
2.40.0

