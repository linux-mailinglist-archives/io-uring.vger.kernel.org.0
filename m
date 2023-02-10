Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBA926924F9
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 19:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbjBJSCf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 13:02:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232513AbjBJSCf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 13:02:35 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF285FB78
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 10:02:32 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230210180228epoutp0345d9bd27cb5d42e4a4ad0d05727a008e~CiIyblMCQ1568615686epoutp03K
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 18:02:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230210180228epoutp0345d9bd27cb5d42e4a4ad0d05727a008e~CiIyblMCQ1568615686epoutp03K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1676052148;
        bh=F8sxz/DFBmvj9dEHvGBa6OIR8k68L/lCnvOr2bzeAWk=;
        h=From:To:Cc:Subject:Date:References:From;
        b=qytfOB27VIxcPQne3c2uBaXsJ1heP7gea0dOnu53xqnmjKGifOHuNVGONETH47jmW
         RJ/mdfNd8pee7BqZSN7uzJz4H3gukMGSBAW7boynScnzPjzGT9L018Z6i0TTYgPbv6
         h4jZC1WlHaFFy/akROJhFj8kjTHzzHHPuPMAqQsE=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230210180228epcas5p229f259e43e883b56e3f354d7cbb2f58e~CiIx__8Fo0745107451epcas5p2U;
        Fri, 10 Feb 2023 18:02:28 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4PD1m24DPHz4x9Pt; Fri, 10 Feb
        2023 18:02:26 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        ED.BB.55678.2B686E36; Sat, 11 Feb 2023 03:02:26 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230210180226epcas5p1bd2e1150de067f8af61de2bbf571594d~CiIwABZH_1487214872epcas5p12;
        Fri, 10 Feb 2023 18:02:26 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230210180226epsmtrp2275bcf6dc658d13c0b572e6d296630b5~CiIv-UX6u0770607706epsmtrp25;
        Fri, 10 Feb 2023 18:02:26 +0000 (GMT)
X-AuditID: b6c32a4a-909fc7000000d97e-41-63e686b21beb
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F6.58.05839.2B686E36; Sat, 11 Feb 2023 03:02:26 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230210180224epsmtip1ad2e07de90dfb2af216925f3260f223c~CiIuqVOBK2565325653epsmtip1N;
        Fri, 10 Feb 2023 18:02:24 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     lsf-pc@lists.linux-foundation.org
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        io-uring@vger.kernel.org, axboe@kernel.dk, hch@lst.de,
        kbusch@kernel.org, ming.lei@redhat.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [LSF/MM/BPF ATTEND][LSF/MM/BPF Topic] Non-block IO
Date:   Fri, 10 Feb 2023 23:30:33 +0530
Message-Id: <20230210180033.321377-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplk+LIzCtJLcpLzFFi42LZdlhTXXdT27Nkg3Xn5SxW3+1ns1i5+iiT
        xbvWcywWR/+/ZbOYdOgao8XeW9oW85c9ZbfY93ovs8Whyc1MDpwel8+Wemxa1cnmsXlJvcfk
        G8sZPXbfbGDzeL/vKptH35ZVjB6fN8kFcERl22SkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
        6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHaekUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJ
        KTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM74tmklc8Fd/op197ezNzA+4eli5OSQEDCROH72
        KmsXIxeHkMBuRon//XOYIJxPjBKHp+1mhHC+MUpMP3ySFaZlzvW5LBCJvYwSm7YeZIZwPjNK
        zP3yEcjh4GAT0JS4MLkUpEFEQFXi7/ojYA3MAscZJRbOvMQMkhAWsJZ4c/wcO4jNAlR0/9RE
        JhCbV8BS4lvPBCaIbfISMy99Z4eIC0qcnPmEBcRmBoo3b50NtlhC4Cu7xNlpK9kgGlwkfrye
        C2ULS7w6voUdwpaS+PxuL1Q8WeLSzHNQC0okHu85CGXbS7Se6gd7gBnogfW79CF28Un0/n7C
        BBKWEOCV6GgTgqhWlLg36Sk0UMQlHs5YAmV7SLzc+wBsk5BArMSX9h3MExjlZiH5YBaSD2Yh
        LFvAyLyKUTK1oDg3PbXYtMAoL7UcHpnJ+bmbGMHpUstrB+PDBx/0DjEycTAeYpTgYFYS4a20
        eZYsxJuSWFmVWpQfX1Sak1p8iNEUGKwTmaVEk/OBCTuvJN7QxNLAxMzMzMTS2MxQSZxX3fZk
        spBAemJJanZqakFqEUwfEwenVANT9qXjJjfetZp6/3FNqFaSmueVvO95YPxtcy/bXq3GipfG
        cfvYVt1u+H2Yj//uum26k+X9t7m+9laR2fft2Da78BvFE+QWdJiavDmsdspwR4ZhzEptI4np
        1zs/presmWJgL/I7k18n9UrNg96Te0UjwjQ5hZL3iJ5h9IperhGYnRg2zTTa8dyH3kf+RooJ
        V9Z+D7uke2xXTf+LLWnbvsueYO4+uiJi5cYrHx5qTotPbnfbramw1djr7Nu6pnUB3NMMNd//
        EF3KOCHzcuvE2Amt0ksL2rnL5+7Y/cFGJEbo1PZu0Q2fnxr1XhLxWxq7jMttqZsL++q7k9Jm
        +5cGm/72XXFZTeO70fcmBddFhrpKLMUZiYZazEXFiQAXBT3cIAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsWy7bCSnO6mtmfJBh/XsVqsvtvPZrFy9VEm
        i3et51gsjv5/y2Yx6dA1Rou9t7Qt5i97ym6x7/VeZotDk5uZHDg9Lp8t9di0qpPNY/OSeo/J
        N5Yzeuy+2cDm8X7fVTaPvi2rGD0+b5IL4IjisklJzcksSy3St0vgyvi2aSVzwV3+inX3t7M3
        MD7h6WLk5JAQMJGYc30uSxcjF4eQwG5GiR+TNrBBJMQlmq/9YIewhSVW/nvODlH0kVHi8f/b
        rF2MHBxsApoSFyaXgtSICKhK/F1/BGwQs8BFRolNq06DNQsLWEu8OX4OzGYBKrp/aiITiM0r
        YCnxrWcCE8QCeYmZl76zQ8QFJU7OfMICYjMDxZu3zmaewMg3C0lqFpLUAkamVYySqQXFuem5
        xYYFhnmp5XrFibnFpXnpesn5uZsYwSGtpbmDcfuqD3qHGJk4GA8xSnAwK4nwVto8SxbiTUms
        rEotyo8vKs1JLT7EKM3BoiTOe6HrZLyQQHpiSWp2ampBahFMlomDU6qBKWvLtzMbH/A6XlzV
        39B3fcvVW+q3D+06s/Zg1auUGfx8m++3FWSJzZ6UWuky+8tSD/vdl7YyOG3fEBIiwbavm6PP
        M4P3hqnPbQuF5VcErAO3WFw22OAxuevi8TJj75Ko08JuBkfesXgXVzEd+aN4q2adr/S8t2wf
        Skz/1j0uvPBoybIidellp9p1+PxeznHytjqrHvqxzLdz+af3bBqzE+LuyR27PfXxxZe79k3a
        92vnoWubuu5st1HnCj3eoX+7YelTN627yWd2qtaHSs677vPJrDlar2S6VsakvPUy1rayfBu3
        xFwIDLgj1NbF28d8lOdSbOS0CpaZ115d+H3VR3ClwMtDK3TaFee1yb69/UCJpTgj0VCLuag4
        EQDC8v5d2AIAAA==
X-CMS-MailID: 20230210180226epcas5p1bd2e1150de067f8af61de2bbf571594d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230210180226epcas5p1bd2e1150de067f8af61de2bbf571594d
References: <CGME20230210180226epcas5p1bd2e1150de067f8af61de2bbf571594d@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

is getting more common than it used to be.
NVMe is no longer tied to block storage. Command sets in NVMe 2.0 spec
opened an excellent way to present non-block interfaces to the Host. ZNS
and KV came along with it, and some new command sets are emerging.

OTOH, Kernel IO advances historically centered around the block IO path.
Passthrough IO path existed, but it stayed far from all the advances, be
it new features or performance.

Current state & discussion points:
---------------------------------
Status-quo changed in the recent past with the new passthrough path (ng
char interface + io_uring command). Feature parity does not exist, but
performance parity does.
Adoption draws asks. I propose a session covering a few voices and
finding a path-forward for some ideas too.

1. Command cancellation: while NVMe mandatorily supports the abort
command, we do not have a way to trigger that from user-space. There
are ways to go about it (with or without the uring-cancel interface) but
not without certain tradeoffs. It will be good to discuss the choices in
person.

2. Cgroups: works for only block dev at the moment. Are there outright
objections to extending this to char-interface IO?

3. DMA cost: is high in presence of IOMMU. Keith posted the work[1],
with block IO path, last year. I imagine plumbing to get a bit simpler
with passthrough-only support. But what are the other things that must
be sorted out to have progress on moving DMA cost out of the fast path?

4. Direct NVMe queues - will there be interest in having io_uring
managed NVMe queues?  Sort of a new ring, for which I/O is destaged from
io_uring SQE to NVMe SQE without having to go through intermediate
constructs (i.e., bio/request). Hopefully,that can further amp up the
efficiency of IO.

5. <anything else that might be of interest to folks>

I hope to send some code/PoC to discuss the stuff better.

[1]https://lore.kernel.org/linux-nvme/20220805162444.3985535-1-kbusch@fb.com/


