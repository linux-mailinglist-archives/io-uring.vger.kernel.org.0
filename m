Return-Path: <io-uring+bounces-1374-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A0F28971BF
	for <lists+io-uring@lfdr.de>; Wed,  3 Apr 2024 15:56:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4BD9C1C217C3
	for <lists+io-uring@lfdr.de>; Wed,  3 Apr 2024 13:56:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEC35148839;
	Wed,  3 Apr 2024 13:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dDCeDUIC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C309B14883C
	for <io-uring@vger.kernel.org>; Wed,  3 Apr 2024 13:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712152569; cv=none; b=Zce+A6HnhIRM7bHEpYqWMiW3Vpr+PAIErbwL3n3aHNncpA/bGv8bllV/EDXcQPj+NzwwBEuNgJkDDZNE29xSTAgN8R39Qj2rLbRXRkM+dwvpm/9WJFYzuEIV2CQcKQyWz02XCyIjZksfDHlAkkGPabdOc+kL87vTixCjrKXPENQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712152569; c=relaxed/simple;
	bh=wjvJ/9BOl/C7SLdXHy9zUcEip4D8QoGkIiH6HVIYkgM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=K+0+e2qp6Ha7kgvzCBFlCmMFjtbH7vFoYxuxg1m+fcu3E5O+o3wK6l7m0skcD90+j4E++6jZU2b9Iq7wGdeIR5+zZ16RDsPVWAt9FBykpVvxRCxM77NgDnxBIHsM6QQ0oKkNEEhdgb2mwISvrafa9KcQB088lP/znpS1mFBMfWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dDCeDUIC; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7cc0e831e11so60232139f.1
        for <io-uring@vger.kernel.org>; Wed, 03 Apr 2024 06:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712152566; x=1712757366; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=g5gb/UK7hSnsv6XrZsgh3YYzOaTtFoLYbjyrECAYjJA=;
        b=dDCeDUICl7vKAG+2KHNWE2pjKpilUlv/vRCtAy6iTPNpBr1fEpJrO2vdhM8vhyAgT5
         mhDgpWrTkR2ncE/2GKekyGS9gqhix+d6kFJGos38LrUCzkcHch40Tf0g40EiOaPMjdVU
         MPPT2xhcbMJEDJ5z0xC/Q8AkzhDPvw67U8PtxB/EjjQKwR5JhIiGJUk4aqAr5Y6wXthB
         h0fXgy7kpknoORLtOKxX7rQefg8BKHTM/TeXG/W0hQkR5l7+5N3wEny6vspA4KYFpfx2
         4/XJzLk5s2gpZEWjJiHSH4kfc8I5Ek9aT9MzCuJ8nb/hZfir2rTE9fbyqJSNyDEzdh6Z
         fmyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712152566; x=1712757366;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g5gb/UK7hSnsv6XrZsgh3YYzOaTtFoLYbjyrECAYjJA=;
        b=dliLDX2hOdtgRyo+4mKLZPO2jhy2P7qZzf4sRlHCnARoWoZ3UGb07d2YUCTIUZ7+Sh
         SorFApxhaQcQu5cbEGPgYeVWpRRI589BfoxGEagDUMbA+Ta68v6kVyfLZvr3jpQkIzfm
         YB9GycnhWIrhn3IMrzesMJ/RdM2n/nyxaFseoWUZuh2nYpAQH+vhwppVZRXhSEm5MlEw
         Ds0+oehVvvHY666QJbp8F08Bg5KEkrl5BFk9bAX79TVkNJBRf+V17NOjGfaC/xIwUAPn
         S5NlFjlFHIhu5SMrW3CZ3xed11ASbP0oxywUjjc2saqFVdhUEfrL0xbavWyLYC2yM9Qm
         rN3g==
X-Gm-Message-State: AOJu0YwSaGkj4olGJ+NgMeop7dMIGAh8SVhFe90q2jENacGO4v7tCQ8B
	bkK/F/22C08GZ5EPGIAmTt+9FBSwawfYV1VOKl5egE6FJbpiHmpPd80J8tWvltlIrtKWUS14rwR
	c
X-Google-Smtp-Source: AGHT+IEM6GwzGIUdRXo0TvDtSycg++3oCo9kFziad9lT8V1uoe/Z007Snj5KukSooHuuVF0yohxmnw==
X-Received: by 2002:a6b:c949:0:b0:7d0:bd2b:43ba with SMTP id z70-20020a6bc949000000b007d0bd2b43bamr11499176iof.0.1712152566176;
        Wed, 03 Apr 2024 06:56:06 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l14-20020a02ccee000000b0047ec296d3c1sm3839460jaq.19.2024.04.03.06.56.05
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Apr 2024 06:56:05 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/4] Cleanup io_buffer_list and mmap handling
Date: Wed,  3 Apr 2024 07:52:33 -0600
Message-ID: <20240403135602.1623312-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series was previously part of the ring map series targeted for
6.10, where remap_pfn_range() was replaced by vm_insert_pages(). But I
think it can stand on its own and has real fixes in it too and should go
in sooner, so sending it out separately.

Series basically gets rid of the split we have between how lists are
stored depending on their buffer group ID, and stores everything in an
xarray to remove the distinction between the two. With that, we can drop
the io_buffer_list->is_ready as well. Then it adds a separate reference
for the io_buffer_list, and uses that to tighten down how mmap buffer
rings are handled.

The resulting code is simpler and easier to follow, and drops more code
than it adds.

 include/linux/io_uring_types.h |   1 -
 io_uring/io_uring.c            |  13 ++--
 io_uring/kbuf.c                | 118 ++++++++++++---------------------
 io_uring/kbuf.h                |   8 ++-
 4 files changed, 52 insertions(+), 88 deletions(-)

-- 
Jens Axboe


