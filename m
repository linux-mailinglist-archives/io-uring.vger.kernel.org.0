Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF932F8BAD
	for <lists+io-uring@lfdr.de>; Sat, 16 Jan 2021 06:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbhAPFg4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Jan 2021 00:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbhAPFgz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Jan 2021 00:36:55 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E9DC061793
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 21:36:15 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id 190so9133037wmz.0
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 21:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PtmGvjBRuLSDV/keD0ig6gdwY7AVPXAYGS8URrSnMl0=;
        b=vE+IlgrFM8G6rpKY36lWxRTOoZ93MZ/iENvWYXhDdZ+3LePNRJikFm1P8xhyFcXg0C
         0gIDxoB9RKv2+49TrdkJ+7nTj+PVDjuchlpcG9Ld2DMO2wTj5yfaJnBMi1DJr68JeSNp
         +fbC4o301M3lEmEB+LM59rqVePNfDZuolE8EHBRXL6a0M8O6C/Zubtq8jxLbbkFp2UO9
         7qs8rAVRaR93CfknAQ+GU9MSRhV9p+k88SBCHi46gWROkUcYBl+EIJRCGYvQ7kM71U77
         4yvfg6KMHnGE3v85wLzwcoJ/y2vPT40ITDEuSN/PvYrCyWTR8dBETRNKrQ5e7biyoUMl
         lF6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PtmGvjBRuLSDV/keD0ig6gdwY7AVPXAYGS8URrSnMl0=;
        b=m6c4xMQoh0i5+FjKJbeWvwnQf+6F/Y+M/H5QICbn6djcm3IUXAe7t8dUDJg0m7s4S1
         gw4uSwOzla+dLs2bnJkyjXIviFlBqm4vkfEgAN2ncarsKdKdV7BLgXe26QmudJo0sQYH
         GkrKcPa5k7eUqCDn4Pz9PvHT97hpdX/SX9Si0LakONov3NrcBHGExBHQeNu5SZSDTkRa
         AQlpgApmNUlqkpxB2tclhbnmeZ+A+7C9yxGav0Xyqmjh2/waL3CFqcjPG7Xrn9GghPjA
         89IMImomroqlbtnbLid1NMeiFw1ci/SBUIefIutFMMcd+Fd6aOBFhOX6eTXNkSfattFD
         mZFA==
X-Gm-Message-State: AOAM531qeJ1iv7qTMnT5hZk8lQhQLfrqs2k/V7O4Q6OfSyQY6w6Xk1kV
        BU1ORiAkAPLB9aoJHm5mDs8=
X-Google-Smtp-Source: ABdhPJyR9oRURtMbpD7uZF7SBMXMAYY3U8Bf+K7qnD/qcIh/3epjouwngRg5UZKJTmypP/5GX9PTag==
X-Received: by 2002:a1c:ddc6:: with SMTP id u189mr11842630wmg.172.1610775373948;
        Fri, 15 Jan 2021 21:36:13 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.150])
        by smtp.gmail.com with ESMTPSA id b132sm15348373wmh.21.2021.01.15.21.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 21:36:13 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Hillf Danton <hdanton@sina.com>,
        syzbot+a32b546d58dde07875a1@syzkaller.appspotmail.com
Subject: [PATCH 2/2] io_uring: fix uring_flush in exit_files() warning
Date:   Sat, 16 Jan 2021 05:32:30 +0000
Message-Id: <83afc4cf00d7a2f0c4ee61e73b7f7b67d57182db.1610774936.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1610774936.git.asml.silence@gmail.com>
References: <cover.1610774936.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

WARNING: CPU: 1 PID: 11100 at fs/io_uring.c:9096
	io_uring_flush+0x326/0x3a0 fs/io_uring.c:9096
RIP: 0010:io_uring_flush+0x326/0x3a0 fs/io_uring.c:9096
Call Trace:
 filp_close+0xb4/0x170 fs/open.c:1280
 close_files fs/file.c:401 [inline]
 put_files_struct fs/file.c:416 [inline]
 put_files_struct+0x1cc/0x350 fs/file.c:413
 exit_files+0x7e/0xa0 fs/file.c:433
 do_exit+0xc22/0x2ae0 kernel/exit.c:820
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x3e9/0x20a0 kernel/signal.c:2770
 arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:302
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

An SQPOLL ring creator task may have gotten rid of its file note during
exit and called io_disable_sqo_submit(), but the io_uring is still left
referenced through fdtable, which will be put during close_files() and
cause a false positive warning.

First split the warning into two for more clarity when is hit, and the
add sqo_dead check to handle the described case.

Reported-by: syzbot+a32b546d58dde07875a1@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9a67da50ae25..b32bdd159e85 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9126,7 +9126,10 @@ static int io_uring_flush(struct file *file, void *data)
 
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		/* there is only one file note, which is owned by sqo_task */
-		WARN_ON_ONCE((ctx->sqo_task == current) ==
+		WARN_ON_ONCE(ctx->sqo_task != current &&
+			     xa_load(&tctx->xa, (unsigned long)file));
+		/* sqo_dead check is for when this happens after cancellation */
+		WARN_ON_ONCE(ctx->sqo_task == current && !ctx->sqo_dead &&
 			     !xa_load(&tctx->xa, (unsigned long)file));
 
 		io_disable_sqo_submit(ctx);
-- 
2.24.0

