Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520AB456981
	for <lists+io-uring@lfdr.de>; Fri, 19 Nov 2021 06:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbhKSF1e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Nov 2021 00:27:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbhKSF1e (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Nov 2021 00:27:34 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320F8C061574;
        Thu, 18 Nov 2021 21:24:33 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id o6-20020a17090a0a0600b001a64b9a11aeso7861723pjo.3;
        Thu, 18 Nov 2021 21:24:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9IDHNEjGPGvONU7x6f+PkPEoXhdxrms0/T5Tg3t65pM=;
        b=QvRRG0AO7JnNqk8ym6ubBMIFN9IgkfkXAcXiVf2NeAkexw/SYix0UnIEkSFTJrlVcl
         hW3EVLeg8OVYve5Hb7PdZoQLi+r+z7BZYlg337yqE1aQ2/bAPznOBlcPtV9vYdPSopCL
         cjV2NOCmGMZJwUZyBqQOhP8G5sLiEi+Iggmg7Le7BgVMTvZVaPWfXXQ27rXVVHTvEhRs
         IoE1iyMXeGlNLxvkiMpisI29uEWiTKA49nJMp7CGXLFeStrgozHGvV+e5crpVHBkdA/W
         st2CrY1nkmX6UtE6ugFxrAUiwWOa4UpJrgHurhVbbE/W8HfJDl6fd0PuELnPr86EJml0
         PjVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9IDHNEjGPGvONU7x6f+PkPEoXhdxrms0/T5Tg3t65pM=;
        b=GK5aLwTwv9qdOp0mbjJa4ukVBLt8p83cTolAO2MsHy18uNQr0V4XLVYcr5VSrohmoD
         9wOtDcMG7njxyWsdlWWIsDvRlU2etzc1uKTt8ExiwK2ElJGHBsvdqWeVlffDjIs3JyvS
         hDoCEQ4xgxK55zdUBUMe9TGRSlsZZO+lDQfzUpfC/ZvxpB5fWbD+kpsXNZShxMX4k2Ic
         EKL9Fp7O6z1zx3MpblPqqZ/Z8VSKFvk36E8AKuUBcnXnFKrulfcoAiYPlgWKQBEAgcNJ
         KtIbiXJdGYYaj9Xxpy539QnOAW8jzc2KXOwProGLNeCuv3HV1lfRmZoXGWThsTtcUSO9
         FWSA==
X-Gm-Message-State: AOAM531AOZZSIqnfRdg6myYvNK/jE9RR6W8kR7SvNt6Dnrb2MnRoEZbZ
        KrGsaiVnHJWnUuJWAvxF8GqSvYcpmkCDCqDoL4c=
X-Google-Smtp-Source: ABdhPJzgbhwyup9AIF5jH3P6fIwej2paCmuZCkDgrrDNXXYTDms4i/1OSBUkuYcC7vSiEUrlgQ6VOfRjelFK0vq+BEU=
X-Received: by 2002:a17:90a:1f45:: with SMTP id y5mr1402308pjy.138.1637299472703;
 Thu, 18 Nov 2021 21:24:32 -0800 (PST)
MIME-Version: 1.0
References: <20211116054237.100814-1-memxor@gmail.com> <20211116054237.100814-2-memxor@gmail.com>
 <20211118220226.ritjbjeh5s4yw7hl@ast-mbp.dhcp.thefacebook.com>
 <20211119041523.cf427s3hzj75f7jr@apollo.localdomain> <20211119045659.vriegs5nxgszo3p3@ast-mbp.dhcp.thefacebook.com>
 <20211119051657.5334zvkcqga754z3@apollo.localdomain>
In-Reply-To: <20211119051657.5334zvkcqga754z3@apollo.localdomain>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 18 Nov 2021 21:24:21 -0800
Message-ID: <CAADnVQ+rdAh2LaHOHxqk7z4aheMQ2gjzMFegrehzEfE_6twBdg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 1/8] io_uring: Implement eBPF iterator for
 registered buffers
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mihalicyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, criu@openvz.org,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Nov 18, 2021 at 9:17 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Fri, Nov 19, 2021 at 10:26:59AM IST, Alexei Starovoitov wrote:
> > On Fri, Nov 19, 2021 at 09:45:23AM +0530, Kumar Kartikeya Dwivedi wrote:
> > >
> > > Also, this work is part of GSoC. There is already code that is waiting for this
> > > to fill in the missing pieces [0]. If you want me to add a sample/selftest that
> > > demonstrates/tests how this can be used to reconstruct a task's io_uring, I can
> > > certainly do that. We've already spent a few months contemplating on a few
> > > approaches and this turned out to be the best/most powerful. At one point I had
> > > to scrap some my earlier patches completely because they couldn't work with
> > > descriptorless io_uring. Iterator seem like the best solution so far that can
> > > adapt gracefully to feature additions in something seeing as heavy development
> > > as io_uring.
> > >
> > >   [0]: https://github.com/checkpoint-restore/criu/commit/cfa3f405d522334076fc4d687bd077bee3186ccf#diff-d2cfa5a05213c854d539de003a23a286311ae81431026d3d50b0068c0cb5a852
> > >   [1]: https://github.com/checkpoint-restore/criu/pull/1597
> >
> > Is that the main PR? 1095 changed files? Is it stale or something?
> > Is there a way to view the actual logic that exercises these bpf iterators?
>
> No, there is no code exercising BPF iterator in that PR yet (since it wouldn't
> build/run in CI). There's some code I have locally that uses these to collect
> the necessary information, I can post that, either as a sample or selftest in
> the next version, or separately on GH for you to take a look.
>
> I still rebased it so that you can see the rest of the actual code.

I would like to see a working end to end solution.

Also I'd like to hear what Jens and Pavel have to say about
applicability of CRIU to io_uring in general.
