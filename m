Return-Path: <io-uring+bounces-6583-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A251CA3DD1E
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 15:41:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BED1416B9DE
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 14:40:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F0001FECC9;
	Thu, 20 Feb 2025 14:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="LV6b5JX3"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE99C1FC7E8;
	Thu, 20 Feb 2025 14:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740062376; cv=none; b=XpOs4crRxa7jK9E0XfeLgmmcOkhilPjIKgErgZd9SQdzkgE4IAotK3F/Ujn1Q5bZH7RR1zpIOZbGpIHnSMjXsaEa37wYNm3Q0Z3g6slCXT8gogT+/NrCLYKcLpOAHHxvaazjnj6ZKDBNqwwycjmFARrTeebUdIJdAAnItrdZMso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740062376; c=relaxed/simple;
	bh=LcSlaUKd8gp4f67QCYONctlj5MrgKx7MxQCQ8IbGlws=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Y7RNwTJ15VltTzKKlgRBdU1tFINMKp8cFEOteK9Rxf3ykdP1VuXWxSj1QDXCWTFyl/Zzg6d893HME03hVZ79lp0Z9wL5CCn8/WxcZE9eSDEHk+h3J+fw102Teon91KUUw5zxt/n94OQTQ6r9f9ZvrgeCWiafL16uyNzbQcVl4y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=LV6b5JX3; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=default; t=1740062093;
	bh=LcSlaUKd8gp4f67QCYONctlj5MrgKx7MxQCQ8IbGlws=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:
	 Content-Transfer-Encoding:Message-ID:Date:From:Reply-To:Subject:To:
	 Cc:In-Reply-To:References:Resent-Date:Resent-From:Resent-To:
	 Resent-Cc:User-Agent:Content-Type:Content-Transfer-Encoding;
	b=LV6b5JX3cwKegcP8ZA3zOd5pVdDqr7uvtIxZaxB1WGM3XuRTliTErn6yKSG8cfILB
	 DXU6pGL0KlIFlsCVs1bb7wrtfNLNAtmhS7gYjivWIQCLiJcZrdfynB+B5uO63LdRYL
	 ji1B5i4gRc3icHDpxLB1RfvdKhEn7WNDgCzJJaqCMq1tIdXre1kpxfTB1GBP0DbFl4
	 4D/Jux9yIDtuCUXdnl3SwhE4GMAt3/K8jkqfS0jmAG4nD+q4sAbJ/w5G3HSkP3cRu+
	 +NgQcJz2gBAyKCbw6dxHtZtStqzL/birU9/9kImd7c2wD/fAnEkIB8G6+cbsGE/p9X
	 e1DROzYDXnctA==
Received: from integral2.. (unknown [182.253.126.96])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id D34DB20744A3;
	Thu, 20 Feb 2025 14:34:50 +0000 (UTC)
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 0/3] Fix Compilation Error on Android and Some Cleanup
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Thu, 20 Feb 2025 21:34:19 +0700
Message-Id: <20250220143422.3597245-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Jens,

Another day in the thrilling world of cross-platform compatibility...

Alviro discovered that some Android versions are missing `aligned_alloc()`
in `<stdlib.h>`, leading to a compilation error on Termux 0.118.0:

```
cmd-discard.c:383:11: warning: call to undeclared library function \
'aligned_alloc' with type 'void *(unsigned long, unsigned long)'; ISO \
C99 and later do not support implicit function declarations \
[-Wimplicit-function-declaration]

        buffer = aligned_alloc(lba_size, lba_size);
                 ^
```

To resolve this without rewriting large portions of liburing tests,
introduce a helper function that wraps `posix_memalign()` and provides
our own `aligned_alloc()`.

While we're at it, there's a redundant double negation lurking in
`liburing.h`. Let's clean that up too.  

Also, to prevent yet another round of confusion like what happened in
PR #1336, document the history of `io_uring_get_sqe()` in the header
file.

Ref: https://github.com/axboe/liburing/pull/1336

Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (3):
  liburing.h: Remove redundant double negation
  liburing.h: Explain the history of `io_uring_get_sqe()`
  Fix missing `aligned_alloc()` on some Android devices

 examples/helpers.c     | 10 ++++++++++
 examples/helpers.h     |  7 +++++++
 examples/reg-wait.c    |  2 ++
 src/include/liburing.h | 21 ++++++++++++++++++++-
 test/helpers.c         | 10 ++++++++++
 test/helpers.h         |  8 ++++++++
 6 files changed, 57 insertions(+), 1 deletion(-)


base-commit: 66b071d1470ae787d47d4cb8d9cb3836249baf61
-- 
Ammar Faizi

