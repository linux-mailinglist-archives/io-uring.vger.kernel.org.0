Return-Path: <io-uring+bounces-8157-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0824AC913B
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 16:11:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D41BC3A51C1
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 14:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C12F21C9E4;
	Fri, 30 May 2025 14:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gXpKHrbC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FE2219A70
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 14:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748614279; cv=none; b=nxuKOgmUBlmr3ho1K3QY8HM5tVa/Bw3qcyC+XNAhkClxzHBtnRl2d6g+fVEY4gs//eE2Qt+16mhcTA125QcUhBCgW5LLcRjyBGKR3VluJ1N9JmiOZrYZnpABu3pWez1IsYRiM0KkVt438H8lRzT8DHwARmDm/ubsqJuLfynjIiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748614279; c=relaxed/simple;
	bh=JUmsgdr724gI/p1JMc2L4AKaE9/0pXpffu1qTd7T98w=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=Y1lpe7+NmZG7K4PUa3u7OwThXgE5tb+ENyCZGtesr0aKNiQ7lq0m13lYztcIMDVDHPPjMeoc5sCfNuFeIS5cTGqUL7J0bg5YyNIPQTrsnE7WK7meYajSrRNQv9VCV4u8P7GtF2Zn8UwvJ1RIDCcnmE8mD8mrUajRsu3YBUZjAMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gXpKHrbC; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-604e745b6fbso3995357a12.2
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 07:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748614276; x=1749219076; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4IZL4jba/QTjrw3zN863TVA3diDD+lSKyTLa1lJpC6c=;
        b=gXpKHrbC54qsDC4jf1tuc6PZN6ihXwpmbml9KdrBDNNdLmieZtHxrMV2UmxCDukJD3
         eMIGJx6IthAM2alRXx+bw9df1qfgQWFdo3Hq0eCME6RSxf0e7DQBER3A6QlaFS11WfeO
         j1yfzBu094/GvxDAHVQWtlNZdlciG4VU9O1cppSpK1z5AFGrOvUP/yl8tLAJeyd3pAVf
         FOCzuMxUSXoB8HXw9i3N0KXOWIZ5pC887LT9AR3zvLeGn9viUKtPo7YlB1bXVB3EZJgT
         1tDXuBAo1+yxSzOuoE/iCfm63CSoycsOZh8s7SVQRa6SnTQA9urIOrM6J92tLS/mr0VV
         OxXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748614276; x=1749219076;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4IZL4jba/QTjrw3zN863TVA3diDD+lSKyTLa1lJpC6c=;
        b=OR5Vbl2rt3bziv8/gRxe88bdWPR2LjH47gDkjAku9LGN21r0+ycVdqjACafTc+oUuQ
         hA9yCbhSnSOWuxLLyRWcw2wxPsbsZSNin9WGfQfsWrtQF3khemzu6O3ikAhhYoFVQnIY
         T9cWzPu2hA7aoogFiVyF0OKjapujA3D110FZmNfIHguXmRfRd9Q24f5D7iSgB79FUmd7
         CYNS832eItaGH8j2uAVQrs2BremAoWU5xae/DM7nruypq2y5t+L1LdFb1HHK4q/Euk59
         dWSm01rnRbE/2KQFlfKwQgGHPAj1jA9G9p8paYDdgJclR12R8iAR+1wLHWTdtrOH6AgS
         LFkA==
X-Forwarded-Encrypted: i=1; AJvYcCWnm6Rkcg4+mhXJ5p81InLqln9MeiRmZKBrmxRsooQQGwQCsYhyueTuDYv7CkSXmj2iVTss3QeALg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2poLkvxIAj7Tuc84Z91gbx0OzNp4SsRpMKYHD6LtYTpL/ORhB
	+aVyxo5vpqSW84c61ZFrZf2rf7tm0EHlMRewDB11ZSDa5luCwuQPyQt1
X-Gm-Gg: ASbGnctqPbLlYqXgDZs3N26eZm2S1S2sN3F01b6n+YUkMvf2xukq/4m07oglwJsL2Fh
	6Ns2OSeKke1QdurWZOxAskDfHVE8xk9Y150GXUkdGUkIRHQC9j6DfDx270Rizj8kJ3FJ5BH2J1L
	tecEFeAo+O/rT1hgp1ZmRXPwSKs7lKdDq1bO0ab1sLbdg+aM0w3NourSM6jfjvLsaoZowpNS0ox
	pAqV74fgie9dsaLZ6ZdTx8EAn596lAqDkrL7ByszoP67I6ss/b/JNu8gKYY9RZutmqmh6lUgWyx
	ieogpc9JLhevI8Mbz7Yst4bL4B1uR706rHWdPPpIms6ZfY4aXM4PQtlS6wTKJkeKqIDNSz+lKbY
	=
X-Google-Smtp-Source: AGHT+IFHaw05luWEzNh/svo27TkK0tfbFr1ivKpAAVeMObuZ95JpeA6Az6+tbOq22yKlUxHUgOSyZQ==
X-Received: by 2002:a17:907:1ca4:b0:ad5:42bd:dfab with SMTP id a640c23a62f3a-adb322afc0bmr261589566b.30.1748614275613;
        Fri, 30 May 2025 07:11:15 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::15c? ([2620:10d:c092:600::1:a320])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada5e2bf088sm337561366b.106.2025.05.30.07.11.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 07:11:15 -0700 (PDT)
Message-ID: <e6ea9f6c-c673-4767-9405-c9179edbc9c6@gmail.com>
Date: Fri, 30 May 2025 15:12:28 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/6] io_uring/mock: add basic infra for test mock files
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1748609413.git.asml.silence@gmail.com>
 <6c51a2bb26dbb74cbe1ca0da137a77f7aaa59b6c.1748609413.git.asml.silence@gmail.com>
 <cf2e4b4b-c229-408d-ac86-ab259a87e90e@kernel.dk>
 <eb81c562-7030-48e0-85de-6192f3f5845a@gmail.com>
Content-Language: en-US
In-Reply-To: <eb81c562-7030-48e0-85de-6192f3f5845a@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/30/25 15:09, Pavel Begunkov wrote:
> On 5/30/25 14:28, Jens Axboe wrote:
>> On 5/30/25 6:51 AM, Pavel Begunkov wrote:
>>> diff --git a/init/Kconfig b/init/Kconfig
>>> index 63f5974b9fa6..9e8a5b810804 100644
>>> --- a/init/Kconfig
>>> +++ b/init/Kconfig
>>> @@ -1774,6 +1774,17 @@ config GCOV_PROFILE_URING
>>>         the io_uring subsystem, hence this should only be enabled for
>>>         specific test purposes.
>>> +config IO_URING_MOCK_FILE
>>> +    tristate "Enable io_uring mock files (Experimental)" if EXPERT
>>> +    default n
>>> +    depends on IO_URING && KASAN
>>> +    help
>>> +      Enable mock files for io_uring subststem testing. The ABI might
>>> +      still change, so it's still experimental and should only be enabled
>>> +      for specific test purposes.
>>> +
>>> +      If unsure, say N.
>>
>> As mentioned in the other email, I don't think we should include KASAN
>> here.
> 
> I disagree. It's supposed to give a superset of coverage, if not,
> mocking should be improved. It might be seen as a nuisance that you
> can't run it with a stock kernel, but that desire is already half
> step from "let's enable it for prod kernels for testing", and then
> distributions will start forcing it on, because as you said "People
> do all sorts of weird stuff".

The purpose is to get the project even more hardened / secure through
elaborate testing, that would defeat the purpose if non test systems
will start getting errors because of some mess up, let's say in the
driver.

-- 
Pavel Begunkov


