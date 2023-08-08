Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2E5774BB5
	for <lists+io-uring@lfdr.de>; Tue,  8 Aug 2023 22:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235496AbjHHUyS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Aug 2023 16:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234975AbjHHUyD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Aug 2023 16:54:03 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18016E92
        for <io-uring@vger.kernel.org>; Tue,  8 Aug 2023 13:40:18 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-4fe55d70973so299162e87.0
        for <io-uring@vger.kernel.org>; Tue, 08 Aug 2023 13:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1691527217; x=1692132017;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oZSqs7sM/xUmVsaO/VSjDJU2r/jf/ZAsFJ+wW/v/4VQ=;
        b=Ic+EnNRVXUzTYAXpEYsfEr1NfV/enaSn1Igw/2zybsivmi3UR+c/oQDsVZJst7UMp2
         m95xYUFdHf+aqi3mozANurNyKVennLDjtfsQyNoSGvJ7/l1AKFsaED5BBOhNPMUGG4NR
         MB+xmkQddGyZkjgE7V68r2aIArIAUgsddfuspvvC7rJwVgPoW1pvUwhaoHWPbmJzl/iQ
         IRgvbrMS22GC9cEEXbLwNszBC3l9cJlhYZ/+4IYDgDaPfGB4SvZ97mo4lRuFwO3PgXIV
         GyWlQmXpzdbo9SzzUaeQBt/1ctt+UIS7e3pNAa75+o5mmPeH/nl1DLyWrRDU6Sj57jYq
         kbDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691527217; x=1692132017;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oZSqs7sM/xUmVsaO/VSjDJU2r/jf/ZAsFJ+wW/v/4VQ=;
        b=UqNxZ0KoPBhqGfOeXehLh5xfRromIyRX2j0yv8TY9a0mMlR3hwlupz5DllBWgeUPnB
         UNN4A6OKI4vXdTy9+mQaNypIrJB9ctxHW5ONR7ie0rkSBK7kNzQ4qF4xj7UJrrEd8iL/
         7KHx+FyBoer7/1Cgx+lYVwt1wChHuO6MspyjQkqbJ6PDUKQGiRMQrAbxyuFZXZ7ySuza
         US1ccqTxKDMdZzImlMrnnJuby1bXw1HXOAp3O0bvqUYna3Ug/08APyKKoe0ioM11kZPi
         IZ+2hYOqt+J79/IFk+LgLSFyg/2/iDmt2zPADp7yLA6IFagOjInF0sEAF8LPtludMOs6
         EAog==
X-Gm-Message-State: AOJu0Yx2cyYJVtz3nU6UcTBib4DfWdg6l/6/UGAuhVwFthd+b9YS00qq
        LArq7yVswIHDuvgV2PyfIwV+aw==
X-Google-Smtp-Source: AGHT+IHTv3xkaJDrGPXG1XPcUqhBsHbFzNbsFXqbPKJJ1AU5sQwhzJBRzZO0FDaiRSmaa027Em3nBw==
X-Received: by 2002:a05:6512:239c:b0:4fe:7e3d:de7 with SMTP id c28-20020a056512239c00b004fe7e3d0de7mr359001lfv.29.1691527216259;
        Tue, 08 Aug 2023 13:40:16 -0700 (PDT)
Received: from [10.43.1.246] ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id a6-20020a19f806000000b004fe27229f55sm1981622lff.216.2023.08.08.13.40.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Aug 2023 13:40:15 -0700 (PDT)
Message-ID: <54c8fd9c-0edd-7fea-fd7a-5618859b0827@semihalf.com>
Date:   Tue, 8 Aug 2023 22:40:13 +0200
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
From:   Dmytro Maluka <dmy@semihalf.com>
In-Reply-To: <CAHC9VhRTWGuiMpJJiFrUpgsm7nQaNA-n1CYRMPS-24OLvzdA2A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Paul,

On 11/10/22 22:04, Paul Moore wrote:
> On Thu, Nov 10, 2022 at 12:54 PM Jeffrey Vander Stoep <jeffv@google.com> wrote:
>> On Mon, Nov 7, 2022 at 10:17 PM Paul Moore <paul@paul-moore.com> wrote:
>>>
>>> On Mon, Nov 7, 2022 at 3:58 PM Gil Cukierman <cukie@google.com> wrote:
>>>>
>>>> This patchset provides the changes required for controlling access to
>>>> the io_uring_setup system call by LSMs. It does this by adding a new
>>>> hook to io_uring. It also provides the SELinux implementation for a new
>>>> permission, io_uring { setup }, using the new hook.
>>>>
>>>> This is important because existing io_uring hooks only support limiting
>>>> the sharing of credentials and access to the sensitive uring_cmd file
>>>> op. Users of LSMs may also want the ability to tightly control which
>>>> callers can retrieve an io_uring capable fd from the kernel, which is
>>>> needed for all subsequent io_uring operations.
>>>
>>> It isn't immediately obvious to me why simply obtaining a io_uring fd
>>> from io_uring_setup() would present a problem, as the security
>>> relevant operations that are possible with that io_uring fd *should*
>>> still be controlled by other LSM hooks.  Can you help me understand
>>> what security issue you are trying to resolve with this control?
>>
>> I think there are a few reasons why we want this particular hook.
>>
>> 1.  It aligns well with how other resources are managed by selinux
>> where access to the resource is the first control point (e.g. "create"
>> for files, sockets, or bpf_maps, "prog_load" for bpf programs, and
>> "open" for perf_event) and then additional functionality or
>> capabilities require additional permissions.
> 
> [NOTE: there were two reply sections in your email, and while similar,
> they were not identical; I've trimmed the other for the sake of
> clarity]
> 
> The resources you mention are all objects which contain some type of
> information (either user data, configuration, or program
> instructions), with the resulting fd being a handle to those objects.
> In the case of io_uring the fd is a handle to the io_uring
> interface/rings, which by itself does not contain any information
> which is not already controlled by other permissions.
> 
> I/O operations which transfer data between the io_uring buffers and
> other system objects, e.g. IORING_OP_READV, are still subject to the
> same file access controls as those done by the application using
> syscalls.  Even the IORING_OP_OPENAT command goes through the standard
> VFS code path which means it will trigger the same access control
> checks as an open*() done by the application normally.
> 
> The 'interesting' scenarios are those where the io_uring operation
> servicing credentials, aka personalities, differ from the task
> controlling the io_uring.  However in those cases we have the new
> io_uring controls to gate these delegated operations.  Passing an
> io_uring fd is subject to the fd/use permission like any other fd.
> 
> Although perhaps the most relevant to your request is the fact that
> the io_uring inode is created using the new(ish) secure anon inode
> interface which ensures that the creating task has permission to
> create an io_uring.  This io_uring inode label also comes into play
> when a task attempts to mmap() the io_uring rings, a critical part of
> the io_uring API.
> 
> If I'm missing something you believe to be important, please share the details.
> 
>> 2. It aligns well with how resources are managed on Android. We often
>> do not grant direct access to resources (like memory buffers).
> 
> Accessing the io_uring buffers requires a task to mmap() the io_uring
> fd which is controlled by the normal SELinux mmap() access controls.
> 
>> 3. Attack surface management. One of the primary uses of selinux on
>> Android is to assess and limit attack surface (e.g.
>> https://twitter.com/jeffvanderstoep/status/1422771606309335043) . As
>> io_uring vulnerabilities have made their way through our vulnerability
>> management system, it's become apparent that it's complicated to
>> assess the impact. Is a use-after-free reachable? Creating
>> proof-of-concept exploits takes a lot of time, and often functionality
>> can be reached by multiple paths. How many of the known io_uring
>> vulnerabilities would be gated by the existing checks? How many future
>> ones will be gated by the existing checks? I don't know the answer to
>> either of these questions and it's not obvious. This hook makes that
>> initial assessment simple and effective.
> 
> It should be possible to deny access to io_uring via the anonymous
> inode labels, the mmap() controls, and the fd/use permission.  If you
> find a way to do meaningful work with an io_uring fd that can't be
> controlled via an existing permission check please let me know.

Thank you a lot for this explanation. However, IMHO we should not
confuse 2 somewhat different problems here:

- protecting io_uring related resources (file descriptors, memory
  buffers) against unauthorized access

- protecting the entire system against potential vulnerabilities in
  io_uring

And while I agree that the existing permission checks should be already
sufficient for the former, I'm not quite sure they are sufficient for
the latter.

(The background behind these concerns is: due to a high number of major
vulnerabilities frequently found in io_uring, we consider the io_uring
subsystem insecure as a whole; however, since io_uring brings serious
performance advantages for some I/O intensive applications, we are
willing to take the risk of enabling io_uring in kernel, as long as we
can guarantee that only a small set of trusted userspace programs are
allowed to use it, so that the rest of programs are not able to exploit
vulnerabilities in it.)

So, it seems that in order to prevent a userspace process from
exploiting vulnerabilities in io_uring, we need to prevent it from
triggering execution of any io_uring code in kernel at all, not just
from accessing io_uring resources. (Which, in particular, means that an
LSM hook for io_uring_setup() is not enough for that, we'd need to add
the LSM checks to the entry points of the other 2 io_uring syscalls as
well.)

Although, in fact, denying access to io_uring resources via existing
security checks does, as a side effect, also prevent many of io_uring
vulnerabilities (probably most of them) from being exploited. But can we
be sure that it prevents all of them? (In other words, can we be sure
that any code paths in io_uring not guarded by existing security checks
are trivial enough to assume that vulnerabilities in those code paths
are unlikely?)

Now, assuming that we cannot be sure of that and thus do need a way to
prevent triggering any io_uring kernel code by non-trusted processes, -
there are ways to do that without LSM, but those ways have some
drawbacks:

One option is to use the io_uring_disabled sysctl implemented recently
in [1]. But:

  - That would require trusted processes (i.e. those which we want to
    allow using io_uring) to have CAP_SYS_ADMIN, i.e. way too much
    privilege in the general case. Also, anyone with CAP_SYS_ADMIN, not
    just our trusted processes, would be allowed to use io_uring.

  - There was a proposal [2] to extend this sysctl to allow io_uring for
    processes in a specific group, instead of requiring CAP_SYS_ADMIN.
    But it would still only provide discretionary control: anyone who
    becomes a member of the group can use io_uring.

  - Also, [1] still adds the check to io_uring_setup() only, not to the
    other two syscalls, i.e. still assumes that denying access to
    io_uring objects is enough to prevent attacks on the kernel.

Another option is to use seccomp. For example, the init process could
implement enforcing seccomp filters blocking io_uring syscalls for all
its child processes except the trusted ones. Such a solution does not
even require new changes in kernel, but it has its downsides too:

  - It imposes limitations on the userspace environment, e.g. the init
    system needs to implement this seccomp enforcement, the trusted
    processes need to be children of the init, etc.

  - It is still not fully non-discretionary: trusted processes may
    execute other (non-trusted) programs which then can use io_uring
    too.

  - It has system-wide performance implications: seccomp overhead added
    to all syscalls from any processes that would not have any seccomp
    filter installed otherwise.

So, if we want a solution avoiding the above drawbacks, i.e. providing
more mandatory control and having less intrusive impact on the overall
userspace environment, a possible option is to use LSM: add a new LSM
hook, e.g. uring_allowed, invoked on entry points of all io_uring
syscalls.

I already have a PoC patch [3] adding such LSM hook. But before I try to
submit it for upstream, I'd like to know your opinion on the whole idea.

[1] https://lore.kernel.org/io-uring/20230630151003.3622786-1-matteorizzo@google.com/
[2] https://lore.kernel.org/io-uring/20230726174549.cg4jgx2d33fom4rb@awork3.anarazel.de/
[3] https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/4705534/3

Thanks
