Return-Path: <io-uring+bounces-552-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BE7A84BB04
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 17:34:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CDF461C23874
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 16:34:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A81F2EDF;
	Tue,  6 Feb 2024 16:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IHY3Qip8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1E5138A
	for <io-uring@vger.kernel.org>; Tue,  6 Feb 2024 16:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707237268; cv=none; b=sQOezFc3ImJMExtTy9M7zkakbo41SDHTetADjsjS75m6sfplHcwOjkGQkLBLzlh0Z0F0/88joaKEb/0SZ19+Vdzez954fQPd3JOEv7veb+UGXhO60HtFnawJwUAMbfbypUHZ7bm1N+i7Gu4zg1Czc1SZm0SdeTlLiRxxHTnMtUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707237268; c=relaxed/simple;
	bh=cZbEmAvgGvMMpb1K68GW9CVJS6dB30J+uuRsKHlN0Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KWCK8aQYqbLSRc+TIBgo0IkqxrK4j8SrOKCHtAj3QG2obEXB0MFrIC4dLfUMpXAddQ/D6/bkkdOBwmyGlxWPqK0bxq9kZJQ8EzEHbSg9I8Y14M1Bn8Fk7KnAscaf3ijZ6CmLMXKiaKpH4onNZ6ICmZkxvE1awweiUqGV7eN2S2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IHY3Qip8; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7bbdd28a52aso98778639f.1
        for <io-uring@vger.kernel.org>; Tue, 06 Feb 2024 08:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707237266; x=1707842066; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZjNMAuZWWCVVxs1GmQKOGXD3osRqvyMUPn6iplEeZI4=;
        b=IHY3Qip8VcwS7c2stbTjE0C/PCtUXws5wYhPt7OzvJCNaUZ8Ds3xK7a9G/7ZunEY00
         qtGTfyUFu203bsJVUciEyTGjDUKzCBmAZYkZRYMqknmOo0ilFMcfx1qtWbKHJ123HkED
         nn+gjT61LfpY2cCeIyksxYcg/6XYY5ZYTK5AtwHxFXfmdF5IaC6etfi3ZHtOIfc4l9kM
         zt/07LVQniCiNccRohNs3dggFKPTRsN87cw1FBJWVhNe00mZd6nmHY7yBrZW7LnZymMX
         0/s5yXjNyNivTGpprTlhg9uxdexEdVS9qJS44pZecby0mX14fVXJLC/kdzqg4mRh5sHZ
         sYTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707237266; x=1707842066;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZjNMAuZWWCVVxs1GmQKOGXD3osRqvyMUPn6iplEeZI4=;
        b=qqNXcLSSxyEE4dpN13ZsEEjBT5OwrAmvNv13wdI8l76XaVinjGJdJ3E+o3DS6rizFL
         +9mwdO6h1EqZbZApJww6trGUZDur/QixWKQwwHswhJcNTUs3VYOfMCXqTVx4ry2kn1pW
         csBg2d6PqO+OzomfGZLVz8lgfXA9xO2hWhljN/f8PT0BvP9uXjxOZoRsqTfjjnNgbAVP
         ngrq4geIxCfgStEOjwMTjwGIM3eRKTKcgoXa1H/K+VcgGLh+6msMJ5DLTs1QMx3SO/Sf
         CnrfJG+q+2epIQpPIuuGa812Vnfb84qZ2M51N0067UNFuZCaTywaJvS79LoWIEocmfOo
         0XPA==
X-Gm-Message-State: AOJu0YzYs15x8shpomS9yxSTF/Xvb7nacGMScbJjYFvrggy3zELowF96
	2DeHIAxT/nYAOLFv2xu/s4kAJ0LXXRsnhyqmQ/hr+K6aIbwi+pfKG86ugDXNsxYpV/NRZcj8hix
	hkR8=
X-Google-Smtp-Source: AGHT+IHGvrIrQaojR68Jd0wcVBZXGZJRB4JZovQnrrrTWesXNF83ySXKt0wyJ/0TahYnJUOIgPHG2Q==
X-Received: by 2002:a05:6602:70c:b0:7c2:caa4:561a with SMTP id f12-20020a056602070c00b007c2caa4561amr3331085iox.2.1707237265834;
        Tue, 06 Feb 2024 08:34:25 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVqPyiSaPqUSE/OBqlytKGZa3frMjiLcEmsm6uAAUN0VZ2UFEV42HaFvfcbH/ziYoGkE+x01gQHQcAkx6w1LJ6sqS6tOgIg0KzgrUD1xt9M6n1bceCkk5fWvrUFkNIO
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id u8-20020a02aa88000000b00471337ff774sm573316jai.113.2024.02.06.08.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 08:34:25 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: kuba@kernel.org,
	olivier@trillion01.com
Subject: [PATCHSET v16 0/7] io_uring: add napi busy polling support
Date: Tue,  6 Feb 2024 09:30:02 -0700
Message-ID: <20240206163422.646218-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

I finally got around to testing this patchset in its current form, and
results look fine to me. It Works. Using the basic ping/pong test that's
part of the liburing addition, without enabling NAPI I get:

Stock settings, no NAPI, 100k packets:

 rtt(us) min/avg/max/mdev = 31.730/37.006/87.960/0.497

 and with -t10 -b enabled:

 rtt(us) min/avg/max/mdev = 23.250/29.795/63.511/1.203

In short, this patchset enables per io_uring NAPI enablement, rather
than need to enable that globally. This allows targeted NAPI usage with
io_uring.

Here's Stefan's v15 posting, which predates this one:

https://lore.kernel.org/io-uring/20230608163839.2891748-1-shr@devkernel.io/

Patches are on top of the current 6.9 io_uring branch.

Changes since v15
- Rebase on current tree
- Various cleanups
- Rename NAPI_F_NO_SCHED to NAPI_F_END_ON_RESCHED

-- 
Jens Axboe


