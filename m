Return-Path: <io-uring+bounces-11494-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AA8A7D0177D
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:55:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 990393049285
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:55:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB89F345CA0;
	Thu,  8 Jan 2026 07:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="Lo/ZumX9"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566A8340DB2;
	Thu,  8 Jan 2026 07:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857822; cv=none; b=g5sjQ8tfDKHIt0TArTz2i3eB1bnlvmJmJBxqQTNb9PbhHmHUzP45ySV/n8MwT4+MBOid9N42cKwlcA8yRaSQPjjoVXLRvj0mxCHoOftkZ0r6Gf7iP++A4pnCyasi6wtalu4go2k2dkuYPUN+SNSnaXjOrF6XK2Ydu3LgZL3f2Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857822; c=relaxed/simple;
	bh=nTHKXw8UwcLMJ53XI29POh8UPZpmRIfzCZ6jAwlP48s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pUSIYqCoapxzS7+NJ3BjXcoBH/ncdrCWIlXTXiFhXweakxJexOG2xxcV1GoZ1tgQdp7zaDOVOv+CsCOUNwku/qvmRHM9MO8q2TsE1CoTaksNR2Rr3T1rW/qZ+/FUCNv2ozkgj8VZNmrbyfxOrOsH+n8WKJ33pVFdD6OtyBdDlM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=Lo/ZumX9; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FD17jUCcWuTCEQI03eM0GnSRloJ9zIEZc4eT9v4ubz4=; b=Lo/ZumX9mQKjPPhqKap5cWBikf
	JinkpExLRlcKqkOBLr5uf2ITH3wUaF2bFlf/FtVEYF4xYJSAqOiRVOayQXt5+5LlsAA/qoCFY6KcE
	d6SxlCO1zeKsNIELG51BfxNNeuqRldBo3ivYGxBWsnLmiAw7lJYgrJW/WHwGAg2/l+yDRTIig0t5m
	wHb7nra4KToEG2+tx/vRR866JTIspiAIAk+1lHoCddqLh9g/6rmIDYWw+KiCqYV0kl05PJP3t1wA8
	38n/5bsDeqkRXZO9hMSYuoVvXEC2Rob/2lHtoCAcqoci6JKWdeMngE/DFTWxRCu3XdDzZToo5h6Mt
	2FsbXQrw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkaz-00000001mtl-34xm;
	Thu, 08 Jan 2026 07:38:13 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	mjguzik@gmail.com,
	paul@paul-moore.com,
	axboe@kernel.dk,
	audit@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 50/59] move_mount(2): switch to CLASS(filename_maybe_null)
Date: Thu,  8 Jan 2026 07:37:54 +0000
Message-ID: <20260108073803.425343-51-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260108073803.425343-1-viro@zeniv.linux.org.uk>
References: <20260108073803.425343-1-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namespace.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 888df8ee43bc..612757bd166a 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4402,8 +4402,6 @@ SYSCALL_DEFINE5(move_mount,
 {
 	struct path to_path __free(path_put) = {};
 	struct path from_path __free(path_put) = {};
-	struct filename *to_name __free(putname) = NULL;
-	struct filename *from_name __free(putname) = NULL;
 	unsigned int lflags, uflags;
 	enum mnt_tree_flags_t mflags = 0;
 	int ret = 0;
@@ -4425,7 +4423,7 @@ SYSCALL_DEFINE5(move_mount,
 	if (flags & MOVE_MOUNT_T_EMPTY_PATH)
 		uflags = AT_EMPTY_PATH;
 
-	to_name = getname_maybe_null(to_pathname, uflags);
+	CLASS(filename_maybe_null,to_name)(to_pathname, uflags);
 	if (!to_name && to_dfd >= 0) {
 		CLASS(fd_raw, f_to)(to_dfd);
 		if (fd_empty(f_to))
@@ -4448,7 +4446,7 @@ SYSCALL_DEFINE5(move_mount,
 	if (flags & MOVE_MOUNT_F_EMPTY_PATH)
 		uflags = AT_EMPTY_PATH;
 
-	from_name = getname_maybe_null(from_pathname, uflags);
+	CLASS(filename_maybe_null,from_name)(from_pathname, uflags);
 	if (!from_name && from_dfd >= 0) {
 		CLASS(fd_raw, f_from)(from_dfd);
 		if (fd_empty(f_from))
-- 
2.47.3


