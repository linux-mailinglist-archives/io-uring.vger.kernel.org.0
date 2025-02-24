Return-Path: <io-uring+bounces-6706-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E821FA42DF3
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 21:34:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A856189B5D0
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 20:34:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 070EF22E017;
	Mon, 24 Feb 2025 20:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="WCnEyMQU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A25353BE
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 20:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740429238; cv=none; b=jMcV1vs5zoeTazmbZRatfsfemJSPCxpW0t8+fNdkEwwY4CWeY+RatudC1KLVbqEFNDjRJp36xuVrSTp29nKHqf49o3cnJ4HMUWUXHjymj4xsT22KvhzBsKXn47wrLbDAte7vgtGCY66KqCkf+42RFvsLdqn4dcVInETB4C8zCXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740429238; c=relaxed/simple;
	bh=j+9ETdUfvnGeq3Eg7kc14rJCb71WTe5Jn9bdRFtTSVc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y4A2qWuRFLndSmHbnHu89SbHc0iQLw2eAWD/mAq5eIy4edrsrYAIKb1JwTzS+bSkqvbDYTmwZeCwrHNXWSX9kPLC9Xkw96raub+t1sMM/eB0uTGZbRuQvnIsp5owUDJhCGdrECh1OeSfoo+CAEC5wBMQ7QAg6bIeFojPZKlq4Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=WCnEyMQU; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-221206dbd7eso100047445ad.2
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 12:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1740429236; x=1741034036; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lLfs57J6jTBpXoj2fs4I2EiYCXEP7ocPOaEkyIA+XJM=;
        b=WCnEyMQUf0fQK5+xZGbM/IDXubKUXE4u11bpQ2QY5WgG0b+qFl+kicAfP85l5WeK0T
         ffyUq+6w58iQ1Iv9a4f/XJ7QCILOAdW5O8qFv7F7RJPZJkdtABgzx0/vd3XdOQLtXRMi
         3G3dzIDc7K/z3J2vngMq+Grhq1vXIUG01gdr9v/kBn/x7yeQhao1dYFbxSC6D3DwFlvp
         NB7t7PnVncbd+s5q86mYyDN3rVLa55QSO/xzWA4Hp/EvH7XeyOHeIO2nl91rbzh+2RNj
         njXCboOAZPMU86hp4qlPjD0XKe1ycvIjoB12YFcIfA4R6ccaT3G6WEYJEfzWVAez3h1q
         GKew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740429236; x=1741034036;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lLfs57J6jTBpXoj2fs4I2EiYCXEP7ocPOaEkyIA+XJM=;
        b=cHrDFekLF1kLW3bQYV27VjiGADrxM5EkYXroIn4meHfcyZXaMZ77PajQs2JDLcJ7Jo
         GPdfXmamL84YlfS8B7bHhk9/wY/kYTgemFCNZHY0AX0LN3NFPRxa2n+HcEtcWEyZnsWT
         dEA7jj+IFcmUE+j8IHGfWz9SIhMKQv1IOA+JxOK2bPBlRN7ruDusQyowHtHT+oCDB8JI
         L/iLwXovG1le08MTTTbaKv27RqLCuiVrMtG2bX/2BQTD16OhV7B7k8CO7vXTwxz+jSv2
         aZuRGVDMN4HnltyBFUMm2BaVQbo+8E1/K2ML51qJqnuqgL+XPUX+jNnhc2/v1zdDiyfI
         3WUw==
X-Forwarded-Encrypted: i=1; AJvYcCXtcvT6IGc+L6d7e07iC/PX+ZTnY579JbuC4pRbpawotrXe1QfC2nV4+GLeRN6/HLYy/eVBN1ciig==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyrq4APnqkVXNECfTYW614Y/fzK0dXw0dc9J2GexHWxfD2+DVzP
	TuagCTse0NfmyyY9+dta3DZ0JWBTmKmg4tIK7v51bIYCzs/iMA0aa5LuqJooHaCFXK0WdngTjAj
	X
X-Gm-Gg: ASbGncvxtAhUoh5sIyEUDN5KM2j6KT17H1ON5vsuvu7WrqQGDmn/cInzkruUzLfr3RB
	UHaVBZIosiJJ2CAj3Eoy0MwYhrsDqvR86TtbKe3uoB0MSFqy5Aybgu8G/6SQFjk4+xQAD+fkSYe
	WEHyK2NgaM0FTf0qpeirgGJ4AbhT1WTRNpYrNBIIreg6TgNd+HIr+1bY+h/+VuIOpKWr01mvsdl
	5oeRbKFIatcJq9YAaES39hvB2QAe3fedPE27nmdnbQTLu598p2EakhPCizDbQ1MNiNPaw17LNgs
	0elkxabxMxBxEqLr2IHf4c6XzXIq9lmbxEXGmGoPfMIIhkoWiufTNuBymk6L83wr
X-Google-Smtp-Source: AGHT+IHc308sFhyHxAb1zSs7x62wP6oNF2d2eVr+/rePEVe2E8w9nFQiLRKQgHCxu9pPtaUETU2yiA==
X-Received: by 2002:a17:902:d4ce:b0:21c:1140:136c with SMTP id d9443c01a7336-2219ff2605dmr200196945ad.3.1740429235718;
        Mon, 24 Feb 2025 12:33:55 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1156:1:18cb:90d0:372a:99ae? ([2620:10d:c090:500::6:5f92])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2230a09301bsm225945ad.136.2025.02.24.12.33.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 12:33:55 -0800 (PST)
Message-ID: <531efbe5-aaf1-47a4-b5d1-a5c5ce9156cc@davidwei.uk>
Date: Mon, 24 Feb 2025 12:33:53 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/2] io_uring/zcrx: recvzc read limit
Content-Language: en-GB
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, lizetao <lizetao1@huawei.com>
References: <20250224041319.2389785-1-dw@davidwei.uk>
 <174040774071.1976134.14229369640864774353.b4-ty@kernel.dk>
 <17c27735-a613-4bd5-89df-645ae7ed83a2@kernel.dk>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <17c27735-a613-4bd5-89df-645ae7ed83a2@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-02-24 11:56, Jens Axboe wrote:
> On 2/24/25 7:35 AM, Jens Axboe wrote:
>>
>> On Sun, 23 Feb 2025 20:13:17 -0800, David Wei wrote:
>>> Currently multishot recvzc requests have no read limit and will remain
>>> active so as long as the socket remains open. But, there are sometimes a
>>> need to do a fixed length read e.g. peeking at some data in the socket.
>>>
>>> Add a length limit to recvzc requests `len`. A value of 0 means no limit
>>> which is the previous behaviour. A positive value N specifies how many
>>> bytes to read from the socket.
>>>
>>> [...]
>>
>> Applied, thanks!
>>
>> [1/2] io_uring/zcrx: add a read limit to recvzc requests
>>       commit: 9a53ea6aa5c87fe4c49297158e7982dbe4f96227
>> [2/2] io_uring/zcrx: add selftest case for recvzc with read limit
>>       commit: f4b4948fb824a9fbaff906d96f6d575305842efc
> 
> Fixed up 1/2 for !CONFIG_NET, fwiw.
> 

Thanks, and sorry for the noise. I'll be sure to compile check
!CONFIG_NET next time.

