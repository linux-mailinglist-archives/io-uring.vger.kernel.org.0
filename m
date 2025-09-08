Return-Path: <io-uring+bounces-9640-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C7CAB48D45
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 14:21:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 47F4F1B21862
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 12:22:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEAED220F3F;
	Mon,  8 Sep 2025 12:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W8Ww0piy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAD9221DB5
	for <io-uring@vger.kernel.org>; Mon,  8 Sep 2025 12:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757334115; cv=none; b=rgxt7KdmS3xH+zQl4kCh9VOhWK7rTIiVY4AIiqLpzlELPkVTqPHRUtR12IoE6e19u1aMjllmqqtzJStifgERsC5jBtWnnRGjSRMiI1AVcZM0hdnGqdveri2TVML707Fui7gmlXDWC+qNGzi1agweN1d1xVeMmMZcZ0w7wXtaii4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757334115; c=relaxed/simple;
	bh=uesORb8eksmKCS3q8rSLhn0eA3llEP3s8x38FZNcNL0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U9iSAuEUU56eHoekZoMayEMYWpzhuRJVgdcoH0P9rB6zaa1uDzVapQ6zsI2C2nFMtYxx4ZvXq3+ptQ7hQXLLcUjxueid/pzvYQVKVin5+AGlXryfHDmx/ebGEgzkS9xDlxgD6bS2tlNw4SNHm4Bw38xafCbCxtrMNt/zNP/QMdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W8Ww0piy; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-61d3d622a2bso7386182a12.0
        for <io-uring@vger.kernel.org>; Mon, 08 Sep 2025 05:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757334112; x=1757938912; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8ATM4BMrqtr5ly3RN1VzPdatIHo+Kx3BNW2lyhmpl7k=;
        b=W8Ww0piy2t8SyZk5LtiSd+z9IrVQD40yydlbeqxD52CI4rr4ZlSr9Bg80JXhFHSMfE
         Xm4AvwwwElb6F+AYfPQf+BtXoj4FyidV3H96zchBFTRVYwD12K5Z4L5uW2vkql5NAOK0
         63q4IGhKAAWkmgFl5bXsi8lU+lebd0J2SREIKgggIhROgG4r/Sa2ncIwnYWLQ4PmH4eP
         0LT/40RZw+RALqVMHfgUOdhtI5t7A+2GGanhPWLSZC9C/oNaZVtbAn3wIOuZSOx7CT+r
         +VgSsLdw8JTKSMErmQJIq32FbZFJlBo5Je95hIsVVkKCFVWlPIyGygWarJ8JMz+bizzY
         gA+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757334112; x=1757938912;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8ATM4BMrqtr5ly3RN1VzPdatIHo+Kx3BNW2lyhmpl7k=;
        b=IYsM8iY9l5GuwOzKsw5pTtkYBKMfinR+5qZX/pr7kxzpq95TKzCBJdWZWemZiqxhGV
         +y9Q2aENIvLsQh88WXUy62NteiYbYKOM3jQsfvFr3axqLjQF8hbcSJtbiNFzu2tyuMgI
         YtYFDsR80NGX41xtHNs+lPoaMno7AOEdWzhG9sUouUhSZNCRF8mdT7rqL8eKo8i5MuMN
         Kom9Lkv6Fm1lJ2GDS/PYPmDN98zD6bkkq5YZ0kNh30NJ4Ubnfg3qy66MOCpAitcPXX9O
         ikroxlNzOhhi/mZ+AqzrMaNMoIAArclSvEFU7w0v8aJQpOML82J/bUGRJRba+wcyvu/X
         WgIg==
X-Gm-Message-State: AOJu0YxT3HNpqleTA/Jgfl93KIV3uqtCETJB56zT7UJFgveHfMnlT7a9
	dHtFYCx8CRZf57yG1twsf0/SYhJ0CwHcDgMV4L1UVvUK2+CdAv4f2BG6
X-Gm-Gg: ASbGnctDSyIIdfCkzZS7JM2Z8gZ2vogjpEsKcfHrdNT8xNHC6Tsi7MuFmLkMDO9ixRx
	evpF1uvfpkyQdCBJXUtXZ5APMvxCrWljWv9pQ4H/b8KVmQEiZR2LYSf7a4UY5+8yOYiCJ6y6w/D
	lDpWm+QULg0OjmvCcKF06l+knhO1pVSPVmOvo6FuWph2DsQqlsDv8lFQt9LSauFtJhUtEIEBIv3
	68S4dCofFJmX9BE328wvWXcgWCcPptx1ThRRQvvOvB9jKMibaqgefGGlrokG5DTUgkwCehocz1J
	EiNSbSdrnC77c/QzHECa++JQtDE2EUOskUq7wuPFmRrN82d28/xbxecPQd3i1XDpLFHGDZfziPA
	TsSZIZ8Ale09Ye05BK9K5wuZfnyB/dCFa8ef7KnVvyrcPDuSZjX4izA==
X-Google-Smtp-Source: AGHT+IGUdw7ANYidbpt7Mykso9QWjtFERrsMylzJ8hjkEuDuappLMmyHusAdeuH3Jup7gltaTNgwnw==
X-Received: by 2002:a17:907:1c15:b0:b04:2214:9499 with SMTP id a640c23a62f3a-b04b1dfa8fcmr750531166b.8.1757334112251;
        Mon, 08 Sep 2025 05:21:52 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.147.138])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b046df9a44dsm1275770666b.70.2025.09.08.05.21.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 05:21:51 -0700 (PDT)
Message-ID: <fb16ca29-8124-41a7-ba18-02e756b20610@gmail.com>
Date: Mon, 8 Sep 2025 13:22:56 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/3] introduce io_uring querying
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: io-uring@vger.kernel.org, Gabriel Krisman Bertazi <krisman@suse.de>
References: <cover.1757286089.git.asml.silence@gmail.com>
 <yq1qzwh7dhr.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <yq1qzwh7dhr.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/8/25 05:52, Martin K. Petersen wrote:
> 
> Pavel,
> 
>> Introduce a versatile interface to query auxilary io_uring parameters.
>> It will be used to close a couple of API gaps, but in this series can
>> only tell what request and register opcodes, features and setup flags
>> are available. It'll replace IORING_REGISTER_PROBE  but with a much
>> more convenient interface. Patch 3 for API description.
> 
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

Thanks for review.

And apologies, I forgot to CC you and Gabriel on the series.

-- 
Pavel Begunkov


