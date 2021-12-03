Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18BB46802F
	for <lists+io-uring@lfdr.de>; Sat,  4 Dec 2021 00:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354224AbhLCXTx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Dec 2021 18:19:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233523AbhLCXTw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Dec 2021 18:19:52 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6234DC061751;
        Fri,  3 Dec 2021 15:16:28 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id k4so4493976pgb.8;
        Fri, 03 Dec 2021 15:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=H2tlWxxKk0y0zgMKzXY+FjZgjjuO8jF5VgKYcgWiYKk=;
        b=F1DJlGoun5eYiNj4OKd7aVJDHNgdrvSGnouPSxuOlPsVEDlsUpAaMiUdidLMRUIzwU
         D9cpaf/FzxbIlm6YczhQb+05U1aSMnKuEKlDqeaI93p0pazC6oZyC3r7vc+P3J/wLQri
         zu9sentqnxFm2OdJn07UA5ICC4vtrHIYd/Z1p46r/bTZuNacDPg+xz4p7T0e8f+TM9v/
         7mMjSE4FTTjNKl1ANWNVNkFT9g22uYc1sJCCpNR2db2m5MfctWfvS3DapgvGc4PhuPEW
         px+xoxeiC9aVf/l1AHqpRDhxzljYcW/sySgVSCbEbaS7ua6Hzdb2ulJN9s8SCWkK646Z
         qutQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H2tlWxxKk0y0zgMKzXY+FjZgjjuO8jF5VgKYcgWiYKk=;
        b=CcGIJAr2eJbMOEq+uxMPNDBaSZL9OgrgnhlFR/Uu4XG4hnhocdcnug93cW7yipgstB
         g1jDyQWpYaG8ZJFLJSX0yLqM+lybgsHqBUOBD1UfMVVd3zx7Fhm4sqATUkT5xJmYFpqH
         rrislAFuLbusC514RiruClr25kxOrt62xH2/2QmCLOV08czzJgtuvfphZljMRdU+7us3
         76ajooo7xWC3k8hvPWr2a3Lkn9FT9SqSlIDwUEMDpE2ZHj2mt3HIepXZTMBlgKgNW9DV
         rICs8MokQKkkCzeEnXQSEQ/J54GMsQdMdLRxVfpOLmUFv3xXOy+YRnyrnOEs/L5N0JVz
         CeDA==
X-Gm-Message-State: AOAM533YRPXdwLSSIKpZoKRxGNjdl0DyUtb8Y5w9TW4TyQ3Sw9hca5kW
        eqW+648pnS5JymgIwrXuHsbKRABt1/I=
X-Google-Smtp-Source: ABdhPJxeJWHXwHnCsd9sdh9N1OdXfW+7AZDzXM3JTDHm2cl/KcYduF7X7tXjpRzufyOsrGeRBw2K1g==
X-Received: by 2002:a05:6a00:1990:b0:4a4:ef57:fd72 with SMTP id d16-20020a056a00199000b004a4ef57fd72mr22358034pfl.2.1638573387785;
        Fri, 03 Dec 2021 15:16:27 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:502e:73f4:8af1:9522])
        by smtp.gmail.com with ESMTPSA id t67sm4276616pfd.24.2021.12.03.15.16.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 15:16:27 -0800 (PST)
Date:   Sat, 4 Dec 2021 04:46:24 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mihalicyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, criu@openvz.org,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 1/8] io_uring: Implement eBPF iterator for
 registered buffers
Message-ID: <20211203231624.pqxwzaz4boakudi3@apollo.legion>
References: <20211116054237.100814-1-memxor@gmail.com>
 <20211116054237.100814-2-memxor@gmail.com>
 <20211118220226.ritjbjeh5s4yw7hl@ast-mbp.dhcp.thefacebook.com>
 <20211119041523.cf427s3hzj75f7jr@apollo.localdomain>
 <20211119045659.vriegs5nxgszo3p3@ast-mbp.dhcp.thefacebook.com>
 <20211119051657.5334zvkcqga754z3@apollo.localdomain>
 <CAADnVQ+rdAh2LaHOHxqk7z4aheMQ2gjzMFegrehzEfE_6twBdg@mail.gmail.com>
 <aaf8aa08-f4ee-0688-2af3-2c59bb76dda6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaf8aa08-f4ee-0688-2af3-2c59bb76dda6@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Dec 03, 2021 at 09:22:54PM IST, Pavel Begunkov wrote:
> On 11/19/21 05:24, Alexei Starovoitov wrote:
> > [...]
> >
> > Also I'd like to hear what Jens and Pavel have to say about
> > applicability of CRIU to io_uring in general.
>

Hi Pavel, thanks for taking a look!

> First, we have no way to know what requests are in flight, without it
> CR doesn't make much sense. The most compelling way for me is to add
> a feature to fail all in-flights as it does when is closed. But maybe,
> you already did solve it somehow?

Indeed, as you note, there is no way to currently inspect in-flight requests,
what we can do is wait for a barrier operation to synchronize against all
previous requests.

So for now, my idea is to drain the ring (by waiting for all in-flight requests
to complete), by using a IOSQE_IO_DRAIN IORING_OP_NOP, and then waiting with a
fixed timeout (so that if forward progress depends on a blocked task/ourselves),
we can fail the dumping. This is ofcourse best effort, but it has worked well
for many of the cases I tested so far.

This might have some other issues, e.g. not being able to accommodate all posted
completions in the CQ ring due to unreaped completions from when it was
checkpointed. In that case we can simply give up, since otherwise recreating the
ring as it was becomes very hard if we let it trample over unread items (it is
unclear how I can send in completitions at restore that were in overflow list at
dump).

One idea I had in mind was to add support to post a dummy CQE entry (by
submitting a e.g. IORING_OP_NOP) where the fields of CQE are set during
submission time. This allows faking a completed request, then at restore we can
push all these into the overflow list and project the state as it were if the CQ
ring was full. At dump time it allows us to continually reap completion items.
If we detect that kernel doesn't support overflow, we fail.

Adjustment of the kernel side tail is not as hard (we can use IORING_OP_NOP
completitions to fill it up, then rewrite entries).

There were other operations (like registering buffers) that had similar side
effect of synchronization of ring state (waiting for it to become idle) before
returning to userspace, but that was pre-5.13.

Also we have to do this ring synchronization fairly early during the dump, since
it can lead to addition of other resources (e.g. fds) to the task that then need
to be dumped again.

> There is probably a way to restore registered buffers and files, though
> it may be tough considering that files may not have corresponding fds in
> the userspace, buffers may be unmapped, buffers may come from
> shmem/etc. and other corner cases.

See [0] for some explanation on all that. CRIU also knows if certain VMA comes
from shmem or not (whose restoration is already handled separately).

>
> There are also not covered here pieces of state, SELECT_BUFFER
> buffers, personalities (aka creds), registered eventfd, io-wq
> configuration, etc. I'm assuming you'll be checking them and
> failing CR if any of them is there.

Personalities are not as hard (IIUC), because all the required state is
available through fdinfo. In the PR linked in this thread, there is code to
parse it and restore using the saved credentials (though we might want to
implement UID mapping options, or either let the user do image rewriting for
that, which is a separate concern).

Ideally I'd like to be able to grab this state from the iterator as well, but it
needs atleast a bpf_xa_for_each helper, since io_uring's show_fdinfo skips some
crucial data when it detects contention over uring_lock (and doesn't indicate
this at all) :(. See the conditional printing on 'has_lock'.

SELECT_BUFFER is indeed unhandled rn. I'm contemplating ways on how to extend
the iterator so that it can loop over all items of generic structures like
Xarray in general while taking appropriate locks relevant for the specific hook
in particular. Both personalities registration and IORING_OP_PROVIDE_BUFFERS
insert use an Xarray, so it might make sense to rather add a bpf_xa_for_each
than introducing another iterator, and only mark it as safe for this iterator
context (where appropriate locks e.g. ctx->uring_lock is held).

For registered eventfd, and io-wq, you can look at [0] to see how I am solving
that, TLDR I just map the underlying structure to the open fd in the task. eBPF
is flexible enough to also allow state inspection in case e.g. the corresponding
eventfd is closed, so that we can recreate it, register, and then close again
when restoring. Same with files directly added to the fixed file set, the whole
idea was to bring in eBPF so that dumping these resources is possible when they
are "hidden" from normal view.

[0]: https://lore.kernel.org/bpf/20211201042333.2035153-11-memxor@gmail.com

>
> And the last point, there will be some stuff CR of which is
> likely to be a bad idea. E.g. registered dmabuf's,
> pre-registered DMA mappings, zerocopy contexts and so on.
>

Yes, we can just fail the dump for these cases. There are many other cases (in
general) where we just have to give up.

> IOW, if the first point is solved, there may be a subset of ring
> setups that can probably be CR. That should cover a good amount
> of cases. I don't have a strong opinion on the whole thing,
> I guess it depends on the amount of problems to implement
> in-flight cancellations.
>
> --
> Pavel Begunkov

--
Kartikeya
