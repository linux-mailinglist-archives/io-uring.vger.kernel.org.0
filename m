Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14CE9515313
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 19:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379842AbiD2SAJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 14:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236055AbiD2SAH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 14:00:07 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D5DD1148
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 10:56:47 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id z12so4457757ilp.8
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 10:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kfjqnZOL38qe4ExfZMYi4Qy/yUWn7cNXVBJBAlUBZio=;
        b=c0KcuuJv/GgSJQq9xEvPQbII96nEIrPHc1RQVVXWAROZOZkpK/o7nU9lsoA7lBKYZQ
         CN9eb0AB6zNek2A/Abgx8tji6Gmb8pEtapQ+GI2NX+o6jHMhRkVY9WiU1WMa21BA5oFC
         7Xy26d6IYjCcB6RZQK0ECacX+ez+tfnf8xsKDf9YXrLS1zUurvrau1xolatTubIh0b1/
         aw7BlJKdAIM9CfVr7EH6rrtYW1EJJKpGV+LyDqknTlHVQc7zoVh/BMZPEC6crBbXW/ya
         K1KK0w3qkMFho92ICJ/fGxRCelpmk5KmFyRfmxu9rBAAXK2jgHvPro7Cf0BdBbpPBZbV
         QVgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kfjqnZOL38qe4ExfZMYi4Qy/yUWn7cNXVBJBAlUBZio=;
        b=pU036W8FHSo4nUxzpBwHPnIrk42IfBdxNf9G5BAmuCwqVcsTpDpkOFlfKMTnGPRhXp
         FXniSfvSKWN2bRrDF7qBGcMBY50lmk5gYls+XsJlCQvMENglPoQkhDVTe8IKD3SdSnZ1
         KGliGcAVrTDKJlVGp3njViNsPtrh5tmnhFUc1nd8WBsEPul1DbbnUJ0LKUFY3707Mr00
         kR0BxPiulcSeE+6X4Qi71iTe90mss2MOkQj+/WzEvz+U04H950mmWI7fn/hP2J/F+/ez
         E5GpuWkfSTaBck5RPSEMSIA9FpIRnmNQfaXqdixdFoA2wgX6eZsbcHu67GCS5LGYkXRf
         3V7w==
X-Gm-Message-State: AOAM53338A94IeJJb93ZtjbLf7eNwKaOSyELjagx1sTVNhANb8KlJcWS
        P4/RBp4RrvFd9BAEdjM/tqxdF2WaeCQgoA==
X-Google-Smtp-Source: ABdhPJzaAhyzmnXEfWEHKgVW0PvXTydjn3PcnAyVj9BveqX+cNBYqK9Ucrr1p5G8JLdWdx1l5KtYnQ==
X-Received: by 2002:a05:6e02:1bc1:b0:2cd:5db6:d9e8 with SMTP id x1-20020a056e021bc100b002cd5db6d9e8mr218418ilv.276.1651255007088;
        Fri, 29 Apr 2022 10:56:47 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o9-20020a02cc29000000b0032b3a78179dsm744082jap.97.2022.04.29.10.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 10:56:46 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 07/11] io_uring: add buffer selection support to IORING_OP_NOP
Date:   Fri, 29 Apr 2022 11:56:31 -0600
Message-Id: <20220429175635.230192-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220429175635.230192-1-axboe@kernel.dk>
References: <20220429175635.230192-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Obviously not really useful since it's not transferring data, but it
is helpful in benchmarking overhead of provided buffers.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4bd2f4d868c2..d4004c3a88a1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1052,7 +1052,9 @@ struct io_op_def {
 };
 
 static const struct io_op_def io_op_defs[] = {
-	[IORING_OP_NOP] = {},
+	[IORING_OP_NOP] = {
+		.buffer_select		= 1,
+	},
 	[IORING_OP_READV] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
@@ -4905,11 +4907,20 @@ static int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 static int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	void __user *buf;
 
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 
-	__io_req_complete(req, issue_flags, 0, 0);
+	if (req->flags & REQ_F_BUFFER_SELECT) {
+		size_t len = 1;
+
+		buf = io_buffer_select(req, &len, issue_flags);
+		if (IS_ERR(buf))
+			return PTR_ERR(buf);
+	}
+
+	__io_req_complete(req, issue_flags, 0, io_put_kbuf(req, issue_flags));
 	return 0;
 }
 
-- 
2.35.1

