Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B93B5336EC
	for <lists+io-uring@lfdr.de>; Wed, 25 May 2022 08:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238874AbiEYGv1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 May 2022 02:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233403AbiEYGvZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 May 2022 02:51:25 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE43240A8
        for <io-uring@vger.kernel.org>; Tue, 24 May 2022 23:51:21 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220525065115epoutp039d6cad25efde522bed793bbe44118b3e~yRnOmXOlS0734807348epoutp03H
        for <io-uring@vger.kernel.org>; Wed, 25 May 2022 06:51:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220525065115epoutp039d6cad25efde522bed793bbe44118b3e~yRnOmXOlS0734807348epoutp03H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653461475;
        bh=ceX8JJzuivffrtSIL7kYWX1aadCxIxXyUXuwVtCAX38=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SDRgCcqHHh/s2sd6OJcgPJBlVxKBVotbQcZoF/ZKzUVF9HDn26qiWSSs91uhBXvVP
         2YWy0qlhvMT2kBtwOKuHY1kEMKsc+EMvDBjV3nKHFatXAuuQWEYzcaWlYfI+9eYg5E
         4ddGaCRE7G+xOUnhXEML6ZEgchdtD7kwP/ThHSXQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220525065115epcas5p41f5077051a18a032413e25d9f7d0a739~yRnOZ5akm2460724607epcas5p4a;
        Wed, 25 May 2022 06:51:15 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4L7MD04qdKz4x9QK; Wed, 25 May
        2022 06:51:12 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        27.FA.10063.CD1DD826; Wed, 25 May 2022 15:51:08 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220525062115epcas5p434519bfbb7da8e2a76a3604e143a57c9~yRNBkbwpu2579125791epcas5p4s;
        Wed, 25 May 2022 06:21:15 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220525062115epsmtrp18059d7176dc6df7220a83f63437a94bf~yRNBjy_a-1894118941epsmtrp1f;
        Wed, 25 May 2022 06:21:15 +0000 (GMT)
X-AuditID: b6c32a49-4cbff7000000274f-95-628dd1dc8ce6
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        8C.31.11276.ADACD826; Wed, 25 May 2022 15:21:14 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220525062114epsmtip27dd91e5d3020c428dd4f5442f82b0bf5~yRNBEB6R51151511515epsmtip2R;
        Wed, 25 May 2022 06:21:14 +0000 (GMT)
Date:   Wed, 25 May 2022 11:46:01 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH 1/6] io_uring: make timeout prep handlers consistent
 with other prep handlers
Message-ID: <20220525061601.GC4491@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220524213727.409630-2-axboe@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHKsWRmVeSWpSXmKPExsWy7bCmlu6di71JBrOW8FqsvtvPZvGu9RyL
        A5PH5bOlHp83yQUwRWXbZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoq
        ufgE6Lpl5gBNV1IoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevl
        pZZYGRoYGJkCFSZkZ/yZuJCt4DZLxdVfN1kaGPtZuhg5OSQETCSubF7M1sXIxSEksJtRYvPJ
        ZnYI5xOjxOM3R6Gcb4wS34+dZIVpOTdxLyNEYi+jxNOOaawQzjNGib0XNjOBVLEIqEocOL8D
        aAkHB5uApsSFyaUgYREBBYme3yvZQGxmARmJyXMus4PYwgLJEj9fz2IDKecV0JHY/CENJMwr
        IChxcuYTsFM5Bcwk7iw5BHaDqICyxIFtx5lA1koIHGKXuLLrBNQ/LhJn2x5A2cISr45vYYew
        pSRe9rdB2ckSrdtB9nIA2SUSSxaoQ4TtJS7u+csEEmYWyJDYtiEbIiwrMfXUOiaIi/kken8/
        YYKI80rsmAdjK0rcm/QUGjziEg9nLIGyPSQ+nV0Bdo2QwFZGiUkvpCYwys9C8tkshG2zwDZY
        SXR+aGKFCEtLLP/HAWFqSqzfpb+AkXUVo2RqQXFuemqxaYFhXmo5PLKT83M3MYITnpbnDsa7
        Dz7oHWJk4mA8xCjBwawkwpuzuDdJiDclsbIqtSg/vqg0J7X4EKMpMJomMkuJJucDU25eSbyh
        iaWBiZmZmYmlsZmhkjivwP/GJCGB9MSS1OzU1ILUIpg+Jg5OqQamzDl9K3JmxWZFp/ed+FXD
        +8TX6vGPy5ueaSs84jLe1XxpicGr9yJqn4xtfjyb8Fq2dUL1WdeWp+par735WfcsfX1PcssV
        LRHb2g2WUwJOPRd8+tjjxpxCjrXxfgYZUyfo7754O7q8qfhLib/FdMlDR08WRFidWSX5Sbjr
        uuUC3aSv73tUvxty3X7c+ZFv6eHT9dwmK29xbTzzyql1T9DaFdI/5iTGvJbZEOH78L/e7tdv
        Hz97+lXApzBL8/yfFRI3YsO/hpyZFlXre8+87P92xmWuE6u5VTsr9++zP9u/N+ZfwfFLFXKS
        hUoc1gusvHMyv3yO53GcPL+u2r77/qcd/EVHNzFEc5s5L73SbDOjR4mlOCPRUIu5qDgRAC3Y
        mQkBBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsWy7bCSvO6tU71JBv1PLC1W3+1ns3jXeo7F
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgyNjy9xVjQy1Rx+sp71gbG24xdjJwcEgImEucm
        7gWyuTiEBHYzSqya/ZcNIiEu0XztBzuELSyx8t9zdoiiJ4wSb16tYQZJsAioShw4v4Oli5GD
        g01AU+LC5FKQsIiAgkTP75Vgc5gFZCQmz7kMNkdYIFmi6/5cNpByXgEdic0f0iBGbmWU+H+g
        AayGV0BQ4uTMJywQvWYS8zY/ZAapZxaQllj+jwMkzAkUvrPkECuILSqgLHFg23GmCYyCs5B0
        z0LSPQuhewEj8ypGydSC4tz03GLDAsO81HK94sTc4tK8dL3k/NxNjOBw1dLcwbh91Qe9Q4xM
        HIyHGCU4mJVEeHMW9yYJ8aYkVlalFuXHF5XmpBYfYpTmYFES573QdTJeSCA9sSQ1OzW1ILUI
        JsvEwSnVwBTc11e9OEhLk0/VaFPMrBNLzszcbC96J2X2Re3jj/dZfbjfsuTDngvqM+wuPl7M
        U2PxkvHbodppTQbV7O4RlnYZRxqXn228qx8wV63vxoa7T4QmvTIOrnonzbefXUnt2Z7/mS9U
        D0+ZLCWXMS1ib+HjT5/i4oplmpo+8a19ksbKL2T1kudI4cucT5GTJxxUtf61zao05JLLKbVC
        m1sfDtw981BgyZrs5oOzEyUfVpQ4Xmg+4blR8vW3srRO880b7Lm1d1dWHXi483rT7LrZqZ/k
        LmV2n9/T4FXqKDH59sNPeV2sLQJb/y+Y9tWfhXFK0r2XorsnyUlNep+RMv3WpoVJdf4lLB2l
        l0+XJEn9b/dVYinOSDTUYi4qTgQAcfUqYMYCAAA=
X-CMS-MailID: 20220525062115epcas5p434519bfbb7da8e2a76a3604e143a57c9
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----HMHzcl7Kov5y0bbYah5tgDYyhjafTXQAGx6UUfEgMJOMVZI4=_1f6d1_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220524213738epcas5p155cdcaea02c95bb62a22679218a5cd1a
References: <20220524213727.409630-1-axboe@kernel.dk>
        <CGME20220524213738epcas5p155cdcaea02c95bb62a22679218a5cd1a@epcas5p1.samsung.com>
        <20220524213727.409630-2-axboe@kernel.dk>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------HMHzcl7Kov5y0bbYah5tgDYyhjafTXQAGx6UUfEgMJOMVZI4=_1f6d1_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Tue, May 24, 2022 at 03:37:22PM -0600, Jens Axboe wrote:
>All other opcodes take a {req, sqe} set for prep handling, split out
>a timeout prep handler so that timeout and linked timeouts can use
>the same one.

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>

------HMHzcl7Kov5y0bbYah5tgDYyhjafTXQAGx6UUfEgMJOMVZI4=_1f6d1_
Content-Type: text/plain; charset="utf-8"


------HMHzcl7Kov5y0bbYah5tgDYyhjafTXQAGx6UUfEgMJOMVZI4=_1f6d1_--
