Return-Path: <io-uring+bounces-11642-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 70181D1C5C9
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:33:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D61483063907
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 724B931ED89;
	Wed, 14 Jan 2026 04:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="vFXQVmd0"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6072E1EE7;
	Wed, 14 Jan 2026 04:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365114; cv=none; b=F7t+mvWOyS79795cg29Z6uCMA2dBx51J+q4cxM0LEsJoZaa9sW2y7pkHXSOXzIJb4Lgh7pM/BrCPq7Fb8a6o/VR2DN7FcfbIHMQhNB1uNtK6THJsrh0wHJOE7fMoR09O+Tsb8/3mQjYsm0Vvj9FLq7MKFB1YRd3KlGUusYIvy5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365114; c=relaxed/simple;
	bh=xKaH/NZFW5DN3VJir82hEz4CpporN5Oy57a9aSeWAFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jE2ti8iBQY2N8HgQ7RYw8j6kbRGAwVtfnE5nVnRJ1WGLFBjfd/9gF3vbzmZjFOyxbYCPXdr+dsnK/oQLII3jWOhM5vRD+/HqDoocPg/KBV9SDZb1Ca4nXCnQALW27Yg4VX5X0q04yFugEAUM4YSH0mBGgHZnu8xj0A86ZPBqgYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=vFXQVmd0; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gaYRFNRfoRssLh/Ga6RL0HdpHSyeDiJIvDb89vnXUNo=; b=vFXQVmd0qkv6J5Ez2WjTVeS+4O
	6JUC+YLswCAyV84l/NbUYCf6WlMJolyGYBJE3i8XyLWgDhGpsEYCTtFnFnRk+3FiptGh+QOEXCwjp
	GcnP5O7jF2p8i9EU5DXsxBgPrqvbZyLVgf2FrGYxi06NS0/MmqJYQMDNrS5SrzYhdTsUPuibiR+dX
	0XlIsCOPzZXgYdi8Wygb8gPy0RumI+UyOq/RarprYfNfmNVMMbC6PsXIOfayNe5Mi8mCNSBxVMTog
	rTLog7DWwYCtBYFo6nqlH9WTXs7jRT1U2zac6cxNtVaxHf1AWJTiGpL3KCXeJmmz8AxTDhistP8Iq
	50W7wZ8A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZG-0000000GIoK-1xAK;
	Wed, 14 Jan 2026 04:33:14 +0000
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
Subject: [PATCH v5 32/68] do_sys_openat2(): get rid of useless check, switch to CLASS(filename)
Date: Wed, 14 Jan 2026 04:32:34 +0000
Message-ID: <20260114043310.3885463-33-viro@zeniv.linux.org.uk>
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

do_file_open() will do the right thing when given ERR_PTR() as name...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/open.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 3d2e2a2554c5..ac8dedea8daf 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1425,18 +1425,12 @@ static int do_sys_openat2(int dfd, const char __user *filename,
 			  struct open_how *how)
 {
 	struct open_flags op;
-	struct filename *tmp __free(putname) = NULL;
-	int err;
-
-	err = build_open_flags(how, &op);
+	int err = build_open_flags(how, &op);
 	if (unlikely(err))
 		return err;
 
-	tmp = getname(filename);
-	if (IS_ERR(tmp))
-		return PTR_ERR(tmp);
-
-	return FD_ADD(how->flags, do_file_open(dfd, tmp, &op));
+	CLASS(filename, name)(filename);
+	return FD_ADD(how->flags, do_file_open(dfd, name, &op));
 }
 
 int do_sys_open(int dfd, const char __user *filename, int flags, umode_t mode)
-- 
2.47.3


