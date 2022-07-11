Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE08570A3E
	for <lists+io-uring@lfdr.de>; Mon, 11 Jul 2022 20:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiGKS7k (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jul 2022 14:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiGKS7j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jul 2022 14:59:39 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53F027169
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 11:59:37 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220711185935epoutp03b9ed50bc394992a86fde33f15744a6f9~A23kNAKcG1850418504epoutp03F
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 18:59:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220711185935epoutp03b9ed50bc394992a86fde33f15744a6f9~A23kNAKcG1850418504epoutp03F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1657565975;
        bh=8WNQ5ChxuGE5Q71oImwf+rEE0lr/N+rms/8BqaHTtew=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H4C2iQDUpwqtM8f3kMctEqEoZK7BXqDvQ5hv6d1RTbOJcoV4JGsEbJCG3tEkBEpph
         9pgFQM7duYs4tI9phNOzqnpiw6DJp46+453fRl/8hsmxktT+VQc6rxyawV1Lai+t7m
         AVhzPk9DzVfwStaWK9EW393Vo8X/YlagVfZtP+Ac=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220711185934epcas5p3aec09119e47cc1946203b0b36a9a2581~A23jMqlp32413124131epcas5p3R;
        Mon, 11 Jul 2022 18:59:34 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4LhY8h2NvSz4x9Pp; Mon, 11 Jul
        2022 18:59:32 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        22.0C.09566.4137CC26; Tue, 12 Jul 2022 03:59:32 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220711185931epcas5p1bf5d0c8aa5ed5b6d262b81023c2a266e~A23gRc9HF2883828838epcas5p1P;
        Mon, 11 Jul 2022 18:59:31 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220711185931epsmtrp237cb38be85c8eb71b8f670812d341b3f~A23gQpCjA0917509175epsmtrp2x;
        Mon, 11 Jul 2022 18:59:31 +0000 (GMT)
X-AuditID: b6c32a4a-ba3ff7000000255e-7d-62cc731425f3
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        AB.C5.08802.3137CC26; Tue, 12 Jul 2022 03:59:31 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220711185929epsmtip1aac3f7335cfdd50514bcdcb4c399abdf~A23eBcsj00490104901epsmtip1V;
        Mon, 11 Jul 2022 18:59:29 +0000 (GMT)
Date:   Tue, 12 Jul 2022 00:24:06 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Sagi Grimberg <sagi@grimberg.me>, hch@lst.de, kbusch@kernel.org,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        asml.silence@gmail.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
Subject: Re: [PATCH for-next 4/4] nvme-multipath: add multipathing for
 uring-passthrough commands
Message-ID: <20220711185406.GB20562@test-zns>
MIME-Version: 1.0
In-Reply-To: <5c71b8f6-afec-8ef6-0a70-d13e71ded79c@samba.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Tf0xbVRTHva+lPJpVnx2ES3FdfWYhTCktK/UVqTNhzOdGHG7GMZyWUp4t
        Utra1zJlM5IiICTAxBFXKsFEZLE1LlRgAmVjZYDCBoPpCMYVCUUQM34mKrNstrxq9t/nnPs9
        P+4596Is/gBHgBYaLJTZoNbjHC67ayAxMSmavp4vGXI8RtjObrGIz5xdgHDdqecQ0/3dCPGV
        axAhlivG2MT43QGEaPDeBkTfz08TLW3zkcRE2yab+OaPFfYLO8jupjuR5LivnU3eumEl3c5q
        Dvlt6wdk73QZh2zuqQNkXYcTkBtuYXZUblG6jlIXUGYRZdAYCwoNWiV++JgqQ5Uql0iTpAri
        WVxkUBdTSvxAVnbSwUJ9sGFcVKLWW4OubDVN48nPp5uNVgsl0hlpixKnTAV6k8wkptXFtNWg
        FRsoS5pUIklJDQrzinRXb8lN3h3v/ui8j5SBFW4NQFGIyWD/vZQawEX5WC+AE1cW2YyxDuAD
        x6VIxtgA0DbTA2pA1HZEWfsEYA56AOypXI9gjN8AXJ8KxUehbGwPHGqsjwjV4GCJ8OYn1pA7
        GkuAk7/f3C7BwmoQ6Cor39bvxDTQ7W9AQszDkuCcq53D8OPwB7ufHcoThSlh1eaLIXcM9hTs
        7xpGQnkg9j0KA5c84e4OwLrmNoThnXBpuCOSYQHcWO7jMKyBk/axsMYC5zxXw7wfVozUs0LM
        wgrhwuBcmB+Ftf/4EWZePPhRJZ+RPwl9DfMRDMfC2fOtYSbhWkt5eHJfInD1LxfrLBA2PXSd
        podKMJwGq1dtEQzvhuWdjqAfDXI8vHAfZTARXuxJ/hxwnCCOMtHFWopONaUYqFP/r1tjLHaD
        7de899B3YPbXVbEXICjwAoiy8Ghe4MZIPp9XoH6vlDIbVWarnqK9IDW4qo9ZghiNMfgdDBaV
        VKaQyORyuUyxTy7FY3mHfnLn8zGt2kIVUZSJMv8Xh6BRgjLEQTvP0HFfv9q7sBhzucpe22Ft
        EV3Rnn7rokRzVNViW3rH+0aeHcJXPjzeKKo0HdZ1Jo/m8F5KrppF/YMradeM0k7heOCJOL8w
        136mXHlkebBi69z5+BO3d7Van6kYHflij0bWtJTr0NnZiT4y4++7vY8ckUgvDJ8+VYdm5ShW
        +rqdM8MZxzPwjtpZ6vpWSezLea651wOZgWPDMwsCoXIpYcvnDryf6R8lTM81xxnGPM2oJ8c2
        tD+9dA29HL/6dqOCeMA9mTlt8ZUvFpUoJ4XiuKmpX67l3uPni2c1RzWe6hOvRcwt+/atDek/
        ncfozVx36snS3ecG3gzsyvozgYuzaZ1aupdlptX/AkziaK1WBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsWy7bCSnK5w8Zkkg0XTFC2aJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFuffHmaymHToGqPF3lvaFvOXPWW3uLjsJ4vFutfvWRx4
        PHbOusvucf7eRhaPy2dLPTat6mTz2Lyk3mP3zQY2j7m7+hg9+rasYvT4vEkugDOKyyYlNSez
        LLVI3y6BK6Px7w7GggucFRf+7GJsYJzF0cXIySEhYCLRsPEiYxcjF4eQwA5GiTl3N7FAJMQl
        mq/9YIewhSVW/nvODlH0hFFi0u9JbCAJFgFViWNT+1m7GDk42AQ0JS5MLgUJiwioS1x6eQFs
        DrNAD5PE9jWMILawQLLEpieTmEBsXgFdicerN7JBzFzKJLFy9UuohKDEyZlPoJrNJOZtfsgM
        Mp9ZQFpi+T8OiLC8RPPW2WBhTgFbifaf7iBhUQFliQPbjjNNYBSahWTQLCSDZiEMmoVk0AJG
        llWMkqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMFRqKW1g3HPqg96hxiZOBgPMUpwMCuJ
        8P45eypJiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkmDk6pBqYz
        /ZNN6hzbuV1NVhy4JsAVtf/fM4lbk3MCdK4K3NsbY+bnwDh1mWHevMY9b32cW/tXOPZcU2P0
        ql4euWlbMd+Cgmvpi3w3Pt7lEqsndyx6W43i3JMOd5X4Lnebyse4/fWoObbJNrooQy2xtTHY
        +f2C2l65ZRmXf/x9bMs+bb6mCpe3xoOa6rXnp1YdPm2ym41t3xGTrwr7Pk11neD0oGDSY9Un
        Jz4E1id/2b6ic5mL3Vf71MjNQTO1rTyrOeJM3OcaRO0721UyTeJP4eR/3WGv5shFyhevEygK
        DGZk3bwoII+Nx67zuvVdzcWzzN5Fpst2SkyaqbicYzbPyvucWcctwv/FuaTI6uyXmlbxToml
        OCPRUIu5qDgRADwyCBQxAwAA
X-CMS-MailID: 20220711185931epcas5p1bf5d0c8aa5ed5b6d262b81023c2a266e
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----HMHzcl7Kov5y0bbYah5tgDYyhjafTXQAGx6UUfEgMJOMVZI4=_11bf0b_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220711110827epcas5p3fd81f142f55ca3048abc38a9ef0d0089
References: <20220711110155.649153-1-joshi.k@samsung.com>
        <CGME20220711110827epcas5p3fd81f142f55ca3048abc38a9ef0d0089@epcas5p3.samsung.com>
        <20220711110155.649153-5-joshi.k@samsung.com>
        <3fc68482-fb24-1f39-5428-faa3a8db9ecb@grimberg.me>
        <5c71b8f6-afec-8ef6-0a70-d13e71ded79c@samba.org>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------HMHzcl7Kov5y0bbYah5tgDYyhjafTXQAGx6UUfEgMJOMVZI4=_11bf0b_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On Mon, Jul 11, 2022 at 05:12:23PM +0200, Stefan Metzmacher wrote:
>Hi Sagi,
>
>>>@@ -189,6 +190,12 @@ enum {
>>>      NVME_REQ_USERCMD        = (1 << 1),
>>>  };
>>>+static inline struct nvme_uring_cmd_pdu *nvme_uring_cmd_pdu(
>>>+        struct io_uring_cmd *ioucmd)
>>>+{
>
>Shouldn't we have a BUILD_BUG_ON(sizeof(struct nvme_uring_cmd_pdu) > sizeof(ioucmd->pdu));
>here?
Not sure if I got the concern. We have this already inside
nvme_ns_uring_cmd function.

>>>+    return (struct nvme_uring_cmd_pdu *)&ioucmd->pdu;
>>>+}
>>>+
>
>>>diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
>>>index d734599cbcd7..57f4dfc83316 100644
>>>--- a/include/linux/io_uring.h
>>>+++ b/include/linux/io_uring.h
>>>@@ -15,6 +15,8 @@ enum io_uring_cmd_flags {
>>>      IO_URING_F_SQE128        = 4,
>>>      IO_URING_F_CQE32        = 8,
>>>      IO_URING_F_IOPOLL        = 16,
>>>+    /* to indicate that it is a MPATH req*/
>>>+    IO_URING_F_MPATH        = 32,
>
>Isn't that nvme specific? If so I don't think it belongs in io_uring.h at all...

Right. Removing this was bit ugly in nvme, but yes, need to kill this in
v2.

------HMHzcl7Kov5y0bbYah5tgDYyhjafTXQAGx6UUfEgMJOMVZI4=_11bf0b_
Content-Type: text/plain; charset="utf-8"


------HMHzcl7Kov5y0bbYah5tgDYyhjafTXQAGx6UUfEgMJOMVZI4=_11bf0b_--
