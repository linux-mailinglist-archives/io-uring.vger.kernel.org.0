Return-Path: <io-uring+bounces-9097-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48BD4B2DBCA
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 13:53:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 606E85819C1
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 11:52:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC4392E4242;
	Wed, 20 Aug 2025 11:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YzpgQyk2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DF5242D72;
	Wed, 20 Aug 2025 11:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755690753; cv=none; b=hhUOacvbe8yAuZtwOfbyata3GumM9Z6dAbQXBdiVj2Ck6oBg9o1mI2eOif73yIy75vAo3ZQiMB8KkdadFzjzUsrUOCWSdVDrVIfudvprI0RgIpSrEXg2uxJlREFkY8QhZJP9BNdhVP3K0sOhR/wM9HSzHm6W0TgnBNuWUMCVgBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755690753; c=relaxed/simple;
	bh=R9iF5T6tpoWEcjvE3D2NwXjxHO1gXy2NbsB9Lw6ftNI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L2W3xlFX1Oj6W1A3qlAwcoP0m6on0aBEyEoeORo5xuqZQBXmh+flaLgvMWyACqpvPF/11VC+489YZq4whtcTdU1tMxL5gqhUSqyQj1BDjstFn+amN852D+XkUc/NCAgoGKdIowW2be771uHbPVBoy8Cpe4QxRCh9bHEiTiC3WOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YzpgQyk2; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45a1b065d59so33198755e9.1;
        Wed, 20 Aug 2025 04:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755690750; x=1756295550; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Eu0bz/4XJ8iPbptyw2I6gZv+1EznEZ+UL5PIm0i7/ig=;
        b=YzpgQyk2HjucUzq4QO6OclXM1SvBBhlZPlcaDdl9kDd4W+Xgw8LsmWuJ/CL1cMqFQ0
         HkMrlcr1uKFIagz8iDoQ7VkHeQ+aGUcN7GnLLn9nOt4xiRYCGLluq9rkogDHYl5f3/E3
         IBigsABYRqkhtfKeVto1wqI4AxuKGzRazvTLGtgKXvUNCnoerEUeSlcgxXYeEZLWdxQX
         3XhCpFw95JdLKgAnv/y+QBbqIYYcASlZWKUAEX3VjopHOIyJ37lsaq9LnkJ0+EKA6o6r
         dYrMnYqsghT4p6hKVUiCCbA4HUQW3cMXBZFW1x8WZGpj5poNmjSFBQqXzwHqqs43n/v/
         gOyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755690750; x=1756295550;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Eu0bz/4XJ8iPbptyw2I6gZv+1EznEZ+UL5PIm0i7/ig=;
        b=M0j03g8WISONw8ZAc+1HlWnWp+UUXm8dV1xOEZqPAIxnDHQxv4a+ET9TepGEEWXnwJ
         v5YiUKuBjekG4PQQzfFesRqZ4Z7cd5aIxJ3yFCkZIe/e/Bv31MI/FWijePfOtQNAVYnV
         79G+kStS3SiB4F8yhR+eWR3y30mKLlHyArU8cHYb/dL6hUmSvBlkV0QB4fT/s7ub70vZ
         nmFiWK+4QMthZUAgG+0xN9mqzvvgtO2vBXWrATcRTMCH67S9AnlTG2NCVlYZHSKDy9r5
         GsWc3gJCpgtueDJf8DlZX9M8C6ryWzYxtkQzSnxuNowoQbO8jgV7cguRABrGZPE9eb1f
         eUcw==
X-Forwarded-Encrypted: i=1; AJvYcCUgAFz+XQSu8AurNpVXWIUnjBUV9jLFAMZxZb2wBilr2BTcdIjuUc3+9Ei696Pf2354FPAzLyKYgQ==@vger.kernel.org, AJvYcCVkLZBTNC5LpxzFWuMNnHmOexrTFc0fYu5HeaHJAtXObkbS9olMFHzBC5G5sGeaju7rCr2pHzUN@vger.kernel.org, AJvYcCWpC7wAMtsJ9byTB47l4sjjgGYgA/5fvB3JYsWNuk/BHe2r/spuyWvQM3H9WXxl/4fzSMTPNiKWtuP0/o7W@vger.kernel.org
X-Gm-Message-State: AOJu0YxusT2CamTnjNnfIRtUrGLnsxDqTDcci7JHWrOeR4TyHW7uNdP2
	Ow1wD9Y/Pe7ao7+t13kWBPq6kV866M/r235gqylMnmc+g5TwIJpbNgvh8uk96w==
X-Gm-Gg: ASbGncuE6aDszTEn/F9bn4F+CBLltfSFOg0k2VIOGle5+toB99KDBUjFdi6tzAgz4bD
	/0AIFC3/Wr2mAQWMETqAr8QFxUF93X8ganXY8Z0MSiYQ2z9g8F7stXdEd8XEozlP2f6qh7WyMdC
	bHuwh/I7QAcVIMLERTRR8RJF5UD59kc/n4TKf69wlG47WcfKSPg2Ca8t7IIzxJLfB7Jr+3A2AEe
	S3Y2Byu3FnSlr6Ok0jM0pv+6pjGEJBlH0ByemryKoAFXUG9OJcUOxGRdfVbZVojzRpyl4b2Fq++
	AfXHacNsmnN48qzXAF2glEOLP2beoN33btmFshOkE2obgFProi2nF8ukg8QUPvHPr8RMuoO/0am
	IbiGgMpvKAEumt59G9vupcYYxsMNiv9oqTGQQt9fSCatrwDEPi+VWZlw=
X-Google-Smtp-Source: AGHT+IG/41RoPw5wW2LkypeGV8sEJ1A7KyvnRuzku6eq2XkgUVHV82AxBRbCjJXQq7vFgqll6W0jWA==
X-Received: by 2002:a05:600c:628f:b0:459:e025:8c5a with SMTP id 5b1f17b1804b1-45b47a0f88bmr19090025e9.33.1755690750190;
        Wed, 20 Aug 2025 04:52:30 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:5f7e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c077789c92sm7386521f8f.52.2025.08.20.04.52.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Aug 2025 04:52:29 -0700 (PDT)
Message-ID: <9eedeee2-8a89-42e4-90ab-ebd40b0d360a@gmail.com>
Date: Wed, 20 Aug 2025 12:53:40 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 04/23] net: use zero value to restore
 rx_buf_len to default
To: Mina Almasry <almasrymina@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>,
 Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org,
 davem@davemloft.net, sdf@fomichev.me, dw@davidwei.uk,
 michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <cover.1755499375.git.asml.silence@gmail.com>
 <d36305d654e82045aff0547cb94521211245ed2c.1755499376.git.asml.silence@gmail.com>
 <CAHS8izO_ivHDO_i9oxKZh672i6GSWeDOjB=wzGGa00HjA7Zt7Q@mail.gmail.com>
 <ab60ab17-c398-492b-beb7-0635de4be8e6@gmail.com>
 <CAHS8izPuZRsrBXaQoTNBPyisEo3w7J2aF0qyyOOnUAV=2-8o+w@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izPuZRsrBXaQoTNBPyisEo3w7J2aF0qyyOOnUAV=2-8o+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/19/25 20:27, Mina Almasry wrote:
> On Tue, Aug 19, 2025 at 8:51 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 8/19/25 01:07, Mina Almasry wrote:
>>> On Mon, Aug 18, 2025 at 6:56 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>
>>>> From: Jakub Kicinski <kuba@kernel.org>
>>>>
>>>> Distinguish between rx_buf_len being driver default vs user config.
>>>> Use 0 as a special value meaning "unset" or "restore driver default".
>>>> This will be necessary later on to configure it per-queue, but
>>>> the ability to restore defaults may be useful in itself.
>>>>
>>>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>
>>> I wonder if it should be extended to the other driver using
>>> rx_buf_len, hns3. For that, I think the default buf size would be
>>> HNS3_DEFAULT_RX_BUF_LEN.
>>
>> I'd rather avoid growing the series even more, let's follow up on
>> that in a separate patch on top, that should be just fine. And
>> thanks for the review
>>
>>> Other than that, seems fine to me,
>>>
>>> Reviewed-by: Mina Almasry <almasrymina@google.com>
>>
>> With the said above, do you want me to retain the review tag?
>>
> 
> I initially thought adding my reviewed-by would be fine, but on closer
> look, doesn't this series break rx_buf_len setting for hns3? AFAICT so
> far, in patch 3 you're adding a check to ethnl_set_rings where it'll
> be an error if rx_buf_len > rx_buf_len_max, and i'm guessing if the
> driver never sets rx_buf_len_max it'll be 0 initialized and that check
> would always fail? Or did I miss something?

Good point, it'll need to be fixed then. I'll take a closer look

-- 
Pavel Begunkov


