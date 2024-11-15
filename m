Return-Path: <io-uring+bounces-4723-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 672899CF328
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 18:42:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E3DB8B3D60D
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 16:54:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D8381D61A5;
	Fri, 15 Nov 2024 16:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QVowQ1ll"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A46C762E0
	for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 16:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731689641; cv=none; b=P6klgoQpkzod8LGgI9+4KpgLejLWmCDxKa98oK1ea3Snt52yj3bXx47SGuzz2V1fjLQszTiwRZZXBCS6AhsEUXHO/0yR+SZJcGgT3WILmtchkn73z6w1bkSgfUIi6QUxlh7EJ7fyz3Vls8ZDJlPpG1aUKypt3hHMh2K+xFwDYxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731689641; c=relaxed/simple;
	bh=C2x1YUFhAH3Xa2rU5GM+rPcmhVttfxJ+qupdaEyvvW0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UAH3kwsFRkMNuBiWvat4bfGkHZHR5CiMqURQhog///XwR7GVkmgY1Enh96/ys+WhJDvMpsop8VvMFRC3Y06GCoU6UzmR8mkYCibNjZIXuADx6sg2LPWJZ6CI+py0sOWNZwTYoNny88HJ46pHdJK/QvnXBOqsFmT3vTatL5m6yuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QVowQ1ll; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-38222245a86so1031464f8f.1
        for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 08:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731689637; x=1732294437; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YSEGn2aHARabFs7/DWQ9H+ZcokKqADHeSFNYQl1I4Ok=;
        b=QVowQ1llTUHcoZ1yzqVSD00F/WfPbTlvsN42v5tgQQRFxrzzsNm7imMVRz/Lga3hp5
         w1epTS9yosLFMzkBpdscs3Yo4kQoVx+UYnazkSSYlPi4SlrnNn8tsr/rlMMiZNswqs7I
         sgLtJr+/lZ3SVTz+B27R0JmJxNKoutD0scwIk1bDeUhHeF2PU6jmAgL8Ts5y+F0aa2ZH
         XOh/YqgtlgKQBLUAP2Miyx0U3PwAMJhCFfPEnYqMMguwnpYwVsNNXrkgnYhMMyEcdgt0
         Me78rDAqroiUzsG97qQJ03EA4uS/SP+jIpdmxxJo3wYO9Ci32CW+BaBCCbq8ItxnOogB
         niyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731689637; x=1732294437;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YSEGn2aHARabFs7/DWQ9H+ZcokKqADHeSFNYQl1I4Ok=;
        b=WK7kgClVLsqqp1CEBoYkbZZRefBrCdUbLHxxaPa8/hhJqUR5bxsX/JJfYxSGX8Buwl
         k7xyFuRWtebuVBh0QNRNjUw+dCL0J8e99WE80yFTw7T43qUB3n5T0wMIfK7ja31w+Au0
         iGvRj+4etOMdNJglhxwJ4/Usc/HzcGGFxDpMk2dV8TmBCPeRXGUy4iip9fM2rym3fZW9
         gO257PA28Kl/IVU7NJdmarvxA1bIDwlfunDh0agD/1ZKNi2pA04LXabKW853fqU8AJJB
         cbJAvxG7Cu7CR0UBdTS0mimD4zsBWEetPbe8/1kAXYA4FBs32cusTVkHhIacvLoKi3rK
         1z4g==
X-Gm-Message-State: AOJu0Yzdj4qa5z/khf45g3ELfcCRVSFlzm2RFRFWMRpXOtdzgUhdaBw1
	lLE5UGA3vtzVrnyXcjHK+HSHi4taibCSGyVfq6zQTD1I3zwf2KgOrxWp/w==
X-Google-Smtp-Source: AGHT+IFuQ8EOsMT0jfouUXpLJDnyuGjRsbPGPrRujb5jgZnf9y1/vzO3sUhB7qmMAfNBEZ49XEHlXg==
X-Received: by 2002:a05:6000:4915:b0:374:c92e:f6b1 with SMTP id ffacd0b85a97d-38225a047bamr2620900f8f.23.1731689636409;
        Fri, 15 Nov 2024 08:53:56 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.132.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3821ae2f651sm5011895f8f.87.2024.11.15.08.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 08:53:56 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 0/6] regions, param pre-mapping and reg waits extension
Date: Fri, 15 Nov 2024 16:54:37 +0000
Message-ID: <cover.1731689588.git.asml.silence@gmail.com>
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
That will be useful in the future to implement a more flexible rings
creation, especially when we want to share same huge page / mapping.
Patch 6 uses it for registered wait arguments, and it can also be
used to optimise parameter passing for normal io_uring requests.

A dirty liburing branch with tests:

https://github.com/isilence/liburing/tree/io-uring-region-test

v3: fix page array memleak (Patch 4)

v2: cleaned up namings and commit messages
    moved all EXT_ARG_REG related bits Patch 5 -> 6
    added alignment checks (Patch 6)

Pavel Begunkov (6):
  io_uring: fortify io_pin_pages with a warning
  io_uring: disable ENTER_EXT_ARG_REG for IOPOLL
  io_uring: temporarily disable registered waits
  io_uring: introduce concept of memory regions
  io_uring: add memory region registration
  io_uring: restore back registered wait arguments

 include/linux/io_uring_types.h | 20 +++----
 include/uapi/linux/io_uring.h  | 28 +++++++++-
 io_uring/io_uring.c            | 27 +++++-----
 io_uring/memmap.c              | 69 ++++++++++++++++++++++++
 io_uring/memmap.h              | 14 +++++
 io_uring/register.c            | 97 ++++++++++++----------------------
 io_uring/register.h            |  1 -
 7 files changed, 166 insertions(+), 90 deletions(-)

-- 
2.46.0


