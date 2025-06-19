Return-Path: <io-uring+bounces-8432-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4DD9AE0DF8
	for <lists+io-uring@lfdr.de>; Thu, 19 Jun 2025 21:28:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C697B7A68F1
	for <lists+io-uring@lfdr.de>; Thu, 19 Jun 2025 19:26:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBBD5246770;
	Thu, 19 Jun 2025 19:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="G8+WJPES"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f225.google.com (mail-pl1-f225.google.com [209.85.214.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF1723B607
	for <io-uring@vger.kernel.org>; Thu, 19 Jun 2025 19:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750361280; cv=none; b=RN2ILgTBxWLNR7FTS36C2E3Tef6jhrSEV7oPMZUVqAkYFtDiyT/vCapv9RD75WiMEsijKH3y79ps6B1kuBD0K4AD71D1w/lvhMZd63cQj9e/o1MrM15UsqcIuE8AefdB2YeJDGppF5wKADnTjg+5vlj80fao+DN8wla82ervZlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750361280; c=relaxed/simple;
	bh=FnPpDqN7O0aPwX/W/1yco6ofOjFg1aDQKv5V46Z7+ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYZ28g/0POoxK1SOythldSDW5p7fFimSIlglyrz22f77Eyn69P/w6Z+BxrEFlSDTKn4zBMjhn0LSOFP0YAd7StqYvVctrLXV3++I9ERt4V2UwlExDcVB3kLiGCDjfimZKig6hLwyPQ7NB7F0gqqBeknmHXR1QiLW9/H+qpnRmaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=G8+WJPES; arc=none smtp.client-ip=209.85.214.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f225.google.com with SMTP id d9443c01a7336-2369dd5839dso2360855ad.3
        for <io-uring@vger.kernel.org>; Thu, 19 Jun 2025 12:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1750361278; x=1750966078; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mybhRJjeD/SDX1/X5lJ4CCixpkUUl0tnOPI9FH5o5Og=;
        b=G8+WJPESiplzzhpyna5EgK1kyFBSnv64BZUN19yC4lhrCGAlPCrl8JpEWVPDcTdzoQ
         T4unbnj0bmXn0+DyTc+dVPTtie1eAP3W3AhOORbNxd1abQKsflv0U0VGjNRrxJVzKXMS
         Cp6hyuoO2g5ZBchQ+0pf2F6dFwdnqIgQHUaq7m/BW99nRLdDHZpUZN+ih8xDuy10/n37
         hhcPTqyW54ys/uv8HJKgwS9WJA1G+m3A1CCSxiIGTgpFRu9izTlbuR0qFZYgoq5hU6/r
         w3+xgj1FCGs+3osK46jNqzcPohmmB7YkvtILVDgbXmATDy456WViZHyhaKOFRXEqZuWx
         miAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750361278; x=1750966078;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mybhRJjeD/SDX1/X5lJ4CCixpkUUl0tnOPI9FH5o5Og=;
        b=r4vUAnip5B0l1zrjZTZXfLeqtjf03SdLr/R3XKFyl3okpt5OmdQ6ACsflEqf0ooN2L
         WrAYFlmB72KgFc/GLhLFQbv2z1jlvQNGEBPJY6JY+oAZP96VbV495evkVPmtLsx7jIrI
         EdIXwy4WecbKC5d59u9jtcEWVJ3CERPOXojc3hUYpoE+Yd0zh4oIerrM9UnLteba3U/u
         9mvvbcTueos+h7lCl8+JjYrB9fKFemAFgtaUZ/wL8iyL3PdSQOBHdzoEPp36VhYja4SG
         S5xktC1sDCJGIDgzCJpKlXx9EdssIzFGcCn5qev0p7gAsJxaI3sSbbnBHm9s4fgIXzIQ
         r2yA==
X-Forwarded-Encrypted: i=1; AJvYcCXNJaPDSX4X7WOe+jdrtYrYP5MDWnLhgpVmP/f/7klQRIze71jHVFuLRtxl5O/LDIrw+ca6SgdtDw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzi4YruaW7CENypnb0rJSJXp7J8V8OcJAkXU860njv4Ek2mr6NH
	HEOqb95UFSE8N0x3kHWhPvacdytXvhjMovBwcWv+w7vhOIhqPafXWgzCzkg/iuRbVcvB+uP2PUx
	S34SAu6kChWECe6bnN79EjpWYe9xDZn8MoTX4MknffXRKNP+HbU8l
X-Gm-Gg: ASbGncuhMO0QTGK6LeShPSO68tuAGTmbHZLPn1qm0vK7WOXqG3TNDjgimP2HJq/Nmqs
	Tl2LbwzcwZA/DHyhwtIxUcMDZxod+oJA05GWGlwL023eEFId9+5CSZnm1ggpFg6B7RZ+s/3Kmrb
	T5xbab48NocziVLt06FeAGdTUVPMX1RXPXDXoX73yZN4AnR8ySZnAmCio8P+jUUFElcOP60tKQT
	1cuPP+AJGkstpatCQerAePO05fgJSJeChKEE2jFMAkOf+lUCQURMGET/DuVgoSaxu6OnvDxZeTP
	MnOcWJ8wL4aDz/VwUVJYZbMbg4NDk9cTy06JY9eQ
X-Google-Smtp-Source: AGHT+IEfrbbqTW03ZQbYjJQQRg096jlIfeAiuyNMhayogR1nYrPRl8KDaYpdUx/qZmaAflOknzL1laWBTyeO
X-Received: by 2002:a17:903:24f:b0:235:ca87:37d0 with SMTP id d9443c01a7336-237d9aa8e20mr65ad.11.1750361277865;
        Thu, 19 Jun 2025 12:27:57 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-237d8324080sm120925ad.45.2025.06.19.12.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 12:27:57 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 56FD234031F;
	Thu, 19 Jun 2025 13:27:57 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 55009E4410B; Thu, 19 Jun 2025 13:27:57 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: Mark Harmstone <maharmstone@fb.com>,
	linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH 3/4] btrfs/ioctl: store btrfs_uring_encoded_data in io_btrfs_cmd
Date: Thu, 19 Jun 2025 13:27:47 -0600
Message-ID: <20250619192748.3602122-4-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250619192748.3602122-1-csander@purestorage.com>
References: <20250619192748.3602122-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs is the only user of struct io_uring_cmd_data and its op_data
field. Switch its ->uring_cmd() implementations to store the struct
btrfs_uring_encoded_data * in the struct io_btrfs_cmd, overlayed with
io_uring_cmd's pdu field. This avoids having to touch another cache line
to access the struct btrfs_uring_encoded_data *, and allows op_data and
struct io_uring_cmd_data to be removed.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 fs/btrfs/ioctl.c | 38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ff15160e2581..6183729c93a1 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4627,10 +4627,17 @@ static int btrfs_ioctl_encoded_write(struct file *file, void __user *argp, bool
 		add_wchar(current, ret);
 	inc_syscw(current);
 	return ret;
 }
 
+struct btrfs_uring_encoded_data {
+	struct btrfs_ioctl_encoded_io_args args;
+	struct iovec iovstack[UIO_FASTIOV];
+	struct iovec *iov;
+	struct iov_iter iter;
+};
+
 /*
  * Context that's attached to an encoded read io_uring command, in cmd->pdu. It
  * contains the fields in btrfs_uring_read_extent that are necessary to finish
  * off and cleanup the I/O in btrfs_uring_read_finished.
  */
@@ -4648,10 +4655,11 @@ struct btrfs_uring_priv {
 	int err;
 	bool compressed;
 };
 
 struct io_btrfs_cmd {
+	struct btrfs_uring_encoded_data *data;
 	struct btrfs_uring_priv *priv;
 };
 
 static void btrfs_uring_read_finished(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
@@ -4706,10 +4714,11 @@ static void btrfs_uring_read_finished(struct io_uring_cmd *cmd, unsigned int iss
 		__free_page(priv->pages[index]);
 
 	kfree(priv->pages);
 	kfree(priv->iov);
 	kfree(priv);
+	kfree(bc->data);
 }
 
 void btrfs_uring_read_extent_endio(void *ctx, int err)
 {
 	struct btrfs_uring_priv *priv = ctx;
@@ -4789,17 +4798,10 @@ static int btrfs_uring_read_extent(struct kiocb *iocb, struct iov_iter *iter,
 	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
 	kfree(priv);
 	return ret;
 }
 
-struct btrfs_uring_encoded_data {
-	struct btrfs_ioctl_encoded_io_args args;
-	struct iovec iovstack[UIO_FASTIOV];
-	struct iovec *iov;
-	struct iov_iter iter;
-};
-
 static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	size_t copy_end_kernel = offsetofend(struct btrfs_ioctl_encoded_io_args, flags);
 	size_t copy_end;
 	int ret;
@@ -4811,11 +4813,15 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
 	loff_t pos;
 	struct kiocb kiocb;
 	struct extent_state *cached_state = NULL;
 	u64 start, lockend;
 	void __user *sqe_addr;
-	struct btrfs_uring_encoded_data *data = io_uring_cmd_get_async_data(cmd)->op_data;
+	struct io_btrfs_cmd *bc = io_uring_cmd_to_pdu(cmd, struct io_btrfs_cmd);
+	struct btrfs_uring_encoded_data *data = NULL;
+
+	if (cmd->flags & IORING_URING_CMD_REISSUE)
+		data = bc->data;
 
 	if (!capable(CAP_SYS_ADMIN)) {
 		ret = -EPERM;
 		goto out_acct;
 	}
@@ -4841,11 +4847,11 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
 		if (!data) {
 			ret = -ENOMEM;
 			goto out_acct;
 		}
 
-		io_uring_cmd_get_async_data(cmd)->op_data = data;
+		bc->data = data;
 
 		if (issue_flags & IO_URING_F_COMPAT) {
 #if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
 			struct btrfs_ioctl_encoded_io_args_32 args32;
 
@@ -4939,21 +4945,28 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
 out_acct:
 	if (ret > 0)
 		add_rchar(current, ret);
 	inc_syscr(current);
 
+	if (ret != -EIOCBQUEUED && ret != -EAGAIN)
+		kfree(data);
+
 	return ret;
 }
 
 static int btrfs_uring_encoded_write(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	loff_t pos;
 	struct kiocb kiocb;
 	struct file *file;
 	ssize_t ret;
 	void __user *sqe_addr;
-	struct btrfs_uring_encoded_data *data = io_uring_cmd_get_async_data(cmd)->op_data;
+	struct io_btrfs_cmd *bc = io_uring_cmd_to_pdu(cmd, struct io_btrfs_cmd);
+	struct btrfs_uring_encoded_data *data = NULL;
+
+	if (cmd->flags & IORING_URING_CMD_REISSUE)
+		data = bc->data;
 
 	if (!capable(CAP_SYS_ADMIN)) {
 		ret = -EPERM;
 		goto out_acct;
 	}
@@ -4971,11 +4984,11 @@ static int btrfs_uring_encoded_write(struct io_uring_cmd *cmd, unsigned int issu
 		if (!data) {
 			ret = -ENOMEM;
 			goto out_acct;
 		}
 
-		io_uring_cmd_get_async_data(cmd)->op_data = data;
+		bc->data = data;
 
 		if (issue_flags & IO_URING_F_COMPAT) {
 #if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
 			struct btrfs_ioctl_encoded_io_args_32 args32;
 
@@ -5061,10 +5074,13 @@ static int btrfs_uring_encoded_write(struct io_uring_cmd *cmd, unsigned int issu
 	kfree(data->iov);
 out_acct:
 	if (ret > 0)
 		add_wchar(current, ret);
 	inc_syscw(current);
+
+	if (ret != -EAGAIN)
+		kfree(data);
 	return ret;
 }
 
 int btrfs_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
-- 
2.45.2


