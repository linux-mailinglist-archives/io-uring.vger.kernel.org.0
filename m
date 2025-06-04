Return-Path: <io-uring+bounces-8208-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AC94ACDA3D
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 10:50:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B5A23A485A
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 08:50:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A37C28314B;
	Wed,  4 Jun 2025 08:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jtAzd3l9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24E2231A57;
	Wed,  4 Jun 2025 08:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749027037; cv=none; b=Drt/BEAcjnm75Z6HfsStKBqLk+jCTYWb0/pOHeycB3o0yB7khCtioVGLgtOGcgDa+ys9g6Em1/qobrCM5+zkbytvuLL84ea0ezAcFxeRuaH17HcHR+Ak7wU5apvtog8kIsCGxwSo1+vZDoHxzzDoZ1xoTlpWCz9ziogGDaBaZ44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749027037; c=relaxed/simple;
	bh=ltu9mzV6Vq+XyGrQABCmGnei2uwm4HnFL2Iyy6ThvtM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qpk//Egga8zKtAg6ja0om3BD+Z5GdZeDhPhPbVvJJfYh7ecwBz0Q/vJCbWyDwjJSZdmbXxO6AuRi2scRPUuFKX/N+xYUA+gicv+Cr5Dj7TCh8i1KY6tBjBO/z4HTXcY0n70cE46mnaro4bUswHfzRvAX4GGFgMrHtC2PZz9RWKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jtAzd3l9; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6020ff8d35dso1508298a12.0;
        Wed, 04 Jun 2025 01:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749027033; x=1749631833; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GBq+VhZUNf+P5nZ2UqIFnLSYKsdXYI6VPPRPAW8VSck=;
        b=jtAzd3l9L9BBXc0zUA5j+DiafQo/xOP69If9mTLBuqDksQSxZx2Ih8WPt+Zojrc/lq
         j7gUUTLfswIItySalIMtOhvxsJO72I6KqCSx2nu8fkumbd5AQn0TsC+eHWbdcdNyU3wW
         1/wODG2Ax11T8ZY9JeM/49KcY+IH1t77Z81KMWsPInfAfXYSE9w9Ho6h+7QSY9jFBQgA
         0S9Lq38eDgQ3j1lTIwstYt+w9w3kyCMGlt4QB9ouE/EQCQp34KkZWHgbWrCjMDKbW1mn
         RcgPPphzT7QZEtQ2Ld5Nzen2RNnwtWVIKJqju2Kk/sAifQP3YPUlkxXOSQjYg+go9URS
         2KIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749027033; x=1749631833;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GBq+VhZUNf+P5nZ2UqIFnLSYKsdXYI6VPPRPAW8VSck=;
        b=Wo83Y0TJHu4jlKZcFWG4oL3yG8+q8YWbmiHz/6rAiCrfw72XdlLSrrhhTPBs1aHD+x
         lSnvpmzkdLhp87n9+pexnzzm8liNouA3O5a+kd/4z0UACDbuQcEbIx2AuTVcsQDBbVcI
         r1duN71u2Zhtu7vTQsoidmHehTfdCCi075R6elOcyqHzwXMZ33tQ61YiWY3bdPYkB9gD
         UEViZzlRTA/wQvkfjj1OXgk/dxnGf8Agi95/EeTBedc505xtp0aN43yL96r4OaLUrPeV
         ms67KbFRHAQsj+sqCE/pg748Y5ti/qKS01Ge7gfWhZZFZ9A7DLkSj33aMp62cnY7mN38
         F5xw==
X-Forwarded-Encrypted: i=1; AJvYcCXulIGjj4LhjcBprpePdp+YNWh00qz8SCENeU7DUMUQwaBhySkAtzZJKq1/YK0n2HdaZ7av41VM+Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YzVuzqG9qGLGhm6FVIJRGMuBIHW8OhYhfsOGZjKOXXHUp+JQOa3
	u7j+B5wSoc5jKRJDyh/XBeARru24URsUm2lBQTJ6LvibTI4k8yg8LGqL
X-Gm-Gg: ASbGncv2Gf47xgIQpaAbWybGzHFr9hMVyf5CGxciS2MvmgteVtzflKNLeqGQgn5ql1b
	m8qfBDTjojf2511UfRCfbjSytkk3iX0WcThY9glv+RJ+wVSpJZGcqbtKqAXYhzdthF2pIrvK0l6
	e4uxxyF+7xdUxwyCC0okyRQIYO6l9cWNXHv/Lh1/yf8MNPxYbCXhKx7wJDvDte5aj9uHRmbU1vR
	CqpSHiGFtskm2DMW3x36+mCuRRRY4sD/lkKrRHhfRTh2QNAIkcfLLmEvlP/MQbfhbHgwriqNOTA
	ZhIro7s6HmijPmeaaV4h3kJyAwyw8uIFAvBo66LgkFjXJ0TlqweJ17vPt+faoggHS+NLno2Wjow
	=
X-Google-Smtp-Source: AGHT+IGqyr6Sj1icSYtx3y0ovDby0IaR/trKQnM4KSOFiHa4OPNqXYIMrNQ2+CdFNVS5IByN3W4e7g==
X-Received: by 2002:a05:6402:1cc1:b0:605:c570:57de with SMTP id 4fb4d7f45d1cf-606afa11824mr5595999a12.8.1749027032770;
        Wed, 04 Jun 2025 01:50:32 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::26f? ([2620:10d:c092:600::1:b3d1])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-606fe850afasm315989a12.78.2025.06.04.01.50.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jun 2025 01:50:32 -0700 (PDT)
Message-ID: <abd16c0d-480e-4bc7-a4ce-6775e6068e70@gmail.com>
Date: Wed, 4 Jun 2025 09:51:53 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] net: timestamp: add helper returning skb's tx tstamp
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 io-uring@vger.kernel.org, Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, "David S . Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>
References: <cover.1748607147.git.asml.silence@gmail.com>
 <6e83dc97b172c2adb2b167f2eda5c3ec2063abfe.1748607147.git.asml.silence@gmail.com>
 <683c5b38ed614_232d4429431@willemb.c.googlers.com.notmuch>
 <07d408c8-c816-4997-ab87-1a6521d0bacd@gmail.com>
 <683da7b621fc2_328fa4294e0@willemb.c.googlers.com.notmuch>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <683da7b621fc2_328fa4294e0@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/2/25 14:31, Willem de Bruijn wrote:
> Pavel Begunkov wrote:
>> On 6/1/25 14:52, Willem de Bruijn wrote:
>>> Pavel Begunkov wrote:
>>>> Add a helper function skb_get_tx_timestamp() that returns a tx timestamp
>>>> associated with an skb from an queue queue.
...>> ...>> diff --git a/net/socket.c b/net/socket.c
>>>> index 9a0e720f0859..d1dc8ab28e46 100644
>>>> --- a/net/socket.c
>>>> +++ b/net/socket.c
>>>> @@ -843,6 +843,55 @@ static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb,
>>>>    		 sizeof(ts_pktinfo), &ts_pktinfo);
>>>>    }
>>>>    
>>>> +bool skb_has_tx_timestamp(struct sk_buff *skb, struct sock *sk)
>>>
>>> Here and elsewhere: consider const pointers where possible
>>
>> will do

I constantized the sock pointer in v2 but can't do same with skb as
skb_hwtstamps() and other helpers don't work with const. I can follow
up on top preparing those helpers, but to avoid cross tree conflicts
it's probably better to leave the helpers from this patch without
const untill all is merged and pulled, hope that's works for you.

-- 
Pavel Begunkov


