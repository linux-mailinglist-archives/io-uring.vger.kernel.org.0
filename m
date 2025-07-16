Return-Path: <io-uring+bounces-8689-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0C6AB06AAC
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 02:44:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1637816EB3F
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 00:44:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A2AD13635C;
	Wed, 16 Jul 2025 00:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="hcHClAxf"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CE312C544;
	Wed, 16 Jul 2025 00:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752626651; cv=none; b=mCFE6xxKPuC5fKf1umAFIL5NcudaD9poKvNTez7a60rc6T3IbmcIu4vwHRZhZsKbNqUMqw94RcP9LH0gJ8yjIKtkncu4ecqc3X51KN4ELyLEDGXypkdSCXp81UOLQZ7o7/XCVxLPh7qv/nUinrvEBAG9dqgPw92HFjSdSbJU/ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752626651; c=relaxed/simple;
	bh=HTdU1t9/CymEpoi9JHQzO+CBlEaFcU1C4gGXbC74CZU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=P5wYZD33JurFeuPQKS1C/JQWtAQEn9FCHis7nZxArxE+119pKpOcFaMtrYojEtYDimqIRVkqOh5fXpfXelsPbqt2GWa2TtjxTUMNW6LlA7BC5XvfgukEngIsQrVvSbVPvyNaYcC31iLy8oSClxDyHkUyJvqTNIE6k+/9rkfGMzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=hcHClAxf; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=default; t=1752626647;
	bh=HTdU1t9/CymEpoi9JHQzO+CBlEaFcU1C4gGXbC74CZU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:
	 Content-Transfer-Encoding:Message-ID:Date:From:Reply-To:Subject:To:
	 Cc:In-Reply-To:References:Resent-Date:Resent-From:Resent-To:
	 Resent-Cc:User-Agent:Content-Type:Content-Transfer-Encoding;
	b=hcHClAxf9PnRM3Ot/fIHvVgsKI3UyfAbZ4V9pZQhWRkEQIJT0V0+aWqiXmgLd+sVr
	 SY3/J0pIVZ1X+24t2gNIkDFbnIpU+V+uedsZ1UzeM5X4ELHXRi+HeV5Wm0h2TiCBol
	 8YrtePhXrclnQkVjyNo0UIYklIvmiAZOQZH1Ww7Gb658L1CDUxo9Ap7xJjCAVUlnkV
	 O0uLlb/D70hPxwXh+P/iQqLXEppL1s/L9V306qv8FVQYSLmgKV05LtvBMBw8umtENx
	 K6rHFurz7A8Pz7QD+93pA+No+DgDDe8VpVE8rQRcHL8+7HgXzCWlh9iaLnel48ode1
	 OXSvZNIDGkUfg==
Received: from localhost.localdomain (unknown [68.183.184.174])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 082752109A7B;
	Wed, 16 Jul 2025 00:44:05 +0000 (UTC)
From: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	io-uring Mailing List <io-uring@vger.kernel.org>
Subject: [PATCH liburing v2 0/3] Bring back `CONFIG_HAVE_MEMFD_CREATE` to fix Android build error
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Wed, 16 Jul 2025 07:43:59 +0700
Message-Id: <20250716004402.3902648-1-alviro.iskandar@gnuweeb.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

This is the v2 revision of the patch series to address the Android
build error related to `memfd_create()`. The series consists of three
patches:

1) Bring back `CONFIG_HAVE_MEMFD_CREATE` to fix Android build error.

Partially reverts commit:

  732bf609b670 ("test/io_uring_register: kill old memfd test")

to bring back `CONFIG_HAVE_MEMFD_CREATE` to resolve Android build
failures caused by:

  93d3a7a70b4a ("examples/zcrx: udmabuf backed areas")

It added a call to `memfd_create()`, which is unavailable on some
Android toolchains, leading to the following build error:
```
  zcrx.c:111:10: error: call to undeclared function 'memfd_create'; ISO C99 and \
  later do not support implicit function declarations \
  [-Wimplicit-function-declaration]
    111 |         memfd = memfd_create("udmabuf-test", MFD_ALLOW_SEALING);
        |                 ^
```
This reversion is a preparation patch for a proper fix by ensuring
`memfd_create()` usage is guarded and portable. It's only a partial
revert because the test itself is not restored.

2) Move `memfd_create()` to helpers.c, make it accessible for all tests.

Previously, the static definition of `memfd_create()` was limited to
io_uring_register.c. Now, promote it to a shared location accessible
to all test cases, ensuring that future tests using `memfd_create()`
do not trigger build failures on Android targets where the syscall
is undefined in the standard headers. It improves portability and
prevents regressions across test builds.

3) Also, add `memfd_create()` helper in the examples directory.

Changelog:
v1 -> v2:
  - Omit the old memfd test because it's not needed anymore (Jens Axboe)
    Link: https://lore.kernel.org/io-uring/4bc75566-9cb5-42ec-a6b7-16e04062e0c6@kernel.dk

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
---

Alviro Iskandar Setiawan (3):
  Bring back `CONFIG_HAVE_MEMFD_CREATE` to fix Android build errors
  test: Move `memfd_create()` to helpers.c, make it accessible for all tests
  examples: Add `memfd_create()` helper

 configure          | 19 +++++++++++++++++++
 examples/helpers.c |  8 ++++++++
 examples/helpers.h |  5 +++++
 test/helpers.c     |  8 ++++++++
 test/helpers.h     |  5 +++++
 5 files changed, 45 insertions(+)


base-commit: 0272bfa96f02cc47c024ec510a764ef7e37b76bf
-- 
Alviro Iskandar Setiawan


