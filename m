Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8609C57AFB2
	for <lists+io-uring@lfdr.de>; Wed, 20 Jul 2022 06:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiGTEJf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Jul 2022 00:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiGTEJd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Jul 2022 00:09:33 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD5E1ADAF
        for <io-uring@vger.kernel.org>; Tue, 19 Jul 2022 21:09:31 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220720040928epoutp040ff8ef688f387252105ac29a8e031703~Dbh9cIogC0256502565epoutp04j
        for <io-uring@vger.kernel.org>; Wed, 20 Jul 2022 04:09:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220720040928epoutp040ff8ef688f387252105ac29a8e031703~Dbh9cIogC0256502565epoutp04j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1658290168;
        bh=hAtl7d/IVesxfMj8ubk3qaBdmb3bOz5d+s+k6dcRMTk=;
        h=From:To:Cc:Subject:Date:References:From;
        b=NWwZfMNqtQpVD0Ho09nAhQCMJuNRiOYrvZaogDmcBFYkm83f8Dz2LVhv+omlDlgOZ
         hAcbb2Sl6WqZvteiHT3IZ+s2RO6DmMpMHsqMN31yguIeR6AzPu/6kaysbIp42T3O6e
         BzpXCNF2QNgavJfpjmrjgrn8xhXJ69oy+ZgY/K7Y=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220720040928epcas5p23aafece45bd7ab15ae2ae948e80aff32~Dbh9Hprr70916309163epcas5p2R;
        Wed, 20 Jul 2022 04:09:28 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4LnhzT1R3nz4x9QB; Wed, 20 Jul
        2022 04:09:25 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F7.EC.09662.EEF77D26; Wed, 20 Jul 2022 13:09:18 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220719135821epcas5p1b071b0162cc3e1eb803ca687989f106d~DP61iIW4z1855618556epcas5p1l;
        Tue, 19 Jul 2022 13:58:21 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220719135821epsmtrp1057d3a1dea56cd49a11fd45625b8d0bb~DP61hX-nB1050910509epsmtrp1P;
        Tue, 19 Jul 2022 13:58:21 +0000 (GMT)
X-AuditID: b6c32a49-885ff700000025be-01-62d77fee4efe
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BA.7A.08905.D78B6D26; Tue, 19 Jul 2022 22:58:21 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220719135820epsmtip18ae1363d0115980b7fa073757e5022af~DP60dFQ493033030330epsmtip1o;
        Tue, 19 Jul 2022 13:58:20 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, paul@paul-moore.com,
        casey@schaufler-ca.com, joshi.k@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH liburing 0/5] Add basic test for nvme uring passthrough
 commands
Date:   Tue, 19 Jul 2022 19:22:29 +0530
Message-Id: <20220719135234.14039-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDKsWRmVeSWpSXmKPExsWy7bCmpu67+utJBk2POS3WXPnNbrH6bj+b
        xb1tv9gs3rWeY7E4+v8tm8XtSdNZHNg8Lp8t9Vi79wWjR9+WVYweR/cvYvP4vEkugDUq2yYj
        NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6AAlhbLEnFKg
        UEBicbGSvp1NUX5pSapCRn5xia1SakFKToFJgV5xYm5xaV66Xl5qiZWhgYGRKVBhQnbG1i/X
        WQr2cVbca29hamBcy97FyMkhIWAicfboC9YuRi4OIYHdjBI7Tn8HSwgJfGKU+HusCCLxjVHi
        4eYPLF2MHGAde58zQ8T3MkpM3HuRFaKhlUmiY7UMiM0moC3x6u0NZhBbREBYYn9HKwtIA7NA
        O6PEhwVHwDYICwRJPF62HcxmEVCVmNx8EKyBV8BG4sWsNUwQ58lLrN5wAGybhMAqdonFdy4w
        QyRcJPbtfAr1g7DEq+NboGwpiZf9bVB2tsSmhz+hBhVIHHnRC9VrL9F6qp8Z5BtmAU2J9bv0
        IcKyElNPrQMrZxbgk+j9/QSqlVdixzwYW1Xi773bLBC2tMTNd1ehbA+Jz88mMkECIlbiw8/v
        bBMYZWchbFjAyLiKUTK1oDg3PbXYtMAwL7UcHk/J+bmbGMHJSstzB+PdBx/0DjEycTAeYpTg
        YFYS4X1aeD1JiDclsbIqtSg/vqg0J7X4EKMpMMwmMkuJJucD02VeSbyhiaWBiZmZmYmlsZmh
        kjiv19VNSUIC6YklqdmpqQWpRTB9TBycUg1MM2qCk3LzOy+YcM8xySn7r3CGUWm2xY8FP+Q7
        Oy9d5+2a5xWsfFzJeo3fvZrrx/csP+y/v/218zGJj/kCHxhifijyZOhxbmW5XMe6mk9NuWXX
        5Pgg496atwb1Uc9qdn17uuGP4cy+NQ7rbC4ymHwVXhDPFuVVu9bsEHNJfJT0jeQUhduRj9Y/
        sZ/1qljGpGN+4vn1XN+vLT1z0rah/FdFfOTjHZpLC/yTEiTjT4d+/vxZ/IbnmT/5/YJ/s0xe
        JC54MasySrZg8/9Wm9vPputLz8/oati7dFeMxfT+k6yqnJFO5eKLNA+eSk46ZjtVIcyGe6qe
        lxP35sdu60QeLDm4vKZDSMxq/d3scyVKcveVWIozEg21mIuKEwEYablY3wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBJMWRmVeSWpSXmKPExsWy7bCSnG7tjmtJBl1z1S3WXPnNbrH6bj+b
        xb1tv9gs3rWeY7E4+v8tm8XtSdNZHNg8Lp8t9Vi79wWjR9+WVYweR/cvYvP4vEkugDWKyyYl
        NSezLLVI3y6BK2Prl+ssBfs4K+61tzA1MK5l72Lk4JAQMJHY+5y5i5GLQ0hgN6PE901rmCHi
        0hIL1yd2MXICmcISK/89Z4eoaWaS+HBiJRtIgk1AW+LV2xvMILYIUNH+jlYWkCJmgV5GiZX/
        jzCBJIQFAiSeLJzNAmKzCKhKTG4+CNbAK2Aj8WLWGiaIDfISqzccYJ7AyLOAkWEVo2RqQXFu
        em6xYYFhXmq5XnFibnFpXrpecn7uJkZw4Ghp7mDcvuqD3iFGJg7GQ4wSHMxKIrwitZeThHhT
        EiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQnliSmp2aWpBaBJNl4uCUamDyPJP+vHtep4Pk
        Lb00c4mXf+8UBJ446WPpN2Xq7f+tz3gzml3jpVatl9MUNPvL9nlNjebmGRdXHT5xTOe0t3w6
        4xbDYo3AwL1Mqi7312xzDxfaIzD33/Rd7z17RfhYnTW0PGouPRFfOucAz5rISXHu7R1nrtnz
        8Myedsh/tttzkyX3N1tGal8KCdyWrX5P+lD8XT/PtiPHrFceDRJ8af/vmMls9e8mGe+XLNm+
        dk+Im5qiVmTVzSl3t4hczq+XPnmicW35k23yPq9O7jMuu3/y1Jn8G5c6Kg6keuirnF/BJvLq
        bJG3rULmjxNxa6fvq6o3fV1UtH6x94zkX6Z3b7wPuGmx0aRH2NHDR9joa4WCEktxRqKhFnNR
        cSIAh5pTbIsCAAA=
X-CMS-MailID: 20220719135821epcas5p1b071b0162cc3e1eb803ca687989f106d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220719135821epcas5p1b071b0162cc3e1eb803ca687989f106d
References: <CGME20220719135821epcas5p1b071b0162cc3e1eb803ca687989f106d@epcas5p1.samsung.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patchset adds test/io_uring_passthrough.c to submit uring passthrough
commands to nvme-ns character device. The uring passthrough was introduced
with 5.19 io_uring.

To send nvme uring passthrough commands we require helpers to fetch NVMe
char device (/dev/ngXnY) specific fields such as namespace id, lba size.

How to run:
./test/io_uring_passthrough.t /dev/ng0n1

This covers basic write/read with verify for sqthread poll,
vectored / nonvectored and fixed IO buffers, which can be easily extended
in future.

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

