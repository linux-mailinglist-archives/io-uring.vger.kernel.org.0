Return-Path: <io-uring+bounces-7963-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 09B97AB5B23
	for <lists+io-uring@lfdr.de>; Tue, 13 May 2025 19:26:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA8731B44186
	for <lists+io-uring@lfdr.de>; Tue, 13 May 2025 17:26:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09C4B2BF3DC;
	Tue, 13 May 2025 17:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mkPysGJ2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A891A2398
	for <io-uring@vger.kernel.org>; Tue, 13 May 2025 17:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747157149; cv=none; b=CTCxH1oKdAWY5Qq2V+t54SZ1hjYTVCr9DUF0hYbX6VueOezBs5gC37m32AVUbL39lSirtnmhkFKcl2impBy0Pir6lsbl02JtLiOCc00PMk6zJsgLgDutHTYPO2W/XKIF0WG6UFm/nMYC22xq844jMbn2gKN2f5ODQRXPJPXix+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747157149; c=relaxed/simple;
	bh=9DT0+p/oc9I60Ykr/jw8frPfz0d5J7j9enj00JhuqPA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aYfHnqCNCyFvPYxk8EkvMuycV2geYQX4ZmdMZEc6yyd59zBUqoaWIqTlgK8YW6ZwXN9yZVoaxDZnaWAK8GTSOrfMopqZfN6+5w9zh6BwWUgJAj12wnoor9E64Ui1oPJ7fSZb9hL5diVWZUWw4xml+IwtQvs1oDm3478TqdZ4mHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mkPysGJ2; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-442ed8a275fso7442765e9.2
        for <io-uring@vger.kernel.org>; Tue, 13 May 2025 10:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747157146; x=1747761946; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=T45+Q4aPB0IUHYpbsVxvmyAOtRZRwkxRBqFlTeaO4hM=;
        b=mkPysGJ20I6D8Lm2rlS+yPpC79ySl2eimfGvu8MknoqhcWgcTHXcx9KcOnR28kcy67
         7wY1DJd+Q9RaiJ1M5MRGWDuC64g5F9HvnoEA0UMXUfxVGQkBTYpzc4tnjqXt667MIZzP
         EonBwzTVs8/nQ/IL0BI7IJRC7yum9Us+LzEBN1ki+t9AjZaX39iFtVnXvgXr1zkSB+8j
         6bA6mb5rFDfxQGZDMkMM64tQhJfyp9AWhgeAdPd8fNVQp3eRDvli5VAQ3iQLc8qDfarB
         uocBvQa7tN4d4uzY0iHf3Dv/EiyPw338rZ3+VqNV6vvZoG6vTsRsLaNxlAvTtvDG+QCd
         KWqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747157146; x=1747761946;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T45+Q4aPB0IUHYpbsVxvmyAOtRZRwkxRBqFlTeaO4hM=;
        b=RjPQfkT3gli6b/Zuwz2SHdwONMzKPvZ6gKTHpP6dn5jTeC6VW3zNUErtzz0vUa5Ngc
         mqh/C0JIPS2LyOqge0vpnt3PQmQnJ46mdzIG4GibbLaSLgJL6GMMKHiITg6+sMX5Gdet
         yb9erAtiW621JdJs1a9BtRuV6DM5Rqc312X5lJPkoKz1lIsJXSr0+/6jmU7/TAMlgoBG
         AbuLSV44Z5aTpFu+/O7nk1b7uC1mtzIz5THF3EeDCwTvSmemZpLLbKzxek1V/jR3ER/I
         +o8ERki6LSsD/XjNmUexxhzMoKpXaykZURU1/8P+rcDEpN4W7WxTI6tKDikFX6N33Uai
         cVWQ==
X-Gm-Message-State: AOJu0YxZg4sU+2Nt7PsqTskOlkSsoRI7eBbjeh9Nx0gQkE0lo1KKr5MS
	4VQEYvMbw+ALih9SKMqXhVeEU6txvLexonec78N9hpBCETI2Hfx0v/sQzQ==
X-Gm-Gg: ASbGncsg9poeMxHpoJXgJ1hoP7iAevmi1DIasshDTz9512oGazeovgHJTyKi4qehj8O
	9o5c0xeE9oH9ZzzE7A9qHtBZjaheBVy10yOgQOSesCvTFWUwR8XfPGibxkAgMhk/qUPEX1RTmWL
	34T43iM9N6ran+rYQuxBLHlBGDVNvmezuC7tGQ7yEL59xRnrUXJwrPvm6GQlgkAZfR5Q25v3HMZ
	nkVjYWY0+OADLIxkWUN8R7gzpjahLv8mj8sV999o5CkXweSjcpwuS6YZ5d9U3Q4JPxiHyRkfiwo
	f15V3UoDq8w50hGejtkgVCcaYtK76VRDFQX7jZZMbWxaZrj9GptSAsDMmHWhujKuKA==
X-Google-Smtp-Source: AGHT+IEE/7pBP4G1fQ3KTZ4BqZl1BhPojoM0LhiKwYJHZ/FfT5hJRQPk2QRajpiFSje8d45biTEfhg==
X-Received: by 2002:a05:600c:3b83:b0:43d:7588:6688 with SMTP id 5b1f17b1804b1-442f20e56demr1677175e9.12.1747157145835;
        Tue, 13 May 2025 10:25:45 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.146.237])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442d67e0ff1sm173034745e9.14.2025.05.13.10.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 10:25:45 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 0/6] provided buffer cleanups
Date: Tue, 13 May 2025 18:26:45 +0100
Message-ID: <cover.1747150490.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Random small improvements for provided buffers [un]registration,
with Patch 6 deduplicating and shrinking legacy pbuf buffer
management opcodes.

Pavel Begunkov (6):
  io_uring/kbuf: account ring io_buffer_list memory
  io_uring/kbuf: use mem_is_zero()
  io_uring/kbuf: drop extra vars in io_register_pbuf_ring
  io_uring/kbuf: don't compute size twice on prep
  io_uring/kbuf: refactor __io_remove_buffers
  io_uring/kbuf: unify legacy buf provision and removal

 io_uring/kbuf.c  | 131 +++++++++++++++++------------------------------
 io_uring/kbuf.h  |   4 +-
 io_uring/opdef.c |   4 +-
 3 files changed, 50 insertions(+), 89 deletions(-)

-- 
2.49.0


