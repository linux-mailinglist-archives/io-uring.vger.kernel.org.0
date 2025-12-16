Return-Path: <io-uring+bounces-11102-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 19D00CC0D11
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 05:00:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1A56E30B4552
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:56:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9B5632ABC1;
	Tue, 16 Dec 2025 03:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="UvPnDkL0"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5954831329D;
	Tue, 16 Dec 2025 03:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857297; cv=none; b=XblCxCJwpY5hPT2Vi8EpVNWZeQgo1UXcKkM9GGBQZkmfjfbu9ffMqWPB60GZsG8LMV81nvI+SApKiV7nW67Zzd8Q5VUbWmUwnhRbwTqgZ0GxxgQxKGC29SW113rc/TrJAee+t5A99xx5zVt8ePCcWGM66it57TZ4Ww7A2gLr/F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857297; c=relaxed/simple;
	bh=dKazOTpP98uEsD5tvT0eCFSPEKi73Z7M/OFRDrSl8h4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hfr106AgqG+yEPUFwOAQ5gRS/NSZZkONxu/58A8zyhCPlCZKKgybCwnkJTWuainX22+/2WaxZ6JERyppW18h6QnRueP+E79JlooOrgnLrxX062Dj3b9y+lLjZtrbzjoEKPhcAiiwndXwDa4+KVDS8NabW88Xq0Y+yWN/l7tB3kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=UvPnDkL0; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/taDnA0SgX1kjdBTGSIJQ+UnMnEm3NgXYjqO+SzjTkM=; b=UvPnDkL0IhCR+6D1UuILbfY7OM
	amMR7Scg1UkyevFJ4ioE42G2hh6unZm++Tbf96fnqarlSLcq5Au5E7yivgAzS9o1aCp57TTQvA1Xu
	cUxU/FmtwiobvAs3lOuRoOyebwPSnyu8ECPVeWoPVkTJ8g/5yLLMAPJ3smAMJZlOSaOIJBpHtqAMz
	qmPVygLbQHxqlSCMqWM4SocT39ITH2VrHB3GIBEKS3AGiE79+0rhCGQOT4g+8Sq3hDuwSA+tJY9b9
	I1WBIYRd/VDPSZz+NdEjpP7f1AzEMH2VJE+DWTLQ0mBLOXBO3APtOjXZCqKxO0NWH7UDXnbWmp5Ya
	8mYQRv/A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9h-0000000GwKu-2FHa;
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
Subject: [RFC PATCH v3 29/59] simplify the callers of do_open_execat()
Date: Tue, 16 Dec 2025 03:54:48 +0000
Message-ID: <20251216035518.4037331-30-viro@zeniv.linux.org.uk>
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
 fs/exec.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index b7d8081d12ea..5b4110c7522e 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -815,14 +815,8 @@ static struct file *do_open_execat(int fd, struct filename *name, int flags)
  */
 struct file *open_exec(const char *name)
 {
-	struct filename *filename = getname_kernel(name);
-	struct file *f = ERR_CAST(filename);
-
-	if (!IS_ERR(filename)) {
-		f = do_open_execat(AT_FDCWD, filename, 0);
-		putname(filename);
-	}
-	return f;
+	CLASS(filename_kernel, filename)(name);
+	return do_open_execat(AT_FDCWD, filename, 0);
 }
 EXPORT_SYMBOL(open_exec);
 
-- 
2.47.3


