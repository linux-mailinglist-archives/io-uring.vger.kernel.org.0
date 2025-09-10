Return-Path: <io-uring+bounces-9699-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B990BB5121A
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 11:04:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C280B3B229D
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 09:04:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 008763115A2;
	Wed, 10 Sep 2025 09:04:02 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cmccmta2.chinamobile.com (cmccmta8.chinamobile.com [111.22.67.151])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FB4D2D0C78;
	Wed, 10 Sep 2025 09:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.22.67.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757495041; cv=none; b=QzpPzgI4fpZXaVf37NoHq/810PwW9QlikpAwRa8lT3KR/njUsroyYjSAn5Ug/V8qGeDgxnOAIpVlBC5J7xC2uXTAG9SERVtreEnTZXRZILqAkw7waePatW6A9HKcckJZ2ZMBldxfepsaPM4UiY+wPHuZAhPVpEdNo/rghFjnltQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757495041; c=relaxed/simple;
	bh=PdBFBLGT4+VjMvNdmLYfWVy8Sib1ME3+sXE9Q4hTx08=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cA3Jk+rR/cq9/c+mToABpBiO0h9WTkuJUtC94cJ5XT6Qyt2iKZSkyXCGDpmNUFrTszC/WlUIkEG9z6q1ug4W+LaLVfFjI/8W6WSXQ11w45ckSHyWFCcPI+3cxLTTnmIgu067fxoArmne55cbG+gr5rXKfG74nUGL2Njtj+5TrQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com; spf=pass smtp.mailfrom=cmss.chinamobile.com; arc=none smtp.client-ip=111.22.67.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app06-12006 (RichMail) with SMTP id 2ee668c13ef9929-8f2be;
	Wed, 10 Sep 2025 17:03:54 +0800 (CST)
X-RM-TRANSID:2ee668c13ef9929-8f2be
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from Z04181454368174 (unknown[10.55.1.71])
	by rmsmtp-syy-appsvr06-12006 (RichMail) with SMTP id 2ee668c13ef7e77-96786;
	Wed, 10 Sep 2025 17:03:53 +0800 (CST)
X-RM-TRANSID:2ee668c13ef7e77-96786
From: zhangjiao2 <zhangjiao2@cmss.chinamobile.com>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhang jiao <zhangjiao2@cmss.chinamobile.com>
Subject: [PATCH] io_uring/mock: Modify the return value check
Date: Wed, 10 Sep 2025 17:03:47 +0800
Message-ID: <20250910090347.2950-1-zhangjiao2@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: zhang jiao <zhangjiao2@cmss.chinamobile.com>

The return value of copy_from_iter and copy_to_iter can't be negative,
check whether the copied lengths are equal.

Signed-off-by: zhang jiao <zhangjiao2@cmss.chinamobile.com>
---
 io_uring/mock_file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/mock_file.c b/io_uring/mock_file.c
index 45d3735b2708..bdbb1bd8e2c8 100644
--- a/io_uring/mock_file.c
+++ b/io_uring/mock_file.c
@@ -42,7 +42,7 @@ static int io_copy_regbuf(struct iov_iter *reg_iter, void __user *ubuf)
 
 		if (iov_iter_rw(reg_iter) == ITER_SOURCE) {
 			ret = copy_from_iter(tmp_buf, len, reg_iter);
-			if (ret <= 0)
+			if (ret != len)
 				break;
 			if (copy_to_user(ubuf, tmp_buf, ret))
 				break;
@@ -50,7 +50,7 @@ static int io_copy_regbuf(struct iov_iter *reg_iter, void __user *ubuf)
 			if (copy_from_user(tmp_buf, ubuf, len))
 				break;
 			ret = copy_to_iter(tmp_buf, len, reg_iter);
-			if (ret <= 0)
+			if (ret != len)
 				break;
 		}
 		ubuf += ret;
-- 
2.33.0




