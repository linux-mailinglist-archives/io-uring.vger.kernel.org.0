Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B51235746AC
	for <lists+io-uring@lfdr.de>; Thu, 14 Jul 2022 10:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234130AbiGNIZB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jul 2022 04:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbiGNIY7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jul 2022 04:24:59 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644443A4B8
        for <io-uring@vger.kernel.org>; Thu, 14 Jul 2022 01:24:56 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220714082452epoutp03a2757bca012863ccdeb93334d858215c~BpJPhCo9d2577625776epoutp03m
        for <io-uring@vger.kernel.org>; Thu, 14 Jul 2022 08:24:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220714082452epoutp03a2757bca012863ccdeb93334d858215c~BpJPhCo9d2577625776epoutp03m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1657787092;
        bh=ImEm3uLnMWETXbmkm+rCTqM6+ogJkg8BitxVUXzVYEc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r85Z0NLTUykAGEmc7u6tcFoNBPilQ+LgX3kkGHO9h605aH4DfW0q2E1x3YX38PYfu
         FklTeeJcFXYGgdn/fIVHCwFEZ0L/1qqIZHHg/J8FjvO6sjTXnyhTcKsEAW2lKaqS9x
         7pnebfkpUtIj86gIeLWDm9yOdiFgb/Pe/ouvFkAM=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220714082452epcas5p3059d7018af2456b9a88c47e80d467f40~BpJOwDday2978829788epcas5p3g;
        Thu, 14 Jul 2022 08:24:52 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Lk6wx2xZ3z4x9Pw; Thu, 14 Jul
        2022 08:24:49 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EC.32.09566.1D2DFC26; Thu, 14 Jul 2022 17:24:49 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220714082448epcas5p1a3497e7ce59fe8b5388afe8c3edfc6d0~BpJLdb9vS1554115541epcas5p1J;
        Thu, 14 Jul 2022 08:24:48 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220714082448epsmtrp1df67c0bc5028944645406faa6e3d15d9~BpJLcozEi0497104971epsmtrp1e;
        Thu, 14 Jul 2022 08:24:48 +0000 (GMT)
X-AuditID: b6c32a4a-b8dff7000000255e-ab-62cfd2d19600
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        BB.98.08802.0D2DFC26; Thu, 14 Jul 2022 17:24:48 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220714082446epsmtip1e51819c52649a216baff5f9dfc1b9ef1~BpJJrUxNX0771807718epsmtip1f;
        Thu, 14 Jul 2022 08:24:46 +0000 (GMT)
Date:   Thu, 14 Jul 2022 13:49:23 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        hch@lst.de, kbusch@kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        asml.silence@gmail.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
Subject: Re: [PATCH for-next 3/4] io_uring: grow a field in struct
 io_uring_cmd
Message-ID: <20220714081923.GE30733@test-zns>
MIME-Version: 1.0
In-Reply-To: <Ys+QPjYBDoByrfw1@T590>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGJsWRmVeSWpSXmKPExsWy7bCmlu7FS+eTDBpv81s0TfjLbDFn1TZG
        i9V3+9ksbh7YyWSxcvVRJot3redYLM6/PcxkMenQNUaLvbe0LeYve8pucWhyM5PFutfvWRx4
        PHbOusvucf7eRhaPy2dLPTat6mTz2Lyk3mP3zQY2j/f7rrJ59G1ZxejxeZNcAGdUtk1GamJK
        apFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0MFKCmWJOaVAoYDE
        4mIlfTubovzSklSFjPziElul1IKUnAKTAr3ixNzi0rx0vbzUEitDAwMjU6DChOyMNcf4Cnbz
        V9y9tIm5gfEWTxcjJ4eEgInE8mVnGUFsIYHdjBJHFud1MXIB2Z8YJV43LmSDcD4zSiyZfZMZ
        puPW/amMEIldjBLz/r1mh3CeMUosvvKAtYuRg4NFQFWiZbERiMkmoClxYXIpSK+IgJLE3bur
        2UFsZoGZTBJvOpVBbGGBQInVvXvA4rwCuhKb71+FsgUlTs58wgJicwqoSLRuXwB2qaiAssSB
        bceZQNZKCOzgkJj/fC8TxHEuElfm74OyhSVeHd/CDmFLSbzsb4OykyUuzTwHVVMi8XjPQSjb
        XqL1VD8zxHGZEotX3WGBsPkken8/YQL5RUKAV6KjTQiiXFHi3qSnrBC2uMTDGUugbA+Jm7f2
        QgPuE5PEuclLWScwys1C8s8sJCsgbCuJzg9NrLOAVjALSEss/8cBYWpKrN+lv4CRdRWjZGpB
        cW56arFpgVFeajk8hpPzczcxghOwltcOxocPPugdYmTiYDzEKMHBrCTC233oXJIQb0piZVVq
        UX58UWlOavEhRlNg7ExklhJNzgfmgLySeEMTSwMTMzMzE0tjM0MlcV6vq5uShATSE0tSs1NT
        C1KLYPqYODilGphC/ryosVxZNvdD1ezfq9ccPRRwlqM+b+fXfK47U+64y6q7bYy9Jath8uAB
        B+NvMV82F8HIbUbfJge84c9J1pm+ee3OS7NXbtux5cZ7mwP73M3vsywWfOWn9cbr1I4bn+cy
        S0ZPu9y0ocil+O3/mf9PqN/+naZktcO4V+2eMNOxmVskE5fm/Jr9zvmgYZXm//89Cc1rj4gZ
        GvIvP1fK9rpZd6Nu/yPF7znioo2RZ0vuLLu+xJWht1ae3dquoGLu3qZNX+xn3ZhU6q7Be5Rx
        9eObDp/1IgLFpERC1a4w9us/ntM/4frehLDb5h99Zs38O2cKw1GV7eeFF7hZTJO45RgVI3PZ
        dqF0T6lG+911jT91lViKMxINtZiLihMBqxB5VUkEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42LZdlhJTvfCpfNJBts3Slo0TfjLbDFn1TZG
        i9V3+9ksbh7YyWSxcvVRJot3redYLM6/PcxkMenQNUaLvbe0LeYve8pucWhyM5PFutfvWRx4
        PHbOusvucf7eRhaPy2dLPTat6mTz2Lyk3mP3zQY2j/f7rrJ59G1ZxejxeZNcAGcUl01Kak5m
        WWqRvl0CV8aT5p3sBa94Kh7tXcvUwLiYq4uRk0NCwETi1v2pjCC2kMAORonL19Ih4uISzdd+
        sEPYwhIr/z0HsrmAap4wSqzfsIG1i5GDg0VAVaJlsRGIySagKXFhcilIuYiAksTdu6vBWpkF
        ZjJJvOlUBrGFBQIlVvfuAYvzCuhKbL5/lR1i7RcmienLXSDighInZz5hgeg1k5i3+SEzyHhm
        AWmJ5f84QMKcAioSrdsXgF0sKqAscWDbcaYJjIKzkHTPQtI9C6F7ASPzKkbJ1ILi3PTcYsMC
        o7zUcr3ixNzi0rx0veT83E2M4IjS0trBuGfVB71DjEwcjIcYJTiYlUR4uw+dSxLiTUmsrEot
        yo8vKs1JLT7EKM3BoiTOe6HrZLyQQHpiSWp2ampBahFMlomDU6qBaVej45fXpSvq3nv08btd
        un7K8e1FdtnrvCsnLHTmT/03qSctlHGK9SSbbymJ6R/6T7/YdmXl7/+Cvrc0lt/1eB2+285I
        kyn8h4XZJcvA86yiWyLzGlMsjnJULP3E5p7+z/rWqo+fmi9deXdO/0qujeO6DA/xegZ9DSOd
        oKhmu7e5zl8+dz5SzPx0VPfafpcp+fNNLc6cVNt4iqfuVIlMYWPGm85DXW8bggSlTOIPOdUm
        XN57wZRt/d1PR8XqRSr37si8LGV348TlV14ix6xnT192+Ng6k6uL7jUIvtDcfy+gTH2hVeTD
        61l3xM0CrQ+EuC3I3GZ8RkzzwG/WMM90J5Uf8tq+O5I5GVryw/NPKLEUZyQaajEXFScCAG5T
        2vAXAwAA
X-CMS-MailID: 20220714082448epcas5p1a3497e7ce59fe8b5388afe8c3edfc6d0
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----jllqsR28.5W1KdEnZlWKzx60EIuo6gwqBUS1IW9J_3KKio4g=_12d5b0_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220711110824epcas5p22c8e945cb8c3c3ac46c8c2b5ab55db9b
References: <20220711110155.649153-1-joshi.k@samsung.com>
        <CGME20220711110824epcas5p22c8e945cb8c3c3ac46c8c2b5ab55db9b@epcas5p2.samsung.com>
        <20220711110155.649153-4-joshi.k@samsung.com>
        <2b644543-9a54-c6c4-fd94-f2a64d0701fa@kernel.dk>
        <43955a42-7185-2afc-9a55-80cc2de53bf9@grimberg.me>
        <96fcba9a-76ad-8e04-e94e-b6ec5934f84e@grimberg.me> <Ys+QPjYBDoByrfw1@T590>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------jllqsR28.5W1KdEnZlWKzx60EIuo6gwqBUS1IW9J_3KKio4g=_12d5b0_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Thu, Jul 14, 2022 at 11:40:46AM +0800, Ming Lei wrote:
>On Mon, Jul 11, 2022 at 09:22:54PM +0300, Sagi Grimberg wrote:
>>
>> > > > Use the leftover space to carve 'next' field that enables linking of
>> > > > io_uring_cmd structs. Also introduce a list head and few helpers.
>> > > >
>> > > > This is in preparation to support nvme-mulitpath, allowing multiple
>> > > > uring passthrough commands to be queued.
>> > >
>> > > It's not clear to me why we need linking at that level?
>> >
>> > I think the attempt is to allow something like blk_steal_bios that
>> > nvme leverages for io_uring_cmd(s).
>>
>> I'll rephrase because now that I read it, I think my phrasing is
>> confusing.
>>
>> I think the attempt is to allow something like blk_steal_bios that
>> nvme leverages, but for io_uring_cmd(s). Essentially allow io_uring_cmd
>> to be linked in a requeue_list.
>
>io_uring_cmd is 1:1 with pt request, so I am wondering why not retry on
>io_uring_cmd instance directly via io_uring_cmd_execute_in_task().
>
>I feels it isn't necessary to link io_uring_cmd into list.

If path is not available, retry is not done immediately rather we wait for
path to be available (as underlying controller may still be
resetting/connecting). List helped as command gets added into
it (and submitter/io_uring gets the control back), and retry is done
exact point in time.
But yes, it won't harm if we do couple of retries even if path is known
not to be available (somewhat like iopoll). As this situation is
not common. And with that scheme, we don't have to link io_uring_cmd.

Sagi: does this sound fine to you?

------jllqsR28.5W1KdEnZlWKzx60EIuo6gwqBUS1IW9J_3KKio4g=_12d5b0_
Content-Type: text/plain; charset="utf-8"


------jllqsR28.5W1KdEnZlWKzx60EIuo6gwqBUS1IW9J_3KKio4g=_12d5b0_--
