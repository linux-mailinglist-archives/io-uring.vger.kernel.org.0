Return-Path: <io-uring+bounces-8697-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CEA01B07809
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 16:28:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 702D93A5717
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 14:28:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FFE42494FF;
	Wed, 16 Jul 2025 14:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="s8ULJ8NU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CB423BD1B
	for <io-uring@vger.kernel.org>; Wed, 16 Jul 2025 14:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752676115; cv=none; b=fwoqlLBPuQVdPLqoLNRqWcUezTTKe3gqjFZvE1Yeuw3QCdLJVHA2bhT16SbXCjN1zcrEmI8amXLBlbQNGvsQSJ2j8LfHBO2iyXVaHC9WqlDGr45PFkrYzgRSY4KOqZRIpTbMdbHYPiJqM9S9QppMDP2XElu8v/epsfgL63GMH5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752676115; c=relaxed/simple;
	bh=y8gOoLVFQ8/h+R8J9Gf3/90fN5Z7Z/dA8vfQCud+7Fs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=BboMV1sjrlX0mVyJk/taWvFJ/QhSTEFwhFO8KO11MqvEA6Bzqfn1y+h4wNXP/rf/MAhadVYxN2HRhC9A2Y9WQAWNxYkdjaLpbGG0jioUBO5smROQknuSj5Lc8ejqTxK+2xqwjfhr2heMhhxNjUHWL0S2M8IK7FRp7+ydgNEtSvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=s8ULJ8NU; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3df2d8cb8d2so24048985ab.2
        for <io-uring@vger.kernel.org>; Wed, 16 Jul 2025 07:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752676111; x=1753280911; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rveqprwKMcLmQA8Easg7/xnkweEH83Beepz7fHXT5JA=;
        b=s8ULJ8NU8erl0qkGLUng+ZrvpEwzR2ay73S5hOAsURpGHCTYA+kcOFVfOU4dMzLX1f
         CaPr2dDfTUSoIVi9sUfcLiCnAef63whuKQ6ByyfUSt7Zat5YCp6mUfyX5tqt8LYkrtqh
         JZkg25ODWH0+S0IxHLZ+0xXpUEWjQ52wZPP3rqvYGqXDJ4QTEicZAZz28FLsJ/HxXjQn
         iCU9JWbytDKrUWlr+7uoX2eceHLkKrk70SuPIj0ejhVlsdaFvqjBptaCNpPX4PDd3Puq
         GMigPeSTS0vjcxzZGB1YjmRtcmEn4hNITSLBhbQ5vWh+yQF8t+ns69T4Yiwig1eTbKaJ
         jPlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752676111; x=1753280911;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rveqprwKMcLmQA8Easg7/xnkweEH83Beepz7fHXT5JA=;
        b=jBBIdcJ7j9+iiJddcML7iPm+4+Hgc4UAgUHUm5+q0gYVe2OpNOCpfl48/TzaArDViM
         6AfPycg0qoj7lbC+fELUd47ghhdcE6b8VFOj+ev0lThesoetL3nOGoRr08C6exQTDfUK
         Ojg4Y0LrDgWFIFWwmhD1gG60QMnhDJgheehg09JHcNX5sxGiwKt+tNp7A+U7M+X/4b7h
         r5tZMrhtoz4p51CZNEXWGEJELImWNugs9hmzaBwTAqSguIEoxSEFTu0muBlAQe++EirE
         Y+6Ndts887pdrMv8ioVeXvHmjEGDkbV+aJt4LNbCbCHwp8rUJcuSKJVIiydpaQdVmNuv
         LTww==
X-Gm-Message-State: AOJu0YxEAaRnrds05VAJaUHXAsNB5kYO2t7bNc9JTgM+KhUEG9nHvccF
	BUNy3ut5iLCs0RqRBS6L8BcGv/st9Pw8y7HrEbya63XvWn4hpYUg2pxMNLAvlpmmVorxxBq+lYg
	Abw1B
X-Gm-Gg: ASbGncsoNPfp/1lS8QBti5wVkAyvjBDr5dDYWrZlgE3AUlmLvBlrrKx99xfYDQUMDOh
	d5ysudh/vrkjUYhk8vmc3MgKpF0F2FwsldGZudvfID+lvmWdZu1CRE9GR/cgPcNJ8nJM/GIykpc
	JuyUBUpZbCup5Sw/sIRzVLfbthrjFaOYmNyunywthQJ9+6Qz/KBZ5ndDcdzSjoR64XdbN0LqHqb
	ai7DfHdrVHCF0q8bf+WXSOHWdpdHhrFvdwa83iUYEiAJju/tabyuoeEiCNHMopOH1UEZzXwd2lL
	G8BeB8eng8SIxf7fSJAqboOHf7Gue5OMgo4FJN7FMn4lpfiJLyoyl4SAfA2WthMMLUnV9LCJpTQ
	n3KyV9vxSGHOPwHgIEMMoE5bz
X-Google-Smtp-Source: AGHT+IHkape1nu5H5xkoyFdaHNz1Ho/Vgz/XJUzoRsFBDMZs/bjPpYZhOHO665pOn0X1EqfVVyiYvw==
X-Received: by 2002:a05:6e02:4508:20b0:3df:4046:93a9 with SMTP id e9e14a558f8ab-3e282300e22mr24762575ab.5.1752676110802;
        Wed, 16 Jul 2025 07:28:30 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-505569cc6c1sm2951019173.104.2025.07.16.07.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 07:28:29 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, norman.maurer@googlemail.com
Cc: Norman Maurer <norman_maurer@apple.com>
In-Reply-To: <20250715140249.31186-1-norman_maurer@apple.com>
References: <20250715140249.31186-1-norman_maurer@apple.com>
Subject: Re: [PATCH v2] io_uring/net: Support multishot receive len cap
Message-Id: <175267610933.280285.6603963586910105111.b4-ty@kernel.dk>
Date: Wed, 16 Jul 2025 08:28:29 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Tue, 15 Jul 2025 16:02:50 +0200, norman.maurer@googlemail.com wrote:
> At the moment its very hard to do fine grained backpressure when using
> multishot as the kernel might produce a lot of completions before the
> user has a chance to cancel a previous submitted multishot recv.
> 
> This change adds support to issue a multishot recv that is capped by a
> len, which means the kernel will only rearm until X amount of data is
> received. When the limit is reached the completion will signal to the
> user that a re-arm needs to happen manually by not setting the IORING_CQE_F_MORE
> flag.
> 
> [...]

Applied, thanks!

[1/1] io_uring/net: Support multishot receive len cap
      commit: 0ebc9a7ecf6acecf8bdf3a3cb02b6073df4a2288

Best regards,
-- 
Jens Axboe




