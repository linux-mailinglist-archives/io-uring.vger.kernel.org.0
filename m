Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78A82214EA8
	for <lists+io-uring@lfdr.de>; Sun,  5 Jul 2020 20:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgGESwR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Jul 2020 14:52:17 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:31484 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728034AbgGESwQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Jul 2020 14:52:16 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200705185213epoutp047affbe5facb7d3f02db9a26f2546d330~e7-BqvnSC1096410964epoutp04X
        for <io-uring@vger.kernel.org>; Sun,  5 Jul 2020 18:52:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200705185213epoutp047affbe5facb7d3f02db9a26f2546d330~e7-BqvnSC1096410964epoutp04X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593975134;
        bh=EdQAf5+zw6N5J2+HOrsvrQfxx8kc7JZeLZVVK6M6PcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TCGvSGVyqOKSya2EEIuudSvnZj5fnJRrSwoTnr5kY4jH09H83B+QgsK0iBJcrOiAi
         PNhxyOeKwO5R1lWtfF/DzJ/mHJ+Wma5Gw/8kDUD84szYoe9LttBuX0NhA2tsU9hvNY
         Bag031VVnUjczQb3NDjpYsXQqftHbSBpkWOoBU44=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200705185212epcas5p3f7db3dbbf75a909dbc5d85f66b033014~e7-AqOR6C0482204822epcas5p3x;
        Sun,  5 Jul 2020 18:52:12 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4F.B7.09703.C51220F5; Mon,  6 Jul 2020 03:52:12 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200705185211epcas5p4059d05d2fcedb91829300a7a7d03fda3~e7_-ewc7F1418914189epcas5p45;
        Sun,  5 Jul 2020 18:52:11 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200705185211epsmtrp1bb12d193d2271b7451da13042d046c6d~e7_-dwRAV0303903039epsmtrp10;
        Sun,  5 Jul 2020 18:52:11 +0000 (GMT)
X-AuditID: b6c32a4a-4cbff700000025e7-37-5f02215c0cd3
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        D9.37.08303.B51220F5; Mon,  6 Jul 2020 03:52:11 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200705185209epsmtip2b4cf5e349418fb0b9c4ddd3670b42090~e7_9FQgN73204832048epsmtip2s;
        Sun,  5 Jul 2020 18:52:08 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, viro@zeniv.linux.org.uk, bcrl@kvack.org
Cc:     hch@infradead.org, Damien.LeMoal@wdc.com, asml.silence@gmail.com,
        linux-fsdevel@vger.kernel.org, mb@lightnvm.io,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Kanchan Joshi <joshi.k@samsung.com>,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: [PATCH v3 1/4] fs: introduce FMODE_ZONE_APPEND and IOCB_ZONE_APPEND
Date:   Mon,  6 Jul 2020 00:17:47 +0530
Message-Id: <1593974870-18919-2-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593974870-18919-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA0WSaUwTURSFfTPTdopWJ8XEJ+JCgRhqRBE0z7jgho5GAvpLCYpVxkKEgi11
        qxhAKaUNgkpksW5AFDGKFoJQBE21YkGoFmRLJaJFBXdwISAopVX/ffeec899uXkkzr/AciOj
        JQmMVCKKEbBdiIoHPsL54R5YxEJzmx8azslmIW1JBUDXX2SykXq0nECpaT8w1JBVgKFPqU0E
        em0d4CDj749slH02BaCaznnobo2JQM16LRsV33lIoIrhizhqyS7A0ftBExuZR+pYq/h0Vf4L
        Dl1WLKSbG+W0rv80h9Y8HwT0yfISQA/oZtFp9zUYrbN9xEK5YS7LI5mY6AOMdMHKXS5RhZ15
        WLze9VDbryxWEkih1IBLQioAGqsfse3Mp6oBHLwfqAYuY9wP4NtXD4CjGAAwrcDG+jvRbqti
        OQQ9gPW1mcQ/182Ox5gakCSb8oFPz8jtOJVaDquKvOwWnErDYavJMh7kSm2GQw3vMDsTlDds
        vNgI7Myj1sJ6UynbsWwW7GhKx+3MpdZBZXUDbg+CVCUJW5Lfju+CY4LmK+3wu8K+unKOg91g
        b6bSyTI4ZDU6Z1UAtiXlEQ4hED67OzKeg4+9uVS/wN7GqckwY9jmjOdBlZLvcHvArtM9zjtM
        g925RU6m4dO8IuC4Yg6Ayfo5WWBm/v/QSwCUgOlMvCxWzMgWxy+SMAd9ZaJYmVwi9t0TF6sD
        419IuKkSdL/84msAGAkMAJK4YCovYx6I4PMiRYePMNK4CKk8hpEZwAySEEzjCQaf7ORTYlEC
        s49h4hnpXxUjuW5J2IQo61ZBwI7Xu/fmnzD/NmtCw9sjUJB3yJDqRsqG4MIS63Flj7+78vsp
        YVd/y3ZtHM+2+abiztyUJ4VvSEn7lNrPu+oSR/Uhy47d05sKI2d/Dfomql2RLG+1eG7d4aMg
        uEe6z6SCOdbcCbzb6TfCHlvU33met/Z5Gm6dK6OL3d+sV3gH+vdi+aXGdG7mlX4ppV0iSgx+
        x7n0Y7Wib015R/S2+qCA9MCehGtcvw9bRkavNgu14Srq3HujbSLTlYt+WVozdOdPeeRsvFy2
        dO5u6QGL+INbd0+H//NJisTO6UeTFSEbztaUafb3NvmGfur76bNXcGKN3Fx5OCxG7K7y0hsE
        hCxK5CfEpTLRH4P2NpuxAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsWy7bCSvG60IlO8wamVSha/p09htZizahuj
        xeq7/WwWXf+2sFi0tn9jsjg9YRGTxbvWcywWj+98Zrc4+v8tm8WUaU2MFntvaVvs2XuSxeLy
        rjlsFiu2H2Gx2PZ7PrPFlSmLmC1e/zjJZnH+73FWByGPnbPusntsXqHlcflsqcemT5PYPbqv
        /mD06NuyitHj8yY5j/YD3Uwem568ZQrgjOKySUnNySxLLdK3S+DKWHxrJlPBLuGK638msDYw
        Ngl0MXJySAiYSNx4spO1i5GLQ0hgB6PE2ZMLmCES4hLN136wQ9jCEiv/PQezhQQ+Mkos+mDS
        xcjBwSagKXFhcilIWETAQaLr+GMmkDnMAlOZJeY2H2ADSQgL+Ej8Ov2CCcRmEVCVODv/LCOI
        zSvgLHHq5Ho2iPlyEjfPdYLt5RRwkWjbfZoZZL4QUM3US4oTGPkWMDKsYpRMLSjOTc8tNiww
        ykst1ytOzC0uzUvXS87P3cQIjgEtrR2Me1Z90DvEyMTBeIhRgoNZSYS3V5sxXog3JbGyKrUo
        P76oNCe1+BCjNAeLkjjv11kL44QE0hNLUrNTUwtSi2CyTBycUg1MJZOKTjFq/ymPNP230afs
        44L3k6K3bDyU8CV3rWrA3vmZK5dPeyD45JALV98m3sVaQVHNOx0X6Rk0P79SEfuyQ4PH/0wJ
        Q5zipqszFjhOTGWZWXu96e6dLTdv5dot/2gqsk0tUGWqTXihZfLnbYJLC9TMCzcKaDBW/e3l
        1pedyLhrJZ+PiJ+hvMH7o7/nss/3D5rS0nuQ6btzw5mCVkY/kWMt/1Xmfr183W7GidqE5TMz
        C9c1/tqyMuZEvX7kO5cU+RUSL/uv8c2cq+XYNefknsLVYX9kanh2PdPpUL0X5lpcsubk6swb
        XTlN3TuuxdTemrf/0RpP8ZzdqZauva8rhDUT11qd2My+z3KCuy+TEktxRqKhFnNRcSIAqAaK
        GPACAAA=
X-CMS-MailID: 20200705185211epcas5p4059d05d2fcedb91829300a7a7d03fda3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200705185211epcas5p4059d05d2fcedb91829300a7a7d03fda3
References: <1593974870-18919-1-git-send-email-joshi.k@samsung.com>
        <CGME20200705185211epcas5p4059d05d2fcedb91829300a7a7d03fda3@epcas5p4.samsung.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Enable zone-append using existing O_APPEND and RWF_APPEND infra.
Unlike file-append, zone-apppend requires bit of additional processing
in common path to send completion-result to upper layer. To skip that
for non-zoned block-devices/files, introduce FMODE_ZONE_APPEND and
IOCB_ZONE_APPEND.
When a file is opened, it can subscribe to zone-append by setting
FMODE_ZONE_APPEND. Add IOCB_ZONE_APPEND which is set in kiocb->ki_flags
if write meets existing file-append critera, and file has subscribed to
zone-append.

Signed-off-by: Selvakumar S <selvakuma.s1@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
---
 include/linux/fs.h | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6c4ab4d..ef13df4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -175,6 +175,9 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 /* File does not contribute to nr_files count */
 #define FMODE_NOACCOUNT		((__force fmode_t)0x20000000)
 
+/* File can support zone-append */
+#define FMODE_ZONE_APPEND	((__force fmode_t)0x40000000)
+
 /*
  * Flag for rw_copy_check_uvector and compat_rw_copy_check_uvector
  * that indicates that they should check the contents of the iovec are
@@ -315,6 +318,7 @@ enum rw_hint {
 #define IOCB_SYNC		(1 << 5)
 #define IOCB_WRITE		(1 << 6)
 #define IOCB_NOWAIT		(1 << 7)
+#define IOCB_ZONE_APPEND	(1 << 8)
 
 struct kiocb {
 	struct file		*ki_filp;
@@ -3427,8 +3431,11 @@ static inline bool vma_is_fsdax(struct vm_area_struct *vma)
 static inline int iocb_flags(struct file *file)
 {
 	int res = 0;
-	if (file->f_flags & O_APPEND)
+	if (file->f_flags & O_APPEND) {
 		res |= IOCB_APPEND;
+		if (file->f_mode & FMODE_ZONE_APPEND)
+			res |= IOCB_ZONE_APPEND;
+	}
 	if (file->f_flags & O_DIRECT)
 		res |= IOCB_DIRECT;
 	if ((file->f_flags & O_DSYNC) || IS_SYNC(file->f_mapping->host))
@@ -3454,8 +3461,11 @@ static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags)
 		ki->ki_flags |= IOCB_DSYNC;
 	if (flags & RWF_SYNC)
 		ki->ki_flags |= (IOCB_DSYNC | IOCB_SYNC);
-	if (flags & RWF_APPEND)
+	if (flags & RWF_APPEND) {
 		ki->ki_flags |= IOCB_APPEND;
+		if (ki->ki_filp->f_mode & FMODE_ZONE_APPEND)
+			ki->ki_flags |= IOCB_ZONE_APPEND;
+	}
 	return 0;
 }
 
-- 
2.7.4

