Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C140C59062A
	for <lists+io-uring@lfdr.de>; Thu, 11 Aug 2022 20:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbiHKSGu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Aug 2022 14:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbiHKSGt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Aug 2022 14:06:49 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392BDA220C
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 11:06:47 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220811180645epoutp010b7c18dcbc8d2a0f4a73de678b011fe2~KXJRsHa7M1988119881epoutp012
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 18:06:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220811180645epoutp010b7c18dcbc8d2a0f4a73de678b011fe2~KXJRsHa7M1988119881epoutp012
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1660241205;
        bh=IC499IQ/Dzlqkf12/27cf06uLSzagTMhqQJH5TerAss=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PqYdD2tQHy2BVH7iu+2HstFCtnargrSWI7UDZO0wdfJhT0b5XNu2Pdv86ra8yWZhc
         s6lXzkE7p0sJ9Xmk20qXBgCg4eGhQ7WeUzX89iLgruFR4f3zyBG7tEXL82u7BIP0Z3
         gJPKXt0NKa7G6JvoPiPmic3iBhp3iUPon+5NTj8Q=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220811180644epcas5p180ca37be7d24409ea2157c17034fbeac~KXJRQdyg32413824138epcas5p1W;
        Thu, 11 Aug 2022 18:06:44 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4M3ZWR10vtz4x9Pw; Thu, 11 Aug
        2022 18:06:43 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B8.A8.49477.33545F26; Fri, 12 Aug 2022 03:06:43 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220811180642epcas5p4ccd3f387021a73d0c7107f70127046ec~KXJPdVFPT2916829168epcas5p4p;
        Thu, 11 Aug 2022 18:06:42 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220811180642epsmtrp19702b9e9c248edbd6f75525316991275~KXJPcueDg0767907679epsmtrp1Y;
        Thu, 11 Aug 2022 18:06:42 +0000 (GMT)
X-AuditID: b6c32a49-843ff7000000c145-f9-62f54533cb53
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3F.CA.08905.23545F26; Fri, 12 Aug 2022 03:06:42 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220811180642epsmtip1aae5c7cb3b030808899c54d4408bd586~KXJOwXeco0182901829epsmtip1u;
        Thu, 11 Aug 2022 18:06:41 +0000 (GMT)
Date:   Thu, 11 Aug 2022 23:27:09 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     anuj20.g@samsung.com, io-uring@vger.kernel.org, ming.lei@redhat.com
Subject: Re: [PATCH] io_uring: fix error handling for io_uring_cmd
Message-ID: <20220811175709.GB16993@test-zns>
MIME-Version: 1.0
In-Reply-To: <9b80f3d8-bef6-11a2-deb2-f94750414404@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJKsWRmVeSWpSXmKPExsWy7bCmpq6x69ckg3nzWSyaJvxltlh9t5/N
        4l3rORaLQ5ObmRxYPC6fLfV4v+8qm0ffllWMHp83yQWwRGXbZKQmpqQWKaTmJeenZOal2yp5
        B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gBtVFIoS8wpBQoFJBYXK+nb2RTll5akKmTk
        F5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZ6w6t5K5YAt/xa2llg2M93i6GDk5
        JARMJE7sPMXUxcjFISSwm1HiyZELLBDOJ0aJaYvvMUI43xglVs16ygrTsqrtAitEYi+jxITD
        W9kgnGeMEr1L7rKDVLEIqEq07l0NVMXBwSagKXFhcilIWERAQaLn90o2EJtZwF3i4Z0NYOXC
        Ak4Ss58cZgGxeQV0Ja49uwdlC0qcnPkEzOYUsJVofToZrFdUQFniwLbjYHdLCNxjlzh5bQMz
        xHUuEvd2vYayhSVeHd/CDmFLSbzsb4OykyUuzTzHBGGXSDzecxDKtpdoPdXPDHFchsTOiQug
        DuWT6P39hAnkFwkBXomONiGIckWJe5NggSIu8XDGEijbQ2LLh6vskDC5zCTxcuFipgmMcrOQ
        /DMLyQoI20qi80MT6yygFcwC0hLL/3FAmJoS63fpL2BkXcUomVpQnJueWmxaYJiXWg6P4+T8
        3E2M4DSo5bmD8e6DD3qHGJk4GA8xSnAwK4nwli36nCTEm5JYWZValB9fVJqTWnyI0RQYPROZ
        pUST84GJOK8k3tDE0sDEzMzMxNLYzFBJnNfr6qYkIYH0xJLU7NTUgtQimD4mDk6pBialRe7C
        Hxks8+YXR6y4dXnz5T71ZcwKh3bkvv1j8/twRvLzj+qnfyboqRlMW/Mt5IH1Wh19Za9O1l1y
        IZVVNhde8fvPsstJ3SAdYXfB5cBfcyPtIzxVe45GTJ23442iU87p5yEnd0/d4HQl+bjfLFn5
        n2vssxq2XVLZIKPuvd+52+uyR1pur/by70oZjj+nJ5yfoLPj9re8+QIxeu9tX9WoL2QMjuCf
        y6YWwCWYL2xlPHOHYMm+D3szj6cxqX2vfvfSUHT6lr26K4InbjwqX9f66UlcTcLD/4+a7Vrl
        clta3kjO4A01qKhYN5HF9b4g46auFU++nN61fNK0c4F7+UJdV9tkNb3+NVFbNNrPik+JpTgj
        0VCLuag4EQDq4KpEDAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsWy7bCSnK6R69ckg/0zdCyaJvxltlh9t5/N
        4l3rORaLQ5ObmRxYPC6fLfV4v+8qm0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBlnD2bW/CM
        p+L+g1ksDYyruLoYOTkkBEwkVrVdYO1i5OIQEtjNKLHw/3JWiIS4RPO1H+wQtrDEyn/P2SGK
        njBK3PjYzwaSYBFQlWjduxqogYODTUBT4sLkUpCwiICCRM/vlWAlzALuEg/vbACbIyzgJDH7
        yWEWEJtXQFfi2rN7LBAzLzNJHLi9kA0iIShxcuYTFohmM4l5mx8yg8xnFpCWWP6PAyTMKWAr
        0fp0Mli5qICyxIFtx5kmMArOQtI9C0n3LITuBYzMqxglUwuKc9Nziw0LDPNSy/WKE3OLS/PS
        9ZLzczcxgsNaS3MH4/ZVH/QOMTJxMB5ilOBgVhLhLVv0OUmINyWxsiq1KD++qDQntfgQozQH
        i5I474Wuk/FCAumJJanZqakFqUUwWSYOTqkGpqgjB1fOcUh9q8GXckW59/nK+dNezZefanO5
        IWfn9+YDczdN+RtYWb4jU1b71Ye4clnR/jn5Wg9+Hc7zeh/EIB6a909fUdZIMaw27TE/6+mc
        5Em3P56LE9j8lkN0+qWZc5cW8Ub/eO7h9Vxaa6dd/+XzF6f6pLyQPnKm4y3Xg5zzYgr7/ixl
        Vfi1cH+rY990i5NFmYsEjC00xI7aGLvvErhsuLmwZ+FtTet/3rGvBeafsPp4uNHE8NU6t4zv
        jEuenVr5gN0ilMV+X/H7P/mX4jwmMLIzRf+bpWzSEfJl0dXDPxOiV55YfdLDe2/s+cvV+/Mz
        jARF5T23zF5z9X+E15xavbT1b6OnzvTZ1m+8YpcSS3FGoqEWc1FxIgDBJldL2gIAAA==
X-CMS-MailID: 20220811180642epcas5p4ccd3f387021a73d0c7107f70127046ec
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----WgjG.75RCK0vaugoxekoY7._5exx5H51ZqHYxOO8vRDHiV2S=_6ad34_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220811092503epcas5p2e945f7baa5cb0cd7e3d326602c740edb
References: <CGME20220811092503epcas5p2e945f7baa5cb0cd7e3d326602c740edb@epcas5p2.samsung.com>
        <20220811091459.6929-1-anuj20.g@samsung.com>
        <166023229266.192493.17453600546633974619.b4-ty@kernel.dk>
        <f172af9b-2321-c819-2e29-357d4f130159@kernel.dk>
        <20220811173553.GA16993@test-zns>
        <9b80f3d8-bef6-11a2-deb2-f94750414404@kernel.dk>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------WgjG.75RCK0vaugoxekoY7._5exx5H51ZqHYxOO8vRDHiV2S=_6ad34_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Thu, Aug 11, 2022 at 11:51:29AM -0600, Jens Axboe wrote:
>On 8/11/22 11:35 AM, Kanchan Joshi wrote:
>> On Thu, Aug 11, 2022 at 10:55:29AM -0600, Jens Axboe wrote:
>>> On 8/11/22 9:38 AM, Jens Axboe wrote:
>>>> On Thu, 11 Aug 2022 14:44:59 +0530, Anuj Gupta wrote:
>>>>> Commit 97b388d70b53 ("io_uring: handle completions in the core") moved the
>>>>> error handling from handler to core. But for io_uring_cmd handler we end
>>>>> up completing more than once (both in handler and in core) leading to
>>>>> use_after_free.
>>>>> Change io_uring_cmd handler to avoid calling io_uring_cmd_done in case
>>>>> of error.
>>>>>
>>>>> [...]
>>>>
>>>> Applied, thanks!
>>>>
>>>> [1/1] io_uring: fix error handling for io_uring_cmd
>>>>       commit: f1bb0fd63c374e1410ff05fb434aa78e1ce09ae4
>>>
>>> Ehm, did you compile this:
>> Sorry. Version that landed here got a upgrade in
>> commit-description but downgrade in this part :-(
>
>I fixed it up.

noticed, thanks.

>> BTW, we noticed the original issue while testing fixedbufs support.
>> Thinking to add a liburing test that involves sending a command which
>> nvme will fail during submission. Can come in handy.
>
>I think that's a good idea - if you had eg a NOP linked after a passthru
>command that failed, then that would catch this case.

Right. For now in liburing test we don't do anything that is guranteed
to fail from nvme-side. Test issues iopoll (that fails) but that failure
comes from io_uring itself (as .iopoll is not set). So another test that
will form a bad passthru command (e.g. wrong nsid) which only nvme can
(and will) fail.

------WgjG.75RCK0vaugoxekoY7._5exx5H51ZqHYxOO8vRDHiV2S=_6ad34_
Content-Type: text/plain; charset="utf-8"


------WgjG.75RCK0vaugoxekoY7._5exx5H51ZqHYxOO8vRDHiV2S=_6ad34_--
