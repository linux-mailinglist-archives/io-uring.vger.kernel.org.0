Return-Path: <io-uring+bounces-7660-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 36388A987D0
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 12:48:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D06F4449D3
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 10:48:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D59C1F2BA7;
	Wed, 23 Apr 2025 10:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VgvUxBX7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90438645;
	Wed, 23 Apr 2025 10:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745405294; cv=none; b=hjBhT7cnFNcv//uaT18PFLVZG20VWFW4gUL/dRV1muOeorklZgLgeyN2mK/f02VUYM93n4+RW5RmGn5sIF3/4OOYZsgMlcxala4Q1NblgTg5ZLgE3bTlrwUDp97UfPVDRkXZs00JvyzeKRR6zdQcpaimekurLB2uOyAA6wyASv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745405294; c=relaxed/simple;
	bh=QBBn9vTmnK8rVIlRrvQjN8xkipKr+QbWyEEEv7UESDY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NyeMTHGqagBtnbYr71nF424nsVeeg4lqV9H7HWRuBdg88iaTwZn2Frbluu6X5gDXbHfgG2EVBg1OyYH963k3oo/BiJQi3G6R0D/YhrmoXRc/7RzlJv9q/obDMxyFTxXamR4ATZjLGkZxnGxsvgdI1UdgBdHCwykaoKgDCMOAXvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VgvUxBX7; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ac3b12e8518so1015933466b.0;
        Wed, 23 Apr 2025 03:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745405291; x=1746010091; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yW3Ewl9XC1g0tqlHWENmHDvEOdSUdHOSXTlz2TpUlQc=;
        b=VgvUxBX7vTM0r2bj2dFyo8yJFi+Ea5noljGABIYpREsNbCunDQj2xgK5AlOarTmyBH
         NgamrjLxq12t1ee6ure23084joLR/c4xhdR8QRUdlfBa2T70VneQo0qb56o/8tJnjGnq
         cKUb+E2+BECgtwAwleomTaCwBy1smXoYX8gAU+uQm5JpzBWadUTP7ElQHxnWgyjpIUNG
         qVIYu2wroxf/PJm7SEyBDm6y4Eh8OQ6SzSvbXYqRLPTNSUk6uhZc/4nqBiY4HpQA5Hc6
         5xzfR/yE1UokMN7zhTNnigENHECBbxAY+bG9nrtrjY1nZP2lZvFIbZpBRD30pZOrc44b
         4yPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745405291; x=1746010091;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yW3Ewl9XC1g0tqlHWENmHDvEOdSUdHOSXTlz2TpUlQc=;
        b=ti771MtiwXhNhj3eRikGjaZYmDiu2hO4uidPSYDZmQh0+T0VShHc0WVEId06DS9VVK
         FDx/6dkMNdLzKy+/1VqfPblbVIVcsEczesiFrhx+ndh1v6hQu/7YIDeqjBGWnlOFXVqy
         cezEPUBq+Ku0JmYViIZzZS4cNVVBCboecexoFJ9rtreSKrtVo78t5AtbshsF2aafknsP
         fDmZV9FdpQampSNDrjDKoDVvIfN/8a8YuwEuUPwVrICMJPD6pfgL6x/R9LbUxqVLhUtT
         xJD+Qu3BC49O6PoxXe3FULUM3v68KtkD2kmUuS/j/DlFQwmxc8BjKGmi0xjCtdPJYm4+
         xCYw==
X-Forwarded-Encrypted: i=1; AJvYcCUwXAhdrGU3mfGOGDpVFd7hEYKaWvtPyfwjCphXYcEo/ZnCxWabqsZGhnXxgZEvzG6o4k/ABx21N5CH@vger.kernel.org, AJvYcCVAEEcUi1ju5kfrqVHUYOsxnlyHzP4Tg1mPej7rX3vgZSvcSwDmFAorVND5olKOPSZ76TpZamQXSA==@vger.kernel.org, AJvYcCVYvN+tb4cuKCFUyEVbyc2ApRXWZBUsjhq+KHSRRIqdlWeZnQ8kuLncRcol5OSlr7e+BpJwRI8rgDtqXysy@vger.kernel.org, AJvYcCXjkiuFWTQlA8eu3xCBFgYiFDYBpMgMbCtklL6sRf1U6AiQ3n9FmFoilDehV5tByURQtoiGJgTGnJTpL1QVzNqn@vger.kernel.org, AJvYcCXo2yudBq+kcO17evophJZ73LPv0bc4L4axo3cbL3YRxCGQ/+hfIJJt8rSnMLHeZOcoIKf7@vger.kernel.org
X-Gm-Message-State: AOJu0Yzm5eyTPyL2uLxt5NvN9F2jYzQgWCQkl6Lb/xBZElQNZkMg5Mde
	dB+scppkH7AJnXxRGlAh+/Sw4UijPWH2lc25aOmSI2CPaL2DLYhq
X-Gm-Gg: ASbGncsFeoIaWwnetB6qbq2OQ2lM3K8wyEJBUm92rOK2G9Rwb133F0PCSd7Lj0P9BSA
	RT22wSCMdguwwiGoNvV29OMJWR3IuVungpi+i1xrz4LAC2useXqh8b8jK6zaGJvoEBXwBvSqia6
	Zc0/e+QwVeYhpV1fyb6kifUbztcuxy0pPmFOoavghYa2wzYJh5cAfF9sEVigAsT6VUYpLo8ctDF
	eG189lqt1lOt+paGfPxPio9vmg2CMHbt/K9qyqrprVNO+HL0nDzg6GfxF9DoxWkv1vQ3kIdop4J
	soK8Wxl7Yfh5C0o2NjV6+RznIQFQ4LqCT3tCg3BI/mxmC/8eKpI=
X-Google-Smtp-Source: AGHT+IGSOkms0vGWAQQk5LDkY0uQOFjlrtaq8CZWRZeiflOHa+/oqFgsKRBzQiPT5EoHF60fgvH8Mw==
X-Received: by 2002:a17:907:1c21:b0:ab7:1012:3ccb with SMTP id a640c23a62f3a-acb74b2e84cmr1451252366b.14.1745405290671;
        Wed, 23 Apr 2025 03:48:10 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.144.224])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb6ef9669csm780506166b.161.2025.04.23.03.48.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 03:48:09 -0700 (PDT)
Message-ID: <97fd3326-94d0-4d85-bb33-802ed88fcbda@gmail.com>
Date: Wed, 23 Apr 2025 11:49:23 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v9 2/9] net: add get_netmem/put_netmem support
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
 <20250417231540.2780723-3-almasrymina@google.com>
 <484ecaad-56de-4c0d-b7fa-a3337557b0bf@gmail.com>
 <CAHS8izPw9maOMqLALTLc22eOKnutyLK9azOs4FzO1pfaY8xE6g@mail.gmail.com>
 <957b74ed-f29c-4bb8-b819-af4e1168d6c1@gmail.com>
 <CAHS8izM8+zG6KOhV7ysTsCj_PEty5eL+P+uUxTZhdsOSZTwmow@mail.gmail.com>
 <c0bd45f7-0325-4e4b-b0ea-ccae24a1eabd@gmail.com>
 <8c1c6405-1e60-4512-a675-4c00b00d400a@gmail.com>
 <CAHS8izPGuF1PxfdmXUC1XJHpmRqotXh=vUY_a-AEHdAgPmLQ1g@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izPGuF1PxfdmXUC1XJHpmRqotXh=vUY_a-AEHdAgPmLQ1g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/22/25 22:10, Mina Almasry wrote:
...
>>> Instead of adding net_iov / devmem handling in generic paths affecting
>>> everyone, you could change those functions where it's get_page() are
>>> called legitimately. The niov/devmem part of get/put_netmem doesn't
>>> even have the same semantics as the page counterparts as it cannot
>>> prevent from reallocation. That might be fine, but it's not clear
>>
>> Actually, maybe it's not that exclusive to netiov, same reallocation
>> argument is true for user pages, even though they're reffed
>> separately.
>>
>> It might be fine to leave this approach, while suboptimal it should
>> be easier for you. Depends on how folks feel about the extra
>> overhead in the normal tx path.
>>
> 
> Right, I think there is only 2 ways to handle all the code paths in
> the tcp stack that hit skb_frag_ref:
> 
> 1. We go over all of them and make sure they're unreachable for unreadable skbs:
> 
> if (!skb_frags_readable()) return; // or something
> 
> 2. or, we just add net_iov support in skb_frag_ref.
> 
> This patch series does the latter, which IMO is much preferred.
> 
> FWIW I'm surprised that adding net_iov support to skb_frag_ref/unref
> is facing uncertainty. I've added net_iov support for many skb helpers
> in commit 65249feb6b3df ("net: add support for skbs with unreadable
> frags") and commit 9f6b619edf2e8 ("net: support non paged skb frags").
> skb_frag_ref/unref is just 1 helper I "missed" because it's mostly
> (but not entirely) used by the TX path.

It'd have looked completely different if you did it back then, which
is the same semantics mismatch I mentioned. For pp rx niovs it'd
have incremented the niovs ref pinning that specific niov down
and preventing reallocation (by pp), and that with no devmem specific
code sticking into generic code.
This patch adds a 3rd way to refcount a frag (after page refs and
pp_ref_count), which is why it attracted attention.

-- 
Pavel Begunkov


