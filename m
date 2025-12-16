Return-Path: <io-uring+bounces-11080-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 161F0CC0C7E
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:56:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EF41F304F104
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91D4131BC91;
	Tue, 16 Dec 2025 03:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="C/Yn+Nno"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70412312827;
	Tue, 16 Dec 2025 03:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857295; cv=none; b=DZB8D69c18AFOPc8ZqjsszMrh5zZwuvIFxH57mzt+AFFI6Hcvu5mmmoFLWJJW0decRP/Ui/8O0khOfh/70GikEqRqNpmHNuOumHNg45FnkSoaHrdsuMCbtoFI0jpzq6dcKdKOYOcjo0+mkspni/U5hPrMSWteCVZpVFMmdHggFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857295; c=relaxed/simple;
	bh=C+2EcojQwnwv5U/vpMob42+W8dy1bNTjOKNG9HnaK5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=anIwXnaMK40GoScXdsC68z+41OIc3kVomkFwZRJNAUiM4fikMUkaAN0Hr1sd8Qu8ypBx3bg3kX69zeR5fssf4q6h9dreHdBhvl+Om0eUHHT13Yg370VxEowPoV311UTo3NO/1bpcEZ/ET/3az/D2T0JgFLYA/WfWCjxKilhP4rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=C/Yn+Nno; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nX+MJLbNwZ93pbRcj4nhRonYJnvqZZukCpm52ExmhG4=; b=C/Yn+Nno+TxYAgVSwm9Efs58sc
	I6q2yZEv/68PcwWcfMSUyDl1x8hk0mSfhwWosX0n2cCpNtyS65+6G9rvcFzx4OPMI8iZhwB8z8XZR
	b5OdNU/vd1n2OZpYSIVDPRvIFMJ/A+gBLxJcmQChY2txmc22DFLt4irXdxjn3b/RxZy8bPgsrH2q4
	ojmpFqhxPb/Y+ASXu5XCJItie+b2g6ABJ9Pgrih7mCtJxiPNKDSOOQyJsODvJPLD8iSiJ7gqddG80
	IM5NqEp+bfk+0TioiNpLkQj1nMV+SnjN3vREOl30ojjnfuyVLg2Di3j//GTi8jzZPkZkQQHQ0crDj
	+eaRVpIA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9g-0000000GwKF-3GHF;
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
Subject: [RFC PATCH v3 22/59] move_mount(): filename_lookup() accepts ERR_PTR() as filename
Date: Tue, 16 Dec 2025 03:54:41 +0000
Message-ID: <20251216035518.4037331-23-viro@zeniv.linux.org.uk>
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
 fs/namespace.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index c58674a20cad..9d0d8ed16264 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4427,9 +4427,6 @@ SYSCALL_DEFINE5(move_mount,
 		uflags = AT_EMPTY_PATH;
 
 	to_name = getname_maybe_null(to_pathname, uflags);
-	if (IS_ERR(to_name))
-		return PTR_ERR(to_name);
-
 	if (!to_name && to_dfd >= 0) {
 		CLASS(fd_raw, f_to)(to_dfd);
 		if (fd_empty(f_to))
@@ -4453,9 +4450,6 @@ SYSCALL_DEFINE5(move_mount,
 		uflags = AT_EMPTY_PATH;
 
 	from_name = getname_maybe_null(from_pathname, uflags);
-	if (IS_ERR(from_name))
-		return PTR_ERR(from_name);
-
 	if (!from_name && from_dfd >= 0) {
 		CLASS(fd_raw, f_from)(from_dfd);
 		if (fd_empty(f_from))
-- 
2.47.3


