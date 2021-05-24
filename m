Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE0B38F3F6
	for <lists+io-uring@lfdr.de>; Mon, 24 May 2021 21:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbhEXUA4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 May 2021 16:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233073AbhEXUAv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 May 2021 16:00:51 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A347C06138C
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 12:59:23 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id lg14so43593317ejb.9
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 12:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=09wkFCImo62hLXHkPnzCDHAYLxWzFwtrCMOPgJlSi80=;
        b=YPDA+Xc5XRpHuRWNw83rgJb7PAeoUrr32wd0YoytgmXhNe7upISv9x7+VbYgvBRRRZ
         b1/35UAnT2GeCOcUlkm8zabNyAF+k8Cn+e5O0hJ1x2gxBn3cdJTTvuVHYhCehubyE1rf
         7LkrfO5dlawwPih4pzrlgP54+8tXpJIwTAqYJ9AYeKWy9J78rgvQjAbFvg0SbnFTQyGO
         UfL80Or+LC+uiw/fI8E7yVHljeCMy/Ee9NriTZfdTBWr3mnMMB96bBZxa1ESHq439TEO
         lI31NQJyIX76xNxgH/iQJLXmJEUWuRh5GidWMSCPd8K2FtLgR6A19p/trTaYQBXDfyvd
         XKGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=09wkFCImo62hLXHkPnzCDHAYLxWzFwtrCMOPgJlSi80=;
        b=pdpCMEo5Uq4Qs2nyQmcXbDrpOau9VlA6mANNybT2a7DyH+NMFi6zEFiJMMB6oGgVJY
         zidbuEgoPTOHuw7Zn7tor3iaT31A3ljAEy7zg/FFzZxcE3xqcdKlQWURJxed6hAeHR83
         olXgb6A3f+bSTffKtC18TrFcObfsZH1y99DZ+XtLZZW5KCAQXpjaGV4gPi/Mvxnmv11K
         L6fI4V7a8oDDrbRQRAuBNbt/kbAh6hH7UTdU9/RkCi7Cf+IRs1LoLNHp6VDWf0Lx/Feb
         MpObojYx+gVMnPvUaf/dDnzi04C/6ED1sNPk24EslWGl4RHKL1j2hPMKJL7fT4sdS94C
         9TPw==
X-Gm-Message-State: AOAM532bHyqEWU2AmbjgGR8fEL5I7529GYmGfOfyR5IJENYHFhbb5WZw
        w5PouKLO0y9WgaMa20r5yaudZXMlHqo/+Nv+pKwUwZZean3p
X-Google-Smtp-Source: ABdhPJyJnn8cTuWE0D6WCTdnxc3zkrXdZltcoobyaH7I8DthDbUf1aZItUpXKY/gO3bnHsam4ng+oV2h/jNU1sQt9pA=
X-Received: by 2002:a17:907:10d8:: with SMTP id rv24mr24731654ejb.542.1621886361736;
 Mon, 24 May 2021 12:59:21 -0700 (PDT)
MIME-Version: 1.0
References: <162163367115.8379.8459012634106035341.stgit@sifl>
 <162163379461.8379.9691291608621179559.stgit@sifl> <f07bd213-6656-7516-9099-c6ecf4174519@gmail.com>
 <CAHC9VhRjzWxweB8d8fypUx11CX6tRBnxSWbXH+5qM1virE509A@mail.gmail.com> <162219f9-7844-0c78-388f-9b5c06557d06@gmail.com>
In-Reply-To: <162219f9-7844-0c78-388f-9b5c06557d06@gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 24 May 2021 15:59:10 -0400
Message-ID: <CAHC9VhSJuddB+6GPS1+mgcuKahrR3UZA=1iO8obFzfRE7_E0gA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/9] audit,io_uring,io-wq: add some basic audit
 support to io_uring
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, May 23, 2021 at 4:26 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> On 5/22/21 3:36 AM, Paul Moore wrote:
> > On Fri, May 21, 2021 at 8:22 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >> On 5/21/21 10:49 PM, Paul Moore wrote:
> [...]
> >>>
> >>> +     if (req->opcode < IORING_OP_LAST)
> >>
> >> always true at this point
> >
> > I placed the opcode check before the audit call because the switch
> > statement below which handles the operation dispatching has a 'ret =
> > -EINVAL' for the default case, implying that there are some paths
> > where an invalid opcode could be passed into the function.  Obviously
> > if that is not the case and you can guarantee that req->opcode will
> > always be valid we can easily drop the check prior to the audit call.
>
> It is always true at this point, would be completely broken
> otherwise

Understood, I was just pointing out an oddity in the code.  I just
dropped the checks from my local tree, you'll see it in the next draft
of the patchset.

> >> So, it adds two if's with memory loads (i.e. current->audit_context)
> >> per request in one of the hottest functions here... No way, nack
> >>
> >> Maybe, if it's dynamically compiled into like kprobes if it's
> >> _really_ used.
> >
> > I'm open to suggestions on how to tweak the io_uring/audit
> > integration, if you don't like what I've proposed in this patchset,
> > lets try to come up with a solution that is more palatable.  If you
> > were going to add audit support for these io_uring operations, how
> > would you propose we do it?  Not being able to properly audit io_uring
> > operations is going to be a significant issue for a chunk of users, if
> > it isn't already, we need to work to find a solution to this problem.
>
> Who knows. First of all, seems CONFIG_AUDIT is enabled by default
> for many popular distributions, so I assume that is not compiled out.
>
> What are use cases for audit? Always running I guess?

Audit has been around for quite some time now, and it's goal is to
provide a mechanism for logging "security relevant" information in
such a way that it meets the needs of various security certification
efforts.  Traditional Linux event logging, e.g. syslog and the like,
does not meet these requirements and changing them would likely affect
the usability for those who are not required to be compliant with
these security certifications.  The Linux audit subsystem allows Linux
to be used in places it couldn't be used otherwise (or rather makes it
a *lot* easier).

That said, audit is not for everyone, and we have build time and
runtime options to help make life easier.  Beyond simply disabling
audit at compile time a number of Linux distributions effectively
shortcut audit at runtime by adding a "never" rule to the audit
filter, for example:

 % auditctl -a task,never

> Putting aside compatibility problems, it sounds that with the amount of overhead
> it adds there is no much profit in using io_uring in the first place.
> Is that so?

Well, if audit alone erased all of the io_uring advantages we should
just rip io_uring out of the kernel and people can just disable audit
instead ;)

I believe there are people who would like to use io_uring and are also
required to use a kernel with audit, either due to the need to run a
distribution kernel or the need to capture security information in the
audit stream.  I'm hoping that we can find a solution for these users;
if we don't we are asking this group to choose either io_uring or
audit, and that is something I would like to avoid.

-- 
paul moore
www.paul-moore.com
