Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF1D4583E6E
	for <lists+io-uring@lfdr.de>; Thu, 28 Jul 2022 14:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235511AbiG1MPu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jul 2022 08:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235249AbiG1MPu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jul 2022 08:15:50 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A47646DAC
        for <io-uring@vger.kernel.org>; Thu, 28 Jul 2022 05:15:48 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220728121547epoutp0378f4b5d973cbd96c829901794d5056d4~F-U2AMBsG1291512915epoutp03w
        for <io-uring@vger.kernel.org>; Thu, 28 Jul 2022 12:15:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220728121547epoutp0378f4b5d973cbd96c829901794d5056d4~F-U2AMBsG1291512915epoutp03w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1659010547;
        bh=Wt3GT05nDCrD14yF1klLj7HBIA0Nx53ev5pis4HZUcE=;
        h=From:To:Cc:Subject:Date:References:From;
        b=GGDnrCHvC6vLfRVA06bCw/vYt00v2NxFVIatGvsq9YOhTrTFJ+cs8qKimziSkMs9m
         CjNdksiHxuIeMlsjJaR4lBckuyeGBhA+47iGIuDEIhLG1xEiHfVZLQDfeU5R0sNYH8
         giuno4AYsZTUI1V3MQ4oWEcST2+GMxyhXwDDdWfs=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220728121546epcas5p3d4aa6492d83256405cafcd34b27d2166~F-U1pBWjS1153811538epcas5p3K;
        Thu, 28 Jul 2022 12:15:46 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4LtqNv6DnHz4x9Pp; Thu, 28 Jul
        2022 12:15:43 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2A.5C.09639.FED72E26; Thu, 28 Jul 2022 21:15:43 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220728093902epcas5p40813f72b828e68e192f98819d29b2863~F9L-mNUNP0693706937epcas5p4U;
        Thu, 28 Jul 2022 09:39:02 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220728093902epsmtrp2dbfa2dae26431eb820a34a3847a0d8f2~F9L-llTvz3160531605epsmtrp2G;
        Thu, 28 Jul 2022 09:39:02 +0000 (GMT)
X-AuditID: b6c32a4b-e83ff700000025a7-c9-62e27def0057
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E5.7B.08802.63952E26; Thu, 28 Jul 2022 18:39:02 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220728093901epsmtip1c597b9fb82d4d00e14683fe9027099e9~F9L_xMGU31234512345epsmtip1H;
        Thu, 28 Jul 2022 09:39:01 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH liburing v3 0/5] Add basic test for nvme uring passthrough
 commands
Date:   Thu, 28 Jul 2022 15:03:22 +0530
Message-Id: <20220728093327.32580-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsWy7bCmpu772kdJBvPfGlisufKb3WL13X42
        i3et51gsjv5/y+bA4nH5bKlH35ZVjB6fN8kFMEdl22SkJqakFimk5iXnp2TmpdsqeQfHO8eb
        mhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYALVNSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2Cql
        FqTkFJgU6BUn5haX5qXr5aWWWBkaGBiZAhUmZGecuT+FveAgT8XNDb2sDYxXObsYOTkkBEwk
        9n07x9bFyMUhJLCbUeLNvm+sIAkhgU+MEs+3B0MkPjNKHO84ywrTcfRMA1THLkaJf5N2skM4
        rUwSf389B6tiE9CWePX2BjOILSIgLLG/o5UFxGYWiJJY8+osI4gtLBAq0bb7OFicRUBVYvL7
        k2C9vAI2EpPu3mGB2CYvsXrDAWYIu5tdYv2qCgjbReJ/zxImCFtY4tXxLewQtpTE53d72SDs
        bIlND39C1RRIHHnRCzXHXqL1VD+QzQF0j6bE+l36EGFZiamn1jFBnMkn0fv7CVQrr8SOeTC2
        qsTfe7ehTpOWuPnuKpTtIbHpyD9GSMjFSmzcv41lAqPsLIQNCxgZVzFKphYU56anFpsWGOel
        lsPjKTk/dxMjOAlpee9gfPTgg94hRiYOxkOMEhzMSiK8CdH3k4R4UxIrq1KL8uOLSnNSiw8x
        mgKDbCKzlGhyPjAN5pXEG5pYGpiYmZmZWBqbGSqJ83pd3ZQkJJCeWJKanZpakFoE08fEwSnV
        wLTxf+/yH0e4PlzZv+1SZHxNw6ZPUsdPnW3PiN7Xe1zjpo/A/YTOk2fuWpSzmfovmVKyPrvx
        /dIIz4NP1VSPZdadS929SDk18/QD5Zw14vE+Z/cvN1+tkynqcN5sTUz1p2AuhkNmzxeeeGDS
        biMnEcqwrmCV9NfKjMYfJadi3Pv5fYMSYnS2XshlnCl6ltstgiG/19Jd83nm9NnZu/IzJxqu
        VlghKRSlLbzAg9e/3aGrV/L81k1GTHdnzG15Ibt4fvf9eUc2v6nzY2IxSog6fSvo05/n91Zs
        fb9id9Rtx59XuzI2uW1mOvZo5v4/sqdXeRd8nVJs4yfBzB37Z265i58w1/vQdasuV6/r6Nm+
        MF6JpTgj0VCLuag4EQDEKy1aywMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJMWRmVeSWpSXmKPExsWy7bCSnK5Z5KMkg687dSzWXPnNbrH6bj+b
        xbvWcywWR/+/ZXNg8bh8ttSjb8sqRo/Pm+QCmKO4bFJSczLLUov07RK4Ms7cn8JecJCn4uaG
        XtYGxqucXYycHBICJhJHzzSwdTFycQgJ7GCU2HL5P3sXIwdQQlpi4fpEiBphiZX/nrND1DQz
        STw9dZcdJMEmoC3x6u0NZhBbBKhof0crC4jNLBAjMfXIYTBbWCBYYtqf7YwgNouAqsTk9ydZ
        QWxeARuJSXfvsEAskJdYveEA8wRGngWMDKsYJVMLinPTc4sNC4zyUsv1ihNzi0vz0vWS83M3
        MYIDQktrB+OeVR/0DjEycTAeYpTgYFYS4U2Ivp8kxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdC
        18l4IYH0xJLU7NTUgtQimCwTB6dUA9O+4lKxd2tzam7qWE2R3N5iw/uzR3TeiU+/7nxsiKjh
        MA/p7i5NOeP68FqC0hEVfd56HgXOxZadjVGr4lcsPJcoO79sepRV8TWHlrO3suc6FTzzfjfn
        VMv9xt+2+7P/Vb7cOE/Z69P6o86Jy7aZTd50QMZFv1A2MfhBx+TN3zufvFhQfmjys81HS3d1
        /551/Kx0lZbptqPyjKUncq2Sl3yIKHrfKnPb3Er2o36UnofhhsfsFco8Wh9+L1kjuXpnGouW
        uojctvpv8jnBK5NSWg5n6OUlyK1ftbOf4fyl2nm2B2au6O8x2HP9k3JuPK9bZVatytcL/2JD
        9h9beIXrHwff4az7t887R7/dP2OGSLUSS3FGoqEWc1FxIgDz2eSadwIAAA==
X-CMS-MailID: 20220728093902epcas5p40813f72b828e68e192f98819d29b2863
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220728093902epcas5p40813f72b828e68e192f98819d29b2863
References: <CGME20220728093902epcas5p40813f72b828e68e192f98819d29b2863@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patchset adds a way to test NVMe uring passthrough commands with
nvme-ns character device. The uring passthrough was introduced with 5.19
io_uring.

To send nvme uring passthrough commands we require helpers to fetch NVMe
char device (/dev/ngXnY) specific fields such as namespace id, lba size etc.

How to run:
./test/io_uring_passthrough.t /dev/ng0n1

It requires argument to be NVMe device, if not the test will be skipped.

The test covers write/read with verify for sqthread poll, vectored / nonvectored
and fixed IO buffers, which can be extended in future. As of now iopoll is not
supported for passthrough commands, there is a test for such case.

Changes from v2 to v3
 - Skip test if argument is not nvme device and remove prints, as
   suggested by Jens.
 - change nvme helper function name, as pointed by Jens.
 - Remove wrong comment about command size, as per Kanchan's review

Ankit Kumar (5):
  configure: check for nvme uring command support
  io_uring.h: sync sqe entry with 5.20 io_uring
  nvme: add nvme opcodes, structures and helper functions
  test: add io_uring passthrough test
  test/io_uring_passthrough: add test case for poll IO

 configure                       |  20 ++
 src/include/liburing/io_uring.h |  17 +-
 test/Makefile                   |   1 +
 test/io_uring_passthrough.c     | 390 ++++++++++++++++++++++++++++++++
 test/nvme.h                     | 168 ++++++++++++++
 5 files changed, 594 insertions(+), 2 deletions(-)
 create mode 100644 test/io_uring_passthrough.c
 create mode 100644 test/nvme.h

-- 
2.17.1

