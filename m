Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3C37C8B2C
	for <lists+io-uring@lfdr.de>; Fri, 13 Oct 2023 18:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbjJMQXD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Oct 2023 12:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbjJMQWl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Oct 2023 12:22:41 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CAE41984;
        Fri, 13 Oct 2023 09:22:33 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D077C433C8;
        Fri, 13 Oct 2023 16:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697214153;
        bh=77wzV9MEoTXLXfQTuKRRmBfTs1SSurFIFiGTL+MyTDY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R14unBPRHsceasa7071+fmC82i7CgNT4e9sYuWd7ckZA9bsebHSt6D3G4DtzXH11T
         jYQtoXu9YqxIme3RHsPYrLzzNLoXtALd88VDpD6kRtX+XHt5pQUCk5pEIPcctqxmVX
         GSLvysb1y10jRfhW9CrsGjnIhmVK6CeUSXlpP8MZZDW1SanPraU7pO9CoGbAdaLUQP
         W41kE0Q/WQ66m2HnuVgIEvnx8QkmPmf2UJvusIbTUfTkZI47ZDVGZqqXYlNtzE0Wwm
         SaPgTW40CJf9lH5D0+xmyf7uMuWnLTlqHt0mC4Pw9NldSOg8t5VpVrBC2YrGtrwLMV
         AJ3t8KOb6vyuQ==
Date:   Fri, 13 Oct 2023 18:22:28 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Dan Clash <daclash@linux.microsoft.com>,
        linux-kernel@vger.kernel.org, axboe@kernel.dk,
        linux-fsdevel@vger.kernel.org, dan.clash@microsoft.com,
        audit@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH] audit,io_uring: io_uring openat triggers audit reference
 count underflow
Message-ID: <20231013-hakte-sitzt-853957a5d8da@brauner>
References: <20231012215518.GA4048@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20231013-karierte-mehrzahl-6a938035609e@brauner>
 <CAHC9VhTQFyyE59A3WG3Z0xkP6m31h1M0bvS=yihE7ukpUiDMug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHC9VhTQFyyE59A3WG3Z0xkP6m31h1M0bvS=yihE7ukpUiDMug@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Oct 13, 2023 at 11:56:08AM -0400, Paul Moore wrote:
> On Fri, Oct 13, 2023 at 11:44 AM Christian Brauner <brauner@kernel.org> wrote:
> >
> > On Thu, 12 Oct 2023 14:55:18 -0700, Dan Clash wrote:
> > > An io_uring openat operation can update an audit reference count
> > > from multiple threads resulting in the call trace below.
> > >
> > > A call to io_uring_submit() with a single openat op with a flag of
> > > IOSQE_ASYNC results in the following reference count updates.
> > >
> > > These first part of the system call performs two increments that do not race.
> > >
> > > [...]
> >
> > Picking this up as is. Let me know if this needs another tree.
> 
> Whoa.  A couple of things:
> 
> * Please don't merge patches into an upstream tree if all of the
> affected subsystems haven't ACK'd the patch.  I know you've got your
> boilerplate below about ACKs *after* the merge, which is fine, but I
> find it breaks decorum a bit to merge patches without an explicit ACK
> or even just a "looks good to me" from all of the relevant subsystems.

I simply read your mail:

X-Date: Fri, 13 Oct 2023 17:43:54 +0200
X-URI: https://lore.kernel.org/lkml/CAHC9VhQcSY9q=wVT7hOz9y=o3a67BVUnVGNotgAvE6vK7WAkBw@mail.gmail.com

"I'm not too concerned, either approach works for me, the important bit
 is moving to an atomic_t/refcount_t so we can protect ourselves
 against the race.  The patch looks good to me and I'd like to get this
 fix merged."

including that "The patch looks good to me [...]" part before I sent out
the application message:

X-Date: Fri, 13 Oct 2023 17:44:36 +0200
X-URI: https://lore.kernel.org/lkml/20231013-karierte-mehrzahl-6a938035609e@brauner

> Regardless, as I mentioned in my last email (I think our last emails
> raced a bit), I'm okay with this change, please add my ACK.

It's before the weekend and we're about to release -rc6. This thing
needs to be in -next, you said it looks good to you in a prior mail. I'm
not sure why I'm receiving this mail apart from the justified
clarification about -stable although that was made explicit in your
prior mail as well.

> 
> Acked-by: Paul Moore <paul@paul-moore.com>

Thanks for providing an explicit ACK.
