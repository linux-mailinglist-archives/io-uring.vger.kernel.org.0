Return-Path: <io-uring+bounces-4335-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 878BA9B9986
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 21:35:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AA8C7B20EF5
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 20:35:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 755751D5AA3;
	Fri,  1 Nov 2024 20:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YgPbcV53"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AC21D0F49
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 20:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730493330; cv=none; b=LaT5TZ8Ea5oeFq0lrGkQmphZdUokUWgo5gwrqRcPTtuHBMdam5huj6D+oNtG+XX5QIaXWFtSZKlFdGV7Tilrt/sSPur7/9XFi6pzaqtRYe3qk9fuq9Yk0S2koLvaakytrSM0GnZIjfuwFt4T14+kTdjf971+nZxaNA+SKLpVXrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730493330; c=relaxed/simple;
	bh=4vdkDamk0gxVinFJGmu5KVA+KIxk1kPx12dr5LKotfs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Va9pczacnYK3ok1Yl04YZi2yGqaaEAt0o47gqntmOL/1kE91S4ybDKjVSkyQ+Cpn7fKKtJzes8sew1Xy502KvweYtI+eD9iiF68+mq1DRcF3Femf3XTVvmNfGJAzAfcDAop/wHqzDsA3LL9Gp+j6kSVYLZLRXxzOkWx68fPYZTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YgPbcV53; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7203c431f93so2082699b3a.1
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 13:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730493327; x=1731098127; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JgFVDaRa27hED3DzOWnvyHEJGlmoGmBkQ7w8ANTDlE4=;
        b=YgPbcV53ZFPxSbyUdHb4iH62YCh2a+0p7/Enjt+a/Llm5v65lQgAMIwFoqhOoSugPi
         iJ7KcgE+TLGqdlpmatkup/3Y+HRDRdf+IgLeZApXAc8CTb4VYTogbgD040dNeFFRvoHt
         bhoqZoz/V5GJ63mDbhnoGLWAkyjEgpXiYesfKSkf4YRj3HAp+Lfi0OShy5hs7vS4D06T
         drqOgmQDFGTLTETKTt0bPVyMAIwVKKHxuvkr702Oeo36c7itSBELOh8jV4bce6mM0M+0
         a0MIqhZicfBqaj4OWg67Kl1Y2RGsqAUJZs9FJn7jfLzf03B0nlme3vdt2kJ57mJnEhV4
         oRog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730493327; x=1731098127;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JgFVDaRa27hED3DzOWnvyHEJGlmoGmBkQ7w8ANTDlE4=;
        b=ZXEGtfpQ2FcEtkckR4Ias61kuWr9NzHb4Xj02zDzYGXKPRyp/0GIY8CgbqmgpyEY6o
         Sf/PD0XuFPxvhl6XF1DCk1pK0D05UguRyKXo7UuklvvPUo+7laSpQkdYnZ8udvWQM3Nt
         xWfCv6e9OsN3iaV6D0a/884Y0we/Z/ec6Y0dfgHmBxeP9I75NjoJn+/wmpWIbAEpPrWW
         px52UFxCW4cnSg2FqaFRmbzKI4dvyjKI5UN0Bko7HkuPitO+aAvu2xTZ0GVrxw/RGy3t
         RC2snMHrpHRmYFUW7MO0Vi5VcO/X9LwSbfkKT+M9GEoqhulepwvDp0Ve3MTXkdF7pB5u
         xaOQ==
X-Gm-Message-State: AOJu0Yz6fL0WI71UxcFKGZHWFqT7cZWwdmqP9+++Qvv1sCITpkUu5mUH
	Hv/+epqRIyJLSDZNKjVnIsdTcN/1gXQrH3neCTdby7RBx3aiqZHUcfm5P/5ZKAk=
X-Google-Smtp-Source: AGHT+IHqElhzOIuhDL1c7nxGy2/dlYFAR4amzACX2pAjU+R4lmxrcXgjLJC/snIUnrp+DnwYpnjqXw==
X-Received: by 2002:a05:6a00:a0a:b0:71e:581f:7d7e with SMTP id d2e1a72fcca58-720b9c29c4cmr11075114b3a.15.1730493327205;
        Fri, 01 Nov 2024 13:35:27 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc1b8d2fsm3085449b3a.9.2024.11.01.13.35.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2024 13:35:26 -0700 (PDT)
Message-ID: <ae63ef86-9dba-4360-bdbf-9ac5ae04adbf@kernel.dk>
Date: Fri, 1 Nov 2024 14:35:25 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 13/15] io_uring/zcrx: set pp memory provider for an rx
 queue
To: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241029230521.2385749-1-dw@davidwei.uk>
 <20241029230521.2385749-14-dw@davidwei.uk>
 <CAHS8izMFV=1oRR6Tq-BVJxCL3hbEjNa0CBzWmWxbnk_0MZOs6w@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHS8izMFV=1oRR6Tq-BVJxCL3hbEjNa0CBzWmWxbnk_0MZOs6w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/1/24 2:16 PM, Mina Almasry wrote:
> On Tue, Oct 29, 2024 at 4:06?PM David Wei <dw@davidwei.uk> wrote:
>>
>> From: David Wei <davidhwei@meta.com>
>>
>> Set the page pool memory provider for the rx queue configured for zero
>> copy to io_uring. Then the rx queue is reset using
>> netdev_rx_queue_restart() and netdev core + page pool will take care of
>> filling the rx queue from the io_uring zero copy memory provider.
>>
>> For now, there is only one ifq so its destruction happens implicitly
>> during io_uring cleanup.
>>
>> Signed-off-by: David Wei <dw@davidwei.uk>
>> ---
>>  io_uring/zcrx.c | 86 +++++++++++++++++++++++++++++++++++++++++++++++--
>>  io_uring/zcrx.h |  2 ++
>>  2 files changed, 86 insertions(+), 2 deletions(-)
>>
>> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
>> index 477b0d1b7b91..3f4625730dbd 100644
>> --- a/io_uring/zcrx.c
>> +++ b/io_uring/zcrx.c
>> @@ -8,6 +8,7 @@
>>  #include <net/page_pool/helpers.h>
>>  #include <net/page_pool/memory_provider.h>
>>  #include <trace/events/page_pool.h>
>> +#include <net/netdev_rx_queue.h>
>>  #include <net/tcp.h>
>>  #include <net/rps.h>
>>
>> @@ -36,6 +37,65 @@ static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct net_iov *nio
>>         return container_of(owner, struct io_zcrx_area, nia);
>>  }
>>
>> +static int io_open_zc_rxq(struct io_zcrx_ifq *ifq, unsigned ifq_idx)
>> +{
>> +       struct netdev_rx_queue *rxq;
>> +       struct net_device *dev = ifq->dev;
>> +       int ret;
>> +
>> +       ASSERT_RTNL();
>> +
>> +       if (ifq_idx >= dev->num_rx_queues)
>> +               return -EINVAL;
>> +       ifq_idx = array_index_nospec(ifq_idx, dev->num_rx_queues);
>> +
>> +       rxq = __netif_get_rx_queue(ifq->dev, ifq_idx);
>> +       if (rxq->mp_params.mp_priv)
>> +               return -EEXIST;
>> +
>> +       ifq->if_rxq = ifq_idx;
>> +       rxq->mp_params.mp_ops = &io_uring_pp_zc_ops;
>> +       rxq->mp_params.mp_priv = ifq;
>> +       ret = netdev_rx_queue_restart(ifq->dev, ifq->if_rxq);
>> +       if (ret)
>> +               goto fail;
>> +       return 0;
>> +fail:
>> +       rxq->mp_params.mp_ops = NULL;
>> +       rxq->mp_params.mp_priv = NULL;
>> +       ifq->if_rxq = -1;
>> +       return ret;
>> +}
>> +
> 
> I don't see a CAP_NET_ADMIN check. Likely I missed it. Is that done
> somewhere? Binding user memory to an rx queue needs to be a privileged
> operation.

There's only one caller of this, and it literally has a CAP_NET_ADMIN at
the very top. Patch 9 adds the registration.

-- 
Jens Axboe

