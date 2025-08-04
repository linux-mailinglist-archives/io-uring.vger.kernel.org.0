Return-Path: <io-uring+bounces-8882-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB785B1A24C
	for <lists+io-uring@lfdr.de>; Mon,  4 Aug 2025 14:54:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08C6216C9B3
	for <lists+io-uring@lfdr.de>; Mon,  4 Aug 2025 12:51:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50A7626E706;
	Mon,  4 Aug 2025 12:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fkHZ1CuX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8306D26E17D;
	Mon,  4 Aug 2025 12:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754311733; cv=none; b=B0wa0JfTbOrXWPBylvSzB9lZeDrm60R/a1N8JfnJNBYpVuOFEUKyxZExBriyya5W8JTIRF1e4bDfG1q+41YfbBmYwGRr3ll+iy1cUWpFn2rCod7Qu/poSvMNx2avJ34/OJlZwhXLhT/uP81W/OExI1SkGTClGOoO5Tn87Z4/SVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754311733; c=relaxed/simple;
	bh=59H73LX8PBLGOnWexguPOFUUCzKaRLA64e2x5v9d50Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lZe7EUfMLumiu0A+0j3rDAMFKURV0eDJNR5+eyvuYAPGHgzkieIRz9MDH1IZ4caoU7ij578MWS3Px4hme3QaMEhz97dwf29sjg3uoYGHj+N424u0k1o963HBNGCCTFRDkxV/PhceYzJ9qUbP4nWHT5SULbxgTaS0fq5tB4P9Njo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fkHZ1CuX; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-454f428038eso37154885e9.2;
        Mon, 04 Aug 2025 05:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754311730; x=1754916530; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uFjq/ccIa6phfVTzlseeDSMDj8VXW6rCCDNMSZoFxcM=;
        b=fkHZ1CuXY3SFEJNRWcZFtmpgSfrItJjSQKEfDPkofi06uHwP8uidx4pkSo1ECT6EC8
         gKBeQfHRXbW3S3rNGVTBQOcEfksyqJ7DiVPZuYmE0ple5dN8ID4Tn//t+ZQ7huMF+77Z
         5afxDtZj4H+r8Q6kFaPr6H+mxRPBhBt4lBvEhPvZ1Pom7LIQ0IKkxW9cMaqGX4d5WMb1
         0unDpboffPkihxCzuQpPQ0IO9feVViZaG7MoUPmJE+FwEldL0s+25EUbzrAucswA6hx0
         tdI/yqRLY8ZVcMJDU0JEXxL64IfdcxM10pNYCxgExTyKtV0IwJbVjnMyxky1jsc9Ojrq
         Qn/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754311730; x=1754916530;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uFjq/ccIa6phfVTzlseeDSMDj8VXW6rCCDNMSZoFxcM=;
        b=Aov+ju07wyDAoYMwOTBJ9epCA9TWkkGNJD1aOam2if+/WlPaKgWOwmtxITc5qNK4aj
         WV3hJ94qkQC2ANgEjWX7X+Dmci1UPtfXWoz/35fEdrMXR+Vb2LL6bC8Ou7vul7WbL2L1
         L2iWNFMzmmY3ZSZ7ALOJ7+qHpf2LMdPAsrPeiTKHCVDCv/yvyFNl3k42acQWqAR62gPp
         odJVV3TKTD1Xkjss9mjyWK6mPpxA+28l2UQfxdxhPhQ0YlFFQZPfhzgfv6MIfxJQavfU
         24hSNWJrDfAjzLYDnt6X5NtsoJ4Bzdu/xU33cI4BoRqlPuNMvPWKuxX51+We/sJ3cY9+
         yfcg==
X-Forwarded-Encrypted: i=1; AJvYcCUZO4gMusz1GgONW+m/1KFnaUQe1Aj7ukIJ4hFFqYvpAbPPbJe+DnpmBrsAPaX+Y4KvFCegtAT6iw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxPhuXu/6ozNjX/pIMlRuVAGtb0o5hxE7bt2PY8LrUJn1TS4vDo
	zdL3I2+Mkue443EZqrhlLdpzYbqBmC4yFxwFSMs/zBQjcmsXqGa2ZJyj
X-Gm-Gg: ASbGnctpQ95vmXEu9YDHx/K2P6a006XKOYZOwbd3/Iy9FfHaeAI2Vb8XpuNNSqM3nLE
	1aCklUAvopYzJ8/7CQPvloIJOrpCE+RjmSoNz0yQMKtLAY2J7dfaVrxo9ULiEDRXQeiqdAkstiS
	tSa3bs48ZubX7AX/kmnDE/TM5oIOnu7crFG8sv2c5AayFrlvFvdatYY75b/bRe4dztWDimOYR+N
	e9qR9imLBh/xazlZJKO0+nrxVaig132l0qQ3VGc0Rq5rjIJf4lUKs6E/NPVzgghfA2uHkpKm87Y
	camMpynNWc+JoumqCYAIdUntIhQW7d1/NZlg11Si3fZ8jtvdSXOrwL2mZ51j11zJYrapt6/Lz44
	K0RIIQBiVakUQjpg2sB1CcTom4W0+K66CR+Y=
X-Google-Smtp-Source: AGHT+IHl9k3pYdNBy32uOQnp3EIaG9vjJhDfzKHZqRs9VQBLELW6xAGD9WNiayU/YNBMqhL+RtEDag==
X-Received: by 2002:a05:600c:6d7:b0:456:1c4a:82ca with SMTP id 5b1f17b1804b1-458b9359829mr43650345e9.32.1754311729396;
        Mon, 04 Aug 2025 05:48:49 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::26f? ([2620:10d:c092:600::1:c055])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c4530a8sm15438378f8f.38.2025.08.04.05.48.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 05:48:48 -0700 (PDT)
Message-ID: <11caecf8-5b81-49c7-8b73-847033151d51@gmail.com>
Date: Mon, 4 Aug 2025 13:50:08 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 21/22] net: parametrise mp open with a queue config
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, io-uring@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>,
 Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org,
 davem@davemloft.net, sdf@fomichev.me, almasrymina@google.com,
 dw@davidwei.uk, michael.chan@broadcom.com, dtatulea@nvidia.com,
 ap420073@gmail.com
References: <cover.1753694913.git.asml.silence@gmail.com>
 <ca874424e226417fa174ac015ee62cc0e3092400.1753694914.git.asml.silence@gmail.com>
 <20250801171009.6789bf74@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250801171009.6789bf74@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/2/25 01:10, Jakub Kicinski wrote:
> On Mon, 28 Jul 2025 12:04:25 +0100 Pavel Begunkov wrote:
>> This patch allows memory providers to pass a queue config when opening a
>> queue. It'll be used in the next patch to pass a custom rx buffer length
>> from zcrx. As there are many users of netdev_rx_queue_restart(), it's
>> allowed to pass a NULL qcfg, in which case the function will use the
>> default configuration.
> 
> This is not exactly what I anticipated, TBH, I was thinking of
> extending the config stuff with another layer.. Drivers will
> restart their queues for most random reasons, so we need to be able
> to reconstitute this config easily and serve it up via

Yeah, also noticed the gap that while replying to Stan.

> netdev_queue_config(). This was, IIUC, also Mina's first concern.
> 
> My thinking was that the config would be constructed like this:
> 
>    qcfg = init_to_defaults()
>    drv_def = get_driver_defaults()
>    for each setting:
>      if drv_def.X.set:
>         qcfg.X = drv_def.X.value
>      if dev.config.X.set:
>         qcfg.X = dev.config.X.value
>      if dev.config.qcfg[qid].X.set:
>         qcfg.X = dev.config.qcfg[qid].X.value
>      if dev.config.mp[qid].X.set:               << this was not in my
>         qcfg.X = dev.config.mp[qid].X.value     << RFC series
> 
> Since we don't allow MP to be replaced atomically today, we don't
> actually have to place the mp overrides in the config struct and
> involve the whole netdev_reconfig_start() _swap() _free() machinery.
> We can just stash the config in the queue state, and "logically"
> do what I described above.

I was thinking stashing it in struct pp_memory_provider_params and
applying in netdev_rx_queue_restart(). Let me try to move it
into __netdev_queue_config. Any preference between keeping just
the size vs a qcfg pointer in pp_memory_provider_params?

struct struct pp_memory_provider_params {
	const struct memory_provider_ops *mp_ops;
	u32 rx_buf_len;
};

vs

struct struct pp_memory_provider_params {
	const struct memory_provider_ops *mp_ops;
	// providers will need to allocate and keep the qcfg
	// until it's completely detached from the queues.
	struct netdev_queue_config *qcfg;
};

The former one would be simpler for now.

-- 
Pavel Begunkov


