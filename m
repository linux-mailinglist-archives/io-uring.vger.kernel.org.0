Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305575718D2
	for <lists+io-uring@lfdr.de>; Tue, 12 Jul 2022 13:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiGLLqO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Jul 2022 07:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiGLLqK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Jul 2022 07:46:10 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6841B1947
        for <io-uring@vger.kernel.org>; Tue, 12 Jul 2022 04:46:09 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220712114607epoutp0415941be5b9b84490b7e9cb1fd037c426~BEmYtBYnG2670826708epoutp04A
        for <io-uring@vger.kernel.org>; Tue, 12 Jul 2022 11:46:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220712114607epoutp0415941be5b9b84490b7e9cb1fd037c426~BEmYtBYnG2670826708epoutp04A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1657626367;
        bh=zMdXetJT+/feFCQLF4Yj27rJKHTUDOLFXnQpuT6tZ90=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b/wNBonx2qWMVx9UthN2ksOM58sYAO8Vs4jqlaGVdXBqLdzGVf0F5DT3l1TjeeXvD
         6QKFYWrLFNSBM+y8TbjHA2FzCvlQdGK2YYsWzCrJ74LoaVBTpM8XbwxQCBJh9xmabO
         XZ+WoSVFql48p+QgYgR8gxDIvIwMEuAOWdkuEpBk=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220712114607epcas5p34f4e1a64e810990d6a2ad2c31ddcf177~BEmYPfCMT0058800588epcas5p3Q;
        Tue, 12 Jul 2022 11:46:07 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4LhzV43Dgxz4x9Pr; Tue, 12 Jul
        2022 11:46:04 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        44.B2.09639.7FE5DC26; Tue, 12 Jul 2022 20:45:59 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220712114559epcas5p307791594bb4d99b7b9c02ffb0960d5c1~BEmQcVqt_1633316333epcas5p3J;
        Tue, 12 Jul 2022 11:45:59 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220712114559epsmtrp1e925269083cab0f968d55e5d9a813007~BEmQbJW3J0872808728epsmtrp1Y;
        Tue, 12 Jul 2022 11:45:59 +0000 (GMT)
X-AuditID: b6c32a4b-e83ff700000025a7-6d-62cd5ef78d75
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        27.51.08802.6FE5DC26; Tue, 12 Jul 2022 20:45:58 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220712114557epsmtip26ca397013840dc596018671d58b3557b~BEmO6pf_k1376913769epsmtip2F;
        Tue, 12 Jul 2022 11:45:57 +0000 (GMT)
Date:   Tue, 12 Jul 2022 17:10:34 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Sagi Grimberg <sagi@grimberg.me>, hch@lst.de, kbusch@kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, asml.silence@gmail.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
Subject: Re: [PATCH for-next 3/4] io_uring: grow a field in struct
 io_uring_cmd
Message-ID: <20220712114034.GB4465@test-zns>
MIME-Version: 1.0
In-Reply-To: <7fb16d2a-21f4-3380-75f3-c8e8c08fd318@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAJsWRmVeSWpSXmKPExsWy7bCmuu73uLNJBg+6NC2aJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFuffHmaymHToGqPF3lvaFvOXPWW3WPf6PYsDt8fOWXfZ
        Pc7f28jicflsqcemVZ1sHpuX1HvsvtnA5tG3ZRWjx+dNcgEcUdk2GamJKalFCql5yfkpmXnp
        tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBnKimUJeaUAoUCEouLlfTtbIryS0tS
        FTLyi0tslVILUnIKTAr0ihNzi0vz0vXyUkusDA0MjEyBChOyM548f8xS0CdY8bfjFXsD41S+
        LkZODgkBE4kpu5axdjFycQgJ7GaUaFo/hRnC+cQoseT9YzYI5zOjxKYrL5lgWqZu2swCkdjF
        KHHg136oqmeMEl1bu9lBqlgEVCX+Xn4LZHNwsAloSlyYXAoSFhFQkOj5vRKsnlngJ6PE9H2d
        YFOFBQIlVvfuAevlFdCRuDZnAQuELShxcuYTMJtTwFai598NsHpRAWWJA9uOM4EMkhBYyyGx
        b/sTVojzXCQOXHvJBmELS7w6voUdwpaSeNnfBmUnS1yaeQ7qnRKJx3sOQtn2Eq2n+plBbGaB
        DIkpXw5D2XwSvb+fMIE8IyHAK9HRJgRRrihxb9JTqLXiEg9nLIGyPSRu3toLDZReZom/d24z
        T2CUm4Xkn1lIVkDYVhKdH5pYZwGtYBaQllj+jwPC1JRYv0t/ASPrKkbJ1ILi3PTUYtMC47zU
        cngsJ+fnbmIEJ10t7x2Mjx580DvEyMTBeIhRgoNZSYT3z9lTSUK8KYmVValF+fFFpTmpxYcY
        TYHxM5FZSjQ5H5j280riDU0sDUzMzMxMLI3NDJXEeb2ubkoSEkhPLEnNTk0tSC2C6WPi4JRq
        YHJ/sHSfaYJ/TGzL+5OpxeuNS5iY6l0cmW04JphyPXOb8fbIrtCNqbVqrTvXdjQ/e8GUHSMl
        OceAMVXh/on3X17qxOilGlmdMk46s7Vtweu1UcvbIszuleeZSNVbf+eqduJtdGGbteBdYqLK
        /LDN2zoCpDVmOSTyif2atsaleNX71rdpWjXH7PK3fZm+YMbDZWeCP3Uc5bziELx5wZcNbxps
        tSTqfaRTtU4fMp61NeJTq9ZqS4eHSVnfLeO3N59uWxE3S2dHr+L5pksvHBsnVuzomTTp8/cd
        62VVOb3/MzHrFcwUsNLOfibYuf2VauujRHM2+1VfZu5PkF4eJNJs5ipYu9cl0Xl19bc1lvNr
        lViKMxINtZiLihMBuoek+EMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWy7bCSvO63uLNJBiebrCyaJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFuffHmaymHToGqPF3lvaFvOXPWW3WPf6PYsDt8fOWXfZ
        Pc7f28jicflsqcemVZ1sHpuX1HvsvtnA5tG3ZRWjx+dNcgEcUVw2Kak5mWWpRfp2CVwZbf3c
        BQf4KqY8nsfewPiQu4uRk0NCwERi6qbNLF2MXBxCAjsYJTatmMECkRCXaL72gx3CFpZY+e85
        O0TRE0aJI3c/gxWxCKhK/L38FijBwcEmoClxYXIpSFhEQEGi5/dKNpB6ZoGfjBL/rt1jBkkI
        CwRKrO7dAzaUV0BH4tqcBVCbe5klvv87ygKREJQ4OfMJmM0sYCYxb/NDZpAFzALSEsv/cYCE
        OQVsJXr+3WACsUUFlCUObDvONIFRcBaS7llIumchdC9gZF7FKJlaUJybnltsWGCUl1quV5yY
        W1yal66XnJ+7iREcQ1paOxj3rPqgd4iRiYPxEKMEB7OSCO+fs6eShHhTEiurUovy44tKc1KL
        DzFKc7AoifNe6DoZLySQnliSmp2aWpBaBJNl4uCUamBiPemuFNcS1Lz07sZilw9uc2T1J+xw
        vND+ZkHrd+byONkUyQTRNQsDZIMuOju0n2G/X2CYI3Rsxmrui5oLN01Y+CLc6MgutpjZB9x2
        MPcYJZbk8d6VXHnj8ILEv8u0VxuxNczmlG/Xf6fJ8bcw78qa6qt3/WqUuesi8utzDVjXNf/N
        jpu9il345syoXK7g6QlLVrNHcd+6OkPqSFF2/ralJ6Li3y49afRj4cqPXrl7LQ91nrt69UfB
        JpEAlcaeH2vO1ob3TViyeWnSi8ALJpdv/Nj8/uzKDU+XevBOnCJ5ZxZ/xA6xjikbfEV2X1q3
        ze/d1DYemY2LJrNOXvXM57Jx8ir92UeUnpxpLV5sq/++TYmlOCPRUIu5qDgRABLdqn0QAwAA
X-CMS-MailID: 20220712114559epcas5p307791594bb4d99b7b9c02ffb0960d5c1
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----OEEzMZle2oafIX2psGkTvPl59BrXC3apHO-sLjJPJT1qP5Pe=_81924_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220711110824epcas5p22c8e945cb8c3c3ac46c8c2b5ab55db9b
References: <20220711110155.649153-1-joshi.k@samsung.com>
        <CGME20220711110824epcas5p22c8e945cb8c3c3ac46c8c2b5ab55db9b@epcas5p2.samsung.com>
        <20220711110155.649153-4-joshi.k@samsung.com>
        <2b644543-9a54-c6c4-fd94-f2a64d0701fa@kernel.dk>
        <43955a42-7185-2afc-9a55-80cc2de53bf9@grimberg.me>
        <96fcba9a-76ad-8e04-e94e-b6ec5934f84e@grimberg.me>
        <7fb16d2a-21f4-3380-75f3-c8e8c08fd318@kernel.dk>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------OEEzMZle2oafIX2psGkTvPl59BrXC3apHO-sLjJPJT1qP5Pe=_81924_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Mon, Jul 11, 2022 at 12:24:42PM -0600, Jens Axboe wrote:
>On 7/11/22 12:22 PM, Sagi Grimberg wrote:
>>
>>>>> Use the leftover space to carve 'next' field that enables linking of
>>>>> io_uring_cmd structs. Also introduce a list head and few helpers.
>>>>>
>>>>> This is in preparation to support nvme-mulitpath, allowing multiple
>>>>> uring passthrough commands to be queued.
>>>>
>>>> It's not clear to me why we need linking at that level?
>>>
>>> I think the attempt is to allow something like blk_steal_bios that
>>> nvme leverages for io_uring_cmd(s).
>>
>> I'll rephrase because now that I read it, I think my phrasing is
>> confusing.
>>
>> I think the attempt is to allow something like blk_steal_bios that
>> nvme leverages, but for io_uring_cmd(s). Essentially allow io_uring_cmd
>> to be linked in a requeue_list.
>
>I see. I wonder if there's some other way we can accomplish that, so we
>don't have to shrink the current space. io_kiocb already support
>linking, so seems like that should be workable.
>
>>> nvme failover steals all the bios from requests that fail (and should
>>> failover) and puts them on a requeue list, and then schedules
>>> a work that takes these bios one-by-one and submits them on a different
>>> bottom namespace (see nvme_failover_req/nvme_requeue_work).
>>
>> Maybe if io_kiocb could exposed to nvme, and it had some generic space
>> that nvme could use, that would work as well...
>
>It will be more exposed in 5.20, but passthrough is already using the
>per-op allotted space in the io_kiocb. But as mentioned above, there's
>already linking support between io_kiocbs, and that is likely what
>should be used here too.
>
io_kiocb linking is used if user-space wants to link SQEs for any
ordering. If we go this route, we give up that feature for
uring-command SQEs.

------OEEzMZle2oafIX2psGkTvPl59BrXC3apHO-sLjJPJT1qP5Pe=_81924_
Content-Type: text/plain; charset="utf-8"


------OEEzMZle2oafIX2psGkTvPl59BrXC3apHO-sLjJPJT1qP5Pe=_81924_--
