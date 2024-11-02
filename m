Return-Path: <io-uring+bounces-4345-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6CDD9B9D9F
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 08:32:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19091B21787
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 07:31:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 218B415688C;
	Sat,  2 Nov 2024 07:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="EAetXOvQ"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFA713C689;
	Sat,  2 Nov 2024 07:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730532713; cv=none; b=d0ZTYsXho5vTGEmRfYNUY5DtFPLx9stczmEFnz8p4dEf3D5jrHYaxIXa8+jG862eHDfm2DPogOAeu9ycDrY9f4Q9hj7wnbtPJ02aslCVMwBDUmvT5zadCUxA4Nc63kRFDk2eGYzBrDsDhJF8BqEW6sZ2AaVL+FwtmrSmxZFKdDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730532713; c=relaxed/simple;
	bh=wrAK8GWUnKgolQ2z/c3Ma/GJvRqLPBCuOn6ORmedNZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FTNM9f5vCwAwn3WkPUCyT59iqWBKIJsXYdEyny5AOl2XV4Df/1DcccYyrZ2fmy1RdY75r1r/z9bOBdBjj/nTRPmTUydChkxp18GA6IFA8rAHqHfdTk5AegAlEkzTyDWPRsdeYXOpGkHU5Cbw77SHrcPSPb3PsmK4g26sBARVdmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=EAetXOvQ; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=DGhSDWn32QTMB3ujcBJ0Ej51Fa5Ytz9zjamnl+wee8k=; b=EAetXOvQ1LmMQh92iy/lD5AH63
	76zldOodgr3F8OVHeMqeHKmUy+o0M5Tm3yUsts9B446+tnfglaoxazboGjYtoRewFuhQoeAHiI0DB
	ErUtEmopIe387YAM2qC0q4JIemv3WDO0iahuPuaJX1tAXp450LWVv74hcuEnJNs3SwjEK394clWuy
	IG9xHwCw4wkEQShUoxFuEXTzNH+VYTVtl2S9TCHME0fsiJ3Ek/fUkVg3XRI1+glRm3IZ+lNX+B375
	6RUDOmbFeavHbh3NUW+XswwBJUn9/z/+gHo5e5we5VrNWT99SDFgyTsKaNNsYl1p0zv+s0wNy/+zv
	9Ff7qaRA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t78bt-0000000AJF1-0cIW;
	Sat, 02 Nov 2024 07:31:49 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
	io-uring@vger.kernel.org,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
Subject: [PATCH v2 01/13] teach filename_lookup() to treat NULL filename as ""
Date: Sat,  2 Nov 2024 07:31:37 +0000
Message-ID: <20241102073149.2457240-1-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241102072834.GQ1350452@ZenIV>
References: <20241102072834.GQ1350452@ZenIV>
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
 fs/namei.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index 4a4a22a08ac2..aaf3cd6c802f 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -588,6 +588,7 @@ struct nameidata {
 		unsigned seq;
 	} *stack, internal[EMBEDDED_LEVELS];
 	struct filename	*name;
+	const char *pathname;
 	struct nameidata *saved;
 	unsigned	root_seq;
 	int		dfd;
@@ -606,6 +607,7 @@ static void __set_nameidata(struct nameidata *p, int dfd, struct filename *name)
 	p->depth = 0;
 	p->dfd = dfd;
 	p->name = name;
+	p->pathname = likely(name) ? name->name : "";
 	p->path.mnt = NULL;
 	p->path.dentry = NULL;
 	p->total_link_count = old ? old->total_link_count : 0;
@@ -2439,7 +2441,7 @@ static int link_path_walk(const char *name, struct nameidata *nd)
 static const char *path_init(struct nameidata *nd, unsigned flags)
 {
 	int error;
-	const char *s = nd->name->name;
+	const char *s = nd->pathname;
 
 	/* LOOKUP_CACHED requires RCU, ask caller to retry */
 	if ((flags & (LOOKUP_RCU | LOOKUP_CACHED)) == LOOKUP_CACHED)
-- 
2.39.5


