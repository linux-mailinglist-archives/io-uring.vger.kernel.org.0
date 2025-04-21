Return-Path: <io-uring+bounces-7598-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1842DA9538F
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 17:26:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0651E3A41D3
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 15:25:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B36A21AAA1D;
	Mon, 21 Apr 2025 15:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MyJ/IBWF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B62A1494D8
	for <io-uring@vger.kernel.org>; Mon, 21 Apr 2025 15:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745249167; cv=none; b=tcb+SOV+6aPiGGYotsJMjJtIEaUTeKTgMzz1j4QdCzhVqcx2YNA5KguEzXlrKKkQPOYQJETZs5iuc/iizA/4xlOC/8Ff6MdnBQQWJUKw08hT6XQl/aQgrZNLbLbGE+2Jd2Fy/jaCeKqMVyN0McW6mp3nC3WBvTYKVkcrP9B619I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745249167; c=relaxed/simple;
	bh=9EMkpSKW8fzETSRQ49tgF+F47BhYIMYLswgp48NR4mw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=uFC2KpXOxGldvbR4oalJtqTwe7YANqbQYvTi85bGeFjhqXwelfYUhgSjuOn2IqCVAQIOVYjRt3G+3+t+0Cva/0B49hR/VEK1K3k3RhAkkvWU0rcCxD75VicrAuaEny0hzcXlIUlRG2qmaXt3ne5N3vsibInqdGFch7F+gI07jwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MyJ/IBWF; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3d8020ba858so41598945ab.0
        for <io-uring@vger.kernel.org>; Mon, 21 Apr 2025 08:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745249163; x=1745853963; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aFRc734VYlCYJT6XePDlQIm770mvjLEX+yb1GziQFOs=;
        b=MyJ/IBWFVpVj1ARbked0OXVKbrCsgAW54bSC0zDt2AJsvxUIFImLuBMi+wGYhGNdCx
         VdsjObCeqPMykNkp7pqdO91uZX7aqPhE26IBfyLjtdRVFEFs5af7S6KfGwy7g0BF6y2O
         943qOSNKF6q+BuM/A+4E7yCeM3VpKeTcugKV254xcsFIePE2KTMBJaGH7StXCqPfbhW7
         umwPuFD3ocN9m6nXKuVc0vz9zz28dUmyBzrNWVtqbeXJulqLsPev6YLbqHM2IabS4wUD
         0FJPRF1LVgLtO4QvjSnTC9Lsz03rUfQQr7E+Q/8C2XVqOjnP2ms6pXmbzdva6qDlt5gW
         BJjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745249163; x=1745853963;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aFRc734VYlCYJT6XePDlQIm770mvjLEX+yb1GziQFOs=;
        b=XWgTktfHDsH38256p2iDWurMDGC9OJSJ/AMHzYyPAxwdHXt1BRQuGes1jtOFMP/V5d
         pllwUHbLKKMXZLwCYb7JkMjeoC62zIvaOD7STGzcsBsYXd+N/zDO4UhgKhd0nB/ox5UC
         KKoWNp5BS2RDtVIKgjKLcHWulXZGXE29GydM1p/jDtuSi/tVT2Apd93MyEvyF6K+tMem
         rj3iQhxyX8zoXiy+mr9Rg0TbjmRJR86OrbuVEARjvCTFRUN7sHU+foUoeDYWc087TvPT
         RCd7rYe+dTTjZjaabnDL3VJ2kmm1DHMkf8b+upfHmC3F/xiNvgtE+jam1C48W4DBPeBQ
         rqJA==
X-Gm-Message-State: AOJu0YwBdAx0fkD3mqC3EpqLyftUCL/XKfkVGLq2NDw8E1LoN5NuS3+E
	y6Oqm8oZeDRvPNzrxptvXjhKVkmuhZ1T2o27LJlmG4AXoLjv+NdzFzcK99qlJ4Wl708z7zJd9K2
	9
X-Gm-Gg: ASbGncvX+wVU35Fj94aVNEwo993sA5LHSJBxzIxbwibbMWw9lSFko/Hs4ssylDntSyt
	2yE4GXgNj6QpMJsVIUYyxS2fwi8leklEFJomMddlKARu0HpjpeFSuQEd3PvCTwJwWjSRZ1TUPC1
	0w9J0xC6XSKXUUhNkKyQETlGVR4izUnM3dRy+HxlPop1lYPVdyaP9jyGLoJFJ6PBrDU1+tvI3eQ
	2lALW1nkuUG1wVkkYMwtutICw1beuv3l0CnwBofTUgjtMqChET0JnVwoNEDeaMu65rSi7tTwYyS
	75bbp9JJRzBZTaUX/RP4RRsCuodRJrmphJajCku9aw==
X-Google-Smtp-Source: AGHT+IEU3Qbdh5aVpozvgJiAom/9Bmc0G4Q63BjPPsfzP91+afPISiORmReCYIeFnXJPOVMujU48lA==
X-Received: by 2002:a05:6e02:1606:b0:3d8:1b25:cc2 with SMTP id e9e14a558f8ab-3d88ed89722mr117236405ab.8.1745249162861;
        Mon, 21 Apr 2025 08:26:02 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f6a37cb943sm1816250173.4.2025.04.21.08.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Apr 2025 08:26:02 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>
In-Reply-To: <cover.1745141261.git.asml.silence@gmail.com>
References: <cover.1745141261.git.asml.silence@gmail.com>
Subject: Re: [PATCH v2 0/6] add support for multiple ifqs per io_uring
Message-Id: <174524916208.914665.2840674688077237522.b4-ty@kernel.dk>
Date: Mon, 21 Apr 2025 09:26:02 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Sun, 20 Apr 2025 10:31:14 +0100, Pavel Begunkov wrote:
> Note: depends on patches queued for 6.15-rcN.
> 
> Patches 3-5 allow to register multiple ifqs within a single io_uring
> instance. That should be useful for setups with multiple interfaces.
> 
> Patch 1 and 2 and not related but I just bundled them together.
> 
> [...]

Applied, thanks!

[1/6] io_uring/zcrx: remove duplicated freelist init
      commit: 37d26edd6bb4984849a71e21c6824c961fcd19db
[2/6] io_uring/zcrx: move io_zcrx_iov_page
      commit: a79154ae5df9e21dbacb1eb77fad984fd4c45cca
[3/6] io_uring/zcrx: remove sqe->file_index check
      commit: 59bc1ab922bbb36558292c204e56ab951e833384
[4/6] io_uring/zcrx: let zcrx choose region for mmaping
      commit: 77231d4e46555d30289b1909c2a2f26bcf00f08c
[5/6] io_uring/zcrx: move zcrx region to struct io_zcrx_ifq
      commit: 632b3186726984319e2337987de86a442407f30e
[6/6] io_uring/zcrx: add support for multiple ifqs
      commit: 9c2a1c50844265152b7011599a1a9dfe473d1f51

Best regards,
-- 
Jens Axboe




