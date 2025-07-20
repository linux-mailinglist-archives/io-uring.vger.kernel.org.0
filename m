Return-Path: <io-uring+bounces-8736-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 05404B0B309
	for <lists+io-uring@lfdr.de>; Sun, 20 Jul 2025 03:05:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8FD657A6664
	for <lists+io-uring@lfdr.de>; Sun, 20 Jul 2025 01:03:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 926601DDD1;
	Sun, 20 Jul 2025 01:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="slJHjzk2"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D17A29;
	Sun, 20 Jul 2025 01:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752973500; cv=none; b=npWcMfhWBWBMvQcqdUG3PFJL9+aZvlIHc9AWeojRs3H2rowCGNZNRLOSpFRmhAiZ8jGALpy0zDUKiztDmyGdPIvHdaw/pg2aKXvGOBO6rN9+38Nl02uYqKw79BKV3GJMeNDV0VjdJqZ/Yd3InrSgWakR/e16etpGgOY3xQtWyEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752973500; c=relaxed/simple;
	bh=J5ONf2/vObDogmie4E1Tcjz5eWlIkgUdQHIpkojtkIo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G1AXUnafaskLfz5CP9J47pA9abaYrytP64D2S9qv/eFkCekIL1F0AZXwie9YkvAazKNopS4SRuCeIlbM/LYkc7p7XFwvrfUoqpBkjnmDwpDuZnJbiMWxQDA0dNtD5wpDGVHtao80EFdgal4OvEzwk8GQe9P+rHZxMRb1Ha2LMgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=slJHjzk2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=1IpDDexvMkyflO8ZMuyVczK9Fvl4IY3sUtSAnnEn6dg=; b=slJHjzk2Btjdg5uUOrfXaIr8+e
	8lVvBcCHx5q3iRWaw8uAf4KUuFWew/rYoFYWJlnMznPq4OdtP+8EglDuA93VFePqFAfRDkwrRH0Z3
	+xcuLEWo8u19Vb9mmN4GY13/wjkq4jGg0YZNaCq6uyhnvDSIwESyKKcsDr3YUA5pp7TQzeEOePI8B
	6bRSvd5+eBD52eyfdg2JxS889O0GC+lQPyOO1f2OxtYzA2QoPkZ1LOX6NmMMKnPwZ4/mGmrWH+Zqj
	9HfPEvuzqIluJW1bT/DhAGfnXNeUJt061BEQZwck48YciFR5demJwrwXVAGU5iLf84JrKWAD25eMz
	sT/x6T4A==;
Received: from [50.53.25.54] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1udIU5-0000000Emxl-1PHm;
	Sun, 20 Jul 2025 01:04:57 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	io-uring@vger.kernel.org
Subject: [PATCH] io_uring: fix breakage in EXPERT menu
Date: Sat, 19 Jul 2025 18:04:56 -0700
Message-ID: <20250720010456.2945344-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a dependency for IO_URING for the GCOV_PROFILE_URING symbol.

Without this patch the EXPERT config menu ends with
"Enable IO uring support" and the menu prompts for
GCOV_PROFILE_URING and IO_URING_MOCK_FILE are not subordinate to it.
This causes all of the EXPERT Kconfig options that follow
GCOV_PROFILE_URING to be display in the "upper" menu (General setup),
just following the EXPERT menu.

Fixes: 1802656ef890 ("io_uring: add GCOV_PROFILE_URING Kconfig option")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: io-uring@vger.kernel.org
---
 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next.orig/init/Kconfig
+++ linux-next/init/Kconfig
@@ -1827,7 +1827,7 @@ config IO_URING
 
 config GCOV_PROFILE_URING
 	bool "Enable GCOV profiling on the io_uring subsystem"
-	depends on GCOV_KERNEL
+	depends on IO_URING && GCOV_KERNEL
 	help
 	  Enable GCOV profiling on the io_uring subsystem, to facilitate
 	  code coverage testing.

