Return-Path: <io-uring+bounces-6381-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F2F9A330F9
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 21:46:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8A883A88D7
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 20:46:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A8571FFC51;
	Wed, 12 Feb 2025 20:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="T+xlsJEg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626D11FF5EF
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 20:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739393167; cv=none; b=e+8E2DE7rIyIA5GQmpD7xwablR4FCmy1rQibuKSrS3+k5B+GkoYNEx9avGHYjCWU5DyEDV8tviQQ66nX1TpWTrxki6d0gqjU6SgdKKN2mcknkcVFGMShLRC45/j63D6cMgh1xcQ92IMIt7UnLFfsmYG8JFMHttdFOtc3ZRq6RoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739393167; c=relaxed/simple;
	bh=0LJjSt3oEend1gmYZZak25M8M1v0B3rrlIqISknkskg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=os6sAnsekJZ0hjWibgrxEFTRslynDR4mmdGxoFIrLgp5J+qKk/Fbjj5e428m+qoquO/KjxeUxuXNUoan8vuE6CBKP2BR2lIR5tKSUipEkSYC56wC53Q+MjX0GR+DfX8P4fR2bX2M5XXTWi1nGN9eo9ilvK27sbaLbrl/PwMZ/sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=T+xlsJEg; arc=none smtp.client-ip=209.85.214.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-21f54143aeaso184875ad.1
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 12:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739393164; x=1739997964; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZiHGm8Z7lClPdUqk0kB1EHyQ03s+QvOZkIRAonfJV60=;
        b=T+xlsJEg3Enk1k+4E+HGWPbEvYUvBODmMjPAfVZr6smu3MGE3nI7FTv1PnL+nvPCij
         uoLL9/PrCsSsu+WhF4ITXost4ZH6ZqpcEpr3u1YKb5faDDDpjHo3JWQKGU2rqkVwyvOg
         hXl7snm+fujE3z2jw1yTrXFjfu2ABt1mwat4O0/y06TeYZ22IRSQq/Q3U9JGmlB6dHEc
         pR98JMhW37Xn7LTKnqsT3erudRz+NwPcX5FBRFB6GGTqePFRMGJ7ZaiAc+uNY1Ucgv1p
         ng43YLC2L5tb96HXiAKeW1HxRyJ3TjT42+tKiQ/P3L1crpFGPzVJdkXKtKQdeDXpIh3H
         WadQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739393164; x=1739997964;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZiHGm8Z7lClPdUqk0kB1EHyQ03s+QvOZkIRAonfJV60=;
        b=Oc77Ndk4Uz4eLeMAC8nPIyDwwiIYFIcNRMFyTwA6z8BeRTiSCEk2dIPV3oT5mBPdsu
         X0LD3LxBerHC6FyCZGeS6ug+kyJvapGoSIjx3r//f02MfM6CF9EehPIXrJRHebjIiHPO
         EaxSV1UnXLl6vZyjtwcKgHwgjQPbCg5/3jpBDyWlbcDknA56syZjT9mvKSPv16rbgDqy
         g70EChwoueffZkac11Tl78JyTzcMrd+5Aoff8ZdVApP2rJmFfu+OWT2xO12k9ZarIBel
         PVC8ytlVxbhskKjbgcJT5oEH6g9EQYpNkmCuw67PSMN2yU6abrpduT4hFxYxh4KRTFwC
         mtSQ==
X-Forwarded-Encrypted: i=1; AJvYcCUALtP4D/zrKLkRZtX1rHbOnvrVzDFPh28jEt7GsQoq1daL/LS5zJWurRQFI9PTLCQYT7HAVn6OAg==@vger.kernel.org
X-Gm-Message-State: AOJu0YytCPdEUnAIBYTmn0c079cmkfaa7WtWiKK2OI7d1/1GyrM3HzG7
	WhpDQcnF1hS8Cb+8Cw5h/pcBJvC5WCBG8sPIfTVhLH8d4rWw0cnxYhvlM5VmL3eiEaNpyqNf49D
	lcjVwQ1g6Pgt9XzeNSuuB8r0Y2EYfv7vF
X-Gm-Gg: ASbGncstXjdtOqa7rU5dMt/DdQNho4ODFKb/ogsMD2/kuduu9LnFpf626YoPGFmOqK4
	CD6PXbIyJhUBsd4Le0AWBfBZTPi5J9gVEIewKt3faj8DPxALYILdI2kMCtj0fJRwRcRCMJb2IRj
	fOqpJhFpXxuly4Gbr+AJAg9bVaFrvk2/RkwgO34obYl2HsxLkVeX7ZxbkmnKHh26IDW7FzUvrKd
	Nf53WjuZi/GwSeARqSm4iUUF+/kELonhfso/ZRa4dSjytCZpVI2NkJJum4UmvFiqPWyQtP7E17i
	elYmuXdW3l6SRrqolcAe3pLV2w+xzr7w3sjWBQ==
X-Google-Smtp-Source: AGHT+IEesfnwMWPhBe3XCPFux/HTRuC73toUxHqLiz/tK4QjkS1qFTzqnxeFbt046WfoZgAZrpqPeYrRUO/D
X-Received: by 2002:a17:902:dac2:b0:215:b75f:a1d8 with SMTP id d9443c01a7336-220bbaaefcemr27593215ad.2.1739393164580;
        Wed, 12 Feb 2025 12:46:04 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-220c93caa35sm550195ad.47.2025.02.12.12.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 12:46:04 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id F35263401A2;
	Wed, 12 Feb 2025 13:46:03 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id EF352E419A0; Wed, 12 Feb 2025 13:46:03 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Riley Thomasson <riley@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH 1/2] io_uring/uring_cmd: don't assume io_uring_cmd_data layout
Date: Wed, 12 Feb 2025 13:45:45 -0700
Message-ID: <20250212204546.3751645-2-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250212204546.3751645-1-csander@purestorage.com>
References: <20250212204546.3751645-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

eaf72f7b414f ("io_uring/uring_cmd: cleanup struct io_uring_cmd_data
layout") removed most of the places assuming struct io_uring_cmd_data
has sqes as its first field. However, the EAGAIN case in io_uring_cmd()
still compares ioucmd->sqe to the struct io_uring_cmd_data pointer using
a void * cast. Since fa3595523d72 ("io_uring: get rid of alloc cache
init_once handling"), sqes is no longer io_uring_cmd_data's first field.
As a result, the pointers will always compare unequal and memcpy() may
be called with the same source and destination.

Replace the incorrect void * cast with the address of the sqes field.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: eaf72f7b414f ("io_uring/uring_cmd: cleanup struct io_uring_cmd_data layout")
---
 io_uring/uring_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 1f6a82128b47..cfb22e1de0e7 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -250,11 +250,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
 	if (ret == -EAGAIN) {
 		struct io_uring_cmd_data *cache = req->async_data;
 
-		if (ioucmd->sqe != (void *) cache)
+		if (ioucmd->sqe != cache->sqes)
 			memcpy(cache->sqes, ioucmd->sqe, uring_sqe_size(req->ctx));
 		return -EAGAIN;
 	} else if (ret == -EIOCBQUEUED) {
 		return -EIOCBQUEUED;
 	}
-- 
2.45.2


