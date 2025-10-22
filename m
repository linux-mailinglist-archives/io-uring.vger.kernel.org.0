Return-Path: <io-uring+bounces-10136-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9222CBFDC0D
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 20:02:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38FA719C24D9
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 18:02:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8E2C2D0C60;
	Wed, 22 Oct 2025 18:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="D6avh5Cl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EEBB2C15A3
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 18:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761156127; cv=none; b=XEB/XRFZGtsw7j1AuS0KzsYBFOjJh8oNRPtmEQ0owKhgYpwfL6jSdBwX+dRQ3dEpAapOaEP3h3nlnenKPR+r6MnvXzGI9sB1exVsyeeatO/3/dfh2oNmNCB9FgVxiQY3VCDL6OW9OKEZFTvQP6RGay209Xr5vVHEFq1mXmqv4WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761156127; c=relaxed/simple;
	bh=TIXl6G8S4trdGMef44ymvUD1vrTlX/NiGwAiuWM56YU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ILxF/Ys1UO2BtzMOMmM+Gpu1wJrxvmiSiXQXqkHXJ+cPIjm9Api9hpeTjEjuomJIgxvJQ8BKXgdoOQ1f4NAjYqssxAPbDDBrWHYoUoAeqaBW5F/0PKUOLoTm5ZRjyieR8fxyONiU4jdSj9pe/5s0EX9ieAC7aHVwDeUyY6WX53w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=D6avh5Cl; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-430c17e29d9so32062485ab.1
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 11:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761156124; x=1761760924; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xk85zOG/MZ7yZqz+1vKNWnNsIRxn3oxcKiRyK7bSrh8=;
        b=D6avh5ClG4Q4fwzkFwmsZT9iPEklSwoQo4yQ65FpyhM4ULX3SyBOgbufXzY+w73Hff
         OJqxurxJZflkX5dLbbKjN0DYyd0GqTYBNi9bisLF1UPU73ZIZJTNjcNEKjPa0+dQy6ln
         DA6RJq+1CgQAOBkwP0MZDLU2x7b5Xt7esguTLB1AzR2RIrmGZqCSzPs3XsB5xyFcaoZY
         IV4l+A+CNpNcG1HzTYmc/L13c9csVpKhyt2eK75qaxlv4oo25/QBsNtEyQ926OtkMv/j
         zmxzrz76Fdus7/+KGxZnyJg1lgx83uVuyubNKupLoOUVAGgUPnROWSJ9TqdKcwiFlSsd
         67Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761156124; x=1761760924;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xk85zOG/MZ7yZqz+1vKNWnNsIRxn3oxcKiRyK7bSrh8=;
        b=PQt+flDZM1EuLq0idTVmtl/WyAvl2QxRRac7mE/BKBpI74CBT6bouhVoEWIZD89wDo
         L7evYcBjyxBrwtVU/TBur2D2HGFpG6wMKWpSpg0RBu5OmNyaqCi8VqFrkUnPwgmaaVbL
         gBMAe/OxRHkVfJFxirz80It34xZ2AiVgwaxu5zTWi5p594I4D5tNMIvgW7JazMqeUTYK
         cTbxn0E8J7d0cwLkBYD7hFLbi2q/r184/T35vOcgkdHpnUsFC5IrmwFAM36lq7KnoXio
         /l/gqQJc93RtcDfXSVLzOeOpM4SRSbevFQr1B487RtV17ZTMsjEwqpAxCYuh9V/B21CB
         zm1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXOtyRJGbLSJU6AYIWJK2vKoGD5Sz8pSG9vGuwqLLqX1HGDxbgFUzJ/+O+g/LFQ13OyAhrsNMjStg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzLE8G2Ahk9wlH6gir+CnZ3LQAJSOcWrAKZs+N5SoCw2eSKz4AA
	/YR8+oSRaTed6pBXbgPgBHcyXGGJjCyPrScYBafpImpXjvOr/tX7cKC+vJ5f4sCdY3XigaVhU2F
	jfkEfyuw=
X-Gm-Gg: ASbGnctMLQQ1DUdlNekSCpTxRbd4zg7klrH0RYzm0us6QGJYLIZA/5M+lGZEqijkBqo
	t1TjnxPuRR1uUzJHSVkxmmpRO7nprrFrWw/HnQAh8HN2Ri14UskXDFeCoD5cPBQVrnMpG8UFSTY
	TWT9Yzm+8pCQVPWXX/bdTGdK0uM/mYHDXeJAnoEOelRbQXOp17TZkED7w4ejuDwFnBHA+/8ZimT
	vWVkZGDH2BvbIxaE5ToFptArcJjYNss8CFAfM4slVhx+SCVKAzgc4cRMVEfpEmcjcmWskhsBPhf
	poybq73NIchdXWEpNFwSE5JnnHG6kaT92t+99AKIFO4DcEBvIhwDMNEPzRx9dqeHk9YzX1tmF4v
	KmQ+dvtQYj2igOmdmi5oKyspBMpKrdRBLA3gE+H59RtMLIXJ0N/sIWPl7Uk1mY9fVNu8cn04U
X-Google-Smtp-Source: AGHT+IEG5j+t7fzvNIpKjQomq4w0E6qaFnJr0gFUylF/bfzhMcfUHGXP+A3wxX+wleV/QmW38w9HBg==
X-Received: by 2002:a92:cda3:0:b0:3f3:4562:ca92 with SMTP id e9e14a558f8ab-430c525f520mr115161615ab.10.1761156124180;
        Wed, 22 Oct 2025 11:02:04 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-431d669b925sm8187105ab.13.2025.10.22.11.02.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 11:02:02 -0700 (PDT)
Message-ID: <f3b648e2-94c2-46c5-8769-a59e89890910@kernel.dk>
Date: Wed, 22 Oct 2025 12:02:02 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] add man pages for new apis
To: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>
References: <20251022180002.2685063-1-kbusch@meta.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251022180002.2685063-1-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/22/25 12:00 PM, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Add manuals for getting 128b submission queue entries, and the new prep
> functions.

Thanks! A bit of too much copy pasting in terms of versions etc, but I
can just fix those up. Also needs a bit of man formatting love, I'll
do that too.

-- 
Jens Axboe


