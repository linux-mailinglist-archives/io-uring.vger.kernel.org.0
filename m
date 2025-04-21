Return-Path: <io-uring+bounces-7597-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FC5FA95314
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 16:50:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D286F3A6CDA
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 14:50:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75A1285931;
	Mon, 21 Apr 2025 14:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZMpcGnu1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4318E13D246
	for <io-uring@vger.kernel.org>; Mon, 21 Apr 2025 14:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745247032; cv=none; b=hFvnapMvmCZX2tO1mg2VaPXV5q7dBI942JgfIPBSyLeOHVfkbqntU3NbxJ3wHdSgfduK4sBsz/O2oGVtNWRFIAD03rZpjHKujhlEbY0iIdhPtnN49YamKUtqtPMb/bwB6UAKztHOziUWTFBE4L/fCYpRMy6t4Fb0dDsnMb9k/EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745247032; c=relaxed/simple;
	bh=HiQ1tYkOxaqy3WeGU+Rwg+WI964CDgYpDtsiP0VIsrg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NiO5Mn31Mdh9OrP198PEeFwIp87F4frWi0dldtS6D7NWO0ninwVT8+6unsPyhHAiM77IjhkvQpHkmyCR0mAzc/KgktwH7gGHwmdKPmc3sS0QkVvQiZcHj0RTiFj+egLEWQGKJmEZYr3DvtyB4Mg0n+sF73RWizCREdDCpmr4lfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZMpcGnu1; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-86192b64d0bso338566839f.3
        for <io-uring@vger.kernel.org>; Mon, 21 Apr 2025 07:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745247028; x=1745851828; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fRaWmveyk0daKNSpqFnUOlh2OSMi/o32rcRoFYK1ixo=;
        b=ZMpcGnu1OK/DRznFYb0I1DPOOKh/2G60vByHju0rpEbo8XUVEWUgLMvUofcp2ac3nn
         E/x96esIQCsyyF3djwCfQDynQAZ58QlfZGl3IQpFI96zPCh5uYSqDrwFEikSPsOBo84h
         S/XQEEZeyqa6SvPWXVh6MjV0K3rk649RTzX8jMmYFiBwnDH/6sH9a9wEL/UWs6JIq/Y3
         eCOEQXACF/2hxTEPS7ikiVNybWiShnAXt2OkQNuRuJM70/1MPKE4CERsOqM5rPnAkfpJ
         lTwjLhyyDsKN+S0bigjjl6odo0FCY1W9octfpk6gF/+X+Y8Z1iGaQu3UoivEPB/eZsTc
         lPAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745247028; x=1745851828;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fRaWmveyk0daKNSpqFnUOlh2OSMi/o32rcRoFYK1ixo=;
        b=lagJaFlChOBoMZYKt+0ozio4lYdfN2yoxsDFUbyZ7f1C0BqY12J7BJvcmdQ1OcFDAS
         bl2SKfNzp39/D7LyKXjocyQ97Ga+lwXt5cYDAHSRf8yrzeVU0FS/FjFAQ6EnaZINDGsl
         dpI4ABQD4LMtvfpx4FxDnVGwQDcNRArKNr8TZUnBpUiiBoa3hY0CDvB2R/O5ZbF6M0v5
         nnI/v6jlBzwqK6mpL986Qa2Dc3YKhcmT/z0FZpZ7GSq3bO0K5pQOBYxEZoD17S5vcasy
         aFHdkaszPvoQSNLNVIPE2piTNj7AIvp43YHX4MkKF39q/r1A2B2NZQfuTYtOGdoLHr6s
         Zumw==
X-Gm-Message-State: AOJu0Yxy8jTlTm1ytu2rsdr6sNOhmkI6iuSWgWhCx5uWTAezYWhpgmQg
	zv7HdCOceiDzDqM+hRnbISFJC0KejbsdtqOHq/3PiHPg3RajZ8XvmVyNmnLUgPE=
X-Gm-Gg: ASbGncs/X5YrKX8FlpRF2L8KW4579RUjZkQ6wRj189whFfU9N1u+atp15lcMMtEKIYp
	QkZ23IGZ/CbnSW9+4kKi6JfQYNNXG/8fr9tFx5Ir1K4P6rZvEASoRDjB1MVoPXQqBrd+0WrFUVQ
	tLB2/MTZTbp40hbH+/dV3X7/oy9oz5I4alFvYhH2gUNcyj/Tms04hoMLlf7HNVrfIq9hq6u0GF6
	/jzIqYWE24vspCNzVAGf09QIojgwQWeGAbYP30s9NfzCaRk6X1qacoCA2npGNVvycZieY93CSqV
	lCpWvkGu3Lzu601avUg8SUIGre6O0dp4ndeW
X-Google-Smtp-Source: AGHT+IGezrPIy7g/Y6ZjgX7vnlu8jNO6vnAMGVOe3c186cAwceeMsqqTppKhKHsQSGHevz9r3LNcog==
X-Received: by 2002:a05:6602:7205:b0:85e:a8a5:b0e9 with SMTP id ca18e2360f4ac-861dbdd115bmr1144083439f.1.1745247028284;
        Mon, 21 Apr 2025 07:50:28 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f6a37cb6b5sm1794797173.22.2025.04.21.07.50.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Apr 2025 07:50:27 -0700 (PDT)
Message-ID: <858529ff-93bb-449a-9101-7f6cf5fe98f6@kernel.dk>
Date: Mon, 21 Apr 2025 08:50:27 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] io_uring/rsrc: clean up io_coalesce_buffer()
To: Nitesh Shetty <nj.shetty@samsung.com>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
References: <cover.1745083025.git.asml.silence@gmail.com>
 <ad698cddc1eadb3d92a7515e95bb13f79420323d.1745083025.git.asml.silence@gmail.com>
 <CGME20250421115925epcas5p18c9a46be72b98c089dc1833befc4d06d@epcas5p1.samsung.com>
 <20250421115057.mr43ociu7erpohhj@ubuntu>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250421115057.mr43ociu7erpohhj@ubuntu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/21/25 5:50 AM, Nitesh Shetty wrote:
> On 19/04/25 06:47PM, Pavel Begunkov wrote:
>> We don't need special handling for the first page in
>> io_coalesce_buffer(), move it inside the loop.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>> io_uring/rsrc.c | 47 ++++++++++++++++++++++-------------------------
>> 1 file changed, 22 insertions(+), 25 deletions(-)
>>
>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>> index 40061a31cc1f..21613e6074d4 100644
>> --- a/io_uring/rsrc.c
>> +++ b/io_uring/rsrc.c
>> @@ -685,37 +685,34 @@ static bool io_coalesce_buffer(struct page ***pages, int *nr_pages,
>>                 struct io_imu_folio_data *data)
>> {
>>     struct page **page_array = *pages, **new_array = NULL;
>> -    int nr_pages_left = *nr_pages, i, j;
>> -    int nr_folios = data->nr_folios;
>> +    unsigned nr_pages_left = *nr_pages;
>> +    unsigned nr_folios = data->nr_folios;
>> +    unsigned i, j;
> checkpatch.pl complains about just "unsigned", "unsigned int" is preferred.
> 
>>
>>     /* Store head pages only*/
>> -    new_array = kvmalloc_array(nr_folios, sizeof(struct page *),
>> -                    GFP_KERNEL);
>> +    new_array = kvmalloc_array(nr_folios, sizeof(struct page *), GFP_KERNEL);
> Not sure whether 80 line length is preferred in uring subsystem, if yes
> then this breaks it.

It's fine to use checkpatch for new contributors, but it's generally
just pretty useless imho. io_uring does exceed 80 chars regularly, if it
improves readability. And we also do use unsigned, not sure why
checkpatch is against that.

-- 
Jens Axboe

