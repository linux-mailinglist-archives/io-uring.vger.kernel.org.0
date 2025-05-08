Return-Path: <io-uring+bounces-7916-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 51131AAFE7F
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 17:10:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F635188C129
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 15:09:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63AB9279916;
	Thu,  8 May 2025 15:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fQ6ytKvd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A8B279902
	for <io-uring@vger.kernel.org>; Thu,  8 May 2025 15:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716764; cv=none; b=NwlThWgmJYRcfStOHvIjWTnrK+IOjVbk8XTG+FcRR+qsYGNPyTNvE2rcagHyKopXJcZ94LHTDFXOICMyLeYKNiVhJyNI+Nv9GpIaaZJhmHULfZ5ADHpDN493Y0IFqKx3qaT/3DlsjGvjHXl/+cswFg5UzNeHuF/oKwncjgpLHVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716764; c=relaxed/simple;
	bh=x18HZDpO4/AfOTYMyI2T7MVF84ndUzJ8OmJycvJGKxY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XZPKvZKmThx3wJbnV+N2BqE8G8vh+FYUQgfL++qihREYOGwW1huZFOKgx/I4k1BV6+1HhybPZNMqIY8H0ozhmGOuB8yrVw1zAc8ibxK7YrFI/JaveIMHBVVLkO4XjWdE83Sek1d1DdV2k8PCVu6ol3i9+MrB8S+RKtEDQQbkhJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fQ6ytKvd; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-85e15dc8035so23713739f.0
        for <io-uring@vger.kernel.org>; Thu, 08 May 2025 08:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746716761; x=1747321561; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oojzGy2rPvyvD3fwspYiXamOJIatZnX+so2HECZ/CEE=;
        b=fQ6ytKvde5cHfbxuQhzY3NOWWNJn0115HhfkcanhmqYiWQCjSLSJiIP0ruP1G5I0/d
         9a++YxZaEapN8H32KSnXTdrJITeAl+qZTw4Wcg2tO/svEflDHlyK84wWaXuocrVotWAD
         Zakd10w7wf6VSlFbhCpftKFehKyMK84EqSP0Fd76+Cyi7t5wdu2tlbrnd3Co0jxHy5wk
         xr8tYRYgZ6ro4BSs8pdHupVKCTxm2ZHPe+GZcCyKLOf3G/9H77RgXiOMaf9CVP+Tm3KK
         5wLyJRb3Xca0TPKLFwOowhu2n4jdSruoFkPsj9bcf1LdeBTAxOTZKtqyMGVVOSpMmSkg
         9LDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746716761; x=1747321561;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oojzGy2rPvyvD3fwspYiXamOJIatZnX+so2HECZ/CEE=;
        b=iqJmnIe3Y5Tx/Kf+JdVzpu1YySgDsqRecUAn7L+04/EDajSRFdzwwEKwvS93st7QQD
         JJu8OBN+jTdMsEsO94uPiAAjQDkM727HFrKiLo3iol2aURfqZySix09pHJGVt1fSrkMZ
         FaQ7/js2VeCHzH5ORP0s1iBXtX1s5UBjZ+6QK19RvqZNtbUK0cnOAaq4Gf6iCYusANAx
         0zVvjgHJrhDh485eJnCTwhvHDB1lYbDmnXB24lxog3wDnLHIT5lQbx0Q/howdyyUUMgk
         HkXxl+WX3wCuitKr8Lipp2LJOoejw+QqTfh2bK7l75dLxkm0J6TCQJGNCoi3N3+ksW1V
         6pXQ==
X-Forwarded-Encrypted: i=1; AJvYcCX12cTOLJwAJff1tbQCBiXxtuIPsihbJJ8D+kJ05CvKJ7fJnbNTi4p2ox7h3xgotH1cWTGR2hy08Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YzKjm5rxF9CnatrH7YuiFqZh4v261o29NmiwbBdac2QAZk+Q9Vs
	vDLIJjOSMB3xG3PSteuLxFtTlTsuWstLszRf+paggjgjv+dr2YJUDAG/hUgh/ME=
X-Gm-Gg: ASbGnctzqWzbQQCxfzHwegRMpBbzH4V9z17ArYlBy4txZvvr1l9wfoAqjeRg/PAaYxl
	YYaH3cZ3JbKSFpBySEWymWzGS4Ge07PY3gwlB8SkMoq6oq4l6Jikzs6sWoLfoU0WHHAkWiXe1VL
	PA8bTUDals/tfE5FHTuC3QLPNdm9gil8xW0UNBSIOLmObpTuK5E9qxsR1nJBIp6Fcz5E31G6n4i
	G9HWeiMvymKGN4UaC5jVRCeZIl9cBrY86qQsSrJrc4Vwt304KjWUOKbaNEFS71ZZZLJmAxz9SYp
	Sh/GJFal+sgT8DDWeJw/p7sz89CB0gmakhTP79dRevX3JkM=
X-Google-Smtp-Source: AGHT+IEfGrAt/nAymBQqANABYk4MXHhBbOjqWMik/FGHnukDHhPjKhYplTKB9EqvQxT+gtj+Y0dYfA==
X-Received: by 2002:a05:6602:3422:b0:85a:eecd:37b with SMTP id ca18e2360f4ac-867479246d9mr889219339f.11.1746716760884;
        Thu, 08 May 2025 08:06:00 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f88aa59313sm3117407173.103.2025.05.08.08.06.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 08:06:00 -0700 (PDT)
Message-ID: <89253238-9c01-4ff1-97aa-6b9bccd65991@kernel.dk>
Date: Thu, 8 May 2025 09:05:59 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Fix Hybrid Polling initialization issue
To: hexue <xue01.he@samsung.com>, asml.silence@gmail.com,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: peiwei.li@samsung.com
References: <CGME20250508021828epcas5p21b9313ec7c9e0da2e7e49db36854aa22@epcas5p2.samsung.com>
 <20250508021822.1781033-1-xue01.he@samsung.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250508021822.1781033-1-xue01.he@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/7/25 8:18 PM, hexue wrote:
> Modify the defect that the timer is not initialized during IO transfer
> when passthrough is used with hybrid polling to ensure that the program
> can run normally.

Patch title should be:

io_uring/uring_cmd: fix hybrid polling initialization issue

and then you need a Fixes line and a stable tag, if appropriate.

-- 
Jens Axboe


