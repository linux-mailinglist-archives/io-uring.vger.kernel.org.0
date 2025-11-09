Return-Path: <io-uring+bounces-10465-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F428C4393C
	for <lists+io-uring@lfdr.de>; Sun, 09 Nov 2025 07:37:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 61F2F4E13A4
	for <lists+io-uring@lfdr.de>; Sun,  9 Nov 2025 06:37:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B1EE242D91;
	Sun,  9 Nov 2025 06:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="wRBujgxm"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F1D1C5D7D;
	Sun,  9 Nov 2025 06:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762670270; cv=none; b=foDywCkeqg/To8d+BfcxBAiGjbniKW6Bop/n2HcHKFKhA1qCvB7BRz6tOGEibwaxZxsE2G1VZrrxIS4ST89hVIumuFIk9AW4F0WsSM/PtorKtts79Cf6O/iEn7XHcs2ilys6hXlcZx1lGCP41CmAocA2QfswoKRXLpo7aMzLjlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762670270; c=relaxed/simple;
	bh=5MEqgjhpmzI29H1uV/1SQLwXuo398WOo5iQ8G4kZTTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IAoA9zbfe3RcAA7uU/DoiRR1aXiWVn3i8ZIa0hM9vTbZVZncHJ7ijO7eXMOUXWKZLR+gz+4cIozxlb/7kP8Y7uDi8ZUckSRpozBb2ewnumLaUD801BbDsea4czvZykUKWjy6v0j6uF5jRNXhSgywz9jBYmuMQzscgDlz2YakGn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=wRBujgxm; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=H3lRaX9hzJYaGyPHgtEsqC7lsKDUGMd09oess7PslzA=; b=wRBujgxmD+7Nj7zqiunCbeNK6m
	4ZfGkuiyFSAr/eJNo7V+t5OQDOGnsSicKcqxZav7DPEqCGf5oqgu6q+KtiGEOF80+vjo9Eku6oZrO
	UzQW8ZBVCTXnVECl+Ksz589nedh+mbB8Nfo4BxKKHS41ml7zV33j9gkOEVj1ldPtWmdLYyGUfuvRj
	YMJENNhilRzhxRg90GXj2qgE3VVU+Lg2++MEooS03azE33EzzQHqjLU9hVnZY8I6YAV+fSC3dCLYT
	4TXLrVgP+DxLO6WHZt5+pi3D+Gpoih5tIGMQD9Fmx8k/HxQgQrBCLowWUrrHkDrBenXZxsc5p7eIb
	cAHXO0NQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vHz3a-00000008lc7-1zU4;
	Sun, 09 Nov 2025 06:37:46 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	mjguzik@gmail.com,
	paul@paul-moore.com,
	axboe@kernel.dk,
	audit@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [RFC][PATCH 07/13] user_statfs(): import pathname only once
Date: Sun,  9 Nov 2025 06:37:39 +0000
Message-ID: <20251109063745.2089578-8-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

Convert the user_path_at() call inside a retry loop into getname_flags() +
filename_lookup() + putname() and leave only filename_lookup() inside
the loop.

In this case we never pass LOOKUP_EMPTY, so getname_flags() is equivalent
to plain getname().

The things could be further simplified by use of cleanup.h stuff, but
let's not clutter the patch with that.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/statfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/statfs.c b/fs/statfs.c
index a45ac85e6048..a5671bf6c7f0 100644
--- a/fs/statfs.c
+++ b/fs/statfs.c
@@ -99,8 +99,9 @@ int user_statfs(const char __user *pathname, struct kstatfs *st)
 	struct path path;
 	int error;
 	unsigned int lookup_flags = LOOKUP_FOLLOW|LOOKUP_AUTOMOUNT;
+	struct filename *name = getname(pathname);
 retry:
-	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
+	error = filename_lookup(AT_FDCWD, name, lookup_flags, &path, NULL);
 	if (!error) {
 		error = vfs_statfs(&path, st);
 		path_put(&path);
@@ -109,6 +110,7 @@ int user_statfs(const char __user *pathname, struct kstatfs *st)
 			goto retry;
 		}
 	}
+	putname(name);
 	return error;
 }
 
-- 
2.47.3


