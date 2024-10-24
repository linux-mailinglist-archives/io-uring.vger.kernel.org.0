Return-Path: <io-uring+bounces-3967-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B6E639AE937
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 16:43:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65B6A1F21ED7
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 14:43:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B6141DD0DF;
	Thu, 24 Oct 2024 14:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="w1WYOcU/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02011D9A72
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 14:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729781029; cv=none; b=OPt9Ajo9JCnu9hGrReozzzvzosbYVOS5cZDxa7sWnqdB64XlFmPBM7698tKf0lOL6tQSHGJR3HBsueSVdsCIqlQIkS4U1CsbCLmBxW3uYMA8yD000oOEAlMbvyYLERok8Wsr8rAKva1jR6Ku1CoNH6u4ZtqsTCPFEED/8WrkcB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729781029; c=relaxed/simple;
	bh=zR1bxIz7AsMpP5s9k8Vm64Z6H++Ddw2cS1G06GReHLs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=j0p+wMdzOuRrPqLRMapef2sth83N3k5E9pYKqfriuQw6UM02Xe6rqUyw01FGoXNi5ZkYemTSA98VNGJY+VJXcW4nVrawK1sr2dPrP0638B5X7lcwR69x1IfUv77LqSQHGl7/Ze/0ddlsrgJ6cXsM+AklAUVh29SfDmg6boICZzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=w1WYOcU/; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-83abcfb9f37so39915539f.1
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 07:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729781025; x=1730385825; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6CO/yKLfToyFRKAxDmcX8z2fxbf7kMfbd0LZF9mw8wQ=;
        b=w1WYOcU/sgZecV4QS7AS6lx5oXjUCPXHmf88DuzGSD6MDZlt+sWBi4v9Gqui9QoXmv
         ipazEmCnBtA/Ejl23/4eg7lxXLiMAdXP0OyaLyfflKc2UkwSnw+T54jVWuVdMgPkp1FR
         N02m/wgUsNyu/aM4bD1wxbpOeB075Xej9U6/CjHEv362DmVmZ8MGSgXK5ktgLykW58UC
         TdfpZnxuysWnFEI4Gc4ZqlMq5mJlrD4Cw/+TvzjnIuYkr+8HTbkZP555W3bq52nTkulU
         5/v/naiBcZ9KgCFBdo6DTnblBh/rFdsgxVphOXZ/qOrEg2CePc3A+mKLAjjra9jQgh8P
         AMXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729781025; x=1730385825;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6CO/yKLfToyFRKAxDmcX8z2fxbf7kMfbd0LZF9mw8wQ=;
        b=SDy+tmmUTr9fXUyU+k63hVo4smkDJXpvQ4AY1ctabm96eWpGPxyGaeuvaKXwHXOfv2
         8BFCpkD4B8UcmQqdutGRNsZWZ9n/Y2LS7ySAmVkvINAe1NrXn0K6x775/E455GzzU0yo
         ANgPp6cox+PGcuyjZzqDehSCgLleYhruQF00epwWgTnpMAeCCBmcWMR0mrAVJMSM9c0s
         bYNARbXw971OpfZ5c8UY3EYvI9MpQADZ+oIE/RjPizY37ZS9Oaw6WZB0+Bi07hmUsQHU
         ShTyjDKbgZC6RNFntFGPcLs8Bc40U3T1reVdiTJd5jNU+Us67ciEnvNzzbBhS7ERbYMi
         5z9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUez+58Cri84OO0WTxGgad/w4V99zQQ5PG39ilzYItLZdS3Iiv9oWa3l2M8sYs2poKCttcmUqiIvw==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywio3ak6nAwS8SaySvZrMFXh5jZ05I9B9Fr1e7OOgVAt68TzAE5
	u0rLzzdl0YkIhygj+oive+wrMuaOAH8oLQ2YapuPvBqWnNu/OsFAmFnIERb9iafI5whnXBG2r7I
	q
X-Google-Smtp-Source: AGHT+IGN0s78tmplJdnm//6GtV8VrVqZZfXl38vhGvFaDXbVKMthhazhZ+d8qMEsvi7WGX42XlQobQ==
X-Received: by 2002:a05:6602:6201:b0:83a:b149:fcf9 with SMTP id ca18e2360f4ac-83b04077ac6mr250020139f.11.1729781025570;
        Thu, 24 Oct 2024 07:43:45 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83ad1dce129sm283223139f.34.2024.10.24.07.43.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 07:43:45 -0700 (PDT)
Message-ID: <954749c7-ee49-4526-9394-4dec4304a1b4@kernel.dk>
Date: Thu, 24 Oct 2024 08:43:44 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET RFC 0/7] Add support for provided registered buffers
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20241023161522.1126423-1-axboe@kernel.dk>
 <9e6ba7d3-22ae-4149-8eab-ed92a247ac61@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <9e6ba7d3-22ae-4149-8eab-ed92a247ac61@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/24/24 8:36 AM, Pavel Begunkov wrote:
> On 10/23/24 17:07, Jens Axboe wrote:
>> Hi,
>>
>> Normally a request can take a provided buffer, which means "pick a
>> buffer from group X and do IO to/from it", or it can use a registered
>> buffer, which means "use the buffer at index Y and do IO to/from it".
>> For things like O_DIRECT and network zero copy, registered buffers can
>> be used to speedup the operation, as they avoid repeated
>> get_user_pages() and page referencing calls for each IO operation.
>>
>> Normal (non zero copy) send supports bundles, which is a way to pick
>> multiple provided buffers at once and send them. send zero copy only
>> supports registered buffers, and hence can only send a single buffer
> 
> That's not true, has never been, send[msg] zc work just fine with
> normal (non-registered) buffers.

That's not what I'm saying, perhaps it isn't clear. What I'm trying to
say is that it only supports registered buffers, it does not support
provided buffers. It obviously does support regular user provided
buffers that aren't registered or provided, I figured that goes without
saying explicitly.

>> at the time.
> 
> And that's covered by the posted series for vectored registered
> buffers support.

Right, for sendmsg.

>> This patchset adds support for using a mix of provided and registered
>> buffers, where the provided buffers merely provide an index into which
>> registered buffers to use. This enables using provided buffers for
>> send zc in general, but also bundles where multiple buffers are picked.
>> This is done by changing how the provided buffers are intepreted.
>> Normally a provided buffer has an address, length, and buffer ID
>> associated with it. The address tells the kernel where the IO should
>> occur. If both fixed and provided buffers are asked for, the provided
>> buffer address field is instead an encoding of the registered buffer
>> index and the offset within that buffer. With that in place, using a
>> combination of the two can work.
> 
> What the series doesn't say is how it works with notifications and
> what is the proposed user API in regard to it, it's the main if not
> the only fundamental distinctive part of the SENDZC API.

Should not change that? You'll should get the usual two notifications on
send complete, and reuse safe.

-- 
Jens Axboe

