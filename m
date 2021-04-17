Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436CE362E75
	for <lists+io-uring@lfdr.de>; Sat, 17 Apr 2021 10:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235981AbhDQIEC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 17 Apr 2021 04:04:02 -0400
Received: from us2-ob2-2.mailhostbox.com ([162.210.70.54]:34096 "EHLO
        us2-ob2-2.mailhostbox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236040AbhDQIEB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 17 Apr 2021 04:04:01 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Apr 2021 04:04:01 EDT
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: hello@oswalpalash.com)
        by us2.outbound.mailhostbox.com (Postfix) with ESMTPSA id D5ABB781DB2
        for <io-uring@vger.kernel.org>; Sat, 17 Apr 2021 07:57:08 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oswalpalash.com;
        s=20160715; t=1618646229;
        bh=nOWtxwvsdLSGA+5YNQeiAIaP2n2MR29tVu7qdfAUunU=;
        h=From:Date:Subject:To;
        b=aucUzsuZbWFHSaesdctKU3yWe+/Qx8sW5qbhhwtxL0NIB8NK/wA8V4uTqA7Y70143
         KL5B1KqNSjKqqLIK022XDyq91TjALie/zLw313Q8vcbySZMPgPB6S+65XNmjq4Zs69
         xExTT77udzdTPlgT5CgTJ3rka8VEeLHHK5QGqRUM=
Received: by mail-lj1-f173.google.com with SMTP id z8so33504654ljm.12
        for <io-uring@vger.kernel.org>; Sat, 17 Apr 2021 00:57:08 -0700 (PDT)
X-Gm-Message-State: AOAM532UmaX1D1enm+E7b2k4jCbkf+2gy60FWzSbgmKEQPz7LDb9+YEo
        noNToEz4jOxM9vzlUZ67L+Wtnm8dDmDXK52uRzo=
X-Google-Smtp-Source: ABdhPJyNnOq+E2e9dbcaW7LWieGHvB+WWsHGZ/Yc/ZKnIfh/M3RexKiO3OUeXzjiFFlxGIhyLTT+46AoGbNN05mKt+o=
X-Received: by 2002:a2e:b5b5:: with SMTP id f21mr4899856ljn.340.1618646227231;
 Sat, 17 Apr 2021 00:57:07 -0700 (PDT)
MIME-Version: 1.0
From:   Palash Oswal <hello@oswalpalash.com>
Date:   Sat, 17 Apr 2021 13:26:56 +0530
X-Gmail-Original-Message-ID: <CAGyP=7cWH6PsO=gbF0owuSXV7D18LgK=jP+wiPN-Q=VM29vKTg@mail.gmail.com>
Message-ID: <CAGyP=7cWH6PsO=gbF0owuSXV7D18LgK=jP+wiPN-Q=VM29vKTg@mail.gmail.com>
Subject: [RFC] Patch for null-ptr-deref read in io_uring_create 5.11.12
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=I7wbu+og c=1 sm=1 tr=0
        a=uiWFakvDa7lx8AkR5Wbrfw==:117 a=IkcTkHD0fZMA:10 a=3YhXtTcJ-WEA:10
        a=hEAMlF8AIHaD93pZH-EA:9 a=QEXdDO2ut3YA:10
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

I have been trying to decipher a bug that my local syzkaller instance
discovered in the v5.11.12 stable tree. I have more details in [1].
Could someone please review.

[1] https://oswalpalash.com/exploring-null-ptr-deref-io-uring-submit/
Signed-off-by: Palash Oswal <hello@oswalpalash.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8b4213de9e08..00b35079b91a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8995,7 +8995,7 @@ static void io_disable_sqo_submit(struct io_ring_ctx *ctx)
 {
     mutex_lock(&ctx->uring_lock);
     ctx->sqo_dead = 1;
-    if (ctx->flags & IORING_SETUP_R_DISABLED)
+    if (ctx->flags & IORING_SETUP_R_DISABLED && ctx->sq_data)
         io_sq_offload_start(ctx);
     mutex_unlock(&ctx->uring_lock);

-- 
2.27.0
