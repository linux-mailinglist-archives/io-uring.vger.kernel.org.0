Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B851B34CE1B
	for <lists+io-uring@lfdr.de>; Mon, 29 Mar 2021 12:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbhC2KoR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Mar 2021 06:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbhC2Knp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Mar 2021 06:43:45 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988FDC061574
        for <io-uring@vger.kernel.org>; Mon, 29 Mar 2021 03:43:44 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id d8-20020a1c1d080000b029010f15546281so8275028wmd.4
        for <io-uring@vger.kernel.org>; Mon, 29 Mar 2021 03:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3Pl9BcFLNXFbmmCNqGWv2Vn4rYnc2KZZO0ikC+cK8oU=;
        b=gcnHC0NnwC58nSV0Lw/bYvuVyO0htYcg+9xK1E0gf+CHcbpb74N/n+ucOroHe5sxv/
         RiQB7hv2rvOAIFtwUxCoi0nTuN+T5WSAsxxie/PdZlwHONlsIcmIEOsoHTlPnFrsbaFe
         FNQ2u5EVHJ3j8AjJSgfF/jSKZ47earyy/Qs+V+BWKfGeuZFT+T7vDqjnfH87SDtqkoQ8
         dTrs3v4u6pKHd1fakyvR1H+e2qyZZrtLHh5e5cSNLpxTct2i0aUrEbxGDC1J7pOrx2sG
         BvcSyHFgYDLLs3oW77STTbyIImT7LocNrSCLDvUJi2uzieU8NvrooTBGOQNPlERI+Mbo
         G0Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3Pl9BcFLNXFbmmCNqGWv2Vn4rYnc2KZZO0ikC+cK8oU=;
        b=QECXqPOo4ypuUvTVnNhxFnNWCtmPatzaDh2dPYhl76BlXDQBJZqXvxQYMDf89IOLVM
         +vD0kkn8OY0y3ENZb4/bppX1IN74V9aHZheVAVeUf3rvo8eVcv9her7xoKhD4iILN2vz
         EYv3d0Vb8GyPY+PcjIrF+3Xn8M1A0l6LwYspTHxRdzwzgAYtiCY3xB2rWHV+7hNcEo19
         4VjJZPrejNFKComXS/6Fw2wDM+yRT65Q+qpBNfkOT2KUpYGxGSJfn5n5l5zX5s9V/KgH
         vgb9rAP1Y0XqT5oTF1PLJl3R+bg1K/H38zau7y7Lm67gx+/OPpJ9XsB4fkqylcKU28q7
         MFYw==
X-Gm-Message-State: AOAM533FPhMRX4lIyTpMIVtc1/VYzc87W4oiyaQGkWdNfkC79fginF38
        fm7jXD2McESv1H9P9xfOE58ZuPR7RjSYEQ==
X-Google-Smtp-Source: ABdhPJx8RKaf2vofxlLapUjpKNvzf36b5RmE5tEIEmO/svG0IJ92rf+2o4UvbzEaBzqHZ9bJTRdY8w==
X-Received: by 2002:a1c:7ec4:: with SMTP id z187mr24294341wmc.3.1617014623397;
        Mon, 29 Mar 2021 03:43:43 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id x11sm24092938wmi.3.2021.03.29.03.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 03:43:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     syzbot+0e905eb8228070c457a0@syzkaller.appspotmail.com
Subject: [PATCH 5.12] io_uring: handle setup-failed ctx in kill_timeouts
Date:   Mon, 29 Mar 2021 11:39:29 +0100
Message-Id: <660261a48f0e7abf260c8e43c87edab3c16736fa.1617014345.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

general protection fault, probably for non-canonical address
	0xdffffc0000000018: 0000 [#1] KASAN: null-ptr-deref
	in range [0x00000000000000c0-0x00000000000000c7]
RIP: 0010:io_commit_cqring+0x37f/0xc10 fs/io_uring.c:1318
Call Trace:
 io_kill_timeouts+0x2b5/0x320 fs/io_uring.c:8606
 io_ring_ctx_wait_and_kill+0x1da/0x400 fs/io_uring.c:8629
 io_uring_create fs/io_uring.c:9572 [inline]
 io_uring_setup+0x10da/0x2ae0 fs/io_uring.c:9599
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

It can get into wait_and_kill() before setting up ctx->rings, and hence
io_commit_cqring() fails. Mimic poll cancel and do it only when we
completed events, there can't be any requests if it failed before
initialising rings.

Fixes: 80c4cbdb5ee60 ("io_uring: do post-completion chore on t-out cancel")
Reported-by: syzbot+0e905eb8228070c457a0@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a4a944da95a0..088a9d3c420a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8603,9 +8603,9 @@ static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
 			canceled++;
 		}
 	}
-	io_commit_cqring(ctx);
+	if (canceled != 0)
+		io_commit_cqring(ctx);
 	spin_unlock_irq(&ctx->completion_lock);
-
 	if (canceled != 0)
 		io_cqring_ev_posted(ctx);
 	return canceled != 0;
-- 
2.24.0

