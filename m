Return-Path: <io-uring+bounces-9111-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48659B2E4D3
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 20:21:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9119E5C1B93
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 18:21:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9160427A91D;
	Wed, 20 Aug 2025 18:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PygJm4W5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344E1261B81
	for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 18:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755714054; cv=none; b=ssVGtX5Dbi0I8dyJ2hDbUYC9x4hwHpITDOZUWJ/k9EOPxJ1mm171ynGp/2RZLv2e+NzBkgyN/iXCLNFSAzBaZ/3LXh08bCEWjYQT7WwURG50x+oEcJif+ArW6OgM0e4aDVQ7krITWn9sBnGe70zpDjIxoDnQ4UsTQ6JGIwwodck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755714054; c=relaxed/simple;
	bh=BY4/HssqVhG4++j2CoUFVrXxbqLpvQUftWnonjc722I=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=U/L5zMTunhN1qr0y86RuZkcfVcvI0oPJB0NI+fg65+Sn6XFNyhQhYJzboisGxnChbKrD6oCGW1AmJsDBXy2qrfUnNWKRvu4NxnWXwi+TKVXzCwY0YQlnK5dLwvY6fPMBWTZTfYcmUaiH/jFUCeYOc+ZfJ8zgpz1f2hDjgNWxQiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PygJm4W5; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3e671afa78bso955745ab.1
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 11:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755714051; x=1756318851; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5jyop/hDWdfUNbD/69gtPX753LTs562RaQLw2lgTZEk=;
        b=PygJm4W5ZYs8BTqid1FPMMHwjOfTW0377AmRSm3NiOeGomsoIQlCy1pA8nGfUqnIoY
         GNKDBXGxQvSUyRai8UbX3VzTFNSNwocpr9x+e7g6Q2NrmPGzrH1utahZvL62QODU5Wpg
         8Ht18P3u79TlnEvLaqVBvumDQgUhnNQgn5q2tYjoWiUxA5zi8kgdQ/FOxCqcQ2HwHY5q
         iqr1rNeceo1TTPQ3JZvu+Zs7lxjXpjV99wy1yJ+lth1fuvZ2zEAl7pO0WpgaTtqnbg1z
         VCL0g4wdH7JZiK6FSvZ2309gykg5TYkjYPl2INYTWg+sgQK81xkfvIA52LvpD1Zefhw9
         ypwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755714051; x=1756318851;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5jyop/hDWdfUNbD/69gtPX753LTs562RaQLw2lgTZEk=;
        b=I8m5KCMBNxIndM6J3ENrRLbLuNCnk/xWNUbtl+o104MfxW3R7tA4t06CJglupToN1M
         Z5IOEe9NTV4lxl6jl/Y+nu7c748BTxDy/KsXZiSMYyctMqOKbUxaknVItMYQE5RAyP9I
         xt14eyJ9Zq+/34/17nsgtEwO37nsU7pTVYEMXr2ikf2b/0tYtCFS6oa0uU1+JA5bstJO
         1v5NAuO7fNE34ipcAMHIzI90MlLYJ92jlrStfiirvDT/WwnXHVPtFlqRFXA7csOL9Sgu
         c53RhQDuMPwuZTzFRSMb6x9rX6aph2lujJIpygJtvMtQ/s0vyhC/FA0RLNAAlYm+fPeM
         buLw==
X-Gm-Message-State: AOJu0YyN/9wDlOKiS4ocfFLkISSojauqjzCMzIv0OBrRS1XwoI6jBcVf
	xrFNg8SOjgxxGSJ+qZiNYMIvKmy5c54z9WAKcT3J2ffLMewB1UC/FksTn3kuoVC+9wxgMTC6G5b
	SfcCz
X-Gm-Gg: ASbGnctw7ag+YE95552HUDYRSCmxUvsmlmgr2wEYt8/HPnsOxdukLCJwCRKQYmvD7PN
	9ncsJI6OO2ByMD9fOa710J50ndk+4auVY9TsWsJn95+ljO4n33bjFU3vgwE2u53QOFB6b25fvhS
	WFiIeC6zljLVzxNbawsr/lsaRp4rCb6QxXTOCjcV14cpmrcrd07/oVO0PDDEAKMIldhjl0bBFzn
	3StwiCYGgiR9J4iQuEUIrDtUkyWMdFvij7FBHkEcMPZgXqnZwCNU09ygIZJuMWgjHpLiXLaVt4q
	TApf0zWZdHsDqQrDqErcRjUuVxMV5QCO+sqwQZy17gkFx+l82l5/seM/n+YIovPDjCx/q+OVXWf
	xDhYD4Aj2veCS959x97TE34xvBpYVg2SxFlY=
X-Google-Smtp-Source: AGHT+IHj1lY0oZhu9+f5QKvwNA0ZQHTGajzgtTp86E5s6oDHrru+NJpTHDlXNAE2GFJhWGMuL5Z9BQ==
X-Received: by 2002:a05:6e02:2304:b0:3e5:3520:4a76 with SMTP id e9e14a558f8ab-3e67ca52d75mr64712635ab.24.1755714050720;
        Wed, 20 Aug 2025 11:20:50 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e58398cd34sm50335665ab.20.2025.08.20.11.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 11:20:48 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1755467608.git.asml.silence@gmail.com>
References: <cover.1755467608.git.asml.silence@gmail.com>
Subject: Re: [zcrx-next 0/8] niov sizing and area mapping improvement
Message-Id: <175571404820.442349.2298884067112481853.b4-ty@kernel.dk>
Date: Wed, 20 Aug 2025 12:20:48 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Sun, 17 Aug 2025 23:44:11 +0100, Pavel Begunkov wrote:
> This includes a bunch of cleanups deduplicating area type handling,
> and Patch 7 introduces handling for non-PAGE_SIZE niovs.
> 
> For a full branch with all relevant dependencies see
> https://github.com/isilence/linux.git zcrx/for-next
> 
> Pavel Begunkov (8):
>   io_uring/zcrx: don't pass slot to io_zcrx_create_area
>   io_uring/zcrx: move area reg checks into io_import_area
>   io_uring/zcrx: check all niovs filled with dma addresses
>   io_uring/zcrx: pass ifq to io_zcrx_alloc_fallback()
>   io_uring/zcrx: deduplicate area mapping
>   io_uring/zcrx: remove dmabuf_offset
>   io_uring/zcrx: make niov size variable
>   io_uring/zcrx: set sgt for umem area
> 
> [...]

Applied, thanks!

[1/8] io_uring/zcrx: don't pass slot to io_zcrx_create_area
      commit: e205db1eb9596e6e7d9ed78882d4c47c8448c2e5
[2/8] io_uring/zcrx: move area reg checks into io_import_area
      commit: ff9d7473a29a241491fad2b9e0e2de6671556b4e
[3/8] io_uring/zcrx: check all niovs filled with dma addresses
      commit: c6c489577c004b65734f2d59a9c0da94c8bd3187
[4/8] io_uring/zcrx: pass ifq to io_zcrx_alloc_fallback()
      commit: f37d7f9b092274a33fe40b58b05327a82702e936
[5/8] io_uring/zcrx: deduplicate area mapping
      commit: fc8b5f573a2fa1cc5e7347493687229557ebd013
[6/8] io_uring/zcrx: remove dmabuf_offset
      commit: 1228c5129dd5577e1b988f85915e63d24b99ad92
[7/8] io_uring/zcrx: make niov size variable
      commit: 16a4e2d99220fd844efcf6d34b4d954912ed8d35
[8/8] io_uring/zcrx: set sgt for umem area
      commit: 14fcac7a7cec83e4ed15538103ef6c51400c559c

Best regards,
-- 
Jens Axboe




