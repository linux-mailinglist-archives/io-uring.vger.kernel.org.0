Return-Path: <io-uring+bounces-8415-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 50C10ADE4E1
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 09:51:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EEC57179771
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 07:51:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C4D325A33A;
	Wed, 18 Jun 2025 07:51:38 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from bg1.exmail.qq.com (bg1.exmail.qq.com [114.132.58.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77D07E105
	for <io-uring@vger.kernel.org>; Wed, 18 Jun 2025 07:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.132.58.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750233098; cv=none; b=aelr1GJ++pxefd0Moe9mKM0C4an3/3Uep3Fqf+x2qVtW4szAWwV2C12PbDuFzRK1BP/zcJ+ct4UCZJFYndl2su26BuI0L+TbgtHDZj995+tGWzpJAjvV583VGeoLvjuAxc0Q+0BtSJbiDNMV0zlicjm/AcaFLK81vAYVzvjKyS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750233098; c=relaxed/simple;
	bh=Sd2+rinfXNFORFv5YPnfSf1Jtu/5E4qznIAezT45lZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ioC8fHxbjs9ikJlhyhGA8i3ZZng+sReVUtq3GtW2adSuQarFSEGFoS49a7DP5pbg6W+9XCrvaOCnR9yXqkSf+m8/QXgtvdu1tfXfUJFAcdl4p+modOzCPJAMl6tnu7GtCyb2oKc6xU31Syzqz8HamwaKs+E5XLuINLYENvwaokQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloudprime.ai; spf=none smtp.mailfrom=cloudprime.ai; arc=none smtp.client-ip=114.132.58.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloudprime.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=cloudprime.ai
X-QQ-mid: zesmtpgz1t1750233067t2163279a
X-QQ-Originating-IP: CcIfWSRlPwB9vLauNETTdNT1ZmI5mFVMOVMM+CA5ulc=
Received: from haiyue-pc.localdomain ( [222.64.207.179])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 18 Jun 2025 15:51:07 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 17761109489978830081
EX-QQ-RecipientCnt: 2
From: Haiyue Wang <haiyue.wang@cloudprime.ai>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyue.wang@cloudprime.ai>
Subject: [PATCH liburing v1 1/6] Add uring_ptr_to_u64() helper
Date: Wed, 18 Jun 2025 15:49:16 +0800
Message-ID: <4039F3DF27B2BC61+20250618075056.142118-2-haiyue.wang@cloudprime.ai>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250618075056.142118-1-haiyue.wang@cloudprime.ai>
References: <20250618075056.142118-1-haiyue.wang@cloudprime.ai>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:cloudprime.ai:qybglogicsvrgz:qybglogicsvrgz7a-0
X-QQ-XMAILINFO: Mnff/9wu0oJYYL1JhmxiaOijUl5q19Tehm4JcHGMBdF+IWgGAxgXwP1I
	Bb3MqKTpfzXCTdg3gCQcJrYT2t3nGuX2xcoBpBzFjGVZFBTT7Q9IOXKIeGhXeQgyOTNZqyJ
	TuKU97KoEDA4TjTOzKFyhnCpD/jOsJVTI0mywKOCjLyOLnMt6WJMzbaQlTh7T+6t5l7cT9v
	73LdorSvw4x2y09ALVyBuZ6qgQPuTwW5q73ZsTIPryU0BvqyRUPe4/NyrE+HcE9HknzhFEx
	7wurrz7uAM7pbQSldh+wa62txNJxertzjPA3X6LXkTXBTPlJWZV79AcswYDdQWJ4kVDZEjh
	U0DRF1pAMwiwmKQeEU9yYKooZOvE+o2G2asytsuEytTWg1n+NJXn8CI0xGHZL/YZdHH36di
	hP9P5gAF3ROZkd0dVu5PMnRblBh/1KrxQq1Cyb0wxnGL1uzxRxREUNOdb2RnJLs+nRVa8rD
	OagFyTFdWdx3BjVp0HSp8zEZt33Fkqq8xBceSGRUySLWfZKZzpiG5H2VcQXDLSrWePoNRKw
	Rb86+IWeYAHKHhxFH3Oag4u1y7KuLqPMnIDa6Y70QJ1xqmrpU0rjD9jmowW25+bKGjO9ASk
	GgwUd1hyH1jWevINNCw6Cp3aKDwlQApfsMajQSR7BWrffzMynXNS0QpYnIWQmDrPcXKbLwO
	7BmDKMKOXJgA5R7mVsZz6A2+Pr+Xyx+8Z7Gg+kh1M0sFa++AoXrx3lGGDeAis6Yj29yQPzo
	/K/uUDI0OKfg//vBwnLvy8+YHpTkqbfVU3QFCAvMHq9kwW2Q3yhA3U6wP4sqZNiXu75tTS7
	BH3Oxb+x5vizMHisMqysenrq6Z5Lmg6HdYmfalFkD2mtKqDkdirqaqJW1EuJyPEFc35xJFe
	jaHTHAghq18x4OohSAJzaVul5wL0cb/S0gM+ln1BEwR+9X/wK4FUzCCw/kZYf5D18XamX3y
	XZnRd0LBOMym2KCiAK0AByQ8IN9rp7KDlVtv7OaVBuHg2+w==
X-QQ-XMRINFO: M/715EihBoGSf6IYSX1iLFg=
X-QQ-RECHKSPAM: 0

Add this helper to convert *ptr type to u64 type easily.

Signed-off-by: Haiyue Wang <haiyue.wang@cloudprime.ai>
---
 src/include/liburing.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 96eeed3..6d87248 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -32,6 +32,11 @@
 #define IOURINGINLINE static inline
 #endif
 
+IOURINGINLINE __u64 uring_ptr_to_u64(const void *ptr)
+{
+	return (__u64) (unsigned long) ptr;
+}
+
 #ifdef __alpha__
 /*
  * alpha and mips are the exceptions, all other architectures have
-- 
2.49.0


