Return-Path: <io-uring+bounces-8589-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F1EA2AF65A0
	for <lists+io-uring@lfdr.de>; Thu,  3 Jul 2025 00:49:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E328C1890997
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 22:49:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE07D1EFFB2;
	Wed,  2 Jul 2025 22:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H5RoSOO4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746CEBA2E
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 22:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751496558; cv=none; b=WTQPmNjNbGVn9DQH5LE4uCCJMrZi0R00Crc+4ox9G9DRRW9DVoSucKOqp5+ub9BrAxiLLCkEwPAsHFPrT+IoCcP3fYJghqTZ9FuWLb1P+uwkknGi3A5cpe6j8+c/AF9wiQFDFGUA7hHKwSIEIRSVE8bF37kaAxFlRbOieuXRnMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751496558; c=relaxed/simple;
	bh=mThnHFKYXt4aElwS/UKOkB20z33Vi1VDkA9Vfg3Xs38=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LX6VBJnoVBCOP9Z1hTe9LO6Qx+9p03MDpeOH/92g5izPTw4zGhdPgW6YKjW1TVC2r45/fcifDSJxdSwn1F648BwqlUf/721WjW08iqB+iaK0xjRL6bYT795XQ+TsM9YUhOhULvvaP1o3/X0FJ/kzc0DJzwq0hNmNfAUrq6FER3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H5RoSOO4; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-748e63d4b05so3289327b3a.2
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 15:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751496557; x=1752101357; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t8/CoWUFytp2zbE7kmTf+R+gYCXDd6IfSffTuAI2S0w=;
        b=H5RoSOO4GyMwTQui5cbpIvJil0FoeFnok1h4wshIQoIHN4a3r3SuuajieJL9uZdaOy
         9gcp9NWqTcqy+CpUm36zkanvuS/yhMi9+n63mNKl0ppMkE8PY3zmduD2rJ1jf8VzrcYV
         8zZxsWoK+LRytzuq642/Lm7iYDaVAPEkiwlmO0+B+JYPezrpILSx6ibwvJvH4yr8kQ/A
         AfqatskObcxxNWdvOA2SA+reAdblCCry9cJfMPoA/NRP+92YYm1fON8lHXcbaWNbLHfx
         NtSCXT9Ys3yGKfPEvJShZJUTcngr8W3yJ003gyWztI7XNVqKnR8dI0k8vS8qiPOupNoI
         moJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751496557; x=1752101357;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t8/CoWUFytp2zbE7kmTf+R+gYCXDd6IfSffTuAI2S0w=;
        b=EH3NMTPZ6I5G1VyodeXVdiFUFe4wVtMHmtToB1fOgw9qjpjoqxfO4UxibFDbTPFOnl
         4TWuYlcexWNdj9tCIREl2Idgzp31bLxDL1AmTO9FpDFuLQCZQWcgclUJkLbM1vjZOA3E
         N1Rj+qkk/4IlWkkdtrHyxhWLjhFJiGle+AJ32O+C87QJK0Bjt9cVrbTyDBKIanX5sb2a
         FKH98qNyt869hycH1SpZbocKfSmRMzZj7np031TrSBXVcTEBBnOYohsiER2Ll9gw/YiA
         eTuxfeP8I7veiVWfvPoYCALtbllLHOAl5scVKlnpVTU/uXoNPbf3ZI8CKLeh3jUTx5OM
         JSVA==
X-Forwarded-Encrypted: i=1; AJvYcCU9vRxgq1qGcnAMM0LrD9nTLXGCK6ow1PWIs3IT3HBdoc0y3LXir47T59n357aAXVOKQvPLKdhhKQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwiVwDMGwCS3VqACk1PptftIRXdV0YnL+V3e5j9IE1p2KJqMt2e
	ylK9LCyTKwgabnd45mURQyW0iqvm6XL3XKjYc3zdehsWM1Ro9hSrZZJ7RFBeFCKS
X-Gm-Gg: ASbGnct5efaTJ8hUM/dvYryfG3ue29n/R2sysAo5VgkCHnlbinlk6nz6ErSXcdtNgCs
	2yrI2SiaE09klL4dxgjoZlmCW/py9oUYcTW5Soz+Kil2SKuKyF5yxSFHUeoTQOM++gmXeQDtAe9
	ipq2Uh+R08xPe65e7LkXA0ZYHR3UDWewSSF8c124Snv9jdJePhPyhA/wz+aHn1dLZkzmuz9TY4c
	PKVZ58h6e34DWmOqYRGzy65Ov4pc1hfdLTCr50eRKLbabeN/iqBETv+1rb++S9IDUoCmjvzjmXk
	UgPQL2Bb/alRWd135dAb0QHb7uggHZb1hAeskuay8BVXxSBB8Fn0D3mfAPJQySBnCcSQfBV5
X-Google-Smtp-Source: AGHT+IEUqf0ImZl1b3eXPxwm/bkyVNSnxjnyfRQvpXGzOZ2w8tRdLoZ5p6sQ24HkAU/P/LjAaeJ53w==
X-Received: by 2002:a05:6a00:3cd6:b0:742:ae7e:7da8 with SMTP id d2e1a72fcca58-74b510402e8mr6941448b3a.8.1751496556556;
        Wed, 02 Jul 2025 15:49:16 -0700 (PDT)
Received: from [192.168.225.141] ([50.230.198.98])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af557b3adsm15223957b3a.106.2025.07.02.15.49.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jul 2025 15:49:16 -0700 (PDT)
Message-ID: <17d0fc14-afd9-4320-a317-c8d7cc049d41@gmail.com>
Date: Wed, 2 Jul 2025 23:50:44 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/6] io_uring/zcrx: return error from
 io_zcrx_map_area_*
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
References: <cover.1751466461.git.asml.silence@gmail.com>
 <42668e82be3a84b07ee8fc76d1d6d5ac0f137fe5.1751466461.git.asml.silence@gmail.com>
 <bf0aac47-723e-40eb-a280-f8868edf9d26@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <bf0aac47-723e-40eb-a280-f8868edf9d26@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/2/25 23:27, David Wei wrote:
> On 2025-07-02 07:29, Pavel Begunkov wrote:
>> io_zcrx_map_area_*() helpers return the number of processed niovs, which
>> we use to unroll some of the mappings for user memory areas. It's
>> unhandy, and dmabuf doesn't care about it. Return an error code instead
>> and move failure partial unmapping into io_zcrx_map_area_umem().
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   io_uring/zcrx.c | 27 ++++++++++++++-------------
>>   1 file changed, 14 insertions(+), 13 deletions(-)
>>
>> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
>> index 99a253c1c6c5..2cde88988260 100644
>> --- a/io_uring/zcrx.c
>> +++ b/io_uring/zcrx.c
> 
> ...
> 
>> @@ -254,29 +254,30 @@ static int io_zcrx_map_area_umem(struct io_zcrx_ifq *ifq, struct io_zcrx_area *a
>>               break;
>>           }
>>       }
>> -    return i;
>> +
>> +    if (i != area->nia.num_niovs) {
>> +        __io_zcrx_unmap_area(ifq, area, i);
>> +        return -EINVAL;
>> +    }
>> +    return 0;
>>   }
> 
> Does io_release_dmabuf() still need to be called in
> io_zcrx_map_area_dmabuf() in case of failure, if say
> net_mp_niov_set_dma_addr() fails in the loop?

It doesn't. The function only sets niov addresses, and it's fine
to leave garbage on failure. In contrast, the umem version sets
up dma mappings and needs to unmap if there is an error.

-- 
Pavel Begunkov


