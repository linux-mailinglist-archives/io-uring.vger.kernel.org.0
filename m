Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2A228B9E2
	for <lists+io-uring@lfdr.de>; Mon, 12 Oct 2020 16:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390824AbgJLOEb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Oct 2020 10:04:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49861 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730766AbgJLODo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Oct 2020 10:03:44 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kRyQP-0003fj-Cq; Mon, 12 Oct 2020 14:03:41 +0000
From:   Colin King <colin.king@canonical.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] io_uring: Fix sizeof() mismatch
Date:   Mon, 12 Oct 2020 15:03:41 +0100
Message-Id: <20201012140341.77412-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

An incorrect sizeof() is being used, sizeof(file_data->table) is not
correct, it should be sizeof(*file_data->table).

Addresses-Coverity: ("Sizeof not portable (SIZEOF_MISMATCH)")
Fixes: 5398ae698525 ("io_uring: clean file_data access in files_register")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b58169240c77..6b30670fffbd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7306,7 +7306,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	spin_lock_init(&file_data->lock);
 
 	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_FILES_TABLE);
-	file_data->table = kcalloc(nr_tables, sizeof(file_data->table),
+	file_data->table = kcalloc(nr_tables, sizeof(*file_data->table),
 				   GFP_KERNEL);
 	if (!file_data->table)
 		goto out_free;
-- 
2.27.0

