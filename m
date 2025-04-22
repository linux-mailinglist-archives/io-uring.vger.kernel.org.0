Return-Path: <io-uring+bounces-7605-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 673BBA96309
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 10:55:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 914453B5EFF
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 08:49:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A902625EF96;
	Tue, 22 Apr 2025 08:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JoNMZ1/g"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01E225E806;
	Tue, 22 Apr 2025 08:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745311432; cv=none; b=t/a/gMpN6s2P1GBqTs24228QdfApwU2qFU6+d/PcFidoGAsX8UM220HjWVL/4bKrwxIEAYGwNvqXPtVd3/Xk6g5vEM4eIcsMKJrmOhZ6MLm+4yOMwIPvZsxTAKlAo8wL02te1Tmu5+Dj9FXyGSF1IS017ojXhqJXNWQIKPjxk/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745311432; c=relaxed/simple;
	bh=lqD7m89r2sQrsEOmBfAzRt8RKN827E6V2hOjWrQC4mY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lS4SUd4wqfue1F6+zrJ7DJXNYSbWCcggKJatgVlD/s8Y8R6fyPEMkNd29d+yLhIKihfNH5VBAOsYKnZ9YHN8UndOENlqCn5jJZnVuvU2Wgz3pviQiLlFpLh+C1rgOToN08sKJOkF7fSyX0wvLZtP2NZLebL2DTeFpv8c/ZUsRaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JoNMZ1/g; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5e8be1bdb7bso7483682a12.0;
        Tue, 22 Apr 2025 01:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745311429; x=1745916229; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=03SE0QEScorD8X63ZKpeNL8JKETFXurDVO26PPtrnKM=;
        b=JoNMZ1/gyxMannbt9i/1J5HgS+tzX6kFPLD2sL5PYwbHo3yIPeqp5LBG6Y9YiZbNEU
         jb1RjSnjeCI2L70B16dp2zcgF9+uifk94Q9I+a5ltkqiWr66/n6y/ygqLMzvwPOzSdzr
         pEo8aYtmSlaHG4oTi8RGB6jXrpU5WFo5y70SJ5/0K3zt9BmHvNH3qgGWdldRbitMF72A
         Wo4YrAVMe+I8e7uz5YBdO6kLXJQbVd0Ch3pnoDyKV0WHDVfQnEPKEgRLrxEC11uJ/Qlt
         NiG8obCWAt5o+mhExOrKPXppbGqFwWHsm82XyJsE6w2X8wKQkpQXk/kSmVqv9GLVsIFB
         rEvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745311429; x=1745916229;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=03SE0QEScorD8X63ZKpeNL8JKETFXurDVO26PPtrnKM=;
        b=VT7arvIDRfkpfquvs5JisdzgIBGVu1yu3iii6c7T7my9RMzVYEIkGz2BMQiE6Wskon
         vs7XBZ6h7x0d9iJVY6lxAVAiX8ZRw3XZO4jB/NTQMNCzIogoMapWYOblkwrz1mQgi0Q6
         oyYZeeXnHb290iVzgfSoiLf+YLvNCojKS0ccHhgbcaIqaZStecVe0RNc8ykJBP1wzv0Y
         mKAA/ridEiN7lGw+WmtxDf6SHUSpJI/JY9UulRo0On1VgUHZaHZEyUy9hgLkS/aB1zBE
         Dfc3AWKyQAbqgQ5fnphbw/NoHO80Ky9SAJdzaK60VvSRVH8tmnDS82lW5Gpwdjk8kSlP
         9/4A==
X-Forwarded-Encrypted: i=1; AJvYcCUsQccODKIh6v81KYPAo8qCQAswkDnkbzFg5oOSRaVREzbTb4OJenc0img0Y3gVz2hP68edN4Rt@vger.kernel.org, AJvYcCVGyOfJGNaKImMFHUByDvcxvvxUK88N4cDLcx34I8aS+mFcKt+Terd7cVBf0d5/UQegrMkeQ4i+B0Uz@vger.kernel.org, AJvYcCW6fuFzWHhsfK0LtXIo8V3NUkvM675eG+BneXg+sEr5PMRvxHSEeZL5NiYlYxf1zcL5lkrv4r1XEA==@vger.kernel.org, AJvYcCWFr6zCvy+X0dwcTSWOxe8nKgh6iknO8rOauaRS9PmcMU2ZW+at7gNEYGvKkPmf5qR3tkYDdCqYIh2vvCbJCJOh@vger.kernel.org, AJvYcCWuX1tIyLmm8WC8WH/EedAnhFUGckwP3h50F3/B8NPovpH2yEMO+3UeL1bv29w4h/4V4Z1n@vger.kernel.org, AJvYcCX7H4ZZcsZ1DgwCJFknaFPXVOj2wWErha/hYHvnD1CQx8yYu7IlrkVYnmPFp9nY6swymRikZfnYgBIGMQfe@vger.kernel.org
X-Gm-Message-State: AOJu0YwChA7nRNMqYUmZ/d8UsxnwsT74ykiUv+pgWFT/dVY2jXlXzO07
	rPuGZb97KwgDz084HOmWdNUxQAd7kCNDZDGdEATlqd5QdNucDn3B
X-Gm-Gg: ASbGncs6fiXetxak4xhs/qqU3vDfUqmphGQikL479W1KSU5jBrdH1ePn/EyVCWtcWal
	eIiZlWYCdEoS50ujMPAMO9rmG8yM/syKX5aTo0vjKnnKsJzneAk5AZevNkT9Jzlk7fh38M3wI1j
	ZJPBJ2N81Fwp2VuknMbUB6DKSnYxJ/ljiDb0mBUWxDm33vzewxdwdVQG2Qr/XJnn4Pfd2IkR6N0
	ZpRWwKxCy/n/Nq21HWCdJZmR1ASSI1uU2/JqGqU8Kh3pWCOgflvWqrqwBuEYqrTOtGdW7K9+uws
	cWEEsBl1OMuwZSbgNGbmECLdL4SW1ayhUANaA0Y/AOWpSy/zTBT6v/37KqboHy9G
X-Google-Smtp-Source: AGHT+IHwRLxRlfj/B+cZPJBkcYi+NC7m90ZU8vBSpXmplNdykziG156hWUX5aB76mCTOP3JqMinJQg==
X-Received: by 2002:a17:906:ef05:b0:aca:db46:8170 with SMTP id a640c23a62f3a-acb74e79d11mr1252517166b.60.1745311429050;
        Tue, 22 Apr 2025 01:43:49 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::158? ([2620:10d:c092:600::1:558d])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb6ec42af6sm623375166b.43.2025.04.22.01.43.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Apr 2025 01:43:48 -0700 (PDT)
Message-ID: <484ecaad-56de-4c0d-b7fa-a3337557b0bf@gmail.com>
Date: Tue, 22 Apr 2025 09:45:04 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v9 2/9] net: add get_netmem/put_netmem support
To: Mina Almasry <almasrymina@google.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 io-uring@vger.kernel.org, virtualization@lists.linux.dev,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Donald Hunter <donald.hunter@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
 Andrew Lunn <andrew+netdev@lunn.ch>, Jeroen de Borst <jeroendb@google.com>,
 Harshitha Ramamurthy <hramamurthy@google.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn
 <willemb@google.com>, Jens Axboe <axboe@kernel.dk>,
 David Ahern <dsahern@kernel.org>, Neal Cardwell <ncardwell@google.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>,
 sdf@fomichev.me, dw@davidwei.uk, Jamal Hadi Salim <jhs@mojatatu.com>,
 Victor Nogueira <victor@mojatatu.com>, Pedro Tammela
 <pctammela@mojatatu.com>, Samiullah Khawaja <skhawaja@google.com>
References: <20250417231540.2780723-1-almasrymina@google.com>
 <20250417231540.2780723-3-almasrymina@google.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250417231540.2780723-3-almasrymina@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/18/25 00:15, Mina Almasry wrote:
> Currently net_iovs support only pp ref counts, and do not support a
> page ref equivalent.

Makes me wonder why it's needed. In theory, nobody should ever be
taking page references without going through struct ubuf_info
handling first, all in kernel users of these pages should always
be paired with ubuf_info, as it's user memory, it's not stable,
and without ubuf_info the user is allowed to overwrite it.

Maybe there are some gray area cases like packet inspection or
tracing? However in this case, after the ubuf_info is dropped, the
user can overwrite the memory with its secrets. Definitely iffy
in security terms.

-- 
Pavel Begunkov


