Return-Path: <io-uring+bounces-4699-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8B529C9195
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 19:22:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DE3EBB379A2
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 17:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CC1418C022;
	Thu, 14 Nov 2024 17:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kjkW4Ew5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55DD18BC21
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 17:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731605891; cv=none; b=FQ0jTzWBR9eobTTIkNh2vl+0wrD0tG9Ni9JNhQBsp7P7mwt3i54Pah5psh3upwN4k5Pr+ZG/MpjZKlA6mDInCQklo36Jn7CFyO24wUSfIZjjLFKnSzt2dyqK1QE8uVYYmhRDO6a6ZamGFtaK/f+W8dWhBVUEnqkdGBM82ZqLlm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731605891; c=relaxed/simple;
	bh=bOXuPylse+C0vi8bk1k20OU0yKwquVaExqg5AhfYLSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LFM2Z4mWoMzsxNd/x5rHh7Nev5GELO2apTrFiQ5SabqyK4P/sZqtH1dbnJriuvUknOtGKaQYGUNiJpCq2pT1fM1mOIFkWX3+p91qavjiA8UYCJ2F+1Um7i/ogvyAT0cgCVZovMbapwdrT+NW8/SDu3vlNB8LvuNLRYM+zoTk/WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kjkW4Ew5; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5c96b2a10e1so1531149a12.2
        for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 09:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731605886; x=1732210686; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hwyltf5fgdrVd41AJQ/C7rIRuEDCxBHV6H77DqLRdb4=;
        b=kjkW4Ew57qQt1wa34buEqr00mf4vLxG2Az+cq/OBVHUrV3T3CzyufhjH7Jd+3b8Xsf
         IzDhlNd+AXfdNvqy+83wSd/4lOikoEUFh4xBsVn9Eu5EPHbW4LCsbPYja9loNyAHwH9S
         ConrBgiUk3vxah2WW17fNRO/93Ec4BPMNjyMRucc4hHIZHh53fTdnIaj5Og6a18c7b0+
         u3kKWHiHFWYDQ2WAzhhSLwV6Zo64zv8Uw1jrtO2VPAX2sUfcre4fXAw8qu0OJUl5fsja
         WtmbfUf+PaIK0x/UiNZsxvAjseyFEZA0dOGMXVd+5qk2x0oWZvY/4ZMlKN7J7FlaTmoI
         8VVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731605886; x=1732210686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hwyltf5fgdrVd41AJQ/C7rIRuEDCxBHV6H77DqLRdb4=;
        b=Yz3SXA5aJyF+8L8dV9nGZAKmzECBft4qPCrB43MAz6/GiYq1N0Kq5eBduNLz7/RhD6
         j15B9E0uzizAQmCfcbNv6wn7bHvF+RzRFpWkyZPmhqdXr1tnCdFSilcKDhpV6KNWNOgw
         RG7+7y1KrsbHPfsojvp1XOZJ6EkKloatWUw+eFYKIn9KmohTOpo3WlhzbKW/4XkD7DaP
         ZghbetGjQKmB0OqJiz5gUAwX0zCsAXHt+AvgljLb/Y0yXgT5hCevGHHLDL2+8bHc8LtK
         1YbO9yuYKr4Rh8TZ1GTF/AeYKO7kDU1cXYxBtHzabNaY3jPK/njabMbOcXTGuTy3S4ln
         KEnw==
X-Gm-Message-State: AOJu0YwYgcats8TNVU5Rvn+cDdlzk2oHX/zhPUTLP3FmL3Gtku2wQqGX
	dxlbZu9vO776S30NRT/O1DtNjJaNP+EG+lzAmpWc7XVqkpG/AZwnxe0qEA==
X-Google-Smtp-Source: AGHT+IFLrBnrhgupBSxAeeyTLlK6AzEX2PN7Q7KdVaFeLRU3EICLH6ubGg0wE/iSII3BQYMR/Lj0/w==
X-Received: by 2002:a17:906:4f96:b0:a9f:168:efdf with SMTP id a640c23a62f3a-a9f0169008dmr1613752466b.6.1731605885712;
        Thu, 14 Nov 2024 09:38:05 -0800 (PST)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20df56b31sm85799966b.72.2024.11.14.09.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 09:38:05 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 2/6] io_uring: disable ENTER_EXT_ARG_REG for IOPOLL
Date: Thu, 14 Nov 2024 17:38:32 +0000
Message-ID: <a35ecd919dbdc17bd5b7932273e317832c531b45.1731604990.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731604990.git.asml.silence@gmail.com>
References: <cover.1731604990.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IOPOLL doesn't use the extended arguments, no need for it to support
IORING_ENTER_EXT_ARG_REG. Let's disable it for IOPOLL, if anything it
leaves more space for future extensions.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index bd71782057de..464a70bde7e6 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3214,12 +3214,8 @@ static int io_validate_ext_arg(struct io_ring_ctx *ctx, unsigned flags,
 
 	if (!(flags & IORING_ENTER_EXT_ARG))
 		return 0;
-
-	if (flags & IORING_ENTER_EXT_ARG_REG) {
-		if (argsz != sizeof(struct io_uring_reg_wait))
-			return -EINVAL;
-		return PTR_ERR(io_get_ext_arg_reg(ctx, argp));
-	}
+	if (flags & IORING_ENTER_EXT_ARG_REG)
+		return -EINVAL;
 	if (argsz != sizeof(arg))
 		return -EINVAL;
 	if (copy_from_user(&arg, argp, sizeof(arg)))
-- 
2.46.0


