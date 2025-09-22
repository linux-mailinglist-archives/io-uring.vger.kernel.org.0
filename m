Return-Path: <io-uring+bounces-9860-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96BC8B91070
	for <lists+io-uring@lfdr.de>; Mon, 22 Sep 2025 14:00:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51B873A8F09
	for <lists+io-uring@lfdr.de>; Mon, 22 Sep 2025 12:00:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ABFD18EFD1;
	Mon, 22 Sep 2025 12:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KCpcbwpj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294AB3208
	for <io-uring@vger.kernel.org>; Mon, 22 Sep 2025 12:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758542435; cv=none; b=mp/F4cO5cqoHupVsQvWYzr5++GDbvEg4Nfe8PASAZN0qnLFcOND6OL0PdM0aMtNZ0JfeumRsmFYDFxBx2lTuU4IbmbCdFOV0opfXDTMYWmy25w3zTjVU+kQYo8YaxSX5sroHxi4sZ65biOaf9Pj+iP5/7GEC3dojhLH000XIXJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758542435; c=relaxed/simple;
	bh=/MYvbSO76Qn+s+vWb3j2sCr19uVEiMcPBF7fEmp1ZLo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=FVM9NXeImQNtTtUopy4BXbpxz1Ke8YzTozV7EiTJD3acLkXFbTEvUyiMP4CLlxgtsRJkqr9lD7JC2Ac/iXy95lbi15+nu1j7OjbfmIhzjn7IIIMo1ym+4dQ1WOCHCJ2Pm6Mejjl1lhJyMlw4CPYISq9tPtB1IN6nwPbuBaaYNnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KCpcbwpj; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-749399349ddso12384617b3.3
        for <io-uring@vger.kernel.org>; Mon, 22 Sep 2025 05:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1758542431; x=1759147231; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=F43s+Q41D5c9aERGDjBBOL8UZSAhLnKK7j2+ereGF0U=;
        b=KCpcbwpjWBZbJZ2Sg+BAAm9J+g3eseGEMitcYlg72bMhjm+SweYxlvvatVoHVZO26D
         eR4d51IWdmcLwiSXIL99PkW6VQgQPezaKLngMkQVXONL7kIyHSb/DloYleyRKaIkN0Uk
         YlmlduunwdzTPV41KN07oTutFY0hqeu/gvgir9q6sPGNqqsXrKeKgA8EDWS/bQHLc6wm
         KzWjg7kcs2tfYh+2cumdlQPeYz1bWxVl7vvroSI41o3vOU8S9Uf9ieI5GfgD/fNgGzF1
         zOy32HUc+pK2R1QvO8wYtDY1FXKk49ywZCPF010Izs1vBi87TqKQwPJZUPUOZ5mullCQ
         auwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758542431; x=1759147231;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F43s+Q41D5c9aERGDjBBOL8UZSAhLnKK7j2+ereGF0U=;
        b=FoBxyEdsn//9g4jMr7lUAiNXEWIx0YwXQooozd36rC2mdiLQo4+7L+Gj+xtgGDavoY
         HBGu4Uk9FUZm5VOjPVC74VbbZlT2dFc7ecWUXvxM3qevXsprZBtfYxzANgSOCllPqxyN
         z77AMYyN8RhkBNyrcVp44lJz2zKmGeSEkuXfNP5vzW4OWImirfG1TLK0pfok+ddh12wO
         XPkyK3uMAfZIQPqIANXIsTTyjnw8hzYwkdtoKdydIk9uBMcgPtJyqCHH3+3fPbDokhTx
         IN2PpSSbXwUwh97shxMl/njQI/Mo7MydvhazIqX5LqzH86Nnzaag4UTbhaqb9ni0a1Ax
         dKCg==
X-Forwarded-Encrypted: i=1; AJvYcCVXUN0xl1Zrxc07yG8/5JcIw0dEreIt2wBEUrimQI0wQz6ZgkMzJB6/ge9lzJLb19NIMp2n1XRmHg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/JfdpEn5n5JVuXbUFCz7qpUah5URcs3lsAzqu8KAYwsqbCdRu
	h49dGvoNrxxIwwoEic99KAndUDGmbRv3xvpICDes/u9Rs+tKB0nCvKSZmm1173AY6drgWhy1Fcg
	YNpmUe44=
X-Gm-Gg: ASbGncseLNdDDkDmOcrNQ2Kd1r4gJUsXByO3sEe4tYlBZtBecWVNc/Ss1myzQ1L9+YV
	895DLXxWdF2x3iK7WPc+eB1qnlBqMoOlrsQojoPTOlPmm9mC16MEJZCRnuBq3yT5thAJyc413ru
	p0Xe0ywrVL0z4W714yuYL5khPSruzpLK4Sa0+ryZJ+KEkqAL8a1A0Xb6iQd2IW0Z5KfDg0OLYuJ
	i4+l+/DjejVSzVDP+pgV39pQxhHbecuKhHPMgs8j0AvqbsJnYI8URcTwnjmGbAai0sfSMwJTVB/
	dyrK2B1dPAQ9+RmgYV+aquHAdST84K2HLkAsndM1MzjnUTWkH/F44YL+YZ0BSk2e4/FDsfHdWOU
	StaTppqoB2BvKqvb1Wlec2hxsfyDZSgi+SXRAfBqT29sm7rNGjeKMTaaH8B0Sw+8hfw==
X-Google-Smtp-Source: AGHT+IEUvxwSBmPe2AZ7+OEmRL7wqcHZdhizxvy/BqwcvICbJykgM3S9ZcRnEeQdaSydaWNkqaPYew==
X-Received: by 2002:a05:690c:4b83:b0:744:abdf:ecb8 with SMTP id 00721157ae682-744abdfeda6mr76782767b3.39.1758542430608;
        Mon, 22 Sep 2025 05:00:30 -0700 (PDT)
Received: from ?IPV6:2600:380:9e50:8ddc:ef63:e01e:eaad:c699? ([2600:380:9e50:8ddc:ef63:e01e:eaad:c699])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7397171329asm33615927b3.29.2025.09.22.05.00.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 05:00:30 -0700 (PDT)
Message-ID: <8d2f3421-ca14-4b61-b8a7-d33017deaadb@kernel.dk>
Date: Mon, 22 Sep 2025 06:00:28 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 0/6] Add query and mock tests
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1757589613.git.asml.silence@gmail.com>
 <175828771958.850015.18156781064751353661.b4-ty@kernel.dk>
 <55ffd8a2-feca-427b-90f3-151e3e78ecc5@kernel.dk>
 <0571f0d5-afef-4ba9-9db9-b2b61611368c@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0571f0d5-afef-4ba9-9db9-b2b61611368c@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/22/25 1:55 AM, Pavel Begunkov wrote:
> On 9/19/25 17:56, Jens Axboe wrote:
>> On 9/19/25 7:15 AM, Jens Axboe wrote:
> ...>> [1/6] tests: test the query interface
>>>        commit: 7e565c0116ba6e0cd1bce3a42409b31fd4dd47d3
>>> [2/6] tests: add t_submit_and_wait_single helper
>>>        commit: f1fc45cbcdcd35064b2fbe3eab6a2b89fb335ec6
>>> [3/6] tests: introduce t_iovec_data_length helper
>>>        commit: 7a936a80be37f50a1851379aa0592eeb3b42a9a1
>>> [4/6] tests: add t_sqe_prep_cmd helper
>>>        commit: 7d3773fd9e5352b113b7d425aa5708acdd48d3c0
>>> [5/6] tests: add helper for iov data verification
>>>        commit: 9e69daf86de39c9b4e70c2dd23e4046293585f34
>>> [6/6] tests: add mock file based tests
>>>        commit: d5673a9b4ad074745e28bf7ddad3692115da01fd
>>
>> I noticed that there's no man page additions for this. Can
>> you add something for IORING_REGISTER_QUERY? Might not be a bad idea to
>> add a helper for this so applications don't have to use
>> io_uring_register(), and then the documentation for how to use the query
>> API could just go in there and just get referenced from
>> io_uring_register.2 rather than put all of it in there.
> 
> Will take a bit to do, but that should be fine as it's
> not yet released and will take at least few releases to
> really become useful.

Yeah that's fine, if we can make the next liburing release with the
query helper and man page that is certainly sufficient.

-- 
Jens Axboe

