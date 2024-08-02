Return-Path: <io-uring+bounces-2641-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ADD44945E64
	for <lists+io-uring@lfdr.de>; Fri,  2 Aug 2024 15:11:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B982285404
	for <lists+io-uring@lfdr.de>; Fri,  2 Aug 2024 13:11:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A34E91E3CD4;
	Fri,  2 Aug 2024 13:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hHbWHYjb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1F31E2889
	for <io-uring@vger.kernel.org>; Fri,  2 Aug 2024 13:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722604271; cv=none; b=nmqDML69Qh8H6M0dMe4bToleMHEGvXcMdIF1/14usdOh50mvlYyP1tuGwcZh2jtkS2xGH1z1a1/8qg2I5TvSpjRJOz5MuNjs7fU4htYobj5K8Qw6FBaLWehzpgxYveqxHdwprSvWw8dsebPAHa9Bd/HyiEXqG6fcKu1H616q3jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722604271; c=relaxed/simple;
	bh=TiiSYEUXPhhVr56uUAfZVMwD5/68JIXm2jVwqIzf5rc=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=tXht5nQFvpT5UegT5R9AEcGLDN8rxhD0Av7WFpAFJI8VUKyW3SmkLszOBhptHLJKT7YTZV/6cdCogkv1/I1tqIQVS/QJ8/1VHHzokNBT9bago8I9Z6Ge1OYxMip8oqdVWC0j4iACWEXwiKyW+LNwduXIvUFL03IOp8hVjGkwsdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hHbWHYjb; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1fd8f92d805so3609275ad.0
        for <io-uring@vger.kernel.org>; Fri, 02 Aug 2024 06:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1722604268; x=1723209068; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4sBfjj1cjv70KwgS93DjC0JqgN6DJVVmq/7DfTWedRk=;
        b=hHbWHYjbLr6obIsWRNcNnME0Rxq848uMB1rPcBRvM5FXXZX0x0NCmplyhsJK6Z8JPV
         ndMnxyZptnN+TZGhxJpqZYA7dxfFILl5J63RLNMxBsXzxNe7g4BctWLrZjcP7J9Ac7jz
         RWymDnpemuuy0vspE4Fz/mXxXcQC5kKNh9wsnBFDiAHPMbj+p2k1HMOc2/YYBitNuYJp
         am+aBX8SgW1qrzjEJWHji2mPBOhro9Ac/fLewIGF1JyW8o45di1pbsKLGVQbehEhApzd
         82o+CcIr4Pzsiq7YRzgpEt9Psd7bGeJWVcWMUypA6t83xDwBBvM48DJ0ujLxVUIgBQSL
         H+tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722604268; x=1723209068;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4sBfjj1cjv70KwgS93DjC0JqgN6DJVVmq/7DfTWedRk=;
        b=tCM2xNWsI82Ew4gmVus0zhM/8YMbyMCzLzq4dObehGifDtBaVNksoZUlg3Gj+6kE/2
         fU/PQFHbsSTzPzimfTeyNFZKZrcTKEsEhjUQJIdldb1tUd5Xdro0YIjcenfOsUW91G+z
         zunArWPcfRh2iIz3gcAQaPNAj4N3CFv0d4F43LUWYbmXunZxT/4Numhi2A5V67rhH6jL
         xxMhqHEUXm3sXmAixBiWkftwvP5KiDiJk57RsvIrGQdtPDzK6bWyC39y/lO7y2SYEgay
         /n0jVgVuIYItdd8WjG9R1b2T8hG3aXSqWgkf4omfay+rMQQZMxppf+Kfdc9zwKqQI2DU
         zVew==
X-Forwarded-Encrypted: i=1; AJvYcCXhkMLJCBI8pMpP58AzjaP0ktnNuvPKejmwvRQSnoRTlMXYi6q9+6GJ4mqYILdxuJOvwVEz19Uflg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzkDLiCzy4WIrGKwCMFUy04TDxDL0iQI3cmPrSi4NaR+gL2dhzj
	9r7eG1Fp9Fwd1KsFfjS06tEWLr6TMLHQ3QYlWeRiMRmvhqEDzwMKvXcC+c4P5+J3TGuatWipMl+
	c
X-Google-Smtp-Source: AGHT+IGKK2vcmCE0t2mV+SiiSdmSYz/51sbyyjzpMoaeVFrdMXSVVZZBG3DkRI8m28mjE+NxOTt65A==
X-Received: by 2002:a17:902:e811:b0:1fc:7180:f4af with SMTP id d9443c01a7336-1ff572930a2mr26598065ad.1.1722604267659;
        Fri, 02 Aug 2024 06:11:07 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff5916eaffsm16611305ad.194.2024.08.02.06.11.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Aug 2024 06:11:06 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
 Olivier Langlois <olivier@trillion01.com>
In-Reply-To: <cover.1722374370.git.olivier@trillion01.com>
References: <cover.1722374370.git.olivier@trillion01.com>
Subject: Re: (subset) [PATCH 0/2] io_uring: minor sqpoll code refactoring
Message-Id: <172260426601.62322.5371189034087982389.b4-ty@kernel.dk>
Date: Fri, 02 Aug 2024 07:11:06 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Tue, 30 Jul 2024 17:19:30 -0400, Olivier Langlois wrote:
> the first patch is minor micro-optimization that attempts to avoid a memory
> access if by testing a variable to is very likely already in a register
> 
> the second patch is also minor but this is much more serious. Without it,
> it is possible to have a ring that is configured to enable NAPI busy polling
> to NOT perform busy polling in specific conditions.
> 
> [...]

Applied, thanks!

[1/2] io_uring: micro optimization of __io_sq_thread() condition
      commit: 5fa7a249d5bc847876e04b91133d6b18d5c17140

Best regards,
-- 
Jens Axboe




