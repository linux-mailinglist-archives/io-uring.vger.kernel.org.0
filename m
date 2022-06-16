Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E02154D78B
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 03:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349884AbiFPBzN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 21:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348001AbiFPBzM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 21:55:12 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56CC618364
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 18:55:11 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id v17-20020a17090a899100b001ead067eaf9so502847pjn.0
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 18:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:cc:content-transfer-encoding;
        bh=nW/e+jBO8wEgsZiiBJtv7dQGFLCIRmJbop3gsocaY1A=;
        b=PLth28EKcSxIRm4XpfxvvwpJAwheOEgcQvMSWCvD4uQFAliPrmKtRLP4x9qxwZiKqF
         MH+fbslitd5rgj4WypEZtdB/7SSaP3uKi6A+p+nvOABAMS3nxN9DhanghF+ZEqnhoBRo
         KN2zBDjr+CVUuxUq+C3wJX6SQQY892t9itCF717TjbKZ6LSAuPNBChKspgJA5by5Se40
         KRB52a3ijw5anobIKQbIRs4lVGLpbns8pftCH1J5UnS1Cep4wPdev3qjsGI3eY+tIGPi
         erFe5sVBe0xWFfVIBh1JkZ+3iQKN6hVM7gSthjy2T/r5/Rqg3XDMwgLfskkHHCyH4Qy8
         9XqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:cc:content-transfer-encoding;
        bh=nW/e+jBO8wEgsZiiBJtv7dQGFLCIRmJbop3gsocaY1A=;
        b=iM/EwqUs51iUI0h0TwbOCm8Z5Lq+2W1hHFn1ZGNuryDiw77Bgl/dCQHHbfXwvNh7l3
         5RjptfzbJSeIn3AdAvkEBnrnTjoghD7ym+LncRtja/M9+phIu2FKJ4sVZdhbB+Zl7ooM
         iFyf94KKCQhj4v/GFD5oHnr2uf5FOAEXpxvn3yobmXc8eGm9ryFJ95Pf48OdvV6jFQLL
         eKQa3LGjLgLXNdM1FBw/dFhU+4VpOlapQVielpx++nLvlG4SeHZZthHm3hpPOie95H6t
         eAnUXu0NwacurL0XEL/WahEzc/Uc3/wDJSK0/GqXeepx3W+QU4EjhbV8qryRy7c1fUxB
         ZrXA==
X-Gm-Message-State: AJIora/2HjH+zw9t9aB9+VrCIlGHzEQ7sNlXQPOMbsLOL7HDExBojI2y
        cOGGw7U+1qE0Z6jKVhlVK1gZ3JbwtQGwUQ==
X-Google-Smtp-Source: AGRyM1t0bNoM06FgEFtAHX/mJ/IBg323PjBMdCOLmoY6GPzSCP/ZCjlc6aZhacI7AH++ZqiWch7hdg==
X-Received: by 2002:a17:90a:b894:b0:1e2:d8f8:41e9 with SMTP id o20-20020a17090ab89400b001e2d8f841e9mr13378092pjr.20.1655344510545;
        Wed, 15 Jun 2022 18:55:10 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y11-20020a170902d64b00b00161955fe0d5sm273748plh.274.2022.06.15.18.55.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 18:55:09 -0700 (PDT)
Message-ID: <b0c9112b-15d3-052b-3880-a81bed7a5842@kernel.dk>
Date:   Wed, 15 Jun 2022 19:55:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: read/readv must commit ring mapped buffers upfront
Cc:     Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For recv/recvmsg, IO either completes immediately or gets queued for a
retry. This isn't the case for read/readv, if eg a normal file or a block
device is used. Here, an operation can get queued with the block layer.
If this happens, ring mapped buffers must get committed immediately to
avoid that the next read can consume the same buffer.

Add an io_op_def flag for this, buffer_ring_commit. If set, when a mapped
buffer is selected, it is immediately committed.

Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5d479428d8e5..05703bcf73fd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1098,6 +1098,8 @@ struct io_op_def {
 	unsigned		poll_exclusive : 1;
 	/* op supports buffer selection */
 	unsigned		buffer_select : 1;
+	/* op needs immediate commit of ring mapped buffers */
+	unsigned		buffer_ring_commit : 1;
 	/* do prep async if is going to be punted */
 	unsigned		needs_async_setup : 1;
 	/* opcode is not supported by this kernel */
@@ -1122,6 +1124,7 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
 		.buffer_select		= 1,
+		.buffer_ring_commit	= 1,
 		.needs_async_setup	= 1,
 		.plug			= 1,
 		.audit_skip		= 1,
@@ -1239,6 +1242,7 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
 		.buffer_select		= 1,
+		.buffer_ring_commit	= 1,
 		.plug			= 1,
 		.audit_skip		= 1,
 		.ioprio			= 1,
@@ -3836,7 +3840,8 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	req->buf_list = bl;
 	req->buf_index = buf->bid;
 
-	if (issue_flags & IO_URING_F_UNLOCKED) {
+	if (issue_flags & IO_URING_F_UNLOCKED ||
+	    io_op_defs[req->opcode].buffer_ring_commit) {
 		/*
 		 * If we came in unlocked, we have no choice but to consume the
 		 * buffer here. This does mean it'll be pinned until the IO

-- 
Jens Axboe

