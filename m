Return-Path: <io-uring+bounces-3580-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BD4969999CF
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 03:49:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF5531C22E77
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 01:49:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E52BD12B63;
	Fri, 11 Oct 2024 01:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OjPnivWL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0DB3D6D;
	Fri, 11 Oct 2024 01:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728611328; cv=none; b=OYejc49WcyB+16UnELVsrodPi3R0YEERQzqOqp5GGSII3SCfsA60U8HLxuDWDhJgC38q27ERcwMDuOFW2LbfhlRYr41Pg7XyciVLfee1zMhIbqq+w42x5QhuNsxrx/A9P5rDYgHooBAAQ2ZyGyNBc5u50DkUKuB2Tb9SRx58Wmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728611328; c=relaxed/simple;
	bh=ebYQGJR4/2idytoCa5qitHrSGwmqiKg3LREX68gTw0g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OAQnMOkk9a6CoBL8m5GYTE05HFMyY8dymAcixgFUD1xGxtPiSjbgENLTaD0dJkvuhgpNz1l2I7KKyQE/HlkR3g+NpuxTiUi75Z3IJygNjV+1QySzODBUAMhniJT9AC/UQK+jTLLSJ+2XCy2b8Sd8aaGweWbQxAYDy03rSjE7Etc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OjPnivWL; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a994ecf79e7so248516066b.0;
        Thu, 10 Oct 2024 18:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728611325; x=1729216125; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=osklON086igs20FO8CPmxbOkuqxHN/ddjVQSkArzwHk=;
        b=OjPnivWLY1nPgix56i2hZEaMAi/kBIqVlXPkb+BjRFIVZ25c20DAT/365isCkmTHRp
         b4jYKTckvP0Awf6WG2EDiLaz3XrakyeOClaSK1gnc2ilIso5Roud5eqeENJ8kl8FuKFG
         50MBAgBUh6ehRu5PgCyQfDiDgK7Mkd3EqtD7u2w5HvUg/0cC+31KjFaBZZCTFLPlwjUf
         AU6EQ/LZ05QzxjF0m9mXzmp/RgbKwWB2e+G3MRIKj1o+gKIcfsyNKBy+2vz7lKmm9wia
         oBPN2Hc6ZKMlb4Tkr2OXMe/S59TPPLvu4f5UZND6GwBIoKBBKm/Cil2K5PgmVhbFeKbz
         TcsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728611325; x=1729216125;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=osklON086igs20FO8CPmxbOkuqxHN/ddjVQSkArzwHk=;
        b=aIr/YhOyzwSCMp8sNRnM7hSmAVJTIW5E8+pq66Ew0Uc9mMK+nrrT82sk4ILUGp9uEt
         yOlbN0wvPvk5TUexU65wslmCyrj1XAeOvPxtuy9fAK9KSqtpuc2Rn0N2USyB1EkNKEP6
         Glo326uOXmzdgiYcqElU3CEj3oo0FGZ75kch9PckJ/gTGwwdhr2gtT05NyPnQaF64kS/
         8iVAON5B5ircS7lNoypw/7mFXaQwTqmHX85tw0Lox5sDavn2mMKN54QFGa3BucKkSC5s
         xkky1wx59oNl2OjlavJeSh0zwxf56DUthPsih0Z9kIepjBBNNxBwGLzKRneJsJi6kWUE
         nVtg==
X-Forwarded-Encrypted: i=1; AJvYcCUGtnLZHdezU/BQ21sUmSBKBPbakjphG9OU6bCrwlMacQ11pxFdhRRgrXS1aG66KTECeosfyEmJ+g==@vger.kernel.org, AJvYcCXYU81jApF+9KdR3uNv4YFtxt9aD7X5g+wF88qpEzTL0ObMwohgU0NKYWdHx1Of2/uLecgDMvEB@vger.kernel.org
X-Gm-Message-State: AOJu0YxLV1o4C+pSWBhzCAkX5lGCaracAoS2YGsXjxmOgspvH6tEH97n
	OKPfIBmEr1M4RasluLI+Mal8NA84xJw2pgfPznpPJyt+T5RqLl/UC21eeg==
X-Google-Smtp-Source: AGHT+IHoWvXwc5MNOg0puS283x6JHqn6vQP8kx30yuYMxQl0It5z4tmco6z5Bjc2Z7ln9sCeltSdjw==
X-Received: by 2002:a17:906:c10c:b0:a99:5f2a:444d with SMTP id a640c23a62f3a-a99b966b13dmr71776266b.56.1728611324868;
        Thu, 10 Oct 2024 18:48:44 -0700 (PDT)
Received: from [192.168.42.108] ([148.252.140.94])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99a80dc62dsm154785166b.163.2024.10.10.18.48.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2024 18:48:44 -0700 (PDT)
Message-ID: <6254de3f-c44f-4090-9ba7-7e69d04a9ba0@gmail.com>
Date: Fri, 11 Oct 2024 02:49:17 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 11/15] io_uring/zcrx: implement zerocopy receive pp
 memory provider
To: Mina Almasry <almasrymina@google.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-12-dw@davidwei.uk>
 <CAHS8izO-=ugX7S11dTr5cXp11V+L-gquvwBLQko8hW4AP9vg6g@mail.gmail.com>
 <94a22079-0858-473c-b07f-89343d9ba845@gmail.com>
 <CAHS8izPjHv_J8=Hz6xZmfa857st+zyA7MLSe+gCJTdZewPOmEw@mail.gmail.com>
 <f89c65da-197a-42d9-b78a-507951484759@gmail.com>
 <CAHS8izMrPuQNvwGwAUjh7GAY-CoC81rc5BD1ZMmy-nNds3xDgA@mail.gmail.com>
 <096387ce-64f0-402f-a5d2-6b51653f9539@gmail.com>
 <CAHS8izMi-yrCRx=VzhBH100MgxCpmQSNsqOLZ9efV+mFeS_Hnw@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izMi-yrCRx=VzhBH100MgxCpmQSNsqOLZ9efV+mFeS_Hnw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/11/24 01:32, Mina Almasry wrote:
> On Thu, Oct 10, 2024 at 2:22 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>>> page_pool. To make matters worse, the bypass is only there if the
>>> netmems are returned from io_uring, and not bypassed when the netmems
>>> are returned from driver/tcp stack. I'm guessing if you reused the
>>> page_pool recycling in the io_uring return path then it would remove
>>> the need for your provider to implement its own recycling for the
>>> io_uring return case.
>>>
>>> Is letting providers bypass and override the page_pool's recycling in
>>> some code paths OK? IMO, no. A maintainer will make the judgement call
>>
>> Mina, frankly, that's nonsense. If we extend the same logic,
>> devmem overrides page allocation rules with callbacks, devmem
>> overrides and violates page pool buffer lifetimes by extending
>> it to user space, devmem violates and overrides the page pool
>> object lifetime by binding buffers to sockets. And all of it
>> I'd rather name extends and enhances to fit in the devmem use
>> case.
>>
>>> and speak authoritatively here and I will follow, but I do think it's
>>> a (much) worse design.
>>
>> Sure, I have a completely opposite opinion, that's a much
>> better approach than returning through a syscall, but I will
>> agree with you that ultimately the maintainers will say if
>> that's acceptable for the networking or not.
>>
> 
> Right, I'm not suggesting that you return the pages through a syscall.
> That will add syscall overhead when it's better not to have that
> especially in io_uring context. Devmem TCP needed a syscall because I
> couldn't figure out a non-syscall way with sockets for the userspace
> to tell the kernel that it's done with some netmems. You do not need
> to follow that at all. Sorry if I made it seem like so.
> 
> However, I'm suggesting that when io_uring figures out that the
> userspace is done with a netmem, that you feed that netmem back to the
> pp, and utilize the pp's recycling, rather than adding your own
> recycling in the provider.

I should spell it out somewhere in commits, the difference is that we
let the page pool to pull buffers instead of having a syscall to push
like devmem TCP does. With pushing, you'll be doing it from some task
context, and it'll need to find a way back into the page pool, via ptr
ring or with the opportunistic optimisations napi_pp_put_page() provides.
And if you do it this way, the function is very useful.

With pulling though, returning already happens from within the page
pool's allocation path, just in the right context that doesn't need
any additional locking / sync to access page pool's napi/bh protected
caches/etc.. That's why it has a potential to be faster, and why
optimisation wise napi_pp_put_page() doesn't make sense for this
case, i.e. no need to jump through hoops of finding how to transfer
a buffer to the page pool's context because we're already in there.

>  From your commit message:
> 
> "we extend the lifetime by recycling buffers only after the user space
> acknowledges that it's done processing the data via the refill queue"
> 
> It seems to me that you get some signal from the userspace that data

You don't even need to signal it, the page pool will take buffers
when it needs to allocate memory.

> is ready to be reuse via that refill queue (whatever it is, very
> sorry, I'm not that familiar with io_uring). My suggestion here is
> when the userspace tells you that a netmem is ready for reuse (however
> it does that), that you feed that page back to the pp via something
> like napi_pp_put_page() or page_pool_put_page_bulk() if that makes
> sense to you. FWIW I'm trying to look through your code to understand
> what that refill queue is and where - if anywhere - it may be possible
> to feed pages back to the pp, rather than directly to the provider.

-- 
Pavel Begunkov

