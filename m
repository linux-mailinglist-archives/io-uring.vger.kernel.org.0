Return-Path: <io-uring+bounces-3352-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 43A9398CAAC
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 03:22:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 748821C20F4D
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 01:22:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9FC5138E;
	Wed,  2 Oct 2024 01:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="heROSkdP"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAF79454;
	Wed,  2 Oct 2024 01:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832153; cv=none; b=Tosu8rNIv9dlsIHp8g1vzGPnu7MWnN11wggexI4Dng9avtJTR2CBbB6B3eirEPu0u25CEO/JgRqnvPU+Jk0jDGWqi/WLECP7/2Sf7oatklAK4hZVupvoMBDGrQPBBfrDn2ENcAZIwZ3mhjsWpvEEIeC7yX2FGeLvE1OVZ4Ff2ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832153; c=relaxed/simple;
	bh=gStnpPyvw9dmCFt/+rNPkZRYWlrAfXwW2VfkGt+hHSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k5BYCRfhol908NEz2gnAwk/wvagRTnXLeX2tB4PCsAJ/fyGQjclhne6bTbuojah13xFBV4Wtw+grLhbKyEXtcU3nGzdO0twZv5+XB1cm8Ef1hE0bEy5xdPnLTdSgFtUIQwUCT+h39prqDiMynXUJ/A4TeuFhvaxCVRshlrFQ4TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=heROSkdP; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZRmhc+N4gRJDAvuKVshJF7vx2/FasZk6WdJnNtu+PX8=; b=heROSkdPtzw9/Gb8QZBf2daWIy
	y3ysFyd0EWZyRRv5sF+kIa8PeDidFLIyGBQ5OA+BmfVzs/xP9YquN5SaR5R7tSfw0U9I72fbkITSL
	Vw3UN2uuoCuN1wHpvO++JDZx9dbhB2ZLh8kjytD7qzhRwO8IOIUv7CChQ0y4BgODCIoQ/rOjdo2VF
	/Ad6RqKjn3gASqZDHBMAZ6ErOydewh7Z74kxhlXrwTPwB/gkrHNNHo+hWlE7L3IyogeypCMtp086Q
	+cKV8ajE5jLavxQgozzJ4dRE/LcE7FxS+GCF7N4DlnhUsbvRHlkABDQstM3DCXK09FDCObr4tQsu1
	ZuUpgGsQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svo4U-0000000HW0D-1krp;
	Wed, 02 Oct 2024 01:22:30 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: brauner@kernel.org,
	io-uring@vger.kernel.org,
	cgzones@googlemail.com
Subject: [PATCH 3/9] io_[gs]etxattr_prep(): just use getname()
Date: Wed,  2 Oct 2024 02:22:24 +0100
Message-ID: <20241002012230.4174585-3-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20241002012230.4174585-1-viro@zeniv.linux.org.uk>
References: <20241002011011.GB4017910@ZenIV>
 <20241002012230.4174585-1-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

getname_flags(pathname, LOOKUP_FOLLOW) is obviously bogus - following
trailing symlinks has no impact on how to copy the pathname from userland...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 io_uring/xattr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/xattr.c b/io_uring/xattr.c
index 5b4594ede935..04abf0739668 100644
--- a/io_uring/xattr.c
+++ b/io_uring/xattr.c
@@ -96,7 +96,7 @@ int io_getxattr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	path = u64_to_user_ptr(READ_ONCE(sqe->addr3));
 
-	ix->filename = getname_flags(path, LOOKUP_FOLLOW);
+	ix->filename = getname(path);
 	if (IS_ERR(ix->filename)) {
 		ret = PTR_ERR(ix->filename);
 		ix->filename = NULL;
@@ -189,7 +189,7 @@ int io_setxattr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	path = u64_to_user_ptr(READ_ONCE(sqe->addr3));
 
-	ix->filename = getname_flags(path, LOOKUP_FOLLOW);
+	ix->filename = getname(path);
 	if (IS_ERR(ix->filename)) {
 		ret = PTR_ERR(ix->filename);
 		ix->filename = NULL;
-- 
2.39.5


