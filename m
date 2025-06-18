Return-Path: <io-uring+bounces-8419-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 73E15ADE97A
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 13:01:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DAD41189D765
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 11:01:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 063BC285066;
	Wed, 18 Jun 2025 11:00:59 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B828428505A
	for <io-uring@vger.kernel.org>; Wed, 18 Jun 2025 11:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750244458; cv=none; b=Y/HvI62zzOW9JnfXlx7sOY9KoMHQwZMNKZO/1bh9zngbNC3UzhMHGbu/wqJZhvfqMcP7ecr0JgwI/XPyd2Ng5hficWb1Kds1w3lWB8Agn5EIYvZPsgb+QfR249HlWkFrNgAkp3h3LiLNXJR+14rwLhtRbOxjIHCwC6P3s4aRg8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750244458; c=relaxed/simple;
	bh=X3tF91DpdlJdyJXYvxxrVBJ8Usmz4F9pk2pf3tHXCBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSjZULbFBAfRpwqQtTv3rHBolRoeiAeOEzK4eZs+s93Fypi4UBj7nOUpY6kZED2bxgla3Aggz+WfmFQ35/PWNymvJWMH4Yu04I7I5xnUqoOtToc0wd/XcnEv3B+dR9mWK6qVR/5wE5u7JVEE40Fl48ibScmqhzLcecmdSbc3aGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloudprime.ai; spf=none smtp.mailfrom=cloudprime.ai; arc=none smtp.client-ip=54.204.34.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloudprime.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=cloudprime.ai
X-QQ-mid: zesmtpgz8t1750244444t3f5e9050
X-QQ-Originating-IP: jnS8rJWP5M9Ky9u3GThs8A3dz9BJbacxpWZ5LcLiYUw=
Received: from haiyue-pc.localdomain ( [222.64.207.179])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 18 Jun 2025 19:00:43 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 1236819653091985832
EX-QQ-RecipientCnt: 2
From: Haiyue Wang <haiyue.wang@cloudprime.ai>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyue.wang@cloudprime.ai>
Subject: [PATCH liburing v2 2/6] liburing: use uring_ptr_to_u64() helper to convert ptr to u64
Date: Wed, 18 Jun 2025 18:55:39 +0800
Message-ID: <D6366A1870815E8A+20250618110034.30904-3-haiyue.wang@cloudprime.ai>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250618110034.30904-1-haiyue.wang@cloudprime.ai>
References: <20250618110034.30904-1-haiyue.wang@cloudprime.ai>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:cloudprime.ai:qybglogicsvrgz:qybglogicsvrgz7a-0
X-QQ-XMAILINFO: NiFdmnmiW14n560tERWGlaPMEvfwq0wlnXVmep75tGFVPkJKltXjRdjg
	ttwqdcVa8KBgBBD+c+rfOUmjswBs5MJ4bfFtSsKMLfzBtQ8RrklzkqY2H2sSqyOCvccv/Uj
	/XG+IwH+BiOXa2g9TUuukpxa3n1tqadl/NYot7L7HkD/70H4RdbSKNDyPlE078vrnbpEuSY
	pEaDWU2WE7dL/b4pyyQkjUKv+4HKFWU/9u/JKim5hCL7KDbcLPSYmlQezthdDf+2vpDFNay
	a51Ltb7E1hUOHYGYs8ItwLiIBTLg0mscPmP2C8T/ilBw2Q5SwwuBwEAfnonfxVb3kO9EOYE
	ngHkPc85XGKUVcQrpSwpwpRxyGxDxaAVADlhRLEIn7VyOqZn4sP2I9BXwlPwk0yLka9ShgI
	ameQRJXsSQfju49q3PbmkNWfpDAUKIcDmrYkpIzDbjVrcg5fAuEwnf+r2bX9ugF0j/lb39R
	DNn26tilMOnhaTJbR60ChdIwLPGr7xisXE4zLZ8h4P2N2YDTqK1MmPa3GQR8o6qd7PCuT38
	KKD7d6zUT1B+VHc4qedwaKz5UQ5BleCMRGUzDXMn0eOvGyTn0E8BHnp9qUSJax2rzErbGdl
	blO8zpls6Jf9c+fw3KW4aV35aB3FKao/Lr4hVIEuAKaEZxx/7U/Y7fN7KIS6DKWIrrzmh2o
	/9lL8baTia3Szn52Wydwd/l07H+6ZNfpLxoWlUq2e1wQ3r9PRexhXv77VtxVOQ6rv+AAldT
	p9I/HcgiY0aDZGCpMZtBlBpDULv0Yu5HQNc4AN00eNKpuqoD2Re3uVYpeWmvQ6IAPgxWguW
	BjsGuod8VCR8opaddkyO8p86HU+sbXjlknfgDreNdxW8tYKVGO+Pd0uDBIwDaZkvp0HYqB3
	t5tk8FXe5WITGEyAZn6O+Pd6SQlfnhgV6vZmMuATJJQFLnD+wjiblEW9eSxD7fzYLyGsKTD
	k1mTgAE7E0yBhwwZWyh4lklUSqKRzu3ybmRbwxWrHJrQLZU7wRImU7ML+XWrMEQ7022kj4j
	V5aKygig==
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
X-QQ-RECHKSPAM: 0

Use the helper to handle type convertions, instead of two type
convertions by hand: '(__u64) (unsigned long)'

Signed-off-by: Haiyue Wang <haiyue.wang@cloudprime.ai>
---
 src/include/liburing.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 520b07d..35d2b27 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -721,7 +721,7 @@ IOURINGINLINE void io_uring_prep_accept(struct io_uring_sqe *sqe, int fd,
 					socklen_t *addrlen, int flags)
 {
 	io_uring_prep_rw(IORING_OP_ACCEPT, sqe, fd, addr, 0,
-				(__u64) (unsigned long) addrlen);
+				uring_ptr_to_u64(addrlen));
 	sqe->accept_flags = (__u32) flags;
 }
 
@@ -907,7 +907,7 @@ IOURINGINLINE void io_uring_prep_statx(struct io_uring_sqe *sqe, int dfd,
 				       unsigned mask, struct statx *statxbuf)
 {
 	io_uring_prep_rw(IORING_OP_STATX, sqe, dfd, path, mask,
-				(__u64) (unsigned long) statxbuf);
+				uring_ptr_to_u64(statxbuf));
 	sqe->statx_flags = (__u32) flags;
 }
 
-- 
2.49.0


