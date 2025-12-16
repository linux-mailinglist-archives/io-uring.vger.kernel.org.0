Return-Path: <io-uring+bounces-11063-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A3E8CC0C24
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:55:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AFA513028FF0
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:54:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 296DE3128B6;
	Tue, 16 Dec 2025 03:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="UfOk6tag"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F673126AC;
	Tue, 16 Dec 2025 03:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857292; cv=none; b=bCst9SOL19rI+8zDgBN6/rhI78wqG//HdxVTt6WrOHA2oSsYWn9FZOKtaNG56YO+xJayoa672oN2OntCJ/XULVww5x/T8VnSyK1GuaADlyXP48vKieqO3tH5L2QOlZdRytFSOyPzS4SiCYFa1e+MDDlSXkIs5j/B/4bWJL9lOm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857292; c=relaxed/simple;
	bh=ml4RNN/VCnYi1f5kE1GxmfC7TyVm/T5H+RGWeGZ6lPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3qxddwBYxicGE3JZ/qS4finDVl1iWVQs0usjX3CnemOPkAJZYUAN/mSaM377PACrmMFwEghEqrvNKt9pLNyc7cHcpkhU4IIA50k+iO4nkXVocxRMmu//jevvi53lB26WsX0OnNYabKMz+qXKkiWDPHu78KhWbM4vE7ED8WSCy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=UfOk6tag; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8u3Dw0scZ1Xzc2uavtsf6xcpNT1HTgSA1P3hF8Kuknw=; b=UfOk6tagInO7YYNbNiepmAeijx
	ZNvZcwI9OM7WMSUSAVVUZX6tO/3+xHMKnVkXbM/4q7Y2+rs5ykR0OC7JRMtgXxW0XlRrIU/ZXeacg
	3aRMd0qp+MPZ5R2h7IFTTC7M8Y2MOw4gYJ2LifRBL+KyxkUTEpQMCdRc+ZnUCJIVvPUTpNizGar+J
	71GTQZvfNp9BiCpH/RLIBDyhEvxakXkm/YFy6G65jsUQHMrOk0zdB+dIhnkAPtUl5y8ksugxiBu/E
	gSxggMLmrDXJ/vMQ/djxB951wpXzLv2yQgRV4Mil8cLPXn9BVh+IloSFkao7oncuehGSQIvq0ozMr
	TWcm9x6A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9k-0000000GwO8-2LS9;
	Tue, 16 Dec 2025 03:55:24 +0000
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
Subject: [RFC PATCH v3 55/59] user_statfs(): switch to CLASS(filename)
Date: Tue, 16 Dec 2025 03:55:14 +0000
Message-ID: <20251216035518.4037331-56-viro@zeniv.linux.org.uk>
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

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/statfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/statfs.c b/fs/statfs.c
index a5671bf6c7f0..377bcef7a561 100644
--- a/fs/statfs.c
+++ b/fs/statfs.c
@@ -99,7 +99,7 @@ int user_statfs(const char __user *pathname, struct kstatfs *st)
 	struct path path;
 	int error;
 	unsigned int lookup_flags = LOOKUP_FOLLOW|LOOKUP_AUTOMOUNT;
-	struct filename *name = getname(pathname);
+	CLASS(filename, name)(pathname);
 retry:
 	error = filename_lookup(AT_FDCWD, name, lookup_flags, &path, NULL);
 	if (!error) {
@@ -110,7 +110,6 @@ int user_statfs(const char __user *pathname, struct kstatfs *st)
 			goto retry;
 		}
 	}
-	putname(name);
 	return error;
 }
 
-- 
2.47.3


