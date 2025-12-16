Return-Path: <io-uring+bounces-11079-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E9573CC0C76
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:56:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DF16C30341D0
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97DC331BCAF;
	Tue, 16 Dec 2025 03:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="A66y6vHd"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B575531283A;
	Tue, 16 Dec 2025 03:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857295; cv=none; b=Vfi/bReFqrS+u3T2YvPXBhplTjwq3JkNOInnSHz1L+cmAw8Ax4HJAwLVaDlBSxy/kvpgrs94aRoSDaHWgqIJKZ8Hu6smwYquR3D2clMV1WSZ1YaACuGhbwrITYgekzA39br05AVgrmUQ9/v30bHQcUwBpnulrC6WMCfgu6HOnNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857295; c=relaxed/simple;
	bh=IX9w7fPMNXPKv9Q0A7fH9oFpc94P7btxSOr2pZJLITM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkFDyjc7yqR/OK9hwfZ6tmeAL7vXbkkBgJ2e/Gkwl8Itm9csYvHkTTfkfYM2qd840PUD4ktPDADtXOgFENVpS1nOYa6Zlb35m4PHEuDkbRnrtMmX0eGpSeY0SZ8CB/rVFV1Qnzgpp5Y5tfPdoerGd3kj9gKoSF/Sw/tzshrBjj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=A66y6vHd; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=CVl8K5qCw4DMEXt5OfjSK+oeyIn0fDQavSQJ4SK/2cU=; b=A66y6vHdLvdW7oY/9E46riGsRD
	+LUFf8zyrfoxXTIzQRAHM0jdICeKJ7fFK/Ixn040vV6KzVqQs3U/r80r/vB/e5BQh4cBTS7Ku6IZH
	MHj5ltG1v8Ra5Khp2Eh5L4o9lEBtxpmnFC9A0j2FStiPsX3OqyAyXgY2mkZHDRlkRV7TiYJy39g0s
	RRmeLaWibaYsuFTlXdmtUH2rvGimEbVGlFWHDWaddiFEF9Jm9kEeiNwlxcn7MCpOSN2xf8mGy2gux
	SEWwX9PSsQFkXrBHs8s7LhE61mONn67/+4tRi030qVeV3bzRIdTi4xc/MMVFrUTX8Cv0aGaO5MJOv
	hNuC3MRg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9h-0000000GwKc-0dcx;
	Tue, 16 Dec 2025 03:55:21 +0000
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
Subject: [RFC PATCH v3 25/59] do_filp_open(): DTRT when getting ERR_PTR() as pathname
Date: Tue, 16 Dec 2025 03:54:44 +0000
Message-ID: <20251216035518.4037331-26-viro@zeniv.linux.org.uk>
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
index 192d31acb4ff..af7fd253a712 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4865,6 +4865,8 @@ struct file *do_filp_open(int dfd, struct filename *pathname,
 	int flags = op->lookup_flags;
 	struct file *filp;
 
+	if (IS_ERR(pathname))
+		return ERR_CAST(pathname);
 	set_nameidata(&nd, dfd, pathname, NULL);
 	filp = path_openat(&nd, op, flags | LOOKUP_RCU);
 	if (unlikely(filp == ERR_PTR(-ECHILD)))
-- 
2.47.3


