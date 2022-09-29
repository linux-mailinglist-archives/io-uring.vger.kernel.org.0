Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCBC5EF550
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 14:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235605AbiI2MYB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 08:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235286AbiI2MXx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 08:23:53 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C2E149D12
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 05:23:50 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220929122348epoutp03befd9cc81960c1441872b63242a37b4b~ZVE1xG1Us2090720907epoutp03R
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 12:23:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220929122348epoutp03befd9cc81960c1441872b63242a37b4b~ZVE1xG1Us2090720907epoutp03R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664454228;
        bh=Z3PK6vAIkjNPzydQ/3AsMAslieosT5m/aEKA82hKphM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SlAni5IQMe/LI2qf819CONh/gzHX0S4y/nbOvnwUZzZJvbQQ/8laRXMEZBt/WV2WB
         EvWALVc52Y3LZiAbpGQlM4LAqO8ohzS0gYviWXElWIi5TLyn8NM6sRpOROSsGWs9Vr
         Bx5NcxY7JkZ0d118yohSbvFpvfttROlcmHnuQVC8=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220929122348epcas5p34e0fb4decac1005f3080c4ab016d5946~ZVE1XEd_10262002620epcas5p3X;
        Thu, 29 Sep 2022 12:23:48 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4MdXb51Dhtz4x9Q1; Thu, 29 Sep
        2022 12:23:45 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FD.9F.56352.15E85336; Thu, 29 Sep 2022 21:23:45 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220929121701epcas5p287a6d3f851626a5c7580d9a534432e9b~ZU_6oC5ll2579425794epcas5p2S;
        Thu, 29 Sep 2022 12:17:01 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220929121701epsmtrp2a681b5bef377744050439db211fd039b~ZU_6mGWvn1794617946epsmtrp2f;
        Thu, 29 Sep 2022 12:17:01 +0000 (GMT)
X-AuditID: b6c32a4b-5f7fe7000001dc20-42-63358e511047
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E7.43.14392.DBC85336; Thu, 29 Sep 2022 21:17:01 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220929121700epsmtip1034d1120294b80632ca910941a802a1f~ZU_5LcNVb3029530295epsmtip1A;
        Thu, 29 Sep 2022 12:17:00 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH for-next v11 09/13] nvme: pass ubuffer as an integer
Date:   Thu, 29 Sep 2022 17:36:28 +0530
Message-Id: <20220929120632.64749-10-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929120632.64749-1-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIJsWRmVeSWpSXmKPExsWy7bCmlm5gn2mywdbXbBZNE/4yW6y+289m
        cfPATiaLlauPMlm8az3HYnH0/1s2i0mHrjFa7L2lbTF/2VN2i+7rO9gcuDwuny312LSqk81j
        85J6j903G9g8+rasYvT4vEkugC0q2yYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJc
        SSEvMTfVVsnFJ0DXLTMH6C4lhbLEnFKgUEBicbGSvp1NUX5pSapCRn5xia1SakFKToFJgV5x
        Ym5xaV66Xl5qiZWhgYGRKVBhQnbG0VtzWQoeSlVcO3uZuYGxW6yLkZNDQsBEYtOzQ4xdjFwc
        QgK7GSWm3N7LCuF8YpQ4uX4mO0iVkMA3Ronmn9IwHa8fvWKCKNrLKLF+9zRmCOczo8TXWbvA
        OtgE1CWOPG9lBLFFBIwk9n86CTaWWeAm0KRj+5hAEsICLhIH9q9jA7FZBFQlvr26DdbMK2Al
        sfXkCWaIdfISMy99B4tzAsUXX5vDClEjKHFy5hMWEJsZqKZ562ywKyQEGjkknjSdAyriAHJc
        JF4fhDpbWOLV8S3sELaUxOd3e9kg7HSJH5efMkHYBSC3MULY9hKtp/qZQcYwC2hKrN+lDxGW
        lZh6ah0TxFo+id7fT6BaeSV2zIOxlSTaV86BsiUk9p5rgLI9JO7NugYNuV5GiTMzHjNOYFSY
        heSdWUjemYWwegEj8ypGydSC4tz01GLTAuO81HJ4LCfn525iBKdVLe8djI8efNA7xMjEwXiI
        UYKDWUmEV7zANFmINyWxsiq1KD++qDQntfgQoykwvCcyS4km5wMTe15JvKGJpYGJmZmZiaWx
        maGSOO/iGVrJQgLpiSWp2ampBalFMH1MHJxSDUw88y7PWxWrb7GMVeLigtvbwlrm174SPJkV
        JSf4d0rh8do7lyfLf2dh7exu/lQ1rUBZZm97l/6LY9v6XulWP3vEHChXY/jPOUDpDcOBMxK9
        Vyctufd1G++Kk3PfazifsxRc8SquwlzH4A5jaqzUpujPX6qfiDpdcD2R3C734MGUYLUQi+4l
        X9jufY98M7n2+5S7b7NM5y3Vzo/98PjPqaajXEUXf06J2VeV9GC/S1LGiVjjho231txk/NjA
        kxIaxuym2rsl/uf9+4kzzmw7vya74CF7+QnPg35njh092Ny6bZunGZ/Mrb8Hpxx8/lyA9drh
        +b3PDmj+O7irSXWmr/yzNfMeb5zkdErvnKRGXcXEDUosxRmJhlrMRcWJANQd9Uw0BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsWy7bCSnO7eHtNkgzPfNC2aJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsFt3Xd7A5cHlcPlvqsWlVJ5vH
        5iX1HrtvNrB59G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV8bRW3NZCh5KVVw7e5m5gbFbrIuR
        k0NCwETi9aNXTF2MXBxCArsZJa7eWskEkZCQOPVyGSOELSyx8t9zdoiij4wSE64fYwFJsAmo
        Sxx53gpWJCJgJrH08BoWkCJmgfuMEm+bd4MVCQu4SBzYv44NxGYRUJX49uo2O4jNK2AlsfXk
        CWaIDfISMy99B4tzAsUXX5vD2sXIAbTNUmL7TQWIckGJkzOfgI1kBipv3jqbeQKjwCwkqVlI
        UgsYmVYxSqYWFOem5xYbFhjmpZbrFSfmFpfmpesl5+duYgQHvpbmDsbtqz7oHWJk4mA8xCjB
        wawkwiteYJosxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdC18l4IYH0xJLU7NTUgtQimCwTB6dU
        A9OJmyZWqXqJ9u9VPJ92ih+bVNTO7iNXuOnd6m+6dmdWv5Gx7FuztOAsf+M1lxen2K86GXgz
        2LqWFutadhW3zXu1aAE7T/7xvZ1aZt/0e3p+2GzkdmHNXBHCm7egeTv3qV0erm5tWQJ94tPf
        vZt+f4XmpY/7/9TPux/1S3zDFucGqf0OVfc26f3ZJZW/24nx66qcckWrB4zie8W0lhxzk/kj
        U/q6LGKO3ZoXGw5Gma4VWODLsO6JgvsvCSPFY9W/5yzribv/hbd8yrSu8vfdHumMcU7bfrXv
        Vikx+7v54QfGDO3w4M+xt6fJK86f1Oa3SvSF5KrCKVMaecTZNTaz1laev9fIp1hnw7ZIraLq
        mxJLcUaioRZzUXEiAJBoCtzrAgAA
X-CMS-MailID: 20220929121701epcas5p287a6d3f851626a5c7580d9a534432e9b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220929121701epcas5p287a6d3f851626a5c7580d9a534432e9b
References: <20220929120632.64749-1-anuj20.g@samsung.com>
        <CGME20220929121701epcas5p287a6d3f851626a5c7580d9a534432e9b@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Kanchan Joshi <joshi.k@samsung.com>

This is a prep patch. Modify nvme_submit_user_cmd and
nvme_map_user_request to take ubuffer as plain integer
argument, and do away with nvme_to_user_ptr conversion in callers.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 drivers/nvme/host/ioctl.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 0143f62b27c2..4a7e45a263b6 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -83,9 +83,10 @@ static struct request *nvme_alloc_user_request(struct request_queue *q,
 	return req;
 }
 
-static int nvme_map_user_request(struct request *req, void __user *ubuffer,
+static int nvme_map_user_request(struct request *req, u64 ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
-		u32 meta_seed, void **metap, bool vec)
+		u32 meta_seed, void **metap, struct io_uring_cmd *ioucmd,
+		bool vec)
 {
 	struct request_queue *q = req->q;
 	struct nvme_ns *ns = q->queuedata;
@@ -136,7 +137,7 @@ static int nvme_map_user_request(struct request *req, void __user *ubuffer,
 }
 
 static int nvme_submit_user_cmd(struct request_queue *q,
-		struct nvme_command *cmd, void __user *ubuffer,
+		struct nvme_command *cmd, u64 ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
 		u32 meta_seed, u64 *result, unsigned timeout, bool vec)
 {
@@ -154,7 +155,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	req->timeout = timeout;
 	if (ubuffer && bufflen) {
 		ret = nvme_map_user_request(req, ubuffer, bufflen, meta_buffer,
-				meta_len, meta_seed, &meta, vec);
+				meta_len, meta_seed, &meta, NULL, vec);
 		if (ret)
 			goto out;
 	}
@@ -239,7 +240,7 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 	c.rw.appmask = cpu_to_le16(io.appmask);
 
 	return nvme_submit_user_cmd(ns->queue, &c,
-			nvme_to_user_ptr(io.addr), length,
+			io.addr, length,
 			metadata, meta_len, lower_32_bits(io.slba), NULL, 0,
 			false);
 }
@@ -293,7 +294,7 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		timeout = msecs_to_jiffies(cmd.timeout_ms);
 
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
-			nvme_to_user_ptr(cmd.addr), cmd.data_len,
+			cmd.addr, cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
 			0, &result, timeout, false);
 
@@ -339,7 +340,7 @@ static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		timeout = msecs_to_jiffies(cmd.timeout_ms);
 
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
-			nvme_to_user_ptr(cmd.addr), cmd.data_len,
+			cmd.addr, cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
 			0, &cmd.result, timeout, vec);
 
@@ -525,9 +526,9 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	req->timeout = d.timeout_ms ? msecs_to_jiffies(d.timeout_ms) : 0;
 
 	if (d.addr && d.data_len) {
-		ret = nvme_map_user_request(req, nvme_to_user_ptr(d.addr),
+		ret = nvme_map_user_request(req, d.addr,
 			d.data_len, nvme_to_user_ptr(d.metadata),
-			d.metadata_len, 0, &meta, vec);
+			d.metadata_len, 0, &meta, ioucmd, vec);
 		if (ret)
 			goto out_err;
 	}
-- 
2.25.1

