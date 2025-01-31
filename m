Return-Path: <io-uring+bounces-6193-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 640AFA23EF5
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 15:06:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF63F1889F64
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 14:06:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA7441C8FD6;
	Fri, 31 Jan 2025 14:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a8l3nyy+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B14E1B6D14;
	Fri, 31 Jan 2025 14:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738332361; cv=none; b=DnDFQKUIqc4qeYSbHLCSJff6nCxPfoDKP2NhdLwvBeW0W1/gtIDhTO3GG8jMxHl2QfA1ui8qtyofvU1V8bpB/GuJ7SbgKr1vyTx326lSr7MhGlSq7H1vmHUIgNf/xEXt+vgD5T+vNfR7dpxRLe1MoFi8gDu0qZBe9b3fcqpykak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738332361; c=relaxed/simple;
	bh=AKhJcbhz9IeNHSLT4dpDp7insuh1ayTEsj8qNLzp5Rc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MEnlexMUjLu6wmhu32D7uWVVsuOhw7kQYWXrFe7uL8ldIesIMqBAO3M48iltGzBU3Da+/yMree4lhl6/hrqX6+/Akg7TzLE7lyLDzqsz+LCbgUbch7YhnoBlWazRHdWcwAULjjEnCIlmSbzE25rl9wgWHDUdVNWkKpCbtkRHESI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a8l3nyy+; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-aa679ad4265so557597366b.0;
        Fri, 31 Jan 2025 06:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738332358; x=1738937158; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z64d2y4NHdd0vk7o+MMO6lu7NEou/L8WkeEtJSuSlfs=;
        b=a8l3nyy+B9RVn5GD/9UNooUh9wrpEs9SL1p7Jz7eIVYAkpnl3OZ0O2oqZ9a6Afwvmt
         0e911jKh60FbTvQufjaGL5Lb2gVb5evTyqp7MfEHeSJRHYq4ImrJ5ZA7M8QmS5JjqeFd
         JI5MR9+QtrvDK1EFccL6+ui57JIohJ1NfGk7Y6ptLmKRFln5XTd7P7rfm7kckS0ZPr6+
         To5yATl3tZs7V0rNaeh+bavls5ex3BkAj7ghrBjyTtDO7Ungu+orvD/qr+e6dG+qQVDw
         CU1jdd3shiqriX9JAMIOnVpBf/kLjji0m9ThwJ1Rgerlv0n4rHp+mKpuiRjzWt3xuFY8
         qWaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738332358; x=1738937158;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z64d2y4NHdd0vk7o+MMO6lu7NEou/L8WkeEtJSuSlfs=;
        b=ICw0tatFfur/+ghbnbDpdY/be4pIwUndmpITQdgnJxIfrixPaF8tsmXyuj+hDDsPCd
         P+j3GzgoxN13pePJ9RP6VC4VXv8RS8YpM2uo4lFh07T0RppgW7qrIJHjgViQhTXjCyNY
         2geNVFMG39UwSMiv0iK6vF7e3EmmL8O8gmSV8PjmGjeHVmirtk8z0CnRoDGXYRySBFth
         LIqLbPOmkWFNxcm0h8WPsDMFOjLC7UyuTZeWtQjs137n2/VnRljOOr9DCKwCnnDhMVKP
         94EKT1wPT4R/OamBR8qBQSMs+628septMvOfVD3hxcvzdty2QXgepDba1Xi5OM/rSvZP
         pfMA==
X-Forwarded-Encrypted: i=1; AJvYcCWNul5HDTyin4hoSzd/aSh8e4VaGdWK8F49+JqCUiVPMt7QyrDnxS74Iob+U8Ni6DX3Lozqfztxt8SGLEs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4MBIKX/T6kt+EacKdWyaiuU4ELP0AVOD1JGxjrzWiAtBc20xU
	bYIiz/sfcae0AmU1C8jhyNvHdBhLQ52ergoMzVCKm+r5YaX9sKue
X-Gm-Gg: ASbGncsoFHmZKl2utJONaZcDupGzbUqV7dEgirurKuUGkEJ5Kk7KK9zPQTC1sOqxtch
	VtAIgwudUaV1GH+yCXDsSIiXe1Ql/HPwpvlQbUOc8ABUG146FCsRBGz1MgB0aY9Btx49lUaA4uD
	yVQAEckFicwWu2aVudPvoGvf0Q1eJh8JkEOz/5cw+ngTVTIgF6gn0uo2ZKVSyelilBIPStsi6ov
	X22cgsxabfrRix4+IZIWrssBdCRFymA+hUGaIR3cy2kdmaXCifT0gzOhsOst/KD40A4tNy+g2u+
	bMTJl73lyCH1du+OVG2DsK7ociQu058MwFOkOZx61l8M/z2y
X-Google-Smtp-Source: AGHT+IGg/fxiAcoXZfZsEb9rL7dSaI71QWP8I8UBj92ldxrklztvC0JjhsHk2Yenwl45sS5zpiiUDg==
X-Received: by 2002:a17:907:9729:b0:ab6:d575:3c4a with SMTP id a640c23a62f3a-ab6e0c2fcb2mr674035466b.9.1738332357767;
        Fri, 31 Jan 2025 06:05:57 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:7071])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e4a59862sm302799966b.178.2025.01.31.06.05.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2025 06:05:57 -0800 (PST)
Message-ID: <274320d4-3031-4ef6-bb57-b45659acf58e@gmail.com>
Date: Fri, 31 Jan 2025 14:06:12 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/8] io_uring/io-wq: cache work->flags in variable
To: Jens Axboe <axboe@kernel.dk>, Max Kellermann <max.kellermann@ionos.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250128133927.3989681-1-max.kellermann@ionos.com>
 <20250128133927.3989681-5-max.kellermann@ionos.com>
 <856ed55d-b07b-499c-b340-2efa70c73f7a@gmail.com>
 <CAKPOu+-Mfx9q79nin7tGi1Rr4qGGY=y-2OhuP80U=7EtRpfBdg@mail.gmail.com>
 <19750632-1f9d-4075-ac5c-f44fab3690a6@gmail.com>
 <CAKPOu+8_Tivtyh0oj7UEuWPmdw-P96k3qRLvte1F1C9XivjS7A@mail.gmail.com>
 <6fa97ace-362c-425e-a721-5e2a9921fe5c@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <6fa97ace-362c-425e-a721-5e2a9921fe5c@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/30/25 14:57, Jens Axboe wrote:
> On 1/29/25 10:36 PM, Max Kellermann wrote:
>> On Thu, Jan 30, 2025 at 12:41?AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>> Ok, then it's an architectural problem and needs more serious
>>> reengineering, e.g. of how work items are stored and grabbed
>>
>> Rough unpolished idea: I was thinking about having multiple work
>> lists, each with its own spinlock (separate cache line), and each
>> io-wq thread only uses one of them, while the submitter round-robins
>> through the lists.
> 
> Pending work would certainly need better spreading than just the two
> classes we have now.
> 
> One thing to keep in mind is that the design of io-wq is such that it's
> quite possible to have N work items pending and just a single thread
> serving all of them. If the io-wq thread doesn't go to sleep, it will
> keep processing work units. This is done for efficiency reasons, and to

Looking at people complaining about too many iowq tasks, we should be
limiting the number of them even more aggressively, and maybe scaling
them down faster if that's a problem.

> avoid a proliferation of io-wq threads when it's not going to be
> beneficial. This means than when you queue a work item, it's not easy to
> pick an appropriate io-wq thread upfront, and generally the io-wq thread
> itself will pick its next work item at the perfect time - when it
> doesn't have anything else to do, or finished the existing work.
> 
> This should be kept in mind for making io-wq scale better.

People are saying that work stealing is working well with thread
pools, that might be an option, even though there are some
differences from userspace thread pools. I also remember Hao was
trying to do something for iowq a couple of years ago.

-- 
Pavel Begunkov


