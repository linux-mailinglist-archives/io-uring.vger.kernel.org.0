Return-Path: <io-uring+bounces-10473-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B31BFC43966
	for <lists+io-uring@lfdr.de>; Sun, 09 Nov 2025 07:38:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8B9E3AD43A
	for <lists+io-uring@lfdr.de>; Sun,  9 Nov 2025 06:38:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C64AC258CD7;
	Sun,  9 Nov 2025 06:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="JW6RFjZV"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33EC138F9C;
	Sun,  9 Nov 2025 06:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762670271; cv=none; b=JtlxsZ5EEZ+zu2JNf780WYtVPcYRApeuwoIINwmFv7VA4f3w/f4HAaqZ+CZmuy8yvKDR/CoomrDZaJHl5zQi4l7KVWQXiNwzqpleQWEyeaxCK1omdtRs6Oo+yQv8SXHYvrCNxtRkcXYL3rGiE2EN6I2GRILaBn7qMXqHU+G+I5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762670271; c=relaxed/simple;
	bh=ejixYtbS5/J13hPkZAA0xbfFwhUsT8keMfQ9xW+VTHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PyeJKwRznX5tVAKo1I+ISPXBKlgxgkY/zioLFK1T79dFLy1qEL3d8eKfEnzdTpQiNUif2kSs8DaI0gon/dOJnfYvsOyPxArz+CyOK/IoOKpj0mMK10xm6JtEklC7gUTmmpcomCTQjzzPSnIhOjdBWvVgA6W1IvkszKNoj+YnXAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=JW6RFjZV; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dtcntkzvfcdf8HXOy2/XIfUxX4DMLOCsDkWNa4rKvpM=; b=JW6RFjZV5C+hRLv5XTAGj96bho
	5HmhmXEaE2DJufiEeHgRiZBczAJUL7eSMrycc5kmynEYwJeTBKOePvL8NapxhrXUrgS++Bje5rOD5
	SeckIvLYPeYHZIywHph90mvtZwfuaJD6GkyRohtM/3ilP9Ouzt0UxA7CbD9HJSO8lBFHRfRSs9VMb
	ixAeX5tGuOKOFBViQI2ccwCEApMjXZnIaX8khfQOopJWcPOL5YNe9qiFh5xHWZ/GS77R+l+CL24cC
	C3lXkyQglttI9FX4fJ/AFsi+QrBOhwpYVwIXNbhNvQs6qezSrtRWn4vOGSsDESS/0HRFtxiY0frxa
	O5vRYSug==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vHz3a-00000008lcL-2Wp7;
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
Subject: [RFC][PATCH 09/13] do_readlinkat(): import pathname only once
Date: Sun,  9 Nov 2025 06:37:41 +0000
Message-ID: <20251109063745.2089578-10-viro@zeniv.linux.org.uk>
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

Take getname_flags() and putname() outside of retry loop.

Since getname_flags() is the only thing that cares about LOOKUP_EMPTY,
don't bother with setting LOOKUP_EMPTY in lookup_flags - just pass it
to getname_flags() and be done with that.

The things could be further simplified by use of cleanup.h stuff, but
let's not clutter the patch with that.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/stat.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index 6c79661e1b96..ee9ae2c3273a 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -566,13 +566,13 @@ static int do_readlinkat(int dfd, const char __user *pathname,
 	struct path path;
 	struct filename *name;
 	int error;
-	unsigned int lookup_flags = LOOKUP_EMPTY;
+	unsigned int lookup_flags = 0;
 
 	if (bufsiz <= 0)
 		return -EINVAL;
 
+	name = getname_flags(pathname, LOOKUP_EMPTY);
 retry:
-	name = getname_flags(pathname, lookup_flags);
 	error = filename_lookup(dfd, name, lookup_flags, &path, NULL);
 	if (unlikely(error)) {
 		putname(name);
@@ -593,11 +593,11 @@ static int do_readlinkat(int dfd, const char __user *pathname,
 		error = (name->name[0] == '\0') ? -ENOENT : -EINVAL;
 	}
 	path_put(&path);
-	putname(name);
 	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
+	putname(name);
 	return error;
 }
 
-- 
2.47.3


