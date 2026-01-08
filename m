Return-Path: <io-uring+bounces-11477-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 394EDD01885
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 09:14:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9A83A313453C
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:58:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D93034251F;
	Thu,  8 Jan 2026 07:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="csE62p9B"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0092133BBD1;
	Thu,  8 Jan 2026 07:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857819; cv=none; b=Z0Ipg9o0O5ZTgcRnSVaYz1pO78g+7+YoTnvd0av6va4RAWFNO7cghLu6BvBAEMG4C5Nl37nHxQfoWCuZCnfykNtkkVCB+znVP8mvi14NW2gk4/G2UKsOPghUnyHGkPkGhSs/0Alxo33+SaBSJhe1EYWd5qEYr0OYECcwcee4zxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857819; c=relaxed/simple;
	bh=ntStfDefI1LSk8YKGruB1ETOnK4upEIT64zjyBPt37E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GTzhjRE3PZlBMW/2sLL0YATjt5LUFntuutLuuCRTDmOYZTIq6gi7y96msuIHzX4wpDmyX/tgiIZE7WcOPd1VjbA8W+FfVeKuO4J4GYpocHhMw5tRju4TX/fxSqrFO1OXNhKmS3OVDwComzONB6Hlg4ux9tE6xIUBTcX2tRQxzEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=csE62p9B; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qCNNGL7/AcB8NbftVI2+HUXdppTuzbETXECNk4eIw2k=; b=csE62p9BakBwVfZvoBMipvMz+b
	lqUbpqq1KUku8pfFJJw7Nnacfpa2g2oFjYT6kZHLGmttO7+QrFAq6Lg1/aucYnt87vQ95ESTV6JSp
	CJYPqNmOXhkrWdfCr77P8qijYeSwVSFqft6cliZt7pFWCF8wsj70OOiseUjMZiKqqbz+JYf/Pw03J
	q+n2LSVXOAMZLWkYY19xmpqwQiBX7WHlOgXKYyqpo3CXC/8BQ987ojdWUUAqfIcB3ErHyG8oyOTzb
	MwS2YIK15SX1Fc+20gIqA/7olVaH8f28Qpjs46MXd5NlZJFt1WchnXibTWRB1Va1PCNAS/lsftxi6
	BH+/pa/A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkax-00000001mpy-0992;
	Thu, 08 Jan 2026 07:38:11 +0000
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
Subject: [PATCH v4 37/59] name_to_handle_at(): use CLASS(filename_uflags)
Date: Thu,  8 Jan 2026 07:37:41 +0000
Message-ID: <20260108073803.425343-38-viro@zeniv.linux.org.uk>
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
 fs/fhandle.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/fhandle.c b/fs/fhandle.c
index 3de1547ec9d4..e15bcf4b0b23 100644
--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -157,9 +157,8 @@ SYSCALL_DEFINE5(name_to_handle_at, int, dfd, const char __user *, name,
 		fh_flags |= EXPORT_FH_CONNECTABLE;
 
 	lookup_flags = (flag & AT_SYMLINK_FOLLOW) ? LOOKUP_FOLLOW : 0;
-	if (flag & AT_EMPTY_PATH)
-		lookup_flags |= LOOKUP_EMPTY;
-	err = user_path_at(dfd, name, lookup_flags, &path);
+	CLASS(filename_uflags, filename)(name, flag);
+	err = filename_lookup(dfd, filename, lookup_flags, &path, NULL);
 	if (!err) {
 		err = do_sys_name_to_handle(&path, handle, mnt_id,
 					    flag & AT_HANDLE_MNT_ID_UNIQUE,
-- 
2.47.3


