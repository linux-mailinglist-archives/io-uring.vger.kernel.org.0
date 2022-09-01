Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE175AA182
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 23:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234002AbiIAVax (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 17:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233277AbiIAVaw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 17:30:52 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BA95FF63
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 14:30:49 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id 6-20020a9d0106000000b0063963134d04so224578otu.3
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 14:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=rN5CPt7nw3uEAzcCrq0p48l3tGPTCfoaJzTvRgTvhaY=;
        b=RExgY6pcLbrzvIhFfwy+2fJB8NPuRDYs1S130rMvHH00zZ3X9PQ4+m/d68VupVexAL
         EPTzawHwwpoMK2H/4TNmxTiFrA/o1eDz7ZaXoOufRA3+b6QhkpdGlBk+wXvMv0F0XOeN
         v9wgOpdG1c7Ef8x1e1ENSg0059CcpH0ydQhzWuw4vGmi3ccRmFYdeiB8diJN8j9K144i
         d65oXTCIZ0rOpUDpzNm+TmRp020jycWfdv6PtCcsmt4dOABNX/U/N/ZVI3VQtf1afWie
         6eFemy9pZT2StimbHGYlvnen1HxzTL6uUcq8lSP+1Q8SXekjsY1dHjLHwJCla9f4qTCV
         EXSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=rN5CPt7nw3uEAzcCrq0p48l3tGPTCfoaJzTvRgTvhaY=;
        b=cjpaaAIbipPnlhs52C0M8pmOPqY6nrn+gXiOc/f/V0j0Bc5+2hE/NE42mCB7g6b6Bm
         cTrmG3xDkLdcLrQri+/E++YqolFQZP3joK0ROwMc7KvHTkmvqRBL7FIxDbVAjbuwKM0/
         EJGQmpu9x7JzwsC5c9kahxpw5lT5ayZkq5Id9tmWg2KIiEAKtw8CPRc6zjotBQjWXdpV
         XPTVqBya1w1hnaBbJHzgE3oaBFaWdqSywuAmuOasFTa65O3mVWoQZwI1jZ86kVIOJMgy
         13qiETN2VGdFEdnY87n+OPIugOx1tt2H0rIR+rdFuFVvNCppA+0RynsUK3ZZ7yGy2sri
         k50Q==
X-Gm-Message-State: ACgBeo1wdESWCyAb2IkaycG4qDlggZexsOk2KuxC/BDiMxWUq/tt5hdm
        HqHrudAfj4+Aa5mqtQXGsjKC8VTWFo/m0rkHh1UQ
X-Google-Smtp-Source: AA6agR4NbZ4JykWGcOB7bzAC3ww/8F3lpZt3ltG1qkwMMyQuIHjLvYZp+xlmwDR2E/Sr/kVIsBI4fD1UMl5Mkoe0gms=
X-Received: by 2002:a05:6830:449e:b0:638:c72b:68ff with SMTP id
 r30-20020a056830449e00b00638c72b68ffmr13195069otv.26.1662067849022; Thu, 01
 Sep 2022 14:30:49 -0700 (PDT)
MIME-Version: 1.0
References: <166120321387.369593.7400426327771894334.stgit@olly>
 <CGME20220901201553eucas1p258ee1cba97c888aab172d31d9c06e922@eucas1p2.samsung.com>
 <166120327379.369593.4939320600435400704.stgit@olly> <20220901201551.hmdrvthtin4gkdz3@localhost>
In-Reply-To: <20220901201551.hmdrvthtin4gkdz3@localhost>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 1 Sep 2022 17:30:38 -0400
Message-ID: <CAHC9VhTDJogwcYhm2xc29kyO74CZ4wcCysySUr1CX6GcUkPf0Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] selinux: implement the security_uring_cmd() LSM hook
To:     Joel Granados <j.granados@samsung.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        io-uring@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 1, 2022 at 4:15 PM Joel Granados <j.granados@samsung.com> wrote=
:
> Hey Paul
>
> I realize that you have already sent this upstream but I wanted to share
> the Selinux part of the testing that we did to see if there is any
> feedback.
>
> With my tests I see that the selinux_uring_cmd hook is run and it
> results in a "avc : denied" when I run it with selinux in permissive
> mode with an unpriviledged user. I assume that this is the expected
> behavior. Here is how I tested
>
> *** With the patch:
> * I ran the io_uring_passthrough.c test on a char device with an
>   unpriviledged user.
> * I took care of changing the permissions of /dev/ng0n1 to 666 prior
>   to any testing.
> * made sure that Selinux was in permissive mode.
> * Made sure to have audit activated by passing "audit=3D1" to the kernel
> * After noticing that some audit messages where getting lost I upped the
>   backlog limit to 256
> * Prior to executing the test, I also placed a breakpoint inside
>   selinux_uring_cmd to make sure that it was executed.
> * This is the output of the audit when I executed the test:
>
>   [  136.615924] audit: type=3D1400 audit(1662043624.701:94): avc:  denie=
d  { create } for  pid=3D263 comm=3D"io_uring_passth" anonclass=3D[io_uring=
] scontext=3Dsystem_u:system_r:kernel_t tcontext=3Dsystem_u:object_r:kernel=
_t tclass=3Danon_inode permissive=3D1
>   [  136.621036] audit: type=3D1300 audit(1662043624.701:94): arch=3Dc000=
003e syscall=3D425 success=3Dyes exit=3D3 a0=3D40 a1=3D7ffca29835a0 a2=3D7f=
fca29835a0 a3=3D561529be2300 items=3D0 ppid=3D252 pid=3D263 auid=3D1001 uid=
=3D1001 gid=3D1002 euid=3D1001 suid=3D1001 fsuid=3D1001 egid=3D1002 sgid=3D=
1002 fsgid=3D1002 tty=3Dpts1 ses=3D3 comm=3D"io_uring_passth" exe=3D"/mnt/s=
rc/liburing/test/io_uring_passthrough.t" subj=3Dsystem_u:system_r:kernel_t =
key=3D(null)
>   [  136.624812] audit: type=3D1327 audit(1662043624.701:94): proctitle=
=3D2F6D6E742F7372632F6C69627572696E672F746573742F696F5F7572696E675F70617373=
7468726F7567682E74002F6465762F6E67306E31
>   [  136.626074] audit: type=3D1400 audit(1662043624.702:95): avc:  denie=
d  { map } for  pid=3D263 comm=3D"io_uring_passth" path=3D"anon_inode:[io_u=
ring]" dev=3D"anon_inodefs" ino=3D11715 scontext=3Dsystem_u:system_r:kernel=
_t tcontext=3Dsystem_u:object_r:kernel_t tclass=3Danon_inode permissive=3D1
>   [  136.628012] audit: type=3D1400 audit(1662043624.702:95): avc:  denie=
d  { read write } for  pid=3D263 comm=3D"io_uring_passth" path=3D"anon_inod=
e:[io_uring]" dev=3D"anon_inodefs" ino=3D11715 scontext=3Dsystem_u:system_r=
:kernel_t tcontext=3Dsystem_u:object_r:kernel_t tclass=3Danon_inode permiss=
ive=3D1
>   [  136.629873] audit: type=3D1300 audit(1662043624.702:95): arch=3Dc000=
003e syscall=3D9 success=3Dyes exit=3D140179765297152 a0=3D0 a1=3D1380 a2=
=3D3 a3=3D8001 items=3D0 ppid=3D252 pid=3D263 auid=3D1001 uid=3D1001 gid=3D=
1002 euid=3D1001 suid=3D1001 fsuid=3D1001 egid=3D1002 sgid=3D1002 fsgid=3D1=
002 tty=3Dpts1 ses=3D3 comm=3D"io_uring_passth" exe=3D"/mnt/src/liburing/te=
st/io_uring_passthrough.t" subj=3Dsystem_u:system_r:kernel_t key=3D(null)
>   [  136.632415] audit: type=3D1327 audit(1662043624.702:95): proctitle=
=3D2F6D6E742F7372632F6C69627572696E672F746573742F696F5F7572696E675F70617373=
7468726F7567682E74002F6465762F6E67306E31
>   [  136.633652] audit: type=3D1400 audit(1662043624.705:96): avc:  denie=
d  { cmd } for  pid=3D263 comm=3D"io_uring_passth" path=3D"/dev/ng0n1" dev=
=3D"devtmpfs" ino=3D120 scontext=3Dsystem_u:system_r:kernel_t tcontext=3Dsy=
stem_u:object_r:device_t tclass=3Dio_uring permissive=3D1
>   [  136.635384] audit: type=3D1336 audit(1662043624.705:96): uring_op=3D=
46 items=3D0 ppid=3D252 pid=3D263 uid=3D1001 gid=3D1002 euid=3D1001 suid=3D=
1001 fsuid=3D1001 egid=3D1002 sgid=3D1002 fsgid=3D1002 subj=3Dsystem_u:syst=
em_r:kernel_t key=3D(null)
>   [  136.636863] audit: type=3D1336 audit(1662043624.705:96): uring_op=3D=
46 items=3D0 ppid=3D252 pid=3D263 uid=3D1001 gid=3D1002 euid=3D1001 suid=3D=
1001 fsuid=3D1001 egid=3D1002 sgid=3D1002 fsgid=3D1002 subj=3Dsystem_u:syst=
em_r:kernel_t key=3D(null)
>
> * From the output on time 136.633652 I see that the access should have
>   been denied had selinux been enforcing.
> * I also saw that the breakpoint hit.
>
> *** Without the patch:
> * I ran the io_uring_passthrough.c test on a char device with an
>   unpriviledged user.
> * I took care of changing the permissions of /dev/ng0n1 to 666 prior
>   to any testing.
> * made sure that Selinux was in permissive mode.
> * Made sure to have audit activated by passing "audit=3D1" to the kernel
> * After noticing that some audit messages where getting lost I upped the
>   backlog limit to 256
> * There were no audit messages when I executed the test.
>
> As with my smack tests I would really appreciate feecback on the
> approach I took to testing and it's validity.

Hi Joel,

Thanks for the additional testing and verification!  Work like this is
always welcome, regardless if the patch has already been merged
upstream.

As far as you test approach is concerned, I think you are on the right
track, I might suggest resolving the other SELinux/AVC denials you are
seeing with your test application to help reduce the noise in the
logs.  Are you familiar with the selinux-testsuite (link below)?

* https://github.com/SELinuxProject/selinux-testsuite

--=20
paul-moore.com
