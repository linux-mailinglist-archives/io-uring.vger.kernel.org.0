Return-Path: <io-uring+bounces-10343-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E46D0C2E6F0
	for <lists+io-uring@lfdr.de>; Tue, 04 Nov 2025 00:41:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9218C4E9EAB
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 23:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78E282FF161;
	Mon,  3 Nov 2025 23:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="PQGiJoG+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C392FF64B
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 23:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762213279; cv=none; b=qEHFtX/xWNcse5YMwHlLISUjBNO+1Gb1ozrOUsEr+XPgbrvVVD4Gn5uFsN24+7mFtVfSsSjA58zPMcbcEpjb3fHGGedmuWbYQ4cMGMeDvutKsO0t8DO5ISyMYKsGeJxSsZIO6J8wTIDUNFdq98sVlYJKTbyWgPo6tuIGvHiRmxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762213279; c=relaxed/simple;
	bh=niVFS7QmiSCG/NJlK5W5oH5yPKgB2SutteL6X0KDEc8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Wk9jNwrzujZHCf3QttngIHjOKXdt0h7Bz8Lbn9HJqG9T/Rd8IlJ5FEkPjG6Y3scKKrf1r38HGR6DHKypNz4tS/vk4VJBDHnWP+CbYn51ORvfBs/pLr7f8jbdfQnxl52fR5yq+O2YYo9Q+2G3MQB1DDsll4k4MvRLEJBJRq/n5+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=PQGiJoG+; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-656b251d27cso18721eaf.2
        for <io-uring@vger.kernel.org>; Mon, 03 Nov 2025 15:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1762213277; x=1762818077; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QL+kI75TdSWf0pTZCj/ff+SufrpiVuwSWgVvYugxj94=;
        b=PQGiJoG+B31YCQ9bvoGT8oLsCm+wV/zQIMU5aEMiYhmIBMgpCXC/rt8cIaN7+h1W31
         qQQ8y3/LYElVX15JC2axMUkn+TnBPHfzvQbb8H3y7yMHa2yQHb9k3HE6YA3ABZYnEyAj
         h9q6Arub6n9vz93I4JK6M6gOpzJIB02xOnzv83bTgw3L31tgBiX/9CURfHn7YgcCtPIx
         /4CD0+qJwj5ZJ203YLY130SHc7f0ZxxLDIQt4ofjPrTQtkd61h5sFFNzc1pAn6RUTpoN
         DpXH6LQ1yQABLjP6VPl33EdcHmaJ6qyRIbKSDyEmF4Q1mSh5mo1gs4U7OdxkdukTfao0
         B9Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762213277; x=1762818077;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QL+kI75TdSWf0pTZCj/ff+SufrpiVuwSWgVvYugxj94=;
        b=A8LMGbzLp0xho8+AOSQCRjDMyr5QbJmk7MP1xwzjPd4BV8bZAZm1H/wquGkjbbieAp
         8ntHqFXC/CCH7Mej3k+8z+DgC0anHxCXcqSQyX6AvvLiaJM0m1jMDXIbbXlAKAXiK7qe
         RVkcP+0fuYdDTkGvqZf6b90e5vgVR62RAGdDUhTF43Tl5KorJQq3c9tkyGUUEde+p7yJ
         HMHs7XM6xvA56YounSCwvEcyVDeARdemrPxv3qBfbvfjPuF4dUINn4tzq5n04pO06QDg
         yfFo1DbNYXHEmuF6NYjdUL7mVbEaGhh6j5F6CjUmwfz15Pm3Qgm/01vircagXzrs8q0y
         kkXg==
X-Gm-Message-State: AOJu0YyzQCfbXjWMnlgJGiTnYUrEDajYpkN0goCw3K3agE9Jfoxae55i
	NdZhfSMBNO2dBvdQUPM0ypHKJwVjvX9Zfev9W2xBNTofeNJIFSUUzsv+LH8nMtxXzYAnAKWgzPQ
	rxEpw
X-Gm-Gg: ASbGncvhLhtli8qCelXxYilgf43zhaAo+9h14F4EVRBVdoIV21A6jVHb1ptMiI0xOUg
	usdxCgXpXIRQ0SpBitrNgT+XbgwWnW+/wITquDwsqlL7HbmYPP+ls5PEAQmLs5Pkak1Ze2QHxuf
	SuwsnwKCCLh3N9C6t1h4dqD4kvBPWjmLEg6VJsMf+xRnTegObhPISKZRgVDRagkdf8Zrx5C0zDs
	w/sKr9kNYHATfCW5ZLJbYRMtoM3V2+psnobRO9n+5s4VZcYYV7khfAKXY4bQsIRxEsgesTxsoin
	FnJF8sQVki3pmesG7P4J5eIGC2S6+lzatTSkug0+G+s3lfkPl3ogw+znxQFEI5eDXosnhZsc9e2
	nnCOTlESw0mTenzzQiFbrKc6kWf5NuNYGIHztd7EtCp+Uu+pYsSdf/qzA184+OUU/oqSdUCVbXp
	p6Vj9uCHReBVyPDDo9xD23B+EiQFYR
X-Google-Smtp-Source: AGHT+IGNlFnNKvYTN9nRNpdMRF8j8MQR5Zei8clCRqCEi6+1Whe/rCnpLclJ4JtFmgnfTxMnQ8KpYQ==
X-Received: by 2002:a05:6820:1749:b0:64e:611e:b7c4 with SMTP id 006d021491bc7-6568a3fd6ebmr5147843eaf.2.1762213276671;
        Mon, 03 Nov 2025 15:41:16 -0800 (PST)
Received: from localhost ([2a03:2880:12ff:7::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-656ad292d31sm468906eaf.8.2025.11.03.15.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 15:41:15 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v4 00/12] io_uring zcrx ifq sharing
Date: Mon,  3 Nov 2025 15:40:58 -0800
Message-ID: <20251103234110.127790-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Each ifq is bound to a HW RX queue with no way to share this across
multiple rings. It is possible that one ring will not be able to fully
saturate an entire HW RX queue due to userspace work. There are two ways
to handle more work:

  1. Move work to other threads, but have to pay context switch overhead
     and cold caches.
  2. Add more rings with ifqs, but HW RX queues are a limited resource.

This patchset add a way for multiple rings to share the same underlying
src ifq that is bound to a HW RX queue. Rings with shared ifqs can issue
io_recvzc on zero copy sockets, just like the src ring.

Userspace are expected to create rings in separate threads and not
processes, such that all rings share the same address space. This is
because the sharing and synchronisation of refill rings is purely done
in userspace with no kernel involvement e.g. dst rings do not mmap the
refill ring. Also, userspace must distribute zero copy sockets steered
into the same HW RX queue across rings sharing the ifq.

v5:
 - remove sync refill api
 - pp mp taking ref on ifq
 - add ifq export to file
 - implement sharing by importing ifq fd

v4:
 - lock rings in seq instead of both
 - drop export io_lock_two_rings()
 - break circular ref between ifq and ring ctx
 - remove io_shutdown_zcrx_ifqs()
 - copy reg struct to user before writing ifq to ctx->zcrx_ctxs

v3:
 - drop ifq->proxy
 - use dec_and_test to clean up ifq

v2:
 - split patch

David Wei (9):
  io_uring/memmap: remove unneeded io_ring_ctx arg
  io_uring/memmap: refactor io_free_region() to take user_struct param
  io_uring/rsrc: refactor io_{un}account_mem() to take {user,mm}_struct
    param
  io_uring/zcrx: add io_zcrx_ifq arg to io_zcrx_free_area()
  io_uring/zcrx: add user_struct and mm_struct to io_zcrx_ifq
  io_uring/zcrx: move io_unregister_zcrx_ifqs() down
  io_uring/zcrx: reverse ifq refcount
  io_uring/zcrx: move io_zcrx_scrub() and dependencies up
  io_uring/zcrx: share an ifq between rings

Pavel Begunkov (3):
  io_uring/zcrx: remove sync refill uapi
  io_uring/zcrx: introduce IORING_REGISTER_ZCRX_CTRL
  io_uring/zcrx: export zcrx via a file

 include/uapi/linux/io_uring.h |  25 ++-
 io_uring/io_uring.c           |  11 +-
 io_uring/kbuf.c               |   4 +-
 io_uring/memmap.c             |  20 +--
 io_uring/memmap.h             |   2 +-
 io_uring/register.c           |  10 +-
 io_uring/rsrc.c               |  26 +--
 io_uring/rsrc.h               |   6 +-
 io_uring/zcrx.c               | 319 +++++++++++++++++++++++++---------
 io_uring/zcrx.h               |  17 +-
 10 files changed, 297 insertions(+), 143 deletions(-)

-- 
2.47.3


