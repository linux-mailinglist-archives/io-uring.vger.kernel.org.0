Return-Path: <io-uring+bounces-8212-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 414F4ACDDF5
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 14:32:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7BBB11893C79
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 12:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 925A81E4A9;
	Wed,  4 Jun 2025 12:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V9wbjB7+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDA84C92;
	Wed,  4 Jun 2025 12:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749040320; cv=none; b=Qa6lYKXq0zGRsfvVLwCwdjFvZPl+uI5UDunjYZ4uHbvTjewi45SU9uiIhPXwLlmdmaPSKJke5Ban8rQvM8m6QFwAUn+WJXT6ZMU2y7c0NMfG+TZL0CP9Qfhx4me5CaZh6bFjccPc1e5PQCKiWJZA/UhM/gFwH71rbfD8R9ljJj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749040320; c=relaxed/simple;
	bh=fi52jnaMaFrQ/PB1arfuBcTPlI2lz9GVewFdRTLpi2Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jNZ5K0Hqps9WIYu05mGgz8y/ConVgwo1flOI3NSAqMOgcxjUAyzOEfDNErReJDVComGT1l4kJP7I3rF0QNBLvBonBFQNLBChjfeTJ7WqmixaIHJrkweb6AYmH+J1KA7ppw06iYUQxBoa3MSl6bR9xE7V9hqwcTc4M0DCts3EZ18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V9wbjB7+; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-addda47ebeaso591905366b.1;
        Wed, 04 Jun 2025 05:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749040317; x=1749645117; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8JfxGhRht7tR89L1a0RnOIrOYGcHKHQdm8iSsh68rGk=;
        b=V9wbjB7+JEE3AwAOrk54PweBPO8PLSO0sEJAUNSYsk1mqen8Cz/KA3av19EBzOQH4H
         3jRDiqdrgv2BOYiZCpgqHo6T9StqRAgjU1fApSPDiBmv/b63QjuTrvkn6xemNKF/RSKO
         DfESGmfb7UEPy9rZwRafjhBbtRX45VUBUXZd1bXK8v+wXUCRf/sFK3TopOksLoms3tIr
         d4NBLooZ/4mUElCPkdGafGoH2S2EVS1Rtf/19rzn/IsoUgPr8mObcJYKXW0LxpQ5NKyn
         fIa8h2xT1d1D5kBdxu9wazfYMVv8la4YuKfB80V3QJUjv+JVQpvJUd0AfNbYs+KfYmH8
         94Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749040317; x=1749645117;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8JfxGhRht7tR89L1a0RnOIrOYGcHKHQdm8iSsh68rGk=;
        b=g8zPc8+MNvctKCwmecmr2lq0lN+IOVZ9osdmNTxu56hQXixZQLJQnSbRaJvKquECzy
         eXN2qGmar3MgWSizo4MILsrLnTcbxybnMbFbcTKgOwjiOom3oEs4/nR4CmwfFi0IjO1g
         Vce+Gyw71/ouvLle5Y6+1pqNMAXJLD5+gE1qotACjHPliAuPaQYSb7UxFfEfV6U38+vi
         /t8dv6PVcCHlzTIdQr+wiAbK/IKNj5SeSUMrKgi+E18pOHlkeOHtt97D62nJW/Th7fpH
         Cn1eP8Wn95cNgEiVqUsbyhLsI2zMuS2xjgSg6iP1q36KptTMcfS/mj8N5THWdIEeslQj
         jq1A==
X-Forwarded-Encrypted: i=1; AJvYcCXi1qpJhBUBG47QdNQj8Uu36OO4jepauP3pLF58FSqGKpp/rZdQYesFmgkEGtr/N3gWWdVIQfoCIg==@vger.kernel.org
X-Gm-Message-State: AOJu0YylOrtKb1Q248vacvwVnaICghMySl9q5Vd5P7ygbNErFqc2DbQW
	gguOehagLu2HNnLu1hbK4ad5Gn6/4TIMeG2D4nLuROMdRTFszxU4VhoR
X-Gm-Gg: ASbGnctw6pTAbH31lCUCHZB9BcLNOuzaZ1BMvSiiI8/CFi9uwYPwY1nBE4uCoFKY5Ff
	EDquvdcVKUOQaHchAIlOnJSi/JFB+lwswtAZ5kTiQQpg581SwFRvJfab2fDjChxiESmOPtRuT95
	rc67ibF5FQhL9QLKKuuXlgRe41lgYrsW5UYq6mVzQl10Jqqjqj/Ws+TqL51XwyX+xAYOy8oJwVM
	8dMEEOWbFEqhlccH2XtwNVU+Ju8yhdaQ6R3BytYQzrJhoIXnX7ffk9SZdzMVe9tX2BnQvB9X9pF
	GBb/V9oDhgmJALA4/EhxZ/JKnvMphGoUNiyuMbHz9rOSA9jFolsnQlU9E0oYjaiT
X-Google-Smtp-Source: AGHT+IFTrv4iTW0OnuaN6PQs68ZH/pOhj9Jbd+AoRDH38F2PNdQrHQe95Gpedm7B1fzG7Q8fMIlwdA==
X-Received: by 2002:a17:907:3f1a:b0:acf:15d:2385 with SMTP id a640c23a62f3a-addf8d1dff1mr259361766b.16.1749040316611;
        Wed, 04 Jun 2025 05:31:56 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::26f? ([2620:10d:c092:600::1:b3d1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada6ad3949bsm1091080866b.129.2025.06.04.05.31.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jun 2025 05:31:55 -0700 (PDT)
Message-ID: <db7e43e3-89bf-4ec4-a225-0c352b6fc306@gmail.com>
Date: Wed, 4 Jun 2025 13:33:17 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] io_uring/netcmd: add tx timestamping cmd support
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, "David S . Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>
References: <cover.1749026421.git.asml.silence@gmail.com>
 <7b81bb73e639ecfadc1300264eb75e12c925ad76.1749026421.git.asml.silence@gmail.com>
 <b82bd278-1562-4901-971a-aa111c749747@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b82bd278-1562-4901-971a-aa111c749747@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/4/25 13:04, Jens Axboe wrote:
> On 6/4/25 2:42 AM, Pavel Begunkov wrote:
>> Add a new socket command which returns tx time stamps to the user. It
>> provide an alternative to the existing error queue recvmsg interface.
>> The command works in a polled multishot mode, which means io_uring will
>> poll the socket and keep posting timestamps until the request is
>> cancelled or fails in any other way (e.g. with no space in the CQ). It
>> reuses the net infra and grabs timestamps from the socket's error queue.
>>
>> The command requires IORING_SETUP_CQE32. All non-final CQEs (marked with
>> IORING_CQE_F_MORE) have cqe->res set to the tskey, and the upper 16 bits
>> of cqe->flags keep tstype (i.e. offset by IORING_CQE_BUFFER_SHIFT). The
>> timevalue is store in the upper part of the extended CQE. The final
>> completion won't have IORING_CQR_F_MORE and will have cqe->res storing
>                           ^^
> 
> CQE_F_MORE
> 
> Minor nit below.
> 
>> +static bool io_process_timestamp_skb(struct io_uring_cmd *cmd, struct sock *sk,
>> +				     struct sk_buff *skb, unsigned issue_flags)
>> +{
>> +	struct sock_exterr_skb *serr = SKB_EXT_ERR(skb);
>> +	struct io_uring_cqe cqe[2];
>> +	struct io_timespec *iots;
>> +	struct timespec64 ts;
>> +	u32 tskey;
>> +
>> +	BUILD_BUG_ON(sizeof(struct io_uring_cqe) != sizeof(struct io_timespec));
>> +
>> +	if (!skb_get_tx_timestamp(skb, sk, &ts))
>> +		return false;
>> +
>> +	tskey = serr->ee.ee_data;
>> +
>> +	cqe->user_data = 0;
>> +	cqe->res = tskey;
>> +	cqe->flags = IORING_CQE_F_MORE;
>> +	cqe->flags |= (u32)serr->ee.ee_info << IORING_CQE_BUFFER_SHIFT;
> 
> Get rid of the tskey variable?

Why? I named it specifically so that it's obvious what the field
means, and "cqe->res = serr->ee.ee_data" hardly tells the meaning
of the fields without extra digging.

And I think this would be more easily
> readable if it used:
> 
> 	cqe[0].user_data = 0;

I don't see how it'd be easier to read by cluttering the code
with "[0]" in multiple statements. Combined with that it's
one extended cqe and not some array of them.
  > etc.
> 
>> +	iots = (struct io_timespec *)&cqe[1];
>> +	iots->tv_sec = ts.tv_sec;
>> +	iots->tv_nsec = ts.tv_nsec;
>> +	return io_uring_cmd_post_mshot_cqe32(cmd, issue_flags, cqe);
>> +}
> 
> A bit of a shame we can't just get the double CQE and fill it in, rather
> than fill it on stack and copy it. But probably doesn't matter much.
> 

-- 
Pavel Begunkov


