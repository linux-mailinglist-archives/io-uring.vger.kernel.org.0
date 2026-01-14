Return-Path: <io-uring+bounces-11649-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 29848D1C5F9
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:35:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 41A0F307D62F
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7987632AAC6;
	Wed, 14 Jan 2026 04:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="ZsDFyg/p"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B919B2E62D1;
	Wed, 14 Jan 2026 04:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365115; cv=none; b=ilVSDhGP4HeLP6/KzJd9/LlCl3D5TSFYPNudZcKWhZCew0STh/hqyF/kdnPexL0C0m8IiC6De2rLmIOV3bkq0Wf6KdfeWpHJp8m5juqXwMMDQPVMw75BGIt/+nVXK5Euy1yE8mdhhka+FRgb/sz8epYcLKTvHTTMQYws4skvat4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365115; c=relaxed/simple;
	bh=YMNUEUX2X0rac/jj1KnbG49MMhT1wum48jSCSjbmLLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MolhaxUd1RNV1XhqDg8KTgaAmHUkBBbblanB5aLZlSbVJ83cGpjrYaTTg4lTIfAsAA+vcdPkltqkeLnaeHTe/Jjo4Y1sdNmuiTeGZsSqzjW6/qszEWlBcodvws1FWr7MP0MPmw7L69U3B/te02fm2u6M2b3iM8BhQYzi+1qcmW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=ZsDFyg/p; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wVP92Y8THW65X9H3vwh5lJvI+FBhhIBHJIGei+WW+zs=; b=ZsDFyg/pLFkFQbFTbzswbvd+z7
	GLvV1alzsCT4Jyw6pxYxy7Gt8dI7tk796nwYxdJ3vG/JoUi/AUfBMDIK0r37FOuU1wVga7Rbfbvj2
	YVdRpC0BNSdEolwlazoTxpO+nyCq3OHFwApwy+ZsLk+R/5QIZJaFKyFAW6/sqkacKGzGxukEjFKG3
	RljD+SXruu1E63zIHvpXeWTtozAqzBBNjTjz2khLE0eonfSEPayIKQvuvposi1CryzgN/orQi/ULd
	jvVVyiAYlFED1gJh7thwUB1LzndRXtVo+1W5iUYNvFnRTqZtd8SKTByWdplFrS78+shWwh2AUuQie
	FhFonf3A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZE-0000000GInb-28eX;
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
Subject: [PATCH v5 17/68] getname_flags() massage, part 1
Date: Wed, 14 Jan 2026 04:32:19 +0000
Message-ID: <20260114043310.3885463-18-viro@zeniv.linux.org.uk>
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

In case of long name don't reread what we'd already copied.
memmove() it instead.  That avoids the possibility of ending
up with empty name there and the need to look at the flags
on the slow path.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 3ba712032f55..72ee663a9b6b 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -174,36 +174,35 @@ getname_flags(const char __user *filename, int flags)
 	 */
 	if (unlikely(len == EMBEDDED_NAME_MAX)) {
 		const size_t size = offsetof(struct filename, iname[1]);
-		kname = (char *)result;
+		struct filename *p;
 
 		/*
 		 * size is chosen that way we to guarantee that
 		 * result->iname[0] is within the same object and that
 		 * kname can't be equal to result->iname, no matter what.
 		 */
-		result = kzalloc(size, GFP_KERNEL);
-		if (unlikely(!result)) {
-			__putname(kname);
+		p = kzalloc(size, GFP_KERNEL);
+		if (unlikely(!p)) {
+			__putname(result);
 			return ERR_PTR(-ENOMEM);
 		}
-		result->name = kname;
-		len = strncpy_from_user(kname, filename, PATH_MAX);
+		memmove(result, &result->iname, EMBEDDED_NAME_MAX);
+		kname = (char *)result;
+		p->name = kname;
+		len = strncpy_from_user(kname + EMBEDDED_NAME_MAX,
+					filename + EMBEDDED_NAME_MAX,
+					PATH_MAX - EMBEDDED_NAME_MAX);
 		if (unlikely(len < 0)) {
-			__putname(kname);
-			kfree(result);
+			kfree(p);
+			__putname(result);
 			return ERR_PTR(len);
 		}
-		/* The empty path is special. */
-		if (unlikely(!len) && !(flags & LOOKUP_EMPTY)) {
-			__putname(kname);
-			kfree(result);
-			return ERR_PTR(-ENOENT);
-		}
-		if (unlikely(len == PATH_MAX)) {
-			__putname(kname);
-			kfree(result);
+		if (unlikely(len == PATH_MAX - EMBEDDED_NAME_MAX)) {
+			kfree(p);
+			__putname(result);
 			return ERR_PTR(-ENAMETOOLONG);
 		}
+		result = p;
 	}
 	initname(result);
 	audit_getname(result);
-- 
2.47.3


