Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7CC456A12
	for <lists+io-uring@lfdr.de>; Fri, 19 Nov 2021 07:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbhKSGPX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Nov 2021 01:15:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbhKSGPV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Nov 2021 01:15:21 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91BCC061757;
        Thu, 18 Nov 2021 22:12:20 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id q17so7315044plr.11;
        Thu, 18 Nov 2021 22:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0vlFTFNGU4TzImjGgcP9WVs/xDWGV6QhBtB/igQrgA4=;
        b=X7/coZFc3LVK0ZZb/OnK+LCoxog0ZJTF699urYd6fPETAfpodMkL6g/3ZgSqHKs5z2
         afc3s3MuBToYBDB7mArLWqa17pi+OlpDK3Q6LrdxBkzYeEsWnDDQ7lsas/k89W6r/ggo
         bCa4a3tcJ1uwa/P2cFbfqnJjDMgZQRyL95aBf5TbRZV3C+8HE62xARRMrpndcWqfpIH7
         Q6UItcpEh67LBz6JjF/lPrO4E6w7NwaIHW8KYRl+xi7Yn61gEhdtP4rSoB4WZ3uYykUJ
         6s4TKjXYLJSv6OVOZVtq2gYHCZxaGdI71xUN8IHOwvWwJYtWS2sLiVC8hb0sOA7QqzcN
         5uzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0vlFTFNGU4TzImjGgcP9WVs/xDWGV6QhBtB/igQrgA4=;
        b=iNR3/kEo7VnU/qfIKh5XN178Dy4uk7bb7mIrzV/s/wlgrtE6W+FtXVgCdTVvsH8Jrg
         m102mAi/gVM7jCN3PtJX5BVRXDqX2yWwNLZ/Y+MpErqh4fpxIju8pwlNbU4GnGEXedM0
         0cBQMHq9A2JNbFRKt4PvhdlBffeUMju3f0bL1IIuMjpZEaMJO5NEFiGbdDGDU+0bvz/9
         puS/Od08+Cf/Otjth6baMFBGCAMrk8V5qrexXpZ6SRMDpb82d1qq7Vjr0uIKqwEIrLs6
         p4k5Kj3YUy7zA1385VCZv4MHblQWmi3p5R3Vj54RNwPPobv0acIYkKL1R9aWdR59bjM2
         GAqw==
X-Gm-Message-State: AOAM532cs7IH+qOp2FkvUf9fYndVgMoWcAy+I3F2+EVGEN+cIxhS2wXF
        qSf0zD2SnNDt6QZyfsYXcFM=
X-Google-Smtp-Source: ABdhPJxI4BfYYOZRQP+jdrzJ/tejEWy9hQ0mjL5s/RWDjxlO0QpAnXIUcYBXTDeJpxrk5shmSgjJww==
X-Received: by 2002:a17:90b:1c06:: with SMTP id oc6mr1699541pjb.126.1637302340312;
        Thu, 18 Nov 2021 22:12:20 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:502e:73f4:8af1:9522])
        by smtp.gmail.com with ESMTPSA id oa17sm1192722pjb.37.2021.11.18.22.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 22:12:19 -0800 (PST)
Date:   Fri, 19 Nov 2021 11:42:15 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mihalicyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, criu@openvz.org,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 1/8] io_uring: Implement eBPF iterator for
 registered buffers
Message-ID: <20211119061215.3kcz6r6em7g4p3vr@apollo.localdomain>
References: <20211116054237.100814-1-memxor@gmail.com>
 <20211116054237.100814-2-memxor@gmail.com>
 <20211118220226.ritjbjeh5s4yw7hl@ast-mbp.dhcp.thefacebook.com>
 <20211119041523.cf427s3hzj75f7jr@apollo.localdomain>
 <20211119045659.vriegs5nxgszo3p3@ast-mbp.dhcp.thefacebook.com>
 <20211119051657.5334zvkcqga754z3@apollo.localdomain>
 <CAADnVQ+rdAh2LaHOHxqk7z4aheMQ2gjzMFegrehzEfE_6twBdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+rdAh2LaHOHxqk7z4aheMQ2gjzMFegrehzEfE_6twBdg@mail.gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Nov 19, 2021 at 10:54:21AM IST, Alexei Starovoitov wrote:
> On Thu, Nov 18, 2021 at 9:17 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > On Fri, Nov 19, 2021 at 10:26:59AM IST, Alexei Starovoitov wrote:
> > > On Fri, Nov 19, 2021 at 09:45:23AM +0530, Kumar Kartikeya Dwivedi wrote:
> > > >
> > > > Also, this work is part of GSoC. There is already code that is waiting for this
> > > > to fill in the missing pieces [0]. If you want me to add a sample/selftest that
> > > > demonstrates/tests how this can be used to reconstruct a task's io_uring, I can
> > > > certainly do that. We've already spent a few months contemplating on a few
> > > > approaches and this turned out to be the best/most powerful. At one point I had
> > > > to scrap some my earlier patches completely because they couldn't work with
> > > > descriptorless io_uring. Iterator seem like the best solution so far that can
> > > > adapt gracefully to feature additions in something seeing as heavy development
> > > > as io_uring.
> > > >
> > > >   [0]: https://github.com/checkpoint-restore/criu/commit/cfa3f405d522334076fc4d687bd077bee3186ccf#diff-d2cfa5a05213c854d539de003a23a286311ae81431026d3d50b0068c0cb5a852
> > > >   [1]: https://github.com/checkpoint-restore/criu/pull/1597
> > >
> > > Is that the main PR? 1095 changed files? Is it stale or something?
> > > Is there a way to view the actual logic that exercises these bpf iterators?
> >
> > No, there is no code exercising BPF iterator in that PR yet (since it wouldn't
> > build/run in CI). There's some code I have locally that uses these to collect
> > the necessary information, I can post that, either as a sample or selftest in
> > the next version, or separately on GH for you to take a look.
> >
> > I still rebased it so that you can see the rest of the actual code.
>
> I would like to see a working end to end solution.
>

Understood, I'll address this in v2.

> Also I'd like to hear what Jens and Pavel have to say about
> applicability of CRIU to io_uring in general.

--
Kartikeya
