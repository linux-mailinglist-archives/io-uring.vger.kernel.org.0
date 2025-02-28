Return-Path: <io-uring+bounces-6865-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98D44A4A66C
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 00:03:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 477557A8A9A
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2025 23:02:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45B5B1DED6E;
	Fri, 28 Feb 2025 23:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="BWPn5+DA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB6123F372
	for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 23:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740783821; cv=none; b=mW2pz5BAq3Ksvp8CsNreBqqXqnxi9DN0xsL93f1eUYLzYeorvRixMBFpBJl6gjp0YEo71ITH9izWiI/W0dSmhle+uhM/xcZZ2IvsrpQvtktntIVEf4vU+h4vOz6I/ic6sfLDSh2PlSa4JpgpLRKuo2ww7zQJGgXKMpKU8nDgdHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740783821; c=relaxed/simple;
	bh=7j3qjGvPFFSYTj58FVcu/QNHzMyIyli39yBCI3WM1kI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uNVH0eO4Drt2HFtMcEpPxPuTrwbt2AfI7zwQVlsaMpsoYCr01+rYuPdiTNkfWweJ0TdK7brExZXDwFukZd2uUoFZ6ICBtOr0xO0UTn2VyleIft4dANj3if7ZoycfmUuZ+Cgj+TT/NhyTZCkIAWEJEzR8/4U/WSbe/0YeMF5kUPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=BWPn5+DA; arc=none smtp.client-ip=209.85.214.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-2211ea911b5so7252155ad.0
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 15:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1740783817; x=1741388617; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Yf/QBUV7NVEQKN07Cfxd8tCBRl6ymxJlYuA3WLlAYys=;
        b=BWPn5+DAPWkRpGJUpq/O7z2kT/4xWYRVva11InSZbTBvuA2+P7hCma0YlUxTlE68qH
         cyvTMBFtUIFL/Nlf7XPLt1JaeCDnCumLF+WeFcapco3g/aikJKyWNqCLMgPa3fsiAV6E
         wfj5jXG2qPAZaX9UCCeeYDv0UAzmcoMPkoyyyJCP6EWueh9cIk2gulnhe8w8FSjkapA0
         Od7IEgz0Un+WY0F0AwBnM70tOUZJyCacgx0+NLbiMWF5o76VPTmZCiBapGdMnUAR5RUO
         e4yx8vOf/RrWStsxLzGxx4YrmaqVyIZBoW0Y5DEd50cxeSs19rJazwE7m3oSjei7WFZQ
         T5tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740783817; x=1741388617;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yf/QBUV7NVEQKN07Cfxd8tCBRl6ymxJlYuA3WLlAYys=;
        b=h31KEdxBhk6VZjywD+QU54azEmmsHPLOeHp37Ums37Na1QTNioe2dFiFUVUFTfEqoe
         O3fhLIM2uczIvGe5Xe8unSzYF5LbbH57uee4ERKBOGCmnwAy6C/AG9+t+jZVId8lhaxs
         rkfYqQGUrRR7MsE1MC3o11P5iMrdjCH3hgZTyD7qoZWHoOJyHdPwrBTcnTJ1u0BQFU0p
         h6AuKLaz4PhQucIBR7LlDuoRxSnqIxn1SkcjhK1UmAuqMPc+7RuihqsPWIWRPuYqGrhY
         QslVlsSkzbwsmghv/ESP6qMjJhCJZ6M6+hHLYfBc6edesiiUhtMpmJYZdk6xWgwcw/VZ
         DTIg==
X-Forwarded-Encrypted: i=1; AJvYcCXHvg/lLj7Ax2/YN+0G5uktuFGIPFmNd6TGVETMJGRmn+vj7TZl7nOEFtxLYTMaUfVgI8diAXpVKg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwIRELplSY01Mj3iHu5dIrPmzXaxDTnJZG1qlHnWTHKhNK6WQL8
	4DLiyZgI16J4EhL+lloX7JuyU81BjCv4uWYQqBB1zFh14leLVZISk1hVChNKEmNOP3408VJya57
	g4BWw9LufMKS9IulfsNtJ70VZav9/ooxN
X-Gm-Gg: ASbGncvBb1vUd7CAxSIjAqDyGC1wytmEaK0QUtKPaUdGS2bp+MW8bbwX5SXv3EseCNH
	OWTMiJnM1g3nzpVM5uu+6A7ECh0xO0Pa/EgHdzL2gqARFewJgErwdwmzPsxhb7s8/yTE8D6o5cW
	jul29jZA9EWRV3wbNU6GwqN2EW5ijz0o3sdZ0/Xdl9RV3kZZhKf5NP6gNDX/LP/QexUhbznEjL/
	+gIv59NMYRr6JwWKOdT5ZzyfiySyfJ3ZgZW2qZ1M9xcRlGPfxFwSz30uNNdxH9XsNjZoTbjGHoO
	+rpv4AfpjeX3kITRsxaRnA51PxCaRCjZoRCca8qUF0FtX/3P
X-Google-Smtp-Source: AGHT+IHUdSS4qvxNQbUG1GSSETx1tYeYbCJTASaP2vuO663APRzoix+sZ3ezmTaHknBze/LbhOwuljxwBf8y
X-Received: by 2002:a05:6a00:2348:b0:736:355b:5df6 with SMTP id d2e1a72fcca58-736355b8b91mr227420b3a.6.1740783817284;
        Fri, 28 Feb 2025 15:03:37 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-7349fdc7aacsm290722b3a.1.2025.02.28.15.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 15:03:37 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id CB61434028F;
	Fri, 28 Feb 2025 16:03:36 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id B891CE419D4; Fri, 28 Feb 2025 16:03:06 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: convert cmd_to_io_kiocb() macro to function
Date: Fri, 28 Feb 2025 16:03:04 -0700
Message-ID: <20250228230305.630885-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The cmd_to_io_kiocb() macro applies a pointer cast to its input without
parenthesizing it. Currently all inputs are variable names, so this has
the intended effect. But since casts have relatively high precedence,
the macro would apply the cast to the wrong value if the input was a
pointer addition, for example.

Turn the macro into a static inline function to ensure the pointer cast
is applied to the full input value.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 include/linux/io_uring_types.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 432c98ff52ee..72aac84dca93 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -605,11 +605,15 @@ static inline void io_kiocb_cmd_sz_check(size_t cmd_sz)
 }
 #define io_kiocb_to_cmd(req, cmd_type) ( \
 	io_kiocb_cmd_sz_check(sizeof(cmd_type)) , \
 	((cmd_type *)&(req)->cmd) \
 )
-#define cmd_to_io_kiocb(ptr)	((struct io_kiocb *) ptr)
+
+static inline struct io_kiocb *cmd_to_io_kiocb(void *ptr)
+{
+	return ptr;
+}
 
 struct io_kiocb {
 	union {
 		/*
 		 * NOTE! Each of the io_kiocb union members has the file pointer
-- 
2.45.2


