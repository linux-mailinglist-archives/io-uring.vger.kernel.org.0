Return-Path: <io-uring+bounces-966-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C44E987D0D8
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 17:00:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 206B61F2427E
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 16:00:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3072A3D572;
	Fri, 15 Mar 2024 16:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qRV3Xf9a"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAF244C76
	for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 16:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710518429; cv=none; b=sn1mJEtoUJo35ccT6/PJ+TGdj/10wOOYvRbvAH3eQbHtFRhPNxsSRxGKBZZ7fvu1zC2x3umD4HoberVx7BEVSJYFSL2iAQ1ae+5q9xpJkm+lNYT/gC1NK4ex4swqfryhLRzrwH3BQLamIYdrDvE1Uiw4RknlbdyLTw6Dw/dLk2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710518429; c=relaxed/simple;
	bh=dS257NMoQWn5pczHCLtU883bO4jf4jsc0GeE93LBSO4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iq3D4t1QiAPowt+RPnLxnbDwsWDXIgsduFe1QnFcrTruiTtgmkv50F4yaFw2VA7y8LO1PxG3Y6LKGFpERbbPaa9syj2eVJEiHrlhKkhhVoIZZOuMERzr9VLZARFb0Dedp0Y9uQQS6sR+EG8Ss28sg8qOuCNwK/x6Yd+mSlNtjGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qRV3Xf9a; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-366970716fcso945505ab.0
        for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 09:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710518426; x=1711123226; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QSAiUQ/26gYGYoChbtGi36JWDBk8aj1qdbN4fCTUSOw=;
        b=qRV3Xf9ax7HRp4AaP3QNVJML8L8Dw5oCCIa45rHCog1QuxWlEBfT+bCEY870us2ud6
         kyhAH3R3UwsrBn9bibicZgi5mLgBUL/sIw6ab7RgdkX/7hF7VPsXM2KmTejx552rSDxM
         RB1h9PFEDPSvSpu5ivQ7LHLdtQ1CwKHjD0yUD2A9KahZ0K78tnLfJXwtysBUOURqKoRL
         XsflWCs2ku7QXvbZmoUcUl6UTJ/BxosVQQKPYP7LnunNyLrApYszGFtKdTnke0TOSNEw
         QF0lu6Vjjbg82sMC7ZDsMJBWva1M+a+atJBVRu5XXuCBY03X2WtNgc7/6mAAXlzKAZwj
         ltuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710518426; x=1711123226;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QSAiUQ/26gYGYoChbtGi36JWDBk8aj1qdbN4fCTUSOw=;
        b=XGr2Tl18+K+jv+t+dOguyYa+bThurl2n2+QgCQTBNtAF0S4r5CwKcrmGtuK+suH0lQ
         cPt4hZjAIf2+6EvT0ruvZJ/OVQmaol7X1FUqsXI/mgrN5Y/Rp/pl0KPJsIR/j+E0D+eV
         8ozS2zIpyjSziTvRPv1bNFEc2tVj+ZV9zWgCwHM5YOPfrk/q9sR5t5xr30x41b391dnv
         BIG+F/O2VFADbiqV15jDVzqyXFlwTLQVlib9BYQDyLP7v566kvvyg/x8V6W/m/hAkH2v
         bYR7V47aS88VBTiORe1sCJLr4uUsizdFDPS+SD4/VvPEXlbfSeUrfGCvGjP9paVxKqGM
         HRFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYklF0X60gJnnzzl2ycjP07agheoAa5qaKWnPBnM+qyHNk4a56y4o6Bz4jexKc+nJLGALO+a3vLAvR9w54nuVw3Lo/yyVqo8k=
X-Gm-Message-State: AOJu0Yz8nQZC9BQMsJGPYA/VoKv6//7ceIJj5kFLUodgvm80VNUupLEo
	pY7qoU0RnDO2I+dfRN73N8nD1nmZ4rE7mqRAKD+a/hL6sQyNJmxbQ/v/iXvRfls=
X-Google-Smtp-Source: AGHT+IHK9IFfzOiTdqWihi8zayDhm30wfNbsdFZ00+1KyxfjhpAe+kATAwgjPeDurhqUfUmAMUAsOw==
X-Received: by 2002:a6b:6303:0:b0:7c8:d514:9555 with SMTP id p3-20020a6b6303000000b007c8d5149555mr2472641iog.1.1710518425760;
        Fri, 15 Mar 2024 09:00:25 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a5-20020a029405000000b0047469b04c35sm842119jai.65.2024.03.15.09.00.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 09:00:25 -0700 (PDT)
Message-ID: <971db084-0b99-4556-8466-9a1201f737df@kernel.dk>
Date: Fri, 15 Mar 2024 10:00:24 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/11] remove aux CQE caches
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
 Ming Lei <ming.lei@redhat.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1710514702.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/15/24 9:29 AM, Pavel Begunkov wrote:
> The nvme cmd change is tested with io_uring_passthrough.c, however
> it doesn't seem there is anything in liburing exercising ublk paths.
> How do we test it? It'd be great to have at least some basic tests
> for it.

Forgot to comment on this... Last time I tested it, I just pulled the
ublk repo and setup a device and did some IO. It would indeed be nice to
have some basic ublk tests in liburing, however.

-- 
Jens Axboe


