Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF39573583
	for <lists+io-uring@lfdr.de>; Wed, 13 Jul 2022 13:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235706AbiGMLec (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jul 2022 07:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235313AbiGMLeb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jul 2022 07:34:31 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D02606B0
        for <io-uring@vger.kernel.org>; Wed, 13 Jul 2022 04:34:26 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220713113421epoutp032f86fe2e568e3ff93588e3e9e35b3b19~BYFY3e1zc2841528415epoutp03C
        for <io-uring@vger.kernel.org>; Wed, 13 Jul 2022 11:34:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220713113421epoutp032f86fe2e568e3ff93588e3e9e35b3b19~BYFY3e1zc2841528415epoutp03C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1657712061;
        bh=jNQcGckq/C69LOQQ/cLEX1diqAcKv25heOBBxeK9Hso=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lSfEd2KHIQktyW4L4hq1jZqiz8gPC/IPIM0y3mxJKJm9ibKBKdbM9YV+H2jtNpS4t
         9VmMPFrCsQImJS6N+S/Rmwn0D7HSFCrnGTGIhse5emIEQJPTmd63laCplhU92ncM0Q
         jnH1hSZvL5tPQievOSrS3NZfOjnwQPwTM3DymFb0=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220713113420epcas5p2f6ffffb7b4a28367683dd698421701db~BYFYUPfqL1307313073epcas5p2V;
        Wed, 13 Jul 2022 11:34:20 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4LjbB21tw3z4x9Q0; Wed, 13 Jul
        2022 11:34:18 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EA.A1.09662.8BDAEC26; Wed, 13 Jul 2022 20:34:16 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220713113415epcas5p3ebffdbb62e1ec75e91fddb55a349bb01~BYFTi17KU1019810198epcas5p3J;
        Wed, 13 Jul 2022 11:34:15 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220713113415epsmtrp2705cca99a2e2583cf1ed427b270b4bca~BYFThs_6R2637826378epsmtrp2Y;
        Wed, 13 Jul 2022 11:34:15 +0000 (GMT)
X-AuditID: b6c32a49-885ff700000025be-98-62ceadb83bcb
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        0A.66.08905.7BDAEC26; Wed, 13 Jul 2022 20:34:15 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220713113413epsmtip1962effb45ddc119218799b3a3c3e60a1~BYFR7ek5_0690606906epsmtip1N;
        Wed, 13 Jul 2022 11:34:13 +0000 (GMT)
Date:   Wed, 13 Jul 2022 16:58:50 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     hch@lst.de, kbusch@kernel.org, axboe@kernel.dk,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, asml.silence@gmail.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
Subject: Re: [PATCH for-next 4/4] nvme-multipath: add multipathing for
 uring-passthrough commands
Message-ID: <20220713112850.GD30733@test-zns>
MIME-Version: 1.0
In-Reply-To: <f15bc945-8192-c10e-70d8-9946ae2969ce@grimberg.me>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHJsWRmVeSWpSXmKPExsWy7bCmhu6OteeSDBo+C1g0TfjLbDFn1TZG
        i9V3+9ksbh7YyWSxcvVRJot3redYLM6/PcxkMenQNUaLvbe0LeYve8puse71exYHbo+ds+6y
        e5y/t5HF4/LZUo9NqzrZPDYvqffYfbOBzaNvyypGj8+b5AI4orJtMlITU1KLFFLzkvNTMvPS
        bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4DOVFIoS8wpBQoFJBYXK+nb2RTll5ak
        KmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZ9y4o1CwiL9i2cwmxgbGYzxd
        jJwcEgImEo9e/GLsYuTiEBLYzSjx99IPKOcTo8T+t+uZIZxvjBI3m64zwrQs2jeTFSKxl1Gi
        8dkmqKpnjBI7F/5mAaliEVCVWPx3ClAVBwebgKbEhcmlIKaIgIrEmze5IOXMAi8YJRbOW8gK
        Ui4skCyx6ckkJhCbV0BXon//aVYIW1Di5MwnYCM5BewlPs34zgZiiwooSxzYdpwJZJCEwFoO
        iVNff0Jd5yKx5nUXG4QtLPHq+BZ2CFtK4vO7vVDxZIlLM88xQdglEo/3HISy7SVaT/Uzg9jM
        ApkS6ya1skHYfBK9v58wgTwgIcAr0dEmBFGuKHFv0lNWCFtc4uGMJVC2h8TH+c3skDD5yyzx
        qPEc4wRGuVlI/pmFZAWEbSXR+aGJdRbQCmYBaYnl/zggTE2J9bv0FzCyrmKUTC0ozk1PLTYt
        MMxLLYfHcXJ+7iZGcMLV8tzBePfBB71DjEwcjIcYJTiYlUR4/5w9lSTEm5JYWZValB9fVJqT
        WnyI0RQYPROZpUST84EpP68k3tDE0sDEzMzMxNLYzFBJnNfr6qYkIYH0xJLU7NTUgtQimD4m
        Dk6pBqau84knW5L/RW76UXxAIcv/4wKNW/sLlbRfT3VIO3pTzORmUdLrrwHll48rSJ2Wzot6
        YJb08d06ExHRBcfMXNb/n7g2ZNFSppx/0pJTA7e3z/K3jrcNenbeuejeV7kFFdZXXwrc08mf
        yLLqo6yHl/GjglB5kYXHd5rPeC346gxbafCdZ2dmXErbK/NSTSTrzJFUqdqiXE7losaDtoXJ
        K278P7LMrELBOE2+YN6hWZ+eaGc9qWI68njGOp3fJY3cz/5Gr4u51WJ7v6NMsSH0L6tWymyV
        3Z0ch6P2s/4qmJY1NzM540fFzGVnLE8qvm5by7yvWdx76+fsCY4cKdaX1PgFC6+7NzByXH4z
        wUnojasSS3FGoqEWc1FxIgA8sd4CQQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWy7bCSnO72teeSDJbuE7domvCX2WLOqm2M
        Fqvv9rNZ3Dywk8li5eqjTBbvWs+xWJx/e5jJYtKha4wWe29pW8xf9pTdYt3r9ywO3B47Z91l
        9zh/byOLx+WzpR6bVnWyeWxeUu+x+2YDm0ffllWMHp83yQVwRHHZpKTmZJalFunbJXBlXNr0
        mqXgIk/FrdPTWBoY+7m6GDk5JARMJBbtm8naxcjFISSwm1Fi+4XdzBAJcYnmaz/YIWxhiZX/
        noPZQgJPGCXWtyWD2CwCqhKL/04BaubgYBPQlLgwuRTEFBFQkXjzJhdkJLPAC0aJi1e2sICU
        CwskS2x6MokJxOYV0JXo338aau9fZok356axQCQEJU7OfAJmMwuYSczb/JAZZCizgLTE8n8c
        IGFOAXuJTzO+s4HYogLKEge2HWeawCg4C0n3LCTdsxC6FzAyr2KUTC0ozk3PLTYsMMxLLdcr
        TswtLs1L10vOz93ECI4gLc0djNtXfdA7xMjEwXiIUYKDWUmE98/ZU0lCvCmJlVWpRfnxRaU5
        qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0tSC2CyTJxcEo1MJlqvW790G2vfmyd3vprMVMctaNC
        n5U9sDnQp7evra02Mu97kOzK25+NrjHvXiK04U1icWDHozccD7yK356Qd646aviYsTLhwgOH
        csEZ3dKXdugxLioJSE+KT2w31fqi35J3f5143sWrzlvbu+OkeKae7lX0Ohixylvpf5sWg7rZ
        xYNHJ+gtWPZz696Sd/d3PxG6kbDz1pGsnYEFcsFq07I/b/mu6TwvbNH/iSmPF+pfLmWbaXdS
        IedM45KrDLWC6SyNZ3iyjb+VLVYr2sfp1Xw7fc9Ch0Vi5f/XbvvkybrynjLP8Sa/dy32s/J4
        d9s28YTO+PZwVqhzlGgze1JgwHZnn26dd45uftvfyl/dpsRSnJFoqMVcVJwIADW4z8kPAwAA
X-CMS-MailID: 20220713113415epcas5p3ebffdbb62e1ec75e91fddb55a349bb01
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----jllqsR28.5W1KdEnZlWKzx60EIuo6gwqBUS1IW9J_3KKio4g=_128281_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220711110827epcas5p3fd81f142f55ca3048abc38a9ef0d0089
References: <20220711110155.649153-1-joshi.k@samsung.com>
        <CGME20220711110827epcas5p3fd81f142f55ca3048abc38a9ef0d0089@epcas5p3.samsung.com>
        <20220711110155.649153-5-joshi.k@samsung.com>
        <3fc68482-fb24-1f39-5428-faa3a8db9ecb@grimberg.me>
        <20220711183746.GA20562@test-zns>
        <5f30c7de-03b1-768a-d44f-594ed2d1dc75@grimberg.me>
        <20220712042332.GA14780@test-zns>
        <3a2b281b-793b-b8ad-6a27-138c89a46fac@grimberg.me>
        <20220713053757.GA15022@test-zns>
        <f15bc945-8192-c10e-70d8-9946ae2969ce@grimberg.me>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------jllqsR28.5W1KdEnZlWKzx60EIuo6gwqBUS1IW9J_3KKio4g=_128281_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Wed, Jul 13, 2022 at 12:03:48PM +0300, Sagi Grimberg wrote:
>
>>>However io_kiocb is less
>>>constrained, and could be used as a context to hold such a space.
>>>
>>>Even if it is undesired to have io_kiocb be passed to uring_cmd(), it
>>>can still hold a driver specific space paired with a helper to obtain it
>>>(i.e. something like io_uring_cmd_to_driver_ctx(ioucmd) ). Then if the
>>>space is pre-allocated it is only a small memory copy for a stable copy
>>>that would allow a saner failover design.
>>
>>I am thinking along the same lines, but it's not about few bytes of
>>space rather we need 80 (72 to be precise). Will think more, but
>>these 72 bytes really stand tall in front of my optimism.
>
>You don't have to populate this space on every I/O, you can just
>populate it when there is no usable path and when you failover a
>request...

Getting the space and when/how to populate it - related but diferent
topics in this context.

It is about the lifetime of SQE which is valid only for the first
submission. If we don't make the command stable at that point, we don't
have another chance. And that is exactly what happens for failover.
Since we know IO is failed only when it fails, but by that time
original passthrough-command is gone out of hand. I think if we somehow
get the space (preallocated), it is ok to copy to command for every IO
in mpath case.

The other part (no usuable path) is fine, because we hit that condition
during initial submission and therefore have the chance to allocate/copy
the passthrough command. This patch already does that. 



------jllqsR28.5W1KdEnZlWKzx60EIuo6gwqBUS1IW9J_3KKio4g=_128281_
Content-Type: text/plain; charset="utf-8"


------jllqsR28.5W1KdEnZlWKzx60EIuo6gwqBUS1IW9J_3KKio4g=_128281_--
