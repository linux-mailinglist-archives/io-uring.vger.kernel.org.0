Return-Path: <io-uring+bounces-11608-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 40E3AD18232
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 11:46:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4162E3009760
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 10:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01A6A34164B;
	Tue, 13 Jan 2026 10:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JyXKhICb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4801EB5FD
	for <io-uring@vger.kernel.org>; Tue, 13 Jan 2026 10:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768301210; cv=none; b=RSkkWlACucq6jl+D7gYDuODfheZZ3KRaXJC/HQYphoEiXYbXJf/BChhfcKtsT9jtM3cajAJzj4xuYYJoL+WGylq8HsMfHqr/PGw0XCNg7Z6IhdOqmF8vZMaKsawCz+TtcKcLvOsEwEDJhFev1BMuqf88Iac9wAwW+d5/etlLq5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768301210; c=relaxed/simple;
	bh=fYO5mAVLp/077UFBDfQhXzmX4QvLaBG8lItV9IMLT1o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sF1ZOr43Cng0R5HJ3FATe7N/X9C1q2XUKSvTdAmxaqC7lS13+FKnqQb4KPzwE6hNgjmR1z9Z6rHATbmY5E7j0I086NoHPYKYClkKRgkaIPPDJTrAzU0Cfv/vwszeE6yvnqqb4awL7SpJJb/4xr4RR9Ev21YCs2ETjSx7IzB3SV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JyXKhICb; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-47d5e021a53so54643275e9.3
        for <io-uring@vger.kernel.org>; Tue, 13 Jan 2026 02:46:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768301208; x=1768906008; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PKsf3wgw23/pKBp3MaibLO9IrAlpfXga+vfr5Wqb9rU=;
        b=JyXKhICbCoxP4aQeGECr8h7juVZdqeUZtCsHAACCmLhkJ9aLM2y+NZoqn0eL6f2r3p
         df1b+F6B3uSBXVjDOcz1Kfj214xWYIx6H86DQ8Hhw2Jsy0M9YtKzEPV4I38I2mepytQK
         gJMn8zeE1OsZq/HVlUCIgeN7c+MfTZrNgS7tU31PtvArPKl1NHElPMD7DxmnpzaGsh2B
         A3GWLEXLZBWrE6Cv4aHV+x/aJH10eZC5W0xW8otpiUj/05wiQmP/v2mvWfxcSv7+7XKO
         ZoVHNExc1emjviKYf8v4WMXDIgCEzv5EJN2y16SK4KXQ8BX9sz05qYbghCzMzMoY4wmX
         xI9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768301208; x=1768906008;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PKsf3wgw23/pKBp3MaibLO9IrAlpfXga+vfr5Wqb9rU=;
        b=O7IdSySNAFXKawU+bKPkl+8EcrZL9Z3EMrQJDYnxuHd2mWXAj/YKw0uxpaW5mtH7RG
         rwda+rVhyO2em9KsfnS/9gVmqRAFEyykVTQxCPu1Y+WGabr0XbnpCTlrG3KUnqOj/NHH
         +pXHE/n8d7tq9jXTfVmaWrC683G3YmmqwisvxyLFJ6KWCNy/rOjaRi+mwMKbC1EL6enc
         ZYlRZmAlmp5IOjrVXATn1coG3JzEplsnVhuv+3L3aruc7OqBrpFwUHK8I45rDVJdst5i
         hrzDbLYUmYdCWFT+mY7BRM8qQadOtmWHJZc8CUIuE4KF1hp1k/BhBX3AvI1yojro03xa
         R3eg==
X-Forwarded-Encrypted: i=1; AJvYcCXzAGELhDtIcz1C8zijZx/o3nt+f1yZEPnM0DDsxd40Jvlwak7FRapGakKRtSrzyXUMLEwpeyBJ1w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzWRQe8jLbI4QDVrpTl8fwGmfMjgCFe9xmyHigmoB6vzOlt1Po+
	LAq7NwdHqe4OaAqBmnzoUQ/6l6vheoK12v5Kwpq+nXHflbzNeu4kuTSA
X-Gm-Gg: AY/fxX7PLtMoMRT2FD4eM8b9wd2RPz5NkHTzP/K+MhoYiB7FZqUW4/XqVro5Qfa6Afp
	xoo2txz3w6NFfWSbBP2FEjd/Bqc8b/6jBnvASICFesmmjlaLIbaLm2Rl/ThM1wl4WMvZiTYl44N
	CmuxBSE+BWjYVnubsuM/bZkEgifj1IOhf1qRusT0JpQcFg+soblNmhp0m4AYaykPttPfG4EtKNU
	/bVzZ4Yfc2QWP/eHsVGf/6CxrYIkFcfDRz9mXYFsgVuXXjpwgDIZESiev4SaMOo6o5Kk0OahPP6
	Vk5rQDZ8uNy63nf6JF7OBSK0Nbpj7mgbvlUSY8DoOvrq08w/b6YAs4ZZJwjToyOMEhR6GzxjMxg
	w1ZXSe8jmzCfucMqsg31w7j1/s0nFceXNO1IqJ9iKExlqPuRB33Gb0q1ox9V4uG6g0bUU8aSC7/
	eVcuJujAkkfh+2WUnyBVO3H3/r2SrDDPZZYY3zc3xcRc13L72fYZ2ZOU0fAiXHJ+Uso88FG7hd2
	y5FfaOJPiF4D/Z69A/oHSRKhhZZNBceMuZzydCobtfDW8056VKNNJuiZ6g3X044LA==
X-Google-Smtp-Source: AGHT+IEymhtJvsVvq7h/MiDqH9B3Tq4aNk4c91QeNppt4FR+JHUA9Tffj05tYCrsjh9jqUJvxHBGZw==
X-Received: by 2002:a05:600c:3152:b0:47d:403c:e5a0 with SMTP id 5b1f17b1804b1-47d84b184abmr250841245e9.12.1768301207472;
        Tue, 13 Jan 2026 02:46:47 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f65d9f0sm409975245e9.12.2026.01.13.02.46.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jan 2026 02:46:46 -0800 (PST)
Message-ID: <da02d2af-ba34-4646-b56b-bcb9631cb286@gmail.com>
Date: Tue, 13 Jan 2026 10:46:41 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v8 5/9] eth: bnxt: store rx buffer size per queue
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
 <e01023029e10a8ff72b5d85cb15e7863b3613ff4.1767819709.git.asml.silence@gmail.com>
 <017b07c8-ed86-4ed1-9793-c150ded68097@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <017b07c8-ed86-4ed1-9793-c150ded68097@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/13/26 10:19, Paolo Abeni wrote:
> On 1/9/26 12:28 PM, Pavel Begunkov wrote:
>> @@ -4478,7 +4485,7 @@ static void bnxt_init_one_rx_agg_ring_rxbd(struct bnxt *bp,
>>   	ring = &rxr->rx_agg_ring_struct;
>>   	ring->fw_ring_id = INVALID_HW_RING_ID;
>>   	if ((bp->flags & BNXT_FLAG_AGG_RINGS)) {
>> -		type = ((u32)BNXT_RX_PAGE_SIZE << RX_BD_LEN_SHIFT) |
>> +		type = ((u32)(u32)rxr->rx_page_size << RX_BD_LEN_SHIFT) |
> 
> Minor nit: duplicate cast above.

oops, missed that, thanks

> 
>> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
>> index f5f07a7e6b29..4c880a9fba92 100644
>> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
>> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
>> @@ -1107,6 +1107,7 @@ struct bnxt_rx_ring_info {
>>   
>>   	unsigned long		*rx_agg_bmap;
>>   	u16			rx_agg_bmap_size;
>> +	u16			rx_page_size;
> 
> Any special reason for using u16 above? AFAICS using u32 will not change
> the struct size on 64 bit arches, and using u32 will likely yield better
> code.

IIRC bnxt doesn't support more than 2^16-1, but it doesn't really
matter, I can convert it to u32.

-- 
Pavel Begunkov


