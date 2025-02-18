Return-Path: <io-uring+bounces-6523-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B04CDA3AB69
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 23:01:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 959A51896819
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 22:01:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 190251D0F5A;
	Tue, 18 Feb 2025 22:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="GY8GuPJn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6092862BD
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 22:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739916104; cv=none; b=AC77+Irgua0hK8bdD/p5Hkv7x/PmAgfzYtOfxb5oIPu9Mru6ZaMUtA9h8uS5GYSjhruuW+y7LwlF/IYhxOqKfeMEFPHSmwdHD8v3v5Pd7AlQFkp/KFGRJJif6heNSnJH0eEsZf16m5LIMZ8nJU1wY5qwc2yh4rTkwOc9dqsmOUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739916104; c=relaxed/simple;
	bh=99I6/zgqVCDkZYfoGh22I6TBaxsdDxAiWVAMOyIISKI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fQlYDJlLDuKteFNnAQrfMc4FPHR6BiHVjMGli3S4mE+nK3J7kqbzYMBQuAI6/dgU9biGva0PO4reIc3zx9zG9TNlc6tdzqArFvazYFJ5j0kdCBjIUFFiJ8nMPGUGGtMrat8e1DKNBvhaTr/sBFr+CR3ooIYRvGRUwqWT+yWm4Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=GY8GuPJn; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-220dc3831e3so4117095ad.0
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 14:01:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739916100; x=1740520900; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9HOeQ3lrQPusdLgGGUR+GaLnFeJfor9EQPzhK7Dfdw8=;
        b=GY8GuPJniBt+OQKlw63dfp6hO/mP2R1X23twrlmVuXMXINGGTqXC8Y+oXu16C8zgVT
         IiPK1tmzboGYSNJs99ymyjc59qWLOmksEsxKbGRqu9vZ5XRbtpgQn5+fj/lBeAGOsVVK
         Wjl26lbQmciigqWmuqUMc7kGt5vCT2WCH6x9o+oC2OjObpdEUedsExsducL4TqQj4Bwa
         JN5ZjOjLvYj+GZCxGdxBOdC29dIhQe8UCTMoXvAetmBWkx4m5Ff7rihqUQnKMUcJusZo
         87ZgnyCYIGvwaREo9zabQpqkUENbQ/JKKgICir6Akqmo0CHzfAQQulIUvyHWp/pnxOIv
         1oLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739916100; x=1740520900;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9HOeQ3lrQPusdLgGGUR+GaLnFeJfor9EQPzhK7Dfdw8=;
        b=d+Bo86ZLJyAqenmzFxPV3RVwi/mjXBFNN44kW3Ix7vz0FDasBhTUsPu3vkPAJDz66Z
         o6T6fwJAQ5v98h2dv+H30XDWtAvhh2OmECmL4UOPZsO7bbNQ6PWvUnoanWQE09zpE1na
         Ssx+He/mnxML5zDoixhYoJ2w9TVZp3U+NIL7v9rwBRwwX6hmWNg+hN4Rshm7DrSlWDeJ
         DIPCVR/MBCeO2b5ieobexc8IWhXt19ZVvTOqiSFVfWUq8Ck/5ia/2DWO0CAd/mgFWbX4
         EdW4ZngQ4crxWPNOWX4gMWDfgArwH6FQd2paCdKDc4AoiRgg/H3IgcxZ8jq1bf9mMzs/
         GdWA==
X-Gm-Message-State: AOJu0YwLciDF3/ywZKqGxBBalJjG+y6OPSKmy9GqWbYufoY0y8RuQZ/k
	swCiikCy9dnHVRP8BGggPTQi/U/87lN96nme6HFQ9fNdZNb+XzUm8oTWKG20o3grOHY/RH2b/wk
	D
X-Gm-Gg: ASbGnct4I6w/SlTm6ZFQXKMYxoA31cyGjYOR0MUx5Ucu7d9jAV0j/JsxAPjBkhm4lYW
	cyjO6aFvPhOV+vmfkfUMnFkmWq23C29IT016eSJwPWAYMEeIYyiKJuE15DEbXMzYO156GvQ4Iuc
	iteosPusdKlcZu51lo+dSlRZLekyDUy3SjGjywVPiHliK4CTqi6qDCslgxTFKDLQkR/c3TkmRUG
	TZvllhjSveMlSFYFFqovJVW9C/IiRLCRYPh6KqtZuvgjWeDovd7CVRV1dYzLqiF3/KZQkz2FuG9
X-Google-Smtp-Source: AGHT+IGfWzQCtGlg+IWa5wYlGrTCwBJP91Wkjqd46ZfS/j2OQzBJoUVXID7KhBDc0OqQmWqYA6QQEQ==
X-Received: by 2002:a05:6a00:8215:b0:72a:83ec:b1cb with SMTP id d2e1a72fcca58-7329cbc5a1dmr1838220b3a.0.1739916100505;
        Tue, 18 Feb 2025 14:01:40 -0800 (PST)
Received: from localhost ([2a03:2880:ff:70::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73242568acesm10962307b3a.56.2025.02.18.14.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 14:01:40 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH liburing v2 0/4] add basic zero copy receive support
Date: Tue, 18 Feb 2025 14:01:32 -0800
Message-ID: <20250218220136.2238838-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add basic support for io_uring zero copy receive in liburing. Besides
the mandatory syncing of necessary liburing.h headers, add a thin
wrapper around the registration op and a unit test.

Users still need to setup by hand e.g. mmap, setup the registration
structs, do the registration and then setup the refill queue struct
io_uring_zcrx_rq.

In the future, I'll add code to hide the implementation details. But for
now, this unblocks the kernel selftest.

Changes in v2:
--------------
* Split out linux/io_uring.h header sync changes
* Move exporting io_uring_register_ifq() to LIBURING_2.10 section

David Wei (4):
  liburing: sync io_uring headers
  zcrx: sync io_uring headers
  zcrx: add basic support
  zcrx: add unit test

 src/include/liburing.h          |  12 +
 src/include/liburing/io_uring.h |  62 ++-
 src/liburing-ffi.map            |   2 +
 src/liburing.map                |   2 +
 src/register.c                  |   6 +
 test/Makefile                   |   1 +
 test/zcrx.c                     | 918 ++++++++++++++++++++++++++++++++
 7 files changed, 1001 insertions(+), 2 deletions(-)
 create mode 100644 test/zcrx.c

-- 
2.43.5


