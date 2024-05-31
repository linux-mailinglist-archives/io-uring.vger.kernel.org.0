Return-Path: <io-uring+bounces-2035-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AD1328D66BC
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 18:24:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 62E051F2301C
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 16:24:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D8F6158D8D;
	Fri, 31 May 2024 16:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vhacHjyj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F228A15623B
	for <io-uring@vger.kernel.org>; Fri, 31 May 2024 16:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717172647; cv=none; b=tYOb3fvUdFUWEE09u3ygzE+YGnAvhZ143j1U4jGzS6AjGV2wUEsa4glNUXRg07CJQeIqR7xPmS7I9MbFk/sPvKIOiklqEFHDe9FEP6tpED0P9uD439sNw2qOtscjMe863Ddkk/RSG5m5WKlirM73gJ3X+MGa1ZleGb8x/1c0NXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717172647; c=relaxed/simple;
	bh=lbfmCc0C6vxw1XUTxL5z++ZJIOBzsLoT9JsXDkl9BJs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bCnaWmYr3y8dArgA5E93EJytqfj9+1IkWM0vrPq5n+s8OrdwwkN0KqgiLHBV6JLLvibLysKpWIWSfvNKCR6J8NJo0ASnoSmz8FiW6ZKZfSD3SlgypcMDi8Vq7wfuuwZ8hWrazHmINKTNjY2mNo9JZUyxAdguANWfkBNffr5pnPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vhacHjyj; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-24c582673a5so69643fac.2
        for <io-uring@vger.kernel.org>; Fri, 31 May 2024 09:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717172643; x=1717777443; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rd2v09dpPVB0uQaTFOM+mu5cCEjyqc20z6fVnQytKmg=;
        b=vhacHjyjwhUG+mVVxwjx5ghyvf4UhE+3ygqgAvVOjBSBk4dutnqjQUuNHuHfXGbTX0
         hR+EZ2FVexrqqNcf31ufTlswPNQJTPUn++G+OsWeksDU3i4viEioGYtIMX6EARxmftWi
         M93YPrIq6oBWNLzQs2ZRYowUZpodL7prgIBS7+a2wewVJmvrX/TSwvcr7kwfidnzJE/I
         BEgPjFei8kBJErcJqWr9hbVF64MozNWS2CCB/2zKYHVp0HGAY5MGqNzPJHwVdgyHnd4d
         SzxFfL0Gmef2eA80X5xx5n/jvNoglcPtW3/IHjSD43crBCdPcFGOteiseJaQ3MG23NgM
         naQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717172643; x=1717777443;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rd2v09dpPVB0uQaTFOM+mu5cCEjyqc20z6fVnQytKmg=;
        b=I6LP0Ic6DmVqTvbkWUEOHneFqJCNHxPlQzce60NSd4URy4TTcBUqWtQiN6Hl+O/hCH
         NQh0W6AT3MdP/5+TP8jgeUja69F3TO69mucA8fAnbF3Mp3YaDfIsjsnuR7zVrty0Nr7I
         8KGEC8tPsb0oorpAg6yhJ9OlKwXFntrPI7TuG9/kK0jFOmJuuWWpGRPFTQhzr2lAr4lA
         cDl+wJ58l/nkY7+rNchLutFauo8FkduX83Xwzq+4TPEROz/zMwtyQN9uPgpqxjBpBoKa
         LBgvY8k6pG/lwrG+e9dN1GKdmAVnSqt2bQysqkXmAiSscceoDZbLnn8/TluwbaMZVR05
         rw6g==
X-Gm-Message-State: AOJu0YxwlMtf+SuQ2VlV6S79rXqB1oYs4NWAuYZCjhQAnmOpzBp7LPJa
	Lm2nY6lSImdRoZ4vjUezgYaVPYPzAeQluHVaqR1WTur6Oik1gm65gTSBrXKCoXk=
X-Google-Smtp-Source: AGHT+IFivnw1QES2JYvk0mbF8rmqda47iKxw5iyCB/Z8gLPHMrhzIOsSbr0pKOdfyVdLpn1NDoFexA==
X-Received: by 2002:a05:6870:f71f:b0:250:826d:5202 with SMTP id 586e51a60fabf-2508bd9611amr2762121fac.3.1717172642916;
        Fri, 31 May 2024 09:24:02 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-25084ee76adsm594421fac.11.2024.05.31.09.24.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 May 2024 09:24:01 -0700 (PDT)
Message-ID: <ee075116-5ed0-4ad7-9db2-048b14655d42@kernel.dk>
Date: Fri, 31 May 2024 10:24:00 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 19/19] fuse: {uring} Optimize async sends
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>,
 Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org,
 bernd.schubert@fastmail.fm
Cc: io-uring@vger.kernel.org
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <20240529-fuse-uring-for-6-9-rfc2-out-v1-19-d149476b1d65@ddn.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240529-fuse-uring-for-6-9-rfc2-out-v1-19-d149476b1d65@ddn.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/29/24 12:00 PM, Bernd Schubert wrote:
> This is to avoid using async completion tasks
> (i.e. context switches) when not needed.
> 
> Cc: io-uring@vger.kernel.org
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>

This patch is very confusing, even after having pulled the other
changes. In general, would be great if the io_uring list was CC'ed on
the whole series, it's very hard to review just a single patch, when you
don't have the full picture.

Outside of that, would be super useful to include a blurb on how you set
things up for testing, and how you run the testing. That would really
help in terms of being able to run and test it, and also to propose
changes that might make a big difference.

-- 
Jens Axboe


