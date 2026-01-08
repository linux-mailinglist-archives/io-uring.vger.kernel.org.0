Return-Path: <io-uring+bounces-11465-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 74554D016CF
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:37:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CD6E23005014
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:37:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C9D333D51A;
	Thu,  8 Jan 2026 07:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="ufTx/oHg"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9709632A3F2;
	Thu,  8 Jan 2026 07:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857817; cv=none; b=d1NZogdd7+iYYwLR3KAXkqVt6xfYwSUmo3JRrb1+dtP2HEK4zpNqLDyLzl4fzRbNCJHIyZlQJWfvMcn1fD90GpU3nQXHggK+6tz/L74mtDO9DhdXq3eudKLMjVQtXS8Sh/PJk77zMFHjuRvSNWY0pIwLPEP+laYuf7ShWl+d4z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857817; c=relaxed/simple;
	bh=WRriJN466GNrPVDup+aZWVv/Wp3+fkgE/IoVZ5UfeDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4ePkVt6lNi1czudqbdBKSJNgErExHesHdqKraVUKAhkMAkleES7rhRe8zifg3z/3lZ5MjUnxg4rJnjv21KA+rSyZF/+h7etbpHgNK1faVzMtKX9lWq6cuXhc7PDOFSSBLVnCqIoVQBpwxcEJ127Phk8XL/3DcebCTI4pWMDxlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=ufTx/oHg; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ozC9vkaM+z/rcpUfiwPLiYxS2TFpYNOL05SazZBN1Ps=; b=ufTx/oHgVLiZ4qK9L168IAQy38
	2UFakTLf+kObTwCBKRn+ZKoegkIU1FjE2RKzB43vLjVkS9fYKWCkTDDWMeLXp3ENzg0CV1QbExDQp
	MeSZ4WgIJ1Lu7i5on2MY1nHDLInS+ux8iFgYAG9FFD9R712+VnFM8rcmPIMZNL94RyLzItlcr9467
	PCjS+RPC5Yia126kkIdzldLIT2RwyITC8oeUwYago4DpCYFtdIuw+Zr4ZpvFFCEFcp3xSc5P1QrVO
	qvwH0AriYkdjkLaeyh6w2l89C+rMZF8ydUQT1wVybJie8t2g7FIukJFqU96ZiwCYFZJumcxsrzCeC
	puHQD/Hg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkau-00000001mm6-1y5X;
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
Subject: [PATCH v4 26/59] do_filp_open(): DTRT when getting ERR_PTR() as pathname
Date: Thu,  8 Jan 2026 07:37:30 +0000
Message-ID: <20260108073803.425343-27-viro@zeniv.linux.org.uk>
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

The rest of the set_nameidata() callers treat IS_ERR(pathname) as
"bail out immediately with PTR_ERR(pathname) as error".  Makes
life simpler for callers; do_filp_open() is the only exception
and its callers would also benefit from such calling conventions
change.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/namei.c b/fs/namei.c
index 8f26e91de906..c8410dc6c0c6 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4862,6 +4862,8 @@ struct file *do_filp_open(int dfd, struct filename *pathname,
 	int flags = op->lookup_flags;
 	struct file *filp;
 
+	if (IS_ERR(pathname))
+		return ERR_CAST(pathname);
 	set_nameidata(&nd, dfd, pathname, NULL);
 	filp = path_openat(&nd, op, flags | LOOKUP_RCU);
 	if (unlikely(filp == ERR_PTR(-ECHILD)))
-- 
2.47.3


