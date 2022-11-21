Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 935A9632E6A
	for <lists+io-uring@lfdr.de>; Mon, 21 Nov 2022 22:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbiKUVFv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Nov 2022 16:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbiKUVFu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Nov 2022 16:05:50 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A76DB847
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 13:05:49 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id o5-20020a17090a678500b00218cd5a21c9so65942pjj.4
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 13:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=R045ZF72NR23G1ZVkzr/C9+6Gj8dK4yaud4FFWB06A8=;
        b=6hHoQ5SI00tWEj/5CciSWhgxmyxPJEPavjeSlkZNktCb1TAU2XWeQJnIzx+tcdQCsA
         kGOg/T2nPxDXmEddcqW6PFa5JP7WgOPCkosyW0tk5A6oEC3JJNFomMtL2NE1cRlno/ey
         hm+zAHuz0FpCiPtrCaaej0udDxiQ4yTBVMNOfzXD2MKfUlrJs71P+RITDEzBbYJFNffl
         6AkTkOaFXu0n3W+eBGRik1iUGC+Qhyk1gbeloVpzAcVKalh+7fst4JD0LvNPOgwEPHiW
         y/UZs1/1qoXpeWPcl8b2rxJIkNw/QUSn0v5Ws/VbL0WbguXnJ7U8hCx+7fO2eJyffFRp
         B98g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R045ZF72NR23G1ZVkzr/C9+6Gj8dK4yaud4FFWB06A8=;
        b=NJ5COihp7PMc2eAOy6/aualXYzfGKnlmISNbYSFiJ1tcwczq+WRmUQR1cTaeej88XR
         PRgiNcaKaUd72uPr0HYT12J68AnFsT/WnDSAmtgpVb7Aka/7sBMtw7R3vAwcEQ/Rz1V3
         Een4FJirLfC+aAZD3dr+hUy3Z5Q7AEWNmFe2wQg2COcjhAzIdlWJ86aX0GPI3GJoPqET
         renvOkkyF+w9MJzrQcE3PTRBtCimkuTBCKsAFFxFpA5n1RJGbJ3nbg2uCAnqWfFx8+J6
         ZbxTZThB2a0kgWhzGGfT7iHPGVlibYH/EUQiWBIk1dHRqg3Arcmh/K2E4zaOHFkFuzS8
         T8Ng==
X-Gm-Message-State: ANoB5pl2qs18zL84rD3Vs7dMWzjYiozJ4McoS7YRs2ykGlcPlVC2N3N+
        lj37NbyZrTbpwJynQTS6/3PvPJwAhwNfjAHWOG0cy5c4Nw==
X-Google-Smtp-Source: AA0mqf6Nq00AjeM4Q5AsrjkZOzvkvQDZmdltkcREvU9Z7I0fFwvWETBtmo1aujho8qq2qp7HrObB9C5zedBzI6roC6w=
X-Received: by 2002:a17:902:f7cc:b0:17b:4ace:b67f with SMTP id
 h12-20020a170902f7cc00b0017b4aceb67fmr14179105plw.12.1669064749107; Mon, 21
 Nov 2022 13:05:49 -0800 (PST)
MIME-Version: 1.0
References: <20221116125051.3338926-1-j.granados@samsung.com>
 <CGME20221116125431eucas1p1dfd03b80863fce674a7c662660c94092@eucas1p1.samsung.com>
 <20221116125051.3338926-2-j.granados@samsung.com> <20221116173821.GC5094@test-zns>
 <CAHC9VhSVzujW9LOj5Km80AjU0EfAuukoLrxO6BEfnXeK_s6bAg@mail.gmail.com>
 <20221117094004.b5l64ipicitphkun@localhost> <CAHC9VhSa3Yrjf9z5L0oS8Cx=20gUrgfA8evizoVjBNs4AB_cXg@mail.gmail.com>
 <Y3vXLQz1k8E/qu5A@bombadil.infradead.org>
In-Reply-To: <Y3vXLQz1k8E/qu5A@bombadil.infradead.org>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 21 Nov 2022 16:05:37 -0500
Message-ID: <CAHC9VhR+RFqJ7c6mFhnMFdDXPcCBg-pnAzEuyOc-TX5hmsubwg@mail.gmail.com>
Subject: Re: [RFC 1/1] Use ioctl selinux callback io_uring commands that
 implement the ioctl op convention
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Joel Granados <j.granados@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>, ddiss@suse.de,
        linux-security-module@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Nov 21, 2022 at 2:53 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> On Thu, Nov 17, 2022 at 05:10:07PM -0500, Paul Moore wrote:
> > On Thu, Nov 17, 2022 at 4:40 AM Joel Granados <j.granados@samsung.com> wrote:
> > > On Wed, Nov 16, 2022 at 02:21:14PM -0500, Paul Moore wrote:
> >
> > ...
> >
> > > > * As we discussed previously, the real problem is the fact that we are
> > > > missing the necessary context in the LSM hook to separate the
> > > > different types of command targets.  With traditional ioctls we can
> > > > look at the ioctl number and determine both the type of
> > > > device/subsystem/etc. as well as the operation being requested; there
> > > > is no such information available with the io_uring command
> > > > passthrough.  In this sense, the io_uring command passthrough is
> > > > actually worse than traditional ioctls from an access control
> > > > perspective.  Until we have an easy(ish)[1] way to determine the
> > > > io_uring command target type, changes like the one suggested here are
> > > > going to be doomed as each target type is free to define their own
> > > > io_uring commands.
> > >
> > > The only thing that comes immediately to mind is that we can have
> > > io_uring users define a function that is then passed to the LSM
> > > infrastructure. This function will have all the logic to give relative
> > > context to LSM. It would be general enough to fit all the possible commands
> > > and the logic would be implemented in the "drivers" side so there is no
> > > need for LSM folks to know all io_uring users.
> >
> > Passing a function pointer to the LSM to fetch, what will likely be
> > just a constant value, seems kinda ugly, but I guess we only have ugly
> > options at this point.
>
> I am not sure if this helps yet, but queued on modules-next we now have
> an improvement in speed of about 1500x for kallsyms_lookup_name(), and
> so symbol lookups are now fast. Makes me wonder if a type of special
> export could be drawn up for specific calls which follow a structure
> and so the respective lsm could be inferred by a prefix instead of
> placing the calls in-place. Then it would not mattter where a call is
> used, so long as it would follow a specific pattern / structure with
> all the crap you need on it.

I suspect we may be talking about different things here, I don't think
the issue is which LSM(s) may be enabled, as the call is to
security_uring_cmd() regardless.  I believe the issue is more of how
do the LSMs determine the target of the io_uring command, e.g. nvme or
ublk.

My understanding is that Joel was suggesting a change to the LSM hook
to add a function specific pointer (presumably defined as part of the
file_operations struct) that could be called by the LSM to determine
the target.

Although now that I'm looking again at the file_operations struct, I
wonder if we would be better off having the LSMs inspect the
file_operations::owner field, potentially checking the module::name
field.  It's a little painful in the sense that it is potentially
multiple strcmp() calls for each security_uring_cmd() call, but I'm
not sure the passed function approach would be much better.  Do we
have a consistent per-module scalar value we can use instead of a
character string?

--
paul-moore.com
