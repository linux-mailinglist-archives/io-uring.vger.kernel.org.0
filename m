Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C67104D6C09
	for <lists+io-uring@lfdr.de>; Sat, 12 Mar 2022 03:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiCLC3F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Mar 2022 21:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiCLC3F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Mar 2022 21:29:05 -0500
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30CBEB;
        Fri, 11 Mar 2022 18:27:57 -0800 (PST)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220312022755usoutp0135d834b50fa23546bb3c6726ae8846d9~bgSLS-z2U2375223752usoutp01P;
        Sat, 12 Mar 2022 02:27:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220312022755usoutp0135d834b50fa23546bb3c6726ae8846d9~bgSLS-z2U2375223752usoutp01P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1647052075;
        bh=ycZ6PjlNwfErV9jdtCW1snPh1XZ/wDgoyFe/fyOfjl0=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=lSvj9Ygwda7i5NkcKO3mHbNyS7Wfm6P3PDvYGVM6kSmPP5pAyXzqrldZvpfikQNNo
         9ZRPxqOCh8crOT3mxb/ZjZ9DmSfmytf3FuGaN6qcimvITiToRIvqKTD+l3vAyBEItI
         dAwpO3GxUkA/9Cx0sTlrlCJ3a6Bm7wO+mYhpbmMQ=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220312022754uscas1p2377229dd66473f11ee9d1aa7db030c37~bgSKsP1Ez2378723787uscas1p2x;
        Sat, 12 Mar 2022 02:27:54 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id 5A.F3.09687.A250C226; Fri,
        11 Mar 2022 21:27:54 -0500 (EST)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
        [203.254.195.91]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220312022753uscas1p24fffcf71c95207ef1c4c98d79125ead6~bgSJkp3kM2378723787uscas1p2w;
        Sat, 12 Mar 2022 02:27:53 +0000 (GMT)
X-AuditID: cbfec370-9c5ff700000025d7-92-622c052a737d
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id 2E.96.10042.9250C226; Fri,
        11 Mar 2022 21:27:53 -0500 (EST)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2242.4; Fri, 11 Mar 2022 18:27:43 -0800
Received: from SSI-EX3.ssi.samsung.com ([fe80::8d80:5816:c578:8c36]) by
        SSI-EX3.ssi.samsung.com ([fe80::8d80:5816:c578:8c36%3]) with mapi id
        15.01.2242.008; Fri, 11 Mar 2022 18:27:43 -0800
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
Thread-Index: AQHYMwMGkOxasisH10Kgb51ozZAKiKy40f0AgAAatgCAAgGiAIAAcwUAgAAwNQA=
Date:   Sat, 12 Mar 2022 02:27:43 +0000
Message-ID: <20220312022732.GA10120@bgt-140510-bm01>
In-Reply-To: <20220311233501.GA6435@bgt-140510-bm01>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <F99B8F44354B9E48B04A61A1E8A2F907@ssi.samsung.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsWy7djXc7parDpJBi/XKFvMWbWN0WL13X42
        i5WrjzJZvGs9x2LRefoCk8X5t4eZLCYdusZosfeWtsX8ZU/ZLZa0HmezuDHhKaPFmptPWSw+
        n5nH6sDr8ezqM0aPnbPusns0L7jD4nH5bKnHplWdbB6bl9R77L7ZwOaxbfFLVo/Pm+QCOKO4
        bFJSczLLUov07RK4Mi78ucBcsFioYt7+w4wNjH38XYycHBICJhJbFr9m7mLk4hASWMkosWDb
        DTaQhJBAK5PEtNleXYwcYEU/Z5hB1KxllOj/vpgFwvnIKHFsdg8ThHOAUWLitd0sIN1sAgYS
        v49vZAaxRQQ0JPZN6AUrYhZ4wipx6P0EsBXCAmYSp743s0MUmUv8XjSBFcL2k2i5/IgJxGYR
        UJX4tv8S2CBeoDNmrv8MtoATyG5f0w/WyyggJvH91BqwemYBcYlbT+YzQfwmKLFo9h5mCFtM
        4t+uh2wQtqLE/e8v2SHq9SRuTJ3CBmHbSTw/NIcZwtaWWLbwNdReQYmTM5+wQPRKShxccQPs
        fQmB+ZwSDfe6GCESLhJvJq6GsqUl/t5dxgRRtIpRYsq3NnYIZzOjxIxfF6DOs5b413mNfQKj
        yiwkl89CctUsJFfNQnLVLCRXLWBkXcUoXlpcnJueWmycl1quV5yYW1yal66XnJ+7iRGYAk//
        O1ywg/HWrY96hxiZOBgPMUpwMCuJ8DaFaiQJ8aYkVlalFuXHF5XmpBYfYpTmYFES512WuSFR
        SCA9sSQ1OzW1ILUIJsvEwSnVwBTrYyLmzaUXIr7pVPOz8J23rgXb1Bt4GX8zqyuqefg+PTtK
        KsqleuLHgNNbHLT3T42S4pY6vGJyyKI8xVeGWXcWnQ6dYhlUYvRNTe3HfxFZ8crTh/au6jWf
        UblR9P/c5x5vKjhzv+w+YW57XkLmKFus6aSi7X83Fyx33DKd6eO6CbufHhWb1eUpPW+zzZxc
        3TbWmczGagcjuu+8fhGt9v0WQ1viFVMtK4n5tScOHGApPZqwPL1gZ69LmfO35e5znQ4mbdnn
        f+XulAM3np4T0G9fEiyjNpeZk9MlcHtA4F8TS3vLbz5l7yeonfm8OeHHs0Ybu6rVj7dO0Etb
        +6X+yGzVvucpKQncVbe0PBfP+6DEUpyRaKjFXFScCACPQEg88AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsWS2cA0UVeTVSfJ4F+LjsWcVdsYLVbf7Wez
        WLn6KJPFu9ZzLBadpy8wWZx/e5jJYtKha4wWe29pW8xf9pTdYknrcTaLGxOeMlqsufmUxeLz
        mXmsDrwez64+Y/TYOesuu0fzgjssHpfPlnpsWtXJ5rF5Sb3H7psNbB7bFr9k9fi8SS6AM4rL
        JiU1J7MstUjfLoEr48KfC8wFi4Uq5u0/zNjA2MffxcjBISFgIvFzhlkXIxeHkMBqRonN3XNZ
        IJyPjBLr5+5jhXAOMEpMfXeSvYuRk4NNwEDi9/GNzCC2iICGxL4JvUwgRcwCT1glDr2fwAaS
        EBYwkzj1vZkdoshc4veiCawQtp9Ey+VHTCA2i4CqxLf9l8AG8QKdMXP9Z6jVp5gkPjQ0soAk
        OIES7Wv6wQYxCohJfD+1BqyZWUBc4taT+WC2hICAxJI955khbFGJl4//sULYihL3v79kh6jX
        k7gxdQobhG0n8fzQHGYIW1ti2cLXUEcISpyc+YQFoldS4uCKGywTGCVmIVk3C8moWUhGzUIy
        ahaSUQsYWVcxipcWF+emVxQb5aWW6xUn5haX5qXrJefnbmIEJo/T/w5H72C8feuj3iFGJg7G
        Q4wSHMxKIrxNoRpJQrwpiZVVqUX58UWlOanFhxilOViUxHlfRk2MFxJITyxJzU5NLUgtgsky
        cXBKNTBNM5Hwq/j8cgaPzSLzar3KPaHRdt8u/DTKrg+Lk368S9zndnXIhK8rFG7e+rac4ewD
        DREty5OfrLneTegxv6u8/CHzo1lN97W6Emed5ZA/dsy9NuEkSxqXetXsTX/T7quGT+xPci+R
        50wUUXGZcepSjQVvVkLAef3pFR8TDDl2/tFO91APk2PVePPu7y1xJ73P/x6kVtk8+XQk8uCB
        qn4llsKH/lcfHzldU7xpwl6+Z406N/dUb955s2qrN++CN5+fq6y4GFT5RChZZsXmV05rPsuK
        c34Wb/q21OOM+PNF++p3HD4a0LNJKOmd/SImQUmRb7ucV8V0WDoV/Uz+7qCZ+k5988uj03ht
        +ouWbD6mxFKckWioxVxUnAgAb6OZ3Y0DAAA=
X-CMS-MailID: 20220312022753uscas1p24fffcf71c95207ef1c4c98d79125ead6
CMS-TYPE: 301P
X-CMS-RootMailID: 20220308152651epcas5p1ebd2dc7fa01db43dd587c228a3695696
References: <CGME20220308152651epcas5p1ebd2dc7fa01db43dd587c228a3695696@epcas5p1.samsung.com>
        <20220308152105.309618-1-joshi.k@samsung.com>
        <20220310082926.GA26614@lst.de>
        <CA+1E3rJ17F0Rz5UKUnW-LPkWDfPHXG5aeq-ocgNxHfGrxYtAuw@mail.gmail.com>
        <Yit8LFAMK3t0nY/q@bombadil.infradead.org>
        <20220311233501.GA6435@bgt-140510-bm01>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 11, 2022 at 03:35:04PM -0800, Adam Manzanares wrote:
> On Fri, Mar 11, 2022 at 08:43:24AM -0800, Luis Chamberlain wrote:
> > On Thu, Mar 10, 2022 at 03:35:02PM +0530, Kanchan Joshi wrote:
> > > On Thu, Mar 10, 2022 at 1:59 PM Christoph Hellwig <hch@lst.de> wrote:
> > > >
> > > > What branch is this against?
> > > Sorry I missed that in the cover.
> > > Two options -
> > > (a) https://urldefense.com/v3/__https://protect2.fireeye.com/v1/url?k=
=3D03500d22-5ccb341f-0351866d-0cc47a31309a-6f95e6932e414a1d&q=3D1&e=3D4ca7b=
05e-2fe6-40d9-bbcf-a4ed687eca9f&u=3Dhttps*3A*2F*2Fgit.kernel.dk*2Fcgit*2Fli=
nux-block*2Flog*2F*3Fh*3Dio_uring-big-sqe__;JSUlJSUlJSUl!!EwVzqGoTKBqv-0DWA=
JBm!FujuZ927K3fuIklgYjkWtodmdQnQyBqOw4Ge4M08DU_0oD5tPm0-wS2SZg0MDh8_2-U9$=20
> > > first patch ("128 byte sqe support") is already there.
> > > (b) for-next (linux-block), series will fit on top of commit 9e9d83fa=
a
> > > ("io_uring: Remove unneeded test in io_run_task_work_sig")
> > >=20
> > > > Do you have a git tree available?
> > > Not at the moment.
> > >=20
> > > @Jens: Please see if it is possible to move patches to your
> > > io_uring-big-sqe branch (and maybe rename that to big-sqe-pt.v1).
> >=20
> > Since Jens might be busy, I've put up a tree with all this stuff:
> >=20
> > https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel=
/git/mcgrof/linux-next.git/log/?h=3D20220311-io-uring-cmd__;!!EwVzqGoTKBqv-=
0DWAJBm!FujuZ927K3fuIklgYjkWtodmdQnQyBqOw4Ge4M08DU_0oD5tPm0-wS2SZg0MDiTF0Q7=
F$=20
> >=20
> > It is based on option (b) mentioned above, I took linux-block for-next
> > and reset the tree to commit "io_uring: Remove unneeded test in
> > io_run_task_work_sig" before applying the series.
>=20
> FYI I can be involved in testing this and have added some colleagues that=
 can=20
> help in this regard. We have been using some form of this work for severa=
l=20
> months now and haven't had any issues. That being said some simple tests =
I have
> are not currently working with the above git tree :). I will work to get =
this=20
> resolved and post an update here.=20

Sorry for the noise, I jumped up the stack too quickly with my tests. The=20
"simple test" actually depends on several pieces of SW not related to the=20
kernel.

>=20
> >=20
> >   Luis=
