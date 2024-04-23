Return-Path: <io-uring+bounces-1611-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 27ADD8ADB90
	for <lists+io-uring@lfdr.de>; Tue, 23 Apr 2024 03:36:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D184B1F22BE6
	for <lists+io-uring@lfdr.de>; Tue, 23 Apr 2024 01:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1812112E40;
	Tue, 23 Apr 2024 01:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="b502/hTr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E2DF9D4
	for <io-uring@vger.kernel.org>; Tue, 23 Apr 2024 01:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713836167; cv=none; b=ofzHROqoexAKGIg+QeYGjvmTkvyoHlIUaDMHoNtcL/xip0bZUKw4cFuetlBd2C86yJPH9aTq23ZjEmSH9HPgpiaxgMRIvGCm4f085GQYz0p2C2WrMzV2KBpBgCcuutZ2w7CFO/V/ruhgza9y/m48OgjyNd0AkRnLNOhEfnWWl/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713836167; c=relaxed/simple;
	bh=FzHzlKOYZu3jrDJtojwBIp3jG1Z4L84R0ebQ+R2aHlQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=qvsUUv6hUwp0/NwMA7RK+i1vI49ej1drnTB6R6PFD+lPuAAsQ9qv5WGNw7ou1OgBE86elrF1akOAywOLE7LFadX+VggNGbofULZfQdapEVJ6avbuwBW+VF6GR2Vn1WmJWsNqu0hWjXnWZpKJCmrbN41LzNP47zcZxpYqMYTKcYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=b502/hTr; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2ab48c14332so801514a91.2
        for <io-uring@vger.kernel.org>; Mon, 22 Apr 2024 18:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1713836164; x=1714440964; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s9oPaH/VV1Sgs6JhGxcg9NL/ZQE2v/wkBZW2pxzw1II=;
        b=b502/hTrpauQropwUYfnOS4g+CLIvcCqk6glX1AEYsrKayuzoQjrT6Yxtm0WnsL09T
         f6j6/mBlCAPfyoQDCID8x2r0CxGIjdvmTpYpDEcn5smlmGpcjfKYuxz01z3WDlOTej9V
         EDOdDBBbRoNEWCHaoJZbhsfIDXDyYJ+GHcJoDs4P6MGMxcTrlXAEizEoRLTigGU58rK7
         OZWiAGMy3lrZkpSmx989kaUGrZCYozxr6HWEDydMLBkc6IfJ+LiS9wYtauC59XC3YsAv
         PkCTDj331Op6E0OM8Xt8ZNvPHm2te9gClx5f/oRz3LqAHDK3FXKhrOrlojyrzSXPwY4M
         g/lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713836164; x=1714440964;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s9oPaH/VV1Sgs6JhGxcg9NL/ZQE2v/wkBZW2pxzw1II=;
        b=RFJT+j6jjg/hOV7OnakzPbihdkgZj1OUZUq1mjxCdZ8mqP6Ta6EMnN68RuI9CMWbMW
         Bc5Rr6me2NtEXrgZlPmyTNmUxx8+ytJT8kqpNnxlbR1065vKpP2dQ/UMii7N/qRetpKw
         NZLGDitAlC5O1UYSQ1tUyYpiixbF6ymeEFDvEBEYK5ELpxV4AhObfRhWhPP4Pw34ezUj
         DpFgtXqWUXdHdvoAfhZVIi7nOm7votqOILVJ9+oIpbMbLTm43M0v4wvjXKuXqUr+ieTJ
         C/x5FgP7yMkukAYJQjjAw5NWWlHMTF5VXzQtUnTp7yDK/GKhU4Iv3D1fmqAZTLY8DeBZ
         7BgA==
X-Gm-Message-State: AOJu0YxrM7Irs0W9TUoNDS40F9guJgIOlhl/MMNKawr0bPWiGcOJ4yOf
	yA8Aq7LynZbYJhbWXxMLV4WrJo8S6TL1p0vBx8jm9FHTNQTKnGHyGt5B59uLDyY=
X-Google-Smtp-Source: AGHT+IGzlYpawNDmZcr5CUIaLSVmPzj5i1QCymzAQ8rNfxRGM71jaLD4N1FTIjMDD+MiT7VbGVUzTQ==
X-Received: by 2002:a17:902:ec84:b0:1e8:4063:6ded with SMTP id x4-20020a170902ec8400b001e840636dedmr14042378plg.1.1713836164318;
        Mon, 22 Apr 2024 18:36:04 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id f21-20020a170902ab9500b001e5119c1923sm8777775plr.71.2024.04.22.18.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Apr 2024 18:36:03 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, netdev@vger.kernel.org, 
 Pavel Begunkov <asml.silence@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>, 
 Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@kernel.org>, 
 Eric Dumazet <edumazet@google.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 Jason Wang <jasowang@redhat.com>, Wei Liu <wei.liu@kernel.org>, 
 Paul Durrant <paul@xen.org>, xen-devel@lists.xenproject.org, 
 "Michael S . Tsirkin" <mst@redhat.com>, virtualization@lists.linux.dev, 
 kvm@vger.kernel.org
In-Reply-To: <cover.1713369317.git.asml.silence@gmail.com>
References: <cover.1713369317.git.asml.silence@gmail.com>
Subject: Re: (subset) [PATCH io_uring-next/net-next v2 0/4] implement
 io_uring notification (ubuf_info) stacking
Message-Id: <171383616279.27114.3831538607187347697.b4-ty@kernel.dk>
Date: Mon, 22 Apr 2024 19:36:02 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Fri, 19 Apr 2024 12:08:38 +0100, Pavel Begunkov wrote:
> Please, don't take directly, conflicts with io_uring.
> 
> To have per request buffer notifications each zerocopy io_uring send
> request allocates a new ubuf_info. However, as an skb can carry only
> one uarg, it may force the stack to create many small skbs hurting
> performance in many ways.
> 
> [...]

Applied, thanks!

[3/4] io_uring/notif: simplify io_notif_flush()
      commit: 5a569469b973cb7a6c58192a37dfb8418686e518
[4/4] io_uring/notif: implement notification stacking
      commit: 6fe4220912d19152a26ce19713ab232f4263018d

Best regards,
-- 
Jens Axboe




