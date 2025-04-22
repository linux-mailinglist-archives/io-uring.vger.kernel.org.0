Return-Path: <io-uring+bounces-7639-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECFC3A97673
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 22:03:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3A763B4155
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 20:03:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F0B2298CC5;
	Tue, 22 Apr 2025 20:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kdQudz1p"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A35D1D63C2;
	Tue, 22 Apr 2025 20:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745352211; cv=none; b=OHFujGanj7vNY68PKaic31KMPjy7yHiqaXp34HSOQLFw8JvdYfH3kehFO8pleFlQUPXQPRcxBr1LJYJa81MgBpC8LlkGylS0OoPHK9OGHQDiq8Hx9FmuaLWg999xyBI5KuCXSje+M0IUI24o1BGpI3MebUOLDz7FmdaSiAEq1jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745352211; c=relaxed/simple;
	bh=flx1X1PjzPEns4chd4qdAsjn7Uq40UIGYu9K3jmqWtc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=kAzP34Jo0+NIaZw/qfyDBlyZ34cUBC2oj6YhVGl6HdZB0VmxCdIDXziOJ3m1NPvGNn8iCjri92Ln6WPD9fALE04/w2XOT3ZUJzxRevpxYoa82LWW1eb2/jCybMRdpSDI8ShTpOzu5Ba/N/jSbwr37pw6scDhQ67Q8NbpCW45NbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kdQudz1p; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3a064a3e143so593275f8f.3;
        Tue, 22 Apr 2025 13:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745352207; x=1745957007; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UKj7RHO7Q2wBMbkNPnOSKUZxAmZQvo37ML03ejRqDVw=;
        b=kdQudz1pBFJT49QLKwT/YheepFl2ji6UOVJ2SYk974gd7rO/gOGopHTQH9EyFKdgW4
         B/eKTRe2htUA45TzE1/KiMmgiXP1hhNdLaLqmqQS0/SkAcClTrUiY8UWoXl0l2SvxvEm
         e+x21/409z/gLwULXYXwPhEoUGB0bFGdCQjBYqNA6+Oo91iQqPQgRgSFxtal7LZdCKjt
         j+tfNaxs0gIbo9s+B+OmxMXMOEL34H4/bvDufQANn7uk99xwpXsOI36TKCiUT7tz0DwQ
         qPuuV1fb2W7cyqb+8c2mOpeM4zM0xw4I7D1P0SbYKR9RxITasoAqJJlkJxXLi3h3ilLJ
         vAsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745352207; x=1745957007;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UKj7RHO7Q2wBMbkNPnOSKUZxAmZQvo37ML03ejRqDVw=;
        b=SDGVoVJ5p1JXpv5xaCzlCpO2tZZ5M5sOgSpMsHSzva1AucxZftsliM0ghlRyanCKsZ
         QiZwY9Bv3X2Wys+1jJkIl2jLXgAERXTjc2VVsZMLlOKtS3Yz9EnCd9jk5HjpyhQ6ZwmV
         QRyrtqb93gtVHuBJPuY7v76TsIfkUHz6hNb+8LEbvNhS8Co/9XbYDlgnthNFQh2tUDzg
         jPKSAavGdJhaqK/NXn1PqveJGm2DfJY+hfc5vL8jFGefsVjWypLT8sgGi65t2mD3b9OF
         4NgZYSGMs52Ax/2FlFwYDqSxc6iPE19UHuZt6KsFaNcTlOE0IzoY/HDX9wXkuUjiV7X8
         5LFg==
X-Forwarded-Encrypted: i=1; AJvYcCVIRwenq5R3cxDnR7mHZIpPMMcTlA5Cov4vraYGWIvEa0lTouSzXUkBTEhjc1R/rQOUhyQDj0SkBw==@vger.kernel.org, AJvYcCVQqvkBNYERy562sFa8Q5e8fIggsl32dqUtH/SPcL9P/w6TvL/RiZ0/TfuFZFFBJ5ldcHxguLv31gs1D0c7@vger.kernel.org, AJvYcCVtAXa/m5SaF7E1K0KKN0IAlQmvs6svvw3iq1RJ8mTKrrDD9PpefE3wcSxTTPkdob7riIgA@vger.kernel.org, AJvYcCX3Aj5l1y129Rkh4HPsVcdftMErKNMKrsB5D/Db05P1UtPoszFGFXwFZ5Y1arLulHtOGXevQUQIT2Ab@vger.kernel.org, AJvYcCXNKSx/XcliFw6fXx92q0tYsC87z+wtrVVU6wjplOXl25Ax7UBfUe+4E4HpWjpOr1PTiLOG72crnDXBXCrZU7DW@vger.kernel.org
X-Gm-Message-State: AOJu0Yzoahi49ahjIbjuNagMrEWIQDUyYbR9QYsD6cQXrwxGF3UCqXG2
	7OJ46Eq0DVEBDZGdi8aKFvl1Vhh4nrsYyw3F5Yxf7XOxTUta/swf
X-Gm-Gg: ASbGncvM5+FhiUe6Qda+SCrzkctI+hwTiEZdNCC/BM3tZrnjaNK/2w+4u24+aRCnzvB
	2ChfIVrgAKAjbQg62kTjMV7FKeaYSBZKcMPATFWbtKUu5jBd8MeG0bmHe6aiK3OtDecdb9l4Vnl
	hxRjMnn5RhpbUUsP6h7hDKRAI1LM91Q68nlYw9nFW9XB0FCMcQ80yhJiHhuLe23bYXzJELazaUg
	h+YSsPC8XoyonsRYkhSeMn9KEB/4Rf7/Y059H+7unAOOROskQwzRdCp7Imij1ZLuV/OciqrG+oZ
	VuLcoe1YOJcb9ImdypkdWi+LkSKra8dBrFx+V7ySodx+/CAQ
X-Google-Smtp-Source: AGHT+IF+gc5hNP3PcfsbBN/YhSJuJTKdae8tm4WgIVh9uwA2+dAe4gQLce8qN+vp5i5Phgl0ysqOIA==
X-Received: by 2002:a05:6000:4a11:b0:39c:dcc:f589 with SMTP id ffacd0b85a97d-39efba3d0d6mr13189843f8f.20.1745352207445;
        Tue, 22 Apr 2025 13:03:27 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.235.90])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa43319csm16518816f8f.38.2025.04.22.13.03.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Apr 2025 13:03:26 -0700 (PDT)
Message-ID: <8c1c6405-1e60-4512-a675-4c00b00d400a@gmail.com>
Date: Tue, 22 Apr 2025 21:04:40 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v9 2/9] net: add get_netmem/put_netmem support
From: Pavel Begunkov <asml.silence@gmail.com>
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
Content-Language: en-US
In-Reply-To: <c0bd45f7-0325-4e4b-b0ea-ccae24a1eabd@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/22/25 20:47, Pavel Begunkov wrote:
> On 4/22/25 19:30, Mina Almasry wrote:
>> On Tue, Apr 22, 2025 at 11:19 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>
>>> On 4/22/25 14:56, Mina Almasry wrote:
>>>> On Tue, Apr 22, 2025 at 1:43 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>>
>>>>> On 4/18/25 00:15, Mina Almasry wrote:
>>>>>> Currently net_iovs support only pp ref counts, and do not support a
>>>>>> page ref equivalent.
>>>>>
>>>>> Makes me wonder why it's needed. In theory, nobody should ever be
>>>>> taking page references without going through struct ubuf_info
>>>>> handling first, all in kernel users of these pages should always
>>>>> be paired with ubuf_info, as it's user memory, it's not stable,
>>>>> and without ubuf_info the user is allowed to overwrite it.
>>>>>
>>>>
>>>> The concern about the stability of the from-userspace data is already
>>>> called out in the MSG_ZEROCOPY documentation that we're piggybacking
>>>> devmem TX onto:
>>>
>>> Sure, I didn't object that. There is no problem as long as the
>>> ubuf_info semantics is followed, which by extension mean that
>>> any ref manipulation should already be gated on ubuf_info, and
>>> there should be no need in changing generic paths.
>>>
>>
>> I'm sorry I'm not following. skb_frag_ref is how the net stack obtains
>> references on an skb_frag, regardless on whether the frag is a
>> MSG_ZEROCOPY one with ubuf info, or a regular tx frag without a
>> ubuf_info, or even an io_uring frag which I think have the
> 
> Yep
> 
>> msg->ubuf_info like we discussed previously. I don't see the net stack
>> in the current code special casing how it obtains refs on frags, and I
>> don't see the need to add special casing. Can you elaborate in more
> 
> You'll be special casing it either way, it's probably unavoidable,
> just here it is in put/get_netmem.
> 
>> detail what is the gating you expect, and why? Are you asking that I
>> check the skb has a ubuf_info before allowing to grab the reference on
>> the dmabuf binding? Or something else?
> 
> get_page() already shouldn't be a valid operation for ubuf backed frags
> apart from few cases where frags are copied/moved together with ubuf.
> The frags are essentially bundled with ubuf and shouldn't exist without
> it, because otherwise user can overwrite memory with all the following
> nastiness. If there are some spots violating that, I'd rather say they
> should be addressed.
> 
> Instead of adding net_iov / devmem handling in generic paths affecting
> everyone, you could change those functions where it's get_page() are
> called legitimately. The niov/devmem part of get/put_netmem doesn't
> even have the same semantics as the page counterparts as it cannot
> prevent from reallocation. That might be fine, but it's not clear

Actually, maybe it's not that exclusive to netiov, same reallocation
argument is true for user pages, even though they're reffed
separately.

It might be fine to leave this approach, while suboptimal it should
be easier for you. Depends on how folks feel about the extra
overhead in the normal tx path.

-- 
Pavel Begunkov


