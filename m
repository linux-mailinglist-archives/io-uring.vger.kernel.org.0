Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5974FE987
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 22:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbiDLUkd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 16:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbiDLUkA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 16:40:00 -0400
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C576C765A6
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 13:35:42 -0700 (PDT)
Received: by mail-pf1-f182.google.com with SMTP id b15so61731pfm.5
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 13:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=0Y/977pws4vP8z3KZlbishz7dcAJFpjJRsJxtUL6ugM=;
        b=IcZO5QoACx9MBtRhQbp29xTKmSF8p3Ls4MeseYC3gojb/+0jvQBO/O4HRUjLolPEbO
         9mIGC+pV2dcIwexdWxe2Ti+JzHGbErXYUG2HCM7AUde6cfx6tDUQxsHUI7pzbDulH3HN
         1vN44qdJEDQwa3DUGzf95WqxCD9LDFDnZAwZ8CCWYpdhsf4apCJJjnefFUoDHzj1l/wo
         VhjF4b0J8HSIueaPJo+/ZQxkT+NuFgT51yDfch9gLcpmR5BrsRgWDu4x2ng+ubTbispI
         OATvpc9rqxB0vBqe2tuNzNJIKPe7PkmHx0j+l5wDgJVK3a8duLK4F2vNoxrsif+esebV
         Zu0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=0Y/977pws4vP8z3KZlbishz7dcAJFpjJRsJxtUL6ugM=;
        b=gtQ+0gNyefOWJ0uld4Yt7aDuiSFlsYCXTrtzWNbGWLqqeBdux5q/FuRCACF2Ek42tE
         2vN9pXuDyO+xUHnJ9cMzDi8UxvjYheA2z11vnKIUORyXsQiMIItM09OS5tOvWXgL934M
         9KbflW9MQ6AYSqSXQcQR5nMOhZZh3VOy14vTG3tQtNDWIgfXNDk1SdUN/w8vY5J1mqqK
         fFyv/phY+od6edrYqBpJQAgeKeD5hOQBCWSt00q4cY8tgO8SES5XfPkNFB1caASTyemD
         HuYusweKPjIlQpMBTIAEqB3XmU7Zuqbm5MFMIkfdWsASmpXkO9Bdb6e6EKiM+cbO1rRP
         mbbQ==
X-Gm-Message-State: AOAM533HEtk3l1meKJYXm26UHW6OFcnovSSQDJkmpczJ5cssFO3e8xEI
        6AXdWz9Z2Ynj0neinZsHtgCQZbVMJVYiQWqm
X-Google-Smtp-Source: ABdhPJwfYhFw42ejVKV5CcdM7Iw1ftir1wPDFxZJ2HMN/vHJDV4nshnO3OMp8MxUNSwKmxqglqaWcQ==
X-Received: by 2002:a63:1b20:0:b0:382:70f9:dc24 with SMTP id b32-20020a631b20000000b0038270f9dc24mr31168139pgb.485.1649795226900;
        Tue, 12 Apr 2022 13:27:06 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u25-20020aa78399000000b00505f75651e7sm3637468pfm.158.2022.04.12.13.27.06
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 13:27:06 -0700 (PDT)
Message-ID: <ee10eb48-ee50-7efb-54a7-7cb55bb23c15@kernel.dk>
Date:   Tue, 12 Apr 2022 14:27:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: allow direct descriptors for connect
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Looks like an oversight that this is currently disabled, but I guess it
didn't matter before we had direct descriptor support for socket.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 17b4dc9f130f..b83134906a3a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5982,8 +5982,7 @@ static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->len || sqe->buf_index || sqe->rw_flags ||
-	    sqe->splice_fd_in)
+	if (sqe->ioprio || sqe->len || sqe->buf_index || sqe->rw_flags)
 		return -EINVAL;
 
 	conn->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));

-- 
Jens Axboe

