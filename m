Return-Path: <io-uring+bounces-8947-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF8D3B233C4
	for <lists+io-uring@lfdr.de>; Tue, 12 Aug 2025 20:32:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B51D3BE9D4
	for <lists+io-uring@lfdr.de>; Tue, 12 Aug 2025 18:27:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1CCB27FB12;
	Tue, 12 Aug 2025 18:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+yXMv2c"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A7461FFE;
	Tue, 12 Aug 2025 18:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023273; cv=none; b=OOHhOQZCOPRhjPr8yBOjcdwhB3yzT05ZHv6WN+I7eeWIIHWB20MC4DYcjZ32UVHljlgYWt9Ol6JIcHUdrq1gK9i6Q8SFIj2o8YFAXc7kCuROlfZfHUtvKunZf+Sksbi+K6Vz8WPOHnTLqCCE8O4bTGH25i1o8Qc6KKXDggFZ3vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023273; c=relaxed/simple;
	bh=PaIuis6KUP35l5ianooxwhJBS1qUyJpPN2ckE36NABg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D1qYXBWgjQeGyQiHI5CxuRaq3tyjNN38GIqMJ5B5HAIc/q1Tip+/vK4Pv5NCPSxvt5ynfesHX3lKYD+dS+yCfRbmChPGTWoSlExsBbEUZxSVHRne9x+BU6z7N58ke/Om0cSI7q07SfS2HK3VNo96PMZwBvkA3hFDO/VngL3+VBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+yXMv2c; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DEDC4CEF0;
	Tue, 12 Aug 2025 18:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023273;
	bh=PaIuis6KUP35l5ianooxwhJBS1qUyJpPN2ckE36NABg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U+yXMv2c0sOBXXUlhHsXxNbDWOj+Ymf20jMq0Y5me7U/+sj1S7IY4bWB9KoqJBsCW
	 HEOQrUOu8LMKpNuXPiklp00iXn71/PYbWcv/4ijcsyhrl1/6/kLN8kwZzSMp7XQ2gX
	 sJ0GbeK6qfZckGK023ZUWnJ36z2vlKVK0PLz7xJc=
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
Subject: [PATCH 6.16 024/627] io_uring: fix breakage in EXPERT menu
Date: Tue, 12 Aug 2025 19:25:19 +0200
Message-ID: <20250812173420.236334473@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 666783eb50ab..2e15b4a8478e 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1794,7 +1794,7 @@ config IO_URING
 
 config GCOV_PROFILE_URING
 	bool "Enable GCOV profiling on the io_uring subsystem"
-	depends on GCOV_KERNEL
+	depends on IO_URING && GCOV_KERNEL
 	help
 	  Enable GCOV profiling on the io_uring subsystem, to facilitate
 	  code coverage testing.
-- 
2.39.5




