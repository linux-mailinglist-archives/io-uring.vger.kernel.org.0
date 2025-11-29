Return-Path: <io-uring+bounces-10841-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18D04C9452E
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 18:03:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 184113A8DAC
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 17:01:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 510CA27F010;
	Sat, 29 Nov 2025 17:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="JZiVzC1Y"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D7122256F;
	Sat, 29 Nov 2025 17:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764435700; cv=none; b=o553D3VP8dCU2KfmyYqMBVcTAVTCqV4k1zjDZ93jY+iLyGjUlgKkt3aUvrDn62r6VFu1KUq0ljp72LhM+iDyfLLIbffWvkqfTWUc4rfFImmwI3CeIyDhS2NrXyYmEJs/hznZEqug8QKxgES20cLjIVywA3JNlORr2u3AVQ3j6Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764435700; c=relaxed/simple;
	bh=sMpauPvEJwGDtLBQG/iTx+xTGPghb3my1NHgM/6j9G0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBRJwf8rUcjhMYp/S1pCvdir6pddWGMKCfaWNnxd58rLYztfkk34w+yMsp0BgxkZ7LQ7yGoIwutu2Lx2GzUHIcnD3U5CcjH8JTaeANao1LkJigW9pF3n9NZpSjCTONc5QPZxSQIMKp2/vTh3k75qn40d/FhpEo6IVjAIwUSomOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=JZiVzC1Y; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=r9RneWoJ2ADclp4gzk9Ex1aEKHWv5hbsuogQp9Vg4tc=; b=JZiVzC1YQ5ZtbWkvVJyWckoe8D
	v4duQNuRxeqpdWE+GlIfYMLFeY3KsFhZvHUMS6U3Q4ImEeW/L9idIM8Brt9J6+cao7jadIOIfqCU9
	ArrMaznFn++eguNf1Tyz3z7+qPKh1iOW79+S0tKzmwntyBuU+i+hKgHB3TV0uZ+HKonUmOhfewkta
	acN4iazrtDy0/EHLVEh2NezCmL+jkTTAzUGSiZUESFo361sBgWI2uCRxwDWYX7poXc+kqj4DGroV3
	9TxS8Rmd2+9F4DFSXvKZQsL8GAi1rkksQDmcktNa2vYPf69NikVFG/un6YZqBgSkV+imk+V7ATQms
	Lxq+BtOw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vPOKN-00000000dCq-1gjg;
	Sat, 29 Nov 2025 17:01:43 +0000
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
Subject: [RFC PATCH v2 08/18] do_sys_truncate(): import pathname only once
Date: Sat, 29 Nov 2025 17:01:32 +0000
Message-ID: <20251129170142.150639-9-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251129170142.150639-1-viro@zeniv.linux.org.uk>
References: <20251129170142.150639-1-viro@zeniv.linux.org.uk>
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
 fs/open.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/open.c b/fs/open.c
index e67baae339fc..eb2ff940393d 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -129,14 +129,16 @@ EXPORT_SYMBOL_GPL(vfs_truncate);
 int do_sys_truncate(const char __user *pathname, loff_t length)
 {
 	unsigned int lookup_flags = LOOKUP_FOLLOW;
+	struct filename *name;
 	struct path path;
 	int error;
 
 	if (length < 0)	/* sorry, but loff_t says... */
 		return -EINVAL;
 
+	name = getname(pathname);
 retry:
-	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
+	error = filename_lookup(AT_FDCWD, name, lookup_flags, &path, NULL);
 	if (!error) {
 		error = vfs_truncate(&path, length);
 		path_put(&path);
@@ -145,6 +147,7 @@ int do_sys_truncate(const char __user *pathname, loff_t length)
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
+	putname(name);
 	return error;
 }
 
-- 
2.47.3


