Return-Path: <io-uring+bounces-8378-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B8947ADBB41
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 22:33:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 08CB21891C0B
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 20:33:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC69420B207;
	Mon, 16 Jun 2025 20:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a6wtaycN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8622066CE;
	Mon, 16 Jun 2025 20:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750105993; cv=none; b=PW+1VpjBDSAId27f+xnhw0b59IOXgPh5HyLUHJ2x9jpGQDCHhzfDoK4ol6lusliSJjSejodEF7loXpDFO6+iUU31O8PeVElboP9geYXEeTuMPi083EHkiHCzFJeouIW/QgykZ3f87e9ZzYjpiHgt2L++pgKBvVq2cXadAYfaHVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750105993; c=relaxed/simple;
	bh=kjsstH0g/6h8iyZiDwg843MOB/KIHiCArEwD/tjr9f0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YpKadW5/nqRyMJJMJ3JEY2pPl7ApwcHTSYUcSF6H8SY47OHCr3Q57XNY2Q9xKKnz0b/ABV5Gi2P+qhjmG6DsMjmWzO23eFEC6KarfkO0WjqWQcoMf5jSSNZ1c7euJbYBItVfcyymbjIi72i2puJ3FPkdKWhrArAGpoi7ht8SGXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a6wtaycN; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ade4679fba7so912283166b.2;
        Mon, 16 Jun 2025 13:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750105990; x=1750710790; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OEBc6DmNsPMl2/ONkGg2uWpAKh13Fm66hHVxJiveGZk=;
        b=a6wtaycNeRdWqCkT0wCFklp16HLLaTowwdrvvKTNupnmtZ94oHu44H5f11Ltij/1Kh
         In9JSbnDV0JHn/Bo+WakdRk8PaCQDmKvX7LAazP7cX2pp8ZS0ZZHcU23MKXHhgAkC1on
         cRZRcsoy9079c6Fjeg6Jx7PYSuCrXlrFOSWxR5/TsDT/Il6yrrAtTRZaENpAY/2gcAqZ
         vsPDH0PyhmyCC/fqdwUfYtB46vr8KLInIlEGiUdAYtIrmD1hXnRv95yd07C8EMgrgS/N
         qM/2L1rXYHoWllQjib35EkncnGkrUjmdJJt1irM/2F85EeHWpHIDsLG31x8tO3Msy6eD
         FeMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750105990; x=1750710790;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OEBc6DmNsPMl2/ONkGg2uWpAKh13Fm66hHVxJiveGZk=;
        b=vQn+TmCwU1AWVyO/C6cQWaEbWv0jye4jy55XdVjjwxg3rgCDegPgoRCkxdlWCeP2iT
         Wq9AUKWQYabFuxnv+Oqs1T6mj8P9N0z1P8BjI+eJZqvfwt6Q5Bh/yao+FoBOb1O99VKC
         6ryTX76hsaY3Qp8cFfz6FAN5WhwBhX6+M/TBPXiwvHjYT12+61ofjF7b4CrxGxkUgbRX
         toYyH7UYjbfswOYNaBi7Dzudy4KlJUnO8Adx2INYCxgsHAaC5c6Zk6gkWvnUcFqFdNOl
         xriOwhk76qmG/N8jHMowGedA6NQK94z4x9n1DjJl0ZaCICuMfVwBKGlY+x2y0p9VZwl8
         +46A==
X-Forwarded-Encrypted: i=1; AJvYcCW8CU5jHjfA6c77MJO6Km3vqOabgZSfhQJcWp3yGL2FnzaOBQxRpy0ji4LBOtWkx+Pn9SZzT17RSyA=@vger.kernel.org, AJvYcCWa5/hdVv/bIyjEhLF9XZpp4H5YBqrvlFqsLpnVJCn6loauXoVSqwN+ci/3WBC/Stnhj1Y=@vger.kernel.org, AJvYcCXrAOUtRbAtOE2YMKul+W4UxdtT1b6P6Hbcg74oiBCtCc46iDbHJcEH+9YqxXKUdZf8m9se9vy8cuQuWH3T@vger.kernel.org
X-Gm-Message-State: AOJu0YzEQI6nbQY+X/ZVVgAPwNMhbwaXIw3MPNYhOzM3ZUXZJ+AXUvbD
	8g5pmvso9znCEjWhKaX+2s2jMxBNHpMtTd/MZGLAhgmDTAaa+wwt/XTYANlkwQ==
X-Gm-Gg: ASbGncv0rg9diJ3o5g9aaRT6acS9zT1CmASf3f7QO10jDTQ2vCd8hF3L31EbPDtaym2
	p/Ji2uPcdprpzgIcBYotyXg7Pog4uEBo1s7zOc6bAhQiiWTiFdtDHdUKuO7aE15n8m1mindpFhx
	UrG4xW1EhIGIaTIz/n/lMyq8O0cS4s3Z8xA/47J0nUtlhyX5v4bqAXddy4scuSlj5Cbz2vAK/hS
	sac50e49sTNP9vnvg7D8uWjnJkcAt46Bx22M311nQNNrV/GA21RV6/hLDvVBj6PM7s7BboYD8KT
	2IlyccevEg76NoJLacZcqIqkQVTzucbK/vXOxLXg+1zE8kst5l0uxxOOd6DJJRazKZwAp4/gsA=
	=
X-Google-Smtp-Source: AGHT+IGJaPijeeK4rEyWHsiNGdE/UP7lH5KLXmf4DzrmbGOWBAJf0kKNQ20Q+3Zilv5wxiFx/KZTGw==
X-Received: by 2002:a17:907:3c90:b0:ad5:3a97:8438 with SMTP id a640c23a62f3a-adfad598a60mr1053388166b.41.1750105990192;
        Mon, 16 Jun 2025 13:33:10 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.141.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adec81c5c3bsm729292066b.61.2025.06.16.13.33.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jun 2025 13:33:09 -0700 (PDT)
Message-ID: <639fe690-2a47-45fb-843e-31e91f6d2dd0@gmail.com>
Date: Mon, 16 Jun 2025 21:34:26 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 5/5] io_uring/bpf: add basic kfunc helpers
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrii Nakryiko <andrii@kernel.org>, io-uring@vger.kernel.org,
 Martin KaFai Lau <martin.lau@linux.dev>, bpf <bpf@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>
References: <cover.1749214572.git.asml.silence@gmail.com>
 <c4de7ed6e165f54e2166e84bc88632887d87cfdf.1749214572.git.asml.silence@gmail.com>
 <CAADnVQJgxnQEL+rtVkp7TB_qQ1JKHiXe=p48tB_-N6F+oaDLyQ@mail.gmail.com>
 <8aa7b962-40a6-4bbc-8646-86dd7ce3380e@gmail.com>
 <CAADnVQ+--s_zGdRg4VHv3H317dCrx_+nEGH7FNYzdywkdh3n-A@mail.gmail.com>
 <415993ef-0238-4fc0-a2e5-acb938ec2b10@gmail.com>
 <CAADnVQKu6Q1ePFuxxSLNsm-xggZbUEmWb_Y=4zeU54aAt5o6HA@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAADnVQKu6Q1ePFuxxSLNsm-xggZbUEmWb_Y=4zeU54aAt5o6HA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/13/25 20:51, Alexei Starovoitov wrote:
> On Fri, Jun 13, 2025 at 9:11 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
...>>
>> It's valid within a single run of the callback but shouldn't cross
>> into another invocation. Specifically, it's protected by the lock,
>> but that can be tuned. Does that match with what PTR_TO_MEM expects?
> 
> yes. PTR_TO_MEM lasts for duration of the prog.
> 
>> I can add refcounting for longer term pinning, maybe to store it
>> as a bpf map or whatever is the right way, but I'd rather avoid
>> anything expensive in the kfunc as that'll likely be called on
>> every program run.
> 
> yeah. let's not add any refcounting.
> 
> It sounds like you want something similar to
> __bpf_kfunc __u8 *
> hid_bpf_get_data(struct hid_bpf_ctx *ctx, unsigned int offset, const
> size_t rdwr_buf_size)
> 
> we have a special hack for it already in the verifier.
> The argument need to be called rdwr_buf_size,
> then it will be used to establish the range of PTR_TO_MEM.
> It has to be run-time constant.

Great, I can just use that

> What you're proposing with "__retsz" is a cleaner version of the same.
> But consider bpf_dynptr_from_io_uring(struct io_ring_ctx *ctx)
> it can create a dynamically sized region,
> and later use bpf_dynptr_slice_rdwr() to get writeable chunk of it.
> 
> I feel that __retsz approach may actually be a better fit at the end,
> if you're ok with constant arg.
I took a quick look, 16MB sounds a bit restrictive long term. I'll
just go for rdwr_buf_size while experimenting and hopefully will be
able to make a more educated choice later

-- 
Pavel Begunkov


