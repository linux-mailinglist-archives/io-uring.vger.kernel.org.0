Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA491C176D
	for <lists+io-uring@lfdr.de>; Fri,  1 May 2020 16:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729199AbgEAOKy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 May 2020 10:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728840AbgEAOKx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 May 2020 10:10:53 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01D8C061A0C;
        Fri,  1 May 2020 07:10:52 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id x17so11658504wrt.5;
        Fri, 01 May 2020 07:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Yot0ugCacCTxvS+7siBunkvNS10BlH+a/PmDpbaLlNI=;
        b=eROwJpkjkcrP/WH3hd0g5Zc0RozBjPbtfNGtqcM0xayYeiiH7PfkH/GNylakaGPanh
         bPxoBc/nF4erMTFCa2b+42uagfzRUGto9jCUZ0aYFsVEvrz6gh+Vl623QXQbsjefwCoU
         pGMwYkTV0AjI7QEAaH80t4rbARMhYpla1yM27IMr9uetsTUvC1JHaj7jeL/AAJn6K3Sa
         cG3RHrvZaUeTiPP3OTb7XIwfYj+h8PAnmqzgtShQwQTAcstjjvb4a+rd0U51JBA7d5O5
         +1QHoO76GfIo/0dGeRFTbmz96pyL9QDic4Wa9CVYGBvWG/KeliHgGl703vguMUg/kaue
         hW4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yot0ugCacCTxvS+7siBunkvNS10BlH+a/PmDpbaLlNI=;
        b=cg02fscfEscyXUshdQcIj8lz+kZr3IBgEYJPnR08/Lhow9PLfzbYZl41LVz8HDVSrM
         IimCzuNRbLizK63/cmZMIvtTsWvVh5piITO2t9BqINEBfC+x46cer4riotXY9qhPrM8j
         rQez7+sCmcv3+Igu4/Q3nr+jihW6/paRCK+FbgUAmVt0jBR/OgXzVMEalg3qgljQZ6TT
         LlCFMEr7Zo+DrAoOkFbvO7myZCExey7RCjHPPtVjhAZKs6bbAmTx31s5Kh+HT4sxjVD4
         aop/a2meu5hFNjs11iVfMcsqA/CFYIM/bYDho2FDvZbS7ewrO/wkxNb0a4fraAwYpN7L
         nMVg==
X-Gm-Message-State: AGi0PuZJCritOAjixdKhcwcEzB8Z835iv4hB5ExQb0uUInAF92DE2GEm
        cndysf9XX/xn1glJpnwW++8=
X-Google-Smtp-Source: APiQypJql1+SX7lhm3hPGwL35x/DT46L3OCPKFF6fTdO+WzWoZU67OSoaIRuh5Jytsh/rbQvEl7aww==
X-Received: by 2002:a05:6000:146:: with SMTP id r6mr1211944wrx.9.1588342251713;
        Fri, 01 May 2020 07:10:51 -0700 (PDT)
Received: from localhost.localdomain ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id j17sm4837390wrb.46.2020.05.01.07.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 07:10:51 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] io_uring: fix extra put in sync_file_range()
Date:   Fri,  1 May 2020 17:09:36 +0300
Message-Id: <bd2ca136bb6bebe2b1bb94afc4fae464df151a84.1588341674.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1588341674.git.asml.silence@gmail.com>
References: <cover.1588341674.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[   40.179474] refcount_t: underflow; use-after-free.
[   40.179499] WARNING: CPU: 6 PID: 1848 at lib/refcount.c:28 refcount_warn_saturate+0xae/0xf0
...
[   40.179612] RIP: 0010:refcount_warn_saturate+0xae/0xf0
[   40.179617] Code: 28 44 0a 01 01 e8 d7 01 c2 ff 0f 0b 5d c3 80 3d 15 44 0a 01 00 75 91 48 c7 c7 b8 f5 75 be c6 05 05 44 0a 01 01 e8 b7 01 c2 ff <0f> 0b 5d c3 80 3d f3 43 0a 01 00 0f 85 6d ff ff ff 48 c7 c7 10 f6
[   40.179619] RSP: 0018:ffffb252423ebe18 EFLAGS: 00010286
[   40.179623] RAX: 0000000000000000 RBX: ffff98d65e929400 RCX: 0000000000000000
[   40.179625] RDX: 0000000000000001 RSI: 0000000000000086 RDI: 00000000ffffffff
[   40.179627] RBP: ffffb252423ebe18 R08: 0000000000000001 R09: 000000000000055d
[   40.179629] R10: 0000000000000c8c R11: 0000000000000001 R12: 0000000000000000
[   40.179631] R13: ffff98d68c434400 R14: ffff98d6a9cbaa20 R15: ffff98d6a609ccb8
[   40.179634] FS:  0000000000000000(0000) GS:ffff98d6af580000(0000) knlGS:0000000000000000
[   40.179636] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   40.179638] CR2: 00000000033e3194 CR3: 000000006480a003 CR4: 00000000003606e0
[   40.179641] Call Trace:
[   40.179652]  io_put_req+0x36/0x40
[   40.179657]  io_free_work+0x15/0x20
[   40.179661]  io_worker_handle_work+0x2f5/0x480
[   40.179667]  io_wqe_worker+0x2a9/0x360
[   40.179674]  ? _raw_spin_unlock_irqrestore+0x24/0x40
[   40.179681]  kthread+0x12c/0x170
[   40.179685]  ? io_worker_handle_work+0x480/0x480
[   40.179690]  ? kthread_park+0x90/0x90
[   40.179695]  ret_from_fork+0x35/0x40
[   40.179702] ---[ end trace 85027405f00110aa ]---

Opcode handler must never put submission ref, but that's what
io_sync_file_range_finish() do. use io_steal_work() there.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 75ff4cc9818b..e7d7e83e3d56 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3515,7 +3515,7 @@ static void io_sync_file_range_finish(struct io_wq_work **workptr)
 	if (io_req_cancelled(req))
 		return;
 	__io_sync_file_range(req);
-	io_put_req(req); /* put submission ref */
+	io_steal_work(req, workptr);
 }
 
 static int io_sync_file_range(struct io_kiocb *req, bool force_nonblock)
-- 
2.24.0

