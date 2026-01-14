Return-Path: <io-uring+bounces-11655-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A0B6D1C5FC
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:35:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3EE343080086
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77AA832A3C6;
	Wed, 14 Jan 2026 04:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="Eyx6zVtK"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2152E6CCE;
	Wed, 14 Jan 2026 04:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365116; cv=none; b=eWDDV6GqBxKI5CvstG5rUWjdICOlrT0M0m0B2j6RE0oFn1JxlJSnj4/g31/FiaH6Zxn5Jw2twSlv22x6bAD3VsGl1hP7r3BOWUGz4UrYpllp170fEle0u2lsYpNsuUeXKvOS9doWmBfvY5JgUm5zo5xeTNINLlE30moIfOa3VI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365116; c=relaxed/simple;
	bh=zFlDLU2alFVD/MwuTFbdq6QS587tb9atKC26F68cFjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6pXPp0Su4EK2mdU24qs5r/KQTccRnleQ4fdQreIu9JKDVIGIj3OGFSE9c7IVj2LMrYwZQJXqx5+OnSkmS2AD/0VrORr3GLVwkthuraeI4XEfdFLy7qqBHWvELpCgrofY3irehmFs+LYPjRJTfgoGMhbflaw/2XLRNvEelRdYzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=Eyx6zVtK; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=KE0bqgoAYg4WN/vY/qas7LhrImQSJi8EcGd+/Tk2T7o=; b=Eyx6zVtKeC1a57zZ4GuXLtCX6+
	ryIKdXV4Zy4+RL9CC9blHZX1gcOlwbBCLLjRCe1kOQD2vTab9wVNwmVbXopbUxSqsaJsQLwkz1uDj
	AxBJt2/xPhe7wo7usLRyWK1UAjIO2CdLkNtJHgRRZI5WN2iUGt/FWVYFHVMzwTpwVIFRDtlurBMhm
	4re+osGD+D1DzSnWVsA0Ou/+cqvt+dGTaj3UrKxqvVCEOxcfuBar/vxPWz51jshJAnrq48H5Z4D+u
	9ARmmL6XCCx1NW4sgQ6zKCUHfz4cEWKuXGgTKuALneABEuFQvcDSgerjCEMd+0Fj8E4ebW5tBdvu0
	OBVHwhhw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZE-0000000GInT-04wO;
	Wed, 14 Jan 2026 04:33:12 +0000
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
Subject: [PATCH v5 13/68] do_sys_truncate(): import pathname only once
Date: Wed, 14 Jan 2026 04:32:15 +0000
Message-ID: <20260114043310.3885463-14-viro@zeniv.linux.org.uk>
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
index 6f48fa9c756a..2fea68991d42 100644
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


