Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3A44DABDF
	for <lists+io-uring@lfdr.de>; Wed, 16 Mar 2022 08:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241615AbiCPHgi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Mar 2022 03:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234688AbiCPHgh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Mar 2022 03:36:37 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9493853E32
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 00:35:22 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220316073520epoutp024288c0a08ed22bee59ebfd99447bb3b6~czDuxs_kI2235222352epoutp021
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 07:35:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220316073520epoutp024288c0a08ed22bee59ebfd99447bb3b6~czDuxs_kI2235222352epoutp021
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1647416120;
        bh=0ch16WX5sxYc+WOht+eFe2RkcmpBFB4vfsqCaL2z36M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=at5FIj/VsuPyPzHfOi83uqZ1+1jCSzwcdFhzTzVIVe8gDdycsTzBiaqwTcqM0T2by
         ZOG5ae/WafP4zKbNxl+cYhRif77u1vQPvV0KKFLJTFugJraSlk4XuCYG6GlBOzaOAn
         pTVHWbeodhWDl9FLnNNxM7hL24dO1Ft1QwwzJZTA=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220316073519epcas5p2c43131a53bdc2868f6aa1e49d08cb7d5~czDuJqTFf2807628076epcas5p2q;
        Wed, 16 Mar 2022 07:35:19 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4KJMW06rT1z4x9QT; Wed, 16 Mar
        2022 07:35:08 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        53.EC.05590.52391326; Wed, 16 Mar 2022 16:35:01 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220316073230epcas5p47458b509510ee55be5bfa5152fad991b~czBQITy3w2400724007epcas5p4H;
        Wed, 16 Mar 2022 07:32:30 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220316073230epsmtrp1ac86bafccc6d7619a09cd86cb9e4f0cc~czBQHZRMF1062610626epsmtrp1P;
        Wed, 16 Mar 2022 07:32:30 +0000 (GMT)
X-AuditID: b6c32a4b-739ff700000015d6-3b-62319325b78c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        EF.92.03370.D8291326; Wed, 16 Mar 2022 16:32:30 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220316073227epsmtip267db15d1cd03c9e484f7eefb9176d97a~czBN9SbvN2834028340epsmtip2l;
        Wed, 16 Mar 2022 07:32:27 +0000 (GMT)
Date:   Wed, 16 Mar 2022 12:57:27 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     axboe@kernel.dk, kbusch@kernel.org, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, pankydev8@gmail.com, javier@javigon.com,
        mcgrof@kernel.org, a.manzanares@samsung.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com
Subject: Re: [PATCH 05/17] nvme: wire-up support for async-passthru on
 char-device.
Message-ID: <20220316072727.GA2104@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220315085410.GA4132@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTVxzeubctlyaFOwQ50mzAJWAAgXaW7sJgL4neqFmaGbbE4OACd0AK
        t01vO19jYyoLZeGhiLw7EBwOHDLoGnmYSRELIi+ZIEQZOCCDRUGZi3GBrOWWxf++3/f7vnO+
        33lgqMeUyAfLYPWMjqUzCZFYYOkN3hkWWCJPlk3VepNlvf7kqeJ1lKxusgCy+WGRiPyxuQ8h
        n+QOC0jj4ChCjjzuRchz1glAXp8OJb//YcGFbMi1icj7xQuAvDK1ICDX7piE77tTi/cWAdVR
        +dCFOl37QECNDxmotiajiGpv+JrqmsoRUZb6JSFVaG4C1FrbmyrxYXVMOkOnMjo/hk3RpGaw
        abHEgUOJexIjlTJ5mDyKfJvwY+ksJpaIO6gK25uRaZ+B8PuCzjTYKRXNcUTEuzE6jUHP+KVr
        OH0swWhTM7UKbThHZ3EGNi2cZfTRcpnsrUi7MEmdPl3wFNE2Bhy7d3dWmAOuS/OBKwZxBXxR
        kIfmAzHmgXcB+LjrFsIXzwAc6VgV8MUagI+elLlsWcxnCoV8oxPAlpVWZ7EI4F/d/cChEuCB
        sDrvO/taGCbCg+FoicFBe+IEXFgeAg49ivcjsGbGhDga2/B4eCaX10vwXXAtj3LQEvx1OFAx
        L3BgVzwUlvSXow7shQfAGxbbZlSI/4bB+hflgE8XB1fMA86k2+CyzezEPnCp6Fsn5uDLB30o
        b84DcDKnQsA33oNj3eubgVA8A853/IHw/Buw9HaLk3eDBf/OO3kJvGbawv5w5tyCkMfecK68
        QegYBuIUbKiS8gd0EYGWGzWCYuBb+cpwla9sx+NoaFw9Jay021FcChs3MB4Gw6udEbVA2AR2
        MFouK43hIrW7Webo/zeeoslqA5tvPOTANfBodjXcChAMWAHEUMJTcufPiGQPSSp9/ASj0yTq
        DJkMZwWR9rs6i/p4pWjsn4TVJ8oVUTKFUqlURO1Wyglvye20VtoDT6P1jJphtIxuy4dgrj45
        iCK72X/4Z+ll1cmJm4mXTotMLnWqbq163OSVFLJHTC22NZYdTwj9bK6wzkgNWIZda0taG3w7
        1xPcq6br8IlB03aLuD+/9PnS0av+MR9d3lDHvRx5zTOwPjmuK/ud7CsnZq09Naz16bMiTdRg
        Z0zKjm80x7rP7vNVTob3zKC/7tmlPr/T7fz+5U/d9x3h4i9xtoGVoM+t1R9/EHF3fv9PN1tY
        23jUP0GquiKF+pbb3P1yzZftY7YKzYaqr3UoWgqnzMn5E78EySdHD3dc7En46sLfXrKAFWas
        87m+vck3+xNEeCTwUEBpvHE60ASM281S0Yd7k8QH3UN/D9YzAScNVTkFhIBLp+UhqI6j/wP7
        45vZbAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsWy7bCSvG7fJMMkg8YGRovphxUtmib8ZbaY
        s2obo8Xqu/1sFitXH2WyeNd6jsWi8/QFJovzbw8zWUw6dI3RYu8tbYv5y56yWyxpPc5mcWPC
        U0aLNTefslh8PjOP1YHf49nVZ4weO2fdZfdoXnCHxePy2VKPTas62Tw2L6n32H2zgc1j2+KX
        rB59W1YxenzeJBfAFcVlk5Kak1mWWqRvl8CVMaFjOnvBNYWK01+fsjQwtkl2MXJySAiYSGxp
        6WMFsYUEdjBKNCxkhoiLSzRf+8EOYQtLrPz3HMjmAqp5wijx9f4CsAYWAVWJOR3dTF2MHBxs
        ApoSFyaXgoRFBJQknr46ywhSzyxwikmiYds7sEHCAqESLa0Q9bwCOhKfOzwg9i5hkth+Sg/E
        5hUQlDg58wkLiM0sYCYxb/NDZpByZgFpieX/OEDCnALaEpNPzAA7U1RAWeLAtuNMExgFZyHp
        noWkexZC9wJG5lWMkqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMGRp6W1g3HPqg96hxiZ
        OBgPMUpwMCuJ8J55oZ8kxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdC18l4IYH0xJLU7NTUgtQi
        mCwTB6dUA9OGKT8Uj2mfXL7s+ZNyoe3q983+bVQ8kFHzMmtLkkxPgfgW6bMRf6asSzSYLqIS
        8yvnbRabaNC2KrECDdPCQO9vk3Rafj3y/JI8603zvhAjey+f1BXiXa+fJf59aV8U8dswVyBU
        MIyZzbF6L3/VaZN7Ct9y3uu//JjI09Az8cM3J0/RaskJOvFP2PetneHr9EdY8+b6kJxXzXWP
        isqMBBOiOmQijuiUqghfut0cn5e0+Yiz0qs5P7eu+vk2oy3o7J1DgVuTrdb41Cle2rh4wlGR
        r8cF8vfWr2I48ehj1s+fUYzWES+mnlJo32Dlv5jvpcoew9o7/sxnN0RJt/O0uqxwfXbjkfoC
        KZubWUGci5VYijMSDbWYi4oTAZrfQggrAwAA
X-CMS-MailID: 20220316073230epcas5p47458b509510ee55be5bfa5152fad991b
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----7Im1L.vKorTl163deO4rxYDAHxkziUWsBhtki-3JrW1s26Hg=_11b0d6_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220308152702epcas5p1eb1880e024ac8b9531c85a82f31a4e78
References: <20220308152105.309618-1-joshi.k@samsung.com>
        <CGME20220308152702epcas5p1eb1880e024ac8b9531c85a82f31a4e78@epcas5p1.samsung.com>
        <20220308152105.309618-6-joshi.k@samsung.com>
        <20220311070148.GA17881@lst.de> <20220314162356.GA13902@test-zns>
        <20220315085410.GA4132@lst.de>
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------7Im1L.vKorTl163deO4rxYDAHxkziUWsBhtki-3JrW1s26Hg=_11b0d6_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Tue, Mar 15, 2022 at 09:54:10AM +0100, Christoph Hellwig wrote:
>On Mon, Mar 14, 2022 at 09:53:56PM +0530, Kanchan Joshi wrote:
>>>> +struct nvme_uring_cmd_pdu {
>>>> +	u32 meta_len;
>>>> +	union {
>>>> +		struct bio *bio;
>>>> +		struct request *req;
>>>> +	};
>>>> +	void *meta; /* kernel-resident buffer */
>>>> +	void __user *meta_buffer;
>>>> +} __packed;
>>>
>>> Why is this marked __packed?
>> Did not like doing it, but had to.
>> If not packed, this takes 32 bytes of space. While driver-pdu in struct
>> io_uring_cmd can take max 30 bytes. Packing nvme-pdu brought it down to
>> 28 bytes, which fits and gives 2 bytes back.
>
>What if you move meta_len to the end?  Even if we need the __packed
>that will avoid all the unaligned access to pointers, which on some
>architectures will crash the kernel.
ah, right. Will move that to the end.

>> And on moving meta elements outside the driver, my worry is that it
>> reduces scope of uring-cmd infra and makes it nvme passthru specific.
>> At this point uring-cmd is still generic async ioctl/fsctl facility
>> which may find other users (than nvme-passthru) down the line. Organization
>> of fields within "struct io_uring_cmd" is around the rule
>> that a field is kept out (of 28 bytes pdu) only if is accessed by both
>> io_uring and driver.
>
>We have plenty of other interfaces of that kind.  Sockets are one case
>already, and regular read/write with protection information will be
>another one.  So having some core infrastrucure for "secondary data"
>seems very useful.
So what is the picture that you have in mind for struct io_uring_cmd?
Moving meta fields out makes it look like this - 

@@ -28,7 +28,10 @@ struct io_uring_cmd {
        u32             cmd_op;
        u16             cmd_len;
        u16             unused;
-       u8              pdu[28]; /* available inline for free use */
+       void __user     *meta_buffer; /* nvme pt specific */
+       u32             meta_len; /* nvme pt specific */
+       u8              pdu[16]; /* available inline for free use */
+
 };
And corresponding nvme 16 byte pdu - 
 struct nvme_uring_cmd_pdu {
-       u32 meta_len;
        union {
                struct bio *bio;
                struct request *req;
        };
        void *meta; /* kernel-resident buffer */
-       void __user *meta_buffer;
 } __packed;

I do not understand how this helps. Only the generic space (28 bytes)
got reduced to 16 bytes.

>> I see, so there is room for adding some efficiency.
>> Hope it will be ok if I carry this out as a separate effort.
>> Since this is about touching blk_mq_complete_request at its heart, and
>> improving sync-direct-io, this does not seem best-fit and slow this
>> series down.
>
>I really rather to this properly.  Especially as the current effort
>adds new exported interfaces.

Seems you are referring to io_uring_cmd_complete_in_task().

We would still need to use/export that even if we somehow manage to move
task-work trigger from nvme-function to blk_mq_complete_request.
io_uring's task-work infra is more baked than raw task-work infra.
It would not be good to repeat all that code elsewhere.
I tried raw one in the first attempt, and Jens suggested to move to baked
one. Here is the link that gave birth to this interface -
https://lore.kernel.org/linux-nvme/6d847f4a-65a5-bc62-1d36-52e222e3d142@kernel.dk/
 

>> Deferring by ipi or softirq never occured. Neither for block nor for
>> char. Softirq is obvious since I was not running against scsi (or nvme with
>> single queue). I could not spot whether this is really a overhead, at
>> least for nvme.
>
>This tends to kick in if you have less queues than cpu cores.  Quite
>command with either a high core cound or a not very high end nvme
>controller.
I will check that.
But swtiching (irq to task-work) is more generic and not about this series.
Triggering task-work anyway happens for regular read/write
completion too (in io_uring)...in the same return path involving
blk_mq_complete_request. For passthru, we are just triggering this
somewhat earlier in the completion path. 

------7Im1L.vKorTl163deO4rxYDAHxkziUWsBhtki-3JrW1s26Hg=_11b0d6_
Content-Type: text/plain; charset="utf-8"


------7Im1L.vKorTl163deO4rxYDAHxkziUWsBhtki-3JrW1s26Hg=_11b0d6_--
