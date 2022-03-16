Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7114DADE2
	for <lists+io-uring@lfdr.de>; Wed, 16 Mar 2022 10:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355000AbiCPJzS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Mar 2022 05:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352334AbiCPJzR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Mar 2022 05:55:17 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246D13527C
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 02:54:01 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220316095356epoutp03244cc6f660b426d7a983f4be471413e6~c08vSNkbX0804608046epoutp03u
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 09:53:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220316095356epoutp03244cc6f660b426d7a983f4be471413e6~c08vSNkbX0804608046epoutp03u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1647424436;
        bh=mSMJ9cGzydVxQn3GOG+Xz40/39UD/07WX/O511Ux3dc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ugGzC+kLVsxZupYSH7OoOT+Ny9fylmQ4ZtSQIdfnbytfqMzChMFCvINBVIC9s5aZQ
         t03BGoYXhqeAZcpBwXEJzdKVPIUb9qXm4Yw2xlDrJUp0VXzR/doAuXAYqzJSnnZf2y
         ntxu0svVpiVRXSJfkBSGDbqf/vml9WhiYLU4arxo=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220316095355epcas5p2d9effa961ba45f0acb61d59a4e4afc30~c08uoPPHo1366013660epcas5p2f;
        Wed, 16 Mar 2022 09:53:55 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4KJQb313Kfz4x9Q7; Wed, 16 Mar
        2022 09:53:51 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        08.F4.12523.FA3B1326; Wed, 16 Mar 2022 18:53:51 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220316092656epcas5p49e5a6fea697e69f6ed465c13f1298b84~c0lKysoFA3265232652epcas5p4S;
        Wed, 16 Mar 2022 09:26:56 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220316092656epsmtrp1c301fe2f25338646d25904a082904183~c0lKxs5Tp1643116431epsmtrp1y;
        Wed, 16 Mar 2022 09:26:56 +0000 (GMT)
X-AuditID: b6c32a4a-5a1ff700000030eb-fd-6231b3afea2a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        CD.94.03370.06DA1326; Wed, 16 Mar 2022 18:26:56 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220316092653epsmtip191cd7737b14754c7ca47476899eae306~c0lIg4rCT1872618726epsmtip1G;
        Wed, 16 Mar 2022 09:26:53 +0000 (GMT)
Date:   Wed, 16 Mar 2022 14:51:53 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Kanchan Joshi <joshiiitr@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, Pankaj Raghav <pankydev8@gmail.com>,
        Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 05/17] nvme: wire-up support for async-passthru on
 char-device.
Message-ID: <20220316092153.GA4885@test-zns>
MIME-Version: 1.0
In-Reply-To: <8f45a761-5ecb-5911-1064-9625a285c93d@grimberg.me>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Tf1BUVRTH5773dvdBrj35EddFDJ86zkrALu7SW4YNMqun1kRTNhl/0APe
        LAT7o327ReokI5CAhoDj8MMEgp0lYJNkCQlhYkDajN8pAgXomiCIoQPMOKOA7fKg8b/POed7
        7jnnnntx1MsplODJOhNr1DGppNATa+qUSoPr7fJ4mf0qRhV1bqNO5C+j1He1TYCqGz8jpGrq
        uhBqLqsPo3K6BxCq/99OhCrsuAmotr+CqHLrpIiyZDmE1Ej+JKBso5MYdXH2IUYt9JQJogl6
        amgK0L+Ujovo/olLGJ1RMYbR13vNdENtjpC2W47TV0bThXRT1YyAzmusBfRCw9aYFz5JiUxi
        mUTWGMjqEvSJyTqNmjz4QdwbccpwmTxYrqJeJQN1jJZVk/veiQl+KznVNQ0Z+AWTana5YhiO
        I0NfizTqzSY2MEnPmdQka0hMNSgMIRyj5cw6TYiONUXIZbIwpUv4aUpSZWmR0PAjkWZzXkDS
        Qb84F3jgkFDABscQlgs8cS/iCoCztjYBb8wDOHHjDupWeRELABZY0tYz2mxZgBe1ADhSPC/k
        jSkAfz7ZCdwqjNgJ70/9juQCHBcSUjhw1uxGH2IHfPBA65ajRB4Ghx9fw9xyb+IQzMw6hbhZ
        TLwCv+/+W8TzJnit5O6qxoOIgo3ZMwI3+xLbYXuTA+EbmsZhZUsAz/vgXJFTwLM3vO9oFPEs
        gTNnvlljDj4Z60LdTUAiG8Dh9BKMD0TBwdbl1UNRIhnaVoYB7w+A5/64uObfCL99enetsBg2
        l63zNjhROLlW2A86iy0C98CQoKHlvD9/P3MIfPjPMywfvFz63Gylz5XjOQLmPDohKHWlo4Q/
        rF7BeZTC+pbQCiCoBZtZA6fVsJzSEKZjv/x/3wl6bQNYfeu7DzQD5+1HIR0AwUEHgDhK+oh7
        pkPjvcSJzFdHWKM+zmhOZbkOoHStqgCV+CboXZ9FZ4qTK1QyRXh4uEK1J1xO+om7NT8xXoSG
        MbEpLGtgjet5CO4hSUf09HHVOd3Z/aO+J0uEQUsvevcutrx9yrFzh+h6+S7R0SXiQFyAWvJx
        dEPZEzNOpl3KFjcvdvVCe0XsFucxTVZegXaTWv/+1pWMlzpPj6KtOZHbbb41pGLpTlr0s6sD
        9RKb1PJ1pSbH7oM4pmMzfOocQx/p3+t7d++xmoQCa8j8bPWbl9v79kZkFg9vqHl8WHlkc9mS
        quCowBuhVP4bCjPl1h51UH77/l3owm/WyMGqol83jnFRovOHX6+yrtxw3vrcHFtxM8TPCrti
        Tt9Dqkdue7T2mz8b/HPxQ2Bv8yxsfJqs2zMeJmy+LB06tOxXqKSWhn7ob1qoi42/lX1vS7Ss
        nMS4JEa+GzVyzH/gQE+GdAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsWy7bCSnG7CWsMkgxv/+SymH1a0aJrwl9li
        zqptjBar7/azWaxcfZTJ4l3rORaLztMXmCzOvz3MZDHp0DVGi723tC3mL3vKbrGk9TibxY0J
        Txkt1tx8ymKx7vV7FovPZ+axOgh4PLv6jNFj56y77B7n721k8WhecIfF4/LZUo9NqzrZPDYv
        qffYfbOBzWPb4pesHn1bVjF6fN4kF8AdxWWTkpqTWZZapG+XwJUx5fxsloI7vBW3/39lbWCc
        wd3FyMkhIWAisXdNK2MXIxeHkMAORomzCy6wQiTEJZqv/WCHsIUlVv57zg5R9IRRoqN/AlgR
        i4CqxKtnJ5i6GDk42AQ0JS5MLgUxRQRUJN68yQUpZxaYxCJxbt02sHJhgVCJltZuJhCbV0BH
        YuHp21Az3zFJHHqzhREiIShxcuYTFhCbWcBMYt7mh8wgQ5kFpCWW/+MACXMK2Ets6XgJNlNU
        QFniwLbjTBMYBWch6Z6FpHsWQvcCRuZVjJKpBcW56bnFhgVGeanlesWJucWleel6yfm5mxjB
        EamltYNxz6oPeocYmTgYDzFKcDArifCeeaGfJMSbklhZlVqUH19UmpNafIhRmoNFSZz3QtfJ
        eCGB9MSS1OzU1ILUIpgsEwenVANTQjbfRIvTgbkXfnhO/NFRKLhLMM/uQ9xfqdVhNfu8Jue+
        a8x1Ud3TNEFe66GUpFHt0dje1bvM2aZJ96UVxix2bpmjOS9GNLfi4ZM4G9dsu64lZWuXW1uL
        Onalq+XUGZ7dvVCZt8KdIeCyUYPJLXk9PvlZ22I3rPRuFOOV0m6rKeCasu5BWOKjv/YPl//m
        W7AjLzXnm1Kh2Y0T823uVhadsnvOyMTc4HhMrspNfEHwlYUzNxlm745K3uf/fWq8WnzC3f33
        DV1LNzdFyN36rf3zm4jcmdULZ/4vUXbJVtpc/MDs8UTb6ZrSfxgmTXrb8Df6sVNZcfvUVwf7
        VXdJrrHK3s3j+3SbvMtthjkLzyuxFGckGmoxFxUnAgAi1LGpNwMAAA==
X-CMS-MailID: 20220316092656epcas5p49e5a6fea697e69f6ed465c13f1298b84
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----8TtN9ZnHmYbjupaEpeShJ04PQlBV3ZvePY_ZWnFgjSBPeLtG=_11c0b5_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220308152702epcas5p1eb1880e024ac8b9531c85a82f31a4e78
References: <20220308152105.309618-1-joshi.k@samsung.com>
        <CGME20220308152702epcas5p1eb1880e024ac8b9531c85a82f31a4e78@epcas5p1.samsung.com>
        <20220308152105.309618-6-joshi.k@samsung.com>
        <7a123895-1102-4b36-2d6e-1e00e978d03d@grimberg.me>
        <CA+1E3rK8wnABptQLQrEo8XRdsbua9t_88e3ZP-Ass3CnxHv+oA@mail.gmail.com>
        <8f45a761-5ecb-5911-1064-9625a285c93d@grimberg.me>
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------8TtN9ZnHmYbjupaEpeShJ04PQlBV3ZvePY_ZWnFgjSBPeLtG=_11c0b5_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Tue, Mar 15, 2022 at 11:02:30AM +0200, Sagi Grimberg wrote:
>
>>>>+int nvme_ns_head_chr_async_cmd(struct io_uring_cmd *ioucmd)
>>>>+{
>>>>+     struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
>>>>+     struct nvme_ns_head *head = container_of(cdev, struct nvme_ns_head, cdev);
>>>>+     int srcu_idx = srcu_read_lock(&head->srcu);
>>>>+     struct nvme_ns *ns = nvme_find_path(head);
>>>>+     int ret = -EWOULDBLOCK;
>>>>+
>>>>+     if (ns)
>>>>+             ret = nvme_ns_async_ioctl(ns, ioucmd);
>>>>+     srcu_read_unlock(&head->srcu, srcu_idx);
>>>>+     return ret;
>>>>+}
>>>
>>>No one cares that this has no multipathing capabilities what-so-ever?
>>>despite being issued on the mpath device node?
>>>
>>>I know we are not doing multipathing for userspace today, but this
>>>feels like an alternative I/O interface for nvme, seems a bit cripled
>>>with zero multipathing capabilities...
>>
>>Multipathing is on the radar. Either in the first cut or in
>>subsequent. Thanks for bringing this up.
>
>Good to know...
>
>>So the char-node (/dev/ngX) will be exposed to the host if we enable
>>controller passthru on the target side. And then the host can send
>>commands using uring-passthru in the same way.
>
>Not sure I follow...

Doing this on target side:
echo -n /dev/nvme0 > /sys/kernel/config/nvmet/subsystems/testnqn/passthru/device_path
echo 1 > /sys/kernel/config/nvmet/subsystems/testnqn/passthru/enable

>>May I know what are the other requirements here.
>
>Again, not sure I follow... The fundamental capability is to
>requeue/failover I/O if there is no I/O capable path available...

That is covered I think, with nvme_find_path() at places including the
one you highlighted above.

------8TtN9ZnHmYbjupaEpeShJ04PQlBV3ZvePY_ZWnFgjSBPeLtG=_11c0b5_
Content-Type: text/plain; charset="utf-8"


------8TtN9ZnHmYbjupaEpeShJ04PQlBV3ZvePY_ZWnFgjSBPeLtG=_11c0b5_--
