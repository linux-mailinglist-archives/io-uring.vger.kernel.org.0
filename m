Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E02865718B0
	for <lists+io-uring@lfdr.de>; Tue, 12 Jul 2022 13:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiGLLio (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Jul 2022 07:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiGLLin (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Jul 2022 07:38:43 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA9FEE39
        for <io-uring@vger.kernel.org>; Tue, 12 Jul 2022 04:38:39 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220712113834epoutp02cfe876a8b65d0df9fa15e350ae67dcde~BEfy5GsLl1595915959epoutp02H
        for <io-uring@vger.kernel.org>; Tue, 12 Jul 2022 11:38:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220712113834epoutp02cfe876a8b65d0df9fa15e350ae67dcde~BEfy5GsLl1595915959epoutp02H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1657625915;
        bh=cyTZ0JqqZSgf5ijTit5hlDsdeh3mZXsbfkOgDoJM25c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QlQIy8xqYUHYEAo38+VY7bZjY+IaIh5qVRLyG1n6SU2DHJSs3Cfbx0h9wLW/5dXHv
         2m8tgUgDAvY6/a/Qhcjf8ZFhS20maEKZJyUoK0A/Zhk110ebBYAd/DpCT8azVxwkNs
         1KESspkZiJT5s1bnfPCMEmcUQKXf97uLtOynBdl0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220712113834epcas5p4656a40f25db4218ee2362731b1c3881a~BEfyMe5TT2337223372epcas5p4E;
        Tue, 12 Jul 2022 11:38:34 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4LhzKL1dGwz4x9Pt; Tue, 12 Jul
        2022 11:38:30 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        71.86.09566.63D5DC26; Tue, 12 Jul 2022 20:38:30 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220712113829epcas5p450d873c7e596124b079f17595fc42e9f~BEftvBJyZ2337223372epcas5p44;
        Tue, 12 Jul 2022 11:38:29 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220712113829epsmtrp1b6a97dd9a13941a3024487eca20a16a3~BEftuNYIr0581305813epsmtrp1D;
        Tue, 12 Jul 2022 11:38:29 +0000 (GMT)
X-AuditID: b6c32a4a-b8dff7000000255e-75-62cd5d360378
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        63.31.08905.53D5DC26; Tue, 12 Jul 2022 20:38:29 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220712113827epsmtip16c82cf0b4509137dd52e2cd1092c0b23~BEfsJMP7o1734017340epsmtip11;
        Tue, 12 Jul 2022 11:38:27 +0000 (GMT)
Date:   Tue, 12 Jul 2022 17:03:04 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     sagi@grimberg.me, kbusch@kernel.org, axboe@kernel.dk,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, asml.silence@gmail.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
Subject: Re: [PATCH for-next 4/4] nvme-multipath: add multipathing for
 uring-passthrough commands
Message-ID: <20220712113304.GA4465@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220712065250.GA6574@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPJsWRmVeSWpSXmKPExsWy7bCmlq5Z7Nkkg09TuSyaJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFuffHmaymHToGqPF3lvaFvOXPWW3WPf6PYsDt8fOWXfZ
        Pc7f28jicflsqcemVZ1sHpuX1HvsvtnA5tG3ZRWjx+dNcgEcUdk2GamJKalFCql5yfkpmXnp
        tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBnKimUJeaUAoUCEouLlfTtbIryS0tS
        FTLyi0tslVILUnIKTAr0ihNzi0vz0vXyUkusDA0MjEyBChOyM96cPsxW8IajomvCOaYGxtPs
        XYycHBICJhLrmk+zdjFycQgJ7GaU+PrgMQuE84lR4suEDmYI5xujxLLH69hgWuZtuMQOkdjL
        KPH+2gqo/meMEk+3nWMEqWIRUJVo6ugDSnBwsAloSlyYXAoSFhFQknj66ixYCbPAO0aJKe9y
        QGxhgWSJTU8mMYHYvAI6Es/7FrBD2IISJ2c+YQGxOQW0JT4veAp2hKiAssSBbceZQPZKCKzk
        kNg4ZRszxHUuEv9fzmOCsIUlXh3fAvWolMTL/jYoO1ni0sxzUDUlEo/3HISy7SVaT/UzQxyX
        ITG3r5MVwuaT6P39hAnkFwkBXomONiGIckWJe5OeskLY4hIPZyyBsj0kPs5vhgbQHUaJ4/9n
        ME9glJuF5J9ZSFZA2FYSnR+agGwOIFtaYvk/DghTU2L9Lv0FjKyrGCVTC4pz01OLTQuM8lLL
        4ZGcnJ+7iRGccrW8djA+fPBB7xAjEwfjIUYJDmYlEd4/Z08lCfGmJFZWpRblxxeV5qQWH2I0
        BUbPRGYp0eR8YNLPK4k3NLE0MDEzMzOxNDYzVBLn9bq6KUlIID2xJDU7NbUgtQimj4mDU6qB
        yXrqtb+/HVc65wksD/i+Jz9Cft0h8U1VzZdV89fIFtjLXUoU74zL/RDncMJutuXFT47ZsVrd
        93/cyrwzXypwpUebiqLWz6sWLLMfdwe3JRb9NMmfIv9Wv9wuT+1xeCJ7x6ez1he/J8g+6Nr+
        pfmCnzNTnNu8hmven1bWbtBxW5wzl3H2/G9T9k2R1oqYso3dK2K1OEfTC8FlfIU9jQ9M2VW4
        wz2DOnvfPVl7LCbbX/2/nuZM0eS0tyelpgqkyRjzRoQbJBiqrdptUOdr77bLi8vtuGS329MI
        QzeVlxWL2Zhsd557cMf8+oW9Llwps7u/tM3S+lFrXunTF7CO84l/wYYvk+OMZ89jN5zhN0+J
        pTgj0VCLuag4EQCxsYW2QgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWy7bCSnK5p7Nkkg9e7hSyaJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFuffHmaymHToGqPF3lvaFvOXPWW3WPf6PYsDt8fOWXfZ
        Pc7f28jicflsqcemVZ1sHpuX1HvsvtnA5tG3ZRWjx+dNcgEcUVw2Kak5mWWpRfp2CVwZBz6e
        YyqYx1Zx6dxt9gbG6axdjJwcEgImEvM2XGLvYuTiEBLYzSjRtfoZO0RCXKL52g8oW1hi5b/n
        UEVPGCU6Vk8BS7AIqEo0dfQBTeLgYBPQlLgwuRQkLCKgJPH01VlGkHpmgXeMEk3zullAEsIC
        yRKbnkxiArF5BXQknvctgBp6j1Gi7dEzFoiEoMTJmU/AbGYBM4l5mx8ygyxgFpCWWP6PAyTM
        KaAt8XnBUzYQW1RAWeLAtuNMExgFZyHpnoWkexZC9wJG5lWMkqkFxbnpucWGBYZ5qeV6xYm5
        xaV56XrJ+bmbGMFRpKW5g3H7qg96hxiZOBgPMUpwMCuJ8P45eypJiDclsbIqtSg/vqg0J7X4
        EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkmDk6pBqboN1tfvsybvsLvf8SC/Y7znV2S8l1e
        iFt+YzUWXWRdvuHR3mRXp7qt9v/X7P/xSo8js5DBp29K2LFQhu7CDgFx/1sPtGSdDWO0dkj/
        rlvZyiuXOI8nKPW3ytnz09dnvjc5NzeRxy8jZOuC7xOmO+rpmRu/nKMZza5g1eKiJnIrRO0R
        0zmZScsvvJJbdWP3kqwC47D5Ul8mzrLncmH6U7lWZJrUm6pnjbVhB1jPK4QeOrDHintP+C2h
        9Jxt3T8k2Is956lyPjned05FMHLuu8f9Ufr9kh0/V2/aIrznhANLnLPtWhmHBJGmNxN/u7BE
        FYnN93zVczomaG0VU5KXUKRTaQHPsftKK76XfhPvVWIpzkg01GIuKk4EAKwPXvURAwAA
X-CMS-MailID: 20220712113829epcas5p450d873c7e596124b079f17595fc42e9f
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----OEEzMZle2oafIX2psGkTvPl59BrXC3apHO-sLjJPJT1qP5Pe=_81827_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220711110827epcas5p3fd81f142f55ca3048abc38a9ef0d0089
References: <20220711110155.649153-1-joshi.k@samsung.com>
        <CGME20220711110827epcas5p3fd81f142f55ca3048abc38a9ef0d0089@epcas5p3.samsung.com>
        <20220711110155.649153-5-joshi.k@samsung.com> <20220712065250.GA6574@lst.de>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------OEEzMZle2oafIX2psGkTvPl59BrXC3apHO-sLjJPJT1qP5Pe=_81827_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Tue, Jul 12, 2022 at 08:52:50AM +0200, Christoph Hellwig wrote:
>Hmm, I'm a little confused on what this is trying to archive.
>
>The io_uring passthrough already does support multipathing, it picks
>an available path in nvme_ns_head_chr_uring_cmd and uses that.
>
>What this does is adding support for requeing on failure or the
>lack of an available path.  Which very strongly is against our
>passthrough philosophy both in SCSI and NVMe where error handling
>is left entirely to the userspace program issuing the I/O.
>
>So this does radically change behavior in a very unexpected way.
>Why?

I think ask has been to add requeue/failover support for
async-passthrough. This came up here - 
https://lore.kernel.org/linux-nvme/88827a86-1304-e699-ec11-2718e280f9ad@grimberg.me/

------OEEzMZle2oafIX2psGkTvPl59BrXC3apHO-sLjJPJT1qP5Pe=_81827_
Content-Type: text/plain; charset="utf-8"


------OEEzMZle2oafIX2psGkTvPl59BrXC3apHO-sLjJPJT1qP5Pe=_81827_--
