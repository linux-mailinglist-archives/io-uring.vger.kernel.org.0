Return-Path: <io-uring+bounces-3865-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ACF9D9A6F90
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 18:34:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 58DE41F25E48
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 16:34:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16C6C1E573A;
	Mon, 21 Oct 2024 16:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ou7IBG9o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F069C1CCEC8;
	Mon, 21 Oct 2024 16:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729528420; cv=none; b=fov2ekioK/5QbUbCvuwrtzQ9dkdE67Ia1Tl9GzLRczB0sUD0KGnC6JzvaOjehdj1M71tvqmUcKWTXykpDYHMVTX9xvQCcQkHHGe0quc91aj3jbqW5FL/vCxOMolbTxR2SP//2huNam5xSUjFi8LYKwRRwvS0QRllmsAF9qtQXZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729528420; c=relaxed/simple;
	bh=ISB32DIpmLtQnlKan6hD4y9P0D/fsK+mbBuLqY6L0ko=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UNZqQ92bnzbDhtUZ4k1Ru+yuSQvqMleC+pF00HdDE4HWsEyVaj38/F9tHUTJh9UtFJUkrfcKSa6AwdCt6EKyGFb8+2JmIy0RfQNckkLgcM6EbLOD2h7Q27ItqnremoON5fTdAz6IKZd2nF6li1sxLQQ3QBsIduMPKR3IspcTWVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ou7IBG9o; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4314a26002bso52036395e9.0;
        Mon, 21 Oct 2024 09:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729528416; x=1730133216; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CV7GbeYlI/vNSdUUkxwVHLfDlEaPT9Tp2iK6YG6h+W0=;
        b=Ou7IBG9oEURqrhvpduOYSPAfFZQBolOgQMkV74/nW2rEEFFOKZCjlgWZl0nCg5Y41p
         Bqj9cDsyKAuAyEgbp5lkBEZ1xuNtdgp8HRs21tYdyrPSoIKntx0UUOce+IWQPlefhGK1
         NP0Uo0CLgOSYGSsgcqDWO75f/JlTXcfA/lhsj1Mpr2fBhGMiskBfU9803STEcMAGpC35
         FiJGz++d1YiVhATtU04jRE9kcHp4ky2oZ+RvcIGqZ4O7wjVUGUW30AFMOsFiNHzx+E+C
         gEPt5V/bpHr1xOCrqrE1287X9lezSlDsLoAHxc3BSahocYqsAkdxCQOyLV7N8h4eks1l
         /P3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729528416; x=1730133216;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CV7GbeYlI/vNSdUUkxwVHLfDlEaPT9Tp2iK6YG6h+W0=;
        b=SKMAhPhQYCiLN1UUnVKe6u911j5Mc9qkvfjsfx36bmjhzg7wBOVyCKpx8uxplcnIIl
         5Ri+8QiIkRxknl5g1/yIA8UkQ53peHxx5Ua0fFK5FLLqztbrI8sa2GTXahpKyt14wF5N
         CetVwU1xiwyPR1JN1a6oF5L1pHVm7YfzI/LAXFq69x9kkOcB2pv8Jbd463gVIKgrTTrW
         n/w46t/DKIAna6Uvk74DuYXyvTJW4lSdTcAM5s5YY6bMW0sHTqc5rffCO3wzKS9NyUnj
         niP8XuDWw6aNESI65Acu++8NUiWlMCCAXdok+hfYt3cRql0cw9NknsLCX/2B0A2LqbA0
         ukzg==
X-Forwarded-Encrypted: i=1; AJvYcCVOTZiaQw2Jyo2wLiQoXMnagfFpZnvVKC3/tts7G2Ne7Fy15V07kKuVHNoPVduq6lPQn0oyCPyC2g==@vger.kernel.org, AJvYcCXl/iof3dlbEaPLwa0504rZ0aH3tdHbLv39/QKHR8z6qLLT67G5Dd+0qj5zckPAsXH585TKenXI@vger.kernel.org
X-Gm-Message-State: AOJu0Yyoyd0gRJWXhztk3ECpdIWiE89rZKwVDi04EHpJHxU8seEap4QP
	f8+jWnkBCyVQXhMnGi3vepUIIHHMQqMTqNnzrO+UlbSBobeeRudo
X-Google-Smtp-Source: AGHT+IEU/PiclPdoTFCrm4ZdZBqTYZ1bOwcpfgJd9E+hv5TULHlQvupbFlIedLwbZ3E5Xo1mpy3agw==
X-Received: by 2002:a05:600c:3596:b0:426:5269:1a50 with SMTP id 5b1f17b1804b1-4316164b0camr96860725e9.11.1729528415982;
        Mon, 21 Oct 2024 09:33:35 -0700 (PDT)
Received: from [192.168.42.158] ([185.69.144.55])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37ee0a47b74sm4692001f8f.27.2024.10.21.09.33.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 09:33:35 -0700 (PDT)
Message-ID: <5eab8684-4dcc-433b-a868-0ffdd656157f@gmail.com>
Date: Mon, 21 Oct 2024 17:34:21 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/15] net: add helper executing custom callback from
 napi
To: Jens Axboe <axboe@kernel.dk>, Paolo Abeni <pabeni@redhat.com>,
 David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241016185252.3746190-1-dw@davidwei.uk>
 <20241016185252.3746190-9-dw@davidwei.uk>
 <cd9c2290-f874-49e6-bc99-5336a096cffb@redhat.com>
 <b5d1ce8b-fd7f-4c14-870d-a169d81629fc@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b5d1ce8b-fd7f-4c14-870d-a169d81629fc@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/24 16:49, Jens Axboe wrote:
> On 10/21/24 8:25 AM, Paolo Abeni wrote:
>> Side notes not specifically related to this patch: I likely got lost in
>> previous revision, but it's unclear to me which is the merge plan here,
>> could you please (re-)word it?
> 
> In the past when there's been dependencies like this, what we've done
> is:
> 
> Someone, usually Jakub, sets up a branch with the net bits only. Both
> the io_uring tree and netdev-next pulls that in.
> 
> With that, then the io_uring tree can apply the io_uring specific
> patches on top. And either side can send a pull, won't impact the other
> tree.
> 
> I like that way of doing it, as it keeps things separate, yet still easy
> to deal with for the side that needs further work/patches on top.

Yep, I outlined in one of the comments same thing (should put it into
the cover letter). We'll get a branch with net/ patches on the common
base, so that it can be pulled into net and io-uring trees. Then, we
can deal with io_uring patches ourselves.

-- 
Pavel Begunkov

