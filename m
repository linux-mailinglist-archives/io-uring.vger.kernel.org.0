Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E60156702A
	for <lists+io-uring@lfdr.de>; Tue,  5 Jul 2022 16:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbiGEOC1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jul 2022 10:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbiGEOB6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jul 2022 10:01:58 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DE42DC0
        for <io-uring@vger.kernel.org>; Tue,  5 Jul 2022 06:47:28 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id ay10so13665747qtb.1
        for <io-uring@vger.kernel.org>; Tue, 05 Jul 2022 06:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aC7tiWGDUmjG4E+Vlf1HDuDZFXAFOR+FnjCqRmORTyc=;
        b=HPc5a7APrqmVXvuv5diow+iSYd8P0GBEUcygVWpOkE9Y4My7LL+qpTLid+Vu13E7kq
         ZMzttA9/ceVExR+3wOxr9nXJMAmqRpxVRSpYfEVN/whAoVKGpdd+2bnjuO0hZ0cKt6HL
         PE8bLwSxxoYkiuJytIdQBdmnQCnoNlzIxkyB6hT8uKG6uENRnBCSh3qQyDDRIdtq2kcf
         m9+dqK82EAbZwoLIeAqHobNHiyQHxfPQ7zF+aST8mPzSQbGYsOJURJqVNtVPmusK+qqN
         +vQQA4O2OJyk6d3OD+pLnWLLy70RYnuD+ox2bgcmMRbq9cPOmSHZmkCam8OCt8A598JW
         ZQxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aC7tiWGDUmjG4E+Vlf1HDuDZFXAFOR+FnjCqRmORTyc=;
        b=oINMy1ZAcxSiyx5hA0a1E9ijQIN8ujdPd2Dd3InD0jH57rKzY5y6z9UXOLolYbwOx8
         bUOEZZWNwmYttK6S3ipOhhk5xHkaczVCW6RTg8HL5UD3ZSf5udkc44wPZSofDP4yzPqI
         3xMptPiQPgigO1rbb/tPjtOZ6f4sDO9f8KothERiVxOjTb3aTvQIwQYoMCJ3fXA9FVm+
         COpY+wyqPBTl8eUeVlu4vUg1sv3WyHePlznsz0r/PwobazsfHpwbSvKQGwf2taQsx25j
         2BUSsxDSQjv0qO44irsP+cT+qLYR6lKW5PC9UeHksdYL4nItUqBgp/YRpFl2vtfSMUYx
         LvBQ==
X-Gm-Message-State: AJIora/eZByEEdA+vRtQlfUjQDToTbd+6NCLM5fmD5e8zNZEvLIbusFQ
        P5YNS2WxwrKeWAdmDeuc6OoAeA==
X-Google-Smtp-Source: AGRyM1vvib7F+uTcsONBGb8V+lPuSuzNrIyahf3+BZ177JeEEhvuW5nixoUCeLrPQ5VLMB5h+kPVNQ==
X-Received: by 2002:a05:6214:5099:b0:473:5d:d29f with SMTP id kk25-20020a056214509900b00473005dd29fmr5025227qvb.55.1657028847407;
        Tue, 05 Jul 2022 06:47:27 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id c4-20020a05620a268400b006aee03a95dfsm26905631qkp.124.2022.07.05.06.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 06:47:26 -0700 (PDT)
Date:   Tue, 5 Jul 2022 09:47:25 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Stefan Roesch <shr@fb.com>,
        io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>, rgoldwyn@suse.com
Subject: Re: [PATCH v7 15/15] xfs: Add async buffered write support
Message-ID: <YsRA7TGWA7ovZjrF@localhost.localdomain>
References: <20220601210141.3773402-1-shr@fb.com>
 <20220601210141.3773402-16-shr@fb.com>
 <Yr56ci/IZmN0S9J6@ZenIV>
 <0a75a0c4-e2e5-b403-27bc-e43872fecdc1@kernel.dk>
 <ef7c1154-b5ba-4017-f9fd-dea936a837fc@kernel.dk>
 <ca60a7dc-b16d-d8ce-f56c-547b449da8c9@kernel.dk>
 <Yr83aD0yuEwvJ7tL@magnolia>
 <47dd9e6a-4e08-e562-12ff-5450fc42da77@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47dd9e6a-4e08-e562-12ff-5450fc42da77@kernel.dk>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 01, 2022 at 12:14:41PM -0600, Jens Axboe wrote:
> On 7/1/22 12:05 PM, Darrick J. Wong wrote:
> > On Fri, Jul 01, 2022 at 08:38:07AM -0600, Jens Axboe wrote:
> >> On 7/1/22 8:30 AM, Jens Axboe wrote:
> >>> On 7/1/22 8:19 AM, Jens Axboe wrote:
> >>>> On 6/30/22 10:39 PM, Al Viro wrote:
> >>>>> On Wed, Jun 01, 2022 at 02:01:41PM -0700, Stefan Roesch wrote:
> >>>>>> This adds the async buffered write support to XFS. For async buffered
> >>>>>> write requests, the request will return -EAGAIN if the ilock cannot be
> >>>>>> obtained immediately.
> >>>>>
> >>>>> breaks generic/471...
> >>>>
> >>>> That test case is odd, because it makes some weird assumptions about
> >>>> what RWF_NOWAIT means. Most notably that it makes it mean if we should
> >>>> instantiate blocks or not. Where did those assumed semantics come from?
> >>>> On the read side, we have clearly documented that it should "not wait
> >>>> for data which is not immediately available".
> >>>>
> >>>> Now it is possible that we're returning a spurious -EAGAIN here when we
> >>>> should not be. And that would be a bug imho. I'll dig in and see what's
> >>>> going on.
> >>>
> >>> This is the timestamp update that needs doing which will now return
> >>> -EAGAIN if IOCB_NOWAIT is set as it may block.
> >>>
> >>> I do wonder if we should just allow inode time updates with IOCB_NOWAIT,
> >>> even on the io_uring side. Either that, or passed in RWF_NOWAIT
> >>> semantics don't map completely to internal IOCB_NOWAIT semantics. At
> >>> least in terms of what generic/471 is doing, but I'm not sure who came
> >>> up with that and if it's established semantics or just some made up ones
> >>> from whomever wrote that test. I don't think they make any sense, to be
> >>> honest.
> >>
> >> Further support that generic/471 is just randomly made up semantics,
> >> it needs to special case btrfs with nocow or you'd get -EAGAIN anyway
> >> for that test.
> >>
> >> And it's relying on some random timing to see if this works. I really
> >> think that test case is just hot garbage, and doesn't test anything
> >> meaningful.
> > 
> > <shrug> I had thought that NOWAIT means "don't wait for *any*thing",
> > which would include timestamp updates... but then I've never been all
> > that clear on what specifically NOWAIT will and won't wait for. :/
> 
> Agree, at least the read semantics (kind of) make sense, but the ones
> seemingly made up by generic/471 don't seem to make any sense at all.
>

Added Goldwyn to the CC list for this.

This appears to be just a confusion about what we think NOWAIT should mean.
Looking at the btrfs code it seems like Goldwyn took it as literally as possible
so we wouldn't do any NOWAIT IO's unless it was into a NOCOW area, meaning we
literally wouldn't do anything other than wrap the bio up and fire it off.

The general consensus seems to be that NOWAIT isn't that strict, and that
BTRFS's definition was too strict.  I wrote initial patches to give to Stefan to
clean up the Btrfs side to allow us to use NOWAIT under a lot more
circumstances.

Goldwyn, this test seems to be a little specific to our case, and can be flakey
if the timing isn't just right.  I think we should just remove it?  Especially
since how we define NOWAIT isn't quite right.  Does that sound reasonable to
you?

I think a decent followup would be to add a NOWAIT specific fio test to fsperf
so we still can catch any NOWAIT related regressions, without trying to test for
specific behavior for something that can fail under a whole lot of conditions
unrelated to our implementation.  Thanks,

Josef 
