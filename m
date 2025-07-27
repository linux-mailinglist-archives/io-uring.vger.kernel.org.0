Return-Path: <io-uring+bounces-8792-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B261B12D35
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 02:43:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ADB09178A39
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 00:43:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57FF32C187;
	Sun, 27 Jul 2025 00:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="Nd6wWWc6"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985988F6E;
	Sun, 27 Jul 2025 00:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753577024; cv=none; b=HXDgElmNKI1AroqFJB1MIA1pzwVJlT3CpsQaeNoJXdm2EgohHgLgv973FPKQl3kIBDIWszSHi7hZjiLQHxsP+s61JiEUQqXv4i6Ut8LTuEuACiAQmM6TJ3IyfilQi8OtNUttZoSq1dlQ5Gs1C0WoxoXnlqRst43WP7eGrK8eS6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753577024; c=relaxed/simple;
	bh=TnXW7fZnrm+uavSGu7+OvFNTZCEXcKrFHrQeTFKXCGk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JW5ZHfzGWx4f5X7nYP2lCnMt70gOgWZ7KpJSw6UZxyn2y/c+V2Hj6xOGJabsqvGldr9cBJ1wm2f3BfIw9jpg7Iwa/FuN+b9TWA5hksGq1vEtMOWyOax822b+5afhGSlQopC0U6eSr+Hshes3KHtEsuzYyRUn6NDwloddYb++SZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=Nd6wWWc6; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=new2025; t=1753577013;
	bh=TnXW7fZnrm+uavSGu7+OvFNTZCEXcKrFHrQeTFKXCGk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:
	 Content-Transfer-Encoding:Message-ID:Date:From:Reply-To:Subject:To:
	 Cc:In-Reply-To:References:Resent-Date:Resent-From:Resent-To:
	 Resent-Cc:User-Agent:Content-Type:Content-Transfer-Encoding;
	b=Nd6wWWc6R0BsD+cwBXtWTI6OsEU9GVu5c4xIec0nQ+yJjPgpAFyuKCMW2hgxqGnF3
	 zospQ/p0psp+sqCiGVdy7Bc/3h+SFH9GYeBpU8Xmzzanstab1mCdSMw/bSTMNoIpKA
	 ecStKMBjiAkAeSBXh9DJqQwB1UW8DOlsYAj5/d6opJuok7X/Qnh5BwKCUuAHr3FOyB
	 C4YjyoBlPiexMxFQ9vFGQ4cjTATzWpUr6/7ZVgZd9My6F4esHIBQfUH3LBXbpVR9u+
	 0Du2DO1aRjbQtNUCABAFDQ8SdunZN5HBao8FpmrAxU+JQWwbNzdo2PrV9YTD8PP94l
	 D0OuRDji4u9vw==
Received: from integral2.. (unknown [182.253.126.144])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 3A3133126E01;
	Sun, 27 Jul 2025 00:43:32 +0000 (UTC)
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
	Christian Mazakas <christian.mazakas@gmail.com>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH liburing 0/3] Manpage updates for iowait toggle feature and one extra FFI fix
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Sun, 27 Jul 2025 07:43:13 +0700
Message-Id: <20250727004316.3351033-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Jens,

As previously discussed on Discord, here are two manpage updates
about the iowait toggle feature. And then I have one extra FFI
trivial fix. The FFI fix is safe to apply for the liburing 2.12
release.

  - Add `io_uring_set_iowait(3)` manpage.

  - Add `IORING_ENTER_NO_IOWAIT` flag to `io_uring_enter(2)`

  - Don't use `IOURINGINLINE` on private helpers in `liburing.h`.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (3):
  man: Add `io_uring_set_iowait(3)`
  man: Add `IORING_ENTER_NO_IOWAIT` flag
  liburing: Don't use `IOURINGINLINE` on private helpers

 man/io_uring_enter.2      | 16 ++++++++++-
 man/io_uring_set_iowait.3 | 57 +++++++++++++++++++++++++++++++++++++++
 src/include/liburing.h    |  6 ++---
 3 files changed, 75 insertions(+), 4 deletions(-)
 create mode 100644 man/io_uring_set_iowait.3


base-commit: 6d3d27bc42733f5a407424c76aadcc84bd4b0cf0
-- 
Ammar Faizi


