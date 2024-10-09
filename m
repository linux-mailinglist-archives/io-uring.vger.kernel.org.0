Return-Path: <io-uring+bounces-3483-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C256996F65
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 17:14:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 084651F21168
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 15:14:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 881191991B2;
	Wed,  9 Oct 2024 15:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f8psHNME"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE04B1E1C36;
	Wed,  9 Oct 2024 15:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728486390; cv=none; b=PF2aC2gqI4VAilG6H8DOYQbNo+Dd5eXMK9Su5+a42d0mmhOSal4FoLWCtM58V8mcqV09OEQgImHXYocKEZXJgXJ9wqPU9Sukmz8AAtgzRd/5SN13f/mWjV14XZf3Ao4VoJh0HcrBWgkllyFEvNiTWhOPqxwHF+yCxVFZbRokSYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728486390; c=relaxed/simple;
	bh=XG9BUzLl0iSLdRVbkDDTsB0zdvBysNvrU81sU1Mx95U=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=oB3RRsVoUeelt1tJBOw9DJYq8fXnaI54FwnFCuiriU14p37Y4Byc0FceX5YvvLTY9JH7i1t12q0ydEmKnefW6PayGwEr7Gxr7tYbeGAJGNiKhNrOLjYyDZ1KjRe/fJ7B30c8wWirfcREx7WUFfiOI/voNmf9ib5bH9y80sawJFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f8psHNME; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a99422c796eso641465966b.3;
        Wed, 09 Oct 2024 08:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728486387; x=1729091187; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MHk/zkCAjFuD+HHhG6I/0xViBA/w7+RItj14vqo45CU=;
        b=f8psHNMEIgFBlOsXlcaVPQRlwcTls0WmQ47FZySoRz9l74O3YnMZPVBGe9dIBdBSTr
         bVD3cFRX32xLpGp3ESsh3lNIWUjo5/dNw6QstY+UbdQDWyoCIhmkG06tqQs+hLvc16Mz
         TgBgMql+Zf8yfBXm++LY6QxeSeD8WsVB/zdaId33rp0Xh+L/Q9SPv/8FceUpGqQCp/9O
         mnzDXw4Y0pVDo8OdVvIQBMzzJhz4F5rf7LOqPYP14oshiflFnO8L/4hyV/Yuq0EjiGsR
         04VB28nT8Vk9FN2X8ApeIVKQSLYHlgRKMRtvqXSrJySTHswPzY9oH+w1AWQfY6iGhEOP
         FQNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728486387; x=1729091187;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MHk/zkCAjFuD+HHhG6I/0xViBA/w7+RItj14vqo45CU=;
        b=hl/ApTbyPymOZXZ1F80L+tzKCq9pOijN0rkued1AaGmTNztv0wLF8TT0mUVb5uevdG
         Q46vbJBPUZX3DmwnD6MMT8bpY+QihjmuwrPK7m2PNB/oE8FmJBlLcfO1Q8i8TnR73alR
         Ej34OxXxMQjw4wXBJJf5i228JwEgBmGnUPJON1k+o1p4v1X4dTTdDOYbDbk4sMy/Q+SQ
         GTsOvyNi/m7YNoKR1kQt0I2m5gJtOeBYvWkLKeCZRhwEZPbKlXfsgWaHLwXAUAoxT7F5
         JV0Ce0iBzC14xlpilQPclU5sdEZXOrs83pOMKShILR7bUuRcujjvmVs2NkCnUTD5bm6q
         ljkw==
X-Forwarded-Encrypted: i=1; AJvYcCVcqhXhXL9gkbjIoIFVFHPgkTFeaz7D/KDDmqBuJwfQDnmzFxzSJLXyIhGl9EWZIG0eBMWSW+U6aA==@vger.kernel.org, AJvYcCVt1Rp7K9px5zH51c1XMk+Df8mKA+QHBycqX5ZPbAzudsDuXPT17+b6psDWGq3jkKngulkcvn81@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/A1dFPN/0Xm2tPCCad7SHYeT0I4ZLUyiqCnkx2g65nou4jX1A
	1fU8LizdKBu5drc09MnLjTiDUT708XOlhAxrVuJxRQ8FK92/qUC3
X-Google-Smtp-Source: AGHT+IE6fXI+7lx+sq/YXctwN07yUrcKBeO84heKL/nOSWlGs8cjAj4OSAyD4wIhJ43hUcUBwuQbxg==
X-Received: by 2002:a17:907:2d8f:b0:a99:4262:cc16 with SMTP id a640c23a62f3a-a999e6d5399mr37724466b.27.1728486386773;
        Wed, 09 Oct 2024 08:06:26 -0700 (PDT)
Received: from [192.168.42.207] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99409f1db6sm586065266b.97.2024.10.09.08.06.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 08:06:26 -0700 (PDT)
Message-ID: <6a45f884-f9d3-4b18-9881-3bfd3a558ea8@gmail.com>
Date: Wed, 9 Oct 2024 16:07:01 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/15] io_uring zero copy rx
To: Joe Damato <jdamato@fastly.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <ZwW7_cRr_UpbEC-X@LQ3V64L9R2>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZwW7_cRr_UpbEC-X@LQ3V64L9R2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/24 00:10, Joe Damato wrote:
> On Mon, Oct 07, 2024 at 03:15:48PM -0700, David Wei wrote:
>> This patchset adds support for zero copy rx into userspace pages using
>> io_uring, eliminating a kernel to user copy.
>>
>> We configure a page pool that a driver uses to fill a hw rx queue to
>> hand out user pages instead of kernel pages. Any data that ends up
>> hitting this hw rx queue will thus be dma'd into userspace memory
>> directly, without needing to be bounced through kernel memory. 'Reading'
>> data out of a socket instead becomes a _notification_ mechanism, where
>> the kernel tells userspace where the data is. The overall approach is
>> similar to the devmem TCP proposal.
>>
>> This relies on hw header/data split, flow steering and RSS to ensure
>> packet headers remain in kernel memory and only desired flows hit a hw
>> rx queue configured for zero copy. Configuring this is outside of the
>> scope of this patchset.
> 
> This looks super cool and very useful, thanks for doing this work.
> 
> Is there any possibility of some notes or sample pseudo code on how
> userland can use this being added to Documentation/networking/ ?

io_uring man pages would need to be updated with it, there are tests
in liburing and would be a good idea to add back a simple exapmle
to liburing/example/*. I think it should cover it

-- 
Pavel Begunkov

