Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D163A7E89
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 15:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhFONCS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 09:02:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59258 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbhFONCS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 09:02:18 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lt8fs-0004x7-5k; Tue, 15 Jun 2021 13:00:12 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next][V2] io_uring: Fix incorrect sizeof operator for copy_from_user call
Date:   Tue, 15 Jun 2021 14:00:11 +0100
Message-Id: <20210615130011.57387-1-colin.king@canonical.com>
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
this is true for all cases.  Fix this by using a temporary pointer
tag_slot to make the code a clearer.

Addresses-Coverity: ("Sizeof not portable")
Fixes: d878c81610e1 ("io_uring: hide rsrc tag copy into generic helpers")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
V2: Use temp variable tag_slot, this makes code clearer as suggested by
    Pavel Begunkov.
---
 fs/io_uring.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d665c9419ad3..7538d0878ff5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7230,8 +7230,10 @@ static int io_rsrc_data_alloc(struct io_ring_ctx *ctx, rsrc_put_fn *do_put,
 	if (utags) {
 		ret = -EFAULT;
 		for (i = 0; i < nr; i++) {
-			if (copy_from_user(io_get_tag_slot(data, i), &utags[i],
-					   sizeof(data->tags[i])))
+			u64 *tag_slot = io_get_tag_slot(data, i);
+
+			if (copy_from_user(tag_slot, &utags[i],
+					   sizeof(*tag_slot)))
 				goto fail;
 		}
 	}
-- 
2.31.1

