Return-Path: <io-uring+bounces-1541-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CE98E8A4639
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 01:55:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5BC1B21836
	for <lists+io-uring@lfdr.de>; Sun, 14 Apr 2024 23:55:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CB6313698F;
	Sun, 14 Apr 2024 23:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k4UcOGeJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A27134433;
	Sun, 14 Apr 2024 23:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713138924; cv=none; b=sxcf62HADLGerUNq7LATdgPG40W8co1GE8/kvR9l8M0nXqRBCI27TBzdgU8nwjQ55eCtn9rLpEbVOgBWWVP97LHjC4g7b35jJhSCDe+Lvswf1vgx7pLR+J9BDPsZfOFBSZOBu9p7ilRbLaltaVpNZxYbyYl7IzpTchnRGhru4x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713138924; c=relaxed/simple;
	bh=x/ZaivhLVqGcYww6tuaww8ga6KDYPIEMngqcbFtdkNE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cJ9clkCGRrqg1UjqnJxEQ5OQttNFabDmJpQeB4HQSFRW54ACzIPTrmTSscq6oqt9UYJtZHDTwYhyYC+foxcVTtavoGr1mow3rq4Z4GdL8JDgr0pisbcn6vlOtXfnNGcutHdbvzGfbnSxffk4aHY1wkOKnV9D/jPjvi1lTZl+nok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k4UcOGeJ; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-343eb6cc46bso1837653f8f.2;
        Sun, 14 Apr 2024 16:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713138921; x=1713743721; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Qk0hsuz00TRW+haVYjAhBcrIuoH2nHlh3kbDkUGYqrg=;
        b=k4UcOGeJe1MXBz5vFP78Y5TreHiGEKUcKm3IZ9bWj6Bjd4I0K0rli4iUKo58KfCncV
         wkeap8gFC6N/zE7sv01OWnoWhEVdZO9TUqXr4fQRuTqlmVCHG/lk2XCYoy4VSLmBtceH
         LIrlCzBmToB5lkvyYsvwyg8TemkqFdJwTKxEZxqS+lHwiHCW7pRkQctIJX92GZFStOVk
         jMjrNmbsWqkeUXiJF2Q/rwYcDgvFQhNHhvWJtc8b+nnAVk9E+HzY3KstFygVbHOIDkAG
         4S/E9j1UO66EMHWsNAnaWPdmisS9PtdFdriY5wVHcvs2NUE1k2Ee4jh15Q59k856MBmR
         snaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713138921; x=1713743721;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qk0hsuz00TRW+haVYjAhBcrIuoH2nHlh3kbDkUGYqrg=;
        b=nQzHJLVToWk8OheSzu1Hr7J7oJuo/m/oxEgD6vMoIONs+QWtR8ZKk9PyoTRNhfxl0u
         xZEnazRR4YGk4cOFKOJqZSBddrJ1LKKgiBFL2JdYpt4q2q6VFGbPAKMrc3bLEMcJkner
         YIFG9FNOK1AxWCDvBWWCQ+ooRIm94CbLuyHKrXxwqBpVuKEgLZHoy1EH5OyztmfQRnyI
         srABQlV6V0LNk2sUspfK1QQ6ZqVXLu30jX+qE/IUgHyJpAVNGtbKEeagyjO9p1Bqqc+q
         HcoDvlk4yOz1Hb9gXKFs82GHANOZ9aWVkbkNBUI8azStyeCB8Oh57nzZuwtsKSe0vgEz
         e91g==
X-Forwarded-Encrypted: i=1; AJvYcCUCSMiwGxhyO4IFDjSo3VY8vf1TddZJ3+W577BuvfJAUL3rop530nQIQY1Ee9vDE16nZeZpSwfpThMDQiD0dkxfWvTx78uhJGfoytIxVo/VEbBzbvXfGn0vWBqM6MDcUmo=
X-Gm-Message-State: AOJu0YwbjCG0dQ+VHgmTophFqCFYq8W2Fa3D384Z5bvMlUFqQIlwcNNF
	sWcPEdys/474QQwnxfByYDxReDYF7i1Dn2PCUYzR7b+9IsubTc8a1pi/hA==
X-Google-Smtp-Source: AGHT+IFVHj266RMtsOlBEdxA7w27ArsH1N7+4IcEmm2RDrcVgkXpPeXxRs/ymlU2XPCXPXOyxCqcow==
X-Received: by 2002:a5d:6d84:0:b0:343:6ca4:97e8 with SMTP id l4-20020a5d6d84000000b003436ca497e8mr6529644wrs.45.1713138921100;
        Sun, 14 Apr 2024 16:55:21 -0700 (PDT)
Received: from [192.168.42.114] ([85.255.232.172])
        by smtp.gmail.com with ESMTPSA id u13-20020a5d434d000000b00346bda84bf9sm10154480wrr.78.2024.04.14.16.55.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Apr 2024 16:55:20 -0700 (PDT)
Message-ID: <e686d9ba-f5fc-48c7-9399-06fcbed6ebd5@gmail.com>
Date: Mon, 15 Apr 2024 00:55:22 +0100
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <661c0e083f05e_3e77322946e@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/14/24 18:10, Willem de Bruijn wrote:
> Pavel Begunkov wrote:
>> The network stack allows only one ubuf_info per skb, and unlike
>> MSG_ZEROCOPY, each io_uring zerocopy send will carry a separate
>> ubuf_info. That means that send requests can't reuse a previosly
>> allocated skb and need to get one more or more of new ones. That's fine
>> for large sends, but otherwise it would spam the stack with lots of skbs
>> carrying just a little data each.
> 
> Can you give a little context why each send request has to be a
> separate ubuf_info?
> 
> This patch series aims to make that model more efficient. Would it be
> possible to just change the model instead? I assume you tried that and
> it proved unworkable, but is it easy to explain what the fundamental
> blocker is?

The uapi is so that you get a buffer completion (analogous to what you
get with recv(MSG_ERRQUEUE)) for each send request. With that, for skb
to serve multiple send requests it'd need to store a list of completions
in some way. One could try to track sockets, have one "active" ubuf_info
per socket which all sends would use, and then eventually flush the
active ubuf so it can post completions and create a new one. but io_uring
wouldn't know when it needs to "flush", whenever in the net stack it
happens naturally when it pushes skbs from the queue. Not to mention
that socket tracking has its own complications.

As for uapi, in early versions of io_uring's SEND_ZC, ubuf_info and
requests weren't entangled, roughly speaking, the user could choose
that this request should use this ubuf_info (I can elaborate if
interesting). It wasn't too complex, but all feedback was pointing
that it's much easier to use hot it is now, and honestly it does
buy with simplicity.

I'm not sure what a different model would give. We wouldn't win
in efficiency comparing to this patch, I can go into details
how there are no extra atomics/locks/kmalloc/etc., the only bit
is waking up waiting tasks, but that still would need to happen.
I can even optimise / ammortise ubuf refcounting if that would
matter.

> MSG_ZEROCOPY uses uarg->len to identify multiple consecutive send
> operations that can be notified at once.

-- 
Pavel Begunkov

