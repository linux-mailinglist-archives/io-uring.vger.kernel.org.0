Return-Path: <io-uring+bounces-11108-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 49C12CC0D2C
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 05:01:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 791AF303EA34
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:56:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C8E532B9BC;
	Tue, 16 Dec 2025 03:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="kg9UCy+h"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45AE31283F;
	Tue, 16 Dec 2025 03:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857298; cv=none; b=Y9lVc9pVkfHGmWLUKorwZWSAyODP44rWyy/NTk6Sdoz7G4WKkKXEbTxVn4LfNCF1xu1NUqTgMRiXi3w7SMal4gEyb6Wvr+niNzb50GnczJpjCXon7Rrat+4QcOjze+pnEQw5ibvl/eKqOiBo86etNM6gJnzMHuBlui43weWP0s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857298; c=relaxed/simple;
	bh=lUNdt9aHq9kzNNWp8Kylraqjc+Cf9GYejJrl9RAZwDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBGDhAcD6gxihxRQuuRTVMATeHc6Hcq95DIyCwFfE9LA5UpbD+bMgqsBnJvbwUoz59uFnlTtfRLt7/2foGnecAAJe91xhycIUpMD+x+r6mdBhwFjjJSlPhM/v12sI3Y+hrYV4qUjoqejtyF2ll9XMwYD7Al6OGu0qq6w1WRebFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=kg9UCy+h; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZIlG9KS8Rwh0aHQ/9boEXA29Zfm9oooDLZyOQ0XaJCE=; b=kg9UCy+hJmC9TF5h75L+KC/uQf
	vA3ZCL/9NpnGCFUBOQEIpSTihFSVQjFN5DzZLTuFnkqnRS+PKzw8LXP9GwlGkUGccDjTULZOB+k1X
	dBXkM623iRAaZH17GyDzzEFaCp7qlI1/qiV/udpEzwz8RNg/1spoh/xF5khUfMK5jNK4C/GbNEtXP
	y47bkcEyOcfeEhCFvv4GJjsK+YQjIOqlZaoNQS4qb/X9HuLaJMlB0X1/TEpNGHOR3t+TRcv96Dr97
	hvusTQeqWCyq9M8fk4T688oKUVRBqlf/DA2aXlfZwEvkgK3smwJ7/0MI+DZPJAupnW/4lg9g/rtEu
	ArO56LKQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9h-0000000GwL7-3C1Z;
	Tue, 16 Dec 2025 03:55:21 +0000
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
Subject: [RFC PATCH v3 32/59] file_[gs]etattr(2): switch to CLASS(filename_maybe_null)
Date: Tue, 16 Dec 2025 03:54:51 +0000
Message-ID: <20251216035518.4037331-33-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216035518.4037331-1-viro@zeniv.linux.org.uk>
References: <20251216035518.4037331-1-viro@zeniv.linux.org.uk>
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
 fs/file_attr.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index 915e9a40cd42..b547161be742 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -372,7 +372,6 @@ SYSCALL_DEFINE5(file_getattr, int, dfd, const char __user *, filename,
 		unsigned int, at_flags)
 {
 	struct path filepath __free(path_put) = {};
-	struct filename *name __free(putname) = NULL;
 	unsigned int lookup_flags = 0;
 	struct file_attr fattr;
 	struct file_kattr fa;
@@ -393,7 +392,7 @@ SYSCALL_DEFINE5(file_getattr, int, dfd, const char __user *, filename,
 	if (usize < FILE_ATTR_SIZE_VER0)
 		return -EINVAL;
 
-	name = getname_maybe_null(filename, at_flags);
+	CLASS(filename_maybe_null, name)(filename, at_flags);
 	if (!name && dfd >= 0) {
 		CLASS(fd, f)(dfd);
 		if (fd_empty(f))
@@ -426,7 +425,6 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const char __user *, filename,
 		unsigned int, at_flags)
 {
 	struct path filepath __free(path_put) = {};
-	struct filename *name __free(putname) = NULL;
 	unsigned int lookup_flags = 0;
 	struct file_attr fattr;
 	struct file_kattr fa;
@@ -456,7 +454,7 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const char __user *, filename,
 	if (error)
 		return error;
 
-	name = getname_maybe_null(filename, at_flags);
+	CLASS(filename_maybe_null, name)(filename, at_flags);
 	if (!name && dfd >= 0) {
 		CLASS(fd, f)(dfd);
 		if (fd_empty(f))
-- 
2.47.3


