Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 145A87CAABF
	for <lists+io-uring@lfdr.de>; Mon, 16 Oct 2023 16:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233562AbjJPOBt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Oct 2023 10:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233445AbjJPOBq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Oct 2023 10:01:46 -0400
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037ECE3;
        Mon, 16 Oct 2023 07:01:45 -0700 (PDT)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-523100882f2so7633308a12.2;
        Mon, 16 Oct 2023 07:01:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697464903; x=1698069703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VMTVz0v3sd6CbNeaWSc/IAFY8fAG0gp37H36LBoCuEY=;
        b=HgMGfVmEq4HtnYPh+fovghJbeoV2Wv46wCW1O0AjIUeN/CYoXFgFJVB6hHMesbxj0I
         RF2gQW1X69ra/yxsheRemdJ+2tmMbPz6IZrL1Pp0dm/8U/bA/Uhh3j90U7VSmILtazOv
         K4XLYPWt9+zzkinKDzxlecIiVNZX8aLTrXVaM5en8qReWVXBzeyW9MJI4SoO2zGmmxaP
         MF9ZdPbhcPtT8SkLIIJhd+17/9GJwKalyxcD2z4lZJz6XBcGJAaE8A6QO7mccJv+lc7l
         CqZXEG9rxgwXi0ZdU5fKZODpe2pBUPgsl5qKUqx3/T0Oxg2GfiYatJ7mSbGWZ7y56yU9
         YdoA==
X-Gm-Message-State: AOJu0YzcSbSVRpHEEg2DEZxuAZFRI+6GXNUvrGt2m+A6O7tnNHqCTxLw
        9GevXmQ8h6dXEW9c69u2BLI=
X-Google-Smtp-Source: AGHT+IGGw8pWYeUP4kPNXFpNNDHaQySfWE7Hr5VNG/1M9aHu6uc+ou050XkJAQBc24YjTpyU/sylTw==
X-Received: by 2002:a17:907:8b8c:b0:9a2:28dc:4166 with SMTP id tb12-20020a1709078b8c00b009a228dc4166mr32176684ejc.75.1697464903116;
        Mon, 16 Oct 2023 07:01:43 -0700 (PDT)
Received: from localhost (fwdproxy-cln-016.fbsv.net. [2a03:2880:31ff:10::face:b00c])
        by smtp.gmail.com with ESMTPSA id gx11-20020a1709068a4b00b0099290e2c163sm4040171ejc.204.2023.10.16.07.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 07:01:42 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        pabeni@redhat.com, martin.lau@linux.dev, krisman@suse.de
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH v7 05/11] io_uring/cmd: Pass compat mode in issue_flags
Date:   Mon, 16 Oct 2023 06:47:43 -0700
Message-Id: <20231016134750.1381153-6-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231016134750.1381153-1-leitao@debian.org>
References: <20231016134750.1381153-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Create a new flag to track if the operation is running compat mode.
This basically check the context->compat and pass it to the issue_flags,
so, it could be queried later in the callbacks.

Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 include/linux/io_uring.h | 1 +
 io_uring/uring_cmd.c     | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index b4391e0a9bc8..aefb73eeeebf 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -23,6 +23,7 @@ enum io_uring_cmd_flags {
 
 	/* set when uring wants to cancel a previously issued command */
 	IO_URING_F_CANCEL		= (1 << 11),
+	IO_URING_F_COMPAT		= (1 << 12),
 };
 
 /* only top 8 bits of sqe->uring_cmd_flags for kernel internal use */
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 00a5e5621a28..4bedd633c08c 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -175,6 +175,8 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 		issue_flags |= IO_URING_F_SQE128;
 	if (ctx->flags & IORING_SETUP_CQE32)
 		issue_flags |= IO_URING_F_CQE32;
+	if (ctx->compat)
+		issue_flags |= IO_URING_F_COMPAT;
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
 		if (!file->f_op->uring_cmd_iopoll)
 			return -EOPNOTSUPP;
-- 
2.34.1

