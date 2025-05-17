Return-Path: <io-uring+bounces-8024-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 15C22ABA9E2
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 13:49:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A15AA4A4CB3
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 11:49:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A43641F869E;
	Sat, 17 May 2025 11:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Yl6Wmv4x"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29ECE18C937
	for <io-uring@vger.kernel.org>; Sat, 17 May 2025 11:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747482588; cv=none; b=uCHo5qa+899dYX2SqUnzC8x0xbBbcCxlypW4AnV7rmxGl4SNe/wEj5MLNm882IarZJ107JS8mT8rXWeq4c0E77NVjLh+ng3wjxzf+sAoSBaIhEK3EirhgrFzfwxqIuo7Grzyiz73w7aMbk4X0sLPHsZ1LzC2OuyH4K06WmyH+yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747482588; c=relaxed/simple;
	bh=ZxMYJZd7iee2ZovnRcG4x8YmL/UIeMnlqfGRsYlv0oM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M2RBzQ1b9GC0UrGchS6KXFpI8eFlOltiwWA45xlwtJU8R53wm/LFwd4YbV22BoOvxan3vjlQfhFUru5LJzU3ANLUdHQKW1bq8q1858zeR+fgEyUXO7xmsI/ctnQY1+C83oe8pllPgXK21kEn6exiMkHQAjY/35B6X5ZGa979SCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Yl6Wmv4x; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3d965c64d53so9623505ab.1
        for <io-uring@vger.kernel.org>; Sat, 17 May 2025 04:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747482582; x=1748087382; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9NxwXTWMzb+MNHSIeeheIx7SgCaJpaCUDgpnsCU0YSs=;
        b=Yl6Wmv4xSkf/IbwBkS7Sz2/fsXSmLOlqhmUW15TX3gLHVsYXTBmYAsBlWXdlcTJga5
         eA667F+/IXokB4q20nPnquzVQSyHif8tRh63kDNAbkf5un+/Q+iw2kJag2M1nE3zCP3R
         HHulZ5SH83NdEi1T7jgq86Rq6hcLNJIHskZtAmvvp8mu8Ax1O/zKUxdvOEvlHu1UrgLq
         oSQsKuVCtkGQKGQgQ4o0WiXrgS4HlYg6vb2JLcdW76h39wTzz/MTLhVe5LfRQQmBAOXP
         yTJ0bGJ0LDaa5OYFUP/+Y9PiOhOI8e3naP/fFUp7IiaNp+ZVqupQf7G3Umv3pK9/fukQ
         aPuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747482582; x=1748087382;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9NxwXTWMzb+MNHSIeeheIx7SgCaJpaCUDgpnsCU0YSs=;
        b=d6fDSk6OvuUTITgVMJidbwm/Iid7bcB1FHlR9xlgEfhhLD3tGWR+F8CR6h8Q/uG3lL
         Xij6LPgoG8Z8xYIkfHmQy5/qDZZihZk78eWgeanQ52xP2bmL/drQJV1cTyZlarHfVJyl
         UlLweX+avbt8h+DGTBhswapwKC1lXsyIrnQa6E8fFpHvlti92qrTiG36OqTFfJhKBf6L
         FbVTY1bXicve5b0UhOPBUr74Hj15DAqMJGjvkLi2Uq6E5+9UYIIjtTnrrHNqjuziQCl6
         zMNPMHvBen+DcDSevfQVvAyv6uV0IMNb0BZ2TAvIPsIVuHs6pFBvJZANt+5OhqEhPnkq
         Bxbw==
X-Gm-Message-State: AOJu0YxlakdpS6+zMmdgbeMnc9OyPOd8KQ4XPi0Y5k2XW+H+wNA8eKjC
	BejTcneXaFZvv+SZfsOKc9O0HyWNBMbezynTXQAGcvKu044iDDLOYazhV/uclfUTeRpK72QUhYI
	7DYcl
X-Gm-Gg: ASbGncvHBKiNGTjvqOWdJguysalGFZftk9iY22RF1WyvCIcZA4+0rFAbH96gb8ES1rr
	KrMC78pcQfhucCBw1xZ38F5ucsScKy6+uPiVKhYBCbv3xkqqznetFvH1sZ7lQe7i7i2AR87rInj
	ngYx+MHPxZLgtWyHVEazJND9WUQP+DU5+feMrYHUtq6/PfF83jJAHUHAKqLF8Q53/WfoLG7S+jf
	J5lbQy3HmdDooqpSO+Cp53mNKJiAylRKQBBtKbgPehr+6sO5O8DL8mGYb4jLA55Cu23t/2SOg+N
	OSwM7d7xz301xVBfbJo83It97r885DqeqvehtaObCQapjgXCLKE5Nk17opae0iV42MQ=
X-Google-Smtp-Source: AGHT+IEBTjyOa1dtYmXvdKDgLn6wLCknYOCC/8JhGtgu1QHLeA4/3b7LK9sR0+y90RWVX6ODB9SBQw==
X-Received: by 2002:a92:cda6:0:b0:3da:7213:fcc7 with SMTP id e9e14a558f8ab-3db842fb76fmr80665705ab.12.1747482582289;
        Sat, 17 May 2025 04:49:42 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc3b1a8bsm874354173.47.2025.05.17.04.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 May 2025 04:49:41 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	csander@purestorage.com
Subject: [PATCHSET v4 0/5] Allow non-atomic allocs for overflows
Date: Sat, 17 May 2025 05:42:10 -0600
Message-ID: <20250517114938.533378-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is heavily inspired by the series that Pavel posted here:

https://lore.kernel.org/io-uring/cover.1747209332.git.asml.silence@gmail.com/

Basically this patchset tries to accomplish two things:

1) Enable GFP_KERNEL alloc of the overflow entries, when possible.

2) Make the overflow side pollute the fast/common path as little as
   possible.

Also does some cleanups, like passing more appropriate and easily
readable arguments to the overflow handling, rather than need 3..5
arguments of various user_data/res/cflags/extra1/extra1 being passed
along.

 include/linux/io_uring_types.h |  2 +-
 io_uring/io_uring.c            | 99 ++++++++++++++++++++++------------
 2 files changed, 65 insertions(+), 36 deletions(-)

Since v3:
- Fix typos in commit message.
- Rename io_cqe_overflow_lockless() -> io_cqe_overflow(), and
  io_cqe_overflow() -> io_cqe_overflow_locked().
- Make io_init_cqe() a static inline function rather than a macro.

-- 
Jens Axboe


