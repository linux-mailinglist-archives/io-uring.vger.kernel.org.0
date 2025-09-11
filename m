Return-Path: <io-uring+bounces-9731-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DA8C7B53058
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 13:27:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD6F11884061
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 11:27:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8E923148AC;
	Thu, 11 Sep 2025 11:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RPLMjnSJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA481CAA4
	for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 11:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757589904; cv=none; b=ONl58y8zrVMKDQZR5zK9/1czqRuqzbb2FOPKrDtK9vtQ55txw9q7KxN7WPS+ZfIARnulIUl/hrS7dCANg+x/Pl3TqLlKFUF986Ox+kljoxui64yuQcl0VqpjoeK2Q+YNC3ZFgt6vV7ToG23d3P377nPvdOqY+Mf01p2m5cE04lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757589904; c=relaxed/simple;
	bh=nTW3oU94cQz4kmSCuDXLzDovpxoVwhpcqy7TUbCvqqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ScIvAVQRfSxIokzzKTnA5KAsZ1ezqqGn9ZmRwgvP+GyH8aFfFQWsYDQ/svZPK+ZqwL8doiYzjP5TZs02/iWzeZhKVPLG4l+ZY9aghJ01yMNUm1uHnLzeDEAuYy8KA9wkonNR7ViQqcMCwbJCaJ1vLT8AklJZ4iBUibWevNhdJY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RPLMjnSJ; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3e7512c8669so470348f8f.0
        for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 04:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757589901; x=1758194701; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5ZI0D+yB5TvFzC3onoG0wS5dx2aaluUttcYMtrdmRuI=;
        b=RPLMjnSJlWhWulXvP4dLiOk3HtctYRX/LT1j++mpgQpdMJV7LO3wLy6jCkNl7bjNzs
         exa5iRDCOR2NGHZKXnU+zT2w3s6lncCBPSLHYvxeJ1gfOdThyl6aPrlmv3ljF5mOs9c6
         zQAvHY0jFtXG2eZOgiQY/2oNL50wUEuTcG70fojFzWwsUVPTQTDjh9/wenmLFR43HBAd
         ezRKlaWrBHW0ReBj5YcU8QhHAaDzZOqsaSg5fqr0TBVryL69qFjxvZjwE8TsBrIXe7/c
         v9RDAK57DklcTD7w84c+WM3x52aoQqsLkThOavO0JyMruVUDiDkkhSDQ5AniuokDFhrJ
         a1Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757589901; x=1758194701;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5ZI0D+yB5TvFzC3onoG0wS5dx2aaluUttcYMtrdmRuI=;
        b=UjcdVw8vIoocaqQC/RR79W/7A7lIWNJtkgg+0ItubCTYD0aEgxMTB0yGqYVoyYOq9O
         Q3pd4giLoZFPlyMTtabencBgphLrxIDdGgijku1EdNdkLWSptMdvjxeG68GHTVCRcyEg
         hND8geX86Xc896Eei3fjLN+/R74SOjXedA8YPBqCs8ziA6EpNnjofxOCYnPW4CnkO1L0
         w7zzy/PGJbHiKqmwwAgjg9nnR8WIy+qFrPZC5t/fqAHNgZw/Yuzq31rgWtpuGAuzwKjp
         xI9z///Kvp3mPgc1o8tz4uD4zEG4LQJlHaxLaHL2cR7PUknzOu8xazBXKCif/xRPIKl1
         sTNQ==
X-Gm-Message-State: AOJu0Yyk5eudonx3nynoTKLYLiFxqtjQFNJRzM7L7iiGyxEgK2/NW/4k
	jaDayWGnaW9gqv76p/mOiOMsCmnwMZNSMamE4IWZ6vBxDOHbHrP8TVHSGWUqDQ==
X-Gm-Gg: ASbGncvWriEUvIdwguJ35vrHq3OL4NS3gK02L+OHQJqOVVKPQ993cFbTinj+nw9fGma
	/OrFDmTLWluvzA1Lop8TIyKvPgteqNjOCXgh0AX9K2Nqg0SpFnsYSkcDHSp4d2rYymSjgw5NWAt
	My2d+I+gbd/orIIN8Oi8jV70bKlsQLLmXlLNs4y2Jpdqo5mEpxzqpLTJ5cLT7bSciq+sC/T+wPD
	TTuiT3+F4oaa9AbXl6FC8XzdXw2unv7nGEEnvl838rRwTZ0B82Bp+FtlRyeIp6Ft/Re9QiElsbx
	YFMG4+PRaX7GOb0ZL/8+LzCGdzcWuWedE8eKEjSYKxnGBJcmtJ9FdulNZExw2auMW3EG6ivAOqP
	KC6R2Dg==
X-Google-Smtp-Source: AGHT+IFjzHBp0T8glEoFs4qCDMO4a0VqJOoefrrYRC82P+f/NCGn3hpkP8gv1fYxPWcqbW/IpdYkBw==
X-Received: by 2002:a05:6000:4184:b0:3e7:d46:2f64 with SMTP id ffacd0b85a97d-3e70d4632a2mr16565269f8f.28.1757589900588;
        Thu, 11 Sep 2025 04:25:00 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a309])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607d822fsm2095608f8f.53.2025.09.11.04.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 04:25:00 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 0/6] Add query and mock tests
Date: Thu, 11 Sep 2025 12:26:25 +0100
Message-ID: <cover.1757589613.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Also introduces a bunch of test/ helper functions.

Pavel Begunkov (6):
  tests: test the query interface
  tests: add t_submit_and_wait_single helper
  tests: introduce t_iovec_data_length helper
  tests: add t_sqe_prep_cmd helper
  tests: add helper for iov data verification
  tests: add mock file based tests

 src/include/liburing.h                |   1 +
 src/include/liburing/io_uring.h       |   3 +
 src/include/liburing/io_uring/query.h |  41 +++
 test/Makefile                         |   2 +
 test/helpers.c                        |  71 +++++
 test/helpers.h                        |  14 +
 test/mock_file.c                      | 373 ++++++++++++++++++++++++++
 test/mock_file.h                      |  47 ++++
 test/ring-query.c                     | 322 ++++++++++++++++++++++
 test/vec-regbuf.c                     |   6 +-
 10 files changed, 876 insertions(+), 4 deletions(-)
 create mode 100644 src/include/liburing/io_uring/query.h
 create mode 100644 test/mock_file.c
 create mode 100644 test/mock_file.h
 create mode 100644 test/ring-query.c

-- 
2.49.0


