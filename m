Return-Path: <io-uring+bounces-7683-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EDE5A99918
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 22:01:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 163435A2E78
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 20:00:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BEE11EF0A6;
	Wed, 23 Apr 2025 20:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="g22PQgz0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974B31C6FF4
	for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 20:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745438461; cv=none; b=nbj7GoLQbacs/FhYa4hRxMDwuBrVgq6yLDPzvZKrJwBgq51vxA1Km7gqZQWmMMHeiIPw3OMoyMVXwW08MvBM6whGv9dPBJeRlfjRKGvOi+hQMvtg4r/pnb1ZR8RI+n16F5pZ2er1YysTMWi+rzxILwExCMyW4TgZK3XdCtCz4PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745438461; c=relaxed/simple;
	bh=h2M+PjuiqihDn8UI0bIeuvqvs68oC4dHnFtaxGy7224=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ndNjwDpS1r7F3PNLKHBvdRpeCIcQVXgYVuhhq5hBYvxp0k5fJqty74niiXjJWBTstEz6hJfZ96BC6JoChfy2TNTHbCND8JrTMaaCrxguQY8TrqYeNJxg9qondyV+YhLgTRbRVZRRBn2F+EEcaAi+AfA4Dx0x/YxEowUnu/UBEOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=g22PQgz0; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3d812103686so867795ab.0
        for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 13:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745438458; x=1746043258; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YhRw0ijG2ISYGib3LZ/AImnLRvOlVjcPg6EmNKD88s4=;
        b=g22PQgz0K2QwAkmHM/OL5Hw7S/6IcWFU20aGSm1U/CHN8Vhmn6lpZ4o1vE1WGAOrwz
         4KCr2ZX5dC1KrBKhS/ESj8/BT9pXF8pbfiOc2wJ/o0OINF1i5T3kAMRhN9vtuUPyk+AZ
         iejTJCHzlX8aAznTNg9gpqMIv69ex48P062Luk2uPWTig1SLCC7gqTlEb+UB42/OZ9Lg
         c5ArgCeEbax0flMPzp8tYo5DNmF4X85FN0zabybr85tytINoxADXLHemOVRC4y6SIvnr
         9+0sIWxf6zxq9TYduBjx4fcI595JCSAclOoUlzAzfI/zDj6PaOTDOn338l8hCNGAr6mj
         VhDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745438458; x=1746043258;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YhRw0ijG2ISYGib3LZ/AImnLRvOlVjcPg6EmNKD88s4=;
        b=wJkhV4j32/IeVwdcWP2ZbRVSbim150lvNZ667dp2K0Ij2opXuFiy/sMvdJoixvwkGf
         rOzWFLTFcBvKQLJbjcRPsf+Cu0cl7euQPHdBcgcHyXwRtCB26bhl1lE5DwV6nFOQoQrw
         wcpeW4Yztu5/Xr5cti0vQntfHdDsJcGLXeSXQMslVMo4i26HJj8BKL0SfW/cy2CpQRMP
         Lg/Vt0hG+LP1foXwtKh9f6y089tONEh8YPUeuG4w16wFa9xoknDlzn54ej20cG/XXKpl
         pEH8pKnXSPJfrmhvwjfOpGUuahHDZOf4TObSG4KIPliOYwmt9V4H4BtCLeSmyhULJa+4
         F5+g==
X-Gm-Message-State: AOJu0YxK+99fjsPmVdzLnm3hp3789rRN0bJ/THaj8Hjib1aUghVFb2Xq
	yu8nAn4KYDXDikXS7rO+jG1EJNYe0o/O/5dP0wjGTfcCvKJXGmwoVM9cG6asDdUQZm7tk+n9h14
	C
X-Gm-Gg: ASbGncsjO2RDNtIBxo6ZcEoCJCZoQv8tPA6OwhKqHHbpRwtbLNnGrhqcHw09sXVVvnk
	ORf1rhwKa7HAxD5djCmGaLcV25KN6HFNGe+luF0LhKjqKeDC5FhG2S6vDlGOC2w1p+nWM1yWLb7
	oYqKnF7ZKaeXTXII7F++9+JyOm81PXgBafz/7Ld4xV4cPZpfSAw9yYcf+nO9y7iIgBe/WtUrRcv
	HmZaFIhWzaex0opddrPrDU1iUz7vic6AllLhfeBW94FeIV9kiGY+Y3Aj+/EUaCcSQH4a8saGfpj
	AKEy0ozb3nkPuCqfsD5SbPBVA1k57FI=
X-Google-Smtp-Source: AGHT+IHoYkgWVBOoACc499EmTnc136Edd0n1fNb+sPbkmcQLUk2bvoVDJFuonpF/GH8BONUul1j8FQ==
X-Received: by 2002:a92:d107:0:b0:3d8:17b4:1792 with SMTP id e9e14a558f8ab-3d92f3d2843mr6693635ab.3.1745438458607;
        Wed, 23 Apr 2025 13:00:58 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f6a3933a24sm2954738173.83.2025.04.23.13.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 13:00:58 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>
In-Reply-To: <cover.1745409376.git.asml.silence@gmail.com>
References: <cover.1745409376.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 0/2] huge page support for the zcrx examples
Message-Id: <174543845781.540533.4711084159323250980.b4-ty@kernel.dk>
Date: Wed, 23 Apr 2025 14:00:57 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Wed, 23 Apr 2025 12:58:36 +0100, Pavel Begunkov wrote:
> Patch 1 is a fix, followed by adding an option to allocate the area
> as huge pages.
> 
> Pavel Begunkov (2):
>   examples/zcrx: fix final recvzc CQE handling
>   examples/zcrx: add huge page backed areas
> 
> [...]

Applied, thanks!

[1/2] examples/zcrx: fix final recvzc CQE handling
      commit: 5af333652abf0bb2c8eb764f4f5221d91a55d945
[2/2] examples/zcrx: add huge page backed areas
      commit: fea11fe9b37b7944d1fdafe6daebbb3eb8e7abd0

Best regards,
-- 
Jens Axboe




