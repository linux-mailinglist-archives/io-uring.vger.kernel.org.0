Return-Path: <io-uring+bounces-11005-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D54D2CB4721
	for <lists+io-uring@lfdr.de>; Thu, 11 Dec 2025 02:39:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5541A300118B
	for <lists+io-uring@lfdr.de>; Thu, 11 Dec 2025 01:39:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BC6423717F;
	Thu, 11 Dec 2025 01:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MihA49fl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644741F95C
	for <io-uring@vger.kernel.org>; Thu, 11 Dec 2025 01:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765417166; cv=none; b=Df77DMWGYtRbHuwt7RB48lc+PUAyH6FK1EdXadk99O5C81lYCgBTKwlay6s+NPSgbJyikaGCxHJ0+J27mEsnYioI/1MJgw7x3fzAeZa7ASq65lddI2PMLFe5Bz1ir9Txr7QVy0VfHVmKLcJodCAiOtVesKfF6YIuNhXHMw774wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765417166; c=relaxed/simple;
	bh=erA1n//FwJ/YQXinNTTcC2usXHzwpMJZDsBPQoI9z90=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VpnEZesixsvPqCqezxXzZT+9JblfJEgomu1M9Pt+6V7T6qbDYVjPDD1knosqMmBha88S/mof+kmApGpiaPmk1IS54T62vnB2xUF5pt2eabDDjnWm5BohSlP5fDwefH9r+tZ+yoFakbUtI0VQ+bb3PK4jpiJ19t39FmKe1oURD+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MihA49fl; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-298250d7769so3782305ad.0
        for <io-uring@vger.kernel.org>; Wed, 10 Dec 2025 17:39:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765417164; x=1766021964; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IPBrlzp2E8C4ePjFcmKaseg+JThcQtY0+QpZZyIeYQc=;
        b=MihA49flq+R4MySAVx6PVn8LV9SHm9fmPVZDqyINdglAfg9noE/uNWlXJrbeNro3Mr
         8JNaMzXARd/jqYr6q8x9eDSyT/9JuuO0OcpDDQTqPVwnDDL0bCiOEU8YFabLTAESyXn6
         9jD3LSSn3HbmA+HXEkufAwCXzymhmiQq6QOzfyx7SxVoRI4Y/07LJbp2/f03thiaxoBA
         rVx7gA/CpADHDTbjcwuNeCrgl1D3K/7dAbcKlC8vAMCdT+GiUDnV8qHqrmVnc++5ZbHf
         k9z52FuPUyqUT3VilR8uVhTuLcPXor3EL2elBNK8kGpF3kj0ltS0UG1o0pM/QO7JGnOJ
         /uzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765417164; x=1766021964;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IPBrlzp2E8C4ePjFcmKaseg+JThcQtY0+QpZZyIeYQc=;
        b=OSeuAFzNd5COAw2vNuTTAY94DmVoLDLnOCatsBk5YUl3Q1dzGV6hYb6ybQIT7R9eKn
         FZj5DVqBt4cyjqjw9TOtoyuL/32eG4EyOPC5x0Idg4CmVznEiKmUBmOZn1yECZH/Exv4
         bQfalikMBc/YD5240oX+H8gbky33Inektnb0SUmMeGDnBPXKKmMKbc9To34aHri1oA2L
         MGrH2T/afJdTSbj/ZNOGO8qKfNyRoQcfH8tYxAiXS1YyxoIGfTeBwkhLwxiMc3t732oE
         jSrHtgrab7f2+/hK1tO/sdw6b/osHCEQ/Vt4/BXGQ0wyCFkMnbvHkg7k5RzAE4gRI9GY
         NaIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHocx/CtNNmniQqgiA82H+tRdw4zjtbD1b0sBmbGUdOFsAdKge+DtQxCbaM0w0FF9VoajZ5QFskQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywmm9mXgya5/TXPDRZT4kRdDVj7mXoHJMLsVsAOzrOdnuVnUc81
	lHEClNg0BUVACJex+cD1C26YzBbp9eV4CQI0rWSrW53zYi39N22r6h0p
X-Gm-Gg: AY/fxX4RtA+icWKILEOUD8L5Ep2KV2+jhuIrDsp3LbzbPR6rnqFCvEIS4cdGWu5JPR9
	YahUblfDGMvUnjbSKQFIpzrAb9yD/IT9uGRJ1Lo4QWudq5AP9rI6ZluUUgkQecxCxVfski8wNN3
	O7HzPFU+UEda0C6qDvMgENs6V7FR2Nj4uGq4l8i3knLIM1n/8yAYSO/INHHSReKJwNveANKSQIz
	1L4X4os+1xO7CTbL9nR1n23cXGrknVVgIrrZ3/J0eV9X7f51XFFub3O6H0yrcg16NLlEmJMl1hK
	noDEPu+ocCOdjfeuudvaOuvCiWdQOeQOFmBy6J3JBsm6bA6Z7F7tHEEru3fUWR6yZkV8eNGhWge
	S6ANIzvH0L1guJ0obvoZuqtiFJGpLZ+wIiRVRboOWCXj7lhe5jArRQxDVhMQT502bkqB15V1FUC
	a+62AUX3iUQP6ujxqLv6ANA/mXK0mkxKJydzh3z0PW4jPl0ls9SVNbrkNFWRA2WerdU9fy+QoDL
	ik0WHsjRIAnPrFNxrR1UrCLkmXlO2kd8CeJAuIGqeYs4lgdsdA8hgX8Ci9oZQ==
X-Google-Smtp-Source: AGHT+IHMLbGR0SeszHCUe5dGxSuVdd58yhBKf6E+3phqHxJVDWFPPS1CN++3WroD7xAIWnKPrzG/Ow==
X-Received: by 2002:a17:903:2311:b0:295:9cb5:ae07 with SMTP id d9443c01a7336-29ec25a7010mr41542155ad.38.1765417163663;
        Wed, 10 Dec 2025 17:39:23 -0800 (PST)
Received: from [10.200.8.97] (fs98a57d9d.tkyc007.ap.nuro.jp. [152.165.125.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29eea06dd9bsm5759535ad.99.2025.12.10.17.39.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Dec 2025 17:39:23 -0800 (PST)
Message-ID: <c97d2c95-31c5-4bf6-b58f-552e85314056@gmail.com>
Date: Thu, 11 Dec 2025 01:39:25 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v7 7/9] eth: bnxt: allow providers to set rx buf
 size
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Jonathan Corbet <corbet@lwn.net>, Michael Chan <michael.chan@broadcom.com>,
 Pavan Chebbi <pavan.chebbi@broadcom.com>, Andrew Lunn
 <andrew+netdev@lunn.ch>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, Shuah Khan
 <shuah@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Yue Haibing <yuehaibing@huawei.com>,
 David Wei <dw@davidwei.uk>, Haiyue Wang <haiyuewa@163.com>,
 Jens Axboe <axboe@kernel.dk>, Joe Damato <jdamato@fastly.com>,
 Simon Horman <horms@kernel.org>, Vishwanath Seshagiri <vishs@fb.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
 io-uring@vger.kernel.org, dtatulea@nvidia.com
References: <cover.1764542851.git.asml.silence@gmail.com>
 <95566e5d1b75abcaefe3dca9a52015c2b5f04933.1764542851.git.asml.silence@gmail.com>
 <20251202105820.14d6de99@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251202105820.14d6de99@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/2/25 18:58, Jakub Kicinski wrote:
> On Sun, 30 Nov 2025 23:35:22 +0000 Pavel Begunkov wrote:
>> +static ssize_t bnxt_get_rx_buf_size(struct bnxt *bp, int rxq_idx)
>> +{
>> +	struct netdev_rx_queue *rxq = __netif_get_rx_queue(bp->dev, rxq_idx);
>> +	size_t rx_buf_size;
>> +
>> +	rx_buf_size = rxq->mp_params.rx_buf_len;
>> +	if (!rx_buf_size)
>> +		return BNXT_RX_PAGE_SIZE;
> 
> I'd like to retain my cfg objects in the queue API, if you don't mind.
> I guess we just need the way for drivers to fill in the defaults and
> then plumb them into the ops.

It was problematic, I wanted to split it into more digestible chunks.
My main problem is that it was not really optional and could break
drivers that don't even care about this qcfg len option but allow
setting it device-wise via ethtool, and I won't even have a way to
test them.

Maybe there is a way to strip down qcfg and only apply it to marked
queue api enabled drivers for now, and then extend the idea it in
the future. E.g.

set 1) optional and for qapi drivers only
set 2) patch up all qapi drivers and make it mandatory
set 3) convert all other drivers that set the length.

I can take a look at implementing 1) in this series. It should help
to keep complexity manageable.

...
>>   static int bnxt_queue_mem_alloc(struct net_device *dev, void *qmem, int idx)
>>   {
>>   	struct bnxt_rx_ring_info *rxr, *clone;
>>   	struct bnxt *bp = netdev_priv(dev);
>>   	struct bnxt_ring_struct *ring;
>> +	ssize_t rx_buf_size;
>>   	int rc;
>>   
>>   	if (!bp->rx_ring)
>>   		return -ENETDOWN;
>>   
>> +	rx_buf_size = bnxt_get_rx_buf_size(bp, idx);
>> +	if (rx_buf_size < 0)
>> +		return rx_buf_size;
> 
> Does this survive full ring reconfig? IIRC the large changes to the NIC
> config (like changing ring sizes) free and reallocate all rings in bnxt,
> but due to "historic reasons?" they don't go thru the queue ops.

I'll check when I'm back from lpc, but I was coming from an assumption
that the qcfg series was doing it right, and I believe only the restart
path was looking up the set len value. I'll double check.

-- 
Pavel Begunkov


