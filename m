Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826B862918D
	for <lists+io-uring@lfdr.de>; Tue, 15 Nov 2022 06:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbiKOFjn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Nov 2022 00:39:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiKOFjn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Nov 2022 00:39:43 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52E71B9D1
        for <io-uring@vger.kernel.org>; Mon, 14 Nov 2022 21:39:40 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id ud5so33499906ejc.4
        for <io-uring@vger.kernel.org>; Mon, 14 Nov 2022 21:39:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9K3V25osQLREMG6ZUk7AC0ZkFnZLHBbL3WZnP0tsfH4=;
        b=lP1c+QctBSuAkoA0Voq5SO1rZHAodr96QmUnxvNWlD5+dWN0+a+G2GJSKPjIWX/FP2
         yEf+NE2GSx/2I5MZekALkcGZ8fWAnnGpaxXL47vF1dPwqA/e4AVM2x9VT96NMomw6PIM
         NFiXrtCZPAgVWLg3AbpT7mEzwkJKD1dRuwghDCmDown3PemV71JAfKEJAK18qY+R1drY
         yTGHzc6xOjYGTZJL1+eK79Pf9py2dwz8vvc49geY7D98Q+v/bHXRmmcO7rWyP1SxOSp3
         wLBijaAXnhZPHyAAk0yHwAwelCZATdN4NJbqmolDb7AvnOEHfNz/ut64iBqOyb6ykDlT
         f76g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9K3V25osQLREMG6ZUk7AC0ZkFnZLHBbL3WZnP0tsfH4=;
        b=4cLamR/lFZbZUT+AE48VTQNFARiuHOPF+t7BwpSpK2f+O6KRXXLvgXeVP4mVTn9OcH
         bepBZcBiXWYjs905QMKt5i8OBwpR2hpudOCQRwh/m9SnDAXyIUVYX5T7j1iyQmgJYgnQ
         my4XTmVNm/q8IfkFKhspLsO6vyU/PCKRBpSRe5JLunRDtz2rcDpb3YBT2+Hc2HKeTTAu
         EmE5eg/l7yKqNd/Zw/bW/MQZIQAIzZ7Pi80ZkscUUog60tumMlfJuko6tjIarljKA8/i
         YM5Z+fuQPFCM5LicZRqVwY2+Q+qvnlySnXjzDNJXJXMjlKRPXByOqg+Di23Uz6UqV8kL
         HeGQ==
X-Gm-Message-State: ANoB5pkENoL4txMsFjwa4dxU7+fZyps5TuyG5rdDjWq7dL5PSklp6Vth
        61BJAbQfHwFuqxBEoOl0Eip/2v4olE0OMQ33HTIM5dG9gxs=
X-Google-Smtp-Source: AA0mqf493ZLOHNguaLcfeGRl3oJcG1IBsHoRBk8cyDf4TKkHQT186EwcYZmwKDfunLnNwgS4fJ8HQ1Oe3Tv40FbbsyU=
X-Received: by 2002:a17:906:71b:b0:7ad:9892:91e8 with SMTP id
 y27-20020a170906071b00b007ad989291e8mr12896729ejb.620.1668490779010; Mon, 14
 Nov 2022 21:39:39 -0800 (PST)
MIME-Version: 1.0
References: <20221107205754.2635439-1-cukie@google.com> <CAHC9VhTLBWkw2XzqdFx1LFVKDtaAL2pEfsmm+LEmS0OWM1mZgA@mail.gmail.com>
 <CABXk95ChjusTneWJgj5a58CZceZv0Ay-P-FwBcH2o4rO0g2Ggw@mail.gmail.com>
 <CGME20221114143147eucas1p1902d9b4afc377fdda25910a5d083e3dc@eucas1p1.samsung.com>
 <CAHC9VhRTWGuiMpJJiFrUpgsm7nQaNA-n1CYRMPS-24OLvzdA2A@mail.gmail.com> <20221114143145.ha22rdxphhpgd53u@localhost>
In-Reply-To: <20221114143145.ha22rdxphhpgd53u@localhost>
From:   Jeffrey Vander Stoep <jeffv@google.com>
Date:   Tue, 15 Nov 2022 06:39:26 +0100
Message-ID: <CABXk95BxnZWPEg397cAW0uXi2NxZpODVYPByyQOxP2LO08Gjug@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] Add LSM access controls for io_uring_setup
To:     Joel Granados <j.granados@samsung.com>
Cc:     Paul Moore <paul@paul-moore.com>, Gil Cukierman <cukie@google.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Super helpful, thanks Paul! We'll look into this and get back to you
if it doesn't fit our needs.

On Mon, Nov 14, 2022 at 3:31 PM Joel Granados <j.granados@samsung.com> wrote:
>
> On Thu, Nov 10, 2022 at 04:04:46PM -0500, Paul Moore wrote:
> > On Thu, Nov 10, 2022 at 12:54 PM Jeffrey Vander Stoep <jeffv@google.com> wrote:
> > > On Mon, Nov 7, 2022 at 10:17 PM Paul Moore <paul@paul-moore.com> wrote:
> > > >
> > > > On Mon, Nov 7, 2022 at 3:58 PM Gil Cukierman <cukie@google.com> wrote:
> > > > >
> > > > > This patchset provides the changes required for controlling access to
> > > > > the io_uring_setup system call by LSMs. It does this by adding a new
> > > > > hook to io_uring. It also provides the SELinux implementation for a new
> > > > > permission, io_uring { setup }, using the new hook.
> > > > >
> > > > > This is important because existing io_uring hooks only support limiting
> > > > > the sharing of credentials and access to the sensitive uring_cmd file
> > > > > op. Users of LSMs may also want the ability to tightly control which
> > > > > callers can retrieve an io_uring capable fd from the kernel, which is
> > > > > needed for all subsequent io_uring operations.
> > > >
> > > > It isn't immediately obvious to me why simply obtaining a io_uring fd
> > > > from io_uring_setup() would present a problem, as the security
> > > > relevant operations that are possible with that io_uring fd *should*
> > > > still be controlled by other LSM hooks.  Can you help me understand
> > > > what security issue you are trying to resolve with this control?
> > >
> > > I think there are a few reasons why we want this particular hook.
> > >
> > > 1.  It aligns well with how other resources are managed by selinux
> > > where access to the resource is the first control point (e.g. "create"
> > > for files, sockets, or bpf_maps, "prog_load" for bpf programs, and
> > > "open" for perf_event) and then additional functionality or
> > > capabilities require additional permissions.
> >
> > [NOTE: there were two reply sections in your email, and while similar,
> > they were not identical; I've trimmed the other for the sake of
> > clarity]
> >
> > The resources you mention are all objects which contain some type of
> > information (either user data, configuration, or program
> > instructions), with the resulting fd being a handle to those objects.
> > In the case of io_uring the fd is a handle to the io_uring
> > interface/rings, which by itself does not contain any information
> > which is not already controlled by other permissions.
> >
> > I/O operations which transfer data between the io_uring buffers and
> > other system objects, e.g. IORING_OP_READV, are still subject to the
> > same file access controls as those done by the application using
> > syscalls.  Even the IORING_OP_OPENAT command goes through the standard
> > VFS code path which means it will trigger the same access control
> > checks as an open*() done by the application normally.
> >
> > The 'interesting' scenarios are those where the io_uring operation
> > servicing credentials, aka personalities, differ from the task
> > controlling the io_uring.  However in those cases we have the new
> > io_uring controls to gate these delegated operations.  Passing an
> > io_uring fd is subject to the fd/use permission like any other fd.
> >
> > Although perhaps the most relevant to your request is the fact that
> > the io_uring inode is created using the new(ish) secure anon inode
> > interface which ensures that the creating task has permission to
> > create an io_uring.  This io_uring inode label also comes into play
> > when a task attempts to mmap() the io_uring rings, a critical part of
> > the io_uring API.
> >
> > If I'm missing something you believe to be important, please share the details.
> >
> > > 2. It aligns well with how resources are managed on Android. We often
> > > do not grant direct access to resources (like memory buffers).
> >
> > Accessing the io_uring buffers requires a task to mmap() the io_uring
> > fd which is controlled by the normal SELinux mmap() access controls.
> >
> > > 3. Attack surface management. One of the primary uses of selinux on
> > > Android is to assess and limit attack surface (e.g.
> > > https://twitter.com/jeffvanderstoep/status/1422771606309335043) . As
> > > io_uring vulnerabilities have made their way through our vulnerability
> > > management system, it's become apparent that it's complicated to
> > > assess the impact. Is a use-after-free reachable? Creating
> > > proof-of-concept exploits takes a lot of time, and often functionality
> > > can be reached by multiple paths. How many of the known io_uring
> > > vulnerabilities would be gated by the existing checks? How many future
> > > ones will be gated by the existing checks? I don't know the answer to
> > > either of these questions and it's not obvious. This hook makes that
> > > initial assessment simple and effective.
> >
> > It should be possible to deny access to io_uring via the anonymous
> > inode labels, the mmap() controls, and the fd/use permission.  If you
> > find a way to do meaningful work with an io_uring fd that can't be
> > controlled via an existing permission check please let me know.
>
> Also interested in a more specific case. Sending reply so I get added to
> the group response.
> >
> > --
> > paul-moore.com
