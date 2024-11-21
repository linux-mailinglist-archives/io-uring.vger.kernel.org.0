Return-Path: <io-uring+bounces-4935-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51AB89D5092
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 17:20:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1730A28223B
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 16:20:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A83519D8B4;
	Thu, 21 Nov 2024 16:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VhWdhPjP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EAE155CBF
	for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 16:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732206021; cv=none; b=AWXCZ/al9FyhVVbQduiehHn4WCWwdM++WF/YjYvoc09OJrcgslV2EvJH72PsGsKVvd7FkOOXVWmdtSL1kjlX1TExWtZqGr/sb+xdmL4hXhmg9D/dShdutAwNBy2tUCzLa2stFyW2Ddby5X5swGt/nnsYrm+O+7dkaji7U2t1cHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732206021; c=relaxed/simple;
	bh=eXvhXsZ1XgdDiFQjcXYyUsIIIt3bBu/3PvMPpDQmZeU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gGzZvHDYIBun4OIdXTup4Cp3jOtg1NfewBFwexbM2sFe/Ajeo1wuYNopXmSk9vJEZlykVNRsZHkVc7+E7Ewdh0SDAS+R3AIygxa8gbhODMdpifb0xckpx/5oWzOt1KhUVQV+B2v31cbJgH1BdOr2Bg90Zn+ZCUJ/ZTXstG/rBEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VhWdhPjP; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3e600add5dcso619346b6e.2
        for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 08:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732206016; x=1732810816; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TOqrPU6wkhh7C8nX5SQGLnlzcMLlbirPTWwyk4bVuUw=;
        b=VhWdhPjPvu4p1bxGFKi8Kn1P0JGK+HsuIPMrccqXRhvl9OnjYRpF3yMI5eMfroe6Fj
         sLf+8HATfsYiQhyRGsemu7A4tRzWlUTsP84zECNtCiHAtUFWCiEaakqqv6G9JXC0pMbF
         hpJoOndKuEsk3UThgLJu9y8wG1HWk9y+LVTSNdXEBrkjd/9qZYljI2EmTfVQzJPaKd9+
         9EUmwO39PqaWejgi85a0phDzU1TNcLT0R42lz7P9GubGen6h/kGBlXeTJ2HMV2oIzRW8
         AVkOmMmDNK2uFZsBW5G4APiYIZlDA9faHa4NgtEgNsZRS7QHwsUp6JaaxyJentNLR9FW
         Y/RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732206016; x=1732810816;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TOqrPU6wkhh7C8nX5SQGLnlzcMLlbirPTWwyk4bVuUw=;
        b=NAbsqmc0wX1ME3JYp71812UuoVM5a52QrHrjObIIhB2+u+3UwwZx7TYh6eUBVLppWU
         boWpeGXULSW/Zs1nEqN8LvBuuFsbP8cRIsDZ8tEDe0HNSRPVIc9EdJN5Wd3HqzfZGCyo
         EJB3SqwZKJb2nIboKYEO720OSfQ80XczIPZvjgvHrq+6UlMPBy/u1YBIoPao+rmMZANP
         z4J5KpNOvULYczRIoGsDv2lCyereGQYnkYLjtBId7hjRdSPdfkImkRWym3vqh+/fN9xg
         s4yQtaNxUXyoHIxnVdt/P4/uWn5hCSvXx4qRgchVnH2E1BD4HNqkq2ulmwh/bCPK8CQt
         HPqA==
X-Forwarded-Encrypted: i=1; AJvYcCUa6cTxc5rbWivhSSxUdpMqSyYlL8OYqDlah5C9eRZrfCu+eMs1Ucs+OWyeFBYOsrGV/MZ1q6fXkg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyRPDhiQYOGT69YXLbGvnm+Qcj1uV/qQ7Gl+JO8gQWm76M0DKSy
	V19vZkX0bOangCD4LOqU3aVyy3tc3kAlckEvw7jqzXGc+SzM04z7rEcLjTOgsgA=
X-Gm-Gg: ASbGncvIJIx9pZRF1/tFl+K4avl8heQKPSDu24OsjA2pAvxMcb2uQygdjEU/fFwQ6FK
	cUjIgkoi+RnClkvHzQlS4Q+QeA7mlujkPaLIRgzib2wI4Gq+1FEKb/KPmAG0l3VGwBhuvMuduw2
	eIYTaIsauG6MHf0+oder49vea7xi/qMk+LkrqMZ/tVxK0Vt/0aMPEY+2qsPoCYvaFtTaCPMExvV
	fJyC9Ns5X9dZKnZwNic8tiyPA1bN4FqJ9/zY//osX1VRg==
X-Google-Smtp-Source: AGHT+IGLGPJcXRMMBz+H/KmBvu6orXWZbgPDCx+mO1Ujvo5SLpL3OlSbZ5mSUI+ojziThG3bZo6Ssw==
X-Received: by 2002:a05:6808:f91:b0:3e7:61f6:811a with SMTP id 5614622812f47-3e7eb7c7ba4mr7361216b6e.35.1732206016557;
        Thu, 21 Nov 2024 08:20:16 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3e7bcd82997sm4763133b6e.34.2024.11.21.08.20.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2024 08:20:15 -0800 (PST)
Message-ID: <375a1b30-5e68-439d-be55-444eaa19d7ef@kernel.dk>
Date: Thu, 21 Nov 2024 09:20:14 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next v1 2/2] io_uring: limit local tw done
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20241120221452.3762588-1-dw@davidwei.uk>
 <20241120221452.3762588-3-dw@davidwei.uk>
 <f32b768f-e4a4-4b8c-a4f8-0cdf0a506713@gmail.com>
 <95470d11-c791-4b00-be95-45c2573c6b86@kernel.dk>
 <614ce5a4-d289-4c3a-be5b-236769566557@gmail.com>
 <b7170b8e-9346-465b-be60-402c8f125e54@kernel.dk>
 <66fa0bfd-13aa-4608-a390-17ea5f333940@gmail.com>
 <9859667c-0fbf-4aa5-9779-dae91a9c128b@kernel.dk>
 <3e6a574c-27ae-47f4-a3e3-2be2c385f89b@kernel.dk>
 <357a3a72-5918-44e1-b84f-54ae093cf419@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <357a3a72-5918-44e1-b84f-54ae093cf419@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/21/24 9:18 AM, Pavel Begunkov wrote:
> On 11/21/24 15:22, Jens Axboe wrote:
>> On 11/21/24 8:15 AM, Jens Axboe wrote:
>>> I'd rather entertain NOT using llists for this in the first place, as it
>>> gets rid of the reversing which is the main cost here. That won't change
>>> the need for a retry list necessarily, as I think we'd be better off
>>> with a lockless retry list still. But at least it'd get rid of the
>>> reversing. Let me see if I can dig out that patch... Totally orthogonal
>>> to this topic, obviously.
>>
>> It's here:
>>
>> https://lore.kernel.org/io-uring/20240326184615.458820-3-axboe@kernel.dk/
>>
>> I did improve it further but never posted it again, fwiw.
> 
> io_req_local_work_add() needs a smp_mb() after unlock, see comments,
> release/unlock doesn't do it.

Yep, current version I have adds a smp_mb__after_unlock_lock() for that.

Will do some quick testing, but then also try the double cmpxchg on top
of that if supported.

-- 
Jens Axboe


