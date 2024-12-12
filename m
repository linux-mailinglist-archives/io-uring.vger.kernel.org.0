Return-Path: <io-uring+bounces-5464-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFDA89EE8C9
	for <lists+io-uring@lfdr.de>; Thu, 12 Dec 2024 15:28:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D7658166378
	for <lists+io-uring@lfdr.de>; Thu, 12 Dec 2024 14:28:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A0082153C4;
	Thu, 12 Dec 2024 14:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="C25E5S3P"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72E42147FE
	for <io-uring@vger.kernel.org>; Thu, 12 Dec 2024 14:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734013718; cv=none; b=eHH3H2cgivJjIDX9yxJyr5BJJFRjKwgMWckT/PEl57ELiCOsQnzMMJgkB1ixD3C83mod3CGncLbGqDCt9PSP+T9gSGJ5RoEBdz1nYHU7Pi993lnZ6R5R62ne3iN/8CGkFWyAtXyz757B3PjwYAZ+CttOQ5fU6RX6gvJExb+C/14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734013718; c=relaxed/simple;
	bh=NTvAln/IDG7xjORAFo53OF9UnbmAqt+wQ/HWM4jEFy8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ka2gc5B3zmMPp5rgcXjE6DxWSNgJ7OkECx7j1v7xFo0xlzdF4rcFDogSqiDUZwLkiH3hDy3z7FWuTkZtcv9QOjN2etYS3EwwmeYn1LuOlgBPpoSNVOQG98LxV2buWrkjBV9ahIl+Dr5s+p5Oxwt888Shr0xu+vQ/OqF88r/NmEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=C25E5S3P; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-844c5f31d48so57431139f.1
        for <io-uring@vger.kernel.org>; Thu, 12 Dec 2024 06:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1734013713; x=1734618513; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gfT3X0hae33k9lYMBuaLlSL6M/DETLFxdAGxRb+Okr8=;
        b=C25E5S3PzR4C7mwPPUfAZxsCKHc5fXivB2GfIzFbVq0cptfamjojE2GjTMu4/IOMQq
         8GP9lWSfpXAqc7sIkRGKED7OuxOk7QNmlwT4BGW2Yn01s8ChjKXpEn0WYqNAHnSuFhGm
         1gohqiwedMOgcKmtjHH9oMrSvldeujktTUsbdzMsQn9sC3ilE5X5pt1rpENNgjyjkodt
         dA1y4M0PEL18tkqrPRAA5YpSmCRPESRpjg+y1eUKY4bsAVECDqNtd+P2u47GdNv5V13p
         37GxWBv6rTPkRUKdH1cqsZx5j6pDAiYLBJvHzJGd4dc1GruQz2TtRHyz2J0q5mcLhQDX
         lJFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734013713; x=1734618513;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gfT3X0hae33k9lYMBuaLlSL6M/DETLFxdAGxRb+Okr8=;
        b=LhNfrx2kzmYwtwi5POxpEQBg4G/BWu/8Jsym+XgM72h3ij/eTNqUYyxT8WQ8bbSznH
         ZgJMnTiUs4vFQnff+o752Ihbr7xcbRMmz6zHzdeadboj6N5J3+KsElChk/OUIlR9lC/5
         0lPz7csPxsy3OVJVetAhbHhBe7t7Un22zSGbCgraovwCEU+TCkhbI/xnU3+VXyKDZT11
         5IT6Jp5k8gcpXBswyEWsSLFoH86swXYCpaRny4TOfvdBZYvYydaPHKoPsexmXtZ13Zgr
         Mh4PsEpG+5PwaviT/JJFN6UkaqS9Ang09WBo1tcYz8SoLRSzAy7n7M15dszLFUnec6tg
         UW2g==
X-Forwarded-Encrypted: i=1; AJvYcCVklhJ4RGH1WkFoZn+YtlRwF/JnG2U7NREFlTqEdAawiOW4bbI6mebDKHhI+beJCZlG2hi7OWTuPA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzl6PaG8WPeM77BTXQsKFsPksb21VRpgggE1X8zQQMePsO0ZBJ3
	OKMYWLzCUVq5XGGQ0iMK0AmW2AE2OR7Fpg5NghjECMZ9H/uhavxOL6xswjFr5o8=
X-Gm-Gg: ASbGncu3QnVyfnrjfC79anYG4ecnU0+O4Nvw6H+OGUyIz/H/7kYc1iB81WMvr2IyXY1
	9i7w945AM/meizS2ZE6S2mhSGTHwxDBQSL4Mnx6reIMFQa4sx/olkV41cc/dU8BLME3vaB04D/r
	Oejrrjhi60YLJllBuV8POcm1UEdXaznAahbNQhfm76agxpNNjWUWaDspS7vOf+e+52JHhRaDa3h
	8/gWP8elZqEwbRzhk6OOhBjkukpZPHvgTAhq0/XyDTO2BDr8DuW
X-Google-Smtp-Source: AGHT+IEo716tZ/bf64k/pM3NNqQqr3GtHvW/buaqDLTjPaaZqAyM21XkFM8J+8Oq4OWE5W1X/+IKww==
X-Received: by 2002:a05:6602:6b06:b0:842:ef83:d3cf with SMTP id ca18e2360f4ac-844e56ac550mr38232639f.11.1734013713655;
        Thu, 12 Dec 2024 06:28:33 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-844d3d47507sm65658939f.27.2024.12.12.06.28.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2024 06:28:32 -0800 (PST)
Message-ID: <f1f0be9c-b66c-4444-a63b-6bae05219944@kernel.dk>
Date: Thu, 12 Dec 2024 07:28:32 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: possible deadlock in __wake_up_common_lock
To: chase xd <sl1589472800@gmail.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <CADZouDRFJ9jtXHqkX-PTKeT=GxSwdMC42zEsAKR34psuG9tUMQ@mail.gmail.com>
 <1a779207-4fa8-4b8e-95d7-e0568791e6ac@kernel.dk>
 <CADZouDQEe6gZgobLOAR+oy1u+Xjc4js=KW164n0ha7Yv+gma=g@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADZouDQEe6gZgobLOAR+oy1u+Xjc4js=KW164n0ha7Yv+gma=g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/11/24 4:46 AM, chase xd wrote:
> Hi, the same payload triggers another deadlock scene with the fix:

Looks like the same thing, are you sure you have the patch in that
kernel?

-- 
Jens Axboe


