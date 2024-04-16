Return-Path: <io-uring+bounces-1578-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD87D8A6FDB
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 17:31:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A9EB282049
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 15:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCBC8130E2B;
	Tue, 16 Apr 2024 15:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aaYDQFPc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F295130AE5;
	Tue, 16 Apr 2024 15:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713281504; cv=none; b=DdMidjRYnlgzocf6uWwUSRc0voQam+Oeqi9BGCunHPj0xF2NDd0aFC66BoSipFz4phlTQ+Z35HJ/mus1U4F5+mq3bld4/AbRE7pySRvlv9f+9SEmTiZDw4ZZUiSlc4eeeTgE8X+o1A5wI+LsegiG3912e7eBI5wYrRDwhfnxZuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713281504; c=relaxed/simple;
	bh=cidw1n/YgMA3/WKaCBYFBA7zjZugTU7R1lAjK1WZ7og=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T4ZT/BWf/+7RKgqIlA5dYf6K5PyRRazXOf9TeW5EqasxxsZPYkTPw0/jo9cReDx/w6Y1hVBXRjNtXGUITbqqdyYNgzwmyk5TR7I8OuunTGx6S+NV74t02F/AKpfh9G2erA5xl3SW4tis758ATPvDWhZDasPsC1eavwwpZ5bsB+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aaYDQFPc; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5701f175201so718921a12.1;
        Tue, 16 Apr 2024 08:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713281501; x=1713886301; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=17WfKab0NfR6qDB7g04dZD9V8Bdl6JixIYq10hAWnWE=;
        b=aaYDQFPc0bI9dSTLm8hgFN7+tUjprZ1EZZFSkv4uI1lkXSJO8J+pryiaRRX27WwHrf
         F/QI6tF0QneWgejUApQwYNP2tmqNPUxsC5D1XxPGGTwFHl8iR+73OjJLiYLSoVXekxZO
         KCdVADwTguPtfdZ7VcBg5oL4gLPbRoi8fAKX+QjyBKLDCg9xQYraxmcPZm/J1YcVhY9h
         gMR/e2JuR0GqD6Z55duU4mxBOcIP3IMS87PDrIF0kVyqR4vPQSSlZOv43MSn2pl/eE2V
         OTA5K5DwtpRee4az9YWjBn4ljQvBLNw4s+H2AHb1sKaSOB1HTGoydB2ebpKvkGwPNFnw
         36/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713281501; x=1713886301;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=17WfKab0NfR6qDB7g04dZD9V8Bdl6JixIYq10hAWnWE=;
        b=qL6TmG3/cYAsYUxhr+aj9oz9vjMyMNiFey92AeJrhV31SbBU6uxOrVrAfT4sBObR2g
         0RoGR+fVsJiP/KTp0rHrB6wlriSC+O8XtAgfcplz6NFj3U3ZKKxW3qsKqF0J8ZoyX2R5
         cScVKYJqLKuKYi8sqlioRkKmcQ4ET8WH1Lxg5DeX0kOB1M6ctCGSCTuGVi40gWGIaZyB
         /XmM9Px9njocgm/r3JCleTWclwrWPsIG9e31pbBFmKYFWXSdOGbJDQkwya/q2T4eITDu
         4x6QZf+OIfZ5jjXOTl04WRYar7RFcHFfOxGjageqCIJX4pZ91eBP0UGXhvcv/+gJFAaV
         uBWg==
X-Forwarded-Encrypted: i=1; AJvYcCUa5dTNTnGFVq8zScFkQG9M48BdZuL1bBW66HoAIsUlqjxTx6BUw95IWpcv9WBajwsAzgw+bHCBuWYsLR5Mg033ijii+9BaJo/hD730XWgOQTEaOH2XWJATDZ18U0Ml0Vk=
X-Gm-Message-State: AOJu0YzrueJgBV7lfNdCsS4tr6dxGdFy/FWfVw++/jM+ysE1JlILSFXa
	SpdRNIjSEmZJUbbQ+NN6AWV7ifTzKU7vXZP407jgFeZ+9txqV6Hz
X-Google-Smtp-Source: AGHT+IHmfe15k27Trw/I4tgeg4rZ9o5wSoXNBQCXetuO4jc2KzRlW7hBQZu0DTazvthL3H9zAF7upQ==
X-Received: by 2002:a50:d49c:0:b0:56c:1735:57a2 with SMTP id s28-20020a50d49c000000b0056c173557a2mr12152251edi.31.1713281501336;
        Tue, 16 Apr 2024 08:31:41 -0700 (PDT)
Received: from [192.168.42.213] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id h14-20020a1709070b0e00b00a518c69c4e3sm6938326ejl.23.2024.04.16.08.31.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Apr 2024 08:31:41 -0700 (PDT)
Message-ID: <26442b80-047f-4bd6-a455-89afd2c07539@gmail.com>
Date: Tue, 16 Apr 2024 16:31:48 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/6] net: extend ubuf_info callback to ops structure
To: David Ahern <dsahern@kernel.org>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, "David S . Miller" <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>
References: <cover.1712923998.git.asml.silence@gmail.com>
 <62a4e09968a9a0f73780876dc6fb0f784bee5fae.1712923998.git.asml.silence@gmail.com>
 <661c0d589f493_3e773229421@willemb.c.googlers.com.notmuch>
 <8b329b39-f601-436b-8a17-6873b6e73f91@gmail.com>
 <502a2cfc-b4b1-4903-a6eb-3cbe2369047d@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <502a2cfc-b4b1-4903-a6eb-3cbe2369047d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/24 15:50, David Ahern wrote:
> On 4/14/24 6:07 PM, Pavel Begunkov wrote:
>> On the bright side,
>> with the patch I'll also ->sg_from_iter from msghdr into it, so it
>> doesn't have to be in the generic path.
> 
> So, what's old is new again? That's where it started:
> 
> https://lore.kernel.org/netdev/20220628225204.GA27554@u2004-local/

Hah, indeed, your patch had it in uarg. I wonder why I didn't put
them all in a table back then, if the argument was to keep struct
ubuf_info leaner.

-- 
Pavel Begunkov

