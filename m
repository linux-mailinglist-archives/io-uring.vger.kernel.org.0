Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3161E5BADB3
	for <lists+io-uring@lfdr.de>; Fri, 16 Sep 2022 14:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbiIPM7M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Sep 2022 08:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbiIPM7J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Sep 2022 08:59:09 -0400
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C718886884;
        Fri, 16 Sep 2022 05:59:06 -0700 (PDT)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20220916125903euoutp02b8b1518db86853f047bc7a1cb06288ed~VWK5r6vLl0589505895euoutp02j;
        Fri, 16 Sep 2022 12:59:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20220916125903euoutp02b8b1518db86853f047bc7a1cb06288ed~VWK5r6vLl0589505895euoutp02j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1663333143;
        bh=7S6fZCvxbKnL2G64Qtc1c+1jERgxR3HM3+9/H/MbFmQ=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=WLPwzbVaIOD+mp+5f/IzT6skdFY/q9QaMoY3j+yKmy1E8AmOOY3i1zjOt4nN/BX93
         W5mXx1PmgEFgMDXGbuSRD8O9OOP6El5rSc9UvrmU7WKBMwNFOHgyUOkgpEq1YwwiDH
         BSLwOhkwKX0evsQDpDy1bTU7k0gMXPHRoD/luWqQ=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220916125903eucas1p2af44e7ca2f96c5a0e2fed06e2bbc1017~VWK5VffOE0598605986eucas1p2N;
        Fri, 16 Sep 2022 12:59:03 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 3E.CE.19378.71374236; Fri, 16
        Sep 2022 13:59:03 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20220916125902eucas1p2cb16b02813a264bfaff6cb5946121cbb~VWK406eoz0600206002eucas1p2P;
        Fri, 16 Sep 2022 12:59:02 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220916125902eusmtrp14ca487e700130cd46842838b3d47384d~VWK4z1zSX0946509465eusmtrp1s;
        Fri, 16 Sep 2022 12:59:02 +0000 (GMT)
X-AuditID: cbfec7f5-a35ff70000014bb2-f3-632473177d84
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id AC.AA.07473.61374236; Fri, 16
        Sep 2022 13:59:02 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220916125902eusmtip1ff1f913de333188522e1eddf71055936~VWK4n9KDJ0825708257eusmtip1p;
        Fri, 16 Sep 2022 12:59:02 +0000 (GMT)
Received: from localhost (106.210.248.110) by CAMSVWEXC01.scsc.local
        (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Fri, 16 Sep 2022 13:59:01 +0100
Date:   Fri, 16 Sep 2022 14:59:00 +0200
From:   Joel Granados <j.granados@samsung.com>
To:     Paul Moore <paul@paul-moore.com>
CC:     <linux-security-module@vger.kernel.org>, <selinux@vger.kernel.org>,
        <io-uring@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH 2/3] selinux: implement the security_uring_cmd() LSM
 hook
Message-ID: <20220916125900.yvgnbpqm3j2cxpvd@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="ajzavhv4aawhfwou"
Content-Disposition: inline
In-Reply-To: <20220907081729.r3ork6q3wnvv7rrv@localhost>
X-Originating-IP: [106.210.248.110]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
        CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNKsWRmVeSWpSXmKPExsWy7djPc7rixSrJBvNPsFr8nXSM3aJ58Xo2
        i3et51gsPvQ8YrO4MeEpo8XtSdNZLM4fP8buwO7x+9ckRo9NqzrZPPbPXcPusXbvC0aPz5vk
        AlijuGxSUnMyy1KL9O0SuDLe/JnEXDDFo+LTrpksDYyrrbsYOTkkBEwkfqxexdrFyMUhJLCC
        UeLo2XmMIAkhgS+MEufum0MkPjNK3PxzkR2m48Tfh2wQieWMEgtfv2OB6ACqejodatRWRonn
        LffZQBIsAqoSs/ong41lE9CROP/mDjOILSKgIrH46XpGkAZmgXuMEjdObGYCSQgL+EtsvDcV
        rIFXwFzi8tGP7BC2oMTJmU/AtjELVEhcPdwPtI0DyJaWWP6PAyTMKWAh0bn5P9SlyhIHlx2C
        smsl1h47ww6yS0JgNqfEm9aHTBAJF4mPPQuYIWxhiVfHt0A1yEicntzDAmFnS+ycsguqpkBi
        1smpbCB7JQSsJfrO5ECEHSXW72hghgjzSdx4KwhxJZ/EpG3TocK8Eh1tQhDVahI7mrYyTmBU
        noXkr1lI/pqF8BdEWEdiwe5PbBjC2hLLFr5mhrBtJdate8+ygJF9FaN4amlxbnpqsXFearle
        cWJucWleul5yfu4mRmAaO/3v+NcdjCtefdQ7xMjEwXiIUQWo+dGG1RcYpVjy8vNSlUR4VT1V
        koV4UxIrq1KL8uOLSnNSiw8xSnOwKInzJmduSBQSSE8sSc1OTS1ILYLJMnFwSjUwTW5Rsli9
        ZmYI++Hz8zsY1379/KUz02vKydN9FrJzNP6LP91TartOQUxrwaw3a88Kva76ef/vDMfDxvrc
        d87MzfX8w9P+b13b5m0b7TeUyXefc2lnfqouGD/nifwjh/iiHRvyn0YtSK+YGdn7e+omof7w
        TYGrNc/arNRMrNOebC6VEmpkVvZcc9WZK5raFjuvbvzBfeXVnO6dnx3+fTsdXfzjIzPvpW0n
        a5227jRObTrIr5KWyjBZ6xAHu9qOVpPkUxLthldTts4QCrnN57jGdNWvnf4aHDIMEWvmPlsl
        vrdFe6a3k/p2+yD1W63+GbdNvz7PCb3E8XWjZZfSq/L/6fln2Mv/u9f/03i3dYLjXiWW4oxE
        Qy3mouJEADutF0DeAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t/xu7pixSrJBiseKFj8nXSM3aJ58Xo2
        i3et51gsPvQ8YrO4MeEpo8XtSdNZLM4fP8buwO7x+9ckRo9NqzrZPPbPXcPusXbvC0aPz5vk
        Alij9GyK8ktLUhUy8otLbJWiDS2M9AwtLfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DI2
        /H7KWjDJo2Ljlx2sDYwrrbsYOTkkBEwkTvx9yNbFyMUhJLCUUWLRkb+sEAkZiU9XPrJD2MIS
        f651QRV9ZJS4PmEXK4SzlVFi7sPzYB0sAqoSs/onM4LYbAI6Euff3GEGsUUEVCQWP13PCNLA
        LHCHUeLlnIcsIAlhAV+JNe8OMYHYvALmEpePgqwDmfqOSeLVh5OMEAlBiZMzn4A1MAuUSZz9
        cxfoDg4gW1pi+T8OkDCngIVE5+b/UKcqSxxcdgjKrpV4dX834wRG4VlIJs1CMmkWwiSIsJbE
        jX8vmTCEtSWWLXzNDGHbSqxb955lASP7KkaR1NLi3PTcYkO94sTc4tK8dL3k/NxNjMCo3nbs
        5+YdjPNefdQ7xMjEwXiIUQWo89GG1RcYpVjy8vNSlUR4VT1VkoV4UxIrq1KL8uOLSnNSiw8x
        mgKDcSKzlGhyPjDd5JXEG5oZmBqamFkamFqaGSuJ83oWdCQKCaQnlqRmp6YWpBbB9DFxcEo1
        MInGx9283mLWFDOXZ/WdG3k3g69xlvtcSdxhNktigWuOwL3CQpcZsms0/Vgr9Y8tC1hddTDy
        7qnwmctXGDQ7Z9iJ11Wts7w/3363iufib+zJoYeYkuQT0ku+PbW75FOm3jO95esmJZdNcx73
        2p9UOfSFNa59pd2ePTwrDTZKHdxzS3Py/m3Hb84X2nxIwU9e+LdJ/0OjJy09s/kFmytY1dUz
        77hv/tN3oLO6cNFciT+qoT4LVgYyc+e8uvrvvIW+vsCkLZNmnOZNnTd/yRu2I+t/CBQd7Jhk
        9y6uTF5W5qjcwYzAU996zW03Hm7dGyc6z4zvveJXs/UPCr7+77wVN/VKfmYPk+WZ2dpONzJ7
        5ymxFGckGmoxFxUnAgCIAAPMfwMAAA==
X-CMS-MailID: 20220916125902eucas1p2cb16b02813a264bfaff6cb5946121cbb
X-Msg-Generator: CA
X-RootMTR: 20220901201553eucas1p258ee1cba97c888aab172d31d9c06e922
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220901201553eucas1p258ee1cba97c888aab172d31d9c06e922
References: <166120321387.369593.7400426327771894334.stgit@olly>
        <CGME20220901201553eucas1p258ee1cba97c888aab172d31d9c06e922@eucas1p2.samsung.com>
        <166120327379.369593.4939320600435400704.stgit@olly>
        <20220901201551.hmdrvthtin4gkdz3@localhost>
        <CAHC9VhTDJogwcYhm2xc29kyO74CZ4wcCysySUr1CX6GcUkPf0Q@mail.gmail.com>
        <20220907081729.r3ork6q3wnvv7rrv@localhost>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--ajzavhv4aawhfwou
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello.

Took the time to re-run my performance tests on the current LSM patch
for io_uring_cmd. I'll explain what I did and then give the results:

How I ran it:
I took a version of the kernel with the patch a0d2212773d1 and then
compiled two versions: The first was the vanilla kernel and the other
was the same except for the LSM hook called from io_uring_cmd removed.
Same kernel configurations. For my tests I used one of the test files
=66rom FIO called t/io_uring.c which is basically a READ test. I ran my
tests on both an nvme device and the null device (/dev/null). For the
first I did not change io_uring.c and for the second I replaced the
admin calls with dummy data that was not really needed for testing with
/dev/null. These are the arguments I used for the test
"./t/io_uring -b4096 -d128 -c32 -s32 -p0 -F1 -B0 -O0 -P1 -u1 -n1"
Finally, I'm taking the max of several samples.

Results:
+-------------------------------------+------------------------+-----------=
------------+
|                Name                 | /dev/ng0n1 (BW: MiB/s) | /dev/null =
(BW: GiB/s) |
+-------------------------------------+------------------------+-----------=
------------+
| (A) for-next (vanilla)              |                   1341 |           =
      30.16 |
| (B) for-next (no io_uring_cmd hook) |                   1362 |           =
      40.61 |
| [1-(A/B)] * 100                     |             1.54185022 |          2=
5.732578183 |
+-------------------------------------+------------------------+-----------=
------------+

So on a device (dev/ng0n1) there is a 1% performance difference on a
read. Whereas on the null device (dev/null) there is a 25% difference on
a read.

This difference is interesting and expected as there is a lot more stuff
happening when we go through the actual device.

Best

Joel

On Wed, Sep 07, 2022 at 10:17:29AM +0200, Joel Granados wrote:
> Hey Paul
>=20
> On Thu, Sep 01, 2022 at 05:30:38PM -0400, Paul Moore wrote:
> > On Thu, Sep 1, 2022 at 4:15 PM Joel Granados <j.granados@samsung.com> w=
rote:
> > > Hey Paul
> > >
> > > I realize that you have already sent this upstream but I wanted to sh=
are
> > > the Selinux part of the testing that we did to see if there is any
> > > feedback.
> > >
> > > With my tests I see that the selinux_uring_cmd hook is run and it
> > > results in a "avc : denied" when I run it with selinux in permissive
> > > mode with an unpriviledged user. I assume that this is the expected
> > > behavior. Here is how I tested
> > >
> > > *** With the patch:
> > > * I ran the io_uring_passthrough.c test on a char device with an
> > >   unpriviledged user.
> > > * I took care of changing the permissions of /dev/ng0n1 to 666 prior
> > >   to any testing.
> > > * made sure that Selinux was in permissive mode.
> > > * Made sure to have audit activated by passing "audit=3D1" to the ker=
nel
> > > * After noticing that some audit messages where getting lost I upped =
the
> > >   backlog limit to 256
> > > * Prior to executing the test, I also placed a breakpoint inside
> > >   selinux_uring_cmd to make sure that it was executed.
> > > * This is the output of the audit when I executed the test:
> > >
> > >   [  136.615924] audit: type=3D1400 audit(1662043624.701:94): avc:  d=
enied  { create } for  pid=3D263 comm=3D"io_uring_passth" anonclass=3D[io_u=
ring] scontext=3Dsystem_u:system_r:kernel_t tcontext=3Dsystem_u:object_r:ke=
rnel_t tclass=3Danon_inode permissive=3D1
> > >   [  136.621036] audit: type=3D1300 audit(1662043624.701:94): arch=3D=
c000003e syscall=3D425 success=3Dyes exit=3D3 a0=3D40 a1=3D7ffca29835a0 a2=
=3D7ffca29835a0 a3=3D561529be2300 items=3D0 ppid=3D252 pid=3D263 auid=3D100=
1 uid=3D1001 gid=3D1002 euid=3D1001 suid=3D1001 fsuid=3D1001 egid=3D1002 sg=
id=3D1002 fsgid=3D1002 tty=3Dpts1 ses=3D3 comm=3D"io_uring_passth" exe=3D"/=
mnt/src/liburing/test/io_uring_passthrough.t" subj=3Dsystem_u:system_r:kern=
el_t key=3D(null)
> > >   [  136.624812] audit: type=3D1327 audit(1662043624.701:94): proctit=
le=3D2F6D6E742F7372632F6C69627572696E672F746573742F696F5F7572696E675F706173=
737468726F7567682E74002F6465762F6E67306E31
> > >   [  136.626074] audit: type=3D1400 audit(1662043624.702:95): avc:  d=
enied  { map } for  pid=3D263 comm=3D"io_uring_passth" path=3D"anon_inode:[=
io_uring]" dev=3D"anon_inodefs" ino=3D11715 scontext=3Dsystem_u:system_r:ke=
rnel_t tcontext=3Dsystem_u:object_r:kernel_t tclass=3Danon_inode permissive=
=3D1
> > >   [  136.628012] audit: type=3D1400 audit(1662043624.702:95): avc:  d=
enied  { read write } for  pid=3D263 comm=3D"io_uring_passth" path=3D"anon_=
inode:[io_uring]" dev=3D"anon_inodefs" ino=3D11715 scontext=3Dsystem_u:syst=
em_r:kernel_t tcontext=3Dsystem_u:object_r:kernel_t tclass=3Danon_inode per=
missive=3D1
> > >   [  136.629873] audit: type=3D1300 audit(1662043624.702:95): arch=3D=
c000003e syscall=3D9 success=3Dyes exit=3D140179765297152 a0=3D0 a1=3D1380 =
a2=3D3 a3=3D8001 items=3D0 ppid=3D252 pid=3D263 auid=3D1001 uid=3D1001 gid=
=3D1002 euid=3D1001 suid=3D1001 fsuid=3D1001 egid=3D1002 sgid=3D1002 fsgid=
=3D1002 tty=3Dpts1 ses=3D3 comm=3D"io_uring_passth" exe=3D"/mnt/src/liburin=
g/test/io_uring_passthrough.t" subj=3Dsystem_u:system_r:kernel_t key=3D(nul=
l)
> > >   [  136.632415] audit: type=3D1327 audit(1662043624.702:95): proctit=
le=3D2F6D6E742F7372632F6C69627572696E672F746573742F696F5F7572696E675F706173=
737468726F7567682E74002F6465762F6E67306E31
> > >   [  136.633652] audit: type=3D1400 audit(1662043624.705:96): avc:  d=
enied  { cmd } for  pid=3D263 comm=3D"io_uring_passth" path=3D"/dev/ng0n1" =
dev=3D"devtmpfs" ino=3D120 scontext=3Dsystem_u:system_r:kernel_t tcontext=
=3Dsystem_u:object_r:device_t tclass=3Dio_uring permissive=3D1
> > >   [  136.635384] audit: type=3D1336 audit(1662043624.705:96): uring_o=
p=3D46 items=3D0 ppid=3D252 pid=3D263 uid=3D1001 gid=3D1002 euid=3D1001 sui=
d=3D1001 fsuid=3D1001 egid=3D1002 sgid=3D1002 fsgid=3D1002 subj=3Dsystem_u:=
system_r:kernel_t key=3D(null)
> > >   [  136.636863] audit: type=3D1336 audit(1662043624.705:96): uring_o=
p=3D46 items=3D0 ppid=3D252 pid=3D263 uid=3D1001 gid=3D1002 euid=3D1001 sui=
d=3D1001 fsuid=3D1001 egid=3D1002 sgid=3D1002 fsgid=3D1002 subj=3Dsystem_u:=
system_r:kernel_t key=3D(null)
> > >
> > > * From the output on time 136.633652 I see that the access should have
> > >   been denied had selinux been enforcing.
> > > * I also saw that the breakpoint hit.
> > >
> > > *** Without the patch:
> > > * I ran the io_uring_passthrough.c test on a char device with an
> > >   unpriviledged user.
> > > * I took care of changing the permissions of /dev/ng0n1 to 666 prior
> > >   to any testing.
> > > * made sure that Selinux was in permissive mode.
> > > * Made sure to have audit activated by passing "audit=3D1" to the ker=
nel
> > > * After noticing that some audit messages where getting lost I upped =
the
> > >   backlog limit to 256
> > > * There were no audit messages when I executed the test.
> > >
> > > As with my smack tests I would really appreciate feecback on the
> > > approach I took to testing and it's validity.
> >=20
> > Hi Joel,
> >=20
> > Thanks for the additional testing and verification!  Work like this is
> > always welcome, regardless if the patch has already been merged
> > upstream.
> np
>=20
> >=20
> > As far as you test approach is concerned, I think you are on the right
> > track, I might suggest resolving the other SELinux/AVC denials you are
> > seeing with your test application to help reduce the noise in the
> > logs.  Are you familiar with the selinux-testsuite (link below)?
> >=20
> > * https://protect2.fireeye.com/v1/url?k=3D6f356c96-0ebe79ac-6f34e7d9-74=
fe4860008a-01002a6e4c92bb3e&q=3D1&e=3D46f33488-9311-49fa-9747-da210f2d147d&=
u=3Dhttps%3A%2F%2Fgithub.com%2FSELinuxProject%2Fselinux-testsuite
> Thx. Could not figure out how to remove the AVC from a quick look at the
> page, but I'll probably figures something out :).
>=20
> ATM, I'm doing a performance test on the io_uring_passtrhough
> path to see how much, if any, perf we loose.
>=20
> Thx again
>=20
> Best
>=20
> Joel
>=20
> >=20
> > --=20
> > paul-moore.com



--ajzavhv4aawhfwou
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmMkcwgACgkQupfNUreW
QU9KIgv+KPms+bdDy7mZLQHCn26Q5KAgdB/I9W/EXwEnA1UNCz2ynb3ItPIq8Y2X
4hPXWehxRJfgu+sSUjGW5klfV3rgfpErMm7XqkwvaG34FDfHd/JK9bi7+xywD1nW
CZucd2o5xFp4tVuTNuo+VXwHIJOZRml9C01ji98vhTcmE9nBCxv5mSrmx7ZPrMPF
f38tc7ckONumFxrGpIWXWn5l16o+yH6EobHnPDZSIS/hg4vRcbAPK/FwmMs/F/iG
P7TLMBcTzj4KLqsHX0Iu2I6ZPFaass8+bOtqBJYmGWYTL5nyUVqeVxWrjKJCmhxf
HFtDeBpg8wCDitWlZ0TFV1KcnycuLUof+0p9sVfWAn/EGkPh1R76gNiJXgo/Te2i
hnZHy0jHW4k+msmLUHconZb9gOJSvwP35FMEGIzc0Qg4g4elwUo/2RNRzHK+fEE+
jkRaE2X0owmv7jevH7sJOEftjuur1V3s5lKcY0T5/EPKU5qWyEw+FpzL50quQD8f
uuyOkngI
=P0TM
-----END PGP SIGNATURE-----

--ajzavhv4aawhfwou--
