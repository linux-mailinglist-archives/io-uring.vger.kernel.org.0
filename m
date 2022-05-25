Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C19F5336F2
	for <lists+io-uring@lfdr.de>; Wed, 25 May 2022 08:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243846AbiEYGvz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 May 2022 02:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244274AbiEYGvy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 May 2022 02:51:54 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859B32C11C
        for <io-uring@vger.kernel.org>; Tue, 24 May 2022 23:51:50 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220525065148epoutp04f66fadac4bdadb6c93a31e7feca774e0~yRntIPclU0806608066epoutp04V
        for <io-uring@vger.kernel.org>; Wed, 25 May 2022 06:51:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220525065148epoutp04f66fadac4bdadb6c93a31e7feca774e0~yRntIPclU0806608066epoutp04V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653461508;
        bh=UfzRK+q6V3s7bWi10ytOxNu7XZMygiv9L1TMl0V/7eY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DeVFYf8gGdeshNnA0LbdoPwRxCCz86rZzMHAj4ZiwLc9jPH6M2xn4X9NNDjEl6gpm
         K+uQlmZfOTp16T/dy4ki32p6usTnhdWO2wIfwamaFRI6XjJTzYC32nZujdVSZ/gMDo
         1IYqHLdWYouwT3886CahkYLO6Tb9I/ch04KHoAMo=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220525065148epcas5p388d4e23b26f5324f30eaaf65b8cc9e7f~yRns6StOz1122011220epcas5p3N;
        Wed, 25 May 2022 06:51:48 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4L7MDc6dWCz4x9Pt; Wed, 25 May
        2022 06:51:44 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A3.3B.10063.EF1DD826; Wed, 25 May 2022 15:51:42 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220525061200epcas5p317aa27b54fd0d51ad0ab0cb4ce700606~yRE8y8c4M2188721887epcas5p3u;
        Wed, 25 May 2022 06:12:00 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220525061200epsmtrp2d0d6d27514f032f17a4edddfdeb662bd~yRE8yS2ZI2263922639epsmtrp2i;
        Wed, 25 May 2022 06:12:00 +0000 (GMT)
X-AuditID: b6c32a49-4b5ff7000000274f-26-628dd1fe2e6a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        71.B9.08924.FA8CD826; Wed, 25 May 2022 15:12:00 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220525061159epsmtip1855d5df1234403e505c4e799cc08bb76~yRE8RXtEE2372723727epsmtip1B;
        Wed, 25 May 2022 06:11:59 +0000 (GMT)
Date:   Wed, 25 May 2022 11:36:46 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH 2/6] io_uring: make prep and issue side of req handlers
 named consistently
Message-ID: <20220525060646.GA4491@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220524213727.409630-3-axboe@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAKsWRmVeSWpSXmKPExsWy7bCmlu6/i71JBlN+qFqsvtvPZvGu9RyL
        A5PH5bOlHp83yQUwRWXbZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoq
        ufgE6Lpl5gBNV1IoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevl
        pZZYGRoYGJkCFSZkZ6y7qV1wmr1iy7Ep7A2ME9i6GDk5JARMJF6du8MKYgsJ7GaUuH8mtouR
        C8j+xCixddVNZgjnM6PE1f3XWWA6Lu3qY4RI7GKUeHluEVTVM0aJbfNWgM1iEVCVmHy5E6iD
        g4NNQFPiwuRSkLCIgIJEz++VYKuZBWQkJs+5zA5iCwskSNz/1Qxm8wroSEy+1cAGYQtKnJz5
        BGwxp4CZxK+bM5hBbFEBZYkD244zgeyVEDjELnHkzjyo61wkuh8vZISwhSVeHd/CDmFLSXx+
        txfq52SJ1u0gizmA7BKJJQvUIcL2Ehf3/GWCuC1DYuqd+0wQcVmJqafWQcX5JHp/P4GK80rs
        mAdjK0rcm/SUFcIWl3g4YwmU7SGxfPFbJkj4bGWUmHRsD+sERvlZSH6bhWQfhG0l0fmhiXUW
        0HnMAtISy/9xQJiaEut36S9gZF3FKJlaUJybnlpsWmCYl1oOj+7k/NxNjOCkp+W5g/Hugw96
        hxiZOBgPMUpwMCuJ8OYs7k0S4k1JrKxKLcqPLyrNSS0+xGgKjKqJzFKiyfnAtJtXEm9oYmlg
        YmZmZmJpbGaoJM4r8L8xSUggPbEkNTs1tSC1CKaPiYNTqoHJO3ja17ajPyZk5xZ+yN0nK5nJ
        vvCBi5cPYwB3ucHMFbx7bKV9zm/Ieqg9aU1p45RTzH0fQytOdZ3M0dAU5tL6tf3Tut/O7XsE
        /lyQ4uYs0c0NuRByn1vv9myBcwc7V6xaILo9TmqF4pv8S1OPL/f/9b7JJy8mfcsprZRfNRFM
        x+wm7PjQa523yCV0afOevbJ2HtNe9c54cPt9ZmxVSu5S/U1cMz7/OOBzIeOZn3jMtroprdNY
        /702jbye+2LN+dZVurlsihLcMSfUPAIDD60s7vP57Ss5tfq0+uW2WK/7Khfv/vHtqfiv5+Hm
        GrOhW2/P1uupvBMqgxt3NbnbWldVumjtMzX6nOp6P/fG9b1KLMUZiYZazEXFiQD9sXVVAwQA
        AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsWy7bCSnO6GE71JBs1vGS1W3+1ns3jXeo7F
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgynkz6xV7wl6XixbMbLA2Md5i7GDk5JARMJC7t
        6mPsYuTiEBLYwShxcVIvI0RCXKL52g92CFtYYuW/5+wQRU8YJf7cWcUKkmARUJWYfLmTpYuR
        g4NNQFPiwuRSkLCIgIJEz++VbCA2s4CMxOQ5l8HmCAskSNz/1Qxm8wroSEy+1cAGMXMro8T1
        NS/YIBKCEidnPmGBaDaTmLf5ITPIfGYBaYnl/zhAwpxA4V83Z4A9ICqgLHFg23GmCYyCs5B0
        z0LSPQuhewEj8ypGydSC4tz03GLDAqO81HK94sTc4tK8dL3k/NxNjOCA1dLawbhn1Qe9Q4xM
        HIyHGCU4mJVEeHMW9yYJ8aYkVlalFuXHF5XmpBYfYpTmYFES573QdTJeSCA9sSQ1OzW1ILUI
        JsvEwSnVwOQr8ucRZ/lv7s3neZTmTO826yvaFvXaZF0ze7BWVHLjc/1FvcsfScW822zvfnhn
        efL0I4E3+WNjlkm5lF86lTv5U/6LW3IbOaXNtWMv3YncyslvJrg6/P3f9xtr+lVjXixZyr3x
        91LnFY49b97UPfhmHLRB/NQ6i1t2k5S7V57jj9GczxNUNnnXqVf37RdYO99rfsT8f9fm8xbC
        Ri85dk1JEM1/o6Fz6La29I0C9gkJDQvL3k9zz2STEdDT+7H0vPH9PBdWVq270qsvcuW51Oq7
        rLSS+lfl8f1PTNSPL7uZ9xZtefDDk0t8/oqH4g586zd1hs9/9v2iosLPpbKHfwf7vX0VtEch
        /ly7VaCC9wYlluKMREMt5qLiRAAcNo/PxwIAAA==
X-CMS-MailID: 20220525061200epcas5p317aa27b54fd0d51ad0ab0cb4ce700606
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----jllqsR28.5W1KdEnZlWKzx60EIuo6gwqBUS1IW9J_3KKio4g=_1f25e_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220524213738epcas5p470641a86a7e0ecff2d3f21767bc5a782
References: <20220524213727.409630-1-axboe@kernel.dk>
        <CGME20220524213738epcas5p470641a86a7e0ecff2d3f21767bc5a782@epcas5p4.samsung.com>
        <20220524213727.409630-3-axboe@kernel.dk>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------jllqsR28.5W1KdEnZlWKzx60EIuo6gwqBUS1IW9J_3KKio4g=_1f25e_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Tue, May 24, 2022 at 03:37:23PM -0600, Jens Axboe wrote:
>Almost all of them are, the odd ones out are the poll remove and the
>files update request. Name them like the others, which is:
>
>io_#cmdname_prep	for request preparation
>io_#cmdname		for request issue

        case IORING_OP_READV:
        case IORING_OP_READ_FIXED:
        case IORING_OP_READ:
        case IORING_OP_WRITEV:
        case IORING_OP_WRITE_FIXED:
        case IORING_OP_WRITE:
                return io_prep_rw(req, sqe);

Should io_prep_rw be renamed to io_rw_prep as well?
Looks good.
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>


------jllqsR28.5W1KdEnZlWKzx60EIuo6gwqBUS1IW9J_3KKio4g=_1f25e_
Content-Type: text/plain; charset="utf-8"


------jllqsR28.5W1KdEnZlWKzx60EIuo6gwqBUS1IW9J_3KKio4g=_1f25e_--
