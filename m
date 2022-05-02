Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 323E7516993
	for <lists+io-uring@lfdr.de>; Mon,  2 May 2022 05:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238656AbiEBDac (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 May 2022 23:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbiEBDab (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 May 2022 23:30:31 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6743F334
        for <io-uring@vger.kernel.org>; Sun,  1 May 2022 20:27:03 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id gj17-20020a17090b109100b001d8b390f77bso15107869pjb.1
        for <io-uring@vger.kernel.org>; Sun, 01 May 2022 20:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=rVm0CHym8p7AhzCEDqyVgDhmR8qm2Ptb0ytmdsX476E=;
        b=5XwjQN+JBGmnplMEyukFlXUze3z54AbjYCPteaYKIArV3km1gPEZxqKiUFWAx8ky0d
         C7dtQMlnNxJdecxKDX8zzN7JdD+r14rMT+asCW+Y+7sEHNP3aHddsD+ch5PRzjGBE1ff
         kHQa4xnqLx7LEIsu58CgJ1cl/bsv5sABQUABDIw69z4Hqh2SDZOR/75a9dISVaBQU8O/
         PicZ9UIcFAbGDG+FUXz0zLTV81eoOOLM0jXQKxrJHx8TXRzR1mZb0atUOv8Z1LT2+jDB
         6xgsnFRL+BRLhQYSQGKiaXPnVJo287s4IX9M1i0P2bWxJ+B7fLZ3lzmV+eQscMLcdtb1
         +/Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=rVm0CHym8p7AhzCEDqyVgDhmR8qm2Ptb0ytmdsX476E=;
        b=UZi9eB10YL8fZP4I/I/wnEvYJgiaRmSZ1J1ao9isLIqWesyaPnyHIrxn0JnGFMoMMg
         yZwhFaYHfEu/KzYE0+7gu67gdlEPh1T0QdBC4lrZzNYT81h2xVXWQYUQ6bhJusRNWkYV
         dCChKfkVapnGLU6809BY9hv0oflvBGlOWdtT6FGrmcRRBFrQ74TYR5b88Ck6IB7apYLs
         ZhJ16JkSOOwW1QMTssceu8T0tzve6znqOLvEPUrtuIku6z4OEouJGARd7LpdjNJgQEWE
         HmhWIqzAKxHtPNFljRJt1GIcjXVkZvTDhRQFbPp5/9mk6eJOS26IOOPKRSbLsUOScORg
         oAfg==
X-Gm-Message-State: AOAM5314w243bweARa9WPQBirkVTidCeuopV3pBb+mi/g/oXTvk/hsSQ
        Y6LaJkg/t9pO0679iw1FhiC7Xxq9rV1Plg==
X-Google-Smtp-Source: ABdhPJysX8m5/kVB4kvbmGqt5IMCTPK4+4bBp3qxNmHEmW3neQpeBdt352M8dxWkeAWY6hDN9uPkPw==
X-Received: by 2002:a17:90a:c797:b0:1d9:2764:a83b with SMTP id gn23-20020a17090ac79700b001d92764a83bmr15817433pjb.5.1651462022915;
        Sun, 01 May 2022 20:27:02 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id e1-20020aa78241000000b0050dc76281c7sm3530223pfn.161.2022.05.01.20.27.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 May 2022 20:27:02 -0700 (PDT)
Message-ID: <76d08f1c-3744-6470-1fe3-9d4064a61869@kernel.dk>
Date:   Sun, 1 May 2022 21:27:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: assign non-fixed early for async work
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

We defer file assignment to ensure that fixed files work with links
between a direct accept/open and the links that follow it. But this has
the side effect that normal file assignment is then not complete by the
time that request submission has been done.

For deferred execution, if the file is a regular file, assign it when
we do the async prep anyway.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Undecided if we really need this, but as it stands, if the app does:

io_uring_prep_read(sqe, fd, buf, sizeof(buf), 0);
sqe->flags |= IOSQE_ASYNC;
io_uring_submit(ring);
close(fd);

then before the deferred assignment, this would've worked as the file
assignment would have been done before io_uring_submit() returns. Now,
this isn't the case, and we'll get -EBADF. Another case would be that
if you do:

io_uring_prep_read(sqe, fd, buf, sizeof(buf), 0);
sqe->flags |= IOSQE_ASYNC;
io_uring_submit(ring);

close(fd);
fd = open(something else);

and the new fd has the same value as the old one, then the above sqe
could get either one in the read. With this patch, we'll consistently
get the old fd as we did before.

It's worth nothing that IORING_SETUP_SQPOLL has the same behavior, both
before and after that deferred file assignment. Though that's more
expected, and the general contract between the app and the kernel for
SQPOLL is that submission side state needs to be valid until the
completion as the app doesn't know when the sqe has been consumed.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index e01f595f5b7d..7d73b8ecc2e2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6947,7 +6947,12 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 static int io_req_prep_async(struct io_kiocb *req)
 {
-	if (!io_op_defs[req->opcode].needs_async_setup)
+	const struct io_op_def *def = &io_op_defs[req->opcode];
+
+	/* assign early for deferred execution for non-fixed file */
+	if (def->needs_file && !(req->flags & REQ_F_FIXED_FILE))
+		req->file = io_file_get_normal(req, req->cqe.fd);
+	if (!def->needs_async_setup)
 		return 0;
 	if (WARN_ON_ONCE(req_has_async_data(req)))
 		return -EFAULT;

-- 
Jens Axboe

