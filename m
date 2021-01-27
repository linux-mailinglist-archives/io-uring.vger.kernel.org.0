Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66DAB305F13
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 16:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235591AbhA0PFk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 10:05:40 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:47646 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235381AbhA0PCV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jan 2021 10:02:21 -0500
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210127150136epoutp033cfa6d5daf33c12ce4bf335516e924a8~eHueD5el62214422144epoutp03e
        for <io-uring@vger.kernel.org>; Wed, 27 Jan 2021 15:01:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210127150136epoutp033cfa6d5daf33c12ce4bf335516e924a8~eHueD5el62214422144epoutp03e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611759696;
        bh=/y/wC+y+qAXvjcOOetUDXeKAPN6Gfevzpc0/eSbAaYk=;
        h=From:To:Cc:Subject:Date:References:From;
        b=Ej2CTDdmb4UwfaKiSQ7mmkEl6psEF0Ta4Guixvtmt4LiLfKmh5vWlAcDm223t6lkA
         VHD9GRngMuXbUX+ilmtvxxe7SeHiYRiE+TI6Wl8u+g9S+CCt7DCvq28PnT+UFFKpkQ
         FUNgoY1NyPrO1cF7WEheUWgvKqgp1gXP80IwoslY=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20210127150135epcas5p4e4d14fb8a4d32d2b8b20fe6d06583ff5~eHuc_L6aS1817018170epcas5p4q;
        Wed, 27 Jan 2021 15:01:35 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        76.A0.33964.E4081106; Thu, 28 Jan 2021 00:01:35 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20210127150134epcas5p251fc1de3ff3581dd4c68b3fbe0b9dd91~eHucR5GAU2309923099epcas5p2g;
        Wed, 27 Jan 2021 15:01:34 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210127150134epsmtrp29f12da6ad6b5258d68b481385c0eaded~eHucQ-enw0989109891epsmtrp2m;
        Wed, 27 Jan 2021 15:01:34 +0000 (GMT)
X-AuditID: b6c32a4b-ea1ff700000184ac-7d-6011804e2981
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CA.05.13470.E4081106; Thu, 28 Jan 2021 00:01:34 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210127150132epsmtip21a0aa87a0d2e31bc0b2c9e4ff286fdaf~eHuaSkOnQ2273022730epsmtip22;
        Wed, 27 Jan 2021 15:01:32 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me
Cc:     linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        javier.gonz@samsung.com, nj.shetty@samsung.com,
        selvakuma.s1@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [RFC PATCH 0/4] Asynchronous passthrough ioctl
Date:   Wed, 27 Jan 2021 20:30:25 +0530
Message-Id: <20210127150029.13766-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsWy7bCmpq5/g2CCwaMlTBa/p09htVh9t5/N
        YuXqo0wW71rPsVg8vvOZ3eLo/7dsFpMOXWO02LP3JIvF5V1z2CzmL3vKbrHt93xmiytTFjFb
        rHv9nsXi9Y+TbA58HufvbWTxuHy21GPTqk42j81L6j1232xg8+jbsorR4/MmuQD2KC6blNSc
        zLLUIn27BK6MKRsOMhdcEKs4PN2vgbFXqIuRk0NCwERix59ZLF2MXBxCArsZJba9usME4Xxi
        lLjftZAVwvnGKPHv1zs2mJZfvSugqvYySkxZ9hiq/zOjRG/3ceYuRg4ONgFNiQuTS0EaRARc
        JC78PsAOUsMs8I5R4vy9LYwgCWEBc4lXPx+C2SwCqhJTdm5jBbF5BSwk7m2awwKxTV5i5qXv
        7BBxQYmTM5+AxZmB4s1bZzODDJUQ6OSQeP8YokgCaNvzqS9ZIWxhiVfHt0DFpSQ+v9sL9UKx
        xK87R6GaOxglrjfMhNpmL3Fxz18mkA+YgT5Yv0sfYhmfRO/vJ2BhCQFeiY42aOApStyb9BRq
        lbjEwxlLoGwPiW+3doGtEhKIlZhzdSr7BEa5WUhemIXkhVkIyxYwMq9ilEwtKM5NTy02LTDO
        Sy3XK07MLS7NS9dLzs/dxAhOS1reOxgfPfigd4iRiYPxEKMEB7OSCK+dgmCCEG9KYmVValF+
        fFFpTmrxIUZpDhYlcd4dBg/ihQTSE0tSs1NTC1KLYLJMHJxSDUzrmGKjvY1VXvvqTdCc3bMw
        53pn9crYCzsmybtM0ft+wuxf6G+LFIF5Se7fP+s9qhF4w7bUuW7GJSF+4Zk6+p6nn9UmXkua
        VNAwb/Iu7zWTjmYwHf+mt3lLwRRWk6sHb0SU+fxQc/RInuY98RbXs63nj0y1Z93JGfFzW//U
        ZiXHH9m3ov4J/d5qe7XrLoP4wUy+ZHb+kICg+vI7jxTlI5QqkgPVBLQNVHkuPdvjdcm8rkQh
        Rn9aWnNaYeehxYFP1jrG1bGp5tSsauVQdjhttYhtj1FYmpvbq98BUwstdzrnqnl4Zx7QLNPd
        l3pPTG1BxcPSeqGTH6fd2WjOWD41fsKzxPY1EsESZ76VvtWXVmIpzkg01GIuKk4EAKIkCGy6
        AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsWy7bCSvK5fg2CCwaJ7Aha/p09htVh9t5/N
        YuXqo0wW71rPsVg8vvOZ3eLo/7dsFpMOXWO02LP3JIvF5V1z2CzmL3vKbrHt93xmiytTFjFb
        rHv9nsXi9Y+TbA58HufvbWTxuHy21GPTqk42j81L6j1232xg8+jbsorR4/MmuQD2KC6blNSc
        zLLUIn27BK6MKRsOMhdcEKs4PN2vgbFXqIuRk0NCwETiV+8KJhBbSGA3o8Ttq5YQcXGJ5ms/
        2CFsYYmV/54D2VxANR8ZJWa+/Q/UwMHBJqApcWFyKYgpIuAlsW2pIUgJs8A3Rok1a0+xgvQK
        C5hLvPr5kBHEZhFQlZiycxtYnFfAQuLepjksEPPlJWZe+s4OEReUODnzCVicGSjevHU28wRG
        vllIUrOQpBYwMq1ilEwtKM5Nzy02LDDMSy3XK07MLS7NS9dLzs/dxAgOey3NHYzbV33QO8TI
        xMF4iFGCg1lJhNdOQTBBiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2ampBalF
        MFkmDk6pBiZmPX3T50d+53ma8ggwR15vn8A+OUjkjtVrGUejXUFxB0PzpjC5SMmmX7s7XeqG
        hfX3T1Jy5YcVK2/1rnss0eK8LaRCnkVl59ff6V7ZmVsf3q52vM64w1Wyz/5imNjRfR9WzVaV
        WWbPf2RbuvLlQ8ahjQL+b1bp6qtdyUsRj4jldlbt7mSa2/Vy+8yGoHNRvnNb139f48Oj3PCt
        livsf8MPdofKNAEDlj/Fiz7YrCquiF50o7NfUXnK7TAVF46iX3MKZXLXiV32PLmw/Kmi8a7v
        jcfZRWXWvmTQrxZ5eWH5M85XBv+0b95Jswj6rMwyVzZ8/6VlkdNXqVzttpu9QWn/42uqukJS
        1uWsx+8yKLEUZyQaajEXFScCAOnBizvqAgAA
X-CMS-MailID: 20210127150134epcas5p251fc1de3ff3581dd4c68b3fbe0b9dd91
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20210127150134epcas5p251fc1de3ff3581dd4c68b3fbe0b9dd91
References: <CGME20210127150134epcas5p251fc1de3ff3581dd4c68b3fbe0b9dd91@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This RFC patchset adds asynchronous ioctl capability for NVMe devices.
Purpose of RFC is to get the feedback and optimize the path.

At the uppermost io-uring layer, a new opcode IORING_OP_IOCTL_PT is
presented to user-space applications. Like regular-ioctl, it takes
ioctl opcode and an optional argument (ioctl-specific input/output
parameter). Unlike regular-ioctl, it is made to skip the block-layer
and reach directly to the underlying driver (nvme in the case of this
patchset). This path between io-uring and nvme is via a newly
introduced block-device operation "async_ioctl". This operation
expects io-uring to supply a callback function which can be used to
report completion at later stage.

For a regular ioctl, NVMe driver submits the command to the device and
the submitter (task) is made to wait until completion arrives. For
async-ioctl, completion is decoupled from submission. Submitter goes
back to its business without waiting for nvme-completion. When
nvme-completion arrives, it informs io-uring via the registered
completion-handler. But some ioctls may require updating certain
ioctl-specific fields which can be accessed only in context of the
submitter task. For that reason, NVMe driver uses task-work infra for
that ioctl-specific update. Since task-work is not exported, it cannot
be referenced when nvme is compiled as a module. Therefore, one of the
patch exports task-work API.

Here goes example of usage (pseudo-code).
Actual nvme-cli source, modified to issue all ioctls via this opcode
is present at-
https://github.com/joshkan/nvme-cli/commit/a008a733f24ab5593e7874cfbc69ee04e88068c5

With regular ioctl-
int nvme_submit_passthru(int fd, unsigned long ioctl_cmd,
                         struct nvme_passthru_cmd *cmd)
{
	return ioctl(fd, ioctl_cmd, cmd);
}

With uring passthru ioctl-
int nvme_submit_passthru(int fd, unsigned long ioctl_cmd,
                         struct nvme_passthru_cmd *cmd)
{
	return uring_ioctl(fd, ioctl_cmd, cmd);
}
int uring_ioctl(int fd, unsinged long cmd, u64 arg)
{
	sqe = io_uring_get_sqe(ring);

	/* prepare sqe */
	sqe->fd = fd;
	sqe->opcode = IORING_OP_IOCTL_PT;
	sqe->ioctl_cmd = cmd;
	sqe->ioctl_arg = arg;

	/* submit sqe */
	io_uring_submit(ring);

	/* reap completion and obtain result */
	io_uring_wait_cqe(ring, &cqe);
	printf("ioctl result =%d\n", cqe->res)
}

Kanchan Joshi (4):
  block: introduce async ioctl operation
  kernel: export task_work_add
  nvme: add async ioctl support
  io_uring: add async passthrough ioctl support

 drivers/nvme/host/core.c      | 347 +++++++++++++++++++++++++++-------
 fs/io_uring.c                 |  77 ++++++++
 include/linux/blkdev.h        |  12 ++
 include/uapi/linux/io_uring.h |   7 +-
 kernel/task_work.c            |   2 +-
 5 files changed, 376 insertions(+), 69 deletions(-)

-- 
2.25.1

