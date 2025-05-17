Return-Path: <io-uring+bounces-8030-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB0A5ABAA06
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 14:26:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48FD74A6B17
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 12:26:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B0021C1ADB;
	Sat, 17 May 2025 12:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FU8jkT7S"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61FD1FC8
	for <io-uring@vger.kernel.org>; Sat, 17 May 2025 12:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747484797; cv=none; b=Jl7uEfEJ94HN8KZ4bxdeK5d8p43W6VEtEy8/S9K0tTjpGdGo8nDicLO4NQorJTDLZKyb5JKCN+7chfCPLP/+3mkQPt1CBA1XoAeVBImttiZ2EJkRDU3Hi40j05HBLzWjGyPcUz1g1B8xoZGoRnQ0d4ayYGcLZqhHH+0+cczletE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747484797; c=relaxed/simple;
	bh=9OS6AChYXsHaXZj8oxwjIEsc23JySsTnSufPr603P9g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rHMUC/zbfN9X8r7dBYH0VE9AiyaWgJX3ErPJvTJkxLf1euN+tCG0NfL9udEPZR3xnhhZBK8ERuYLEIhlNvXfBkAhkaD00HaE3WmQMkf0vaYeYhuotTHiyC8GRFBwtlyxH8ETd1rTXWRQZOq9ot/v8W5nCngDpYCd2Slqu14nC5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FU8jkT7S; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5fcac09313cso4565968a12.2
        for <io-uring@vger.kernel.org>; Sat, 17 May 2025 05:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747484794; x=1748089594; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=y3SWBMa7ZalrQmLvp3dArYX+uE2Z2HY7j4QWocpr/Is=;
        b=FU8jkT7SAazc68qtyEiiT6yRyJfChC+aaL9lwltQaE5ioINCFtdKspt0yXdFs/Md5d
         K/snywBK4zPY5zBRBG9Xpy7sSRW59+Zo2R3mhnEW6capBIRlEx7kYbKyLwMglbthNCKL
         BSYjmN0kvMaGq3onivceHQspihXd4dLs6BAcHZ9UQitt38w4aP7NIusLmwjW3UpwUtRp
         EX0GEd60i9xLoBeE5CRQ/r6AsMAIXVNzraEqB4+obRIz1sBqrY5tALWPPTfjGuBKX6iV
         2JUdSXagAC/j2lXlBju/J6fZ7cJqBZXU9jNvIM2+qQpcBEdM0ptrpFsvlmlgy8szEdAm
         a+Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747484794; x=1748089594;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y3SWBMa7ZalrQmLvp3dArYX+uE2Z2HY7j4QWocpr/Is=;
        b=T3k9BXnpa3gahFwxRP6ikRMmy7gpTI3YCBLrlWeqmNtAmigeQRxuZ476FpWCgpc7zd
         V4SNIKuOdYw6WpGiWiTmYVv3P/btRoj85zKC0LJrqdz5oiK/yyJP0AOQGvb/aM1M0JQu
         7tydXsT+hAUMfJ7mUa/0HooEDkq6sBCieE6UYO+ELejuZIe7/uZlgoFn1aVht8VWFZjg
         hbGgWFIRrCsYu1c+AAkw9Hbd2n47SGEDQqg6ho3sIQq0f0V53sd2MHYXJMCrdhtE167h
         VPGapEHrc46npAo82r1xA7xnf8K0WZKE8YeJaDsWISAKyJb3DR6XQ8rz302AO48FiY/J
         gN/A==
X-Gm-Message-State: AOJu0Yw2HwqocprjujOp0e6wKJvJwPt5KnBQ6ge80WOpTyHNtRBq6nCa
	nkYT9QQUsAogMzA4/rXfM4+dpFHdoZoiJnL1wLRZLaUtAhcYAj3vc5ie7/mLhQ==
X-Gm-Gg: ASbGncuLT2Vh9MF8nKHOG0lhSgXjPGGaECRFAhYz/++8UyQ5WHXGGQ68rtF0OVi4YQh
	Rt8x6+OrixkbjU+5EJlCMkSFyxYjgiyVYvbE5ZXRx0Ts+83yFgeHlMjQWwj4DnpNJQ8bCCnCqef
	5/mgvDpv1kOFODyq4bYwJAzYXiYBpnRPPGfz2nPPP4029HiPTkcrByIO/R5UEekLlebkZbIHFmX
	c5W9KjkqP0OUpvXDWBkDkt3iU5WrSz9If/HpKmN724esfEghI4OVaW92KNoHtAtLl9owG7/i2YN
	PFOAvfzMmoryT+kV5AJQvkFliKdE+NlTjqDUa97oFMmH9AblGYQ80HPjDpKH5hI=
X-Google-Smtp-Source: AGHT+IFemxchSknzFoIWA/ZMfAYwDIYp31pGSreuC8Jc77UhsQ/9znOCgZzKa8kafBCBxTImAjrCYA==
X-Received: by 2002:a05:6402:1e89:b0:5ff:97dd:21d6 with SMTP id 4fb4d7f45d1cf-601140a21bamr5071282a12.17.1747484793602;
        Sat, 17 May 2025 05:26:33 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.234.71])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6005a6e6884sm2876604a12.46.2025.05.17.05.26.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 May 2025 05:26:32 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 0/7] simplify overflow CQE handling
Date: Sat, 17 May 2025 13:27:36 +0100
Message-ID: <cover.1747483784.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some improvements for overflow posting like replacing GFP_ATOMIC
with GFP_KERNEL in few cases and debug assertions for invariant
violations.

v2: nest another lock to get rid of conditional locking

Pavel Begunkov (7):
  io_uring: fix overflow resched cqe reordering
  io_uring: init overflow entry before passing to tracing
  io_uring: open code io_req_cqe_overflow()
  io_uring: split __io_cqring_overflow_flush()
  io_uring: separate lock for protecting overflow list
  io_uring: avoid GFP_ATOMIC for overflows if possible
  io_uring: add lockdep warning for overflow posting

 include/linux/io_uring_types.h |   1 +
 io_uring/io_uring.c            | 122 ++++++++++++++++++---------------
 2 files changed, 67 insertions(+), 56 deletions(-)

-- 
2.49.0


