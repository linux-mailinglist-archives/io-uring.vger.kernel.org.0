Return-Path: <io-uring+bounces-10836-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EB2AC94516
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 18:03:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F1E13A5F04
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 17:01:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1651D23AB8D;
	Sat, 29 Nov 2025 17:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="T4Emt3U4"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBB21F4168;
	Sat, 29 Nov 2025 17:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764435699; cv=none; b=VhQIdcQRv1+H2PPDOOE2E9J4ImVrnybJp0PlEMBP3aiTMwiydm5lEbwAOMcmlig5PlA2t9rEe2x5qfyJg83tTrZJD3cCgH8O1EX7Q6lGVHBu7+ety277NqFW0h0n+YYrNrDEwcpVkCtixGzsoCFv3r8jl+NDHt7KI8H0gJS3pgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764435699; c=relaxed/simple;
	bh=xQ7El2M28M0wHx+P+g8Yo1qBcNgqMr0WmiWcFdzVu9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvF27EPT529bo790suBLTfTYTTdJC9ru6QpGXH9cAgqpxqiEkz3uaGr5xMtbbQTnU+TbO2m9+O3q0Vc6lAeBt++WaZmj6SGkMAIeAbltPqKc8coe7dA0JR7KWaUMAlCuWd2bdIJ3fG44kJBHXyAeYuvtRoHcbr8CF8JvqT6Ve1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=T4Emt3U4; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=OSmE8RDttZ57sO3CJH0P4rRo3qRd5TrH+VcvqqudS9I=; b=T4Emt3U468OJpWCEF3VRYAR/ll
	NrngMAi2N4+03J2sWont+MJqyvSrCoOH1lA8vA5MbkgaGEpLXKEviheoy7/ipVY7BFatvGwqhpuU1
	M8BoBhPA1mi9z2JXs/A28B8splPaCWZz12SK/iPthYoIvYtfEssVpfXBP4KfWsQwpz9+cbtdB7+69
	S91M7w0OjBHpWb/A3Ka7e4opjn0ZAghy83oTB4ivEPap1HSTjLyafNSaudFX8rYzSJjI2Q78pfXYB
	Jjz8R0IbMFZc/XhjVX9tw1NbP3coMJ3I43J4O7TZFYFLmk7cbjFELZoBZtU9KuztPxrd1sO2a1tU+
	/27i2QlQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vPOKN-00000000dCh-0yab;
	Sat, 29 Nov 2025 17:01:43 +0000
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
Subject: [RFC PATCH v2 06/18] chroot(2): import pathname only once
Date: Sat, 29 Nov 2025 17:01:30 +0000
Message-ID: <20251129170142.150639-7-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251129170142.150639-1-viro@zeniv.linux.org.uk>
References: <20251129170142.150639-1-viro@zeniv.linux.org.uk>
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
index 8bc2f313f4a9..e67baae339fc 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -603,8 +603,9 @@ SYSCALL_DEFINE1(chroot, const char __user *, filename)
 	struct path path;
 	int error;
 	unsigned int lookup_flags = LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
+	struct filename *name = getname(filename);
 retry:
-	error = user_path_at(AT_FDCWD, filename, lookup_flags, &path);
+	error = filename_lookup(AT_FDCWD, name, lookup_flags, &path, NULL);
 	if (error)
 		goto out;
 
@@ -628,6 +629,7 @@ SYSCALL_DEFINE1(chroot, const char __user *, filename)
 		goto retry;
 	}
 out:
+	putname(name);
 	return error;
 }
 
-- 
2.47.3


