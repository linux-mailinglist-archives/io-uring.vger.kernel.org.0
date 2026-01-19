Return-Path: <io-uring+bounces-11810-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9519ED3AAD2
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 14:54:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id F0E673008983
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 13:54:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD86A36CE0C;
	Mon, 19 Jan 2026 13:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OYiIrJRs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4A736D50B
	for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 13:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768830881; cv=none; b=JyJEoWYtaS3JBop43nDIrrFBsm+tiLM/Ux7SEhKgtG6U6N0EYPTj9Tn74lx6O51EaDc0PnoGkppB6x7SV8ArMv/EHaJ0UNBhFxmDVnAY7Eew1S8K9mLv7bS4jS1RSDL+YJ+Nt7UvBYotsiQrAnnXdFpuVcKlbh596o2DHdXHvjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768830881; c=relaxed/simple;
	bh=lo81BFx/Ulv0xcaPTgRdmV6KO1F84bHVc1SQVycS4S4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B8TJ/9s6BX/uyKGq4jOvEPoxeut9Lgiy2ljUEDbaz6VBAuJfAYH97E4LhhgFrX4ixnLyKXozkGm4Xb4OvF9gB1IFCyiIgtn5JDcBM28f5tJqog0Oe3JhDfRCLSBD8r8z7tikvJ3MmktW1oXDFCKul3wehDTIDUr0Ey6C5Yfgn74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OYiIrJRs; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-430f3ef2d37so3367826f8f.3
        for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 05:54:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768830878; x=1769435678; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MPy6cjzmHwuoEQvvRHEOfQ3zwGp51DN3ulInpeNRzkQ=;
        b=OYiIrJRseciC2w1wnZYx/HQx+/0wX9AA+uU2X5/x12E/i8fcD9BBGk2WIj8Vzl3nQ2
         heoHllWVgyETGz3o9UJgZUj2iw1g5A5wmNYoC6B6US3c9/XQGop6MP/TI4iL4MetxhRY
         Kgm5v0Ns51mj3FsZElRH0eS5inpYEalQgzOnzZJg34NDzxt6sEx55JnBLY9QqwL0TAZM
         yKR9AQMFWpTfpCIbn+BPlWKV+6IlkWqzjZnim0bEJWKxZhSFiE9zCJqz4FO0cu+JXDSh
         KRlwuTmdMrX0dyEWK65U+OJAyPp+Pq2QXSV3yn85P+XNHgTTnyyXX46U0HrzUcZZQLQD
         EG4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768830878; x=1769435678;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MPy6cjzmHwuoEQvvRHEOfQ3zwGp51DN3ulInpeNRzkQ=;
        b=P/DM5A5htzP4MFKvqC9LJ9/AwrzZL3WpKc1yyyUzyr0HzBJEyA5LupHeFKCcXn/lif
         TVB/owR1Lopru7xTfh4xQ5yn8FFUxraX/65AAJ40kJE1P2u+KkAxACR0hUg4vaAM/myL
         /ledD+qHYwh1e/nQpU/jkd15A+VYw9hQgbof4X/aL2gx63Lmr8oIsXlVgEpe209iUTQW
         hTIls0R4eND5jkBecOoYNENBn/yPjvCjxINoCg1WA8ymklNPnng+tD4KvSHQBmpmG4bH
         qMiP4E7E8c+86SqEkrQ1YNKbSDqVHUGAHe+Yp+Ooy3xEu8e0/DMCIfKb7xM0bM4rFGqi
         bA8Q==
X-Forwarded-Encrypted: i=1; AJvYcCU8kcI0vrAo3H+su+ztd90f/5RehSUztSc+QbT5kxN9bcnxixMGKjPo1UQPaP9XTxtkaBunGT7v8w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzS4hOIrGduHJtvcDvgkxQYILLTDETpdmIpACC+A/XfNa3bxV0X
	3h+TF83rw1u/WgHIDptoGJlmR5GRx1M/IYgkiC6xMcdcC6pqlPJxypkg
X-Gm-Gg: AZuq6aKO/83E33w7t0rfr69y3VnkRs7iMynQindIgetLY2tQqaYDL7kq5BvN/bt6wXC
	9M8xMC63vq3iBhrOPxiRO08Qw5rtwNF5lTQM4hL7lEstXIdqUUBOOoK8Q1H7UMfmFpz3oHHA5ns
	ORKOyXuzejoUiF27Jg0nvW5i0EmXfn0cYr4rM5hXF6ajEukyj5c5vH7JOG93tkyq5sdgX2gqHCs
	Fzt1mC7bL32QQ5u5oodqmAEx23ntbP4242EiYnxKL3kdpn3mYb02AiGbJPtOYRTLzzlWik2DyW4
	oMd6vdtLoedXLj5NezzODNbv50xiWKP4M8Qcb7x0mVSh6mc4nFVOVZ6Tc/ciC6y4hsA+Eam5J0Q
	C6H9r095aZxXCLk6HFjWbYnZvABnjiYTvejgtd0U1yqkMp5CXUzcUJIGQplxOLUUNQnmm6PazpX
	+nYDfhmxsu1dmB0+TAnw8+AfuJM+UAVHy73pIOwUND3p2o+rSBKzrVsAmWRalAd+RMpUdK2fV2k
	WaPzm/VMk7oFTVoA5JXaNUX+o9koxHn35uesDWCVt5oLjqHDg1P6g1U/MX/QKGy
X-Received: by 2002:a05:6000:3110:b0:431:48f:f78f with SMTP id ffacd0b85a97d-4356996f2f0mr12962136f8f.1.1768830877534;
        Mon, 19 Jan 2026 05:54:37 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43569921f6esm22810483f8f.4.2026.01.19.05.54.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jan 2026 05:54:36 -0800 (PST)
Message-ID: <7ab5309d-8654-4fa8-9a1e-24b948bccba2@gmail.com>
Date: Mon, 19 Jan 2026 13:54:37 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v9 0/9] Add support for providers with large rx
 buffer
To: netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Michael Chan <michael.chan@broadcom.com>,
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
 Samiullah Khawaja <skhawaja@google.com>,
 Alexander Lobakin <aleksander.lobakin@intel.com>, David Wei
 <dw@davidwei.uk>, Yue Haibing <yuehaibing@huawei.com>,
 Haiyue Wang <haiyuewa@163.com>, Jens Axboe <axboe@kernel.dk>,
 Simon Horman <horms@kernel.org>, Vishwanath Seshagiri <vishs@fb.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kselftest@vger.kernel.org, dtatulea@nvidia.com, kernel-team@meta.com,
 io-uring@vger.kernel.org
References: <cover.1768493907.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1768493907.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/26 17:11, Pavel Begunkov wrote:
> Note: it's net/ only bits and doesn't include changes, which shoulf be
> merged separately and are posted separately. The full branch for
> convenience is at [1], and the patch is here:

Looks like patchwork says the patches don't apply, but the branch
still merges well. Alternatively, I can rebase on top of net-next
and likely delay the final io_uring commit to one release after.

-- 
Pavel Begunkov


