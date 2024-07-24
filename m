Return-Path: <io-uring+bounces-2566-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B1D493B034
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 13:16:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19A17281CAD
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 11:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0E42156886;
	Wed, 24 Jul 2024 11:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D/blJki8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4523814A4EF
	for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 11:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721819771; cv=none; b=TjRH5bRMoDyVMKKrFQ8HflQDWe3ZtZetB+AnY1niQA1On83zm8kS0B/3zgxlYb9rDzpoxIt+yWyqJhzfChO3G9JORjR4lwiGv8PsqO9/54aAhaeHAopLZRWuko3sllRuJLnZtyohypmI2+ZyJJIKRkPSO2oFVjmoixg3lZAWLJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721819771; c=relaxed/simple;
	bh=imeA3vE4jQrsL5WVBvXJe96G47DMdm+AVT4a1WuBEj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=latm7HWxqIYvHfiB8AQ8YeApKKJoXkad1HjW/vEIzUacIFjL79fsXtxmEIkZKhT9S9N21ZJS9v3TXbZT7gGTgRMmaW+XHdwWu42ShMn9tb/zjZDQ/VvWvPN2kxCm1rHBvu6u/wANS1FkJH1d9ur4oJB0iCqLeWFQY+a+hw1Bxxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D/blJki8; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a7a91cdcc78so89634966b.3
        for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 04:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721819767; x=1722424567; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2IDRXaD5aJDjvygbnrDO7lP8PgaoSxeYXNcOZBIEhtU=;
        b=D/blJki8F3ekO150xyABaeEWCF0gWX68Yfv3LvUNZ7jGiyrUowiBAHuEAAL7VzjmWJ
         Qxu4GQvpXEEmRo4xn6X7tCiggAWGH9VQz6JAtxYjVrUMWX7tLbM4sWzgtZ3QI/TRb037
         BYYXk2+eDMs3CFNxq9Ib1KCZd9D+ALEv4xh3WRHp7wtLD54TLIRm+rsYFpHrdhBkm10t
         KeCObRPHMU7KRvTH1xjY1lQPqv3oUfM9x63AcDPCkYeKJBeNizXmbUZ29b9S5suwWP75
         jMsGuzkTIusZmSSt6vfE31qfWV2Ncua6SzND129NZsqNZ5YGuXLEga5nk3IWewgxPR4b
         TyZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721819767; x=1722424567;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2IDRXaD5aJDjvygbnrDO7lP8PgaoSxeYXNcOZBIEhtU=;
        b=CGik0m5kHJHxJrMDolw30WS6DqV2ts8XJQM/0Pc6r5o9wcslyDuvJZsXsJN7a+xYAB
         lq/dBJh3jsknSD0xDYlniZEObLANHl0W+jchuvCnjY9UftmOEQJucRaNbX8ulvrBTR0f
         7APu2stlGh9wZUEWcfdDtqflzO1g5y4ahx2KjuWZDHy9aCgFbi8gJJdSLXPa+a7xDTJi
         KqTxFBtJjp5inBZc76UHddG+udNM9757Mq3dk8z6PIP5OFg7kXP4NpyB3ZwKeWPg+zIp
         DhS1ip37xw60C4b/+x4t+g/IjJrrBYH0tQzKcpqhUdyvkSmGfH4kkQDPIwov9jRzPh4U
         Bsqg==
X-Gm-Message-State: AOJu0Yz3/F3mjE4ZXEg0X7A63DXQGXYRrkAEVdv/LYnHk0BMGHK2mb2t
	wmTBIJyqhE/DI3jT60s8x6XC4HEdqa9XYycAnJ8RM0393fl5oHqSOh7BQA==
X-Google-Smtp-Source: AGHT+IH2lv7jpxntTtf99KZMZ/2/kqB4CMCq59l9/o9GslIn4aYm3rwqA9TQgEAGkvkbd8GyqQ1EFw==
X-Received: by 2002:a50:d7d3:0:b0:58e:2f7c:a9c with SMTP id 4fb4d7f45d1cf-5aaa50c9dbemr2320548a12.26.1721819766917;
        Wed, 24 Jul 2024 04:16:06 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5a745917f82sm5006310a12.85.2024.07.24.04.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 04:16:06 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 5/6] io_uring: kill REQ_F_CANCEL_SEQ
Date: Wed, 24 Jul 2024 12:16:20 +0100
Message-ID: <e57afe566bbe4fefeb44daffb08900f2a4756577.1721819383.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1721819383.git.asml.silence@gmail.com>
References: <cover.1721819383.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We removed the reliance on the flag by the cancellation path and now
it's unused.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 3bb6198d1523..e62aa9f0629f 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -461,7 +461,6 @@ enum {
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
 	REQ_F_POLL_NO_LAZY_BIT,
-	REQ_F_CANCEL_SEQ_BIT,
 	REQ_F_CAN_POLL_BIT,
 	REQ_F_BL_EMPTY_BIT,
 	REQ_F_BL_NO_RECYCLE_BIT,
@@ -536,8 +535,6 @@ enum {
 	REQ_F_HASH_LOCKED	= IO_REQ_FLAG(REQ_F_HASH_LOCKED_BIT),
 	/* don't use lazy poll wake for this request */
 	REQ_F_POLL_NO_LAZY	= IO_REQ_FLAG(REQ_F_POLL_NO_LAZY_BIT),
-	/* cancel sequence is set and valid */
-	REQ_F_CANCEL_SEQ	= IO_REQ_FLAG(REQ_F_CANCEL_SEQ_BIT),
 	/* file is pollable */
 	REQ_F_CAN_POLL		= IO_REQ_FLAG(REQ_F_CAN_POLL_BIT),
 	/* buffer list was empty after selection of buffer */
-- 
2.44.0


