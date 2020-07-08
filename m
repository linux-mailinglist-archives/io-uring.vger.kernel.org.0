Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6B7219246
	for <lists+io-uring@lfdr.de>; Wed,  8 Jul 2020 23:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgGHVSC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 17:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgGHVSC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 17:18:02 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC68C061A0B
        for <io-uring@vger.kernel.org>; Wed,  8 Jul 2020 14:18:02 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id gc9so116169pjb.2
        for <io-uring@vger.kernel.org>; Wed, 08 Jul 2020 14:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=vv68x9SyvRhGqitYXr8FYZE9kVtAZHNXCyl5tRHN7qI=;
        b=FaEi03fjp9juvK+9ymnJbo0OG0XKaRx5OY1uQW73ga2dKn1DxGfru+Obvjc+ALfCSw
         dsYL40JebOfHWma0q74zDEbIy9hhhVO4bCTVld0ZXxjR2a+meaMpEGzW6BY/nXpVP6Gs
         0vUBPZ83zqRBb+25emHcUL4a+zr2CbVPc6AFPNabJb3P4ahGdiLv2fUAne2L5FksLiUs
         T0eZt542c10hCqPAAm6M8RLKmyVDBGonvc3uYi1u4xClD3/4qfaIugJQB1oXTLHsUh+A
         iZTQQhGrzMw/kDgdn2LGmKBYwzb197j+6zxYv6n/Uf9YAxfQE6bFUSI3M84plnvVsaTx
         SYwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=vv68x9SyvRhGqitYXr8FYZE9kVtAZHNXCyl5tRHN7qI=;
        b=i9uvaRqKVOwQ71/E3TDBgarihZbpTyC94dIFaL5ZpY8cd57vlRSWypxPq2YKxAezD+
         HotRqBsX/t0xp6n9IXcTJHUMRsv7Sh4LANDj8LMGOiVptpTPPaO2EuBLyl6mbtKNvbBi
         6dl/HuIqMjImP4Uuw2bjJ20rwMPH/cxC+U2xNqDxTZwqGt/GHjX76nqJZ03C8o5xE1D/
         eXGjwrUyE9/MXlb8CZRwY4B0AtC9aIdHxJAE1XcKxx1FLpmHF6vXnnLjSBeV3EtrYhTH
         ObTq/+IsurgKKR62kxTIzBybeICBsqCJ+9tVt/g34FLUDlpKiX9TZf5hF9PB+pmCEx0N
         mejQ==
X-Gm-Message-State: AOAM531QKB/LqjGrN5K/iTeFS0j2HD/zRPOjHHmsSeXpOJxUYU24yVt0
        7i0nLGmWAD6on1F90sAwtnrwngwFMBgcZA==
X-Google-Smtp-Source: ABdhPJys/s/u+O4YEFG+S95UCHQThy8wp1Xwm6avDLH6nVOf1l1aTgrpjy6joQw8Zr3zPDqrbKoUFw==
X-Received: by 2002:a17:90a:7487:: with SMTP id p7mr11554894pjk.233.1594243081736;
        Wed, 08 Jul 2020 14:18:01 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id a9sm637760pfr.103.2020.07.08.14.18.01
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 14:18:01 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: only call kfree() for a non-zero pointer
Message-ID: <cb22e312-0476-eb8e-bef6-3f844886f9c5@kernel.dk>
Date:   Wed, 8 Jul 2020 15:18:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's safe to call kfree() with a NULL pointer, but it's also pointless.
Most of the time we don't have any data to free, and at millions of
requests per second, the redundant function call adds noticeable
overhead (about 1.3% of the runtime).

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Kinda silly, this is 100% reproducible. Actually somewhat baffled
that kfree() isn't a inline, to avoid a function call if the pointer
is NULL.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 14168fbc7d79..51ff88330f9a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1519,7 +1519,8 @@ static void io_dismantle_req(struct io_kiocb *req)
 	if (req->flags & REQ_F_NEED_CLEANUP)
 		io_cleanup_req(req);
 
-	kfree(req->io);
+	if (req->io)
+		kfree(req->io);
 	if (req->file)
 		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
 	__io_put_req_task(req);

-- 
Jens Axboe

