Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 940F31359E7
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2020 14:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730589AbgAINRt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jan 2020 08:17:49 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54555 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730311AbgAINRt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jan 2020 08:17:49 -0500
Received: by mail-wm1-f66.google.com with SMTP id b19so2873623wmj.4
        for <io-uring@vger.kernel.org>; Thu, 09 Jan 2020 05:17:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lz9oT0g/BUrKzzJlpJYIcSed7Ii78YOCeDkGkAv0aso=;
        b=BCJkQTkfoJDQalwVonyd9FjXYQ7mUxoipo1KrzAM/vJasYpiG+aeDLXegOIOKvIg3F
         EnbE0xagoTGDcRmVXRmvxBY9gc1CRzIbAZO8ThUjo1Z1QD+UsSabBwpeU8sWi9qeBDVz
         qF6HfeN8PAEJqT6h1GDPQAoxJW7jT7+VQGMlIeTJm0f7qkMU5qdi14x5CXuaC4sXQZDg
         RbmBNHTDvSH0noFDEM69SLjS9IprFoBhMgMjBZWLc9Sle3x3N4OzcQSYMtFkw4kaco04
         5/zOP4KFfEvZgvjCqEwcRbMth/jKPRyorwiFf3P98eo9gERymtNhssQGif4SOAzFpSim
         4D+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lz9oT0g/BUrKzzJlpJYIcSed7Ii78YOCeDkGkAv0aso=;
        b=e8FFPucuWJ7h6IAvKGHWD1P+AGAv/Xsxf9s687UeJSCsn2nkPnw4DfsvA0Era/0P1C
         1XNY8Wh1xzvz82oU7hXh36EDhiTEwHC8QzN4NVHwcwHCehJ+yMaCSUsY8tht8T6+EQSP
         mD6bRLFIu8bvwaDxPobRdf0KstXVL2gUVE7hGNl5ggKOe2V3zkWAu+FlX5qW1Ju0umoS
         nXwDERCrTXjHX5ZY8B2IssI1rvOwAJ7hlQ7HHChDRk73mdKavrbcTgsZP9Ajk/0/ql3v
         UR4NbfhUTuQ98whze+85wVc7sCpQgOckgz8kS97+k+96VhDTlapBgaiWuxCLb6VTGcyr
         xrvg==
X-Gm-Message-State: APjAAAXZSBjZmPC+at+zbe6vVVDJZY22405hzINsoxRrcaYEsFNAiFjF
        x3c1oKJ1vBtDDgWMj31tFQQ=
X-Google-Smtp-Source: APXvYqw7qu6O9sV+fN5U52UTpp5J2uYz/0QsPrx0Ma3pdSIbc9tUj0EKrL92NFVhRKiDXc52XjhQ2g==
X-Received: by 2002:a1c:6755:: with SMTP id b82mr4818746wmc.126.1578575867597;
        Thu, 09 Jan 2020 05:17:47 -0800 (PST)
Received: from localhost.corp.ad.zalando.net ([185.85.220.193])
        by smtp.gmail.com with ESMTPSA id e8sm8075081wrt.7.2020.01.09.05.17.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Jan 2020 05:17:47 -0800 (PST)
From:   Dmitrii Dolgov <9erthalion6@gmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org
Cc:     Dmitrii Dolgov <9erthalion6@gmail.com>
Subject: [RFC] Check if file_data is initialized
Date:   Thu,  9 Jan 2020 14:17:50 +0100
Message-Id: <20200109131750.30468-1-9erthalion6@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With combination of --fixedbufs and an old version of fio I've managed
to get a strange situation, when doing io_iopoll_complete NULL pointer
dereference on file_data was caused in io_free_req_many. Interesting
enough, the very same configuration doesn't fail on a newest version of
fio (the old one is fc220349e4514, the new one is 2198a6b5a9f4), but I
guess it still makes sense to have this check if it's possible to craft
such request to io_uring.

More details about configuration:

[global]
filename=/dev/vda
rw=randread
bs=256k
direct=1
time_based=1
randrepeat=1
gtod_reduce=1

[fiotest]

fio test.fio \
    --readonly \
    --ioengine=io_uring \
    --iodepth 1024 \
    --fixedbufs \
    --hipri \
    --numjobs=1 \
    --runtime=10

Signed-off-by: Dmitrii Dolgov <9erthalion6@gmail.com>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

I'm not entirely sure if my analysis is correct, but since this change
fixes the issue for me, I've decided to post it.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c770c2c0eb52..c5e69dfc0221 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1232,7 +1232,8 @@ static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
 do_free:
 	kmem_cache_free_bulk(req_cachep, rb->to_free, rb->reqs);
 	percpu_ref_put_many(&ctx->refs, rb->to_free);
-	percpu_ref_put_many(&ctx->file_data->refs, rb->to_free);
+	if (ctx->file_data)
+		percpu_ref_put_many(&ctx->file_data->refs, rb->to_free);
 	rb->to_free = rb->need_iter = 0;
 }
 
-- 
2.21.0

