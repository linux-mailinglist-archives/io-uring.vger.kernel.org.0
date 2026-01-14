Return-Path: <io-uring+bounces-11637-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EBA24D1C57E
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:32:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6A3A430124F8
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F338030DD29;
	Wed, 14 Jan 2026 04:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="rDHtoqZE"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D072E03EA;
	Wed, 14 Jan 2026 04:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365113; cv=none; b=WGrMiYF9wLZy5pRIuNBmZOFlaI7uttfjDoLRnIVCZQ+DLcNRO7rQpQxagxOOG0Ags9873nuN7dW+SZT7zttvq7hRY9RJ1ti4Zo66msJVApFs8AyUNx/ECRRsq48fBVpfLvGGvPfWCLI4hRLfgG6Kx4/GnhAwU2UQCB3kne7gFF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365113; c=relaxed/simple;
	bh=Ydled4U6L1X7V26SQt7n9puQ7dfK0LX63LBtB+WlC0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2rgHqN6zjUgxo2XucFL2LrnG4GusagcHlDj5ClbkM7ZxP6VnseNqNc70OHc93fVaF25b7XBjfsLoaLVyPAv2sxuMe3uR4rE+s/kG+76eCaR50v5Am+eV7wq0avtYRY1wP36+RW3xXt4qpKRE8xaP648u811vYpNaXE94/JVTP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=rDHtoqZE; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=sd2Rgca4jMZ7f1mAJaupLk+3fuY1coBUzS+dbbv0xtA=; b=rDHtoqZEiD/2rjP3tVdAyhqd9B
	a+/TcZajyABSj4wxRS3kCCBf89GVzUkvpCw8M9e48tmfrMysbIMlVoSZtLHeVNWi1QukXQUo9CWPv
	7bklDvLPEGIh7l8z/ZSv/4VEaxYR6IOweNWOkv4OGAK6NSFaX2Qi3Aq36ZQPD8CuY6A4omjZk9A1I
	P+dEFfy1XDzsn0jILjzoiQ0d/+liV4z1nltsuGvIqfYEWilgILFirMdsfZr+z+kEHLZEYyMP3F2tp
	bbUTOxRP69nO8DqS8wW1iAALaLUcAED05Pgf24F8/VNMpyPtqST6xwQe+qF1Du9ccmhfI0xsEohf1
	qrK7EBRA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZF-0000000GIoA-4BQ5;
	Wed, 14 Jan 2026 04:33:14 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Jens Axboe <axboe@kernel.dk>,
	audit@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 28/68] ksmbd_vfs_path_lookup(): vfs_path_parent_lookup() accepts ERR_PTR() as name
Date: Wed, 14 Jan 2026 04:32:30 +0000
Message-ID: <20260114043310.3885463-29-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114043310.3885463-1-viro@zeniv.linux.org.uk>
References: <20260114043310.3885463-1-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

no need to check in the caller

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/smb/server/vfs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index f891344bd76b..a97226116840 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -67,9 +67,6 @@ static int ksmbd_vfs_path_lookup(struct ksmbd_share_config *share_conf,
 	}
 
 	filename = getname_kernel(pathname);
-	if (IS_ERR(filename))
-		return PTR_ERR(filename);
-
 	err = vfs_path_parent_lookup(filename, flags,
 				     path, &last, &type,
 				     root_share_path);
-- 
2.47.3


