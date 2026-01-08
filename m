Return-Path: <io-uring+bounces-11449-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A915AD016B8
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:37:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 10CD83035AA6
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:37:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C42B330B07;
	Thu,  8 Jan 2026 07:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="wB3/enK5"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13039318B85;
	Thu,  8 Jan 2026 07:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857812; cv=none; b=a+cPMPVj25XUUcTRTuVpORjtdcdJ0phJjiufu092wJ/kXHVAGIw+DGQVCYoUEIQxkQxPGVowcOcTlxJq+oHZ5BibgijIR4UJSwDj1Bb0Wa/OyMcJ02A00PCzYGH48WsaiSC7/riRn05B8DqHgmHiLFfjSuZI9GWzWyyi1BQuA0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857812; c=relaxed/simple;
	bh=zFlDLU2alFVD/MwuTFbdq6QS587tb9atKC26F68cFjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iintklJTLu9h7yvvaGW0zcz5+Bcrt0YKuFXKWyZFDerzvHwYbTKdq5x4TncHCnEahDSrxU12OjmrOYhpPdaxKTY8QlXlCHI1LT4uyqo1bP1JmtIAdwApm37vssHStvMO2agwz3CZD3QVLUv2yR/EYAqTwEBo6ImoKGdz2WYzW7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=wB3/enK5; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=KE0bqgoAYg4WN/vY/qas7LhrImQSJi8EcGd+/Tk2T7o=; b=wB3/enK5RgfmAhp5YUwMjO87c9
	CqPv7z4TAKkutVZV5/JzhBVXetAuoXRpTQfvwAxdCr8bhcWmPz2q3OtyzBb/f5L2F10YpzKAu/3KQ
	wX3tPDZnsBjLdo6bfGB7rcTlPIb64dLPf6n+ewrod835Gxa4+FcBqNY+81+oTfP8rpTXnGkltHpMj
	498EGM6YgluWM/dxu8RlbFvXhIcvDOiTx6iIq4CqVb+3Z4Im/lgydJ/4rGpiCPJhMYfeNwt1BiUo1
	Wikq9LvPPH65O0jDPAfb3loYIQcYIVOXpCrn0y4hSnyjYd+X6TrC7rd9H0SBAtOHE8d2o6WfEwSLG
	eVN92xtA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkaq-00000001mg4-2oUl;
	Thu, 08 Jan 2026 07:38:04 +0000
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
Subject: [PATCH v4 08/59] do_sys_truncate(): import pathname only once
Date: Thu,  8 Jan 2026 07:37:12 +0000
Message-ID: <20260108073803.425343-9-viro@zeniv.linux.org.uk>
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

Convert the user_path_at() call inside a retry loop into getname_flags() +
filename_lookup() + putname() and leave only filename_lookup() inside
the loop.

In this case we never pass LOOKUP_EMPTY, so getname_flags() is equivalent
to plain getname().

The things could be further simplified by use of cleanup.h stuff, but
let's not clutter the patch with that.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/open.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/open.c b/fs/open.c
index 6f48fa9c756a..2fea68991d42 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -129,14 +129,16 @@ EXPORT_SYMBOL_GPL(vfs_truncate);
 int do_sys_truncate(const char __user *pathname, loff_t length)
 {
 	unsigned int lookup_flags = LOOKUP_FOLLOW;
+	struct filename *name;
 	struct path path;
 	int error;
 
 	if (length < 0)	/* sorry, but loff_t says... */
 		return -EINVAL;
 
+	name = getname(pathname);
 retry:
-	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
+	error = filename_lookup(AT_FDCWD, name, lookup_flags, &path, NULL);
 	if (!error) {
 		error = vfs_truncate(&path, length);
 		path_put(&path);
@@ -145,6 +147,7 @@ int do_sys_truncate(const char __user *pathname, loff_t length)
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
+	putname(name);
 	return error;
 }
 
-- 
2.47.3


