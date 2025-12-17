Return-Path: <io-uring+bounces-11153-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9303ACC88D8
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 16:46:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7292831A3A7D
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 15:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6180134A78A;
	Wed, 17 Dec 2025 15:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=deepseek.com header.i=@deepseek.com header.b="Ne2L98hN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-m21467.qiye.163.com (mail-m21467.qiye.163.com [117.135.214.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2CF33B6E0
	for <io-uring@vger.kernel.org>; Wed, 17 Dec 2025 15:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.214.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765984932; cv=none; b=S2RM6QD0fFIySMh5NHiUzP1AT5rwOpteS+ceenSpOryQcnY1rASBUsZ2KOVJwi/mUdoZfqk7rbXXJoBNaxSaAMTbJn2dAD60AthR+F7Fz8nN1rFaHZL53I8MdWNZUe1HSlmn0mSNuDf7tzg21zVzhjgq1tlrLjo0b8ukSZw2zh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765984932; c=relaxed/simple;
	bh=vfE/wHpM2916OwZZk7+ZV/KtQcS4omXKFlMf6ygZyAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HtErbFEFzp4VtlCrqa8zlHS+AQBzRDeVzF/bfdk3o7QI+r2AK+GsmW/MGE98Kx4FLCD2Ov7If+fZt6MRfUn4rwVMZoW5YnthCnUSB0Q85O7uZwQds25/0vVOENir/PbVIDwk17G+i7d86JQ7C/YCO2djiyOdnJJFBbCnI6EgzKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com; spf=pass smtp.mailfrom=deepseek.com; dkim=pass (1024-bit key) header.d=deepseek.com header.i=@deepseek.com header.b=Ne2L98hN; arc=none smtp.client-ip=117.135.214.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deepseek.com
Received: from localhost.localdomain (unknown [159.138.106.230])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2d9c8e5bf;
	Wed, 17 Dec 2025 23:16:48 +0800 (GMT+08:00)
From: huang-jl <huang-jl@deepseek.com>
To: ming.lei@redhat.com
Cc: axboe@kernel.dk,
	csander@purestorage.com,
	huang-jl@deepseek.com,
	io-uring@vger.kernel.org
Subject: Re: [PATCH v6.20] io_uring/rsrc: refactor io_import_kbuf() to use single loop
Date: Wed, 17 Dec 2025 23:16:47 +0800
Message-ID: <20251217151647.193815-1-huang-jl@deepseek.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251217123156.1100620-1-ming.lei@redhat.com>
References: <20251217123156.1100620-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b2ce2a10309d9kunm27c09bf1618feb
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkaHU5NVkhOT0pIQxpNHUlJGVYVFAkWGhdVEwETFh
	oSFyQUDg9ZV1kYEgtZQVlKTkJVSkhDVUpLTVVJSEtZV1kWGg8SFR0UWUFZT0tIVUpLSUJNS0pVSk
	tLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=Ne2L98hNOh9qbxzOiLOipD2Q9ltiqfT6B3lWs7Xsk8yyEN00WqYRUVFV4FjYuV5UHHPlMzDsU/hp6rSUvREkzAxIu6n+yQjHb+m+5fa1ncOQtSEHzGlz+gHW9Wk0EtTE03Dhne0FBVZ4zADNF+zWJkdFVmSFTRE9H+99bb9RFEk=; c=relaxed/relaxed; s=default; d=deepseek.com; v=1;
	bh=vfE/wHpM2916OwZZk7+ZV/KtQcS4omXKFlMf6ygZyAA=;
	h=date:mime-version:subject:message-id:from;

The code looks correct to me.

> This simplifies the logic

I'm not an expert in Linux development, but from my perspective, the
original version seems simpler and more readable. The semantics of
iov_iter_advance() are clear and well-understood.

That said, I understand the appeal of merging them into a single loop.

> and avoids the overhead of iov_iter_advance()

Could you clarify what overhead you mean? If it's the function call
overhead, I think the compiler would inline it anyway. The actual
iteration work seems equivalent between both approaches.

Thanks,
huang-jl

