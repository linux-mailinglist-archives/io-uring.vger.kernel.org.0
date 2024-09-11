Return-Path: <io-uring+bounces-3152-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 26347975BBD
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 22:30:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C43EE1F23937
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 20:30:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E62E5143887;
	Wed, 11 Sep 2024 20:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="f8Z0+qtn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119967DA9C
	for <io-uring@vger.kernel.org>; Wed, 11 Sep 2024 20:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726086628; cv=none; b=HGADKVIHvPNa7yovLC0ymWybmEbXV40WNbX4/CclogymkZg2drfqrRi0W5LcFGrE1dmTET2tI+zFiKAxhAwjHwAA7c5AtQSIlbw7Ya7/TZMl6EkP6v2hvJTy7A9g2cpEioEY30v++MkkzTQgf+U/84aJOydUvqYEFc0dBYrNIWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726086628; c=relaxed/simple;
	bh=CtxWthPDMzYcn4DwBoVFxBgPnBhGQOvvL7gMXzgJmXk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=oun1SA1WCP4VDPMUX6EE7x7daKxGyXlSOl9tx2al4rnO0z9C2WOqMDpbspx2k6dplZQ3EW3/NT+J0gBiw4D7+0NV0aK11V17hfVdXvwa/CxhuMD251w6saWwgHayfVKCWsanL6sJGYNNbBZR2dgal5kapzXfVFYeWR1ATzchKyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=f8Z0+qtn; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-82aa7c3b3dbso10524239f.2
        for <io-uring@vger.kernel.org>; Wed, 11 Sep 2024 13:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726086624; x=1726691424; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=OkHhFOaTFyrM0yROpilfQezopjU/Aw8IlatgjrNRwCs=;
        b=f8Z0+qtndc2luBO2hSDweoNWZFm18MhELRysQATEOXgnmvJPeZB60lb4Puq3VtAbYv
         3MN8SuUFekCgJO9rzPkx0XNzQEGkO1Z194aZqbZfOXq4M+4m1tySw/C5cXLlNONBxFPZ
         pklASEeESwB4yj5V2AqWawSQNzBqTBvjOAqMGLwosPYkhe/zg9zdnEYm9AvMA74yhkN2
         QaNvMD6Ldqfr1GFiUysDBvp9uu09NpYs6MUJJivThjtgownF+cN7gdWysGKIkfpMFPxU
         AbjC0kNwl2bFzQwm3qHmtFobUGaamXgP0uF+B6d7McKrh4ws0pLzpZT8AVkk/YXO8CV+
         k0lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726086624; x=1726691424;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OkHhFOaTFyrM0yROpilfQezopjU/Aw8IlatgjrNRwCs=;
        b=MN78hcUc/EOc9JekZvo+QuDSui9JLkP8kcGHpkTCSOG8/XerzJEgrXNlZujk4EPIfO
         GJmkAGyvUR0484/YOx82qPak3oCQMRoG9PaFZyUZsGC+RBut53HC+dn3G065WRU0epsk
         zbtELaCHiJXv7se+qhe7cxxX46pnFYdzej6rb9WFnB0zlG8aPv54IT+U9UHEvlI/HzLH
         gsLSB8mdgB3KPDZ3Xloa3RDW6+1w+rHp6aQ/xzL2VkaZhrycmBC/HCtFOQIcGrWjyA9o
         Zuj51yUVbLmzViw48EJWLxeir7ZXwAQ7X9Veqj1Cqy0TvlgiWMwRaontfMq2cSEemhA6
         jZLQ==
X-Gm-Message-State: AOJu0YzewqWZR/i0DOghVaDenPvs5xfsqxFCg5qo43EAnmL+nHVLHKTx
	s2V8FfAXkvHfKyHHIc72JZM37pq05GeaP6XY02bLWGI2meIOyFJtFh9wc/HCyOp46W5ElpWhVUo
	x9eQ=
X-Google-Smtp-Source: AGHT+IE6KYDF2OfrvKbRORt7yEl+r6uf+wxg/IbQyOjgBt8ue0Tm43gqHruJyF1KKpwBhiIj6PD5Dg==
X-Received: by 2002:a05:6602:601b:b0:82c:edd4:f0a6 with SMTP id ca18e2360f4ac-82d1f984d79mr110346239f.12.1726086624219;
        Wed, 11 Sep 2024 13:30:24 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4d35f433d60sm185173173.26.2024.09.11.13.30.23
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2024 13:30:23 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET v2 0/3] Provide more efficient buffer registration
Date: Wed, 11 Sep 2024 14:29:38 -0600
Message-ID: <20240911203021.416244-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Pretty much what the subject line says, it's about 25k to 40k times
faster to provide a way to duplicate an existing rings buffer
registration than it is manually map/pin/register the buffers again
with a new ring.

Patch 1 is just a prep patch, patch 2 adds refs to struct
io_mapped_ubuf, and patch 3 finally adds the register opcode to allow
a ring to duplicate the registered mappings from one ring to another.

This came about from discussing overhead from the varnish cache
project for cases with more dynamic ring/thread creation.

Since v1:
- Actually send out the right version...

 include/uapi/linux/io_uring.h |  8 +++
 io_uring/register.c           |  6 +++
 io_uring/rsrc.c               | 95 ++++++++++++++++++++++++++++++++++-
 io_uring/rsrc.h               |  2 +
 4 files changed, 110 insertions(+), 1 deletion(-)

-- 
Jens Axboe


