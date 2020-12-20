Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEC12DF440
	for <lists+io-uring@lfdr.de>; Sun, 20 Dec 2020 07:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbgLTGv2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Dec 2020 01:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbgLTGv2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Dec 2020 01:51:28 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C096C0613CF;
        Sat, 19 Dec 2020 22:50:48 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id v2so4521305pfm.9;
        Sat, 19 Dec 2020 22:50:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GxxzTBDSRDHyuhWRw4W2qqZlaU5pdzFe8fEwTaUs9WE=;
        b=gzqoY1gK/EQtK1qgxt9rkz7xbvNxdeH/QWq71v7oqV2qklg/yCCdyGLEwdsYDaGMZt
         lsYsodqKyEWk2MMVKW1qf+SzlRRNgcFsgaNvvy1UJtdiR9IoKJQ2o7F5SlFLWKB63u6+
         3EFpst5/1I2QNV+tuCO74oNJk+dDWRA/vD2gUAanvIIXYvJCm0xsLZwTrTHT71gPEp72
         j3/qtQHKtB5ZIkIivBeWpKgmHoXcy1SI/weHLS+4WXUptBS+RdiFh8omC9FScHUVtnlg
         e4hAvYyfq0Uv+jdgYAV4s2OzmlUkMabN6afVI5MuRQBLlAWMMSbSaz9V2Dw8+B2IlBCL
         aH3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GxxzTBDSRDHyuhWRw4W2qqZlaU5pdzFe8fEwTaUs9WE=;
        b=ATp0dvvg2UBBccwMzqtJ11L1f6sgN5/c9u4WhkdpyDwlAYSp92NU6wfhaI1KNYF88a
         p5QbpLG2C7orwj6ts//zYohP5vY6yA5VtmgJxgQWX6TpuMxzHlJ2mQUCYtS1KxiTzQRV
         gXULmhCrZotjxJpd9UTKffX54g7HNgXu+rbna4UykfzYZYn1BZGeLkF2TKlO5MOuMdZ1
         zifCi4OhwSq7vyBEsEW7Ij944zRiz6249e+qH0svTfnaiNIut/xTtxbA98/oBVeYTEbN
         g+TMxgq68sD3YWlF5uswBtEImcHh+6J0afw4ccRld7w2nxDGM9VbUzFVvFLalP4tlDP4
         i0yQ==
X-Gm-Message-State: AOAM530jXJkIuRB7SilCYinjfouBl2aRvea/NDNeKOMFT1vG791a+vc/
        PPmys8DSEpCIQJr27yvtxvg=
X-Google-Smtp-Source: ABdhPJxMe09hsE9jwnlOmDLbZhHlSE4vk3ID1ryYwiMBtx05aKRzON/oHJrTPtebB0lZsHsufi9b1g==
X-Received: by 2002:a62:ea17:0:b029:1ad:4788:7815 with SMTP id t23-20020a62ea170000b02901ad47887815mr3057594pfh.1.1608447047524;
        Sat, 19 Dec 2020 22:50:47 -0800 (PST)
Received: from noah.hsd1.ca.comcast.net ([2601:642:c300:6ca0:1800:e2b9:9586:956b])
        by smtp.googlemail.com with ESMTPSA id p15sm12579758pgl.19.2020.12.19.22.50.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Dec 2020 22:50:47 -0800 (PST)
From:   noah <goldstein.w.n@gmail.com>
Cc:     goldstein.w.n@gmail.com, noah <goldstein.n@wustl.edu>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fs: io_uring.c: Add skip option for __io_sqe_files_update
Date:   Sun, 20 Dec 2020 01:50:25 -0500
Message-Id: <20201220065025.116516-1-goldstein.w.n@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: noah <goldstein.n@wustl.edu>

This patch makes it so that specify a file descriptor value of -2 will
skip updating the corresponding fixed file index.

This will allow for users to reduce the number of syscalls necessary
to update a sparse file range when using the fixed file option.

Signed-off-by: noah <goldstein.w.n@gmail.com>
---
 fs/io_uring.c | 72 ++++++++++++++++++++++++++-------------------------
 1 file changed, 37 insertions(+), 35 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6f9392c35eef..43ab2b7a87d4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7876,42 +7876,44 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 			err = -EFAULT;
 			break;
 		}
-		i = array_index_nospec(up->offset, ctx->nr_user_files);
-		table = &ctx->file_data->table[i >> IORING_FILE_TABLE_SHIFT];
-		index = i & IORING_FILE_TABLE_MASK;
-		if (table->files[index]) {
-			file = table->files[index];
-			err = io_queue_file_removal(data, file);
-			if (err)
-				break;
-			table->files[index] = NULL;
-			needs_switch = true;
-		}
-		if (fd != -1) {
-			file = fget(fd);
-			if (!file) {
-				err = -EBADF;
-				break;
-			}
-			/*
-			 * Don't allow io_uring instances to be registered. If
-			 * UNIX isn't enabled, then this causes a reference
-			 * cycle and this instance can never get freed. If UNIX
-			 * is enabled we'll handle it just fine, but there's
-			 * still no point in allowing a ring fd as it doesn't
-			 * support regular read/write anyway.
-			 */
-			if (file->f_op == &io_uring_fops) {
-				fput(file);
-				err = -EBADF;
-				break;
-			}
-			table->files[index] = file;
-			err = io_sqe_file_register(ctx, file, i);
-			if (err) {
+		if (fd != -2) {
+			i = array_index_nospec(up->offset, ctx->nr_user_files);
+			table = &ctx->file_data->table[i >> IORING_FILE_TABLE_SHIFT];
+			index = i & IORING_FILE_TABLE_MASK;
+			if (table->files[index]) {
+				file = table->files[index];
+				err = io_queue_file_removal(data, file);
+				if (err)
+					break;
 				table->files[index] = NULL;
-				fput(file);
-				break;
+				needs_switch = true;
+			}
+			if (fd != -1) {
+				file = fget(fd);
+				if (!file) {
+					err = -EBADF;
+					break;
+				}
+				/*
+				 * Don't allow io_uring instances to be registered. If
+				 * UNIX isn't enabled, then this causes a reference
+				 * cycle and this instance can never get freed. If UNIX
+				 * is enabled we'll handle it just fine, but there's
+				 * still no point in allowing a ring fd as it doesn't
+				 * support regular read/write anyway.
+				 */
+				if (file->f_op == &io_uring_fops) {
+					fput(file);
+					err = -EBADF;
+					break;
+				}
+				table->files[index] = file;
+				err = io_sqe_file_register(ctx, file, i);
+				if (err) {
+					table->files[index] = NULL;
+					fput(file);
+					break;
+				}
 			}
 		}
 		nr_args--;
-- 
2.29.2

