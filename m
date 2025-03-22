Return-Path: <io-uring+bounces-7209-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D52E3A6CBC6
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 19:20:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0EEC53B2CF1
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 18:20:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 416611865EE;
	Sat, 22 Mar 2025 18:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mfnq0RrN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3099443
	for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 18:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742667628; cv=none; b=E9GbTJ52QwVc0aUot+S/diHNOl8Cx3UI8FFtfhChIvHDaTHc5akNdDXZrN2IdMHS+eH3BXMFkAmehVci+aBqUZ7UQ+npSuURjTegvZKbAXR2brJ/B5giAz/mHIDHkXV2/4IxUd7ETVAD3PvM7HJocL6QBRfT2Znj/Xs7DjXzcH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742667628; c=relaxed/simple;
	bh=Y3lyAOL4J8/DGtUZVPbn/yTVE+wX5oA0Ih9ews6pU9k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UiixWEMVeD8GxaMJNER4IskmJT7HdRQA/+5MsKTu1Y2O4I40sKy6r3cpiR+wVRUw/MDg1jpMaH1I/4npndSRedVFv9rdIKoE5dJH8k1lEv8lUqaMGmfjkBbJ5AO6z5xjvMSD1O7uxDilwuLVN/doIOqlyVCn90WKRLTjSApYQdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mfnq0RrN; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ac2bfcd2a70so454932066b.0
        for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 11:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742667625; x=1743272425; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y13a5KclgKud/tBaA8U+Uz/sAl8IO3d77RLlBKbwhGA=;
        b=Mfnq0RrNywLRLOYveLoFVoCrLOFJeXs5+FJ3R5LBEYTM+g9hoDZI9hU8spzQzsiMAi
         Z1V/lxLvVTnvlzcfdvZafbDV3e5Zv6UCMWVEb9vI77f6SA3l5OEbMyQsFFHs8Ij581Ke
         AaLeuffBCUlWiXV1tw62/+B7rWBolnMwIBQMKN0Tb1XaOiHOfqTxFa4hLj90P/s2xoKp
         HYHmxAdc4mFt4Cjvw0myu+Rl8PJfWSfSURLoRRUrKe2URL4MlmdTpKrVg3TXvwIMxUKP
         5s996sdJGm3JUtWVgz8Ql+1GeEQLWBa87YKOqYMEMHDLFC2VZ8gP0aQSBcbtzkp4T+Ft
         Go/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742667625; x=1743272425;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y13a5KclgKud/tBaA8U+Uz/sAl8IO3d77RLlBKbwhGA=;
        b=fmsjsncU4ifheUqyTMyGu6wKuFSGhwaO04B0Z5LKszQBm14vP0hvymtmXt97ZT/Ao1
         0SRd2wwC+vQrAY2rUc/rYHVYkZJEKb2/e9d7StfgDVk9dlUd9yzddvg9VodZ3FzieQDh
         PYBV5+N+4gmMrkPk2qUyBApcqWflPl9w0OdkedxN7kS+qc2dyG2XHvAEfPXQdOKsXaJa
         KoDPxIRbjXhAdmCbS11XEc3zgErxPCk+VI8Dcr91OnfXwlaGdtLpnqGWQmcHMgt3LIuR
         EjkvAq/viilSWT0oSWjjnbpsnMhKf/MTynp1cQC172fLNJkROhK2FR6tZ9wQ3QRL4RWC
         qPLA==
X-Forwarded-Encrypted: i=1; AJvYcCWq6nqkIWizJ5XcasAPpXAPUglmFInPzsUbAIIxUuVupxBPsqQ/TA7fka/hhUCcQlFkk8jXKrnJCQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6/ZOKpaNN5gWYx8PwOblpqwiWO4s0Sgwo1/oUoejh4FO9GAUl
	8U+L6vnpNpH/v4d6xC0E13k20Xev5VchZ1ENlpFysVj+LmP2mfl9Wbt/kg==
X-Gm-Gg: ASbGncuct8MMfPBN0kyNsQ0asgWSondfZ0MOQ5tE/GyEtuy8Vr0c/LvH5bIW7l60LLp
	cJeH0uoCBW2w2Se3IVqRX6KmApdYTHD6KDn8PpaSbDuGzsqd+wObwAUWh1YI3Pqbn77V28Na/Fy
	JBKNzUWrnlewgzsCWdqDxiULW/uuRKcjP08OPqEFPuW9/TVGn19TVorOGYlMfmO/FHOgoZAL/+7
	qxLbq7Ee8uCOIvwJU2GiJJ88dCjOKYaNpNLdFdGSw8JNBIWs3QZEq5twc175oPIdXif0uGsa4Hb
	0PA6Hv5werexT8XCqIsBgaZdeK45cwy0S/4yr13fhWpIpez0++Cu
X-Google-Smtp-Source: AGHT+IGXUz11mox0PV0HN8QPewWh6ENR/SXE7IaY09QHgCxCPBlpKW/Yh6V/gW88jB7S8H/eqs0CIw==
X-Received: by 2002:a17:907:a58b:b0:ac4:85b:f973 with SMTP id a640c23a62f3a-ac4085c029amr388240266b.34.1742667624495;
        Sat, 22 Mar 2025 11:20:24 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.234.37])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3efbd4672sm382405566b.127.2025.03.22.11.20.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Mar 2025 11:20:23 -0700 (PDT)
Message-ID: <458b8b70-4ff3-48dd-8d03-cf49819a4574@gmail.com>
Date: Sat, 22 Mar 2025 18:21:16 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: zero remained bytes when reading to fixed
 kernel buffer
To: Keith Busch <kbusch@kernel.org>, Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 Caleb Sander Mateos <csander@purestorage.com>
References: <20250322075625.414708-1-ming.lei@redhat.com>
 <ae74ba78-d102-42de-95a6-1834f5f85dc6@gmail.com> <Z97ALTDd-s0-uT7O@fedora>
 <Z9741KU2Fz7J0NSq@kbusch-mbp>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z9741KU2Fz7J0NSq@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/22/25 17:52, Keith Busch wrote:
> On Sat, Mar 22, 2025 at 09:50:37PM +0800, Ming Lei wrote:
>> On Sat, Mar 22, 2025 at 12:02:02PM +0000, Pavel Begunkov wrote:
>>> On 3/22/25 07:56, Ming Lei wrote:
>>>> So far fixed kernel buffer is only used for FS read/write, in which
>>>> the remained bytes need to be zeroed in case of short read, otherwise
>>>> kernel data may be leaked to userspace.
>>>
>>> Can you remind me, how that can happen? Normally, IIUC, you register
>>> a request filled with user pages, so no kernel data there. Is it some
>>> bounce buffers?
>>
>> For direct io, it is filled with user pages, but it can be buffered IO,
>> and the page can be mapped to userspace.
> 
> I may missing something here because that doesn't sound specific to
> kernel registered bvecs. Is page cache memory not already zeroed out to
> protect against short reads?

In which case it's not up to io_uring to handle it. Just to be clear,
maybe you implied that as well. But another question is the level of
trust to kernel drivers vs userspace drivers. One may argue you have
to trust the kernel drivers.

> I can easily wire up a flakey device that won't fill the requested
> memory. What do I need to do to observe this data leak?

-- 
Pavel Begunkov


