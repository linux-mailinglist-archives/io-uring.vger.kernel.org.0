Return-Path: <io-uring+bounces-325-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B55088194EC
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 01:04:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1E7E3B2426F
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 00:04:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DD35156E2;
	Wed, 20 Dec 2023 00:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jhRrvTgo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8305F14F65;
	Wed, 20 Dec 2023 00:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-54bf9a54fe3so6353101a12.3;
        Tue, 19 Dec 2023 16:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703030689; x=1703635489; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X5S0Pd7ohGCP42Ze9PIwQlcyhis2/KWJU2IYvv2awBs=;
        b=jhRrvTgoHkSUKgKb2S/LItL6d8kiubhUi0Vk0cmIE4M57wY6KzPcZup279c4xrYKu8
         LMSplnR0eR1+7qZfMeLEmqTLephs/8PUHKB9U5vJFI+lrzAbL4yIipbcUCNUYDumit0b
         6dtJ8TwChg+a2s8dDSuu0GvZGKvWiXJvpu5Szmzmw/WTlS/QoVUNjPHyVbp6PqmVnky7
         RCZBecKaUBOhwZ3UTzWHm3K1aMKzHP9fv6tJG4Wv7sOprFewCtsvZNBZDZB659+jrzfO
         mtvJAgmg0asNxMhesWhyZjDp868RDAVFIhQQivrA7gyOaANA48ed1Rqtnu5u+zGFJfY0
         INVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703030689; x=1703635489;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X5S0Pd7ohGCP42Ze9PIwQlcyhis2/KWJU2IYvv2awBs=;
        b=U4ie9rz0zF9AGa43i6aAKC8vmkjyB9AGUHxYCs8RUSuz5vpUBCz7i88wHfTR5l0xyZ
         DjB7peA7zbv/29WlLmjYyJ3Rc7B5m/cWHdOotCIuD2G9TFJzzvWDnmWmHiqOOSYS5nly
         JhuV9W9aebzCgxwK6iiEuhhiIpTwpC0jyyurjQNoKmrIwel4rKLqFnEd5AwtyibpLsOu
         6/ZvaPAVA6F6N3bZ2zoQiSI3pCLD0bKikC2YfDZh1pyREEbqsK/oBt66M/TYtAVXhkOr
         WxR299gL42PbQxfGXDyE/2g6IXdAMi3Jmd3rf/Enj9fWJBiL+b3EDCcDLAbfHZjBVnO8
         nfVA==
X-Gm-Message-State: AOJu0Ywzc/BPtkDpL2qCzoHhw0d2oLP8SCe6MMZijwMThIpK5aBIMEMd
	nRB0i7X6AtuYJuZ+Vyw0fO8SazVTmLc=
X-Google-Smtp-Source: AGHT+IE6yCwTZBujm8ZJAl3PMp6/TjEdt/h167kHn1xj/TgFj5cDH4ksvPzCjeMqACT2bXHNrueQPg==
X-Received: by 2002:a50:8754:0:b0:553:7303:96e5 with SMTP id 20-20020a508754000000b00553730396e5mr1718574edv.24.1703030689440;
        Tue, 19 Dec 2023 16:04:49 -0800 (PST)
Received: from [192.168.8.100] ([85.255.233.166])
        by smtp.gmail.com with ESMTPSA id fk7-20020a056402398700b00552d39abdc1sm4751628edb.19.2023.12.19.16.04.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Dec 2023 16:04:49 -0800 (PST)
Message-ID: <b0299ecf-ee31-4a7d-a86e-640ccf69c93a@gmail.com>
Date: Tue, 19 Dec 2023 23:59:48 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 01/20] net: page_pool: add ppiov mangling helper
Content-Language: en-US
To: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
References: <20231219210357.4029713-1-dw@davidwei.uk>
 <20231219210357.4029713-2-dw@davidwei.uk>
 <CAHS8izMQ2u9KTBz+QhnmB483OW0hmma7Vy7OgoTGajM7FyJhiA@mail.gmail.com>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izMQ2u9KTBz+QhnmB483OW0hmma7Vy7OgoTGajM7FyJhiA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/19/23 23:22, Mina Almasry wrote:
> On Tue, Dec 19, 2023 at 1:04 PM David Wei <dw@davidwei.uk> wrote:
>>
>> From: Pavel Begunkov <asml.silence@gmail.com>
>>
>> NOT FOR UPSTREAM
>>
>> The final version will depend on how ppiov looks like, but add a
>> convenience helper for now.
>>
> 
> Thanks, this patch becomes unnecessary once you pull in the latest
> version of our changes; you could use net_iov_to_netmem() added here:
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/20231218024024.3516870-9-almasrymina@google.com/
> 
> Not any kind of objection from me, just an FYI.

Right, that's predicated, and that's why there are disclaimers
saying that it depends on your paches final form, and many of
such patches will get dropped as unnecessary.

-- 
Pavel Begunkov

