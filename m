Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08467583F9E
	for <lists+io-uring@lfdr.de>; Thu, 28 Jul 2022 15:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238902AbiG1NJc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jul 2022 09:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238518AbiG1NJb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jul 2022 09:09:31 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317AC52DEB
        for <io-uring@vger.kernel.org>; Thu, 28 Jul 2022 06:09:30 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220728130928epoutp01ad94ea4a293373bb8e93856a69eb78a6~GADuDejW61978819788epoutp01h
        for <io-uring@vger.kernel.org>; Thu, 28 Jul 2022 13:09:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220728130928epoutp01ad94ea4a293373bb8e93856a69eb78a6~GADuDejW61978819788epoutp01h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1659013768;
        bh=R9d1g3ZEJQPeBzUHz+0RoUtU3ACPlaFu8eS27c8zYbU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s1K4bhtAJpZuuOsiyszSCqmFyllH1sQVwqN69miVb/YcaruaJ4QQBUDHPWGo0rMTa
         UoS7yYq5T41wzWJ4isoZDV00Lgry7O8biMwUaRISGZF8WsSPIytII2OY/dNHULjf83
         TTCdfh3ZDXtbTjboflKG1z+XD93vSkJU7kHxQiMw=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220728130927epcas5p331f917aa8d60e7138a87c6319966ddca~GADtj5Hpp0320803208epcas5p3x;
        Thu, 28 Jul 2022 13:09:27 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4LtrZr2MQBz4x9Pq; Thu, 28 Jul
        2022 13:09:24 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AF.F3.09662.48A82E26; Thu, 28 Jul 2022 22:09:24 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220728130658epcas5p21e9f3b745e2783799bbd216b13d67bbe~GABiNIu0l0169501695epcas5p2r;
        Thu, 28 Jul 2022 13:06:58 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220728130658epsmtrp2f3c07e3d38b9dc10dba92a78e0554329~GABiMi1O02237422374epsmtrp2f;
        Thu, 28 Jul 2022 13:06:58 +0000 (GMT)
X-AuditID: b6c32a49-885ff700000025be-51-62e28a840a56
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        72.33.08905.2F982E26; Thu, 28 Jul 2022 22:06:58 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220728130657epsmtip121698de24b5ade343986cfaf780a53c5~GABhkVg5M0427204272epsmtip1v;
        Thu, 28 Jul 2022 13:06:57 +0000 (GMT)
Date:   Thu, 28 Jul 2022 18:31:29 +0530
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com
Subject: Re: [PATCH liburing v3 0/5] Add basic test for nvme uring
 passthrough commands
Message-ID: <20220728130129.GA20031@test-zns>
MIME-Version: 1.0
In-Reply-To: <0a9c81d0-d6f6-effd-5d3f-132a92d54205@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDKsWRmVeSWpSXmKPExsWy7bCmum5L16Mkg9Z5ghar7/azWbxrPcdi
        cfT/WzYHZo/LZ0s9+rasYvT4vEkugDkq2yYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ
        0sJcSSEvMTfVVsnFJ0DXLTMHaI+SQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8Ck
        QK84Mbe4NC9dLy+1xMrQwMDIFKgwITvjy3nbgnW8FefWvWVqYLzD1cXIySEhYCKx7tV9pi5G
        Lg4hgd2MEjcPTWKEcD4xSlzc3MgG4XxjlFjzcCIjTMu2Wa+hqvYySvw7dZ8FwnnGKPFx8Xx2
        kCoWAVWJP4+XM4HYbALaEq/e3mAGsUUEFCR6fq8EGsvBwSxgKNE6Ix8kLCwQKbFx42s2EJtX
        QFdi08ZlULagxMmZT1hAbE4BW4lDG/vBbFEBZYkD246D3S0hcI5don3nZGaI61wk+ppnsELY
        whKvjm9hh7ClJD6/28sGYWdLbHr4kwnCLpA48qIXqtdeovVUP5jNLJAh0XV2IlSNrMTUU+uY
        IOJ8Er2/n0DFeSV2zIOxVSX+3rvNAmFLS9x8dxXK9pDYdOQfNLQOM0p8P36HdQKj/Cwkz81C
        sg/C1pFYsPsT2yxwGElLLP/HAWFqSqzfpb+AkXUVo2RqQXFuemqxaYFhXmo5PMKT83M3MYKT
        oZbnDsa7Dz7oHWJk4mA8xCjBwawkwpsQfT9JiDclsbIqtSg/vqg0J7X4EKMpMK4mMkuJJucD
        03FeSbyhiaWBiZmZmYmlsZmhkjiv19VNSUIC6YklqdmpqQWpRTB9TBycUg1MCf/WvPDe2t8i
        s+TWxhVHJ7FP3uahO1v23nW7N/ynArYaTTMJjbSpYlz3kvv4DzbNTR//LjmuIz915e3bxftt
        VCM/Xwxd4vZYc63FqqQHMiG3t2ku0yyb9sxsfXmH74O50a/2p+//kGyVKbutOSt75VmDW66m
        DQyPlr2IWXn3jfjTmbsWRp4Xya6qy1oT+/nPzrVhNcveTd84TdjryNT3vDunbogRCg171T5v
        q2ONTeRx5YNbTng9zFTkXCf/mrvujaacos/OwIcxfAaOb8WkP/SH5cxsUlBMfBXSG7XZv/mC
        qkzEpeiSjL09NXedF+7jtnZpZ7dd+5ln45LXXddWWR0P/Vq/b02VwNYW80Nt1kosxRmJhlrM
        RcWJAOv5Ry8PBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsWy7bCSnO6nzkdJBodbWSxW3+1ns3jXeo7F
        4uj/t2wOzB6Xz5Z69G1ZxejxeZNcAHMUl01Kak5mWWqRvl0CV8bVW7eZC95xVZxoWsjYwLiV
        o4uRk0NCwERi26zXjF2MXBxCArsZJbYcPMjUxcgBlJCWWLg+EaJGWGLlv+fsEDVPGCVmH7zP
        CpJgEVCV+PN4OROIzSagLfHq7Q1mEFtEQEGi5/dKNpA5zAKGEq0z8kHCwgKREhs3vmYDsXkF
        dCU2bVzGBjHzMKNE27obLBAJQYmTM5+A2cwCWhI3/r1kgpgjLbH8H9jNnAK2Eoc29oOViAoo
        SxzYdpxpAqPgLCTds5B0z0LoXsDIvIpRMrWgODc9t9iwwDAvtVyvODG3uDQvXS85P3cTIziE
        tTR3MG5f9UHvECMTB+MhRgkOZiUR3oTo+0lCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwX
        EkhPLEnNTk0tSC2CyTJxcEo1MO3IK7b4cpLPeOO/z9K/eFXamr49eV42N1RTbdNTeaO1uwVr
        VWT1tgrUTLXaVThbZp7C5bB3se0zCgP4tspePcvupRy7eK3X3EtXTv0tOmAmqxOj/e1MXof5
        hrKr9p99mzR+WORM2CR772wxYzGLj8bMnaXW2wSEpfnzqxpn2W2Ylpm94O8m82v3GVmum/oJ
        rZ+UOkHGiek/d/y66Ux5AjaHj+h4e8mU5z7iD8h8X7S2duvlprR7q27uSqnfsf0Vw4pT8VJJ
        C9ZlRUR3W0eFmp0UDw1Zwvt2an1oieHcDPa1/e5yJ64ujA88/fRIRfCl251Xg+eeqVwbnTSL
        88eM21wq3v9/+a56eDXY/tziTiWW4oxEQy3mouJEAJyCA2fQAgAA
X-CMS-MailID: 20220728130658epcas5p21e9f3b745e2783799bbd216b13d67bbe
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----3GC0G0c67CHFz-pUzO9qV37oeXJmKwYP9xQRy1YHFCjbzJ45=_26c9c_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220728093902epcas5p40813f72b828e68e192f98819d29b2863
References: <CGME20220728093902epcas5p40813f72b828e68e192f98819d29b2863@epcas5p4.samsung.com>
        <20220728093327.32580-1-ankit.kumar@samsung.com>
        <0a9c81d0-d6f6-effd-5d3f-132a92d54205@kernel.dk>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------3GC0G0c67CHFz-pUzO9qV37oeXJmKwYP9xQRy1YHFCjbzJ45=_26c9c_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Thu, Jul 28, 2022 at 06:36:51AM -0600, Jens Axboe wrote:
> On 7/28/22 3:33 AM, Ankit Kumar wrote:
> > This patchset adds a way to test NVMe uring passthrough commands with
> > nvme-ns character device. The uring passthrough was introduced with 5.19
> > io_uring.
> > 
> > To send nvme uring passthrough commands we require helpers to fetch NVMe
> > char device (/dev/ngXnY) specific fields such as namespace id, lba size etc.
> > 
> > How to run:
> > ./test/io_uring_passthrough.t /dev/ng0n1
> > 
> > It requires argument to be NVMe device, if not the test will be skipped.
> > 
> > The test covers write/read with verify for sqthread poll, vectored / nonvectored
> > and fixed IO buffers, which can be extended in future. As of now iopoll is not
> > supported for passthrough commands, there is a test for such case.
> > 
> > Changes from v2 to v3
> >  - Skip test if argument is not nvme device and remove prints, as
> >    suggested by Jens.
> >  - change nvme helper function name, as pointed by Jens.
> >  - Remove wrong comment about command size, as per Kanchan's review
> 
> I didn't get patch 2/5, and lore didn't either. Can you resend the series?
> 
> -- 
> Jens Axboe
> 
>
Sorry, issue from my side it. You should have 2/5 now and I see its there in
lore as well. Hope its sufficient and doesn't require me to resend the entire series
again.

------3GC0G0c67CHFz-pUzO9qV37oeXJmKwYP9xQRy1YHFCjbzJ45=_26c9c_
Content-Type: text/plain; charset="utf-8"


------3GC0G0c67CHFz-pUzO9qV37oeXJmKwYP9xQRy1YHFCjbzJ45=_26c9c_--
