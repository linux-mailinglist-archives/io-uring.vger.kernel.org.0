Return-Path: <io-uring+bounces-11673-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4567FD1C662
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:37:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 316F030ABCD1
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C5A532FA35;
	Wed, 14 Jan 2026 04:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="dBP1edPb"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8202E9ECA;
	Wed, 14 Jan 2026 04:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365118; cv=none; b=EaE2UhTveGkmWcRbI78wviaP5b5gdNpUNbkeWa/5nbL3mpnf6RMKebcgqmx+CathV63qHrScIVCgAsJLjr1F+Vn/YHo4zogDe8OSwMnL+32uOuKz9kz5YAfiX2ZQ/SX+Qeo2zhK233szUkj6SpQ+wrUvT5Ospw3s3n+49VbcFUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365118; c=relaxed/simple;
	bh=JGIE1Xn73bLwFlYFa1TfmbrgYmGn/Qjf/OmTPOTQAHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/oucq4lF7cbxefsGPu5W8k/zhVUVDSmL5eRLq6SiQWwIPaSykiL+aAUmaHZ+0U78hLt6ah9HkfwFnbUtdha/CpjnOy56Wl1R8e5Cwfg7aBKr5iEhf8PnMIBNqMCFx0u7SIAAuvVMQJhP9hJB+NrXDEa5WvluasT64G9tsdbMes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=dBP1edPb; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=w+ofnS0NH5sbZoyF6cXcsB14QEggir0J8dBphBaxor8=; b=dBP1edPbZtJmAyoFq/2obna7dP
	leWUifReRB+aEsaQlG8yfZoRSK/6myvFJFh+nakW/e7BLpfjTazQjve+jRsXGEgfBerbPCduvWIVO
	0yBgfxdJR50ojXoYSaGoVzT3U3s9Ir2iH+T0jQR/KOYynEjOExbuhjKX7KGQwKPc1klSKjmU8MMwY
	krUpOC2nYVn+BjkwaU30zDFtNu5LPHxPOdgJa9r3fs+yAz+jcMEbZp0bkFHXV0oCZIzjNFkxU7cJg
	FNKbitKXPC8zeCCfBT7UpkhtYdVqps8XWF/x/txMtU3igeToizpCI7EIi84cWM1guSPXlwdNREOvg
	1OTHTVww==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZK-0000000GIuu-1JcP;
	Wed, 14 Jan 2026 04:33:18 +0000
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
Subject: [PATCH v5 48/68] vfs_open_tree(): use CLASS(filename_uflags)
Date: Wed, 14 Jan 2026 04:32:50 +0000
Message-ID: <20260114043310.3885463-49-viro@zeniv.linux.org.uk>
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


