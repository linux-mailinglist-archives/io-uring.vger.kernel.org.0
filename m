Return-Path: <io-uring+bounces-11117-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B685CC0DD5
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 05:18:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 94AEF300119C
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:18:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B29932E736;
	Tue, 16 Dec 2025 04:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="h1USBK4/"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B23931A7EE;
	Tue, 16 Dec 2025 04:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765858360; cv=none; b=RzK2gujQkxB8DQ+7i3urnk62GWJGInAyxSkgS+icQ05T72hp9w2W9CtYJe3+T1RNjlSEqkHKzlSI/3pa4b9YJRA2cSSF4F4rvY4v54ihqIF8cY17akgseqIt3VIZYbL+bAR5woMgDmNJSpiTnAb+E0KE/utYXFd+cLYC68UL7Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765858360; c=relaxed/simple;
	bh=ZQKnnJ+DT/olw6Lm8LfztDzd27NRaCqPT+q4vUOkjL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xm4IuW2uxmAZTpRZb1SJl0LACvS33N4n10q0GdTTuD5HCXkbhSbWLHzHT2h1rjsHutcvNNHu8tbEic0Ir4PnhaOlmG6oXRBCjQgKuMpMYUtZQnPA1uh3FzAnwAFDkS6ou6QA2s9W3WH1bwyi1YvRITeoqUD0R7Ud1wR6veRq97I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=h1USBK4/; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6hUHHzqGq4rboHjLsjdGtX8PCDDP5BU01+h08kclRhg=; b=h1USBK4/J/2BPfuVa9VqsyW5eG
	EF9ysDZT3LaosEx2IxsgDzlzsDVthW0qoCprMBdvT/9zxfeNRQPljWGc0utzwEl3NZljtUivzezeZ
	AOCCjre6hDHcccAcK0aVDYN0fqO9fVRkKlXmQPHvZPPx3mPpktdYhwjtF28U6E/PXdOhnN2QsctCT
	pGtsgQk4QfgF9VFbrvZVVz7opPLR5lXK4vehLGXrg8ECZ0MSkdVfN8T3wsERl/M8TBjrpErzHmHtK
	WCcUBAP0EXshdHGHAOkHWAOp7Ud3im47DDBFKMbzHd/N0NWJaSRE4xfFYEyNvojrYGif+S8YlzSY2
	/90/5Zxw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9j-0000000GwMC-0C6S;
	Tue, 16 Dec 2025 03:55:23 +0000
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
Subject: [RFC PATCH v3 42/59] do_readlinkat(): switch to CLASS(filename_flags)
Date: Tue, 16 Dec 2025 03:55:01 +0000
Message-ID: <20251216035518.4037331-43-viro@zeniv.linux.org.uk>
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
 fs/stat.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index ee9ae2c3273a..d18577f3688c 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -564,20 +564,17 @@ static int do_readlinkat(int dfd, const char __user *pathname,
 			 char __user *buf, int bufsiz)
 {
 	struct path path;
-	struct filename *name;
 	int error;
 	unsigned int lookup_flags = 0;
 
 	if (bufsiz <= 0)
 		return -EINVAL;
 
-	name = getname_flags(pathname, LOOKUP_EMPTY);
+	CLASS(filename_flags, name)(pathname, LOOKUP_EMPTY);
 retry:
 	error = filename_lookup(dfd, name, lookup_flags, &path, NULL);
-	if (unlikely(error)) {
-		putname(name);
+	if (unlikely(error))
 		return error;
-	}
 
 	/*
 	 * AFS mountpoints allow readlink(2) but are not symlinks
@@ -597,7 +594,6 @@ static int do_readlinkat(int dfd, const char __user *pathname,
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-	putname(name);
 	return error;
 }
 
-- 
2.47.3


