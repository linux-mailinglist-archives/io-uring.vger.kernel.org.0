Return-Path: <io-uring+bounces-11664-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 32115D1C620
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:36:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5CBD53094F47
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0004C32C929;
	Wed, 14 Jan 2026 04:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="ZXIEwLqM"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21A82D73A6;
	Wed, 14 Jan 2026 04:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365117; cv=none; b=qB3hb9elJZT0XhRNulg77JxblYh6N/r+bhzCxP1rPLah+2a1CMp2fZRdIfXJWW/byYuGrOire9spMZyY6l+dz6FcjBVKaQ5/5YZbLeKQn8HYzSeeufJVtvaodUU+J0R0RoTW7kEAiyG6gqCKVXQzuewKB8Rr1X48U02FfPXX+yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365117; c=relaxed/simple;
	bh=II4Jd1KayzSu2stxBC7ry6BC6NM93imrG4s5Ru4XzRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0CpH1etsIs+ttHfHgGuXXpEmsFoFfGxNf4Vw9dzx073eDqV3oQX597GhTG1kA7m6i1w0+E8rJbTAL5uM3UoUm+nv3F8llQxWP+I7VUy4doVsFNnV+koUW5WWmecKXXuWYhGTY1YrY0C5qCOg9BsKUVSNojuFRID6wiXrvhhygA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=ZXIEwLqM; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NWFscm8Ml2vJyvKBphRWn8KIV03jpnxcc61yG5p5SAY=; b=ZXIEwLqMKdy6sb2gEW8WyByLTK
	ZEEwvOwNNdinopg3GjsvsjGTcCSfubVxyxFbstC41gP8DX3QpMtvrkO1xuh5RiZXS0UZr0BeyPDKg
	CxJQETWQKzwWcCWpG8NhCPkCPg6H/eODv2lCxon4rp6uh6OzsTpWJ9mqkbsqRJwqIiV8S1WzRJGdJ
	38sSYGSIHjkiMYrGo801YlDACaM50Izxk5D+I8EZEPaPFB+JWkY/PCqXhEfkq7+hlMpaJEtvKA9t7
	WJFjHH0CPvp/BILRU9gVNQxH3SerKTjYSL2ISzl9WQxrfZMuvrTHn0GdseFjb02iqBUpxLTcBjMej
	C5z5Uvyg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZF-0000000GInn-19Wu;
	Wed, 14 Jan 2026 04:33:13 +0000
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
Subject: [PATCH v5 22/68] switch __getname_maybe_null() to CLASS(filename_flags)
Date: Wed, 14 Jan 2026 04:32:24 +0000
Message-ID: <20260114043310.3885463-23-viro@zeniv.linux.org.uk>
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
 fs/namei.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 06d60808b0ff..f1a2161bd691 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -227,7 +227,6 @@ struct filename *getname_uflags(const char __user *filename, int uflags)
 
 struct filename *__getname_maybe_null(const char __user *pathname)
 {
-	struct filename *name;
 	char c;
 
 	/* try to save on allocations; loss on um, though */
@@ -236,12 +235,11 @@ struct filename *__getname_maybe_null(const char __user *pathname)
 	if (!c)
 		return NULL;
 
-	name = getname_flags(pathname, LOOKUP_EMPTY);
-	if (!IS_ERR(name) && !(name->name[0])) {
-		putname(name);
-		name = NULL;
-	}
-	return name;
+	CLASS(filename_flags, name)(pathname, LOOKUP_EMPTY);
+	/* empty pathname translates to NULL */
+	if (!IS_ERR(name) && !(name->name[0]))
+		return NULL;
+	return no_free_ptr(name);
 }
 
 struct filename *getname_kernel(const char * filename)
-- 
2.47.3


