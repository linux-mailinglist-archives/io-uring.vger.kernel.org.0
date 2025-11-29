Return-Path: <io-uring+bounces-10851-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E0AD9C94501
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 18:02:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3BFE04E394F
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 17:02:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F5C03112BB;
	Sat, 29 Nov 2025 17:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="mNVgYSws"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707BF30FC0E;
	Sat, 29 Nov 2025 17:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764435702; cv=none; b=Kz/+JP5DlvFNI/8THVFAfcoLy/X4wg6pRt9dvb64yTViw1etdrG6+1VnGcS6m0dxUqoA7cCiSdJSwwVRpDueYxq4ElKsaOhJE31xBxEHRdubOqXNf3I2Xv3ydeDck11x7fDfSQWNO7oo6LDrrpQ6mOnM699nWwAuRS0y3wEAVxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764435702; c=relaxed/simple;
	bh=bQH5wtm0BD6/qtbI9/3ZSlMHlBzaF2jm/CPhUCieAUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEh0xpRuqFPipYjYm3PtfA8oCAmiblNAkSqAFufsTqzBL32TvPIQQzRJHug+gCsyJ0SVW3HEOCYRq87FOnH8QjNuHrZNo5reL+GM31pcQS2JCaZwdmqRBVFkMue+S/YbkrwKZg4kge335ANZYRw/it7UUFTWqa6O4crXpSezQaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=mNVgYSws; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=b9o68/4CN8froikzgVbMO1h3wNtbrDgDk7b1PLKhvXU=; b=mNVgYSwswF5ctKyLQZH7EqmHvn
	nfaUFRtC/YcRmNQXB+kZ08VYU/kQakcpRm1hjPpGl/hiDcPY/x9RyfUqFAgDdMgp923PSd3+pxgT5
	NskB6C2dAoVVpLCA81GTCHhmRR8+yMyjEVuvhfuUw0fxstU7rH3o+plExgeYUa/Aix7n8boDJmUw2
	XPKJlF31xwSzG4/pulGXpu9YbPoIwTFyKPaRUTp1njmvf9W5kwiK9Gp+wFJ0Q08hF0C7SL/rkvfHG
	p4as2fB7tHr4Kd8aG8r65qrT3xl4eWs1Xivfi3gvBnMyXUt7eLJ8+6u5yTuLUcNnkOVcZCLOMDOfJ
	IeLW1hXw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vPOKN-00000000dD7-2iUM;
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
Subject: [RFC PATCH v2 12/18] getname_flags() massage, part 1
Date: Sat, 29 Nov 2025 17:01:36 +0000
Message-ID: <20251129170142.150639-13-viro@zeniv.linux.org.uk>
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

In case of long name don't reread what we'd already copied.
memmove() it instead.  That avoids the possibility of ending
up with empty name there and the need to look at the flags
on the slow path.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index dd86e41deeeb..bc5fe9732949 100644
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


