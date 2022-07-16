Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54AE6576B6E
	for <lists+io-uring@lfdr.de>; Sat, 16 Jul 2022 05:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiGPD0R (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jul 2022 23:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbiGPD0P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jul 2022 23:26:15 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19867436A
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 20:26:13 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220716032610epoutp0297e554ed91e2ed5373d5ce06a311fd43~CMXAIXkTs1911819118epoutp02E
        for <io-uring@vger.kernel.org>; Sat, 16 Jul 2022 03:26:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220716032610epoutp0297e554ed91e2ed5373d5ce06a311fd43~CMXAIXkTs1911819118epoutp02E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1657941970;
        bh=9t8nL8rQn5cHV5JiqdShNz/B50DJYuVSJR8J3CiVZZc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WCBO5JT5qETUyxmyxVFxLAtLvcZo5cKNgIgBbLSJFSC0qS3tLzfi+oP1A3oyFbEa8
         jU+5SDgRo+GHrVqHkVRsV1pRXXg6aErKtNPZIm7vN8HtORyLeh2wsZWmJElONOyNnT
         O6wkkpFc/jXPmj8/Q6h/TDscX6jJ80k/ZilxD6Ng=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220716032609epcas5p153f19be3ee9654107a98e21c6aef2375~CMW-tgUkF2278222782epcas5p1y;
        Sat, 16 Jul 2022 03:26:09 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4LlDCM4kLBz4x9Pv; Sat, 16 Jul
        2022 03:26:07 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B4.F2.09566.FCF22D26; Sat, 16 Jul 2022 12:26:07 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220716032606epcas5p4bb3a44863ba540f7dc98e6ecf7eadd1e~CMW8tn6YA2888628886epcas5p4m;
        Sat, 16 Jul 2022 03:26:06 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220716032606epsmtrp28c24ab586b969d020313482da4b477c3~CMW8s1xc51780117801epsmtrp2a;
        Sat, 16 Jul 2022 03:26:06 +0000 (GMT)
X-AuditID: b6c32a4a-b8dff7000000255e-e6-62d22fcfd4b8
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        31.F9.08905.ECF22D26; Sat, 16 Jul 2022 12:26:06 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220716032604epsmtip147d4d0bea5ee5d1c304b72a9f93302cd~CMW7MH6ab1922419224epsmtip1d;
        Sat, 16 Jul 2022 03:26:04 +0000 (GMT)
Date:   Sat, 16 Jul 2022 08:50:41 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>, casey@schaufler-ca.com,
        axboe@kernel.dk, linux-security-module@vger.kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, a.manzanares@samsung.com,
        javier@javigon.com
Subject: Re: [PATCH] lsm,io_uring: add LSM hooks to for the new uring_cmd
 file op
Message-ID: <20220716032041.GB25618@test-zns>
MIME-Version: 1.0
In-Reply-To: <CAHC9VhQMABYKRqZmJQtXai0gtiueU42ENvSUH929=pF6tP9xOg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOJsWRmVeSWpSXmKPExsWy7bCmlu55/UtJBu+WK1lMP6xosfpuP5vF
        vW2/2CzetZ5jseg8fYHJYu8tbYv5y56yW3zoecRmcWPCU0aL25OmszhweTQvuMPicflsqcem
        VZ1sHpuX1Hus3fuC0aNvyypGj6P7F7F5fN4kF8ARlW2TkZqYklqkkJqXnJ+SmZduq+QdHO8c
        b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SgkkJZYk4pUCggsbhYSd/Opii/tCRVISO/uMRW
        KbUgJafApECvODG3uDQvXS8vtcTK0MDAyBSoMCE748yK9cwFzUIVq/ZZNjA+5eti5OSQEDCR
        +PPkH3MXIxeHkMBuRonJB++xQzifGCVeNDSxgVQJCXxjlLi5JQqmY97P+1AdexklGhZ8YIJw
        njFKfJt7lgWkikVAVWJlx0egbg4ONgFNiQuTS0HCIgIqEoufrmcEqWcWaGaSmPxvOjNIQlgg
        WKJn7SEmEJtXQFdi/t6fLBC2oMTJmU/AbE6BQInpJzrYQWxRAWWJA9uOM0FctJRDYt0TTwjb
        ReLQ1i9QcWGJV8e3sEPYUhKf3+1lg7CTJS7NPAdVUyLxeM9BKNteovVUP9g9zAKZEocOzmCH
        sPkken8/YQL5RUKAV6KjTQiiXFHi3qSnrBC2uMTDGUugbA+Jcyu+QkPxGJPEhfNrmSYwys1C
        8s4sJCsgbCuJzg9NrLOAVjALSEss/8cBYWpKrN+lv4CRdRWjZGpBcW56arFpgVFeajk8ipPz
        czcxglOsltcOxocPPugdYmTiYDzEKMHBrCTC233oXJIQb0piZVVqUX58UWlOavEhRlNg9Exk
        lhJNzgcm+bySeEMTSwMTMzMzE0tjM0MlcV6vq5uShATSE0tSs1NTC1KLYPqYODilGpiW/7zb
        v+0pz0kV/Tm5SUqn93U9XHFdiXlKq3yW2VpBnnsZB8+9NPGYuVN54rN49lNzbgsyyc7dw6Su
        p7V6r/ztuOvSO2qFHpsLpM3W6Em5ntWpaTXPKd/WYhanw31F15qS9ZxTV7IUH089NdfcvG7T
        orVhmzbv+9VY9j7I8FyrWuXDLz+Wnfy2Ivzp3EN8KW4ZH/PqbOVvXS5+6q7ncDt1+2+91G8p
        cUopLRpivFejTk65UZX57GOj3fFfmqU1UzR9FJZsPGi6OfQv4/OA4r2izOvL+T9+iugNiU7g
        crmdYCNc39+0oTkqekGQql7MhI656pvb9voL6pfcnWJ85Bnr0anxd6W059VWO9zuqlViKc5I
        NNRiLipOBAA8rTusOgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWy7bCSnO45/UtJBisu8FtMP6xosfpuP5vF
        vW2/2CzetZ5jseg8fYHJYu8tbYv5y56yW3zoecRmcWPCU0aL25OmszhweTQvuMPicflsqcem
        VZ1sHpuX1Hus3fuC0aNvyypGj6P7F7F5fN4kF8ARxWWTkpqTWZZapG+XwJXx+WsbS8Em/oo1
        q+cwNTCu4+li5OSQEDCRmPfzPnMXIxeHkMBuRomWxTvYIRLiEs3XfkDZwhIr/z1nhyh6wijx
        dsM1NpAEi4CqxMqOj0A2BwebgKbEhcmlIGERARWJxU/XM4LYzAKtTBItO9NBbGGBYImetYeY
        QGxeAV2J+Xt/skDMPMYkseLZA3aIhKDEyZlPWCCazSTmbX7IDDKfWUBaYvk/DpAwp0CgxPQT
        HWDlogLKEge2HWeawCg4C0n3LCTdsxC6FzAyr2KUTC0ozk3PLTYsMMxLLdcrTswtLs1L10vO
        z93ECI4bLc0djNtXfdA7xMjEwXiIUYKDWUmEt/vQuSQh3pTEyqrUovz4otKc1OJDjNIcLEri
        vBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUamNx3rmU2bXzj9Kmldlv0VlW9Vc8reLOW+t9aJPjv
        oKczz8bff+MUti53D0iuTy+eNOHIb6uHc/ICBR4v/C1t9mLzl7lVD90nZlmrfT5nOfXjMqnO
        OT33F1/T+GQkU/6q8VXfVu950zzeMk1Q07jp/e9o7OopGVlKB7dkztK5GWW8UEpZYNYXhfdv
        hJbmSdd9z25Nc1T1+euydNv7Q+W9ZtV9L8Ke+GgmKwWfTv/usm6u/Pqj13LNyo76l0+YvEz8
        wYnXpdNZa+u8Nbl+cr/8FbuvL1v/7gLe+olGbFaFu6RN1jzln6chwvvq6ZqTfk/q+T2WRU7s
        +cb1SafI6InKvla1oMoJjUsjGzR9Ux9vOa/EUpyRaKjFXFScCACFMUcpCgMAAA==
X-CMS-MailID: 20220716032606epcas5p4bb3a44863ba540f7dc98e6ecf7eadd1e
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----jllqsR28.5W1KdEnZlWKzx60EIuo6gwqBUS1IW9J_3KKio4g=_136310_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220715184632epcas5p36bd157d36a2aed044de40264911bec05
References: <20220714000536.2250531-1-mcgrof@kernel.org>
        <CAHC9VhSjfrMtqy_6+=_=VaCsJKbKU1oj6TKghkue9LrLzO_++w@mail.gmail.com>
        <YtC8Hg1mjL+0mjfl@bombadil.infradead.org>
        <CGME20220715184632epcas5p36bd157d36a2aed044de40264911bec05@epcas5p3.samsung.com>
        <CAHC9VhQMABYKRqZmJQtXai0gtiueU42ENvSUH929=pF6tP9xOg@mail.gmail.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------jllqsR28.5W1KdEnZlWKzx60EIuo6gwqBUS1IW9J_3KKio4g=_136310_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Fri, Jul 15, 2022 at 02:46:16PM -0400, Paul Moore wrote:
>On Thu, Jul 14, 2022 at 9:00 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>> On Wed, Jul 13, 2022 at 11:00:42PM -0400, Paul Moore wrote:
>> > On Wed, Jul 13, 2022 at 8:05 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>> > >
>> > > io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
>> > > add infrastructure for uring-cmd"), this extended the struct
>> > > file_operations to allow a new command which each subsystem can use
>> > > to enable command passthrough. Add an LSM specific for the command
>> > > passthrough which enables LSMs to inspect the command details.
>> > >
>> > > This was discussed long ago without no clear pointer for something
>> > > conclusive, so this enables LSMs to at least reject this new file
>> > > operation.
>> > >
>> > > [0] https://lkml.kernel.org/r/8adf55db-7bab-f59d-d612-ed906b948d19@schaufler-ca.com
>> >
>> > [NOTE: I now see that the IORING_OP_URING_CMD has made it into the
>> > v5.19-rcX releases, I'm going to be honest and say that I'm
>> > disappointed you didn't post the related LSM additions
>>
>> It does not mean I didn't ask for them too.
>>
>> > until
>> > v5.19-rc6, especially given our earlier discussions.]
>>
>> And hence since I don't see it either, it's on us now.
>
>It looks like I owe you an apology, Luis.  While my frustration over
>io_uring remains, along with my disappointment that the io_uring
>developers continue to avoid discussing access controls with the LSM
>community, you are not the author of the IORING_OP_URING_CMD.   You

I am to be shot down here. Solely.
My LSM understanding has been awful. At a level that I am not clear
how to fix if someone says - your code lacks LSM consideration.
But nothing to justify, I fully understand this is not someone else's
problem but mine. I intend to get better at it.
And I owe apology (to you/LSM-folks, Luis, Jens) for the mess.

------jllqsR28.5W1KdEnZlWKzx60EIuo6gwqBUS1IW9J_3KKio4g=_136310_
Content-Type: text/plain; charset="utf-8"


------jllqsR28.5W1KdEnZlWKzx60EIuo6gwqBUS1IW9J_3KKio4g=_136310_--
