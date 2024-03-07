Return-Path: <io-uring+bounces-851-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D221875002
	for <lists+io-uring@lfdr.de>; Thu,  7 Mar 2024 14:33:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DBC201F21483
	for <lists+io-uring@lfdr.de>; Thu,  7 Mar 2024 13:33:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2812C12CDB5;
	Thu,  7 Mar 2024 13:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nSkh68G5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B5412C80A
	for <io-uring@vger.kernel.org>; Thu,  7 Mar 2024 13:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709818417; cv=none; b=PnmS99H/hSfI6nI07ztTNDfs5ho1a4gE4I3xEJuYdh4+/dkp2XaUoNzCTsE2Ci2hpQHloVaRRFKAGJizCuomo7LT9OeaJu+swfOAnVtqF0xytz6FnBDIh7MZ15pKOdHFu2naT6XzOIB21vdrLH3CbHDwriSp76YO73+NWt22gkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709818417; c=relaxed/simple;
	bh=ijVQ8adAvTsppTRk+BKJvGSPVgOzwDDOci0RIM0hPKI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Uwt5aqge0/td16pcWLDzCZPpTJbhsvGgeSfk9vkrHdQIsfz3yhpWQMufSd7KLztouzemPiYo/1eIbA35CtVfOCVMdKbj85186zwXdzNYp9rciVn3RxxsmZGFOCHDCkHvT9xgy1TFshRZIMe57wix6JSbptEZTTHEQfhhijQr+Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nSkh68G5; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5a1b939f18dso39175eaf.1
        for <io-uring@vger.kernel.org>; Thu, 07 Mar 2024 05:33:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709818413; x=1710423213; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mUWcc1HDGmcy/cfWbsKZ0KeY8UR61VXyQjdziGDDjFU=;
        b=nSkh68G5BFBjo1ORQ6m/MlxjBo/UC4PUgg/NArfooF7F46q+MgbsA/HVWjNo4QWbEe
         3UYtoO/B8U6V3bzJ5ypoT4NLiDZx6llHXNKu7p5wssA8aMePtBMRFGEdQXvzC3K+NW7z
         QePfDAcjTObGtVY/4vR8o8g3V9mcc29SgKx4XFr+eqwhG16ylrw5zIACATJVjqFSPjNi
         f/ijcIggOm3VarzNp8B3FNFsuGo450FpggT1Ha4koWTnFSWrgKggqpElmPqKUy3lOM4S
         +iI89g4Pl3wgEEN+r4qCdCttMOgBETuDWzwQwiPQKOURKYdjcyB+Ql4XIvwB58SMKT9M
         0lHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709818413; x=1710423213;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mUWcc1HDGmcy/cfWbsKZ0KeY8UR61VXyQjdziGDDjFU=;
        b=TBajyqM1iUxeuaAWwfYo3972Q+ezgdaAIjju0ZSAp6k1Dh/epOFyjAt8texobKmL5i
         aYjgYvvqqO1SVYUBTPkGXQQkC3yKrRxRiGY3QKv7BSvwjFFTucRTIy60PwqHtI/uFJVl
         LA6tUoM8oRs8gdkuEZdFFImOgk7Zmes5kiDmk0EsWkWODdGGRTW449n0plVX3Esh/vvl
         ofgacm4bxjllkbtCn/NjzdYeysv99qAOukxLd1sUaRkGBd2cYzmraAf12jniIliBAY5A
         13gdvHXu99XFJC7fkuhF7v4/MJgCrMa2JXMOeTOqn/lxuvJijcEhrR4knmiRkDB2f0Jd
         7f2w==
X-Forwarded-Encrypted: i=1; AJvYcCVK2JTXuFOSYNjcW9io6cAuuPGFfABh08L+s8uQ+7gOxip7a3ShYFpO0/rQrYqMJ6IIl71PeV5u6mXI3NaHq0gxU4/d7wU+2T4=
X-Gm-Message-State: AOJu0Yw69IO/03Wrho7arEGColq2P2CXsONQumPvVsxwTCqcNe0i/6Fv
	+3qfN159V3gY1TY3OFeEFIohUjdHehb3FEd8pW7c4rLHlslqVMslTH9HJZw+DkU=
X-Google-Smtp-Source: AGHT+IHJ17mrWk1DGwIza8IdnFHUcovBYqvVAjnM/OWknP1xeP2hcX+04ieGD6U9JeFCURGnOD23EQ==
X-Received: by 2002:a05:6820:2c12:b0:5a1:b8f4:4a15 with SMTP id dw18-20020a0568202c1200b005a1b8f44a15mr969331oob.0.1709818413676;
        Thu, 07 Mar 2024 05:33:33 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id l185-20020a6388c2000000b005dab535fac2sm12398888pgd.90.2024.03.07.05.33.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Mar 2024 05:33:33 -0800 (PST)
Message-ID: <faf44f4f-1aa4-4d72-9a32-8038a6554a9a@kernel.dk>
Date: Thu, 7 Mar 2024 06:33:32 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: fix mshot read defer taskrun cqe posting
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <6fb7cba6f5366da25f4d3eb95273f062309d97fa.1709740837.git.asml.silence@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6fb7cba6f5366da25f4d3eb95273f062309d97fa.1709740837.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/6/24 9:02 AM, Pavel Begunkov wrote:
> We can't post CQEs from io-wq with DEFER_TASKRUN set, normal completions
> are handled but aux should be explicitly disallowed by opcode handlers.

Looks good - but I can't help but think that it'd be nice to handle this
from io_wq_submit_work() instead, and take it out of the opcode
handlers themselves (like this one, and the recv/recvmsg part). That'd
put it in the slow path instead.

Anyway, it's applied, as it's a real fix and any work like the above
should be done separately of course.

-- 
Jens Axboe


