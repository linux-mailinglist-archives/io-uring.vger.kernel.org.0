Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11ACB51606D
	for <lists+io-uring@lfdr.de>; Sat, 30 Apr 2022 22:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242602AbiD3UyL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 Apr 2022 16:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245170AbiD3Ux6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 Apr 2022 16:53:58 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2687613F70
        for <io-uring@vger.kernel.org>; Sat, 30 Apr 2022 13:50:35 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id a11so9577621pff.1
        for <io-uring@vger.kernel.org>; Sat, 30 Apr 2022 13:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=552Zxr/Ks+nliIwSuB+IALQxcQANSOxSIES+S1Zy8NI=;
        b=Zup1iKYslJKcwHJZakWNbh/QFkKOgH/X3T5CIrquSwDEer339psyAfybzhjLP36dvd
         RT5uch6LdCIsVf4hW2duoRbWLADXnJI7UFE3ZEEkcRrq/WjqbtXMSinRTX7IWYnyJjQu
         dkshv8dVR6qn7XiMgIIG9OxHUOQ4NBuVsnB08yVxm3HSUbqozP6XR/PMQwT0wD39OIMX
         byHuno2Uq02VB5HAg9cECBTUmg0d+m7ZsvDzLxB376fvHKANUTQ44dT0kzQyDSYbFQsJ
         /Lf0/61SU1CySq11OBOYl+it4QKBnneV9Yq+VqrnVd6V1NzydRt85mlYy2DDGmotz/JU
         Ly+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=552Zxr/Ks+nliIwSuB+IALQxcQANSOxSIES+S1Zy8NI=;
        b=ixOO0kWUPtwmDrbxqf4zlZvzwnxS8kGppgXyZzRq9xm1RRAUrrA/Eqm2LV0+RJYsSg
         VA4/SsJSHaDuDatLiG7M3tYhdQN/Dv8vkr0ztnwp1HWD7iabAkahkBgtWN6FyUWqugQW
         nbKPQREAVl3Zlub7cqIEDhcAcBFg+ZzyN5idu/ojV4Pc8Idfd5KDDnvQ+oVwKpKL/8y/
         KnzItJLrpMFc3EGCggrnR5tc4LmapGH2l7siwm53aWt+RY06dcl5LGXNTpVAz+lOcAxz
         5O77WTqETJAzuwmFlMsznj49mstfO1Na29AWXnEq1UyvKRD22HPXRwjESndccVesZhtD
         S9aQ==
X-Gm-Message-State: AOAM531UtW6u0qRszXLKIECkyrd6QNiNKZYJqZg1uDNoO5j+U/Z01RA5
        Ep3IxUQqpefc4LQgIK6pzLThl09HS1a2Vc1y
X-Google-Smtp-Source: ABdhPJyjI+Mw4Fc7QLlyVj7w/E2JXpO0iURd8wRfloLtfk/3HFPw5LhceXi8LIJb4ONX9xuFv/qn6Q==
X-Received: by 2002:a62:6d47:0:b0:4fe:15fa:301d with SMTP id i68-20020a626d47000000b004fe15fa301dmr4910686pfc.29.1651351834386;
        Sat, 30 Apr 2022 13:50:34 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t13-20020a17090340cd00b0015e8d4eb1c4sm1854066pld.14.2022.04.30.13.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Apr 2022 13:50:33 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 08/12] io_uring: add buffer selection support to IORING_OP_NOP
Date:   Sat, 30 Apr 2022 14:50:18 -0600
Message-Id: <20220430205022.324902-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220430205022.324902-1-axboe@kernel.dk>
References: <20220430205022.324902-1-axboe@kernel.dk>
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
index 3b61cf06275d..eb168a7c6e06 100644
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
@@ -4910,11 +4912,20 @@ static int io_splice(struct io_kiocb *req, unsigned int issue_flags)
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

