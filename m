Return-Path: <io-uring+bounces-11074-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5760ACC0C45
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:55:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6728330287B3
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AFE231A07C;
	Tue, 16 Dec 2025 03:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="eDL6unSj"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3EE312825;
	Tue, 16 Dec 2025 03:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857294; cv=none; b=W3eDQfcSjcpBJijLT0jE+NxbBMh/NYhp1vntcR5iXK9xxXD/21cUMpiibm0hElyQ4lRabH71FZ/lrv/RLE2x8g5OWz6YKi06Ol04GwhyD1Awa9xjilLha1qjJEG6PUIP+H0tEn47yThR5lF2yCGdTv8E3wXB/YBbLwxx0M78sZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857294; c=relaxed/simple;
	bh=5FlUUS1jD/qO4GjkFoeGP/pqV3ffAtfSXhOlZdx96OI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZeDnCuJRBhMt1QD8wDVLUxCwNSv3ouWkPoTq0m5ZLrm4MUYQhefneTI5l+blgFTlInERS2Z0AsKAcalBLlp12wExw+Hpg8iqWkBwanwQ2LC3j9RChod7IXpKS02RS3rwN6V4+V13KKlmaaMGIFXmwYK6hlxREBo6Vp7OLWhZCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=eDL6unSj; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=RyR3DA8HjjdPyUD9sKhD9cSoJBBdR+vnig5rZSsrQgk=; b=eDL6unSj2eovkNAwj5r1sgNkWS
	1dNluo8dUTAc7/Zv48Op3LcU8hQb5+K4Q3ev88GQ8i13OO2olnlAjwJzYdJx0LwzN1LPzv+25ABmY
	5An1arm6tbCGTG0VTJQ70z01JImrTsZG3tcLInXFJOCwfucKKKowZVoAPEUm4yF3ym3A5UMUvX3jv
	xbo0VM+6Ggz1R2XfXI/4/Vg+ahC6hrMH4JbMtLcrVz+Dd4B/PjsTb/jk7l3ae9nmsdMtBlArZxwrG
	G+VVv1sixaRyjpVZOh/6b7CCPwHwB2vKBHIhD+OhXG9iV86qhOLTyho7Qc0tEH+OspIAp8Vro/RqR
	QipadUvg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9g-0000000GwKL-3fQB;
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
Subject: [RFC PATCH v3 23/59] ksmbd_vfs_path_lookup(): vfs_path_parent_lookup() accepts ERR_PTR() as name
Date: Tue, 16 Dec 2025 03:54:42 +0000
Message-ID: <20251216035518.4037331-24-viro@zeniv.linux.org.uk>
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

no need to check in the caller

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/smb/server/vfs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 98b0eb966d91..e874b27666a1 100644
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


