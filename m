Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2701E7A01
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2020 12:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725681AbgE2KCi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 May 2020 06:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgE2KCh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 May 2020 06:02:37 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E59C03E969;
        Fri, 29 May 2020 03:02:37 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id y18so1713726iow.3;
        Fri, 29 May 2020 03:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=PRXLLP0ChGebQsjy7LttpTWT4vF15KpSJHuHPQMfXdg=;
        b=J7Irtzhfx6yeYMngT0dh1GtsRRS/07J6BytNuUleDqw7uCTPig9ihWSvPweJPmmsy0
         vn3SBWB0MysOQxyzA/os4hdtN8bWw59kCBuVfmpZb+O9x70WhrrYwSrV4sOf3D7HthZI
         BqWsBJq4xfQV8f18Ytdzl/gevSCKsa1RsjOkTU7f2S7I/pZxPDGOg1evDHrNc6aWOxnw
         WG+3cB4U8e/dkENms31Ixe5DVyhiD+I3q5B5YW9LYCGW2d5PO2H14TQQMFb5r2JzfEIp
         WzMnwMSr1boTYAAvQpjlJWVebRP85UGdtoev9Fl0H6aYtyyUV2u/w0O4tXGkfRTTKKW6
         JbAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=PRXLLP0ChGebQsjy7LttpTWT4vF15KpSJHuHPQMfXdg=;
        b=pCtC+sL1rsyVZhD38tKxvA0OvwV6210XydbXEMc8mCrHF3ArEcR0rqfRhud8NOQU8S
         lAPppMy2Ao4Rf9IvCfzRPegiWnXbhKcTY6UJGghhwLJ8HE26pILeIiRxVetuXuNP4b4O
         E7g+ze8pA+ezEpzHz0UFhXl5rf2ZTYxIETAeTosP3PQzGTJADBp00NTdlQ0C/WupV36G
         3jAouXehnRYJhfcb1dgQeFGxzPi1RwKTE326hUDNCTPqfJzbjuB+78zblgvFJpiHcPqc
         2C5r/VL7XsoYHG0VH/IdSMYsQR7SlRGDAD0COpCD+6TsKLwVb5PPu9lspHm8zRScfTX8
         O9uw==
X-Gm-Message-State: AOAM5304Sqm0ZfHZjC3T+N6jJR+mBgsNFbiXUL/rUjOnbJzRk+W/r8uN
        H8z1zNAg0G0FM1YidBxbxfP7ZgwW2MVHt3jOV3k=
X-Google-Smtp-Source: ABdhPJzqpEoQkAYUOAOHwjoJZZG1uP7pVCnN5FOvfILoxWd1U7BINI6qEZTyxdObt9ncMCTTtfe7+0yqxvPhQUiHOgk=
X-Received: by 2002:a02:ca18:: with SMTP id i24mr6407331jak.70.1590746556697;
 Fri, 29 May 2020 03:02:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200526195123.29053-1-axboe@kernel.dk> <CA+icZUWfX+QmroE6j74C7o-BdfMF5=6PdYrA=5W_JCKddqkJgQ@mail.gmail.com>
 <bab2d6f8-4c65-be21-6a8e-29b76c06807d@kernel.dk>
In-Reply-To: <bab2d6f8-4c65-be21-6a8e-29b76c06807d@kernel.dk>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Fri, 29 May 2020 12:02:40 +0200
Message-ID: <CA+icZUUgazqLRwnbQgFPhCa5vAsAvJhjCGMYs7KYBZgA04mSyw@mail.gmail.com>
Subject: Re: [PATCHSET v5 0/12] Add support for async buffered reads
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[ ... ]

> > Hi Jens,
> >
> > I have pulled linux-block.git#async-buffered.5 on top of Linux v5.7-rc7.
> >
> > From first feelings:
> > The booting into the system (until sddm display-login-manager) took a
> > bit longer.
> > The same after login and booting into KDE/Plasma.
>
> There is no difference for "regular" use cases, only io_uring with
> buffered reads will behave differently. So I don't think you have longer
> boot times due to this.
>

Yupp, you are right.

The previous Linux v5.7-rc7 without your patchset shows the same symptoms.

I did some debugging and optimizing with systemd-analyze boot and time.

I optimized systemd-journald.service and systemd-journal-flush.service...

# cat /etc/systemd/journald.conf.d/00-journal-size.conf
[Journal]
SystemMaxUse=50M

...and reduced the time spent flushing systemd's journal from ~30s
down to 1,6s...

# journalctl -b --unit systemd-journald.service
-- Logs begin at Fri 2020-05-29 00:58:37 CEST, end at Fri 2020-05-29
11:42:18 CEST. --
Mai 29 11:34:52 iniza systemd-journald[281]: Journal started
Mai 29 11:34:52 iniza systemd-journald[281]: Runtime Journal
(/run/log/journal/566abbcb226b405db834b17a26fe4727) is 8.0M, max
78.5M, 70.5M free.
Mai 29 11:34:53 iniza systemd-journald[281]: Time spent on flushing to
/var/log/journal/566abbcb226b405db834b17a26fe4727 is 1.656233s for 765
entries.
Mai 29 11:34:53 iniza systemd-journald[281]: System Journal
(/var/log/journal/566abbcb226b405db834b17a26fe4727) is 56.2M, max
50.0M, 0B free.

Unfortunately, I upgraded some user-space stuff like udisks2 and
libblockdev packages.
Downgrading did not help and disabling the systemd-unit also.

As I saw stallings with e2scrub_reap.service and swap partition
(partly seen in the boot-process and noted the UUID 3f8e).
I disabled e2scrub_reap.service and deactivated swap partition in /etc/fstab.

Doing all above together did not help.

Finally, I checked the health of the HDD where my root-fs is.
smartmontools says everything is OK.

I have not checked the status of the Ext4-FS where my root-fs is.
Such things I do with a linux-live-system - as a Debianist I admit I
use an ArchLinux ISO on USB-stick :-).

Unsure, if I will contact the systemd (and mabye udisks) Debian folks
to hear their opinion.

Thanks Jens and your patchset.
I don't know when I last run systemd-analyze & stuff and investigated
so deeply :-).

A lot of Hygge (I love to write wrong Huegge - see English hugs) to you Jens.

- Sedat -

[1] http://ftp.halifax.rwth-aachen.de/archlinux/iso/
