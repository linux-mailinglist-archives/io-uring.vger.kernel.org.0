Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0123510E7A
	for <lists+io-uring@lfdr.de>; Wed, 27 Apr 2022 04:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356808AbiD0BxY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 21:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356736AbiD0BxX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 21:53:23 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8704215824
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 18:50:11 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id fv2so196181pjb.4
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 18:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8r171opknbKJUnYZLLvZw4drJgoJzZw12UPzs6Awqsk=;
        b=IptFlrLAU/0ERLfhSnSBpt3ZYVsHJqW2ExpBRua7XqGuqvycM6PhlnjLY4FVrzJWah
         GMWBBtzy44nw7XBLNvBcOu7J5l9L2Uel83ifZZ+/xTvm2fn2Hgxv3LT9SMGtzlE7I6KG
         XdzzeX5UVjX1InN26L8rzmfDeMCGUw/pi6OAv91EG0QWBoZN4t3wQ3k5SPUxy9nDJX/b
         kwaRu8qUm5JIf8J0cyO4TaJLGUEbXsGoflUnMl8I50RBTR7AjZLQ7oLmG2tK+4MCVRuC
         xrpGlcwyYrSqMTVfVctq6O6E/6VvfLPmn9182A+0JrTafiCt0m75+E8EYqcWmoP2VC35
         AX6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8r171opknbKJUnYZLLvZw4drJgoJzZw12UPzs6Awqsk=;
        b=37QSZqHK+zNMlqmeoF9PkLTssiCpoYAHYcYyJ6bSzC3KaGwETOeS2YzM8iOzKmOdie
         bWfu4Z5DNZfg2EC6DIp2KFIEyS557vKUj3uBPrDHuzlm8EIaCQ4kjMPXYOKa5Psfusrn
         y6I+73YJpJWoUvthP3EZeH08oGAwdrl4FLcFLLafkMKWM+rwogj3zHDZ2O+MlxeLgd7U
         22ce+6ZCUss6tPIY56QVzoc53mWekjRv3Vci/EFjXDFo8r4hYKxy+O9HIJYunkmbYXvA
         SohfWif2/MUW6smSF6T2R7OU+HdXqBiIcXGE4yIBqluZ2GRE6BCg5C2dCb6z6i6ah1A5
         o+2Q==
X-Gm-Message-State: AOAM5301JsFkHPn4x25VbkRXxsxVoSxQbKuJHLiUbYMXI1GnEpjUBU/K
        J8A+CO/96n5Aze0Kjxa06t8YTRS84wR/D8Ov
X-Google-Smtp-Source: ABdhPJw08Lwqq3G4TeVtYO8IIP3NbXyMczytngFQ62qtT7OvCmO4P+Wy0jnrIDuPXIhWtvVBRKXKVA==
X-Received: by 2002:a17:903:2d1:b0:156:7ceb:b56f with SMTP id s17-20020a17090302d100b001567cebb56fmr26464310plk.11.1651024210763;
        Tue, 26 Apr 2022 18:50:10 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j2-20020a17090a734200b001cd4989febcsm4554547pjs.8.2022.04.26.18.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 18:50:10 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring: check reserved fields for send/sendmsg
Date:   Tue, 26 Apr 2022 19:50:06 -0600
Message-Id: <20220427015007.321603-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427015007.321603-1-axboe@kernel.dk>
References: <20220427015007.321603-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We should check unused fields for non-zero and -EINVAL if they are set,
making it consistent with other opcodes.

Fixes: 0fa03c624d8f ("io_uring: add support for sendmsg()")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1e7466079af7..072fe4e9985f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5300,6 +5300,8 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
+	if (unlikely(sqe->addr2 || sqe->file_index))
+		return -EINVAL;
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
-- 
2.35.1

