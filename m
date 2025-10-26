Return-Path: <io-uring+bounces-10221-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 851DFC0AEFF
	for <lists+io-uring@lfdr.de>; Sun, 26 Oct 2025 18:34:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 43D943499B8
	for <lists+io-uring@lfdr.de>; Sun, 26 Oct 2025 17:34:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2596A23EAA4;
	Sun, 26 Oct 2025 17:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="2L2Qu9Hn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C131DE3DF
	for <io-uring@vger.kernel.org>; Sun, 26 Oct 2025 17:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761500080; cv=none; b=pC4mulYeDeLkGmh0wNN4wU5n1n5daw4OpdiB7xY2swsQ8vASE+9P5PvCOGwqG4kgs5iZD1u1oHwBLL7/1FVUTX6i9GghodOIw8BLQtWmUuA3bW7cxGcy1gNRJV6WzbGJogZDx2A6cbe177FAvWHL+t8FSnoRvw0IVYLZpOHk5qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761500080; c=relaxed/simple;
	bh=QCBFei7KB3yyz2A6/OKf5PD02Y+9+ae7zgwF2c10W4o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FIH7GGI1iaGFmVjiprvDu2ZtAj2U9/dmYtcM9xLaPZfXYWrwRV5wmydyzNrajW7wTqTyOB0ZrO16FwuZlo43BPABeWe5ofDazKYZ+dPoQd6Xpmx0RXyNPlK5E2dFa9a/Lz4H3mhYFQRYfMIu71T7NAJ/jX8GeJyDKteuEtl4lhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=2L2Qu9Hn; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7c28ff7a42eso1268826a34.3
        for <io-uring@vger.kernel.org>; Sun, 26 Oct 2025 10:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1761500077; x=1762104877; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5hQAycWTbfOVoFZsVkJMPoP0nvYfcVdGuBZb+36T10M=;
        b=2L2Qu9HnJ9lF8HXBSUvhKZmfCs0hE0cg+MWktpxVoimGNIZ2sWS4lrqcvoBpvjeY5r
         mO/qyeFWMkKFhUyd+fV1MBWXqbObZVXzaR5SP1LS62+z47TPoIiTwP0ESTGGOiMciAwt
         4WpZypzJv/CexDWwX45puLgFHHx/nR8AwvwdyrkaIAOi8L5v3kuNnlO4NZZvL49qj2rq
         ANvfGK+pq6HWh3y1GQhOzHJLqyvtGMiFGumdg21VyRhTqh7ohC+gGBKmFAhfV4u46DE0
         hioWFKeK6vKT9CXCZMtGwt+q1HLpsQZFO2n7WXrG5gPNLYMu9DljoOJoAOfkSylMcylU
         kECQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761500077; x=1762104877;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5hQAycWTbfOVoFZsVkJMPoP0nvYfcVdGuBZb+36T10M=;
        b=I8mgAs9zpIqJmBnobrtI+GoQJ1hM0Tl2g3BhVPoNJFy405jGtWOrbiLBuG8oiwFkBw
         UB5HClfkzwyx84fdgk/XJsdpsKda7gjDn0IeCnXZbm+cSfpKLxY+3rGnYEIiqL49AvjL
         evIvoarmOEw1hcJea26NBCt7GEmoLQzN70qNT2IqmY0cavF0uLF48BrvsbrjQYnpqi4r
         41hotCzgfXerPOXhbcDCHVtGDnq1BiASdD77Zicvrz7gvrGdS7jJWamroRh1Hk+FiYyA
         5oaKeu5HKLUfYiQ9gt6Mu2T/KGw38wlrsJL5tyaqRf2F697oJSbAm/++GS4JRZMmm0kU
         WLNw==
X-Gm-Message-State: AOJu0YwaA5geiIXyrB0d3VWlKcRpY/D/QykrCkHbPUN5J3gsiT4wZP1Z
	KC4KNuiFojBkuNNKhDAuijvpSOH8fObT77ZtIc9edWRc+iG4s+kGhpwuwTqK8EY8MISwhNVywKj
	AhTgA
X-Gm-Gg: ASbGncsWmwAjThfd/eHMES8ruBNGWT6BOvZGtw/ENJbV/GLhdiKsO2EUP2kvlOQuy9O
	ymUq9GxMbKOmNZGIUt6X2u/ghfCdolFaXjt/a4KuyXg9ypBI8lbs6jMQCDhspg3OhSWHIpUnSKz
	6m/Ij3p30BWGbu4AA1AQxrNI6r0Cy+fylrJ8Vi6I9UgfZ2SPI/sXhnsN4YYgQBgEPr3ian/KXq/
	MRXUL02WBP3rFq+BzamLO4spe3ZcVl7cT6UdRBfrpbA/epD2on6a2xwY37dKT9OTJTvB8/RwpfF
	8a0CcnOzfU2cPyeOqdqy2hxryNkRkhd+NFkB3qaCc2xBnbCORpOx3Iy8CjZZgJts2QaAsigOuXU
	QGuW4UiaYtOXTHCu0NNXG3jganh4Tl/Ok1FDF/6i29wXiyKwhS0XnCnLTN9+bLMa4nlbUTGIzwp
	1Bpr5DkSNXOXv3HSWqdniTW4Jy1Xs+
X-Google-Smtp-Source: AGHT+IGEqLdM2C1BN2NDHEbms/8SX7mak2n+saPOfiLXotnF1OBnVQ6BvXsjs9oX8v5tfy3LZqxEkQ==
X-Received: by 2002:a05:6830:2705:b0:7b3:5908:34d8 with SMTP id 46e09a7af769-7c524066962mr5183898a34.11.1761500076706;
        Sun, 26 Oct 2025 10:34:36 -0700 (PDT)
Received: from localhost ([2a03:2880:12ff:9::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c530221d90sm1526800a34.33.2025.10.26.10.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Oct 2025 10:34:36 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v3 0/3] io_uring zcrx ifq sharing
Date: Sun, 26 Oct 2025 10:34:31 -0700
Message-ID: <20251026173434.3669748-1-dw@davidwei.uk>
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

v3:
- drop ifq->proxy
- use dec_and_test to clean up ifq

v2:
- split patch

David Wei (3):
  io_uring/rsrc: rename and export io_lock_two_rings()
  io_uring/zcrx: add refcount to struct io_zcrx_ifq
  io_uring/zcrx: share an ifq between rings

 include/uapi/linux/io_uring.h |  4 ++
 io_uring/rsrc.c               |  4 +-
 io_uring/rsrc.h               |  1 +
 io_uring/zcrx.c               | 92 +++++++++++++++++++++++++++++++++--
 io_uring/zcrx.h               |  2 +
 5 files changed, 97 insertions(+), 6 deletions(-)

-- 
2.47.3


