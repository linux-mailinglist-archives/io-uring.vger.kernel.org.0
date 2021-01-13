Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDB92F4B9C
	for <lists+io-uring@lfdr.de>; Wed, 13 Jan 2021 13:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbhAMMqu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jan 2021 07:46:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbhAMMqu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jan 2021 07:46:50 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874C8C06179F
        for <io-uring@vger.kernel.org>; Wed, 13 Jan 2021 04:46:09 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id c5so1980675wrp.6
        for <io-uring@vger.kernel.org>; Wed, 13 Jan 2021 04:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a8KL+55LMuFKJMvNeokMPE+vW3rjoI1VdjPIOLrJf3g=;
        b=MfJ7w8AUrNhjhOBXa97IinbuBBiuM7Rq0FAlMIjiR6V2j2Es+Dn8RkPa/FWv4zK2Gp
         3wxq//LUiPkhshVAE15pOTaDiXQqzJz/VlgA5TMvz2gtQqmOlUyZv5fEhRXCTK69CjQj
         vXfvD8j3nWd6AIrV4rSyjtlQ0obnz0mYUK9uyFvw7ASxmyJUdTrKeOuxOKFCM1VC1Bdl
         QLj0sXx1qjsv0pAhD3k3JRZXctnTbjFRPcyXKImD0RCLk0l71zavqo2y0wgiFD9/8Yji
         RFEMAZ3RaKKPdnYhBSliiNzBf+fsRP/L4jt+nnPujc6rGxJ0dXzv7JSgyYs99kaifDIW
         fXUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a8KL+55LMuFKJMvNeokMPE+vW3rjoI1VdjPIOLrJf3g=;
        b=ofXN/DwTvdHuc9RVX8w07SQp89d3I/GCfEm86wSRcuoRe23O9jLJRGEVkeMb7dT+zv
         LQ8nwcWic/1PWaH/Asa2hm+Tu+YoAGaV5OYGFVwLQYtOBY1Z1mtCgszHj2WfiUBH1Eq7
         3jsvajKrOsWU75erxr94gQJ5dij0I5RwweiOXC4BgBqe/icZey/M3kZn9Cy/BTLO0MYZ
         5peSCI5DvZsB4LwszGnFedJz6yhYnUuLpfEe9FgUGOEdEtj8L7jMN8IIkcL0vr0UoKIQ
         /gbiJgXDee4fb2uSh3o9wfIYWMPZTJq0F5am6gR6dqKFuwY7w2RtzhWva5y/C+3CsWp1
         xFig==
X-Gm-Message-State: AOAM533hroZfSBc5eolqqoq7F+OaxhPKXxHiLI4E9BOVkc4Y4TpBcatr
        Tn47pduaeWw3ZujtHXSIBOxUBGb5gANnIQ==
X-Google-Smtp-Source: ABdhPJxrKQvDsh88o/ayQmX5gLTRfnU2gG96E3Nx69cjQoBiFIaO2eyz8oI2zv7Ys/w7VLK6puVZ7A==
X-Received: by 2002:a5d:6206:: with SMTP id y6mr2487272wru.413.1610541968319;
        Wed, 13 Jan 2021 04:46:08 -0800 (PST)
Received: from localhost.localdomain ([85.255.235.134])
        by smtp.gmail.com with ESMTPSA id j7sm2835764wmb.40.2021.01.13.04.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 04:46:07 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     syzbot+ab412638aeb652ded540@syzkaller.appspotmail.com
Subject: [PATCH 1/2] io_uring: fix null-deref in io_disable_sqo_submit
Date:   Wed, 13 Jan 2021 12:42:24 +0000
Message-Id: <4c53f4cd1201c7732af5ef6ca5f5918f22a649f9.1610540878.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1610540878.git.asml.silence@gmail.com>
References: <cover.1610540878.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

general protection fault, probably for non-canonical address
	0xdffffc0000000022: 0000 [#1] KASAN: null-ptr-deref
	in range [0x0000000000000110-0x0000000000000117]
RIP: 0010:io_ring_set_wakeup_flag fs/io_uring.c:6929 [inline]
RIP: 0010:io_disable_sqo_submit+0xdb/0x130 fs/io_uring.c:8891
Call Trace:
 io_uring_create fs/io_uring.c:9711 [inline]
 io_uring_setup+0x12b1/0x38e0 fs/io_uring.c:9739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

io_disable_sqo_submit() might be called before user rings were
allocated, don't do io_ring_set_wakeup_flag() in those cases.

Reported-by: syzbot+ab412638aeb652ded540@syzkaller.appspotmail.com
Fixes: d9d05217cb69 ("io_uring: stop SQPOLL submit on creator's death")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2f305c097bd5..bf043c600e55 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8888,7 +8888,8 @@ static void io_disable_sqo_submit(struct io_ring_ctx *ctx)
 	mutex_unlock(&ctx->uring_lock);
 
 	/* make sure callers enter the ring to get error */
-	io_ring_set_wakeup_flag(ctx);
+	if (ctx->rings)
+		io_ring_set_wakeup_flag(ctx);
 }
 
 /*
-- 
2.24.0

