Return-Path: <io-uring+bounces-8490-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CC094AE8F8E
	for <lists+io-uring@lfdr.de>; Wed, 25 Jun 2025 22:33:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31D7C173AAB
	for <lists+io-uring@lfdr.de>; Wed, 25 Jun 2025 20:33:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 861492DCBEC;
	Wed, 25 Jun 2025 20:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mj2+qJIg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD15D2E11B2
	for <io-uring@vger.kernel.org>; Wed, 25 Jun 2025 20:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750883560; cv=none; b=EyTCHiiD793YAWq/w18uUdF0dUm/l0B2UeqP8/YQr2Fg+tC/HrqGPIofITfr904uXA8s4MKTjJfdxCrQADQ0rd8GiTa1vE1+mgfn6ArsjRYLbEadeev9Fne05gc6KPllPWlZzTUPg8YNZ4Me7JLjXQ2N4EqM2lC1jKan0J0TcS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750883560; c=relaxed/simple;
	bh=Qg+u940a4lLv1XVnpGtOi0RNwZnRWbC+etqRoxEkplQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lWy9vQ+5EmXBF4vjDTrlAZHW8FZmpAKvbLRRon1tQt9rAw2+wMBs5IzDI08LrUEMuW2us4dJkBNihX0zdUf388vNUAVgUVeHRHy517J5Faf7F+cDc8DrzuRNgiZnMwveyyUUgx9N7Rzl0PzcYu3XbznO1ml2c0EBSxyZ/jpnGAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mj2+qJIg; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ae0a420431bso61585966b.2
        for <io-uring@vger.kernel.org>; Wed, 25 Jun 2025 13:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750883554; x=1751488354; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hucBU0AYzCLqCH22BrgEdtZHoqCF4ABpL4ZsWRLB+VQ=;
        b=Mj2+qJIgif0xrsnThArHMVBFEgyPR98YoSfwCmg3fkX/xpr4UoRf3k8sNG5jU2tWUx
         7pAiZn2/GouwsxgylQcFh9sO0VpEThxc4Thw9Okh9bUc3iZ+GXxiljgW1YsPlRhDSJGZ
         1zTMEBplm2qeoq1uki1ipI8lSvRDM45kXTY7BT+diOAh08ZldvteXRcftdaMeT6x7I0v
         xlJ2ppuATyfRtcoJfTPm08tq5+AtaP14vD90NC/xDFMc60uMIoRf1Z3eznsQtpzVsvww
         EQrb8uH1FOEJ9ueoXaP8UiEksrBjx3ZpvKj+lVs+mmQY1wt/AJBtmL55PQx2EltfjtKP
         KnJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750883554; x=1751488354;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hucBU0AYzCLqCH22BrgEdtZHoqCF4ABpL4ZsWRLB+VQ=;
        b=QRs3uU8wjrKT3plq+hsIr7Szda6KTLjZ4ixlu9WdZR43/ewrQMhbYE2DpvqJKOcBpE
         SmJdc7jZrXQFZbqbpq/mfB0MipBkbbKJE3HAZKGWSQ0WyjqGhoWv8Na0FqDKpHGQPmYS
         UrzGKaJh4QwYdOyOa1Ze9iArlviFq+1LBWetHPQfVA1VaJBhFzdpGqev3Js1N8TwG759
         buIwrOsBqcQGjw+Ysa96pT1/MGNSsxevm8U8XEbxJ0axZ5ylznHZqec5htRVW4MWUrg4
         nF713FyHXGKVqJp8IBpCIimGfPJFw+4A2FEsdoZQVfr7ZhshzdrBFFNrC8JXdhxPMUVF
         Xjvg==
X-Forwarded-Encrypted: i=1; AJvYcCV6ZShVodgMCbSj/fdKPyOjs6XpBHzPsSi+pfVgEh10mh8L2oYuPStWvBP4CUQ+DiORgdISsMBSPA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxKe7plR9zx+qR5TW5W1rp6BbA/M/YQ3qWrlqN/MqUpKg+f+0fL
	WSBoFMMzfcyfz6J2Dupmy4S66KaB7cGAy0vtiyASSNvfZWnJij5x5zjKBfmPIg==
X-Gm-Gg: ASbGncuKO4+bA+fyOBDpyjODAKrJJDOHGig8rc4aXVszMzm2Lp2FpPJLwCdG7/uqKKl
	knqqyA8Al6YfpxVRIzdrx2+zpfvPaTd8RdNRfBQNh/8PFvWK1yMr2fbZ+maH2xgCoYK7GrWidRW
	ArVZxfntwFcWAB1XqlDkgEgnF5s9t0Q5nSnnQW1goQYzMagnEe9QjRMN86Fn6P7qL+oLal+dcXR
	WMbMPl+ui2MyhQykEt45E83sXGhizHRbmpxSGbAXztMJ9GYXz+Ok5hcrtQZIA75qRcTxs2+uXIL
	xfK09z3W1un/yGLpNECp3uk5UAxpty6aSAfXiF2OiLUdT98llfKtXP/DFIZh5+hhhUTrKGLu
X-Google-Smtp-Source: AGHT+IE0IZlfMyd/6K4jLpIJdShHihz30WI4avxnBVxK2smymsrYaz6tCLbmTmaoBH04BWLIvAvB9g==
X-Received: by 2002:a17:907:2da4:b0:ade:31eb:66f7 with SMTP id a640c23a62f3a-ae0befbff1amr492893266b.58.1750883553764;
        Wed, 25 Jun 2025 13:32:33 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.133.155])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae0cf02acd2sm65801866b.130.2025.06.25.13.32.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jun 2025 13:32:33 -0700 (PDT)
Message-ID: <faff225e-9396-40e1-9a7f-1d69010370ab@gmail.com>
Date: Wed, 25 Jun 2025 21:33:57 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] io_uring/rsrc: fix folio unpinning
To: David Hildenbrand <david@redhat.com>, io-uring@vger.kernel.org
References: <cover.1750771718.git.asml.silence@gmail.com>
 <a28b0f87339ac2acf14a645dad1e95bbcbf18acd.1750771718.git.asml.silence@gmail.com>
 <d51f982c-f487-491e-b105-cd858f39e6e3@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <d51f982c-f487-491e-b105-cd858f39e6e3@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/25/25 08:53, David Hildenbrand wrote:
...>>   static struct io_mapped_ubuf *io_alloc_imu(struct io_ring_ctx *ctx,
>> @@ -810,7 +813,8 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
>>       imu->nr_bvecs = nr_pages;
>>       ret = io_buffer_account_pin(ctx, pages, nr_pages, imu, last_hpage);
>>       if (ret) {
>> -        unpin_user_pages(pages, nr_pages);
>> +        for (i = 0; i < nr_pages; i++)
>> +            unpin_user_folio(page_folio(pages[i]), 1);
>>           goto done;
>>       }
> 
> It should fix the issue, but it's a bit suboptimal in the case where we didn't coalesc, but there are folio ranges to coalesc:
> 
> unpin_user_pages() does a per-folio coalescing.
> 
> So in an ideal world, we would cleanly split both paths, and work with folios after we coalesced to use folios, and work with pages, when we didn't coalesc to use folios.

Agreed, but I'm not too much concerned, it's a slow path, users
should be mindful while registering memory. Localised hammering
on the refcount is not great but ultimately shouldn't matter much.

> Then, we can just use unpin_folios() after we coalesced.
> 
> In any case, for a fix this is good enough, but probably we can do better later.
> 
> Acked-by: David Hildenbrand <david@redhat.com>

Thanks for the report!

-- 
Pavel Begunkov


