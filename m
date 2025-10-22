Return-Path: <io-uring+bounces-10140-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B946BFE25C
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 22:23:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A27D1A08303
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 20:24:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 192512FAC16;
	Wed, 22 Oct 2025 20:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JeeiKJZ7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D2B26F46C
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 20:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761164594; cv=none; b=MNtaqTv43qlDq79T0FqffdvmMEVjaiR7KAixqDmAYncXdV9to6coe6s+G6pBj2vn2iPNbn0XHAEx8gOatG16chVbk4GEQyZ+YpTA5KWFkb8kU1khs0NucsnGwhvL14NciMW+5ME3deTZ2mc2pgbAaL/L15wgu6NmxPcEfumE7yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761164594; c=relaxed/simple;
	bh=cp5ty5nbE5cmwdf7e+GOM7vNP/yCBdewq52VexwfjUE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sejOI86Krl/2fs+iE4ogdwXkRin35h+s6FZp8aVxNn0SntSUBkvdwvXzAMVPXgeFseUZGQLmt1wNqrRkjHEsR/5K0ZIspenlnCUJhFe0lVSx07aeSIBN7Q7nTNdv0+85JXPX9rFTPY8dK5r4ywUZYIb7Kv6C3Um/HG0CYR8ZbQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JeeiKJZ7; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7835321bc98so39401b3a.2
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 13:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761164588; x=1761769388; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=owh6411Khvjod0u0PmuG4C6qfWHhdBSTnJs4puqC3Kg=;
        b=JeeiKJZ7KlHyBHQ9E0rl6br2ZF0p1Ii2ouAGhMjJm6NK+dNTZQsRt5UIfeosCbbxFa
         ZFJYNRjwlHbu0JrK1pN6Q51k2LTge0/rYJwku/s5Cf39QQEBAdnO0Q7Pian1YIDZwqUJ
         L/kcVPiymblXP4LithiKaE/RAFQ3qV8/4zE35vKIcH6uAWpfgyQcrYsLlxS2LhHR6468
         4fdeRmGvF91YmpKY3JLO+u+nXfsK8vUIg8Aifeqgn4PfPloTg3xJhDi/4pBVcPdUgSbP
         me49fg7GxaKmrG4vGXtLPfYUhSbYULnMEwWkRn1IUPUNqmKvmTWn2JFMpV5ZnsMPMaF5
         hdLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761164588; x=1761769388;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=owh6411Khvjod0u0PmuG4C6qfWHhdBSTnJs4puqC3Kg=;
        b=AEU5na/OmE24JmNsd2t1+UQpPncdbEe1ZN4JXvDRxWu8FGVr9z1xXGU35R18E4MHwo
         5uy62ClB38S51kRIrBidYTU7tO4zoDzYx8cQ/1PA/07/D8UiFCF0yLoAj9V/cX5jV51X
         UXRum9ILRQC6UDZTLxKth59LC2br3xHki2rrq//JhInkakrasmHVv3upLo0daUyCC1eI
         uUktavxu44qf+oM3orDzqevNptun1hCZwL5xTsItdaKaQd/HQmyF/qCzcIx3ks3qtSEN
         sQNi4Vy1Vj1eTPMUAEBobbU9+P6KbUJKut7vVCWbuM1lLYptoTjILB/Eb34wEqLzWr04
         VKEg==
X-Forwarded-Encrypted: i=1; AJvYcCVQdCdqPGGRzI0PuptN/rsYgoVCgGqO1FTi+B2wjfJgugeJg+FNILRYTfjaNgMKbwuvlQNlN+b4ag==@vger.kernel.org
X-Gm-Message-State: AOJu0YwasUNmqdXeRchFai53nHgcylSze2Miwthk2++Ozju9Tg1Ww0J7
	NO2iuWfyyt9Qb1n19/6SpfH9kZh17pUtb3H6c+vLpRmWGQSGyCdLP+tp
X-Gm-Gg: ASbGncvJ1aCuBEtddrn29kELyeNHhN6hTvuvbh0ftGR4gPAP+ZOXeYegtm3jyGaN8Jr
	jBjPKiO669FO2HMWt1oJJRBsvX7EXhYlEyktnyi3R8Y5lubEllrv5TlPI7e9TjH7tH9l4qkU8rm
	oGrKc5w00rLZrF0rGZCYlpmgqL64CjT1UcU1wIQg3lkhny2cavg/lgfpOlIodddBX7VSMsH9Pgu
	C8kSrNBvTfdU7aw62B3h+KwOSFPp5Vjy2erGK5uwvDuGTBbHGXGGLBidRdP7ClIrtqqd2Ub61oT
	RLtTv6IURC8hPr7FZXA+zY0IDJLi6/l1CmdF9dD/PC2TO0O1d2O3+ClufZF7vHYAOeLzcKb9lra
	TMkotNxEqLiaU45DTIIcRxDuYm96QoXXG5Eq9Z5QhGm9mmH/eyzlWKXxIpmGQORiA6+f234w6mw
	6AYVMkmMQvXdqTzlpQhiMzEMGKOwP27AmqBhupQQ==
X-Google-Smtp-Source: AGHT+IGuB/VB6sKdsdIJLryUCnbDbDEr5ucYqlOAO+Rxg4lhkaXlPLYt7lOInmpiv3ym/DzPYwaUVA==
X-Received: by 2002:a05:6a21:6d94:b0:249:3006:7567 with SMTP id adf61e73a8af0-334a8607433mr30211682637.35.1761164587609;
        Wed, 22 Oct 2025 13:23:07 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:40::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a274b8b82dsm99075b3a.50.2025.10.22.13.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 13:23:07 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: linux-fsdevel@vger.kernel.org,
	bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	xiaobing.li@samsung.com
Subject: [PATCH v1 0/2] fuse io_uring: support registered buffers
Date: Wed, 22 Oct 2025 13:20:19 -0700
Message-ID: <20251022202021.3649586-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds support for daemons who preregister buffers to minimize the overhead
of pinning/unpinning user pages and translating virtual addresses. Registered
buffers pay the cost once during registration then reuse the pre-pinned pages,
which helps reduce the per-op overhead.

This is on top of commit 211ddde0823f in the iouring tree.

Joanne Koong (2):
  io-uring: add io_uring_cmd_get_buffer_info()
  fuse: support io-uring registered buffers

 fs/fuse/dev_uring.c          | 216 ++++++++++++++++++++++++++++++++---
 fs/fuse/dev_uring_i.h        |  17 ++-
 include/linux/io_uring/cmd.h |   2 +
 io_uring/rsrc.c              |  21 ++++
 4 files changed, 236 insertions(+), 20 deletions(-)

-- 
2.47.3


