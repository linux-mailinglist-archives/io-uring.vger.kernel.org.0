Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E948F518C94
	for <lists+io-uring@lfdr.de>; Tue,  3 May 2022 20:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241655AbiECSw7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 May 2022 14:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241658AbiECSww (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 May 2022 14:52:52 -0400
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F39F3F895
        for <io-uring@vger.kernel.org>; Tue,  3 May 2022 11:49:17 -0700 (PDT)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20220503184913euoutp011e35937a4dfbde069dc08f1b10d81255~rrN0JkQ-62551925519euoutp01H
        for <io-uring@vger.kernel.org>; Tue,  3 May 2022 18:49:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20220503184913euoutp011e35937a4dfbde069dc08f1b10d81255~rrN0JkQ-62551925519euoutp01H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1651603753;
        bh=iz+p7bDMUcYyKlNup+Zqd20j5kqXKUQ6Q5x3pgksN8U=;
        h=From:To:Cc:Subject:Date:References:From;
        b=gyZUlv7X8c/2BwBpYII28htJ6iNRabjP7RryNfPpUHmNbSY3plP1v9AEpIgkvKVFt
         CinTfUJxQ7XGrpqFZf5xRtSxn40QNOyLEokdjNApApTOOBtVepx8UCQWEaZF3g6ums
         E8hvLz5tGufVsvcXt4EKmw5nDlo/oKg5+yuy/Msk=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220503184912eucas1p2d2ac748490606e9dde2dd8865bbeedd0~rrNyzNESl0195601956eucas1p2L;
        Tue,  3 May 2022 18:49:12 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id F2.2E.10009.82971726; Tue,  3
        May 2022 19:49:12 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20220503184911eucas1p1beb172219537d78fcaf2a1417f532cf7~rrNyMqchm1431714317eucas1p1N;
        Tue,  3 May 2022 18:49:11 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220503184911eusmtrp105885fccf2f72e1e60d4cd9040d9d464~rrNyL5eux2552825528eusmtrp1U;
        Tue,  3 May 2022 18:49:11 +0000 (GMT)
X-AuditID: cbfec7f2-e95ff70000002719-8f-627179288291
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 49.F6.09404.72971726; Tue,  3
        May 2022 19:49:11 +0100 (BST)
Received: from localhost (unknown [106.210.248.170]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220503184911eusmtip18cef2fe915b96c7eaf34d52893770bb4~rrNx15GjS0995809958eusmtip1B;
        Tue,  3 May 2022 18:49:11 +0000 (GMT)
From:   Pankaj Raghav <p.raghav@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        shr@fb.com, joshiiitr@gmail.com, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v3 0/5] io_uring passthough for nvme
Date:   Tue,  3 May 2022 20:48:26 +0200
Message-Id: <20220503184831.78705-1-p.raghav@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsWy7djPc7oalYVJBp2HOSzmrNrGaLH6bj+b
        xc0DO5ksVq4+ymTxrvUci8XR/2/ZLM6/PcxkMX/ZU3aLGxOeMlocmtzMZHH15QF2B26Pic3v
        2D12zrrL7nH5bKnHplWdbB6bl9R77L7ZwObxft9VNo++LasYPT5vkgvgjOKySUnNySxLLdK3
        S+DK6PinVfCOt2Lh5DVsDYw/uboYOTkkBEwkFn65ydLFyMUhJLCCUWLD18dsEM4XRon259ug
        nM+MEvM/bGeGaZm9bzVUYjmjxNu9uxghnJdAzsfpQMM4ONgEtCQaO9lBGkQE5CW+3F4LtoNZ
        4B6jxOk5DWAJYaBJjYfXgNksAqoSm7oXs4HYvAKWEuuaHrJBbJOXmHnpOztEXFDi5MwnLCA2
        M1C8eetsZpChEgJXOCT6p55mhGhwkVgyaz2ULSzx6vgWdghbRuL05B4WCLta4umN31DNLYwS
        /TvXs4FcLSFgLdF3JgfEZBbQlFi/Sx+i3FHi7JsfjBAVfBI33gpCnMAnMWnbdGaIMK9ER5sQ
        RLWSxM6fT6CWSkhcbpoDtdRDonfFEnAYCgnESmxoPcw+gVFhFpLHZiF5bBbCDQsYmVcxiqeW
        FuempxYb5qWW6xUn5haX5qXrJefnbmIEJq3T/45/2sE499VHvUOMTByMhxglOJiVRHidlxYk
        CfGmJFZWpRblxxeV5qQWH2KU5mBREudNztyQKCSQnliSmp2aWpBaBJNl4uCUamASUpHIdXh6
        08Gv5r6fub7e8WsfmtmepodMuVrN+eJe2B6utdN1iiZNYJhnrn/6xj73+VHCeUE+i5N31E15
        MXFn9eK3byRWnHNfsVldaF62cOLua8u6VQKSJU5evq7hJ6+TaeiksjdP8ctjzdLVf3Zfi/nN
        vLfFWHfx8w9CURtM7k+4E7BI0oD1w0yp4gU7Dj2ds2sWW2vRj3XL+C//ZmBdWqTLtInJp/nx
        F/Mfn3czMr1cpzE5aM0xswxjjyVl+5rXrT7347/WxAsCZf57bi60Lfg5IV6Ms0c+9e8Tw+Ca
        MGnL0r1L1j+efXqH3lsTOcdw5V9fypcvy3Eqnbvsj9acgiuf84IubPtf6/xBdcEnXiWW4oxE
        Qy3mouJEAFYpyi7JAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e/4XV31ysIkg1f7FC3mrNrGaLH6bj+b
        xc0DO5ksVq4+ymTxrvUci8XR/2/ZLM6/PcxkMX/ZU3aLGxOeMlocmtzMZHH15QF2B26Pic3v
        2D12zrrL7nH5bKnHplWdbB6bl9R77L7ZwObxft9VNo++LasYPT5vkgvgjNKzKcovLUlVyMgv
        LrFVija0MNIztLTQMzKx1DM0No+1MjJV0rezSUnNySxLLdK3S9DL6PinVfCOt2Lh5DVsDYw/
        uboYOTkkBEwkZu9bzdbFyMUhJLCUUeJNSzc7REJC4vbCJkYIW1jiz7UuqKLnjBLXvl8BSnBw
        sAloSTR2gtWLCChKbPwIUs/FwSzwglHi5f3bLCAJYaANjYfXgBWxCKhKbOpezAZi8wpYSqxr
        esgGsUBeYual7+wQcUGJkzOfgPUyA8Wbt85mnsDINwtJahaS1AJGplWMIqmlxbnpucVGesWJ
        ucWleel6yfm5mxiB8bLt2M8tOxhXvvqod4iRiYPxEKMEB7OSCK/z0oIkId6UxMqq1KL8+KLS
        nNTiQ4ymQPdNZJYSTc4HRmxeSbyhmYGpoYmZpYGppZmxkjivZ0FHopBAemJJanZqakFqEUwf
        EwenVANTeumN2wc2PlvWH9YovSbI/i7f38INdr1JR6fK9B+U5o+d9+RC21X3y2LvfNif7jne
        ucM05U7SR8njMt9D+BhtUz7dPxv3tqH+uubjEpn+guWxysulPs982/j6zUnzuNK8Fs4nPIsW
        WXioxijPihP342xkv1PgfoCbuSDQx5+/sP25+ZZanuiFenL7o873zPkpq8vmmyIufV7pju38
        3w1ufGk3F3iLC8x6LHMv8+rjew9tD80PX/zE621gkIDloxvShf7egf5zQjSO9+wTfvG48pT1
        to+5Yr3fdfj+H+/LSugyuWd7IOyu7uvqcNVInmmeJxeVZBmJ1rXNaZJTqXV/W71OSGbCL7P8
        s/6PNiuxFGckGmoxFxUnAgCR3K9IIAMAAA==
X-CMS-MailID: 20220503184911eucas1p1beb172219537d78fcaf2a1417f532cf7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20220503184911eucas1p1beb172219537d78fcaf2a1417f532cf7
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220503184911eucas1p1beb172219537d78fcaf2a1417f532cf7
References: <CGME20220503184911eucas1p1beb172219537d78fcaf2a1417f532cf7@eucas1p1.samsung.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Kanchan Joshi <joshi.k@samsung.com>

NOTE: Sending on behalf of Kanchan as he is having some trouble sending
emails.

This iteration is against io_uring-big-sqe brach (linux-block).
On top of a739b2354 ("io_uring: enable CQE32").

fio testing branch:
https://github.com/joshkan/fio/tree/big-cqe-pt.v3

Changes since v2:
- Rewire uring-cmd infrastructure on top of new big CQE
- Prep patch (refactored) and feedback from Christoph
- Add new opcode and structure in nvme for uring-cmd
- Enable vectored-io

Changes since v1:
https://lore.kernel.org/linux-nvme/20220401110310.611869-1-joshi.k@samsung.com/
- Trim down by removing patches for polling, fixed-buffer and bio-cache
- Add big CQE and move uring-cmd to use that
- Remove indirect (pointer) submission

v1:
https://lore.kernel.org/linux-nvme/20220308152105.309618-1-joshi.k@samsung.com/

Anuj Gupta (1):
  nvme: add vectored-io support for uring-cmd

Christoph Hellwig (1):
  nvme: refactor nvme_submit_user_cmd()

Jens Axboe (2):
  fs,io_uring: add infrastructure for uring-cmd
  block: wire-up support for passthrough plugging

Kanchan Joshi (1):
  nvme: wire-up uring-cmd support for io-passthru on char-device.

 block/blk-mq.c                  |  90 +++++++-------
 drivers/nvme/host/core.c        |   1 +
 drivers/nvme/host/ioctl.c       | 212 +++++++++++++++++++++++++++++++-
 drivers/nvme/host/multipath.c   |   1 +
 drivers/nvme/host/nvme.h        |   3 +
 fs/io_uring.c                   |  81 ++++++++++--
 include/linux/fs.h              |   2 +
 include/linux/io_uring.h        |  29 +++++
 include/uapi/linux/io_uring.h   |   8 +-
 include/uapi/linux/nvme_ioctl.h |  29 +++++
 10 files changed, 399 insertions(+), 57 deletions(-)

-- 
2.25.1

