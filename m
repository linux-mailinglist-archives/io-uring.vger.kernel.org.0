Return-Path: <io-uring+bounces-863-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 573B78765C9
	for <lists+io-uring@lfdr.de>; Fri,  8 Mar 2024 14:59:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D23991F224A2
	for <lists+io-uring@lfdr.de>; Fri,  8 Mar 2024 13:59:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E5654085D;
	Fri,  8 Mar 2024 13:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UJPo4Ees"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C163D3BBE1
	for <io-uring@vger.kernel.org>; Fri,  8 Mar 2024 13:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709906331; cv=none; b=u4K9gG4G0+FVyHzDOwylLXtZRvG2KccSliecv8WGDHzkL8M+1M72uWBGV7WcRDIcpmZZgDDdtNVIfbaCr/YJRXzh8m8MnS6QsTp53OtYFfnLJ9RKndykmaqK7lgt0y5afwyyCuQ9e25dDuE//27rtXt5fBewMcgtnsJP8yrJlcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709906331; c=relaxed/simple;
	bh=Hnz0TJ47YCih85UzBCKVeP88j5Fwcvo6GsgDkr73Pb4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Rb5lN9oDg1b0tv3v4HgpsIc8+cyvs6MveY/lTlGQBB2iaKvgNhjAA+rsCKy8rvwn/CmAy44hUzD21Sf57ew8mAKJslenjkZz7XXejVSZ01CJzh/rMvnXBSXSqskaSnprpRND5PpDlRUVhME56ef/dhytj9kur04rJWHVv8NCdY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UJPo4Ees; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a44e3176120so292477166b.1
        for <io-uring@vger.kernel.org>; Fri, 08 Mar 2024 05:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709906327; x=1710511127; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CimPf3ZCTzVYkkHpSBGyvqc1qEcFUzAZkzvO4weaNJY=;
        b=UJPo4EesBRckZqclalPHSXApLmP+WdB0SKGoaZ95qdbbB5HGjcNHddfGK1gjqekNr7
         iDK36+Wy/kW2QQ5R2RG8GNmsCs9+f3thlrRtrOu6duq5SoV+OZwndh2Mo0wvE7Gm5MOb
         3g93RjL7L6jB8VdEd9Qa3BUKl/sw7X8m3zgCHQDcRaSbN2dFg0yDDuVb9WVhZl0PI5nJ
         29MwcCZlJp6r8D13sNCp7yIand/V+gEh/imUQUgxiZ+hB5MlxT5DRr6bPyGRiLOtUwMJ
         i9p859qAkRl1VKIP7V7j6P0lpC+Pmz/fqyZZmAwbM4YnkHGRy6HWbViSYEloNXu6baIc
         iGTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709906327; x=1710511127;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CimPf3ZCTzVYkkHpSBGyvqc1qEcFUzAZkzvO4weaNJY=;
        b=ZghZfPXlvA9ywPR5UM4Ra/5oLE+BkNLUvdhqDup8GkZpCjvYz+eM76Wp8cyMqA4Edf
         pNgrJabJ1bJqXjvvocr09RXM24jN+IsySobp9d3aHEeyLJnBXw1mrH8Fbx7bAIzOtyUV
         fJwXe4aJvDouH8Q459p6xPq81G+qCmP0A9oqmy7foILtX+ZWcMWNM2m4yAVlNmMtKZ+r
         W7k8anpcneyYRrsSA5WU8oE7xGJ0NXzmK/oUp9grMq6Z8u8qrq2Iv0xZxdRyCohVgBb4
         eo6uQ/n32bdv8O4kVXkGKDLqrmbaFKotU0CqxkBpcNhHiHGIz0XSJ6rHG1LSf6j/Ydmu
         h7Og==
X-Gm-Message-State: AOJu0YxUgcB0cRFLokAbA/OyXFlM3pUnB6JTh8RtDltrkQQmc1tFIIaX
	kXWRGGc36wNqCNNgLD8Tnil/tlTF3CzQnLj3uXW1dhkKxkY2ML70ks3SLGSZcYA=
X-Google-Smtp-Source: AGHT+IFTzAHeZmTtV4NQ7ChTJQfV4bXMIZxJ/c7aH/0NqLInQis6IC27JIGCIdbCbCV0Z+ixb0S/lA==
X-Received: by 2002:a17:906:f819:b0:a45:d17f:e22f with SMTP id kh25-20020a170906f81900b00a45d17fe22fmr3382247ejb.61.1709906327365;
        Fri, 08 Mar 2024 05:58:47 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:d306])
        by smtp.gmail.com with ESMTPSA id p16-20020a170906229000b00a442979e5e5sm9303189eja.220.2024.03.08.05.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Mar 2024 05:58:47 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 0/3] net mshot fixes and improvements
Date: Fri,  8 Mar 2024 13:55:55 +0000
Message-ID: <cover.1709905727.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The first patch fixes multishot interaction with io-wq for net
opcodes, followed by a couple of clean ups.

Pavel Begunkov (3):
  io_uring: fix mshot io-wq checks
  io_uring: refactor DEFER_TASKRUN multishot checks
  io_uring/net: dedup io_recv_finish req completion

 io_uring/io_uring.c | 20 ++++++++++++++++++++
 io_uring/net.c      | 37 ++++---------------------------------
 io_uring/rw.c       |  2 --
 3 files changed, 24 insertions(+), 35 deletions(-)

-- 
2.43.0


