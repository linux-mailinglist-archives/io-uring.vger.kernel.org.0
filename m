Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8246A775BEC
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 13:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjHILWQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 07:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233586AbjHILWP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 07:22:15 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654B02683
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 04:22:03 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-4fe463420fbso10432045e87.3
        for <io-uring@vger.kernel.org>; Wed, 09 Aug 2023 04:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1691580121; x=1692184921;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NKzdgfdfuVj+XSmSmvvfmRlSIXkPZbyE/cWIrs+YHVY=;
        b=lj48dMBPNJn5+m0MgFE4sM3lRHJ2qKVJR68lH0fu/wIRES7I39BUbDlu/MMDi2ftFZ
         cPaxwkxfTOXIhQ0fP7ygUs7hFlNf1uYuW1mMNUt+jyvyMBP7vIDt9uvUNF06N4Eky3TC
         ++zqXJzj97LLKz1D4HmkgfmtdcaZg1My/eDEfI6dvtSDrua0YPD6fvhuJWOOCrxqmvAs
         T2oWuxtRksHxlSJNofjX0gtbB+Hn4fVDt/ZlWxPwTmAer5MC/GFjiHekYy5BDAERuw/V
         Gnj88Ujm5d8hGd3XBLctC2nG0EQO4XyALXGhTsuXngfIs1QhhNSLIdSTkmowCxhdLuBI
         QnRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691580121; x=1692184921;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NKzdgfdfuVj+XSmSmvvfmRlSIXkPZbyE/cWIrs+YHVY=;
        b=lizCE6pDc4dyqI13d4QGriHvY5qtvRW8SX1cjp8lOgJOZwnN/wipxISi6frObtfiUt
         5zyoYUA84WeFn1AhLPvXAufc+BzXU2kvguC5mxTBItk8NBUGuoehthqzcOVBKFxAlgZ/
         1z567NCGT1OrPvDtXfoDE8me5fFLbOi51QJjoYMlnpa//xW+h2QgJ4xzNLrk9iRkNhiw
         DmWVxP3Z5EYPYgNxKhpxRHkkiW2otra276v8hhCrbEvc5RoL/tYtZgVzFfpqsFiGOOBy
         kByc97djpLeSFJltuxFHrsG6OwNcBg6GY99VPVSPT/Q1xyZyXZQzyS6Z1eEvI42euM/q
         +dRA==
X-Gm-Message-State: AOJu0YyHKemjMR8xw7Ws+DcRK7+fKxXtiXOK3vfXp0FqqnDhHhA11ljR
        TRxvW+jGuLuERAYN0FCHdPFVVQ==
X-Google-Smtp-Source: AGHT+IHzlXbuU4mO9eU5VjDUQacowYKrGPFGV8XFQSH91qSAL4Ahwvmm/1iYmr8hrrrhQBY2qkIkKg==
X-Received: by 2002:a19:ee17:0:b0:4fb:8771:e898 with SMTP id g23-20020a19ee17000000b004fb8771e898mr1556701lfb.15.1691580120986;
        Wed, 09 Aug 2023 04:22:00 -0700 (PDT)
Received: from [10.43.1.246] ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id 4-20020ac24824000000b004f8675548ebsm2266606lft.20.2023.08.09.04.21.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 04:22:00 -0700 (PDT)
Message-ID: <d2eaa3f8-cca6-2f51-ce98-30242c528b6f@semihalf.com>
Date:   Wed, 9 Aug 2023 13:21:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v1 0/2] Add LSM access controls for io_uring_setup
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>
Cc:     Jeffrey Vander Stoep <jeffv@google.com>,
        Gil Cukierman <cukie@google.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        Joel Granados <j.granados@samsung.com>,
        Jeff Xu <jeffxu@google.com>,
        Takaya Saeki <takayas@chromium.org>,
        Tomasz Nowicki <tn@semihalf.com>,
        Matteo Rizzo <matteorizzo@google.com>,
        Andres Freund <andres@anarazel.de>
References: <20221107205754.2635439-1-cukie@google.com>
 <CAHC9VhTLBWkw2XzqdFx1LFVKDtaAL2pEfsmm+LEmS0OWM1mZgA@mail.gmail.com>
 <CABXk95ChjusTneWJgj5a58CZceZv0Ay-P-FwBcH2o4rO0g2Ggw@mail.gmail.com>
 <CAHC9VhRTWGuiMpJJiFrUpgsm7nQaNA-n1CYRMPS-24OLvzdA2A@mail.gmail.com>
 <54c8fd9c-0edd-7fea-fd7a-5618859b0827@semihalf.com>
 <CAHC9VhS9BXTUjcFy-URYhG=XSxBC+HsePbu01_xBGzM8sebCYQ@mail.gmail.com>
From:   Dmytro Maluka <dmy@semihalf.com>
In-Reply-To: <CAHC9VhS9BXTUjcFy-URYhG=XSxBC+HsePbu01_xBGzM8sebCYQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/9/23 02:31, Paul Moore wrote:
> On Tue, Aug 8, 2023 at 4:40 PM Dmytro Maluka <dmy@semihalf.com> wrote:
>> On 11/10/22 22:04, Paul Moore wrote:
>>> On Thu, Nov 10, 2022 at 12:54 PM Jeffrey Vander Stoep <jeffv@google.com> wrote:
>>>> On Mon, Nov 7, 2022 at 10:17 PM Paul Moore <paul@paul-moore.com> wrote:
>>>>>
>>>>> On Mon, Nov 7, 2022 at 3:58 PM Gil Cukierman <cukie@google.com> wrote:
>>>>>>
>>>>>> This patchset provides the changes required for controlling access to
>>>>>> the io_uring_setup system call by LSMs. It does this by adding a new
>>>>>> hook to io_uring. It also provides the SELinux implementation for a new
>>>>>> permission, io_uring { setup }, using the new hook.
>>>>>>
>>>>>> This is important because existing io_uring hooks only support limiting
>>>>>> the sharing of credentials and access to the sensitive uring_cmd file
>>>>>> op. Users of LSMs may also want the ability to tightly control which
>>>>>> callers can retrieve an io_uring capable fd from the kernel, which is
>>>>>> needed for all subsequent io_uring operations.
>>>>>
>>>>> It isn't immediately obvious to me why simply obtaining a io_uring fd
>>>>> from io_uring_setup() would present a problem, as the security
>>>>> relevant operations that are possible with that io_uring fd *should*
>>>>> still be controlled by other LSM hooks.  Can you help me understand
>>>>> what security issue you are trying to resolve with this control?
>>>>
>>>> I think there are a few reasons why we want this particular hook.
>>>>
>>>> 1.  It aligns well with how other resources are managed by selinux
>>>> where access to the resource is the first control point (e.g. "create"
>>>> for files, sockets, or bpf_maps, "prog_load" for bpf programs, and
>>>> "open" for perf_event) and then additional functionality or
>>>> capabilities require additional permissions.
>>>
>>> [NOTE: there were two reply sections in your email, and while similar,
>>> they were not identical; I've trimmed the other for the sake of
>>> clarity]
>>>
>>> The resources you mention are all objects which contain some type of
>>> information (either user data, configuration, or program
>>> instructions), with the resulting fd being a handle to those objects.
>>> In the case of io_uring the fd is a handle to the io_uring
>>> interface/rings, which by itself does not contain any information
>>> which is not already controlled by other permissions.
>>>
>>> I/O operations which transfer data between the io_uring buffers and
>>> other system objects, e.g. IORING_OP_READV, are still subject to the
>>> same file access controls as those done by the application using
>>> syscalls.  Even the IORING_OP_OPENAT command goes through the standard
>>> VFS code path which means it will trigger the same access control
>>> checks as an open*() done by the application normally.
>>>
>>> The 'interesting' scenarios are those where the io_uring operation
>>> servicing credentials, aka personalities, differ from the task
>>> controlling the io_uring.  However in those cases we have the new
>>> io_uring controls to gate these delegated operations.  Passing an
>>> io_uring fd is subject to the fd/use permission like any other fd.
>>>
>>> Although perhaps the most relevant to your request is the fact that
>>> the io_uring inode is created using the new(ish) secure anon inode
>>> interface which ensures that the creating task has permission to
>>> create an io_uring.  This io_uring inode label also comes into play
>>> when a task attempts to mmap() the io_uring rings, a critical part of
>>> the io_uring API.
>>>
>>> If I'm missing something you believe to be important, please share the details.
>>>
>>>> 2. It aligns well with how resources are managed on Android. We often
>>>> do not grant direct access to resources (like memory buffers).
>>>
>>> Accessing the io_uring buffers requires a task to mmap() the io_uring
>>> fd which is controlled by the normal SELinux mmap() access controls.
>>>
>>>> 3. Attack surface management. One of the primary uses of selinux on
>>>> Android is to assess and limit attack surface (e.g.
>>>> https://twitter.com/jeffvanderstoep/status/1422771606309335043) . As
>>>> io_uring vulnerabilities have made their way through our vulnerability
>>>> management system, it's become apparent that it's complicated to
>>>> assess the impact. Is a use-after-free reachable? Creating
>>>> proof-of-concept exploits takes a lot of time, and often functionality
>>>> can be reached by multiple paths. How many of the known io_uring
>>>> vulnerabilities would be gated by the existing checks? How many future
>>>> ones will be gated by the existing checks? I don't know the answer to
>>>> either of these questions and it's not obvious. This hook makes that
>>>> initial assessment simple and effective.
>>>
>>> It should be possible to deny access to io_uring via the anonymous
>>> inode labels, the mmap() controls, and the fd/use permission.  If you
>>> find a way to do meaningful work with an io_uring fd that can't be
>>> controlled via an existing permission check please let me know.
>>
>> Thank you a lot for this explanation. However, IMHO we should not
>> confuse 2 somewhat different problems here:
>>
>> - protecting io_uring related resources (file descriptors, memory
>>   buffers) against unauthorized access
>>
>> - protecting the entire system against potential vulnerabilities in
>>   io_uring
>>
>> And while I agree that the existing permission checks should be already
>> sufficient for the former, I'm not quite sure they are sufficient for
>> the latter.
> 
> ...
> 
>> I already have a PoC patch [3] adding such LSM hook. But before I try to
>> submit it for upstream, I'd like to know your opinion on the whole idea.
> 
> First please explain how the existing LSM/SELinux control points are
> not sufficient for restricting io_uring operations.  I'm looking for a
> real program flow that is able to "do meaningful work with an io_uring
> fd that can't be controlled via an existing permission check".

As I said at the beginning of my reply, I agree with you that the
existing LSM controls are sufficient for restricting io_uring I/O
operations. That is not my concern here. The concern is: how to (and
do we need to) restrict triggering execution of *any* io_uring code in
kernel, *in addition to* restricting the actual io_uring operations.

In other words, "a real program doing a meaningful work with io_uring"
in this case would mean "an exploit for a real vulnerability in io_uring
code (in the current or any older kernel) which does not require an
access to io_uring operations to be exploited". I don't claim that such
vulnerabilities exist or are likely to be introduced in future kernels.
But I'm neither an io_uring expert nor, more importantly, a security
expert, so I cannot tell with confidence that they are not and we have
nothing to worry about here. So I'm interested in your and others'
opinion on that.

As an example, IIUC the inode_init_security_anon LSM hook already allows
us to prevent a process from obtaining a valid io_uring fd via
io_uring_setup(). But what if the process passes an invalid (unrelated)
fd to io_uring_register() or io_uring_enter()?

It looks like all that happens is: it will quickly fail the
io_is_uring_fops() check and return an error to userspace. So I suppose
we may reasonably assume that this particular simple code path will
remain bug-free and thus we don't need to worry about potential
vulnerabilities in this case. Even if so, can we assume that any other
code paths in io_uring that are reachable without passing the existing
permission checks are similarly trivial?
