Return-Path: <io-uring+bounces-10369-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 550FFC3349A
	for <lists+io-uring@lfdr.de>; Tue, 04 Nov 2025 23:45:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D736518C493B
	for <lists+io-uring@lfdr.de>; Tue,  4 Nov 2025 22:45:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E327315D30;
	Tue,  4 Nov 2025 22:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="fbWy/xOC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0AE2D594B
	for <io-uring@vger.kernel.org>; Tue,  4 Nov 2025 22:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762296302; cv=none; b=WedaYYeiIBrumv1WeH09/KTX+6659aqhGBECUPvT5j/7MxtfBlHxaLjmGnogrNQnBpblUtSyEErUE9G9A9AncqvdbJHEjSJaqsjAioay+SZccCxTJzjyJNWf6NLDDhgQLIczfDmfbBpcAPJs5iITnhWYzx0a8Bp5b9BJCeVb/Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762296302; c=relaxed/simple;
	bh=SzbY949HTbeuEbcREeo1jaQ7GGyIn8WCWHS7yaQgov8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Nbgyhsf9QK+8W00/xUivv4NogvI404EQSAIhfr1sFCV1GW2wSJo9BuNCQHfbD/y/piyL5JnMU4KWZaFZu8US6JMMaVpK2XXwmvo/BJeIqq20rNlmXog80dx5gaOlZaVU1tyTTIPEtGjbiTfn/ie/p5Ei+UExvKOt/i/BQu6r7X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=fbWy/xOC; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-3d3e9a34eeaso2270810fac.3
        for <io-uring@vger.kernel.org>; Tue, 04 Nov 2025 14:45:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1762296300; x=1762901100; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qX3+I65dPv2qgKgN/xQHOS5A8iQyG9INbe7rBCqX/kQ=;
        b=fbWy/xOCYe9hT14RrM9HtHMDk/2ge2Fnf+r1hjbR9K2AXoQQZxx6+jyYJ3j9MNjDg+
         yZt8zgltZRYAhfFTxq45LioQHh9PA235EBOnyVXB80tjfQMWBOOPIsCXfT4Yr2TW1MKt
         Xnib26mPmKI2/vmsvWO1GMtwCCIuv+glbGSpPvXTYc5gvSOppavUcibvbZy4eGhg/11U
         pUX4q6V+7V/T8c2H+Qilcd1CiYGV23uvHQNezNQgghODxu4Ap65mVE7lV2bxMEsI4hmz
         9rJczmwFTa0EeSFWcofJJ0JkuIbFUkV02I+4JYrQU07s34l0FU0mU1uaYjkHl7Ru0us1
         E8kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762296300; x=1762901100;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qX3+I65dPv2qgKgN/xQHOS5A8iQyG9INbe7rBCqX/kQ=;
        b=jP0Kf62FWCdvzRKUPZKAkK3T2tcblW4L7Od4TgsnanFMWPrrK2rYmFoGWyP506YrTr
         f8Obdz+ygXCOcZd3QBpU5QK1v82V8d2Rkdr2+t0InHgS+GTo1pGdIAXpfPYdkex2MGd9
         jQzCuNrz8Oy1+eLv4l2zQVhPI9JHHQ6Y0YIt6Psqu4//E+ML5y7DCW5+qUtXkmoE6PmQ
         yS2TrQPrtW/1WhJVUYvA3EgDQShDsQGLmV7TsiIAsIbnFjdpsxzPA72kE0Hjn9+ORfp3
         tKQzTcU5FrVeFEdgteLCLY9+jrcQBziECFAfDit0v7m4pl1+vKOFsU3H9CckX8IWRc0+
         WM7A==
X-Gm-Message-State: AOJu0YyuwdmmDzpYw549EV0u6WuDXhAc03oypuwiaWaMzI/3VjUs+w6P
	WhDtI+3o9VDboW5oIVeAvPAz9D4OgwbkSdbdxhKCMLb0U5mK/L1cVeNjfvB1TVtz4sDQBB2th0M
	381M3
X-Gm-Gg: ASbGncuPf6j5gBK64+IbPda4ZpYjhdRX4UsMk7fG+M1+s1UPwyKbgnQwIm5kZmFp+OY
	gxe283iOem1ogc4mHymBvrU4wcW6yzBB+YWAxNmh62ad/6/x9NI42flcf1h2SD6RRbQVHjmBBCC
	7CA5Sz+wLEnBxI2kj5oLASdAe1WKYxlYXhp49YLuT12EsBfXwnIuEfe1oasrAU0y+4izveNB7de
	h8PBOd71y5gyhUX+NgTr8rlEj1+zGk7/9klazT5SzQLtUjEtC1+0e7kMcYy7KMx0/fz3Cx5ecw5
	KWz3CDMHnD3/3JE3LlPi8sqbaQGgZUumlmzbVYHfuBwk37nYbralSB+arNWDjMUa3F8GVBHswS1
	9tXod9UPAQOATYvIcobBNckrMZ6Rdx3ibN+2dA+fJHVx61o92GXg6sPmLxMGHDbSHDtf/wfuR0M
	+2fOUt/m2H9RNhQfixH0o=
X-Google-Smtp-Source: AGHT+IHSwP5/mzEm4oVJq2TsD2zENGY/Ep5zG4Qpm0jNwYERcESqk/zpzuvT+YFMn9xJEFZqVeGVqA==
X-Received: by 2002:a05:6870:392b:b0:3d2:590b:8d12 with SMTP id 586e51a60fabf-3e19b942b06mr426968fac.45.1762296299865;
        Tue, 04 Nov 2025 14:44:59 -0800 (PST)
Received: from localhost ([2a03:2880:12ff:72::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3dff736d114sm1483098fac.17.2025.11.04.14.44.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 14:44:59 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v1 0/7] reverse ifq refcount
Date: Tue,  4 Nov 2025 14:44:51 -0800
Message-ID: <20251104224458.1683606-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reverse the refcount relationship between ifq and rings i.e. ring ctxs
and page pool memory providers hold refs on an ifq instead of the other
way around. This makes ifqs an independently refcounted object separate
to rings.

This is split out from a larger patchset [1] that adds ifq sharing. It
will be needed for both ifq export and import/sharing later. Split it
out as to make dependency management easier.

[1]: https://lore.kernel.org/io-uring/20251103234110.127790-1-dw@davidwei.uk/

David Wei (7):
  io_uring/memmap: remove unneeded io_ring_ctx arg
  io_uring/memmap: refactor io_free_region() to take user_struct param
  io_uring/rsrc: refactor io_{un}account_mem() to take {user,mm}_struct
    param
  io_uring/zcrx: add io_zcrx_ifq arg to io_zcrx_free_area()
  io_uring/zcrx: add user_struct and mm_struct to io_zcrx_ifq
  io_uring/zcrx: move io_unregister_zcrx_ifqs() down
  io_uring/zcrx: reverse ifq refcount

 io_uring/io_uring.c | 11 ++----
 io_uring/kbuf.c     |  4 +-
 io_uring/memmap.c   | 20 +++++-----
 io_uring/memmap.h   |  2 +-
 io_uring/register.c |  6 +--
 io_uring/rsrc.c     | 26 +++++++------
 io_uring/rsrc.h     |  6 ++-
 io_uring/zcrx.c     | 91 +++++++++++++++++++++++++--------------------
 io_uring/zcrx.h     |  8 ++--
 9 files changed, 89 insertions(+), 85 deletions(-)

-- 
2.47.3


