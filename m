Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB8E1400AF
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2020 01:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729559AbgAQAQr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jan 2020 19:16:47 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46049 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbgAQAQq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jan 2020 19:16:46 -0500
Received: by mail-pl1-f196.google.com with SMTP id b22so9064316pls.12
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2020 16:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=We+X+vIvTn3VnSo1BpMXBHpt3KILQFV1ZkuQwzzKTUM=;
        b=u6+Q+vdSHEzkzK36tr0G9danJzdqCAJBQ0ETzYFrMcbn/t3XlBjn1Jk1C6EjfUaOb/
         TPJ085yRpJSKTy049KHITcnFL4twlf3IR9T9XBaKW0Fj6bWzLSkmc1RzHz97+8e8CNUR
         /r5aPeUX/9t328wa7OmG8hP8VoIkdZSBP1WDQFUgw9UyjMIBsWNyXoFthjwcPMcflpAN
         vcNcj90F8262UuN5rZ2+taBRpxdNFxLAeTwEN82PKwIhdxMqK6ehmHt2pnDtTCMX9w9Y
         E0EJizP4GCD5t9rrs4npEW69xz+xMR8S7ZHNGOQ6LmTUVtl98Curjp7Rv6R9zTHHPNYL
         NTlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=We+X+vIvTn3VnSo1BpMXBHpt3KILQFV1ZkuQwzzKTUM=;
        b=ri5mSo7HbK6V00AX9q1acq3rsUVxSyiYRkaP7VY6lzlFGKpK+WpgFwn5/+SRdveldh
         6M2pfxJqwae6PRZYy+oF0TIE+E8dLPhUFTkIEsKhwJwOoaVtZrNMulFOQvZ2VGjdHooR
         M88GrR/aBjO4L/ldRfA0oDFbVgTw3kONjupshw46MA2eeXp4oAZfODNZa9TLziS/Lpht
         TwBs4ldV53eOgY797VDWqEHFQ/5Us20HAXZ4k/gS6k9siBZqb7JQsX9mxlbFkGpowpY3
         X7fQVhMvlehdGykWUYbtrtim5nJt9fUQUP+CMvEOWAV/+at28nb3auB1Yu4+46lvD7pI
         INaw==
X-Gm-Message-State: APjAAAVdRQQaU2AePu+1q3RVUVEv1HAk2cbTy9de3/BuM1g2bK51qwI+
        Ih5W17Pcx3X+SJRRG1rKI7iQSriVmwY=
X-Google-Smtp-Source: APXvYqxzz1M/pk06Z7GJkM0c1x9sbutC0F5pqZEW9HvxA+T0gweRLJP5ZrUnzLLEb7tTNFANPHCU/A==
X-Received: by 2002:a17:902:6bc3:: with SMTP id m3mr34054257plt.185.1579220205962;
        Thu, 16 Jan 2020 16:16:45 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id y14sm26500574pfe.147.2020.01.16.16.16.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 16:16:45 -0800 (PST)
Subject: Re: [PATCH 3/6] io_uring: add support for IORING_OP_OPENAT
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
References: <20200107170034.16165-1-axboe@kernel.dk>
 <20200107170034.16165-4-axboe@kernel.dk>
 <82a015c4-f5b9-7c85-7d80-78964cb0d82e@samba.org>
 <4ccb935c-7ff9-592f-8c27-0af3d38326d7@kernel.dk>
 <2afdd5a5-0eb5-8fba-58d1-03001abbab7e@samba.org>
 <9672da37-bf6f-ce2d-403c-5e2692c67782@kernel.dk>
 <d0f0e726-8e6f-aa43-07b6-fdb3b49ce1bc@samba.org>
 <d5a5dc20-7e11-8489-b9d5-c2cf8a4bdf4b@kernel.dk>
 <a0f1b3a0-9827-b3e1-da0c-a2b71151fd4e@samba.org>
 <0b8a0f70-c2de-1b1c-28d4-5c578a3534eb@kernel.dk>
 <d42d5abd-c87b-1d97-00f3-95460a81c527@samba.org>
 <7c97ddec-24b9-c88d-da7e-89aa161f1634@kernel.dk>
 <cbbebc78-3e3d-b12a-c2dc-9018d4e99c17@samba.org>
 <17dac99c-e3c5-0e50-c26d-c159c1e1724d@kernel.dk>
 <7a91c0ee-ee1c-bec4-98fd-a25664839423@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <38c19d02-ff10-c4a3-3d25-c59530ada19e@kernel.dk>
Date:   Thu, 16 Jan 2020 17:16:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <7a91c0ee-ee1c-bec4-98fd-a25664839423@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/16/20 3:42 PM, Stefan Metzmacher wrote:
>>> I'm not sure if current->mm is needed, I just added it for completeness
>>> and as hint that io_op_defs[req->opcode].needs_mm is there and a
>>> needs_creds could also be added (if it helps with performance)
>>>
>>> Is it possible to trigger a change of current->mm from userspace?
>>>
>>> An IORING_REGISTER_CREDS would only be useful if it's possible to
>>> register a set of credentials and then use per io_uring_sqe credentials.
>>> That would also be fine for me, but I'm not sure it's needed for now.
>>
>> I think it'd be a cleaner way of doing the same thing as your patch
>> does. It seems a little odd to do this by default (having the ring
>> change personalities depending on who's using it), but from an opt-in
>> point of view, I think it makes more sense.
>>
>> That would make the IORING_REGISTER_ call something like
>> IORING_REGISTER_ADOPT_OWNER or something like that, meaning that the
>> ring would just assume the identify of the task that's calling
>> io_uring_enter().
>>
>> Note that this also has to be passed through to the io-wq handler, as
>> the mappings there are currently static as well.
> 
> What's the next step here?

Not sure, need to find some time to work on this!

> I think the current state is a security problem!
> 
> The inline execution either needs to change the creds temporary
> or io_uring_enter() needs a general check that the current creds match
> the creds of the ring and return -EPERM or something similar.

Hmm, if you transfer the fd to someone else, you also give them access
to your credentials etc. We could make that -EPERM, if the owner of the
ring isn't the one invoking the submit. But that doesn't really help the
SQPOLL case, which simply consumes SQE entries. There can be no checking
there.

-- 
Jens Axboe

