Return-Path: <io-uring+bounces-3558-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E5ED998765
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 15:18:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF5AC1F2247D
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 13:18:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D84151C8FD7;
	Thu, 10 Oct 2024 13:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ne/FRbhQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9F91C57B0;
	Thu, 10 Oct 2024 13:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728566311; cv=none; b=tqBt597k8tkBMYOK/uOvboty9zr+H4WMT+a74YHmsumWdsiM3QTxM/rs+Wws2qi/4HmdDJRs6J3Z0eEtFYLN29WOcdW8w2wqO7BvmJPDYwYbupvXdQ8GEcKPLD5/im3pxwa0KnRy2XD/KCFkvR633VcEJjO2YIK26aEEFhoygZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728566311; c=relaxed/simple;
	bh=qXy9q0iSHkJyMKk1H6N6KbU2uVtJt0ntlke/Uo5d+S4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I7fPJhEToYO0IeAiTnLm5D0Ttd6SkOKgMS/O4rPFxXncQIyt8sNWFDyHVwIzndsXJFzQFrCwAh+TA1ype3cPSuXzhBeVkd+KIkdPC3jYqAx2vTi7nvfKZKp0PLecr6PL10DwKLvMPJgqM7S4vg7q8CXsd2Qmbt5jq7d2jilE5UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ne/FRbhQ; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a93c1cc74fdso154672166b.3;
        Thu, 10 Oct 2024 06:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728566308; x=1729171108; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7ZBn+lAnzBaHMDuUYp+rp8OVT9yOBl3jTCFjHM6xNoQ=;
        b=ne/FRbhQMKNWcNDbtP9aZ7auhzbLFcaLrrEKAIdtGbzvTnl5bgVj+IiYDQYotOtV90
         34yB69HyeapfYoOLiP+5nOdNnpa/Xv2aXIAeZIbTPs5J0ADAjzjZ5ZksWyWaw43ELCNL
         +L3gpK9stIgCyZ54Afa4x8OzYmnP1SQLfDux9zJt+ogkm376AVcja4KTbAGHB51SUfvz
         xRdYaobseRuMPzsRmpNXAGB8oPYC1txu2lu/uGNiXeSrV1H7lQD6DU0kbkYliykKO/8K
         osVgh7OfGCxi6oLzVGIq+XML7ZznjrFunf+tAwRaLJrcYhpQIebUvrRKvifxFr5kSaPh
         FRqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728566308; x=1729171108;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7ZBn+lAnzBaHMDuUYp+rp8OVT9yOBl3jTCFjHM6xNoQ=;
        b=aNpQYweN2x6YrIyzgCZbim5optJabYCyZjbct8Xm5oNFPx48ZnToZd/a4IyMy/w2YS
         7BcUAL7WZodalUdvuagvp92dd3sMn26BEUlTsKIrXgbq2hYM1cT9ngYZKUYgTxEZHeaL
         AYOo/K3KdaPSBoqvL3Y1/E4XlgH/krSnflTo14zyfETGth9pNIHft5OO+rsPx+vI1c3X
         RdkHIdnf9BuGqpPMg20xiQnb0JDAxEF0FIlT6rfKL7JxuXwdgKhLAc6So5+Eq7zH6aEA
         IULFi9ByU7WVHsSbfe02Vwsw0jCSrzfijqU3AlVqTGXCWUs9Fe5eDu/EmZ/8oZD4wcIf
         LHSA==
X-Forwarded-Encrypted: i=1; AJvYcCVF/uhtvgDkw18s6j3/BgbRbK7JT2DCqqi2dHLdET08UvIYLjO7hjv8DwyQOmiJUrpPx5IJpiw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxK8PkNz+skj1IdGROv0hCKesXhZEPxdxonH4ejDF6Ic64VOomj
	/IBPWJ3uhY080hVLrD3vlB30EDseL+1Vrwv+7MmOul/UZ4KKHj0u
X-Google-Smtp-Source: AGHT+IFo5KkwHjyHhdob4u/bFPM9b/EywFJPe9ioyboNa8H9bMxz1ekuMvRfh9FE+jUBfMWwDlmD7A==
X-Received: by 2002:a17:907:6d24:b0:a99:3214:e6f with SMTP id a640c23a62f3a-a998d32b916mr588731466b.49.1728566308148;
        Thu, 10 Oct 2024 06:18:28 -0700 (PDT)
Received: from [192.168.42.45] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99a7f24569sm88670566b.58.2024.10.10.06.18.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2024 06:18:27 -0700 (PDT)
Message-ID: <65f68caf-d5f1-42fa-b149-6aee5662081a@gmail.com>
Date: Thu, 10 Oct 2024 14:19:03 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/15] io_uring zero copy rx
To: Pedro Tammela <pctammela@mojatatu.com>,
 Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <CAHS8izOv9cB60oUbxz_52BMGi7T4_u9rzTOCb23LGvZOX0QXqg@mail.gmail.com>
 <2b23d0ba-493b-48ba-beca-adc1d1e0be61@mojatatu.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <2b23d0ba-493b-48ba-beca-adc1d1e0be61@mojatatu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/24 19:21, Pedro Tammela wrote:
> On 09/10/2024 13:55, Mina Almasry wrote:
>> [...]
>>
>> If not, I would like to see a comparison between TCP RX zerocopy and
>> this new io-uring zerocopy. For Google for example we use the TCP RX
>> zerocopy, I would like to see perf numbers possibly motivating us to
>> move to this new thing.
>>
>> [1] https://lwn.net/Articles/752046/
>>
> 
> Hi!
> 
>  From my own testing, the TCP RX Zerocopy is quite heavy on the page unmapping side. Since the io_uring implementation is expected to be lighter (see patch 11), I would expect a simple comparison to show better numbers for io_uring.

Let's see if kperf supports it or can be easily added, but since page
flipping requires heavy mmap amortisation, looks there are even
different sets of users the interfaces cover, in this sense comparing
to copy IMHO could be more interesting.

> To be fair to the existing implementation, it would then be needed to be paired with some 'real' computation, but that varies a lot. As we presented in netdevconf this year, HW-GRO eventually was the best option for us (no app changes, etc...) but still a case by case decision.

-- 
Pavel Begunkov

