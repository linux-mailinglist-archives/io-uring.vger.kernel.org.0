Return-Path: <io-uring+bounces-10476-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 549E1C43978
	for <lists+io-uring@lfdr.de>; Sun, 09 Nov 2025 07:38:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE3073B32DC
	for <lists+io-uring@lfdr.de>; Sun,  9 Nov 2025 06:38:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CC4825FA2D;
	Sun,  9 Nov 2025 06:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="DYK/zp8o"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7634523F417;
	Sun,  9 Nov 2025 06:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762670272; cv=none; b=H6mB/qt6n3FnsE1jFklmT7MKkM7LMGzg/63D1Nu+cROxEEqgCJ7iT0jcC+t87WyuiMVnAtV/BSlI/+hI5J1UdrnOo7Xyt7m5TfCKrHIkvzA8AJei3ZseSQVrLUIprePyTG7lA/077Kn/39AFLpMt9a+wD2HlFVrPpnTakwF4qUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762670272; c=relaxed/simple;
	bh=50uqlYUSR9Q7eSLBNlflI7yR4HM90sJ7OfoHWy5bB7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pNXsJoyFgmWZV6Bs5jSBmfhr/l/RxJYodePIsaFhEjjjIoxFhnhuppGELOHtwMUNrNbzabt08TQaCWof5C//n1TIotihaHmearlGZIb3tqXHbPj/t9kpyqE6uvEd5yOnOql+Ql2yv0+9zKc5jUpNiibfEP3X1DpED5nhj3yvPYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=DYK/zp8o; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gdaxaeDhsyMzJv2EwTpRcq8Aui72c9xYsghs2WB+Ca8=; b=DYK/zp8o6ZBNgg+0TiKiu9285h
	/MXa34WVs3uKSiR2drdxxidb5CKU5T7pj0Zkxq/UU4ObQ/I3JU/52UDd4FRQ2hxWICrjL0XOHBxZf
	Ro8ra5crLZsk/IMLzgria9j+PZWIrP+UHmioqpiNBV6FLoZHoI1GOc2GS6qVUchvlwHMQ9lCnYow/
	l+E7nJr/n7pH0rgRFV6RgrYy2rp//sehFK+p98Er8eLF5Iiz0rHbg63uA0SFBGW92zzrIP9uniNIW
	tXo8IUOpklTyatRMtAxdRbeYXKOXNG6OFNTrZt5347MgW9ckj1kcjXnjxaj+CymqhlkMVvRBkg5sh
	noLy1WNQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vHz3a-00000008ldN-41kb;
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
Subject: [RFC][PATCH 12/13] fs: touch up predicts in putname()
Date: Sun,  9 Nov 2025 06:37:44 +0000
Message-ID: <20251109063745.2089578-13-viro@zeniv.linux.org.uk>
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

From: Mateusz Guzik <mjguzik@gmail.com>

1. we already expect the refcount is 1.
2. path creation predicts name == iname

I verified this straightens out the asm, no functional changes.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Link: https://patch.msgid.link/20251029134952.658450-1-mjguzik@gmail.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 fs/namei.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 37beb524b362..bb306177b8a3 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -284,7 +284,7 @@ void putname(struct filename *name)
 		return;
 
 	refcnt = atomic_read(&name->refcnt);
-	if (refcnt != 1) {
+	if (unlikely(refcnt != 1)) {
 		if (WARN_ON_ONCE(!refcnt))
 			return;
 
@@ -292,7 +292,7 @@ void putname(struct filename *name)
 			return;
 	}
 
-	if (name->name != name->iname) {
+	if (unlikely(name->name != name->iname)) {
 		__putname(name->name);
 		kfree(name);
 	} else
-- 
2.47.3


