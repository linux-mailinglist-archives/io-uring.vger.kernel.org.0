Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717401F4D17
	for <lists+io-uring@lfdr.de>; Wed, 10 Jun 2020 07:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725844AbgFJFmB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Jun 2020 01:42:01 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:57045 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725270AbgFJFmB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Jun 2020 01:42:01 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01355;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U.9K-kq_1591767719;
Received: from localhost(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0U.9K-kq_1591767719)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 10 Jun 2020 13:41:59 +0800
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
Subject: [PATCH] io_uring: check file O_NONBLOCK state for accept
Date:   Wed, 10 Jun 2020 13:41:59 +0800
Message-Id: <1591767719-22583-1-git-send-email-jiufei.xue@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If the socket is O_NONBLOCK, we should complete the accept request
with -EAGAIN when data is not ready.

Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
---
 fs/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a476112..b8102b2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3969,6 +3969,9 @@ static int io_accept(struct io_kiocb *req, bool force_nonblock)
 {
 	int ret;
 
+	if (req->file->f_flags & O_NONBLOCK)
+		req->flags |= REQ_F_NOWAIT;
+
 	ret = __io_accept(req, force_nonblock);
 	if (ret == -EAGAIN && force_nonblock) {
 		req->work.func = io_accept_finish;
-- 
1.8.3.1

