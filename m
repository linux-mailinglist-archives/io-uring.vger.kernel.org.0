Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955BC6B1FFA
	for <lists+io-uring@lfdr.de>; Thu,  9 Mar 2023 10:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjCIJ2U (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Mar 2023 04:28:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjCIJ2S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Mar 2023 04:28:18 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4D422DCD
        for <io-uring@vger.kernel.org>; Thu,  9 Mar 2023 01:28:13 -0800 (PST)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230309092811epoutp011ba5996d97c25587bfa3788b2f75dc2a~KtidVR4Gu1750117501epoutp01j
        for <io-uring@vger.kernel.org>; Thu,  9 Mar 2023 09:28:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230309092811epoutp011ba5996d97c25587bfa3788b2f75dc2a~KtidVR4Gu1750117501epoutp01j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1678354091;
        bh=4cX7o1PwKJ0Kt0T/F93C++vPRlszy1wa4yf7usQy2GA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jIIm4sKRMNUsNKq3Dv9lJEjytL+rWdxHpy/B276DLbKN3Fhy0IHFkwgmSg54BUQXh
         +DX4YNEBd0RKFvSqYKAzffRp1h5pJzAtPZ5A0L0IhdZypQ1+hZ/IH2VIDbrxKcnYMa
         oBaFSd1cLJ93Y+wLMII7u1z7YDZgtwKDU2h//Jro=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20230309092810epcas5p1921fce2872ad664b35627a418e29177d~KtidF9ECd1920219202epcas5p1z;
        Thu,  9 Mar 2023 09:28:10 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4PXP494WC2z4x9Q1; Thu,  9 Mar
        2023 09:28:09 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AE.5C.55678.8A6A9046; Thu,  9 Mar 2023 18:28:08 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20230309092808epcas5p498d0c428279b1f03bfddf233eb80bf0f~Ktiar9g5q1940819408epcas5p4L;
        Thu,  9 Mar 2023 09:28:08 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230309092808epsmtrp2a4f319e7ba575c02ef3a1317ada0c9f0~KtiarX_Wf2920729207epsmtrp2Q;
        Thu,  9 Mar 2023 09:28:08 +0000 (GMT)
X-AuditID: b6c32a4a-6a3ff7000000d97e-26-6409a6a81750
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        20.95.31821.8A6A9046; Thu,  9 Mar 2023 18:28:08 +0900 (KST)
Received: from green5 (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20230309092807epsmtip13855262b8588314412641c814ce2a373~KtiaI1N5T0351003510epsmtip1-;
        Thu,  9 Mar 2023 09:28:07 +0000 (GMT)
Date:   Thu, 9 Mar 2023 14:57:32 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring/uring_cmd: ensure that device supports IOPOLL
Message-ID: <20230309092732.GA14977@green5>
MIME-Version: 1.0
In-Reply-To: <2349df76-0acb-0a56-bda1-2cb05aa55151@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCKsWRmVeSWpSXmKPExsWy7bCmpu6KZZwpBrNmWlusvtvPZvGu9RyL
        A5PH5bOlHp83yQUwRWXbZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoq
        ufgE6Lpl5gBNV1IoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevl
        pZZYGRoYGJkCFSZkZ3zs/cxYsJS14ujyi0wNjKdZuhg5OCQETCSOfS/rYuTiEBLYzSjR8fsi
        C4TziVHiwqMZjBDOZ0aJDR0b2boYOcE6Ph+Zzg5iCwnsYpRYe48VougJo8TR7R+ZQRIsAioS
        SybvYgNZwSagKXFhcilIWERAQaLn90qwOcwC6hK3pxwFs4UFvCXenbgGZvMKaEt8nf8FyhaU
        ODnzCQuIzSlgK/Hzy05WEFtUQFniwLbjTCB7JQT2sUss3j+bFeI4F4nNHy9CHSos8er4FnYI
        W0ri87u9UPFkiUszzzFB2CUSj/cchLLtJVpP9TNDHJchcfjKDnYIm0+i9/cTJkhw8Up0tAlB
        lCtK3Jv0FGqtuMTDGUugbA+JW8s3Q8NkAqPE4cftbBMY5WYh+WcWkhUQtpVE54cm1llAK5gF
        pCWW/+OAMDUl1u/SX8DIuopRMrWgODc9tdi0wCgvtRwexcn5uZsYwclNy2sH48MHH/QOMTJx
        MB5ilOBgVhLh/S7FkSLEm5JYWZValB9fVJqTWnyI0RQYPROZpUST84HpNa8k3tDE0sDEzMzM
        xNLYzFBJnFfd9mSykEB6YklqdmpqQWoRTB8TB6dUA1NMVq7gjVl7zle97XS0XHfl989ktcsB
        84MdN5We1et5GTxr3rpGsw2z79dyHZT1MWo0OfO8dce7faKKUtM8n8VMjRMSbXb9ypv2jf2i
        ndkssY9Levd9CwtPCsqr26vOpc6UUzl5lsUMkbDictmDpmtXXL16TtDVNOmDO6tProDOMdOn
        hS1uQfEKVTnm+8U9pt27/6Ml4VPVGaPlWvftp6u+1Pq+Inxu6uPLez84SnSZxrFe6XDkfJqX
        PuVKhF7UB49Lgqk/mlavPXbQZv5foYcdZnMypnPJrv8Q+Fh64ozWS7kvhbKnLknvjpyo/OlQ
        1u6sHWsWmtqoJRV8eVGl8+hPl4qrzOYFhnFhwW0t65VYijMSDbWYi4oTARN67tn3AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsWy7bCSnO6KZZwpBlMX8VusvtvPZvGu9RyL
        A5PH5bOlHp83yQUwRXHZpKTmZJalFunbJXBlvL72n73gOlPFz1XdjA2M05m6GDk5JARMJD4f
        mc7excjFISSwg1FiyZFXrBAJcYnmaz/YIWxhiZX/nkMVPWKUWPCgEyzBIqAisWTyLrYuRg4O
        NgFNiQuTS0HCIgIKEj2/V7KB2MwC6hK3pxwFs4UFvCXenbgGZvMKaEt8nf+FDWLmBEaJ/x+f
        QiUEJU7OfMIC0WwmMW/zQ2aQ+cwC0hLL/3GAhDkFbCV+ftkJdqeogLLEgW3HmSYwCs5C0j0L
        SfcshO4FjMyrGCVTC4pz03OLDQuM8lLL9YoTc4tL89L1kvNzNzGCA1ZLawfjnlUf9A4xMnEw
        HmKU4GBWEuH9LsWRIsSbklhZlVqUH19UmpNafIhRmoNFSZz3QtfJeCGB9MSS1OzU1ILUIpgs
        EwenVAPT1mviE6f/OWD655XLCvOETWxhTmdd/y7sVHX56HyEeYodv33fTBkx7rUzGJn7bBe1
        b3x16HOzc+IfQZtanVU2pVtyvp28VT5/9/O+v3oqy3cFZaxcw9O/N9pnntDWLaoum5v9lph8
        dGFLf3hc3qIy6PtlE6+P695yz2DY//vZujfV33M2VwdMW2UUYhrt0nDNZ5Vg+H4fZr3HHdGN
        yu8y5ku/agvc52V+936Wb2924Ey2N9yPjzcFmPa156oxrz78dCZjmQVrnoMEE2vmCZUcTSnG
        GFYV7Uc+xa+nfbk0gT/soPu5u8W3XnfPXWs4TXpturCmi9CPO5v1/AOb1zv475BhTsr+pF9R
        yT2b47wSS3FGoqEWc1FxIgCrEVN7xwIAAA==
X-CMS-MailID: 20230309092808epcas5p498d0c428279b1f03bfddf233eb80bf0f
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----3NzO0p8.1sh3-RRiYuI9FQqPO8oRjrHoddadEkfGMyLJmz0h=_c43bb_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230308163102epcas5p45cc9c1b5b2ab0bcd772c5ff8d72acd93
References: <CGME20230308163102epcas5p45cc9c1b5b2ab0bcd772c5ff8d72acd93@epcas5p4.samsung.com>
        <2349df76-0acb-0a56-bda1-2cb05aa55151@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------3NzO0p8.1sh3-RRiYuI9FQqPO8oRjrHoddadEkfGMyLJmz0h=_c43bb_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Wed, Mar 08, 2023 at 09:30:56AM -0700, Jens Axboe wrote:
>It's possible for a file type to support uring commands, but not
>pollable ones. Hence before issuing one of those, we should check
>that it is supported and error out upfront if it isn't.

Indeed, I missed that altogether.

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>

------3NzO0p8.1sh3-RRiYuI9FQqPO8oRjrHoddadEkfGMyLJmz0h=_c43bb_
Content-Type: text/plain; charset="utf-8"


------3NzO0p8.1sh3-RRiYuI9FQqPO8oRjrHoddadEkfGMyLJmz0h=_c43bb_--
