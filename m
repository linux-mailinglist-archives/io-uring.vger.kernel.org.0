Return-Path: <io-uring+bounces-11498-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 16EA1D0181B
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 09:07:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9CEF83110E6E
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 08:00:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 998783469FD;
	Thu,  8 Jan 2026 07:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="LCqYn/K3"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8772B342532;
	Thu,  8 Jan 2026 07:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857823; cv=none; b=XWEIv6sDKxeZHWXy3Q9+dC6eVC3gHfMtHkZlM5zjkFjLYE+tweC/0Up6CEsJPQ3DIvrTIEfO+UgYFFe0hDaK6/oAHxQPcVuS/bQ/BTgNsbcKxLm4hB9Wjm8mnuKYM5ukWiEXNn6iDsaJQhwaAQiygVfEexagBC8lXQKKklc/hrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857823; c=relaxed/simple;
	bh=ml4RNN/VCnYi1f5kE1GxmfC7TyVm/T5H+RGWeGZ6lPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0Dkss0TV+VCDrXoTW6r8iwU96kl0DLgG+5shPYe5l786DxAl6PJGqGJf63sNUXyh/m9PtWf/fUNc33IYTIj6xjslLWwZk4UfoloDeOKiY+D1xnZe3uXVMkoDM7/YRGqjG0YU3n1VT4G8CuAshs07k8Fp2oo4CXBXLeRfkb4L6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=LCqYn/K3; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8u3Dw0scZ1Xzc2uavtsf6xcpNT1HTgSA1P3hF8Kuknw=; b=LCqYn/K3og9GsXtqYeqjHOltkL
	sYN9hFq8j+w4NVS6su0ZVBTajLk0GdoSNLTXtr3yCp2VBQUtZJQI0C5wIsmQpTWwiPchv0ZlopuCY
	2145jBUa4qAjFLE5Y6hGLUvNn/jGvPUTvQs9QqSFplPoG4bl+3E2O4oAxdxUkDv+w4qj1F5tRPYLF
	RCzkN90bl8cSvXgMrdwhSZB1tNz8czldO5sHp6SEWni2k4sGjjF5YQDMkOPM9Tuc56DBH9IDJrnbc
	nAXvroYkl/rwo4xJ2Xssj3J1xL+qNS2zAOrSh7vnEPf2JYmXxQC1JNBCPs1YpZcvtVkClqUA7vhwc
	HLqpoCGQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkb0-00000001mvQ-3OHy;
	Thu, 08 Jan 2026 07:38:14 +0000
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
Subject: [PATCH v4 54/59] user_statfs(): switch to CLASS(filename)
Date: Thu,  8 Jan 2026 07:37:58 +0000
Message-ID: <20260108073803.425343-55-viro@zeniv.linux.org.uk>
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

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/statfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/statfs.c b/fs/statfs.c
index a5671bf6c7f0..377bcef7a561 100644
--- a/fs/statfs.c
+++ b/fs/statfs.c
@@ -99,7 +99,7 @@ int user_statfs(const char __user *pathname, struct kstatfs *st)
 	struct path path;
 	int error;
 	unsigned int lookup_flags = LOOKUP_FOLLOW|LOOKUP_AUTOMOUNT;
-	struct filename *name = getname(pathname);
+	CLASS(filename, name)(pathname);
 retry:
 	error = filename_lookup(AT_FDCWD, name, lookup_flags, &path, NULL);
 	if (!error) {
@@ -110,7 +110,6 @@ int user_statfs(const char __user *pathname, struct kstatfs *st)
 			goto retry;
 		}
 	}
-	putname(name);
 	return error;
 }
 
-- 
2.47.3


