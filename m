Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A977F292417
	for <lists+io-uring@lfdr.de>; Mon, 19 Oct 2020 10:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbgJSI7p (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Oct 2020 04:59:45 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:34922 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728477AbgJSI7o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Oct 2020 04:59:44 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UCU-WDb_1603097982;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UCU-WDb_1603097982)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 19 Oct 2020 16:59:42 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, joseph.qi@linux.alibaba.com,
        xiaoguang.wang@linux.alibaba.com
Subject: [PATCH v2] io_uring: use blk_queue_nowait() to check if NOWAIT supported
Date:   Mon, 19 Oct 2020 16:59:42 +0800
Message-Id: <20201019085942.31958-1-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201019084737.110965-1-jefflexu@linux.alibaba.com>
References: <20201019084737.110965-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

commit 021a24460dc2 ("block: add QUEUE_FLAG_NOWAIT") adds a new helper
function blk_queue_nowait() to check if the bdev supports handling of
REQ_NOWAIT or not. Since then bio-based dm device can also support
REQ_NOWAIT, and currently only dm-linear supports that since
commit 6abc49468eea ("dm: add support for REQ_NOWAIT and enable it for
linear target").

Fixes: 4503b7676a2e ("io_uring: catch -EIO from buffered issue request failure")
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2e1dc354cd08..7d8615df3c01 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2601,7 +2601,7 @@ static struct file *__io_file_get(struct io_submit_state *state, int fd)
 static bool io_bdev_nowait(struct block_device *bdev)
 {
 #ifdef CONFIG_BLOCK
-	return !bdev || queue_is_mq(bdev_get_queue(bdev));
+	return !bdev || blk_queue_nowait(bdev_get_queue(bdev));
 #else
 	return true;
 #endif
-- 
2.27.0

