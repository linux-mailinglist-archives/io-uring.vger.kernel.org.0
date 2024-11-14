Return-Path: <io-uring+bounces-4670-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 73E539C81CF
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 05:14:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 10F33B2498A
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 04:14:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1BA51E764D;
	Thu, 14 Nov 2024 04:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l/l5rt/b"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009551DF72E
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 04:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731557639; cv=none; b=h53vOQ/kqapzHc944CTASo6HPdfbz8MfLSoghHW6LkkJALfs7/1Ux48XZZdHxj5gOAPGzKKVQNnzwwtLdoghlNm+nrIRvXrG6Mv/zuyCahXDA5s9d66ouekSFEjei1qt+UUzUQpN79sRyO7D+gDd3+Zyf7XZtWFlSXNteePg7eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731557639; c=relaxed/simple;
	bh=+iRgfyvp1RV26mi5Rk4qeJ9YgK5DHWOntnhKYOuumOw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BARtkJTcVSKm7q5xGpAtGVUSeyUk9VRYok0qNhec+NPw1474UqAoSlgiKz5BNxQBxnFATYljnJ0hp4KIEh419pO+nnGEpIi1b+QLxNB62B5y0fJpeZDtBBrBG8WIrB9QEmBa7ZhTM+mGOeLAJ8nJbVBB0oZZOZnvyatqQ2HoOXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l/l5rt/b; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-37d49a7207cso117135f8f.0
        for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 20:13:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731557636; x=1732162436; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WJC61Z+l/SJvIvjUmjLzVjrZctJ2eO3GV8rkixkOSuA=;
        b=l/l5rt/bDqdmayopk9T/d/NM1fTsR0cvZrtoIyble/JLPA7spSFXjh6TAm8S1meA05
         Qh0n0lp4mpSUlTu3gq5cbMMIjihrBthe30voxLz07ThI7tChhl4Uvf6u0HjOKnzNP6HV
         hYvumvY9CvJqgj9cVgXTnY+krVEAHIULx/7BEVGkf+NQ+ITCckVyZfJjM9lMxUTuoneM
         ysUOPfKgQrUEUqAbRqhEbis4CwKCpLAuFmNXdNvvU620Ywkbj/rbRqf0F9jmlsDEPQXf
         X6Xcr55p69+lHEiFDCNjghUhpxAD4NMv4TcUGPNKXDgSL/weKgQfDRJjru4jsqFm71Tl
         2u3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731557636; x=1732162436;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WJC61Z+l/SJvIvjUmjLzVjrZctJ2eO3GV8rkixkOSuA=;
        b=IAeeUzUb6B7vc7KorKQcLxGXO1No+yiiLfXadPRqjad9IRKpPlVYI5qeWYhbZaH1GN
         nu+OeiEAODj+J/zOUBmxTj8q34cS8gSmNcNrhzEhoopL3PCjPtZqsgAUl3Dv/8jmEG34
         fsgj7vtmMzURTOxd94fTiLVfN8b6c35ykvCpzM5OI+eboN1hU4Eofh33kH96gTdlo9ye
         DfVQpCwAHabFXTWf1oniILK74wNUOptG55DST4xmP6/QiZ57U45iR7O5jxRVPyVzU5I5
         ZOtg6oLAqkfouaWfCPmemzNUeOlhmGZRj11BW9sPH+rApPW1Nu8SfsCFu6MOPJVMo/6P
         QSKg==
X-Gm-Message-State: AOJu0YxbsSJv+GQmZqm4idGMVprFJS+/6G0n+Ny5+PEd3K71PpHKBm11
	AgTQhDhoQ1idLtkb3rQ59y7IyLcmtbdTz2sRC9kJnZ6sAV6KaxlhGVxbqw==
X-Google-Smtp-Source: AGHT+IGKFhjh1q0gwQ/nIZuBLEf1laYM4IIrHZsXSA9rqEj6d/KhuIpF9sw6XNIF6b0VGfhpdzGehg==
X-Received: by 2002:a05:6000:1865:b0:37d:5232:a963 with SMTP id ffacd0b85a97d-38218503565mr445703f8f.14.1731557635904;
        Wed, 13 Nov 2024 20:13:55 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.132.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3821ae311fbsm251936f8f.95.2024.11.13.20.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2024 20:13:55 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 0/6] regions, param pre-mapping and reg waits extension
Date: Thu, 14 Nov 2024 04:14:19 +0000
Message-ID: <cover.1731556844.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A bit late but first we need a better and more generic API for
ring/memory/region registration (see Patch 4), and it changes the API
extending registered waits to be a generic parameter passing mechanism.
That will be useful not only for waiting but also request arguments
(msghdr, iovec, etc), upcomig rw with meta attrobitutes (PI), and for
BPF proposal as well.

I covered region registration with tests, but for reg waits it only
enables the basic test. Need to enable and run the rest of them
before merged. Dirty branch:

https://github.com/isilence/liburing/tree/io-uring-region-test

Pavel Begunkov (6):
  io_uring: fortify io_pin_pages with a warning
  io_uring: disable ENTER_EXT_ARG_REG for IOPOLL
  io_uring: temporarily disable registered waits
  io_uring: introduce memory regions
  io_uring: add parameter region registration
  io_uring: enable IORING_ENTER_EXT_ARG_REG back

 include/linux/io_uring_types.h | 20 ++++----
 include/uapi/linux/io_uring.h  | 27 ++++++++++-
 io_uring/io_uring.c            | 26 +++++-----
 io_uring/memmap.c              | 67 +++++++++++++++++++++++++
 io_uring/memmap.h              | 14 ++++++
 io_uring/register.c            | 89 +++++++++++++---------------------
 io_uring/register.h            |  1 -
 7 files changed, 161 insertions(+), 83 deletions(-)

-- 
2.46.0


