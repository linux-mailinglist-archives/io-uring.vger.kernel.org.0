Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07954342944
	for <lists+io-uring@lfdr.de>; Sat, 20 Mar 2021 01:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhCTABi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 20:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbhCTABS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 20:01:18 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12765C061760
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 17:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=I8/e2LSz/iZT2C/Twx5FSD5vKUDjCWsGcRorMTUpzvU=; b=EQdLGA3rg8IgMHYmh/F/GDzwYe
        WT1NpX1U0obJV6PeBknBIiWMeSEowYAxVFPPun3AZfUwfUlqUcrVUDAJyRGmIRfQyUnyFp3JmBGzN
        aVgp/fSbhwuMwcNIYqdx4byabmMdkmAKxCmbCaCyfeuJmKFqs2cSgWvHUnlrKSFA9cy22NFAdjZSm
        heihUp1QI19qz9fxqQJzlZsGhf5akW8+WTBBYcEossmmkrwjZxp+68Bprt7JDi34MT27briJAXgNz
        BDvrgd4PJlqxOFwQFRkq6QDWdRZLvIS5JHMsfGREShnNqW2gzE4NMxqODD6gGvr5GLZouVewmq6Pb
        T353z++0PlElPTJpd4vB/9i1P7AgkeIa0OhvChne/aATRXQF9c5q1em7aZIc33cHuyOp7EggDc9Mw
        QCKkRCJ2yjgvNe6LKElC2VsziuPiEuoYv9dA+6wvAorASr08WOww8ZPkezt48sqFYmF/djrstQJqs
        aHjNbyakw7rEvki/2BuiG0sa;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lNP3M-0007XC-5W; Sat, 20 Mar 2021 00:01:16 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v2 5/5] fs/proc: hide PF_IO_WORKER in get_task_cmdline()
Date:   Sat, 20 Mar 2021 01:00:31 +0100
Message-Id: <d4487f959c778d0b1d4c5738b75bcff17d21df5b.1616197787.git.metze@samba.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1616197787.git.metze@samba.org>
References: <cover.1615826736.git.metze@samba.org> <cover.1616197787.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We should not return the userspace cmdline for io_worker threads.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/proc/base.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 3851bfcdba56..6e04278de582 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -344,6 +344,9 @@ static ssize_t get_task_cmdline(struct task_struct *tsk, char __user *buf,
 	struct mm_struct *mm;
 	ssize_t ret;
 
+	if (tsk->flags & PF_IO_WORKER)
+		return 0;
+
 	mm = get_task_mm(tsk);
 	if (!mm)
 		return 0;
-- 
2.25.1

