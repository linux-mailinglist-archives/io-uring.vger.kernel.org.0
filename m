Return-Path: <io-uring+bounces-3183-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D769976F3D
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 18:59:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1121FB22408
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 16:59:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93AD21BE857;
	Thu, 12 Sep 2024 16:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GYU4agDS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774D51BE22D
	for <io-uring@vger.kernel.org>; Thu, 12 Sep 2024 16:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726160367; cv=none; b=gGYSbkO4isdrZKOJuDOJOwyvC2ye0FCwF3KPEvKWXrHSvtZ1Ruk+SvbjuOCdeySklg8IQDBLJv/YecayQuPCsY82gjgCG0sg2FyXFni+zPkSwYglwj8QeTUuc6juvrZpR3J5kxSHkRDOVTY5hHR4olpfMiM6tJ886jiwRzJTTG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726160367; c=relaxed/simple;
	bh=Ldi+zibZ/V2S4z3E7xRWlW+SCbd0ir+Qiyr40188ii8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HGn2H5dJZUhMxauO5qOcJniBLI0xxXp0bPbpYNJamC6Ks69ZRE7hmhlPTdomtsRfoSipubijLXUf83JA9qg5c0oKaCow+Qk60GHe9YPFlGaB9qOHhBA54vP5ACijgyC7RNu96QxBgJ0i7qLZ8/Npi31T47iQ/JM+irAseNcYKLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GYU4agDS; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3a056727fdfso4525595ab.3
        for <io-uring@vger.kernel.org>; Thu, 12 Sep 2024 09:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726160363; x=1726765163; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ik/dQnu5jeslrWeWVW6FYf9oUqwHtJ5XqerEocsu/Sk=;
        b=GYU4agDS4iEXZGoU5T+spxa4npgyuu3pn7xBkvYqrIHJ+/B8/I5cfmjT/KRcA8onaB
         9D9Yi1gDoEt9qUgHVnnZMlS37iSiCLwHDIAfX2otvv59d6QIMkDi5+i+0TXWpRGEsEmK
         Ivi5WiofRVwSOn9YxLMFb60aXfzF8aRADYRlExcArsggUbgta8dytDVUaaOhz8AHQWyu
         JPu6j75bJJAyB4P6wdzPHWnla75/002esdiVobrzemLFFwkWP1nZQnXCugsARY3aUBDo
         u0zAgsqyiiENM6PVtNGvdQ4ZsushInZ4YVtrfFA0F4FQ7EGbAPaerTOIiJxgi8B8McQk
         jXtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726160363; x=1726765163;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ik/dQnu5jeslrWeWVW6FYf9oUqwHtJ5XqerEocsu/Sk=;
        b=pHGonRFYAh5gbve7LriANG6fz1yVYrLuNYZFoLy3bnFOifceueA3NsZ8Gi9Z9D6dC1
         KJXcDuNfC33nQ716DwOdSec45/bevJANrQ7f8yl/Jl7hUfXTjSIfcwC1hY4uZqrfOTtR
         pcYafDj8Nq8Qs6KQKMl6mFuaeLlfPMsIhh1yhY7MtqW7a04iGAGfvcHhPfz9kpO8Sv9h
         VO/g7ZeD++XMOUez9AO/RfMRVoQrwHhmt6ESvvpDrTAB995BjoZT5JLctCuRavGXXGuH
         qtUTajGFAHWtbrDCOHMkKPf+OJz9Xar+85++SVBb7TUgvhFDOVWEiAy1BPUOTVHJhD/0
         jadw==
X-Gm-Message-State: AOJu0YyiOmDI3w5rrTMPFr0ZiVdOTDZ/nOvwR8kC4wCRDOyH3Mf7EeQ0
	ErLDa1FwRk3M5llR5rx5IJcrFhsgnaQmU7dsRdnUffRCArSRxeKfS03VprKR9vI=
X-Google-Smtp-Source: AGHT+IG0/AkbaBfjjgY5RdNvez4Q8oJijXmJux9z3RJ6adhyGPQMc3fgvUyAsKJD5k8HozTbpJTZnQ==
X-Received: by 2002:a05:6e02:1a8b:b0:375:c443:9883 with SMTP id e9e14a558f8ab-3a08494ab32mr34292555ab.21.1726160363430;
        Thu, 12 Sep 2024 09:59:23 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4d35f433cbcsm693841173.20.2024.09.12.09.59.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Sep 2024 09:59:22 -0700 (PDT)
Message-ID: <7e6ab59d-2248-4dab-81e4-4de6343b2672@kernel.dk>
Date: Thu, 12 Sep 2024 10:59:22 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/8] block: implement write zeroes io_uring cmd
To: Pavel Begunkov <asml.silence@gmail.com>,
 Christoph Hellwig <hch@infradead.org>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 linux-mm@kvack.org, Conrad Meyer <conradmeyer@meta.com>
References: <cover.1726072086.git.asml.silence@gmail.com>
 <8e7975e44504d8371d716167face2bc8e248f7a4.1726072086.git.asml.silence@gmail.com>
 <ZuK1OlmycUeN3S7d@infradead.org>
 <707bc959-53f0-45c9-9898-59b0ccbf216a@gmail.com>
 <38a79cd5-2534-4614-bead-e77a087fefb2@kernel.dk>
 <6ecd3129-e039-4b86-9e67-03a7a519266e@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6ecd3129-e039-4b86-9e67-03a7a519266e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/12/24 10:53 AM, Pavel Begunkov wrote:
> On 9/12/24 17:32, Jens Axboe wrote:
>> On 9/12/24 10:25 AM, Pavel Begunkov wrote:
>>>> an entirely different command leading to applications breaking when
>>>> just using the command and the hardware doesn't support it.
>>>>
>>>> Nacked-by: Christoph Hellwig <hch@lst.de>
>>>>
>>>> to this incomplete API that will just create incompatbilities.
>>>
>>> That's fine, I'd rather take your nack than humouring the idea
>>> of having a worse api than it could be.
>>
>> How about we just drop 6-8 for now, and just focus on getting the actual
>> main discard operation in? That's (by far) the most important anyway,
>> and we can always add the write-zeroes bit later.
> 
> That's surely an option, and it's naturally up to you.

Just trying to make forward progress - and since the actual discard is
the most interesting bit (imho), seems silly to gate it on the latter
bits.

> But to be clear, unless there are some new good arguments, I don't
> buy those requested changes for 6-8 and refuse to go with it, that's
> just creating a mess of flags cancelling each other down the line.

That's something to hash out, might be easier to do in person at LPC
next week.

For now I'll just drop 6-8.

-- 
Jens Axboe

