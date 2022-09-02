Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E485AB579
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 17:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237279AbiIBPlI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 11:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237148AbiIBPki (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 11:40:38 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F269B4198B
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 08:27:15 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220902152705epoutp02af01a2a3e68bfb690be0d10315febb3f~RFKJpL4-71991819918epoutp02r
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 15:27:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220902152705epoutp02af01a2a3e68bfb690be0d10315febb3f~RFKJpL4-71991819918epoutp02r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662132425;
        bh=KbluhO1edFwLkVxT5mMJM4Fz5H4uRnTUISzGxIYAGu4=;
        h=From:To:Cc:Subject:Date:References:From;
        b=EWGGcnVVFPqwnC2x20PpuqHWnO3+fAUs1YuCQ8t+foaQtHA9iW2ZxuWlu7tjkabRy
         KFadz8vW1rB9Mr7dx2yr25LsOxTOh4c9m4+wjdP6XAkhjCXV1LoUR7IhswSnm3Xca7
         5GF5MOMw3DUWYRbKRXPHgBiEU5SIR/mprql4UD1g=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220902152704epcas5p480164d19695cdb4b61615647c7e9e542~RFKIxJmGB1345413454epcas5p4N;
        Fri,  2 Sep 2022 15:27:04 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4MK1x171w4z4x9Pr; Fri,  2 Sep
        2022 15:27:01 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        75.30.53458.5C022136; Sat,  3 Sep 2022 00:27:01 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220902152701epcas5p1d4aca8eebc90fb96ac7ed5a8270816cf~RFKGHShBc2163521635epcas5p1X;
        Fri,  2 Sep 2022 15:27:01 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220902152701epsmtrp1c55eea15537ee18ce95745447b46fd4b~RFKGGLkxW2718227182epsmtrp1S;
        Fri,  2 Sep 2022 15:27:01 +0000 (GMT)
X-AuditID: b6c32a4a-a5bff7000000d0d2-19-631220c5aed8
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        20.2C.14392.5C022136; Sat,  3 Sep 2022 00:27:01 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220902152700epsmtip2be7b74f69c8476632caad5661afd2cd0~RFKExW0xs1295812958epsmtip22;
        Fri,  2 Sep 2022 15:26:59 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v3 0/4] fixed-buffer for uring-cmd/passthrough
Date:   Fri,  2 Sep 2022 20:46:53 +0530
Message-Id: <20220902151657.10766-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnk+LIzCtJLcpLzFFi42LZdlhTU/eoglCywaIX5hZzVm1jtFh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsDpweO2fdZfe4fLbUY9OqTjaP
        zUvqPXbfbGDz6NuyitHj8ya5APaobJuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtz
        JYW8xNxUWyUXnwBdt8wcoLuUFMoSc0qBQgGJxcVK+nY2RfmlJakKGfnFJbZKqQUpOQUmBXrF
        ibnFpXnpenmpJVaGBgZGpkCFCdkZ01a/YC04I1zRvOs4ewPjHIEuRk4OCQETiZ232xi7GLk4
        hAR2M0oc23aYDSQhJPCJUaLrmylE4hujxNKjf9lhOk53TWCFSOxllLjX/IkZwvnMKDGh9wiQ
        w8HBJqApcWFyKUiDiICXxP3b78EamAVmMEqs7ngNNklYwF3i4pUVLCA2i4CqRNO046wgNq+A
        hcS71wtYILbJS8y89J0dIi4ocXLmE7A4M1C8eetssMUSAm/ZJRbMWcEM0eAisXfJe1YIW1ji
        1fEtUGdLSbzsb4OykyUuzTzHBGGXSDzecxDKtpdoPdUP9gAz0APrd+lD7OKT6P39hAkkLCHA
        K9HRJgRRrShxb9JTqE3iEg9nLIGyPSSO9M9igYRirMTCTQ+ZJjDKzULywSwkH8xCWLaAkXkV
        o2RqQXFuemqxaYFRXmo5PC6T83M3MYJTpJbXDsaHDz7oHWJk4mA8xCjBwawkwjv1sECyEG9K
        YmVValF+fFFpTmrxIUZTYLBOZJYSTc4HJum8knhDE0sDEzMzMxNLYzNDJXHeKdqMyUIC6Ykl
        qdmpqQWpRTB9TBycUg1MEbyXebzjfl5bK3vzofihRzEBxiybJB8kXFXaE84unn/beGL18i7m
        Sazye/8xh2285yYoes9j0pYJ3+ufSwU/m302sotJ7fnK6T8+J3r1rnkusSbHcJLjSk71c1+c
        8mwDOTeHuhksTOvY8Obhrmt8J+cdWPfpxQKb/GeBJx2W6VVK68y0dTB79Sj42b4NEzd/+Wzq
        IPGR+c3pefeXnJudNCWKi/nIVyFd4f5H3bOecO3TFP2yctOb55vFLcR2FP/afG1GTf7D7VMl
        574I5T809/+EnwUvN23zypn0qeTt7eJlWzM0tKY6ql7eKJzwaZWC8LMPKcx9ckU6xid+XXql
        f6ZTZf7dA13h5ZeEby1OkxNXYinOSDTUYi4qTgQA7mr60hoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsWy7bCSvO5RBaFkg557ohZzVm1jtFh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsDpweO2fdZfe4fLbUY9OqTjaP
        zUvqPXbfbGDz6NuyitHj8ya5APYoLpuU1JzMstQifbsEroxpq1+wFpwRrmjedZy9gXGOQBcj
        J4eEgInE6a4JrF2MXBxCArsZJabNOswEkRCXaL72gx3CFpZY+e85O0TRR0aJBx2LGbsYOTjY
        BDQlLkwuBakREQiQONh4GayGWWAOo8Tly3vAmoUF3CUuXlnBAmKzCKhKNE07zgpi8wpYSLx7
        vYAFYoG8xMxL39kh4oISJ2c+AYszA8Wbt85mnsDINwtJahaS1AJGplWMkqkFxbnpucWGBYZ5
        qeV6xYm5xaV56XrJ+bmbGMGBrKW5g3H7qg96hxiZOBgPMUpwMCuJ8E49LJAsxJuSWFmVWpQf
        X1Sak1p8iFGag0VJnPdC18l4IYH0xJLU7NTUgtQimCwTB6dUA5NaTrnvDI5zR4Rcuz2KPfmd
        tYR3LWWWZLy3tW+DptvtPXl3G9ccaTH/5/ErdanclvXa97/K50pqze22SdeJW3zMxa+s8lRL
        cbaM9ETfcy8Of5k8RW+OkiHL31ul0rJbHs/WWnHkeLmaCt/FzyJVb1bvZ13blPDxmvzt5z/f
        LvuXmWs70Wt910RG5kghIW32+1bah90+LFw6SfqRz6pD287E77E132C385maVALj4uYLfmlK
        n+wOnl+4u3iqyduVnx0sZxf9mHvOqjDdYVNhX/bmyWZX1q79Lqht57P64/zmJvfbez5JClw8
        ukBnzeVtpQuenjl7RKjGYlKHa5KnZdLLBBfzuzLBt3JSjni/DfqqxFKckWioxVxUnAgAwmkt
        NtMCAAA=
X-CMS-MailID: 20220902152701epcas5p1d4aca8eebc90fb96ac7ed5a8270816cf
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220902152701epcas5p1d4aca8eebc90fb96ac7ed5a8270816cf
References: <CGME20220902152701epcas5p1d4aca8eebc90fb96ac7ed5a8270816cf@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Currently uring-cmd lacks the ability to leverage the pre-registered
buffers. This series adds the support in uring-cmd, and plumbs
nvme passthrough to work with it.

Using registered-buffers showed peak-perf hike from 1.85M to 2.17M IOPS
in my setup.

Without fixedbufs
*****************
# taskset -c 0 t/io_uring -b512 -d128 -c32 -s32 -p0 -F1 -B0 -O0 -n1 -u1 /dev/ng0n1
submitter=0, tid=5256, file=/dev/ng0n1, node=-1
polled=0, fixedbufs=0/0, register_files=1, buffered=1, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
IOPS=1.85M, BW=904MiB/s, IOS/call=32/31
IOPS=1.85M, BW=903MiB/s, IOS/call=32/32
IOPS=1.85M, BW=902MiB/s, IOS/call=32/32
^CExiting on signal
Maximum IOPS=1.85M

With fixedbufs
**************
# taskset -c 0 t/io_uring -b512 -d128 -c32 -s32 -p0 -F1 -B1 -O0 -n1 -u1 /dev/ng0n1
submitter=0, tid=5260, file=/dev/ng0n1, node=-1
polled=0, fixedbufs=1/0, register_files=1, buffered=1, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
IOPS=2.17M, BW=1059MiB/s, IOS/call=32/31
IOPS=2.17M, BW=1057MiB/s, IOS/call=32/32
IOPS=2.16M, BW=1055MiB/s, IOS/call=32/32
^CExiting on signal
Maximum IOPS=2.17M

Patch 1, 3 = prep/infrastructure
Patch 2 = expand io_uring command to use registered-buffers
Patch 4 = expand nvme passthrough to use registered-buffers

This series is prepared on top of:
for-next + iopoll-passthru series [1].
A unified branch is present here:
https://github.com/OpenMPDK/linux/commits/feat/pt_fixedbufs_v3

t/io_uring util with fixedbuf support is here:
https://github.com/joshkan/fio/tree/priv/fb-v3

Changes since v2:
- Kill the new opcode, add a flag instead (Pavel)
- Fix standalone build issue with patch 1 (Pavel)

Changes since v1:
- Fix a naming issue for an exported helper

[1] https://lore.kernel.org/io-uring/20220823161443.49436-1-joshi.k@samsung.com/ 



Anuj Gupta (2):
  io_uring: introduce io_uring_cmd_import_fixed
  io_uring: introduce fixed buffer support for io_uring_cmd

Kanchan Joshi (2):
  block: add helper to map bvec iterator for passthrough
  nvme: wire up fixed buffer support for nvme passthrough

 block/blk-map.c               | 71 +++++++++++++++++++++++++++++++++++
 drivers/nvme/host/ioctl.c     | 38 +++++++++++++------
 include/linux/blk-mq.h        |  1 +
 include/linux/io_uring.h      | 11 +++++-
 include/uapi/linux/io_uring.h |  9 +++++
 io_uring/uring_cmd.c          | 29 +++++++++++++-
 6 files changed, 145 insertions(+), 14 deletions(-)

-- 
2.25.1

