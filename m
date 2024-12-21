Return-Path: <io-uring+bounces-5591-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 389559F9D99
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2024 02:07:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A63316CAB5
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2024 01:07:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 128EF748A;
	Sat, 21 Dec 2024 01:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c3O/Sllx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641F3A59;
	Sat, 21 Dec 2024 01:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734743218; cv=none; b=anJUxFIdm0CdbmmpOL9WRQP30e+rVkdOLdwVwIqyCKdC9cD1CJ5xyEiIM4iKm5Ar3Q75fJnsvVEINafDOLVeFRuSdxn9aOuQw5BYSAX9saToRFqlAp94uYMvSUsDvvlndWTbPhYwhPpnD8ikjeTLpCiInfVO7d8AoDiUl8T/FIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734743218; c=relaxed/simple;
	bh=XvIeZ2LFl9fDkI5kGQ68eooFzuk1Mu5NWZ7OXwcFUMw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RFujoZez/DbmKcN/b3zFoNc7pLGDSwNe3t2plZsNlTZFR+eVA3hivl5bi+QF/wRWxP15EJ+PDuq0DiKmUpx2Cx0Lc4yZX9Yvz/Si+6ZAI6e0B1+n7FhR29+h/KpUFzYURSPdgwd1/QRjjgqfIe6OO1KnPIF3O42BkkUILvPlL4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c3O/Sllx; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3862b364538so1418810f8f.1;
        Fri, 20 Dec 2024 17:06:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734743215; x=1735348015; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Uf1aPw9hT0CVE8rhSPlHbIRPFwZbEd+3ihpvNPQheR0=;
        b=c3O/SllxJeXB4u50pSJr3ZxYfjTOjQSMSmLcLXvoF6i55rqI73ZedtSOVpbLWaKU2m
         NQjHKH0+uh9hKHgpmpdeElZvvbfddlgaKSREwb6HqEoycXix7WtQEsh9ul1ZIuGFWnqL
         tBqqbKsjZ2LEm2Xmo/IS987oJbMkL75CCpqDZh92qcwPqiMbw4xUZOt3lTa/E3GQASXf
         0bcxgD+9piPENobR4vuZVGhaVqxM6wDx0XCBg5cmpqGDQ+irjlCy6p+/FiM4JcfNJtGP
         f8auze4XG2+SkTPQiCE5wrJht6awYTg9DwPI5s6kCG8KLjxYcQ+De9lAnJuj19B2xLw5
         RI7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734743215; x=1735348015;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uf1aPw9hT0CVE8rhSPlHbIRPFwZbEd+3ihpvNPQheR0=;
        b=PNplUxUAgh2lu6s3lnLjr2q5RMdzy4/CyekgXBBSI27nrKaIfHuOXTOthjJA251RDU
         bqYhdwkTcxnU1OzCw5ndUIzwNtD0YKG22WMcDiWXXMoe61njiUai7gm4V/mkpJQyswzA
         3lN4CzFkCGd6xTPQIi6SxvW/cGyuV3Dv2h7nNMHhWMiTR3rc3XPuhKb72wSBplqjRVnz
         Ptox4Iq6DqrP5WcU9s1kmBF+vsTLs+gAHyS2l3IviuF1kGgjhM35teneA/SUAysvy2ky
         xpKjtNcppLcKt46cindUiow3r2rCkDtT1v46y/DFgy2siSnZpAbafYbkTEIKQ9mRRz+a
         6Giw==
X-Forwarded-Encrypted: i=1; AJvYcCUO3q4z8NHmw37O3DhpmOyP4r1RNRH9ifiF8/A0JK/2Z163EKXBJWP7VPrxZmUjtuMW0dA7BvE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPkbcUuX1goxYlb5uecJ71yYO3LKc+NH3ChKyMrNfmphoFs76F
	L/ug0ApJgnGlh1eGnWsLJVzaPQI/F6bT5V0MbF+OJcN+rQXWzJIHElWgGw==
X-Gm-Gg: ASbGncs7CiA5dz8ZwgCpU+h1dDb3bCH8vVJM+7hpWSXTsfBWPqHVl35izceVBPZvJy8
	URmwv1jkDXmX5hhjMyXwigHXepzfw7dcsxGQ1s4cdXV193ZtK8ktqOWjG3an3pZwusBppyZf0Yz
	Y75GTrYEDAY4Cx7EpbfgIocYrS6trJLab+00uRHsBuN1eYxzyOUI+nfm1kkFa5bAuB+l+kygzEV
	9Nge16M5ROkG7UsWowWJpwgvsNdp+dFH/9c08P/+OW4Oq0gsO4vrifY8M1VM1vRJzo=
X-Google-Smtp-Source: AGHT+IGt6jqyvOoh/bTQ6NILWImDxL/FllwZLiB7ECRvJVGFPlV8OKYjhG/aMpJCCTN9IWnI+6Kbzw==
X-Received: by 2002:a5d:5d09:0:b0:385:fa30:4f87 with SMTP id ffacd0b85a97d-38a2276a0a1mr5088619f8f.0.1734743214411;
        Fri, 20 Dec 2024 17:06:54 -0800 (PST)
Received: from [192.168.42.184] ([185.69.144.186])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c8a6cb1sm5398593f8f.89.2024.12.20.17.06.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2024 17:06:53 -0800 (PST)
Message-ID: <99969285-e3f9-4ec8-8caf-f29ae75eb814@gmail.com>
Date: Sat, 21 Dec 2024 01:07:44 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v9 08/20] net: expose
 page_pool_{set,clear}_pp_info
To: Jakub Kicinski <kuba@kernel.org>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241218003748.796939-1-dw@davidwei.uk>
 <20241218003748.796939-9-dw@davidwei.uk> <20241220143158.11585b2d@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241220143158.11585b2d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/20/24 22:31, Jakub Kicinski wrote:
> On Tue, 17 Dec 2024 16:37:34 -0800 David Wei wrote:
>> From: Pavel Begunkov <asml.silence@gmail.com>
>>
>> Memory providers need to set page pool to its net_iovs on allocation, so
>> expose page_pool_{set,clear}_pp_info to providers outside net/.
> 
> I'd really rather not expose such low level functions in a header
> included by every single user of the page pool API.

Are you fine if it's exposed in a new header file?

-- 
Pavel Begunkov


