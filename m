Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2B72570088
	for <lists+io-uring@lfdr.de>; Mon, 11 Jul 2022 13:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbiGKL2r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jul 2022 07:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiGKL2Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jul 2022 07:28:16 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA72F322
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 04:08:02 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220711110757epoutp04fdf028347f3d02add9514bbb03b09eb2~Awbw7jrM50066300663epoutp04e
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 11:07:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220711110757epoutp04fdf028347f3d02add9514bbb03b09eb2~Awbw7jrM50066300663epoutp04e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1657537677;
        bh=rfBwCyaPTWgve+aNLgO7YznJVxf6LVxBLuPK/IeYRRc=;
        h=From:To:Cc:Subject:Date:References:From;
        b=F+hXuGoBJ6QKBCMAyP9aiiuQZEPtpYXgK38YjcSA+pODmEzQXy0NA5IhNScEcXYee
         CN01+PU6xlBwfiVcu8DgVBQl2oBp5dg5DZgkI9BUYS501vuF7UCmNqNYWhEq3VfTUn
         2AWMaKvnSVuE2m1XdYp7fwY4+ZDMoPcgq4fHk5jo=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220711110756epcas5p10847bd1317dc4be3e3fa169081c35b62~AwbwOTEhI1352413524epcas5p18;
        Mon, 11 Jul 2022 11:07:56 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4LhLhV2MlMz4x9Pt; Mon, 11 Jul
        2022 11:07:54 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        55.20.09566.A840CC26; Mon, 11 Jul 2022 20:07:54 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220711110753epcas5p4169b9e288d15ca35740dbb66a6f6983a~AwbtzOTky0387003870epcas5p4j;
        Mon, 11 Jul 2022 11:07:53 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220711110753epsmtrp22fc9aa1e8677181c1165fc0e32b6db35~AwbtyZxb_2556725567epsmtrp22;
        Mon, 11 Jul 2022 11:07:53 +0000 (GMT)
X-AuditID: b6c32a4a-b8dff7000000255e-6e-62cc048afe11
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        D7.89.08802.9840CC26; Mon, 11 Jul 2022 20:07:53 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220711110751epsmtip2af1d1762efbc5c9c0992382025e8908a~AwbsAefGg0337803378epsmtip2B;
        Mon, 11 Jul 2022 11:07:51 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     hch@lst.de, sagi@grimberg.me, kbusch@kernel.org, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, asml.silence@gmail.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next 0/4] nvme-multipathing for uring-passthrough
Date:   Mon, 11 Jul 2022 16:31:51 +0530
Message-Id: <20220711110155.649153-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNJsWRmVeSWpSXmKPExsWy7bCmpm4Xy5kkg9vr+SyaJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFkf/v2WzOP/2MJPFpEPXGC323tK2mL/sKbvFutfvWRx4
        PHbOusvucf7eRhaPy2dLPTat6mTz2Lyk3mP3zQY2j74tqxg9Pm+SC+CIyrbJSE1MSS1SSM1L
        zk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpVSaEsMacUKBSQWFyspG9n
        U5RfWpKqkJFfXGKrlFqQklNgUqBXnJhbXJqXrpeXWmJlaGBgZApUmJCdMWnSZdaCJ7wVf7dt
        ZWtgXMLdxcjJISFgIrH48yaWLkYuDiGB3YwSFw7/ZYJwPjFK3Nn9iRnC+cwo0bmhlwWm5cXV
        DqiqXYwST/p/McFV7Ty+A6iKg4NNQFPiwuRSkAYRAReJzqbprCA1zAJ3GSUadq1mBEkIC7hK
        dJ5cywhSzyKgKnFueyVImFfAUuLkztfsEMvkJWZe+s4OEReUODnzCdgRzEDx5q2zwa6TEGjl
        kDhwfT3UdS4S538vYYKwhSVeHd8CNUhK4vO7vWwQdrLEpZnnoGpKJB7vOQhl20u0nupnBrmH
        Gej+9bv0IXbxSfT+fsIEEpYQ4JXoaBOCqFaUuDfpKSuELS7xcMYSKNtDYseju8wgtpBArMTl
        139ZJzDKzULywSwkH8xCWLaAkXkVo2RqQXFuemqxaYFRXmo5PC6T83M3MYJTqZbXDsaHDz7o
        HWJk4mA8xCjBwawkwvvn7KkkId6UxMqq1KL8+KLSnNTiQ4ymwFCdyCwlmpwPTOZ5JfGGJpYG
        JmZmZiaWxmaGSuK8Xlc3JQkJpCeWpGanphakFsH0MXFwSjUw7fH1dTM2X3OgsHCff4LUFVOX
        7RbPT8x9etj27FH3FN+Lq713vjoiKGD5/nqd8OONUnGGq6QsmzY+yuUL7uuX3a/WcTzj+5Or
        iolbb/UclmTQm1sWv6u0yGCh4+/zv1taZDaouiuVMvu8D7vmILzvHZ/rl74y3bKP/JyfJ0UL
        vzqpd2PL/tAjXBqHpJvS8yS8jJ5YlOb84Tn5x8OY6/p833u2xtPd5yzslrI9Hrj0zZzC9yV5
        Lst3ip+IF5j45OCbXQcmaetZ6x+9fPnoTNmdN+6/k8w+qc0fN0OptedjtIuq9d28g8U+nmLr
        XmbcOcV14lf4veUcd672nkjZNWvyxj9Fh1e0TFp9xnMuw6NF65VYijMSDbWYi4oTAbe2JGEu
        BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsWy7bCSvG4ny5kkg7eXFS2aJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFkf/v2WzOP/2MJPFpEPXGC323tK2mL/sKbvFutfvWRx4
        PHbOusvucf7eRhaPy2dLPTat6mTz2Lyk3mP3zQY2j74tqxg9Pm+SC+CI4rJJSc3JLEst0rdL
        4MqYNOkya8ET3oq/27ayNTAu4e5i5OSQEDCReHG1g6mLkYtDSGAHo0T70m3MEAlxieZrP9gh
        bGGJlf+es0MUfWSUOPrlPmMXIwcHm4CmxIXJpSA1IgJeEit6/oANYhZ4yigxeVY/I0hCWMBV
        ovPkWrB6FgFViXPbK0HCvAKWEid3voaaLy8x89J3doi4oMTJmU9YQGxmoHjz1tnMExj5ZiFJ
        zUKSWsDItIpRMrWgODc9t9iwwCgvtVyvODG3uDQvXS85P3cTIzjctbR2MO5Z9UHvECMTB+Mh
        RgkOZiUR3j9nTyUJ8aYkVlalFuXHF5XmpBYfYpTmYFES573QdTJeSCA9sSQ1OzW1ILUIJsvE
        wSnVwCT82/aO16mNke1JZuUGKnf7ew838dxN/O9jmbJZTEfnkvo9WZ41ZxOLytwfOqn1M4Qp
        V5UWnNlzMmTiMWve5uPc11yfx9v3GspbpL7b0X746Yvt22Of3Z6xglGa8a1h1qsXkvJT33NM
        MmmKPHJlG2da0d+MT+o6upUXPZc0/Jh+lsvXwW1Pb5Ntv+cXhlIORrlXKxXiK4N82Zan/oq9
        LJrqoC+w+KHzrrUOD98mOYi3nf55IORkhddrlY8bT/Isyfv5fz5DeHnRxM0v9/wR9ea8wvw4
        1PJXnPJPpQ7373GCTrxm1VOc93jJBrzxXHv0xf335at7/0nPW1Dw2O+PxSMN1yuvfXyE2WYL
        rljWo8RSnJFoqMVcVJwIALhWjX7mAgAA
X-CMS-MailID: 20220711110753epcas5p4169b9e288d15ca35740dbb66a6f6983a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220711110753epcas5p4169b9e288d15ca35740dbb66a6f6983a
References: <CGME20220711110753epcas5p4169b9e288d15ca35740dbb66a6f6983a@epcas5p4.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

nvme passthrough lacks multipathing capability and some of us have
already expressed interest to see this plumbed. Most recently during LSFMM,
around 2 months back.

This series wires up multipathing for uring-passthrough commands.
Attempt is not to affect the common path (i.e. when
requeue/failover does not trigger) with allocation or deferral. The
most important design bit is to treat "struct io_uring_cmd" in the same
way as "struct bio" is treated by the block-based nvme multipath.
Uring-commands are queued when path is not available, and resubmitted on
discovery of new path. Also if passthrough command on multipath-node is
failed, it is resubmitted on a different path.

Testing:
Using the upstream fio that support uring-passthrough:

fio -iodepth=16 -rw=randread -ioengine=io_uring_cmd -bs=4k -numjobs=4
-size=1G -iodepth_batch_submit=16 -group_reporting -cmd_type=nvme
-filename=/dev/ng0n1 -name=uring-pt

1. Multiple failover - every command is retried 1-5 times before completion
2. Fail nvme_find_path() - this tests completion post requeue
3. Combine above two
4. Repeat above but for passthrough commands which do not generate bio
(e.g. flush command)


Anuj Gupta (2):
  nvme: compact nvme_uring_cmd_pdu struct
  nvme-multipath: add multipathing for uring-passthrough commands

Kanchan Joshi (2):
  io_uring, nvme: rename a function
  io_uring: grow a field in struct io_uring_cmd

 drivers/nvme/host/ioctl.c     | 157 +++++++++++++++++++++++++++++-----
 drivers/nvme/host/multipath.c |  36 +++++++-
 drivers/nvme/host/nvme.h      |  26 ++++++
 include/linux/io_uring.h      |  44 +++++++++-
 io_uring/uring_cmd.c          |   4 +-
 5 files changed, 237 insertions(+), 30 deletions(-)

-- 
2.25.1

