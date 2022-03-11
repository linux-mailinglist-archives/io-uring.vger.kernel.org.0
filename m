Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2A74D6B07
	for <lists+io-uring@lfdr.de>; Sat, 12 Mar 2022 00:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiCKXpC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Mar 2022 18:45:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiCKXpB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Mar 2022 18:45:01 -0500
X-Greylist: delayed 525 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 11 Mar 2022 15:43:56 PST
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C584E034
        for <io-uring@vger.kernel.org>; Fri, 11 Mar 2022 15:43:56 -0800 (PST)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220311233509usoutp01a8e84a76172d310f12762728ede84164~bd7Vx9VAV2581625816usoutp01D;
        Fri, 11 Mar 2022 23:35:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220311233509usoutp01a8e84a76172d310f12762728ede84164~bd7Vx9VAV2581625816usoutp01D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1647041709;
        bh=p1cJHc2jRcoRjfZs31QEpSlK6mPhfM74YG5Z7tTaP1Q=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=CYgpujSb1n2I39fN4vsCwYcxSOM6u9VCUjg70ev8JfKmy9yGaFpQOthbQYpf9MiCs
         gXADwfQtXD62mippJ9srkG91GCUTCY6TgXxDvyl8EWW05hKMqK6seuKZRgPl00wqKX
         V3RcSbUvMugIAN/jkI3I1aHDl1eJF+YabA/eFUE0=
Received: from ussmges1new.samsung.com (u109.gpu85.samsung.co.kr
        [203.254.195.109]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220311233509uscas1p1a0ad15c6386c4626d500e2907a3e1cac~bd7Vj9ccB0406904069uscas1p1N;
        Fri, 11 Mar 2022 23:35:09 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges1new.samsung.com (USCPEMTA) with SMTP id 3E.84.09744.DACDB226; Fri,
        11 Mar 2022 18:35:09 -0500 (EST)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
        [203.254.195.92]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220311233509uscas1p18451ff7aa07eb7dfb078af21087e6f39~bd7VMM6Gu0406904069uscas1p1M;
        Fri, 11 Mar 2022 23:35:09 +0000 (GMT)
X-AuditID: cbfec36d-879ff70000002610-e5-622bdcadb67f
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id D4.E4.09657.CACDB226; Fri,
        11 Mar 2022 18:35:09 -0500 (EST)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2242.4; Fri, 11 Mar 2022 15:35:08 -0800
Received: from SSI-EX3.ssi.samsung.com ([fe80::8d80:5816:c578:8c36]) by
        SSI-EX3.ssi.samsung.com ([fe80::8d80:5816:c578:8c36%3]) with mapi id
        15.01.2242.008; Fri, 11 Mar 2022 15:35:08 -0800
From:   Adam Manzanares <a.manzanares@samsung.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
CC:     Kanchan Joshi <joshiiitr@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Keith Busch" <kbusch@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "sbates@raithlin.com" <sbates@raithlin.com>,
        "logang@deltatee.com" <logang@deltatee.com>,
        Pankaj Raghav <pankydev8@gmail.com>,
        =?iso-8859-1?Q?Javier_Gonz=E1lez?= <javier@javigon.com>,
        Anuj Gupta <anuj20.g@samsung.com>,
        "j.granados@samsung.com" <j.granados@samsung.com>,
        "j.devantier@samsung.com" <j.devantier@samsung.com>
Subject: Re: [PATCH 00/17] io_uring passthru over nvme
Thread-Topic: [PATCH 00/17] io_uring passthru over nvme
Thread-Index: AQHYMwMGkOxasisH10Kgb51ozZAKiKy40f0AgAAatgCAAgGiAIAAcwUA
Date:   Fri, 11 Mar 2022 23:35:07 +0000
Message-ID: <20220311233501.GA6435@bgt-140510-bm01>
In-Reply-To: <Yit8LFAMK3t0nY/q@bombadil.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <5400D1787D21494DBEE14042D58251F7@ssi.samsung.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDKsWRmVeSWpSXmKPExsWy7djXc7pr72gnGRw6rmwxZ9U2RovVd/vZ
        LFauPspk8a71HItF5+kLTBbn3x5msph06Bqjxd5b2hbzlz1lt1jSepzN4saEp4wWa24+ZbH4
        fGYeqwOvx7Orzxg9ds66y+7RvOAOi8fls6Uem1Z1snlsXlLvsftmA5vHtsUvWT0+b5IL4Izi
        sklJzcksSy3St0vgyvi+/wJ7wVv+iu0nTrA1MK7i7WLk5JAQMJH42HeGDcQWEljJKPG0z6yL
        kQvIbmWSWPtwFjNM0Yx309ghEmsZJX58/c4C0fGRUeJUUzRE4gCjxNYHU1lBEmwCBhK/j28E
        6xYR0JDYN6GXCaSIWeAJq8Sh9xPA9gkLmEmc+t7MDlFkLvF70QRWCNtN4sPJ+WBxFgFVia7X
        PWD1vALGEhdX7QeKc3BwAvUeXWwNEmYUEJP4fmoNE4jNLCAucevJfCaIqwUlFs3eA/WBmMS/
        XQ/ZIGxFifvfX7JD1OtJ3Jg6hQ3CtpPo+7WcEcLWlli28DUzxFpBiZMzn7BA9EpKHFxxgwXk
        FwmBxZwSS0/1QA11kTjY/J4VwpaWmL7mMlTRKkaJKd/a2CGczYwSM35dgDrPWuJf5zX2CYwq
        s5BcPgvJVbOQXDULyVWzkFy1gJF1FaN4aXFxbnpqsWFearlecWJucWleul5yfu4mRmACPP3v
        cO4Oxh23PuodYmTiYDzEKMHBrCTC2xSqkSTEm5JYWZValB9fVJqTWnyIUZqDRUmcd1nmhkQh
        gfTEktTs1NSC1CKYLBMHp1QDk4Zx2kkp/g9VbxZcTnzSm7XExbdRmy+r6Pnl5o0MDUapT173
        F/myfve9LctTfcw3zPmEWJjSGbuajrizfXzfG5Z+/D4v42vBLMYaJSMX3rnzmXdHZXpJTtrA
        MDmOO9o3O0lkY8sFz2BLVu9Z9T6Hc49peV3Zd0i4qVdNJtlB8OId/WVTnSTaZ81h+Lzk4ufQ
        7+ydz36xtWgd27l+W/rzo4tny3Q77bR5vCpSc/mxUO6oHfsK9xc5Psu5Vty0WGBJ0ykhCa5l
        R28dCvijxOF9M5HlkTrP74dGV3YJxG1W+dCjuLS7o3hh5xM24bnCGROKffpNn5/4v/qMq42w
        V/lqv/PydZqPXLp+3a1p2q+jxFKckWioxVxUnAgAlNazDu8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsWS2cA0UXftHe0kgxOLOC3mrNrGaLH6bj+b
        xcrVR5ks3rWeY7HoPH2ByeL828NMFpMOXWO02HtL22L+sqfsFktaj7NZ3JjwlNFizc2nLBaf
        z8xjdeD1eHb1GaPHzll32T2aF9xh8bh8ttRj06pONo/NS+o9dt9sYPPYtvglq8fnTXIBnFFc
        NimpOZllqUX6dglcGd/3X2AveMtfsf3ECbYGxlW8XYycHBICJhIz3k1j72Lk4hASWM0o0dGw
        nh0kISTwkVFi5XUBiMQBRolDixezgiTYBAwkfh/fyAxiiwhoSOyb0MsEUsQs8IRV4tD7CWwg
        CWEBM4lT35vZIYrMJX4vmsAKYbtJfDg5HyzOIqAq0fW6B6yeV8BY4uKq/VBnLGCS+HFoIdAG
        Dg5OoEFHF1uD1DAKiEl8P7WGCcRmFhCXuPVkPhPECwISS/acZ4awRSVePv7HCmErStz//pId
        ol5P4sbUKWwQtp1E36/ljBC2tsSyha+ZIW4QlDg58wkLRK+kxMEVN1gmMErMQrJuFpJRs5CM
        moVk1CwkoxYwsq5iFC8tLs5Nryg2zkst1ytOzC0uzUvXS87P3cQITB2n/x2O2cF479ZHvUOM
        TByMhxglOJiVRHibQjWShHhTEiurUovy44tKc1KLDzFKc7AoifN6xE6MFxJITyxJzU5NLUgt
        gskycXBKNTB1WM9d8NyBS/7Bfy/JsE0nSo4+29dc5pb6LOCJ5enZu9SLzq///Ya5M9Y1zsbu
        enlYx4Ef+66sbRJY3+tsEn74RawGL8PXRaeUHY6VRlzV49p0fMXFeIkrZkLdB29Pq77QvSVN
        7NFzM8sdfx++VtFzVdwxp/Wow9a0CYsfdGurXH4cYdu/sGLirVNnTHYllcVus9z2eN0n8dXZ
        S8SXP7zdKq/FKtDEuTFkomKMfOjeYwZ886+rh9vH+53ZdM12RmT/lWVP6ph/cXH+vfB61mv1
        74IrZecp+UmyX7rO8n3DlLZs0QOf7hi9SJZpeRN90F5f7fTEp9VzOWbyWB2Olr3B1bynwXCz
        2IwZgffEH5QcV2Ipzkg01GIuKk4EAA8jEVaMAwAA
X-CMS-MailID: 20220311233509uscas1p18451ff7aa07eb7dfb078af21087e6f39
CMS-TYPE: 301P
X-CMS-RootMailID: 20220308152651epcas5p1ebd2dc7fa01db43dd587c228a3695696
References: <CGME20220308152651epcas5p1ebd2dc7fa01db43dd587c228a3695696@epcas5p1.samsung.com>
        <20220308152105.309618-1-joshi.k@samsung.com>
        <20220310082926.GA26614@lst.de>
        <CA+1E3rJ17F0Rz5UKUnW-LPkWDfPHXG5aeq-ocgNxHfGrxYtAuw@mail.gmail.com>
        <Yit8LFAMK3t0nY/q@bombadil.infradead.org>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 11, 2022 at 08:43:24AM -0800, Luis Chamberlain wrote:
> On Thu, Mar 10, 2022 at 03:35:02PM +0530, Kanchan Joshi wrote:
> > On Thu, Mar 10, 2022 at 1:59 PM Christoph Hellwig <hch@lst.de> wrote:
> > >
> > > What branch is this against?
> > Sorry I missed that in the cover.
> > Two options -
> > (a) https://urldefense.com/v3/__https://protect2.fireeye.com/v1/url?k=
=3D03500d22-5ccb341f-0351866d-0cc47a31309a-6f95e6932e414a1d&q=3D1&e=3D4ca7b=
05e-2fe6-40d9-bbcf-a4ed687eca9f&u=3Dhttps*3A*2F*2Fgit.kernel.dk*2Fcgit*2Fli=
nux-block*2Flog*2F*3Fh*3Dio_uring-big-sqe__;JSUlJSUlJSUl!!EwVzqGoTKBqv-0DWA=
JBm!FujuZ927K3fuIklgYjkWtodmdQnQyBqOw4Ge4M08DU_0oD5tPm0-wS2SZg0MDh8_2-U9$=20
> > first patch ("128 byte sqe support") is already there.
> > (b) for-next (linux-block), series will fit on top of commit 9e9d83faa
> > ("io_uring: Remove unneeded test in io_run_task_work_sig")
> >=20
> > > Do you have a git tree available?
> > Not at the moment.
> >=20
> > @Jens: Please see if it is possible to move patches to your
> > io_uring-big-sqe branch (and maybe rename that to big-sqe-pt.v1).
>=20
> Since Jens might be busy, I've put up a tree with all this stuff:
>=20
> https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/g=
it/mcgrof/linux-next.git/log/?h=3D20220311-io-uring-cmd__;!!EwVzqGoTKBqv-0D=
WAJBm!FujuZ927K3fuIklgYjkWtodmdQnQyBqOw4Ge4M08DU_0oD5tPm0-wS2SZg0MDiTF0Q7F$=
=20
>=20
> It is based on option (b) mentioned above, I took linux-block for-next
> and reset the tree to commit "io_uring: Remove unneeded test in
> io_run_task_work_sig" before applying the series.

FYI I can be involved in testing this and have added some colleagues that c=
an=20
help in this regard. We have been using some form of this work for several=
=20
months now and haven't had any issues. That being said some simple tests I =
have
are not currently working with the above git tree :). I will work to get th=
is=20
resolved and post an update here.=20

>=20
>   Luis=
