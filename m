Return-Path: <io-uring+bounces-7095-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F037DA65215
	for <lists+io-uring@lfdr.de>; Mon, 17 Mar 2025 15:00:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29E5F1767C4
	for <lists+io-uring@lfdr.de>; Mon, 17 Mar 2025 13:59:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0720241667;
	Mon, 17 Mar 2025 13:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="KdwR8lkn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4156C245021
	for <io-uring@vger.kernel.org>; Mon, 17 Mar 2025 13:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742219886; cv=none; b=n1fdds41lLbIjV+DIdwa1QVBAIJ6D0eu7y/qUdoYRS/bxgjE46HgWbF67KXJhY7sY5yOGcef7dccnkyYUBQ7AXkQ5bJKytliiUMTPKhvRQ7iSJeMN939Wp5xZsr0HVfTa+uCZAE43qcBqUucEMmmgFSY2MRbPaBrknfePrjsTsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742219886; c=relaxed/simple;
	bh=jjy/ipAsVAjM570PsPj8EFg1BR0qzO1tolMoinZ9Ul8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gyKK5i9pcHU8Ow3SzA2pqtM0TnVhBsxGaruYp+fRNqNTNA71BBg7/UHycVrRXG6Y2dmGUnM/7UGxmrf9YFRIhGOglLfgJuhEUVk5S9pbOoqy5MuofGrpiTt+0r9AlCke4xOuBu5n7Gqntbt6+Jp6S+ycqHhM/nW50Jj0A4uTBTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=KdwR8lkn; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-224171d6826so32000145ad.3
        for <io-uring@vger.kernel.org>; Mon, 17 Mar 2025 06:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1742219884; x=1742824684; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gA/GFNSLx9g8BrxtQW6nnUtMwtq8vRTEsCNTXthdg1I=;
        b=KdwR8lknBkk0y3/Ue2UtywXBWCCkbDYoO67uQcXxecd3q21/h9QkEYEg9KfeDXWOtq
         ciw+CRCLmFDHrCIbze5ahmRiF3m2Y4r4LPmOzGFcLSAu39To5DnwxLI2erwKqL2ve8sG
         IJqxdQC7mKZ3NJf4q/+Hbv+3v+TjybPDrB2+8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742219884; x=1742824684;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gA/GFNSLx9g8BrxtQW6nnUtMwtq8vRTEsCNTXthdg1I=;
        b=MiMWY6iKBLP1WoztMxiyNwMKsOZECJYtlPggtprWmjYJ+uzCdSh7JMzp2qstmdmgXi
         JFUet3SudqEDu6pzjtE0e1HPTtAAl/pSiMJ+41GXobEXVp2FQVYCZr5SqFmvvB4WZrSc
         EKin2NQZ+TKxI1SpRV9BcEMdjf1Hk0Bfhg+SS+rTf9w6/AXC/8YVxt8fkMFfmq+0QxpA
         wMJZHnSB4glmNerSzWOdjEoxdDyM5hIPAyDUOafB9L10v3/GXtTlp5dxD6X+DK7zsZPw
         BmOl+Nt2NK1cJZoM+eeFr42ptU/vQr/0P///OgsIT1qxL8ch4+NCxTKWR4XVRP5tlzVK
         Ci2g==
X-Forwarded-Encrypted: i=1; AJvYcCUOQJwWYRUv6xBl692fCXg1fXizSQg6MQXOkoSO5m7cg8Ke9Ulok3KSNWqKL5uuLNNRQJUYoKmx6A==@vger.kernel.org
X-Gm-Message-State: AOJu0YxskWnGg9GlICRL3dFrEk4NGk4AjHa0QpZN+RmkwFX+WFNkMV1S
	34UgghV/1WTOBgqiBbo+xZPCnd6gZF/FFB66ptgF+EgL2WqhIgtrMD3xibcqB1Q=
X-Gm-Gg: ASbGncuT1/GHrko7AAsmZeE8B7g03WLWpEyl7Od7xHr5THJKy9TAW+L8voolGMaRFr0
	WFR6Q5PTSIl/+rfRoWBtJmKPjYro1gBwfJBinokrvt2Zs7IjvbqK8B8lcuTZ5R4xqU5QEkG/PMo
	L+eD1PIQZpqAzebYgKPoEN3JI6qCdU+AXLaWl/SmJh6TAVSR1mAVCpMMHsz7hNxY+1ByJEYbhyE
	9pAhN0pIFoBWP62oyh6hknphYI/EGBbUA/IzvuGu1Jc/Wm6z3oTeDHr8uWIbl2IpV6EWA41LL+c
	lZccNDKoNWEqjIJ6gH/5QAXYOxEBLIGHNj3vt9UM9rccexdqeQjqSmUK6Zqo3jZTOoe1cTuDc6V
	U1sCO4FDjKe9uL6M=
X-Google-Smtp-Source: AGHT+IFR7AcxAe0GTSDHpA3O1seZLZqT6TdAlslNuPZsXOgxqL8PZ6/n5ArYVp7pqIiRkt7+bkJSOQ==
X-Received: by 2002:a17:90b:4d04:b0:2fe:baa3:b8bc with SMTP id 98e67ed59e1d1-30151d3fbb4mr12872664a91.23.1742219884680;
        Mon, 17 Mar 2025 06:58:04 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30153b99508sm5993742a91.39.2025.03.17.06.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 06:58:04 -0700 (PDT)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Sidong Yang <sidong.yang@furiosa.ai>
Subject: [RFC PATCH v4 4/5] btrfs: ioctl: introduce btrfs_uring_import_iovec()
Date: Mon, 17 Mar 2025 13:57:41 +0000
Message-ID: <20250317135742.4331-5-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250317135742.4331-1-sidong.yang@furiosa.ai>
References: <20250317135742.4331-1-sidong.yang@furiosa.ai>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch introduces btrfs_uring_import_iovec(). In encoded read/write
with uring cmd, it uses import_iovec without supporting fixed buffer.
btrfs_using_import_iovec() could use fixed buffer if cmd flags has
IORING_URING_CMD_FIXED.

Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
---
 fs/btrfs/ioctl.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 6c18bad53cd3..a7b52fd99059 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4802,6 +4802,28 @@ struct btrfs_uring_encoded_data {
 	struct iov_iter iter;
 };
 
+static int btrfs_uring_import_iovec(struct io_uring_cmd *cmd,
+				    unsigned int issue_flags, int rw)
+{
+	struct btrfs_uring_encoded_data *data =
+		io_uring_cmd_get_async_data(cmd)->op_data;
+	int ret;
+
+	if (cmd && (cmd->flags & IORING_URING_CMD_FIXED)) {
+		data->iov = NULL;
+		ret = io_uring_cmd_import_fixed_vec(cmd, data->args.iov,
+						    data->args.iovcnt,
+						    ITER_DEST, issue_flags,
+						    &data->iter);
+	} else {
+		data->iov = data->iovstack;
+		ret = import_iovec(rw, data->args.iov, data->args.iovcnt,
+				   ARRAY_SIZE(data->iovstack), &data->iov,
+				   &data->iter);
+	}
+	return ret;
+}
+
 static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	size_t copy_end_kernel = offsetofend(struct btrfs_ioctl_encoded_io_args, flags);
@@ -4874,10 +4896,7 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
 			goto out_acct;
 		}
 
-		data->iov = data->iovstack;
-		ret = import_iovec(ITER_DEST, data->args.iov, data->args.iovcnt,
-				   ARRAY_SIZE(data->iovstack), &data->iov,
-				   &data->iter);
+		ret = btrfs_uring_import_iovec(cmd, issue_flags, ITER_DEST);
 		if (ret < 0)
 			goto out_acct;
 
@@ -5022,10 +5041,7 @@ static int btrfs_uring_encoded_write(struct io_uring_cmd *cmd, unsigned int issu
 		if (data->args.len > data->args.unencoded_len - data->args.unencoded_offset)
 			goto out_acct;
 
-		data->iov = data->iovstack;
-		ret = import_iovec(ITER_SOURCE, data->args.iov, data->args.iovcnt,
-				   ARRAY_SIZE(data->iovstack), &data->iov,
-				   &data->iter);
+		ret = btrfs_uring_import_iovec(cmd, issue_flags, ITER_SOURCE);
 		if (ret < 0)
 			goto out_acct;
 
-- 
2.43.0


