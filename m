Return-Path: <io-uring+bounces-3872-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6574B9A725E
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 20:31:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FF9C280EED
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 18:31:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E36F119414A;
	Mon, 21 Oct 2024 18:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="DxHqz2iY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC303BBF2
	for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 18:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729535508; cv=none; b=YkJ5umwtH6u5U4Frx4lOuWXErV4SIN7iGlscmaRtC0UTeF/M/HhXZV0fCCFN48c7N3ApSmoYufsOK/gPjEYf19m/YNll98u6QOUF9bC1elZ/tvfFdpioK+i6fE+729RwUWqUPz+XI4+08rGOqOSmBhkQbh9eCGMOdiWOcGbj5Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729535508; c=relaxed/simple;
	bh=jC0DkXntGiZLd0To46e4yNwT0r9WH91SeNws8hipw7s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z2U7cjzEkrl0sb1Uv99pSwVPWCqGyyxkcE2bDzrWRmSXJ7UyezBAIv9d/bQFbOqaJX19UiTLHqrp1JkHYqdsjx0tRQXIBxETGLml+MYCifWXWd0kkJLX03kIZy+MANxowmv1Gq7JBmIteZrMqcnt4jrmk3NtBUF0xA49c0eJ/t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=DxHqz2iY; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-20cf3e36a76so46947145ad.0
        for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 11:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1729535506; x=1730140306; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7/EgoAZFIh9BoVeqC6+Fs1CWcfsi8BdDAV/4Dy94O54=;
        b=DxHqz2iYxM22M4a/6LO0FSkUTveJGJKc+r4B9erElcI3zMzSCiLPgOy7pBPlgAxzB0
         NxjOPWUUNRNG5x2x2lGYIkpwEccsfr9CDXCruLXe8R4+Q1ytSTQKo4bd6Koi0sHuXhFa
         qDpPE1QWc06tPOEgAAMG0krwb13MtWFXgLyhHZgo0Ff9KDs4VLKipFXLw06yKz9NbY8B
         FqeqdgRgH27u9f5f9YXHdfIAPvJI+SdgtVfemew270tCqgvA/A6nNJgZaxscAoJDRUJl
         lH3CUxUFmt5v1WIf2CKrvnSiemFUYdpgAAN28po+nTqEpNBDCpTl9ese1z5OM/G2kRMt
         V3xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729535506; x=1730140306;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7/EgoAZFIh9BoVeqC6+Fs1CWcfsi8BdDAV/4Dy94O54=;
        b=TTsaeb5Ji1Zb+DJZjv8RqmCRXUnDLh9i/UMF6TEjsclRX55v8NILluGZs2RWuD4Uhm
         cdyr6i5GDDVBlaV9GeuZxbOZarsAJxBFnHOjFaKyfqkvRhQxz+AzGM75DpWpR+iOMzT7
         eq0ds3S2/tXQuQLwUYB9M1oAqG5YszWoUsj/htKVmr1a+0pXrp//Vik6OGYOztXvyWbd
         WwH1Xig+VuaN6xZ0EHjQEdK5Nk24dMRwipREdCQZMqy6lRxETyBh5Wzyzf4KsdZdZmxx
         S0QxVSbjxcp5emUku4m1jvgqAdAYeUIoqehYZAm2v883XyLsP7uALYHE7WT0yOv1pg3z
         slZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGmb7T8SGnlL8MwfC214XwPaqVhwFP9/vkV8kMRIq18DHCA6B6aPAPARU99kjJ1oLATuW2ixmQTg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9ykKrZFS+ZMXNnrJFR6r/7uVsB7eneZHOZ4V/WK1gnmaGHAiw
	pRqsXkKANcpig6OixE070gAGs1XmkyHTCmTbpfc2EvIUSNcp7zILSK2oY/Djb3QptQUOFlGw5ih
	rAGg=
X-Google-Smtp-Source: AGHT+IEKCdDY85XBnBi2dTM20VjDzCW8X0a7Prx3JPE6BkBcJycnaU/w3jYmmnA8gx8vGc+Oi5wT2g==
X-Received: by 2002:a17:902:e849:b0:20c:83e7:ca54 with SMTP id d9443c01a7336-20e984aadf8mr1138275ad.27.1729535506379;
        Mon, 21 Oct 2024 11:31:46 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1256:1:80c:c984:f4f1:951f? ([2620:10d:c090:500::6:d291])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7ef1a953sm29269815ad.112.2024.10.21.11.31.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 11:31:45 -0700 (PDT)
Message-ID: <32ca8ddf-2116-43b9-b434-d8393cdbdde1@davidwei.uk>
Date: Mon, 21 Oct 2024 11:31:42 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 14/15] io_uring/zcrx: add copy fallback
Content-Language: en-GB
To: Paolo Abeni <pabeni@redhat.com>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241016185252.3746190-1-dw@davidwei.uk>
 <20241016185252.3746190-15-dw@davidwei.uk>
 <4f61bdef-69d0-46df-abd7-581a62142986@redhat.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <4f61bdef-69d0-46df-abd7-581a62142986@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-10-21 07:40, Paolo Abeni wrote:
> On 10/16/24 20:52, David Wei wrote:
>> @@ -540,6 +562,34 @@ static const struct memory_provider_ops io_uring_pp_zc_ops = {
>>  	.scrub			= io_pp_zc_scrub,
>>  };
>>  
>> +static void io_napi_refill(void *data)
>> +{
>> +	struct io_zc_refill_data *rd = data;
>> +	struct io_zcrx_ifq *ifq = rd->ifq;
>> +	netmem_ref netmem;
>> +
>> +	if (WARN_ON_ONCE(!ifq->pp))
>> +		return;
>> +
>> +	netmem = page_pool_alloc_netmem(ifq->pp, GFP_ATOMIC | __GFP_NOWARN);
>> +	if (!netmem)
>> +		return;
>> +	if (WARN_ON_ONCE(!netmem_is_net_iov(netmem)))
>> +		return;
>> +
>> +	rd->niov = netmem_to_net_iov(netmem);
>> +}
>> +
>> +static struct net_iov *io_zc_get_buf_task_safe(struct io_zcrx_ifq *ifq)
>> +{
>> +	struct io_zc_refill_data rd = {
>> +		.ifq = ifq,
>> +	};
>> +
>> +	napi_execute(ifq->napi_id, io_napi_refill, &rd);
> 
> Under UDP flood the above has unbounded/unlimited execution time, unless
> you set NAPI_STATE_PREFER_BUSY_POLL. Is the allocation schema here
> somehow preventing such unlimited wait?

Hi Paolo. Do you mean that under UDP flood, napi_execute() will have
unbounded execution time because napi_state_start_busy_polling() and
need_resched() will always return false? My understanding is that
need_resched() will eventually kick the caller task out of
napi_execute().

> 
> Thanks,
> 
> Paolo
> 

