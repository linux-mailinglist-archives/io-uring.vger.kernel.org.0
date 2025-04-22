Return-Path: <io-uring+bounces-7638-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CB58A97626
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 21:52:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7238B7A7242
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 19:51:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5191729898F;
	Tue, 22 Apr 2025 19:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZFjJkvh3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905821DEFC8;
	Tue, 22 Apr 2025 19:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745351552; cv=none; b=njYdQIr1DBzkY+GsaM/PTTz34QmSRAdDL5sF/1F1y909p54WbjyaCQvmniImfqTr8mwtJBGNfNRskRCWBR142cocXgjy1MNRecbbydSujfcrtFwLrx+E5VKohCz5No72fz9NSeL/Apfd9H7Gx5UFhSWwcxC8Ig4Qcj4kxSIPqFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745351552; c=relaxed/simple;
	bh=TsKpKK9AIx4BTd1yFG2C5c7DbVWMwacOB58VibFxJvM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rDSIfjlI8W4XQYM9WVJgU2Gsph4tfmC6x9y1dI6qXqVrmGKR5QWz/RiSbFpBoJw2Fg27bLrGqOKwJb6IhNKa3DWb18F2ZY6Vjz4XbaiSVP+KnWpfaMSXG3LrCdJde6ZcjOuFxXvuAS802Hs6riwVKkn4ZeP2a23mJyUxBQlxRxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZFjJkvh3; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4394a0c65fcso61428405e9.1;
        Tue, 22 Apr 2025 12:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745351549; x=1745956349; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XaJv2nPBZFqC9cL0CpWH1eeCNJ8QkWT+UyTio/7U2Qc=;
        b=ZFjJkvh38BHdCipp9eJLyiQNkOzz52MbXV4Sj+9UR5xCQNVEYrEQcyXu9dlvsfTN5R
         5fGIes2x8vz1xw5wWnGa7TfuDt2GQb6ullNc0sL0mp0qV/N7W/RsrLizK684SlFwnE2H
         d+RgYK8f0lkj5QhW9Gw67lWKwV6xAHO56DSSFguHkSwF8eC07s33TdujZEV33+aDyOvW
         wmA1fhuLloA7v5kouwLNKbmina8ORS7BFPcAC4v8eEM+ktfH6OcqZvsQr4gx0ZyVl3Jx
         neMT0vqGOZIOF5n8XPgBdqhUC8Tb4ouk4xtjAiQaBlVcn5mKH22WQV0t/Rj4T+II903m
         tSpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745351549; x=1745956349;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XaJv2nPBZFqC9cL0CpWH1eeCNJ8QkWT+UyTio/7U2Qc=;
        b=abeiJzOtap2Rd09jh4Y2+jMxKiMrDeVMR5zwb0cygEtu17b0RhqFoRSNC1NO23aaaT
         8v6H6hnuXfhnQhY7t8INouXq7vBTxnC9doMEAQCRBiIxXCs0gpxxfR5XZL2EKe/DNljV
         /bYr5Oxa6HwLRZadGqUEkTz4MfyHul9VQVtOgfZgbFKIp9vLYbNBXE0dNfHokEYkEfdg
         y6W/82A7LV0mehJwNte0AbHRClIszSCYkkPq0UECbA38FHeIXV3e3ywDtEekVgjYTJBm
         z6YJzEonEOCGCJEnn673FpoxrN2aqjp4jlD6lVyVqooi9jzE+c48aGJPbGV+q21bSMg8
         tDzQ==
X-Forwarded-Encrypted: i=1; AJvYcCUERe/KhjSg6zw+AKH1mEygucFHSch1m71efNXt+nZFAqIwwutU/3zrqURxmvOtaAS8g4Dt@vger.kernel.org, AJvYcCVtLvU4l8SBicqo0anIPT1ZUqsB8MTkwlyKRwRkOemJ9U2rLDm0l2r64WTWIXQQRkbIxD2mk/YG6dipIsj9@vger.kernel.org, AJvYcCW4b/NRiGPnRg9smYea1BdYgd/cOgQkGcvKbgU1U0ZlEwPmjyjnar7sjHOfEyH34lJZk5P30M3O1oRv@vger.kernel.org, AJvYcCXezD2/TtrhsA+vtNMEn7JzURDHY/7/ahdmlQqRAheMUG1AsxJx26RCIXInzzYSY66UoA3BG4sDfCL9PPfjTCBs@vger.kernel.org, AJvYcCXo6SaB6zy+sWcZn50yJI3bL0TbR96bNoZKvg2TOQ2vhXQ4DJlrFuFO06eCz+cb9vXv1AUz5n+adQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx42k/vxkqa+DJD6XA2nTCJlKOJCGLy80p9QjCkdgFg/+FWXkT7
	t9UZoje5n3F1G5/EH0kdvChSqK8/8h1++A6b53deqw9Jtqxn/rb+
X-Gm-Gg: ASbGncu4qxjryBvPfyTzojRDaFM309MEcqjz8JqHRtb4fqbdPF69H7+gk6ZoIz3YJ3D
	ThXK+wZkOyJW9l9Nq/cCDq6iy65ThuRSdZ/t+TrIHpYDPSI6O1QdsBazyzaGS2u0Jonu57jk4M+
	LfuDkHhsBKrAaTLVJ5Hhf4cg6CyRtUFNjMov34lhsfbVsE6Et93IZBXDoVWcmkUSlPtRNHagQ7N
	nLYnH6qdYeGAfv1dbjrScae4MRnJ+ylaStOoDlPmVwef7rGDsfZKQToaIPRjHjpbHwW0eCuVz+6
	F9d0JCRV2GhdUe+9QZrYPHQyFrVrPrzextV2ppx+A8eWTT3n
X-Google-Smtp-Source: AGHT+IEl6pg04k8aqg4kCSPz/epA7Jsgnzijdyhk9uUD8rpuhWFSBuVeC+Gc0wxgNurOByb1LeTItQ==
X-Received: by 2002:a05:600c:1914:b0:43d:45a:8fc1 with SMTP id 5b1f17b1804b1-4406ab70701mr143149385e9.4.1745351548385;
        Tue, 22 Apr 2025 12:52:28 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.235.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4406d6e034csm183795355e9.39.2025.04.22.12.52.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Apr 2025 12:52:27 -0700 (PDT)
Message-ID: <5d2f86ce-e2bb-406a-8d53-58a464958d2d@gmail.com>
Date: Tue, 22 Apr 2025 20:53:41 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v9 1/9] netmem: add niov->type attribute to
 distinguish different net_iov types
To: Mina Almasry <almasrymina@google.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, io-uring@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
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
 <20250417231540.2780723-2-almasrymina@google.com>
 <f7a96367-1bb0-4ed2-8fbf-af7558fccc20@gmail.com>
 <CAHS8izMFxDG5E07ZdqnDH_2D_g1fW8X0M7u3gGyV8efzxDNZbg@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izMFxDG5E07ZdqnDH_2D_g1fW8X0M7u3gGyV8efzxDNZbg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/22/25 15:03, Mina Almasry wrote:
> On Tue, Apr 22, 2025 at 1:16 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 4/18/25 00:15, Mina Almasry wrote:
>>> Later patches in the series adds TX net_iovs where there is no pp
>>> associated, so we can't rely on niov->pp->mp_ops to tell what is the
>>> type of the net_iov.
>>
>> That's fine, but that needs a NULL pp check in io_uring as well,
>> specifically in io_zcrx_recv_frag().
>>
> 
> I think you mean this update in the code:
> 
> if (!niov->pp || niov->pp->mp_ops != &io_uring_pp_zc_ops ||
>      io_pp_to_ifq(niov->pp) != ifq)
> return -EFAULT;
> 
> Yes, thanks, will do.

That will work. I'm assuming that those pp-less niovs can
end up in the rx path. I think it was deemed not impossible,
right?

>> You can also move it to struct net_iov_area and check niov->owner->type
>> instead. It's a safer choice than aliasing with struct page, there is
>> no cost as you're loading ->owner anyway (e.g. for
>> net_iov_virtual_addr()), and it's better in terms of normalisation /
>> not unnecessary duplicating it, assuming we'll never have niovs of
>> different types bound to the same struct net_iov_area.
>>
> 
> Putting it in niov->owner->type is an alternative approach. I don't
> see a strong reason to go with one over the other. I'm thinking there
> will be fast code paths that want to know the type of the frag or skb> and don't need the owner, so it will be good to save loading another
> cacheline. We have more space in struct net_iov than we know what to
> do with anyway.

That's fine. I wouldn't say it's about space, we can grow net_iov
private bits beyond the pp fields in sturct page, but it's rather
about the mess from the aliasing page. The fact that it's net_iov
makes it better, but I'd rather avoid any additional aliasing
altogether.

-- 
Pavel Begunkov


