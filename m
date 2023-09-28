Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D485D7B213D
	for <lists+io-uring@lfdr.de>; Thu, 28 Sep 2023 17:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbjI1P2Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Sep 2023 11:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbjI1P2P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Sep 2023 11:28:15 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE68919E
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 08:28:12 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-9b27f99a356so220389166b.0
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 08:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695914891; x=1696519691; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I+z9rKq17x/D6tZ5zWYzJU0a+c8lE3LrnU6JJS6XdMQ=;
        b=k6+K0IrnDZUPMn43UmU/gT7vipN8ZJesCXZATRFm6cMREXg99z8zpfpPffNxRK88V0
         UKiD63Kx8JoMHiweMWefrxReCm+mexC4o7rxMj95uH4h8AmEnmxiXMQVzSuf8kUfpIls
         3FWK1C/rT6Nj57U9+VFxg8q4ARmU/KibvqCNU+7n9r+0LjJ0DVr1K+bFEb5tZArZe51A
         A7gVyKPn4AvRJdAT+Eb19BYksi9Yc5Bw3FyCT//FZa/pAa4r3MTa8pWSWSqrkjwYbsuw
         SPHiYWiihFMjQUOoWaun1xf73yLIMgpZkLCSW2hpwPXnBVNZ5M8VyNJbOp38pUdUMZSB
         qXcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695914891; x=1696519691;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=I+z9rKq17x/D6tZ5zWYzJU0a+c8lE3LrnU6JJS6XdMQ=;
        b=fqOiXA4NXYT8l8L6lg6/dKQJXsdcGopVLK0MuDfeLmIJSb9vPrMiAe2Sn8xfdMUJn5
         NuJmgseAbG0JzavD28hAHtKvpgjUyPvm1C9zhCKslu+ejyi1DsPwOBUYDomdJEfwbeJ4
         4JSEtiDhcTQFEqHc4fr62FxVB4Yzsx93FHZQxl6WV7Akl6RlBgPJDl308o8SWtuXbB5a
         GFoYQpFgT9B0WKQwV7RcTCJYZfOo3KeeNDfxPBhrIWPseJgztfMyKbqe093rP6hTO00N
         LFaJN47sAB4/cZ/vIJ6Wvc++Riwy8buDn4YOxw7U286LsyBHliu4QEokAzIleH38ruuT
         TXiw==
X-Gm-Message-State: AOJu0Yzk+zQePgMf4iQkN2VcXiQuOYgXkzDvd5URqU3VaFNlbIxNZIEY
        WKfWLNUGEZDpnZZbH8I7jzPQothXCJ9BQm4S4K/WMF+j
X-Google-Smtp-Source: AGHT+IE0zuNCQHoaGJO7aAYsqq8UueMoIq/3qS1r0mQCnU4Hpj1l/Osa3248iQPhRLan4ieYQvZ/KQ==
X-Received: by 2002:a17:906:105d:b0:9ae:5868:c8c9 with SMTP id j29-20020a170906105d00b009ae5868c8c9mr1418770ejj.0.1695914890670;
        Thu, 28 Sep 2023 08:28:10 -0700 (PDT)
Received: from [172.20.13.88] ([45.147.210.162])
        by smtp.gmail.com with ESMTPSA id o26-20020a1709061b1a00b0099bcb44493fsm11157535ejg.147.2023.09.28.08.28.09
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Sep 2023 08:28:09 -0700 (PDT)
Message-ID: <47be2cca-66f9-40bf-b0c9-364e8927d4fb@kernel.dk>
Date:   Thu, 28 Sep 2023 09:28:09 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/fs: remove sqe->rw_flags checking from LINKAT
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

This is unionized with the actual link flags, so they can of course be
set and they will be evaluated further down. If not we fail any LINKAT
that has to set option flags.

Fixes: cf30da90bc3a ("io_uring: add support for IORING_OP_LINKAT")
Cc: stable@vger.kernel.org
Link: https://github.com/axboe/liburing/issues/955
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/fs.c b/io_uring/fs.c
index f6a69a549fd4..08e3b175469c 100644
--- a/io_uring/fs.c
+++ b/io_uring/fs.c
@@ -243,7 +243,7 @@ int io_linkat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct io_link *lnk = io_kiocb_to_cmd(req, struct io_link);
 	const char __user *oldf, *newf;
 
-	if (sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
+	if (sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;

-- 
Jens Axboe

