Return-Path: <io-uring+bounces-3992-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 990DD9AED32
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 19:08:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DDC7282F39
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 17:08:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 199511FAEE5;
	Thu, 24 Oct 2024 17:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oEC8Rvs/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C213B1F9ECC
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 17:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729789723; cv=none; b=eCfs0M2aeWbYo6ynPZSrsKrWtrBqrlZmIHSPtkRQY8/fxy+YikuY5wTEPAT+/xmKjysyi/pJ2X+cxOBDyPYGYPHKtItcK/6QDXGLN8t/bMavFIXEhFBlNKBeihp7bqfSTe32u99JIjo628V3yaOp7Dm/CuOWvy2887eXqxx9TkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729789723; c=relaxed/simple;
	bh=Hc8LWFF+BnTAwlQsvqEqcz1icMxeGM4aq1XGEcW9+IY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9KF+LXGVCeiZVk1BM1pi5OdGmhlPU9EcuHF205e2BJXzQJf+F2a88TbNjeRhAt4I/eN1euoE2/mMhGYalSxH9XloQkj6tCH3Ur+HwKe2PFrBMb+H0r4FhGn2n5kRDxl0GSqAIJMinGIA7DXlC1vBCCtfTUj7hDXKKRc59SqIk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oEC8Rvs/; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3a3a6abcbf1so4846385ab.2
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 10:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729789719; x=1730394519; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=olc4hQqg9C/G+s6Y4gqlaKc2EU5xK/tf7mC8ufS+JaY=;
        b=oEC8Rvs/R7cfkdeR4LAE+UqhfwNSjAsUDW6W9CHSs6Ast0t1Lq71x5U5ivoqNkpTf3
         V/fZygIY3j9ixboS/TKeN+1CFStGK9omS64T+KsXSWFPZPQBLQmYEQEaCaCAJ7aVpzeO
         ChQJ5T8KInBIyS1Cyf3K4CXhtXPSR7tpiy4yIjZap6fCoqOdptwEbi3vCLSiYNi86zel
         7a5ZlMeoDt2tlJJLVkTBDbLgokana/smhm4xQ1ktGLxy1rrZR3g30VbSU9k2SjkMEo9c
         PPnIKYFasjwVSv4n670Uu18c+r4Hhy6/H7GghhrsGUe5akR3zB07ADvUCHxbTVpdC9yG
         sjxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729789719; x=1730394519;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=olc4hQqg9C/G+s6Y4gqlaKc2EU5xK/tf7mC8ufS+JaY=;
        b=wUzC1s4AHHlRILbeCUcxD5N1b6JS+vhHMHsS3lRK66sT5tSklhNsUO0quPwdP/J0U2
         pivZuICaO+Vh5MDR62951DzhX1Eh1MDbXtG0JqBT34IYAqHwr5rECBEZXQhvPk8Gvnub
         vE8WjPKWKa7Aoms6pQmvqKU8eFoh3YUY75XLGfa01accAS0ffpokbOxDE517r0k2UsJT
         pSQUgeHbfqd3vIMe7sLQH4nFgaGQKzmvN49wNhPplYoB6BZ+3zLJwL1/xjfHiCiJMzHR
         M7NrQssAoqaiGmUBPjE82CwxymXQekcqVAhEJrrsanlj5UgFAPY1fpAP6tOn0hvb7ToT
         wFSg==
X-Gm-Message-State: AOJu0Ywxbus8IWcp6Q/WSaEtc124HK23DjLXuOHalhMmDLhxufic1WSf
	Q3xM6ipnhTnyfKCRJLXZsfOYpioYRJ/PaiBpf94JG0n2f72Km/EA7BOIu3wnjkz3hlvAuehGd4P
	T
X-Google-Smtp-Source: AGHT+IEvKaCJSldSQ/mwldl75w3PUJIuycZLqIFBzWu8kszemQckISZQ70u3Zh1UB8XuL46NnXrhQg==
X-Received: by 2002:a05:6e02:1448:b0:3a0:5642:c78 with SMTP id e9e14a558f8ab-3a4d599d224mr76969665ab.15.1729789719148;
        Thu, 24 Oct 2024 10:08:39 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a400b63981sm31368045ab.67.2024.10.24.10.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 10:08:37 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: jannh@google.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring/memmap: explicitly return -EFAULT for mmap on NULL rings
Date: Thu, 24 Oct 2024 11:07:38 -0600
Message-ID: <20241024170829.1266002-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241024170829.1266002-1-axboe@kernel.dk>
References: <20241024170829.1266002-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The later mapping will actually check this too, but in terms of code
clarify, explicitly check for whether or not the rings and sqes are
valid during validation. That makes it explicit that if they are
non-NULL, they are valid and can get mapped.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/memmap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index a0f32a255fd1..d614824e17bd 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -204,11 +204,15 @@ static void *io_uring_validate_mmap_request(struct file *file, loff_t pgoff,
 		/* Don't allow mmap if the ring was setup without it */
 		if (ctx->flags & IORING_SETUP_NO_MMAP)
 			return ERR_PTR(-EINVAL);
+		if (!ctx->rings)
+			return ERR_PTR(-EFAULT);
 		return ctx->rings;
 	case IORING_OFF_SQES:
 		/* Don't allow mmap if the ring was setup without it */
 		if (ctx->flags & IORING_SETUP_NO_MMAP)
 			return ERR_PTR(-EINVAL);
+		if (!ctx->sq_sqes)
+			return ERR_PTR(-EFAULT);
 		return ctx->sq_sqes;
 	case IORING_OFF_PBUF_RING: {
 		struct io_buffer_list *bl;
-- 
2.45.2


