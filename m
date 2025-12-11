Return-Path: <io-uring+bounces-11004-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FC88CB46C0
	for <lists+io-uring@lfdr.de>; Thu, 11 Dec 2025 02:31:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A7395300096D
	for <lists+io-uring@lfdr.de>; Thu, 11 Dec 2025 01:31:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E3922D5920;
	Thu, 11 Dec 2025 01:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IeYXdFQK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEAC52D374F
	for <io-uring@vger.kernel.org>; Thu, 11 Dec 2025 01:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765416675; cv=none; b=G9XVBS3BxFrmhQiw8ZK1J0yrS0nkehBmOACbWhOdkS9/gPkUaQICqj77FH1Rt59F/6XD046gju/W53pPvFcGpWEpv30ZWxTAxaO5otk4zoiq1e3kkkF0mmxHhNoISVq1f8RDuHnDaO/PPAyDo/JmjqZgHlxuhJwuFr88s5zN20I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765416675; c=relaxed/simple;
	bh=WTGcFCS6w7nlAaqkBZ3n6Gv7wFcX8BfAhcm/JFIe5Lk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DbNO2UGTrmlk0YU7nikYmuD7QZEN5kXDk9v1ZM8QXBD2VB9VuV+5gb6BvJiEWNBeaIkbimry9Ig2CfEAGJ8YqxyPFWjT0Yxpwjyn+MeJ/n754n/uOMICURmki0pKeZyhKOS6ZwkrQhS6oJiQhjbJJXIJo6I0ESOlJ4Q+Z4y9sO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IeYXdFQK; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7b9387df58cso639281b3a.3
        for <io-uring@vger.kernel.org>; Wed, 10 Dec 2025 17:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765416673; x=1766021473; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fZdCO/Mv9RBE0LHZ0bjkyPo+ciEfdxSfUwGGq9Yh/c0=;
        b=IeYXdFQKWk7t+QfhJqDOEqv0XEjreRqj+MI3d6Je3A12CgF4LpScw8LH8F1RG7zmUO
         JDm06TPyDoqBHiKEZoh9TGOFeAvZ9dpQC46DDNtSEY5VqcktDvLdTtZ9dFj+UNW7Js2F
         TnM61m83TBAWje3XUfVC2rABiD1Zp53TavlIFhJwson7M0/WEnLdqFBcCXpjCBNos6RA
         tsO483vypG3w1MhDgmKNYdMsnFQAbonE3ibAxD0NwV8VoSnLVZ5C9Jang1AuMhNA92r9
         2npaDjbBCEYe1fdrTg4bS5OYlCJhPTy+CoKQpuedqBpFCo5pGA94jJoXUjwUoVfoWxe+
         Zqtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765416673; x=1766021473;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fZdCO/Mv9RBE0LHZ0bjkyPo+ciEfdxSfUwGGq9Yh/c0=;
        b=JDT6IDEeQVMxil21ibSQjEjjvb3GC+VEqAafhgSB1npJAPCfKt2pj8zurtyZuXYrrx
         9w6mSY3s46fGe92ET2NcnHy73/+WHnVHEEmSTrYlAce84Fcga/OJw8MhLN91+/CLhP73
         CE6gX6J2vxyxYaysXGpuZ31rWRG/uBWQtKcYYTsS/lVH6BGiVzCBdCT+Jxa2m2DSkdM6
         EsWs/KgVokFZAYGUx6CMuoY6FuFcsPICfTnSM3ZaCdAxvQOTfTkrWuY4NsCzpVUc3CMa
         ScSjZbTTLqPIczQRYeXfwHPst7iK0wlgVsZ17HvkAhchwJaT+Z2gHQXi0dykuzDCetNT
         biSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYiYxqc019GvISiOkXCC3EhpihI8vfaDXjMfl+0RaRa4fovTcUyEUV8p9ExHWfuneV6qa+EWbOfA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyKLLzFcpzcIUu+0BGoTHLHat3uLis8Hc4SHZUc3gRDVw6C27i/
	l2Igkp5xnvYyZ0NVJMaekfEFnmR6HQMVXySYGQeHmTt+Y6DWjEps9vCf
X-Gm-Gg: ASbGncvb68BSTcX6KEbzzCPkUOK5OpcVKAl8GwD+Pw9x0587fCvKz6OQ1VcRRjiSGL+
	XEimhdPsx4k9oWKL5XkW7RSLSprpj0fapA4zRQTpo9pURSOS3mWxAl8OhFpnZyNRX3d5ey63kZw
	3osaTqA9gu7s1JiLttCkshwvQ/rWPcZ0aHOEvHeUKSjjE3fNWvRRUPoYx5q45OSvZTK8CGr1PY/
	jREDGz7++Fq7OKLrohIBoNUp1qrDbWDDSC1ScKqAdhw4FvDnqbJtUrJnpqDVo9d4Vrh5nKBFX1y
	GgBtAQBQfq7/Y8okOoe7ROxwTCUZQRNso4Jpuc83f0q4JdjZjenLngD4j8DWhF9L4HMSPlbWOBF
	vF6S8VPa+xxv8q5M3VNloXucGaQQCw/ScDz0oz9zpoCxr0O6In65NaaqMuBzF8DoGAuPaqTbZdH
	b63MZmNFg4EE477AVZvwnyxfAPWJsQdu0MP0rjkRHuAy5EDM1zPC61ZsCb4vN64Z/Rf9hI5JoD9
	wIXXzDmcfnaw5fC4GHpwNCAkEHXXAz8mwoO9GqcqBn+EbxBQ8gTseBi93PBaw==
X-Google-Smtp-Source: AGHT+IGVt+ykzKwUkvlI66EhGPLEJT0k2WcMqC7wbWNtFp2WzvnzQClEU8G0uA4bJZHHBv9Er2SFdw==
X-Received: by 2002:a05:6a20:3d25:b0:366:14b0:1a37 with SMTP id adf61e73a8af0-366e33be8e5mr4459913637.69.1765416673027;
        Wed, 10 Dec 2025 17:31:13 -0800 (PST)
Received: from [10.200.8.97] (fs98a57d9d.tkyc007.ap.nuro.jp. [152.165.125.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c0c2bfa0845sm618391a12.28.2025.12.10.17.31.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Dec 2025 17:31:12 -0800 (PST)
Message-ID: <878759ec-f630-4961-a17f-6355df26507f@gmail.com>
Date: Thu, 11 Dec 2025 01:31:09 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v7 4/9] net: let pp memory provider to specify rx
 buf len
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Jonathan Corbet <corbet@lwn.net>, Michael Chan <michael.chan@broadcom.com>,
 Pavan Chebbi <pavan.chebbi@broadcom.com>, Andrew Lunn
 <andrew+netdev@lunn.ch>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, Shuah Khan
 <shuah@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Yue Haibing <yuehaibing@huawei.com>,
 David Wei <dw@davidwei.uk>, Haiyue Wang <haiyuewa@163.com>,
 Jens Axboe <axboe@kernel.dk>, Joe Damato <jdamato@fastly.com>,
 Simon Horman <horms@kernel.org>, Vishwanath Seshagiri <vishs@fb.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
 io-uring@vger.kernel.org, dtatulea@nvidia.com
References: <cover.1764542851.git.asml.silence@gmail.com>
 <0364ec97cc65b7b7b7376b98438c2630fa2e003c.1764542851.git.asml.silence@gmail.com>
 <20251202110431.376dc793@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251202110431.376dc793@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/2/25 19:04, Jakub Kicinski wrote:
> On Sun, 30 Nov 2025 23:35:19 +0000 Pavel Begunkov wrote:
>> +enum {
>> +	/* queue restart support custom rx buffer sizes */
>> +	NDO_QUEUE_RX_BUF_SIZE		= 0x1,
> 
> If you have to respin -- let's drop the NDO from this define.
> To suggest something specific - QCFG_ is a better prefix?
> IDK why we ended up with ndo_ prefix on the queue ops..

QCFG_ sounds better indeed

> Also RX_PAGE_SIZE is a better name for the fields? RX_BUF_SIZE
> is easy to confuse with RX_BUF_LEN which we are no longer trying
> to modify.

It's not "page" because there are no struct page's, and those are
just buffers. Maybe it's also some net/driver specific term?
I don't get the difference here b/w "size" and "len" either, but
in any case I don't really have any real opinion about the name,
and it can always be changed later.

-- 
Pavel Begunkov


