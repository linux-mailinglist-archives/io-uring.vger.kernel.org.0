Return-Path: <io-uring+bounces-5838-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12BFCA0AC17
	for <lists+io-uring@lfdr.de>; Sun, 12 Jan 2025 23:02:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E197A3A5B28
	for <lists+io-uring@lfdr.de>; Sun, 12 Jan 2025 22:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD13F839F4;
	Sun, 12 Jan 2025 22:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HjySOqVq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69741494D8
	for <io-uring@vger.kernel.org>; Sun, 12 Jan 2025 22:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736719341; cv=none; b=s7aGMAzXMiPEFmBmgHSqAPhmk4jYm5imSrEgUPozVyYzAqqFs6oSS10g+MK+kcagGeROBLpHcgr92h7QZssv5Cpl9blG6++ywUvff/JloBTX6DUIb3+65ZT1C1+yzedScFmcaexQtkCkkgtZIs7v/PMfqfwbx/pDQEUxGeJiuDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736719341; c=relaxed/simple;
	bh=3AliTRGKQ/C0sYSOxntIOn2ITKIC0fmLQo/J0FfCzmg=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=F4GwoHqbEpi9tMJ3NaM/T53Ce+S3kpDOuVKq6v9PI/O6RqUdC0EYWICTUGs6wIar41qcy2wZrIE8bL0kQTZspPJ/S/6PBiO147q1ykwRo1GQSqbzsnXELvI3aXfEcHhsk4kxH6eDK7Qb6KHfHeQK7Y7B/Ji+hdGy3OyLrnBPpJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HjySOqVq; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3a9628d20f0so24952735ab.2
        for <io-uring@vger.kernel.org>; Sun, 12 Jan 2025 14:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736719339; x=1737324139; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DyYZlaYDStoyCftQAb2AMqXEE6Y4fSOTr88Ian73x5U=;
        b=HjySOqVqqsGBtDeawcZbf8KAjNX1iEBhrKKyV0vxsPTKW2fi/LOt3N7QGx4COXpEcj
         ROi/hyr4924uU5PttqaOwJprlT8+h4DaEA9KHWTLshLM7VmrVFwBZqoX+wfYukrly4Nw
         dUoBVR46yvEXN9nwt6G5teUjIbJD9DhLR8qT8NCTaYhlkAAd5+TK7qQsOF/pYFcw3thX
         yHS7mtK+pjH0HG5YJEIkbiLDOQQXx8BYAl/ptW12CCZpbxUjuhivMJw/Bze4ktH4lk4e
         oY2NU6I8DAKpGirO/PmRoQEpK3oJfVxt+F9NDKxTpG78BhQEMqGebBNX1yKree6k5dur
         URaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736719339; x=1737324139;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DyYZlaYDStoyCftQAb2AMqXEE6Y4fSOTr88Ian73x5U=;
        b=D70nyFDg9kf3ihV1uyE94mdIN6SwhtFg5ViAswEM7CXkyAXDPCumKVBBFpEf8MvqNs
         2+pDZad1hei1xdmLF2l1gna2V0crZJNuUA2Sn/XlTB5pXP5NbbLiNt971h6JIna6Uvw3
         GrO7ofmBMI6cTRwSUUHX3IK5xuw4o6f82ter83hzlJyS4P3Q3ljSFKW5bJAdmQA+pXa0
         jnRzUvf6ZOmDoYgvnpNRdhJFZrmGnk5MMZbzascAD3BbRiMKrwU2T9WDRiQQlEK1wLeu
         ENqjfUcGUBpBiZ0rTLskGDtjOfLBGaGxO4UeQAd2WEyGMtF0O0OFNHrYkzvqFyL99Qsm
         BuWQ==
X-Gm-Message-State: AOJu0Yx0/Kcw+lhPGflqSNHJXlLMGULY4/4M7H3xMTavWboRtyXkJJ9M
	q60PtQyE7fix1cUvSHzkZLLzPB6ze7j6ohkty97V7ZV+JGWXibUkaN0S+MqpPujdUuP/Mh1n3DL
	d
X-Gm-Gg: ASbGncvK8Zkx7v2xZLSJeylOU+4brdWbie7BkEjQ4OZME4rU88g1vRRkMfnH0/j3k9m
	0PTG9ZlS2nB+ZCxgWjowFq8i6Ey7u5f2BRRqFz8d4YuiGcughfilJqL5jWK05uSS+pDPnc5nJTz
	ZNJP0uXnp25sMIfByC6mvla73JR6nxtq23bHLETRpbmPGUzFJuc3+amWviGpKhcfowqfKU7e0lg
	qmzG3pJDFX86p+w4higkjfgcpAR4MXgQELh+R7LZNffL41y
X-Google-Smtp-Source: AGHT+IEftSmWbHX0LuAwGyKIQNDlV/Qpm6u4ak1+viIBp6tX2Wt9bXG0Ex4C/T+PrlrkFCJ0Gkn2Hw==
X-Received: by 2002:a05:6e02:1908:b0:3ce:6af4:78d8 with SMTP id e9e14a558f8ab-3ce6af47a4cmr32317155ab.12.1736719339050;
        Sun, 12 Jan 2025 14:02:19 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b5f82desm2346625173.19.2025.01.12.14.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2025 14:02:18 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20250112180831.18612-1-marcel@holtmann.org>
References: <20250112180831.18612-1-marcel@holtmann.org>
Subject: Re: [PATCH liburing] examples/io_uring-test: Fix memory leak
Message-Id: <173671933815.1103166.13622970529782808467.b4-ty@kernel.dk>
Date: Sun, 12 Jan 2025 15:02:18 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Sun, 12 Jan 2025 19:08:30 +0100, Marcel Holtmann wrote:
> The iovecs structure is leaking even for the succesful case and since
> everything else gets cleaned up before exit, just free the iovecs
> allocated memory as well.
> 
> 

Applied, thanks!

[1/1] examples/io_uring-test: Fix memory leak
      commit: 3124a4619e4daf26b06d48ccf0186a947070c415

Best regards,
-- 
Jens Axboe




