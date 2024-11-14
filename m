Return-Path: <io-uring+bounces-4697-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F93E9C9133
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 18:57:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E93B5B33A8B
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 17:38:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F7F417A583;
	Thu, 14 Nov 2024 17:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cm/TO0yn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898BA2AE8E
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 17:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731605888; cv=none; b=qnLodqm7nRLAH59Pw9Qb8SkFPKSHFimT176x0PFUMJnGeiVG60vJsog5WNDTWXpDznPDVA4Qg6AuubyG1gN/d1QMHDbe1C2KA7o/B0ZzJqd+/BLl6PSXF3Aez+Qrvf3S2nHTlCJsSSyEz3Ww3BXrv45cgGSY8N/G9Sx5b7KnKKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731605888; c=relaxed/simple;
	bh=U5QF/x6b8+AVnGXyhRLblaAIRQzMWVGP0691lgarnBI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IBOwo9wmuBUqRNq9uV8RMtKa+IQ5jQMGF+qHGC1RB+Z/As2g0mGcDfMDZPm6LfTUm/9qoQdAAWw2k+g3Ai/8ZEsHL3zQ47v+/m3SE+95Wuvtwkf1BrWvY25+yWFkbun2xdjZEQy7sCOXNJQ7jhplgYsAofS+GPjZdoeLlG92onk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cm/TO0yn; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a9ed7d8c86cso177262066b.2
        for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 09:38:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731605885; x=1732210685; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Z4ypbSiI4hdag8CKI3LLUTCpl2wpJ0QYfEe4bYMO1/o=;
        b=cm/TO0yngZw+8+Tw0JUImZVJtK//ZAjULEa/45qpXnVjjacEil7qnN42pD1Rq58JTH
         iFJy9ty0H3dw88Htl17OBZsjQ1gorcpefs8DyoBFPyqYHe1VvytY75wjwCjAyT7R4WJR
         pR41GVRb4m50HcrxzPNqdyRXiISfAgqC4Mg3uokWduTVkGgP0TaCz13HZ4NwucFCFcGH
         JGuOp30SZDv6ey1u15EVQMKBuhP12nrq4DgLRhI3KiNkvi9gkdAEYHKvxFsgZs6gDX/e
         0ETEU3DrV/h4zN/1+QpJjM8Fjw84A81lvrkVY+q3psGBsgv9vQqPIHrcKR8JNH0UvRjE
         xGMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731605885; x=1732210685;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z4ypbSiI4hdag8CKI3LLUTCpl2wpJ0QYfEe4bYMO1/o=;
        b=Wyhu6cIZ3SN5eQdC6IiuNYTOckWwYZ4oACnSTdIlXRuyh2hNmbBw61GSwsSdErgoSw
         zSsmeBoDg/CXsM5aTYG3z5IvkvYw6R3hcPe+SYv58Ka1r1JX0BhZZh2b0/snj7blPtsi
         PXLaOMPqgcKy0H+sIFyQztBtstiqwRoA1WMhvqm2F1iUE8La7YfkF1W8LUy7LyG1dxrz
         L63oiPs6r0sNsu2LaAPeggGY8NoIuQQojMeDu/8E+GFM4E0eeAeopE4ppu7MQsPZuToz
         igepolnN5IbBfN3rCDDwrG0AkkjlNdOaC+enF24MAQfzwWNssG8buDSYaZNpUHVDf40N
         Pyjw==
X-Gm-Message-State: AOJu0YxmTWJ9PgSUj83nh0siotIbabhg9VsKbnRVQU7LRL0MD8JOY9kn
	TLu/IZu67+ujZZBDJsN18E71uVzn+MBAfbn3+KecDMknDJKQI/xEbEhcLw==
X-Google-Smtp-Source: AGHT+IHyLsh9xUzWoUfqtyYp/VxR0k1fJiao9xrG4VMoMWvuTKAyzm1paxJXGzXFzp30YPMOuXLTBg==
X-Received: by 2002:a17:907:c2a:b0:a9e:c4df:e3c5 with SMTP id a640c23a62f3a-aa1f813b2fdmr725812366b.54.1731605884316;
        Thu, 14 Nov 2024 09:38:04 -0800 (PST)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20df56b31sm85799966b.72.2024.11.14.09.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 09:38:03 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 0/6] regions, param pre-mapping and reg waits extension
Date: Thu, 14 Nov 2024 17:38:30 +0000
Message-ID: <cover.1731604990.git.asml.silence@gmail.com>
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
 io_uring/memmap.c              | 67 +++++++++++++++++++++++
 io_uring/memmap.h              | 14 +++++
 io_uring/register.c            | 97 ++++++++++++----------------------
 io_uring/register.h            |  1 -
 7 files changed, 164 insertions(+), 90 deletions(-)

-- 
2.46.0


