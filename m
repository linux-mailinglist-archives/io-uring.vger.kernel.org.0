Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B353D22CAE5
	for <lists+io-uring@lfdr.de>; Fri, 24 Jul 2020 18:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgGXQXP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jul 2020 12:23:15 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:11030 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbgGXQXP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jul 2020 12:23:15 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200724162312epoutp037219f48c991d596a65e4b2ee611a031d~kvNU_EPCs0314403144epoutp03M
        for <io-uring@vger.kernel.org>; Fri, 24 Jul 2020 16:23:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200724162312epoutp037219f48c991d596a65e4b2ee611a031d~kvNU_EPCs0314403144epoutp03M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595607792;
        bh=3/hObnOc9E+5ViVw9dw3TpFAV846dpgwS54UTPL/cw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iAYnurzXe1n9BOwoI5rbjOH3cfe1cT7XxpvXZh3qv11Sxidh9EcCHP6pklb2YTd6R
         s7RkhlApfPIzvKMBwKDrdh4OW6lOgHZskxnKbGQHBBKXRkREvb59R8f/EzUnMSeseT
         wULsLmPxkqZzRwgEpPlW2X/7MSPSBgiIlTOxuHhw=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200724162310epcas5p2955a85236339220eef80c3dd7d31b83c~kvNTxP-Af2787827878epcas5p2i;
        Fri, 24 Jul 2020 16:23:10 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E3.58.09467.EEA0B1F5; Sat, 25 Jul 2020 01:23:10 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200724155324epcas5p18e1d3b4402d1e4a8eca87d0b56a3fa9b~kuzT5b_jF1547815478epcas5p1e;
        Fri, 24 Jul 2020 15:53:24 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200724155324epsmtrp2ac97110668ca8b26f68e5a7762bebd01~kuzT4mIS52867528675epsmtrp2Q;
        Fri, 24 Jul 2020 15:53:24 +0000 (GMT)
X-AuditID: b6c32a49-a3fff700000024fb-11-5f1b0aee4672
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        68.02.08382.3F30B1F5; Sat, 25 Jul 2020 00:53:24 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200724155321epsmtip1282f16a93147d538ce36f0d2cea0002d~kuzROb9DX0159201592epsmtip1a;
        Fri, 24 Jul 2020 15:53:21 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, viro@zeniv.linux.org.uk, bcrl@kvack.org
Cc:     willy@infradead.org, hch@infradead.org, Damien.LeMoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, SelvaKumar S <selvakuma.s1@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: [PATCH v4 2/6] fs: change ki_complete interface to support 64bit
 ret2
Date:   Fri, 24 Jul 2020 21:19:18 +0530
Message-Id: <1595605762-17010-3-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595605762-17010-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsWy7bCmuu47Lul4g08f1C1+T5/CajFn1TZG
        i9V3+9ksuv5tYbFobf/GZHF6wiImi3et51gsHt/5zG5x9P9bNosp05oYLTZ/72Cz2HtL22LP
        3pMsFpd3zWGz2PZ7PrPFlSmLmC1e/zjJZnH+73FWi98/5rA5CHvsnHWX3WPzCi2Py2dLPTZ9
        msTu0bdlFaPH501yHu0Hupk8Nj15yxTAEcVlk5Kak1mWWqRvl8CVsanxI3PBapWKS8emsDUw
        dst1MXJwSAiYSPyfrtDFyMUhJLCbUeLtwhnMEM4nRolba69COd8YJdav72HsYuQE62g//oMF
        xBYS2MsosfmVFETRZ0aJm20nmEHGsgloSlyYXApiigjYSOxcogJSwiywnFliQscPVpBeYYEA
        idMrXoDZLAKqEi96DoPN5xVwlpj1cSYbxC45iZvnOplBbE4BF4kLF+8yggySENjBITF/21eo
        IheJPY9eMEPYwhKvjm9hh7ClJD6/2wtVUyzx685RZojmDkaJ6w0zWSAS9hIX9/xlArmUGejo
        9bv0IcKyElNPrWMCsZkF+CR6fz9hgojzSuyYB2MrStyb9JQVwhaXeDhjCZTtITH/zR0WSKBM
        Z5Q4v+UT2wRGuVkIKxYwMq5ilEwtKM5NTy02LTDMSy3XK07MLS7NS9dLzs/dxAhOUFqeOxjv
        Pvigd4iRiYPxEKMEB7OSCO+Kb1LxQrwpiZVVqUX58UWlOanFhxilOViUxHmVfpyJExJITyxJ
        zU5NLUgtgskycXBKNTBtytpZ1nb43c97XxZxWR/KKti6WvGT7Ls/C3OUfuepH5yy1TM2r+7E
        WuZAaWbOg443355sT3z759HSkup3zI1SRWr2ycJenToyClz2jNweBaZZtaoBskc5A+9z9jV/
        ecd65d5ZK6tbBi02Cpk+Wm9284hMMK7MkHV1sS7bFdpVy2e0UpTFafOkv/8cXK742Pa7JDh/
        5K4psOd5xdj0attBBaXg5+0q/KwH625NWCH66m9BScmamJcHTfR5znbWMSqeuLbsqtbdvBa/
        G3/4NHrMX9i7fbLnTjcTO15boV444ea65piArrNal7NOOOrYJBz7Ehb1SnVVhUNfX1TuhKUf
        F99tiFvRmz4hPXuvEktxRqKhFnNRcSIAI19b8r8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsWy7bCSnO4XZul4g9nNjBa/p09htZizahuj
        xeq7/WwWXf+2sFi0tn9jsjg9YRGTxbvWcywWj+98Zrc4+v8tm8WUaU2MFpu/d7BZ7L2lbbFn
        70kWi8u75rBZbPs9n9niypRFzBavf5xkszj/9zirxe8fc9gchD12zrrL7rF5hZbH5bOlHps+
        TWL36NuyitHj8yY5j/YD3Uwem568ZQrgiOKySUnNySxLLdK3S+DK2NT4kblgtUrFpWNT2BoY
        u+W6GDk5JARMJNqP/2ABsYUEdjNKvJsYBxEXl2i+9oMdwhaWWPnvOZDNBVTzkVHi/+JnrF2M
        HBxsApoSFyaXgtSICDhIdB1/zARSwyywnVli5tG5rCAJYQE/ifPPloMtYBFQlXjRc5gRxOYV
        cJaY9XEmG8QCOYmb5zqZQWxOAReJCxfvMoLMFwKqufijfAIj3wJGhlWMkqkFxbnpucWGBYZ5
        qeV6xYm5xaV56XrJ+bmbGMExoKW5g3H7qg96hxiZOBgPMUpwMCuJ8K74JhUvxJuSWFmVWpQf
        X1Sak1p8iFGag0VJnPdG4cI4IYH0xJLU7NTUgtQimCwTB6dUA1P9If6nn4Je2l+7scwr2/Zn
        w9fDtl/+Lvvgq7hgWfCTJNlv3LfkxI+pLquc310qKLTjklChWdqhT7nbOs5yarKIrpj2s96t
        wXC/94yA4pvp2QliOX8sXtn5uL1Ytkbxxu+y4D/bXK7FrwxcKxHtLuFx4P5jjbI/WzNObTrL
        IBXILLL4ZbdH46HDepN8ap8djxOY8NruO5P4/R0H7nYutf7g8fvY8d5nPD0nqieWvKhP+Gp+
        5MnCq381qy+oRsnriaaezqo8VVRlMGvS27T1U+xkIrr3qXFqHT6XrhydmHFpd7vm8vSJFSL3
        C345C8lrZZ9g2y+mn/rmOP/BLPlTfgnOT6JaS7TubVu69M/6uRuVWIozEg21mIuKEwFpBBFV
        8AIAAA==
X-CMS-MailID: 20200724155324epcas5p18e1d3b4402d1e4a8eca87d0b56a3fa9b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20200724155324epcas5p18e1d3b4402d1e4a8eca87d0b56a3fa9b
References: <1595605762-17010-1-git-send-email-joshi.k@samsung.com>
        <CGME20200724155324epcas5p18e1d3b4402d1e4a8eca87d0b56a3fa9b@epcas5p1.samsung.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: SelvaKumar S <selvakuma.s1@samsung.com>

kiocb->ki_complete(...,long ret2) - change ret2 to long long.
This becomes handy to return 64bit written-offset with appending write.
Change callers using ki_complete prototype.

Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
---
 drivers/block/loop.c              | 2 +-
 drivers/nvme/target/io-cmd-file.c | 2 +-
 drivers/target/target_core_file.c | 2 +-
 fs/aio.c                          | 2 +-
 fs/io_uring.c                     | 4 ++--
 fs/overlayfs/file.c               | 2 +-
 include/linux/fs.h                | 2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index c33bbbf..d41dcbd 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -512,7 +512,7 @@ static void lo_rw_aio_do_completion(struct loop_cmd *cmd)
 	blk_mq_complete_request(rq);
 }
 
-static void lo_rw_aio_complete(struct kiocb *iocb, long ret, long ret2)
+static void lo_rw_aio_complete(struct kiocb *iocb, long ret, long long ret2)
 {
 	struct loop_cmd *cmd = container_of(iocb, struct loop_cmd, iocb);
 
diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index 0abbefd..ae6e797 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -123,7 +123,7 @@ static ssize_t nvmet_file_submit_bvec(struct nvmet_req *req, loff_t pos,
 	return call_iter(iocb, &iter);
 }
 
-static void nvmet_file_io_done(struct kiocb *iocb, long ret, long ret2)
+static void nvmet_file_io_done(struct kiocb *iocb, long ret, long long ret2)
 {
 	struct nvmet_req *req = container_of(iocb, struct nvmet_req, f.iocb);
 	u16 status = NVME_SC_SUCCESS;
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 7143d03..387756f2 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -243,7 +243,7 @@ struct target_core_file_cmd {
 	struct kiocb	iocb;
 };
 
-static void cmd_rw_aio_complete(struct kiocb *iocb, long ret, long ret2)
+static void cmd_rw_aio_complete(struct kiocb *iocb, long ret, long long ret2)
 {
 	struct target_core_file_cmd *cmd;
 
diff --git a/fs/aio.c b/fs/aio.c
index 7ecddc2..7218c8b 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1418,7 +1418,7 @@ static void aio_remove_iocb(struct aio_kiocb *iocb)
 	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
 }
 
-static void aio_complete_rw(struct kiocb *kiocb, long res, long res2)
+static void aio_complete_rw(struct kiocb *kiocb, long res, long long res2)
 {
 	struct aio_kiocb *iocb = container_of(kiocb, struct aio_kiocb, rw);
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 155f3d8..7809ab2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1958,7 +1958,7 @@ static void io_complete_rw_common(struct kiocb *kiocb, long res)
 	__io_cqring_add_event(req, res, cflags);
 }
 
-static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
+static void io_complete_rw(struct kiocb *kiocb, long res, long long res2)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 
@@ -1966,7 +1966,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
 	io_put_req(req);
 }
 
-static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
+static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long long res2)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 01820e6..614b834 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -268,7 +268,7 @@ static void ovl_aio_cleanup_handler(struct ovl_aio_req *aio_req)
 	kmem_cache_free(ovl_aio_request_cachep, aio_req);
 }
 
-static void ovl_aio_rw_complete(struct kiocb *iocb, long res, long res2)
+static void ovl_aio_rw_complete(struct kiocb *iocb, long res, long long res2)
 {
 	struct ovl_aio_req *aio_req = container_of(iocb,
 						   struct ovl_aio_req, iocb);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ef13df4..a6a5f41 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -327,7 +327,7 @@ struct kiocb {
 	randomized_struct_fields_start
 
 	loff_t			ki_pos;
-	void (*ki_complete)(struct kiocb *iocb, long ret, long ret2);
+	void (*ki_complete)(struct kiocb *iocb, long ret, long long ret2);
 	void			*private;
 	int			ki_flags;
 	u16			ki_hint;
-- 
2.7.4

