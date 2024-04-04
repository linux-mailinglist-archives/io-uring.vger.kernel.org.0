Return-Path: <io-uring+bounces-1395-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54CC8899309
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 04:16:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 838F61C21C5C
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 02:16:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B7D8FBF6;
	Fri,  5 Apr 2024 02:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hD+CAJCg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F76AC13D;
	Fri,  5 Apr 2024 02:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712283399; cv=none; b=mOCoGUz0P591HU+rdJb1IhZabehTcqxkGFeAQoX84PVfRFw9JqrHRznuSGA19NnZOFZGxmVswpEPUaWVinV0qqC2yOH7Ozk1Qi3bOb61OuF03zU+Tdt/GyK+i46+LWM+pzG04hC1AwlcdMqfDWgjQGVper5bktjIGTJ1RdkKHvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712283399; c=relaxed/simple;
	bh=STPVYoPQr3IUpl3V11g5YGSOIYs+skD4DTzlIbgQUPo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=EIguLoScvaOX+Q7qgnQLYLKt4QxbmOqQ0nfEpl8lmmEf/z/214tw30VqdZWhmD/6NHsLnMbTa4TIcVRFHeQ1c4K/gopzwmnzwdE+g8QOrCIkyHY0wY3J+epgcSrQnMzlGzTri46Z1gNQpAjKWK8hIVolE6AAmzlTy3rMU3puXgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hD+CAJCg; arc=none smtp.client-ip=209.85.217.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-479d6a85be8so184391137.3;
        Thu, 04 Apr 2024 19:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712283397; x=1712888197; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lZ9R5uibYBrT2uu3N8NZ5MqGVHwCm+hOT4GQItGAlZk=;
        b=hD+CAJCgNQhzMvsT9nLFy37RiF4OX/t0W1gKIPOHRcnjzxflvRJzxRpXEN6FbLw1nk
         WevGjseKPGIhxawJYTuVmZ1Xf572TRhoQHBGniJqK/gNVEdjXBatnBlDEhr/1MlCWU8y
         Bbyp/MrHvjr6bFxcXm/dsuq4F6hx1MGv0kdStba0hQ9a+L+wJohW1NMZgUdyLQHjmeQr
         ibUhnb5rsw8Oe/2tgIpEW3bZYGiprCKMCd22/rNdg2rSyGtyMeuh6SFzf68skC0Y+ALO
         Fd9SRLTPDfczDEqvBBX8GK5ax2l1oQxMeObaDzIMNHelOvVKZ2z+NrhcS+P6DTej4SVp
         zExQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712283397; x=1712888197;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lZ9R5uibYBrT2uu3N8NZ5MqGVHwCm+hOT4GQItGAlZk=;
        b=fYGBwrNtqV6douL976uLx+G9sUswGPp59YgUEhRoEfVf8/DD5eRV0ZXHGeZvgmMM+q
         CofWqQzM7QyZB3zTeiP9fS9kgDtTv4yZiXUBVLjRnIbT36hGboH5FHMgS1UC3I5RYnZl
         fTQtDj2dObtt5nornmovQt92V4ZjYSV0DIXXtIbtxxN5Cjmwq3ESQKFlvPE8J99qZMhQ
         hqImazBQ2s2oGRVINRtgQUX+anrGeOmW+UzKGEKSvnuL5DcrGNmPSE6Cr2rLPW6b3cor
         Q7MoJDSxn9Ol0oBcZw3pn4RvZ7E09HkkRGax2uoZ/6CPmPlsGacdQB4MkZOmdr/HELrz
         sBbA==
X-Forwarded-Encrypted: i=1; AJvYcCXa3Deig3AcjnCiVKXFrVS2TD+EeqR4BnSP4KoMo8WL22NkAJPTn8fc1thbXXGazD1N3QsSbLL5o0qggZdYeMXsx67tYlXz6pj+885deqxT3sYSOMEcMWByZeX7WUYi9e/EXmSqOLY0hyEeGwiDot0Z7o5KFoAK1pb5IwQxp1FTIwBDdgMj
X-Gm-Message-State: AOJu0YxmPscj6Ysl6J1w4ZjvtzyWhHqW59SZytu7e5a5gz1Hk65vLySx
	bMkDqSIbTHeMxp/NvwUA4iDT/0ERaWm9pDW+4ESm/QCX2gwBudzY
X-Google-Smtp-Source: AGHT+IGgL1UJiFk/I77NlkRd5fRGkLlGcjB7Ly+1fspzFVhYBaHuOXRPUsNTiXFrNYAheSSW4Gddgg==
X-Received: by 2002:a05:6102:2acb:b0:478:855b:52e2 with SMTP id eh11-20020a0561022acb00b00478855b52e2mr257138vsb.12.1712283397421;
        Thu, 04 Apr 2024 19:16:37 -0700 (PDT)
Received: from localhost ([2601:8c:502:14f0:acdd:1182:de4a:7f88])
        by smtp.gmail.com with ESMTPSA id s12-20020a0cf64c000000b00698705a47c5sm249064qvm.103.2024.04.04.19.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 19:16:37 -0700 (PDT)
Date: Thu, 4 Apr 2024 18:16:38 -0400
From: Oliver Crumrine <ozlinuxc@gmail.com>
To: axboe@kernel.dk, asml.silence@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, shuah@kernel.org, 
	leitao@debian.org
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Add REQ_F_CQE_SKIP support to io_uring zerocopy
Message-ID: <cover.1712268605.git.ozlinuxc@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This patchset allows for io_uring zerocopy to support REQ_F_CQE_SKIP,
skipping the normal completion notification, but not the zerocopy buffer
release notification.

This patchset also includes a test to test these changes, and a patch to
mini_liburing to enable io_uring_peek_cqe, which is needed for the test.

Oliver Crumrine (3):
  io_uring: Add REQ_F_CQE_SKIP support for io_uring zerocopy
  io_uring: Add io_uring_peek_cqe to mini_liburing
  io_uring: Support IOSQE_CQE_SKIP_SUCCESS in io_uring zerocopy test

 io_uring/net.c                                |  6 +--
 tools/include/io_uring/mini_liburing.h        | 18 +++++++++
 .../selftests/net/io_uring_zerocopy_tx.c      | 37 +++++++++++++++++--
 .../selftests/net/io_uring_zerocopy_tx.sh     |  7 +++-
 4 files changed, 59 insertions(+), 10 deletions(-)

-- 
2.44.0


