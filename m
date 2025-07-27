Return-Path: <io-uring+bounces-8797-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ED10B12D49
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 03:03:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EB88175A51
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 01:03:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D4AF502BE;
	Sun, 27 Jul 2025 01:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="IQyEl+ET"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714CE3C1F;
	Sun, 27 Jul 2025 01:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753578178; cv=none; b=R8BMZrQljJuavZ6C01mSnt4da5H2mNVOMYj3fyBvv7PvYuJ2sky1TZF8MdoRZGOxaLV3wfi1wNFzuxTrYl+G7N9AyjjiWxcSpDbsimw/5wx8ehvclRGHQpUpdw9wvceerkjHk3j1QmkYlK8u6+vDPdUHsxwOyeg65R014JJ06h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753578178; c=relaxed/simple;
	bh=fdB0aP+GUPksX8JZut2TJU4QF/4OPbF/mROEoA+EjgA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=T70gYALy1rPQYU0I2eqYMrJG9EjDy++05amLzAj/PtZ7gWig+ksrU03C5rO4J7W8nt/uKj0sk2HxrQNq6/Ul9zAxTJpBtW4HantZmZR0hSNLqi1kjeeNdHyh0I1+QAPMzAmQHHGehiz+pXMUaD+sjZfZb/Etf8zLDb0fOORq+lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=IQyEl+ET; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=new2025; t=1753578175;
	bh=fdB0aP+GUPksX8JZut2TJU4QF/4OPbF/mROEoA+EjgA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:
	 Content-Transfer-Encoding:Message-ID:Date:From:Reply-To:Subject:To:
	 Cc:In-Reply-To:References:Resent-Date:Resent-From:Resent-To:
	 Resent-Cc:User-Agent:Content-Type:Content-Transfer-Encoding;
	b=IQyEl+ETiRiB5WjT8cAQgLGEsEY3HHbEuUiZvX7M88P30yB+7mefBsDrBqP4NsrHF
	 AHuuw/M7+ItKWTvBb5pTCjs+f9Nlp+Kcdw//nfDT+qt61Kr9Mu4bAFuZqliLNkJpw8
	 rCymKQeARZBWWQgN/uBwhnDgACx+wOCvi/T09bAj6RUI4KHm6FjSWN3Up9HqwT7oCL
	 C55LD72o2RMbl1Ms7EvTnCpVWZEARvEIrG1969A3wLNUCjFfllq/vURlkA3528+fj4
	 8GuUP2wLUfXNXB/TWnXgY2eOVTpWxCGNL6Lt3WBuipLKgHC9u7UJZBXoDHzyZh7y2V
	 Azg8oUu20zT0w==
Received: from integral2.. (unknown [182.253.126.144])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 4E8AF3126E01;
	Sun, 27 Jul 2025 01:02:54 +0000 (UTC)
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: 
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
	Christian Mazakas <christian.mazakas@gmail.com>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH liburing v2 0/3] Manpage updates for iowait toggle feature and one extra FFI fix
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Sun, 27 Jul 2025 08:02:48 +0700
Message-Id: <20250727010251.3363627-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[ 
  v2: Keep using IOURINGINLINE on __io_uring_buf_ring_cq_advance
      because it is in the FFI map file.

  Now, only remove `IOURINGINLINE` from these two private helpers:
    - __io_uring_set_target_fixed_file
    - __io_uring_peek_cqe

  I have verified these two functions are not in liburing-ffi.map.
  I will be more careful next time verifying the FFI map file.
]

Hi Jens,

As previously discussed on Discord, here are two manpage updates
about the iowait toggle feature. And then I have one extra FFI
trivial fix. The FFI fix is safe to apply for the liburing 2.12
release.

  - Add `io_uring_set_iowait(3)` manpage.

  - Add `IORING_ENTER_NO_IOWAIT` flag to `io_uring_enter(2)`

  - Don't use `IOURINGINLINE` on private helpers in `liburing.h`.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Ammar Faizi (3):
  man: Add `io_uring_set_iowait(3)`
  man: Add `IORING_ENTER_NO_IOWAIT` flag
  liburing: Don't use `IOURINGINLINE` on private helpers

 man/io_uring_enter.2      | 16 ++++++++++-
 man/io_uring_set_iowait.3 | 57 +++++++++++++++++++++++++++++++++++++++
 src/include/liburing.h    |  4 +--
 3 files changed, 74 insertions(+), 3 deletions(-)
 create mode 100644 man/io_uring_set_iowait.3


base-commit: 6d3d27bc42733f5a407424c76aadcc84bd4b0cf0
-- 
Ammar Faizi


