Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0FC262E55
	for <lists+io-uring@lfdr.de>; Wed,  9 Sep 2020 14:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbgIIMKg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Sep 2020 08:10:36 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11293 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728971AbgIIMIn (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 9 Sep 2020 08:08:43 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D06E4FBF7B637EB7039C;
        Wed,  9 Sep 2020 20:05:48 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Wed, 9 Sep 2020
 20:05:41 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <viro@zeniv.linux.org.uk>, <axboe@kernel.dk>,
        <linux-fsdevel@vger.kernel.org>, <io-uring@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH -next] io_uring: Remove unneeded semicolon
Date:   Wed, 9 Sep 2020 20:12:37 +0800
Message-ID: <20200909121237.39914-1-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Fixes coccicheck warning:

fs/io_uring.c:4242:13-14: Unneeded semicolon

Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d00eb6bf6ce9..565a3e568766 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4239,7 +4239,7 @@ static int io_send(struct io_kiocb *req, bool force_nonblock,

 	ret = import_single_range(WRITE, sr->buf, sr->len, &iov, &msg.msg_iter);
 	if (unlikely(ret))
-		return ret;;
+		return ret;

 	msg.msg_name = NULL;
 	msg.msg_control = NULL;
--
2.26.0.106.g9fadedd

