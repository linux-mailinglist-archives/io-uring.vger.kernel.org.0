Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF8923F6FB
	for <lists+io-uring@lfdr.de>; Sat,  8 Aug 2020 10:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgHHIpT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 8 Aug 2020 04:45:19 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55946 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725957AbgHHIpT (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 8 Aug 2020 04:45:19 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2D232D207F3831C12E19;
        Sat,  8 Aug 2020 16:45:11 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Sat, 8 Aug 2020
 16:44:32 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <axboe@kernel.dk>, <viro@zeniv.linux.org.uk>
CC:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linmiaohe@huawei.com>
Subject: [PATCH] io_uring: Convert to use the fallthrough macro
Date:   Sat, 8 Aug 2020 16:47:01 +0800
Message-ID: <1596876421-22911-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

Convert the uses of fallthrough comments to fallthrough macro.

Signed-off-by: Hongxiang Lou <louhongxiang@huawei.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2a3af95be4ca..77e932c25312 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2516,7 +2516,7 @@ static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
 		 * IO with EINTR.
 		 */
 		ret = -EINTR;
-		/* fall through */
+		fallthrough;
 	default:
 		kiocb->ki_complete(kiocb, ret, 0);
 	}
-- 
2.19.1

