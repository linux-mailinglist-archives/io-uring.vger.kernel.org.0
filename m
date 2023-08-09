Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64901776674
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 19:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbjHIR2c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 13:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbjHIR2b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 13:28:31 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFEAB0
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 10:28:29 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4fe2d152f62so11763529e87.0
        for <io-uring@vger.kernel.org>; Wed, 09 Aug 2023 10:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1691602108; x=1692206908;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yw22Rug4OEXyPMn54DIvL6wFU6vMQ8oGwoG/iSU6CIc=;
        b=KIbY2LyyTl/AnYXTkkb6pgPDIwlxFzi/gU1TOXHFBIULY9+bxRCqT0/5PbrBQZr65u
         8ThZm7mo/+9F5dlunFcUes8zmBpOi4GsUlCOLcfKT8uAkLUulHD92tPA2i1ve2IBJIUZ
         D/NL9+3lSH9g3jwpXQ9hc2hG37wgUM9SNAYuMLmU0pp4prRKrCiKVdtYeHuVIdo7p8zk
         WTL1Capi6iCC69SDt+EVndrPPpbesmWQcHbMOSX/evqo9RJAWI0TlSiSjqmCkpWYvNrY
         IdkFfg2hyXY2jFG1qswWzSBv/aaeQaDhiVhK8ptuomf4MZWDnBdlCZCxWHh8NqcU7jEq
         5mJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691602108; x=1692206908;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yw22Rug4OEXyPMn54DIvL6wFU6vMQ8oGwoG/iSU6CIc=;
        b=VQteti/8JbAu1eF08mc9QW6rQyS7AF2Bbb+tCRk7Nh9MUhKNN96UO/AN0jDKuRkhw4
         KAUzlJky6kLTAMylBB+o1xcPCsV85iMYjNG2qjV+74v9+XIpky9Qw6gzvzmMD4u6eyUd
         urfHX500Y/C2w3RWJNSqVuKzBZpQjctM7+JT5XfhuibN1G+bKFcrffh60oG6H57SV3qK
         N9Zv5qUINHMT4giFV3jJC9VvACnKffb4Yoqe1LjlWwa4DHQlyUAFVO+QhnW6kFif0t0T
         JcocwTjqw4skOSOnRBWfUSkaeLwwA0yfzcIwgWJQYBWhMsntvd+WPWvmJalcrKMsQkHQ
         h2kQ==
X-Gm-Message-State: AOJu0YyaGyZY2e76QhIKmCHpBYz2iZb+LjywZPGqmmE8eKonZ7Ul6a/U
        hD4y7MOstkhGW0cWFkMKipmefg==
X-Google-Smtp-Source: AGHT+IFGU6DlsIDGan/Ed64LTo5h4x9cjw5aWImDy8ojY1Rnld19e+Tgnw2G60Ovk+FaCUg8I76/yg==
X-Received: by 2002:a19:8c54:0:b0:4fe:676:8c0b with SMTP id i20-20020a198c54000000b004fe06768c0bmr2411269lfj.11.1691602107522;
        Wed, 09 Aug 2023 10:28:27 -0700 (PDT)
Received: from [10.43.1.246] ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id p3-20020a19f003000000b004fcddf3671dsm2388034lfc.177.2023.08.09.10.28.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 10:28:26 -0700 (PDT)
Message-ID: <dc055b47-b868-7f5d-98bf-51e27df6b2d8@semihalf.com>
Date:   Wed, 9 Aug 2023 19:28:25 +0200
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
 <d2eaa3f8-cca6-2f51-ce98-30242c528b6f@semihalf.com>
 <CAHC9VhQDAM8X-MV9ONckc2NBWDZrsMteanDo9_NS4SirdQAx=w@mail.gmail.com>
From:   Dmytro Maluka <dmy@semihalf.com>
In-Reply-To: <CAHC9VhQDAM8X-MV9ONckc2NBWDZrsMteanDo9_NS4SirdQAx=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/9/23 16:49, Paul Moore wrote:
> On Wed, Aug 9, 2023 at 7:22 AM Dmytro Maluka <dmy@semihalf.com> wrote:
>> On 8/9/23 02:31, Paul Moore wrote:
>>> On Tue, Aug 8, 2023 at 4:40 PM Dmytro Maluka <dmy@semihalf.com> wrote:
>>>> On 11/10/22 22:04, Paul Moore wrote:
>>>>> On Thu, Nov 10, 2022 at 12:54 PM Jeffrey Vander Stoep <jeffv@google.com> wrote:
>>>>>> On Mon, Nov 7, 2022 at 10:17 PM Paul Moore <paul@paul-moore.com> wrote:
>>>>>>>
>>>>>>> On Mon, Nov 7, 2022 at 3:58 PM Gil Cukierman <cukie@google.com> wrote:
>>>>>>>>
>>>>>>>> This patchset provides the changes required for controlling access to
>>>>>>>> the io_uring_setup system call by LSMs. It does this by adding a new
>>>>>>>> hook to io_uring. It also provides the SELinux implementation for a new
>>>>>>>> permission, io_uring { setup }, using the new hook.
>>>>>>>>
>>>>>>>> This is important because existing io_uring hooks only support limiting
>>>>>>>> the sharing of credentials and access to the sensitive uring_cmd file
>>>>>>>> op. Users of LSMs may also want the ability to tightly control which
>>>>>>>> callers can retrieve an io_uring capable fd from the kernel, which is
>>>>>>>> needed for all subsequent io_uring operations.
>>>>>>>
>>>>>>> It isn't immediately obvious to me why simply obtaining a io_uring fd
>>>>>>> from io_uring_setup() would present a problem, as the security
>>>>>>> relevant operations that are possible with that io_uring fd *should*
>>>>>>> still be controlled by other LSM hooks.  Can you help me understand
>>>>>>> what security issue you are trying to resolve with this control?
>>>>>>
>>>>>> I think there are a few reasons why we want this particular hook.
>>>>>>
>>>>>> 1.  It aligns well with how other resources are managed by selinux
>>>>>> where access to the resource is the first control point (e.g. "create"
>>>>>> for files, sockets, or bpf_maps, "prog_load" for bpf programs, and
>>>>>> "open" for perf_event) and then additional functionality or
>>>>>> capabilities require additional permissions.
>>>>>
>>>>> [NOTE: there were two reply sections in your email, and while similar,
>>>>> they were not identical; I've trimmed the other for the sake of
>>>>> clarity]
>>>>>
>>>>> The resources you mention are all objects which contain some type of
>>>>> information (either user data, configuration, or program
>>>>> instructions), with the resulting fd being a handle to those objects.
>>>>> In the case of io_uring the fd is a handle to the io_uring
>>>>> interface/rings, which by itself does not contain any information
>>>>> which is not already controlled by other permissions.
>>>>>
>>>>> I/O operations which transfer data between the io_uring buffers and
>>>>> other system objects, e.g. IORING_OP_READV, are still subject to the
>>>>> same file access controls as those done by the application using
>>>>> syscalls.  Even the IORING_OP_OPENAT command goes through the standard
>>>>> VFS code path which means it will trigger the same access control
>>>>> checks as an open*() done by the application normally.
>>>>>
>>>>> The 'interesting' scenarios are those where the io_uring operation
>>>>> servicing credentials, aka personalities, differ from the task
>>>>> controlling the io_uring.  However in those cases we have the new
>>>>> io_uring controls to gate these delegated operations.  Passing an
>>>>> io_uring fd is subject to the fd/use permission like any other fd.
>>>>>
>>>>> Although perhaps the most relevant to your request is the fact that
>>>>> the io_uring inode is created using the new(ish) secure anon inode
>>>>> interface which ensures that the creating task has permission to
>>>>> create an io_uring.  This io_uring inode label also comes into play
>>>>> when a task attempts to mmap() the io_uring rings, a critical part of
>>>>> the io_uring API.
>>>>>
>>>>> If I'm missing something you believe to be important, please share the details.
>>>>>
>>>>>> 2. It aligns well with how resources are managed on Android. We often
>>>>>> do not grant direct access to resources (like memory buffers).
>>>>>
>>>>> Accessing the io_uring buffers requires a task to mmap() the io_uring
>>>>> fd which is controlled by the normal SELinux mmap() access controls.
>>>>>
>>>>>> 3. Attack surface management. One of the primary uses of selinux on
>>>>>> Android is to assess and limit attack surface (e.g.
>>>>>> https://twitter.com/jeffvanderstoep/status/1422771606309335043) . As
>>>>>> io_uring vulnerabilities have made their way through our vulnerability
>>>>>> management system, it's become apparent that it's complicated to
>>>>>> assess the impact. Is a use-after-free reachable? Creating
>>>>>> proof-of-concept exploits takes a lot of time, and often functionality
>>>>>> can be reached by multiple paths. How many of the known io_uring
>>>>>> vulnerabilities would be gated by the existing checks? How many future
>>>>>> ones will be gated by the existing checks? I don't know the answer to
>>>>>> either of these questions and it's not obvious. This hook makes that
>>>>>> initial assessment simple and effective.
>>>>>
>>>>> It should be possible to deny access to io_uring via the anonymous
>>>>> inode labels, the mmap() controls, and the fd/use permission.  If you
>>>>> find a way to do meaningful work with an io_uring fd that can't be
>>>>> controlled via an existing permission check please let me know.
>>>>
>>>> Thank you a lot for this explanation. However, IMHO we should not
>>>> confuse 2 somewhat different problems here:
>>>>
>>>> - protecting io_uring related resources (file descriptors, memory
>>>>   buffers) against unauthorized access
>>>>
>>>> - protecting the entire system against potential vulnerabilities in
>>>>   io_uring
>>>>
>>>> And while I agree that the existing permission checks should be already
>>>> sufficient for the former, I'm not quite sure they are sufficient for
>>>> the latter.
>>>
>>> ...
>>>
>>>> I already have a PoC patch [3] adding such LSM hook. But before I try to
>>>> submit it for upstream, I'd like to know your opinion on the whole idea.
>>>
>>> First please explain how the existing LSM/SELinux control points are
>>> not sufficient for restricting io_uring operations.  I'm looking for a
>>> real program flow that is able to "do meaningful work with an io_uring
>>> fd that can't be controlled via an existing permission check".
>>
>> As I said at the beginning of my reply, I agree with you that the
>> existing LSM controls are sufficient for restricting io_uring I/O
>> operations. That is not my concern here. The concern is: how to (and
>> do we need to) restrict triggering execution of *any* io_uring code in
>> kernel, *in addition to* restricting the actual io_uring operations.
> 
> If your concern is preventing *any* io_uring code from being executed,
> I would suggest simply not enabling io_uring at build time.  If you
> need to selectively enable io_uring for some subset of processes, you
> will need to make use of one of the options you discussed previously,
> e.g. a LSM, seccomp, etc.
> 
> From a LSM perspective, I don't believe we want to be in the business
> of blocking entire kernel subsystems from execution, rather we want to
> provide control points so that admins and users can have better, or
> more granular control over the security relevant operations that take
> place within the different kernel subsystems.
> 
>> In other words, "a real program doing a meaningful work with io_uring"
>> in this case would mean "an exploit for a real vulnerability in io_uring
>> code (in the current or any older kernel) which does not require an
>> access to io_uring operations to be exploited". I don't claim that such
>> vulnerabilities exist or are likely to be introduced in future kernels.
>> But I'm neither an io_uring expert nor, more importantly, a security
>> expert, so I cannot tell with confidence that they are not and we have
>> nothing to worry about here. So I'm interested in your and others'
>> opinion on that.
> 
> Once again, if you have serious concerns about the security or safety
> of an individual kernel subsystem, your best option is to simply build
> a kernel without that subsystem enabled.

Thanks for the answer. Yeah, disabling a problematic kernel subsystem at
build time is surely the safest option (and that is what we are already
doing in ChromeOS for io_uring, for that matter), and if we still want
to enable it for a limited subset of processes, it seems the cleanest
option is to use seccomp, rather than to add new ad-hoc LSM hooks for
blocking a specific subsystem.

One of the angles I'm coming from is actually the following:

- Android currently enables io_uring but limits its use to a few
  processes. But the way Android does that is by relying on the existing
  SELinux access controls for io_uring resources [1][2], rather than by
  preventing execution of any io_uring code via seccomp or other means.

  I guess the reason why Android doesn't use seccomp for that is the
  downsides of seccomp which I mentioned previously: in short, seccomp
  is well-suited for selectively denying syscalls for specific
  processes, but not so well-suited for selectively allowing them.

  So one of the questions I'm wondering about is: if Android implemented
  preventing execution of any io_uring code by non-trusted processes
  (via seccomp or any other way), how much would it help to reduce the
  risk of attacks, compared to its current SELinux based solution?

- ChromeOS currently completely disables io_uring in kernel, but we do
  want to allow it for a limited set of processes similarly to Android,
  and we are exploring ways to do it securely. Thus the above
  considerations for Android apply to ChromeOS as well.

[1] https://android-review.git.corp.google.com/c/platform/system/sepolicy/+/2302679
[2] https://android-review.git.corp.google.com/c/platform/system/sepolicy/+/2302679/6/public/te_macros
