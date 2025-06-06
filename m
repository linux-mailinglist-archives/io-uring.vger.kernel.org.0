Return-Path: <io-uring+bounces-8247-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FC9FAD0395
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 15:56:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 046B23A81B2
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 13:56:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B133F28936B;
	Fri,  6 Jun 2025 13:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i43mJHS8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE851E377F;
	Fri,  6 Jun 2025 13:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749218207; cv=none; b=MY0I7upovlyUI2EqZ2JwIOvyI28fvBrrAmlEnTvz1k8OLh+BVSrNyLv5dzF1ha6Vy06MTit1o0D5cQ9f6EzqH9KL+H9AdjdDS9U6jddVNim/KPoZa9qTyKdA9PX1OWJlm3OjAYxDi4QJSiv9eobSu0VwsVhQ9CPDX+1osWup4u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749218207; c=relaxed/simple;
	bh=f2qlTQ2FKcMWo5g25PTPNlS6DP8xIrL2O5cw4mtYuA0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ixHvZy3rFRcySrT1RyEc+6eLIhEphpdvNdZHzTCtnRZVFO+XKaVng476WdYcPDv6bAzJQhkrilqDcVe5UL1JiAFwrH3G2jaI6joLAYMLSAKrCv/02u7YwNnXBkqh+5GyyCOU4JpkbO4/b9eIe7+WkIo/6pn6es19h79mCmb4ZAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i43mJHS8; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-601f278369bso4249416a12.1;
        Fri, 06 Jun 2025 06:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749218203; x=1749823003; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ai/BqRXBDTuvUKyO814cjzx4npUVyisZt8TkZV4iMuQ=;
        b=i43mJHS85hvro1WnWzxjR5OnFub9mKX0F0jADbtE67c6LUbEio7KzO19n7XzYy6esu
         2Hj86s1kQxFUDycJovtiAd7p13Rk3rUA5zicyhI73fCEcx4CUmtjzGR7XgxFZwYB9j4j
         5uMprdp3lBd3fYp/G2A6SMzwpiM7QjMuyGiLKoWrq5/GFPXkxxzaUtgz/9nn0poHqnQV
         dttk2xcx2+rqIx670cUdk5Y9z5aIrWKaWYoOhPsvV4OjgpvMz1r52g0ol1Pv10NxYWlA
         tZfsv0c1W7xCQtnt9Ij4/ruGHJdCaztmA4+ujmFMOoxGpP1AHShOGRbcuvxdPLicUD9B
         UWdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749218203; x=1749823003;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ai/BqRXBDTuvUKyO814cjzx4npUVyisZt8TkZV4iMuQ=;
        b=vK8ATqGYypZrS9BxzJ7BhsNbhAKEvsrD+7y/Ii4x4nB1jXdAQrcpWUl8eEEx/6M6wx
         8WQj/X1aEOUWluBcOYWe0/OuphuKOweAGdqskiYXVi2uwdJTSNDx9CPz6LJdfs4qAWO5
         lmwSd+io5HelBxsCsv7B/Mk5ifhx3aMbWL4BmeKm25sNCQYpdv0WTCjr7wNQdOpiP8KL
         jhg+e2uIJ8HzchHzgRdubtkapDRXfeN//hToRS0v0oPql36ydwM91tkE3ZOEXyGYwGhR
         Rt8tuO1Y/EMbr2KSsTkprGCJlQsOzsRQ7Gn9o/8SkO5+gdZkztmq/vXLUZ4ACWHE35Au
         Ptdw==
X-Forwarded-Encrypted: i=1; AJvYcCUj2OHfToO3MFWj89505bqKBS0Ci9DNiRyX9iWCx735cKx43gAiR0LPPn/QwfByzG3l6TA=@vger.kernel.org, AJvYcCW/BHGDj4I6WsinojuRg2GqrUilIqhhiL/FkMMMEpnkJhpTB9PIh/dn74h2H1Y69zMjN+5cshYDhv+DV6P0@vger.kernel.org
X-Gm-Message-State: AOJu0Yzd/5A7+gNmfcF/wOLbeIviZ5CXYN7uqG8JPWnHq7DYD/3Yqwjs
	+YwmpiDCIlzY9/7vdVNScXVnL56MEdokrjILjxgNJVfIBR1BfdyygTM18H+00g==
X-Gm-Gg: ASbGncuXLWbHsnft7Tlplff1XPFrh4elfV7ZEg/AjCRtMWiJGasYKNGu9+CcT0+BwFq
	s9G/Tg+ZEr7531CrvzJuqJ+0kf01P04e/+cOVpCgBABePVUsonaxlMuFp7WJknnlq1fsTrUn4H7
	WgJLRZhjrpGxyTWJWIuM4kPAwzRp130WdgsyRq39jb25yqBNagIz9zPo86n5JyzwFlw475difz1
	+Xog9RhBb/I2UlTF/yIHjAP4TI+AvKHPDRd6bwyAvblwwoLhVKKhcINXmT8a/FyQcqiJcOWQc7A
	WE1oI1ltBWyvgFkI0i6Ft2LzI3Cnr0/cm26arNEvd5p25g==
X-Google-Smtp-Source: AGHT+IEhR63MMEj7DNFl5prD+jv7i2jhBn6t3pwmamGFRcTbrgyqh3gprpxwZbwhCaImZoVIhyRu2A==
X-Received: by 2002:a17:907:1c07:b0:ad8:a115:d554 with SMTP id a640c23a62f3a-ade1ab5ec36mr270844966b.56.1749218203265;
        Fri, 06 Jun 2025 06:56:43 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ade1dc379f6sm118026766b.110.2025.06.06.06.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jun 2025 06:56:42 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Martin KaFai Lau <martin.lau@linux.dev>,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC v2 0/5] BPF controlled io_uring
Date: Fri,  6 Jun 2025 14:57:57 +0100
Message-ID: <cover.1749214572.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds io_uring BPF struct_ops, which allows processing
events and submitting requests from BPF without returning to user.
There is only one callback for now, it's called from the io_uring
CQ waiting loop when there is an event to be processed. It also
has access to waiting parameters like batching and timeouts.

It's tested with a program that queues a nop request, waits for
its completion and then queues another request, repeating it N
times. The baseline to compare with is traditional io_uring
application doing same without BPF and using 2 requests links,
with the same total number of requests.

# ./link 0 100000000
type 2-LINK, requests to run 100000000
sec 20, total (ms) 20374
# ./link 1 100000000
type BPF, requests to run 100000000
sec 13, total (ms) 13700

The BPF version works ~50% faster on a mitigated kernel, while it's
not even a completely fair comparison as links are restrictive and
can't always be used. Without links the speedup reaches ~80%.

This allows arbitrary relations between requests including using
a result from one request to configure the following one. There are
other use cases in mind that need access to in-kernel resources and
can't be implemented from userspace. On top, it can be extended with
more callbacks to get finer control over task work batching.

It's a prototype, I intend to remake the kfunc helpers, enchance
program verification, and fix some mild io_uring waiting edge
cases.

Kernel branch:
https://github.com/isilence/linux/tree/io-uring-bpf/v2
git https://github.com/isilence/linux.git io-uring-bpf/v2

Liburing + bpf bootsrap examples:
https://github.com/isilence/liburing/tree/bpf-struct-ops-examples
git git@github.com:isilence/liburing.git bpf-struct-ops-examples

Pavel Begunkov (5):
  io_uring: add struct for state controlling cqwait
  io_uring/bpf: add stubs for bpf struct_ops
  io_uring/bpf: implement struct_ops registration
  io_uring/bpf: add handle events callback
  io_uring/bpf: add basic kfunc helpers

 include/linux/io_uring_types.h |   4 +
 io_uring/Kconfig               |   5 +
 io_uring/Makefile              |   1 +
 io_uring/bpf.c                 | 277 +++++++++++++++++++++++++++++++++
 io_uring/bpf.h                 |  45 ++++++
 io_uring/io_uring.c            |  45 ++++--
 io_uring/io_uring.h            |  11 +-
 io_uring/napi.c                |   4 +-
 8 files changed, 376 insertions(+), 16 deletions(-)
 create mode 100644 io_uring/bpf.c
 create mode 100644 io_uring/bpf.h

-- 
2.49.0


