Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9603039A507
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 17:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhFCPzw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 11:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbhFCPzv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 11:55:51 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD478C061756
        for <io-uring@vger.kernel.org>; Thu,  3 Jun 2021 08:54:06 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id x9so6037057ilp.4
        for <io-uring@vger.kernel.org>; Thu, 03 Jun 2021 08:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=buCUvWOaV46TEe0pfybKHgNeLuajhkCoUvc4V9kk0GM=;
        b=AvHRoUndMbsOR2LZQbV9UyOHSi2H1HcMJtDtgjOBthii3UKRGsG7GL9gvctRI4YTI2
         0X9ilAdtUWDZFiGmyoPZBn+lXmQfQZ6KY1ZpZvgZhJaJ3ULWIl/8uS7SPC8m+7FcnOxS
         clyfp/+5Vqub24anQIDa/6/e0+sFnJ7s4mkbPZW7i3fnrqBxXoh3C7Ww4vlAz2rtqMe9
         CtP5aaQ0MyyliBAq/hWpqGP8hPmdjDDu02ogwMSzqRt88NEhbzkmE7EgRb9TkzFDow0c
         0UAK0ZAB6xYTithTdVkeFKWhJCWDAMu8QETBbIN3cbEdaR/c/XH5/Vhi/x28M2u4PqQB
         sVzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=buCUvWOaV46TEe0pfybKHgNeLuajhkCoUvc4V9kk0GM=;
        b=PamIJ4bXg7o9kSuAFgta1eMZPAHi9WBcwGaWNWmrSI2mXOATUz9kjoZ2Za4LHBLkDT
         DlStttDnl+ZEOi7NgXssAjNFrlmQDUZpT/Trm2txyneSeKvE9+FkNRRtIOlqUJYowAOp
         +hvsMM5S1iKQ97hpftITLXZXmjeNYASwfzi7DlPiTUonusxYHPPz/6awSjjSGCnDRoVB
         DH0aZyAahQ8gX0JixxqjGGD5lKPUjAIgLDm6D9DBGkdK/j3Y4YpFqmp21Ac5hLDqJfdn
         8qoLHSmhbSj1sRjEpYMme0yyYbLyRanmQG3P84JwHW7rRMbOuT49M9iAwUpYSSxIhyx3
         zMOg==
X-Gm-Message-State: AOAM532BZH4mFD92dlEq6Jl+rlw/7bw6eyK3NUT5Q3r6VNFBPDdHzUqm
        QZxBXdhvsS63nbcgQPr3GJWHAQ==
X-Google-Smtp-Source: ABdhPJxTgRBRHHntkEyxXKkKZCy9JIZBYhMq02FcIt13uKSk14obLbdz2JV2Qm8ADOaXFhFzOvBNQg==
X-Received: by 2002:a05:6e02:13a9:: with SMTP id h9mr62415ilo.96.1622735645969;
        Thu, 03 Jun 2021 08:54:05 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s6sm787512ilt.50.2021.06.03.08.54.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 08:54:05 -0700 (PDT)
Subject: Re: [RFC PATCH 2/9] audit,io_uring,io-wq: add some basic audit
 support to io_uring
To:     Paul Moore <paul@paul-moore.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
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
 <9e69e4b6-2b87-a688-d604-c7f70be894f5@kernel.dk>
 <3bef7c8a-ee70-d91d-74db-367ad0137d00@kernel.dk>
 <fa7bf4a5-5975-3e8c-99b4-c8d54c57da10@kernel.dk>
 <a7669e4a-e7a7-7e94-f6ce-fa48311f7175@kernel.dk>
 <CAHC9VhSKPzADh=qcPp7r7ZVD2cpr2m8kQsui43LAwPr-9BNaxQ@mail.gmail.com>
 <b20f0373-d597-eb0e-5af3-6dcd8c6ba0dc@kernel.dk>
 <CAHC9VhRZEwtsxjhpZM1DXGNJ9yL59B7T_p2B60oLmC_YxCrOiw@mail.gmail.com>
 <CAHC9VhSK9PQdxvXuCA2NMC3UUEU=imCz_n7TbWgKj2xB2T=fOQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <46381e4e-a65d-f217-1d0d-43d1fa8a99aa@kernel.dk>
Date:   Thu, 3 Jun 2021 09:54:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHC9VhSK9PQdxvXuCA2NMC3UUEU=imCz_n7TbWgKj2xB2T=fOQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/28/21 10:02 AM, Paul Moore wrote:
> On Wed, May 26, 2021 at 4:19 PM Paul Moore <paul@paul-moore.com> wrote:
>> ... If we moved the _entry
>> and _exit calls into the individual operation case blocks (quick
>> openat example below) so that only certain operations were able to be
>> audited would that be acceptable assuming the high frequency ops were
>> untouched?  My initial gut feeling was that this would involve >50% of
>> the ops, but Steve Grubb seems to think it would be less; it may be
>> time to look at that a bit more seriously, but if it gets a NACK
>> regardless it isn't worth the time - thoughts?
>>
>>   case IORING_OP_OPENAT:
>>     audit_uring_entry(req->opcode);
>>     ret = io_openat(req, issue_flags);
>>     audit_uring_exit(!ret, ret);
>>     break;
> 
> I wanted to pose this question again in case it was lost in the
> thread, I suspect this may be the last option before we have to "fix"
> things at the Kconfig level.  I definitely don't want to have to go
> that route, and I suspect most everyone on this thread feels the same,
> so I'm hopeful we can find a solution that is begrudgingly acceptable
> to both groups.

Sorry for the lack of response here, but to sum up my order of
preference:

1) It's probably better to just make the audit an opt-out in io_op_defs
   for each opcode, and avoid needing boiler plate code for each op
   handler. The opt-out would ensure that new opcodes get it by default
   it someone doesn't know what it is, and the io_op_defs addition would
   mean that it's in generic code rather then in the handlers. Yes it's
   a bit slower, but it's saner imho.

2) With the above, I'm fine with adding this to io_uring. I don't think
   going the route of mutual exclusion in kconfig helps anyone, it'd
   be counter productive to both sides.

Hope that works and helps move this forward. I'll be mostly out of touch
the next week and a half, but wanted to ensure that I sent out my
(brief) thoughts before going away.

-- 
Jens Axboe

