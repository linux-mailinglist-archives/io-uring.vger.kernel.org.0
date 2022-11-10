Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B29006248B8
	for <lists+io-uring@lfdr.de>; Thu, 10 Nov 2022 18:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbiKJRyR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Nov 2022 12:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbiKJRyQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Nov 2022 12:54:16 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C05749B68
        for <io-uring@vger.kernel.org>; Thu, 10 Nov 2022 09:54:15 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id 13so6987122ejn.3
        for <io-uring@vger.kernel.org>; Thu, 10 Nov 2022 09:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kfHz50Kg7kyBZpgLz1L+duIpLshaF3vQXrti1dXGZLQ=;
        b=himkAUve95kura1F4xyrjgF2Ao9L01DaBYcsivT7aKJ5J4AF6ajPklOMnZ88snF8S/
         Sm6FEemOqLF/MrgUC5yLIaXtMop2DLyIxPzRPUoUFaA5aKTYxAFSqWUMJk850gnqShNb
         wE7XZ4ZD0YABNLuFjY+X3KglYL7nJG8JNkkvLu3QJtRk3djhDQghiY7LCQX3IS7glCq2
         M3Z3rUTcmamKd9fp2ozIcuSHynhl1Xgi/GnqGciIWHpaSJNBKuTCOn3Ej65qPgsyN7ok
         8FB28sjmPUx11WchT1uogNEcf84eSNHyyoLzumQXLDUlwM/q3BMdB2xufOMmSmbksCWm
         YjnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kfHz50Kg7kyBZpgLz1L+duIpLshaF3vQXrti1dXGZLQ=;
        b=nau5r6nvfArkQh5EhGrU3TiRqZz5mnqSYZbare2OlYd899JQUJ1JvO9OX14PUxtrip
         aFmk3p0UmwggmxWshXZ29/4h2cyGMe1DYlHSwHUm6wjRK6oTkpdvy1cutxAldSyUoU49
         7Xn8p3MkSoVEGUyLBwJyaba2s7iRULd6L2To/ivrUGwiKQfTJ7DK5Nxd7W3o3QvaW+Sb
         EvBON47ZNFSx5UjaybDaGy/5RKiSgaI4Tx4gGHdm5MpS8Dm4gzdhxEZiOBBzjzu7+NYn
         zURpx2vHbCbH/eQR9/xgsTT2WpP4Gvockbr1uprpntMPmZmF7zrT1BhWWHydCyiFkuas
         5Nxw==
X-Gm-Message-State: ACrzQf01mOEZ8wPET/wZH+u6j434gaDL/UmwO/CmODD0Q835uqFogJ7C
        WyMtR9XSci2PPrHmFbG5Kj3WSQ3itB6VAmC3zNDIdg==
X-Google-Smtp-Source: AMsMyM6vrGhmh/p4SKFqy2anpSAGg2zavB8DiqImU+Pk6mNYMjVBxK6TvhzwwuErIW2caX7ljkBnR/t2VrPytOoRZ6I=
X-Received: by 2002:a17:906:b34b:b0:7ad:e8dd:837c with SMTP id
 cd11-20020a170906b34b00b007ade8dd837cmr3571084ejb.264.1668102853085; Thu, 10
 Nov 2022 09:54:13 -0800 (PST)
MIME-Version: 1.0
References: <20221107205754.2635439-1-cukie@google.com> <CAHC9VhTLBWkw2XzqdFx1LFVKDtaAL2pEfsmm+LEmS0OWM1mZgA@mail.gmail.com>
In-Reply-To: <CAHC9VhTLBWkw2XzqdFx1LFVKDtaAL2pEfsmm+LEmS0OWM1mZgA@mail.gmail.com>
From:   Jeffrey Vander Stoep <jeffv@google.com>
Date:   Thu, 10 Nov 2022 18:54:00 +0100
Message-ID: <CABXk95ChjusTneWJgj5a58CZceZv0Ay-P-FwBcH2o4rO0g2Ggw@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] Add LSM access controls for io_uring_setup
To:     Paul Moore <paul@paul-moore.com>
Cc:     Gil Cukierman <cukie@google.com>, Jens Axboe <axboe@kernel.dk>,
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Paul,

There are a few reasons why we want this particular hook.

1.  It aligns well with how other resources are managed by selinux
where access to the resource is the first control point (e.g. "create"
for files, sockets, or bpf_maps, "prog_load" for bpf programs, and
"open" for perf_event) and then additional functionality or
capabilities require additional permissions.
2. It aligns well with how resources are managed on Android. We often
do not grant direct access to resources (like memory buffers). For
example, a single domain on Android manages the loading of all bpf
programs and the creation of all bpf maps. Other domains can be
granted access to these only once they're created. We can enforce base
properties with MAC, while allowing the system to manage and grant
access to resources at run-time via DAC (e.g. using Android's
permission model). This allows us to do better management and
accounting of resources.
3. Attack surface management. One of the primary uses of selinux on
Android is to assess and limit attack surface (e.g.
https://twitter.com/jeffvanderstoep/status/1422771606309335043) . As
io_uring vulnerabilities have made their way through our vulnerability
management system, it's become apparent that it's complicated to
assess the impact. Is a use-after-free reachable? Creating
proof-of-concept exploits takes a lot of time, and often functionality
can be reached by multiple paths. How many of the known io_uring
vulnerabilities would be gated by the existing checks? How many future
ones will be gated by the existing checks? I don't know the answer to
either of these questions and it's not obvious. I believe some of them
currently are exploitable without any selinux permissions. But in any
case, this hook makes that initial assessment simple and effective.

On Mon, Nov 7, 2022 at 10:17 PM Paul Moore <paul@paul-moore.com> wrote:
>
> On Mon, Nov 7, 2022 at 3:58 PM Gil Cukierman <cukie@google.com> wrote:
> >
> > This patchset provides the changes required for controlling access to
> > the io_uring_setup system call by LSMs. It does this by adding a new
> > hook to io_uring. It also provides the SELinux implementation for a new
> > permission, io_uring { setup }, using the new hook.
> >
> > This is important because existing io_uring hooks only support limiting
> > the sharing of credentials and access to the sensitive uring_cmd file
> > op. Users of LSMs may also want the ability to tightly control which
> > callers can retrieve an io_uring capable fd from the kernel, which is
> > needed for all subsequent io_uring operations.
>
> It isn't immediately obvious to me why simply obtaining a io_uring fd
> from io_uring_setup() would present a problem, as the security
> relevant operations that are possible with that io_uring fd *should*
> still be controlled by other LSM hooks.  Can you help me understand
> what security issue you are trying to resolve with this control?


I think there are a few reasons why we want this particular hook.

1.  It aligns well with how other resources are managed by selinux
where access to the resource is the first control point (e.g. "create"
for files, sockets, or bpf_maps, "prog_load" for bpf programs, and
"open" for perf_event) and then additional functionality or
capabilities require additional permissions.
2. It aligns well with how resources are managed on Android. We often
do not grant direct access to resources (like memory buffers). For
example, a single domain on Android manages the loading of all bpf
programs and the creation of all bpf maps. Other domains can be
granted access to these only once they're created. We can enforce base
properties with MAC, while allowing the system to manage and grant
access to resources at run-time via DAC (e.g. using Android's
permission model). This allows us to do better management and
accounting of resources.
3. Attack surface management. One of the primary uses of selinux on
Android is to assess and limit attack surface (e.g.
https://twitter.com/jeffvanderstoep/status/1422771606309335043) . As
io_uring vulnerabilities have made their way through our vulnerability
management system, it's become apparent that it's complicated to
assess the impact. Is a use-after-free reachable? Creating
proof-of-concept exploits takes a lot of time, and often functionality
can be reached by multiple paths. How many of the known io_uring
vulnerabilities would be gated by the existing checks? How many future
ones will be gated by the existing checks? I don't know the answer to
either of these questions and it's not obvious. This hook makes that
initial assessment simple and effective.
>

>
> --
> paul-moore.com
