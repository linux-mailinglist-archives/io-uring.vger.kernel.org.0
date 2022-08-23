Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB6259EB1C
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 20:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiHWSfM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 14:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232414AbiHWSer (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 14:34:47 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4521BC3F6B
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 09:57:02 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220823165700epoutp04ccfaf724265402fec86990cc64af3211~OB7zkcePc0860208602epoutp04S
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 16:57:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220823165700epoutp04ccfaf724265402fec86990cc64af3211~OB7zkcePc0860208602epoutp04S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1661273820;
        bh=eWiU3m0OO+kqfJpDO7JCgDhpwj9yKnUjfIO/EECsvk8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bzQGtxBLbPQppbWDJRot/5fDy0O87JvbS4c1g/LlBqEYjqLl/8oqFJuHED8fTVX+f
         Bw+abxN8mo1CZk57aME4THo0lbQ2DwqffEGx4RYwD1UHZ2USosBVqFPjvncNZO0Xbt
         7FQU82KE6ilTESMxs2KV61fS5akDPDIwDrLySB6M=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220823165659epcas5p11fb3555a30cd0e422ae1ea5dbd97a9a0~OB7y3HJ9v0627606276epcas5p1C;
        Tue, 23 Aug 2022 16:56:59 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MBwPQ16WQz4x9Pt; Tue, 23 Aug
        2022 16:56:58 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        DA.3C.15517.9D605036; Wed, 24 Aug 2022 01:56:57 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220823165657epcas5p3c04fed1c8a3bcb4abc206fa83f1af270~OB7xCjalb2604826048epcas5p3o;
        Tue, 23 Aug 2022 16:56:57 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220823165657epsmtrp153e406252ebb137b7db7467eecfc9939~OB7xB2kTq0748607486epsmtrp1H;
        Tue, 23 Aug 2022 16:56:57 +0000 (GMT)
X-AuditID: b6c32a4b-e21ff70000003c9d-13-630506d9330f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        6C.63.18644.9D605036; Wed, 24 Aug 2022 01:56:57 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220823165656epsmtip21ddd1f516a0c01c9ba389eef6ad18f33~OB7wVQPoo1397013970epsmtip2p;
        Tue, 23 Aug 2022 16:56:56 +0000 (GMT)
Date:   Tue, 23 Aug 2022 22:17:16 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        anuj20.g@samsung.com
Subject: Re: [PATCH] io_uring: fix submission-failure handling for uring-cmd
Message-ID: <20220823164716.GA3046@test-zns>
MIME-Version: 1.0
In-Reply-To: <ceaf9d3f-7588-a64c-0661-79133222f443@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsWy7bCmlu5NNtZkg+6DNhZNE/4yW8xZtY3R
        YvXdfjaLd63nWBxYPHbOusvucflsqUffllWMHp83yQWwRGXbZKQmpqQWKaTmJeenZOal2yp5
        B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gBtVFIoS8wpBQoFJBYXK+nb2RTll5akKmTk
        F5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZyxYf4ytYAlnRd/0ZpYGxtfsXYyc
        HBICJhLbdq1k7GLk4hAS2M0oMfvlBkaQhJDAJyDnfQRE4jOjxMoTa4A6OMA6Hr9gh4jvYpTo
        vPmdCcJ5xiixasYjVpBuFgFVib0rNrCCNLAJaEpcmFwKEhYRUJDo+b2SDcRmFvCSeP95BTOI
        LSzgI/Gr6y0LiM0roCMxY/lyZghbUOLkzCdgcU4BW4mDn66AHScqoCxxYNtxsL0SArfYJRZe
        /AB1nIvEpQu5EJ8JS7w6vgXqSymJl/1tUHayxKWZ55gg7BKJx3sOQtn2Eq2n+pkhbsuQmN96
        hQnC5pPo/f2ECWI8r0RHmxBEuaLEvUlPWSFscYmHM5ZA2R4SPbM2MkOCZB+jxM/Z+5knMMrN
        QvLOLCQrIGwric4PTayzgFYwC0hLLP/HAWFqSqzfpb+AkXUVo2RqQXFuemqxaYFxXmo5PIaT
        83M3MYJToJb3DsZHDz7oHWJk4mA8xCjBwawkwmt1jCVZiDclsbIqtSg/vqg0J7X4EKMpMHYm
        MkuJJucDk3BeSbyhiaWBiZmZmYmlsZmhkjjvFG3GZCGB9MSS1OzU1ILUIpg+Jg5OqQam08tr
        pjTOmqCxx+T00kWfo+c4HojmKF6etElVf3tVuVeJzeun/Y+WCx+a9n7uS0ZZ6elma1hF03zY
        fpoZ1S0x4XdIrXOVU/x8T+aZ0KOms1dmxXJUJkSqvU/dKWL0fV/EjMVdq7KOvPHaU8vxhWOb
        kNnNNXOPW6o+VY9VPXI7935h/o71HTc852xcq9nH0bvbLYjL5/q2N85H6/z7jTLs+vxc9yXt
        CuXfVH3xA1t7EKOKnYr65WktL67dVmIxzfd70j6D49YVg5VCl0/aamxUMrM5psHZWeK7viDq
        Qqfd9Wuqd6a/fu9+ycgjxf1Dl5pFz6/T0z1aT5i9ZTpX/uOZe/FEC3PfjOuXxTXEnTqVWIoz
        Eg21mIuKEwGhIEEpCgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsWy7bCSvO5NNtZkg5131SyaJvxltpizahuj
        xeq7/WwW71rPsTiweOycdZfd4/LZUo++LasYPT5vkgtgieKySUnNySxLLdK3S+DK6Fl4hqng
        GltFy4cJLA2M21m7GDk4JARMJB6/YO9i5OIQEtjBKLH42AumLkZOoLi4RPO1H+wQtrDEyn/P
        oYqeMEr8m3OQDSTBIqAqsXfFBrBBbAKaEhcml4KERQQUJHp+rwQrYRbwknj/eQUziC0s4CPx
        q+stC4jNK6AjMWP5cmaImfsYJZ5s/QmVEJQ4OfMJC0SzmcS8zQ+ZQeYzC0hLLP/HARLmFLCV
        OPjpCiOILSqgLHFg23GmCYyCs5B0z0LSPQuhewEj8ypGydSC4tz03GLDAqO81HK94sTc4tK8
        dL3k/NxNjOCw1tLawbhn1Qe9Q4xMHIyHGCU4mJVEeK2OsSQL8aYkVlalFuXHF5XmpBYfYpTm
        YFES573QdTJeSCA9sSQ1OzW1ILUIJsvEwSnVwCSiFayp+SlorrBHpmTqr+tXK/bIruc0dlOz
        SCn6/qkgfM583zqOzPWXU67tfugWZBiyu6/06KL9Br4+Jw2LKwM+ytx7kJ2edPz8vtCUtMna
        Nrvzej/V7Mk9vtwybuP9iRzc66KrHgfvnb+kO1EjKjLh+ck3ZjonWD47/2Qzr2WUWJ11Ju7c
        tLwFMw36lNOUZ/Nsvu38tbFS6k+q6m993h1G92fV7bG2n7BfpE2n++Tq4h73zQxW33e++3OW
        603o7a0ftJgtfl6+d2e52MxYx3v8r3+aafWrXnB5pX1kPVPN0U9tFU4f15xcwtvHf8H1up6X
        41fd0kN/ayTsZvo+WWc5+ZqHy2rvG9f1RWzkRZVYijMSDbWYi4oTAYYZf0faAgAA
X-CMS-MailID: 20220823165657epcas5p3c04fed1c8a3bcb4abc206fa83f1af270
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----W1bEPTvsorsTcy9-0QGogbD0KLvGmowfrJUeCoG.R5S2F01G=_a00ee_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220823152018epcas5p3141ae99b73ba495f1501723d7834ee32
References: <CGME20220823152018epcas5p3141ae99b73ba495f1501723d7834ee32@epcas5p3.samsung.com>
        <20220823151022.3136-1-joshi.k@samsung.com>
        <ceaf9d3f-7588-a64c-0661-79133222f443@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------W1bEPTvsorsTcy9-0QGogbD0KLvGmowfrJUeCoG.R5S2F01G=_a00ee_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Tue, Aug 23, 2022 at 09:47:39AM -0600, Jens Axboe wrote:
>On 8/23/22 9:10 AM, Kanchan Joshi wrote:
>> If ->uring_cmd returned an error value different from -EAGAIN or
>> -EIOCBQUEUED, it gets overridden with IOU_OK. This invites trouble
>> as caller (io_uring core code) handles IOU_OK differently than other
>> error codes.
>> Fix this by returning the actual error code.
>
>Not sure if this is strictly needed, as the cqe error is set just
>fine. But I guess some places also check return value of the issue
>path.

So I was testing iopoll support and ran into this issue - submission
failed (expected one), control came back to this point, error code
got converted to IOU_OK, and it started polling endlessly for a command
that never got submitted.
io_issue_sqe continued to invoke io_iopoll_req_issued() rather than
bailing out.

------W1bEPTvsorsTcy9-0QGogbD0KLvGmowfrJUeCoG.R5S2F01G=_a00ee_
Content-Type: text/plain; charset="utf-8"


------W1bEPTvsorsTcy9-0QGogbD0KLvGmowfrJUeCoG.R5S2F01G=_a00ee_--
