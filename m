Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56E61F9F04
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2020 20:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729806AbgFOSGr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Jun 2020 14:06:47 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:48870 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728585AbgFOSGr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Jun 2020 14:06:47 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R861e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07488;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U.iUARa_1592244404;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U.iUARa_1592244404)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 16 Jun 2020 02:06:45 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH v2 1/2] io_uring: don't fail links for EAGAIN error in IOPOLL mode
Date:   Tue, 16 Jun 2020 02:06:37 +0800
Message-Id: <20200615180638.19905-2-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200615180638.19905-1-xiaoguang.wang@linux.alibaba.com>
References: <20200615180638.19905-1-xiaoguang.wang@linux.alibaba.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In IOPOLL mode, for EAGAIN error, we'll try to submit io request
again using io-wq, so don't fail rest of links if this io request
has links.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 61fca5afaac8..a3119fecfe40 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1974,7 +1974,7 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 	if (kiocb->ki_flags & IOCB_WRITE)
 		kiocb_end_write(req);
 
-	if (res != req->result)
+	if (res != -EAGAIN && res != req->result)
 		req_set_fail_links(req);
 	req->result = res;
 	if (res != -EAGAIN)
-- 
2.17.2

