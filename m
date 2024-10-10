Return-Path: <io-uring+bounces-3559-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D425299876E
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 15:19:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E55D91C2266B
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 13:19:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 117611C8FDB;
	Thu, 10 Oct 2024 13:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YGAKd7/h"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C27A1C1AC1
	for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 13:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728566375; cv=none; b=U2j5D56IsGV88K3KXNewkyXKzuPARv7jbPTemACbkfQggSwCKiNKIzM43KqrtegR9D87G5Nn5QIGV4lBKUiWSncsFeKTzX6ne+x9S9PdoJp7O27V/Bg3jylfytiCgr4uwHbiPCKXvfByNuCBnDp0wDF8ZVXlu1oDP4WEyE5jvIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728566375; c=relaxed/simple;
	bh=cpOaercjncQOB9gV1IYhByw7G5IKZygARcivDskCyR8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lRT0+xwlqCzWFVqofjEIcONqNGaA2mpFXFHVQ2QlEqZlSy62WCcgI3/2x+CAyi6GoF6Janx0sMKachevgJ3kQDsyEbnp7aHdyw+fi5t36ZhoW5pCCHkDWThKK+6Yz2lN1Si5sRY8ZkHtFGQIsMhZGlyOu/l66+pUDm/ZTea/rxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YGAKd7/h; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-8354cecdf83so16865539f.2
        for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 06:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728566372; x=1729171172; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lSOi3DtOdsijIeimPagm2VwpzMqM+VhZby/6Pj6Npv0=;
        b=YGAKd7/h5XCT6IYGI1E+7L3mXjRYtv0h++Q9RVQjgi3PGgnF4nLM6HlHUd03TvNhiD
         jM8J9iGspikMQ4pFc99eVTho1wMkrALqnzMMP5srwsBi6h+uf/steGzn+SUEUszYa8I2
         wMaiobOVOP8QxZkagnEXrf0f5KNrRzixhi0MGf7wXlbXxWdjxfcpM3xNQT+uwOQ7rp9b
         aI0qvmFt7cvK/3i0r42RQhsSx871Ndh3VMotj1EnFeOYVj8/e6bG9NJVNKdSrdppIiFx
         jtLY9WSfW6MQCakSfOeWfD1xhQDoTp3JHeIYlcO4+BiXHAimqEPPYm5TgvFVIaxdgsZu
         CVeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728566372; x=1729171172;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lSOi3DtOdsijIeimPagm2VwpzMqM+VhZby/6Pj6Npv0=;
        b=Ed2oYR6VaFXND4+EXK9T0Htxx4wZl9dfiU6jTUXZZUmq3wwYK4KdrTe44Hsye+GTEK
         UWp/7CBtEdD/JuJTh04MX14gyeUhsXCFBJYbOgFdrIgWE4c3kAk3N3zxzBg86/8Bytol
         1o7LALDDM5CJ1y0EAdK1fZSl0obaRO/1BcxfhCycKK5+eAV9Fx36o0wUPiPT4G4QImgn
         +8FvPX6/8r9j3xpZz6V0kANbPxvEbZHePrDq3x2WMhsuP0J/qlv1aHWrA3SrMdQTFq7w
         7UNlNLy9WDriaC3JGWDRF5gqluQFya7UrPDmCcA/C7z9IkB3T8C1G9p7iuAcmmLDOJeQ
         +P9g==
X-Forwarded-Encrypted: i=1; AJvYcCU/tj4VP6l2q0nNIK47kalddsCL0Ds0VXscdrn68sn1rTObg+Fbys/49Aj8U4qTwBCO4rZ9MHWcHg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyjWyfiOBgLJyM5Vj6Au4GkB91hAxTajLNFaDv4MluAWTIThq7h
	bNadaR0Cbl5yRDuA4MvK3v9At7ujjpAwInGSK9zL4aNUQ74fElfF/1/t1RfDrSM=
X-Google-Smtp-Source: AGHT+IEfuaThIrnTiZMf+XnJ5qGwySu3D9xl7h3sdOh4Z8U7QUEwy1QmNLOVYuh7HK0DKH/HbrPwCA==
X-Received: by 2002:a05:6602:2dcd:b0:82a:ab20:f4bf with SMTP id ca18e2360f4ac-8353d47c380mr522731139f.1.1728566371817;
        Thu, 10 Oct 2024 06:19:31 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dbad9d604fsm239318173.52.2024.10.10.06.19.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2024 06:19:31 -0700 (PDT)
Message-ID: <6f8a5e79-e496-4f94-93df-84c66a10e73a@kernel.dk>
Date: Thu, 10 Oct 2024 07:19:30 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 14/15] io_uring/zcrx: set pp memory provider for an rx
 queue
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-15-dw@davidwei.uk>
 <53f1284c-6298-4b55-b7e8-9d480148ec5b@kernel.dk>
 <678babf5-4694-4b65-b32a-55b87017ed87@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <678babf5-4694-4b65-b32a-55b87017ed87@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/10/24 7:09 AM, Pavel Begunkov wrote:
> On 10/9/24 19:42, Jens Axboe wrote:
>> On 10/7/24 4:16 PM, David Wei wrote:
>>> From: David Wei <davidhwei@meta.com>
> ...
>>>       if (copy_to_user(arg, &reg, sizeof(reg))) {
>>> +        io_close_zc_rxq(ifq);
>>>           ret = -EFAULT;
>>>           goto err;
>>>       }
>>>       if (copy_to_user(u64_to_user_ptr(reg.area_ptr), &area, sizeof(area))) {
>>> +        io_close_zc_rxq(ifq);
>>>           ret = -EFAULT;
>>>           goto err;
>>>       }
>>>       ctx->ifq = ifq;
>>>       return 0;
>>
>> Not added in this patch, but since I was looking at rtnl lock coverage,
>> it's OK to potentially fault while holding this lock? I'm assuming it
>> is, as I can't imagine any faulting needing to grab it. Not even from
>> nbd ;-)
> 
> I believe it should be fine to fault, but regardless neither this
> chunk nor page pinning is under rtnl. Only netdev_rx_queue_restart()
> is under it from heavy stuff, intentionally trying to minimise the
> section as it's a global lock.

Yep you're right, it is dropped before this section anyway.

-- 
Jens Axboe

