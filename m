Return-Path: <io-uring+bounces-11485-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C77DBD01895
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 09:15:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A241F30C4476
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:59:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A935343D75;
	Thu,  8 Jan 2026 07:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="mQOuYjMI"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D455D329C7D;
	Thu,  8 Jan 2026 07:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857821; cv=none; b=cL30tUPRpWIA3jSmvQ6kGYFfv9xBHu9HGoQx7c5a5ul+8BnKdZDF0TFXmjoU0TCQ+heXDPaOlYyWWmahAn48/+rmYBdYbpDb4XJEHrKZAZNk6+hzdO7jcc0/1+TVArBSxd+ZALA438pwxqEFM7FlLqh54+hGl465VbbVLVvGbXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857821; c=relaxed/simple;
	bh=JGIE1Xn73bLwFlYFa1TfmbrgYmGn/Qjf/OmTPOTQAHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qypotK2MOR+CvxgcEL/Mda0b58bseOQ3xgvEitjyIkScu33GKeIL9zes3c0lj2MoiDEMqSvgkTAaStuT+CsjBLZgdJYucl36dFKos9im45b/qAEngDRt/uoP2OE96rXWJeqZkZw2o9Z9QCnK6rKRHe2MoVyX9ksrygaD0YvExgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=mQOuYjMI; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=w+ofnS0NH5sbZoyF6cXcsB14QEggir0J8dBphBaxor8=; b=mQOuYjMIw/MxruNXwEsIy0TBW0
	G6/01cKmwDecRFaeDRsDRocV3e0bXU+qA5Z8dEsh9vtK1x3qzFF+eAa4Sqx5wD5Egt5HVgRCIclFl
	Ep2J4AMQdi3V4Y92F8ckEueK7xC05L82clsqcJRaUqP1DNgNQf9ngVO5nyMV6VLSHjuNeef0MV6bJ
	zrf0uE0naxN/tSsL4GfJ3NN+r4bUEPP8XwMVKOW0PC/AuxdNiQAAJ3x2tQTy7e7NQ/EkWR5/08PdP
	3t94/ns0CLzAM9z++yZTCSHR1zEL5Iks9/00jeyAZUuFRdPnHsPbx8tBb4JDJ/OTXgikkACZWjVBO
	NKMyDY8w==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkaw-00000001mpd-3Mib;
	Thu, 08 Jan 2026 07:38:10 +0000
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
Subject: [PATCH v4 36/59] vfs_open_tree(): use CLASS(filename_uflags)
Date: Thu,  8 Jan 2026 07:37:40 +0000
Message-ID: <20260108073803.425343-37-viro@zeniv.linux.org.uk>
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
 fs/namespace.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index d632180f9b1a..888df8ee43bc 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3082,13 +3082,12 @@ static struct file *vfs_open_tree(int dfd, const char __user *filename, unsigned
 		lookup_flags &= ~LOOKUP_AUTOMOUNT;
 	if (flags & AT_SYMLINK_NOFOLLOW)
 		lookup_flags &= ~LOOKUP_FOLLOW;
-	if (flags & AT_EMPTY_PATH)
-		lookup_flags |= LOOKUP_EMPTY;
 
 	if (detached && !may_mount())
 		return ERR_PTR(-EPERM);
 
-	ret = user_path_at(dfd, filename, lookup_flags, &path);
+	CLASS(filename_uflags, name)(filename, flags);
+	ret = filename_lookup(dfd, name, lookup_flags, &path, NULL);
 	if (unlikely(ret))
 		return ERR_PTR(ret);
 
-- 
2.47.3


