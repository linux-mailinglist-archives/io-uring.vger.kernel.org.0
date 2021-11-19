Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF28D456972
	for <lists+io-uring@lfdr.de>; Fri, 19 Nov 2021 06:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbhKSFUC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Nov 2021 00:20:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhKSFUC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Nov 2021 00:20:02 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7C1C061574;
        Thu, 18 Nov 2021 21:17:01 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id 136so7694340pgc.0;
        Thu, 18 Nov 2021 21:17:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fx0dGgFJCOx9/LzOB3ogiZG9ij2DHDjGtsNy7kSo8Gc=;
        b=PFFK3XQYWK1QQMuaJW08fpKh4RabDd4ReUgPkCBW8vYpqehqruhYOUK3/Ez+1RgBOy
         L0R4YPtEt4jw27CGMZF8bcV3bERLQubVypVeS8/nQAbVNY7URKBM58YIZ/9AIDbC9Igu
         yPwXyWKPaDVFK7opSU75Zt4YJHYgOUE8fFwoqpnKiwSauIVkiu9b8Vr+dt+bgQ5LLmOm
         TSwfDBe1iRolBzXcqYsBijD28YlCxpkIRJL1DMTuzIjNXrLebPheh4DBGyENcVtoDSvH
         4bspwava1NppJ7v73ST+uWI5xbxkI6n2B2AFS5xmGh2/R376Vg8/FtGWBBmXSpFw5F9R
         KdwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fx0dGgFJCOx9/LzOB3ogiZG9ij2DHDjGtsNy7kSo8Gc=;
        b=cjotaCy/X32KXdTfoVjVLRFfTWT1eluuLVl+7zFJ937SDvge5S8qKZwX9gefLSxB2a
         FO4FJYGBZB4AdxQnYgkOB1daKCa7Yy3ITaCGOQwVhABrhd12hhhHVk7LX+7VV79GzJ0C
         sv2JLsxd/AQZLZf4NYZSFIrdy2pXgz6wJ/p1EU0WsikJamQlX3bFzH+Pf67+/h//lSWE
         iYdkVrQ6M3POUnSXYdP6F1hwDRRYWbUxYfXTNSSdAKpb+7A6vpmStVo/dC0e9WoOlk1E
         EeDPAi4sMLhvp2SS7HbB3Yn1hq1xFdRrUcm6/qXm9K/iOMYVtjZgaNkAvo+mUhg0DRnv
         u8WA==
X-Gm-Message-State: AOAM531AcmWc0UEeZs20GBljEuwIBUdKNi9jvMVa+3q6VtXF6ajU6jNk
        6OGZdIiyIflwgaQKrLBJ4V4=
X-Google-Smtp-Source: ABdhPJxlgmmYEDNwG2YYNQfU90fF9/0iomNeB042ruJ5L6TUD+lPTaLld4kROA6MGILfnbbP4gFUUg==
X-Received: by 2002:a62:dd0d:0:b0:494:6e7a:23d with SMTP id w13-20020a62dd0d000000b004946e7a023dmr20589827pff.17.1637299020670;
        Thu, 18 Nov 2021 21:17:00 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:502e:73f4:8af1:9522])
        by smtp.gmail.com with ESMTPSA id m18sm1368055pfk.68.2021.11.18.21.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 21:17:00 -0800 (PST)
Date:   Fri, 19 Nov 2021 10:46:57 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mihalicyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, criu@openvz.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 1/8] io_uring: Implement eBPF iterator for
 registered buffers
Message-ID: <20211119051657.5334zvkcqga754z3@apollo.localdomain>
References: <20211116054237.100814-1-memxor@gmail.com>
 <20211116054237.100814-2-memxor@gmail.com>
 <20211118220226.ritjbjeh5s4yw7hl@ast-mbp.dhcp.thefacebook.com>
 <20211119041523.cf427s3hzj75f7jr@apollo.localdomain>
 <20211119045659.vriegs5nxgszo3p3@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119045659.vriegs5nxgszo3p3@ast-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Nov 19, 2021 at 10:26:59AM IST, Alexei Starovoitov wrote:
> On Fri, Nov 19, 2021 at 09:45:23AM +0530, Kumar Kartikeya Dwivedi wrote:
> >
> > Also, this work is part of GSoC. There is already code that is waiting for this
> > to fill in the missing pieces [0]. If you want me to add a sample/selftest that
> > demonstrates/tests how this can be used to reconstruct a task's io_uring, I can
> > certainly do that. We've already spent a few months contemplating on a few
> > approaches and this turned out to be the best/most powerful. At one point I had
> > to scrap some my earlier patches completely because they couldn't work with
> > descriptorless io_uring. Iterator seem like the best solution so far that can
> > adapt gracefully to feature additions in something seeing as heavy development
> > as io_uring.
> >
> >   [0]: https://github.com/checkpoint-restore/criu/commit/cfa3f405d522334076fc4d687bd077bee3186ccf#diff-d2cfa5a05213c854d539de003a23a286311ae81431026d3d50b0068c0cb5a852
> >   [1]: https://github.com/checkpoint-restore/criu/pull/1597
>
> Is that the main PR? 1095 changed files? Is it stale or something?
> Is there a way to view the actual logic that exercises these bpf iterators?

No, there is no code exercising BPF iterator in that PR yet (since it wouldn't
build/run in CI). There's some code I have locally that uses these to collect
the necessary information, I can post that, either as a sample or selftest in
the next version, or separately on GH for you to take a look.

I still rebased it so that you can see the rest of the actual code.

--
Kartikeya
