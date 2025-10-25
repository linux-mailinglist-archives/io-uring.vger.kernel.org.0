Return-Path: <io-uring+bounces-10208-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CAC04C09F06
	for <lists+io-uring@lfdr.de>; Sat, 25 Oct 2025 21:15:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8FDA81B261B7
	for <lists+io-uring@lfdr.de>; Sat, 25 Oct 2025 19:15:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5E443019C3;
	Sat, 25 Oct 2025 19:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="Msk3OXys"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14322C0F83
	for <io-uring@vger.kernel.org>; Sat, 25 Oct 2025 19:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761419713; cv=none; b=SHilt3oDeRVXa7ja5I0X2rhsuIHPoCSrfkEQzuZ7PH/g9ruWXZ31eVnsOwdSJBZzLTYAHkrnRnbsxCx5aRHh8C65SoCU4QnvgmTu2Xfl6Thtnk/km5v7DtGIMse2S90UqM6XVdpEnnWHpvJ2oA1erEwF/yMA1N8AyswbCWW+4Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761419713; c=relaxed/simple;
	bh=k6HLdZL+DG1B/F/EBBIQxpw/n6hUEgF1dkyWmOYf3uE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CrjZiurM2FWUfr+KNQy+/gVYrK4sQFBWXhlLkQ8++SEBQoG4zPlPXJnl9EVfaHaWnwJ88G1HqSysGxhRPSU3lLHOyvtgI3iE5170evOhJR7izyg7gHEcFJizJyKY0JZjGHZeFTsl86S13Tee4g/GkK9pRuGbn1D553mruSuI5Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=Msk3OXys; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7c52fa75cd3so801954a34.3
        for <io-uring@vger.kernel.org>; Sat, 25 Oct 2025 12:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1761419711; x=1762024511; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9EJ9nJJCeU4TaVjFbXv6AgUmx+IvrSUjodgZO0uVGkY=;
        b=Msk3OXysZIJL58oqI8hQZa9EFOISJ51P4SAFOCEnOLdnpA4/xXH/QMzrkHkMS1s3pr
         YI1JKYL7AMSjsrgN/4MSGjJIHpQRSP2ZyDCyrWDKhaqlSRIlbnYJAdOEOHmAJhM/h6T7
         Nh1SRFnnhnEH4a3WQvi4x+JT/O88oAWTy78yYPVwf6yCg38zI+Juq6YRM7dZuZWfGVNv
         iLqTaftdZrTu/TcmX0LsWICbxOfyKa2hwl16KEek5ZqwdH2D0l4H/8oNfzq9PxNoa1ZB
         AWvaY9b5R5rdD2HHFTlD4AvlNcGqO/H6UEMuxf4KxixwNyJeiEr1prllMZBC1PRKxWdY
         kk2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761419711; x=1762024511;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9EJ9nJJCeU4TaVjFbXv6AgUmx+IvrSUjodgZO0uVGkY=;
        b=kUmpcjVfCyy3bDju2Nrfs3ie39yMmONPjDTjKonV8QHqcd9gTHIqTzUJB4wP7/veUN
         /TQFuYtrOZXmHwdOELiHgJcLcbeTJwKO3UrQ5ddvarlrG32EC1dWxMxZDqi8K2dF/ipp
         lyi9eHPqac+UqDEf8hjzABvUwmBwVirkdDdsSwUxiAatisJnpxUaqulg5hZZUq5+6G/P
         PsJCmOxSGdwO3ybKvQETcdGHUkyvLZdmnhbAzKYfb0htACEXE1+RHAc5fMmdM5yL2dwx
         jCK2tuDEenK9QkOFB0e8SqtvvWpTJ2KPg+OXrd+uOlUNuqlh/8pH9DFSY84AVJ3kcUlz
         Vz2A==
X-Gm-Message-State: AOJu0YxlTrJWOkoadYQpsFU+FVT/lq0A32httloTbKdzl/7cax3pEjMA
	WqHZhymd+jkg/4hNCEBj5YALRfroVf8mveD/HDwXqYCCZ2obJvPiNXFTC11vypm25GOBKPhWjjh
	xnXoC
X-Gm-Gg: ASbGncsHk1ugD2e5DziUVtBgl2atxHJEIIwHItDMqVQErFs7udeXI9KwxlDo5fUc5C3
	+WVsxXRiTNaPQeWEqWUVqXPPILTOir9H3ZS8kb37GyYuyTVlttayfiRLZm3uekfq6W+CjzOhAwH
	Ww8j9G2G3wfqY5X67I8fmt4ztBzPfdlyRe2aYze74BTemdCgzjRIWzeD7B44nahBBgdKuSUPswE
	/yd6YWJGhSxx4Mzx/CeFPlwNdxSWjEUGZa7rrG9gcVrVqLRpinBqWRWRs9M2oZcqim1J4Anev65
	hghQwP0L8NPe9HfFY/+EWUE0Kr5qN2TsWYntBn2vtKUBEs0LorfzJAW3SfBPyBmX8wVwl1lGvTN
	IW2YMFJXJKRv/+Sx6RmH+Nau6mLzoBoqJRhFTdZRSgEPqnKMuMf1uWlfL/DnwMI2phpWHQ1pJWg
	R6uz3HZHEvb8vqWsaQV1+NkCY2U5fVC5OSL3hR8N8=
X-Google-Smtp-Source: AGHT+IEWYGnwi+ICuEJclTP02WG6mGKz6SJ9O2M6tBVrfZBU5WoiE3tq8m52gV2TSMsYDbGcKuUFAw==
X-Received: by 2002:a05:6830:2b13:b0:758:85e2:9a00 with SMTP id 46e09a7af769-7c52413caaemr3257016a34.17.1761419710920;
        Sat, 25 Oct 2025 12:15:10 -0700 (PDT)
Received: from localhost ([2a03:2880:12ff:3::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c53022052fsm799078a34.30.2025.10.25.12.15.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Oct 2025 12:15:10 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v2 0/5] io_uring zcrx ifq sharing
Date: Sat, 25 Oct 2025 12:14:59 -0700
Message-ID: <20251025191504.3024224-1-dw@davidwei.uk>
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
real ifq that is bound to a HW RX queue. This is done by having dst
rings create proxy ifqs that point to a real ifq in a src ring. Rings
with proxy ifqs can issue io_recvzc on zero copy sockets, just like the
src ring.

Userspace are expected to create rings in separate threads and not
processes, such that all rings share the same address space. This is
because the sharing and synchronisation of refill rings is purely done
in userspace with no kernel involvement e.g. dst rings do not mmap the
refill ring. Also, userspace must distribute zero copy sockets steered
into the same HW RX queue across the shared ifqs.

David Wei (5):
  io_uring/rsrc: rename and export io_lock_two_rings()
  io_uring/zcrx: add refcount to struct io_zcrx_ifq
  io_uring/zcrx: share an ifq between rings
  io_uring/zcrx: redirect io_recvzc on proxy ifq to src ifq
  io_uring/zcrx: free proxy ifqs

 include/uapi/linux/io_uring.h |  4 ++
 io_uring/net.c                |  2 +
 io_uring/rsrc.c               |  4 +-
 io_uring/rsrc.h               |  1 +
 io_uring/zcrx.c               | 91 +++++++++++++++++++++++++++++++++--
 io_uring/zcrx.h               |  3 ++
 6 files changed, 100 insertions(+), 5 deletions(-)

-- 
2.47.3


