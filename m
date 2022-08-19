Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F25565999EE
	for <lists+io-uring@lfdr.de>; Fri, 19 Aug 2022 12:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348447AbiHSKkw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Aug 2022 06:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348376AbiHSKkv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Aug 2022 06:40:51 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2283DF075C
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 03:40:44 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220819104037epoutp03608808313959e9661e05ceac2d5bd5cd~MuOChHxAS1672816728epoutp03O
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 10:40:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220819104037epoutp03608808313959e9661e05ceac2d5bd5cd~MuOChHxAS1672816728epoutp03O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1660905637;
        bh=JGP/jpExxvVdC928u6XDcrs4zExHnARu8CONfihBAxk=;
        h=From:To:Cc:Subject:Date:References:From;
        b=YTaPFCu4ppEJGlDSr0FmsunLKhHhE1SWdrE6tylNSt4teOF/opa8Dq4QMbi6KrBox
         Bi4PE0j/pSi+p2F0ct5CXoKx0Qi36+V+yhdUCEtmDx0M05X6tjCGHws1dOOXwcx/pb
         GoY7a5Jd/RtfOO2OdlSrPVu8YG6QNMBCkfZ0nW8o=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220819104036epcas5p4681d73d8f2b3dfee6778b5ca3b4dcb05~MuOBpUTwT3157731577epcas5p46;
        Fri, 19 Aug 2022 10:40:36 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4M8JDz05KDz4x9Pp; Fri, 19 Aug
        2022 10:40:35 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A6.E3.49477.0A86FF26; Fri, 19 Aug 2022 19:40:32 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220819104031epcas5p3d485526e1b2b42078ccce7e40a74b7f5~MuN9E7YjH1666016660epcas5p3U;
        Fri, 19 Aug 2022 10:40:31 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220819104031epsmtrp2b2633f4bc22b41b43dd1aa2585a53486~MuN9CsnWa3211132111epsmtrp2D;
        Fri, 19 Aug 2022 10:40:31 +0000 (GMT)
X-AuditID: b6c32a49-82dff7000000c145-65-62ff68a0a661
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2A.7C.08905.F986FF26; Fri, 19 Aug 2022 19:40:31 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220819104030epsmtip152b228208b1a231374ab60f19e721276~MuN7iWjEg0595705957epsmtip1K;
        Fri, 19 Aug 2022 10:40:29 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next 0/4] fixed-buffer for uring-cmd/passthrough
Date:   Fri, 19 Aug 2022 16:00:17 +0530
Message-Id: <20220819103021.240340-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42LZdlhTS3dBxv8kg7uzhS1W3+1ns7h5YCeT
        xcrVR5ks3rWeY7E4+v8tm8WkQ9cYLfbe0raYv+wpu8Whyc1MDpwel8+Wemxa1cnmsXlJvcfu
        mw1sHu/3XWXz6NuyitHj8ya5APaobJuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtz
        JYW8xNxUWyUXnwBdt8wcoLuUFMoSc0qBQgGJxcVK+nY2RfmlJakKGfnFJbZKqQUpOQUmBXrF
        ibnFpXnpenmpJVaGBgZGpkCFCdkZL5d0shbM46uY9mkeawPjcu4uRk4OCQETiRdt7exdjFwc
        QgK7GSXmHH7KDOF8YpSYeq6FBcL5xiixc/o11i5GDrCWlW2GIN1CAnsZJR6td4Oo+cwo8ezn
        a2aQGjYBTYkLk0tBakQEjCT2fzrJClLDLLCWUeL03i9MIAlhAReJr8d2gM1kEVCVmN1pAxLm
        FbCU6PtzkRHiOnmJmZe+s0PEBSVOznzCAmIzA8Wbt84GO1RC4C27xK7fDVC3uUh0/q+C6BWW
        eHV8CzuELSXx+d1eNgg7WeLSzHNMEHaJxOM9B6Fse4nWU/1g5zMDnb9+lz7EKj6J3t9PmCCm
        80p0tAlBVCtK3Jv0lBXCFpd4OGMJ1AEeEpvm+0ICJ1bi6O021gmMcrOQ3D8Lyf2zEHYtYGRe
        xSiZWlCcm55abFpgmJdaDo/H5PzcTYzg1KjluYPx7oMPeocYmTgYDzFKcDArifDeuPMnSYg3
        JbGyKrUoP76oNCe1+BCjKTBMJzJLiSbnA5NzXkm8oYmlgYmZmZmJpbGZoZI4r9fVTUlCAumJ
        JanZqakFqUUwfUwcnFINTJUNuYzsj6ZluucJGms6GH1wW7/xQNk5VYF3hsG1e8UvZSUu9J27
        0EWhWajl8u3byyWC3yy/LPdLe4r7rFdzr/3ect+nz+KvYX1gftE6odvqpptOOt3eMT2+I3gr
        r8MDMcfuw537jsi/jQ999C14Zuur9JaX63nKg53f8PyOPDJrVdPUGONF3zvfxDZfdH702OHX
        AalNPpMPtVYraDzbf6m7/as6y5eLLW+EZq3/vjbH/JHRo7W8DcaTH53JtY2dntCh2c7eekpE
        74a3l/ac2ac3pHN+c66a6uniz/L8SYQnY/j6jXn5V31uBmf7fBZetfbuTftN9ScPen24qfjb
        TOO+cGn8plMnL/2Wjt9qnaXEUpyRaKjFXFScCADDSTLDFgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsWy7bCSnO78jP9JBtcfKVisvtvPZnHzwE4m
        i5WrjzJZvGs9x2Jx9P9bNotJh64xWuy9pW0xf9lTdotDk5uZHDg9Lp8t9di0qpPNY/OSeo/d
        NxvYPN7vu8rm0bdlFaPH501yAexRXDYpqTmZZalF+nYJXBkvl3SyFszjq5j2aR5rA+Ny7i5G
        Dg4JAROJlW2GXYxcHEICuxklXp9/x9zFyAkUF5dovvaDHcIWllj57zk7RNFHRolJ/y+zgzSz
        CWhKXJhcClIjImAmsfTwGhaQGmaBzYwSn04fAxskLOAi8fXYDlaQehYBVYnZnTYgYV4BS4m+
        PxcZIebLS8y89J0dIi4ocXLmExYQmxko3rx1NvMERr5ZSFKzkKQWMDKtYpRMLSjOTc8tNiww
        zEst1ytOzC0uzUvXS87P3cQIDmItzR2M21d90DvEyMTBeIhRgoNZSYT3xp0/SUK8KYmVValF
        +fFFpTmpxYcYpTlYlMR5L3SdjBcSSE8sSc1OTS1ILYLJMnFwSjUwnWhfuPPT5g199vMn9Cx9
        rn9Y547Gyfj2hDlzYhfFf+OXuvTimXWRRplBp/jBInFe58PzOuP9s7eVRE+qm9W4+7tb2+J8
        xa9t+1e+YHn8v8VW2izghfyPnf+57yZfO31b3+xt6IWFK3bPm5t5f3dor/XmLUkusTMzfr9i
        n9HBuJLJr7wlVaUlwlvlibPjZMF9tRwZDv+W2Zs+Xu+8snXibocLEqo7rieZ6X1377rrfabT
        8+2F13FzPoYxO6+pdu/bvCbSPyjppN2Dlo/a1nFbJs7KKZ9n+d1W2uPW5IgVZcs97x/9H6ny
        2Yh3W0z030ib/DelDU8Off4VZPLf7Xg2b2OL3o+WOIX0GqVVdfKvlFiKMxINtZiLihMBlrk0
        /NECAAA=
X-CMS-MailID: 20220819104031epcas5p3d485526e1b2b42078ccce7e40a74b7f5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220819104031epcas5p3d485526e1b2b42078ccce7e40a74b7f5
References: <CGME20220819104031epcas5p3d485526e1b2b42078ccce7e40a74b7f5@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Currently uring-cmd lacks the ability to leverage the pre-registered
buffers. This series adds new fixed-buffer variant of uring command
IORING_OP_URING_CMD_FIXED, and plumbs nvme passthrough to work with
that.

Patch 1, 3 = prep/infrastructure
Patch 2 = expand io_uring command to use registered-buffers
Patch 4 = expand nvme passthrough to use registered-buffers

Using registered-buffers showed 5-12% IOPS gain in my setup.
QD   Without     With
8     853        928
32    1370       1528
128   1505       1631

This series is prepared on top of:
for-next + iopoll-passthru series [1] + passthru optimization series [2].
A unified branch with all that is present here:
https://github.com/OpenMPDK/linux/commits/feat/pt_fixedbufs_v1

Fio that can use IORING_OP_URING_CMD_FIXED (on specifying fixedbufs=1)
is here -
https://github.com/joshkan/fio/commit/300f1187f75aaf2c502c180041943c340670d0ac

[1] https://lore.kernel.org/linux-block/20220807183607.352351-1-joshi.k@samsung.com/
[2] https://lore.kernel.org/linux-block/20220806152004.382170-1-axboe@kernel.dk/

Anuj Gupta (2):
  io_uring: introduce io_uring_cmd_import_fixed
  io_uring: introduce fixed buffer support for io_uring_cmd

Kanchan Joshi (2):
  block: add helper to map bvec iterator for passthrough
  nvme: wire up fixed buffer support for nvme passthrough

 block/blk-map.c               | 71 +++++++++++++++++++++++++++++++++++
 drivers/nvme/host/ioctl.c     | 38 +++++++++++++------
 include/linux/blk-mq.h        |  1 +
 include/linux/io_uring.h      | 10 +++++
 include/uapi/linux/io_uring.h |  1 +
 io_uring/opdef.c              | 10 +++++
 io_uring/rw.c                 |  3 +-
 io_uring/uring_cmd.c          | 26 +++++++++++++
 8 files changed, 147 insertions(+), 13 deletions(-)

-- 
2.25.1

