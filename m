Return-Path: <io-uring+bounces-1953-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 58ED98CD82A
	for <lists+io-uring@lfdr.de>; Thu, 23 May 2024 18:12:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 104AA280E62
	for <lists+io-uring@lfdr.de>; Thu, 23 May 2024 16:12:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 485CE10A0A;
	Thu, 23 May 2024 16:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wHRx80X7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59048F9D4
	for <io-uring@vger.kernel.org>; Thu, 23 May 2024 16:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716480727; cv=none; b=Ck65MuTi8gf+HLZaDfeLA820ut2jRTLXry7CbgCYThq/Gs8zX1bUcMoJpPxOlNXnSJnFpiGmYMFthq1zQLOZNUnA5Cdi41P5l8e6pQFqhIJwlAbBPuAbLWOI0CJC+uEC7ebH8CdIl/D8wv1A/0ejP6YdmoKMPk4XW8Xlc7COC4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716480727; c=relaxed/simple;
	bh=GHPo08DDxBFpiFwbuaAK00FkUlMuSQpcwkCXD5nq1q0=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=k+ak279a0KjT8sXhrDpOC6CmCtkMEk3Yo/8QwlDxmtDPtj6tOjy9QVom1UqauGMJQhmzeIKFqEjxm3JjcKj1onseuQ4wr8ZPAppjhHhBkDgISTPd2CmOV2eUNWGrnsbgdRdkgNQCvqHu1o6Je4jN5GZafHIK/dAmj6g10plAH70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wHRx80X7; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3711744c61cso2280475ab.1
        for <io-uring@vger.kernel.org>; Thu, 23 May 2024 09:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716480722; x=1717085522; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iXm159xaA8LoWVmBm625cmzgk9ag6Blas/C2pc9APlc=;
        b=wHRx80X7WGx1DUzW8ffwXbuR52aFuWCQVMv8WcERRIDq6g96xHzFxpj6e96v/js0BH
         QmTj2xWoLmpf7TVfe2T75LrZ1FnVJ9X4UZXfzxnM94dJH5ssLuwaI1ksPbhPv1sMHZvA
         mxm/ltcf6DJuuUddFavX7I/yNwgisVg7t0t35bZT8+cZl+kWwPZR3K+iY2g4PCAaZaSu
         5Bt3LNfsZuQIzVic4Y5h1m7L3DtfmK5pGBz4yWAitXfBm6mx678XAIQNAdRoLNC0we5w
         ZCF20wNSdYsQdpT636zbVQfc8e0BqVfXUvWZZ7RyKQc/kT9cQSXLMe/U2hy0h5ZGXhP3
         G9Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716480722; x=1717085522;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iXm159xaA8LoWVmBm625cmzgk9ag6Blas/C2pc9APlc=;
        b=Cq1fFmThfoQR7fFOXQey+cGxNsYanOclu9GBENA/fzWIhai458Gv4GMZnVWNSWxAMi
         sHkvV9j0UX/QUrp9QqPptHLONilWb/c/YdmqVKmrSXKk1IMl66PMFk5T+vBN2mziLj3L
         dDchEP/oUUZnfBhu73JgLLhbqMmy3sQFwQcRKkTV8wWPtcj/cdbkkfE8/B5tCP0IwIaC
         MiuTEHudahdJ2NX4EqOJjmnG3XRobWDX8yFZs1u7LBX2w/nxAR1i7ywmmLkSbinRPhVx
         Yj8+5th97wx4XbaFd9lnKo66IvUOb5tWjujyCyiyVzTkS2A4Q8zhMoI1SLYmnEgAOZKX
         +3uw==
X-Gm-Message-State: AOJu0YzP1QvfUBoIDcv2crxIGGwYYugisjR2yuuUOuuT1qdReUnScUTg
	g9+yifRC3SfLeXihrlCMcedJQvMMYl9wGJZd53uObovOUCnevlXPhwSxJ4JkVFPxcfcNQUj0RG2
	t
X-Google-Smtp-Source: AGHT+IE5THG7h5c8WdE32BmaSmU/GFnrvK5JRGRRIUb8oryntBmZ3GErzL6ji+h7MFOELC9fgaUoPQ==
X-Received: by 2002:a05:6e02:1fc1:b0:36c:5440:7454 with SMTP id e9e14a558f8ab-371f6e0ddecmr59570595ab.1.1716480722457;
        Thu, 23 May 2024 09:12:02 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-36db7900ac5sm48255425ab.27.2024.05.23.09.12.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 May 2024 09:12:01 -0700 (PDT)
Message-ID: <986ba297-eb14-41cc-ba16-b74062ff3470@kernel.dk>
Date: Thu, 23 May 2024 10:12:00 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.10-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Single fix here for a regression in 6.9, and then a simple cleanup
removing some dead code.

Please pull!


The following changes since commit b9dd56e813af002f45f6a494414d4a05dfdaa30e:

  Merge tag 'soundwire-6.10-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/vkoul/soundwire (2024-05-21 11:23:36 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.10-20240523

for you to fetch changes up to 547988ad0f9661cd9632bdebd63cf38e008b55b2:

  io_uring: remove checks for NULL 'sq_offset' (2024-05-22 11:13:44 -0600)

----------------------------------------------------------------
io_uring-6.10-20240523

----------------------------------------------------------------
Jens Axboe (2):
      io_uring/sqpoll: ensure that normal task_work is also run timely
      io_uring: remove checks for NULL 'sq_offset'

 io_uring/io_uring.c | 6 ++----
 io_uring/sqpoll.c   | 6 ++++--
 2 files changed, 6 insertions(+), 6 deletions(-)

-- 
Jens Axboe


