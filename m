Return-Path: <io-uring+bounces-5392-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C3E49EA73E
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 05:44:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F8582852B0
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 04:44:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF89D1BEF7E;
	Tue, 10 Dec 2024 04:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OtyF6os4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0001469D;
	Tue, 10 Dec 2024 04:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733805876; cv=none; b=buSxN3JksZjpzQ/ejSCr8wVAVISJyml+SarVbKi8u7lm2u+0yIegv3idPLaZCiWlimVi2UBDS5XeD+d1Pv0xGALmTh0ecOz20FOsvw6fS1V/6r1Madz227bCschoYewe1Ex+TY5nbQTq6W6aC81qh+IooKVDnTTwk0FXTR3YKDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733805876; c=relaxed/simple;
	bh=usmoSvRfsyuaG0FH+OsJ5bunv3PxoIq8+T1/Wn+vupI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kQzggjeFi8dDCLC7DZ595UGVz9qOzlRc8xQsVwkVolXO3yrOdj8JrP/h02oiG54Vr9/T/t1Yp8MTv4etDxs3Nl6Hh72OmlKlUD4AbUMiiuHg7SqOhl9IKeXCUHEEocZWhzlQlpgIyldOd34J2xbXtxQZPOuDHgynGWaQlWPW+IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OtyF6os4; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-385e27c75f4so3816115f8f.2;
        Mon, 09 Dec 2024 20:44:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733805872; x=1734410672; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lxGxgVGAkcffuohfV6paO9a73qZMmaQvMcR8flfxmcU=;
        b=OtyF6os4oE8aq7tbGb0tjPt7kdTDhH1h8VjD1Ya5kF89SXjKGXYkZu/BYzFfK6DEOH
         Nx1xC6g/s1S2wvHIRoVWyRl+TFQFzWaeDT7oUbFUZ8MxPb5Le3F0+aOrKnBWI6ZC4iIU
         MHkrxNbzS8tIzxaXmt0RKzrp9S06dD+6sRq8j4pgS+7HW4g73NOOV3j5tdhefek584/f
         2YLxInkVsFPh6p3FOJmnItkXIrCT4JIvSzfUJnuI9V56HzkiIa9EzlWXCKUrJxcLK8hH
         h4j9N33SG9ULuEWsI5WFS9HSzTGhKQICGZWwK1bs6bsEnv48k3P3hP+DJKWQqG/St0t5
         WA7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733805872; x=1734410672;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lxGxgVGAkcffuohfV6paO9a73qZMmaQvMcR8flfxmcU=;
        b=q5YEBew7HfcSuU83WtRwxawnlQWNbsWX6Kpctrx4RpiDuAQdH1RKVxOJavMoqL7o2i
         iGTF7h/02c/eb5qe1Mh4YnGmFAMi8qZpbhxGQ6JjcB5MyJ0Vsp6vTYEE52++9an7BjDI
         U4JUVNGaE7HQIArawJfA6q11imzvgzv6tjMzFvDm1hlM/OBqQ+2WW3PqWeSaUBCkvSQO
         +TZf+dELhKGCTRVtqjoH1USpXDZsQixpm6JcJrr8tHVMQPwH4/dCzhF8FylgxFmi8s67
         tqi37T3Tb9zpd4v9wiCrsxd5Gc4+iH3GzDTcwFHE6nsSEiBsfUDiCvLqI5K+/szXEp7k
         uiew==
X-Forwarded-Encrypted: i=1; AJvYcCXlNjjk24UD8DuKv+ayib2AdrEJcW69jZf4JFde0GY3o7BBdwIUwRx3mrDqec80pQuLuAtdhug=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYhGoRevq7J9a9klPIJSowpUF0Pi0kV1UBmDPF0bAgRNpoC72O
	juaWpwQwFg8s9Bbax+chMtF3c1Qx4RALbHUwasdHc4BD+Va2Y2B7
X-Gm-Gg: ASbGncuB2Y2iLAsptajYuSpGveF8rdhS7Oiuu7Yp9ApU05ji2n2wSahTKcKJn17repk
	1O0ImkVos1yxFUeiZGOZq+x2z6tEKkAu6bxt31fB5Xu9L5A/NvIWURV3ruQm9VNWE/CaSBfQmAR
	QGB+EHDwLDrYz761PSmxn+yq4Inl2TkBcJ5Fo0KS6tIjI3C4uN+wGzQH0HCmzGixcZL70TP+caA
	Y0jeLL2DrDHDFmR1ZtIY8PTAb44Tve/StDN3b7DX4HXZSl+hdqJbEoJTCBCdy0=
X-Google-Smtp-Source: AGHT+IFo7Hkvdq7Tk0icSNEGs5umpoB2Gtw2Bof2liSPpgTQBGU0HZo+uyxfslSLBEjWwdmyH4fusw==
X-Received: by 2002:a5d:59a3:0:b0:386:37bb:ddc1 with SMTP id ffacd0b85a97d-386454000a2mr2128937f8f.56.1733805872171;
        Mon, 09 Dec 2024 20:44:32 -0800 (PST)
Received: from [192.168.42.90] ([85.255.235.153])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3862a9705dfsm12579374f8f.4.2024.12.09.20.44.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2024 20:44:31 -0800 (PST)
Message-ID: <aa20a0fd-75fb-4859-bd0e-74d0098daae8@gmail.com>
Date: Tue, 10 Dec 2024 04:45:23 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v8 11/17] io_uring/zcrx: implement zerocopy
 receive pp memory provider
To: Jakub Kicinski <kuba@kernel.org>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241204172204.4180482-1-dw@davidwei.uk>
 <20241204172204.4180482-12-dw@davidwei.uk>
 <20241209200156.3aaa5e24@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241209200156.3aaa5e24@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/10/24 04:01, Jakub Kicinski wrote:
> On Wed,  4 Dec 2024 09:21:50 -0800 David Wei wrote:
>> Then, either the buffer is dropped and returns back to the page pool
>> into the ->freelist via io_pp_zc_release_netmem, in which case the page
>> pool will match hold_cnt for us with ->pages_state_release_cnt. Or more
>> likely the buffer will go through the network/protocol stacks and end up
>> in the corresponding socket's receive queue. From there the user can get
>> it via an new io_uring request implemented in following patches. As
>> mentioned above, before giving a buffer to the user we bump the refcount
>> by IO_ZC_RX_UREF.
>>
>> Once the user is done with the buffer processing, it must return it back
>> via the refill queue, from where our ->alloc_netmems implementation can
>> grab it, check references, put IO_ZC_RX_UREF, and recycle the buffer if
>> there are no more users left. As we place such buffers right back into
>> the page pools fast cache and they didn't go through the normal pp
>> release path, they are still considered "allocated" and no pp hold_cnt
>> is required. For the same reason we dma sync buffers for the device
>> in io_zc_add_pp_cache().
> 
> Can you say more about the IO_ZC_RX_UREF bias? net_iov is not the page
> struct, we can add more fields. In fact we have 8B of padding in it
> that can be allocated without growing the struct. So why play with

I guess we can, though it's growing it for everyone not just
io_uring considering how indexing works, i.e. no embedding into
a larger struct.

> biases? You can add a 32b atomic counter for how many refs have been
> handed out to the user.

This set does it in a stupid way, but the bias allows to coalesce
operations with it into a single atomic. Regardless, it can be
placed separately, though we still need a good way to optimise
counting. Take a look at my reply with questions in the v7 thread,
I outlined what can work quite well in terms of performance but
needs a clear api for that from net/

-- 
Pavel Begunkov


