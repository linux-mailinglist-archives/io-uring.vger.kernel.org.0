Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB6504E7EBE
	for <lists+io-uring@lfdr.de>; Sat, 26 Mar 2022 04:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbiCZDVG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Mar 2022 23:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiCZDVE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Mar 2022 23:21:04 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DF1506E3
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 20:19:23 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220326031919epoutp0111e9d801594aea3eae206c6f9bdc7ff6~f0BDkmPrk1650316503epoutp01M
        for <io-uring@vger.kernel.org>; Sat, 26 Mar 2022 03:19:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220326031919epoutp0111e9d801594aea3eae206c6f9bdc7ff6~f0BDkmPrk1650316503epoutp01M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1648264759;
        bh=F0N8qMeD0azlIV/3buov8aYHcihb5aLD/QeHO9g9Lfw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bvryxoTBXggI8k7QxPQ2UJ8zHY1t14BISLyKOaEnh0GIUbgBvhAV/aWl9cxuBSg2U
         AneFoP8+6TekYc5uYPV7B1ghx7EQQD2tHz3AM98jLP+mjhXrOkX1iE61k++PbPkNxk
         eYlKuLAsuYYfUGOrZW6WHDk4PNL27n7wRewDeGyE=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220326031919epcas5p3b798f432c72e2951210a076642884495~f0BDIZ28S0726907269epcas5p3i;
        Sat, 26 Mar 2022 03:19:19 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4KQPM74QK7z4x9Q0; Sat, 26 Mar
        2022 03:19:15 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A1.C2.12523.3368E326; Sat, 26 Mar 2022 12:19:15 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220325134426epcas5p41f9bb3a823879981550237281458ad6e~fo5kC5pcs2339723397epcas5p4I;
        Fri, 25 Mar 2022 13:44:26 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220325134426epsmtrp130df0ddebfed92e2b430677f028d3d4a~fo5kB8I9I0574005740epsmtrp1Z;
        Fri, 25 Mar 2022 13:44:26 +0000 (GMT)
X-AuditID: b6c32a4a-5a1ff700000030eb-34-623e86334397
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        65.1A.29871.A37CD326; Fri, 25 Mar 2022 22:44:26 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220325134423epsmtip24e5d06ec63fbe8b4f0e3c4aceca7a4e8~fo5h7EN3q0616106161epsmtip2a;
        Fri, 25 Mar 2022 13:44:23 +0000 (GMT)
Date:   Fri, 25 Mar 2022 19:09:21 +0530
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
Subject: Re: [PATCH 17/17] nvme: enable non-inline passthru commands
Message-ID: <20220325133921.GA13818@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220324063218.GC12660@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKJsWRmVeSWpSXmKPExsWy7bCmpq5xm12SwaPrihbTDytaNE34y2wx
        Z9U2RovVd/vZLFauPspk8a71HItF5+kLTBbn3x5msph06Bqjxd5b2hbzlz1lt1jSepzN4saE
        p4wWa24+ZbH4fGYeqwO/x7Orzxg9ds66y+7RvOAOi8fls6Uem1Z1snlsXlLvsftmA5vHtsUv
        WT36tqxi9Pi8SS6AKyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
        ycUnQNctMwfoByWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFpXrpe
        XmqJlaGBgZEpUGFCdkZ7/3SWgqOyFee2NzI2MN4S62Lk5JAQMJE4eP4BSxcjF4eQwG5GiX9/
        J0E5nxglJi/ewQ5SJSTwjVHiyMRsmI6rP/vYIIr2MkrseniCHcJ5xiix/tMjRpAqFgFVia6f
        74BGcXCwCWhKXJhcChIWEVCSePrqLCNIPbPAG2aJtb/3soIkhAVcJDb2XmMDqecV0JX4sqgI
        JMwrIChxcuYTsDGcAjoSz/+7g4RFBZQlDmw7zgQyRkLgDofEmo7tzCA1EkBjei7qQdwpLPHq
        +BZ2CFtK4mV/G5SdLNG6/TI7RHmJxJIF6hBhe4mLe/4ygdjMAukSjw80Q5XLSkw9tQ4qzifR
        +/sJE0ScV2LHPBhbUeLepKesELa4xMMZS6BsD4njja8YIaEzk0Vi271OlgmM8rOQfDYLyT4I
        20qi80MT6yyg85gFpCWW/+OAMDUl1u/SX8DIuopRMrWgODc9tdi0wCgvtRwe28n5uZsYwelb
        y2sH48MHH/QOMTJxMB5ilOBgVhLhvX/ZOkmINyWxsiq1KD++qDQntfgQoykwoiYyS4km5wMz
        SF5JvKGJpYGJmZmZiaWxmaGSOO/p9A2JQgLpiSWp2ampBalFMH1MHJxSDUy+LXtKzzEckhV2
        KHN97bP5+YtTgi89Qiv0/C/J2DkGKTVXRyQ4emdeUL1o25w7dfHarW/mrLh/yNpfwNb08fRd
        zj6Biu//HnfXlZZwuS2WlP/Buf+UZ6slc9ziwODyT/Ou3Tj/QL+UK7XqBeOUY8dupyzZsujf
        yUlzCzZNnLzp8xZBzddsX14uUJqtc+rgjUtT8tafu6G2v1R7XVWWvtSq7rkyX36sjV73WOla
        9mQ9i9tzHnaECufkes2Zt+xc8aE+zRO96YczTrwsZ0v+4Rm+vr5yv5D/lhy//p+7fK6L6+oZ
        ihcJ+ZbWnog8uXDj7CO3Z1qs9fOwibXXvTnpyIQXTLd3N67iXja1fLbskr0SSizFGYmGWsxF
        xYkAc8KG9mgEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsWy7bCSvK7Vcdskg83XWS2mH1a0aJrwl9li
        zqptjBar7/azWaxcfZTJ4l3rORaLztMXmCzOvz3MZDHp0DVGi723tC3mL3vKbrGk9TibxY0J
        Txkt1tx8ymLx+cw8Vgd+j2dXnzF67Jx1l92jecEdFo/LZ0s9Nq3qZPPYvKTeY/fNBjaPbYtf
        snr0bVnF6PF5k1wAVxSXTUpqTmZZapG+XQJXxobJ+xgLfklVHH3Vz9TAuFKki5GTQ0LAROLq
        zz62LkYuDiGB3YwSn/dcYoFIiEs0X/vBDmELS6z895wdougJo8Sd3gtsIAkWAVWJrp/vgBo4
        ONgENCUuTC4FCYsIKEk8fXWWEaSeWeATs8Tm14vA6oUFXCQ29l5jA6nnFdCV+LKoCGLmTBaJ
        yzOPMYLU8AoISpyc+QTsCGYBM4l5mx8yg9QzC0hLLP/HAWJyCuhIPP/vDlIhKqAscWDbcaYJ
        jIKzkDTPQtI8C6F5ASPzKkbJ1ILi3PTcYsMCw7zUcr3ixNzi0rx0veT83E2M4NjT0tzBuH3V
        B71DjEwcjIcYJTiYlUR471+2ThLiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6HrZLyQQHpiSWp2
        ampBahFMlomDU6qBicd2/ZVty9bYFl1PyuTcv/CvSo5aFldmp2pQVWNlps45zXebtCetzOXs
        mXRo/VcP6V6Fd/MV/r86xaBk8r9j4YcPT+TF8maYM7fLrm6cZ9R8Lp417LPjEbOpRmlCu+qm
        n+F4zGSvM/v1BZUreiaPWFbrVsu+b/C2WXY5duGHHXX7vqo/kG998XeCiq6USOGmJXq6d8Sn
        HjxQ1WN0IstremmfzS6pBo0Ckb3OtscCdRjy924qLU1a5c/tvO2YrVAXJ+8LfpUbpTF9u0ME
        zHc9ObWlMPD8R/ENP/Ub9zsn1m0I6pxjr7rWOEmqKIl/0t/VHktKRLgfftyzsOjb1W1318V1
        XpQv/xggyGSsfMhQiaU4I9FQi7moOBEA1ygI6iwDAAA=
X-CMS-MailID: 20220325134426epcas5p41f9bb3a823879981550237281458ad6e
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----48ALem4cADf3xwa-0Uc1Gf-iSzVqekzis73It7X2K98eFieH=_67a8_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220308152729epcas5p17e82d59c68076eb46b5ef658619d65e3
References: <20220308152105.309618-1-joshi.k@samsung.com>
        <CGME20220308152729epcas5p17e82d59c68076eb46b5ef658619d65e3@epcas5p1.samsung.com>
        <20220308152105.309618-18-joshi.k@samsung.com>
        <20220310083652.GF26614@lst.de>
        <CA+1E3rLaQstG8LWUyJrbK5Qz+AnNpOnAyoK-7H5foFm67BJeFA@mail.gmail.com>
        <20220310141945.GA890@lst.de>
        <CA+1E3rL3Q2noHW-cD20SZyo9EqbzjF54F6TgZoUMMuZGkhkqnw@mail.gmail.com>
        <20220311062710.GA17232@lst.de>
        <CA+1E3rLGwHFbdbSTJBfWrw6RLErwcT2zPxGmmWbcLUj2y=16Qg@mail.gmail.com>
        <20220324063218.GC12660@lst.de>
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------48ALem4cADf3xwa-0Uc1Gf-iSzVqekzis73It7X2K98eFieH=_67a8_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Thu, Mar 24, 2022 at 07:32:18AM +0100, Christoph Hellwig wrote:
>On Tue, Mar 22, 2022 at 10:40:27PM +0530, Kanchan Joshi wrote:
>> On Fri, Mar 11, 2022 at 11:57 AM Christoph Hellwig <hch@lst.de> wrote:
>> > > And that's because this ioctl requires additional "__u64 result;" to
>> > > be updated within "struct nvme_passthru_cmd64".
>> > > To update that during completion, we need, at the least, the result
>> > > field to be a pointer "__u64 result_ptr" inside the struct
>> > > nvme_passthru_cmd64.
>> > > Do you see that is possible without adding a new passthru ioctl in nvme?
>> >
>> > We don't need a new passthrough ioctl in nvme.
>> Right. Maybe it is easier for applications if they get to use the same
>> ioctl opcode/structure that they know well already.
>
>I disagree.  Reusing the same opcode and/or structure for something
>fundamentally different creates major confusion.  Don't do it.

Ok. If you are open to take new opcode/struct route, that is all we
require to pair with big-sqe and have this sorted. How about this -

+/* same as nvme_passthru_cmd64 but expecting result field to be pointer */
+struct nvme_passthru_cmd64_ind {
+       __u8    opcode;
+       __u8    flags;
+       __u16   rsvd1;
+       __u32   nsid;
+       __u32   cdw2;
+       __u32   cdw3;
+       __u64   metadata;
+       __u64   addr;
+       __u32   metadata_len;
+       union {
+               __u32   data_len; /* for non-vectored io */
+               __u32   vec_cnt; /* for vectored io */
+       };
+       __u32   cdw10;
+       __u32   cdw11;
+       __u32   cdw12;
+       __u32   cdw13;
+       __u32   cdw14;
+       __u32   cdw15;
+       __u32   timeout_ms;
+       __u32   rsvd2;
+       __u64   presult; /* pointer to result */
+};
+
 #define nvme_admin_cmd nvme_passthru_cmd

+#define NVME_IOCTL_IO64_CMD_IND        _IOWR('N', 0x50, struct nvme_passthru_cmd64_ind)

Not heavy on code-volume too, because only one statement (updating
result) changes and we reuse everything else.

>> >From all that we discussed, maybe the path forward could be this:
>> - inline-cmd/big-sqe is useful if paired with big-cqe. Drop big-sqe
>> for now if we cannot go the big-cqe route.
>> - use only indirect-cmd as this requires nothing special, just regular
>> sqe and cqe. We can support all passthru commands with a lot less
>> code. No new ioctl in nvme, so same semantics. For common commands
>> (i.e. read/write) we can still avoid updating the result (put_user
>> cost will go).
>>
>> Please suggest if we should approach this any differently in v2.
>
>Personally I think larger SQEs and CQEs are the only sensible interface
>here.  Everything else just fails like a horrible hack I would not want
>to support in NVMe.

So far we have gathered three choices: 

(a) big-sqe + new opcode/struct in nvme
(b) big-sqe + big-cqe
(c) regular-sqe + regular-cqe

I can post a RFC on big-cqe work if that is what it takes to evaluate
clearly what path to take. But really, the code is much more compared
to choice (a) and (c). Differentiating one CQE with another does not
seem very maintenance-friendly, particularly in liburing.

For (c), I did not get what part feels like horrible hack.
It is same as how we do sync passthru - read passthru command from
user-space memory, and update result into that on completion.
But yes, (a) seems like the best option to me.

------48ALem4cADf3xwa-0Uc1Gf-iSzVqekzis73It7X2K98eFieH=_67a8_
Content-Type: text/plain; charset="utf-8"


------48ALem4cADf3xwa-0Uc1Gf-iSzVqekzis73It7X2K98eFieH=_67a8_--
