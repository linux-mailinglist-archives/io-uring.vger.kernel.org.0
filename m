Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE946E2564
	for <lists+io-uring@lfdr.de>; Fri, 14 Apr 2023 16:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjDNOO7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Apr 2023 10:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbjDNOOs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Apr 2023 10:14:48 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2B3C164
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 07:14:15 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230414141402epoutp02ccb5bdfb6ee95130ec687aaa94aca618~V0qUug04N0431304313epoutp02i
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 14:14:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230414141402epoutp02ccb5bdfb6ee95130ec687aaa94aca618~V0qUug04N0431304313epoutp02i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1681481642;
        bh=lj0gVRn/bKS++4nKkcIaA6aqxfYvm/8QYI+jfgsXIEA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KphNYpTEU4VN2JR/f+xyrMmMUCmQGs7w9qpnwNTNSfko3WBKpfhOpc8nVFNmgh2jD
         qjexftOKu4NHTygWTsp7gthhfC39/dZhzTORI9etk4yfYB793+k4mFf7MSpFtdYWK5
         xpKbhu9Hwq8pQZXW2AgzZq/vgAzh864Kq7kHhGhs=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230414141402epcas5p2b8624584dae0ba39ad9d44aa337fc066~V0qUcpSo62256922569epcas5p2w;
        Fri, 14 Apr 2023 14:14:02 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4PydjN6X3lz4x9Pp; Fri, 14 Apr
        2023 14:14:00 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        36.30.09961.8AF59346; Fri, 14 Apr 2023 23:14:00 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20230414141400epcas5p23a48bedb6e7fc93d4c75c778cb235667~V0qSp7Y3E1523515235epcas5p2Q;
        Fri, 14 Apr 2023 14:14:00 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230414141400epsmtrp2289425b60fa4d5af6b0ab0bb17aeefec~V0qSpwGsO1068610686epsmtrp2C;
        Fri, 14 Apr 2023 14:14:00 +0000 (GMT)
X-AuditID: b6c32a49-52dfd700000026e9-de-64395fa8d323
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        29.73.08609.8AF59346; Fri, 14 Apr 2023 23:14:00 +0900 (KST)
Received: from green5 (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20230414141359epsmtip2b1af7b810b33f04b47052d9eeea5b937~V0qR8Z46q0057700577epsmtip2M;
        Fri, 14 Apr 2023 14:13:59 +0000 (GMT)
Date:   Fri, 14 Apr 2023 19:43:15 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring: complete request via task work in case of
 DEFER_TASKRUN
Message-ID: <20230414141315.GC5049@green5>
MIME-Version: 1.0
In-Reply-To: <ZDlay1++tidiKv+n@ovpn-8-21.pek2.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGKsWRmVeSWpSXmKPExsWy7bCmlu6KeMsUgzUL9S3mrNrGaLH6bj+b
        xbvWcywWhyY3MzmweOycdZfd4/LZUo/3+66yeXzeJBfAEpVtk5GamJJapJCal5yfkpmXbqvk
        HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCR
        X1xiq5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQnXGtaQdLwSbeipuzfzE1MPZzdzFy
        ckgImEi8azzF3sXIxSEksJtR4srihWwQzidGiUsLF0M5nxklZj/5xAzTsuziPKiWXYwSXx+d
        ZwVJCAk8YZTY/1i3i5GDg0VAVeLUVnsQk01AU+LC5FKQChEBJYm7d1ezg9jMAqkSr15/YQSx
        hQUiJBYtnAlm8wpoSdx9c4sFwhaUODnzCQvIGE4BS4ldE+NAwqICyhIHth1nArlAQuAeu0T/
        5l+MEKe5SCy62MYKYQtLvDq+hR3ClpL4/G4vG4SdLHFp5jkmCLtE4vGeg1C2vUTrqX5miNsy
        JF5MWwx1J59E7+8nTCA3SAjwSnS0CUGUK0rcm/QUapW4xMMZS1ghSjwk+o7zQQLnPaPE4jcv
        GCcwys1C8s0sJBsgbCuJzg9NrLOA2pkFpCWW/+OAMDUl1u/SX8DIuopRMrWgODc9tdi0wDAv
        tRwewcn5uZsYwQlQy3MH490HH/QOMTJxMB5ilOBgVhLhrbK0TBHiTUmsrEotyo8vKs1JLT7E
        aAqMm4nMUqLJ+cAUnFcSb2hiaWBiZmZmYmlsZqgkzqtuezJZSCA9sSQ1OzW1ILUIpo+Jg1Oq
        gcmzPnqKQVET7xNBrXcFz5uMZ72uCoxou6HBp5C61Lbj/I6X3kxa3NfuM9o8KCxeEHmvbf7j
        p/aC/1SMP+zaWCF16briu3lJcbbS59u0y6U4La76nRTsTqj3frzp+nmNYweF1zKUTXjbWxwb
        OF0zXGCezg7pyn2yIRt5zTzsWEtD63b8+yg1q3HN+56ec37rfRK691pKBl1j37764rz8xN97
        elOMFdwmvdI3mf99y0nzEmHPhP6eA8ZX5k3YINe5IIZjonXqtNYF32N1jroebK9X2MG/QpbV
        +O+sjSJlclKXq41qw05MWRRY1qmZenIN5/7y46Yu6yuyxVsTUmdpuvw+s2zFjgkShzcs/T8x
        XImlOCPRUIu5qDgRADA2GyQJBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsWy7bCSvO6KeMsUg1XTZC3mrNrGaLH6bj+b
        xbvWcywWhyY3MzmweOycdZfd4/LZUo/3+66yeXzeJBfAEsVlk5Kak1mWWqRvl8CVMePyWcaC
        J1wVL//tYW1gvM3RxcjJISFgIrHs4jz2LkYuDiGBHYwSx768ZoZIiEs0X/vBDmELS6z89xzM
        FhJ4xCgx9VBWFyMHB4uAqsSprfYgJpuApsSFyaUgFSICShJ3764Gq2YWSJV49foLI4gtLBAh
        sWjhTDCbV0BL4u6bWywQa98zSqxZ3MgEkRCUODnzCQtEs5nEvM0PmUHmMwtISyz/xwFicgpY
        SuyaGAdSISqgLHFg23GmCYyCs5A0z0LSPAuheQEj8ypGydSC4tz03GLDAqO81HK94sTc4tK8
        dL3k/NxNjOCQ1tLawbhn1Qe9Q4xMHIyHGCU4mJVEeKssLVOEeFMSK6tSi/Lji0pzUosPMUpz
        sCiJ817oOhkvJJCeWJKanZpakFoEk2Xi4JRqYFpxY8OZORatNuXv+NpYXlzJ2rn00e9L9o0s
        PNsXM51RXvriMd+q6X/vHDdsWsnWt9bc6ON6W4PkIsu3QmFZMZyeXJf/8V+e/OOfg3uw9/XJ
        a0wmFpyefD7HYOqLpVy1TQcVdKuu9Rht9Mw2l5rkvCPyp8rWm9lTKsWji6b5XU3r2XSq055r
        rnaZU/2aXF3JxmbfdaElNn/+pcz0Y8mOf76MQ7Yv76b51ZybvgfKm3bHsf984/Dz7cz17VM9
        Jh9OSfW6YjDnxrLOM5X9UhYbenLfCHGvvdPOtkC8s+drFN/ROpaSL++PBtonXuf7sj7t6NZ3
        GyboLXaSLJDWd2d47HioSVrlhoTuyvUdyQnfZymxFGckGmoxFxUnAgCNQaBY2AIAAA==
X-CMS-MailID: 20230414141400epcas5p23a48bedb6e7fc93d4c75c778cb235667
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----6TPaBgSVJHTP5aYW_KCyJfD-AyyqAIDIArT8HI0pnVcs47o3=_1a3cd_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230414135423epcas5p356635b820c297c1d3a5b806ba8340bfb
References: <20230414075313.373263-1-ming.lei@redhat.com>
        <68ddddc0-fb0e-47b4-9318-9dd549d851a1@gmail.com>
        <CGME20230414135423epcas5p356635b820c297c1d3a5b806ba8340bfb@epcas5p3.samsung.com>
        <ZDlay1++tidiKv+n@ovpn-8-21.pek2.redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------6TPaBgSVJHTP5aYW_KCyJfD-AyyqAIDIArT8HI0pnVcs47o3=_1a3cd_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Fri, Apr 14, 2023 at 09:53:15PM +0800, Ming Lei wrote:
>On Fri, Apr 14, 2023 at 02:01:26PM +0100, Pavel Begunkov wrote:
>> On 4/14/23 08:53, Ming Lei wrote:
>> > So far io_req_complete_post() only covers DEFER_TASKRUN by completing
>> > request via task work when the request is completed from IOWQ.
>> >
>> > However, uring command could be completed from any context, and if io
>> > uring is setup with DEFER_TASKRUN, the command is required to be
>> > completed from current context, otherwise wait on IORING_ENTER_GETEVENTS
>> > can't be wakeup, and may hang forever.
>>
>> fwiw, there is one legit exception, when the task is half dead
>> task_work will be executed by a kthread. It should be fine as it
>> locks the ctx down, but I can't help but wonder whether it's only
>> ublk_cancel_queue() affected or there are more places in ublk?
>
>No, it isn't.
>
>It isn't triggered on nvme-pt just because command is always done
>in task context.
>
>And we know more uring command cases are coming.

FWIW, the model I had in mind (in initial days) was this -
1) io_uring_cmd_done is a simple API, it just posts one/two results into
reuglar/big SQE
2) for anything complex completion (that requires task-work), it will
use another API io_uring_cmd_complete_in_task with the provider-specific
callback (that will call above simple API eventually)


------6TPaBgSVJHTP5aYW_KCyJfD-AyyqAIDIArT8HI0pnVcs47o3=_1a3cd_
Content-Type: text/plain; charset="utf-8"


------6TPaBgSVJHTP5aYW_KCyJfD-AyyqAIDIArT8HI0pnVcs47o3=_1a3cd_--
