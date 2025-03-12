Return-Path: <io-uring+bounces-7064-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 76426A5DEE1
	for <lists+io-uring@lfdr.de>; Wed, 12 Mar 2025 15:24:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE7563B3F27
	for <lists+io-uring@lfdr.de>; Wed, 12 Mar 2025 14:24:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E10FF22DFB4;
	Wed, 12 Mar 2025 14:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b="bB3zlehi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA232505B7
	for <io-uring@vger.kernel.org>; Wed, 12 Mar 2025 14:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741789449; cv=none; b=I4zLkugksnr4V7ei6w6pbk0DsfTQG8afdvZj0SGFjzBGtioBTCTFQKTh2NeuNo3OnHgkV1dUn4ZXBYBzm3TSjni0WgyoiBU8gUKlg6ogYtwDY1yuJS+Mjb3jQz66szjXKtrBYxNpF5FgWmyL4tpa/kZ3UT+nTKOl57wyQ3n4csQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741789449; c=relaxed/simple;
	bh=ga2LSmT61md5n2p7rdCucn4O99aWE/jCY95aOOLVTH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nl7+ECGTa+v/r+hgzX9+/8AO4HgkOscEN4nBeRv3KmwZtMfN3b/u/DlJJfUtguShpweUF+gnkIWjg0jsOfySheBN0SZWknVbR0N061dhsNWv1zhNpC7GZwbOnTePQez9tZPqNRbDRxXr0tIiMlqqhFqVLsrxPQMOsqrsLLWH/xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b=bB3zlehi; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-22403cbb47fso131587255ad.0
        for <io-uring@vger.kernel.org>; Wed, 12 Mar 2025 07:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa-ai.20230601.gappssmtp.com; s=20230601; t=1741789448; x=1742394248; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sf5Mim88v1zsUv2CF9zajfgiTTZumS4UoXrfg/qlMyE=;
        b=bB3zlehiZTFURQmVJcfQacyW7bM61oTMRio0061Ul84NaT+OpR0HreJbtIBbn5l5G1
         Awfru6ADxBPtzGeali+x/cD0Xgan7BJb/beK3eyfzmmMY7SnLnjMqckW5OrPpXUW1L/r
         92z5LkcWZjJ/brlJITek8PoT4axxVyFJ8BqfrUJABI3Z1BJd59zduodfxqJf/ZQ1Awlu
         2P5vChH/QxlRz92kfsEs9r7L/iu0RJiIilyO/s5SHtU5JIQD8iIDegSc/nG1+nWYIDY+
         9pS2wFqWSu0kRzjthDvr9C5GFjUdhiwV79/JeyfRYiZMatRalXqfxx1cQa5OHrVvvMCS
         8B2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741789448; x=1742394248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sf5Mim88v1zsUv2CF9zajfgiTTZumS4UoXrfg/qlMyE=;
        b=SLIIIhHKR5ogmZ0L7XEPGIw3leyVfDB8bQFPGDdTO2Z3jvmOaIsTJlcoRdkSTST0PF
         gTAATPiOgB5sKIgEeP49LSsYi8WyY2kOBEB9N9ziPJ15uYIqA/XLK7xaPItIJ7mXxFfh
         cqm8kYwZo9bA55zna0VvqRE3AwWbqUi+YSspnbmp9zukXElXTzMCT7etjL+o4YFmD1q8
         qPYAJ8ToLWqAlvTCLWj42vF9tSkPZmpsI8xrkuI3ZmqzZTOZeBuZdYLDgJvlesq1Ng2b
         NOidUz0J3LgR4CZJ6xkuX0k/EpRtQDAn2Umr3ruQILj1fJclPAIizrw/e0AqLmJPvjXn
         p3ag==
X-Forwarded-Encrypted: i=1; AJvYcCVo94QUXsWLo/7J8grkrHEd3rzZQNvcpLsTXyYSpwyfoABb97ICs31QbpwodGDclT0HllDuVGUxBQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxRCGtbE08UKR9wDTJ0BpbknXj8sRkoUkhuCdk+XN05YYtU+JHl
	oauddfJ11cK4VX9+j2AgoUJ+55a1f7S8r565CySgNooTNjwpBdFnsG4IRWNG6II=
X-Gm-Gg: ASbGncvj1Laez4y3lA0S/06f7MaNmneIgyZHe7sRgjlZTuW6gi8Sqhu59KFxIEmnhxW
	B6l1IRtSjwS8T/UZDw9WD3aD2AuxzlEPTYIlFmVan361FLRgpLNAitUfRTkfdsGLp93ddSozkIr
	SqvJWhuwk+sUhDsrm6OicChHs/zdiQLnq2t+thf/fq89xOx60mNR3iBDRSe7gCHJOuvVKTC7loD
	tiLZv0SZ6b5jW6wXihAjPzcbA4KIUYCgIgVW7R4uABGdUr9U2Y7jTiOQyaXFbj3FtgqWpdmZOWZ
	8jikxsaSy449kJsHLAGsQd9iwj59C6I77Y4Msof2EjPbLLv6HYs08yu0K5IWtBYedOIo+gG6gy+
	ZvPn5
X-Google-Smtp-Source: AGHT+IEB7zRsn2sn891Qv++mKti8pmW2qB36bnhHeSKSGpIvhV7qeTB7jRROPtq3qpgTC2s59IzhKQ==
X-Received: by 2002:a05:6a00:1401:b0:736:34a2:8a23 with SMTP id d2e1a72fcca58-736aaabee7amr27951202b3a.15.1741789447564;
        Wed, 12 Mar 2025 07:24:07 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736cc972eabsm7413860b3a.144.2025.03.12.07.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Mar 2025 07:24:07 -0700 (PDT)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Sidong Yang <sidong.yang@furiosa.ai>
Subject: [RFC PATCH v2 2/2] btrfs: ioctl: use registered buffer for IORING_URING_CMD_FIXED
Date: Wed, 12 Mar 2025 14:23:26 +0000
Message-ID: <20250312142326.11660-3-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250312142326.11660-1-sidong.yang@furiosa.ai>
References: <20250312142326.11660-1-sidong.yang@furiosa.ai>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch supports IORING_URING_CMD_FIXED flags in io-uring cmd. It
means that user provided buf_index in sqe that is registered before
submitting requests. In this patch, btrfs_uring_encoded_read() makes
iov_iter bvec type by checking the io-uring cmd flag. And there is
additional bvec field in btrfs_uring_priv for remaining bvec
lifecycle.

Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
---
 fs/btrfs/ioctl.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 6c18bad53cd3..7ac5a387ae5d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2007 Oracle.  All rights reserved.
  */
 
+#include "linux/bvec.h"
 #include <linux/kernel.h>
 #include <linux/bio.h>
 #include <linux/file.h>
@@ -4644,6 +4645,7 @@ struct btrfs_uring_priv {
 	unsigned long nr_pages;
 	struct kiocb iocb;
 	struct iovec *iov;
+	struct bio_vec *bvec;
 	struct iov_iter iter;
 	struct extent_state *cached_state;
 	u64 count;
@@ -4711,6 +4713,7 @@ static void btrfs_uring_read_finished(struct io_uring_cmd *cmd, unsigned int iss
 
 	kfree(priv->pages);
 	kfree(priv->iov);
+	kfree(priv->bvec);
 	kfree(priv);
 }
 
@@ -4730,7 +4733,8 @@ static int btrfs_uring_read_extent(struct kiocb *iocb, struct iov_iter *iter,
 				   struct extent_state *cached_state,
 				   u64 disk_bytenr, u64 disk_io_size,
 				   size_t count, bool compressed,
-				   struct iovec *iov, struct io_uring_cmd *cmd)
+				   struct iovec *iov, struct io_uring_cmd *cmd,
+				   struct bio_vec *bvec)
 {
 	struct btrfs_inode *inode = BTRFS_I(file_inode(iocb->ki_filp));
 	struct extent_io_tree *io_tree = &inode->io_tree;
@@ -4767,6 +4771,7 @@ static int btrfs_uring_read_extent(struct kiocb *iocb, struct iov_iter *iter,
 	priv->start = start;
 	priv->lockend = lockend;
 	priv->err = 0;
+	priv->bvec = bvec;
 
 	ret = btrfs_encoded_read_regular_fill_pages(inode, disk_bytenr,
 						    disk_io_size, pages, priv);
@@ -4818,6 +4823,7 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
 	u64 start, lockend;
 	void __user *sqe_addr;
 	struct btrfs_uring_encoded_data *data = io_uring_cmd_get_async_data(cmd)->op_data;
+	struct bio_vec *bvec = NULL;
 
 	if (!capable(CAP_SYS_ADMIN)) {
 		ret = -EPERM;
@@ -4875,9 +4881,19 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
 		}
 
 		data->iov = data->iovstack;
-		ret = import_iovec(ITER_DEST, data->args.iov, data->args.iovcnt,
-				   ARRAY_SIZE(data->iovstack), &data->iov,
-				   &data->iter);
+
+		if (cmd && (cmd->flags & IORING_URING_CMD_FIXED)) {
+			ret = io_uring_cmd_import_fixed_vec(
+				cmd, data->args.iov, data->args.iovcnt,
+				ITER_DEST, issue_flags, &data->iter, &bvec);
+			data->iov = NULL;
+		} else {
+			ret = import_iovec(ITER_DEST, data->args.iov,
+					   data->args.iovcnt,
+					   ARRAY_SIZE(data->iovstack),
+					   &data->iov, &data->iter);
+		}
+
 		if (ret < 0)
 			goto out_acct;
 
@@ -4929,13 +4945,14 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
 		ret = btrfs_uring_read_extent(&kiocb, &data->iter, start, lockend,
 					      cached_state, disk_bytenr, disk_io_size,
 					      count, data->args.compression,
-					      data->iov, cmd);
+					      data->iov, cmd, bvec);
 
 		goto out_acct;
 	}
 
 out_free:
 	kfree(data->iov);
+	kfree(bvec);
 
 out_acct:
 	if (ret > 0)
-- 
2.43.0


