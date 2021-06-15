Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC893A7C5B
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 12:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhFOKrv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 06:47:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55647 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbhFOKrs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 06:47:48 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lt6Zi-0003T3-6k; Tue, 15 Jun 2021 10:45:42 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] io_uring: Fix incorrect sizeof operator for copy_from_user call
Date:   Tue, 15 Jun 2021 11:45:41 +0100
Message-Id: <20210615104541.50529-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Static analysis is warning that the sizeof being used is should be
of *data->tags[i] and not data->tags[i]. Although these are the same
size on 64 bit systems it is not a portable assumption to assume
this is true for all cases.

Addresses-Coverity: ("Sizeof not portable")
Fixes: d878c81610e1 ("io_uring: hide rsrc tag copy into generic helpers")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d665c9419ad3..6b1a70449749 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7231,7 +7231,7 @@ static int io_rsrc_data_alloc(struct io_ring_ctx *ctx, rsrc_put_fn *do_put,
 		ret = -EFAULT;
 		for (i = 0; i < nr; i++) {
 			if (copy_from_user(io_get_tag_slot(data, i), &utags[i],
-					   sizeof(data->tags[i])))
+					   sizeof(*data->tags[i])))
 				goto fail;
 		}
 	}
-- 
2.31.1

