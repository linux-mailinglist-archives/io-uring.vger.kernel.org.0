Return-Path: <io-uring+bounces-10091-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B7E0BF8FE0
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 00:02:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F93218A610C
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 22:03:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE8F917A318;
	Tue, 21 Oct 2025 22:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SiJzU5mY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9EC928152D
	for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 22:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761084152; cv=none; b=INZ8snBA9DB/2k3W9v29ga07pooPlpgu9HU1wojGAZ8O0EYXtQYP9KcfKrvi364/LOfutkuPAwINWR3MIBP1BLiHddOKDoP3cZ0D1pkJCNhjMDRq8LTiHFkAoJCk/PpPXJBD9i3cK/xQYI/h0qJM2PxSmY93JBLSZ7boJF1RAts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761084152; c=relaxed/simple;
	bh=D7B5JWV13vlXOvM2J0yDwCP7ALf2dedGvi5jHCaJkdY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=j50wO3VNbObBKHsmV2pThjV35m9WZavLlvvhztjHdS0DoOJOdk8RJ0vrZne6D3Dt5DojTBBbxSmuXyi2dPX75epTw217Zx46cB/ClIqj3iwaRdtMU2WB3cxEZCuHIX5f+Py40wZdQSLHFuVJ/gXU7EKgfx/ZzvRjptZuUjqCTek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SiJzU5mY; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-930cfdfabb3so18241939f.1
        for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 15:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761084150; x=1761688950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r2SeOcabNhy4dThgmIl43SbgLfDG3ixP410caIy3cuY=;
        b=SiJzU5mYosrls0K0aZURM1vKxNRGdPaR+qanEqOtIEMoZth5J5lD+YCz9CXPFhtt4A
         tTOhUT1lCKo5fR26VoW6iqq21VHCqVZFGF+KMx6MN3A+SPJ40cMjqQLsgPrbrgVbOa7Q
         uClECEg4EM0UqsJyu1T4HZ2en9d0no2ENh1UWN7ylMZXF3bSmppHk2q7hneFZICGET3h
         LXgzN103i7s5CFYnbFA1ZXx4GIimMXPNPfGcW9bEaj7abNdhDN4HbUkvvxh4DgjtvRHQ
         JCwUlNy1BgpdVkOmcJPf2IyUPF0DHtq6cgR68/yNuWCFDhgM8ibfBdg8EFt62aymWgAw
         7gmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761084150; x=1761688950;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r2SeOcabNhy4dThgmIl43SbgLfDG3ixP410caIy3cuY=;
        b=A29RbH6XwN33v1E/I1YySh1GgMhYNtmfJNdjChHA3upsK1nn5QUu+YmhHFK8J+fYPA
         naYb6jk7mdatfl8WKgVB9LVCQxBnRUb9B9QsE2FUFY2GiLWpUb7FxONmoK7cn0qAGx0v
         GPtKJGZ9W4kpUiYOhuiJIo3i13edjAX+D4wdBxRvIr6xU6DNXfBmE3HrGyRjVLIz9Fxw
         cJgnW12sHa0xDhMkFdeTQAyHBKcS+hD3kWzO9Rm7Oy/Z37ioliRZmCfmED32v/H8nRty
         y56uV7kMgdT0f01x52e/9kFiqkbx+ZHxiNuL0u53kL8e6e6Nt0zkezjKYtfP3Nm2Vovk
         tgaw==
X-Gm-Message-State: AOJu0Yz6+tvg0dTJg9qVbgraKPrLJ3GSelxallYJH2eYSfnz8E4CIo+C
	frRl+zYGRp3UVr7eI5cKtaOu53Sv/bZ3oau0Ve+Vb1ixIuD2xxpRx/4AYUTIpjXp6jOlJxJaXjz
	4P49Il0k=
X-Gm-Gg: ASbGncuaPwv5G08IFMF4zK0pcjSYuIJXPU6Dp9lvNnJ1MMdhv6/cRipboXB3nQlfS+Y
	9gxdAT/Lzk+jZZx4n4Vdl1d3eLEdQPZa1O4uBwxkcpLpFcFGk3fzk+iy2XA+gsVQh650+FY22y8
	ZXSoOWHYjOMTb5LKFvS9Ddq0yXULVU9L5VAjhFlyaBbQGbpEHVMe5g43JudoS+Z755tNP2sRb8B
	sz6W/4omZMafaQJ5nu1aPzDtrhLl4PT9D/gUBd1w2Q2HMkKPujGOXioq4gaY0XSfivx4qim6F/p
	tb712C5nlEeM5rJLKN6YOrgluSnS2xe9UJo24XeoqadAFTmGWWM9lsdIPqVu6QyZu9q7G+HZtO3
	+6Tkm6bvX9Oel8+7DNzh5vqi8ByJnX5S2UK1bQ+d1+KsdVtOQYW2IA/5zl1xPNkHMA7WqbXiHqo
	ciYK4=
X-Google-Smtp-Source: AGHT+IGMc7QACfWkkDV1tJ6pAEg3FT6041B6x17J2CCvc2XxQABD4s0Qd0Grne7IrYvlFBR0yWkFMg==
X-Received: by 2002:a92:cd8f:0:b0:430:b004:3d5c with SMTP id e9e14a558f8ab-431d309940bmr22459395ab.9.1761084149654;
        Tue, 21 Oct 2025 15:02:29 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a962f04fsm4462656173.21.2025.10.21.15.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 15:02:28 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, csander@purestorage.com, 
 Keith Busch <kbusch@meta.com>
Cc: Keith Busch <kbusch@kernel.org>
In-Reply-To: <20251016180938.164566-1-kbusch@meta.com>
References: <20251016180938.164566-1-kbusch@meta.com>
Subject: Re: [PATCHv6] io_uring: add support for IORING_SETUP_SQE_MIXED
Message-Id: <176108414866.224720.11841089098235254459.b4-ty@kernel.dk>
Date: Tue, 21 Oct 2025 16:02:28 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Thu, 16 Oct 2025 11:09:38 -0700, Keith Busch wrote:
> Normal rings support 64b SQEs for posting submissions, while certain
> features require the ring to be configured with IORING_SETUP_SQE128, as
> they need to convey more information per submission. This, in turn,
> makes ALL the SQEs be 128b in size. This is somewhat wasteful and
> inefficient, particularly when only certain SQEs need to be of the
> bigger variant.
> 
> [...]

Applied, thanks!

[1/1] io_uring: add support for IORING_SETUP_SQE_MIXED
      commit: 31dc41afdef21f264364288a30013b538c46152e

Best regards,
-- 
Jens Axboe




