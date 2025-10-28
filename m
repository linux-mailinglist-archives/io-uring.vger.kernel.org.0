Return-Path: <io-uring+bounces-10266-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 05A56C164FC
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 18:52:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0C964043B5
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 17:46:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F1082853F8;
	Tue, 28 Oct 2025 17:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="MfIJ5fEW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7110A34CFB9
	for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 17:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761673604; cv=none; b=bAqfbW/oAtZKgdp0EuYJvbQoZFBHPVG4BeLa6nIOqXe55Q6Unrb6LOd+gB59gNwxQLRV5XAAnzBdjLV+YJxpFTyu4XDnMDVs3skkLuvNZ/7U2gHlqe9d7+DJk9NG37GslzqUBQsL0x1EFm9/2m2lXK+M7OvRi4w/s6KirwOUFxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761673604; c=relaxed/simple;
	bh=V1fR79vInIGBpuvSpGpDL2OEYifZYBP3nTnFa8Y0KQM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fAoyVaaVKWZvn3ayrhmMAK3rFFnMnCfg0K5Cfho/8QVyRfnQOIj6i+w4NZhJy+THSRDLpwk0WpxK9SkMryFBJc9EwH897ZxUbTGd14DBS5UeWOWrvd3n5MkU0Z5ONOsKX/K018cJZRBYIw5yxOfd1WPzWHE1/J2V6Ha2LwOCOZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=MfIJ5fEW; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-44f783add60so212097b6e.2
        for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 10:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1761673601; x=1762278401; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MevMVlrLfyU/NRV+2DywzpiJ+/LGIhcHIxG4WKNoNb0=;
        b=MfIJ5fEWhY0j8g8amWPzAIjCgAxCU5JMDDInq9SAgeYRcFmz0mHpnRkJmsaVj8MbU8
         Sr6bsqp1s4X1vJQQUZS1frelSdn3SU/Y7SOU5UalcjWxc0DcNBWo/DcBoXZ632Kem8U9
         gQcbFfCwWB9hFcJ2xktQ7bC7WmCUFqpLC89ZBJM/GZG0REwZQ3Q7++Sjxdn2zV+EqXcL
         XjIVi0dD4zBcnxxjHNBnZ+88d70sN/sN/yUG+yTG978xD1c5srnhZRVaJ+ErJcitCPO4
         /Go8VSiR0BU/k1e7V5wLwShiv7R6WD4TjeAor5GIn1m61U2q1u+y7MhfWmIxUTcJj7iN
         51Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761673601; x=1762278401;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MevMVlrLfyU/NRV+2DywzpiJ+/LGIhcHIxG4WKNoNb0=;
        b=g+ryDBOLw4xaaipVYrrxerto+aOc5ZGMMJswe19RRRnAPUk7zXamChtdJuI0cK9LMt
         lOEfjXlpyko8OcuSH6r7RTwvHVs8oA+0mlQRNhmiW9uyjsqz5FWcAkRHOiQP3v5LLf0W
         ZWySg1ppfWn6XrTJ0SDyYmRxpGiZMi6jgX4FHa7fmyKM3QM9AEYVdUBGTP5TKevbly+1
         fJF68mlERxrabQyxeLXKiQ79jGx45w5QoHps5PYGSK7NLJcNWJ8FmXYEweB/bkH5WEyL
         jh3ezGK/72/cCJG9B2ZNFv08QO/JkzbtgpE+D2cFzUjiSOjAex/nxIQCmghz8BD8AblX
         CSNw==
X-Gm-Message-State: AOJu0YyIHsYL2MVXA6kx4vnde69cG/pQr8sG6JHf5sn15h8z67wpsp3q
	Xai1kvzM6ENR3AHJVr/hsyUyramFpzwe8vi/WOWaWR7HMVW9jEWQbp0rvQcdVR35Y/E5oAwzs6w
	uwFXd
X-Gm-Gg: ASbGncsUmIuLwJCkQBatsk13aH37uNlyA+qu5yLuihgCXiUI4cpO0dWuw0fCCkIbLoq
	/NTRcVei0QMN6gwgj+CMhH58fgnLHLxwTe61Vach1omp1drIR4krXg8arJZBy3UsjZxtxDfW/Ov
	hrNoTTm/kZF7fT7CTo0uliWR+rxTuJBgMu7DBW0ynml8BrGztXQtUYm/ujh6TQBjx7AKdHOyRqQ
	TNrR7wSQgWGwxIqD1LA/IRrcbCnoYubwPAhjgRT98IA4s11hxXjlFfEJES42joTxex02/PZQdT3
	ZIADdmHxrARK3gP8nyrK9xNFQDk0jB+6+TjpM1/N4HTOdXpjqPCJ/8M9JqIm4y8h/wmiiDftsk9
	Vr8TYMlv/jjLIEyUSkdnA1mn1YsQKjZZOPzOrd5/TLJyOp8f7/lKDmjo+Y/QrH5t4C6/ooeQEg9
	u5OHd8OGPrCSEtkSrAPQshO78O0CFB
X-Google-Smtp-Source: AGHT+IF8goPemxSTArcLzWxGKm63RF4SSCDwhYMKJrOBvsVsH/LGsTT6xGkdlmluZ0TTdS2TeZJxdA==
X-Received: by 2002:a05:6808:152c:b0:43f:7287:a5e3 with SMTP id 5614622812f47-44f7a3ffcdfmr173797b6e.28.1761673601426;
        Tue, 28 Oct 2025 10:46:41 -0700 (PDT)
Received: from localhost ([2a03:2880:12ff:5::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-44da3e435d2sm2765845b6e.6.2025.10.28.10.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 10:46:41 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v4 0/8] io_uring zcrx ifq sharing
Date: Tue, 28 Oct 2025 10:46:31 -0700
Message-ID: <20251028174639.1244592-1-dw@davidwei.uk>
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

David Wei (8):
  io_uring/memmap: remove unneeded io_ring_ctx arg
  io_uring/memmap: refactor io_free_region() to take user_struct param
  io_uring/rsrc: refactor io_{un}account_mem() to take {user,mm}_struct
    param
  io_uring/zcrx: add io_zcrx_ifq arg to io_zcrx_free_area()
  io_uring/zcrx: add user_struct and mm_struct to io_zcrx_ifq
  io_uring/zcrx: move io_unregister_zcrx_ifqs() down
  io_uring/zcrx: add refcount to ifq and remove ifq->ctx
  io_uring/zcrx: share an ifq between rings

 include/uapi/linux/io_uring.h |   4 +
 io_uring/io_uring.c           |  11 +--
 io_uring/kbuf.c               |   4 +-
 io_uring/memmap.c             |  20 ++---
 io_uring/memmap.h             |   2 +-
 io_uring/register.c           |   6 +-
 io_uring/rsrc.c               |  26 +++---
 io_uring/rsrc.h               |   6 +-
 io_uring/zcrx.c               | 149 ++++++++++++++++++++++++----------
 io_uring/zcrx.h               |   8 +-
 10 files changed, 149 insertions(+), 87 deletions(-)

-- 
2.47.3


