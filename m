Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E676929C2
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 23:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbjBJWBb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 17:01:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233583AbjBJWBa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 17:01:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B10A7DD1F
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 14:00:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676066446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rBpoNySOkk1lR2L1L/2BfSmbClWUNRdaNhEq2RRlE1I=;
        b=gl7yn4Q+mGKu+mRZJVexkgPhlOXTpE+jquQYKyPFO/u0jK37VWrzn4BhF+lSE4EVVEO4Y2
        QyTTsxaepbhvYJeUfXHwfm4Q/OGzBJ0UCg4qKOAyjbgG2L3hxrgE2p4A/zBRTGwwAwW5Aw
        qK15JtFWbQTLMxFH6WdOZ7rFezhodAs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-495-UBb32r4sMrS2mG1TczmGoA-1; Fri, 10 Feb 2023 17:00:45 -0500
X-MC-Unique: UBb32r4sMrS2mG1TczmGoA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10D3A29AB410;
        Fri, 10 Feb 2023 22:00:40 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.22.50.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 49BC21121315;
        Fri, 10 Feb 2023 22:00:38 +0000 (UTC)
Date:   Fri, 10 Feb 2023 17:00:36 -0500
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Steve Grubb <sgrubb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Christian Brauner <brauner@kernel.org>,
        Stefan Roesch <shr@fb.com>
Subject: Re: [PATCH v2] io_uring,audit: don't log IORING_OP_MADVISE
Message-ID: <Y+a+hBtDwAXBgjsg@madcap2.tricolour.ca>
References: <b5dfdcd541115c86dbc774aa9dd502c964849c5f.1675282642.git.rgb@redhat.com>
 <Y+VrSLZKZoAGikUS@madcap2.tricolour.ca>
 <CAHC9VhTNb4gOpk9=49-ABtYs1DFKqqwXPSc-2bhJX7wcZ82o=g@mail.gmail.com>
 <13293926.uLZWGnKmhe@x2>
 <6939adfb-ce2c-1911-19ee-af32f7d9a5ca@kernel.dk>
 <CAHC9VhTGmGJ81M2CZWsTf1kNf8XNz2WsYFAP=5VAVSUfUiu1yQ@mail.gmail.com>
 <56ef99e4-f9de-0634-ce53-3bc2f1fa6665@kernel.dk>
 <CAHC9VhSgSREUDzJfDq9H_VAbyCZBYakhE19OiUB19QCeEM3q2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhSgSREUDzJfDq9H_VAbyCZBYakhE19OiUB19QCeEM3q2A@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023-02-10 11:52, Paul Moore wrote:
> On Fri, Feb 10, 2023 at 11:00 AM Jens Axboe <axboe@kernel.dk> wrote:
> > On 2/10/23 8:39?AM, Paul Moore wrote:
> > > On Thu, Feb 9, 2023 at 7:15 PM Jens Axboe <axboe@kernel.dk> wrote:
> > >> On 2/9/23 3:54?PM, Steve Grubb wrote:
> > >>> On Thursday, February 9, 2023 5:37:22 PM EST Paul Moore wrote:
> > >>>> On Thu, Feb 9, 2023 at 4:53 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > >>>>> On 2023-02-01 16:18, Paul Moore wrote:
> > >>>>>> On Wed, Feb 1, 2023 at 3:34 PM Richard Guy Briggs <rgb@redhat.com>
> > >>> wrote:
> > >>>>>>> fadvise and madvise both provide hints for caching or access pattern
> > >>>>>>> for file and memory respectively.  Skip them.
> > >>>>>>
> > >>>>>> You forgot to update the first sentence in the commit description :/
> > >>>>>
> > >>>>> I didn't forget.  I updated that sentence to reflect the fact that the
> > >>>>> two should be treated similarly rather than differently.
> > >>>>
> > >>>> Ooookay.  Can we at least agree that the commit description should be
> > >>>> rephrased to make it clear that the patch only adjusts madvise?  Right
> > >>>> now I read the commit description and it sounds like you are adjusting
> > >>>> the behavior for both fadvise and madvise in this patch, which is not
> > >>>> true.
> > >>>>
> > >>>>>> I'm still looking for some type of statement that you've done some
> > >>>>>> homework on the IORING_OP_MADVISE case to ensure that it doesn't end
> > >>>>>> up calling into the LSM, see my previous emails on this.  I need more
> > >>>>>> than "Steve told me to do this".
> > >>>>>>
> > >>>>>> I basically just want to see that some care and thought has gone into
> > >>>>>> this patch to verify it is correct and good.
> > >>>>>
> > >>>>> Steve suggested I look into a number of iouring ops.  I looked at the
> > >>>>> description code and agreed that it wasn't necessary to audit madvise.
> > >>>>> The rationale for fadvise was detemined to have been conflated with
> > >>>>> fallocate and subsequently dropped.  Steve also suggested a number of
> > >>>>> others and after investigation I decided that their current state was
> > >>>>> correct.  *getxattr you've advised against, so it was dropped.  It
> > >>>>> appears fewer modifications were necessary than originally suspected.
> > >>>>
> > >>>> My concern is that three of the four changes you initially proposed
> > >>>> were rejected, which gives me pause about the fourth.  You mention
> > >>>> that based on your reading of madvise's description you feel auditing
> > >>>> isn't necessary - and you may be right - but based on our experience
> > >>>> so far with this patchset I would like to hear that you have properly
> > >>>> investigated all of the madvise code paths, and I would like that in
> > >>>> the commit description.
> > >>>
> > >>> I think you're being unnecessarily hard on this. Yes, the commit message
> > >>> might be touched up. But madvise is advisory in nature. It is not security
> > >>> relevant. And a grep through the security directory doesn't turn up any
> > >>> hooks.
> > >>
> > >> Agree, it's getting a bit anal... FWIW, patch looks fine to me.
> > >
> > > Call it whatever you want, but the details are often important at this
> > > level of code, and when I see a patch author pushing back on verifying
> > > that their patch is correct it makes me very skeptical.
> >
> > Maybe it isn't intended, but the replies have generally had a pretty
> > condescending tone to them. That's not the best way to engage folks, and
> > may very well be why people just kind of give up on it. Nobody likes
> > debating one-liners forever, particularly not if it isn't inviting.
> 
> I appreciate that you are coming from a different space, but I stand
> by my comments.  Of course you are welcome to your own opinion, but I
> would encourage you to spend some time reading the audit mail archives
> going back a few years before you make comments like the above ... or
> not, that's your call; I recognize it is usually easier to criticize.
> 
> On a quasi related note to the list/archives: unfortunately there was
> continued resistance to opening up the linux-audit list so I've setup
> audit@vger for upstream audit kernel work moving forward.  The list
> address in MAINTAINERS will get updated during the next merge window
> so hopefully some of the problems you had in the beginning of this
> discussion will be better in the future.
> 
> > > I really would have preferred that you held off from merging this
> > > until this was resolved and ACK'd ... oh well.
> >
> > It's still top of tree. If you want to ack it, let me know and I'll add
> > it. If you want to nak it, give me something concrete to work off of.
> 
> I can't in good conscience ACK it without some comment from Richard
> that he has traced the code paths; this shouldn't be surprising at
> this point.  I'm not going to NACK it or post a revert, I would have
> done that already if I felt that was appropriate.  Right now this
> patch is in a gray area for me in that I suspect it is good, but I
> can't ACK it without some comment that it has been properly
> researched.

I feel a bit silly replying in this thread.  My dad claims that I need
to have the last word in any argument, so that way he gets it instead...

I appear to have accidentally omitted the connector word "and" between
"description" and "code" above, which may have led you to doubt I had
gone back and re-looked at the code.

> paul-moore.com

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

