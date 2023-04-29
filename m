Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1704A6F23EE
	for <lists+io-uring@lfdr.de>; Sat, 29 Apr 2023 11:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbjD2Jmu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Apr 2023 05:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbjD2Jmt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Apr 2023 05:42:49 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1FA1BDA
        for <io-uring@vger.kernel.org>; Sat, 29 Apr 2023 02:42:47 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230429094246epoutp02c70e00cd42263cf0fdac4ae04fc5bc4d~aXov3aMJo2139121391epoutp02d
        for <io-uring@vger.kernel.org>; Sat, 29 Apr 2023 09:42:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230429094246epoutp02c70e00cd42263cf0fdac4ae04fc5bc4d~aXov3aMJo2139121391epoutp02d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1682761366;
        bh=cGKDfl/XthfWKk15QDiG1O0uY0pyS8zVFh/2tUDjwjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CooSrNQQLUGXRa84Lz00nAf3iTLu431vKL52KxL+WBYW9DkpVXtXO57FVry/CTfRH
         QDC5hTurcj0ci71s03AKidKqvAwoHZ8PnUWUWrZl75vK9gNFEWV7Td5un00PJNULx5
         j3RsMH3zSmMKXzMc5UXR+QAMDzn4H9gUS0f/r+8Q=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20230429094245epcas5p18b332f08089ce47aef7cf4c022276bb1~aXovUNIjP2857728577epcas5p1f;
        Sat, 29 Apr 2023 09:42:45 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Q7kzR4r5Cz4x9Pp; Sat, 29 Apr
        2023 09:42:43 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        58.50.55646.396EC446; Sat, 29 Apr 2023 18:42:43 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230429094243epcas5p13be3ca62dc2b03299d09cafaf11923c1~aXotIHsik1041010410epcas5p1k;
        Sat, 29 Apr 2023 09:42:43 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230429094243epsmtrp1f27744d43c11881159e6c70a6bf698ea~aXotHXscF0376803768epsmtrp1q;
        Sat, 29 Apr 2023 09:42:43 +0000 (GMT)
X-AuditID: b6c32a4b-913ff7000001d95e-dc-644ce6930268
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        46.38.27706.296EC446; Sat, 29 Apr 2023 18:42:42 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230429094240epsmtip29cd999aa5565b7db1f8bef0f06413366~aXorL5mwJ0703907039epsmtip2R;
        Sat, 29 Apr 2023 09:42:40 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, sagi@grimberg.me, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        anuj1072538@gmail.com, xiaoguang.wang@linux.alibaba.com,
        Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [RFC PATCH 03/12] fs, block: interface to register/unregister the
 raw-queue
Date:   Sat, 29 Apr 2023 15:09:16 +0530
Message-Id: <20230429093925.133327-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230429093925.133327-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNJsWRmVeSWpSXmKPExsWy7bCmuu7kZz4pBi8vKll8/PqbxaJpwl9m
        i9V3+9ksbh7YyWSxcvVRJot3redYLI7+f8tmMenQNUaLvbe0LeYve8puse71exaLTX9PMjnw
        eOycdZfd4/y9jSwel8+Wemxa1cnmsfOhpcfmJfUeu282sHn0bVnF6PF5k1wAZ1S2TUZqYkpq
        kUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QvUoKZYk5pUChgMTi
        YiV9O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLSvHS9vNQSK0MDAyNToMKE7Iwf+1uZC5Zw
        VSxdq9bAeJaji5GTQ0LARGLynalMXYxcHEICuxklPvzZwQLhfGKUePFqDVTmG6PE8nmbGWFa
        ei9+ZYNI7GWU+H1xGjuE85lR4vXJ3cxdjBwcbAKaEhcml4I0iAi4SDStnQrWwAwyqWn3XBaQ
        hLBAmMSMx6vBprIIqErsW/+UHcTmFbCU+LW6kwlim7zEzEvfweKcAlYS32eAzAepEZQ4OfMJ
        2BxmoJrmrbOZQRZICCzkkFh6eQtUs4vE7zOz2SBsYYlXx7ewQ9hSEi/726DsZIlLM89B1ZdI
        PN5zEMq2l2g91Q/2DDPQM+t36UPs4pPo/f2ECSQsIcAr0dEmBFGtKHFv0lNWCFtc4uGMJawQ
        JR4SR18mQ4Knl1Hi3cUW9gmM8rOQfDALyQezEJYtYGRexSiZWlCcm55abFpgnJdaDo/X5Pzc
        TYzgVKvlvYPx0YMPeocYmTgYDzFKcDArifDyVrqnCPGmJFZWpRblxxeV5qQWH2I0BQbxRGYp
        0eR8YLLPK4k3NLE0MDEzMzOxNDYzVBLnVbc9mSwkkJ5YkpqdmlqQWgTTx8TBKdXAtPzmbwfu
        pWWHn86Z8LesS/mbpyVXwdHHKZ41AZxhxU6u0devXT95Iqjp759yK9lw5Y3LZD7mCQWtSrO8
        U7FHmNt8/2eDzC9fn/EuXswxL5J7odfsl+an74n1PBSsnDv5TO2re8Ezz5SkTGLy7Jg9xbdk
        j+u69bNvbIr5/toxLXzed+arU+dNXs1X6CBVqTltms4emzyRHi/JiiJzVcVzmRpvmk5cc/5y
        2Ffsoph/SbS3tv/+y+Uzxa+XiC/M9sj45mDEkME9/W9Cx8tfzsdnbfacNOsGZ6IRm1DbhrCj
        u69yvd2tOpf/6IF5Mh3pRyrs+rMUIk4W8P3/sfFZePi5vnINi4XbJfjNRB49f+RyXImlOCPR
        UIu5qDgRAHcRTy4+BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsWy7bCSvO6kZz4pBt1rrS0+fv3NYtE04S+z
        xeq7/WwWNw/sZLJYufook8W71nMsFkf/v2WzmHToGqPF3lvaFvOXPWW3WPf6PYvFpr8nmRx4
        PHbOusvucf7eRhaPy2dLPTat6mTz2PnQ0mPzknqP3Tcb2Dz6tqxi9Pi8SS6AM4rLJiU1J7Ms
        tUjfLoEr48f+VuaCJVwVS9eqNTCe5ehi5OSQEDCR6L34la2LkYtDSGA3o0Tviv1MEAlxieZr
        P9ghbGGJlf+es0MUfWSU2PFtMpDDwcEmoClxYXIpSI2IgJdE+9tZYIOYBf4xSrz/ehlskLBA
        iMS5eY/ABrEIqErsW/8UzOYVsJT4tboTapm8xMxL38HinAJWEt9n7GYGmS8EVNO4IB6iXFDi
        5MwnLCA2M1B589bZzBMYBWYhSc1CklrAyLSKUTK1oDg3PbfYsMAwL7Vcrzgxt7g0L10vOT93
        EyM4SrQ0dzBuX/VB7xAjEwfjIUYJDmYlEV7eSvcUId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwX
        uk7GCwmkJ5akZqemFqQWwWSZODilGpgsk26+f5zl2zxDcVqxv4VBiNmPwnWyjg79L2d7BDlX
        Lryfwnf/EL/ZvmynaTd6Ot8JVn/7e1lSWqj072H2Vc66z5N35kzmnPUp9Gxap+VdFo5Dmzfs
        7X3iJKzFITGhY4VH7/x/9heko/afmV7ZqLbtT+jO73H2h9SmbRGcrDZrcZhu9yXxaGfLEqVt
        3sXlXN97hQxzBUOXFuttaJi0WPnFkxipCdvDuNxPak1MOiPhvv/O3JwJOo9ulZ3NYp92uq7v
        7NkV/GVGCf3xFXYX1xstXNa9LkH/s6KIm7F/6JkwVZE3Gsn+E4+q/dm75lZl4Oa52naXyt9c
        nXp97sqk9KSA7/d5w+JvZVef2m0i26bEUpyRaKjFXFScCACTtju/AQMAAA==
X-CMS-MailID: 20230429094243epcas5p13be3ca62dc2b03299d09cafaf11923c1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230429094243epcas5p13be3ca62dc2b03299d09cafaf11923c1
References: <20230429093925.133327-1-joshi.k@samsung.com>
        <CGME20230429094243epcas5p13be3ca62dc2b03299d09cafaf11923c1@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Anuj Gupta <anuj20.g@samsung.com>

Introduce register/unregister callbacks to fops and mq_ops, so that
callers can attach/detach to raw-queues.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/linux/blk-mq.h | 2 ++
 include/linux/fs.h     | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 06caacd77ed6..7d6790be4847 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -657,6 +657,8 @@ struct blk_mq_ops {
 	 * information about a request.
 	 */
 	void (*show_rq)(struct seq_file *m, struct request *rq);
+	int (*register_queue)(void *data);
+	int (*unregister_queue)(void *data, int qid);
 #endif
 };
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 475d88640d3d..79acccc5e7d4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1798,6 +1798,8 @@ struct file_operations {
 	int (*uring_cmd)(struct io_uring_cmd *ioucmd, unsigned int issue_flags);
 	int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_comp_batch *,
 				unsigned int poll_flags);
+	int (*register_queue)(struct file *f);
+	int (*unregister_queue)(struct file *f, int qid);
 } __randomize_layout;
 
 struct inode_operations {
-- 
2.25.1

