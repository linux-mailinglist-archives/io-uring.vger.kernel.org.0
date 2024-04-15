Return-Path: <io-uring+bounces-1559-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3C7A8A5A3B
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 20:55:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2776AB21A26
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 18:55:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4371B155734;
	Mon, 15 Apr 2024 18:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eLUQh6nm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30A2B656;
	Mon, 15 Apr 2024 18:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713207313; cv=none; b=gNBOoRfahTlVpV8Qud8UMmgEAx1vrk7hHdf864xnaq0Uc2qnyFnYYNZ0GhFbYuog4mWeVjgYEDvhgYbIabKQ2aG+5Y0TuA8MJ2X4hASkthYmEYA1QJ8/gfbwKuZDZ44e4lU87+Cv9v8P/rLyHm2aWPzGxnPaMTL79J7zaN4btW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713207313; c=relaxed/simple;
	bh=5pFqabe5g74rFskG22+Jzp/m0kaK/re9xYQGajaEYYU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YDQgroSPKOUAOgqmV60UbyuvxUoa0aPKxOuKBrl0pYfU0wg7hnLQmcsGLopk9LLvhZ6w8kxVXrR9k9+GQF6ZBuIk8GVrABnu7Wq4i5KXLA+vOfdILMPD1yL2M63qT74sTPqa8XKh7YBC4mCDsDRtiHcjKQGr7q0WoDim8qzIvYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eLUQh6nm; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4187731a6e1so5774225e9.2;
        Mon, 15 Apr 2024 11:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713207310; x=1713812110; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c7Iz4TjO5ye9Vo8bqiMpOmP1OsauHtTpslPlofdnPWs=;
        b=eLUQh6nmcH7KtzlH5UuLMlXxYH2FqXdsnSA8y9sbwcw4MbO6w4tp1uoSEdT4+b+fjW
         xXzITtMcIP60mr9Wv4H8nB4ZAV4LwySLzbGj+9hUaklDqxxGVkyETCpQ/VHWi02jTgm8
         mOnmpG28mAaQFg63DCCtxrCfIgmW7WfL69ye7E+v7pASP7Vfq2tSHdqvX/fvsqYx1GHN
         vPKEqA2SqsNR2b/G7OUnKUq0H4QyuyOsXJ6xgppwh+7+V93iXcxzMF7kLCme7hZvslGG
         o2Xz/OIs8fxnpD3gbOa32rjPxtB0wBexQKtYMmpf0n1s4dauHcuPQXBBoQ21hI43RJ7u
         nRCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713207310; x=1713812110;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c7Iz4TjO5ye9Vo8bqiMpOmP1OsauHtTpslPlofdnPWs=;
        b=EH/F9ljZHrucb9ThYjsHfeGQ6ttXNMOWFSpCRDa4U3vlE2hFV3//NMyY/XKkYtEv3I
         FE+95MTBwbUgzilz0N9lLnCL+rQnB5HZ8ZPiEpDCPXy/teYBzaENgAPYbnSnPiRxEk8O
         2QXem8Dj92aHdPlhVzRUaMw7SkPpME82y4b2Oe+amkYMkcw8whoRov4aWC+ZV64k4JG/
         Cxt7nGC77FMhQBdQiRsbGInKuoQX0MOL3ESog+hLman7A85jYtXsHorblgxeF3PJ4baj
         NZ9ubrQGKMXTBQ1m6evoWmoGLX7XRDgi3zr5P67jeQ4jhc9eyI4dejqWnFmmfxDKlzha
         T7FA==
X-Forwarded-Encrypted: i=1; AJvYcCXN+EK0lgI2/pKl6jHrI5nTrUzm0t+x+3fg6+VeevM4On93nCvhOieOibSmg9o7z2PKz7bKHky464GNNAJcxc6Ksi0elRJUMsRv0sPoGjaIBX9kIYPqQMPHqCHEb2z0aoM=
X-Gm-Message-State: AOJu0YzB9yyabOR8YfSfY10IRG0q6yKmI/KssjUnS0MfSBejFTeV24gx
	1ptyr3GarDM3i+HDw4RqPchIOWO7P/D6FuaDFEz9c1oXuCbxuDja
X-Google-Smtp-Source: AGHT+IHoL7YV+v4IvWTa57gIAIs9GyTGm5xm7psOZd6B/w4AuDXe7L245Hg9ON3oeBBaGcsZGD6K3Q==
X-Received: by 2002:a05:600c:4715:b0:417:29a3:3f59 with SMTP id v21-20020a05600c471500b0041729a33f59mr6730972wmo.36.1713207309917;
        Mon, 15 Apr 2024 11:55:09 -0700 (PDT)
Received: from [192.168.42.178] (82-132-219-157.dab.02.net. [82.132.219.157])
        by smtp.gmail.com with ESMTPSA id fm10-20020a05600c0c0a00b004180abdee2fsm12634062wmb.38.2024.04.15.11.55.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Apr 2024 11:55:09 -0700 (PDT)
Message-ID: <bc8eb305-84e0-46ab-86b1-907dcf864452@gmail.com>
Date: Mon, 15 Apr 2024 19:55:13 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/6] net: extend ubuf_info callback to ops structure
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, "David S . Miller" <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@kernel.org>,
 Eric Dumazet <edumazet@google.com>
References: <cover.1712923998.git.asml.silence@gmail.com>
 <62a4e09968a9a0f73780876dc6fb0f784bee5fae.1712923998.git.asml.silence@gmail.com>
 <661c0d589f493_3e773229421@willemb.c.googlers.com.notmuch>
 <8b329b39-f601-436b-8a17-6873b6e73f91@gmail.com>
 <661d428c4c454_1073d2945f@willemb.c.googlers.com.notmuch>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <661d428c4c454_1073d2945f@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/15/24 16:06, Willem de Bruijn wrote:
> Pavel Begunkov wrote:
>> On 4/14/24 18:07, Willem de Bruijn wrote:
>>> Pavel Begunkov wrote:
>>>> We'll need to associate additional callbacks with ubuf_info, introduce
>>>> a structure holding ubuf_info callbacks. Apart from a more smarter
>>>> io_uring notification management introduced in next patches, it can be
>>>> used to generalise msg_zerocopy_put_abort() and also store
>>>> ->sg_from_iter, which is currently passed in struct msghdr.
>>>
>>> This adds an extra indirection for all other ubuf implementations.
>>> Can that be avoided?
>>
>> It could be fitted directly into ubuf_info, but that doesn't feel
>> right. It should be hot, so does it even matter?
> 
> That depends on the workload (working set size)?
>>> On the bright side,
>> with the patch I'll also ->sg_from_iter from msghdr into it, so it
>> doesn't have to be in the generic path.
> 
> I don't follow this: is this suggested future work?

Right, a small change I will add later. Without ops though
having 3 callback fields in uargs would be out of hands.

>> I think it's the right approach, but if you have a strong opinion
>> I can fit it as a new field in ubuf_info.
> 
> If there is a significant cost, I suppose we could use
> INDIRECT_CALL or go one step further and demultiplex
> based on the new ops
> 
>      if (uarg->ops == &msg_zerocopy_ubuf_ops)
>          msg_zerocopy_callback(..);

Let me note that the patch doesn't change the number of indirect
calls but only adds one extra deref to get the callback, i.e.
uarg->ops->callback() instead of uarg->callback(). Your snippet
goes an extra mile and removes the indirect call.

Can I take it as that you're fine with the direction of the
patch? Or do you want me to change anything?

-- 
Pavel Begunkov

