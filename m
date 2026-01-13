Return-Path: <io-uring+bounces-11615-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F422D1AD31
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 19:23:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DE89F3038189
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 18:23:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E12B34E776;
	Tue, 13 Jan 2026 18:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="T+4jM/q1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054252BDC28
	for <io-uring@vger.kernel.org>; Tue, 13 Jan 2026 18:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768328587; cv=none; b=puvO8oxjGyaNhr3OguW99WoO/nL8DSuyb1ULaFSy94wJHhIKndtxQtRAN9VqTxG+DwDedQhRGyZKcLMgnd1AkoBjO4NKWyZzGBhQAH4tZUEF3FTXhsnBGaXaaAQue3t69kGoYUyoXkeolenjWxndy7aEQNi9oicE/PSQAezZbgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768328587; c=relaxed/simple;
	bh=QtUQX1xeEGpIvICCRaP7UHJf16VULGFcl2bbg4Lzgvw=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Xp8nFeJkPXXRFyjru9aB8g+gq8hHze4VjdbH0CXqRZx5QcfD0xSLAp7jjPFmwPG4gHVIkO6e3HUsuFx09q+Tc/hR7h/52JLeDrVlGnkTP8qF+QA2rp18Z6ByVt8WRSPBMkNBWLDtUdNxJ93T6ZxHHn123seC+DZRmiIe7Nt87ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=T+4jM/q1; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-65f59501dacso3996702eaf.0
        for <io-uring@vger.kernel.org>; Tue, 13 Jan 2026 10:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768328584; x=1768933384; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aefwBc9csPYJ9zzcmDD+DDDsD3YGuXUoQpPqIyLKWMw=;
        b=T+4jM/q1gZ/l+1Evt9DITJXp35TfxjAjOTF5rlDAw7rzPd+Rf1fXCcwy4ogBRSdNCx
         ZkQn/6hPAnMzqulqVsm7gm+WlXQ8aD+xAS+s1RlkaP09g1MZTtIIGmcVO2cAcU5Mzv2c
         ZbWJ692FRvSd4e7XdTfmoj1k/aLHGWsuRzr+m5AIo55XQv1GOv+axo6tY9IDWvzKnyjt
         NGZDRqsiHDzw082ziCVAMrWq5fSZyj13N3LAO6qzOsD5YfK+oXVMuPXIjyG+VlLrj9q9
         Ohw/xXKHgpAKALX1uHR7nnp6rhlzIpM7GeB5U0dPFd5caDUAF/uewmMbQpvZKF07aJZs
         OKDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768328584; x=1768933384;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aefwBc9csPYJ9zzcmDD+DDDsD3YGuXUoQpPqIyLKWMw=;
        b=T4326IIUMQR0nn2EHNiZyxDADwQpSpnlNefeZG8qDWX6XYnWfwlH2h/c3nkLrzeUSc
         h28uR6IZ7FERknn1nxawQnHPR2an3c+WQZ9D6v/j3m9WvYaGSSXRvCat6PcjM0Z2c9O4
         69kr4rPc/oQzY7E6obTQfbN7qx0R+RgeiE79/SjXdixqiKXuRJuv2YpO1l1SmnU8G9CW
         9vP2uuylnQL0G4yC60b7J/2crtA02kKFSCk90AaetnHzmJCl9yc3iwy7Prrl7rF6YHkS
         ShbASG/ydtz9mJqMrdwuQQPqLtJjSe9IL1FVA6LjKgju0GN4QjAHW/nSXSFn5xuECRGq
         qyaw==
X-Gm-Message-State: AOJu0Yx/9MLK+IVmeHr3pkBWtPoxeRDjXpCsO85RT033oAIwWqnaT1CK
	rpVpShfkseQalsgHPXn6PC5g2+/k9Kjquj5QlmMudTxPBI6ZwwzXDOIgdhxPB9YrjDOOhVbl1j+
	m8o2j
X-Gm-Gg: AY/fxX4vftV4NUJycRZQ6Bhn8b9ezYc4wuKFFl1wPHJbaRDucOZwYU2fffVRTSGO0Jj
	Yx5AvFVwba1sbzL8+eJcc2euLAhPdpn/dVyxLHZ3fm4cTKGhMEXVuxCpcL8AVJDHHQiqnxRbclp
	A0/z0YJHC4Dn2KttAZY9v2qysTEIRVwVyw3IeeDeW1p2QSEIKOpCO0/xv/eodWV59hMbCk3+8CT
	o81KV3IYcL5/uYiCM/lcThjn+cWFDWJGTObp7UnV206bSY3rW2hTdncxEhToir5U0WAT+VyrsRj
	O3LzsrqaUdWtct62kYdzJVb3Pi/FaqxpxqXq1b9JL4nBS20rvH6xGCF8k7/20R1Wbzm3UNJ+5Z8
	74YWa6yTLYgHhjJGwhQc1Jpzf3R9lU84s4Opb82U0Mr7EONTwHMQd6pGQagLKJqK+DDsjXQyzb6
	I1EA==
X-Received: by 2002:a05:6820:821:b0:659:9a49:8e96 with SMTP id 006d021491bc7-66100640aebmr80943eaf.26.1768328584433;
        Tue, 13 Jan 2026 10:23:04 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa4de8cbfsm14417890fac.3.2026.01.13.10.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 10:23:03 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260112151905.200261-1-axboe@kernel.dk>
References: <20260112151905.200261-1-axboe@kernel.dk>
Subject: Re: [PATCHSET 0/5] io_uring restrictions cleanups and improvements
Message-Id: <176832858377.335629.9713900334182538237.b4-ty@kernel.dk>
Date: Tue, 13 Jan 2026 11:23:03 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Mon, 12 Jan 2026 08:14:40 -0700, Jens Axboe wrote:
> In doing the task based restriction sets, I found myself doing a few
> cleanups and improvements along the way. These really had nothing to
> do with the added feature, hence I'm splitting them out into a
> separate patchset.
> 
> This series is really 4 patches doing cleanup and preparation for
> making it easier to add the task based restrictions, and patch 5 is
> an improvement for how restrictions are checked. I ran some overhead
> numbers and it's honestly surprisingly low for microbenchmarks. For
> example, running a pure NOP workload at 13-15M op/sec, checking
> restrictions is only about 1.5% of the CPU time. Never the less, I
> suspect the most common restrictions applied is to limit the register
> operations that can be done. Hence it makes sense to track whether
> we have IORING_OP* or IORING_REGISTER* restrictions separately, so
> it can be avoided to check ones op based restrictions if only register
> based ones have been set.
> 
> [...]

Applied, thanks!

[1/5] io_uring/register: have io_parse_restrictions() return number of ops
      commit: 51fff55a66d89d76fcaeaa277d53bdf5b19efa0e
[2/5] io_uring/register: have io_parse_restrictions() set restrictions enabled
      commit: e6ed0f051d557be5a782a42f74dddbc8ed5309ec
[3/5] io_uring/register: set ctx->restricted when restrictions are parsed
      commit: 09bd84421defa0a9dcebdcdaf8b7deb1870855d0
[4/5] io_uring: move ctx->restricted check into io_check_restriction()
      commit: 991fb85a1d43f0d0237a405d5535024f78a873e5
[5/5] io_uring: track restrictions separately for IORING_OP and IORING_REGISTER
      commit: d6406c45f14842019cfaaba19fe2a76ef9fa831c

Best regards,
-- 
Jens Axboe




