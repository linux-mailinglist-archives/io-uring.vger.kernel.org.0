Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7293060A1
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 17:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235923AbhA0QJA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 11:09:00 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:49287 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235399AbhA0PCg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jan 2021 10:02:36 -0500
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210127150142epoutp043194e2ed07c9df00a3f4dd2dd6c887e3~eHuje3EwL2079320793epoutp04P
        for <io-uring@vger.kernel.org>; Wed, 27 Jan 2021 15:01:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210127150142epoutp043194e2ed07c9df00a3f4dd2dd6c887e3~eHuje3EwL2079320793epoutp04P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611759702;
        bh=GV3ACHLLXyiQg4BzUblRVcIeExfz/GyxJRRnouQFv4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ktm8h4jkbBhjzpvZ78rTvZHtuNS4SH4Vttl1nT417HJelDlB1YNXO3l/lUzcXKZi0
         dPJC3Q4mKPhad+8G/Kz65P0t3BKigSJcGgAV/6M9SEZXs0FUUH3eZP5R9zb11wwqFp
         d8L+Bd8ebuXWRi0QGSMAe6xtPCnkoQhyqUDj9BkM=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20210127150141epcas5p303b95d3003294829d0ed9257258ac418~eHuiqXRnB0898508985epcas5p3R;
        Wed, 27 Jan 2021 15:01:41 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6E.23.15682.55081106; Thu, 28 Jan 2021 00:01:41 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20210127150140epcas5p32832cc0c0db953db199eb9dd326f2d4c~eHuhmDGHu0202502025epcas5p38;
        Wed, 27 Jan 2021 15:01:40 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210127150140epsmtrp10851bb7716b9e70ca56d17cee799a874~eHuhlGxLa0033500335epsmtrp1g;
        Wed, 27 Jan 2021 15:01:40 +0000 (GMT)
X-AuditID: b6c32a49-8bfff70000013d42-c3-60118055eebc
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1C.05.13470.35081106; Thu, 28 Jan 2021 00:01:40 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210127150138epsmtip2911ba1cea583786e803f14fb2ba17c0f~eHufq2ViP2133921339epsmtip2_;
        Wed, 27 Jan 2021 15:01:37 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me
Cc:     linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        javier.gonz@samsung.com, nj.shetty@samsung.com,
        selvakuma.s1@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [RFC PATCH 1/4] block: introduce async ioctl operation
Date:   Wed, 27 Jan 2021 20:30:26 +0530
Message-Id: <20210127150029.13766-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210127150029.13766-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01SfVCLcRz32/Ps2bMx9zTSz7iNHe4KJZfzcyScOw+uK+fcyR31xHOJmtma
        8r6jusrMSyXlJUeh6UqzJi1vYzKO6MV0Z5VLdxSFOSJK27OO/z7f7+f7+X5+n+/9SExSzZeS
        icoUVq1kkhSECLc8CAycvU7nFzen9vFoNFCQx0fXXMcIVHbNzkO9Gc9x1PnGLUD2oU8EOml7
        BVDdbQeOmmrPEqj4cpcAWQaKMdScdxFDFT19OOrpdxBLxtINbVU43fRMS5uM2QR9o+QgbW3V
        EbTBbAS02ySLFmwQLdrCJiXuYtUhi+NEW1ur9HzV29FptwoqMR1oF+YAIQmpMGg1/uHnABEp
        oawA1t9/BLjiK4AfCsoxrvgOYHquHoxI3K/zBRxxG8BvFjuPK9wAPrt3eJghSYIKhC9ytR7B
        eGo5fDFwzyvAqF4AG9rM3k3jqAhoe5qLeTBOTYftP3R8DxZTCJ7vsPA4NzksbPwh8GAhtQA2
        W0y+GT/oKHyHezA2PHO4+oz3qZAqJeGTbrOAEy+HzowW36JxsLt+pC+FH45l+rAG/npj94mz
        AHTqCnGOiIAv6/7wPGmw4TSVtSGc2Vh4dOCdtw0pMczKlHDTU2HbyS4+hwPg29MlPkzDtv77
        vmvphw9UX0QcB/Ki/zIU/Zeh6J/bBYAZwURWpUlOYDXzVKFKNjVYwyRrtMqE4M07kk3A+7OC
        VtYAV8fnYBvgkcAGIIkpxosXT/GLk4i3MLv3sOodsWptEquxgUkkrggQ18zpiJVQCUwKu51l
        Vax6hOWRQqmOd0XEyCrvnOiPPGV31X0XSuRrTQ3mmajDuKJ5gb/rY0Vm2TYiypDu7zBmj3JO
        qMIHa1Z3Dxbf4P1eu/onZlVnGltCc+ILtWzf8WZ9i73vuiGtotg23aCS9fPJ6PQhs7RrLu18
        ZJqljAq56YqZnx9RidobD1RPXeYeU6pLKY+JNaTaW7NS6iMdcH1i0sySSzmdJ46iwYdlF8NF
        p6J2le7sfS8YOvdlXbRTEfPrvbTHuq9sz4yw1I3YhMkZg1ZG+nHV3ij8kIzedGTN0uyFk9Nc
        4aumhQjGxHfqGLneuki+Uh7pHJXXeumuJSAxfBlz9ZU7fn+Lv7FuomxWgjRMrlfgmq1MaBCm
        1jB/AROfUpjIAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsWy7bCSvG5Ig2CCwaypTBa/p09htVh9t5/N
        YuXqo0wW71rPsVg8vvOZ3eLo/7dsFpMOXWO02LP3JIvF5V1z2CzmL3vKbrHt93xmiytTFjFb
        rHv9nsXi9Y+TbA58HufvbWTxuHy21GPTqk42j81L6j1232xg8+jbsorR4/MmuQD2KC6blNSc
        zLLUIn27BK6Mmxt7WAseclfsnL6euYHxPmcXIyeHhICJxOcbU9m7GLk4hAR2M0o8+vKbBSIh
        LtF87Qc7hC0ssfLfc6iij4wSt5d1M3YxcnCwCWhKXJhcCmKKCHhJbFtqCFLCLPCNUWLN2lOs
        IL3CAvYSh05PZgaxWQRUJe5/bwCL8wpYSMx7sI0JYr68xMxL38F2cQpYSlzZtgmsRgio5v2E
        h2wQ9YISJ2c+AbuNGai+eets5gmMArOQpGYhSS1gZFrFKJlaUJybnltsWGCYl1quV5yYW1ya
        l66XnJ+7iREcK1qaOxi3r/qgd4iRiYPxEKMEB7OSCK+dgmCCEG9KYmVValF+fFFpTmrxIUZp
        DhYlcd4LXSfjhQTSE0tSs1NTC1KLYLJMHJxSDUxFCQm1MyKmRS60uN6z+xm/xrTm33/3hj59
        t8ZkVdsXh3KlbZusrPM6PcM7kjvXOW7cx5QjtWgZnyBLXnRr+vcd7AEH9Zl7F+/ifb1cTsn1
        LtNzoXtsNiFKHFt+LbgqrTTjyfV82zUdz+2aVNINu/qXlvfFyDcs/cP4NdY+SjzEYssCxzls
        j0Sk4mTkRGbPVJ9dcsY5YqLjg+or4aeZDBOfGt5oP3K690IZp52H5nJP/9asjAzhqycSLYMW
        Kjp55trn1ioXnX1612dVu6TP9NVrp74NStFsXb6AO+vkRN380EWNrh4hepK36j0lhbalZxk0
        9y3JUY07qFX/OeBq9dJ1EhavbUoPpB9SEQ5VYinOSDTUYi4qTgQAj1Uq1gQDAAA=
X-CMS-MailID: 20210127150140epcas5p32832cc0c0db953db199eb9dd326f2d4c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20210127150140epcas5p32832cc0c0db953db199eb9dd326f2d4c
References: <20210127150029.13766-1-joshi.k@samsung.com>
        <CGME20210127150140epcas5p32832cc0c0db953db199eb9dd326f2d4c@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a new block-dev operation for async-ioctl.
Driver managing the block-dev can choose to implement it.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/linux/blkdev.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f94ee3089e01..c9f6cc26d675 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1848,6 +1848,16 @@ static inline void blk_ksm_unregister(struct request_queue *q) { }
 
 #endif /* CONFIG_BLK_INLINE_ENCRYPTION */
 
+struct pt_ioctl_ctx {
+	/* submitter task context */
+	struct task_struct *task;
+	/* callback supplied by upper layer */
+	void (*pt_complete)(struct pt_ioctl_ctx *ptioc, long ret);
+	/* driver-allocated data */
+	void *ioc_data;
+	/* to schedule task-work */
+	struct callback_head pt_work;
+};
 
 struct block_device_operations {
 	blk_qc_t (*submit_bio) (struct bio *bio);
@@ -1856,6 +1866,8 @@ struct block_device_operations {
 	int (*rw_page)(struct block_device *, sector_t, struct page *, unsigned int);
 	int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
+	int (*async_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long,
+				struct pt_ioctl_ctx *);
 	unsigned int (*check_events) (struct gendisk *disk,
 				      unsigned int clearing);
 	void (*unlock_native_capacity) (struct gendisk *);
-- 
2.25.1

