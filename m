Return-Path: <io-uring+bounces-8948-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ACFBB236D4
	for <lists+io-uring@lfdr.de>; Tue, 12 Aug 2025 21:05:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2F7807BC405
	for <lists+io-uring@lfdr.de>; Tue, 12 Aug 2025 19:01:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA53826FA77;
	Tue, 12 Aug 2025 19:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o2b+zBsi"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823241A3029;
	Tue, 12 Aug 2025 19:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025391; cv=none; b=opS6lEv5EzUCmnxNK3gUzq4x4Vlt8K502g3pEsz9IIKxqkjYRurSNh9ZVhGLTR/QOQKqXeJo/z44iyBqdCUaQxEvhHR8RLAB2imGp2LaESBIqgqHHf6jfaa7MNfVUhBHW82KocsQVIc2z9c1uKmatLWcuu6lqBQposgDaRTTEpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025391; c=relaxed/simple;
	bh=wCWKVq3Q5pO1Hg0R7abTVg7Q7oId8lJF+8dUIt9mYnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKMaVbgcHHZRtiYqJC/f79sTbbvDIdeUcA6/4DryK3xvT4pEjIIZt/9CCm+fdDBD8HRqLLJqg6zu47SGpQVp5cimuufU1pVgxHcTkO/9/eCPKfmCLNZPbOnPAvwJEQYZppMBGXm9EaNja6IfAkUtVMP3pTirmbGFvVqJDfUFfp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o2b+zBsi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB122C4CEF0;
	Tue, 12 Aug 2025 19:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025391;
	bh=wCWKVq3Q5pO1Hg0R7abTVg7Q7oId8lJF+8dUIt9mYnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o2b+zBsikznCXLMPGCMzRAaj41Upum0LPsxT3J5OmG8hoI2E75wcw8/xSdtvfwR8q
	 yGuO4sDPlMUmjpNz4oe3StloJtoqHds8hfksSjpT39knaPNSw2qmW3N/vMUGyNzEEq
	 oHAT4cABTda/306U7vcaaN+Jv0Io5XNyGv71A0z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	io-uring@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 027/480] io_uring: fix breakage in EXPERT menu
Date: Tue, 12 Aug 2025 19:43:55 +0200
Message-ID: <20250812174358.449078324@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit d1fbe1ebf4a12cabd7945335d5e47718cb2bef99 ]

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
Link: https://lore.kernel.org/r/20250720010456.2945344-1-rdunlap@infradead.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index bf3a920064be..b2367239ac9d 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1761,7 +1761,7 @@ config IO_URING
 
 config GCOV_PROFILE_URING
 	bool "Enable GCOV profiling on the io_uring subsystem"
-	depends on GCOV_KERNEL
+	depends on IO_URING && GCOV_KERNEL
 	help
 	  Enable GCOV profiling on the io_uring subsystem, to facilitate
 	  code coverage testing.
-- 
2.39.5




