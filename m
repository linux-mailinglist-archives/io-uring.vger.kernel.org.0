Return-Path: <io-uring+bounces-7935-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F0D92AB16B6
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 16:04:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 316A2525865
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 14:03:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28B692918D2;
	Fri,  9 May 2025 14:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XOmUu07I"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312EE2AC17
	for <io-uring@vger.kernel.org>; Fri,  9 May 2025 14:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746799339; cv=none; b=Q7mkD1DTFh5IrIMhOofz2ntWU1cLhyNGeiIt+QXd8PB4vkyHJ52iBESJL8wKYvtQbYs2cuKg4fkrgIJ1RLqFNE7STLySxzq99DQNXyJc+SGntk0cCGB8RVTimdFABValBYW1cA/Icr+YbwFJQgjPnJ3prutXXDFa+iYVFv3Ci0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746799339; c=relaxed/simple;
	bh=FxyioeWiFKnwaYwHzSNLOCNd+1GLmrC8TTsOsb5sWW4=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gFBFkP/hgxgZ3wi1KDmDhWNuyZ9mtT3ruoeGyvGWnhuAAHUeNGB0Q3Ns4zWhIqJ+w7BYiAcJn1ZnloLYW2OEOAl0B0l1r/w+XPYVEl+CpyVZDylcDa1ugV9HQ3XIW/kaHW7b0saI++Yr3Wghjam9Z9/HaEiXci27wRmMykd6Y/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XOmUu07I; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3d90208e922so9355295ab.3
        for <io-uring@vger.kernel.org>; Fri, 09 May 2025 07:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746799336; x=1747404136; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xnPkkXHFNNzDarqXu+Xmhnfv0h5jl1jng7gj2Ce+fyY=;
        b=XOmUu07IIaf9umiyyw1i4JvcXQmbdOOIg1TvEMVnuaLQYHPpyxe6ewJxpkkbnIaomM
         lNQVq44b86rcwfzMkxpypIraH2CPYaBsdgC7w06Che469ZU+KTh+rwJIVWpshYpywSJm
         pr91Ws/J6n4H3bVH9QqrentCw7CRxMa0rcyEGkC+OUhipZW6k2GLFAH3UMTTltW0AQ/t
         mKG5lY1/hf8XAX0BKJob34ht61p0l3dK+nNBdsna/0HXZUehuWRdaCTEqx1mlaNQBJEV
         2syfeV5xnzF+z2DZ/s/gFKc+L6HDV/4q5s5acDh8jFeClhy1im0d+T1+SBqvl+xDMjnJ
         D2Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746799336; x=1747404136;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xnPkkXHFNNzDarqXu+Xmhnfv0h5jl1jng7gj2Ce+fyY=;
        b=a+85hgxKKpUbDkhHZOMDX06fXoDCNDxEt7xsGTgb9h6EG3Dkazqk9o++U2lglwxlSw
         q1pE9n/vD6BLFs2XJnLeE4fopyR3CG34eTmhTEkk5HHgJEpiSa1FodltidHddFUb4Kt5
         G2YJ2vN7CBP1UEiDnbnHX9xTvi/E1hiGImofjTp4VuxHpuYjJ5nduwNAhHUIf+SXMeLg
         9gkR6qhSNbVg+L4lljPfAHHTSyLifFqVar3W/u3/jWpU5TbDXdFA8Y0JJ+4E3aWhZtVt
         bB/DVEEnGLaux4zT10ILAh3WqTA9F2D9/GTD+KcnNlVx9chYZUwn8QUjO1gml9SpICk2
         V7nA==
X-Gm-Message-State: AOJu0Yz/HzwZmX4nr4pq0+KAgL/InM3cgfZJoZdDXC8SXm9wkscgLKAi
	qKZsfBCFDo3RAtAPj5Wc2Ew5wAuLIUlLqqNr/Kh2cuihBXxk2GJ+6Y6ci3Jj8dw=
X-Gm-Gg: ASbGncvny+F/8ZeemmobQ0rQy+rPK6Ac0T7GeypM7XBltnedDHzaeYjn09xyxAUBlPi
	0msFMAMK9sd6kQEQBrqqhFBM4YTkSP83vmmRR5XaHuTr1sWOV87/EjK9N4UklTK2klKHXgj2xX6
	2Ax2jaO0dX1yxVY/4MvLiHtMgBKSczn7XlTqpdujr9GZPH7jf6QBb6gFtrP6Jk7FadK294cJFcg
	1eoucZAPtn3816oGCmVC8gCzo+XZjJ6E8S7WNHdFV7cBfOrtgptwJdtP4kZcEgc95qvRf0ijcnr
	qYHHpPirUJGRpbhUoPqKnAimWS9lQlo=
X-Google-Smtp-Source: AGHT+IFnCN+khQzgBzp4m7Q6FUn8t51BnHuBG0pEwg5VCTYjiZiXeczMyGqTiJdGUgD/EvPRzJw/XQ==
X-Received: by 2002:a05:6e02:18cc:b0:3da:71ea:9a59 with SMTP id e9e14a558f8ab-3da7e1e7c26mr40615605ab.9.1746799336144;
        Fri, 09 May 2025 07:02:16 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3da7e113335sm5768685ab.31.2025.05.09.07.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 07:02:15 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1746788718.git.asml.silence@gmail.com>
References: <cover.1746788718.git.asml.silence@gmail.com>
Subject: Re: [PATCH v2 0/8] allocated requests based drain and fixes
Message-Id: <174679933531.96108.10631131708078512498.b4-ty@kernel.dk>
Date: Fri, 09 May 2025 08:02:15 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Fri, 09 May 2025 12:12:46 +0100, Pavel Begunkov wrote:
> Patches 1-7 are fixes and preparations. Patch 8 implements
> draining based on the number of allocated requests, which
> is simpler and remove cq_extra accounting overhead.
> 
> v2: fix executing still drained reqs on spurious calls to
>     io_queue_deferred() (Patch 2)
> 
> [...]

Applied, thanks!

[1/8] io_uring: account drain memory to cgroup
      commit: f979c20547e72568e3c793bc92c7522bc3166246
[2/8] io_uring: fix spurious drain flushing
      commit: fde04c7e2775feb0746301e0ef86a04d3598c3fe
[3/8] io_uring: simplify drain ret passing
      commit: 05b334110fdc85f536d7dd573120d573801fb2d1
[4/8] io_uring: remove drain prealloc checks
      commit: e91e4f692f7993d5d192228c5f8a9a2e12ff5250
[5/8] io_uring: consolidate drain seq checking
      commit: 19a94da447f832ee614f8f5532d31c1c70061520
[6/8] io_uring: open code io_account_cq_overflow()
      commit: b0c8a6401fbca91da4fe0dc10d61a770f1581e45
[7/8] io_uring: count allocated requests
      commit: 63de899cb6220357dea9d0f4e5aa459ff5193bb0
[8/8] io_uring: drain based on allocates reqs
      commit: 55c28f431651973385c17081bdcdadf8b5c6da91

Best regards,
-- 
Jens Axboe




