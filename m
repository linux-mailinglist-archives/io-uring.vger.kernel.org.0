Return-Path: <io-uring+bounces-1642-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E5EB8B30AC
	for <lists+io-uring@lfdr.de>; Fri, 26 Apr 2024 08:42:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34DD81F24389
	for <lists+io-uring@lfdr.de>; Fri, 26 Apr 2024 06:42:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C3FD13A875;
	Fri, 26 Apr 2024 06:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=disroot.org header.i=@disroot.org header.b="PpJcHE4e"
X-Original-To: io-uring@vger.kernel.org
Received: from layka.disroot.org (layka.disroot.org [178.21.23.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC8913A268
	for <io-uring@vger.kernel.org>; Fri, 26 Apr 2024 06:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.21.23.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714113747; cv=none; b=O/1Hgs6I9kd19a0DgZbtSO9tgq4jJjKDxEn9/yDpi/LEFOYMhg7K/2HDOFRX6EjloxG+SSHezEzIJUSy9HY1m3PEW78St0xGNmkAHxWsR/lqiIZukUBvMMZll1QVXak2zR/aemIZ/he1oRfTGmcfxfQC9s6uePwuymfA+TcSbpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714113747; c=relaxed/simple;
	bh=ErisgnAL9guxKazotRnBbWseagUpdCAcEpnNfFZltpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IhmLJvgw3KVlA3kZM6wyX1LmQqrGwGswayBIQ5QgNw1Ldk19ZF5HzzW1RfJ/GcZ7r2IVpSjjW7xWZ+glVyA/GH4rjIAfzI5RN02yELYzDyO8DYA/so83XJW34r3QfmuYKeLwBt2kxGofzL4LRxe3Fv7VXh4m462LqFa7CMUJTdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=disroot.org; spf=pass smtp.mailfrom=disroot.org; dkim=pass (2048-bit key) header.d=disroot.org header.i=@disroot.org header.b=PpJcHE4e; arc=none smtp.client-ip=178.21.23.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=disroot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=disroot.org
X-Virus-Scanned: SPAM Filter at disroot.org
From: Arthur Williams <taaparthur@disroot.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1714113144; bh=ErisgnAL9guxKazotRnBbWseagUpdCAcEpnNfFZltpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PpJcHE4e0C4WrffgtQAA2wvOToDt9tWFqZkAbDuG6vYxqYA80RZPFIsmfvz99WBtO
	 mLWJTPdtAN2TQx7rKZCSvLzwlPYGNoFHeCY2ibLywg39sqbpgLBpLzOeiMcC7+2s2q
	 RpTPyOzQVdIaxoB2AJqHq5fUZVYrcgLtq9htTS7rxHwempf7wBMeTYUp/u+tCHR+VR
	 4bj2vRNhQ27lj1E5SGM1izsuKy4IrDOlk4CuTlc5nrTini9Ehtb8ySJi8V4SW8fkc5
	 AIFEy1DjO5sQu8LUk+HSx4yLzq82uNjH97qb0j73pnZBvFE30zRYZbx56jlZ/ti8Rj
	 wzLX3c9kDVsng==
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Arthur Williams <taaparthur@disroot.org>
Subject: [PATCH] Fix portability issues in configure script
Date: Thu, 25 Apr 2024 23:31:50 -0700
Message-ID: <20240426063150.27949-1-taaparthur@disroot.org>
In-Reply-To: <ZhV83Ryv1oz6NyxU@biznet-home.integral.gnuweeb.org>
References: <ZhV83Ryv1oz6NyxU@biznet-home.integral.gnuweeb.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The configure script failed on my setup because of the invalid printf
directive "%" and for use of the unportable "echo -e". These have been
replaced with more portable options.

Signed-off-by: Arthur Williams <taaparthur@disroot.org>
---
 configure | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/configure b/configure
index 052920d..f6b590b 100755
--- a/configure
+++ b/configure
@@ -519,9 +519,9 @@ print_config "CXX" "$cxx"
 # generate io_uring_version.h
 # Reset MAKEFLAGS
 MAKEFLAGS=
-MAKE_PRINT_VARS="include Makefile.common\nprint-%: ; @echo \$(\$*)\n"
-VERSION_MAJOR=$(env echo -e "$MAKE_PRINT_VARS" | make -s --no-print-directory -f - print-VERSION_MAJOR)
-VERSION_MINOR=$(env echo -e "$MAKE_PRINT_VARS" | make -s --no-print-directory -f - print-VERSION_MINOR)
+MAKE_PRINT_VARS="include Makefile.common\nprint-%%: ; @echo \$(\$*)\n"
+VERSION_MAJOR=$(printf "$MAKE_PRINT_VARS" | make -s --no-print-directory -f - print-VERSION_MAJOR)
+VERSION_MINOR=$(printf "$MAKE_PRINT_VARS" | make -s --no-print-directory -f - print-VERSION_MINOR)
 io_uring_version_h="src/include/liburing/io_uring_version.h"
 cat > $io_uring_version_h << EOF
 /* SPDX-License-Identifier: MIT */
-- 
2.44.0


