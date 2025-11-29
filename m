Return-Path: <io-uring+bounces-10846-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA28EC9454F
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 18:04:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E80ED3A96E5
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 17:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9ED13101BF;
	Sat, 29 Nov 2025 17:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="EbLV4j2w"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C6F21B9F5;
	Sat, 29 Nov 2025 17:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764435701; cv=none; b=pevWmZmMkH1llh3HC+0G9NeoL9iVcUDNmoqdNxBOaj4EcQV1ca+vdBeYIjbqBfN4oZYh8yG4ziP6HS3r3tdw3iQN5CiJhUQdBAfq8wbcw5LXwLUKSSkZAOeFUA2afBW+XtFprClF1DA3cm3Lgknw29CaEptNq8xU34RvuAHB2U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764435701; c=relaxed/simple;
	bh=5MEqgjhpmzI29H1uV/1SQLwXuo398WOo5iQ8G4kZTTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqfLsDz5DiZfVk4Gaax++s/BSNFyo+lBh8UOO/YjH+g3JCNkCRBaDoCxbCKY3MCGNR7BWLrOEZyys9UZJQlqH9se/gPl2vwYLRW9f8H95tS4/RG6BBG9b9MsGS6FcNYHgYKZWSKpv/ZsKMRUg7Iy6C8YLLaYn9H2jk5qUCVyjqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=EbLV4j2w; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=H3lRaX9hzJYaGyPHgtEsqC7lsKDUGMd09oess7PslzA=; b=EbLV4j2wHiPdm2oxFIPQEEe8ec
	SMImfh84nga+rPtR9dA+q1ROHlKTQaT4j8wndS7R55iCwvNvYF1tlzKuccRLrIWJDqvC4U1Ojoh6p
	OQ3Qd5BmjDE+VWWpS51kayh4oZub0mApHzgBBxqahQJybBVJu/Oxt0IWrjtOl+dAnYWmSBrsutwD5
	GZMJ4B/HlvmUqaZGKQ3F5n9/Jntcva/UwXhI0eTIfVp+AmlTe1A5bLkvxOHEg4TiQzAuARl6E19JP
	RkALaaX282ipKE3hk5sHds8M/XL2E6HKDpbM8a7G42BufjdENYN2LvFXeLBD/TbcY+LXgq6uBPiY1
	ljqW0rYw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vPOKN-00000000dCk-1Ft0;
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
Subject: [RFC PATCH v2 07/18] user_statfs(): import pathname only once
Date: Sat, 29 Nov 2025 17:01:31 +0000
Message-ID: <20251129170142.150639-8-viro@zeniv.linux.org.uk>
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


