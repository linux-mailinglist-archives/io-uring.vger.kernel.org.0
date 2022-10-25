Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A6E60CD9F
	for <lists+io-uring@lfdr.de>; Tue, 25 Oct 2022 15:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbiJYNgj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Oct 2022 09:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbiJYNgi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Oct 2022 09:36:38 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7359E19189C
        for <io-uring@vger.kernel.org>; Tue, 25 Oct 2022 06:36:28 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20221025133622epoutp04a2d5d1a07e4358e9dfe98e7b44b14ece~hU1nBfthf0122101221epoutp044
        for <io-uring@vger.kernel.org>; Tue, 25 Oct 2022 13:36:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20221025133622epoutp04a2d5d1a07e4358e9dfe98e7b44b14ece~hU1nBfthf0122101221epoutp044
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1666704982;
        bh=hHrkOvG8gMVYy/3XRtCzDqEgnAHiaQEwlSLZSqaHtPk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RFdfd9muUU7GGXHED+ArS92xXtzFgnaTQbEHAsN91c7zVjhVznKjQqRW9rMVPr95A
         SqL1X0d+FzM7m9lB/rich0x6feQjmN6KEhzeRTNHsqXw54VolfSHbV0ucFPCW6p1a9
         YrycpVcOq6IOgb3iVF2+pTPcTo37QWHNoahJ8N8g=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20221025133620epcas5p1f8a00400188a1db273131acab4c4d1c8~hU1mA1v172679426794epcas5p1S;
        Tue, 25 Oct 2022 13:36:20 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4MxXyp3mrDz4x9Pp; Tue, 25 Oct
        2022 13:36:18 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BB.CE.01710.256E7536; Tue, 25 Oct 2022 22:36:18 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20221025133617epcas5p112ef9cbf012feea682463c1d85723514~hU1ifCjm62918829188epcas5p1I;
        Tue, 25 Oct 2022 13:36:17 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221025133617epsmtrp2c87b61a5b6d95335fbb7bbdadd920bfa~hU1ieYwF71177211772epsmtrp2-;
        Tue, 25 Oct 2022 13:36:17 +0000 (GMT)
X-AuditID: b6c32a49-c9ffa700000006ae-9b-6357e65256c7
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        94.82.18644.156E7536; Tue, 25 Oct 2022 22:36:17 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20221025133616epsmtip1d00aba8f6769151a5699adbcee17a487~hU1hfRd5c0482804828epsmtip1q;
        Tue, 25 Oct 2022 13:36:15 +0000 (GMT)
Date:   Tue, 25 Oct 2022 18:55:02 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH for-next v3 0/3] implement pcpu bio caching for IRQ I/O
Message-ID: <20221025132502.GA31530@test-zns>
MIME-Version: 1.0
In-Reply-To: <cover.1666347703.git.asml.silence@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42LZdlhTQzfoWXiyweJVkhZzVm1jtFh9t5/N
        YuXqo0wW71rPsVjsvaVtcXnXHDYHNo+ds+6ye1w+W+qx+2YDm8fnTXIBLFHZNhmpiSmpRQqp
        ecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAq5UUyhJzSoFCAYnFxUr6
        djZF+aUlqQoZ+cUltkqpBSk5BSYFesWJucWleel6eaklVoYGBkamQIUJ2RlfLz1jK/gjVPGq
        rZOpgfERfxcjJ4eEgInEnod32LsYuTiEBHYzShx4fIARwvnEKDHx0hsWCOczUObhQlaYlv0/
        d7FBJHYxSnR0t0I5zxglVhyYDFTFwcEioCqx7mA6iMkmoClxYXIpSK+IgLbE6+uHwNYxC8xk
        lDi9cBobSEJYwFvi+frZzCD1vAK6Em97gkDCvAKCEidnPmEBsTkFrCQWH1rGBGKLCihLHNh2
        nAlkjoTAR3aJazN+M0Ec5yKxdPY2RghbWOLV8S3sELaUxOd3e9kg7GSJSzPPQdWXSDzecxDK
        tpdoPdXPDGIzC2RIbD18Csrmk+j9/YQJ5DYJAV6JjjYhiHJFiXuTnkLDRFzi4YwlULaHxJWT
        k1ghQdLLKNH1u4lxAqPcLCT/zEKyAsK2kuj80MQ6C2gFs4C0xPJ/HBCmpsT6XfoLGFlXMUqm
        FhTnpqcWmxYY5qWWw+M4OT93EyM4MWp57mC8++CD3iFGJg7GQ4wSHMxKIrxnb4QnC/GmJFZW
        pRblxxeV5qQWH2I0BcbORGYp0eR8YGrOK4k3NLE0MDEzMzOxNDYzVBLnXTxDK1lIID2xJDU7
        NbUgtQimj4mDU6qBSeP/n7RV5epqV6bt+PaC8eDVKtb49Pui23a+2/Z1suokeRPeLueX/k+2
        bzj+5ruH55KMZUcTt2//zcje1ps7p7uCrfFrV65MRWr0Vv2eQ50fhJuZHNa9br2dO2txf+a5
        8vDvHK+SK/Y0WC0OYLt2eskrHsctRXnei0OVgv1mxCzxN/jy2eXhWrmym6cfu+zYfdlLdo+U
        ppDOYmGm3tioO8+nWLoVXH5cYrW+N0fKZIODdmPaxvSQq8d3bGYPr1uxSnh/vNwG3j+Ndo7T
        U4RzhGwmxvyp//roz9xHS2ZO8X26vGJXZ/szjbdcRqJv1luzlOpsu//qcursd++cT3JV/V54
        ceIF40VJPccOf2JL2a7EUpyRaKjFXFScCACCYaW0FQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsWy7bCSnG7gs/Bkg3W7WCzmrNrGaLH6bj+b
        xcrVR5ks3rWeY7HYe0vb4vKuOWwObB47Z91l97h8ttRj980GNo/Pm+QCWKK4bFJSczLLUov0
        7RK4Ml42XmQpWCdQcaXhM3sD4zreLkZODgkBE4n9P3exdTFycQgJ7GCUaDuwkRUiIS7RfO0H
        O4QtLLHy33MwW0jgCaPE1b/BXYwcHCwCqhLrDqaDmGwCmhIXJpeCVIgIaEu8vn6IHWQks8BM
        RoldHb+ZQBLCAt4Sz9fPZgap5xXQlXjbEwSxtpdRov/9BGaQGl4BQYmTM5+wgNjMAmYS8zY/
        BKtnFpCWWP6PAyTMKWAlsfjQMrCRogLKEge2HWeawCg4C0n3LCTdsxC6FzAyr2KUTC0ozk3P
        LTYsMMpLLdcrTswtLs1L10vOz93ECA5zLa0djHtWfdA7xMjEwXiIUYKDWUmE9+yN8GQh3pTE
        yqrUovz4otKc1OJDjNIcLErivBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUamCIr1O7slZqi+cdo
        f+ZivoyJtpFNuhdK7p3eILC51z3fW95tFf+D94z/9vNr1pwN7l1dYKLfYeyx3jlz8XWb+jU9
        M/lUC43c62ZYtkg9sG376cP+X5Hxxrntq5adCV3ybdqmjU+lDbZztNy4r6AkGx3qXy+ScPTU
        rplfxd503TLpC6iRvDdx19Oj7HO/Hv+o5qHPObNJToSx/WHUic05eStmdHO5m0xg6CrKf/hQ
        qCKotKFM4ujE8we5Htwz039Xuvo+I/OPo5tvbbbN5ftw5jRHrdjSx2zzVmwR4fx7fJ+tZe7T
        ysDn77mcfnOdyv9ifS74W7H26728kXmWv+5aWC6/p/OsQEj8f/P1Tx9Zm5VYijMSDbWYi4oT
        Aehv5KPiAgAA
X-CMS-MailID: 20221025133617epcas5p112ef9cbf012feea682463c1d85723514
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----Bhr1nD2Bk2LUmll8nJ7f302jVE_Mn2nZjP.Hr2fL4.Csl-BK=_90b94_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221021103627epcas5p34eaaf3c8161bbee33160cce8b58efd5f
References: <CGME20221021103627epcas5p34eaaf3c8161bbee33160cce8b58efd5f@epcas5p3.samsung.com>
        <cover.1666347703.git.asml.silence@gmail.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------Bhr1nD2Bk2LUmll8nJ7f302jVE_Mn2nZjP.Hr2fL4.Csl-BK=_90b94_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Fri, Oct 21, 2022 at 11:34:04AM +0100, Pavel Begunkov wrote:
>Add bio pcpu caching for normal / IRQ-driven I/O extending REQ_ALLOC_CACHE,
>which was limited to iopoll. 

So below comment (stating process context as MUST) can also be removed as
part of this series now?

 495  * If REQ_ALLOC_CACHE is set, the final put of the bio MUST be done from process
 496  * context, not hard/soft IRQ.
 497  *
 498  * Returns: Pointer to new bio on success, NULL on failure.
 499  */
 500 struct bio *bio_alloc_bioset(struct block_device *bdev, unsigned short nr_vecs,
 501                              blk_opf_t opf, gfp_t gfp_mask,
 502                              struct bio_set *bs)
 503 {

>t/io_uring with an Optane SSD setup showed +7%
>for batches of 32 requests and +4.3% for batches of 8.
>
>IRQ, 128/32/32, cache off
>IOPS=59.08M, BW=28.84GiB/s, IOS/call=31/31
>IOPS=59.30M, BW=28.96GiB/s, IOS/call=32/32
>IOPS=59.97M, BW=29.28GiB/s, IOS/call=31/31
>IOPS=59.92M, BW=29.26GiB/s, IOS/call=32/32
>IOPS=59.81M, BW=29.20GiB/s, IOS/call=32/31
>
>IRQ, 128/32/32, cache on
>IOPS=64.05M, BW=31.27GiB/s, IOS/call=32/31
>IOPS=64.22M, BW=31.36GiB/s, IOS/call=32/32
>IOPS=64.04M, BW=31.27GiB/s, IOS/call=31/31
>IOPS=63.16M, BW=30.84GiB/s, IOS/call=32/32
>
>IRQ, 32/8/8, cache off
>IOPS=50.60M, BW=24.71GiB/s, IOS/call=7/8
>IOPS=50.22M, BW=24.52GiB/s, IOS/call=8/7
>IOPS=49.54M, BW=24.19GiB/s, IOS/call=8/8
>IOPS=50.07M, BW=24.45GiB/s, IOS/call=7/7
>IOPS=50.46M, BW=24.64GiB/s, IOS/call=8/8
>
>IRQ, 32/8/8, cache on
>IOPS=51.39M, BW=25.09GiB/s, IOS/call=8/7
>IOPS=52.52M, BW=25.64GiB/s, IOS/call=7/8
>IOPS=52.57M, BW=25.67GiB/s, IOS/call=8/8
>IOPS=52.58M, BW=25.67GiB/s, IOS/call=8/7
>IOPS=52.61M, BW=25.69GiB/s, IOS/call=8/8
>
>The next step will be turning it on for other users, hopefully by default.
>The only restriction we currently have is that the allocations can't be
>done from non-irq context and so needs auditing.

Isn't allocation (of bio) happening in non-irq context already?

And
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>


------Bhr1nD2Bk2LUmll8nJ7f302jVE_Mn2nZjP.Hr2fL4.Csl-BK=_90b94_
Content-Type: text/plain; charset="utf-8"


------Bhr1nD2Bk2LUmll8nJ7f302jVE_Mn2nZjP.Hr2fL4.Csl-BK=_90b94_--
