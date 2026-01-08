Return-Path: <io-uring+bounces-11448-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E09FD0169F
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:37:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B3D8930215E0
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:37:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F172D31AA92;
	Thu,  8 Jan 2026 07:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="FPtryimB"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EF9279DCA;
	Thu,  8 Jan 2026 07:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857812; cv=none; b=lx+XPX1CE9oq0bPs7KBQ5WgcVWBBdd1twUyt6FLZnciCSpEj3s9Ejdzu03FD3bwV+2ftV2I6r60NC4Na3pb4kQ00YJcIsLwXZnXOxq20p8ljH43wxqIWCCwZW94415YW22KNnzbgtllRbk674zM+yVSFdRTYYtSzPtcQjkhMbQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857812; c=relaxed/simple;
	bh=ejixYtbS5/J13hPkZAA0xbfFwhUsT8keMfQ9xW+VTHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BhxHVAdJOx8PYEdFDBbD4iyQWOWmAOMouxyDTzqKLg27bPNRGfc77VOtm9kJxtdYeT9DR9hQNC5Aiw+IT5K400ajNMMEAfW1Cb7q0HbbRdLPKTty73ABJDlWJRcyosZaKuPstuuveqAwjUFKl69LThmkoc/43PPBDhH8sqzUTAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=FPtryimB; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dtcntkzvfcdf8HXOy2/XIfUxX4DMLOCsDkWNa4rKvpM=; b=FPtryimBaf6ySEDTxOFGy86kmg
	1h38DhzSwKQ+WfieGiYP39gOPmG8S/XiE10y/FRWWXlRdT5bMr19iNHBIgwztW5FtHU90VaRHhPYc
	DS0qWEHOOILNyorCBfrSBp6ODa5JYUt3GNvpwdWwoGpGvgd/X/tDy5XZkDizIOFW4GzH0DRi0jO5S
	vgrZjtGi4vw3bWGqK8kQYKUz57JrGeuQcdr2Rx2JPNHknKqD92j/JW+6qPS3Ugx0H9536I3VuZDOa
	r1KMJxmr9zAuFAvWC+0nb02OiaPlfldb/6aqNuaQRCK8E36SXQJoTtpe3ilBPL4jLx7/TKncG/zwl
	J0gGwyzA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkaq-00000001mgF-3aRf;
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
Subject: [PATCH v4 09/59] do_readlinkat(): import pathname only once
Date: Thu,  8 Jan 2026 07:37:13 +0000
Message-ID: <20260108073803.425343-10-viro@zeniv.linux.org.uk>
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


