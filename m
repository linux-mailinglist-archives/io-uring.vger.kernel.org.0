Return-Path: <io-uring+bounces-8946-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A136B231F4
	for <lists+io-uring@lfdr.de>; Tue, 12 Aug 2025 20:11:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7CB40162F76
	for <lists+io-uring@lfdr.de>; Tue, 12 Aug 2025 18:06:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B7A92FDC35;
	Tue, 12 Aug 2025 18:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MpRVo/gT"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C5E2F745E;
	Tue, 12 Aug 2025 18:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021970; cv=none; b=fsuyYTAfNUhdWfeuXi3WYiVCV90Pv7RsLfDvhpoBKmvDKSoxfIOHaTQRfTn4qZTwdyiEgQOgAfaXS3ZklgRbkHWmj/xs5yZuXoSkR2eu7GbQyJ49RszDaCVst6CW297091R2MdvG3mzIO8xAieBErBZJO7OkGYTsp5tFR4oWA/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021970; c=relaxed/simple;
	bh=BLaq/T29CoPxFdy40K1Xxaeb5p7zK5DU/UB1bAL4a8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pd9GF1brE9ryJxoFRaYe3oGH3LVKPUxYR2e3VsH8VHp/+6RPu+vffeKrL5GIZAtVXjfmI0igZ1/WADtCvtWW05WOGzHkzEOf3VUGnAwEIVDgXfPr4yruOxCU186xZqM62faY6etPfQ3BAUBwU92ab1t4cjMYkyzDXe76WAtVdLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MpRVo/gT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40039C4CEF6;
	Tue, 12 Aug 2025 18:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021969;
	bh=BLaq/T29CoPxFdy40K1Xxaeb5p7zK5DU/UB1bAL4a8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MpRVo/gTp2nnuD9YxJtr2PLUl76ko0N7/Ow0bQgsP1z/X43k74AcZb7U/MioOHbcs
	 gF3oK5rPV5QrwzTPjTcA0LFCn6AxyfJSDgMBvFHhSxUqf88wYrGgpYtoygaGu3mPog
	 NgLOWf10JElmEHTf+y02Dvn+1KPeigJqNeM50XHg=
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
Subject: [PATCH 6.12 017/369] io_uring: fix breakage in EXPERT menu
Date: Tue, 12 Aug 2025 19:25:14 +0200
Message-ID: <20250812173015.390331886@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d3755b2264bd..45990792cb4a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1741,7 +1741,7 @@ config IO_URING
 
 config GCOV_PROFILE_URING
 	bool "Enable GCOV profiling on the io_uring subsystem"
-	depends on GCOV_KERNEL
+	depends on IO_URING && GCOV_KERNEL
 	help
 	  Enable GCOV profiling on the io_uring subsystem, to facilitate
 	  code coverage testing.
-- 
2.39.5




