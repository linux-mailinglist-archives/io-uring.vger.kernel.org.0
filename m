Return-Path: <io-uring+bounces-336-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 99CA481A524
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 17:30:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3AE581F28F97
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 16:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6167841854;
	Wed, 20 Dec 2023 16:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iEC3j2kU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB0C1D696;
	Wed, 20 Dec 2023 16:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-40c41b43e1eso73935655e9.1;
        Wed, 20 Dec 2023 08:30:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703089814; x=1703694614; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t2t/vrxAhc6r9QDyMW4zp7puXeyjjX6TPCTabdrMLMM=;
        b=iEC3j2kUGRCCKWI+Qb4e5AmOLtZPhOyj6W70MiJcBmQRQ2DObGw0FAANRfG4ML9LkC
         4eL0ddjG5Zx1UK1eT0f/75vLOdvjyY91vhXqHklqRGDT6ltxdPxKhjxNQzb5mAzvSemf
         3S16L5Qcf9Q8LF3fK2RqFtJ+L3+xhAc9b4DLsEjUnxElihG5l2DRib9hcSjH+qPiyYXO
         GswPUQeM1KDgfKCgsgWKpb+x9/1/rldeTYY3hEtPrex5sFzPGonP5pgGmFHnSyljirs4
         4lIp403UcABXO08Aajn3jELHBAEvMO+TXs2G08+GuPzwaJpJibVDY/6cpfwIFdwgBq/R
         lLXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703089814; x=1703694614;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t2t/vrxAhc6r9QDyMW4zp7puXeyjjX6TPCTabdrMLMM=;
        b=OvJVOKRKwZS0vdysXf9N5vOAN65NgCoQqPY+hXmbynp0Md7NYyldHKVHTZlzuDYStB
         iqidhCLFnyCdI3ly+GdIsfUrzK9b5yHpkuQAn+szDmPKnbj0AQGjtns9xwnJQJuZFPkj
         2mdHIJYWWjSHBwPFRqojj41+aiG1cQMbaliQkFSYab5b72/hUskDCPXFcA6sgf2TEfCY
         Vq2djyiVvHmkDLHnwOz7BFeVXC4gaZfjotAnFqhyE71J5iXjD3nKpqtFSUa0+dlr3Hhb
         HhOzk7yQ+Wj0BWhpGyPmUf5zo93hY/jPtv6a1rzzmHYDsxtdlXKjA8a5zJp/IQWylpB2
         Rdsg==
X-Gm-Message-State: AOJu0Yyl3QXHwFZC2kR9yUJk0ReO5f/HVV5PTTf8b9Wusx96uekTYWN0
	9sD2gBQ05BuNbDAZ6jMxIvo=
X-Google-Smtp-Source: AGHT+IENTfFyov/bV+XdXll/GT/DhHSqOKK9sAC0C0GHkijL4W4QYJSUEcVK2M1Dbh2UTvNEhETQog==
X-Received: by 2002:a05:600c:520c:b0:40d:38c6:618c with SMTP id fb12-20020a05600c520c00b0040d38c6618cmr457217wmb.78.1703089813757;
        Wed, 20 Dec 2023 08:30:13 -0800 (PST)
Received: from [192.168.8.100] ([148.252.132.119])
        by smtp.gmail.com with ESMTPSA id v11-20020a05600c470b00b0040c5cf930e6sm157741wmo.19.2023.12.20.08.30.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Dec 2023 08:30:13 -0800 (PST)
Message-ID: <26e767ac-9818-4e62-a206-0838e35a9ebd@gmail.com>
Date: Wed, 20 Dec 2023 16:24:20 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 10/20] io_uring: setup ZC for an Rx queue when
 registering an ifq
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20231219210357.4029713-1-dw@davidwei.uk>
 <20231219210357.4029713-11-dw@davidwei.uk>
 <7fa21652-36fa-4f13-9f36-c1b5ec681bb9@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <7fa21652-36fa-4f13-9f36-c1b5ec681bb9@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/20/23 16:06, Jens Axboe wrote:
> On 12/19/23 2:03 PM, David Wei wrote:
>> From: David Wei <davidhwei@meta.com>
>>
>> This patch sets up ZC for an Rx queue in a net device when an ifq is
>> registered with io_uring. The Rx queue is specified in the registration
>> struct.
>>
>> For now since there is only one ifq, its destruction is implicit during
>> io_uring cleanup.
>>
>> Signed-off-by: David Wei <dw@davidwei.uk>
>> ---
>>   io_uring/zc_rx.c | 45 +++++++++++++++++++++++++++++++++++++++++++--
>>   1 file changed, 43 insertions(+), 2 deletions(-)
>>
>> diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
>> index 7e3e6f6d446b..259e08a34ab2 100644
>> --- a/io_uring/zc_rx.c
>> +++ b/io_uring/zc_rx.c
>> @@ -4,6 +4,7 @@
>>   #include <linux/errno.h>
>>   #include <linux/mm.h>
>>   #include <linux/io_uring.h>
>> +#include <linux/netdevice.h>
>>   
>>   #include <uapi/linux/io_uring.h>
>>   
>> @@ -11,6 +12,34 @@
>>   #include "kbuf.h"
>>   #include "zc_rx.h"
>>   
>> +typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
> 
> Let's get rid of this, since it isn't even typedef'ed on the networking
> side. Doesn't really buy us anything, and it's only used once anyway.

That should naturally go away once we move from ndo_bpf

-- 
Pavel Begunkov

