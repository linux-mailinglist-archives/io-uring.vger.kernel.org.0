Return-Path: <io-uring+bounces-11678-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 04259D1C683
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:37:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1EA5030B53CE
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:33:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8C35330676;
	Wed, 14 Jan 2026 04:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="dkPcWTw8"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0882D8384;
	Wed, 14 Jan 2026 04:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365118; cv=none; b=CwzuATdM3IiaKGghfiWBL6sjfg9H8gzsBzNNMWSA/VU856EUdQAzQCd0vCLWONUD6fNkIhtEsw0bb79pg3CPgeyYay/tKI55Oe2phnKgMeKSwiT/dqYJiLgHQqBPPvxoDGJ1g2nWxHYD2uV5808elqwlB9j3Fj+mLQR+eZmjWqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365118; c=relaxed/simple;
	bh=Lw6fkolzG2z+rslNz1/IkWVTRMaQxHK9deworNvUlPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dBBvMFbjj5/QsUb/71QYKGisW0IvY60qv+d5oAL5+t9ugnsLQsF4bx0KFhx6o/3dcJsmo46LGgObvn37e2h8mKqaqWWfMWo5kNCUolWZJAtvS/hyA3vafIZ7usPtNRHKS9cWrhyXGylSS8cfp12HJycsTlGbVVhGaiaT8rk8+Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=dkPcWTw8; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=XXA+defR+SzZCm3KczoEbpd9A4VhKcPk/m8STTG/ds8=; b=dkPcWTw89yMaDh62THni9wpY/7
	VwJwmSBfa/eMI16hFaGDw4/aN1UT5xoDD1dH3unmtL2ZewruZuZsUjGOLNyza9MwJyhHFq57MWCcX
	Z9vdb9TBCtXAx57ia4wgmV0E5gP7LEZRnM2FVC3HTcFj0+fFpRcD5BxcIS9PIblvFRMyHowRuFgnY
	N+9xvlRxIDzrbBushj31Z46WWYRNYrG/XlufG392ZQyvTKJ6CZgT0EVCEzeGVcCxnmQc8wNbdsz8x
	KLeV2+L0TR1yBdOi6umAVXdEDaHmi+KoxIkkkNCQs9/DbUprhwEV5J7SICJEIkHn3nzkQNcY0jWHK
	FbD42L8A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZK-0000000GIw1-3sPr;
	Wed, 14 Jan 2026 04:33:19 +0000
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
Subject: [PATCH v5 50/68] fspick(2): use CLASS(filename_flags)
Date: Wed, 14 Jan 2026 04:32:52 +0000
Message-ID: <20260114043310.3885463-51-viro@zeniv.linux.org.uk>
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


