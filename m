Return-Path: <io-uring+bounces-10842-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D995C94531
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 18:03:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74E7A3A8E35
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 17:01:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A43230DEC8;
	Sat, 29 Nov 2025 17:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="g+K6+UEF"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DDE223DEA;
	Sat, 29 Nov 2025 17:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764435700; cv=none; b=ezJr5rTSwf43fKJjxwvfxH4mWxS1P48w9vIAFn5W4fy0mOJ64yGcm8gzWitfTPWvz5ouYOLlfD7ZrfxylxAT3eAspfC0NI0e4Qz4g7+FRVLyyUbLWFU+iQJ9TJML91NPg/91e/0VLL6Ean+UabUaxSXpvABfx6AKQ1/R/zIMEPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764435700; c=relaxed/simple;
	bh=Q8GvRJaFJBIZxzLEUHCqkrUgiXdbm8WVdqTn//3lbXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9t78XrDjCqy/KQDQZ9NqZT8Xm0q6NPoxJUYZQywYwHMJCrdXTLJMagiDwJfsAFpb+nFfp7E63UaasAwXLvfUpcQKXeCrhB4hfVO2HnzSge2vTDDO0tObfCLVkyEtE23wDkg1Ya/WASEFHjGvJEDDB9fFBtvDuyrNq6rHV6c7Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=g+K6+UEF; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+wrr31za2iCZDXY8YqT8thxQrPwx7eXwttog/9Pglzc=; b=g+K6+UEFlNLaSDV1QvJiWfrY39
	EiEsv1gf1xXZB28STy/LXjnNBiId5R6dS0ItQ8awp0e8uKuRlnF8lEapl7Y8fpgLBPyu8ClPQNA1M
	nfGILjSsVoHv/yjAJpwsXOqtQ5TVEvt6TAEA58Xw6dx2XqNL3G3buir3fYlfhpk7zeardk0Oxm8zo
	zN+9CTJK/ZI08cjcyAuZz4lwpw7Jf3tfS2I741jjKvsACnTOKvpblFZ6Zfpfy72CX8fJdD2YbZ+Kg
	r6+5x4dBThH9X80NWYpXu4HQbcIO++TbJ5spUT82VsEDjZJtBT7R1twAKbnUMnXR2x0qGE5tEBdE/
	cFt6AadA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vPOKO-00000000dDa-10Y2;
	Sat, 29 Nov 2025 17:01:44 +0000
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
Subject: [RFC PATCH v2 17/18] fs: touch up predicts in putname()
Date: Sat, 29 Nov 2025 17:01:41 +0000
Message-ID: <20251129170142.150639-18-viro@zeniv.linux.org.uk>
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

From: Mateusz Guzik <mjguzik@gmail.com>

1. we already expect the refcount is 1.
2. path creation predicts name == iname

I verified this straightens out the asm, no functional changes.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Link: https://patch.msgid.link/20251029134952.658450-1-mjguzik@gmail.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 fs/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index 37b13339f046..8530d75fb270 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -285,7 +285,7 @@ void putname(struct filename *name)
 		return;
 
 	refcnt = atomic_read(&name->refcnt);
-	if (refcnt != 1) {
+	if (unlikely(refcnt != 1)) {
 		if (WARN_ON_ONCE(!refcnt))
 			return;
 
-- 
2.47.3


