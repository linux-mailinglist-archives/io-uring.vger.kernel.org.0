Return-Path: <io-uring+bounces-4350-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C2AF99B9DA8
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 08:32:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F2C31F22670
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 07:32:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1948F15C15A;
	Sat,  2 Nov 2024 07:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="riw0HR2X"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBA9153BF7;
	Sat,  2 Nov 2024 07:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730532714; cv=none; b=JKSoCieAmenqosUWEzgC2C/3lRfSI6lhc4ENoVZUe/6HjyujJI6ngK8E9KIwemN6RipMtCu6P7hEChs7UgMLvtUn2RLzuYRs/rjOxR2IsEPRxNaUfLhMnh6NtG0BAHvEMHBerAzb0546zJlLWX8qoCSViz96x/fN1A/h806cpa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730532714; c=relaxed/simple;
	bh=PoqTX0mDAe6hP72ChBxF/WuOoSBH0ddySuyGaOqiU0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RK82MZGSag11bqguImoTZ0BJxudiBF67p7rIlKqbqXkeqPf9MXWPS5GW8veiLmiRwbktWXjVA4GHKf2dXLJ+TM7h+18Kn/zjmpSegQsHSGB2yQSmbaIhBoGr2C9YyQSGs+tojS5O47o+G7PACGkghdCy9S/zeS20lNSjXpkIskU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=riw0HR2X; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=zhqXfJhI6uiekzNJ4IN4o0rOS1QxLJxd9xlxoLiD+h0=; b=riw0HR2X3sXHhO83/m9q/D33YS
	OuRvrqpX6gz1ydGWeboMyVno2NbwCaHBkKgnLhxjaQluXXxnHU7/F+saZP6wtwPbKYdqjuUuGDjmi
	2Vhut4iJQKtnQsN3+1bhDigC2FA12pvIdwXP+ub1bwkXwOtF4prxmjLXAf/3+0yTRrAI8+dHEilS2
	A3GHK0MlStgho6Yo1HoEka3MfeCrDrTHQAVQn3DLVKw0vwOoqN/9LPROW76OLtCcMDpjeroo2sUQa
	Cd76RVVpdNaGOaE0DOHmTsIgsPnliImYKCteooO7brdA8eG+CcBigDptAOfYmHERm/LtUqfR2mEDM
	iJ6Pb2aQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t78bu-0000000AJG3-2jw1;
	Sat, 02 Nov 2024 07:31:50 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
	io-uring@vger.kernel.org,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
Subject: [PATCH v2 13/13] xattr: remove redundant check on variable err
Date: Sat,  2 Nov 2024 07:31:49 +0000
Message-ID: <20241102073149.2457240-13-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241102073149.2457240-1-viro@zeniv.linux.org.uk>
References: <20241102072834.GQ1350452@ZenIV>
 <20241102073149.2457240-1-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

From: Colin Ian King <colin.i.king@gmail.com>

Curretly in function generic_listxattr the for_each_xattr_handler loop
checks err and will return out of the function if err is non-zero.
It's impossible for err to be non-zero at the end of the function where
err is checked again for a non-zero value. The final non-zero check is
therefore redundant and can be removed. Also move the declaration of
err into the loop.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/xattr.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index deb336b821c9..02bee149ad96 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -1142,9 +1142,10 @@ generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size)
 {
 	const struct xattr_handler *handler, * const *handlers = dentry->d_sb->s_xattr;
 	ssize_t remaining_size = buffer_size;
-	int err = 0;
 
 	for_each_xattr_handler(handlers, handler) {
+		int err;
+
 		if (!handler->name || (handler->list && !handler->list(dentry)))
 			continue;
 		err = xattr_list_one(&buffer, &remaining_size, handler->name);
@@ -1152,7 +1153,7 @@ generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size)
 			return err;
 	}
 
-	return err ? err : buffer_size - remaining_size;
+	return buffer_size - remaining_size;
 }
 EXPORT_SYMBOL(generic_listxattr);
 
-- 
2.39.5


