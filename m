Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DABC179B6E5
	for <lists+io-uring@lfdr.de>; Tue, 12 Sep 2023 02:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244269AbjIKWKe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Sep 2023 18:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236412AbjIKKef (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Sep 2023 06:34:35 -0400
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9E0E5F;
        Mon, 11 Sep 2023 03:34:30 -0700 (PDT)
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-501cef42bc9so6936103e87.0;
        Mon, 11 Sep 2023 03:34:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694428468; x=1695033268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gptGKutv8UrS/zDN0Qmum7MxSe9eEjLIE1n6bMLfanE=;
        b=fjwGZqU0XX1eFlobZPhQwLGEaFslXYsfR6JtFiPdtqpiFqSNZZY+KEIiAh5YtLlAX6
         aPGRIpoyf2qtUGko6JOnhRFw0ofVPtyV4M7DUOagMbWTYfc9ATkPDcMC5b+mxG3eJLkF
         AuJePBlUumkPNrXhVZy9mvrVoYPo7IqufPSErTzu6mSjZAJ70T9b5MCkYZHpOhc6GfUI
         GK7+X5mzMZv0GWBYpBQWVmzu2XvgN4Fj3yHXVjblddwKQ+TzmvrFqKMy+SjkLOyrK8Yb
         0UK/vsEddCL15EcPcaMoG27aoP8PjrPGxD5Wv13hcFyhWMZSdM8B+E/0skHgEeF5gNYk
         fanA==
X-Gm-Message-State: AOJu0YzXg5hMgTwoNHfscE3OIJlqwOxE6jOg4F8DiNV7CRLurgvnz1LW
        HGTNCtq+XPBLN8Ah7qEUpxU=
X-Google-Smtp-Source: AGHT+IE04qAA52ud2RBYfVMX6E4dXcBtrekuG1o6qnVmzVtntDq44/WaDkwl7P+Orft4t/uxKZ6vzQ==
X-Received: by 2002:a05:6512:3d09:b0:4fb:89b3:3373 with SMTP id d9-20020a0565123d0900b004fb89b33373mr9263203lfv.43.1694428468123;
        Mon, 11 Sep 2023 03:34:28 -0700 (PDT)
Received: from localhost (fwdproxy-cln-118.fbsv.net. [2a03:2880:31ff:76::face:b00c])
        by smtp.gmail.com with ESMTPSA id s10-20020aa7d78a000000b00523653295f9sm4399748edq.94.2023.09.11.03.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 03:34:27 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        martin.lau@linux.dev, krisman@suse.de
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, pabeni@redhat.com
Subject: [PATCH v5 3/8] io_uring/cmd: Pass compat mode in issue_flags
Date:   Mon, 11 Sep 2023 03:34:02 -0700
Message-Id: <20230911103407.1393149-4-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230911103407.1393149-1-leitao@debian.org>
References: <20230911103407.1393149-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
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
---
 include/linux/io_uring.h | 1 +
 io_uring/uring_cmd.c     | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 106cdc55ff3b..bc53b35966ed 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -20,6 +20,7 @@ enum io_uring_cmd_flags {
 	IO_URING_F_SQE128		= (1 << 8),
 	IO_URING_F_CQE32		= (1 << 9),
 	IO_URING_F_IOPOLL		= (1 << 10),
+	IO_URING_F_COMPAT		= (1 << 11),
 };
 
 struct io_uring_cmd {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 537795fddc87..60f843a357e0 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -128,6 +128,8 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
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

