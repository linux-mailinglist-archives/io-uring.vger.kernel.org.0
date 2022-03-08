Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B56004D1BFB
	for <lists+io-uring@lfdr.de>; Tue,  8 Mar 2022 16:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346265AbiCHPmz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 10:42:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347925AbiCHPmv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 10:42:51 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2B04ECEC
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 07:41:52 -0800 (PST)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220308154147epoutp010769ef74f0e6929552f411b0887aa1a4~aciKyuE5H0712807128epoutp01Q
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 15:41:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220308154147epoutp010769ef74f0e6929552f411b0887aa1a4~aciKyuE5H0712807128epoutp01Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1646754107;
        bh=KiMjxqPMgSwlzKAGgUnynmNFgGCy1QEaMYK50C0X4/U=;
        h=From:To:Cc:Subject:Date:References:From;
        b=p/vhv0Vpq+tV0fPBNkxEUduCstpHfrrDlqMDWnhFU9EIZoLhVsDH97JzyjYWFhMQg
         j3HGNK/0m8D4aqYMa0TPTnUGGVvxCt1p81bRku9VKpJmvIPVpDwNwi7TqUt7sPK2yR
         NkatcVf29Rf7rXSqFf45XF+qfMNohIW1tsVSRUBg=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220308154145epcas5p15b240ae9e4d66dd23faa52d072a8c467~aciJm2aQm2239922399epcas5p1c;
        Tue,  8 Mar 2022 15:41:45 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4KCfh64R8Yz4x9Pp; Tue,  8 Mar
        2022 15:41:42 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B1.AB.05590.63977226; Wed,  9 Mar 2022 00:41:42 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220308152651epcas5p1ebd2dc7fa01db43dd587c228a3695696~acVIb9tKl1632216322epcas5p1D;
        Tue,  8 Mar 2022 15:26:51 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220308152651epsmtrp2743c274fcdd1adcb07fb7fc3821c1cd9~acVIbDt__2706527065epsmtrp22;
        Tue,  8 Mar 2022 15:26:51 +0000 (GMT)
X-AuditID: b6c32a4b-723ff700000015d6-03-622779361985
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        62.96.03370.BB577226; Wed,  9 Mar 2022 00:26:51 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220308152649epsmtip19fca21c80039849f8245b1b624d581c8~acVGYcYir1072010720epsmtip1j;
        Tue,  8 Mar 2022 15:26:48 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, pankydev8@gmail.com, javier@javigon.com,
        mcgrof@kernel.org, a.manzanares@samsung.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com
Subject: [PATCH 00/17] io_uring passthru over nvme
Date:   Tue,  8 Mar 2022 20:50:48 +0530
Message-Id: <20220308152105.309618-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAJsWRmVeSWpSXmKPExsWy7bCmhq5ZpXqSweTrMhbTDytaNE34y2wx
        Z9U2RovVd/vZLFauPspk8a71HItF5+kLTBbn3x5msph06Bqjxd5b2hbzlz1lt1jSepzN4saE
        p4wWa24+ZbH4fGYeqwO/x7Orzxg9ds66y+7RvOAOi8fls6Uem1Z1snlsXlLvsftmA5vHtsUv
        WT36tqxi9Pi8SS6AKyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
        ycUnQNctMwfoByWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFpXrpe
        XmqJlaGBgZEpUGFCdsbMs7eZC3plK1bNWsXcwHhIrIuRk0NCwESif24jG4gtJLCbUWLdHL8u
        Ri4g+xOjxKb/ZxkhnM+MEr8u7WCD6Thw8DRUxy5GiU+HFeGK9qydydzFyMHBJqApcWFyKUiN
        iICXxP3b71lBapgFupgk3u67D9YsLGAk8X/mGjCbRUBVYuGLR6wgNq+ApcSuO93sEMvkJWZe
        +s4OEReUODnzCQuIzQwUb946mxlkqITASg6Jz+eWskA0uEh8XLOfCcIWlnh1fAvUICmJz+/2
        Qn1QLPHrzlGo5g5GiesNM6Ga7SUu7vnLBPIBM9AH63fpQ4RlJaaeWscEsZhPovf3E6j5vBI7
        5sHYihL3Jj1lhbDFJR7OWAJle0hs6uljhYRWrMSDlTuYJjDKz0Lyzywk/8xC2LyAkXkVo2Rq
        QXFuemqxaYFxXmo5PGKT83M3MYKTspb3DsZHDz7oHWJk4mA8xCjBwawkwnv/vEqSEG9KYmVV
        alF+fFFpTmrxIUZTYCBPZJYSTc4H5oW8knhDE0sDEzMzMxNLYzNDJXHeU+kbEoUE0hNLUrNT
        UwtSi2D6mDg4pRqYcua+S9xrfOs391nJA2JrrkQW8DfGvQwulXuY8OvoNld+Y021jwI67R59
        E3f9mio0++FbpmfWjzi8zyw98TCS59vctR0q995/ubpv77+QXe9S7QXWvz6xbcr2N4HxgiKu
        Vj7LGjv5dfbrflpV3ir7yjqB/ePtKYzzam2vSP+J1RPzz9p98d79BgePgglv1M50sh+tMFpw
        3Dxv4Xn+0+v2LpvJWBp8vUgg30eSr93wtritOMP/1NRI+31S9peT73R3B1WLZQps+n2/M2L7
        9sLVGvcj5a91vLwX/npWjKvqf3sxP3Oxk9+L84zKdyf1lxznvSHWd1f0eNF5O+tuuy++XK+F
        W5VS8z5GxL8+qu+mxFKckWioxVxUnAgAVt36IFMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsWy7bCSnO7uUvUkg3n72CymH1a0aJrwl9li
        zqptjBar7/azWaxcfZTJ4l3rORaLztMXmCzOvz3MZDHp0DVGi723tC3mL3vKbrGk9TibxY0J
        Txkt1tx8ymLx+cw8Vgd+j2dXnzF67Jx1l92jecEdFo/LZ0s9Nq3qZPPYvKTeY/fNBjaPbYtf
        snr0bVnF6PF5k1wAVxSXTUpqTmZZapG+XQJXxsyzt5kLemUrVs1axdzAeEisi5GTQ0LAROLA
        wdNsXYxcHEICOxglzr47wwiREJdovvaDHcIWllj57zk7RNFHRom2a81ARRwcbAKaEhcml4LU
        iAgESBxsvAxWwywwg0mip/kzC0hCWMBI4v/MNWwgNouAqsTCF49YQWxeAUuJXXe6oRbIS8y8
        9J0dIi4ocXLmE7BeZqB489bZzBMY+WYhSc1CklrAyLSKUTK1oDg3PbfYsMAoL7Vcrzgxt7g0
        L10vOT93EyM4QrS0djDuWfVB7xAjEwfjIUYJDmYlEd7751WShHhTEiurUovy44tKc1KLDzFK
        c7AoifNe6DoZLySQnliSmp2aWpBaBJNl4uCUamAKaJudmH/fvrKJJWTXb4HWXEmWLVwPdPpW
        adec23/VR2FtqZLvxerT+/lcV8wOEFhQa65mxR4bGXgj8YGp7qbbZRcbzk11lIvh/5Ri8nmP
        tZp85aGYTfMuykSndcWuFT/9oXHa0buvtyzU890RWbv2cd2coq7nRuXpe4LenHp5eckbr/ly
        p4PmnPp9sjEyq8dj53HRcy9uSLdFLxPN1jjg8Ubj2la/7pP/5pWdWrb/ZHN7n7OOvsQGOw+/
        wP1fQn5sKXvnZvz6S62OUIDHosWRX2tXapUW3Tqb0GK4lWNDyg+N5LJt2/9uirrgKub/6nWd
        Ssgtv8cMcZxn1Avin2yy+PQhh68/iFPKLoVxt4gSS3FGoqEWc1FxIgA5ZTy8/wIAAA==
X-CMS-MailID: 20220308152651epcas5p1ebd2dc7fa01db43dd587c228a3695696
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220308152651epcas5p1ebd2dc7fa01db43dd587c228a3695696
References: <CGME20220308152651epcas5p1ebd2dc7fa01db43dd587c228a3695696@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a streamlined series with new way of doing uring-cmd, and connects
nvme-passthrough (over char device /dev/ngX) to it.
uring-cmd enables using io_uring for any arbitrary command (ioctl,
fsctl etc.) exposed by the command provider (e.g. driver, fs etc.).

To store the command inline within the sqe, Jens added an option to setup
the ring with 128-byte SQEs.This gives 80 bytes of space (16 bytes at
the end of the first sqe + 64 bytes in the second sqe). With inline
command in sqe, the application avoids explicit allocation and, in the
kernel, we avoid doing copy_from_user. Command-opcode, length etc.
are stored in per-op fields of io_uring_sqe.

Non-inline submission (when command is a user-space pointer rather than
housed inside sqe) is also supported.

io_uring sends this command down by newly introduced ->async_cmd()
handler in file_operations. The handler does what is required to
submit, and indicates queued completion.The infra has been added to
process the completion when it arrives.

Overall the patches wire up the following capabilities for this path:
- async
- fixed-buffer
- plugging
- bio-cache
- sync and async polling.

This scales well. 512b randread perf (KIOPS) comparing
uring-passthru-over-char (/dev/ng0n1) to
uring-over-block(/dev/nvme0n1)

QD    uring    pt    uring-poll    pt-poll
8      538     589      831         902
64     967     1131     1351        1378
256    1043    1230     1376        1429

Testing/perf is done with this custom fio that turnes regular-io into
passthru-io on supplying "uring_cmd=1" option.
https://github.com/joshkan/fio/tree/big-sqe-pt.v1

Example command-line:
fio -iodepth=256 -rw=randread -ioengine=io_uring -bs=512 -numjobs=1
-runtime=60 -group_reporting -iodepth_batch_submit=64
-iodepth_batch_complete_min=1 -iodepth_batch_complete_max=64
-fixedbufs=1 -hipri=1 -sqthread_poll=0 -filename=/dev/ng0n1
-name=io_uring_256 -uring_cmd=1


Anuj Gupta (3):
  io_uring: prep for fixed-buffer enabled uring-cmd
  nvme: enable passthrough with fixed-buffer
  nvme: enable non-inline passthru commands

Jens Axboe (5):
  io_uring: add support for 128-byte SQEs
  fs: add file_operations->async_cmd()
  io_uring: add infra and support for IORING_OP_URING_CMD
  io_uring: plug for async bypass
  block: wire-up support for plugging

Kanchan Joshi (5):
  nvme: wire-up support for async-passthru on char-device.
  io_uring: add support for uring_cmd with fixed-buffer
  block: factor out helper for bio allocation from cache
  nvme: enable bio-cache for fixed-buffer passthru
  io_uring: add support for non-inline uring-cmd

Keith Busch (2):
  nvme: modify nvme_alloc_request to take an additional parameter
  nvme: allow user passthrough commands to poll

Pankaj Raghav (2):
  io_uring: add polling support for uring-cmd
  nvme: wire-up polling for uring-passthru

 block/bio.c                     |  43 ++--
 block/blk-map.c                 |  45 +++++
 block/blk-mq.c                  |  93 ++++-----
 drivers/nvme/host/core.c        |  21 +-
 drivers/nvme/host/ioctl.c       | 336 +++++++++++++++++++++++++++-----
 drivers/nvme/host/multipath.c   |   2 +
 drivers/nvme/host/nvme.h        |  11 +-
 drivers/nvme/host/pci.c         |   4 +-
 drivers/nvme/target/passthru.c  |   2 +-
 fs/io_uring.c                   | 188 ++++++++++++++++--
 include/linux/bio.h             |   1 +
 include/linux/blk-mq.h          |   4 +
 include/linux/fs.h              |   2 +
 include/linux/io_uring.h        |  43 ++++
 include/uapi/linux/io_uring.h   |  21 +-
 include/uapi/linux/nvme_ioctl.h |   4 +
 16 files changed, 689 insertions(+), 131 deletions(-)

-- 
2.25.1

