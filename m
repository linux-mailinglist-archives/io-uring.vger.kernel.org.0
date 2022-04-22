Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A9F50B290
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 10:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445445AbiDVIFT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 04:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445436AbiDVIFS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 04:05:18 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B51527CA
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 01:02:23 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220422080217epoutp02e545d7182d6c0026a7a0f22ae11820b6~oKS1ClSsq3072130721epoutp024
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 08:02:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220422080217epoutp02e545d7182d6c0026a7a0f22ae11820b6~oKS1ClSsq3072130721epoutp024
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1650614537;
        bh=RLzKBvT9SOShPFNH/DQI0qT+9lkcGhnADM9VOdfiQbk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LMAa66TstxesuInV0RFXQZIM0A48qolh/iw1i+2sgXvygwPYZhk/k47jAexs+RRTa
         aFIJoUsq9gr6GUkIes51zr9TxTYpUk6rDz+e5hYNhztX36h0HAATsngDML1F809TvH
         AZvTPNunJGnj+CKtcL8FpWw665ANIazR8wDrkBxA=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220422080217epcas5p2fdc3eecd93a52d41df070b19be07e059~oKS0zVrK_0550305503epcas5p2U;
        Fri, 22 Apr 2022 08:02:17 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Kl6M957rRz4x9Q2; Fri, 22 Apr
        2022 08:02:13 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6C.74.12523.30162626; Fri, 22 Apr 2022 17:02:11 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220422051113epcas5p23ba82e97111807737064be383e593cb2~oH9dgUU_E0135601356epcas5p2a;
        Fri, 22 Apr 2022 05:11:13 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220422051113epsmtrp15ac7dceba40962603b53927e43427799~oH9dfgGBT1466614666epsmtrp1b;
        Fri, 22 Apr 2022 05:11:13 +0000 (GMT)
X-AuditID: b6c32a4a-5b7ff700000030eb-2f-6262610377c1
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        99.7E.03370.1F832626; Fri, 22 Apr 2022 14:11:13 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220422051112epsmtip27c3813dd37648c8e9ac783b16cd59baa~oH9cl1bFi0076900769epsmtip2L;
        Fri, 22 Apr 2022 05:11:12 +0000 (GMT)
Date:   Fri, 22 Apr 2022 10:36:05 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>, kernel-team@fb.com,
        io-uring@vger.kernel.org
Subject: Re: [PATCH v2 00/12] add large CQE support for io-uring
Message-ID: <20220422050605.GA14949@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220422030918.GA20692@test-zns>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgk+LIzCtJLcpLzFFi42LZdlhTU5c5MSnJYOFTC4s5q7YxWqy+289m
        8a71HIvFsb73rBZXXx5gd2D1mNj8jt1j56y77B6Xz5Z6fN4kF8ASlW2TkZqYklqkkJqXnJ+S
        mZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RWSaEsMacUKBSQWFyspG9nU5Rf
        WpKqkJFfXGKrlFqQklNgUqBXnJhbXJqXrpeXWmJlaGBgZApUmJCd0XiyumCKYMXzM7fZGhg3
        8XUxcnBICJhIHLnq1sXIxSEksJtR4snipcwQzidGiUUNrVDOZ0aJzc8/s3QxcoJ1bJnfxQKR
        2MUo0XB9H5TzjFHixM6j7CBVLAKqEi+Pd7KB7GAT0JS4MLkUJCwioCDR83slWJhZoFzi33JH
        kLCwgIPEza97wDp5BXQlJry+ygxhC0qcnPkEbC+ngJ7E5eZ1jCC2qICyxIFtx5lA1koIPGKX
        2LnkHzPEcS4Sl/48ZIewhSVeHd8CZUtJvOxvg7KTJVq3X2aHeL9EYskCdYiwvcTFPX+ZQGxm
        gQyJ28efQJXLSkw9tQ4qzifR+/sJE0ScV2LHPBhbUeLepKesELa4xMMZS6BsD4k5Z5axQoJn
        PbPE5MmP2Ccwys9C8tssJPsgbCuJzg9NrLPAQSQtsfwfB4SpKbF+l/4CRtZVjJKpBcW56anF
        pgVGeanl8NhOzs/dxAhOklpeOxgfPvigd4iRiYPxEKMEB7OSCG/ozPgkId6UxMqq1KL8+KLS
        nNTiQ4ymwJiayCwlmpwPTNN5JfGGJpYGJmZmZiaWxmaGSuK8p9M3JAoJpCeWpGanphakFsH0
        MXFwSjUwrWeqV95gKOe770eZ34GZRX2PU1sT99rdfa5u8SuYqytz+32tIMFPTl4VhkaJwRMv
        dy9+2l95IVygOGKnyTQZNcXy1dpbZmceN1U5dbz5pu9FA9+g84vSYmadMHVgqqy+7HuzxG53
        ioTGt8bJ77Jq/RWb2o4fWrtV6cLaf4crtvXeMLzTnBFWtfrVBME45k3yif3/9etfpFlqpcu9
        ulh/3uH58XduSclnz09ecVrf/+/ViDXldrn2M459lmc0PGWyKObc1ECR9bISJt3R839nMh3k
        XfbXYDsf35qr+/Kacor7Hi26fHdP0gOfggatddGiaj83tG5eH312y6Fq+039S44b/Dv1TD3c
        u6K8O3a+EktxRqKhFnNRcSIAcsduMBsEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsWy7bCSvO5Hi6Qkg9sPuC3mrNrGaLH6bj+b
        xbvWcywWx/res1pcfXmA3YHVY2LzO3aPnbPusntcPlvq8XmTXABLFJdNSmpOZllqkb5dAlfG
        oSN/WAuO8VXcmFzQwPiPu4uRk0NCwERiy/wuli5GLg4hgR2MEnNmPWKHSIhLNF/7AWULS6z8
        95wdougJo8SVbZvYQBIsAqoSL493AtkcHGwCmhIXJpeChEUEFCR6fq8ECzMLlEv8W+4IEhYW
        cJC4+XUP2EheAV2JCa+vMkOMXM8ssXnVPEaIhKDEyZlPWEBsZgEziXmbHzJDzJGWWP6PAyTM
        KaAncbl5HVi5qICyxIFtx5kmMArOQtI9C0n3LITuBYzMqxglUwuKc9Nziw0LjPJSy/WKE3OL
        S/PS9ZLzczcxgsNbS2sH455VH/QOMTJxMB5ilOBgVhLhDZ0ZnyTEm5JYWZValB9fVJqTWnyI
        UZqDRUmc90LXyXghgfTEktTs1NSC1CKYLBMHp1QDk6jNn09XG2f7P3qzQXy525q5Itv+/flh
        0X3oy2eLp8WHea6uOvPH8lbd+ghH1sOOTo/YC5g+MzTatikZPfFb+vbfhA2iywO61u1Z/+9r
        DsOfsyEv93hrupTVW88I0k7bMv3yQ+uj5fXtXlwKhtkBn72iu56tOW74vGHB+lPqN9+f3zb5
        LdN02WDDFOUnbdy8x4w3zDgdsCIow83eWu2s6AKjPZzu+ycY1lpbCMvnmb47sT56UskTq/2r
        We0nRTyXdvRomdmXP8le7g2zcuGuuFWXtzWLCHhdmbd50Y7W2WfPzb3K/GBW6XT2G2Ibu0ts
        Lmj+t1TLu/lBTZyFo7n26SnBLeZdez0jwyX5V3F8iVNiKc5INNRiLipOBABqdeVd3gIAAA==
X-CMS-MailID: 20220422051113epcas5p23ba82e97111807737064be383e593cb2
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----bXrsurgr15J7UbflK9zl7HSxJJpTHU7VPymi_DL2Is9zFqXn=_9eaca_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220421190013epcas5p45c713cd8b430f41a8e33e36c7a21fffa
References: <20220420191451.2904439-1-shr@fb.com>
        <165049508483.559887.15785156729960849643.b4-ty@kernel.dk>
        <5676b135-b159-02c3-21f8-9bf25bd4e2c9@gmail.com>
        <2fa5238c-6617-5053-7661-f2c1a6d70356@fb.com>
        <5008091b-c0c7-548b-bfd4-af33870b8886@gmail.com>
        <CGME20220421190013epcas5p45c713cd8b430f41a8e33e36c7a21fffa@epcas5p4.samsung.com>
        <7dfcf6e8-ac16-5ab1-cb71-6ef81849af82@kernel.dk>
        <20220422030918.GA20692@test-zns>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------bXrsurgr15J7UbflK9zl7HSxJJpTHU7VPymi_DL2Is9zFqXn=_9eaca_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Fri, Apr 22, 2022 at 08:39:18AM +0530, Kanchan Joshi wrote:
>On Thu, Apr 21, 2022 at 12:59:42PM -0600, Jens Axboe wrote:
>>On 4/21/22 12:57 PM, Pavel Begunkov wrote:
>>>On 4/21/22 19:49, Stefan Roesch wrote:
>>>>On 4/21/22 11:42 AM, Pavel Begunkov wrote:
>>>>>On 4/20/22 23:51, Jens Axboe wrote:
>>>>>>On Wed, 20 Apr 2022 12:14:39 -0700, Stefan Roesch wrote:
>>>>>>>This adds the large CQE support for io-uring. Large CQE's are 16 bytes longer.
>>>>>>>To support the longer CQE's the allocation part is changed and when the CQE is
>>>>>>>accessed.
>>>>>>>
>>>>>>>The allocation of the large CQE's is twice as big, so the allocation size is
>>>>>>>doubled. The ring size calculation needs to take this into account.
>>>>>
>>>>>I'm missing something here, do we have a user for it apart
>>>>>from no-op requests?
>>>>>
>>>>
>>>>Pavel, what started this work is the patch series "io_uring passthru over nvme" from samsung.
>>>>(https://lore.kernel.org/io-uring/20220308152105.309618-1-joshi.k@samsung.com/)
>>>>
>>>>They will use the large SQE and CQE support.
>>>
>>>I see, thanks for clarifying. I saw it used in passthrough
>>>patches, but it only got me more confused why it's applied
>>>aforehand separately from the io_uring-cmd and passthrough
>>
>>It's just applied to a branch so the passthrough folks have something to
>>base on, io_uring-big-sqe. It's not queued for 5.19 or anything like
>>that yet.
>>
>Thanks for putting this up.
>I am bit confused whether these (big-cqe) and big-sqe patches should
>continue be sent (to nvme list too) as part of next
>uring-cmd/passthrough series?
>
>And does it make sense to squash somes patches of this series; at
>high-level there is 32b-CQE support, and no-op support.

Maybe as part of v3, as there seems some scope for that (I made comments
at respective places).

------bXrsurgr15J7UbflK9zl7HSxJJpTHU7VPymi_DL2Is9zFqXn=_9eaca_
Content-Type: text/plain; charset="utf-8"


------bXrsurgr15J7UbflK9zl7HSxJJpTHU7VPymi_DL2Is9zFqXn=_9eaca_--
