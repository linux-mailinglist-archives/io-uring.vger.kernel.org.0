Return-Path: <io-uring+bounces-7891-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E42A0AAE855
	for <lists+io-uring@lfdr.de>; Wed,  7 May 2025 20:01:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00D6F9C7EE4
	for <lists+io-uring@lfdr.de>; Wed,  7 May 2025 18:01:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3141E1EA7DD;
	Wed,  7 May 2025 18:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="LkXsmm5f"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B2C28DF44
	for <io-uring@vger.kernel.org>; Wed,  7 May 2025 18:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746640891; cv=none; b=nprnad3SILJTIGy6OcsuWQitPJjOK7H47eZkpA9lExKzQKetPyyu6HNbcELEQOX5EzjxnHntSkPS2M7xSPrwlcyCWLblazWgrSWnhxhhvmHIZytzvuIWRSY+J4zUQF5Bb4ACb0TNwBv/EPobtIkg+AobXyvqgVvievGa8dEAzqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746640891; c=relaxed/simple;
	bh=SlZSp6dduxd1g6M5VnLtvUyrbGeD7sx5hQftjb6BBkI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WtKdzdf93QUwCMo/rgJyw3U4tC8X7NpI2fR1TJx/M3KGQKWOgvRKr6SMaWBcbzzewpvkTWegggUnCEMNvxQ/DA9NxB0F9iCH010be68R7ARrkJcK78Q4mBe7dOjZyqJxbkgMExV0PzXSP4pQyQMNHlBkzXEe7ZO4569//kP+0Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=LkXsmm5f; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-ID:MIME-Version; bh=YrhgP
	ecIb94VxwTeLzow8PAUZ9sHPbCbqK/xpoUqIqI=; b=LkXsmm5fKZsJmTXtVESLw
	/UMUO18gFoS6PjhSSDnljJlPvpqh1O0ah3MeAnvg69U+/VikhhdB29TCfwaGsl/j
	sKA90gCe3o8z16jQgch8OF4PP6r+zZAvrLW64O1hnine5O4wJpWClp/XYQxJeAwC
	XQIXE6L8ShWdQt++M5An9o=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wBnj8rxnxto+_PXFA--.13475S2;
	Thu, 08 May 2025 02:01:21 +0800 (CST)
From: Haiyue Wang <haiyuewa@163.com>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyuewa@163.com>
Subject: [PATCH liburing v1] io_uring.h: Use Tab to separate macro define value
Date: Thu,  8 May 2025 02:00:35 +0800
Message-ID: <20250507180051.28982-1-haiyuewa@163.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBnj8rxnxto+_PXFA--.13475S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZr1DAw13AryrCF1DJFWxCrg_yoWfKrcEv3
	s5Jw1kCFs3Gr4jva13CFZ3XF1Yk3W8Ka1UZa4fArnrZF1ayan5GayDXF9xtF15WF1xur10
	gFnYgw1fGw4jqjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRRXdjtUUUUU==
X-CM-SenderInfo: 5kdl53xhzdqiywtou0bp/1tbiYBFGa2gbmLjljgAAsk

A nit patch to fix the Tab style for macro value definition by running:

diff -Nur
	liburing/src/include/liburing/io_uring.h
	linux-uring/include/uapi/linux/io_uring.h

 /* Use hybrid poll in iopoll process */
-#define IORING_SETUP_HYBRID_IOPOLL      (1U << 17)
+#define IORING_SETUP_HYBRID_IOPOLL     (1U << 17)

Signed-off-by: Haiyue Wang <haiyuewa@163.com>
---
 src/include/liburing/io_uring.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 0baa327..a89d0d1 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -202,7 +202,7 @@ enum io_uring_sqe_flags_bit {
 #define IORING_SETUP_NO_SQARRAY		(1U << 16)
 
 /* Use hybrid poll in iopoll process */
-#define IORING_SETUP_HYBRID_IOPOLL      (1U << 17)
+#define IORING_SETUP_HYBRID_IOPOLL	(1U << 17)
 
 enum io_uring_op {
 	IORING_OP_NOP,
-- 
2.49.0


