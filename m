Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7E9D633B3E
	for <lists+io-uring@lfdr.de>; Tue, 22 Nov 2022 12:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbiKVLXy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Nov 2022 06:23:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbiKVLXU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Nov 2022 06:23:20 -0500
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632CF6069E;
        Tue, 22 Nov 2022 03:18:53 -0800 (PST)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20221122111850euoutp02d9df76f482c7b50a2a34a9dffe399aeb~p5BhlWjm71729517295euoutp02z;
        Tue, 22 Nov 2022 11:18:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20221122111850euoutp02d9df76f482c7b50a2a34a9dffe399aeb~p5BhlWjm71729517295euoutp02z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1669115930;
        bh=MZNcIpnBKYNld7/iOe1THPAvOxrOboKeLL5njDx62+g=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=Nicl8yYB8VFCcNiIlnP4GyCnMIVZNBhcR35KrIPuWiayVpTVCaOvUK23sQ5syAYQP
         BWlsjqN9NzloUoJ/lTzsSn24jo7Je/3HcaGRf+or6jbxe7lTq+BbzAOOj/dtP3/9bM
         qQz0B31zAv58dt2ycGH5g2eslx5vzjUsSPLlZUQo=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20221122111849eucas1p291860dd8201dee8f21f71aa37bc8e2d6~p5BhBKOU60595305953eucas1p2M;
        Tue, 22 Nov 2022 11:18:49 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id AE.FA.09549.910BC736; Tue, 22
        Nov 2022 11:18:49 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20221122111849eucas1p2c889448193960c6a5187addbceb7139d~p5BgoePLc0157801578eucas1p28;
        Tue, 22 Nov 2022 11:18:49 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221122111849eusmtrp29dd0e37e03e367b57ec96d5968d96205~p5BgnwLtz0323803238eusmtrp2r;
        Tue, 22 Nov 2022 11:18:49 +0000 (GMT)
X-AuditID: cbfec7f5-f5dff7000000254d-b9-637cb01944be
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id E6.85.09026.910BC736; Tue, 22
        Nov 2022 11:18:49 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221122111849eusmtip29aa850593d08f91f3316699073ad7aee~p5BgeFh3Y2329423294eusmtip2D;
        Tue, 22 Nov 2022 11:18:49 +0000 (GMT)
Received: from localhost (106.110.32.133) by CAMSVWEXC02.scsc.local
        (2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Tue, 22 Nov 2022 11:18:48 +0000
Date:   Tue, 22 Nov 2022 12:18:49 +0100
From:   Joel Granados <j.granados@samsung.com>
To:     Paul Moore <paul@paul-moore.com>
CC:     Luis Chamberlain <mcgrof@kernel.org>,
        Kanchan Joshi <joshi.k@samsung.com>, <ddiss@suse.de>,
        <linux-security-module@vger.kernel.org>, <io-uring@vger.kernel.org>
Subject: Re: [RFC 1/1] Use ioctl selinux callback io_uring commands that
 implement the ioctl op convention
Message-ID: <20221122111849.eaiiuqbvuxhslgnj@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="5742flrpsafwjcom"
Content-Disposition: inline
In-Reply-To: <CAHC9VhR+RFqJ7c6mFhnMFdDXPcCBg-pnAzEuyOc-TX5hmsubwg@mail.gmail.com>
X-Originating-IP: [106.110.32.133]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
        CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsWy7djPc7qSG2qSDY61qlt8/T+dxeJd6zkW
        iw89j9gsbkx4ymhxe9J0FgdWj02rOtk81u59weix+XS1x+dNcgEsUVw2Kak5mWWpRfp2CVwZ
        d+8tYSloVqvY1NrM2sD4UK6LkZNDQsBE4sDCdYxdjFwcQgIrGCVOzNrIDpIQEvjCKLGoKQgi
        8ZlR4vj6RiaYjg/rf7FCJJYDFR1YzQxXtXBCP5SzhVFi3sQ+sBYWAVWJlsmPGEFsNgEdifNv
        7jCD2CICKhKLn64HW84MMupE6zGwhLBAjsTVbW/YQGxeAXOJv2+eMUPYghInZz5hAbGZBSok
        Ln09ArSAA8iWllj+jwMkzCkQKLHt7BF2iFOVJL6+6WWFsGslTm25xQSyS0KgmVNi19l/LBAJ
        F4lpN+dB2cISr45vgWqWkfi/cz7Uz9kSO6fsYoawCyRmnZzKBrJXQsBaou9MDkTYUaJ9/mZG
        iDCfxI23ghBX8klM2jadGSLMK9HRJgRRrSaxo2kr4wRG5VlI/pqF5K9ZCH9BhHUkFuz+xIYh
        rC2xbOFrZgjbVmLduvcsCxjZVzGKp5YW56anFhvnpZbrFSfmFpfmpesl5+duYgQmqtP/jn/d
        wbji1Ue9Q4xMHIyHGFWAmh9tWH2BUYolLz8vVUmEt96zJlmINyWxsiq1KD++qDQntfgQozQH
        i5I4L9sMrWQhgfTEktTs1NSC1CKYLBMHp1QDU3xP+cZyoax3+2z/XTHoVjXf0usfb3/aMbvk
        5eW/nM8jPgeUty2z7kgNeDztjWLJajPm2vPnruW92pXdYl3eHLtrV4nvBbdL/6ZqpoezZXgk
        LZ5lpl8RnFev/CD5Iu/yh7FntMplAyUO9lQ4HfXvOct4913XN5evK5s/BZWe37Uj2ufez2cR
        asu2uycFNTWd3zFplYTtq3Vzb0lEmpp/EGre5/tbUuS+4KMgrbcTPm2UcnGzSmV5orizZuLM
        etn2Iz8ZG1IcuWMKfa+WvYgqKvHnjpj0JkvW0u9FSE2Q1SW2q8VPo2X08x/MT41y/GLcsNJS
        zHdvc0GTY9bH9uJ6t1UOOVnm55fZZjC0X1ViKc5INNRiLipOBAD8nN7UzwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t/xe7qSG2qSDS7NE7D4+n86i8W71nMs
        Fh96HrFZ3JjwlNHi9qTpLA6sHptWdbJ5rN37gtFj8+lqj8+b5AJYovRsivJLS1IVMvKLS2yV
        og0tjPQMLS30jEws9QyNzWOtjEyV9O1sUlJzMstSi/TtEvQy2vauZC1oVKs4c/I7ewPjfbku
        Rk4OCQETiQ/rf7F2MXJxCAksZZToftnPCJGQkfh05SM7hC0s8edaFxtE0UdGiQeTVjFDOFsY
        JWb9aGABqWIRUJVomfwIrJtNQEfi/Js7zCC2iICKxOKn6xlBGpgFljNKzNvXBjZWWCBH4uq2
        N2wgNq+AucTfN8+gpk5nkTjRsJcFIiEocXLmEzCbWaBMou3qTqYuRg4gW1pi+T8OkDCnQKDE
        trNHoE5Vkvj6ppcVwq6V+Pz3GeMERuFZSCbNQjJpFsIkiLCWxI1/LzGFtSWWLXzNDGHbSqxb
        955lASP7KkaR1NLi3PTcYiO94sTc4tK8dL3k/NxNjMCo3Xbs55YdjCtffdQ7xMjEwXiIUQWo
        89GG1RcYpVjy8vNSlUR46z1rkoV4UxIrq1KL8uOLSnNSiw8xmgKDcSKzlGhyPjCd5JXEG5oZ
        mBqamFkamFqaGSuJ83oWdCQKCaQnlqRmp6YWpBbB9DFxcEo1MLkqLTqlcC5UeVfbj/patm3B
        oXUtntcP1SdV7/ITWfrUl7H397tPx0646j3RY5NepGmWH+C0hjkzodk+/XKWfth7iQ38r10n
        bCzrTSnvmST1fH588sO1bEqHWT7Xl7T8f7eZP+DMmVTvw+XC7xkPq+2+wLj2lxZ7Vd1jqcta
        DF/WJ3P7JmnVTy85qDDp5Z7VVfFCrJOvLfB/3F3+P/TKuooNTXk7Q+d6Trqi+uvD3j+XfiQ6
        C4vO976w9UtFt/r6aNbJLBal+TMX3xWRPf3SnCHxyezFRb8SWec1LIrTnrRGa2eek46jUVHP
        79IXgX8EetMm/P0dN+Oo83/nsFeBs/RPrE5/yBq4ffe1a1ePblViKc5INNRiLipOBABBvcK7
        bwMAAA==
X-CMS-MailID: 20221122111849eucas1p2c889448193960c6a5187addbceb7139d
X-Msg-Generator: CA
X-RootMTR: 20221116125431eucas1p1dfd03b80863fce674a7c662660c94092
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20221116125431eucas1p1dfd03b80863fce674a7c662660c94092
References: <20221116125051.3338926-1-j.granados@samsung.com>
        <CGME20221116125431eucas1p1dfd03b80863fce674a7c662660c94092@eucas1p1.samsung.com>
        <20221116125051.3338926-2-j.granados@samsung.com>
        <20221116173821.GC5094@test-zns>
        <CAHC9VhSVzujW9LOj5Km80AjU0EfAuukoLrxO6BEfnXeK_s6bAg@mail.gmail.com>
        <20221117094004.b5l64ipicitphkun@localhost>
        <CAHC9VhSa3Yrjf9z5L0oS8Cx=20gUrgfA8evizoVjBNs4AB_cXg@mail.gmail.com>
        <Y3vXLQz1k8E/qu5A@bombadil.infradead.org>
        <CAHC9VhR+RFqJ7c6mFhnMFdDXPcCBg-pnAzEuyOc-TX5hmsubwg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--5742flrpsafwjcom
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 21, 2022 at 04:05:37PM -0500, Paul Moore wrote:
> On Mon, Nov 21, 2022 at 2:53 PM Luis Chamberlain <mcgrof@kernel.org> wrot=
e:
> > On Thu, Nov 17, 2022 at 05:10:07PM -0500, Paul Moore wrote:
> > > On Thu, Nov 17, 2022 at 4:40 AM Joel Granados <j.granados@samsung.com=
> wrote:
> > > > On Wed, Nov 16, 2022 at 02:21:14PM -0500, Paul Moore wrote:
> > >
> > > ...
> > >
> > > > > * As we discussed previously, the real problem is the fact that w=
e are
> > > > > missing the necessary context in the LSM hook to separate the
> > > > > different types of command targets.  With traditional ioctls we c=
an
> > > > > look at the ioctl number and determine both the type of
> > > > > device/subsystem/etc. as well as the operation being requested; t=
here
> > > > > is no such information available with the io_uring command
> > > > > passthrough.  In this sense, the io_uring command passthrough is
> > > > > actually worse than traditional ioctls from an access control
> > > > > perspective.  Until we have an easy(ish)[1] way to determine the
> > > > > io_uring command target type, changes like the one suggested here=
 are
> > > > > going to be doomed as each target type is free to define their own
> > > > > io_uring commands.
> > > >
> > > > The only thing that comes immediately to mind is that we can have
> > > > io_uring users define a function that is then passed to the LSM
> > > > infrastructure. This function will have all the logic to give relat=
ive
> > > > context to LSM. It would be general enough to fit all the possible =
commands
> > > > and the logic would be implemented in the "drivers" side so there i=
s no
> > > > need for LSM folks to know all io_uring users.
> > >
> > > Passing a function pointer to the LSM to fetch, what will likely be
> > > just a constant value, seems kinda ugly, but I guess we only have ugly
> > > options at this point.
> >
> > I am not sure if this helps yet, but queued on modules-next we now have
> > an improvement in speed of about 1500x for kallsyms_lookup_name(), and
> > so symbol lookups are now fast. Makes me wonder if a type of special
> > export could be drawn up for specific calls which follow a structure
> > and so the respective lsm could be inferred by a prefix instead of
> > placing the calls in-place. Then it would not mattter where a call is
> > used, so long as it would follow a specific pattern / structure with
> > all the crap you need on it.
>=20
> I suspect we may be talking about different things here, I don't think
> the issue is which LSM(s) may be enabled, as the call is to
> security_uring_cmd() regardless.  I believe the issue is more of how
> do the LSMs determine the target of the io_uring command, e.g. nvme or
> ublk.
I agree, but we might be able to use kallsysms_lookup_name to execute a
callback once we know where the call comes from.

>=20
> My understanding is that Joel was suggesting a change to the LSM hook
> to add a function specific pointer (presumably defined as part of the
> file_operations struct) that could be called by the LSM to determine
> the target.
Indeed. I just sent out the RFC. Its at an idea stage and would be great
to hear what you think

>=20
> Although now that I'm looking again at the file_operations struct, I
> wonder if we would be better off having the LSMs inspect the
> file_operations::owner field, potentially checking the module::name
> field.  It's a little painful in the sense that it is potentially
> multiple strcmp() calls for each security_uring_cmd() call, but I'm
> not sure the passed function approach would be much better.  Do we
> have a consistent per-module scalar value we can use instead of a
> character string?
This is also a possibility. And with that we might just be able to call
some sort of callback with kallsysms_lookup_name or whatever makes
sense.
>=20
> --
> paul-moore.com

--5742flrpsafwjcom
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmN8sBkACgkQupfNUreW
QU93TAv8CXDwCJhvn5rPi1uyB2Nx+am1e+1wzdk1NZXdJ53NSeYIIs5+fUJ5M9qw
yDW3oiRsFmrQr/R6CcRoDideeRuM5MYXO/SWuMR+CkIQ2qR0pN+ECuCLjiPzLIBJ
ZjK3wjXu0iCaufL8FwgiyXccdnbfpHEFRFFcELztziSI4fS/mKeskIkLlrLy3F9e
FDk0CnXRYX/P7pF5YcHU2/l/UI3kkiIeti8xoXResLFA37ZImJshTGoTfCvypxvJ
aFy0T3dZdMOtbsgOpwjT1sCZTejBtr8htkjXJRAnZl/q8l9EPuqLHPkQxUyRa9V8
2+yoxRpjx1kMbcgnhJ/bWdRsrCtqdK3DuQsN89qrx38El8TgkCj4y0HocyQfPIJI
lL9lmS/NFjIuXPMcxqk295DXt8BfLum5ZBCXf77NmxVPdzbMjBE1yzYyTDfeSIXg
I0IX/2hzy2ReE6lXYweGdPbpi6KN2MlO/E5/fWawVnrR36b8vFsJsT69mGGc9pbm
Tmjo7paB
=JUgv
-----END PGP SIGNATURE-----

--5742flrpsafwjcom--
