Return-Path: <io-uring+bounces-2865-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FC849591A3
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 02:13:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0438D284DDF
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 00:13:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE26581E;
	Wed, 21 Aug 2024 00:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lDP1JDX8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0DD7482
	for <io-uring@vger.kernel.org>; Wed, 21 Aug 2024 00:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724199184; cv=none; b=cWdHTmkaW41sKZs9wbjp420ihJ5vuBJns0CFmsGSNrIAdwstTz3rqHxu9szffRMMJ0txC+c0xv5hDXGqWVn2Hf/synmJmvywMgtekcPhuCYndWuzSeOCGs1Z9rLaazY557KlEN5zNVY3/4viAa9HbURArEBvMj/QnKrtTa1dHWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724199184; c=relaxed/simple;
	bh=kOPLBTjcmFaQRa69LNcz5Mx4WQRj65z1ic4d6Ixbsf0=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=eohd5xsV3DuRJFdltbHIlliiwyMYcmfRscTQ4aKSsyYOBddxyCYiYt4XfpINcXcuK5jt26E4KbhfLydh3zclr0xxG6nlEsKQrIGecayh4icT4NOzCEoOVFQmyQAwQV8Y1bYfEQMR8dt1MVm4U5FAMuwPtik7VKaZ/8oyNAY3lUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lDP1JDX8; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1fec34f94abso56107945ad.2
        for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 17:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724199180; x=1724803980; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TlRH6iHmuSRL4pZKJTG75Qf6Il47NLxdGFKrIvRVKtw=;
        b=lDP1JDX8svq/zE72yySp9451kg155wTwl8q47HBUFSdcYyZIc6xCRpzoOh9MkwlfS+
         Xsxk52z3zb9fnfEdj7IBQkfU85+Te3e9Z8Q8+BM/AuuZKYCtB0auexdvRYGNto5uVNOq
         z4leNGJj0D+RmqwjRyl/XEG0SS4PeRK0NvvJDapxEoOHDXemowrg/ecds2fG4630gsGh
         kXSbPQTX9p6jgElLL9cSbvWHYFicu6+/u/80E3fs0UnGkVa0T/LKltlW0ALTnfiP/+0U
         wkzrH7Fw2koWAgQGsBDFqxxbqqx/FSz06KE484cAWav8S+qHYDMmTdY4PDFAszgjwfy6
         YmzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724199180; x=1724803980;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TlRH6iHmuSRL4pZKJTG75Qf6Il47NLxdGFKrIvRVKtw=;
        b=gIiN07kjqlqyCBwQsHn0Q4WDCLbSXjJaumQfjWM3KTDNrVcj8WinVErIcsRsyedZrH
         D0Anzuv2QjY13EFUuP52iKRvqzEzZvifqQfb0qFCy1VN8u31Fxj8ARQsDZ3E5NYiF9Hm
         5vWGFlDtp/Zx730z/OmTZ72M/Am9oi0RIz6ZDF3izVQMC9xJMtV3RGrERgcsYhHklJWs
         HnCdpzleJWYLfdTow+lL5sfLeygQkxWuWy/yCFl1e/Yuk1PYNFLBj4R8txyVyxa9TafT
         Jr53M+W4mzQUBBA+Sx74HR7Kfn9IBCm2B86X5bFG6B0J5wpG/1zKjMKu6nX3IYR5pbG9
         gn6Q==
X-Gm-Message-State: AOJu0YwUGvoGL7cKOiljIGY9D5coA5hV+9pd6Kvkhu1uPVBb2sm0f990
	8Ow8d3FFV9r6f50DTl/kx/nZPlSR5loH4E6A/mpSedNMfFuDy/LNGovQ3rdUCNBzhhW6zUOje1i
	4
X-Google-Smtp-Source: AGHT+IFmq3jjiz8iBJ/PNwf4+BcMuVdPIQZMh8rvKsjUyKEiFXYtpxspO6zKxq4pMdcFut2DDppvTA==
X-Received: by 2002:a17:902:c652:b0:201:f1b5:24ac with SMTP id d9443c01a7336-20368096e5emr4766695ad.54.1724199180406;
        Tue, 20 Aug 2024 17:13:00 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f02faa77sm83165285ad.58.2024.08.20.17.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2024 17:12:59 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <285eca872bd46640ed209c0b09628f53744cb3ab.1724110909.git.asml.silence@gmail.com>
References: <285eca872bd46640ed209c0b09628f53744cb3ab.1724110909.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] test/send-zerocopy: test fix datagrams
 over UDP limit
Message-Id: <172419917963.98368.17880563952445291485.b4-ty@kernel.dk>
Date: Tue, 20 Aug 2024 18:12:59 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Tue, 20 Aug 2024 22:53:39 +0100, Pavel Begunkov wrote:
> 


Applied, thanks!

[1/1] test/send-zerocopy: test fix datagrams over UDP limit
      commit: 2d4e799017d64cd2f8304503eef9064931bb3fbd

Best regards,
-- 
Jens Axboe




