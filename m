Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7C66F23F9
	for <lists+io-uring@lfdr.de>; Sat, 29 Apr 2023 11:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbjD2JnH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Apr 2023 05:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbjD2JnG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Apr 2023 05:43:06 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5626210E
        for <io-uring@vger.kernel.org>; Sat, 29 Apr 2023 02:42:58 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230429094257epoutp0149050a1a76b115643720c791ade4ab37~aXo6SNnqP2540625406epoutp019
        for <io-uring@vger.kernel.org>; Sat, 29 Apr 2023 09:42:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230429094257epoutp0149050a1a76b115643720c791ade4ab37~aXo6SNnqP2540625406epoutp019
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1682761377;
        bh=ZdLCtWWe0/Llin+LzaCzsXrHz2aghk9/ahbIIMl7+Xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YiseguAM2nMEq1UrQmZ5YJxrPzVuqFa6o+zE0l960iE1oy2dHd7WjlfHFw09x/6OW
         mp8SBHmDsWpFBii62yChTelWOCfZy01dqqFlWPRU3NEcGkZLc37R3Oy1xnbwUv8gka
         VZ6EVRl5X86ia+4Nwn8L8kOwDVen/k23+XSa7rrg=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20230429094255epcas5p447f0176a9d404b46dd0f40a3d864e95c~aXo5GlbYu1967019670epcas5p4R;
        Sat, 29 Apr 2023 09:42:55 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Q7kzf1K7zz4x9Pq; Sat, 29 Apr
        2023 09:42:54 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        52.60.55646.E96EC446; Sat, 29 Apr 2023 18:42:54 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20230429094253epcas5p3cfff90e1c003b6fc9c7c4a61287beecb~aXo2uScLC0334203342epcas5p3N;
        Sat, 29 Apr 2023 09:42:53 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230429094253epsmtrp1b582f9b72b57a2a0e53a6d45cb7a2113~aXo2tiA7x0376803768epsmtrp1w;
        Sat, 29 Apr 2023 09:42:53 +0000 (GMT)
X-AuditID: b6c32a4b-913ff7000001d95e-f2-644ce69eed41
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        35.29.28392.D96EC446; Sat, 29 Apr 2023 18:42:53 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230429094251epsmtip227856de4b7a95bc7378b7b46d1facec0~aXo1Ed1Pr0191301913epsmtip2-;
        Sat, 29 Apr 2023 09:42:51 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, sagi@grimberg.me, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        anuj1072538@gmail.com, xiaoguang.wang@linux.alibaba.com,
        Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [RFC PATCH 08/12] block: add mq_ops to submit and complete commands
 from raw-queue
Date:   Sat, 29 Apr 2023 15:09:21 +0530
Message-Id: <20230429093925.133327-9-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230429093925.133327-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFJsWRmVeSWpSXmKPExsWy7bCmhu68Zz4pBrsmsll8/PqbxaJpwl9m
        i9V3+9ksbh7YyWSxcvVRJot3redYLI7+f8tmMenQNUaLvbe0LeYve8puse71exaLTX9PMjnw
        eOycdZfd4/y9jSwel8+Wemxa1cnmsfOhpcfmJfUeu282sHn0bVnF6PF5k1wAZ1S2TUZqYkpq
        kUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QvUoKZYk5pUChgMTi
        YiV9O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLSvHS9vNQSK0MDAyNToMKE7Iy3vbvZCjay
        V0x5MYmxgXEqWxcjJ4eEgInE/971rF2MXBxCArsZJbbtvsEEkhAS+MQo8fEqM0TiM6PExjeL
        4TomdP1nh0jsYpR4eP8iK1xV1+P/QC0cHGwCmhIXJpeCNIgIuEg0rQVZx8XBLPCNUaJp91wW
        kISwQKzEkp9PWUFsFgFViUPtj8E28ApYSsydvoYFYpu8xMxL39lBbE4BK4nvM3YzQ9QISpyc
        +QSshhmopnnrbGaI+qUcEu9nhEHYLhKzZm9mhbCFJV4d38IOYUtJvOxvg7KTJS7NPMcEYZdI
        PN5zEMq2l2g91Q/2CzPQL+t36UOs4pPo/f2ECSQsIcAr0dEmBFGtKHFv0lOoTeISD2csgbI9
        JNqP/GaFBGgvo8TymzUTGOVnIXlgFpIHZiEsW8DIvIpRMrWgODc9tdi0wDgvtRwercn5uZsY
        wYlWy3sH46MHH/QOMTJxMB5ilOBgVhLh5a10TxHiTUmsrEotyo8vKs1JLT7EaAoM4YnMUqLJ
        +cBUn1cSb2hiaWBiZmZmYmlsZqgkzqtuezJZSCA9sSQ1OzW1ILUIpo+Jg1OqgSkzIiFHpE0x
        zWl5uFjL1h/76gOr+cvVY/gZcjldivvMqhu2ei6IXzM56jz3rKb5Sisv+jzQULb65hkreFMh
        uP7GtOJzd0o5eSd8meDcefX1q44zxQ8OHOyNucL9SezGRX7H61cPsz+ekNSnc1m1PGV7+3GR
        tJLzJlNFdJ3qIi+n6sgK79iqrivRz3PNfXvDyfKnT2SubT6x/a/CjF/33rTxPOF8zfLri6SW
        z7K8a8U3tmwufp3v77Q4/P450Xvi7A7/ba8maEdsMvp+ILT68r6SWstMVa18822eJt3bk9bP
        1L1x3X5BfXogr8zvFz95jXQDJdIL9IOtvUPZbgXb2lvd93Hc+Lta7Fn6wuVTlViKMxINtZiL
        ihMBF2wPdz0EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsWy7bCSvO7cZz4pBmf6hSw+fv3NYtE04S+z
        xeq7/WwWNw/sZLJYufook8W71nMsFkf/v2WzmHToGqPF3lvaFvOXPWW3WPf6PYvFpr8nmRx4
        PHbOusvucf7eRhaPy2dLPTat6mTz2PnQ0mPzknqP3Tcb2Dz6tqxi9Pi8SS6AM4rLJiU1J7Ms
        tUjfLoEr423vbraCjewVU15MYmxgnMrWxcjJISFgIjGh6z87iC0ksINR4vcLOYi4uETztR/s
        ELawxMp/z4FsLqCaj4wSJ07vYepi5OBgE9CUuDC5FKRGRMBLov3tLDaQGmaBf4wS779eZgJJ
        CAtESzS9vgo2iEVAVeJQ+2OwxbwClhJzp69hgVggLzHz0newGk4BK4nvM3Yzg8wXAqppXBAP
        US4ocXLmE7ByZqDy5q2zmScwCsxCkpqFJLWAkWkVo2RqQXFuem6xYYFRXmq5XnFibnFpXrpe
        cn7uJkZwlGhp7WDcs+qD3iFGJg7GQ4wSHMxKIry8le4pQrwpiZVVqUX58UWlOanFhxilOViU
        xHkvdJ2MFxJITyxJzU5NLUgtgskycXBKNTDNS0ksTljcq95wPSH1R0nR7QLz85erpGby/y9b
        faJ82Q2n57wvr0fUT74TJnDz4znO+MBfLQvDGZJ2807KbM94Weim9fD9wf0ZE1udKp5/Yikx
        XBW2/tG859rL9nKrW1py3fa89XrivKMa+ziCD0TOZZKUF3hivOvDuwVxi5c/936XsD18nULD
        uqTO1PeLD2fMiHuyuGBOpX/zMQ3BOadsn7zbubXR+uyXooX6oXM/35cy5fhyS2UNV8aKjKuv
        mS/oLpL5Je/GLhksIxO66tXK3pa49bIbN4XEqR1kyowyetSdf71i8vEn6gcuz7Q+3TexePfz
        L9pCx5229F+6rNtmpXRyu9+BkPIv9y/166XmKrEUZyQaajEXFScCAKgzlO8BAwAA
X-CMS-MailID: 20230429094253epcas5p3cfff90e1c003b6fc9c7c4a61287beecb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230429094253epcas5p3cfff90e1c003b6fc9c7c4a61287beecb
References: <20230429093925.133327-1-joshi.k@samsung.com>
        <CGME20230429094253epcas5p3cfff90e1c003b6fc9c7c4a61287beecb@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Anuj Gupta <anuj20.g@samsung.com>

This patch introduces ->queue_uring_cmd and -> poll_uring_cmd in mq_ops,
which will allow to submit and complete (via polling) from the specified
raw-queue (denoted by qid).

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 include/linux/blk-mq.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 7d6790be4847..dcce2939ff1e 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -659,6 +659,9 @@ struct blk_mq_ops {
 	void (*show_rq)(struct seq_file *m, struct request *rq);
 	int (*register_queue)(void *data);
 	int (*unregister_queue)(void *data, int qid);
+	int (*queue_uring_cmd)(struct io_uring_cmd *ioucmd, int qid);
+	int (*poll_uring_cmd)(struct io_uring_cmd *ioucmd, int qid,
+			      struct io_comp_batch *);
 #endif
 };
 
-- 
2.25.1

