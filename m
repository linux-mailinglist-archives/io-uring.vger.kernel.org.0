Return-Path: <io-uring+bounces-10468-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 05D40C43949
	for <lists+io-uring@lfdr.de>; Sun, 09 Nov 2025 07:38:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D4C814E432F
	for <lists+io-uring@lfdr.de>; Sun,  9 Nov 2025 06:38:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 514B224E4B4;
	Sun,  9 Nov 2025 06:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="XlJdbEOy"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3432623EA86;
	Sun,  9 Nov 2025 06:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762670271; cv=none; b=J8NuCOpWyRRbC3Vc32rsW4ZcRGbSF/cRkdOVmVZeXR0hCfv9ngJVGApKeddW1vPGnZNJRbzxEeHZg3lmvrdPlvik1yJpPVmfEw89McFFyoulqoz3DcHokuzODXzkrErNdEclKTQWRLcPgSLd1oz5HNU7law/tfXjjuLUiDXog4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762670271; c=relaxed/simple;
	bh=AnXuVmtBPsHyGrokjaBHTnHhzkPSnaPaZH780cS99cY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIYJIhVJJQNK7qXQ7IN3JGCPlf5GMwT+/B+9vtLfRF0/VZJrt2c+Vy1JEHtUieECZhL/MRMu/yryetAQVjsoxm8ppkhpYyUAUFoyf/B+swrOsjR5NKSy1r3031RhyN5NZqp9Bu3aTb3eguTZC0+1Cyuxmm8JS9jA9CjTg52BG1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=XlJdbEOy; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=D5SfB8HXXA8HDhHotZ8aOqBYp6gM9fz+fE+tuhltnxM=; b=XlJdbEOyOUGJl7/6mQ58TLnTEY
	millbQhNaElXJ0u261Pv12Dg5Hp6IXIoB9aYIuvzBbS4dT7PxNS0tPMvkCIc6Rz/haERVv/2dGTjD
	Md3689dh8CoAv6lzhb7Q295XEAJvXjmMiCXX2ip3b7DdNKLsgdPOu3INN6KQ+kiXGu3YffX3vhRKK
	jGt8XdgeADLuig0eP/5AsnXTQXDtugEFiQPyv/oY4wbedrFpMhRbaDFtNmzRHeqfaGx+nZwHjn7Tk
	woIrHnmV0w6DhvMUd/0UPaTMz9uqequiUf0slLS6kF73ZbwzyI86YAHhr9gLupzzwkE8GwRURypov
	sunpLZiA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vHz3a-00000008lbo-1Je2;
	Sun, 09 Nov 2025 06:37:46 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	mjguzik@gmail.com,
	paul@paul-moore.com,
	axboe@kernel.dk,
	audit@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [RFC][PATCH 05/13] chdir(2): import pathname only once
Date: Sun,  9 Nov 2025 06:37:37 +0000
Message-ID: <20251109063745.2089578-6-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
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
 fs/open.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/open.c b/fs/open.c
index e5110f5e80c7..8bc2f313f4a9 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -558,8 +558,9 @@ SYSCALL_DEFINE1(chdir, const char __user *, filename)
 	struct path path;
 	int error;
 	unsigned int lookup_flags = LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
+	struct filename *name = getname(filename);
 retry:
-	error = user_path_at(AT_FDCWD, filename, lookup_flags, &path);
+	error = filename_lookup(AT_FDCWD, name, lookup_flags, &path, NULL);
 	if (error)
 		goto out;
 
@@ -576,6 +577,7 @@ SYSCALL_DEFINE1(chdir, const char __user *, filename)
 		goto retry;
 	}
 out:
+	putname(name);
 	return error;
 }
 
-- 
2.47.3


