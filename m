Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 411D550B339
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 10:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445608AbiDVIuv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 04:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343811AbiDVIut (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 04:50:49 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30662532F1
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 01:47:56 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220422084754epoutp01426c53017aa1cfae5d697e49c276a768~oK6pVghVP1058910589epoutp01N
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 08:47:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220422084754epoutp01426c53017aa1cfae5d697e49c276a768~oK6pVghVP1058910589epoutp01N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1650617274;
        bh=d+CMiADNx8fxTHacPyCud55VGK1IgpKg6FW+HTovnAI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i4zO7pUpM0fC66nuudtuWrpFlCkVf17tBWndLZeIZ7JLnDNVwh4dr72IcyA9GD9Z8
         SAMtkET/Re35VoQxcPeZfUQDzZ3MF/7haCfB5qQoPHSdN839+CZKTINZG/BhMS3Coc
         LJjP9fHmg381B+QCiWo8foLqanuhGuvTJU2fbEfc=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220422084753epcas5p11ec8a014401d9b855f5f9a3394988025~oK6o1IuyZ2473524735epcas5p17;
        Fri, 22 Apr 2022 08:47:53 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Kl7Mm4v8Gz4x9Px; Fri, 22 Apr
        2022 08:47:48 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B3.05.06423.2BB62626; Fri, 22 Apr 2022 17:47:46 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220422031426epcas5p3666846aa9046ba48704d8196ca520e71~oGXgDMV4c2968429684epcas5p3L;
        Fri, 22 Apr 2022 03:14:26 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220422031426epsmtrp23e39b8fd57157ae27f50b874805307a4~oGXgCecFl2449624496epsmtrp2Z;
        Fri, 22 Apr 2022 03:14:26 +0000 (GMT)
X-AuditID: b6c32a49-b01ff70000001917-17-62626bb2bae6
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        97.BC.24342.29D12626; Fri, 22 Apr 2022 12:14:26 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220422031425epsmtip17ccf0f1007d7882c65192708b0285314~oGXfI4Mou1189411894epsmtip1Z;
        Fri, 22 Apr 2022 03:14:25 +0000 (GMT)
Date:   Fri, 22 Apr 2022 08:39:18 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>, kernel-team@fb.com,
        io-uring@vger.kernel.org
Subject: Re: [PATCH v2 00/12] add large CQE support for io-uring
Message-ID: <20220422030918.GA20692@test-zns>
MIME-Version: 1.0
In-Reply-To: <7dfcf6e8-ac16-5ab1-cb71-6ef81849af82@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgk+LIzCtJLcpLzFFi42LZdlhTU3dTdlKSwcd70hZzVm1jtFh9t5/N
        4l3rORaLY33vWS2uvjzA7sDqMbH5HbvHzll32T0uny31+LxJLoAlKtsmIzUxJbVIITUvOT8l
        My/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2itkkJZYk4pUCggsbhYSd/Opii/
        tCRVISO/uMRWKbUgJafApECvODG3uDQvXS8vtcTK0MDAyBSoMCE7Y9nf/UwFd/gr2r5JNjB2
        83YxcnJICJhIPJ17i62LkYtDSGA3o8TBpZ1MEM4nRol9J0+wQDjfGCUONRxig2n5d/ArVNVe
        RomHu14xQzjPGCVOTnzLDlLFIqAqsXPFeiCbg4NNQFPiwuRSkLCIgIJEz++VbCBhZoFyiX/L
        HUHCwgIOEje/7gHr5BXQlVh28TYThC0ocXLmExYQm1PAVmLL5E2MILaogLLEgW3HwW6QELjH
        LvHm8l0WkJkSAi4Sxw6nQNwpLPHq+BZ2CFtK4vO7vVD3J0u0br/MDlFeIrFkgTpE2F7i4p6/
        YGuZBTIkHi35ywIRl5WYemodVJxPovf3EyaIOK/EjnkwtqLEvUlPWSFscYmHM5ZA2R4Sc84s
        Y4WETjezxJ+Dz1gnMMrPQvLaLCT7IGwric4PTayzwCEkLbH8HweEqSmxfpf+AkbWVYySqQXF
        uempxaYFhnmp5fDYTs7P3cQITpJanjsY7z74oHeIkYmD8RCjBAezkghv6Mz4JCHelMTKqtSi
        /Pii0pzU4kOMpsCImsgsJZqcD0zTeSXxhiaWBiZmZmYmlsZmhkrivKfTNyQKCaQnlqRmp6YW
        pBbB9DFxcEo1MHl2VKTrqeTFBk6Odvg0u3Pp7VvbciJ1POOaZ6evc5hYta6kNq33stHB6Wwb
        d1gulfrFxfz066nbB9Nr7r1jSX3+qaQj5NkLLY1AH8GXOY98AgSmG5qtNsgwsu48YiIodTyC
        68t1DV3uufkJWQHz+8sfG1kv217MeOxH9NmJ+v48zjLGe75GZ1qoPVIN+Sqe8+XMDsdF77Yk
        Ze6Yt0/HgZHbc7X7n5zJu7qMvwjuWWVv/jRNxmr2Fz2Lexqq0hUpqWUdzNITxKc3Tisq6I2b
        kvxn9lJ//e6KYL7yVTLXv/d8i7l34ZzFzZqJNfzMF28Es3rk5qvq9ExvECrbzr554tPWEoG+
        r3M78gvFwn4rsRRnJBpqMRcVJwIA1YweuhsEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsWy7bCSnO4k2aQkg45eRYs5q7YxWqy+289m
        8a71HIvFsb73rBZXXx5gd2D1mNj8jt1j56y77B6Xz5Z6fN4kF8ASxWWTkpqTWZZapG+XwJVx
        aO0l5oI+3opFzzgaGK9zdTFyckgImEj8O/iVqYuRi0NIYDejxKvO6SwQCXGJ5ms/2CFsYYmV
        /56zQxQ9YZRovP2fESTBIqAqsXPFeqAEBwebgKbEhcmlIGERAQWJnt8r2UDCzALlEv+WO4KE
        hQUcJG5+3QM2kldAV2LZxdtQe7uZJXq+P2aGSAhKnJz5BOwGZgEziXmbHzJDzJGWWP6PAyTM
        KWArsWXyJrALRAWUJQ5sO840gVFwFpLuWUi6ZyF0L2BkXsUomVpQnJueW2xYYJiXWq5XnJhb
        XJqXrpecn7uJERzeWpo7GLev+qB3iJGJg/EQowQHs5IIb+jM+CQh3pTEyqrUovz4otKc1OJD
        jNIcLErivBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUamAQ7Cqvl45te+N0zsRas3SXiWnqg59Ci
        KusMa/0JhSUMi9d7pfyxnbF+d/isSwf3Ze03n2OaeFZwwaM29eVf2ZbNSPDsOS58VH22tt2b
        c46zRLnD9i9nWpnHGthyhX+NoLfbEw/FdxqcH70clwbuDzx13ZKTbZ7966tTpqV4SZ6VYrAs
        /aKfsFh/nVVfQ7X1d4cQqxrJg04LVWb77DF/f+R3UPjNQ/P1uxYd25wtvpIniNEm3HnGLQEG
        lfTWJq7WLa/XPnpW++Sm2j/BDZuXv/6Y5Hddtzp9o0h0RK2xpUNEr5HcY/UFittWXsk6sbXH
        2nL+DOHNN97s4fbp3NC53mNTR8I8L1s3uxnSrNmblFiKMxINtZiLihMBQMy1ON4CAAA=
X-CMS-MailID: 20220422031426epcas5p3666846aa9046ba48704d8196ca520e71
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----48ALem4cADf3xwa-0Uc1Gf-iSzVqekzis73It7X2K98eFieH=_9d845_"
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
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------48ALem4cADf3xwa-0Uc1Gf-iSzVqekzis73It7X2K98eFieH=_9d845_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Thu, Apr 21, 2022 at 12:59:42PM -0600, Jens Axboe wrote:
>On 4/21/22 12:57 PM, Pavel Begunkov wrote:
>> On 4/21/22 19:49, Stefan Roesch wrote:
>>> On 4/21/22 11:42 AM, Pavel Begunkov wrote:
>>>> On 4/20/22 23:51, Jens Axboe wrote:
>>>>> On Wed, 20 Apr 2022 12:14:39 -0700, Stefan Roesch wrote:
>>>>>> This adds the large CQE support for io-uring. Large CQE's are 16 bytes longer.
>>>>>> To support the longer CQE's the allocation part is changed and when the CQE is
>>>>>> accessed.
>>>>>>
>>>>>> The allocation of the large CQE's is twice as big, so the allocation size is
>>>>>> doubled. The ring size calculation needs to take this into account.
>>>>
>>>> I'm missing something here, do we have a user for it apart
>>>> from no-op requests?
>>>>
>>>
>>> Pavel, what started this work is the patch series "io_uring passthru over nvme" from samsung.
>>> (https://lore.kernel.org/io-uring/20220308152105.309618-1-joshi.k@samsung.com/)
>>>
>>> They will use the large SQE and CQE support.
>>
>> I see, thanks for clarifying. I saw it used in passthrough
>> patches, but it only got me more confused why it's applied
>> aforehand separately from the io_uring-cmd and passthrough
>
>It's just applied to a branch so the passthrough folks have something to
>base on, io_uring-big-sqe. It's not queued for 5.19 or anything like
>that yet.
>
Thanks for putting this up.
I am bit confused whether these (big-cqe) and big-sqe patches should
continue be sent (to nvme list too) as part of next
uring-cmd/passthrough series?

And does it make sense to squash somes patches of this series; at
high-level there is 32b-CQE support, and no-op support.

------48ALem4cADf3xwa-0Uc1Gf-iSzVqekzis73It7X2K98eFieH=_9d845_
Content-Type: text/plain; charset="utf-8"


------48ALem4cADf3xwa-0Uc1Gf-iSzVqekzis73It7X2K98eFieH=_9d845_--
