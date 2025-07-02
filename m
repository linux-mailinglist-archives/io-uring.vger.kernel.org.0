Return-Path: <io-uring+bounces-8596-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A1347AF662A
	for <lists+io-uring@lfdr.de>; Thu,  3 Jul 2025 01:20:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB8761C42B04
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 23:20:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D10402459FF;
	Wed,  2 Jul 2025 23:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="sBpz3n6L"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74ABD238150
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 23:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751498438; cv=none; b=foaKZc263lMzEbVMKmpzZuKfN6kBFXtVmcDeiMLOU94xXne8/bShMpNkpByLnzfK35+0VuvVAMxer4rBbDSuwRP1M9OkBDYDtJw9yq4Xa0oPMMRt1u8O7crCqR5gL14Ut4v7y5TGOOFrqmtCRj+OxJofYzHBBnWkVrmhPH0QeQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751498438; c=relaxed/simple;
	bh=jmaf5t7ULwm1R1YuiSBI64KJXwzNcahlPwk4DaJAGi0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DiUf/Ntrx4+hoMWmPOaZtuCxiPeCp2IcL9ZCCRRgZodT5hJyl6r03VFbFWRSKtyMsVSjRtbpAmLmE1EfzBaUpAXwpc8FA/W4bIHNTda/6e5BbMV8RPctMrtlEWmkDlZLW0+E9rwxPprW7KakHcaIjpZxnTyWnUURe7piPbfdqf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=sBpz3n6L; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-23aeac7d77aso46277155ad.3
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 16:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1751498437; x=1752103237; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LhtWz4Iro8WLh8e5JbBpZbLllWyp66DwGD7hT6K5c0g=;
        b=sBpz3n6Lk1XdMNNMgjN6iZZe6hNMs5tUq8UAq0HzgxO2Vxq9ShsqPFbA23tY/fhdpw
         Rpr4K3oOXL8YMrBg8Dv17axrxZkX9ceqeaKW8429vaBOsbZNaX6U7RAVSciLy/27u1Xj
         x8JofntYq+mKN+lj3OoJu7CgPHBEBlXCGD1eBoNg5ge+5vPp9ipb9BZDl+1cajtRf1lF
         W5RMGLdWMSP/6R2+NzH4pRP2ydiixLJ6KQj/XYtSFwOhGWriSIBYmHcuthtkqmhvPo7w
         wqW5/M2k3WAT5hcmRdAq+wRLPRLYwYv3OpTBklSsKyU0p29+zZpQ6Yzzi9/Dgrn2ZNjx
         vkuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751498437; x=1752103237;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LhtWz4Iro8WLh8e5JbBpZbLllWyp66DwGD7hT6K5c0g=;
        b=caMPOxx3ErqstWz5BZUK/qYGq5wERvvRFkPOw8+yt5vxLQiBPmFTfY+8cv9zi5BpVC
         HRuttk/EUCuYOYVB8NIfzykNsb1N/uQ8Sau0N8gEoDk/6KOjLn5H+JVyV/N5LyooCNzQ
         7RvXZlOgHtF9GFsfhdd/kWFxzcOVSbX90yj+Oa/3MiwmWGk9f7MF98vcjPHkmRVUTrPx
         VqFtrrjrg41ZYfX7lpjp2Lp2Q7c7/nPscByhSIXJ4OlwqbW+A3IA1Le1flrM5P+nb4Ws
         6eAGyzNszF+/OQW5BLQ0mpurekWgk04j4rJ9eGN5ZdCFCNZopluLvnnJpnX91O5+uPEw
         Qg7w==
X-Forwarded-Encrypted: i=1; AJvYcCVJvyZHmwv1WNw2Kd05wUGvXQvtIaucSItqUXUwwwbkBwRjnL5m+jjOSarpcOMRoHVAnI8oC1D72g==@vger.kernel.org
X-Gm-Message-State: AOJu0YznbXLDALA+TChUSZuXD6VYiXOwt/S8Ey18VmCbDJmI0Pg7Uhi7
	btjwoa1xdr/YYtiTooMu5qXYLe4+exJypq6uK+r6JJd2bIgfQK/5IuR5k3BEGiU0izDMxVNO9lM
	rj1owzK4=
X-Gm-Gg: ASbGncv4cGq/cIMeGThNU23rLReMV78mTuniu3Agy6sJ7t308Dhc62cDlNAlKICcGSK
	JvojWswP82l3r3Unx9ih0ZjZ+9VkP0WF7yxICXOSzutk6GpLOsoOMqAYu9oST0S9eQegQPZrxbx
	4CbPdHz0eFR6w9Hi5HeFSvlJnjabbK5rvGUL5SQxTpjbyLpy8VvPU8bTYiWBWb14u8nH7zkO+UJ
	FDwVRv1GUfoS0HLm957dbHUWsy3ltsx0U5WAuELdDCOPNnIUvRGkrlQphfnW7ssVP906rmyg/Vx
	LFH8wDxl/sTs7YypVspdCkweR9EaFqAdnMu3tVttfHfE0E6yEYmxcAdXQHEp6w2N/hPslsJLbz/
	Tho/Y7LKd5ElgGH0kij7VDlx6TWccC4cY7Zc=
X-Google-Smtp-Source: AGHT+IHlQmC8ghOK1u4nW2vq01OQPl6BxjJWGOIYgNHgDnSPiCG4NX4oAHZiHCWZU7ld0vkUivd+5w==
X-Received: by 2002:a17:902:cec2:b0:235:e8da:8d1 with SMTP id d9443c01a7336-23c7a1db7d6mr8869455ad.8.1751498436766;
        Wed, 02 Jul 2025 16:20:36 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1156:1:14f8:5a41:7998:a806? ([2620:10d:c090:500::5:b65f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb2f21e0sm139053715ad.74.2025.07.02.16.20.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jul 2025 16:20:36 -0700 (PDT)
Message-ID: <56880d4c-6972-4fd5-9af5-1d7f069754c7@davidwei.uk>
Date: Wed, 2 Jul 2025 16:20:35 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/6] io_uring/zcrx: return error from
 io_zcrx_map_area_*
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1751466461.git.asml.silence@gmail.com>
 <42668e82be3a84b07ee8fc76d1d6d5ac0f137fe5.1751466461.git.asml.silence@gmail.com>
 <bf0aac47-723e-40eb-a280-f8868edf9d26@davidwei.uk>
 <17d0fc14-afd9-4320-a317-c8d7cc049d41@gmail.com>
Content-Language: en-US
From: David Wei <dw@davidwei.uk>
In-Reply-To: <17d0fc14-afd9-4320-a317-c8d7cc049d41@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025-07-02 15:50, Pavel Begunkov wrote:
> On 7/2/25 23:27, David Wei wrote:
>> On 2025-07-02 07:29, Pavel Begunkov wrote:
>>> io_zcrx_map_area_*() helpers return the number of processed niovs, which
>>> we use to unroll some of the mappings for user memory areas. It's
>>> unhandy, and dmabuf doesn't care about it. Return an error code instead
>>> and move failure partial unmapping into io_zcrx_map_area_umem().
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>   io_uring/zcrx.c | 27 ++++++++++++++-------------
>>>   1 file changed, 14 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
>>> index 99a253c1c6c5..2cde88988260 100644
>>> --- a/io_uring/zcrx.c
>>> +++ b/io_uring/zcrx.c
>>
>> ...
>>
>>> @@ -254,29 +254,30 @@ static int io_zcrx_map_area_umem(struct io_zcrx_ifq *ifq, struct io_zcrx_area *a
>>>               break;
>>>           }
>>>       }
>>> -    return i;
>>> +
>>> +    if (i != area->nia.num_niovs) {
>>> +        __io_zcrx_unmap_area(ifq, area, i);
>>> +        return -EINVAL;
>>> +    }
>>> +    return 0;
>>>   }
>>
>> Does io_release_dmabuf() still need to be called in
>> io_zcrx_map_area_dmabuf() in case of failure, if say
>> net_mp_niov_set_dma_addr() fails in the loop?
> 
> It doesn't. The function only sets niov addresses, and it's fine
> to leave garbage on failure. In contrast, the umem version sets
> up dma mappings and needs to unmap if there is an error.
> 

Yeah, I see. And it's replaced with sg_table helpers anyway in patch 4.

Reviewed-by: David Wei <dw@davidwei.uk>

