Return-Path: <io-uring+bounces-5241-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F31879E468F
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 22:24:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84B40283D08
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 21:24:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24EFC19007D;
	Wed,  4 Dec 2024 21:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="QHgbGh8U"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03D018FC9F
	for <io-uring@vger.kernel.org>; Wed,  4 Dec 2024 21:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733347467; cv=none; b=p+2IcEK7oXn03kavW3XX128jhV3NoCO8R1UMGlYzWDykbdPkhhFir71tuxmD8j0yYbBicyB5lo0D8+wvNOm5dwqMea1bjGoIf7Cu9CTctiNOqdepmwqqHriViUkDWnel9oNc5hg8rx7tkjA3BlxmB1KAbHcos9MiVVWXWHMt7/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733347467; c=relaxed/simple;
	bh=lANPNiZn9wCjpWgldRHJcgcPHj+OE9gFpeBp2mR2dBw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lc8zkM4uO+pN6q6iXmgI9lwJHr9szaYXJ0uKfyPT2wt5HLeDuzqqyqbF/8+s8WvU/itQPiCx7xC3m6RwCkKYlprHstCYrE8DcHm8h/U+ug4mXl+IB7aAtdThAmNz8hBEmnbw4oy75XPE1+ujIhmqJV4D6qPsMw9HH0llPIKBQ44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=QHgbGh8U; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2155157c58cso1329135ad.0
        for <io-uring@vger.kernel.org>; Wed, 04 Dec 2024 13:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1733347465; x=1733952265; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HVxm73LRxMgGtdBIKKSOYaD34YEdUEHwzi3mWR3Ztqw=;
        b=QHgbGh8UQHqn6GT8KT3qSpyX3fDmg/ey2vLn8UR13TVHzFJ8nFM5sidZQJIld05373
         k/QAS8+TWxMgav6FgGjnnt94QmfML1g9bh9Xnr0jRluQAgrn5Ep03sR+mDEhOVkAuVSU
         KngvxeSC7S5TKtGMef15iO//jaEN+BIGnlvFX2OTF2ysrjG8ohom79koHPEJZlTOi2Er
         AEbbRGV7JvreXflOpWjs9+bvAGNKbzWeIH+2tBsPmTIiHgpFgJUHUiGtnRFI8i5kjEO0
         sPN6C/eS/GGYxxbVRbUIMixBC/cnYCJaPrKg/pls9Lx8n0a72jCerGjYsFHpDmnp3CoK
         P2hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733347465; x=1733952265;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HVxm73LRxMgGtdBIKKSOYaD34YEdUEHwzi3mWR3Ztqw=;
        b=MCbXvXFxZa/PSz56GwMxvhv52gRMLAT7Cdv18zzQvlNeJ9MVqPvmhNvUps/ImNzh9S
         iyXIZhgyG3hpTNHh88kdB7cbuMSHIw/pZaNNaZHxhGR5MEMjbe2KFwsin4yjBvQXHdNH
         +afHPoGVIjGJj5pAM+vx8mK+xzJHPLSX9uI8v3YDbjESEil+irRMD4/kjgJ/FnNil2Av
         REGPE8/JvNscvrYCvukhW+iblFGkkalR1RcseZevm/coC0Ny1fdN3+bK23MUaPo+UBLG
         yMqbVn+EH/wh3gbHfI4W/j0U6eSmnZJ4RdP6CsQbhVw97kdLQFLOKVTG/+XrzSQL9Fsc
         BMYQ==
X-Gm-Message-State: AOJu0Yyugw416H1uAtB+cmCz9n1vzqD/4ehv1gMvPVOQwnAnYMLpwo63
	PE7/rStptMIUXltmTRAd3qB1ePtHGhX1CVh03syKvub4IwI4AU94IrhMxuHlCl8=
X-Gm-Gg: ASbGncv1ni0DhFOYQBaCYGoxR34u7ELhNud5Ck1IGvL5DlCrPT8Q9KWgC56oIN61E/D
	YN0p3eoqlm7mWhXzUIp7j3GUBN8HoLo24DLtbFOnysjkwC5qozVRUdQiAoE1vGAWT3fJPS9qhjf
	+7mLvschd0k1tmKPA2mJYpWSNFjlsxnpqx14o7m4Oc+8BX6PI2mbJNYS70IqfPpihTuTRlccdh8
	NVv0JYFDA+dLKyoE7EFI4Mjj3EhAO2c2hNf62++g7Jk/E2+vnpnWJrRr9PON+WSCky0sV/XfAd/
	RfK+Oz/UHUQt
X-Google-Smtp-Source: AGHT+IHpTGPxyFhHO8MRwvjmGdmAjs1Zq0nyCPmZ/HjAV1D2bqZQUoG6G3AE/jVlEnKO6Sau+K1tmA==
X-Received: by 2002:a17:902:cf0c:b0:215:5aae:50a1 with SMTP id d9443c01a7336-215bd11fc28mr123227335ad.32.1733347464923;
        Wed, 04 Dec 2024 13:24:24 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1151:15:44f:b37e:6801:5444? ([2620:10d:c090:500::7:8999])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21530d2073esm109249945ad.73.2024.12.04.13.24.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 13:24:24 -0800 (PST)
Message-ID: <fdc742c6-6b5c-4a7d-b933-b67e22d7c60d@davidwei.uk>
Date: Wed, 4 Dec 2024 13:24:22 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v8 01/17] net: prefix devmem specific helpers
Content-Language: en-GB
To: Mina Almasry <almasrymina@google.com>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241204172204.4180482-1-dw@davidwei.uk>
 <20241204172204.4180482-2-dw@davidwei.uk>
 <CAHS8izO=8C9nv2e0HKWA4Ksv-Hq7yoYH6c+rbZcUXvbVwevwwg@mail.gmail.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <CAHS8izO=8C9nv2e0HKWA4Ksv-Hq7yoYH6c+rbZcUXvbVwevwwg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2024-12-04 13:00, Mina Almasry wrote:
> On Wed, Dec 4, 2024 at 9:22 AM David Wei <dw@davidwei.uk> wrote:
>>
>> From: Pavel Begunkov <asml.silence@gmail.com>
>>
>> Add prefixes to all helpers that are specific to devmem TCP, i.e.
>> net_iov_binding[_id].
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> Signed-off-by: David Wei <dw@davidwei.uk>
> 
> It may be good to retain Reviewed-by's from previous iterations.
> 
> Either way, this still looks good to me.
> 
> Reviewed-by: Mina Almasry <almasrymina@google.com>
> 

I'm sorry I forgot to do this. Will make sure it is propagated in the
next version.

