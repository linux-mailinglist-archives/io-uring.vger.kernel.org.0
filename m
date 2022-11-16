Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A06D62BEB7
	for <lists+io-uring@lfdr.de>; Wed, 16 Nov 2022 13:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbiKPMyg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Nov 2022 07:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiKPMyf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Nov 2022 07:54:35 -0500
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A374113F4D
        for <io-uring@vger.kernel.org>; Wed, 16 Nov 2022 04:54:33 -0800 (PST)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20221116125430euoutp01e9fab5be7897d7b1dfe97e3f809ab3ca~oEdWFa9O21624416244euoutp01j
        for <io-uring@vger.kernel.org>; Wed, 16 Nov 2022 12:54:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20221116125430euoutp01e9fab5be7897d7b1dfe97e3f809ab3ca~oEdWFa9O21624416244euoutp01j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1668603270;
        bh=HjZKvWsi7Asp/BfxfeYKpMu6OvENuo1t6Dui6oN5Mjw=;
        h=From:To:CC:Subject:Date:References:From;
        b=S8iSPZi4TOHxf+GCBZWbx7e3kQJ9gmTnfthZH9YLWC/sPBdqa1kMkNCy9rcksSy9P
         gme/Y5SnkAAdIy9NMsXVAc5Ib15AtOMZikNdoKQX9UX3u6NGHmdE0RWM2MxtvdT30L
         8SskefPNeINPvg2ghQL4aWCGSFeg7cLIFJD4Tdpc=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20221116125430eucas1p2257c00a068d414c20a449ad53b7affcc~oEdV778030530405304eucas1p2c;
        Wed, 16 Nov 2022 12:54:30 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id D9.25.10112.68DD4736; Wed, 16
        Nov 2022 12:54:30 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20221116125430eucas1p2f2969a4a795614ce3b8c06f9ea3be36f~oEdVsS7xz0496204962eucas1p2k;
        Wed, 16 Nov 2022 12:54:30 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221116125430eusmtrp2c24866dfc6e4991f7cf7048d69d9a82b~oEdVrrP430810808108eusmtrp2B;
        Wed, 16 Nov 2022 12:54:30 +0000 (GMT)
X-AuditID: cbfec7f4-cf3ff70000002780-f0-6374dd862b0f
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 2B.A5.08916.68DD4736; Wed, 16
        Nov 2022 12:54:30 +0000 (GMT)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221116125430eusmtip202f3a4d2d7e99dd8c208bd95d31c7be3~oEdVjhjjh3185831858eusmtip2I;
        Wed, 16 Nov 2022 12:54:30 +0000 (GMT)
Received: from localhost (106.110.32.33) by CAMSVWEXC01.scsc.local
        (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Wed, 16 Nov 2022 12:54:29 +0000
From:   Joel Granados <j.granados@samsung.com>
To:     <joshi.k@samsung.com>, <ddiss@suse.de>, <mcgrof@kernel.org>,
        <paul@paul-moore.com>
CC:     <linux-security-module@vger.kernel.org>,
        <io-uring@vger.kernel.org>,
        "Joel Granados" <j.granados@samsung.com>
Subject: [RFC 0/1] RFC on how to include LSM hooks for io_uring commands
Date:   Wed, 16 Nov 2022 13:50:50 +0100
Message-ID: <20221116125051.3338926-1-j.granados@samsung.com>
X-Mailer: git-send-email 2.30.2
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [106.110.32.33]
X-ClientProxiedBy: CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) To
        CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42LZduznOd22uyXJBs+OyVp8/T+dxeJd6zkW
        iw89j9gsbkx4ymhxe9J0FgdWj02rOtk81u59weix+XS1x+dNcgEsUVw2Kak5mWWpRfp2CVwZ
        /W/aWAuauSu+frnA1sD4lqOLkZNDQsBE4u3RHrYuRi4OIYEVjBJ/F81khHC+MEq8PDmVHcL5
        zCix9UUnE0zLvW97oaqWM0qsOz6FCa7qzpJWqGGbGSVavk1hAWlhE9CROP/mDjOILSIQITF/
        +n9GEJtZoFhi2/55QDs4OIQFPCS6r5qAhFkEVCVWbv0MVsIrYCvxbPU6FojN8hJt16czgpQz
        C2hKrN+lD1EiKHFy5hMWiInyEs1bZzNDlCtKbJnznRXCrpV48KaHGeQ0CYEDHBLrJjRBzXSR
        uL50PyOELSzx6vgWdghbRuL/zvlQH2dL7JyyC2pogcSsk1PZQG6QELCW6DuTAxF2lDj65joT
        RJhP4sZbQYhz+CQmbZvODBHmlehoE4KoVpPY0bSVcQKj8iyEX2Yh+WUWkl8WMDKvYhRPLS3O
        TU8tNspLLdcrTswtLs1L10vOz93ECEwkp/8d/7KDcfmrj3qHGJk4GA8xSnAwK4nw5k8uSRbi
        TUmsrEotyo8vKs1JLT7EKM3BoiTOyzZDK1lIID2xJDU7NbUgtQgmy8TBKdXA1MqxQlGtwCd2
        3r19S5VdfjHssJ94OV7uKcerepF1u5W5nsmf/NXmfTX6tsjh9rkTX3yJ6hFeqDHP+XLxJmcH
        N8/MyiUdcmZlkjfY3n+fss+mMfLlR60D93jXhDR97+DWZp6rv/HzPO1+rqK6e5et5Wu+JBjO
        59Q8vi75a7jrmfQpUywe56/68ceD4RFzYEX9K+N1Ci8+KhpaHT+exTN9wie/hOfOSpfXTtie
        c1JfVK5jhtO7/XqH8x7cWPnGys1XcNfK77/qL/qHPfk9/3uDxTXvhof7ZS7zJjxYvcb4Yt2t
        lpqvafqqxwRCu+WuzjEr+tjWtbYo+JvpXKb26fLT7jxX1+K1lf3wI3DJ5Hu3A5VYijMSDbWY
        i4oTAZH/3ImTAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t/xe7ptd0uSDWZt4bP4+n86i8W71nMs
        Fh96HrFZ3JjwlNHi9qTpLA6sHptWdbJ5rN37gtFj8+lqj8+b5AJYovRsivJLS1IVMvKLS2yV
        og0tjPQMLS30jEws9QyNzWOtjEyV9O1sUlJzMstSi/TtEvQy+t+0sRY0c1d8/XKBrYHxLUcX
        IyeHhICJxL1vexm7GLk4hASWMkq8aT/HCJGQkfh05SM7hC0s8edaFxtE0UdGiQM7z7NDOJsZ
        JR6e3sYKUsUmoCNx/s0dZhBbRCBCYv70/2CTmAWKJdZO6Abq5uAQFvCQ6L5qAhJmEVCVWLn1
        M1gJr4CtxLPV61gglslLtF2fzghSziygKbF+lz5EiaDEyZlPWCAmyks0b53NDFGuKLFlzndW
        CLtWYtPr9UwTGIVmIXTPQtI9C0n3AkbmVYwiqaXFuem5xYZ6xYm5xaV56XrJ+bmbGIGRs+3Y
        z807GOe9+qh3iJGJg/EQowQHs5IIb/7kkmQh3pTEyqrUovz4otKc1OJDjKZA30xklhJNzgfG
        bl5JvKGZgamhiZmlgamlmbGSOK9nQUeikEB6YklqdmpqQWoRTB8TB6dUAxO7z4ZvfCFf1zDf
        Ea3J1vTftOXYtWVcInM2zUzpXXw9+oPRwcuh9gKKu/e7LGj+quVjv1ZLfoJR49mlWh43LAxU
        WfIvyAhu2ynJyXqC53PKctdXpx5+K8z/u/5lm9P2T9u3mgf89RLLsw2I+HM1vvJq2P0WqW8b
        rZJNJaV0cmozPKbtZD6k7q9k9izkf1bX++6enO+tH10e/lh87sUfo0XeVjPWHEv093lelxre
        ae96fmWBp+DGkqqrO88LKG5dNnE5Y8bF9rsPfSewHdKap3hcVM/JQL3jd+mb5EIWCeVrXxgP
        PUtP/XrI//HeKtkINeF7nRNeCSV+rAgucnov3+sSvefSnLOTt5dk5s16nKzEUpyRaKjFXFSc
        CADs/4IVJQMAAA==
X-CMS-MailID: 20221116125430eucas1p2f2969a4a795614ce3b8c06f9ea3be36f
X-Msg-Generator: CA
X-RootMTR: 20221116125430eucas1p2f2969a4a795614ce3b8c06f9ea3be36f
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20221116125430eucas1p2f2969a4a795614ce3b8c06f9ea3be36f
References: <CGME20221116125430eucas1p2f2969a4a795614ce3b8c06f9ea3be36f@eucas1p2.samsung.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The motivation for this patch is to continue the discussion around how to
include LSM callback hooks in the io_uring infrastructure. To begin I take
the nvme io_uring passthrough and try to include it in the already existing
LSM infrastructure that is there for ioctl. This is far from a general
io_uring approach, but its a start :)

You are very welcome to comment on the patch, but I have specific questions
in mind:

1. The nvme io_uring are governed by ioctl numbers. In this patch I have
passed this number directly to the ioctl_has_perm function in selinux. For
the io_uring commands that follow such a pattern, is it enough to forward
the call? or do we need to plumb something else? @Paul: really interested
in hearing your thoughts.

2. Could we use something similar for commands that are not structured as
an ioctl? Does ublk structure its commands after ioctl, or does it use
another system? @David would like to hear your thoughts on
this.

3. Finally, Is there anything preventing us from gathering all these
io_uring commands under a common LSM infrastructure like the one that
already exists for ioctl?

Comments are greatly appreciated

Joel Granados (1):
  Use ioctl selinux callback io_uring commands that implement the ioctl
    op convention

 security/selinux/hooks.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

-- 
2.30.2

