Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7993614F293
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2020 20:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726001AbgAaTLM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 14:11:12 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:37872 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgAaTLL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 14:11:11 -0500
Received: by mail-io1-f67.google.com with SMTP id k24so9383733ioc.4
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2020 11:11:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=vHpG0iztT3/UzzGkFTZhD5bDOr5zgyzEnvUZxGtTdeI=;
        b=AfwGsORHCd4wglIjEVfSma7bWL+4qBEq3QNbhCW3l5V7Thtbpz75t5WegFOykfiLLu
         5jnfxByk6UztDTBJ3eglqFl8lDbncaJXThg6caS6hYVqoVAikQcfSIS3jYf/EfEs9j0N
         bMTc3tkXDigNj+uTipDu0iegZGCmzSfnkP4yqh7ZGuCji6HwDtl/YB38EUy5/M6yzKmR
         DxiFjcqZE4MPADH1mfigznINYp9XIUjI/wGxfR+g54Cs28ZhbV67Ez3cDbVbqeh11rlf
         sevg6YJRfspl/t710lqQyagwo6B/jENBJXJuZEVRuxLqjNkni9EhNDYKk2ksWCenHVSb
         J1iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=vHpG0iztT3/UzzGkFTZhD5bDOr5zgyzEnvUZxGtTdeI=;
        b=Oru1SHGQXhP+TMIKJgxWvLka9b51ON4t2St/PUKVs/3mpVWehgKw4hTDFUz3S4Z7nH
         MRKIdcbFvjox8WWQtIyfuUWRKQIEQ8rVuJbr27EoeiDNGWEUsyer+Sj04sglTSlA/f4v
         3c1tbOgWj5gb4n7bNUSFU+EZvsQ/JYZCEtGZGMol59Kkfw3/rg84yMk5M1w+YGA4XDZp
         6fuktn5YkrWBRKX41rorZaS5Z0BqzfXzeb4gEOCQ7OSuGZCVyNLcwQF8aoXXQgP9GJe6
         kZSB3/cIvkohwYQSYvLYKyy0zbiHVFX/sdRcoeb2fuAeqE4IbeXkTQhbjSx6YF3pzNHq
         Qdog==
X-Gm-Message-State: APjAAAX4A3ikEHFBgQ/PLBNrStSu1fJ9DrNYVkfezHVozqZZM3jxF3vw
        rBNw5w2jYTJzmOsJXjC764FOe0t13is=
X-Google-Smtp-Source: APXvYqxVoE4T5Z8WzIgaksJfw8AaGDsc7XbRizWgB4C4JLHjuZoMx0WbNnAod2Zwx1qde9piA1Cr4g==
X-Received: by 2002:a5e:aa18:: with SMTP id s24mr9363467ioe.221.1580497871077;
        Fri, 31 Jan 2020 11:11:11 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 16sm2689118ioe.84.2020.01.31.11.11.10
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 11:11:10 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: don't map read/write iovec potentially twice
Message-ID: <583a3578-6c26-e268-fc3e-c18bb82aef83@kernel.dk>
Date:   Fri, 31 Jan 2020 12:11:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we have a read/write that is deferred, we already setup the async IO
context for that request. and mapped it. When we later try and execute
the request and we get -EAGAIN, we don't want to attempt to re-map it.
If we do, we end up with garbage in the iovec, which typically leads
to an -EFAULT or -EINVAL completion.

Cc: stable@vger.kernel.org # 5.5
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e3d75f12cf08..05b9fb0764e1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2169,10 +2169,12 @@ static int io_setup_async_rw(struct io_kiocb *req, ssize_t io_size,
 {
 	if (!io_op_defs[req->opcode].async_ctx)
 		return 0;
-	if (!req->io && io_alloc_async_ctx(req))
-		return -ENOMEM;
+	if (!req->io) {
+		if (io_alloc_async_ctx(req))
+			return -ENOMEM;
 
-	io_req_map_rw(req, io_size, iovec, fast_iov, iter);
+		io_req_map_rw(req, io_size, iovec, fast_iov, iter);
+	}
 	req->work.func = io_rw_async;
 	return 0;
 }

-- 
Jens Axboe

