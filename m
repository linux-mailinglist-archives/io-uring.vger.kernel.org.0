Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E89535AA0C3
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 22:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbiIAUQJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 16:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbiIAUQI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 16:16:08 -0400
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A9353D23;
        Thu,  1 Sep 2022 13:16:01 -0700 (PDT)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20220901201555euoutp015eb8f4715c251cbc570388894830c43a~Q1dDTeZeh2048520485euoutp01k;
        Thu,  1 Sep 2022 20:15:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20220901201555euoutp015eb8f4715c251cbc570388894830c43a~Q1dDTeZeh2048520485euoutp01k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662063355;
        bh=NvgOSeFoFSogNC1LBuq58Pq6JzHXJiAK+5etLnqs59A=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=ssxmPI7I8hxRAcQo/6bqpUNo7T1S8o4eBE1TPnkLwxRZdM1mGz7OTkdzAMvdyWIrP
         YNUBqUM6s78T9gzntzTEkuaEwoiFColYiyH3JW1H3jocWQnt8D9q29a+Th0ah8mvTF
         Q8DKFKUeXEAag3HM5qZgdPgNiBddh541xVLzICyU=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220901201554eucas1p17ef2c6f3ab968486fb75ea8e9973de4e~Q1dCSDApY2874428744eucas1p1T;
        Thu,  1 Sep 2022 20:15:54 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id DE.56.07817.AF211136; Thu,  1
        Sep 2022 21:15:54 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20220901201553eucas1p258ee1cba97c888aab172d31d9c06e922~Q1dBQRoEw0139001390eucas1p2b;
        Thu,  1 Sep 2022 20:15:53 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220901201553eusmtrp15391a5bea0f047ed1140c5c877694492~Q1dBPn3KQ0250802508eusmtrp1S;
        Thu,  1 Sep 2022 20:15:53 +0000 (GMT)
X-AuditID: cbfec7f4-893ff70000011e89-0e-631112fa8f57
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 98.B9.07473.9F211136; Thu,  1
        Sep 2022 21:15:53 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220901201552eusmtip14e77c3a00cd1e48cc1ddcb20fb996499~Q1dBFOEQA0914409144eusmtip17;
        Thu,  1 Sep 2022 20:15:52 +0000 (GMT)
Received: from localhost (106.210.248.128) by CAMSVWEXC01.scsc.local
        (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Thu, 1 Sep 2022 21:15:52 +0100
Date:   Thu, 1 Sep 2022 22:15:51 +0200
From:   Joel Granados <j.granados@samsung.com>
To:     Paul Moore <paul@paul-moore.com>
CC:     <linux-security-module@vger.kernel.org>, <selinux@vger.kernel.org>,
        <io-uring@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH 2/3] selinux: implement the security_uring_cmd() LSM
 hook
Message-ID: <20220901201551.hmdrvthtin4gkdz3@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="kd4tc2umiwrccsmt"
Content-Disposition: inline
In-Reply-To: <166120327379.369593.4939320600435400704.stgit@olly>
X-Originating-IP: [106.210.248.128]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
        CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLKsWRmVeSWpSXmKPExsWy7djPc7q/hASTDR53cVv8nXSM3aJ58Xo2
        i3et51gsPvQ8YrO4MeEpo8XtSdNZLM4fP8buwO7x+9ckRo9NqzrZPPbPXcPusXbvC0aPz5vk
        AlijuGxSUnMyy1KL9O0SuDJ+Lb3CVrDQteL+0bnMDYwvrboYOTkkBEwkdq//ytjFyMUhJLCC
        UWLNhF52COcLo8TxG40sEM5nRon5c+4ww7RcftjECpFYzihxdFEfK1zVxXvXoJwtjBKHjmxl
        AWlhEVCRmLHjI1g7m4COxPk3EKNEgOKLn64H284scI9R4saJzUwgCWEBf4mN96Yygti8AuYS
        m5vvQtmCEidnPgEbyixQIbHu3VagazmAbGmJ5f84QMKcAo4SV1//YII4VVmi6dESVgi7VmLt
        sTNgz0kIzOaU+Hb+MhtEwkXi2/a77BC2sMSr41ugbBmJ05N7WCDsbImdU3ZB/V8gMevkVDaQ
        vRIC1hJ9Z3Igwo4S63c0MEOE+SRuvBWEuJJPYtK26VBhXomONiGIajWJHU1bGScwKs9C8tcs
        JH/NQvgLIqwjsWD3JzYMYW2JZQtfM0PYthLr1r1nWcDIvopRPLW0ODc9tdgoL7Vcrzgxt7g0
        L10vOT93EyMwlZ3+d/zLDsblrz7qHWJk4mA8xKgC1Pxow+oLjFIsefl5qUoivFMPCyQL8aYk
        VlalFuXHF5XmpBYfYpTmYFES503O3JAoJJCeWJKanZpakFoEk2Xi4JRqYFrnkMqVFhxQ8Nnz
        WcyaqK/3LONvz22211m7+GiB7EHpGK+i7m5Wo4hZpkG+/eL2lgud7f61sHl8Ln59XD7n+bXy
        I68W2zy2Y+tniD+QIsLmkPr0rtDh4DlfJrkqyGZsvfqp7e2E3nnG02NyXv65OXGn85Xn3yvt
        c/82Xnliaik1c8910aVVXbsaGK8+k+k6mT2f7dvb69PsZFKNfA2Y+zdevtT6IGPOCqG9jry+
        hy2vJRy39pw+5/DpnktK9v//bz/FyrePVW3nprBj5lp8/+VS5/vdu7tp3d6DQhbaa15oHZv6
        1NZGN1zGQ+T45DLjhzm/G2fueWP5nu1aQX1116YgEasfUyJlC+PD7vGe/qXEUpyRaKjFXFSc
        CAB/3yR14AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t/xu7o/hQSTDVZvZ7P4O+kYu0Xz4vVs
        Fu9az7FYfOh5xGZxY8JTRovbk6azWJw/fozdgd3j969JjB6bVnWyeeyfu4bdY+3eF4wenzfJ
        BbBG6dkU5ZeWpCpk5BeX2CpFG1oY6RlaWugZmVjqGRqbx1oZmSrp29mkpOZklqUW6dsl6GX0
        NE9mLpjvWrFu3VrmBsbnVl2MnBwSAiYSlx82sXYxcnEICSxllPi56hkjREJG4tOVj+wQtrDE
        n2tdbBBFHxklGqddZYRwtjBKXN4+lw2kikVARWLGjo/MIDabgI7E+Td3wGwRoPjip+vBGpgF
        7jBKvJzzkAUkISzgK7Hm3SEmEJtXwFxic/NdsNVCAuUSP3Y1sELEBSVOznwCVs8sUCbRv+U1
        UJwDyJaWWP6PAyTMKeAocfX1DyaIS5Ulmh4tYYWwayVe3d/NOIFReBaSSbOQTJqFMAkirCVx
        499LJgxhbYllC18zQ9i2EuvWvWdZwMi+ilEktbQ4Nz232FCvODG3uDQvXS85P3cTIzCmtx37
        uXkH47xXH/UOMTJxMB5iVAHqfLRh9QVGKZa8/LxUJRHeqYcFkoV4UxIrq1KL8uOLSnNSiw8x
        mgJDcSKzlGhyPjDZ5JXEG5oZmBqamFkamFqaGSuJ83oWdCQKCaQnlqRmp6YWpBbB9DFxcEo1
        MHGcu2bG4fTl+FLeLVOf2h6Um1CWoLl18QsV1S+/r5iVzb4arGpVze8Z1LHE9pJ62Y7fLurz
        Rd7MtjgWwD1hOZfehLdXDz95Z3KsfJKO7M4r2vkbzOdvunCwa7N2nm7Km1tLLK32dTD935ip
        7/q+4lOJhsPDz/N5HnqU2lw4wlQaybaC48rm+ykrPecExju4xqxIOVirUenw09lmpWjw35yv
        56wk8j/fevovzV9k9+Hd2pfCtLmMAxjz1kb0XjcVFN1+zkovdp74BxPLtn7fuxeP7eeYdPlW
        8OItGi28lxxf2kTLTBWxVpnWYLtkys9Z6cJtRTvrHU6eMiz7V3jvYFLDwqwnHIUdR7lk3y7e
        +12JpTgj0VCLuag4EQCv2SsHfgMAAA==
X-CMS-MailID: 20220901201553eucas1p258ee1cba97c888aab172d31d9c06e922
X-Msg-Generator: CA
X-RootMTR: 20220901201553eucas1p258ee1cba97c888aab172d31d9c06e922
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220901201553eucas1p258ee1cba97c888aab172d31d9c06e922
References: <166120321387.369593.7400426327771894334.stgit@olly>
        <166120327379.369593.4939320600435400704.stgit@olly>
        <CGME20220901201553eucas1p258ee1cba97c888aab172d31d9c06e922@eucas1p2.samsung.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--kd4tc2umiwrccsmt
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Paul

I realize that you have already sent this upstream but I wanted to share
the Selinux part of the testing that we did to see if there is any
feedback.

With my tests I see that the selinux_uring_cmd hook is run and it
results in a "avc : denied" when I run it with selinux in permissive
mode with an unpriviledged user. I assume that this is the expected
behavior. Here is how I tested

*** With the patch:
* I ran the io_uring_passthrough.c test on a char device with an
  unpriviledged user.
* I took care of changing the permissions of /dev/ng0n1 to 666 prior
  to any testing.
* made sure that Selinux was in permissive mode.
* Made sure to have audit activated by passing "audit=3D1" to the kernel
* After noticing that some audit messages where getting lost I upped the
  backlog limit to 256
* Prior to executing the test, I also placed a breakpoint inside
  selinux_uring_cmd to make sure that it was executed.
* This is the output of the audit when I executed the test:

  [  136.615924] audit: type=3D1400 audit(1662043624.701:94): avc:  denied =
 { create } for  pid=3D263 comm=3D"io_uring_passth" anonclass=3D[io_uring] =
scontext=3Dsystem_u:system_r:kernel_t tcontext=3Dsystem_u:object_r:kernel_t=
 tclass=3Danon_inode permissive=3D1
  [  136.621036] audit: type=3D1300 audit(1662043624.701:94): arch=3Dc00000=
3e syscall=3D425 success=3Dyes exit=3D3 a0=3D40 a1=3D7ffca29835a0 a2=3D7ffc=
a29835a0 a3=3D561529be2300 items=3D0 ppid=3D252 pid=3D263 auid=3D1001 uid=
=3D1001 gid=3D1002 euid=3D1001 suid=3D1001 fsuid=3D1001 egid=3D1002 sgid=3D=
1002 fsgid=3D1002 tty=3Dpts1 ses=3D3 comm=3D"io_uring_passth" exe=3D"/mnt/s=
rc/liburing/test/io_uring_passthrough.t" subj=3Dsystem_u:system_r:kernel_t =
key=3D(null)
  [  136.624812] audit: type=3D1327 audit(1662043624.701:94): proctitle=3D2=
F6D6E742F7372632F6C69627572696E672F746573742F696F5F7572696E675F706173737468=
726F7567682E74002F6465762F6E67306E31
  [  136.626074] audit: type=3D1400 audit(1662043624.702:95): avc:  denied =
 { map } for  pid=3D263 comm=3D"io_uring_passth" path=3D"anon_inode:[io_uri=
ng]" dev=3D"anon_inodefs" ino=3D11715 scontext=3Dsystem_u:system_r:kernel_t=
 tcontext=3Dsystem_u:object_r:kernel_t tclass=3Danon_inode permissive=3D1
  [  136.628012] audit: type=3D1400 audit(1662043624.702:95): avc:  denied =
 { read write } for  pid=3D263 comm=3D"io_uring_passth" path=3D"anon_inode:=
[io_uring]" dev=3D"anon_inodefs" ino=3D11715 scontext=3Dsystem_u:system_r:k=
ernel_t tcontext=3Dsystem_u:object_r:kernel_t tclass=3Danon_inode permissiv=
e=3D1
  [  136.629873] audit: type=3D1300 audit(1662043624.702:95): arch=3Dc00000=
3e syscall=3D9 success=3Dyes exit=3D140179765297152 a0=3D0 a1=3D1380 a2=3D3=
 a3=3D8001 items=3D0 ppid=3D252 pid=3D263 auid=3D1001 uid=3D1001 gid=3D1002=
 euid=3D1001 suid=3D1001 fsuid=3D1001 egid=3D1002 sgid=3D1002 fsgid=3D1002 =
tty=3Dpts1 ses=3D3 comm=3D"io_uring_passth" exe=3D"/mnt/src/liburing/test/i=
o_uring_passthrough.t" subj=3Dsystem_u:system_r:kernel_t key=3D(null)
  [  136.632415] audit: type=3D1327 audit(1662043624.702:95): proctitle=3D2=
F6D6E742F7372632F6C69627572696E672F746573742F696F5F7572696E675F706173737468=
726F7567682E74002F6465762F6E67306E31
  [  136.633652] audit: type=3D1400 audit(1662043624.705:96): avc:  denied =
 { cmd } for  pid=3D263 comm=3D"io_uring_passth" path=3D"/dev/ng0n1" dev=3D=
"devtmpfs" ino=3D120 scontext=3Dsystem_u:system_r:kernel_t tcontext=3Dsyste=
m_u:object_r:device_t tclass=3Dio_uring permissive=3D1
  [  136.635384] audit: type=3D1336 audit(1662043624.705:96): uring_op=3D46=
 items=3D0 ppid=3D252 pid=3D263 uid=3D1001 gid=3D1002 euid=3D1001 suid=3D10=
01 fsuid=3D1001 egid=3D1002 sgid=3D1002 fsgid=3D1002 subj=3Dsystem_u:system=
_r:kernel_t key=3D(null)
  [  136.636863] audit: type=3D1336 audit(1662043624.705:96): uring_op=3D46=
 items=3D0 ppid=3D252 pid=3D263 uid=3D1001 gid=3D1002 euid=3D1001 suid=3D10=
01 fsuid=3D1001 egid=3D1002 sgid=3D1002 fsgid=3D1002 subj=3Dsystem_u:system=
_r:kernel_t key=3D(null)

* From the output on time 136.633652 I see that the access should have
  been denied had selinux been enforcing.=20
* I also saw that the breakpoint hit.

*** Without the patch:
* I ran the io_uring_passthrough.c test on a char device with an
  unpriviledged user.
* I took care of changing the permissions of /dev/ng0n1 to 666 prior
  to any testing.
* made sure that Selinux was in permissive mode.
* Made sure to have audit activated by passing "audit=3D1" to the kernel
* After noticing that some audit messages where getting lost I upped the
  backlog limit to 256
* There were no audit messages when I executed the test.

As with my smack tests I would really appreciate feecback on the
approach I took to testing and it's validity.

Thx in advance

Best


On Mon, Aug 22, 2022 at 05:21:13PM -0400, Paul Moore wrote:
> Add a SELinux access control for the iouring IORING_OP_URING_CMD
> command.  This includes the addition of a new permission in the
> existing "io_uring" object class: "cmd".  The subject of the new
> permission check is the domain of the process requesting access, the
> object is the open file which points to the device/file that is the
> target of the IORING_OP_URING_CMD operation.  A sample policy rule
> is shown below:
>=20
>   allow <domain> <file>:io_uring { cmd };
>=20
> Cc: stable@vger.kernel.org
> Fixes: ee692a21e9bf ("fs,io_uring: add infrastructure for uring-cmd")
> Signed-off-by: Paul Moore <paul@paul-moore.com>
> ---
>  security/selinux/hooks.c            |   24 ++++++++++++++++++++++++
>  security/selinux/include/classmap.h |    2 +-
>  2 files changed, 25 insertions(+), 1 deletion(-)
>=20
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 79573504783b..03bca97c8b29 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -91,6 +91,7 @@
>  #include <uapi/linux/mount.h>
>  #include <linux/fsnotify.h>
>  #include <linux/fanotify.h>
> +#include <linux/io_uring.h>
> =20
>  #include "avc.h"
>  #include "objsec.h"
> @@ -6987,6 +6988,28 @@ static int selinux_uring_sqpoll(void)
>  	return avc_has_perm(&selinux_state, sid, sid,
>  			    SECCLASS_IO_URING, IO_URING__SQPOLL, NULL);
>  }
> +
> +/**
> + * selinux_uring_cmd - check if IORING_OP_URING_CMD is allowed
> + * @ioucmd: the io_uring command structure
> + *
> + * Check to see if the current domain is allowed to execute an
> + * IORING_OP_URING_CMD against the device/file specified in @ioucmd.
> + *
> + */
> +static int selinux_uring_cmd(struct io_uring_cmd *ioucmd)
> +{
> +	struct file *file =3D ioucmd->file;
> +	struct inode *inode =3D file_inode(file);
> +	struct inode_security_struct *isec =3D selinux_inode(inode);
> +	struct common_audit_data ad;
> +
> +	ad.type =3D LSM_AUDIT_DATA_FILE;
> +	ad.u.file =3D file;
> +
> +	return avc_has_perm(&selinux_state, current_sid(), isec->sid,
> +			    SECCLASS_IO_URING, IO_URING__CMD, &ad);
> +}
>  #endif /* CONFIG_IO_URING */
> =20
>  /*
> @@ -7231,6 +7254,7 @@ static struct security_hook_list selinux_hooks[] __=
lsm_ro_after_init =3D {
>  #ifdef CONFIG_IO_URING
>  	LSM_HOOK_INIT(uring_override_creds, selinux_uring_override_creds),
>  	LSM_HOOK_INIT(uring_sqpoll, selinux_uring_sqpoll),
> +	LSM_HOOK_INIT(uring_cmd, selinux_uring_cmd),
>  #endif
> =20
>  	/*
> diff --git a/security/selinux/include/classmap.h b/security/selinux/inclu=
de/classmap.h
> index ff757ae5f253..1c2f41ff4e55 100644
> --- a/security/selinux/include/classmap.h
> +++ b/security/selinux/include/classmap.h
> @@ -253,7 +253,7 @@ const struct security_class_mapping secclass_map[] =
=3D {
>  	{ "anon_inode",
>  	  { COMMON_FILE_PERMS, NULL } },
>  	{ "io_uring",
> -	  { "override_creds", "sqpoll", NULL } },
> +	  { "override_creds", "sqpoll", "cmd", NULL } },
>  	{ NULL }
>    };
> =20
>=20

--kd4tc2umiwrccsmt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmMREukACgkQupfNUreW
QU8aXwwAiA93SWIhbzMaKzc9qEfLx/96vxoLye2AyDLk6LtqGW6VOLheDc+YRZXw
mg6HT9YRBqHge1914tCEjX1x4XBPEKHHneRI4Tl1FNCcfomdZiqYtY50CfJYE0Ea
/ekVDzSs9J7FwArTvPWskxeXbar3F7JuFOEPaj0llLA/7hzmt+wvvL/5EJSAlALm
TWTAlBqS0j6lWZTbpaL2OYhnM/v+j9qpc6F2CqN7dQ2a3COx0UkmZbk+MeIw1nLP
s81cCy0YH4Km2HDw5kTb1alHQxbivnlVKBi4g27Xz7Yblu64GFB9s64K9qqk4eBK
vQ/LqCH6u1qd0ObWS4y1OyM21qIIw1Akq1W3FtgSp6UkCG4Ey7xb+hhZiWL2GgNn
09bwbGeyVFMJA+otjf7wkAnX8xS7ACZlLf7kU6NqoC0Rrn+Q59I96PmS18dHP/r3
IWyXrpA7j4F9p1FonqAmSwCJsvf9NpveeLlwgRYd01TB+suTI4ifQouVDlRtWict
BE2eP9oJ
=v3ia
-----END PGP SIGNATURE-----

--kd4tc2umiwrccsmt--
