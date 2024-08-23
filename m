Return-Path: <io-uring+bounces-2919-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D338395D06F
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 16:52:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 86FC3B2257C
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 14:51:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B48631DA4C;
	Fri, 23 Aug 2024 14:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FzWIHjXF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79BC18859A
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 14:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724424702; cv=none; b=E+CKRmTIabd0Yj1rF82XcGpSOGEkl24jQVv4N9vvPImahYn7smYFgeOukClI7ZmMH9T3chXtxa0xKezOEFjsHeKlFILBNhDKnKxgpAQ2eOEMzh1EvEMun7JcGiuerRmM0vTqo6k3nvFv1QcGV/01cavmb8/31M4qDBgLaZaTMqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724424702; c=relaxed/simple;
	bh=n9BezzD54TesPPklxF/Vw92UMJziSpWVuSX8RKWlImw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=YfNEcY/7EzvPsfRAYGvIsGuwBZDYU3w+kaIk0hFiEawcPyEjxTcNum7ax/MOxEgMrSJTpqy63esnIwwjwas0WQAFO7XKEUJN4y7C+IUh5HaThvIieSCDeTsLJYLuWYpePbDrifqPSEvylly+SzATJFBDfrF/dMNfhIVOUP8/d30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FzWIHjXF; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-824d911b6c4so73577439f.2
        for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 07:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724424697; x=1725029497; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=5nljI1eBOUKo4gDHyath10Y+vs6nO0t+lXf9DJVr9Pg=;
        b=FzWIHjXFJ/wiXhfMgOv8LVCZxLzvMKX6tDTMN+3aXTXdgm4UKNaq8oJMz9rZGhyKEX
         WVS3oz4H7j+znNg/38IZeFrZikdo4NkYPdfZVK9c+3g+g8jukTmqExkCRZMYjBZHT/FN
         TZysFdbJaMUPkRYoi/RDNCw9vSWmtK5fcZLxzhdPZwq+obBEEAi+EtW5ErLu4RwtqdiK
         BjNqhzRHxrdI+U6tZJ8zd+gGz4RMLjPURsoML1p+heWCv7ZPzYukNrTcPDsaeMSg9FGx
         QZe2HCujhQ79QCy/sGJic6akHFLqjC6uk4QdYPuZJyvD+JmUwg4NiLVBJSJ2jTa4z2uI
         G7yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724424697; x=1725029497;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5nljI1eBOUKo4gDHyath10Y+vs6nO0t+lXf9DJVr9Pg=;
        b=d6I0Y7s+T3CxXOhuHiKRiDkFPA52VZ6xrwZ0u+S8ZaA9JZF70980a8lxXKZlY8S3mU
         tId2iip6xuhjs6MN+zrnVR3S5uVQ8cIwgcQfmGv6Y8ohxEZ8SSKO6dajy14WLL69NGEZ
         yxC7hz112L8w6NEbi0agNKVnNoCSJ7xvRyBV0EIRK5cQsJUVY/hGbb0NV2Dwk4K99Yew
         ZpZmzP0Jf6ZqWoaWY37SUfcXihJ4TNih/vE/r6YaUmQCE6CwYC50ijkUNEPYwKUPBn/s
         ncWvd5HYh1hIUs7Mzd7CmCaEXb2fSng9XruqzLeL/iLJukWlmmgWtAENc+CDiJFb+Bws
         tayA==
X-Gm-Message-State: AOJu0YwLSzSRpSP6LOcWCpOKTgGG9Z2Dj6r82051Oy/7o6u86Bp6A36A
	qbXJT3+LQ/mWAhT/aEY3IsLvIRAommoy8flb4yZbJFB8WN4deNG71fvO2ALZ16ltUxeFMTWd/Kr
	N
X-Google-Smtp-Source: AGHT+IFt1CPnSrIgluB3PpzGurGD9zJmAuXe8RZwZ0iAcA7nn2iCUTZV6TLaTqCR0wrFEaEqT5wr9Q==
X-Received: by 2002:a05:6602:340e:b0:81f:9328:9631 with SMTP id ca18e2360f4ac-827880fd1a4mr265580839f.2.1724424697016;
        Fri, 23 Aug 2024 07:51:37 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8253d5aa137sm115039939f.11.2024.08.23.07.51.36
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2024 07:51:36 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET v2 RFC 0/4] Add support for incremental buffer consumption
Date: Fri, 23 Aug 2024 08:42:33 -0600
Message-ID: <20240823145104.20600-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The recommended way to use io_uring for networking workloads is to use
ring provided buffers. The application sets up a ring (or several) for
buffers, and puts buffers for receiving data into them. When a recv
completes, the completion contains information on which buffer data was
received into. You can even use bundles with receive, and receive data
into multiple buffers at the same time.

This all works fine, but has some limitations in that a buffer is always
fully consumed. This patchset adds support for partial consumption of
a buffer. This, in turn, allows an application to supply fewer buffers
for receives, but of a much larger size. For example, rather than add
a ton of 1500b buffers for receiving data, the application can just add
one large buffer. Whenever data is received, only the current head part
of the buffer is consumed and used. This leads to less iteration of
buffers, and also eliminates any potential wasteage of memory if some
of the receives only partially fill a provided buffer.

Patchset is lightly tested, passes current tests and also the new test
cases I wrote for it. The liburing 'pbuf-ring-inc' branch has extra
tests and support for this, as well as having examples/proxy support
incrementally consumed buffers.

Using incrementally consumed buffers from an application point of view
is fairly trivial. Just pass the flag IOU_PBUF_RING_INC to
io_uring_setup_buf_ring(), and this marks this buffer group ID as being
incrementally consumed. Outside of that, the application just needs to
keep track of where the current read/recv point is at. See patch 4
for details. Non-incremental buffer completions are always final, in
that any completion will pass back a buffer to the application. For
incrementally consumed buffers, this isn't always the case, as the
kernel may generate more completions for a given buffer ID, if there's
more room left in it. There's a new CQE flag for that,
IORING_CQE_F_BUF_MORE. If set, the application should expect more
completions for this buffer ID.

Patch 1+2 are just basic prep patches, patch 3 reverts not being able to
set sqe->len for provide buffers for send. With incrementally consumed
buffers, controlling len is important as otherwise it would be very easy
to flood the outgoing socket buffer. patch 4 is the meat of it. But
still pretty darn simple. Note that this feature ONLY works with ring
provide buffers, not with legacy/classic provided buffers. Code can also
be found here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-pbuf-partial

and it's based on current -git with the pending 6.12 io_uring patches
pulled in first.

Comments/reviews welcome! I'll add support for this to examples/proxy
in the liburing repo, and can provide some performance results post
that.

 include/uapi/linux/io_uring.h | 18 +++++++++
 io_uring/io_uring.c           |  2 +-
 io_uring/kbuf.c               | 33 +++++++++--------
 io_uring/kbuf.h               | 70 +++++++++++++++++++++++++++--------
 io_uring/net.c                | 12 +++---
 io_uring/rw.c                 |  8 ++--
 6 files changed, 100 insertions(+), 43 deletions(-)

Changes since v1:
- Add IORING_CQE_F_BUF_MORE flag. I originally intended buf->len to be
  used for this purpose, with a len of 0 left obviously means that the
  buffer is done. However, this doesn't work so well. For example, if
  the incremental buffer size is 64K, and a multishot receive first gets
  16K and then 48K. For the first completion, we decrement buf->len, and
  it's now 48K. However, we immediately process another recv for this
  request, which is 48K. Now buf->len is zero. However, the application
  gets both of these completions before seeing buf, hence it will see
  buf->len == 0 for both of these completions. Adding the BUF_MORE flag
  allows the kernel to set it for the completion that actually finished
  the buffer.
- Fix issue with send side not getting REQ_F_BUFFERS_COMMIT set, hence
  always committing early. This doesn't work for IOBL_INC.
- Allow sqe->len to be set for send + provided buffers. See note above.
- Minor cleanups.
- Move to separate barnch.
- Rebase on top of current tree(s).

-- 
Jens Axboe


