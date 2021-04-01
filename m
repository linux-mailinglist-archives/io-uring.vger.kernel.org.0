Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79824351DD1
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 20:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236267AbhDAScJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 14:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237310AbhDASTF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 14:19:05 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD282C0F26CE
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 07:57:07 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id z136so2461842iof.10
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 07:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=jNUuaffmsWZaUN4Zf++FhSyjEf3MQJHCcJlTX2x5sU4=;
        b=FHI43NnOcDK95RJ+WDXxfCkksb857jpsEU+Q2kFYa+M8Ga/3LsNeZhp/bWF8Ve1hjS
         TFV/8Fz9B1GRb9DTbxj+eFugbWKUgqvBRQe5n7wQBaQAKe1TukE0boifeDh5BtzMXvW+
         o894AcVaS2I1/yB3OSt/XYiARTkD8KXNj4r20eBxNEhZZa66M0CTkv9+aZsp3d2YKh+h
         xmHOvxatR1wJHiWYv/0G5zo1tCCGYipCIBHRV6eZ5DV7tTGbjI5l+o1ILkMUtcdiOpBY
         sGuVQhCOQmlRd3ZjgmlKwEEQoV/TLUYo1xKUbyxNQChddSVDvL18SXbqnLeaZ3qNWIZh
         q8Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=jNUuaffmsWZaUN4Zf++FhSyjEf3MQJHCcJlTX2x5sU4=;
        b=LXDHAN+Nd5dy6ETH6+wi7VOF3kVgIc95syWrUmJcWTMYUqvVOoZGUuEcyjqbNLqbsU
         AR2Euj42zb7ADdNrYjBFugq61jWyP2L+/MrDDTTCONqFxcLX/oGzv7KIE7E6mklc9fw0
         PMwdkILJI++3ATjsPXAit2KpBIfzux/s/NRH4n3KUNorl8V9AdpraRysDqVxKK2uulIa
         N85neFSn36AQhN8D0nAu3eRnjXkFOktbq3VnoqDBxMSm/mL28LEoNTTgEI1JWyTX+A1F
         RBA35NKlU8GeoL1yYTiFqHKEmcP0MaXLdKUUaq9wFhOEV0Hzg6Y+gl3pgzJaxcc7nyzY
         YnUA==
X-Gm-Message-State: AOAM532VdL5bZQeRq9iV2qWrtL+wac9M4c3WMLhJVc/sn7+7KED5aJSJ
        kJ1tFn3xpuok6uL0owI3ihlDhC78Nghjqw==
X-Google-Smtp-Source: ABdhPJxWcHCwfEKkziV2fC7/A+i88XSFs8U/bsmhFj2uATT5yy9brZUcPokkfLpblgrDGJqxqrJ0xg==
X-Received: by 2002:a02:a809:: with SMTP id f9mr8286781jaj.63.1617289026821;
        Thu, 01 Apr 2021 07:57:06 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k13sm2546209ilu.29.2021.04.01.07.57.06
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 07:57:06 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: don't mark S_ISBLK async work as unbounded
Message-ID: <a96971ea-2787-149a-a4bd-422fa696a586@kernel.dk>
Date:   Thu, 1 Apr 2021 08:57:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

S_ISBLK is marked as unbounded work for async preparation, because it
doesn't match S_ISREG. That is incorrect, as any read/write to a block
device is also a bounded operation. Fix it up and ensure that S_ISBLK
isn't marked unbounded.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6d7a1b69712b..a16b7df934d1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1213,7 +1213,7 @@ static void io_prep_async_work(struct io_kiocb *req)
 	if (req->flags & REQ_F_ISREG) {
 		if (def->hash_reg_file || (ctx->flags & IORING_SETUP_IOPOLL))
 			io_wq_hash_work(&req->work, file_inode(req->file));
-	} else {
+	} else if (!req->file || !S_ISBLK(file_inode(req->file)->i_mode)) {
 		if (def->unbound_nonreg_file)
 			req->work.flags |= IO_WQ_WORK_UNBOUND;
 	}

-- 
Jens Axboe

