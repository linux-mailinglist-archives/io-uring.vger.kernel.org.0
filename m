Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02F795F0516
	for <lists+io-uring@lfdr.de>; Fri, 30 Sep 2022 08:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiI3GoP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Sep 2022 02:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbiI3GoC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Sep 2022 02:44:02 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D41FC77C7
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 23:44:01 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220930064359epoutp03633997009e333bc1b7c9d9a6be3000bd~ZkFbVNO-W2779627796epoutp03S
        for <io-uring@vger.kernel.org>; Fri, 30 Sep 2022 06:43:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220930064359epoutp03633997009e333bc1b7c9d9a6be3000bd~ZkFbVNO-W2779627796epoutp03S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664520239;
        bh=Bj/wqbB7bQ5vziUIbpyKvUfT7C3Sk/Q8I9T3WCZwdKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NWdqVWsdqwrpEyyqRQ+hc5BJN+IXutyhhfDAAbttLR1+1Wdj9DcnMQYyUAjL8LEFb
         Nvp7SBTQqr/93pLr5sD4ed2n3iIpA4cbh6MI7LhITjIlzy0jsvtAeu5G6jTLi1fU2K
         w0i/Mb3/t8LcRj/wgInnrL5MgYT6ybEX0RuCGXEc=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220930064359epcas5p150c03a3389aca6e41e13eaeef638a7a8~ZkFav6CKN0319903199epcas5p1H;
        Fri, 30 Sep 2022 06:43:59 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Mf10Y52Zjz4x9Q0; Fri, 30 Sep
        2022 06:43:57 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A2.C5.26992.C2096336; Fri, 30 Sep 2022 15:43:56 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220930063821epcas5p48d4ec5136d487ea779ac74e2c0b740ac~ZkAgnrmDC2890728907epcas5p4O;
        Fri, 30 Sep 2022 06:38:21 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220930063821epsmtrp2c130222ea93037c62d1839088dcf0378~ZkAgm-h192234822348epsmtrp2C;
        Fri, 30 Sep 2022 06:38:21 +0000 (GMT)
X-AuditID: b6c32a49-319fb70000016970-5e-6336902c0c42
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E2.69.14392.DDE86336; Fri, 30 Sep 2022 15:38:21 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220930063819epsmtip29eabf3de3c9eec84a845550e916f145b~ZkAeFtNjb1763417634epsmtip2I;
        Fri, 30 Sep 2022 06:38:19 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v12 06/12] nvme: refactor nvme_add_user_metadata
Date:   Fri, 30 Sep 2022 11:57:43 +0530
Message-Id: <20220930062749.152261-7-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220930062749.152261-1-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNJsWRmVeSWpSXmKPExsWy7bCmlq7OBLNkg533lSxW3+1ns7h5YCeT
        xcrVR5ks3rWeY7E4+v8tm8WkQ9cYLfbe0raYv+wpu0X39R1sDpwel8+Wemxa1cnmsXlJvcfu
        mw1sHn1bVjF6fN4kF8AWlW2TkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
        aqvk4hOg65aZA3SSkkJZYk4pUCggsbhYSd/Opii/tCRVISO/uMRWKbUgJafApECvODG3uDQv
        XS8vtcTK0MDAyBSoMCE74/SBUywF00QqPj76x9jAOFOgi5GTQ0LAROJN83a2LkYuDiGB3YwS
        67fuYYJwPjFKfO5+zgrhfGOUeHzjFgtMy+eVf6ASexkl/mzuYodwPjNKnDnxmBGkik1AXeLI
        81YwW0TASGL/p5NgHcwCWxglmtctZgdJCAt4Srzr7GICsVkEVCWWTJvECmLzClhJXLixiw1i
        nbzEzEvfgeo5ODgFrCWaF+VAlAhKnJz5BOwiZqCS5q2zmSHK/7JLXL+SB1IuIeAi8eFILERY
        WOLV8S3sELaUxOd3e6Gmp0v8uPyUCcIukGg+to8RwraXaD3VzwwyhllAU2L9Ln2IsKzE1FPr
        mCC28kn0/n4C1corsWMejK0k0b5yDpQtIbH3XAOU7SGx8utDZkhQ9TFKvP7zjmUCo8IsJN/M
        QvLNLITVCxiZVzFKphYU56anFpsWGOallsMjOTk/dxMjOJVqee5gvPvgg94hRiYOxkOMEhzM
        SiK84gWmyUK8KYmVValF+fFFpTmpxYcYTYGhPZFZSjQ5H5jM80riDU0sDUzMzMxMLI3NDJXE
        eRfP0EoWEkhPLEnNTk0tSC2C6WPi4JRqYFrwZn3Y85f/BOYe2aj7oXC72ppKrrApBgej1mbw
        7ZqdvVqLec+p34tDZhkK/JC4WDzh7dFzuqY3nio943/7l1199sGnu05n3fuY+6W40EFgce17
        e41FzhxGn5iEnFb/qGS2Sg6J1i7u+HT/yhad7X5ff894xDyZ8de05o5bjwPSUg5dPSN3pDn2
        beqE2b6HF1YY/j62UGDleY6/dTeN71e/MzN2NL4lsDVsqdH8tj0VUw/cSL3uXf8gwdraOXZn
        bGc/28YiuTiDwHs9bVVefyLOi/JNWGrgJmbg77Jousx7FQVXf3GliMPdaxdtEFm+T6JcZVbR
        13NfQ2oT35hLvJaT0vm4vMDQM0R1i6Z8n54SS3FGoqEWc1FxIgDw9SweLgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsWy7bCSvO7dPrNkgxm3TC1W3+1ns7h5YCeT
        xcrVR5ks3rWeY7E4+v8tm8WkQ9cYLfbe0raYv+wpu0X39R1sDpwel8+Wemxa1cnmsXlJvcfu
        mw1sHn1bVjF6fN4kF8AWxWWTkpqTWZZapG+XwJVx+sAploJpIhUfH/1jbGCcKdDFyMkhIWAi
        8XnlH9YuRi4OIYHdjBLHTk9hgUhISJx6uYwRwhaWWPnvOTtE0UdGiXtPPoAl2ATUJY48bwWz
        RQTMJJYeXsMCUsQssItRYu7Wb8wgCWEBT4l3nV1MIDaLgKrEkmmTWEFsXgEriQs3drFBbJCX
        mHnpO9AGDg5OAWuJ5kU5IGEhoJLPe96zQ5QLSpyc+QTsOGag8uats5knMArMQpKahSS1gJFp
        FaNkakFxbnpusWGBYV5quV5xYm5xaV66XnJ+7iZGcLhrae5g3L7qg94hRiYOxkOMEhzMSiK8
        4gWmyUK8KYmVValF+fFFpTmpxYcYpTlYlMR5L3SdjBcSSE8sSc1OTS1ILYLJMnFwSjUwnbuT
        aFGq8rgiaXl8pYzdz1OVVsb7lPXLJ2zkldcRuFw7d7/OP0Wj+gidBx9SHDtM/NvZn4WKePh7
        Gy/bNmUa36OMfydWLXH9+j4rNbjsdOvDOZm1T/UYDddkLJ48yT7zhwhLf95OlqP3bW039Tm1
        TH60KkPKZtO300vu7ElqmjCLxW4/e32l25N/k0KmLTm76myqy/sV785tM7eapNYnf3DeYuMl
        Ho8ldCbz6u8rrvQUPFzw6SJz+Jka1kMzZu2IeL6dXXDflY3dGz+c443ni+/PYZJ8/vnrXW+T
        19rOW97xz/xdv+95eEXOhuNGGrZFRnmSj/i1f69677tmX/BqpgLlxG/3Q97MPMF7auqFPUos
        xRmJhlrMRcWJAPDxIXjmAgAA
X-CMS-MailID: 20220930063821epcas5p48d4ec5136d487ea779ac74e2c0b740ac
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220930063821epcas5p48d4ec5136d487ea779ac74e2c0b740ac
References: <20220930062749.152261-1-anuj20.g@samsung.com>
        <CGME20220930063821epcas5p48d4ec5136d487ea779ac74e2c0b740ac@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Kanchan Joshi <joshi.k@samsung.com>

Pass struct request rather than bio. It helps to kill a parameter, and
some processing clean-up too.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/ioctl.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 3746a02a88ef..bcaa6b3f97ca 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -20,19 +20,20 @@ static void __user *nvme_to_user_ptr(uintptr_t ptrval)
 	return (void __user *)ptrval;
 }
 
-static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
-		unsigned len, u32 seed, bool write)
+static void *nvme_add_user_metadata(struct request *req, void __user *ubuf,
+		unsigned len, u32 seed)
 {
 	struct bio_integrity_payload *bip;
 	int ret = -ENOMEM;
 	void *buf;
+	struct bio *bio = req->bio;
 
 	buf = kmalloc(len, GFP_KERNEL);
 	if (!buf)
 		goto out;
 
 	ret = -EFAULT;
-	if (write && copy_from_user(buf, ubuf, len))
+	if ((req_op(req) == REQ_OP_DRV_OUT) && copy_from_user(buf, ubuf, len))
 		goto out_free_meta;
 
 	bip = bio_integrity_alloc(bio, GFP_KERNEL, 1);
@@ -45,9 +46,13 @@ static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
 	bip->bip_iter.bi_sector = seed;
 	ret = bio_integrity_add_page(bio, virt_to_page(buf), len,
 			offset_in_page(buf));
-	if (ret == len)
-		return buf;
-	ret = -ENOMEM;
+	if (ret != len) {
+		ret = -ENOMEM;
+		goto out_free_meta;
+	}
+
+	req->cmd_flags |= REQ_INTEGRITY;
+	return buf;
 out_free_meta:
 	kfree(buf);
 out:
@@ -70,7 +75,6 @@ static struct request *nvme_alloc_user_request(struct request_queue *q,
 		u32 meta_seed, void **metap, unsigned timeout, bool vec,
 		blk_opf_t rq_flags, blk_mq_req_flags_t blk_flags)
 {
-	bool write = nvme_is_write(cmd);
 	struct nvme_ns *ns = q->queuedata;
 	struct block_device *bdev = ns ? ns->disk->part0 : NULL;
 	struct request *req;
@@ -96,13 +100,12 @@ static struct request *nvme_alloc_user_request(struct request_queue *q,
 		if (bdev)
 			bio_set_dev(bio, bdev);
 		if (bdev && meta_buffer && meta_len) {
-			meta = nvme_add_user_metadata(bio, meta_buffer, meta_len,
-					meta_seed, write);
+			meta = nvme_add_user_metadata(req, meta_buffer,
+					meta_len, meta_seed);
 			if (IS_ERR(meta)) {
 				ret = PTR_ERR(meta);
 				goto out_unmap;
 			}
-			req->cmd_flags |= REQ_INTEGRITY;
 			*metap = meta;
 		}
 	}
-- 
2.25.1

