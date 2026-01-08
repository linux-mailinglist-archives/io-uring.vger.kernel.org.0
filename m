Return-Path: <io-uring+bounces-11462-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E725DD016F6
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:39:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CC652306C3D8
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:37:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EB7A33D4EE;
	Thu,  8 Jan 2026 07:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="Le6EBqcw"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B99329E43;
	Thu,  8 Jan 2026 07:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857816; cv=none; b=SIe3ELAF7oIyQayTOKLhEi6Ib7HVm8iSHHJiguMg2zvKobls+x1QajHypPtjXtI+2i46O2tz3dx+oE+5SEKJ9VxaNB4jbm15g6lGGPcPrN90/QNPyzn0eFMnZ+9u6xUnv6oXJ3s6sMyXLR5EdE8dkxv/AkuT0hotVx2M29KfAFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857816; c=relaxed/simple;
	bh=Ydled4U6L1X7V26SQt7n9puQ7dfK0LX63LBtB+WlC0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7Z+x77e4p1sfqcHS+niwp6nXNRl9B2M4TPqK3JK0n2jQXKhrwTMpF2aS4l+/JFI3+VomyzH75rIeRTPISJUHahqSr6i2w8+9eQJqU/bZtV4CxG7FIy1WyCIFmxUeCVKJc8m/M/u07CFBAR/11QyNoVlDjff0VxX74BhxyX+uyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=Le6EBqcw; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=sd2Rgca4jMZ7f1mAJaupLk+3fuY1coBUzS+dbbv0xtA=; b=Le6EBqcwHAfqnlwwJyguPos+y8
	/St5BqWcms7r9VcHPM2BguyNzGSa03qRCOF1wO9fcSPZ/cn2c/Ph9egBk9LA7EyoZRoCjD9PMBEL8
	9etIzFWOZ4As7QBDDFe+dqNA3ia6Z+9aM03gkr4a68HleKgPC0SNal418WhJ2WshcxyQqLjWkyMXm
	nNACqSzhAQkb9lPSpIZv88h4Wi3OmSOJS4lZaROZiePL44X7fEWvXaXM0TDsCfiMTvnxL1lOdIQZX
	yGEIPO8fOWAi8z1IKJM1vZAK0+zCBoDf/r7KmDtKpOaGpoK/gD4OHyrrRVCgW/nVaaD1vXkumb/HS
	+Js418qw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkau-00000001mlY-0ZDb;
	Thu, 08 Jan 2026 07:38:08 +0000
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
Subject: [PATCH v4 24/59] ksmbd_vfs_path_lookup(): vfs_path_parent_lookup() accepts ERR_PTR() as name
Date: Thu,  8 Jan 2026 07:37:28 +0000
Message-ID: <20260108073803.425343-25-viro@zeniv.linux.org.uk>
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

no need to check in the caller

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/smb/server/vfs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index f891344bd76b..a97226116840 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -67,9 +67,6 @@ static int ksmbd_vfs_path_lookup(struct ksmbd_share_config *share_conf,
 	}
 
 	filename = getname_kernel(pathname);
-	if (IS_ERR(filename))
-		return PTR_ERR(filename);
-
 	err = vfs_path_parent_lookup(filename, flags,
 				     path, &last, &type,
 				     root_share_path);
-- 
2.47.3


