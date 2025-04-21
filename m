Return-Path: <io-uring+bounces-7589-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C4AEEA94CA9
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 08:39:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 81D021891CFE
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 06:39:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8784B7462;
	Mon, 21 Apr 2025 06:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GE/6YBdm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17EB2AD14
	for <io-uring@vger.kernel.org>; Mon, 21 Apr 2025 06:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745217537; cv=none; b=RD1XJr1Psr2ef/qWupSv8yucj9K0pprq8XTh794Ker3Is5VKX5ctHgU5g3/WGVzp15ydYhjQX7c1C0HKQrtJ9zBNQuhMKkYq8g/hkdY/7yXQ0aHpOmB6S3m8l+bKnueiLRIZEBxPSBfhs/zV/gTbmEVNSO0u53o1BE5XLY9XYVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745217537; c=relaxed/simple;
	bh=5mGyA56VXB+weKlcM7gVe2MJ9Wt2955SYYabT3cRs18=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=n2wnmfpNYmlXdHfrGuN+qL69ESJSi7EeQLkTNNYhM0iE6spU0T3rRxHMBRCIZU5EBg/WvBrXsk+LIZ4lOoM9e/o+csPgJStbe866OtUb0chOSLtpC5ec+KcX4z0qnOL1ajnjVm1Xdkx8OdZqBmSKGEXushlFZ8eQh5sKe5j9H0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GE/6YBdm; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ac73723b2d5so697034266b.3
        for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 23:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745217534; x=1745822334; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=onii80aTcgEsNtXQ3g9TgLou/VdaFGx1/5fmrmECr/k=;
        b=GE/6YBdmWdavLPY8UDM+M/jST64E/J+X4Pj2Md6oG4uImWWeX7JVhiKkw5Inz2mbtv
         Bttp9talzU0ZEdbvu7zrpVjqIhAVHiLlxMbOFzESanbdwKky6XDynCcH9lBwqOvO8/FF
         HyA3aJ+I82grvxJ9HZ6KZKSwaVMq5sOZPh/6rygswWYYscuu/SAfLPdzrnQ8yDEqUiMS
         aT2HPeaEtuzUG4FKk3wVxU1E2IG1p4GGLbFXzcc+xnQyhLZFuqndfyWOKEtfLcWCOIe5
         MerOJyVWLbQzYetoyM34zAp6tA/PB+RVbTMSssq9MbgEMOOwJN8gk2n/1O4VAcA426ip
         3obw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745217534; x=1745822334;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=onii80aTcgEsNtXQ3g9TgLou/VdaFGx1/5fmrmECr/k=;
        b=fotnvCS0f+KKuiA0tQkPoeDhFX6sTnmOG8q88bN8YkxHkJh5N1BbSwto7NfSPoQ44C
         3YxbZepynT5MrTP8S6GxNc70gS/g8nH6DgoajURh1LXILPtH2lDtD/0nwXs/Y0NMIUoN
         lpM92V0uOrF5JRKoTBsbe+w5/6/5SYjJxtymFKUrP9moUU/DnRXOFhc9dBgawbqnH6Hh
         NDUaAS1w/22LCALcgOXr3lCjyfE5rdO24rDd1mssZ7/hBb7tWRWW2GgCSlyHaseXi3v1
         /o2/qEc7OOQelB5yf80QVvveSHV5v+b9NsOpNKAGbiMYsiTrGCfJAsAnkHUN+bRM0j8G
         7YoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfHjWyKI8rxEhVtCn9QKQgWjCULI/9KaPA4im7UEGo9qp9J56oYIrwPNPy/2MYcL1YDS0lN3F/+w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyZiPcuHOl5ErTPwfQ3cbuNV5gDGrOa66jRkiFCe4uYg56F2eW4
	X/n7GsVPh4EwyxX04SA0akAm0z4RYOS/orG3BAxrt34titUt7qN1zCSFMg==
X-Gm-Gg: ASbGnct1F6YG2EYhGGjLMWaWBXoSneX2xGXogfH18OXhO4Xg9qL3Nst7wTePo2hw/m1
	k3n4ibG+KrxxpE6dvzBPbci41FYqhVCkmfeOOkG8Lf9vzKVgdLTCg1T8rxSBlu4oByLouU7w9dg
	dW6lglU+SPyl55dkJu/EjC9AEqj/Ce9L4Pr15waZm1MHyIL6WoQbkU9bLzJIn+qMTewKRaM23Ex
	04jVkQCE5oal63mEjeI65pzXxpURlqHZ/7Oh2Ksqyjb52b1TEywl2Vw0zfyJYn/mqQWQD1hnDp4
	y4ns9MyNr5ZcRSMCBLcH3qfVpGheVwB2V6h3lGLzWxje9S4yyg==
X-Google-Smtp-Source: AGHT+IGDF/1Smz2RR+VxWdwTgBfAlKuTIUK0Qo1PtSmCA1O3pDICuFOsz8HxQyeKYGAXkoV4I8K3Og==
X-Received: by 2002:a17:907:608e:b0:ac7:3918:50f3 with SMTP id a640c23a62f3a-acb74df447cmr1111290266b.58.1745217533849;
        Sun, 20 Apr 2025 23:38:53 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.128.74])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb6ef9e0ccsm466248966b.167.2025.04.20.23.38.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Apr 2025 23:38:53 -0700 (PDT)
Message-ID: <a5ad67ad-f5ca-49fd-9bcc-53277394fac1@gmail.com>
Date: Mon, 21 Apr 2025 07:40:05 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 1/3] examples: remove zcrx size limiting
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
References: <cover.1745146129.git.asml.silence@gmail.com>
 <64f4734fbd7722e87a21959ac668b066bd984717.1745146129.git.asml.silence@gmail.com>
 <5a6b754c-d511-42ce-a9db-5aa9ae222599@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <5a6b754c-d511-42ce-a9db-5aa9ae222599@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/21/25 01:22, David Wei wrote:
> On 2025-04-20 04:24, Pavel Begunkov wrote:
>> It's not handled too well and is not great at show casing the feature,
>> remove it for now, we may add it back later in a different form.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   examples/zcrx.c | 34 ++++------------------------------
>>   1 file changed, 4 insertions(+), 30 deletions(-)
>>
> 
> I'm relying on this selftest. Can the deletion wait until the
> replacement is ready?

I assumed you're using the selftest, and not this liburing/examples/*

Anyway, let's see what I can do with it

-- 
Pavel Begunkov


