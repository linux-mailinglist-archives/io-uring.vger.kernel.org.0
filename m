Return-Path: <io-uring+bounces-10879-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 41B32C9BD4C
	for <lists+io-uring@lfdr.de>; Tue, 02 Dec 2025 15:44:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA07A3A7AE7
	for <lists+io-uring@lfdr.de>; Tue,  2 Dec 2025 14:44:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 906D1238D52;
	Tue,  2 Dec 2025 14:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DvLpU6P1";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="LYDfZlca"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63B321CC71
	for <io-uring@vger.kernel.org>; Tue,  2 Dec 2025 14:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764686654; cv=none; b=YGYLwHpkhT/BjYlZKVdYHT1+c1kXCeKMNcjTQL4EuyzdTP2dFRXCRu+tcz7qK2AedyRS85a7DNcD9oSOegDl7qWMJZ+jyyr350KL7zRunsMDPokUDdqoWnUNKIHehny1aa3dlgtvQG9M2cCyMg4Z1Ui3TYBQ8+AXXB8XH/dvW3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764686654; c=relaxed/simple;
	bh=NZj4/NW55RYoRrLPZhkJUjtKoD9IgR8bd7QKEau5f4w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bAoUmYD6+NOCEeZmG/RePTTAIGrQflRXcFChCV3acE0oil7mWj8R7FKvzlfqkQq9b9D2lyDmnBHQYCLgm/nEnlFRna5phqO6GsiYEX56Cb538m4Fj3ZKSkG9FLRqiLO8F1i1V6u+oqSs+fzEBBHB2Q5O36ao4IWfqTUxFK537Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DvLpU6P1; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=LYDfZlca; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764686651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mjNiAor2TkYqFzHs2B3P/P9B9Xp/a4exT6Ioq6XTaKs=;
	b=DvLpU6P1nB2YqddbZfs2RpJvChucfKB5cwlOp/PtSX1mZ0BiEAWT2oe6E51UYseTQZI8ds
	MXfwrqCHYnLVwi+EdjfwGeWMTXWIILvHHOyPUKq0YY8nrV+KrTGka97riJYhCkhS2effnD
	IATPjEfOz6WKvGD32RqS3q9UHonLGpE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-489-a6H7FgdJO1ewkmbecbitZA-1; Tue, 02 Dec 2025 09:44:10 -0500
X-MC-Unique: a6H7FgdJO1ewkmbecbitZA-1
X-Mimecast-MFC-AGG-ID: a6H7FgdJO1ewkmbecbitZA_1764686649
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47904cdb9bbso53277545e9.1
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 06:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764686649; x=1765291449; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mjNiAor2TkYqFzHs2B3P/P9B9Xp/a4exT6Ioq6XTaKs=;
        b=LYDfZlca5UbF4aaOnf0jOqD4gg9ZQkqctRFArK/5FouFONoeAo94rbHM1t/OU2KwY+
         hycZiTPSTurfPFte4blWcmr/f+kZy1z3SKrxrO17YnGeCJebx+Vem03AA+Vh5RlNoJze
         WU1sqqQUX4lH4Ohexgr2nYhWCEznqHj21dk+RrNUhGy/ou5Y1zXJVOvw9XRwdminCHfn
         CoeFHkSpVpahVaFfyR0g//mTg4ztJ39XLUVP9Pvv4d4OBKQm35kQgkHHlwFzowdRE2TU
         xwIguekhSVyyqLtJic+Sp5CI631PEDcIFsdO9tzkTpQHohXMkUgc3zD1rGhK2H3Lmofe
         U4DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764686649; x=1765291449;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mjNiAor2TkYqFzHs2B3P/P9B9Xp/a4exT6Ioq6XTaKs=;
        b=YXgRzhxD+O44hzdLTOvrGzc41scc9j2StBjfCWlMJU621ZAmKVkNjfIFDmAtle0JSK
         aY6eceT9vXC7s3HkidnXx3jb2rtGyiNYHde1Jci0M2X5dPEo4b9PEYz8HDCEXSEuJgb5
         ieX0JCHCy0dOxZu3mtmxKlwX+dqHIpAx2VvFFD0Ql3iu8J7OX6JZBz+XrzsX3CXrlzR1
         8JME8pm6yDjL6IYfgHttIwUA1pNOB0pVeINTCsUvqCbVCY2hEnJYd3j1EWDexkFNoI8L
         snxjlbIlbvZLcnEGetqsKaUxto8F+WqKM11dJfTmwUXcfFybmRm78xaMjmQDOQffsIO0
         IxMA==
X-Forwarded-Encrypted: i=1; AJvYcCUi1Uyp8lCdAslaBeZ/PSvWmDesUa5wYyNMw4tKgJav2ov0NbQRilHmL8kOmhKvzxqIeJlLzSWnnw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzxnf8jyqoQ4w231SAkqCmVtnleY8jTIaGxD+OdUtdeH3jsUQIf
	yuVxRq7o6gNCNCEBV5BJqF32byzAsVr8cf078t2zOa8T+OjGqibC3ORntJxUYWZUu0PtaeUoKb2
	twgrKd2fwArjqKmZpnelLOcacgM5J5+557OVQVkPUWV8l+bpjZxiWt6k4eOrb
X-Gm-Gg: ASbGncvei7pZ9NqJJkcC1SklOZ85zOEwvYAWFUZBAKJEfmfz7FV4NPO7Wq3Jw7PNuU+
	XnRbdUgW0i2LutIRNZYm/HsCOd+anO+OY2WmqKm0o+98W+V9r4pUs1e9CHta7S15qi2zyajln76
	zfZKtW01l9Arv4+KmLZARXpXaBXTxVMvD446SOaKwpuS/fVJqRjyU+CEWnF2D2TIK7STvUogeAe
	O2o3Hk1ksMX/TEzlz2O1ZuC93By2eONVsTHINwK8VUWDQvAJXLxPwGedLhpigGo6353XqeqmZTU
	eaa4zewbvs+15sXiLbzfGvlxLq875uFDcpwcowTObv7Q1w55AmZD0Y9t0h7r6/cfPSFfW7U/fQb
	VJ79twOommjCwhQ==
X-Received: by 2002:a05:600c:190b:b0:46e:2815:8568 with SMTP id 5b1f17b1804b1-47926f99134mr29820265e9.10.1764686649419;
        Tue, 02 Dec 2025 06:44:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG1rSpvcyj7MIWwm/bcqJ3Gqt/h4Kwl1pmES70ih45QAJCy1rFgmux40sFPF3KzuExq8RZOQg==
X-Received: by 2002:a05:600c:190b:b0:46e:2815:8568 with SMTP id 5b1f17b1804b1-47926f99134mr29819585e9.10.1764686648788;
        Tue, 02 Dec 2025 06:44:08 -0800 (PST)
Received: from [192.168.88.32] ([212.105.155.136])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4790b0c3a1dsm380823035e9.10.2025.12.02.06.44.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Dec 2025 06:44:08 -0800 (PST)
Message-ID: <743e8c49-8683-46b7-8a8f-38b5ec36906a@redhat.com>
Date: Tue, 2 Dec 2025 15:44:06 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v7 0/9] Add support for providers with large rx
 buffer
To: Pavel Begunkov <asml.silence@gmail.com>, netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
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
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <cover.1764542851.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/1/25 12:35 AM, Pavel Begunkov wrote:
> Note: it's net/ only bits and doesn't include changes, which shoulf be
> merged separately and are posted separately. The full branch for
> convenience is at [1], and the patch is here:
> 
> https://lore.kernel.org/io-uring/7486ab32e99be1f614b3ef8d0e9bc77015b173f7.1764265323.git.asml.silence@gmail.com
> 
> Many modern NICs support configurable receive buffer lengths, and zcrx and
> memory providers can use buffers larger than 4K/PAGE_SIZE on x86 to improve
> performance. When paired with hw-gro larger rx buffer sizes can drastically
> reduce the number of buffers traversing the stack and save a lot of processing
> time. It also allows to give to users larger contiguous chunks of data. The
> idea was first floated around by Saeed during netdev conf 2024 and was
> asked about by a few folks.
> 
> Single stream benchmarks showed up to ~30% CPU util improvement.
> E.g. comparison for 4K vs 32K buffers using a 200Gbit NIC:
> 
> packets=23987040 (MB=2745098), rps=199559 (MB/s=22837)
> CPU    %usr   %nice    %sys %iowait    %irq   %soft   %idle
>   0    1.53    0.00   27.78    2.72    1.31   66.45    0.22
> packets=24078368 (MB=2755550), rps=200319 (MB/s=22924)
> CPU    %usr   %nice    %sys %iowait    %irq   %soft   %idle
>   0    0.69    0.00    8.26   31.65    1.83   57.00    0.57
> 
> This series adds net infrastructure for memory providers configuring
> the size and implements it for bnxt. It's an opt-in feature for drivers,
> they should advertise support for the parameter in the qops and must check
> if the hardware supports the given size. It's limited to memory providers
> as it drastically simplifies implementation. It doesn't affect the fast
> path zcrx uAPI, and the sizes is defined in zcrx terms, which allows it
> to be flexible and adjusted in the future, see Patch 8 for details.
> 
> A liburing example can be found at [2]
> 
> full branch:
> [1] https://github.com/isilence/linux.git zcrx/large-buffers-v7
> Liburing example:
> [2] https://github.com/isilence/liburing.git zcrx/rx-buf-len

Dump question, hoping someone could answer in a very short time...

Differently from previous revisions, this is not a PR, just a plain
patch series - that in turn may cause duplicate commits when applied on
different trees.

Is the above intentional? why?

Thanks,

Paolo


