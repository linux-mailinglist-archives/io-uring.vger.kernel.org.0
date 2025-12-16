Return-Path: <io-uring+bounces-11090-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9199BCC0C99
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:56:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 40F50305BFE0
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 012C13246F9;
	Tue, 16 Dec 2025 03:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="n6qxSoWI"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6D63128A3;
	Tue, 16 Dec 2025 03:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857296; cv=none; b=U4CKtTYsDGOfBxQR2Mmy9ZlJf+HZrFk3Iqa6ll+5TvbWjPe5J1tI23xg1tzDzdnghelBYpPQh8QcwdCPhpSIKXlFRcNEbr6uXCLs/8iESQGR2LMsg+EF8Sc8EhHe7ZIK6mio+5svTSPBPHAE8gfZ1LkGsC6AFK7/kOj0w3JWziM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857296; c=relaxed/simple;
	bh=ltTrYl7GN0DzsMvuK83DN/Ol0bNTuyKzVNTK64WoEE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHr4gMMPO//N6dPr5sEy06dGhu71vCTsKGuC4HNxoLN3oEcD7vFvoMsQD1NWranjV5c5uft3g747i0DSi50yVIfVTLG1rDq2I/4uWgGePWmmMLmy5pK9I8zU565GyW4M0P9eL5xTwgNrVNFONb757lntPtAPeNQ3dS+GtJL7gJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=n6qxSoWI; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qwJAhJsvJ2SJYlVcArGg+7WWNzPWS5syBQcg8iMXPSQ=; b=n6qxSoWItZefHBpqcxEMN1PCyO
	nSgD7OtiSg/FcQm9gKwYSA3n6Mxg8ywl+958p5JlQKppgkJg6igdhfYYJTc/caiKLAe/Fetz4UqoC
	vMbSicyLUdkBSZHErmh4S3La7mYEqvySWjCyDHOmcpKL9YdtbIxClxDNf2/HN4ulxX134zNjFnN9V
	bgZkKRHOU/rHnu2zJpxFKgyN+lxSSsc0gF4CkLdeJl7FngFhXKESfbaNers+ojr4k/gUamuXcFW8f
	OtzZeDp+01+9VXOBCPH+Edb7ACW+aB2COIvAZ9bZOqnq+G8m0DwLKC2apoS6X0o0PgU4CHy7/touu
	s1lf6Xng==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9h-0000000GwL9-3Zqa;
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
Subject: [RFC PATCH v3 33/59] mount_setattr(2): don't mess with LOOKUP_EMPTY
Date: Tue, 16 Dec 2025 03:54:52 +0000
Message-ID: <20251216035518.4037331-34-viro@zeniv.linux.org.uk>
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

just use CLASS(filename_uflags) + filename_lookup()

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namespace.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 9d0d8ed16264..d632180f9b1a 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4978,8 +4978,6 @@ SYSCALL_DEFINE5(mount_setattr, int, dfd, const char __user *, path,
 		lookup_flags &= ~LOOKUP_AUTOMOUNT;
 	if (flags & AT_SYMLINK_NOFOLLOW)
 		lookup_flags &= ~LOOKUP_FOLLOW;
-	if (flags & AT_EMPTY_PATH)
-		lookup_flags |= LOOKUP_EMPTY;
 
 	kattr = (struct mount_kattr) {
 		.lookup_flags	= lookup_flags,
@@ -4992,7 +4990,8 @@ SYSCALL_DEFINE5(mount_setattr, int, dfd, const char __user *, path,
 	if (err <= 0)
 		return err;
 
-	err = user_path_at(dfd, path, kattr.lookup_flags, &target);
+	CLASS(filename_uflags, name)(path, flags);
+	err = filename_lookup(dfd, name, kattr.lookup_flags, &target, NULL);
 	if (!err) {
 		err = do_mount_setattr(&target, &kattr);
 		path_put(&target);
-- 
2.47.3


