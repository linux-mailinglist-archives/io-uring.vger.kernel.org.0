Return-Path: <io-uring+bounces-11106-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 94526CC0D1D
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 05:00:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C30F430C014D
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:56:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E93F032AAD5;
	Tue, 16 Dec 2025 03:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="elUMOXQx"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685DD313556;
	Tue, 16 Dec 2025 03:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857297; cv=none; b=Jmg+QsDw3xWEtsH8zLE+cjF4eZeniU+AhKY10JpQmnUyPOdFQ7yVwxcsVemF8BqtGU1C06/lwbHxi4D0Z9v3HrBgp2jCps9YbV2sPG6HRjnWTTa6gA26oOstToUcjMHWIt0+K/HAPkL/xgaF3vV09zgaqGCPZjz+53rg0mCnouw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857297; c=relaxed/simple;
	bh=Lw6fkolzG2z+rslNz1/IkWVTRMaQxHK9deworNvUlPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWDhRJfIhXaMravltVgfltBmz9olUmi0YX4SGN9edBW/gQpIrUUVW0xwUvB+pcMkbo3RH4TfgkUVWadVA5E5XfggNkJN/M22cOl3qR8NLUW3MHyYDA1BBptTqKpk0INRncoDcljqs1r03nMiB9Gux/7XuzJLSO7rVXxvLSU2o1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=elUMOXQx; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=XXA+defR+SzZCm3KczoEbpd9A4VhKcPk/m8STTG/ds8=; b=elUMOXQx9qHhJ9VofCpbq3/oq3
	TI088ET0JWDJuEiDjh4pEqtL7AjNVVKUzNIBFObVdf9JEacu7z3Wup7j6GZuFZLN7o1nLzetZhLoT
	VC5BLh41b1mj9Om2FDxO2PQU7KkrzwQUgJ1PQwXem7I9NsM/qmvRt/euUENF0z48QRh5yVgxmcEx9
	4MAcmA3l9e+3cqkypaqOO63Ijk9Vu04u0+93zzH62oTHvexX7mptPjIg7/OJbeMekDIyqOdgaFsJj
	4KYX/rbFjdzAYOqn2/0bJEry/U3GKht2GEaGRuDGPQFZ+xVhUIflQcmLyqguNugyCpqpmlrDW7EKN
	20kvDj1w==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9i-0000000GwLd-15SL;
	Tue, 16 Dec 2025 03:55:22 +0000
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
Subject: [RFC PATCH v3 37/59] fspick(2): use CLASS(filename_flags)
Date: Tue, 16 Dec 2025 03:54:56 +0000
Message-ID: <20251216035518.4037331-38-viro@zeniv.linux.org.uk>
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

That kills the last place where we mix LOOKUP_EMPTY with lookup
flags proper.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/fsopen.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/fsopen.c b/fs/fsopen.c
index f645c99204eb..70f4ab183c9e 100644
--- a/fs/fsopen.c
+++ b/fs/fsopen.c
@@ -181,9 +181,9 @@ SYSCALL_DEFINE3(fspick, int, dfd, const char __user *, path, unsigned int, flags
 		lookup_flags &= ~LOOKUP_FOLLOW;
 	if (flags & FSPICK_NO_AUTOMOUNT)
 		lookup_flags &= ~LOOKUP_AUTOMOUNT;
-	if (flags & FSPICK_EMPTY_PATH)
-		lookup_flags |= LOOKUP_EMPTY;
-	ret = user_path_at(dfd, path, lookup_flags, &target);
+	CLASS(filename_flags, filename)(path,
+			 (flags & FSPICK_EMPTY_PATH) ? LOOKUP_EMPTY : 0);
+	ret = filename_lookup(dfd, filename, lookup_flags, &target, NULL);
 	if (ret < 0)
 		goto err;
 
-- 
2.47.3


