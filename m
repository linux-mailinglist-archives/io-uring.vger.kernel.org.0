Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11B13E157D
	for <lists+io-uring@lfdr.de>; Thu,  5 Aug 2021 15:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241696AbhHENQH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Aug 2021 09:16:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:10934 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241669AbhHENQF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Aug 2021 09:16:05 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210805131549epoutp015c085958ae2f2e7d07983bd379cb91fe~Ya2WzbZec2883228832epoutp013
        for <io-uring@vger.kernel.org>; Thu,  5 Aug 2021 13:15:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210805131549epoutp015c085958ae2f2e7d07983bd379cb91fe~Ya2WzbZec2883228832epoutp013
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1628169349;
        bh=j9P9vPvbT2iT8/YzUb/SidFn3bQRjCw4Zcljejai6Hc=;
        h=From:To:Cc:Subject:Date:References:From;
        b=V6xbvJDU4blRk0ZznvXgkRJ5sUA/q3WtP7sYnGb2+Fe0g0ZXAFyZ/AkgvgEqSrIKy
         KzK6fPCLw076m1wHcRUL0E+d5H8tBuYcKprr/LDryRJzBmD9b6ExV2qRFLymDOfn3F
         YJ9yndGZlqNB18nnstfdIhY+sKHecFMyMuGlm66w=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20210805131548epcas5p196c45b0b62bd53c24f16eeb1f9aecb6f~Ya2VkW-fC0733907339epcas5p1t;
        Thu,  5 Aug 2021 13:15:48 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4GgTcv5FFGz4x9Pt; Thu,  5 Aug
        2021 13:15:43 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D8.2F.09595.F74EB016; Thu,  5 Aug 2021 22:15:43 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20210805125910epcas5p1100e7093dd2b1ac5bbb751331e2ded23~Yan0Xtoux2708927089epcas5p1R;
        Thu,  5 Aug 2021 12:59:10 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210805125910epsmtrp2b3aa44aca8e3f287e2323166dfa8e8d8~Yan0W7uLe2066920669epsmtrp25;
        Thu,  5 Aug 2021 12:59:10 +0000 (GMT)
X-AuditID: b6c32a4a-ed5ff7000000257b-48-610be47f383a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        1C.84.32548.E90EB016; Thu,  5 Aug 2021 21:59:10 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210805125909epsmtip11fc1d584a8747f7bce882b0df86c0e57~Yany4NvjY1036010360epsmtip1e;
        Thu,  5 Aug 2021 12:59:09 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, javier.gonz@samsung.com, hare@suse.de,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [RFC PATCH 0/6] Fixed-buffers io_uring passthrough over nvme-char
Date:   Thu,  5 Aug 2021 18:25:33 +0530
Message-Id: <20210805125539.66958-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBJsWRmVeSWpSXmKPExsWy7bCmum79E+5EgycbVS2aJvxltlh9t5/N
        Ys+iSUwWK1cfZbJ413qOxeLxnc/sFkf/v2WzmHToGqPF/GVP2S2uTFnE7MDlcflsqcemVZ1s
        HpuX1HvsvtnA5tG3ZRWjx+bT1R6fN8kFsEdl22SkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
        6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHaekUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJ
        KTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM7YPo+nYIFYxbdexwbGHqEuRk4OCQETiZ6b3axd
        jFwcQgK7GSU+/PjMDOF8YpSYffIoE4TzmVFifuM5FpiW169WQ1XtYpRYtngzI1zVpaNfgYZx
        cLAJaEpcmFwK0iAiYCSx/9NJsB3MAosYJbbe/80MkhAW8JJY1HOXHcRmEVCVaP08hRGkl1fA
        QuLq9gKIZfISMy99ByvhFRCUODnzCdgRzEDx5q2zwY6QEPjILjHl5l9WiAYXiSOTPzFD2MIS
        r45vYYewpSQ+v9vLBmEXS/y6cxSquYNR4nrDTKjX7CUu7vnLBHIEM9AD63fpQ4RlJaaeWscE
        sZhPovf3EyaIOK/EjnkwtqLEvUlPoW4Ql3g4YwmU7SExqecCWI2QQKzE9BOXmCcwys9C8s8s
        JP/MQti8gJF5FaNkakFxbnpqsWmBUV5qOTxek/NzNzGCk6iW1w7Ghw8+6B1iZOJgPMQowcGs
        JMKbvJgrUYg3JbGyKrUoP76oNCe1+BCjKTCMJzJLiSbnA9N4Xkm8oYmlgYmZmZmJpbGZoZI4
        L3v81wQhgfTEktTs1NSC1CKYPiYOTqkGpmDlYDl5z1uaHVvznqf88/UskNRU2flak0//wJR/
        +rIvvXPX3p0lzPfR/ujyRIN3pQdUe0NjjTxP/ZiVtduf+dH7nxxFX2Z8cT9TIrKTRcVWrvS4
        jf8PtpzJLzPtvhyw1JvDnhSzMSNWLY/3U94kAcntpueqC/d6tTF9efpJ67Bs1q2EWKFCa9Wv
        i5/uWlM2Y1nyAsFHkhsvZuas3/6kdyX3H04O6aYtBtpLDpYY/V9y/7nIjieXQh/PWsoktynr
        qfS5V1Nd+I9/yM48Z/mRu2pb92WhSV4Rt7NEDwqHzb1gXJjC+6bnypvzN3d/6zXPEG7RfiS5
        4aHmrVx5r+1S3UV/fi0SSar6zeO94XtesRJLcUaioRZzUXEiANkckbQrBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsWy7bCSnO68B9yJBh8+aFg0TfjLbLH6bj+b
        xZ5Fk5gsVq4+ymTxrvUci8XjO5/ZLY7+f8tmMenQNUaL+cuesltcmbKI2YHL4/LZUo9NqzrZ
        PDYvqffYfbOBzaNvyypGj82nqz0+b5ILYI/isklJzcksSy3St0vgytg+j6dggVjFt17HBsYe
        oS5GTg4JAROJ169WM3cxcnEICexglNjzYxUbREJcovnaD3YIW1hi5b/n7BBFHxklTmxcA+Rw
        cLAJaEpcmFwKUiMiYCax9PAaFpAaZoEVjBK7+34zgiSEBbwkFvXcBRvEIqAq0fp5CiNIL6+A
        hcTV7QUQ8+UlZl76DlbCKyAocXLmExYQmxko3rx1NvMERr5ZSFKzkKQWMDKtYpRMLSjOTc8t
        Niwwykst1ytOzC0uzUvXS87P3cQIDmYtrR2Me1Z90DvEyMTBeIhRgoNZSYQ3eTFXohBvSmJl
        VWpRfnxRaU5q8SFGaQ4WJXHeC10n44UE0hNLUrNTUwtSi2CyTBycUg1MxSoLJuWe2Fc02ff3
        4qnzf2tPu1rdcGmK/HceVWOOLOvZvgER69ZFBnbazV5+c47T4t/6lzw6Cjak7ngwN/zZqayF
        SyZr37fp/KYwM+KrdgTTasu117idb8kpTTZaI1rXHvO2ObhCduW5byppj2+kRgsdmeL1J7K8
        cuZc3z1b5xTk+n2IktUIVk0yupXt83+VVpDtWcMty/tDU3bF9cR42fB8DssQ9z9x8Uzfn1Xe
        mwWDme8sj7epi2HZ/zJrb8ssk4YW5pcb5+aIGUx757VTzZsnh8Fj6bT+38+OSbz8dtynZYXJ
        Tunw8rRbGS4hxe35JiqujOq1nDZBWQZ2mxb/Cr3JmHPzn87Xx97fLmxSYinOSDTUYi4qTgQA
        4GGZctUCAAA=
X-CMS-MailID: 20210805125910epcas5p1100e7093dd2b1ac5bbb751331e2ded23
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210805125910epcas5p1100e7093dd2b1ac5bbb751331e2ded23
References: <CGME20210805125910epcas5p1100e7093dd2b1ac5bbb751331e2ded23@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

This series takes a dig at expanding io_uring passthrough to have
fixed-buffer support.
For the NVMe side plumbing, it uses the per-namespace char-device as
the backend.

The work is on top of  Jens' branch (which is 5.14-rc1 based):
https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-fops.v5

Testing is done by integrating user-space side with fio:
https://github.com/joshkan/fio/commit/a8f40d4f7013ccd38fc51275d8b00fb4ce2404f5

Patches can be grouped into two parts -
First part (patch 1 and 2) involves extending 'io_uring cmd' infra
(for ioctl updates in task-context), and wire up nvme-passthrough on
char-device (/dev/ngXnY).
The second part (patch 4, 5, 6) introduces fixed-buffer variant of
uring-cmd (IORING_OP_URING_CMD_FIXED), and new NVMe passthrough IOCTLs
that operate on pre-registered buffers.

The buffers are registered with io_uring in the usual fashion. And the
buffer index is passed in command-SQE.
This to be used along with two new fixed-buffer ioctl opcodes:
NVME_IOCTL_IO_CMD_FIXED or NVME_IOCTL_IO64_CMD_FIXED.
For existing passthrough ioctl, nvme-driver maps the buffers in I/O
path for each command.
For the new ioctl, driver supplies buffer-index to io_uring and gets
to reuse pre-mapped buffers.

If introducing new ioctls in nvme (for fixed-buffer) does not sound
great, another option would be to use 'user flags' in the passthrough
command.
I look forward to the thoughts of the community on this.

Jens,

Command-SQE didn't have the field for buf_index. I'm torn among few
options, but repurposed len for now. Please take a look.

I'd appreciate the feedback/comments.


Thanks,

Changes from v4:
https://lore.kernel.org/linux-nvme/20210325170540.59619-1-joshi.k@samsung.com/
1. Moved to v5 branch of Jens, adapted to task-work changes in io_uring
2. Removed support for block-passthrough (over nvme0n1) for now
3. Added support for char-passthrough (over ng0n1)
4. Added fixed-buffer passthrough in io_uring and nvme plumbing

Anuj Gupta (2):
  io_uring: mark iopoll not supported for uring-cmd
  io_uring: add support for uring_cmd with fixed-buffer

Kanchan Joshi (4):
  io_uring: add infra for uring_cmd completion in submitter-task.
  nvme: wire-up support for async-passthru on char-device.
  io_uring: add helper for fixed-buffer uring-cmd
  nvme: enable passthrough with fixed-buffer

 drivers/nvme/host/core.c        |   1 +
 drivers/nvme/host/ioctl.c       | 245 +++++++++++++++++++++++++++++---
 drivers/nvme/host/multipath.c   |   1 +
 drivers/nvme/host/nvme.h        |   5 +
 fs/io_uring.c                   |  69 ++++++++-
 include/linux/io_uring.h        |  15 ++
 include/uapi/linux/io_uring.h   |   6 +-
 include/uapi/linux/nvme_ioctl.h |   2 +
 8 files changed, 319 insertions(+), 25 deletions(-)

-- 
2.25.1

