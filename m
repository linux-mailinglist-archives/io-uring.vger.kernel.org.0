Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE45F3807FE
	for <lists+io-uring@lfdr.de>; Fri, 14 May 2021 13:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbhENLEb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 May 2021 07:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbhENLEb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 May 2021 07:04:31 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68440C061574
        for <io-uring@vger.kernel.org>; Fri, 14 May 2021 04:03:20 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id r12so4053362wrp.1
        for <io-uring@vger.kernel.org>; Fri, 14 May 2021 04:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SKMxMIOWFv8tyb3DQCYQ6WmL3t8Xk43yThLEYCbPbXM=;
        b=HR0g6jh9OIjam1Co5FrCNMWdStQv7OF4DtFZXGFLseTRa8zz1f1DXd16o+f3ToQExA
         5qI4sCwf7eE4IF5mwraVKGbv53oBdROlW672Emo1J4MHdHjjnSJ6QPhqUhLv/o/8N3nI
         Jb6zq9xhQFzZFAhSr/gF6+hWFbzo9r5Weow5WSuRcmWVeUpom+nZLVvryXxKEpbomg3v
         u9/QFhhgF3qg8JUsUbhzonGFFMgVjbYtdBYat5cr52Nj9ImbPRhKIi93nTsuYukjdgDe
         RDI1WahJL8DZh1KvR6NDRgBTcEU2G7LlpFbNY71R8wVLVLWJ3uXERzucZ1bdFyjW7VoX
         zBNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SKMxMIOWFv8tyb3DQCYQ6WmL3t8Xk43yThLEYCbPbXM=;
        b=QkeDDg41o3/+1AvAQaRi+t7Y0FoAGewCON6xsR00THFDHbX+tP/JlpziBk4Zw2m129
         cf3ApJKsDAZ57c0AFQ0WiS4RR9IYbTNG3uwa0/ayKlatRUmverTWPcEWLQJRW7JfvWJb
         NS0f+Of9oDY6m6yOS5qE+o0WpUDARsLyBZ+TR6Ac8uMfq35sTNW2knLiLzcueprAIQTF
         RArmiqgRJzZSN525aDvq2+MDUuq23Z9GslqnpD4KbDai4CZNTDEKAJQoly1rWKsLqxae
         UTcWNW8uKqNNq1VX31bP2wARFRc6V41UCIEqvJPCcD+W+aFfaR42CyyWqEt0VBKY3VGY
         bFlA==
X-Gm-Message-State: AOAM531BDlSDe6HVcKVBILWitzs+rVKt7fnCLhIk1s6SzFik05Tym+X7
        fls60ubdtWPCxWHpD6KuQ2l+JPeSGfk=
X-Google-Smtp-Source: ABdhPJwHKncToUNQt0UHAFrzV2cmBzjGfLhlmHwn+8oKJpO4/KPcR9mDMj3sBh/8ZJ7idsBclhWP6A==
X-Received: by 2002:adf:f7c4:: with SMTP id a4mr57127026wrq.20.1620990199128;
        Fri, 14 May 2021 04:03:19 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.196])
        by smtp.gmail.com with ESMTPSA id s5sm4965744wrw.95.2021.05.14.04.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 04:03:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: fix ltout double free on completion race
Date:   Fri, 14 May 2021 12:02:50 +0100
Message-Id: <69c46bf6ce37fec4fdcd98f0882e18eb07ce693a.1620990121.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Always remove linked timeout on io_link_timeout_fn() from the master
request link list, otherwise we may get use-after-free when first
io_link_timeout_fn() puts linked timeout in the fail path, and then
will be found and put on master's free.

Cc: stable@vger.kernel.org # 5.10+
Fixes: 90cd7e424969d ("io_uring: track link timeout's master explicitly")
Reported-and-tested-by: syzbot+5a864149dd970b546223@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9ac5e278a91e..599102cc6dfc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6354,10 +6354,11 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	 * We don't expect the list to be empty, that will only happen if we
 	 * race with the completion of the linked work.
 	 */
-	if (prev && req_ref_inc_not_zero(prev))
+	if (prev) {
 		io_remove_next_linked(prev);
-	else
-		prev = NULL;
+		if (!req_ref_inc_not_zero(prev))
+			prev = NULL;
+	}
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	if (prev) {
-- 
2.31.1

