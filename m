Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEAB13914C0
	for <lists+io-uring@lfdr.de>; Wed, 26 May 2021 12:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233873AbhEZKUv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 May 2021 06:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233793AbhEZKUv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 May 2021 06:20:51 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97863C061574;
        Wed, 26 May 2021 03:19:18 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id p7so491115wru.10;
        Wed, 26 May 2021 03:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z+Ri2n3Ocsu19UbwoKK73grQnRbFQovYzLp7sCDG7XU=;
        b=HT2qdFrJEOcbSqmn0mj2PZXPRGJPTyWLMUq4Sz5FBCUsKzvBMnojJApDwbnIG2Jcwq
         CObn/SIeDSWdNbEm2Q0vOyG7B/T/jQtWsobjvyGytUJ0a0GFSOZ8HZPhqXl+MyOhqDn+
         21oHC+3cyl/2rSO3q9WeQ9HVIEUNzSNHhIRrxXmRtcuOY4FA/Po5GYpgu9lpJRSy8MoO
         PXnRAHw2NlZ5naEUFKX7UhGXyCYpOyi4L1DwxatAMiOg+CYwRHPBVvFmFnq77FOhhPvC
         /QhsjLiZMF9jgrleP2f/GTD3oELCq0SihHcojHWjksoRBHvqS8WiSHuyvtr5HyizyoUX
         mi5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z+Ri2n3Ocsu19UbwoKK73grQnRbFQovYzLp7sCDG7XU=;
        b=qItsuLbon3SrGakcsPpHIDITwz2D6Vf9P79gd19mr5aADFURjUz5rgaP1I3z372j9i
         x6G/xiZ0sW6wk8lt1lyD3Egr9+EdOWlh9ZCWGJMOANZHhxMpjwuSuTHeDgzejVZcTVRX
         jTLJoPO+lIjRMQdmgZ/uP2JdOT1b6C5LZdy3SMatEIGpEgyZNxd5Qzwg/9V+Qw4HVXYk
         t7+g32mG45PBKshyXzzSu6uQ9Z/2o80hCIsVkrMBMVOiSuAylqYcGTb7knNeBUCGhcQc
         uieNebLlHZSFFZhmngkFdObb/G2D1E2Pf/cBX/2y99WR2vy1EkWj5sM255zF1JSJOk99
         6SMg==
X-Gm-Message-State: AOAM530d/rwpWD8SFOiJTu1i/1JjJn0fEGNuxpgjFIm4Y9XL7UCXDrKN
        T0e/swJHCyokd6C/19bBR30=
X-Google-Smtp-Source: ABdhPJywganIcqZjZaYvnZH3uWCkDwi9O5Ktdyk9fsy+ejFwjvibA7TSYKN66vm6LiQxTCnmYRzmCQ==
X-Received: by 2002:a5d:5407:: with SMTP id g7mr32338951wrv.207.1622024357214;
        Wed, 26 May 2021 03:19:17 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.235.102])
        by smtp.gmail.com with ESMTPSA id u8sm5538665wmq.29.2021.05.26.03.19.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 03:19:16 -0700 (PDT)
To:     Paul Moore <paul@paul-moore.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
References: <162163367115.8379.8459012634106035341.stgit@sifl>
 <162163379461.8379.9691291608621179559.stgit@sifl>
 <f07bd213-6656-7516-9099-c6ecf4174519@gmail.com>
 <CAHC9VhRjzWxweB8d8fypUx11CX6tRBnxSWbXH+5qM1virE509A@mail.gmail.com>
 <162219f9-7844-0c78-388f-9b5c06557d06@gmail.com>
 <CAHC9VhSJuddB+6GPS1+mgcuKahrR3UZA=1iO8obFzfRE7_E0gA@mail.gmail.com>
 <8943629d-3c69-3529-ca79-d7f8e2c60c16@kernel.dk>
 <CAHC9VhTYBsh4JHhqV0Uyz=H5cEYQw48xOo=CUdXV0gDvyifPOQ@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC PATCH 2/9] audit,io_uring,io-wq: add some basic audit
 support to io_uring
Message-ID: <0a668302-b170-31ce-1651-ddf45f63d02a@gmail.com>
Date:   Wed, 26 May 2021 11:19:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAHC9VhTYBsh4JHhqV0Uyz=H5cEYQw48xOo=CUdXV0gDvyifPOQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/26/21 3:04 AM, Paul Moore wrote:
> On Tue, May 25, 2021 at 9:11 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 5/24/21 1:59 PM, Paul Moore wrote:
>>> That said, audit is not for everyone, and we have build time and
>>> runtime options to help make life easier.  Beyond simply disabling
>>> audit at compile time a number of Linux distributions effectively
>>> shortcut audit at runtime by adding a "never" rule to the audit
>>> filter, for example:
>>>
>>>  % auditctl -a task,never
>>
>> As has been brought up, the issue we're facing is that distros have
>> CONFIG_AUDIT=y and hence the above is the best real world case outside
>> of people doing custom kernels. My question would then be how much
>> overhead the above will add, considering it's an entry/exit call per op.
>> If auditctl is turned off, what is the expectation in turns of overhead?
> 
> I commented on that case in my last email to Pavel, but I'll try to go
> over it again in a little more detail.
> 
> As we discussed earlier in this thread, we can skip the req->opcode
> check before both the _entry and _exit calls, so we are left with just
> the bare audit calls in the io_uring code.  As the _entry and _exit
> functions are small, I've copied them and their supporting functions
> below and I'll try to explain what would happen in CONFIG_AUDIT=y,
> "task,never" case.
> 
> +  static inline struct audit_context *audit_context(void)
> +  {
> +    return current->audit_context;
> +  }
> 
> +  static inline bool audit_dummy_context(void)
> +  {
> +    void *p = audit_context();
> +    return !p || *(int *)p;
> +  }
> 
> +  static inline void audit_uring_entry(u8 op)
> +  {
> +    if (unlikely(audit_enabled && audit_context()))
> +      __audit_uring_entry(op);
> +  }

I'd rather agree that it's my cycle-picking. The case I care about
is CONFIG_AUDIT=y (because everybody enable it), and io_uring
tracing _not_ enabled at runtime. If enabled let them suffer
the overhead, it will probably dip down the performance

So, for the case I care about it's two of

if (unlikely(audit_enabled && current->audit_context))

in the hot path. load-test-jump + current, so it will
be around 7x2 instructions. We can throw away audit_enabled
as you say systemd already enables it, that will give
4x2 instructions including 2 conditional jumps.

That's not great at all. And that's why I brought up
the question about need of pre and post hooks and whether
can be combined. Would be just 4 instructions and that is
ok (ish).

> We would need to check with the current security requirements (there
> are distro people on the linux-audit list that keep track of that
> stuff), but looking at the opcodes right now my gut feeling is that
> most of the opcodes would be considered "security relevant" so
> selective auditing might not be that useful in practice.  It would
> definitely clutter the code and increase the chances that new opcodes
> would not be properly audited when they are merged.

I'm curious, why it's enabled by many distros by default? Are there
use cases they use? Tempting to add AUDIT_IOURING=default N, but
won't work I guess

-- 
Pavel Begunkov
