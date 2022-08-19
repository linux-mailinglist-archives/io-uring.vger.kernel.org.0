Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72F215999EF
	for <lists+io-uring@lfdr.de>; Fri, 19 Aug 2022 12:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348450AbiHSKk5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Aug 2022 06:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348452AbiHSKky (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Aug 2022 06:40:54 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9B6F075C
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 03:40:52 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220819104050epoutp030bcea46718e35d36016f9bc6cadf7fb6~MuOO-H06v1672816728epoutp03T
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 10:40:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220819104050epoutp030bcea46718e35d36016f9bc6cadf7fb6~MuOO-H06v1672816728epoutp03T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1660905650;
        bh=jVFwLJ5FLHYEcU2SFU9ctfDNtTJjbt60WwBHMemg378=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T08z+p+PcofxMh4fGG1A6kSspvqIuGE6RjEOUtyGgZldTIxDW5LJez7NF8QztERuv
         8E5VGCFlSHTAqZ7Cxz2RyXHjbA6M0m972g6B2btqwT9c9Qzocq3DwT/jj8jftpFYfY
         0WKuM2Qy3ydlNk9EIfqgbra5EAne1VswG5m6pV24=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220819104049epcas5p132ffb16b2ee1ad35f40b6daf94608be4~MuON3huIn0663706637epcas5p1v;
        Fri, 19 Aug 2022 10:40:49 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4M8JFC6nY3z4x9Py; Fri, 19 Aug
        2022 10:40:47 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        31.30.09494.DA86FF26; Fri, 19 Aug 2022 19:40:45 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220819104045epcas5p117a9fcb0c3143e877e75e24ceba4f381~MuOKBZuMo0658906589epcas5p1r;
        Fri, 19 Aug 2022 10:40:45 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220819104045epsmtrp107ad4c1773c12ffcfddd701f2f479a73~MuOKAraCY1513515135epsmtrp1M;
        Fri, 19 Aug 2022 10:40:45 +0000 (GMT)
X-AuditID: b6c32a4a-1ebff70000012516-2d-62ff68ad2660
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        CA.85.08802.DA86FF26; Fri, 19 Aug 2022 19:40:45 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220819104043epsmtip179a427156a083ce978bdad743c917f7f~MuOIhIS3p0577205772epsmtip1j;
        Fri, 19 Aug 2022 10:40:43 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH for-next 4/4] nvme: wire up fixed buffer support for nvme
 passthrough
Date:   Fri, 19 Aug 2022 16:00:21 +0530
Message-Id: <20220819103021.240340-5-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220819103021.240340-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBJsWRmVeSWpSXmKPExsWy7bCmhu7ajP9JBmcabSyaJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsFocmNzM5cHlcPlvqsWlVJ5vH
        5iX1HrtvNrB5vN93lc2jb8sqRo/Pm+QC2KOybTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwM
        dQ0tLcyVFPISc1NtlVx8AnTdMnOAjlNSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTk
        FJgU6BUn5haX5qXr5aWWWBkaGBiZAhUmZGec2jyVqeC/csX3OxfZGxgXy3YxcnBICJhI/D+f
        3sXIxSEksJtR4tPeHlYI5xOjxJv7rWwQzmdGiTlTfrN3MXKCdbTu/QxVtYtR4sfuRcxwVbdX
        rGUGmcsmoClxYXIpSIOIgJHE/k8nwRqYBS4wStzbeZMFJCEsEC6x43g7K4jNIqAqsehRLzOI
        zStgKXHxWS8bxDZ5iZmXvoNt5hSwkpi19CobRI2gxMmZT8DmMAPVNG+dDXaEhEAvh8T1TXOh
        TnWReDNtKhOELSzx6vgWqLiUxMv+Nig7WeLSzHNQNSUSj/cchLLtJVpP9YM9wwz0zPpd+hC7
        +CR6fz9hgoQdr0RHmxBEtaLEvUlPWSFscYmHM5awQpR4SNyfoQMJnl5giG7tZ5zAKD8LyQez
        kHwwC2HZAkbmVYySqQXFuempxaYFRnmp5fB4Tc7P3cQITqJaXjsYHz74oHeIkYmD8RCjBAez
        kgjvjTt/koR4UxIrq1KL8uOLSnNSiw8xmgKDeCKzlGhyPjCN55XEG5pYGpiYmZmZWBqbGSqJ
        83pd3ZQkJJCeWJKanZpakFoE08fEwSnVwFRU+LJuq0hlX7jR1/f7aqfnz722Ysn6zQ5ZO5VY
        X2nENRYLunDOcItNqNFi36a7Qbjr+s3phi+CTQ85nHkp+DhNY8LJ/QdrOw91CpxP8O2+8yl/
        kYh5WfAtgxkv+VUUP+ovip3irLZzzd8DK3IOr2XhfrIh5IpYTMTmpqYjyTwsKc85LZ+GfddJ
        FVli0PZbWm3Pzm0TQ9xDzGtZ9mwtefTr2QNehlNrLOLTvTa8araN51OJZU1ewjn32LG0+UEW
        c2dczbyvd2nHR77+3PluO67O2cz7eUKPzJ3Izh+ZDFZvLRbPnsactVpycmuv3o636zLszm/k
        OnXmRny+ruuvTgl9kcbn3BHlXp/4P2lvvarEUpyRaKjFXFScCACBHKnCKwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsWy7bCSnO7ajP9JBkcnSVk0TfjLbLH6bj+b
        xc0DO5ksVq4+ymTxrvUci8XR/2/ZLCYdusZosfeWtsX8ZU/ZLQ5NbmZy4PK4fLbUY9OqTjaP
        zUvqPXbfbGDzeL/vKptH35ZVjB6fN8kFsEdx2aSk5mSWpRbp2yVwZZzaPJWp4L9yxfc7F9kb
        GBfLdjFyckgImEi07v3M2sXIxSEksINR4tuP9WwQCXGJ5ms/2CFsYYmV/56zQxR9ZJT4MeM8
        UBEHB5uApsSFyaUgNSICZhJLD69hAalhFrjBKLGvdwoTSEJYIFRi3uwuZhCbRUBVYtGjXjCb
        V8BS4uKzXqhl8hIzL30HW8YpYCUxa+lVsLgQUM2vvx1MEPWCEidnPmEBsZmB6pu3zmaewCgw
        C0lqFpLUAkamVYySqQXFuem5xYYFRnmp5XrFibnFpXnpesn5uZsYwTGgpbWDcc+qD3qHGJk4
        GA8xSnAwK4nw3rjzJ0mINyWxsiq1KD++qDQntfgQozQHi5I474Wuk/FCAumJJanZqakFqUUw
        WSYOTqkGJpfm19t+rpScX7Ep5/uTR0of2+5tW6B/S3nqoVvFt5LntE1aprXl7PpFKw69M7yU
        U+P30zbO8SkH0/VKtQVu9cvyn9sJLOXr8Pn0YKnDDv6C34Yb33L8WNwjvXyyqL472zbHedaO
        F983FqnIXKp2FLbbFXe3NKRkxZZ9ui93ijzJjdjq/iM2+bbt/LbOOe8shDvbbjH6++dmqJ53
        YO3mPOkUvGRjj1XYpY7yY9/vfexO2Omce6hK8e6eiqAFt49wfdReFq79QTdT7mP9F8X08t9z
        xVqft81elxKY0i2//x5jpaXLaaWm+kWeHknXogV2he8Urj3IK7974/FU7gNv9760WtnmP0tp
        7YH6p88/b1BiKc5INNRiLipOBAAkQHBq8AIAAA==
X-CMS-MailID: 20220819104045epcas5p117a9fcb0c3143e877e75e24ceba4f381
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220819104045epcas5p117a9fcb0c3143e877e75e24ceba4f381
References: <20220819103021.240340-1-joshi.k@samsung.com>
        <CGME20220819104045epcas5p117a9fcb0c3143e877e75e24ceba4f381@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

if io_uring sends passthrough command with IO_URING_F_FIXEDBUFS flag,
use the pre-registered buffer to form the bio.
While at it modify nvme_submit_user_cmd to take ubuffer as plain integer
argument, and do away with nvme_to_user_ptr conversion in callers.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 drivers/nvme/host/ioctl.c | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 7756b439a688..5f2e2d31f5c7 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -65,10 +65,11 @@ static int nvme_finish_user_metadata(struct request *req, void __user *ubuf,
 }
 
 static struct request *nvme_alloc_user_request(struct request_queue *q,
-		struct nvme_command *cmd, void __user *ubuffer,
+		struct nvme_command *cmd, u64 ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
 		u32 meta_seed, void **metap, unsigned timeout, bool vec,
-		blk_opf_t rq_flags, blk_mq_req_flags_t blk_flags)
+		blk_opf_t rq_flags, blk_mq_req_flags_t blk_flags,
+		struct io_uring_cmd *ioucmd, bool fixedbufs)
 {
 	bool write = nvme_is_write(cmd);
 	struct nvme_ns *ns = q->queuedata;
@@ -89,14 +90,27 @@ static struct request *nvme_alloc_user_request(struct request_queue *q,
 
 	if (ubuffer && bufflen) {
 		if (!vec)
-			ret = blk_rq_map_user(q, req, NULL, ubuffer, bufflen,
-				GFP_KERNEL);
+			if (fixedbufs) {
+				struct iov_iter iter;
+
+				ret = io_uring_cmd_import_fixed(ubuffer,
+						bufflen, rq_data_dir(req),
+						&iter, ioucmd);
+				if (ret < 0)
+					goto out;
+				ret = blk_rq_map_user_fixedb(req, &iter);
+			} else {
+				ret = blk_rq_map_user(q, req, NULL,
+						nvme_to_user_ptr(ubuffer),
+						bufflen, GFP_KERNEL);
+			}
 		else {
 			struct iovec fast_iov[UIO_FASTIOV];
 			struct iovec *iov = fast_iov;
 			struct iov_iter iter;
 
-			ret = import_iovec(rq_data_dir(req), ubuffer, bufflen,
+			ret = import_iovec(rq_data_dir(req),
+					nvme_to_user_ptr(ubuffer), bufflen,
 					UIO_FASTIOV, &iov, &iter);
 			if (ret < 0)
 				goto out;
@@ -132,7 +146,7 @@ static struct request *nvme_alloc_user_request(struct request_queue *q,
 }
 
 static int nvme_submit_user_cmd(struct request_queue *q,
-		struct nvme_command *cmd, void __user *ubuffer,
+		struct nvme_command *cmd, u64 ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
 		u32 meta_seed, u64 *result, unsigned timeout, bool vec)
 {
@@ -142,7 +156,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	int ret;
 
 	req = nvme_alloc_user_request(q, cmd, ubuffer, bufflen, meta_buffer,
-			meta_len, meta_seed, &meta, timeout, vec, 0, 0);
+			meta_len, meta_seed, &meta, timeout, vec, 0, 0, NULL, 0);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
@@ -220,7 +234,7 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 	c.rw.appmask = cpu_to_le16(io.appmask);
 
 	return nvme_submit_user_cmd(ns->queue, &c,
-			nvme_to_user_ptr(io.addr), length,
+			io.addr, length,
 			metadata, meta_len, lower_32_bits(io.slba), NULL, 0,
 			false);
 }
@@ -274,7 +288,7 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		timeout = msecs_to_jiffies(cmd.timeout_ms);
 
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
-			nvme_to_user_ptr(cmd.addr), cmd.data_len,
+			cmd.addr, cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
 			0, &result, timeout, false);
 
@@ -320,7 +334,7 @@ static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		timeout = msecs_to_jiffies(cmd.timeout_ms);
 
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
-			nvme_to_user_ptr(cmd.addr), cmd.data_len,
+			cmd.addr, cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
 			0, &cmd.result, timeout, vec);
 
@@ -457,11 +471,11 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		rq_flags |= REQ_POLLED;
 
 retry:
-	req = nvme_alloc_user_request(q, &c, nvme_to_user_ptr(d.addr),
+	req = nvme_alloc_user_request(q, &c, d.addr,
 			d.data_len, nvme_to_user_ptr(d.metadata),
 			d.metadata_len, 0, &meta, d.timeout_ms ?
 			msecs_to_jiffies(d.timeout_ms) : 0, vec, rq_flags,
-			blk_flags);
+			blk_flags, ioucmd, issue_flags & IO_URING_F_FIXEDBUFS);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 	req->end_io = nvme_uring_cmd_end_io;
-- 
2.25.1

