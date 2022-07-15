Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6045767C6
	for <lists+io-uring@lfdr.de>; Fri, 15 Jul 2022 21:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbiGOTvK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jul 2022 15:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbiGOTvJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jul 2022 15:51:09 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC9A643CC
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 12:51:05 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id h14-20020a1ccc0e000000b0039eff745c53so3668525wmb.5
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 12:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B3ZiGF2tDesE+mQexAH3kzTRyU5arN1AgSUXC9Mb9ew=;
        b=C5BVrNOtv8yFXOUZEUcznwAm5ACBfjZTrKM1nrHegqukd1Hefyz/I3PKLnAXdbXEoE
         1omsOY2A1h6uFtkMNOPd5VIMCEzPixeQzbWmXfuLw/U0cGxNRVYdieybJHOLmWkNABp7
         ZYt5+A8yXbuOPwvnW9yLTpWHcAzjBoIeZm2/3WBb6Oyyfh+nN9nVotozZk8+9mtsse6Z
         IlR6KcOyCfoeoWHvi6NCyl9HjQrL3NDJZcB1gWLtlEPa6kdO85zxzaqceIqt02hvo6Pe
         prnbeU/odHesphjOtzqT94rWWlIv1xQqKBImdJ0+B+3BECh8YelGM1dR35482bVn1NTo
         ZolA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B3ZiGF2tDesE+mQexAH3kzTRyU5arN1AgSUXC9Mb9ew=;
        b=shc/Ag4UXagSdIRGimS7K2UY8qWQpXjS/ipGv7Zsw5b1/4dBbQ4biUGJMh3vr1betw
         h5uUtPfAW2F136Sj9vXIkIr60fvhtMpGqbqiKC8v49UGh/KTxM2/pSpJGJq+4pTTG3Po
         QHNNHoeD+pmvM7vW0sQ5euwdZQ9gJHe4jV09MoJd5NzvJMRDcMKcgs4cKR+WY1fNv2p2
         u0Get7CKA6BiKHQ8Iz5mKQ5CZgNlSYZU65wbHRinpqcslextBbdqPYWi906OcZwjzb65
         zmiSaOdVYC7q9i0CDvSTonSf1z5g0rll/oHSVqanvh0pf8TxJ5vdRDgIVli8HNWx2RmV
         FnCw==
X-Gm-Message-State: AJIora8rVh+/hDrct+xtclmua/25RPzWO2WciSxHMe7jE/L2RVxRQfmd
        7AfvVt8sLN12X/5LX0VaBYc0SbihmSPK1h8vFpZw
X-Google-Smtp-Source: AGRyM1v9Y59NpuNV8HmLV11n89oSkcfJUYTmai6o9MEZYymhprlb09bXYf1KArAe8J77kBFj3VQqmYg4BbMmRnRxhY8=
X-Received: by 2002:a7b:c381:0:b0:3a2:fe96:2ce4 with SMTP id
 s1-20020a7bc381000000b003a2fe962ce4mr13050035wmj.70.1657914664182; Fri, 15
 Jul 2022 12:51:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220714000536.2250531-1-mcgrof@kernel.org> <CAHC9VhSjfrMtqy_6+=_=VaCsJKbKU1oj6TKghkue9LrLzO_++w@mail.gmail.com>
 <YtC8Hg1mjL+0mjfl@bombadil.infradead.org> <CAHC9VhQMABYKRqZmJQtXai0gtiueU42ENvSUH929=pF6tP9xOg@mail.gmail.com>
 <a91fdbe3-fe01-c534-29ee-f05056ffd74f@kernel.dk>
In-Reply-To: <a91fdbe3-fe01-c534-29ee-f05056ffd74f@kernel.dk>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 15 Jul 2022 15:50:53 -0400
Message-ID: <CAHC9VhRCW4PFwmwyAYxYmLUDuY-agHm1CejBZJUpHTVbZE8L1Q@mail.gmail.com>
Subject: Re: [PATCH] lsm,io_uring: add LSM hooks to for the new uring_cmd file op
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Luis Chamberlain <mcgrof@kernel.org>, casey@schaufler-ca.com,
        joshi.k@samsung.com, linux-security-module@vger.kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, a.manzanares@samsung.com,
        javier@javigon.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 15, 2022 at 3:07 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 7/15/22 12:46 PM, Paul Moore wrote:
> > On Thu, Jul 14, 2022 at 9:00 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >> On Wed, Jul 13, 2022 at 11:00:42PM -0400, Paul Moore wrote:
> >>> On Wed, Jul 13, 2022 at 8:05 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >>>>
> >>>> io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
> >>>> add infrastructure for uring-cmd"), this extended the struct
> >>>> file_operations to allow a new command which each subsystem can use
> >>>> to enable command passthrough. Add an LSM specific for the command
> >>>> passthrough which enables LSMs to inspect the command details.
> >>>>
> >>>> This was discussed long ago without no clear pointer for something
> >>>> conclusive, so this enables LSMs to at least reject this new file
> >>>> operation.
> >>>>
> >>>> [0] https://lkml.kernel.org/r/8adf55db-7bab-f59d-d612-ed906b948d19@schaufler-ca.com
> >>>
> >>> [NOTE: I now see that the IORING_OP_URING_CMD has made it into the
> >>> v5.19-rcX releases, I'm going to be honest and say that I'm
> >>> disappointed you didn't post the related LSM additions
> >>
> >> It does not mean I didn't ask for them too.
> >>
> >>> until
> >>> v5.19-rc6, especially given our earlier discussions.]
> >>
> >> And hence since I don't see it either, it's on us now.
> >
> > It looks like I owe you an apology, Luis.  While my frustration over
> > io_uring remains, along with my disappointment that the io_uring
> > developers continue to avoid discussing access controls with the LSM
> > community, you are not the author of the IORING_OP_URING_CMD.   You
> > are simply trying to do the right thing by adding the necessary LSM
> > controls and in my confusion I likely caused you a bit of frustration;
> > I'm sorry for that.
>
> Maybe, just maybe, outbursts like this are why there's not a lot of
> incentive to collaborate on this? I get why it can seem frustrating and
> that you are being ignored, but I think it's more likely that people
> just don't think of adding these hooks. I don't use any of the access
> controls, nor do I really have a good idea which one exists and what
> they do. None of the external developers or internal use cases we have
> use any of this, and nobody outside of the developers of these kernel
> features have ever brought it up...

While my response may have been misdirected (once again, sorry Luis),
I feel that expressing frustration about the LSMs being routinely left
out of the discussion when new functionality is added to the kernel is
a reasonable response; especially when one considers the history of
this particular situation.  I was willing to attribute the initial
LSM/audit omission in io_uring to an honest oversight, and the fact
that we were able to work together to get something in place was a
good thing which gave me some hope.  However, the issue around
IORING_OP_URING_CMD was brought up earlier this year and many of us on
the LSM side expressed concern, only to see the code present in
v5.19-rcX with little heads-up given outside of Luis' patch a few days
ago.  You can call my comments an outburst if you like, but it seems
like an appropriate reaction in this case.

> I don't mind getting these added, but since I wasn't really part of
> driving this particular feature, it wasn't on my radar.

I generally don't care who authors a commit, it's that code itself
that matters, not who wrote it.  However, since you mentioned it I
went back to check, and it looks like you authored the basic
IORING_OP_URING_CMD infrastructure according to ee692a21e9bf
("fs,io_uring: add infrastructure for uring-cmd"); that seems like a
decent level of awareness to me.

> >> Given a clear solution is not easily tangible at this point
> >> I was hoping perhaps at least the abilility to enable LSMs to
> >> reject uring-cmd would be better than nothing at this point.
> >
> > Without any cooperation from the io_uring developers, that is likely
> > what we will have to do.  I know there was a lot of talk about this
> > functionality not being like another ioctl(), but from a LSM
> > perspective I think that is how we will need to treat it.
>
> Again this perceived ill intent. What are you looking for here?

We expressed concern earlier this year and were largely ignored, and
when the functionality was merged into mainline the LSM community was
not notified despite our previous comments.  Perhaps there is no ill
intent on the side of io_uring, but from my perspective it sure seems
like there was an effort to avoid the LSM community.

As far as what I'm looking for, I think basic consideration for
comments coming from the LSM community would be a good start.  We
obviously have had some success in the past with this, which is why
I'm a bit shocked that our IORING_OP_URING_CMD comments from earlier
this year appeared to fall on deaf ears.

> >>>> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
>
> > Well, we're at -rc6 right now which means IORING_OP_URING_CMD is
> > happening and it's unlikely the LSM folks are going to be able to
> > influence the design/implementation much at this point so we have to
> > do the best we can.  Given the existing constraints, I think your
> > patch is reasonable (although please do shift the hook call site down
> > a bit as discussed above), we just need to develop the LSM
> > implementations to go along with it.
> >
> > Luis, can you respin and resend the patch with the requested changes?
> >
> > Casey, it looks like Smack and SELinux are the only LSMs to implement
> > io_uring access controls.  Given the hook that Luis developed in this
> > patch, could you draft a patch for Smack to add the necessary checks?
> > I'll do the same for SELinux.  My initial thinking is that all we can
> > really do is check the access between the creds on the current task
> > (any overrides will have already taken place by the time the LSM hook
> > is called) with the io_uring_cmd:file label/creds; we won't be able to
> > provide much permission granularity for all the reasons previously
> > discussed, but I suspect that will be more of a SELinux problem than a
> > Smack problem (although I suspect Smack will need to treat this as
> > both a read and a write, which is likely less than ideal).
> >
> > I think it's doubtful we will have all of this ready and tested in
> > time for v5.19, but I think we can have it ready shortly after that
> > and I'll mark all of the patches for -stable when I send them to
> > Linus.
> >
> > I also think we should mark the patches with a 'Fixes:' line that
> > points at the IORING_OP_URING_CMD commit, ee692a21e9bf ("fs,io_uring:
> > add infrastructure for uring-cmd").
> >
> > How does that sound to everyone?
>
> Let's do it the right way for 5.20, and then get it marked for a
> backport. That will be trivial enough and will hit 5.19-stable shortly
> as well. Rushing it now with 1 week before release will most likely
> yield a worse long term result.

That is what I suggested above; it looks like we are on the same page
at least with the resolution.  I'll plan on bundling Luis' hook patch,
Casey's Smack patch, the SELinux patch and send them up to Linus once
they are ready.  If you, and/or other io_uring developers, could
review Luis' LSM hook patch from an io_uring perspective and add your
Ack/Review-by tag I would appreciate it.

-- 
paul-moore.com
