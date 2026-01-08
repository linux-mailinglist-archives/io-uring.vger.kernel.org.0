Return-Path: <io-uring+bounces-11451-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 581DDD0169C
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:37:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6CBFE30010F6
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:37:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B5B93314D9;
	Thu,  8 Jan 2026 07:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="A2V/0dSN"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6BB318BBE;
	Thu,  8 Jan 2026 07:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857812; cv=none; b=J887rAqJOpTu0sTKXrXuRJU3/sJkl5Te4S4F7Nx8gy69m35zF31UkxmfQwYGK5lPxUcojMLiw2PZwkgRSMlqmf8SMFVPOJp2HSJY+mWTdblME24G8s0W9zC+2Vz5Lnz5EJkpMwH96Lzj6KZ+ksv0qClVQV4y/Y1zeEtpZZ2QbVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857812; c=relaxed/simple;
	bh=S4VYrqztxn3qx2+ce8nOumRfGqsXr/vKT8X35BxAw9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+0ofh3HvQeDqQgiAIv1qi2JfHKHdjR4RH5EFJEvNcjS68kM6L2+gOjxIczcqBCTBGWKDhbTC4DEBrNEeV3LJaVNPrIKcoi4FPbpaWg9eauwAsAdWKulstgOi2wagvpzseddZAVk1/Gr/Rh/C2mnMqTyUP0QA+CVsRMeqc1qQ0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=A2V/0dSN; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mxa3cbqR5z2NPq9lAeRLIRLOjiQkAso1d9Wu9XUX5zE=; b=A2V/0dSNFuEtNFTPwFXk+8UjfF
	UEpt6xoZd7ht7T6wuEST8L6/F+15dbriC3v1USrJb5p73F1SdmY3cLaN/gJgtXSvX1QZe4p7Lso6Z
	3BJAC9LQV+tsqaH6/0hhZ7Bcrh3HRumPR8nYcH9kzkTIKjsSA7ShsEXpDpBDu+PBeS1VX8P3uLnrJ
	XxjMFLvMb2Vu8gh8EVr/heZDPGzHLDEfD4BEWgWk9iOIN8RBUNApBbgFHpGlDlfFxx9SA8XgY+7nd
	f/+6y1112boG9KhjobHj/TY1oTm7+1sVYHCXrbPzty3o/Y0/+jsCPGz3+yqXKPd0Bl3LIlJt4or/X
	PXaA+XJQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkar-00000001mgt-0pML;
	Thu, 08 Jan 2026 07:38:05 +0000
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
Subject: [PATCH v4 12/59] getname_flags() massage, part 1
Date: Thu,  8 Jan 2026 07:37:16 +0000
Message-ID: <20260108073803.425343-13-viro@zeniv.linux.org.uk>
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

In case of long name don't reread what we'd already copied.
memmove() it instead.  That avoids the possibility of ending
up with empty name there and the need to look at the flags
on the slow path.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index f22cfdff72ab..ea7efbddc7f4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -174,36 +174,35 @@ getname_flags(const char __user *filename, int flags)
 	 */
 	if (unlikely(len == EMBEDDED_NAME_MAX)) {
 		const size_t size = offsetof(struct filename, iname[1]);
-		kname = (char *)result;
+		struct filename *p;
 
 		/*
 		 * size is chosen that way we to guarantee that
 		 * result->iname[0] is within the same object and that
 		 * kname can't be equal to result->iname, no matter what.
 		 */
-		result = kzalloc(size, GFP_KERNEL);
-		if (unlikely(!result)) {
-			__putname(kname);
+		p = kzalloc(size, GFP_KERNEL);
+		if (unlikely(!p)) {
+			__putname(result);
 			return ERR_PTR(-ENOMEM);
 		}
-		result->name = kname;
-		len = strncpy_from_user(kname, filename, PATH_MAX);
+		memmove(result, &result->iname, EMBEDDED_NAME_MAX);
+		kname = (char *)result;
+		p->name = kname;
+		len = strncpy_from_user(kname + EMBEDDED_NAME_MAX,
+					filename + EMBEDDED_NAME_MAX,
+					PATH_MAX - EMBEDDED_NAME_MAX);
 		if (unlikely(len < 0)) {
-			__putname(kname);
-			kfree(result);
+			kfree(p);
+			__putname(result);
 			return ERR_PTR(len);
 		}
-		/* The empty path is special. */
-		if (unlikely(!len) && !(flags & LOOKUP_EMPTY)) {
-			__putname(kname);
-			kfree(result);
-			return ERR_PTR(-ENOENT);
-		}
-		if (unlikely(len == PATH_MAX)) {
-			__putname(kname);
-			kfree(result);
+		if (unlikely(len == PATH_MAX - EMBEDDED_NAME_MAX)) {
+			kfree(p);
+			__putname(result);
 			return ERR_PTR(-ENAMETOOLONG);
 		}
+		result = p;
 	}
 	initname(result);
 	audit_getname(result);
-- 
2.47.3


