Return-Path: <io-uring+bounces-11486-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 229C5D017B6
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:59:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 88BCB3003BFC
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:54:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B13EE34402B;
	Thu,  8 Jan 2026 07:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="HLtqzkhs"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4AE31D399;
	Thu,  8 Jan 2026 07:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857821; cv=none; b=F+YZXMXyt3oNC4z7UmTR+cB6UCtDGjJvqx2m3Lq/hxvNum6yuEGGdyE2RtqizAQ00rKc3FYu4Gr3xuz6IADLCnRF5/I4YJ8i0A8gWpPQSNaqVc2HTtgVCBrBSlAJpQRgT35nuF33UWssLkClDjHh225oUFyT39BiMtKrWplIzoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857821; c=relaxed/simple;
	bh=ZQKnnJ+DT/olw6Lm8LfztDzd27NRaCqPT+q4vUOkjL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kCpOs/QJDRuF3i/GVZtV/4ZRYB6pL9VENY8tmEh1mC3BJrKExeh+A0u/tCrK1tAUP0fZX1ZdelfyLRvcgSCU9XGAttWrnQafJi03JEhBHUUXfeXE7ACKY8WoA6INZ7INCF9Yy93E2+Zd8xYnvYBOK1c7raTnfcgQjNxqom+prEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=HLtqzkhs; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6hUHHzqGq4rboHjLsjdGtX8PCDDP5BU01+h08kclRhg=; b=HLtqzkhsyJ4Ynir+iyKsOqjDRu
	CAXUGjtb5qZhCXBASe7AkK+gcYXhhugStTpT1yVzQrmqDzO9rxIY1u8UWFjQ9IkNujYZC2wRX5Bbi
	QIquMpDEU8fxGmU6DEAEb7BQ/fnL8gMT1lPzf77CiGsaBmLUtlYCH4bbapp/EBa64oxIZyJcYa5RO
	GSOw7jLghi4Wc41Tk1maY4MNlq0u2BJurdEcYDG6nPew40brpSgl1rn3PLkMq5HK732zaPsREmbpM
	9y01z/4SHx6h2ApVOE7BUgyOZQfU4xeKzD03S6s3gjFZ5ZHCeme9EiDvA5+Q1hEdGqQtRzPmKcxeE
	z7vvmVkQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkay-00000001ms0-25OW;
	Thu, 08 Jan 2026 07:38:12 +0000
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
Subject: [PATCH v4 43/59] do_readlinkat(): switch to CLASS(filename_flags)
Date: Thu,  8 Jan 2026 07:37:47 +0000
Message-ID: <20260108073803.425343-44-viro@zeniv.linux.org.uk>
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


