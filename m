Return-Path: <io-uring+bounces-3894-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 514159A9B72
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 09:49:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 08E791F2326D
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 07:49:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9983536124;
	Tue, 22 Oct 2024 07:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CD8SO0Pt"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E525B946C
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 07:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729583342; cv=none; b=BMZ0vi0U2MZvAtCg0jc6IfnGQiauiucB7wX7OGGvKSFNkZQhaZ+6tSHodt2usXuS87Vn/2Qo9wwZ9EXUmbkMyGfS2mj51DSTacKER9W13yXgUqP7+UGFGq6CXi6qVmFUU0FKHs0LzyMtHh/RAt2V0gbu1l5VjjTRzqahBEtuDfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729583342; c=relaxed/simple;
	bh=z0TFOz8qnWQgiFjOHpeyHIhiXC3wimd3qkk292JZeyk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mDYZdgA6EMShCIzyb8C0g6bXtSfKSL47TtKQn27II8O4IWN45R0JazoHn1Kn8RfVxg/akrY5f5BpC5PSe2b325S8NDdYnKjKynOUKCZ3fDBeLT3kQX5vvcassfZpnPLJ9Dlav3xxqVqf0iTHTj+F6uwLIhhXVb+CwGyo+X+rsEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CD8SO0Pt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729583339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ftccds8EH7SC5Jyy8+I+ZK7tzNnlLXQBxvCZJjQtOYQ=;
	b=CD8SO0PtDwabm58XC0ROcS0iN8p6aXo7RdKuf7h5gSYXISo8CdoDAKlfCXpOV/b9sl7Q7J
	cwlV4UAN6GpwneqW3kasqGtpsnFera+qHyHsAxbDz1pJ+BWHpqdJq6t+AHvNr1LO8TzoH/
	By/5d3RDf2JXNL2QQdSbvW4fzxqxXyU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-412-JU7OaHJmN9CTysupVW9oHg-1; Tue, 22 Oct 2024 03:48:56 -0400
X-MC-Unique: JU7OaHJmN9CTysupVW9oHg-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43157e3521dso38391435e9.1
        for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 00:48:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729583335; x=1730188135;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ftccds8EH7SC5Jyy8+I+ZK7tzNnlLXQBxvCZJjQtOYQ=;
        b=gi3E+BT/8j+EhsoqQTCmdJTOzmE7zdbF7B7MtjQj329b4MSw+x4FajqPAJd5OSVDkG
         yvErhzL+d6hpH6FDP5elo6MCPiLU+x4PCFfjMxpVyZgm5PZAlz6mdZ6imdVU0FFUxces
         L3tdIBHnpz+7vS/5gBQpLSbviLJXsX2j7xTcIAg9K9nZJ0fqp8/6C5+32NaYcSdBLDhv
         aywfKXzmcg/ZVNgWu81SGFTji3/RUHfp8fbSmsw58C0M+0a1MB6OLi5fQawpR/NUCua7
         NQCz1QtV34YSKix4H4yX8UY+Pm9GZQYNtdbRJ2zSkAnY8Az+sCIXs623ARKYIcjuI10R
         B2SQ==
X-Forwarded-Encrypted: i=1; AJvYcCXf/2miavM6WIsRjQd3VGNYNrVoPFmVNF1jjbbtJyOpFF5wH+ulM7zCjdq42wW+7BwT13+LdncnAQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzW+MviEKmxQbBbuF1wmsOIEf7l2pR9e2tnMBWUiZTnBZXfIB8Z
	U/RuyY4mNj2WZRzlqf0DSSqzRTp67opkKxlVhnTeGIQvSnrd/ETABD5cFt+Gv1lFzjrT5mSqzfl
	p1YrY76hj1sqTnfj758GGkiqH4X7T5H+x+U71tr7fmjT5rm4dQuI/YmJC
X-Received: by 2002:a05:600c:354e:b0:42b:a7c7:5667 with SMTP id 5b1f17b1804b1-431616a3a15mr110087745e9.25.1729583335322;
        Tue, 22 Oct 2024 00:48:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHuqlrJZe3z1cluxDCBu1kG7921j0DmfinfCppBqVQKzt/5Bfu3Vfr+sP95jBZDLtg0j2Ax7w==
X-Received: by 2002:a05:600c:354e:b0:42b:a7c7:5667 with SMTP id 5b1f17b1804b1-431616a3a15mr110087415e9.25.1729583334818;
        Tue, 22 Oct 2024 00:48:54 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:1b73:a910:d583:6ebb:eb80:7cd8? ([2a0d:3344:1b73:a910:d583:6ebb:eb80:7cd8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4316f57fbe8sm79095755e9.18.2024.10.22.00.48.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2024 00:48:54 -0700 (PDT)
Message-ID: <6c1e7d85-cfd3-4525-9f0b-5a88c3538286@redhat.com>
Date: Tue, 22 Oct 2024 09:48:52 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 14/15] io_uring/zcrx: add copy fallback
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
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
 <32ca8ddf-2116-43b9-b434-d8393cdbdde1@davidwei.uk>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <32ca8ddf-2116-43b9-b434-d8393cdbdde1@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/21/24 20:31, David Wei wrote:
> On 2024-10-21 07:40, Paolo Abeni wrote:
>> On 10/16/24 20:52, David Wei wrote:
>>> @@ -540,6 +562,34 @@ static const struct memory_provider_ops io_uring_pp_zc_ops = {
>>>  	.scrub			= io_pp_zc_scrub,
>>>  };
>>>  
>>> +static void io_napi_refill(void *data)
>>> +{
>>> +	struct io_zc_refill_data *rd = data;
>>> +	struct io_zcrx_ifq *ifq = rd->ifq;
>>> +	netmem_ref netmem;
>>> +
>>> +	if (WARN_ON_ONCE(!ifq->pp))
>>> +		return;
>>> +
>>> +	netmem = page_pool_alloc_netmem(ifq->pp, GFP_ATOMIC | __GFP_NOWARN);
>>> +	if (!netmem)
>>> +		return;
>>> +	if (WARN_ON_ONCE(!netmem_is_net_iov(netmem)))
>>> +		return;
>>> +
>>> +	rd->niov = netmem_to_net_iov(netmem);
>>> +}
>>> +
>>> +static struct net_iov *io_zc_get_buf_task_safe(struct io_zcrx_ifq *ifq)
>>> +{
>>> +	struct io_zc_refill_data rd = {
>>> +		.ifq = ifq,
>>> +	};
>>> +
>>> +	napi_execute(ifq->napi_id, io_napi_refill, &rd);
>>
>> Under UDP flood the above has unbounded/unlimited execution time, unless
>> you set NAPI_STATE_PREFER_BUSY_POLL. Is the allocation schema here
>> somehow preventing such unlimited wait?
> 
> Hi Paolo. Do you mean that under UDP flood, napi_execute() will have
> unbounded execution time because napi_state_start_busy_polling() and
> need_resched() will always return false? My understanding is that
> need_resched() will eventually kick the caller task out of
> napi_execute().

Sorry for the short reply. Let's try to consolidate this discussion on
patch 8, which is strictly related had has the relevant code more handy.

Thanks,

Paolo


