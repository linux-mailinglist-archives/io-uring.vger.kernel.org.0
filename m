Return-Path: <io-uring+bounces-1558-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA3BF8A5A36
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 20:51:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD2561C22D18
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 18:51:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC19015574F;
	Mon, 15 Apr 2024 18:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dgutVzEN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4361553A7;
	Mon, 15 Apr 2024 18:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713207103; cv=none; b=Ij6ab8z7oH7zGFBgc9XSlnS6/ns06Cm5jAIqTBcfetzIIKdx5K25rK8uSAuZTqHYsT2w++yDbDv3IGUEfO6BjCpa/l5VChPCnvid6VoFwdMSgDf0ls9LHkRDmnWbIFm8hUtoKSU5kh+m8p2qWvZI8s9pu76cOnMPHJs/v/lKNXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713207103; c=relaxed/simple;
	bh=/sAMLmfe/I+pOEqnDHDbhudUFRbhrGoYXArxpnK3J+s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AraZT0raahN5W78SO+0NUQlknRB+xeocsHb0TKn9Kz2WT5UAsVcUHCjdsfHUSOb8zxqKsZs2ckzy09S5IS/DxEqxSidRSQeav27XfcNx0sRwgdYSDKkDCz2NcSDjLzHl3XcayzZiPmJbPeUsbfx/l60AcXjHVGmrI76PV2jSY+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dgutVzEN; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2da0b3f7ad2so43729721fa.2;
        Mon, 15 Apr 2024 11:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713207100; x=1713811900; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Qerp/MnNEpG+kLFPIHEAwjKcl94+9gGxCNfRYtYcw5c=;
        b=dgutVzENlZfhAh1KW6DVncSmN0qAgj/8QytEARVcAjq2TF18gK8dpJr4Bmtn2PP8Hg
         caGZFtQ6jl8h74vTP5IfLA8X/7aT0oXqg7Halh2CUY1nLWhGpby2qR0BeAZ27wJxd2l1
         K4VLjGSEaAhf/9N5/0XZMuGBqLKgH5GpHEeWyENEt6pRgZOzSyvbrEhtf8eZyNUQw9Dk
         fJfu5BpBLzbS2u77srb0ubV1dRZMPRDXyVhIvKi6UBAKY8QU3PPwgzffMkSuCNGJTBIT
         fZVOQhjson+ySszxqcsk3Rtdp0coHLXVn60t0Fe7SUQsWkvxBcAvFOFj0VGg1SQrHgxx
         m+jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713207100; x=1713811900;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qerp/MnNEpG+kLFPIHEAwjKcl94+9gGxCNfRYtYcw5c=;
        b=dbiNETUNFiqbt48yQapcC+j+ERKvICxJ9eoEiMHAU3s9jahc+At1CroxUarpqn9e55
         Hg7LNtVI+PBXYh/Q88PxXknuEqqjnr2t1220/fcippIwY9Wt9gKwxdBY+ijNVpqbomB+
         AJplYUHZwH6YqqVUReKCY+e7QXtQPsU9i7i5fnoB2cE2oSXkijmONKQcC2bQ3Gtus5Ko
         kOFqCd76Bj1xVaOZEkR7CchiosL3xms4ud5mqkJMMOZHNQ1zinozOInaRav52dui6DIn
         Hq63ZlSx1hYT0NbT+KrLOqpzFoFqb2gqRKZ/Lu3v0CLo3n0frK2IUrcDk6NlFvNZfht9
         7+Mw==
X-Forwarded-Encrypted: i=1; AJvYcCVVCp7PuZ+6DHSrpERGA3ED7fNog6M/ychdGau6R0rwEmXDh1ADfdogONKmaqRw92G2CdlF7IUezNlAML7UsCPqR88v9Ca+1N+qMRaTzuZ5FnOldTLWEjgEngCu9NSOO54=
X-Gm-Message-State: AOJu0YzlbdFckVtqgmwmaqByn+K0+ZJGhWnFfCIljK5iC9QZInC4zlSv
	GqN9dInZoj4Q/UmLP/PdbfuByaV9PndYdmbkaboeOwunXXUIL0J0
X-Google-Smtp-Source: AGHT+IHUkC/DKxlwZIXNPFs1LZk8FhdL5AjIEsIIXRgNIDkRfpJ65qE7gDWGl2GV5yD9phBfFVHk5A==
X-Received: by 2002:a2e:3206:0:b0:2d9:fb62:2073 with SMTP id y6-20020a2e3206000000b002d9fb622073mr6140112ljy.47.1713207100035;
        Mon, 15 Apr 2024 11:51:40 -0700 (PDT)
Received: from [192.168.42.178] (82-132-219-157.dab.02.net. [82.132.219.157])
        by smtp.gmail.com with ESMTPSA id fm10-20020a05600c0c0a00b004180abdee2fsm12625288wmb.38.2024.04.15.11.51.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Apr 2024 11:51:39 -0700 (PDT)
Message-ID: <3b06ebe5-509e-45d2-9a41-5f2af67a36a4@gmail.com>
Date: Mon, 15 Apr 2024 19:51:43 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 6/6] io_uring/notif: implement notification stacking
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, "David S . Miller" <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@kernel.org>,
 Eric Dumazet <edumazet@google.com>
References: <cover.1712923998.git.asml.silence@gmail.com>
 <3e2ef5f6d39c4631f5bae86b503a5397d6707563.1712923998.git.asml.silence@gmail.com>
 <661c0e083f05e_3e77322946e@willemb.c.googlers.com.notmuch>
 <e686d9ba-f5fc-48c7-9399-06fcbed6ebd5@gmail.com>
 <661d448142aa_1073d2943a@willemb.c.googlers.com.notmuch>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <661d448142aa_1073d2943a@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/15/24 16:15, Willem de Bruijn wrote:
> Pavel Begunkov wrote:
>> On 4/14/24 18:10, Willem de Bruijn wrote:
>>> Pavel Begunkov wrote:
>>>> The network stack allows only one ubuf_info per skb, and unlike
>>>> MSG_ZEROCOPY, each io_uring zerocopy send will carry a separate
>>>> ubuf_info. That means that send requests can't reuse a previosly
>>>> allocated skb and need to get one more or more of new ones. That's fine
>>>> for large sends, but otherwise it would spam the stack with lots of skbs
>>>> carrying just a little data each.
>>>
>>> Can you give a little context why each send request has to be a
>>> separate ubuf_info?
>>>
>>> This patch series aims to make that model more efficient. Would it be
>>> possible to just change the model instead? I assume you tried that and
>>> it proved unworkable, but is it easy to explain what the fundamental
>>> blocker is?
>>
>> The uapi is so that you get a buffer completion (analogous to what you
>> get with recv(MSG_ERRQUEUE)) for each send request. With that, for skb
>> to serve multiple send requests it'd need to store a list of completions
>> in some way.
> 
> I probably don't know the io_uring implementation well enough yet, so
> take this with a huge grain of salt.
> 
> MSG_ZEROCOPY can generate completions for multiple send calls from a
> single uarg, by virtue of completions being incrementing IDs.
> 
> Is there a fundamental reason why io_uring needs a 1:1 mapping between
> request slots in the API and uarg in the datapath? 

That's an ABI difference. Where MSG_ZEROCOPY returns a range of bytes
for the user to look up which buffers now can be reused, io_uring posts
one completion per send request, and by request I mean an io_uring
way of doing sendmsg(2). Hence the 1:1 mapping of uargs (which post
that completion) to send zc requests.

IOW, and if MSG_ZEROCOPY's uarg tracks byte range it covers, then
io_uring needs to know all requests associated with it, which
is currently just one request because of the 1:1 mapping.

> Or differently, is
> there no trivial way to associate a range of completions with a single
> uarg?

Quite non trivial without changing ABI, I'd say. And a ABI change
wouldn't be small and without pitfalls.

>> One could try to track sockets, have one "active" ubuf_info
>> per socket which all sends would use, and then eventually flush the
>> active ubuf so it can post completions and create a new one.
> 
> This is basically what MSG_ZEROCOPY does for TCP. It signals POLLERR
> as soon as one completion arrives. Then when a process gets around to
> calling MSG_ERRQUEUE, it returns the range of completions that have
> arrived in the meantime. A process can thus decide to postpone
> completion handling to increase batching.

Yes, there is that on the completion side, but in the submission
you need to also decide when to let the current uarg go and
allocate a new one. Not an issue if uarg is owned by the TCP
stack, you don't have to additionally reference it, you know
when you empty the queue and all that. Not that great if
io_uring needs to talk to socket to understand when uarg is
better to be dropped.

>> but io_uring
>> wouldn't know when it needs to "flush", whenever in the net stack it
>> happens naturally when it pushes skbs from the queue. Not to mention
>> that socket tracking has its own complications.
>>
>> As for uapi, in early versions of io_uring's SEND_ZC, ubuf_info and
>> requests weren't entangled, roughly speaking, the user could choose
>> that this request should use this ubuf_info (I can elaborate if
>> interesting). It wasn't too complex, but all feedback was pointing
>> that it's much easier to use hot it is now, and honestly it does
>> buy with simplicity.
> 
> I see. I suppose that answers the 1:1 mapping the ABI question I
> asked above. I should reread that patch.
> 
>> I'm not sure what a different model would give. We wouldn't win
>> in efficiency comparing to this patch, I can go into details
>> how there are no extra atomics/locks/kmalloc/etc., the only bit
>> is waking up waiting tasks, but that still would need to happen.
>> I can even optimise / ammortise ubuf refcounting if that would
>> matter.
> 
> Slight aside: we know that MSG_ZEROCOPY is quite inefficient for
> small sends. Very rough rule of thumb is you need around 16KB or
> larger sends for it to outperform regular copy. Part of that is the
> memory pinning. The other part is the notification handling.
> MSG_ERRQUEUE is expensive. I hope that io_uring cannot just match, but
> improve on MSG_ZEROCOPY, especially for smaller packets.

I has some numbers left from this patchset benchmarking. Not too
well suited to answer your question, but still gives an idea.
Just a benchmark, single buffer, 100g broadcom NIC IIRC. All is
io_uring based, -z<bool> switches copy vs zerocopy. Zero copy
uses registered buffers, so no page pinning and page table
traversal at runtime. 10s per run is not ideal, but was matching
longer runs.

# 1200 bytes
./send-zerocopy -4 tcp -D <ip> -t 10 -n 1 -l0 -b1 -d -s1200 -z0
packets=15004160 (MB=17170), rps=1470996 (MB/s=1683)
./send-zerocopy -4 tcp -D <ip> -t 10 -n 1 -l0 -b1 -d -s1200 -z1
packets=10440224 (MB=11947), rps=1023551 (MB/s=1171)

# 4000 bytes
./send-zerocopy -4 tcp -D <ip> -t 10 -n 1 -l0 -b1 -d -s4000 -z0
packets=11742688 (MB=44794), rps=1151243 (MB/s=4391)
./send-zerocopy -4 tcp -D <ip> -t 10 -n 1 -l0 -b1 -d -s4000 -z1
packets=14144048 (MB=53955), rps=1386671 (MB/s=5289)

# 8000 bytes
./send-zerocopy -4 tcp -D <ip> -t 10 -n 1 -l0 -b1 -d -s8000 -z0
packets=6868976 (MB=52406), rps=673429 (MB/s=5137)
./send-zerocopy -4 tcp -D <ip> -t 10 -n 1 -l0 -b1 -d -s8000 -z1
packets=10800784 (MB=82403), rps=1058900 (MB/s=8078)


-- 
Pavel Begunkov

