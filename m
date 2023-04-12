Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 967616DFD39
	for <lists+io-uring@lfdr.de>; Wed, 12 Apr 2023 20:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjDLSJW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Apr 2023 14:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDLSJV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Apr 2023 14:09:21 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD3610FC
        for <io-uring@vger.kernel.org>; Wed, 12 Apr 2023 11:09:20 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id e9e14a558f8ab-32955d335f5so107905ab.1
        for <io-uring@vger.kernel.org>; Wed, 12 Apr 2023 11:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1681322959; x=1683914959;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tVh0V+0xSxnBUwpVqbXOMIPB07EWpKjIfkHJ1rbZvrM=;
        b=xOI224R/uxi+iH6rIWyBvv9iISNa6YdGkJXVorAKJIIVoQo3o4FmxbIeEyR7qnx32G
         peuLvKQzgzYeA321qFszv2G/rlDhEaFNYnKhRmdR1r9RsYGgG2HxHakCxf06YiwdkZmk
         F1XeF14cT1J2Kvt8LY2zUnMcEmoyCJK4JegCvq8xnlRR7UzTYCiWz/QJ4Y1U/PfAdDmS
         aWbG/3qcGv1XpjP6EQYZCQSIusFeCCKxusXANJAansowaRMJshX1ibJBArUEwTx13QC4
         /yEtFWRxfa2Lj58dhFW1iaOP9t/pFV7/stwtQtwbGzVg0VbVexbFp0hZcad0m6bfg9IC
         ntKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681322959; x=1683914959;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tVh0V+0xSxnBUwpVqbXOMIPB07EWpKjIfkHJ1rbZvrM=;
        b=EGPX/FVyXqW+SvmQye/bs87VD/o62Q6DGl7MfD7J+D9yguVSefG78jxE+JTCBLELVP
         QTg34QnajZUqqowE6q6o4zt0BpTRK5CWrzARDOrpftMgAteXIOgq2lLXPaWmLZ0ivIJg
         PWbmnDzWAVHLKl7brwzMignQmpDMQDaGZNrITeOLGHxwxBYdY2ygsGQr031GieWn6cou
         FLQSJ+8ElwZexHbETghbc/qAI/dLbilJ/eF5U4qrLhPqAyU9NWLbUV1N2B3BlHwYQG1l
         qn+IR85PuPX4pVzDPmobm9cRdbWWNNxGHzFXTU4SazKW/X/RHZu6W5tndzvsR4hpOW6u
         2RBw==
X-Gm-Message-State: AAQBX9epaEDaV5NAYy+L6cCHK+n95TOPt0JO6tc5bhbxkCIFNdv+/K6z
        HMmsebhnsOb8c3s/fEsi8rqE6ZduBEG/7F3enhA=
X-Google-Smtp-Source: AKy350ZBDZ5g6FlkZB6TP8/O2l4M6GogBdHL+0NYIIzb+s4FyKyEkv7OJqon/s++p6g67U+WMt7h5A==
X-Received: by 2002:a05:6e02:1bac:b0:329:5d05:7801 with SMTP id n12-20020a056e021bac00b003295d057801mr588035ili.0.1681322959099;
        Wed, 12 Apr 2023 11:09:19 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id b9-20020a923409000000b003291bea8c7fsm1001003ila.81.2023.04.12.11.09.18
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Apr 2023 11:09:18 -0700 (PDT)
Message-ID: <bbcdf761-e6f2-c2c5-dfb7-4579124a8fd5@kernel.dk>
Date:   Wed, 12 Apr 2023 12:09:18 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/uring_cmd: take advantage of completion batching
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We know now what the completion context is for the uring_cmd completion
handling, so use that to have io_req_task_complete() decide what the
best way to complete the request is. This allows batching of the posted
completions if we have multiple pending, rather than always doing them
one-by-one.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index f7a96bc76ea1..5113c9a48583 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -54,11 +54,15 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
 	io_req_set_res(req, ret, 0);
 	if (req->ctx->flags & IORING_SETUP_CQE32)
 		io_req_set_cqe32_extra(req, res2, 0);
-	if (req->ctx->flags & IORING_SETUP_IOPOLL)
+	if (req->ctx->flags & IORING_SETUP_IOPOLL) {
 		/* order with io_iopoll_req_issued() checking ->iopoll_complete */
 		smp_store_release(&req->iopoll_completed, 1);
-	else
-		io_req_complete_post(req, issue_flags);
+	} else {
+		struct io_tw_state ts = {
+			.locked = !(issue_flags & IO_URING_F_UNLOCKED),
+		};
+		io_req_task_complete(req, &ts);
+	}
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 
-- 
Jens Axboe

