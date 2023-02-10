Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911CC692AA3
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 23:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjBJW7h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 17:59:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjBJW7g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 17:59:36 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CB77E3E5
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 14:59:22 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id mg23so309035pjb.0
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 14:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=k8kv/mNjTYPXMVHJK/DKyXGFstxhwmOIHO4oCrQ/tx8=;
        b=GEHNO5sZNKFN553oQmZMRpV8ObKC+ew1Oh6PMcHBGtVmEPrunQOaH2SOXm+WkPrOhu
         ddNNSdNlTYcF0eTwcvt59UKYsr5H9Sr0f6GKz68rIrYWwatvKMR/rfTMkFkq6FI0mtYf
         VMPqmOuwM+B0WMulgGcmS4DsnfbF6bbE5neV0rGuV5x1SpC2s4awFDNrvQvI71f0BpJU
         i7sE6wdWVulGJqEvE1u3qa91bBOmoOKcAZowKcqUaLa66OWaF6mGCJN91AzJZG9JtOkR
         9dGVLGOj/q0RvoyVymMEjgzuJrMH53th4Zo7k8xqISxh2EqB0gt829QpEZnLke7+VG7Z
         Yqwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k8kv/mNjTYPXMVHJK/DKyXGFstxhwmOIHO4oCrQ/tx8=;
        b=H8+0JFfkHoav7U1Hg1REu5rSEqJz7WZIeFXtIcEXYWIdS4xsHtUdsJVHcOBwyjqsjR
         FQADkKFeTZJtNmgBc8FYiuS6UchKkCaBe5lUiELANHsroIjGmFG5/eIqA7Kf1EQ93LVt
         l0+HDvjOwaNI+5d9zAvKaarQkjIe9g1AqxrLgNSnsyU1rr1W3NXg50GRjSnESA+7F9B5
         DsfNfrKJn6TNX6SfrL3j3uTIupyxF43HopXdQw7xvuLD14nbNRjB6/238hENJqZFp47y
         qo0U5xDLdhmv9E9bmn0kUaZ8oMaKTc5TQkBFDkJvHdU3eHQmpqZECTUMZGes66IiPkqI
         Fwow==
X-Gm-Message-State: AO0yUKWmTbjVTqK9aKTq470Mw1Cv70aL5oMqGLDTnz9rFV/Dq/86TvFx
        fNKQsiSTolBprQN3+Hwg4DmZ9B6H1jrHfwS7Lqyl
X-Google-Smtp-Source: AK7set+Mc0q2UHVVlNVCV9n9vNCPsMk1+S+j3kC3bdm5GMoXKS42jBiWiE3EFNPPxmg10pAs3ilKKYyir3CF2JJWRQE=
X-Received: by 2002:a17:90a:4f85:b0:22c:41c7:c7ed with SMTP id
 q5-20020a17090a4f8500b0022c41c7c7edmr3000314pjh.61.1676069962079; Fri, 10 Feb
 2023 14:59:22 -0800 (PST)
MIME-Version: 1.0
References: <b5dfdcd541115c86dbc774aa9dd502c964849c5f.1675282642.git.rgb@redhat.com>
 <Y+VrSLZKZoAGikUS@madcap2.tricolour.ca> <CAHC9VhTNb4gOpk9=49-ABtYs1DFKqqwXPSc-2bhJX7wcZ82o=g@mail.gmail.com>
 <13293926.uLZWGnKmhe@x2> <6939adfb-ce2c-1911-19ee-af32f7d9a5ca@kernel.dk>
 <CAHC9VhTGmGJ81M2CZWsTf1kNf8XNz2WsYFAP=5VAVSUfUiu1yQ@mail.gmail.com>
 <56ef99e4-f9de-0634-ce53-3bc2f1fa6665@kernel.dk> <CAHC9VhSgSREUDzJfDq9H_VAbyCZBYakhE19OiUB19QCeEM3q2A@mail.gmail.com>
 <Y+a+hBtDwAXBgjsg@madcap2.tricolour.ca>
In-Reply-To: <Y+a+hBtDwAXBgjsg@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 10 Feb 2023 17:59:10 -0500
Message-ID: <CAHC9VhTdJvUQNNcNRFdrx7FAvw__r5jZMzpcO4uzRKS1VqBt_g@mail.gmail.com>
Subject: Re: [PATCH v2] io_uring,audit: don't log IORING_OP_MADVISE
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Steve Grubb <sgrubb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Christian Brauner <brauner@kernel.org>,
        Stefan Roesch <shr@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 10, 2023 at 5:00 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2023-02-10 11:52, Paul Moore wrote:
> > On Fri, Feb 10, 2023 at 11:00 AM Jens Axboe <axboe@kernel.dk> wrote:
> > > On 2/10/23 8:39?AM, Paul Moore wrote:
> > > > On Thu, Feb 9, 2023 at 7:15 PM Jens Axboe <axboe@kernel.dk> wrote:
> > > >> On 2/9/23 3:54?PM, Steve Grubb wrote:
> > > >>> On Thursday, February 9, 2023 5:37:22 PM EST Paul Moore wrote:
> > > >>>> On Thu, Feb 9, 2023 at 4:53 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > >>>>> On 2023-02-01 16:18, Paul Moore wrote:
> > > >>>>>> On Wed, Feb 1, 2023 at 3:34 PM Richard Guy Briggs <rgb@redhat.com>
> > > >>> wrote:
> > > >>>>>>> fadvise and madvise both provide hints for caching or access pattern
> > > >>>>>>> for file and memory respectively.  Skip them.
> > > >>>>>>
> > > >>>>>> You forgot to update the first sentence in the commit description :/
> > > >>>>>
> > > >>>>> I didn't forget.  I updated that sentence to reflect the fact that the
> > > >>>>> two should be treated similarly rather than differently.
> > > >>>>
> > > >>>> Ooookay.  Can we at least agree that the commit description should be
> > > >>>> rephrased to make it clear that the patch only adjusts madvise?  Right
> > > >>>> now I read the commit description and it sounds like you are adjusting
> > > >>>> the behavior for both fadvise and madvise in this patch, which is not
> > > >>>> true.
> > > >>>>
> > > >>>>>> I'm still looking for some type of statement that you've done some
> > > >>>>>> homework on the IORING_OP_MADVISE case to ensure that it doesn't end
> > > >>>>>> up calling into the LSM, see my previous emails on this.  I need more
> > > >>>>>> than "Steve told me to do this".
> > > >>>>>>
> > > >>>>>> I basically just want to see that some care and thought has gone into
> > > >>>>>> this patch to verify it is correct and good.
> > > >>>>>
> > > >>>>> Steve suggested I look into a number of iouring ops.  I looked at the
> > > >>>>> description code and agreed that it wasn't necessary to audit madvise.
> > > >>>>> The rationale for fadvise was detemined to have been conflated with
> > > >>>>> fallocate and subsequently dropped.  Steve also suggested a number of
> > > >>>>> others and after investigation I decided that their current state was
> > > >>>>> correct.  *getxattr you've advised against, so it was dropped.  It
> > > >>>>> appears fewer modifications were necessary than originally suspected.
> > > >>>>
> > > >>>> My concern is that three of the four changes you initially proposed
> > > >>>> were rejected, which gives me pause about the fourth.  You mention
> > > >>>> that based on your reading of madvise's description you feel auditing
> > > >>>> isn't necessary - and you may be right - but based on our experience
> > > >>>> so far with this patchset I would like to hear that you have properly
> > > >>>> investigated all of the madvise code paths, and I would like that in
> > > >>>> the commit description.
> > > >>>
> > > >>> I think you're being unnecessarily hard on this. Yes, the commit message
> > > >>> might be touched up. But madvise is advisory in nature. It is not security
> > > >>> relevant. And a grep through the security directory doesn't turn up any
> > > >>> hooks.
> > > >>
> > > >> Agree, it's getting a bit anal... FWIW, patch looks fine to me.
> > > >
> > > > Call it whatever you want, but the details are often important at this
> > > > level of code, and when I see a patch author pushing back on verifying
> > > > that their patch is correct it makes me very skeptical.
> > >
> > > Maybe it isn't intended, but the replies have generally had a pretty
> > > condescending tone to them. That's not the best way to engage folks, and
> > > may very well be why people just kind of give up on it. Nobody likes
> > > debating one-liners forever, particularly not if it isn't inviting.
> >
> > I appreciate that you are coming from a different space, but I stand
> > by my comments.  Of course you are welcome to your own opinion, but I
> > would encourage you to spend some time reading the audit mail archives
> > going back a few years before you make comments like the above ... or
> > not, that's your call; I recognize it is usually easier to criticize.
> >
> > On a quasi related note to the list/archives: unfortunately there was
> > continued resistance to opening up the linux-audit list so I've setup
> > audit@vger for upstream audit kernel work moving forward.  The list
> > address in MAINTAINERS will get updated during the next merge window
> > so hopefully some of the problems you had in the beginning of this
> > discussion will be better in the future.
> >
> > > > I really would have preferred that you held off from merging this
> > > > until this was resolved and ACK'd ... oh well.
> > >
> > > It's still top of tree. If you want to ack it, let me know and I'll add
> > > it. If you want to nak it, give me something concrete to work off of.
> >
> > I can't in good conscience ACK it without some comment from Richard
> > that he has traced the code paths; this shouldn't be surprising at
> > this point.  I'm not going to NACK it or post a revert, I would have
> > done that already if I felt that was appropriate.  Right now this
> > patch is in a gray area for me in that I suspect it is good, but I
> > can't ACK it without some comment that it has been properly
> > researched.
>
> I feel a bit silly replying in this thread.  My dad claims that I need
> to have the last word in any argument, so that way he gets it instead...
>
> I appear to have accidentally omitted the connector word "and" between
> "description" and "code" above, which may have led you to doubt I had
> gone back and re-looked at the code.

Okay, as long as you've done the homework on this I'm good.  If it's
still on the top of Jen's tree, here's my ACK:

Acked-by: Paul Moore <paul@paul-moore.com>

... if it's not on top of the tree, it's not worth popping patches to
add the ACK IMHO.

Feel free to reply to this Richard if you want to have the last word
in this thread, I think I'm done ;)

-- 
paul-moore.com
