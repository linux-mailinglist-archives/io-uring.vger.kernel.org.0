Return-Path: <io-uring+bounces-7637-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 76CC5A975D9
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 21:46:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90D423BBA46
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 19:45:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CB00291140;
	Tue, 22 Apr 2025 19:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MMhuhZIV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBC3285414;
	Tue, 22 Apr 2025 19:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745351160; cv=none; b=u+0qiwugFTagKorr5CTwfwfM3Ht2B9Z1bLeQ9fT/W9gnKqOnZENFQlzj/uQVQw00dgWy1nCtbvh1B4Ts4daDU0cRbuyV7WWbn882/VaLCWqy8NVEYHM2htdd1YiMg/iHhgRnbuWi7O/o+wD3+1BoqS5Vn3441qXI3qu8ZFMcApU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745351160; c=relaxed/simple;
	bh=TuxclNuUfqcerA2pqrf6VxwnTOX21UT3Y4oqusyj6hQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UBtuh+QTzY+8FwhUm7+Nr3cHMoOtbTwPem6hPfv6uIgOHHPJHorfSQ8wg57aVdQIcMUI6Bc2nZw7GOllNUtPCDlehP94lk6D49L7wdzqW4/4QRZ6tHCI5coHjlk6hK3fqmbauh0s8hzi8KhSnTkn+SVmTE0+7nlqZirtVyDtKQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MMhuhZIV; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43cf0d787eeso65630055e9.3;
        Tue, 22 Apr 2025 12:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745351157; x=1745955957; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ot+UV56+ds2L+x6seBu3bJVACsN/bCDZpbfhgi6yxHM=;
        b=MMhuhZIVXQtJf+/q80ZnTPTsXLT8PeKiTBFtl1XyPRvTfIY8PVlcOMls/9RELVfmhz
         aOzyomGIeHXhtKPTzS0CDn+a2qGlOVBXDCz1iuZJI3FXMvx12FO8twchWqZHh1Hopz8H
         nFNpVO95i4xDvyl6Ub0k4yQ5UdqvyH0MgllQ27mNkFZmzK6/4n17UE6AFVzUnSFhHcsK
         9zxa17ztuEh8hdz2hFRwAxux0BX3qmQxLAklktvWgkOmd2cwPQ1Z+02rm59AYsz2Ok5x
         qFMHv09r2mYzJzYLJeIUr29QgWB7DpfRfUIyak06TSs9pMWdWPNradDJlu0xKihQ6G36
         zbAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745351157; x=1745955957;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ot+UV56+ds2L+x6seBu3bJVACsN/bCDZpbfhgi6yxHM=;
        b=bguDJeOayp01U8zPgS8oot9lo514opUdeDFUljb6w+Ty0bJ1yl9EFePcZJKmlSkYfT
         ynVwwIxNjYKOvylcogRjdutz5RoEKUFkDgJxrpoywj+Ppbhcc7vY/7z38VelRkaA3sUr
         tgUbmfWkYg3fVBNaQk58OYmt3tcQGpq3XRvxND5btTbUaiTR2FVbUHv4yvsSzu8PjbJA
         uqGF2/y/dOrYiHVjQF88Ri4u38SLYtSK+sECNZp3T4qJUOetJ0P32KiKTesVSC2V8tWR
         RuXyV1wGxgUPRf34wxeHlBLbZo3PtyG7LnAup9Wt5jM8bFbp59SjTdy/etD1FrYOj85o
         UIlg==
X-Forwarded-Encrypted: i=1; AJvYcCU36O4I+2Wtl80JiZMM4+Il7kATtkDd3VdzleYBS/FTyTgfAg5qAjx9yDhi80fRGstuFOCi1o9q6iLg82aMm23F@vger.kernel.org, AJvYcCUCWI2aofKRsWMdhBtJNICF6sGk1vULOTPBxcurpxbAQQ8OjIk7cd7wQ2IGP0vd5no0kzDXCAevNWMA@vger.kernel.org, AJvYcCUGmfarGBqLihLCSBN0pKi+8n1JB1bPJXYZe0RggIE8fFNwnTCnkZ0zXsi2olI2riVoVuyRpKzl9PVg3p7n@vger.kernel.org, AJvYcCVPy7MX+mJgrdrLJLoQi7A/0bx1dQtL0da4bwzQjjsLNpqjzrclcQMuoFS/Z2JlB5aFKCSkWXCE3A==@vger.kernel.org, AJvYcCWlrz2w1T0bVpSfIRjZahYv23xGgb5rB1NL4s/RfttgxPNymBsRteiDgRecHRQEikzpSF+M@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/aguU6CvXO2yJYtUy8eEi2ByUM05rVd+54p96c6zrKgQ9antd
	m2LV9Y3NYkGNCdCcTksDH7ho1RCz9uTSq0P1rrm4qd2W9neL3JbW
X-Gm-Gg: ASbGnctiiOkpYimr2YQ0u5Lq3gO6uuDXarbleoy/H5p/uHIM+4KbSbODyUYa2XuCJSF
	Rkql9qzt4ERs6ZLOvAj0jCx9ATNxgdQcIPpdSLa7ACm1YB/pbFUAChvjhCN4OHOEk2X2p6PXzlF
	YP53kBrutGiHDjBNcOfFEgkqILO/35R24OxoHHwxIFYS5BkgHKIi4HopxkGgIsNXlH5OXFwqbxI
	D6Fu0AnlIoD16A/eSvgvJjx61yplwo1wlWtszHo1L4ziPfwfQRoA79cR22xRtrbsT5kgzfzhBSL
	sZzrBNcVIIl6Ww0RP+9q5uq+FrhHqAtsXfYpdOlA9r9pcU4G
X-Google-Smtp-Source: AGHT+IEZ6mFfkFKJXYFnWv0R6K2e+269K01WRtESaCqbhsKRKAntvkXBD22q88SDEn1QFhrdMRwIdA==
X-Received: by 2002:a05:6000:1888:b0:390:f358:85db with SMTP id ffacd0b85a97d-39efba5edf2mr13171386f8f.30.1745351156437;
        Tue, 22 Apr 2025 12:45:56 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.235.90])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa4331a9sm16481640f8f.36.2025.04.22.12.45.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Apr 2025 12:45:55 -0700 (PDT)
Message-ID: <c0bd45f7-0325-4e4b-b0ea-ccae24a1eabd@gmail.com>
Date: Tue, 22 Apr 2025 20:47:09 +0100
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izM8+zG6KOhV7ysTsCj_PEty5eL+P+uUxTZhdsOSZTwmow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/22/25 19:30, Mina Almasry wrote:
> On Tue, Apr 22, 2025 at 11:19 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 4/22/25 14:56, Mina Almasry wrote:
>>> On Tue, Apr 22, 2025 at 1:43 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>
>>>> On 4/18/25 00:15, Mina Almasry wrote:
>>>>> Currently net_iovs support only pp ref counts, and do not support a
>>>>> page ref equivalent.
>>>>
>>>> Makes me wonder why it's needed. In theory, nobody should ever be
>>>> taking page references without going through struct ubuf_info
>>>> handling first, all in kernel users of these pages should always
>>>> be paired with ubuf_info, as it's user memory, it's not stable,
>>>> and without ubuf_info the user is allowed to overwrite it.
>>>>
>>>
>>> The concern about the stability of the from-userspace data is already
>>> called out in the MSG_ZEROCOPY documentation that we're piggybacking
>>> devmem TX onto:
>>
>> Sure, I didn't object that. There is no problem as long as the
>> ubuf_info semantics is followed, which by extension mean that
>> any ref manipulation should already be gated on ubuf_info, and
>> there should be no need in changing generic paths.
>>
> 
> I'm sorry I'm not following. skb_frag_ref is how the net stack obtains
> references on an skb_frag, regardless on whether the frag is a
> MSG_ZEROCOPY one with ubuf info, or a regular tx frag without a
> ubuf_info, or even an io_uring frag which I think have the

Yep

> msg->ubuf_info like we discussed previously. I don't see the net stack
> in the current code special casing how it obtains refs on frags, and I
> don't see the need to add special casing. Can you elaborate in more

You'll be special casing it either way, it's probably unavoidable,
just here it is in put/get_netmem.

> detail what is the gating you expect, and why? Are you asking that I
> check the skb has a ubuf_info before allowing to grab the reference on
> the dmabuf binding? Or something else?

get_page() already shouldn't be a valid operation for ubuf backed frags
apart from few cases where frags are copied/moved together with ubuf.
The frags are essentially bundled with ubuf and shouldn't exist without
it, because otherwise user can overwrite memory with all the following
nastiness. If there are some spots violating that, I'd rather say they
should be addressed.

Instead of adding net_iov / devmem handling in generic paths affecting
everyone, you could change those functions where it's get_page() are
called legitimately. The niov/devmem part of get/put_netmem doesn't
even have the same semantics as the page counterparts as it cannot
prevent from reallocation. That might be fine, but it's not clear
why keep them together where they can't even follow the same behaviour.

Interestingly, you can even replace per frag referencing with taking
one ref per ubuf_info and putting it in the ubuf release callback,
in a way similar to how SKBFL_MANAGED_FRAG_REFS works.

FWIW, I do like the idea of get/put_netmem, it's nice to be able to
easily list all callers, but maybe it should just warn on net_iovs.

-- 
Pavel Begunkov


