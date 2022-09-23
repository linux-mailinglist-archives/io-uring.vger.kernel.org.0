Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49E305E776A
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 11:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbiIWJmQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 05:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbiIWJkn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 05:40:43 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5875313073D
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 02:39:11 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220923093909epoutp035ccffb0e7d5baf7da7ba784e58307a76~Xc9Xc2vJQ2853128531epoutp03X
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 09:39:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220923093909epoutp035ccffb0e7d5baf7da7ba784e58307a76~Xc9Xc2vJQ2853128531epoutp03X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1663925949;
        bh=dZTmQuwMt5F2WWpxMfVBgX2rQ5mk0r4Z0t9aPa7nSxI=;
        h=From:To:Cc:Subject:Date:References:From;
        b=cMH6TFEspF6q/hRreVP1TlZMQePUJMkzrVo1n3gY9YQGlEYAcAb5xjMFTIWDUZitp
         pnCZfAmAFMlrSX0hlTvsbOQkPwLOSgSZaKocgeKoQPBvNScHQu3WEy4bBg05Z2Q9Dy
         6UHXsegM00ifg51gqs5XqP7zAEt0QVilOC4UmXpY=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220923093908epcas5p1256c7061e189426208209e4df26e23c2~Xc9WyD_9m1642216422epcas5p13;
        Fri, 23 Sep 2022 09:39:08 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4MYnCt3Dr3z4x9Pq; Fri, 23 Sep
        2022 09:39:06 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        72.B5.39477.ABE7D236; Fri, 23 Sep 2022 18:39:06 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220923093906epcas5p1308a262f3de722a923339c2e804fc5ee~Xc9UCFe-21642216422epcas5p1z;
        Fri, 23 Sep 2022 09:39:06 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220923093906epsmtrp10a4a75cc59d2bf800f0b405d62182cd3~Xc9UBNlMZ0923409234epsmtrp1_;
        Fri, 23 Sep 2022 09:39:06 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-76-632d7ebaaf7f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F2.37.18644.9BE7D236; Fri, 23 Sep 2022 18:39:05 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220923093904epsmtip287e8875a3a88b667e43fa81a3457870a~Xc9SUeqam2705227052epsmtip2X;
        Fri, 23 Sep 2022 09:39:04 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v8 0/5] fixed-buffer for uring-cmd/passthru
Date:   Fri, 23 Sep 2022 14:58:49 +0530
Message-Id: <20220923092854.5116-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDKsWRmVeSWpSXmKPExsWy7bCmpu6uOt1kg10vxC1W3+1ns7h5YCeT
        xcrVR5ks3rWeY7E4+v8tm8WkQ9cYLfbe0raYv+wpuwOHx+WzpR6bVnWyeWxeUu+x+2YDm0ff
        llWMHp83yQWwRWXbZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
        6Lpl5gBdo6RQlphTChQKSCwuVtK3synKLy1JVcjILy6xVUotSMkpMCnQK07MLS7NS9fLSy2x
        MjQwMDIFKkzIzpiw7StbwS++iqP/P7I2ML7l7mLk4JAQMJF4uVC2i5GLQ0hgN6PEmQXnmLsY
        OYGcT4wSWz/lQyQ+M0psuzMLLAHS8Pb/YjaIxC5GianNj1jhqlpfPmUFGcsmoClxYXIpSIOI
        gJHE/k8nwWqYBWYwSqzueM0OkhAWcJGYefA6C4jNIqAq8XXuA7ANvALmEmuvTGKB2CYvMfPS
        d3aIuKDEyZlPwOLMQPHmrbOZQYZKCNxjlzg77yvUeS4Srx+tZ4KwhSVeHd/CDmFLSbzsb4Oy
        kyUuzTwHVVMi8XjPQSjbXqL1VD8zyAPMQA+s36UPsYtPovf3EyZIcPFKdLQJQVQrStybBPIu
        iC0u8XDGEijbQ+Lv9tXskFCMlTj2+jrrBEa5WUg+mIXkg1kIyxYwMq9ilEwtKM5NTy02LTDK
        Sy2HR2Vyfu4mRnAy1PLawfjwwQe9Q4xMHIyHGCU4mJVEeGff0UwW4k1JrKxKLcqPLyrNSS0+
        xGgKDNaJzFKiyfnAdJxXEm9oYmlgYmZmZmJpbGaoJM67eIZWspBAemJJanZqakFqEUwfEwen
        VANTTV2lB2t3S8UumS1+fxakN8dF/2t0ZHx1PsiAJSnrQUXm+i+bHWU2lb1LVDdrtBc2WVnT
        9+divMI9tYrUhunqzEuvdn0/NF9FVtm0tqno6STBa+uuTbT58clUMfn5lg8CdzfzKfdOqb28
        7mZJgfvb/4JHPnNyfjhm8vvn37LXVaJNK+ayCx9dxC3DytVe7m56Mr0rb6v/EQejyrlSzVpp
        /v82OrO86N+VcXRFQ/eTHzGhK/tFf12PcjmTUi0mv4UtZ9acyzFTJk6/e/K6186adrnUgKu3
        J92W4t5zdLLMc5bDG+LMlhiucY5y8DJrVpkpa/L2Yz7P76Nx3v67n05e5mgkvGaW+bfgqP6p
        qcJKLMUZiYZazEXFiQClLwmNDwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsWy7bCSvO7OOt1kg7+vrCxW3+1ns7h5YCeT
        xcrVR5ks3rWeY7E4+v8tm8WkQ9cYLfbe0raYv+wpuwOHx+WzpR6bVnWyeWxeUu+x+2YDm0ff
        llWMHp83yQWwRXHZpKTmZJalFunbJXBlTNj2la3gF1/F0f8fWRsY33J3MXJySAiYSLz9v5gN
        xBYS2MEo8WaSKkRcXKL52g92CFtYYuW/50A2F1DNR0aJzUfPMXUxcnCwCWhKXJhcClIjImAm
        sfTwGhaQGmaBOYwSly/vAWsWFnCRmHnwOguIzSKgKvF17gNmEJtXwFxi7ZVJLBAL5CVmXvrO
        DhEXlDg58wlYnBko3rx1NvMERr5ZSFKzkKQWMDKtYpRMLSjOTc8tNiwwykst1ytOzC0uzUvX
        S87P3cQIDlktrR2Me1Z90DvEyMTBeIhRgoNZSYR39h3NZCHelMTKqtSi/Pii0pzU4kOM0hws
        SuK8F7pOxgsJpCeWpGanphakFsFkmTg4pRqYdhgkM+lYSq9p65bZ9GrejxPKPu0ep7cK+nvE
        nP7fxs80d49TLkf/9z9X2I5aO+pfUZwyL37B/n+3GPZsDFwYnL121ennDUavrmUfPtOkt6+7
        7bRi7XK31ZlbWFhvPvjftLP7a7TWC7WbZou3znuUuf2Y2vTlYWrJ0y+vWPlBfKF80uTGwv15
        k48k8878O10nqFE638FtRtdXvUdbNgdx2v74N3PJk9UvPiz4+3D2rNBLfY7SG0tOseR1HvU/
        XRu9uvRhgOQZzre8UcyNCf/WbpmiP7XUU6rksNHiGct7WCXuJx+e6P/j3+Qf55h/nnt1IcRg
        y5Q5R/pZZ4SohMXb/Z04ZcIV4bQX4V6VPju+1XMpsRRnJBpqMRcVJwIAF4ekiMgCAAA=
X-CMS-MailID: 20220923093906epcas5p1308a262f3de722a923339c2e804fc5ee
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220923093906epcas5p1308a262f3de722a923339c2e804fc5ee
References: <CGME20220923093906epcas5p1308a262f3de722a923339c2e804fc5ee@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently uring-cmd lacks the ability to leverage the pre-registered
buffers. This series adds that support in uring-cmd, and plumbs
nvme passthrough to work with it.

Using registered-buffers showed IOPS hike from 1.9M to 2.2M in my tests.

Patch 1, 3, 4 = prep
Patch 2 = expand io_uring command to use registered-buffers
Patch 5 = expand nvme passthrough to use registered-buffers

Changes since v7:
- Patch 3: added many cleanups/refactoring suggested by Christoph
- Patch 4: added copying-pages fallback for bounce-buffer/dma-alignment case
  (Christoph)

Changes since v6:
- Patch 1: fix warning for io_uring_cmd_import_fixed (robot)
-
Changes since v5:
- Patch 4: newly addd, to split a nvme function into two
- Patch 3: folded cleanups in bio_map_user_iov (Chaitanya, Pankaj)
- Rebase to latest for-next

Changes since v4:
- Patch 1, 2: folded all review comments of Jens

Changes since v3:
- uring_cmd_flags, change from u16 to u32 (Jens)
- patch 3, add another helper to reduce code-duplication (Jens)

Changes since v2:
- Kill the new opcode, add a flag instead (Pavel)
- Fix standalone build issue with patch 1 (Pavel)

Changes since v1:
- Fix a naming issue for an exported helper

Anuj Gupta (2):
  io_uring: add io_uring_cmd_import_fixed
  io_uring: introduce fixed buffer support for io_uring_cmd

Kanchan Joshi (3):
  nvme: refactor nvme_alloc_user_request
  block: add helper to map bvec iterator for passthrough
  nvme: wire up fixed buffer support for nvme passthrough

 block/blk-map.c               | 111 +++++++++++++++++++++++---
 drivers/nvme/host/ioctl.c     | 141 ++++++++++++++++++++--------------
 include/linux/blk-mq.h        |   1 +
 include/linux/io_uring.h      |  10 ++-
 include/uapi/linux/io_uring.h |   9 +++
 io_uring/uring_cmd.c          |  26 ++++++-
 6 files changed, 230 insertions(+), 68 deletions(-)

-- 
2.25.1

