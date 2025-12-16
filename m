Return-Path: <io-uring+bounces-11105-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 05C8CCC0CE4
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:59:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 959F53009FAB
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:56:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E94C732AAD8;
	Tue, 16 Dec 2025 03:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="KDN1vu5l"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686E9313E1B;
	Tue, 16 Dec 2025 03:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857298; cv=none; b=Guz6fq/ys6UBuZQgX6dRKldr5L8nuMw6hgmMOo40cNQuoXJCEZy9OgN19lJ6NdfmbeZouL8masq/jWEnySlZunVuPubEDvYTwqwoXQ16bB6SX+PLmYylG0pcQp2jfnw1lhkhv0n8coqinXAbw4c9jkBWB3OZfraiFIMlDSPTgNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857298; c=relaxed/simple;
	bh=9rjy/O7zk9NHa0zEpN/u8HwvuzoJz5ExAtWTchA9beE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbDXGezFFZVAlNZjmVteqvDMkEyYVphwt5C5bKtYaQRu13qtE8dSQQNh/lDz3fI6Nm93QsWsUYtfzaWBDaIzF1c51dbJqkYDayZmxWBVMcGyb1GuvPbbZ+HxKrIMQq8a2ZiGtN8HR0d4FKIWHDVytzfdEO6d3OppeZvbz0q/5Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=KDN1vu5l; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=W1bsT0yqh7PPRDzd1LW2lGzYKFRbDxQSk7TwwEivM5Q=; b=KDN1vu5lpjzztXS72hBTNdUZJ4
	dv7mcaW+qw/CpE8zvt4jI0SO0Ad73jIFlJjAbaORTrLaE8R0roMRvgbnr7CL43byzhmAZxYTbv8cY
	Q/Nfw2lO8atJbfi9RdzrM5i3v2itRq/uyRtadIGTHgVsHg57APPZkTyUDYbdImuDdHWR8CcGnsP6V
	ISLm/ZtGnSmzPRu3cQGQmLnACzEojXYoxeMzIfprQjU2Kpaf6fvlR4nB4RGr37XXQnuBdwly2en4h
	73IrYqCP7PrmqmBKEFqFEUUrI2IaUJ7fCeuA8vpcfVFc9JK2j0W3JHgVbVFO6aozK/htQfiIzsp9M
	KG8yHLNA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9i-0000000GwLq-2EUa;
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
Subject: [RFC PATCH v3 38/59] do_fchownat(): unspaghettify a bit...
Date: Tue, 16 Dec 2025 03:54:57 +0000
Message-ID: <20251216035518.4037331-39-viro@zeniv.linux.org.uk>
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
 fs/open.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 7254eda9f4a5..425c09d83d7f 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -810,30 +810,26 @@ int do_fchownat(int dfd, const char __user *filename, uid_t user, gid_t group,
 	struct path path;
 	int error;
 	int lookup_flags;
-	struct filename *name;
 
 	if ((flag & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) != 0)
 		return -EINVAL;
 
 	lookup_flags = (flag & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
-	name = getname_uflags(filename, flag);
+	CLASS(filename_uflags, name)(filename, flag);
 retry:
 	error = filename_lookup(dfd, name, lookup_flags, &path, NULL);
-	if (error)
-		goto out;
-	error = mnt_want_write(path.mnt);
-	if (error)
-		goto out_release;
-	error = chown_common(&path, user, group);
-	mnt_drop_write(path.mnt);
-out_release:
-	path_put(&path);
-	if (retry_estale(error, lookup_flags)) {
-		lookup_flags |= LOOKUP_REVAL;
-		goto retry;
+	if (!error) {
+		error = mnt_want_write(path.mnt);
+		if (!error) {
+			error = chown_common(&path, user, group);
+			mnt_drop_write(path.mnt);
+		}
+		path_put(&path);
+		if (retry_estale(error, lookup_flags)) {
+			lookup_flags |= LOOKUP_REVAL;
+			goto retry;
+		}
 	}
-out:
-	putname(name);
 	return error;
 }
 
-- 
2.47.3


