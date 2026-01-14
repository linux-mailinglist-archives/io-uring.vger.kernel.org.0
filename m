Return-Path: <io-uring+bounces-11695-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 38D59D1C5C6
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:33:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EC8813018823
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:33:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A009E32C942;
	Wed, 14 Jan 2026 04:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="fD1HkbKM"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205AE32862F;
	Wed, 14 Jan 2026 04:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365123; cv=none; b=WEwP7dSx0BeRtVAQRc3cNnMNNdeDmvcozT9ILCOluGt/3tjrzeyJwIkiWDVViIHmdhSgEyxctRaWmSkRiOPJkkSKxXhDLRfgP9cHeUmmGF24tzA2kO31pYrDB0/MLyPMf4tS4Mkme4NtVbqyc+UE6XISa0BoYmaIUen9x6/toos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365123; c=relaxed/simple;
	bh=ml4RNN/VCnYi1f5kE1GxmfC7TyVm/T5H+RGWeGZ6lPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5N1BmQHMsRuLDOgktdmcnFVpQhOryyZL+a7OUNPvbBwBKHsOp9wFLZ7X88SlyqDh9nU0g/xRLQW65ut141YVrGZzcyblzU998N3QqvVHDulMfU0xvr+B41sCBkfkTvSQTOcxbJbvunq2E3c9SEcAVXliTqpgZUEqrtg1baLBm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=fD1HkbKM; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8u3Dw0scZ1Xzc2uavtsf6xcpNT1HTgSA1P3hF8Kuknw=; b=fD1HkbKMlykyUBoNy1c4M8nLib
	IDD1+76YH/xAsKLBziRgc4SkwAm2B2mZTmv5jm1kFX63ie5jKtN/KXsyuN8WIdFzZTJhoZaX0qUnb
	g32H28QMN7dT87q7+zluHnVA2ssydZoloJmQY8+rjKPpHirliw/szoindwpOYMjMJ8BevM2L1hqLL
	plMAvnSh/qWycB8OVMctA4glwWwY1/yrmRSQ6bJf9LVq2BqB68pgi5d/u+dHLYA6SZryjGlnLSsvH
	qRqaWZvtLVezm60Xt0EOLzBQ4PNgcr1oJLOtB8Qgn0TEiuk1FY6nD31kxd7U7VYxEAnCOtB+viTWO
	DkSRDbuA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZO-0000000GIzw-0P7d;
	Wed, 14 Jan 2026 04:33:22 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Jens Axboe <axboe@kernel.dk>,
	audit@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 64/68] user_statfs(): switch to CLASS(filename)
Date: Wed, 14 Jan 2026 04:33:06 +0000
Message-ID: <20260114043310.3885463-65-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114043310.3885463-1-viro@zeniv.linux.org.uk>
References: <20260114043310.3885463-1-viro@zeniv.linux.org.uk>
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


