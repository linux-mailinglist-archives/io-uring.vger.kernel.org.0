Return-Path: <io-uring+bounces-8678-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 95881B05099
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 07:07:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7A14B7ADFD1
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 05:06:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEC0D2D4B44;
	Tue, 15 Jul 2025 05:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="qU0gJoOX"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390B82D3A96;
	Tue, 15 Jul 2025 05:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752556008; cv=none; b=FFpAEvy+JFDLYi4//yDedUXzCvmTZ+BnaFbHZSIEQL/gKaImlKKaWunjjCzLuISSR3fpa5YIKClQjdKSMtPSB9vxPinUO6aZSRBglpAw6lPVShCEyhsSsqMkLm9GbC/vMfK7FZeH+cL23uaL5CwGG52qdDyTjDO6HVmvRGHZoE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752556008; c=relaxed/simple;
	bh=S9Nifo+zeP1i54N1mcfIBp1n44Ci3FJEM3PPIzaBq1A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KGiilMUafB7bPvqmOHVuaeVXssj6qWKDAqy0qZ2n6paFc4bj4pWo9CONt7rWM1IhA2O3T5ysEa9NvHTdrnS5peOhwaKTJ8BnEzS/VBdbmFloKRDLLt8UvOFT6xUhwe9YIS2hibfSqykmo4f0g7p+jgzeml7gmuZYUNxaiHqPTB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=qU0gJoOX; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=default; t=1752555996;
	bh=S9Nifo+zeP1i54N1mcfIBp1n44Ci3FJEM3PPIzaBq1A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:
	 Content-Transfer-Encoding:Message-ID:Date:From:Reply-To:Subject:To:
	 Cc:In-Reply-To:References:Resent-Date:Resent-From:Resent-To:
	 Resent-Cc:User-Agent:Content-Type:Content-Transfer-Encoding;
	b=qU0gJoOXIAat5+J3/NYl4gLxiaoDsYu8CreZKAabTsE9uF5vsc3Kbh72PCvVH71dk
	 P8xWJsLbLv+romXTDSk3aOggBAacT16g6QNWUwjOTw0CvOX5nAHaOBUY1F1110yGWc
	 mx18LtceUrovy2aIcpaRFjm+4iItPulguD++QQO2y0vfBbLnFHGTXkeSTAe8+oU9RI
	 zYkakgfdRDL88LvkgiIgTPJymZLKd2LLLbEu3NEO3353Sqxxdf1Xyr49a7S7rTSC8A
	 la2xftc900U5YAxPh0bDhb9rrQqRVH/LsYUQ5ZJ5LQ3RRnCnQ+a1lvbJAaNWVTJTcd
	 12RS/28buu7Ow==
Received: from server-vie001.gnuweeb.org (unknown [192.168.57.1])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 180852109A34;
	Tue, 15 Jul 2025 05:06:36 +0000 (UTC)
From: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
	Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH liburing 0/3] Bring back `CONFIG_HAVE_MEMFD_CREATE` to fix Android build error
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Tue, 15 Jul 2025 12:06:26 +0700
Message-Id: <20250715050629.1513826-1-alviro.iskandar@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

There are three patches in this series to address Android build
error related to `memfd_create()`. The changes are as follows:

1) Bring back `CONFIG_HAVE_MEMFD_CREATE` and the associated memfd test
to resolve Android build failures caused by:

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
This reversion is a preparation step for a proper fix by ensuring
`memfd_create()` usage is guarded and portable. Issue #620 was
initially unclear, but we now suspect it stemmed from improper
compiler/linker flag combinations.

2) In test dir, relocate `memfd_create()` to helpers.c for broader
test access. Previously, the static definition of `memfd_create()` was
limited to io_uring_register.c. Now, promote it to a shared location
accessible to all test cases, ensuring that future tests using
`memfd_create()` do not trigger build failures on Android targets where
the syscall is undefined in the standard headers. It improves
portability and prevents regressions across test builds.

3) Last, in example dir, add `memfd_create()` helper to fix the
build error in zcrx example.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
---

Alviro Iskandar Setiawan (3):
  Revert "test/io_uring_register: kill old memfd test"
  test: Move `memfd_create()` to helpers.c, make it accessible for all tests
  examples: Add `memfd_create()` helper

 configure                |  19 +++++++
 examples/helpers.c       |   8 +++
 examples/helpers.h       |   5 ++
 test/helpers.c           |   8 +++
 test/helpers.h           |   5 ++
 test/io_uring_register.c | 108 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 153 insertions(+)


base-commit: 0272bfa96f02cc47c024ec510a764ef7e37b76bf
-- 
Alviro Iskandar Setiawan

