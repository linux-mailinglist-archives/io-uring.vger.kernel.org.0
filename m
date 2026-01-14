Return-Path: <io-uring+bounces-11689-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id ECA45D1C69B
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:38:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3D04830C3C7B
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FB5E331A66;
	Wed, 14 Jan 2026 04:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="HUfBs9lK"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BECC32695B;
	Wed, 14 Jan 2026 04:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365121; cv=none; b=V1gqQJMPUF4xXrxpUAjO6eswSLt3UkHk+PABbLgRIe8TJBK47kitmc3I7q8Wxvnls2F0HT3APGc8fNrQxHtvQgmpvg2aFWCcKWZAsFZHTvkCF6xYM5A3sDgoqnpQ40B4c+JOpdcJI2R+GRz65IhXJmpPpDtAnD0U/dDpxGRkJ6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365121; c=relaxed/simple;
	bh=nTHKXw8UwcLMJ53XI29POh8UPZpmRIfzCZ6jAwlP48s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITCmaLyvSQhuX2wnBpCJ7n9tnFCFEpTgu7WmCZ3r8sJWFq1vqgJx+Y48as7ml5+y9074SLyuU65zsXCWqq5UB+F0MRNJMGpzRqNNsn5Uei4YKk0E1/CQP0G07CpGmCkR3J4lFxc/fReSou2N+AhdZ0LqEMBfn9fxHwGv9KXRKKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=HUfBs9lK; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FD17jUCcWuTCEQI03eM0GnSRloJ9zIEZc4eT9v4ubz4=; b=HUfBs9lKvM/kJt/9kxrY4QErYn
	UPJZcRT0qr90jAtOrroNRZKtdHS/d4WyaGAvw6vPLov6CzwRV9JJyFxq39NZsSRUb2pRz9BXkcaeI
	5PNhYprY8ZNsCLEYigNYdoOOBwrmRMXcoocLcM6bL/7PIh3Atr4660/pSTanrBD95o+pGAlCidfYg
	bpeqV18iFKoS+/wJj5F/g7Gfn2NNKcElULFLgp+0ycFyEMEgZbJYbLT8+f++3kiiWMOfgAQZygC7R
	GmH8MkyJ4Xq4C0guBT2HMfQtFUHMsIL4xd0lBEFplBB8zifIiKwo7gKz2kMdexVk8VZN6q1+044P+
	g3Xb3uBQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZN-0000000GIzB-1XEQ;
	Wed, 14 Jan 2026 04:33:21 +0000
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
Subject: [PATCH v5 60/68] move_mount(2): switch to CLASS(filename_maybe_null)
Date: Wed, 14 Jan 2026 04:33:02 +0000
Message-ID: <20260114043310.3885463-61-viro@zeniv.linux.org.uk>
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


