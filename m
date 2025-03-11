Return-Path: <io-uring+bounces-7048-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CE1EA5BF6F
	for <lists+io-uring@lfdr.de>; Tue, 11 Mar 2025 12:42:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C0C20189A052
	for <lists+io-uring@lfdr.de>; Tue, 11 Mar 2025 11:42:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99990256C85;
	Tue, 11 Mar 2025 11:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b="1BENZkCk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1904E254B1B
	for <io-uring@vger.kernel.org>; Tue, 11 Mar 2025 11:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741693326; cv=none; b=sjn/BA+4MH09kcyOOTP7xZG3W/o5bu2vrhixQ7okAeAYAtsXi3M1VXAT26xhYjmrUeNXYObxS+9Ei0ZOOD0QX+tA1aUSKCtoPtVvHNKYnb7PfYmp/89Y0RdG3vSEKC1q0kqUB+7HlcVqqUaISnUEapv5uKUaUzWm5u0CfM7ylFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741693326; c=relaxed/simple;
	bh=NSmyg+PbHJ354WJeRB+D9sthgSs9N/UsZf0bxZC7nPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KeyiAiOSh3BPgaZuxyoR1oqMHcljCvNPZYVYol2Jtr8ApZfVXnasMBHHXWIBR/sdfO16u5dZqcABep3szC2IWrTJy2+mkonbG1+yo6Cp2pdRvDOOQPQ+cnNY5191QSstkGqD22GpM+y0sslpt3FDZajcIPt+e9RNzX2X2BZ+kEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b=1BENZkCk; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2ff4a4f901fso7911095a91.2
        for <io-uring@vger.kernel.org>; Tue, 11 Mar 2025 04:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa-ai.20230601.gappssmtp.com; s=20230601; t=1741693324; x=1742298124; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QXXOHgCX8LOzk7FN9r6WSAUJT1m0r7Sn6/UXaW/zWeI=;
        b=1BENZkCkDVbgiraoYnWGuQAb9hdve3ZegQ8bGiPs7fOWgJuNYkLP52vA4GFrdUjWgO
         IEB+RZCFyqp4FgQtTkjFBLD2qUx/i5dVGXxbCm1HiPbw4t9wcxA+a2LaRwkR+RU/gpia
         LyjEuldzEK0jKQObhF9/DomlautVDFQvRDuth4CLyWTuw7lJL+FQPUlwiBmVNH4kT9Zf
         t6DPvCNutzIewSxIMRSN3yEQy7zS2NfKQyvOv5nMpYWLXMYQmTfoC6dPfECIFiBkTIIM
         RmbNC+gB1s2IvXYhTTehz8aEq7CB5AEpx90lergSC3odukD/n0jf1kJRcntAPfTWvdCB
         PV3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741693324; x=1742298124;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QXXOHgCX8LOzk7FN9r6WSAUJT1m0r7Sn6/UXaW/zWeI=;
        b=TpaECSZNSIRHKeiBk5y8DbXpPIqk6ZwtIvEiE7kDggTEvkcQtV0wIO/IfzVO+2eapf
         vl+Xv2vTMntNkrAyTmkKLfkJdFvWKeBOh1GrUoc8LczeyYnbP1c+Lsp1uc9dWskl3WiF
         Wfx/QplTZgrkqtKWyPO+NcMpaHBUIL2/93J8T5m2SuALHktaS1M5DnWTYJI3A4u8EKRU
         EB6maNfasq4ZJyTsOCZnfiRIvsZPoF62/gGZ7rXfEJPFfTZymM5yGT4hsVIUzIhgPlby
         sIYBOM2KN+q53luHflOtNgXWnJsL6a2cEdlp6GLV+XRzizEFwXoGnulbaQ8iSmZHrLcO
         rIgw==
X-Forwarded-Encrypted: i=1; AJvYcCUPF8Th5ALGy+SzgkZDY2D9E7Xl4vQaXyluBUAde6PYBCiBHEodi5g/1wM67Kr1s07G9YvU7/gXcg==@vger.kernel.org
X-Gm-Message-State: AOJu0YznVzcDCu22MtgfokNRJIlA9dej3xh4WN36YRuQ7SSVbnUAI1dW
	1kE/2Va3hSK70CoKVAWJxuC14pqD+ZzB+A3Hh1YsyMtUdFT8lPlp0o1/LcVfwtE=
X-Gm-Gg: ASbGncttXaONoJ6uldwpFZpSokgR62xZSAFQazlysLRlQR6c6zceTAkyCLnbDtpawVd
	jaNf9fUDlenTGd30mFKDX+kk33f5Gr0kMLxz67scqe5LGhJH7eniB5PryBwDtdxl/0DRWI04WFW
	rZWvG9xHragBeCfVBkTlSpmTivpk/yxeyFoRieFCxF+tOafuzl7IV+F0K457MiRJDDwFw2/w2eb
	vuoGgs7TSuC89k1eHbtdm4uu9UHNyfH6zu2TqHDPdhGKvufhV2JpZB6FRT7Idbe5o8V72Ixkccr
	DtYfH+kKqiuUss0nNLHMxv1XWqBH0qILgzuOQyPKUw8Wj9z8eTEIsNXY3091gjTKJRO7O+GcmST
	W+vdE
X-Google-Smtp-Source: AGHT+IEBsIY0E5YZ6GSFCMY3gvyAGt1pgQYu5PEmxHTi1l7WoLNLU5LMW4UKaTogQ8vfn0kb9QZuCQ==
X-Received: by 2002:a17:90b:3b86:b0:2ff:784b:ffe with SMTP id 98e67ed59e1d1-300ff0d4986mr4643217a91.11.1741693324275;
        Tue, 11 Mar 2025 04:42:04 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([221.148.76.1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ff4e7ff8cfsm11647817a91.37.2025.03.11.04.42.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 04:42:03 -0700 (PDT)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>
Cc: Sidong Yang <sidong.yang@furiosa.ai>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 2/2] btrfs: ioctl: use registered buffer for IORING_URING_CMD_FIXED
Date: Tue, 11 Mar 2025 11:40:42 +0000
Message-ID: <20250311114053.216359-3-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250311114053.216359-1-sidong.yang@furiosa.ai>
References: <20250311114053.216359-1-sidong.yang@furiosa.ai>
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
additional iou_vec field in btrfs_uring_priv for remaining bvecs
lifecycle.

Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
---
 fs/btrfs/ioctl.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 6c18bad53cd3..586671eea622 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4643,6 +4643,7 @@ struct btrfs_uring_priv {
 	struct page **pages;
 	unsigned long nr_pages;
 	struct kiocb iocb;
+	struct iou_vec iou_vec;
 	struct iovec *iov;
 	struct iov_iter iter;
 	struct extent_state *cached_state;
@@ -4711,6 +4712,8 @@ static void btrfs_uring_read_finished(struct io_uring_cmd *cmd, unsigned int iss
 
 	kfree(priv->pages);
 	kfree(priv->iov);
+	if (priv->iou_vec.iovec)
+		kfree(priv->iou_vec.iovec);
 	kfree(priv);
 }
 
@@ -4730,7 +4733,8 @@ static int btrfs_uring_read_extent(struct kiocb *iocb, struct iov_iter *iter,
 				   struct extent_state *cached_state,
 				   u64 disk_bytenr, u64 disk_io_size,
 				   size_t count, bool compressed,
-				   struct iovec *iov, struct io_uring_cmd *cmd)
+				   struct iovec *iov, struct io_uring_cmd *cmd,
+				   struct iou_vec *iou_vec)
 {
 	struct btrfs_inode *inode = BTRFS_I(file_inode(iocb->ki_filp));
 	struct extent_io_tree *io_tree = &inode->io_tree;
@@ -4767,6 +4771,7 @@ static int btrfs_uring_read_extent(struct kiocb *iocb, struct iov_iter *iter,
 	priv->start = start;
 	priv->lockend = lockend;
 	priv->err = 0;
+	priv->iou_vec = *iou_vec;
 
 	ret = btrfs_encoded_read_regular_fill_pages(inode, disk_bytenr,
 						    disk_io_size, pages, priv);
@@ -4818,6 +4823,7 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
 	u64 start, lockend;
 	void __user *sqe_addr;
 	struct btrfs_uring_encoded_data *data = io_uring_cmd_get_async_data(cmd)->op_data;
+	struct iou_vec iou_vec = {};
 
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
+				data->args.iov, data->args.iovcnt, ITER_DEST,
+				&data->iter, cmd, &iou_vec, false, issue_flags);
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
 
@@ -4929,7 +4945,7 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
 		ret = btrfs_uring_read_extent(&kiocb, &data->iter, start, lockend,
 					      cached_state, disk_bytenr, disk_io_size,
 					      count, data->args.compression,
-					      data->iov, cmd);
+					      data->iov, cmd, &iou_vec);
 
 		goto out_acct;
 	}
-- 
2.43.0


