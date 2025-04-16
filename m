Return-Path: <io-uring+bounces-7474-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00A31A8B494
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 11:00:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AED85A0149
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 09:00:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B474233716;
	Wed, 16 Apr 2025 09:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QpD4pfz9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C72B233D93
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 09:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744794014; cv=none; b=uDsWHenqrG9BlBT2OluYUJW2wQQmir3C5hIey+2aCgoGyiSz9zbQWVIGEv3JoyJp3XIcOQheW3WbeoRLGV37YKo57xBW9dTuJYhL02trppF0mFtmEv0xCLxjCaaKJadkFz2V0org9XP4BZRmRnCYnxt9uOIh6/6rL+Eqd93lHvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744794014; c=relaxed/simple;
	bh=ifL+0EWc4EmxI72XXyi71GwtDswqWRN087SHjE5BRDA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gfGuCt8Otj7Y1coDM/MAO/hpQNMyywr9nHRRAqWgibh0p28zeDxUHRIVgSr9bA3c4YdsWZedpenL2TmfSZ9cCoxx858MvtYWARmYCt7w9o0eyx0bMwbqhkWKcsSBduHM4SHK7i0VA+iUwazgg7tdGzjH4JqAOhOujU8QOJepNVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QpD4pfz9; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ac2ab99e16eso1323794666b.0
        for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 02:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744794010; x=1745398810; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=V2O46EIqpST/oT7aMl57Y9hV+chakAD/jNrllQE7IqI=;
        b=QpD4pfz9HckpAriieCJ4zxoPLoDu59DLiLRap76Efo97B5IuI88Vd40ake9fqa5Ojl
         B0F7Ti9fBivK4p7fOXfnyHVMbAasGkD/pjc5t9G80XJzle6G4BTpgOr4a2S28NKHbuat
         8D8QVbCUDTX0cniBIUnr3GOhRE3sbsjy+NpFjTQBgFeENBgIM1Gf2ENMRNXUqFDpPjcT
         lIfazZAZH0ZAx0TRtJw099ksfxPDhMPWJzRGMGHhLpDoqA++eLydVFiL/g5xes1XizWb
         4uc/o9+puKrHZcW6kuCeD6Z/7xRHLTSVxCwx8RLQ66eiUSDR/poJZtexEqn9YP9LDX6V
         h+Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744794010; x=1745398810;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V2O46EIqpST/oT7aMl57Y9hV+chakAD/jNrllQE7IqI=;
        b=lrnxT3ilvRXk/c3/3XGkm4Ax6ec7NoV+WmnIisrwwSS6IEi5j3k63tEp2xNnYLgbjw
         XKK152TzlsHx2xr5ykEAe06fy9pPEOZmz/upNtheyn0BX1lZIasN7w532WaWIQIRKjw8
         yVIN50VAHQV5kBSAjrxPebl5VUK4v7NIWU4eRbJ1IlwXDZBkhqxSX4nilhmNiUCV5yD7
         ff8AF75esC9BV7BriDOL25sJUxQPb1fMoDuzJqAnJjR8925F4dzQrf7tfyE+2qJT5RAQ
         JdzjJVeIIIm9Y6IQ6lsgcIbqXdqaqECuojPwHfM7VyVdhs9729IeCy4JVMt7Q0zRtHbW
         OciQ==
X-Gm-Message-State: AOJu0Yz6lgAAgD6HQGxAgB8N4kjXR9eSjxO8wyK67HpLhjCAy/W76UXl
	kN7jKY5j9ed9kPrqxZGMQRA/+emkzjlfhYM2CEYfdx0//uXhv3ZmnpRnQg==
X-Gm-Gg: ASbGncuOGKIu/yvBUfQn3MrNkvvCS1E7NyPOAsLsdG43uLChF0gA5QZQupdUtdGoahc
	7neTqV2A2T65IybZl6s4tHQdBwdhvFxdDn8iite3MUrU2aqlE15mA4bXSHyGtq8U3N89smlZnrZ
	2RqLFMkyJzsA5i+sgUGu4jVFX/b55MCgtE6v3gmTK0G8sK0DMRno7dnnURqr8ACxxN3ZLaTlwH6
	pKTLRDd4u86fAjC1uD6gf0claeADo3C2t//WINU9YfrOL+D1W67MpdSAOR/b6g5IviMm2bcPx7Q
	bv8X+4tdT/eHHKERI6cyUo/S
X-Google-Smtp-Source: AGHT+IFgh7qmDctsIDoMefxJ3Zr6NlohE87adRl2GZNRJD5GZcJhWOYVU8wbBTZQ+b5azGpPwxO25w==
X-Received: by 2002:a17:907:2d11:b0:aca:d6f2:31b with SMTP id a640c23a62f3a-acb42ca964amr74414466b.61.1744794009804;
        Wed, 16 Apr 2025 02:00:09 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:d39e])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f45bc75b4fsm3378097a12.18.2025.04.16.02.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 02:00:09 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH liburing 0/5] zcrx example and other changes
Date: Wed, 16 Apr 2025 10:01:12 +0100
Message-ID: <cover.1744793980.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We need a simple example for zcrx to show case how the api works
and how to use features. Patch 5 is a brushed up version of the
zcrx selftest.

Apart from that update headers and use the kernel return zcrx id.

Pavel Begunkov (5):
  Update io_uring.h for zcrx
  tests/zcrx: rename a test
  tests/zcrx: use returned right zcrx id
  examples: add extra helpers
  examples: add a zcrx example

 examples/Makefile               |   1 +
 examples/helpers.c              |  15 ++
 examples/helpers.h              |   6 +
 examples/zcrx.c                 | 335 ++++++++++++++++++++++++++++++++
 src/include/liburing/io_uring.h |   4 +-
 test/zcrx.c                     |  21 +-
 6 files changed, 372 insertions(+), 10 deletions(-)
 create mode 100644 examples/zcrx.c

-- 
2.48.1


