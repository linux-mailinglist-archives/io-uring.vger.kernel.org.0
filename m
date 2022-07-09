Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A7456C672
	for <lists+io-uring@lfdr.de>; Sat,  9 Jul 2022 05:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiGIDkM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Jul 2022 23:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGIDkL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Jul 2022 23:40:11 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE8A820D9;
        Fri,  8 Jul 2022 20:40:09 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id z7so337442qko.8;
        Fri, 08 Jul 2022 20:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r3Acqf0qPiTpok7l+9NMl1YVG7Iq8pqhxKKh4tFH9Zs=;
        b=aanHKRsCkYIfLBKuIHYzWRzLDdqIEDo5Xc8RksnSO8C5RqR62uXq4ZIWZ31NNhrg1h
         Ua2p3cC/AP4bcmRtKBr6e4swoP4TAwNGD2uO6FA3W+UuQDBXWH2MwcuEVQb8amb+UYA2
         eB0xCs8MpTjMu+r/I0paZ9sAPRWIA7caN6I1jmBbiXC4ubRMOoBDlyIhdJ97q6qMhCS3
         N5PpuCSRkzjECjp3YJr7qgyEeywUAeNdCeRUtjo9VKrxumIP9UIjVgFIPmcnWMMvB7wa
         56wF3hjQZOh8YO5CvO/vEE+dXaVA/hDQY7doupc1zKRGbu5fr3jm5ygwTbC35o/VCMQb
         1BYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r3Acqf0qPiTpok7l+9NMl1YVG7Iq8pqhxKKh4tFH9Zs=;
        b=qDwUnFH5+OrnB55u5rYNdEtV8L350HuDGrzxZ7/Kcn3xCUJcWTOcLQo3PevGKOibEI
         WgURR86U891sDju0l9nW7qM5ARdyHae9hDCSk2nOfD4nn05+ZqqhBFyzbEXoYahbt7N+
         HDPxSHXRolf+uxyDfSNya2MCsprYV6xUkf8tQRNF7FxbofCAY4jQZKdzMjn9JyZ52BUU
         X9cSlgxrQBU/0hhndiZx/muurt+vS9n4ChHbxoimPasMVyJ6TUHh6NRo89h1J1TNjHZo
         /j+If2h7lHaOqa+hT6VCdkoTn2tGutpwa7PPsBupba++stB8Ze1bsUkze4SmPSPB9C34
         UUcA==
X-Gm-Message-State: AJIora9pSSZpUc2tEtruEh+W2n4uK6WU7cQHU2X9JwMfd6x9vxj3p9hE
        rhLOWJlFiM187TvJRN3LQ3Q68MWh29KIXZRBGjg=
X-Google-Smtp-Source: AGRyM1v3YhObDT/llsef0u9NuSsZKSzQPT7i93CI0qw8+oruef7S/HdMLKHSrYhQqiH6Nm+Acg8i9AErGsY1TdtGbLk=
X-Received: by 2002:a05:620a:bcb:b0:6a9:8f2a:ecf9 with SMTP id
 s11-20020a05620a0bcb00b006a98f2aecf9mr4756378qki.351.1657338008896; Fri, 08
 Jul 2022 20:40:08 -0700 (PDT)
MIME-Version: 1.0
References: <af573afc-8f6a-d69e-24ab-970b33df45d9@proxmox.com>
 <20220708174815.3g4atpcu6u6icrhp@cyberdelia> <CANT5p=rSKRe_EXFmKS+qRyBo4i9Ko1pcgwxy-B1gugJtKjVAMA@mail.gmail.com>
In-Reply-To: <CANT5p=rSKRe_EXFmKS+qRyBo4i9Ko1pcgwxy-B1gugJtKjVAMA@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Sat, 9 Jul 2022 09:09:57 +0530
Message-ID: <CANT5p=qxYh+VxXpVGd2GO=WJoZ5J_p0oodN+wcFqC43t49pRqA@mail.gmail.com>
Subject: Re: Problematic interaction of io_uring and CIFS
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     Fabian Ebner <f.ebner@proxmox.com>, io-uring@vger.kernel.org,
        CIFS <linux-cifs@vger.kernel.org>,
        Thomas Lamprecht <t.lamprecht@proxmox.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jul 9, 2022 at 9:00 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> On Fri, Jul 8, 2022 at 11:22 PM Enzo Matsumiya <ematsumiya@suse.de> wrote:
> >
> > On 07/08, Fabian Ebner wrote:
> > >(Re-sending without the log from the older kernel, because the mail hit
> > >the 100000 char limit with that)
> > >
> > >Hi,
> > >it seems that in kernels >= 5.15, io_uring and CIFS don't interact
> > >nicely sometimes, leading to IO errors. Unfortunately, my reproducer is
> > >a QEMU VM with a disk on CIFS (original report by one of our users [0]),
> > >but I can try to cook up something simpler if you want.
> > >
> > >Bisecting got me to 8ef12efe26c8 ("io_uring: run regular file
> > >completions from task_work") being the first bad commit.
> > >
> > >Attached are debug logs taken with Ubuntu's build of 5.18.6. QEMU trace
> > >was taken with '-trace luring*' and CIFS debug log was enabled as
> > >described in [1].
> > >
> > >Without CIFS debugging, the error messages in syslog are, for 5.18.6:
> > >> Jun 29 12:41:45 pve702 kernel: [  112.664911] CIFS: VFS: \\192.168.20.241 Error -512 sending data on socket to server
> > >> Jun 29 12:41:46 pve702 kernel: [  112.796227] CIFS: Status code returned 0xc00000d0 STATUS_REQUEST_NOT_ACCEPTED
> > >> Jun 29 12:41:46 pve702 kernel: [  112.796250] CIFS: VFS: \\192.168.20.241 Send error in SessSetup = -5
> > >> Jun 29 12:41:46 pve702 kernel: [  112.797781] CIFS: VFS: \\192.168.20.241 Send error in SessSetup = -11
> > >> Jun 29 12:41:46 pve702 kernel: [  112.798065] CIFS: VFS: \\192.168.20.241 Send error in SessSetup = -11
> > >> Jun 29 12:41:46 pve702 kernel: [  112.813485] CIFS: Status code returned 0xc00000d0 STATUS_REQUEST_NOT_ACCEPTED
> > >> Jun 29 12:41:46 pve702 kernel: [  112.813497] CIFS: VFS: \\192.168.20.241 Send error in SessSetup = -5
> > >> Jun 29 12:41:46 pve702 kernel: [  112.826829] CIFS: Status code returned 0xc00000d0 STATUS_REQUEST_NOT_ACCEPTED
> > >> Jun 29 12:41:46 pve702 kernel: [  112.826837] CIFS: VFS: \\192.168.20.241 Send error in SessSetup = -5
> > >> Jun 29 12:41:46 pve702 kernel: [  112.839369] CIFS: Status code returned 0xc00000d0 STATUS_REQUEST_NOT_ACCEPTED
> > >> Jun 29 12:41:46 pve702 kernel: [  112.839381] CIFS: VFS: \\192.168.20.241 Send error in SessSetup = -5
> > >> Jun 29 12:41:46 pve702 kernel: [  112.851854] CIFS: Status code returned 0xc00000d0 STATUS_REQUEST_NOT_ACCEPTED
> > >> Jun 29 12:41:46 pve702 kernel: [  112.851867] CIFS: VFS: \\192.168.20.241 Send error in SessSetup = -5
> > >> Jun 29 12:41:46 pve702 kernel: [  112.870763] CIFS: Status code returned 0xc00000d0 STATUS_REQUEST_NOT_ACCEPTED
> > >> Jun 29 12:41:46 pve702 kernel: [  112.870777] CIFS: VFS: \\192.168.20.241 Send error in SessSetup = -5
> >
> > It looks like this has something to do with multiple session setups on
> > the same channel, and there's a fix introduced in 5.19-rc1:
> >
> > 5752bf645f9 "cifs: avoid parallel session setups on same channel"
> >
> > Can you build a test kernel with that commit and test it again? I
> > couldn't reproduce this with a small liburing test program. If you can
> > provide one, I'd be happy to take a deeper look at this bug.
> >
> > Please note that the actual root cause of the error (CIFS needing
> > reconnect) is not very clear to me, but I don't have experience with
> > io_uring anyway:
> >
> > 178 Jun 29 11:25:39 pve702 kernel: [   87.439910] CIFS: fs/cifs/transport.c: signal is pending after attempt to send
> > 179 Jun 29 11:25:39 pve702 kernel: [   87.439920] CIFS: fs/cifs/transport.c: partial send (wanted=65652 sent=53364): terminating session

This error indicates that the socket could only send partial data to
the server. This causes the client to reconnect. While I don't think
this is the primary issue here, it is definitely an issue. Please look
into that as well.

> > 180 Jun 29 11:25:39 pve702 kernel: [   87.439970] CIFS: VFS: \\192.168.20.241 Error -512 sending data on socket to server
> > <cifs marks all sessions and tcons for reconnect and gets in the
> > erroneous reconnect loop as shown above>
> >
> >
> > Cheers,
> >
> > Enzo
>
> Hi Fabian,
>
> It looks like the server is rejecting new binding session requests
> with STATUS_REQUEST_NOT_ACCEPTED.
> Are you saying that the issue is specific to 5.15+ kernel, and the
> issue doesn't happen on older kernels?
> Also, what server are you using? Has that changed across these attempts?
>
> Can you please dump the output of:
> cat /proc/fs/cifs/DebugData
> when the issue is happening?
>
> --
> Regards,
> Shyam



-- 
Regards,
Shyam
