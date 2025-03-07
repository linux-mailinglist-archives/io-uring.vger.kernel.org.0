Return-Path: <io-uring+bounces-6992-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 71C0FA56CE1
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 17:00:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D70211885F5F
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:00:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B925021E088;
	Fri,  7 Mar 2025 15:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mc+f7Wxl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5E72206B5
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 15:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741363187; cv=none; b=uqp4HIeXuO6WPmmvkKcDEpjQTN0KTcz/5EShOJAf7gfEpw9hvs/IY+v/3tzBi/tLGzPfY93GIq8t9rbgq3SHEe8pFEenPQWkVQSC5Ms+YJon7oDePIWLTjq8Bu6pU6951heAzcGBpADSnxhNDjiKgeFZw7H9W+q4XF66daStTJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741363187; c=relaxed/simple;
	bh=ti+/ysnGAwTETd0MO6rvP2MpOa5do/OMcL02rfdHIrA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Zsvezg5UvEUpzKs6+Uv14DUaplMKuC7RFc6j9lDzrexmgcrwsaHESLdY8B1mwC2egcrbHaWDyA72scQFB5PiFzL9M7wehiQ74z0gf6QcDdx8wtKp5ki04f7FVmtbnfCz+dPhvS/doYT5RIS1UV52o0bPNr2SRtpWJRMuZBdxApw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mc+f7Wxl; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ac25d2b2354so115844966b.1
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 07:59:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741363184; x=1741967984; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=akB8AL6KhxHNXzilpy5OJgLMVqZLqMJw1b6tfncu8R4=;
        b=mc+f7Wxlbmtk4//SpkUcCPIx17VZ2WTek7MCvcECQcnaLqlZcMNb0XBYAZr4TooM4j
         hwbNdVoh9tfYxEflN1/BwZo87LEKCutAU/Vk52Z3rGmZSnPgpAKkBzLjVX07QC4A/h2D
         XZywcCZqKpbcPFeJ9QRC0rARWDLoWPn8e70zgZwEuusxSo64kY84GlD5kg7GpojC0bxf
         3Z0iGQiywPsVErX091p1A5htYbqQp30BN0+zS8uG5eMY3FcqoxK7tf/cGzVnUls1392N
         zuqSJPUu8WhEAM8EUOkYr9w66LxK839Rx0qg7uD//DBa0GeHhJfxViB9mxj3VpinRhFh
         px5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741363184; x=1741967984;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=akB8AL6KhxHNXzilpy5OJgLMVqZLqMJw1b6tfncu8R4=;
        b=k7JRgxt7u139AqYP8MVAD8RAMIORjPsQW0cTFkxwD5lXxPcHecG58SOL/AunVM2je8
         GTX5XvTqWSYtGU1Ro2lEprjuCg2l7Hnne4NKroxm5yWMVxSR9yYWeCIDRhk41qkA0Ca6
         9InNoE0/0qlWklw3kexOybYig7e3dWK3pEOoDB0UwUSW7GnEkiv7KHcrhLm1+au5QGPu
         f1beGG19PPVcoDg5+AtYLZeVWVEJ/1Tgp6eWt9JLowWvfCxyo5skw1AhABB81HOgAgQE
         ldHEl96dzFwHYGq99bDnkMFApPShgGMsRTkT6wGl/74cPsjjXrnD5xOT7MU9TND4nrsc
         I/aA==
X-Gm-Message-State: AOJu0Yz1cQjrk2DgGgc8JxK9Ex/phnYNzk2+I8AUplIH+QCHlnqH9pp1
	8PLKdxC/UUWnnHRY5bHExNhwEBvn/saPxwE/pfdTtwwJBBN+aJl5DS+qLQ==
X-Gm-Gg: ASbGncuPZMBpFv3cFE/Zrmqg9RTHhsd8i7MblxMxGILa+k62e+IWGiyCvOKeMQB6QxA
	Z1H6TCjGYQZ47jfziNNIkvvys+c8V0EyYCPl8/zolj/5qj3wlz17hGritTjlu53r21SHp/v3dgH
	frrJ9fGBi3OBQFhUBdLyAXgk9uxM6mmUPXPeKJsXa3ZzhQKSiWrD2Invq1Rwg96m/uW3hJSI9XC
	N1oxhbQYtd2/cEiHQ6X9FXsw6SS20r5zEk+nSjxjsqG/8aO1mfAUP7xT+99UJe10IlXiHXZDx7l
	jPe9Vfytaa12coiYqcKaDwvmT9ty
X-Google-Smtp-Source: AGHT+IFIrDQKfslrE6AfvkW0l5iY+H6QVQpk4vu45jCtHr+c4bAOZnFK9a8NvCrTx2tupkx7Nmbchw==
X-Received: by 2002:a17:907:1c1f:b0:ac1:e00c:a566 with SMTP id a640c23a62f3a-ac252fa10ffmr513004466b.45.1741363183629;
        Fri, 07 Mar 2025 07:59:43 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:a068])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac2399d7a17sm297369166b.179.2025.03.07.07.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 07:59:42 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v4 0/9] Add support for vectored registered buffers
Date: Fri,  7 Mar 2025 16:00:28 +0000
Message-ID: <cover.1741362889.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add registered buffer support for vectored io_uring operations. That
allows to pass an iovec, all entries of which must belong to and
point into the same registered buffer specified by sqe->buf_index.

The series covers zerocopy sendmsg and reads / writes. Reads and
writes are implemented as new opcodes, while zerocopy sendmsg
reuses IORING_RECVSEND_FIXED_BUF for the user API.

Results are aligned to what one would expect from registered buffers:

t/io_uring + nullblk, single segment 16K:
  34 -> 46 GiB/s
examples/send-zerocopy.c default send size (64KB):
  82558 -> 123855 MB/s

The series is placed on top of 6.15 + zcrx + epoll.

v4: Address cast and include warnings
v3: Handle 32 bit where bvec is larger than iovec
v2: Nowarn alloc
    Cap bvec caching
    Check length overflow
    Reject 0 len segments
    Check op direction
    Other minor changes

Pavel Begunkov (9):
  io_uring: introduce struct iou_vec
  io_uring: add infra for importing vectored reg buffers
  io_uring/rw: implement vectored registered rw
  io_uring/rw: defer reg buf vec import
  io_uring/net: combine msghdr copy
  io_uring/net: pull vec alloc out of msghdr import
  io_uring/net: convert to struct iou_vec
  io_uring/net: implement vectored reg bufs for zctx
  io_uring: cap cached iovec/bvec size

 include/linux/io_uring_types.h |  11 ++
 include/uapi/linux/io_uring.h  |   2 +
 io_uring/alloc_cache.h         |   9 --
 io_uring/net.c                 | 180 +++++++++++++++++++++------------
 io_uring/net.h                 |   6 +-
 io_uring/opdef.c               |  39 +++++++
 io_uring/rsrc.c                | 137 +++++++++++++++++++++++++
 io_uring/rsrc.h                |  23 +++++
 io_uring/rw.c                  |  99 ++++++++++++++++--
 io_uring/rw.h                  |   6 +-
 10 files changed, 420 insertions(+), 92 deletions(-)

-- 
2.48.1


