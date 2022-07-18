Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4245785E6
	for <lists+io-uring@lfdr.de>; Mon, 18 Jul 2022 16:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiGROzj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Jul 2022 10:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234600AbiGROzj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Jul 2022 10:55:39 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6732114092
        for <io-uring@vger.kernel.org>; Mon, 18 Jul 2022 07:55:37 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id az2-20020a05600c600200b003a301c985fcso7252541wmb.4
        for <io-uring@vger.kernel.org>; Mon, 18 Jul 2022 07:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=awB3IScCM82ThTtG2SFehRsEwEakyzEv6teXUnsFMUA=;
        b=xpExZ3kZCdk2WKHRKvNTZvS7M91X0EEJtGhiw331LmrtUZOYjX68OUTX0PXvRoq9Mg
         rqRaN2pueOU9+e0THRE0dnpvpdRcP3K01m4gEUfL1uPoqfF0O0ihsPtN58yxHoc7voDY
         1cQFrVWgDcoMgZ2WmrmEL8uzt0DB4SWAnFV2j4Taehtrz8/xQLX0L0ptEmEwFjp60GVk
         0S5wr44rR8pwrLJpegsNUKKkLGK+MuKZxkjnEkCS7p+fYa7uxUteoCgcGecUQA0ED3RN
         YE1oRr4rJnXM+3ZYpfeYSI/rtdPEpucaIulaDfXRio1x4Wkz9vHEqUBu5M1jnvusK3wR
         CITA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=awB3IScCM82ThTtG2SFehRsEwEakyzEv6teXUnsFMUA=;
        b=cWLisP5iZkSd6MzlMwcLpHMfQAhprGe9EwUVqYbO99oTwdT5uD4Cu54eSqVtzjkPrJ
         Ww+F5GopQoJymd7RMeMv0UuuEZ0eUuExQT6dxUX3rbn7e4aFuxBOhMmA0IB/ynl+k7BA
         ISIr22j6/FZM0y5Bv6NmXXaYRpHdzCw89WG9zId4pRzz6yuuOP3D9ITrmT2SW3/14fQi
         EzBtar6zD+ioUlJVKf19WrFOpj+7nhiRph06yekZG5GITfv0FisBX9nyklXzFkviHFGy
         C59yrXlGioDuyT1xNAvbW0+wI/P41SO6w1IIC9e3YmW64rXa5CYjUqxFOnu9rSawk7Sz
         C9rA==
X-Gm-Message-State: AJIora8hz+Jf4LgUa1JdEwH96PHavapH6yf/IuJLpAzZDfDyxeVuyCsj
        jjwPIBlb0FDIQtUmjnZTGQl191WKabkHpxF/meBN
X-Google-Smtp-Source: AGRyM1tH7+KDgIRxNaY2LGntFQMixVhfjpDqcUF6WGCiIIg9/YcIi0aQwTC6+2UR286rXvWRV6cy1fT2sqKQ7U2WyyY=
X-Received: by 2002:a7b:c3cc:0:b0:3a3:8ec:d69 with SMTP id t12-20020a7bc3cc000000b003a308ec0d69mr17787022wmj.78.1658156135929;
 Mon, 18 Jul 2022 07:55:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220714000536.2250531-1-mcgrof@kernel.org> <CAHC9VhSjfrMtqy_6+=_=VaCsJKbKU1oj6TKghkue9LrLzO_++w@mail.gmail.com>
 <YtC8Hg1mjL+0mjfl@bombadil.infradead.org> <CGME20220715184632epcas5p36bd157d36a2aed044de40264911bec05@epcas5p3.samsung.com>
 <CAHC9VhQMABYKRqZmJQtXai0gtiueU42ENvSUH929=pF6tP9xOg@mail.gmail.com> <20220716032041.GB25618@test-zns>
In-Reply-To: <20220716032041.GB25618@test-zns>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 18 Jul 2022 10:55:24 -0400
Message-ID: <CAHC9VhQKeufrqN=dVZ74wEFgd3K=KY-aEZafYembT738juzWUw@mail.gmail.com>
Subject: Re: [PATCH] lsm,io_uring: add LSM hooks to for the new uring_cmd file op
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>, casey@schaufler-ca.com,
        axboe@kernel.dk, linux-security-module@vger.kernel.org,
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

On Fri, Jul 15, 2022 at 11:26 PM Kanchan Joshi <joshi.k@samsung.com> wrote:
> On Fri, Jul 15, 2022 at 02:46:16PM -0400, Paul Moore wrote:
> >On Thu, Jul 14, 2022 at 9:00 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >> On Wed, Jul 13, 2022 at 11:00:42PM -0400, Paul Moore wrote:
> >> > On Wed, Jul 13, 2022 at 8:05 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >> > >
> >> > > io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
> >> > > add infrastructure for uring-cmd"), this extended the struct
> >> > > file_operations to allow a new command which each subsystem can use
> >> > > to enable command passthrough. Add an LSM specific for the command
> >> > > passthrough which enables LSMs to inspect the command details.
> >> > >
> >> > > This was discussed long ago without no clear pointer for something
> >> > > conclusive, so this enables LSMs to at least reject this new file
> >> > > operation.
> >> > >
> >> > > [0] https://lkml.kernel.org/r/8adf55db-7bab-f59d-d612-ed906b948d19@schaufler-ca.com
> >> >
> >> > [NOTE: I now see that the IORING_OP_URING_CMD has made it into the
> >> > v5.19-rcX releases, I'm going to be honest and say that I'm
> >> > disappointed you didn't post the related LSM additions
> >>
> >> It does not mean I didn't ask for them too.
> >>
> >> > until
> >> > v5.19-rc6, especially given our earlier discussions.]
> >>
> >> And hence since I don't see it either, it's on us now.
> >
> >It looks like I owe you an apology, Luis.  While my frustration over
> >io_uring remains, along with my disappointment that the io_uring
> >developers continue to avoid discussing access controls with the LSM
> >community, you are not the author of the IORING_OP_URING_CMD.   You
>
> I am to be shot down here. Solely.
> My LSM understanding has been awful. At a level that I am not clear
> how to fix if someone says - your code lacks LSM consideration.
> But nothing to justify, I fully understand this is not someone else's
> problem but mine. I intend to get better at it.
> And I owe apology (to you/LSM-folks, Luis, Jens) for the mess.

Thanks for your honesty.  If it is any consolation, my understanding
of io_uring remains superficial at best, and it's one of the reasons
I've asked the io_uring devs to ack/review the LSM io_uring hooks and
their placement in the io_uring code.  Developing a deep understanding
of one kernel subsystem is often very difficult, doing the same across
multiple subsystems requires a *lot* of time and effort.  We have to
rely on our combined expertise to help each other fill in the gaps :)

If you are ever unsure about something in the LSM layer, or how a
change to io_uring (or any other subsystem) might impact the LSMs,
please don't hesitate to ask us.  It might take all of us a little
while to sort it out, but we can usually get it working in the end.

There shouldn't be harm in asking for help/clarification, the harm
usually comes when assumptions are made.

-- 
paul-moore.com
