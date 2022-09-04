Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C235AC523
	for <lists+io-uring@lfdr.de>; Sun,  4 Sep 2022 17:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiIDPy0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Sep 2022 11:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbiIDPyZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 4 Sep 2022 11:54:25 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB5DB19
        for <io-uring@vger.kernel.org>; Sun,  4 Sep 2022 08:54:22 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220904155419epoutp04acc1bbb91bf6f4a65c2aa5592082acf2~Rs0f4baTy2259722597epoutp04k
        for <io-uring@vger.kernel.org>; Sun,  4 Sep 2022 15:54:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220904155419epoutp04acc1bbb91bf6f4a65c2aa5592082acf2~Rs0f4baTy2259722597epoutp04k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662306859;
        bh=Dx2L8jr4infeDXmI+lJMnanj6dR98PMMk4t7bG4TM4g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FZvkQpcOuoBT6W61U1VTMZ5dONXm4N0BtM2vaQ6xsG3Ijy6z51Jx6LzFV/8wjvvf9
         rloFCbk57E8Tlsg+4oYqhbcavO07i7nser80IXeLK6bsW5QRy8ob3GJ/Ec1aatogdU
         KyxxvIhvguegv/pmeHCj4J0XHTHleHt2jL+zfRIY=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220904155417epcas5p4f1bb245c26550f697acc41ea92ddc8f2~Rs0exUIhT0091300913epcas5p4-;
        Sun,  4 Sep 2022 15:54:17 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4MLGRW5zrhz4x9Pp; Sun,  4 Sep
        2022 15:54:15 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        78.88.53458.72AC4136; Mon,  5 Sep 2022 00:54:15 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220904155414epcas5p201348a65b4b7bbf2c196077785e26988~Rs0bh_Y9H0330403304epcas5p2W;
        Sun,  4 Sep 2022 15:54:14 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220904155414epsmtrp15f41593549685392d935560671771bab~Rs0bhaYdP2950829508epsmtrp1F;
        Sun,  4 Sep 2022 15:54:14 +0000 (GMT)
X-AuditID: b6c32a4a-caffb7000000d0d2-8f-6314ca276423
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        85.B1.18644.62AC4136; Mon,  5 Sep 2022 00:54:14 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220904155413epsmtip2d67bf7c2f5c1d53d615d723efafe1630~Rs0bEPX6Z0656306563epsmtip2B;
        Sun,  4 Sep 2022 15:54:13 +0000 (GMT)
Date:   Sun, 4 Sep 2022 21:14:30 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH 1/4] io_uring: cleanly separate request types for iopoll
Message-ID: <20220904154430.GA10536@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220903165234.210547-2-axboe@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCKsWRmVeSWpSXmKPExsWy7bCmlq76KZFkg5b7Char7/azWbxrPcfi
        wORx+Wypx+dNcgFMUdk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZK
        Lj4Bum6ZOUDTlRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFJgV6xYm5xaV56Xp5
        qSVWhgYGRqZAhQnZGad6JjMVPGWpmP77I3MD4zSWLkZODgkBE4mjU88zdzFycQgJ7GaUeP32
        ERuE84lR4tHC+awQzmdGiafHdzPDtMz9epMdxBYS2MUocWR9JUTRM0aJv2e6wRIsAioSKxqv
        AHVzcLAJaEpcmFwKEhYRUJDo+b2SDcRmFpCRmDznMli5sICPxM5FJxlBbF4BXYk9j2+wQdiC
        EidnPgE7lVPATGLT9z9gN4gKKEsc2HacCWSvhMA+dom5++dD/eMiMfHTLkYIW1ji1fEt7BC2
        lMTL/jYoO1ni0sxzTBB2icTjPQehbHuJ1lP9zBDHZUisnX4c6lA+id7fT5hAfpEQ4JXoaBOC
        KFeUuDfpKSuELS7xcMYSKNtDYsmC90yQ8NkKDNJTChMY5WYheWcWkg0QtpVE54cm1llAG5gF
        pCWW/+OAMDUl1u/SX8DIuopRMrWgODc9tdi0wCgvtRwexcn5uZsYwclNy2sH48MHH/QOMTJx
        MB5ilOBgVhLhTdkhkizEm5JYWZValB9fVJqTWnyI0RQYOxOZpUST84HpNa8k3tDE0sDEzMzM
        xNLYzFBJnHeKNmOykEB6YklqdmpqQWoRTB8TB6dUA1PYS7Z15VeuXF0+698uFimm0l05d7Y1
        We47bD5pe+dp3cWB1Qb/w658eMFx+GhHq8uX2unfjOWqPt9zZxX+tp7Ta/5/3fYH1WeZFlrO
        4PT/3p784sI8jiVr//2KPHxl0ozJM/P0+vNevP7JfTu6SIZ722U1/hrGmFztV+t4u2d77ztR
        6Z4eaNzZ1h9rm3Xzwke1c6r9y4w7pDJu7rYMNX8i/pB1clLh9qiSsw3OxZ9O79O66F8tzl8q
        W2xTPCFBZq0nF89FTcFnVUknd/yYX1FxVYGz39rUVi5zSUSBgeA9Q7kV4QZTtno6N9nVFbPX
        crgdOf09oTnp8Lz9/6UCvy3eYb+uat93GQvrwxIH/JVYijMSDbWYi4oTAbcEIJv3AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsWy7bCSvK7aKZFkg+MnpCxW3+1ns3jXeo7F
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgydj73KZjOVLGqbTJLA+Mjxi5GTg4JAROJuV9v
        sncxcnEICexglDjycyIzREJcovnaD3YIW1hi5b/nUEVPGCX2trxiAUmwCKhIrGi8wtrFyMHB
        JqApcWFyKUhYREBBouf3SjYQm1lARmLynMtgc4QFfCR2LjoJtphXQFdiz+MbbBAztzJKdJxa
        xwqREJQ4OfMJC0SzmcS8zQ+ZQeYzC0hLLP/HARLmBApv+v4H7E5RAWWJA9uOM01gFJyFpHsW
        ku5ZCN0LGJlXMUqmFhTnpucWGxYY5aWW6xUn5haX5qXrJefnbmIEh6uW1g7GPas+6B1iZOJg
        PMQowcGsJMKbskMkWYg3JbGyKrUoP76oNCe1+BCjNAeLkjjvha6T8UIC6YklqdmpqQWpRTBZ
        Jg5OqQam/tV3nqxTMMy+/nfzfOdFTrIm8l9MDvhE/pj45O4FhafBih+2xWfOfjSFI2s7+5Er
        K8suH8+qXXGNO+J34HnlcJ2sWm41O88DL/8WtpzYmb+NL0d5pYbozKApfhPrOIJNa5/Lv5mo
        nyQa4COVxXJyuSF7s+7iG4tcgrL++FS8/sYjY3Gy/fEh06rK19dzpn62Lzc/2dCUqVl5yaz0
        /YaV3A9T++be7/tpuuTRZ0mJo5teLu9bxjW1f9LpGW++Jj5levx724+oreG6q5y0/Y92dkQI
        B6t/ueiw7bzd51WfAtYc1Tsu5nT1L/vj3LSjfAJm53bVPSne+EBDP5oz6ixHnbDNmUirtNua
        rPPzcu/9UGIpzkg01GIuKk4EAJAQtbrGAgAA
X-CMS-MailID: 20220904155414epcas5p201348a65b4b7bbf2c196077785e26988
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----zvU9B7RYhoxo0n0NtQiMJbd43ri29uhJZ9UzgKuz80Y8n-YR=_483ba_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220903165244epcas5p30bfcd1c18fdb24178be27cb175388d6d
References: <20220903165234.210547-1-axboe@kernel.dk>
        <CGME20220903165244epcas5p30bfcd1c18fdb24178be27cb175388d6d@epcas5p3.samsung.com>
        <20220903165234.210547-2-axboe@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------zvU9B7RYhoxo0n0NtQiMJbd43ri29uhJZ9UzgKuz80Y8n-YR=_483ba_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Sat, Sep 03, 2022 at 10:52:31AM -0600, Jens Axboe wrote:
>After the addition of iopoll support for passthrough, there's a bit of
>a mixup here. Clean it up and get rid of the casting for the passthrough
>command type.

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>


------zvU9B7RYhoxo0n0NtQiMJbd43ri29uhJZ9UzgKuz80Y8n-YR=_483ba_
Content-Type: text/plain; charset="utf-8"


------zvU9B7RYhoxo0n0NtQiMJbd43ri29uhJZ9UzgKuz80Y8n-YR=_483ba_--
