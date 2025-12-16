Return-Path: <io-uring+bounces-11109-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F3B5ACC0D38
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 05:01:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3EFF4306B17F
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:56:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4150432BF55;
	Tue, 16 Dec 2025 03:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="r8nkNad4"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFE2312803;
	Tue, 16 Dec 2025 03:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857299; cv=none; b=fTciQZtwIq5VLxi4Ts9160OPI/lgIGPNLh2iiaQhsOls7S9SFnKuoVK44uJykkWTuknhXJ/Zxwga72ZLRXc/4DU5IzHSX7pesHIjd0I6kqniiXbe+IC6OpOpljnR359ObQCHBs2eapd4ArQK1f5fE2BcAzaKfCC32daxeJCnSIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857299; c=relaxed/simple;
	bh=S4VYrqztxn3qx2+ce8nOumRfGqsXr/vKT8X35BxAw9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSGyKBtjFl7IIFH7EZ04z4RbltFWKW05AV/z5LN7AJAbtWUnlLRba2I13qmnpn3kG+4jSR+y2/25aoAlQR4kK1qAad+80psvKgFA0nK4v1XYZPWcwEOiRIHJU73WvkwhTYc5HlzNsulJo3eCSJJJGGf9PoBbTbjwew1fJpWdh34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=r8nkNad4; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mxa3cbqR5z2NPq9lAeRLIRLOjiQkAso1d9Wu9XUX5zE=; b=r8nkNad4hXV+URJB4qQ2yAxOPW
	jWM9X95xX6dQQ6b5CKbIUlHuTpNc0qmad3R+Pha8udiMiaO1qAn7AToy2TIst95vUZL74Gax01TGO
	GgbCVMgmQUNHjmSGqkosWiYt0XC/M6VRbROmRYUPfQP0/lFxS+gW5HnaJ/ivyF7Z70P3MHrhib4dK
	xTAyITjioWWzn6eiGspOGDYKtfg3SYwt3P5tjA90AQIFTssv0OWZWFxCGq6T9dPF+wsgc+6IJkN4r
	9LlB4PMzQanufN/SSwWXBIr2wp6Q0/gikd/iXi//6wMB13SJgEk0MNgh9alfathqY3rvXfY1z0pe3
	pWQt9IFA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9f-0000000GwJR-3Tso;
	Tue, 16 Dec 2025 03:55:19 +0000
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
Subject: [RFC PATCH v3 12/59] getname_flags() massage, part 1
Date: Tue, 16 Dec 2025 03:54:31 +0000
Message-ID: <20251216035518.4037331-13-viro@zeniv.linux.org.uk>
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

In case of long name don't reread what we'd already copied.
memmove() it instead.  That avoids the possibility of ending
up with empty name there and the need to look at the flags
on the slow path.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index f22cfdff72ab..ea7efbddc7f4 100644
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


