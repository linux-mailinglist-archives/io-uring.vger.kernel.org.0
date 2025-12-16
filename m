Return-Path: <io-uring+bounces-11072-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9642FCC0C60
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:55:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0675A301E99E
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 145EC319850;
	Tue, 16 Dec 2025 03:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="b8JvIdo9"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16562312824;
	Tue, 16 Dec 2025 03:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857294; cv=none; b=T2KshaqMSE8jL8SIJvXcynG7z3FPw6P5/++XBfBsw5ZwyRvewtFHLyaUzu9PmJV81LLWFPnwSBj2Rk8ugmAadob+A2CC9jAJktXHrfGlSwigq79DtB0+tDnx5ltdrVWXS635WNaVMySO/rRwDaeiABOiBmNOP1/z7VP/J5eZ3Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857294; c=relaxed/simple;
	bh=wKWJZZdbUbSwMoIn246Vmp9XLWPXndgTlWmmQPMekrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEbRKADZdXsqsC+7Nzi876GrQLmN9nAFQObY7ppatNNGIsexsEntl8Xs9AZa6bwpHe4dy8QdP/qZ9J4UjpA5R35HkoxCihheMQg5xdDvJXGz6gt6FDLhZLg5dv9RTDHSexySo357Nk0R7C2HdW0A75Q03UVM7MEnSIn9eOLldQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=b8JvIdo9; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=h5xnIpG93qiqQd/wnfuUtnAxrf53oJ7yelGXYhNBaps=; b=b8JvIdo9+H4c6uWkX4Co1P3uXl
	NIAyGRvhM1f/Ezj07jqUsdMGMr+didEMNUwMIrDY+BUhEbOKSUh3z0h6mLRhOfhYz+XigKKXNWn4j
	i/eLNpN8TeL6n6EGWxcjbKdwd2um84H78PoKkZBEOQEB8wMjcKaErHZ4rvpk3vL8e8s9p5chTlVvF
	WBysysscWHXYm0KW1/MBcMhswp6GZO2gjI+pLMjKCQbGoMhc33t1ZYnm4ntk/wh/G0jg9KTNQ91lp
	rlaEQFV81slYhXz+lrX7cQ8YFl89ZqVURhAwA/S7DAY+ajDWDK+c18hmtsFrE7MGem22dvwXgoFll
	f+Z+lv4A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9g-0000000GwK4-2Rrn;
	Tue, 16 Dec 2025 03:55:20 +0000
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
Subject: [RFC PATCH v3 21/59] file_setattr(): filename_lookup() accepts ERR_PTR() as filename
Date: Tue, 16 Dec 2025 03:54:40 +0000
Message-ID: <20251216035518.4037331-22-viro@zeniv.linux.org.uk>
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

no need to check it in the caller

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/file_attr.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index f9e4d4014afc..915e9a40cd42 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -457,9 +457,6 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const char __user *, filename,
 		return error;
 
 	name = getname_maybe_null(filename, at_flags);
-	if (IS_ERR(name))
-		return PTR_ERR(name);
-
 	if (!name && dfd >= 0) {
 		CLASS(fd, f)(dfd);
 		if (fd_empty(f))
-- 
2.47.3


