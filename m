Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129B022CADE
	for <lists+io-uring@lfdr.de>; Fri, 24 Jul 2020 18:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgGXQW5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jul 2020 12:22:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10995 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgGXQW5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jul 2020 12:22:57 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200724162255epoutp034a651e48450447e5be6c2190cf2ced9b~kvNFeQZF70333203332epoutp03F
        for <io-uring@vger.kernel.org>; Fri, 24 Jul 2020 16:22:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200724162255epoutp034a651e48450447e5be6c2190cf2ced9b~kvNFeQZF70333203332epoutp03F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595607775;
        bh=alboB0qIzBsat5Ky/WzI4KKfCDoIdRWX/zQdLs+zkJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IRjJfvJF1mIZ4Urp+hhfIh6mhG65/w0mWK7e6uNfXBPpswTaJiEgiWSKi3XvCRUs+
         liiogh979T9UawUYL3j42oAThoDqEM0JHGB9a2bd92R9iKlNWPOJUo/abVAal6LyoI
         j2wcKv0qwCUgo1+4b6FkZiZkYpkVBy/7uhPLWBik=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200724162254epcas5p1f4a3fb425b2c3ce8a1ea2996242cabc4~kvNERf2Yo0150101501epcas5p1f;
        Fri, 24 Jul 2020 16:22:54 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        91.CE.40333.DDA0B1F5; Sat, 25 Jul 2020 01:22:53 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200724155258epcas5p1a75b926950a18cd1e6c8e7a047e6c589~kuy8bKUF41547815478epcas5p1N;
        Fri, 24 Jul 2020 15:52:58 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200724155258epsmtrp2de962289c70336346aeef29d0e22e5c2~kuy8aPCoQ2867528675epsmtrp2N;
        Fri, 24 Jul 2020 15:52:58 +0000 (GMT)
X-AuditID: b6c32a4a-991ff70000019d8d-3b-5f1b0addedfd
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E6.02.08382.AD30B1F5; Sat, 25 Jul 2020 00:52:58 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200724155256epsmtip15f08201e859c8819fb0c534a503a7287~kuy5szSx40257802578epsmtip15;
        Fri, 24 Jul 2020 15:52:55 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, viro@zeniv.linux.org.uk, bcrl@kvack.org
Cc:     willy@infradead.org, hch@infradead.org, Damien.LeMoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: [PATCH v4 1/6] fs: introduce FMODE_ZONE_APPEND and IOCB_ZONE_APPEND
Date:   Fri, 24 Jul 2020 21:19:17 +0530
Message-Id: <1595605762-17010-2-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595605762-17010-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsWy7bCmhu5dLul4gzMnbCx+T5/CajFn1TZG
        i9V3+9ksuv5tYbFobf/GZHF6wiImi3et51gsHt/5zG5x9P9bNosp05oYLTZ/72Cz2HtL22LP
        3pMsFpd3zWGz2PZ7PrPFlSmLmC1e/zjJZnH+73FWi98/5rA5CHvsnHWX3WPzCi2Py2dLPTZ9
        msTu0bdlFaPH501yHu0Hupk8Nj15yxTAEcVlk5Kak1mWWqRvl8CVcbT3NGvBNLGKT61n2BsY
        lwh1MXJySAiYSCxfdZ2li5GLQ0hgN6PE+v5OVpCEkMAnRomv9/kgEt8YJR4t2sgM09H/fgUz
        RGIvo8Thj2eh2j8zSjzd9R4ow8HBJqApcWFyKYgpImAjsXOJCkgvs8ByZon1a3lBbGEBH4nH
        QJ+D2CwCqhLXfqwG6+QVcJbY90AHYpWcxM1znWBrOQVcJC5cvMsIsklCYAuHRNu8fWwQRS4S
        L38cZYSwhSVeHd/CDmFLSXx+txeqplji152jzBDNHYwS1xtmskAk7CUu7vnLBLKYGejk9bv0
        IcKyElNPrWOCuJlPovf3EyaIOK/EjnkwtqLEvUlPWSFscYmHM5ZA2R4S37+2s0GCZDqjxJLJ
        G5gmMMrNQlixgJFxFaNkakFxbnpqsWmBUV5quV5xYm5xaV66XnJ+7iZGcHrS8trB+PDBB71D
        jEwcjIcYJTiYlUR4V3yTihfiTUmsrEotyo8vKs1JLT7EKM3BoiTOq/TjTJyQQHpiSWp2ampB
        ahFMlomDU6qB6UDjyR2PD508xReTK/AmPyTjBdMF6R0rxKuELvwyTd5y5f70lHL9tP2Kma9D
        FA5Objw7X+hC7zJnecZVrz0M82s/OW5Zoq0S47Bv6oycY5N5tGZ2Tzv0ztdPemas6NIHxnv4
        lfSL3v6K8vvSmHJwzfot65M4248J6vbw+ZfYnEltafcL6rhStlUqyPZhU/LDScXKtdZ1tbxb
        GZczbGQRcHnepFa9IurkDr43jhM3T/mbc/Rc0XeTmbnLNVf/2lD7Pl/hmJ5ab+6SSY5vOmbv
        eyI1/7bg8a97qpR6v7bd19P/Uq8woetAdsuCs7Er3y3brH9S+rPJy4eMFyvmPpP78voN6+nH
        y5vedS9bnSZpdFKJpTgj0VCLuag4EQBqgvrTvgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsWy7bCSnO4tZul4g2t95ha/p09htZizahuj
        xeq7/WwWXf+2sFi0tn9jsjg9YRGTxbvWcywWj+98Zrc4+v8tm8WUaU2MFpu/d7BZ7L2lbbFn
        70kWi8u75rBZbPs9n9niypRFzBavf5xkszj/9zirxe8fc9gchD12zrrL7rF5hZbH5bOlHps+
        TWL36NuyitHj8yY5j/YD3Uwem568ZQrgiOKySUnNySxLLdK3S+DKONp7mrVgmljFp9Yz7A2M
        S4S6GDk5JARMJPrfr2AGsYUEdjNKfLiaCxEXl2i+9oMdwhaWWPnvOZDNBVTzkVFizaUdQA4H
        B5uApsSFyaUgNSICDhJdxx8zgdQwC2xnlvj+Zj4bSEJYwEfiMdCDIDaLgKrEtR+rmUF6eQWc
        JfY90IGYLydx81wn2A2cAi4SFy7eZQQpEQIqufijfAIj3wJGhlWMkqkFxbnpucWGBYZ5qeV6
        xYm5xaV56XrJ+bmbGMERoKW5g3H7qg96hxiZOBgPMUpwMCuJ8K74JhUvxJuSWFmVWpQfX1Sa
        k1p8iFGag0VJnPdG4cI4IYH0xJLU7NTUgtQimCwTB6dUAxPPYr17/urfnZ7MnDjp2V33i27v
        1dKZH6y2nHTAIfsMz9kVXq/essTdOj1Jcd0j3bUb0yQfrvjtVZb0eMPKz6teyhdpcGrr/Zit
        aj0vgOvp2cBO6zTfia/rsgUYFgbKr/dOmjXtMv8rmdqJ/c8Tf6TxRKac/hu8Izm4ahpH5Tzf
        44FXjJIenG6a4LFGgMPU/5Xu/ST7nj159ptcVocL2bkketl6eUc4Zl2c9mTGhZtWv0Xqcs3n
        aurp7/Ce8Hh6h6rxf49fPI3H/J3e395d/Eo4chPrySar69kXOBeEMX3ZkcAnb52csEDtZviO
        R2/OKE7coizwLv8sw1OuyQrdp+bK/Xv8xtq9cuHnjmVhc9YqsRRnJBpqMRcVJwIAIwT+6e8C
        AAA=
X-CMS-MailID: 20200724155258epcas5p1a75b926950a18cd1e6c8e7a047e6c589
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20200724155258epcas5p1a75b926950a18cd1e6c8e7a047e6c589
References: <1595605762-17010-1-git-send-email-joshi.k@samsung.com>
        <CGME20200724155258epcas5p1a75b926950a18cd1e6c8e7a047e6c589@epcas5p1.samsung.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Enable zone-append using existing O_APPEND and RWF_APPEND.
Zone-append is similar to appending writes, but requires written-location
to be returned, in order to be effective.
Returning completion-result requires bit of additional processing in
common path. Also, we guarantee that zone-append does not cause a short
write, which is not the case with regular appending-write.
Therefore make the feature opt-in by introducing new FMODE_ZONE_APPEND
mode (kernel-only) and IOCB_ZONE_APPEND flag.
When a file is opened, it can opt in for zone-append by setting
FMODE_ZONE_APPEND.
If file has opted in, and receives write that meets file-append
criteria (RWF_APPEND write or O_APPEND open), set IOCB_ZONE_APPEND in
kiocb->ki_flag, apart from existing IOCB_APPEND. IOCB_ZONE_APPEND is
meant to isolate the code that returns written-location with appending
write.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Selvakumar S <selvakuma.s1@samsung.com>
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

