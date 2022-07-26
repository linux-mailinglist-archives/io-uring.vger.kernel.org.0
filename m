Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9C7581253
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 13:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238761AbiGZLum (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 07:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbiGZLui (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 07:50:38 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4084B2BB25
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 04:50:35 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220726115029epoutp0341016526f39c5de2273d05de5d714d9e~FXsMW_JP50722607226epoutp03E
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 11:50:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220726115029epoutp0341016526f39c5de2273d05de5d714d9e~FXsMW_JP50722607226epoutp03E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1658836229;
        bh=61eMueyx7NPjcYoOq/pfUl7b6WQIRiFtw+L+WRhr6qw=;
        h=From:To:Cc:Subject:Date:References:From;
        b=rRS0takJ1qkDI8POy4wRQF1S/qhNTXK84ordVqAe/r4J4q+4UfouEt8hz81Rt8ldr
         9k9eX9v52XzlVC0y02DmejZoG6WVyezKSaFmDySgThBQbOXeDhNOkMyoK+QQp2RRaT
         7c4c4L3qDuW5vB401VcEKHP9JrDndHPR8Hk8A2PU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220726115029epcas5p29733cf4ae52c847a85d7b45f862d2118~FXsMDZkhU0568605686epcas5p2O;
        Tue, 26 Jul 2022 11:50:29 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4LsZwf4TGCz4x9Pr; Tue, 26 Jul
        2022 11:50:26 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F6.C9.09639.FF4DFD26; Tue, 26 Jul 2022 20:50:23 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220726105812epcas5p4a2946262206548f67e238845e23a122c~FW_iQ6Zuq0636306363epcas5p4X;
        Tue, 26 Jul 2022 10:58:12 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220726105812epsmtrp2fc1d86198d358fc86fc69fc7338f7c30~FW_iQUJGU3043430434epsmtrp2V;
        Tue, 26 Jul 2022 10:58:12 +0000 (GMT)
X-AuditID: b6c32a4b-e6dff700000025a7-7d-62dfd4ff817b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AF.D9.08905.4C8CFD26; Tue, 26 Jul 2022 19:58:12 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220726105811epsmtip16035def221f60369bd080af7108c0daf~FW_hNNZle2209422094epsmtip1d;
        Tue, 26 Jul 2022 10:58:10 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH liburing v2 0/5] Add basic test for nvme uring passthrough
 commands
Date:   Tue, 26 Jul 2022 16:22:25 +0530
Message-Id: <20220726105230.12025-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsWy7bCmhu7/K/eTDJ4+47ZYc+U3u8Xqu/1s
        Fu9az7FYHP3/ls2BxePy2VKPvi2rGD0+b5ILYI7KtslITUxJLVJIzUvOT8nMS7dV8g6Od443
        NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBWqakUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVK
        LUjJKTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM6Y9LSXtaCbu2LCzFWMDYwHOLoYOTkkBEwk
        fu/dzNzFyMUhJLCbUWLvm3UsEM4nRok7LWeYQaqEBL4xShz47gLTMfXETUaIor2MEm+nfILq
        aGWS6JjwgQ2kik1AW+LV2xtg3SICwhL7O1pZQGxmgSiJNa/OMoLYwgKhEr9W7AOq5+BgEVCV
        WLErCCTMK2Aj0d7yjg1imbzE6g0HmCHsbnaJqxtKIWwXiZkP+xkhbGGJV8e3sEPYUhKf3+2F
        6s2W2PTwJxOEXSBx5EUv1Bx7idZT/cwga5kFNCXW79KHCMtKTD21jgniSj6J3t9PoFp5JXbM
        g7FVJf7eu80CYUtL3Hx3Fcr2kJj1vRMaVrESe7umskxglJ2FsGEBI+MqRsnUguLc9NRi0wLj
        vNRyeDQl5+duYgSnIC3vHYyPHnzQO8TIxMF4iFGCg1lJhDch+n6SEG9KYmVValF+fFFpTmrx
        IUZTYIhNZJYSTc4HJsG8knhDE0sDEzMzMxNLYzNDJXFer6ubkoQE0hNLUrNTUwtSi2D6mDg4
        pRqY5tzZ57ZbhVPNoPCd+vpAFdcXFyffUBZbkWBQ4aq8UoIl1ybMdGqA2j+mgiPOfAwnMpuM
        s2J2VJ2YMkvlpmJ82I017PaK/7IePzTfy3/0MMeDKPsZxZMMclSnO6zL6w+uevZnVc6+2lZX
        j1efltc1tkY+8j325/0xlSf8/JOiLy6Z8bRTcb61WvDcnaIeu8W8zKyLNA/s36yjfP6L9cno
        yRuW/lZcfX/jthUPgxRVBJelP7ooek1pmnuElcV7M9Fza6sy/n74HCx8XuP2UpFtvqLfP1j2
        i1izXJ8k+WUNm8tuoc1Hlkp7nXnNt3C+rHBi3KrCu/xzKzvPF09hCVo1ffK2Mpn5q5c1+aUZ
        pF8KVWIpzkg01GIuKk4EAJ2xzrXKAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJMWRmVeSWpSXmKPExsWy7bCSnO6RE/eTDO4cYbNYc+U3u8Xqu/1s
        Fu9az7FYHP3/ls2BxePy2VKPvi2rGD0+b5ILYI7isklJzcksSy3St0vgypj0tJe1oJu7YsLM
        VYwNjAc4uhg5OSQETCSmnrjJ2MXIxSEksJtRYvb2pUxdjBxACWmJhesTIWqEJVb+e84OUdPM
        JHHt2mc2kASbgLbEq7c3mEFsEaCi/R2tLCA2s0CMxNQjh8FsYYFgiR2fprKDzGQRUJVYsSsI
        JMwrYCPR3vKODWK+vMTqDQeYJzDyLGBkWMUomVpQnJueW2xYYJiXWq5XnJhbXJqXrpecn7uJ
        ERwOWpo7GLev+qB3iJGJg/EQowQHs5IIb0L0/SQh3pTEyqrUovz4otKc1OJDjNIcLErivBe6
        TsYLCaQnlqRmp6YWpBbBZJk4OKUamORYXj9qfHCucPfiigRFyWlHjhw/zXk+vXrL9H9/N2ec
        NAiQa97W6r3nk0HVz5UHbsvuXuTLsTXUYHWgnFXI0hvV364bP/cR1Z/8IrL9msuXio8Cz7KP
        lttP0XwWHRVz+2Cv8pc2v33K3rolM24rSE1/d8/04aHfs1q4rLoW8TyK6FoaOSW+V/v/8+V2
        biukH+Y2fd53bEWE1IuWsy1TJv0TPhuvdtXgyC2r9VG/kp9NPmJ/R+zQuwOLN4qHHw5LOpbA
        z9y+02H6lSlWO79p/Ko1Xu57Wm7/9X3yszav5IxZLn6/K1/jR5F2adKzk6e68xySIpavsynm
        Ti1rKr9qz3uxTd/gIY/OZoX8vVEzHSKUWIozEg21mIuKEwFfGMQGdgIAAA==
X-CMS-MailID: 20220726105812epcas5p4a2946262206548f67e238845e23a122c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220726105812epcas5p4a2946262206548f67e238845e23a122c
References: <CGME20220726105812epcas5p4a2946262206548f67e238845e23a122c@epcas5p4.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

This patchset adds a way to test NVMe uring passthrough commands with
nvme-ns character device. The uring passthrough was introduced with 5.19
io_uring.

To send nvme uring passthrough commands we require helpers to fetch NVMe
char device (/dev/ngXnY) specific fields such as namespace id, lba size etc.
 
How to run:
./test/io_uring_passthrough.t /dev/ng0n1

The test covers write/read with verify for sqthread poll, vectored / nonvectored
and fixed IO buffers, which can be extended in future. As of now iopoll is not
supported for passthrough commands, there is a test for such case.

There was no reviewer for v1, can you please have a look at the changes.

v1 -> v2
 - Rebase on top of latest master

Ankit Kumar (5):
  configure: check for nvme uring command support
  io_uring.h: sync sqe entry with 5.20 io_uring
  nvme: add nvme opcodes, structures and helper functions
  test: add io_uring passthrough test
  test/io_uring_passthrough: add test case for poll IO

 configure                       |  20 ++
 src/include/liburing/io_uring.h |  17 +-
 test/Makefile                   |   1 +
 test/io_uring_passthrough.c     | 395 ++++++++++++++++++++++++++++++++
 test/nvme.h                     | 168 ++++++++++++++
 5 files changed, 599 insertions(+), 2 deletions(-)
 create mode 100644 test/io_uring_passthrough.c
 create mode 100644 test/nvme.h

-- 
2.17.1

