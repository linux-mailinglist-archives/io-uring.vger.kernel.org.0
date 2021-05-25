Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D5238FCC3
	for <lists+io-uring@lfdr.de>; Tue, 25 May 2021 10:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbhEYI3H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 May 2021 04:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232408AbhEYI3H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 May 2021 04:29:07 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63E0C061574;
        Tue, 25 May 2021 01:27:37 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id u133so16219730wmg.1;
        Tue, 25 May 2021 01:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n4TDHhXKLGm98ATQkggFq7kJQjHR1O3/yQrmrh9XEmM=;
        b=pK9ET0U9olyRf8R1kkL0Qdjahc0TmQjdtLFfBNUridyDlDI2/RkHPc0nMcmtnkf7al
         h/0TcQGMo3BFInklL2kxmQ+lGck9cFsbvtDC6mUe5yqjlm3/HuzD3aB6sT9Vtjkdkyr9
         5QZCKrra2aj3XnhuYexK/dEmIRyEWH5dNHxAzMMxsUiL9VC2pjiH0W4IWom+Z+6u1fTC
         YFyZ2XJa+dnXt8yFcKIf/3vbNJrcUbkTGTOCQFyHdf5RgY+Fu7KiYVzsX+8fFIDDkyaf
         ETscBkIxr0n3lMeRWgSmMUZo6q1xwhugAv0By00rvHPEJaElDbu6T9sjDJ4wikEARz7v
         aBLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n4TDHhXKLGm98ATQkggFq7kJQjHR1O3/yQrmrh9XEmM=;
        b=f0zYv2qBlYzb/6h2qvetjKvE0Thy/kx/tU63ftS9+EDzXvPQ7cPwGZY46k0HT8+tbH
         yyQYSTYqe63CicjHWxQaQfru/59PkENzu0tmMQhYbjmcIjVmbkyhkyhjPrbqrzF8nv7F
         6w+Wvpy9egYt+cawF0nwcn8hBIKFaWeIK6eJNWQNT378jaDygBujAft9Ax5/vzgkStux
         +6MVyUsw3cVS2wKhZOxWvHKgEgmygeizMkQ2xXgUECUi2i0bMAN6X48MGDrRnAsXmcos
         rMpM7USkIiqbY/YAk4oziHS8c0VgsyfmUlH9KIE7iv3dJsyNvJErP9oLiYWEohkGFPEp
         AajQ==
X-Gm-Message-State: AOAM533HXsGTi3nZ0oTDtM0UiB0vUJj6ZW6ySt0MHBsqcPd9uSiJu0jK
        aFDD1r50Z+bnSnt4fPX24BWhc1gTSLs44hcg
X-Google-Smtp-Source: ABdhPJx6n8mtHGkZxffOVh2kvcbXmcFQRIXtEZT9Vyku2YqMpaAPEa+ctBkjyF0jo8Oa6XkZaMNF1A==
X-Received: by 2002:a1c:c208:: with SMTP id s8mr15566928wmf.144.1621931256332;
        Tue, 25 May 2021 01:27:36 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.235.116])
        by smtp.gmail.com with ESMTPSA id w25sm10366706wmk.25.2021.05.25.01.27.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 May 2021 01:27:35 -0700 (PDT)
To:     Paul Moore <paul@paul-moore.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
References: <162163367115.8379.8459012634106035341.stgit@sifl>
 <162163379461.8379.9691291608621179559.stgit@sifl>
 <f07bd213-6656-7516-9099-c6ecf4174519@gmail.com>
 <CAHC9VhRjzWxweB8d8fypUx11CX6tRBnxSWbXH+5qM1virE509A@mail.gmail.com>
 <162219f9-7844-0c78-388f-9b5c06557d06@gmail.com>
 <CAHC9VhSJuddB+6GPS1+mgcuKahrR3UZA=1iO8obFzfRE7_E0gA@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC PATCH 2/9] audit,io_uring,io-wq: add some basic audit
 support to io_uring
Message-ID: <e701511f-520d-4a94-9931-d218b14a80fe@gmail.com>
Date:   Tue, 25 May 2021 09:27:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAHC9VhSJuddB+6GPS1+mgcuKahrR3UZA=1iO8obFzfRE7_E0gA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/24/21 8:59 PM, Paul Moore wrote:
> On Sun, May 23, 2021 at 4:26 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> On 5/22/21 3:36 AM, Paul Moore wrote:
>>> On Fri, May 21, 2021 at 8:22 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>> On 5/21/21 10:49 PM, Paul Moore wrote:
>> [...]
>>>>>
>>>>> +     if (req->opcode < IORING_OP_LAST)
>>>>
>>>> always true at this point
>>>
>>> I placed the opcode check before the audit call because the switch
>>> statement below which handles the operation dispatching has a 'ret =
>>> -EINVAL' for the default case, implying that there are some paths
>>> where an invalid opcode could be passed into the function.  Obviously
>>> if that is not the case and you can guarantee that req->opcode will
>>> always be valid we can easily drop the check prior to the audit call.
>>
>> It is always true at this point, would be completely broken
>> otherwise
> 
> Understood, I was just pointing out an oddity in the code.  I just
> dropped the checks from my local tree, you'll see it in the next draft
> of the patchset.
> 
>>>> So, it adds two if's with memory loads (i.e. current->audit_context)
>>>> per request in one of the hottest functions here... No way, nack
>>>>
>>>> Maybe, if it's dynamically compiled into like kprobes if it's
>>>> _really_ used.
>>>
>>> I'm open to suggestions on how to tweak the io_uring/audit
>>> integration, if you don't like what I've proposed in this patchset,
>>> lets try to come up with a solution that is more palatable.  If you
>>> were going to add audit support for these io_uring operations, how
>>> would you propose we do it?  Not being able to properly audit io_uring
>>> operations is going to be a significant issue for a chunk of users, if
>>> it isn't already, we need to work to find a solution to this problem.
>>
>> Who knows. First of all, seems CONFIG_AUDIT is enabled by default
>> for many popular distributions, so I assume that is not compiled out.
>>
>> What are use cases for audit? Always running I guess?
> 
> Audit has been around for quite some time now, and it's goal is to
> provide a mechanism for logging "security relevant" information in
> such a way that it meets the needs of various security certification
> efforts.  Traditional Linux event logging, e.g. syslog and the like,
> does not meet these requirements and changing them would likely affect
> the usability for those who are not required to be compliant with
> these security certifications.  The Linux audit subsystem allows Linux
> to be used in places it couldn't be used otherwise (or rather makes it
> a *lot* easier).
> 
> That said, audit is not for everyone, and we have build time and
> runtime options to help make life easier.  Beyond simply disabling
> audit at compile time a number of Linux distributions effectively
> shortcut audit at runtime by adding a "never" rule to the audit
> filter, for example:
> 
>  % auditctl -a task,never
> 
>> Putting aside compatibility problems, it sounds that with the amount of overhead
>> it adds there is no much profit in using io_uring in the first place.
>> Is that so?
> 
> Well, if audit alone erased all of the io_uring advantages we should
> just rip io_uring out of the kernel and people can just disable audit
> instead ;)


Hah, if we add a simple idle "feature" like

for (i=0;i<1000000;i+) {;}

and it would destroy all the performance, let's throw useless
Linux kernel then!

If seriously, it's more of an open question to me, how much overhead
it adds if enabled (with typical filters/options/etc).

Btw, do you really need two hooks -- before and right after
execution?

> I believe there are people who would like to use io_uring and are also
> required to use a kernel with audit, either due to the need to run a
> distribution kernel or the need to capture security information in the
> audit stream.  I'm hoping that we can find a solution for these users;
> if we don't we are asking this group to choose either io_uring or
> audit, and that is something I would like to avoid. 

-- 
Pavel Begunkov
