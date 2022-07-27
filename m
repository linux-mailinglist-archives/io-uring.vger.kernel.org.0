Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6331D5832DC
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 21:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbiG0TF4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 15:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233657AbiG0TFb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 15:05:31 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678EA26CD
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 11:33:23 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220727183318epoutp0267986f01045afc4a862d27db2d313e2c~Fw1LRe5J02295422954epoutp027
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 18:33:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220727183318epoutp0267986f01045afc4a862d27db2d313e2c~Fw1LRe5J02295422954epoutp027
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1658946798;
        bh=RS48UBGGGvljPH7h1+NBuqS/5YoqaDr/bIkQd5s5U7U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pVcJAqzqV7gpwB+4t1LZonIfgFdJSWKSqjL45/nF8UzA08rQtaivJ7C+YyRNeRQ32
         hUi6ATbhakrZYLHyrJJFnbV5lt3NW3JDZrjT6vWW422oTTkI+JXQMzjc9Jro/prxZv
         YBGU486HqwjWNsc27L9sJ8CgSJn9Y+nF8e5h8Z7w=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220727183316epcas5p4f7eccff6f062601e185cfc7fcc8c1324~Fw1KGslWR1204012040epcas5p4s;
        Wed, 27 Jul 2022 18:33:16 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4LtMpy2GF7z4x9Pp; Wed, 27 Jul
        2022 18:33:14 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D2.A0.09662.7D481E26; Thu, 28 Jul 2022 03:32:55 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220727183254epcas5p2d51ddf874f460d40577651de9563cc78~Fw01LaAlI3021630216epcas5p2V;
        Wed, 27 Jul 2022 18:32:54 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220727183254epsmtrp170fd873d0d978899e0a68b045f00534f~Fw01KyJ_p2382523825epsmtrp1E;
        Wed, 27 Jul 2022 18:32:54 +0000 (GMT)
X-AuditID: b6c32a49-86fff700000025be-e9-62e184d77480
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        78.0A.08905.6D481E26; Thu, 28 Jul 2022 03:32:54 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220727183253epsmtip1995a721c00814967d44d0937706dee41~Fw00lsn4Z1524915249epsmtip1y;
        Wed, 27 Jul 2022 18:32:53 +0000 (GMT)
Date:   Wed, 27 Jul 2022 23:57:28 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Ankit Kumar <ankit.kumar@samsung.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: Re: [PATCH liburing v2 0/5] Add basic test for nvme uring
 passthrough commands
Message-ID: <20220727182728.GB13647@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220726105230.12025-1-ankit.kumar@samsung.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNKsWRmVeSWpSXmKPExsWy7bCmuu71lodJBt/vqVmsufKb3WL13X42
        i3et51gcmD0uny316NuyitHj8ya5AOaobJuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11D
        SwtzJYW8xNxUWyUXnwBdt8wcoD1KCmWJOaVAoYDE4mIlfTubovzSklSFjPziElul1IKUnAKT
        Ar3ixNzi0rx0vbzUEitDAwMjU6DChOyMiWdvsxbs467YdXkaSwPjcc4uRk4OCQETiS9P97N1
        MXJxCAnsZpTY86+TEcL5xChx5fVWNpAqIYFvjBKru3lhOrpu7mWFKNrLKDFz21wWCOcZo8Sh
        jVfZQapYBFQlTm9qZepi5OBgE9CUuDC5FMQUATLnfWABqWAW0JVYvucxmC0sECnRfWY2O0gJ
        L1D87RwpkDCvgKDEyZlPwEo4BWwlml5OYQWxRQWUJQ5sO84EslVC4BS7xPl7O1kgbnOROLti
        GxuELSzx6vgWdghbSuJlfxuUnSxxaeY5Jgi7ROLxnoNQtr1E66l+ZpAbmAUyJFZ32EKcySfR
        +/sJ2CMSArwSHW1CENWKEvcmPWWFsMUlHs5YAmV7SMz63skMCZAJwNBZcJFxAqPcLCTvzELY
        MAtsg5VE54cmVoiwtMTyfxwQpqbE+l36CxhZVzFKphYU56anFpsWGOallsPjNzk/dxMjONVp
        ee5gvPvgg94hRiYOxkOMEhzMSiK8CdH3k4R4UxIrq1KL8uOLSnNSiw8xmgKjZiKzlGhyPjDZ
        5pXEG5pYGpiYmZmZWBqbGSqJ83pd3ZQkJJCeWJKanZpakFoE08fEwSnVwGR1LGrvmvBVjk0f
        ldbqya9z0hKbznpl10qj27klNWFOvu2LDCf6rP1xkM96lmhq6P9TwsxfLEsmmF6XDJRvKPL6
        zvCk/7Lpncf5LsWX2XkFt0q7W2b8TTDz4OI73nS4YYV12RXVJOssl/3Lj3VKzvDVrfuu7Bpg
        vpLJy/ZL/V6OWZN2TrR5fvQYEz97X18P13ob17KScmc1zirxjJ0Xp24LSbWNXT37f9yZ5Y+O
        Ll37XMr4u7iZ4c2YSTLSZTbbFFPXPTy83X1FgDdzycRI7r35OVa3vKOach1WR6e4KzZOjEip
        ldz77RSzpEuMS2W64a5Lmts8fu6SepxiF8+W5HLoahFDm/2stbciph5XYinOSDTUYi4qTgQA
        8Kzg0P4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsWy7bCSnO61lodJBtOnSlmsufKb3WL13X42
        i3et51gcmD0uny316NuyitHj8ya5AOYoLpuU1JzMstQifbsErozOXY/ZCj5wVCxpfs/WwDiZ
        vYuRk0NCwESi6+Ze1i5GLg4hgd2MEpPmb2WFSIhLNF/7AVUkLLHy33N2iKInjBL/On6xgSRY
        BFQlTm9qZepi5OBgE9CUuDC5FMQUATLnfWABqWAW0JVYvucxmC0sECnRfWY2O0gJL1D87Rwp
        iIkTGCXW3D8JVsMrIChxcuYTqF4ziXmbHzKD1DMLSEss/8cBEuYUsJVoejkF7EpRAWWJA9uO
        M01gFJyFpHsWku5ZCN0LGJlXMUqmFhTnpucWGxYY5qWW6xUn5haX5qXrJefnbmIEB7CW5g7G
        7as+6B1iZOJgPMQowcGsJMKbEH0/SYg3JbGyKrUoP76oNCe1+BCjNAeLkjjvha6T8UIC6Ykl
        qdmpqQWpRTBZJg5OqQamy78FJu+zyAoRdOpwddKdvGbH3Y2b99mdedjy6lnZjfUbtDsf7Fwg
        7rM+2cb34Lf+zI2GV/bnOKfcq/A8qeG0i/WUacW9TemNDKt/bHQ0OzirOGfZFq5dop+bs9Vt
        7i88u+VB0/Z/26WqPj/wzu0um3CzOpChKndL1S+lsxk8cwOWasa0a639ppvj//aFasCl1oNe
        fjmZovI2S+KSc0yfst83Ou1uXvhtGeeEz42NlnJrrrvueLN51goh7SXK02obbtcdLRBfq9a8
        rj3K1kD6Pl87g738ixma9Z4qjxx/L1CJiIqUWPmptUxonePpmS+2Sh1Oub5857s04eTCh5Gf
        GTfHHLHP3HRy6c2Cs9PUlFiKMxINtZiLihMBD5yVHc8CAAA=
X-CMS-MailID: 20220727183254epcas5p2d51ddf874f460d40577651de9563cc78
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----vB7n7NJswZTNf_AiIrah4kmnk8PbkRxRpEeyoX_UVTG8Sgsz=_211d1_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220726105812epcas5p4a2946262206548f67e238845e23a122c
References: <CGME20220726105812epcas5p4a2946262206548f67e238845e23a122c@epcas5p4.samsung.com>
        <20220726105230.12025-1-ankit.kumar@samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------vB7n7NJswZTNf_AiIrah4kmnk8PbkRxRpEeyoX_UVTG8Sgsz=_211d1_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Tue, Jul 26, 2022 at 04:22:25PM +0530, Ankit Kumar wrote:
>Hi Jens,
>
>This patchset adds a way to test NVMe uring passthrough commands with
>nvme-ns character device. The uring passthrough was introduced with 5.19
>io_uring.
>
>To send nvme uring passthrough commands we require helpers to fetch NVMe
>char device (/dev/ngXnY) specific fields such as namespace id, lba size etc.
>
>How to run:
>./test/io_uring_passthrough.t /dev/ng0n1
>
>The test covers write/read with verify for sqthread poll, vectored / nonvectored
>and fixed IO buffers, which can be extended in future. As of now iopoll is not
>supported for passthrough commands, there is a test for such case.

./test/io_uring_passthrough.t /dev/ng0n1
doesn't support polled IO                 

Not sure if iopoll test is bit premature, as above message will keep
coming until this is wired up in kernel-side.
Perhaps this is fine to test as in initial stages graceful no-support
error code was not coming from kernel. The above confirms that
kernel bails out fine now.

Things ran fine for me, so
Tested-by: Kanchan Joshi <joshi.k@samsung.com>

------vB7n7NJswZTNf_AiIrah4kmnk8PbkRxRpEeyoX_UVTG8Sgsz=_211d1_
Content-Type: text/plain; charset="utf-8"


------vB7n7NJswZTNf_AiIrah4kmnk8PbkRxRpEeyoX_UVTG8Sgsz=_211d1_--
