Return-Path: <io-uring+bounces-11461-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B941D016F3
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:39:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id ABE933068BCB
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:37:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75DC833D6C5;
	Thu,  8 Jan 2026 07:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="PJ4zFOZ6"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0F932573B;
	Thu,  8 Jan 2026 07:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857816; cv=none; b=l0uPjw9QvELFdwJB2PqHCJhGQYzo1RGIK6UFkQYGEHRBmo3CNrEOYHryOzbzJzkuGSyEjtr7Go/YWgN7hJ7HLTcORclZthw2ds1F+U7SN5+q5SR9BCS4iRSrHd65NyEPRMBHQ7jA4S02pSl0TnJNaEQbI5KvnbiolyabTvBwweo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857816; c=relaxed/simple;
	bh=2QgRPPysk3RFE9BKSvg2KLBE3NHzd6S7kLOldkJLQu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MiYL77MGzjVAbRPqCnZ/6U5hkn1B3tdtx77D75TXGbHuOWNtRIadCMj9LVKcUXGR2bBKtDCHsj7evA4P5li9XUJ3P0pCBErjZbXBYzbaSTVYhiJUPr3uNOjYQaG2p4j6NFf4r4vHKqUuMY6giUzcL4XBxPmudMkk+HRDr9r45FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=PJ4zFOZ6; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=9NAUwU7USYo2v7JCqOEDK9HM4Z+5fSI5wGIxSuEZ5WQ=; b=PJ4zFOZ6bzP7rB/8AyAMDY2YVb
	pozGc4gjIsicswE8xC9YSXl5yuFdOgbRYVmMrzpkhaewR3Y8SXD3jV/7mKvllyNIlCbwh8n5/BMBV
	1X9hGlfwFebURUTFxhAqquh6HYbWG0WTRIGCL8+kyrEtTly8BCEh/zDtxMEJlxCwr8tqQZ0RZH7Sb
	TvMGwkRsX/aPOD3E+JIagGqsco9w+PxS+9CkHt+P1ak/02Y60byTya7ahphuUPt8jM5avjSWhPKug
	AUt35CxY/q8GktnndfAz15NQb7T6FGIbqE43Jpax7uZM+mdCWFd6BfeZWdHI05iSvVJVySJba4h3x
	PGiDBH0A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkat-00000001mjz-0lym;
	Thu, 08 Jan 2026 07:38:07 +0000
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
Subject: [PATCH v4 18/59] switch __getname_maybe_null() to CLASS(filename_flags)
Date: Thu,  8 Jan 2026 07:37:22 +0000
Message-ID: <20260108073803.425343-19-viro@zeniv.linux.org.uk>
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
 fs/namei.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 15e14802cabb..f8c11e1a6b11 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -227,7 +227,6 @@ struct filename *getname_uflags(const char __user *filename, int uflags)
 
 struct filename *__getname_maybe_null(const char __user *pathname)
 {
-	struct filename *name;
 	char c;
 
 	/* try to save on allocations; loss on um, though */
@@ -236,12 +235,11 @@ struct filename *__getname_maybe_null(const char __user *pathname)
 	if (!c)
 		return NULL;
 
-	name = getname_flags(pathname, LOOKUP_EMPTY);
-	if (!IS_ERR(name) && !(name->name[0])) {
-		putname(name);
-		name = NULL;
-	}
-	return name;
+	CLASS(filename_flags, name)(pathname, LOOKUP_EMPTY);
+	/* empty pathname translates to NULL */
+	if (!IS_ERR(name) && !(name->name[0]))
+		return NULL;
+	return no_free_ptr(name);
 }
 
 struct filename *getname_kernel(const char * filename)
-- 
2.47.3


