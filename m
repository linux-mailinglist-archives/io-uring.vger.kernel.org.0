Return-Path: <io-uring+bounces-10838-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 63070C944D7
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 18:01:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BDC204E2FF1
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 17:01:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A653F23C506;
	Sat, 29 Nov 2025 17:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="KRHbLSu0"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3341122F177;
	Sat, 29 Nov 2025 17:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764435699; cv=none; b=uvXrcj9beO6ZuNt+pOngGjq/the1uNGxA+l5oH0z8Ppx1HOFMqLXzgE8Cp9pcHOorkyXGBuru3B/1mE3ADl6XKEnZ1JLU4ZW3nuSHcQqvD9Bmex5AZ52GfDX512ep6Un81WmMstxrbwPT3pNz9IZkf+UN1753sjqidh1SmkEOTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764435699; c=relaxed/simple;
	bh=AnXuVmtBPsHyGrokjaBHTnHhzkPSnaPaZH780cS99cY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nj0XO6Lt62CrRBChMUlH7j9KMN8Dtw42uW5appCPXpPbqfCoDIZQkZUHW7ESh5rxugeO5mcdZSeo1299rJZGMlq3HfRLRLNLdWqeXBhIvFjbz8cUFF7F5C1YFBaWW16gmFYy0iURyrNvCerocJkLFdgBT9QGhNMeOEdupm0WaqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=KRHbLSu0; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=D5SfB8HXXA8HDhHotZ8aOqBYp6gM9fz+fE+tuhltnxM=; b=KRHbLSu0dKZbQIvmwVI4hw6tOl
	X7XvW7IAeK04adeYGAjh7bFQD0d+ioWSRa+Merue10z/KL8mXShBAm3YIs0aAm1Kxxtg4ibHO44Wc
	jJBFbOi1bmRGzn6EupWoLB2RjwDeRMAxo0aHZK7E5FHvb+E45PLyVqJIK9kIV/7MwFLtHxcFZAvkK
	4kmEL1e+ONAKmJwMaarYttXu1PXVjh+Kp2mTbC4fhI/piB04CHO+DjyTcnXK1f29uYbyMP0eKysF2
	UdC/ySp0ZtR4tGaTNb5//gEB96nBP7Gy5z7y2dh4j1Uvddcz4mgjmeJV4aoFI7o5BQ+csEVG81J47
	iEc+Kokg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vPOKN-00000000dCZ-0ewp;
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
Subject: [RFC PATCH v2 05/18] chdir(2): import pathname only once
Date: Sat, 29 Nov 2025 17:01:29 +0000
Message-ID: <20251129170142.150639-6-viro@zeniv.linux.org.uk>
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
 fs/open.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/open.c b/fs/open.c
index e5110f5e80c7..8bc2f313f4a9 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -558,8 +558,9 @@ SYSCALL_DEFINE1(chdir, const char __user *, filename)
 	struct path path;
 	int error;
 	unsigned int lookup_flags = LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
+	struct filename *name = getname(filename);
 retry:
-	error = user_path_at(AT_FDCWD, filename, lookup_flags, &path);
+	error = filename_lookup(AT_FDCWD, name, lookup_flags, &path, NULL);
 	if (error)
 		goto out;
 
@@ -576,6 +577,7 @@ SYSCALL_DEFINE1(chdir, const char __user *, filename)
 		goto retry;
 	}
 out:
+	putname(name);
 	return error;
 }
 
-- 
2.47.3


