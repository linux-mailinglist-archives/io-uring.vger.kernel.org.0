Return-Path: <io-uring+bounces-2671-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 194FE94B513
	for <lists+io-uring@lfdr.de>; Thu,  8 Aug 2024 04:30:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D7531F21FA6
	for <lists+io-uring@lfdr.de>; Thu,  8 Aug 2024 02:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E4FB9479;
	Thu,  8 Aug 2024 02:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PKdX7yB7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AC828EB
	for <io-uring@vger.kernel.org>; Thu,  8 Aug 2024 02:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723084222; cv=none; b=SncMafxNxZcOwESyW+IUG+26VP+M9nobD50zXxx64kC1lbw9ReVss1jQ3otRh/ZCcti0++/s1kHMixgMdTHPRdTc2BQMo2VIHd8xt75in5GFzV4pUrOMyD4Yd3zkmibOzy/q+WvGEhB2E2vciUnLVNy4eFQhyW5dEhWG1ZZy5Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723084222; c=relaxed/simple;
	bh=1fwdX/rv8fdtWfGEn4Kr0uWMpxfZRhieuJhzbcNhoZ0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=e7MJRleTswl8+P4tI4A8v3OURScSvnTbxIMLsxPfTiq7Oa8w1o5ub7LHAdxTrUkblcUD80dyS0syTsc7g9iDrkGF7As4/ob2kSgWLIH7lCXFO/ah6kaEIkoe7fXZSC3pjS6V7U9+YZ4KrLDBmbwkSJbPBH4TFV0Pnkz1sllgtZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PKdX7yB7; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2cb80633dcfso99179a91.0
        for <io-uring@vger.kernel.org>; Wed, 07 Aug 2024 19:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723084218; x=1723689018; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OqzJMd5ZlUsQupZDxfts+6Mg8pPOpOynW5BSXAVoeTk=;
        b=PKdX7yB7w9bDJTLNPw20KaGe3ImN1rQNXmpE7tqS+KcuTkczO645suSMqfIAeFIpWG
         C8Ms3Dgrtv97+WG+D4086gWqCK6uyK6jftRI8a79RjSLLAtYsLdqHs7d98vjQie1woS8
         GIwsNViw/RENHEVkAxQBPlkZNAjjoD7185Lg93qktSLh/ijbO/0g7s15ppGOYtTl/X6+
         pP+ALDD9W8jSvI8MlP3RkreDO3oICcaJs41JagYoJEgcW0LTh3TQrucKW3PqyUsYGiSi
         hFdhVsE7y47yLf4QVitEmbb7xK5l8Y32YV6aczUNAPO+6WAmxj9bXBuF9WmDe97tLtia
         iyjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723084218; x=1723689018;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OqzJMd5ZlUsQupZDxfts+6Mg8pPOpOynW5BSXAVoeTk=;
        b=XOtht5EFo3x8ZsGMFhXeCDZ3/E87dW936RwYyRxmR2NwE7LFLeUI945u29R1RT5Bwt
         7gLumMw8357zCTcRKEnjB9j7KxG/nSo9Jes06UhOdPV5u/HvwZFboXf4KwyBGKFfE/4E
         BIjDFv0f9hYkpIYNgTN5H2pX0hs5K+oX/E9dTvcKNNJCfOiRHW58xS7h9I9nPsd/7w/O
         2NAbN5SkVW36jRPBBNN+kbC3ku0PPbdC38123iiGfn5mpNQdYGoVkEKqgNAY01UUJPsC
         DYWQWqnY4O3Cfrjd0wtPLRW0U+nyAjcd2g5ZTvgdBOluk+mX/HgLsHkaHcauKoqMVl03
         kHUA==
X-Gm-Message-State: AOJu0YyO/aYcA7omzcR3IHcuS2lMSgFyCHyhV+q09vbJ0GUkrpf9UmPC
	Vrhm2KHdSfOWc/mJ1xLLGbzCyiWFjDAtxI1kZ0GsCuk9h+0A6imBNIIsU+FfJ1oH5l1E3yFH0HS
	M
X-Google-Smtp-Source: AGHT+IG/FMRRYIBqnBfX5hbuBxxes05yhOQvzZRwhmlotpdslcOwlm6Iq4hCD6gUvaD59dnIABx4Jw==
X-Received: by 2002:a17:90a:ce87:b0:2cb:4382:6690 with SMTP id 98e67ed59e1d1-2d1c34cb7aemr332101a91.6.1723084218018;
        Wed, 07 Aug 2024 19:30:18 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d1b36bb520sm2311758a91.22.2024.08.07.19.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 19:30:17 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: asml.silence@gmail.com, Chenliang Li <cliang01.li@samsung.com>
Cc: io-uring@vger.kernel.org, gost.dev@samsung.com
In-Reply-To: <20240805084442.4494-1-cliang01.li@samsung.com>
References: <CGME20240805084453epcas5p363b93b10eaf53df5725417d3d7fbcca0@epcas5p3.samsung.com>
 <20240805084442.4494-1-cliang01.li@samsung.com>
Subject: Re: [PATCH liburing] test/fixed-hugepage: Add small-huge page
 mixture testcase
Message-Id: <172308421706.296149.16208843385494617309.b4-ty@kernel.dk>
Date: Wed, 07 Aug 2024 20:30:17 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Mon, 05 Aug 2024 16:44:42 +0800, Chenliang Li wrote:
> Add a test case where a fixed buffer is composed of a small page and
> a huge page, and begins with the small page. Originally we have huge-small
> test case where the buffer begins with the huge page, add this one to
> cover more should-not-coalesce scenarios.
> 
> 

Applied, thanks!

[1/1] test/fixed-hugepage: Add small-huge page mixture testcase
      commit: 4f134cc45955cf9957e3de9e5f0dbf2162aa49a1

Best regards,
-- 
Jens Axboe




