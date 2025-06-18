Return-Path: <io-uring+bounces-8411-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CE5EADE4E0
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 09:51:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BACA7179827
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 07:51:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3E3E27F007;
	Wed, 18 Jun 2025 07:51:21 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C251275845
	for <io-uring@vger.kernel.org>; Wed, 18 Jun 2025 07:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.59.177.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750233081; cv=none; b=dolUXllhZxnITxFptKyuyEQ0B8n2b6qUVQb6wr/mU+TA/LqvFhTFHAp1C9SNOpJePXeZkzFkz3c0zrAzd5x53wHYZIWT2iFlJIAuDkfZmWtW+VlLCT4ovsgjWLbV4Q5G28gb+sPY2bbHKrZR327n0ges6tuDWYp4e044yr1bDWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750233081; c=relaxed/simple;
	bh=54SdAM2vIByxQ9W6LxMAoKHc0KHizakccacIoEYJwBY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MIknsD+Ubs6DngFsn5SxkFnGZkJOnEezB+pgW/TFKOU4IF+FinL8qcaTaQfNM4OpRqQy+8viXDHZl8Pmr32Z2o8YL3ZMaG/nKrnYlbYUdH6bU64w3RC1WgegLh0Yj1UzUveaOCJv1VCKVYlBuXnlnHwy3moixdGcaBZzlYKJfk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloudprime.ai; spf=none smtp.mailfrom=cloudprime.ai; arc=none smtp.client-ip=52.59.177.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloudprime.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=cloudprime.ai
X-QQ-mid: zesmtpgz1t1750233065t288fa19f
X-QQ-Originating-IP: gvwAmYSuzHQfRWTWLAXct2O77xGVKTMhQsNqc0a5Ub4=
Received: from haiyue-pc.localdomain ( [222.64.207.179])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 18 Jun 2025 15:51:04 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 9295086249755992326
EX-QQ-RecipientCnt: 2
From: Haiyue Wang <haiyue.wang@cloudprime.ai>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyue.wang@cloudprime.ai>
Subject: [PATCH liburing v1 0/6] Add uring_ptr_to_u64() helper to convert ptr to u64
Date: Wed, 18 Jun 2025 15:49:15 +0800
Message-ID: <05EE29151DC406FF+20250618075056.142118-1-haiyue.wang@cloudprime.ai>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:cloudprime.ai:qybglogicsvrgz:qybglogicsvrgz7a-0
X-QQ-XMAILINFO: MyhNtuNETreejmMiiHwxn3oD+nF15PXIDTllQq4oL8I0Tmb0LIX1RmpQ
	8OYBu9lO5js08dldC1l8m/YaVm4CxqrBRCngwXu4c6IzTsSUo0FkxAuiFVcLSu1kXCRCohZ
	srfYB2zQq72sW0wwR3MI41eZ3f/a19v3Z9PIdpVgBQbLYBPMHSqFld+fNEr2UTw63NNBsiV
	rAE+3dArsRqHr4IJz1NDutxDZGsqriJO11wJ+WLV0D71icsMMYLVZ/PJAdDayH4G4oG3XPA
	3npDdpOBVn4SJpJlWXPY5gGrH6DSk5xohG6eOIGghknVNEN7Y9tFWkf4o2tag3mJSdTLIaL
	NShNYuZECF3bw9xAkMZx/Pv95GDm8vux7WpoxMJE5Bvenp4YA+SdzT0PfZFMlNXA24Pe6G8
	kC5gYqKEoVGoZrGb4IMaJlufGol/q1fBdIKOaVpbKDrifMg7JRHUvW8prQfiTJe6rO41ygu
	I0jRI273IsxnIjv6RVg5LDd+BTjG0Z/ql9oWhQ0AT2BahCoaWoviiJWGizOqMNTFyeJOT7y
	2qUrvV5kuSubtCwNyiFl8fvLrfHODz7J6BYWqZoJ1tePmk0PcuVBvpkoMafBXvO6/1pbemT
	+PF7s15AYtqqaWVqQCYVxG9i2+HLMF9ndWA/i99kK1BUDJ19MyyANFS6nyOJa9u5rGB2YOr
	0tUKIi3SZ3q0b3BJOFAyH/znZpIyqQEU/qYE14UsqUzI7dERQpxxb2TyLbQSExDs23jRkxU
	0LxPUFXHTLixTJJ27ny2qXairhuPKrbXI8jSw9mZBX416cgr0sWoSlbhXjYALEuKXOGQEhh
	QGrHOMUGKW14miQLhsMkgPchEvpLo8Wml66uDh3mjr+WgwbwKo75B5ykTpeFIAfJ0Cxbv7A
	RE7OzBvk/ijwetjdqmtdkVt7IlmuUXJogRMeaxfy86jVWeFCfb0l/ACFVDEts1CkZgwL7yx
	XdhPeFEiSHRggORKdp9fCN/lX0zQGYyzFIyuSvZI5V0FkjA==
X-QQ-XMRINFO: MPJ6Tf5t3I/ycC2BItcBVIA=
X-QQ-RECHKSPAM: 0

Instead of '(__u64) (unsigned long) ptr' by hand, define a helper
function to do so.

Haiyue Wang (6):
  Add uring_ptr_to_u64() helper
  liburing: use uring_ptr_to_u64() helper to convert ptr to u64
  examples/reg-wait: use uring_ptr_to_u64() helper to convert ptr to u64
  examples/zcrx: use uring_ptr_to_u64() helper to convert ptr to u64
  test/reg-wait: use uring_ptr_to_u64() helper to convert ptr to u64
  test/zcrx: use uring_ptr_to_u64() helper to convert ptr to u64

 examples/reg-wait.c    |  4 ++--
 examples/zcrx.c        |  8 ++++----
 src/include/liburing.h |  9 +++++++--
 test/reg-wait.c        | 24 +++++++++++------------
 test/zcrx.c            | 44 +++++++++++++++++++++---------------------
 5 files changed, 47 insertions(+), 42 deletions(-)

-- 
2.49.0


