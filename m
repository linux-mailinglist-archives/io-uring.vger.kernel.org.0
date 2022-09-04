Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E1F5AC52D
	for <lists+io-uring@lfdr.de>; Sun,  4 Sep 2022 18:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbiIDQAT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Sep 2022 12:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233489AbiIDQAR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 4 Sep 2022 12:00:17 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A273B19014
        for <io-uring@vger.kernel.org>; Sun,  4 Sep 2022 09:00:14 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220904160011epoutp039cafe7396d561469ed798f65df8a6a58~Rs5oYZ0cr2185021850epoutp03y
        for <io-uring@vger.kernel.org>; Sun,  4 Sep 2022 16:00:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220904160011epoutp039cafe7396d561469ed798f65df8a6a58~Rs5oYZ0cr2185021850epoutp03y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662307211;
        bh=ztCkm/U7sVIRBvCaPg2GJqZPlxYapjj2F8MmQdufgxY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fMrPBpwxMBglUYf6enWO6bmvzFD72MONxvl2BPYHSmbeDE0R2OJAlZs0W58mY2roB
         wZdE5JzR/kd4iLZJzyRovs3rrmtA7yFyp4uBo/IGw26+pQ2vReUHx0IMCqaJaI7J5s
         J/OK1b2dMTAH7L/j2r+DchKIyU4HfEy7of+gn8SQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220904160011epcas5p21d09d42a1d9e0d9e18e829197b1d0b99~Rs5oOCqDt1951419514epcas5p2K;
        Sun,  4 Sep 2022 16:00:11 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4MLGZK4xG5z4x9Pv; Sun,  4 Sep
        2022 16:00:09 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3F.A8.54060.78BC4136; Mon,  5 Sep 2022 01:00:07 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220904160007epcas5p3990c896e79dcf26d3fb6d09aab8761e7~Rs5kCE_d52433624336epcas5p3R;
        Sun,  4 Sep 2022 16:00:07 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220904160007epsmtrp25ff46d447f5fe419b880710668bcd66c~Rs5kBdof_0438604386epsmtrp2V;
        Sun,  4 Sep 2022 16:00:07 +0000 (GMT)
X-AuditID: b6c32a4b-e33fb7000000d32c-ff-6314cb874ced
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        EE.B1.18644.78BC4136; Mon,  5 Sep 2022 01:00:07 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220904160006epsmtip16be93ade6ec157ea190bfafd9c2dcce9~Rs5jhc7Ri2941129411epsmtip1Z;
        Sun,  4 Sep 2022 16:00:06 +0000 (GMT)
Date:   Sun, 4 Sep 2022 21:20:23 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH 4/4] fs: add batch and poll flags to the
 uring_cmd_iopoll() handler
Message-ID: <20220904155023.GB10536@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220903165234.210547-5-axboe@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsWy7bCmpm77aZFkg32vVC1W3+1ns3jXeo7F
        gcnj8tlSj8+b5AKYorJtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22V
        XHwCdN0yc4CmKymUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKTAr0ihNzi0vz0vXy
        UkusDA0MjEyBChOyM14+zC14y1xxdfM8tgbGbcxdjJwcEgImEjt+nGYHsYUEdjNKbLpQ2MXI
        BWR/YpRY09nDBOF8ZpQ4ufIrK0zHwQWTGCESuxgl+jb8ZIFwnjFK9Gy6AzaLRUBF4sn72UA7
        ODjYBDQlLkwuBQmLCChI9PxeyQZiMwvISEyecxmsXFggUmJi2yawk3gFdCV+n7/NBmELSpyc
        +YQFxOYUMJO4vWcpWFxUQFniwLbjYNdJCOxil/hy+jcjxHUuEjP7TzNB2MISr45vYYewpSQ+
        v9vLBmEnS1yaeQ6qpkTi8Z6DULa9ROupfmaI4zIktt26DWXzSfT+fsIE8ouEAK9ER5sQRLmi
        xL1JT6GBIi7xcMYSKNtDYsf3LiZIkG5llPh4P3cCo9wsJO/MQrIBwraS6PzQxDoLaAOzgLTE
        8n8cEKamxPpd+gsYWVcxSqYWFOempxabFhjnpZbDYzg5P3cTIzi1aXnvYHz04IPeIUYmDsZD
        jBIczEoivCk7RJKFeFMSK6tSi/Lji0pzUosPMZoCY2cis5Rocj4wueaVxBuaWBqYmJmZmVga
        mxkqifNO0WZMFhJITyxJzU5NLUgtgulj4uCUamAqD13XFO3VrdnE8lqiREc+YIZ82zO7FvUI
        0z3JqTMW1fxluqTV/C3wyr8ZVr2pn7wPdZo8fNAb2Xbqq/7q9TGfir3jAld+Xxd7i3n6jW/f
        FyrysHs79SrMawiZMknhtfv/Ipkw3h2tcpXpvDs2TuJfv8Ba3PQv25THleaXeM5tPjqdc054
        zrJZuxtbBOvWVfkt4Txn+iE+SCHTMWz6vY6kfqvp2a43tnLes35fVcHPJfHx8/mXFpsNy+LP
        3SxfbrHS+kKZp3xq/r9r8Z/3bc6ySU2bu5Ht5ETR7v2XeW7svzF10aF5dxrFnSy/i6pzhj5r
        WnDx3H/ZWsGwo1fENd88k6sN2n32NWvaiTRmLy4lluKMREMt5qLiRACLLHId9gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsWy7bCSnG77aZFkg30L2CxW3+1ns3jXeo7F
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgy7vaeZS2Yz1jxYvIUxgbGJsYuRk4OCQETiYML
        JoHZQgI7GCX+97lBxMUlmq/9YIewhSVW/nsOZHMB1TxhlHh56x4TSIJFQEXiyfvZzF2MHBxs
        ApoSFyaXgoRFBBQken6vZAOxmQVkJCbPuQw2R1ggUmJi2yZmEJtXQFfi9/nbbBAztzJKrL86
        mREiIShxcuYTFohmM4l5mx+CzWcWkJZY/o8DJMwJFL69ZynYfFEBZYkD244zTWAUnIWkexaS
        7lkI3QsYmVcxSqYWFOem5xYbFhjlpZbrFSfmFpfmpesl5+duYgSHq5bWDsY9qz7oHWJk4mA8
        xCjBwawkwpuyQyRZiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkm
        Dk6pBqYuuYsf52+2CWuLtYycmNP+7HxrQGtRwxU1luRHa7iqjgb5fG6+XmceKbbwnYfToS6n
        YOVzNvr5j7J3hE00kS+7MVEkOugdn2/h6St/txmpSE3bLmvT0y1+1tl3ypb6J/9Sj8nd2v0x
        UXbROc2LBltuvo9tdHaK3fOAz6BsQ4NHSJCy40IPG12j22oTo8QNG1/IHvjwuZt9S5IMR6+/
        a3jmtse158u0uPcwtPQ/qLx0i8GMi62tULf/9pdQS9mmD+2BO00FT17Nz9jmzpbE/C3OePvL
        EJar5zsDsqI1z8dYLXeyqmvxYQ9peLrJ6prYxNxwxoTcekOLVbahyu8yv7Gd/eBvvnV39tOm
        A1OUWIozEg21mIuKEwEWT0gqxgIAAA==
X-CMS-MailID: 20220904160007epcas5p3990c896e79dcf26d3fb6d09aab8761e7
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----zvU9B7RYhoxo0n0NtQiMJbd43ri29uhJZ9UzgKuz80Y8n-YR=_483c6_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220903165250epcas5p473918fb3370390f2feb24ad4bff96769
References: <20220903165234.210547-1-axboe@kernel.dk>
        <CGME20220903165250epcas5p473918fb3370390f2feb24ad4bff96769@epcas5p4.samsung.com>
        <20220903165234.210547-5-axboe@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------zvU9B7RYhoxo0n0NtQiMJbd43ri29uhJZ9UzgKuz80Y8n-YR=_483c6_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Sat, Sep 03, 2022 at 10:52:34AM -0600, Jens Axboe wrote:

nvme missing in title i.e. "fs,nvme: xyz".
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>


------zvU9B7RYhoxo0n0NtQiMJbd43ri29uhJZ9UzgKuz80Y8n-YR=_483c6_
Content-Type: text/plain; charset="utf-8"


------zvU9B7RYhoxo0n0NtQiMJbd43ri29uhJZ9UzgKuz80Y8n-YR=_483c6_--
