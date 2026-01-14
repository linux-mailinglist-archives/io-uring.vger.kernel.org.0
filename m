Return-Path: <io-uring+bounces-11680-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DCD4CD1C677
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:37:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5D8BC30B06BF
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6B8B330B2A;
	Wed, 14 Jan 2026 04:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="iaYxLbX6"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7E5314A76;
	Wed, 14 Jan 2026 04:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365119; cv=none; b=SA8XA3vC/TNCHr9wY4UwFuHOsOIx5X2EFQZWa8RJ8NBMv4gF+Un4nXtUEBRhSeL2dy8j0IMoOxfkgn3w5o7VCF0lY6PjucDfuX4H7b/FXrxJaaxf6q8xz6+L27TSohVj2BaJ7pP0BxI2VMvhAI3XxHptfhsAi0OPdDYjw7kQFFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365119; c=relaxed/simple;
	bh=ZQKnnJ+DT/olw6Lm8LfztDzd27NRaCqPT+q4vUOkjL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bq+zBE6/nt7XRY9VN1z9H5CAYqx4T7jsvT9+ySo5Azbd/nyHpYjxuLhdcUZf+bSaha1DOSiZReKWtz1yblUbZ/480dwt/cDzI5iJrviTSjiS53CrfIhTPqrWWnHYIPv8X8Zd09dpxR1IqK7k3S/VBS2lQSnKv7eQbA4fztMsFro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=iaYxLbX6; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6hUHHzqGq4rboHjLsjdGtX8PCDDP5BU01+h08kclRhg=; b=iaYxLbX6Jw+u11/tdoDO+SeNdn
	pmTwcEuXyT+yoKzAov3P0u9Tr6xqDBJ4ZTsD9Q4GrvwpKUNbCfLFyjJqdVCUuBR+y7WjHjz9cenjP
	IyBgV/JGsizCYcIz5Ow1mPM+OgyhblPkeX9omlglFNM5Rt+NLA7BhgvAbllkL2BppsUG/T6QrU0GX
	MwRO0g8oh7lRD+JNLJko2sFsNyEWg1YMGSU3+SyH6eMMWBJc6Ti/1WLswVgTGcxZyQcY0PCB5y2dH
	bUDE9uDQDM6ttTPCLstyYW/xqttWdNo4znWWjem85SccPKfNcPzAf6jVjQhiRK8raZebBA1SviQQF
	cKWcOHGA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZM-0000000GIxr-0gfy;
	Wed, 14 Jan 2026 04:33:20 +0000
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
Subject: [PATCH v5 55/68] do_readlinkat(): switch to CLASS(filename_flags)
Date: Wed, 14 Jan 2026 04:32:57 +0000
Message-ID: <20260114043310.3885463-56-viro@zeniv.linux.org.uk>
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
 fs/stat.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index ee9ae2c3273a..d18577f3688c 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -564,20 +564,17 @@ static int do_readlinkat(int dfd, const char __user *pathname,
 			 char __user *buf, int bufsiz)
 {
 	struct path path;
-	struct filename *name;
 	int error;
 	unsigned int lookup_flags = 0;
 
 	if (bufsiz <= 0)
 		return -EINVAL;
 
-	name = getname_flags(pathname, LOOKUP_EMPTY);
+	CLASS(filename_flags, name)(pathname, LOOKUP_EMPTY);
 retry:
 	error = filename_lookup(dfd, name, lookup_flags, &path, NULL);
-	if (unlikely(error)) {
-		putname(name);
+	if (unlikely(error))
 		return error;
-	}
 
 	/*
 	 * AFS mountpoints allow readlink(2) but are not symlinks
@@ -597,7 +594,6 @@ static int do_readlinkat(int dfd, const char __user *pathname,
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-	putname(name);
 	return error;
 }
 
-- 
2.47.3


