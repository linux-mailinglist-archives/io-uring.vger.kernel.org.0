Return-Path: <io-uring+bounces-8181-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 657B8ACAD8F
	for <lists+io-uring@lfdr.de>; Mon,  2 Jun 2025 13:52:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EAA217F83E
	for <lists+io-uring@lfdr.de>; Mon,  2 Jun 2025 11:52:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 222442B9A9;
	Mon,  2 Jun 2025 11:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cv/xAjR5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5779E4317D
	for <io-uring@vger.kernel.org>; Mon,  2 Jun 2025 11:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748865149; cv=none; b=fkpx0IkVYUj7NySvMcI1o5uEvkbt99iDgd5hMW+s2oPACvGHuhpUc9vn6OapoNcWfVFrOzVA//Tp7n6Qa4qHpAY+odaGaa6x/AYuVqGzWOvC1DsvUHMPXdhT7wuURqF88t4J2ZeXQMbuwDbaowBX92z8kIytMqqsW7RBA9zdbWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748865149; c=relaxed/simple;
	bh=z9mS5hq7gZ0okqlykXCTdlBbRHo90vLNmtX9EcHZEdE=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gkRmtxr/uUhPJfehT4C/radDH0Liqg08OIsWL7M4FjfGs3tlcxzrQXcVs2h4M9XbEt6DE4hCyycPfr42c30SEh6LMgJCeJBhP09RjsdvtjDVvoZOOeGXHXmvakwJJTXrjM4K+VHrdrduA1Dyp/lGDpLtHr3w+UD9rEQR7puoGf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cv/xAjR5; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3dd87b83302so13983885ab.0
        for <io-uring@vger.kernel.org>; Mon, 02 Jun 2025 04:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748865143; x=1749469943; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9CyMwJoaZZorVVfMnQTUEOQPNvx40fTqozHXYBDvLcU=;
        b=cv/xAjR5/UQvEL6b9AgY00QuzvK03tuRwXJIOHkrWiHUzfouZaU2NOWuKGY6Clt+ha
         jIwnBtLiZ3vjbUNm3bkpEAtRnklv74WIUPT+K8S7E+zmsL9Hpv+//scs8F9xYxdEAprD
         ummoodIkgbC3mdPskMA4QNtA9TYl2YQv/pBk6L+AeGr9zi4SGTNA9d+ZT7wWRUj6U9j9
         xBIsmYlvRouJkOu0Cjt4mQUXPGYio/N/QuLaSQPOW/fkDw6bhxoZTklOC+mKxFXze2h5
         gd31kwDDJpvZBJSp+h2gDL/HoK3MF4vQFTyuTUUkazb5pjn6kyyKOqC7WVZipxCPIrGA
         WYZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748865143; x=1749469943;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9CyMwJoaZZorVVfMnQTUEOQPNvx40fTqozHXYBDvLcU=;
        b=AdWOtsdNIJt8pjgRq/TcCntxzJHwOd+VGvCchO64QKDDqi42hSjSrEMsp2hdXMphQx
         NNV2EveGMjPEcPASYP2f2isFjNDm0flIlzdcpf800Nq1u6gsa+hUratmbike+NLIvMqi
         sgN4BKRWko8fLlF5+LAlJLUfeNyceIvL/Bp6e57/cyO/DbFJcf6zGfkyCgb23Sjjnib6
         cKiYOE4m3MAtePH6aiJc+utdTD1cXIiyluN8d8m5DPoLJhvHMIsUs+EGjHJgfbi2rLMi
         l0SITOWvlypKUTRHbdVwH1osLEudGP5laTHOXENlCEV12XRoKPBJUbtjEJjf2QunNP38
         De1g==
X-Gm-Message-State: AOJu0YytybQzR8HeoQD1WZxcsa2NyRX9L2p++wagkBV12mBJzqiUzfcg
	LTQD6TFeTHyPLhBmaAQUW4ern3Ql9bWIlhG1KrCEyJFt02ovf/FfejSkk7z3bMZVN8oUUmj2+FH
	Mv+9E
X-Gm-Gg: ASbGnctWZfZvu6wQrUK4hYhBjEwhcolktkeeR/MfnUe/5U0ttvn5BSyDBaju4ZNAdeT
	vrPmFCUg7qYHQEVgjcqOcyv0BY4gd505sL35Yk7PokWVTvwqQ8L/zTJeHlkqDhy7wgHjrR4DYvl
	UkTQ+ifYDMajB/Dyd1/jnzSB2bOpBsc7sNs5fOCPMPOTpb1y4fvFPtZHfqPzxj8CE5mAP/U2hcP
	GkBw0K2s+zvd+RfRwsOxgVDvINrdgOymeKuWPiv/ExIKpsJI0HiIci0Edfjity7HK2ZgJCLqHFE
	B9wcJCCIkfMlk/5b6iPrCI8unHJdcQTs7h+l3mFFGYmwK51OiBL+OA==
X-Google-Smtp-Source: AGHT+IGjf23XRHM3W0OMy3lc6NAEtvigJIj4rizvfvm/XO+5Fq8T9GVY5MIG6kXl2Zdk8BxuZzoMhQ==
X-Received: by 2002:a05:6e02:219b:b0:3dc:757b:3fb6 with SMTP id e9e14a558f8ab-3dda305ee69mr68244265ab.0.1748865143017;
        Mon, 02 Jun 2025 04:52:23 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3dd9359dc70sm20210155ab.55.2025.06.02.04.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jun 2025 04:52:22 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <814ec73b73323a8e1c87643d193a73f467fb191f.1748034476.git.asml.silence@gmail.com>
References: <814ec73b73323a8e1c87643d193a73f467fb191f.1748034476.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] MAINTAINERS: remove myself from io_uring
Message-Id: <174886514200.7949.6045689424994668579.b4-ty@kernel.dk>
Date: Mon, 02 Jun 2025 05:52:22 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Fri, 23 May 2025 23:37:39 +0100, Pavel Begunkov wrote:
> Disassociate my name from the project over disagreements on development
> practices.
> 
> 

Applied, thanks!

[1/1] MAINTAINERS: remove myself from io_uring
      commit: e931d3a9d5200bae9d938be2582072b2898e37f7

Best regards,
-- 
Jens Axboe




