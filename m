Return-Path: <io-uring+bounces-10459-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 69804C4330D
	for <lists+io-uring@lfdr.de>; Sat, 08 Nov 2025 19:14:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BF67188DD56
	for <lists+io-uring@lfdr.de>; Sat,  8 Nov 2025 18:15:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B7F7272E54;
	Sat,  8 Nov 2025 18:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="B8hnmsvC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEBA27381E
	for <io-uring@vger.kernel.org>; Sat,  8 Nov 2025 18:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762625670; cv=none; b=r0L5SkbGp9AqnAspM2GeKCKaP19x+NjlJdG+lQ2aTQVTrkUXJCSUANGKBc1nBo/+il51cHmW4SEZM7a17UG6s3BG/mjzaaPcqm/NXExJXSC+ube7nslogS7EkfyxJNHTU7kPOLMzmV7oKLQuXVZM/Evg2EgGCb5Npa8wefmrP+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762625670; c=relaxed/simple;
	bh=vF0HB38wJkPTVly0OuNXG5FV6TL+Iq9ZY8RCdHo5Wak=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ad4s1tgRaMTs2hqb99852DhHFzMXn5qJL857CW+QAE+YZGnKZ/8Fw2AtWkwl3weA4epR5kOknCRRrYdbLOpusc/540N3XoZyp/Zeb9KoQ5ZXOeyYUDpIEn2xrbK9ZrX6c7wkJxeFkb1FnC+wk+Rwam0Y/HuP9G695oFbAVXRsPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=B8hnmsvC; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-3c9789ea2efso602097fac.2
        for <io-uring@vger.kernel.org>; Sat, 08 Nov 2025 10:14:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1762625668; x=1763230468; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=O4oSjCnI9JiSOr8eZcDeqKz0vplgjQLs/0qDcKMj/uM=;
        b=B8hnmsvCiWNEvoaZCvOuTUjquRC2ORFe/DVGS1mf49bsC7fqztGgquU4FbU6biOyDy
         39grLe7L2rc9TDWwV8qCvz02fb7rysVGAeClHpOs8ZjY9cWBAucIUZdX1y3NW1NzeIzd
         aqe37I3aXQvDKbb7zMPEtT8g/U6XwVQzoduOytHcz3JMbnP63A/IwPBevXqkcw0excF5
         cX7WkiLaoGE4+33p8MgPEcrX3VpzZejz92+C5XyIv5vz+0rZ1iHgDbSH6sTrL/ydNAY5
         U6vV/41mxsRpoyqVgKpPKZRjq4lEj0OEyAqJfUQJL2T81V4hmnwom2795ub5+/Za4Php
         3huQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762625668; x=1763230468;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O4oSjCnI9JiSOr8eZcDeqKz0vplgjQLs/0qDcKMj/uM=;
        b=S01WLlG5qNacGgw/F83Tk+BF+z1c1uCtSIg4pdl5bfH4lN7j1Y+mfzZNnjtznl/tz4
         sIP6fgIxBAjwyPrEA3UZHXP2lUjU0WqoAkQZxRQ3TxdCmM40d0uewIeOnsbDJ4UL7WFI
         zjdgGbPtv/6p1OkuF+wEynRyhsfSVQjSqqPyaL7crmc6iqMn9fSnGrvB3emJswiOFl5A
         9s3dgk2sNEUQENytsNdImdffEITgMLYpTcxI5WYpxz+jpPBwBorxx9TOKE6yfODY3kD/
         28RCyApaft1OUjqs6BadV2JTJKCbtvGItxmAeGjTI4QbqN5v/ARxHm2gYTu9VCWGSolX
         8Dxw==
X-Gm-Message-State: AOJu0YzME7ZATC6NVovlfnHL981ZOEu3fhUKhYAirNFN2IfrMfuVW7VJ
	LO5QhD7e67OiRoAA4fqvazrTifpQNNPaboqn0+mf0ozMELCpmePZD12WeLtZeprSjnNIrqsCBzd
	hliM4
X-Gm-Gg: ASbGncvQ2ffanW0HrBFtzo4yiJ/Vuxrb8X3VlmyLJQ/Y0lztlqATxbc3jXLwvm43zSF
	OfWNvQ30r7C5RMH18EAz0AX4/gotzNUEezSqfaLtmra0elU7MRCXD51JTctplRgETYXxCHDe3h8
	kRnUxC9cAiandP8D9SAjg0SmXmAquLA2cBPBe5dea0dvjYbxLnwWKhrKvzN1TnBaY6U0p99UNHC
	IZG3e5KCBjrBUCg0HaoLDk8hLbWxv5wT0jsrCdu0i8L4XlZ632k3t5ogfhhKLX7E3UfFrPacj77
	8dayOw1c/RCPZwLqsZ2AynDB5JBqaI710VN34TU4dkjM3atoaD7NaV0spwiPPwGOSmxRGo8HqWA
	kkGbOT9wmScTFmtOZnTR6dl+xSYziekw4lCqB0l9m+KKYOpvgXoxppKdtImusue0FnmYAj+IoVK
	GF3+lZ3umWzBDBa1WlfPw=
X-Google-Smtp-Source: AGHT+IEsg+MmSrneFrsIwhV52A5JHhy7NSU97/Ab6EeSmSKRZcQtD2Z4wdEXTgfc83fHDbel7AKW2w==
X-Received: by 2002:a05:6808:ec4:b0:442:82:3efe with SMTP id 5614622812f47-4502a176dbdmr1543569b6e.14.1762625667713;
        Sat, 08 Nov 2025 10:14:27 -0800 (PST)
Received: from localhost ([2a03:2880:12ff:49::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45002798bdasm3679000b6e.17.2025.11.08.10.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Nov 2025 10:14:27 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v6 0/5] io_uring zcrx ifq sharing
Date: Sat,  8 Nov 2025 10:14:18 -0800
Message-ID: <20251108181423.3518005-1-dw@davidwei.uk>
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

v6:
 - removed ifq refcounting that merged separately
 - fill in struct io_uring_zcrx_offsets
 - shorten functions + structs
 - move ctx flags checks from export to import

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

David Wei (3):
  io_uring/zcrx: move io_zcrx_scrub() and dependencies up
  io_uring/zcrx: add io_fill_zcrx_offsets()
  io_uring/zcrx: share an ifq between rings

Pavel Begunkov (2):
  io_uring/zcrx: count zcrx users
  io_uring/zcrx: export zcrx via a file

 include/uapi/linux/io_uring.h |   5 +
 io_uring/zcrx.c               | 218 ++++++++++++++++++++++++++--------
 io_uring/zcrx.h               |   2 +
 3 files changed, 173 insertions(+), 52 deletions(-)

-- 
2.47.3


