Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD45B4DA99B
	for <lists+io-uring@lfdr.de>; Wed, 16 Mar 2022 06:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353594AbiCPFSy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Mar 2022 01:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353616AbiCPFSx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Mar 2022 01:18:53 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42AF5D5E2
        for <io-uring@vger.kernel.org>; Tue, 15 Mar 2022 22:17:34 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220316051732epoutp01a859def82c31802b22013e25cab1d5a0~cxLagj7fX0197401974epoutp01J
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 05:17:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220316051732epoutp01a859def82c31802b22013e25cab1d5a0~cxLagj7fX0197401974epoutp01J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1647407852;
        bh=sUMhv7V5Mr8UF8aDj5esC34wRqZ5z8WHnhn52HyKeIk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W4hC9/JmPUbCG7Zf6zL6iV+7R4/eOg7Dp8+s9SA7prgkl0EggWms7PLGNDlWrN9yD
         FzAX95MR3t2sc3V4BKt91IjcHDTpDukI3BfiU0gxH+dYH/07VIvKzl6dt7l33I0+4I
         YQWsxr5f8dgc4JlifarPpuhLFjjwi+FmlCzjwlzY=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220316051731epcas5p1f3f5cf0288f95c6ca9b8fe2dc008602f~cxLZ0wbh63041230412epcas5p1b;
        Wed, 16 Mar 2022 05:17:31 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4KJJS46Lrfz4x9QN; Wed, 16 Mar
        2022 05:17:24 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        09.1D.06423.4E271326; Wed, 16 Mar 2022 14:17:24 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220316051408epcas5p199c4114bb75bad00f98c10c343f3b989~cxIcMqogw2601026010epcas5p1k;
        Wed, 16 Mar 2022 05:14:08 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220316051407epsmtrp1d9073a1b7a6909c25c504b7bd42aa253~cxIcLObpg2039020390epsmtrp1E;
        Wed, 16 Mar 2022 05:14:07 +0000 (GMT)
X-AuditID: b6c32a49-b01ff70000001917-eb-623172e450bc
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        CE.01.03370.F1271326; Wed, 16 Mar 2022 14:14:07 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220316051405epsmtip16bb3c47da5c042494a3836f0677dfa7e~cxIaEOI611821718217epsmtip1l;
        Wed, 16 Mar 2022 05:14:05 +0000 (GMT)
Date:   Wed, 16 Mar 2022 10:39:05 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshiiitr@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, Pankaj Raghav <pankydev8@gmail.com>,
        Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 14/17] io_uring: add polling support for uring-cmd
Message-ID: <20220316050905.GA28016@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220315085745.GE4132@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBJsWRmVeSWpSXmKPExsWy7bCmuu6TIsMkg9ZZRhbTDytaNE34y2wx
        Z9U2RovVd/vZLFauPspk8a71HItF5+kLTBbn3x5msph06Bqjxd5b2hbzlz1lt1jSepzN4saE
        p4wWa24+ZbH4fGYeqwO/x7Orzxg9ds66y+7RvOAOi8fls6Uem1Z1snlsXlLvsftmA5vHtsUv
        WT36tqxi9Pi8SS6AKyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
        ycUnQNctMwfoByWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFpXrpe
        XmqJlaGBgZEpUGFCdsaP2ZuZChbyVkzY84q5gbGLu4uRk0NCwETi8N2v7F2MXBxCArsZJVZu
        P8gM4XxilOh/0M4K4XxmlNjy8AQ7TMv85l6oxC5Gid7rF5ggnGeMEusbJjKBVLEIqEr09ixi
        7GLk4GAT0JS4MLkUJCwioCTx9NVZRpB6ZoE3zBJrf+9lBakRFnCTmP1dFcTkFdCV6FqlC1LO
        KyAocXLmExaQMKeAtsSc2TIgYVEBZYkD246DbZUQuMMh8a1jMzPEbS4S515cYoGwhSVeHd8C
        dbOUxMv+Nii7WOLXnaPMEM0djBLXG2ZCNdhLXNzzF+x8ZoFMiYarjWwQcVmJqafWQcX5JHp/
        P2GCiPNK7JgHYytK3Jv0lBXCFpd4OGMJlO0hMXfbH2j4nmCSeN77g3ECo/wsJM/NQrIPwraS
        6PzQxDoL6GlmAWmJ5f84IExNifW79Bcwsq5ilEwtKM5NTy02LTDMSy2HR3hyfu4mRnAS1/Lc
        wXj3wQe9Q4xMHIyHGCU4mJVEeM+80E8S4k1JrKxKLcqPLyrNSS0+xGgKjKqJzFKiyfnAPJJX
        Em9oYmlgYmZmZmJpbGaoJM57On1DopBAemJJanZqakFqEUwfEwenVAPTWu2Fr/ziWnPa8o4c
        3SakMff+JRHRGzoGuuXpbFcclJnbDnPwNTgHabluzD9Qw+giPtPvXuEus3ifcBcR7p1Bjpcy
        1nk4vrm2elVpCFPONDeudTcyLBS+ND+Ztee4eUcbV3vguebdycLZqoGW+5qX13YGJCz3kfu0
        8phr+7srWd9289y2bmBR2igp/dbjmpRm0yYL+aCVz/W+yp25ZHospOvlw04r2/Y4ycdvBZr5
        uRfEbji5fIbIQXdvCSndtzJaB6Zdc7/VpLDbLS32rlfq0xk12Q+kPqQoLVZ7ms/CGj7hHueE
        huBEKweRqz4vVl9ce7v23axXszum3tJtWP8/LSz70sRXclpzM0o9GJRYijMSDbWYi4oTAe/h
        Z1JrBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsWy7bCSnK58kWGSwb+LlhbTDytaNE34y2wx
        Z9U2RovVd/vZLFauPspk8a71HItF5+kLTBbn3x5msph06Bqjxd5b2hbzlz1lt1jSepzN4saE
        p4wWa24+ZbH4fGYeqwO/x7Orzxg9ds66y+7RvOAOi8fls6Uem1Z1snlsXlLvsftmA5vHtsUv
        WT36tqxi9Pi8SS6AK4rLJiU1J7MstUjfLoEr48T2O+wFF7gqtn94zdrAeJmji5GTQ0LARGJ+
        cy9rFyMXh5DADkaJD+1zGCES4hLN136wQ9jCEiv/PWeHKHrCKDH3/zEWkASLgKpEb88ioAYO
        DjYBTYkLk0tBwiICShJPX51lBKlnFvjELLH59SI2kBphATeJ2d9VQUxeAV2JrlW6ECNPMEkc
        2rMBbC+vgKDEyZlPwMYzC5hJzNv8kBmknllAWmL5Pw4Qk1NAW2LObBmQClEBZYkD244zTWAU
        nIWkeRaS5lkIzQsYmVcxSqYWFOem5xYbFhjlpZbrFSfmFpfmpesl5+duYgRHnpbWDsY9qz7o
        HWJk4mA8xCjBwawkwnvmhX6SEG9KYmVValF+fFFpTmrxIUZpDhYlcd4LXSfjhQTSE0tSs1NT
        C1KLYLJMHJxSDUwxX+rObL1y7ZVtl6yX4dSuhCdLd969y7pK69arqNk/N784UhC9fQfD0jSf
        rjUmVy5WlAnYfufWmz573Rx75eJj32p10++HtzgXL9RROmAWyr79ufb8KfkHpL9Na3p198Sh
        DY9WP02+uOW8IPearxc/7boU/CZu1pOth78eVbxVeD//Rfb72RMfcz58YjGLQ0vPoT/a+9/3
        k0/vuUwO/hBftLPyVXrwjv/v/21vCxD6mvqkc7mpphbr9qQDgcUbJbRD8+1vO8mWzFQ1nxwT
        tCF6aa4SU61V8OndFxfNsb87ySSn9bXftx1TK6yY9sZpbXMxq/D3vsfWsbLrs+fnyL9TosXu
        /NNl+mlQcbH3qFP7FSWW4oxEQy3mouJEAO23rvkrAwAA
X-CMS-MailID: 20220316051408epcas5p199c4114bb75bad00f98c10c343f3b989
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----.rW42XXn7_Ji6OxwuAF4RAMbP.qed.OeqKlvEhSLhB3noATS=_119d09_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220308152723epcas5p34460b4af720e515317f88dbb78295f06
References: <20220308152105.309618-1-joshi.k@samsung.com>
        <CGME20220308152723epcas5p34460b4af720e515317f88dbb78295f06@epcas5p3.samsung.com>
        <20220308152105.309618-15-joshi.k@samsung.com>
        <20220311065007.GC17728@lst.de>
        <CA+1E3rKKCE53TJ9mJesK3UrPPa=Vqx6fxA+TAhj9v5hT452AuQ@mail.gmail.com>
        <20220315085745.GE4132@lst.de>
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------.rW42XXn7_Ji6OxwuAF4RAMbP.qed.OeqKlvEhSLhB3noATS=_119d09_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Tue, Mar 15, 2022 at 09:57:45AM +0100, Christoph Hellwig wrote:
>On Mon, Mar 14, 2022 at 03:46:08PM +0530, Kanchan Joshi wrote:
>> But, after you did bio based polling, we need just the bio to poll.
>> iocb is a big structure (48 bytes), and if we try to place it in
>> struct io_uring_cmd, we will just blow up the cacheline in io_uring
>> (first one in io_kiocb).
>> So we just store that bio pointer in io_uring_cmd on submission
>> (please see patch 15).
>> And here on completion we pick that bio, and put that into this local
>> iocb, simply because  ->iopoll needs it.
>> Do you see I am still missing anything here?
>
>Yes.  The VFS layer interface for polling is the kiocb.  Don't break
>it.  The bio is just an implementation detail.

So how about adding ->async_cmd_poll in file_operations (since this
corresponds to ->async_cmd)?
It will take struct io_uring_cmd pointer as parameter.
Both ->iopoll and ->async_cmd_poll will differ in what they accept (kiocb
vs io_uring_cmd). The provider may use bio_poll, or whatever else is the
implementation detail.

for read/write, submission interface took kiocb, and completion
interface (->iopoll) also operated on the same.
for uring/async-cmd, submission interface took io_uring_cmd, but
completion used kiocb based ->iopoll. The new ->async_cmd_poll should
settle this.


------.rW42XXn7_Ji6OxwuAF4RAMbP.qed.OeqKlvEhSLhB3noATS=_119d09_
Content-Type: text/plain; charset="utf-8"


------.rW42XXn7_Ji6OxwuAF4RAMbP.qed.OeqKlvEhSLhB3noATS=_119d09_--
