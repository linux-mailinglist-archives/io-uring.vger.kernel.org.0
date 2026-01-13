Return-Path: <io-uring+bounces-11609-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DAEBFD18284
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 11:48:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3EC8630031B6
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 10:48:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D75D1369233;
	Tue, 13 Jan 2026 10:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GRXR/S1S"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6100334402D
	for <io-uring@vger.kernel.org>; Tue, 13 Jan 2026 10:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768301315; cv=none; b=gZ1nZAWowprNDrLn3cY7lCMyYY1SnV5GOI7K9/QdJIbDI6WcfL25mbkotVRSPxE5HuWZvgFv8Z6KsOPDiuGUrupczHHhMnPFh6wrtsvWN0T+VWlzPAfdqptw69CojGRjzEoz9G72QclfQTF+v+MWtxY04vH4IsB9hbh17imP2gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768301315; c=relaxed/simple;
	bh=HVWq/nMqCWEx4KqTDxex3BJqfz0Jbfe3bSlD+3srwzk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hajiKlS7P1+Kn5dOPWnb50VZGKTkJsZHU114nMtEnCY3uUMYdqot0gamDDR80fj5jhNtCYiGTqRshD9yF8vjl/oFRILV/k2nkph4svdGbEgBA/RnQR8U9XqDYITOX1P9b8JTdckaZqQlTGYKvMH4xXLH6274d3r7Uj7AV4DEJ9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GRXR/S1S; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-432dc56951eso2448406f8f.0
        for <io-uring@vger.kernel.org>; Tue, 13 Jan 2026 02:48:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768301312; x=1768906112; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JIXnem9PesbM4LOcpc3aqv8ZBT0fEVIpmQqCM7UApXg=;
        b=GRXR/S1S6o/2Ranq5ayXSyqhYVV8bg4+5JdPrIphjLLTHJFc1O2JOq2VCNapLtAJQC
         N6ew3TpIyyO0Juxx46/LTt67OuI1/+NPG1PDDhXfr4KXRCWs5VHyDH0eFMJO14Q1EJ1K
         nA/u5cGuLJJtr/IQRu4mxaqHAkiHxEMXyADjg1C0uBBWKI2C3KgQio/nU57qEgxlICp5
         x1ME/NRHAPxue8p5TkkuxhWLz3oiK+AKebPlqbFYY6SUCxgHo24GC+iLEQJT67FNUJEm
         ky1cwJd3rMdxvzzegaCRGwttKArdIByIKP9ze+XzGknlHB/zXf/+VCbUBBs7dw0PhnL5
         qDtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768301312; x=1768906112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JIXnem9PesbM4LOcpc3aqv8ZBT0fEVIpmQqCM7UApXg=;
        b=aBpwaobKsmjOk+8pN1AXXVNjN4A8rdXP7l7ggWKyl4k7vnoPoJXxLjiVLId4Z65fbs
         jStOEVnYgAEmusk+ZeRSrq6vjOaILQ1lbHu+j6fcbxqQ4n/04wC8+XniZ6jyUIjasX1+
         rQDno6Yr7ef+jHzEf/6lKj3Rinxiuq06d4prB2wOFmfqpJ6zVxIzNadZ5iNySmGPpiF7
         ALmuiwIS+oQGXC8FpTrCd6cRbKpiIXmH0Scm1a1MFrx7iXWgUjOyp5s3C/cKOAR1XxI3
         y/n9rLcpiLulxQ1xTKCjvZ6EIlEEtBMJDzQYSA4d42wyXgO+Mk2g5HULd0cgj2XsNFxz
         6IIA==
X-Forwarded-Encrypted: i=1; AJvYcCXoO9NjVwyQuAU2JS+qKGjFERCsTWpUouDqVbzUqvVJgwHh/OVvKdCD9QVtriiz1WYySihehcdzWA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwviTntxc6DBggsF/qRlbe7ejNUDALCJtTjFOPkLL/AO4LNhkLg
	CZs83E03LkNJ3+k6zDl7dalIauOnsJW/ViB9Yw1slQY/CpozuCyRW7My
X-Gm-Gg: AY/fxX6X1GyuFwbziYBSBXTGC3punRWSaZCX2Fh0/OL2BR+4gMLFmUGkvHtMKgI2k/S
	JaERoYHjHkmSKZev3QiGfD/WxG7NW2gkB8iob3JNMzBWdXMW840/WNLLunLaeBOSHRmhfQx0tYj
	m+i7EnL2gXNuXe8HEAkLoyqSyuxtmjX9UaHsCPrZHqkjM4ADskJOwDP/0iBJLJ+tqtwL6C1UGft
	MmFSzsJKTo6mPoV+nrHeagbza/iI1xhJMx+sT2e3WdxbfxwbRF1Yvv/PNAuMz2hVool+u0l5q0h
	T2BxH6I4qTQWvuiM4iY6V/l+3q4xbQ7oD09X202FQ5vAv5fmSF5B9T0Zz84UGZSiE46BJZxxbsJ
	WbQ2l7aOYUSHEUnvluGK0QXG433i0tSbHl9GYpvrNgTRoGOHngYAwszQD7TBdfCYAbD9NVO5r2J
	qOOxh0vyxD68QogsZwgCbSV8jHnkxswc55WUG4gnpqtKOEI2PGN1cbG2ZRwh3Az1P5kyuV+c2Vp
	JSFSeLcAfIP8vm4qLC+KnI6IMQJ6TPHJAviVFANGBhHQQi3vr3vSgk/04pf8WKSag==
X-Google-Smtp-Source: AGHT+IGJu2DfHIhwL2Wsz6KoyIUAUdvyVOnU75RxhvIHwpjQxcQz5RKKCJsMOQA4l3p4Bbb6eGcwyg==
X-Received: by 2002:a5d:5d81:0:b0:430:fd9f:e6e2 with SMTP id ffacd0b85a97d-432c378a9b2mr22136397f8f.9.1768301311656;
        Tue, 13 Jan 2026 02:48:31 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0dade5sm43860084f8f.9.2026.01.13.02.48.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jan 2026 02:48:30 -0800 (PST)
Message-ID: <a3b10677-a159-48dd-b45c-b78aed94f354@gmail.com>
Date: Tue, 13 Jan 2026 10:48:25 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v8 8/9] selftests: iou-zcrx: test large chunk
 sizes
To: Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Michael Chan <michael.chan@broadcom.com>,
 Pavan Chebbi <pavan.chebbi@broadcom.com>, Andrew Lunn
 <andrew+netdev@lunn.ch>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>,
 Joshua Washington <joshwash@google.com>,
 Harshitha Ramamurthy <hramamurthy@google.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Alexander Duyck <alexanderduyck@fb.com>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, Shuah Khan
 <shuah@kernel.org>, Willem de Bruijn <willemb@google.com>,
 Ankit Garg <nktgrg@google.com>, Tim Hostetler <thostet@google.com>,
 Alok Tiwari <alok.a.tiwari@oracle.com>, Ziwei Xiao <ziweixiao@google.com>,
 John Fraker <jfraker@google.com>,
 Praveen Kaligineedi <pkaligineedi@google.com>,
 Mohsin Bashir <mohsin.bashr@gmail.com>, Joe Damato <joe@dama.to>,
 Mina Almasry <almasrymina@google.com>,
 Dimitri Daskalakis <dimitri.daskalakis1@gmail.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Kuniyuki Iwashima <kuniyu@google.com>,
 Samiullah Khawaja <skhawaja@google.com>, Ahmed Zaki <ahmed.zaki@intel.com>,
 Alexander Lobakin <aleksander.lobakin@intel.com>, David Wei
 <dw@davidwei.uk>, Yue Haibing <yuehaibing@huawei.com>,
 Haiyue Wang <haiyuewa@163.com>, Jens Axboe <axboe@kernel.dk>,
 Simon Horman <horms@kernel.org>, Vishwanath Seshagiri <vishs@fb.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kselftest@vger.kernel.org, dtatulea@nvidia.com,
 io-uring@vger.kernel.org
References: <cover.1767819709.git.asml.silence@gmail.com>
 <bb51fe4e6f30b0bd2335bfc665dc3e30b8de7acb.1767819709.git.asml.silence@gmail.com>
 <6d4941fd-9807-4288-a385-28b699972637@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <6d4941fd-9807-4288-a385-28b699972637@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/13/26 10:34, Paolo Abeni wrote:
> On 1/9/26 12:28 PM, Pavel Begunkov wrote:
>> @@ -65,6 +83,8 @@ static bool cfg_oneshot;
>>   static int cfg_oneshot_recvs;
>>   static int cfg_send_size = SEND_SIZE;
>>   static struct sockaddr_in6 cfg_addr;
>> +static unsigned cfg_rx_buf_len;
> 
> Checkpatch prefers 'unsigned int' above
> 
>> @@ -132,6 +133,42 @@ def test_zcrx_rss(cfg) -> None:
>>           cmd(tx_cmd, host=cfg.remote)
>>   
>>   
>> +def test_zcrx_large_chunks(cfg) -> None:
> 
> pylint laments the lack of docstring. Perhaps explicitly silencing the
> warning?

fwiw, I left it be because all other functions in the file
have exactly the same problem.

-- 
Pavel Begunkov


