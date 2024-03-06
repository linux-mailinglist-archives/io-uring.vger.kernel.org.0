Return-Path: <io-uring+bounces-833-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3175F873282
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 10:26:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AF951B2FA37
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 09:19:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBAF214F7F;
	Wed,  6 Mar 2024 09:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gGUcKZaw"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947831426B;
	Wed,  6 Mar 2024 09:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709716779; cv=none; b=T9y6+G5lorAz0AJiKr56QaPsZzopI52fPSqynsJuX/m7koc+tWeFgDxsy4Yl3JE0ei8Vx0838pDNkebGZfJz12Kq9fTpj9IuA42RZx+1Ol6L0iwrkMTrfQfMHm/Dr9JZCMPAKILbvjS35Y8RE/L9GT+Ty4LspLGtbdrrRyyT4hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709716779; c=relaxed/simple;
	bh=7Nr4IPt40Xh0GYx6TBamWZqIdVZ2XKs/n5BaTVUeY0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TSEDI+0SEzb4fI9uk6EJMzIkHAWKCjg862J4BLvKmka2Qtmaygro01+7JCWD2zcqBiWEaSfA+zUn+M2t7v1eI+JJ234xqPgHgtMApvAw4M2+Lq5Qw5N06dEgxP9DvifH0EsFXPoCwXdWj7alA+Hfg/GDyjtHW0DkAfHoYvWGvOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gGUcKZaw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD14EC433F1;
	Wed,  6 Mar 2024 09:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709716779;
	bh=7Nr4IPt40Xh0GYx6TBamWZqIdVZ2XKs/n5BaTVUeY0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gGUcKZawmRDkrDUi3pOv1ueG35NdRXq8qnFW2jBIJ7WibLJHQhltxFbBrjw8/T+A3
	 xsvNOllVlhiWEwJkQn3AmfroOFx18O7xtIHo5h/LVvdkb4mnSMq80fDC8t3S3ONCuy
	 5C3i5GqtFM9qJ51C91CEEa+eh2Ka8K54U/roohDr8QvDi2tKItyuLn4AQ+M22jq4+R
	 cTgUVHByTXq+e/9UYgX0zYpaSW4y5wjHgFYSpOzjoXLbZ+TzcJc2KMUsgw41Uvwb9a
	 EABeCWveGpr3cEqtCFQ2yFWjxI+24Vw58Q1oqekb9DFYoit0VjaWaLb18XBckqionC
	 ko+708WjNKrdw==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: io-uring@vger.kernel.org
Subject: [PATCH 1/3] fsstress: check io_uring_queue_init errno properly
Date: Wed,  6 Mar 2024 17:19:33 +0800
Message-ID: <20240306091935.4090399-2-zlang@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240306091935.4090399-1-zlang@kernel.org>
References: <20240306091935.4090399-1-zlang@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As the manual of io_uring_queue_init says "io_uring_queue_init(3)
returns 0 on success and -errno on failure". We should check if the
return value is -ENOSYS, not the errno.

Fixes: d15b1721f284 ("ltp/fsstress: don't fail on io_uring ENOSYS")
Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 ltp/fsstress.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 63c75767..482395c4 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -763,8 +763,8 @@ int main(int argc, char **argv)
 #ifdef URING
 			have_io_uring = true;
 			/* If ENOSYS, just ignore uring, other errors are fatal. */
-			if (io_uring_queue_init(URING_ENTRIES, &ring, 0)) {
-				if (errno == ENOSYS) {
+			if ((c = io_uring_queue_init(URING_ENTRIES, &ring, 0)) != 0) {
+				if (c == -ENOSYS) {
 					have_io_uring = false;
 				} else {
 					fprintf(stderr, "io_uring_queue_init failed\n");
-- 
2.43.0


