Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCEC692243
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 16:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbjBJPdm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 10:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232739AbjBJPdl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 10:33:41 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD9675F50
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 07:33:38 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id q9so3949151pgq.5
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 07:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1676043218;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6VZ+XOrSTIecQMUD2x7ocznlsT2yTW/MOJ04EsNi4t4=;
        b=RAFkY7tjZ7gpsX+JzniHJwHyRn2OOAVHicdiWNikW4iaDl7HUQvIkb1Qo1QW4hYqO2
         U1kK3kQBj5mSw5lWE03AvmS38fo/LV24SskyrmRGrvPX/Unof2CNPodLiSF+/zh9Z8nb
         gts1Ez5CCa44eehhqIa64A6Uui/JO9AhREkxm8FN/gFeTKcNZvdPU0DD27ZQH0s1Txcm
         bY8FFj88qmY9D9iL539gZ3CsLdzN3fA3/HTmnY0wTPCzv/0QK9f5i6sPr6KgBcprpVSJ
         TMlYoosY8azDBgKgrxOSTG0C0e+e1OVwDIz5TdVN2fe/NekR4VPrmMPX6DTE2hkpBRqF
         YyOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676043218;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6VZ+XOrSTIecQMUD2x7ocznlsT2yTW/MOJ04EsNi4t4=;
        b=HGUQes9jiY5VKWuKQc/hEKhqGtvpWh9Q7DJY26gqgUUwUdY1Hhxg4eiy/gr42bkDHT
         9dEqGwN9bsZihVGqEzlOTDR2cj3lmytat3Y+82oMe134jXuHgQyfWbVcSig5FtleQ4iU
         cNBSz6JjBiAQjji6DX3AyMR5t2HDnHrEA/D9Uw8qFRK4pvYmlzKX2hzJIJMJG0cj2lcW
         iOKaSmXok2rcrFPrD2WzbX0iCKVk2oDOPFnt44LrgENlj6FiEBMhV1CS5dmY0SYroYfA
         j6b3fUikkYBGb43M9xIxEwubi0ln02tqnp+DT8gjIXFzc8aANUm55Yr7ymsXylpaYcfM
         vXqQ==
X-Gm-Message-State: AO0yUKVJnUGunwRYxVc3KnICcRspSThQ5tExXGR5hFsRI1pkAy2m85xd
        OjBndyuJfzipUXBIhhS2rE5KWaOzZPQD8buEjyyv
X-Google-Smtp-Source: AK7set8WDQ84iFNVjAJNUq6rkApsHXnccnK2E4kViJ2s5HDDWlO2HW8HTcnS2RZWy1SWIRCd7hKhkSxCJMC5kRGL8xg=
X-Received: by 2002:a62:5f02:0:b0:5a8:5247:2589 with SMTP id
 t2-20020a625f02000000b005a852472589mr1395187pfb.7.1676043217708; Fri, 10 Feb
 2023 07:33:37 -0800 (PST)
MIME-Version: 1.0
References: <b5dfdcd541115c86dbc774aa9dd502c964849c5f.1675282642.git.rgb@redhat.com>
 <Y+VrSLZKZoAGikUS@madcap2.tricolour.ca> <CAHC9VhTNb4gOpk9=49-ABtYs1DFKqqwXPSc-2bhJX7wcZ82o=g@mail.gmail.com>
 <13293926.uLZWGnKmhe@x2>
In-Reply-To: <13293926.uLZWGnKmhe@x2>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 10 Feb 2023 10:33:26 -0500
Message-ID: <CAHC9VhTrzsc5bTz6uKumog0iO4LPNn1LJN5XeiHhYXhTAYVDkg@mail.gmail.com>
Subject: Re: [PATCH v2] io_uring,audit: don't log IORING_OP_MADVISE
To:     Steve Grubb <sgrubb@redhat.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
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

On Thu, Feb 9, 2023 at 5:54 PM Steve Grubb <sgrubb@redhat.com> wrote:
> On Thursday, February 9, 2023 5:37:22 PM EST Paul Moore wrote:
> > On Thu, Feb 9, 2023 at 4:53 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > On 2023-02-01 16:18, Paul Moore wrote:
> > > > On Wed, Feb 1, 2023 at 3:34 PM Richard Guy Briggs <rgb@redhat.com>
> wrote:
> > > > > fadvise and madvise both provide hints for caching or access pattern
> > > > > for file and memory respectively.  Skip them.
> > > >
> > > > You forgot to update the first sentence in the commit description :/
> > >
> > > I didn't forget.  I updated that sentence to reflect the fact that the
> > > two should be treated similarly rather than differently.
> >
> > Ooookay.  Can we at least agree that the commit description should be
> > rephrased to make it clear that the patch only adjusts madvise?  Right
> > now I read the commit description and it sounds like you are adjusting
> > the behavior for both fadvise and madvise in this patch, which is not
> > true.
> >
> > > > I'm still looking for some type of statement that you've done some
> > > > homework on the IORING_OP_MADVISE case to ensure that it doesn't end
> > > > up calling into the LSM, see my previous emails on this.  I need more
> > > > than "Steve told me to do this".
> > > >
> > > > I basically just want to see that some care and thought has gone into
> > > > this patch to verify it is correct and good.
> > >
> > > Steve suggested I look into a number of iouring ops.  I looked at the
> > > description code and agreed that it wasn't necessary to audit madvise.
> > > The rationale for fadvise was detemined to have been conflated with
> > > fallocate and subsequently dropped.  Steve also suggested a number of
> > > others and after investigation I decided that their current state was
> > > correct.  *getxattr you've advised against, so it was dropped.  It
> > > appears fewer modifications were necessary than originally suspected.
> >
> > My concern is that three of the four changes you initially proposed
> > were rejected, which gives me pause about the fourth.  You mention
> > that based on your reading of madvise's description you feel auditing
> > isn't necessary - and you may be right - but based on our experience
> > so far with this patchset I would like to hear that you have properly
> > investigated all of the madvise code paths, and I would like that in
> > the commit description.
>
> I think you're being unnecessarily hard on this.

Asking that a patch author does the proper level of due diligence to
ensure that the patch they are submitting is correct isn't being
"unnecessarily hard", it's part of being a good code reviewer and
maintainer.  I'm a bit amazed that you and Richard would rather spend
your time arguing about this rather than spending the hour (?) it
would take to verify the change and make a proper statement about the
correctness of the patch.

> Yes, the commit message
> might be touched up. But madvise is advisory in nature. It is not security
> relevant. And a grep through the security directory doesn't turn up any
> hooks.

You can't rely on grep, you need to chase the code paths to see what
code might be exercised.  For example, look at the truncate syscalls
(truncate, truncate64, ftruncate64, etc.), if you grep through the
SELinux hook code looking for some form of "truncate" you will not
find anything relevant; SELinux doesn't provide implementations for
either the security_file_truncate() or security_path_truncate() hooks.
However, if you follow the syscall code paths you will see that the
truncate syscalls end up calling security_inode_permission() which
*is* implemented in SELinux.

You need to do your homework; relying only on a gut feeling, a few
lines from a manpage, or a code comment is a good way to introduce
bugs.

-- 
paul-moore.com
