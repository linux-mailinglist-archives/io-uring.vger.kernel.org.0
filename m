Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7FB57008B
	for <lists+io-uring@lfdr.de>; Mon, 11 Jul 2022 13:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiGKL2s (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jul 2022 07:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbiGKL2R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jul 2022 07:28:17 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DE7B1A
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 04:08:17 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220711110816epoutp020bae55b8552c5c729cae98597f3f2edd~AwcC8-dcN2789827898epoutp02Q
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 11:08:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220711110816epoutp020bae55b8552c5c729cae98597f3f2edd~AwcC8-dcN2789827898epoutp02Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1657537696;
        bh=o09NKBCLryXYIbhTVut19weRbwkJO8JA/MTc+NYfyJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QJSd+tFHf/gsWs2Vyi9QohGZpSSMfHg+29syb1d5o8F9Hk4lXbIWl1LkILRtwWZMb
         +P4OrSM5LNG8SbbDWouq0tMai8FqQv4cUThNOJxYpvRx8rMN6qbTynOpl0lvncjWzV
         QwcyBjOBvzW3ZyJPaSDGYp46qkH4xBTK6qUyg51M=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220711110815epcas5p25f715eec70cbb947e83e110c44270b1a~AwcCe6aS92363823638epcas5p2d;
        Mon, 11 Jul 2022 11:08:15 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4LhLhs2s6Fz4x9Pv; Mon, 11 Jul
        2022 11:08:13 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        90.6A.09639.D940CC26; Mon, 11 Jul 2022 20:08:13 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220711110812epcas5p33aa90b23aa62fb11722aa8195754becf~Awb-qJkiT1828518285epcas5p3W;
        Mon, 11 Jul 2022 11:08:12 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220711110812epsmtrp2cb5467cd6c76fc82001e53763e6a1ac5~Awb-pRkEk2556725567epsmtrp2E;
        Mon, 11 Jul 2022 11:08:12 +0000 (GMT)
X-AuditID: b6c32a4b-e6dff700000025a7-01-62cc049d545a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FA.9A.08905.C940CC26; Mon, 11 Jul 2022 20:08:12 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220711110807epsmtip24d235af3e4557cf0e2c0d0551f93aac2~Awb6z6Tby0333603336epsmtip2S;
        Mon, 11 Jul 2022 11:08:06 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     hch@lst.de, sagi@grimberg.me, kbusch@kernel.org, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, asml.silence@gmail.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
Subject: [PATCH for-next 2/4] nvme: compact nvme_uring_cmd_pdu struct
Date:   Mon, 11 Jul 2022 16:31:53 +0530
Message-Id: <20220711110155.649153-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220711110155.649153-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEJsWRmVeSWpSXmKPExsWy7bCmhu5cljNJBhd+CVo0TfjLbDFn1TZG
        i9V3+9ksbh7YyWSxcvVRJot3redYLM6/PcxkMenQNUaLvbe0LeYve8puse71exYHbo+ds+6y
        e5y/t5HF4/LZUo9NqzrZPDYvqffYfbOBzaNvyypGj8+b5AI4orJtMlITU1KLFFLzkvNTMvPS
        bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4DOVFIoS8wpBQoFJBYXK+nb2RTll5ak
        KmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZ8y8bF9whbfi2PMnrA2M3dxd
        jJwcEgImEmtOPWcHsYUEdjNK/H3p2cXIBWR/YpS4vekxG4TzjVGi++sqJpiOJ81PWCASexkl
        Tv5+xgThfGaUeP11L5DDwcEmoClxYXIpSIOIgItEZ9N0VpAaZoFtjBIn1rSzgSSEBVwljsxp
        A7NZBFQllr2cBGbzClhK3N3YxwaxTV5i5qXvYPdxClhJzNz+jxGiRlDi5EyQKziBhspLNG+d
        zQyyQEJgJodEw/JnjBDNLhLfN7yAOltY4tXxLewQtpTE53d7oRYkS1yaeQ6qpkTi8Z6DULa9
        ROupfmaQZ5iBnlm/Sx9iF59E7+8nYD9KCPBKdLQJQVQrStyb9JQVwhaXeDhjCZTtIXFyfSs0
        sHoZJd60PmCdwCg/C8kLs5C8MAth2wJG5lWMkqkFxbnpqcWmBcZ5qeXweE3Oz93ECE6sWt47
        GB89+KB3iJGJg/EQowQHs5II75+zp5KEeFMSK6tSi/Lji0pzUosPMZoCw3gis5Rocj4wteeV
        xBuaWBqYmJmZmVgamxkqifN6Xd2UJCSQnliSmp2aWpBaBNPHxMEp1cA0L0GnsDy5IVdqa5sE
        g+DDyPA9v8/eKA6227C1irmh8oZjUBDjDN3junqvxIQPfOh1mfr6frv6VoOTi+dMrbRbH9/p
        2vaiYPUFxX8Sk38fFLd16p/rb5Z8JevF/t6OFcfnTHwWH13a185U5n554uuSuUc0rCSX9MgW
        /7/uEFZqkJM2pV/m6b6JdvJt5w60dM9//mkn42YpmVUS68Myzt2zun7lZsDHpXGhlyL+Tfkv
        zyf7e5VUxnEL14JVohfNxdP2LhVZs+bmLVXRC5p7vySw3i1l5fZTCZ70a+fJzU9jL/q8XVXg
        0xXLVxyzyv7V751NW7/Yb7z+4uf2EzM9/p56EcC4etGp5pNB++afrj/mo8RSnJFoqMVcVJwI
        AHSJtyk1BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsWy7bCSvO4cljNJBidPGVo0TfjLbDFn1TZG
        i9V3+9ksbh7YyWSxcvVRJot3redYLM6/PcxkMenQNUaLvbe0LeYve8puse71exYHbo+ds+6y
        e5y/t5HF4/LZUo9NqzrZPDYvqffYfbOBzaNvyypGj8+b5AI4orhsUlJzMstSi/TtErgyZl62
        L7jCW3Hs+RPWBsZu7i5GTg4JAROJJ81PWLoYuTiEBHYzSlzdupUFIiEu0XztBzuELSyx8t9z
        MFtI4COjxNEVOl2MHBxsApoSFyaXgoRFBLwkVvT8YQKxmQX2MUoceiMMYgsLuEocmdPGBmKz
        CKhKLHs5CczmFbCUuLuxjw1ivLzEzEvfwcZzClhJzNz+jxFilaXEqbszmSDqBSVOznzCAjFf
        XqJ562zmCYwCs5CkZiFJLWBkWsUomVpQnJueW2xYYJiXWq5XnJhbXJqXrpecn7uJERwRWpo7
        GLev+qB3iJGJg/EQowQHs5II75+zp5KEeFMSK6tSi/Lji0pzUosPMUpzsCiJ817oOhkvJJCe
        WJKanZpakFoEk2Xi4JRqYJLWmLh/kv+0N1w2spLfnh1tep4yz6e+0SuQdUL02wPzJrs+Zcnr
        khWb6NV31EMqMqb1jGBV6ILLcr+CeIMKzNa8nHH6wZ+X2R+NDu4quLnm8O9bcXyLC44t2SVR
        wv1tVlXhTTYG3oMynVcNJx4/dKv52MUFMRet422c2522LJu35OeHxouSeknbni03v+sSnfPg
        5juxvfNNLI33hR7Tq9aTf7Sp4NPz9zlrj4csWaDV+XbGQ/Wzpxo1Gv0uskjfXu/12q3Fno/x
        7N3wTR84flSaNM4XYj8mk/P1WssWtWVdSdM5Gz5W/JX8WS+REiK+LXv+V2FNbtkD5dJ9D/s+
        2zhKZMaK/uZsT261NpTheazEUpyRaKjFXFScCACHKrFS9wIAAA==
X-CMS-MailID: 20220711110812epcas5p33aa90b23aa62fb11722aa8195754becf
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220711110812epcas5p33aa90b23aa62fb11722aa8195754becf
References: <20220711110155.649153-1-joshi.k@samsung.com>
        <CGME20220711110812epcas5p33aa90b23aa62fb11722aa8195754becf@epcas5p3.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Anuj Gupta <anuj20.g@samsung.com>

Mark this packed so that we can create bit more space in its container
i.e. io_uring_cmd. This is in preparation to support multipathing on
uring-passthrough.
Move its definition to nvme.h as well.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/nvme/host/ioctl.c | 14 --------------
 drivers/nvme/host/nvme.h  | 14 ++++++++++++++
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 9227e07f717e..fc02eddd4977 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -340,20 +340,6 @@ struct nvme_uring_data {
 	__u32	timeout_ms;
 };
 
-/*
- * This overlays struct io_uring_cmd pdu.
- * Expect build errors if this grows larger than that.
- */
-struct nvme_uring_cmd_pdu {
-	union {
-		struct bio *bio;
-		struct request *req;
-	};
-	void *meta; /* kernel-resident buffer */
-	void __user *meta_buffer;
-	u32 meta_len;
-};
-
 static inline struct nvme_uring_cmd_pdu *nvme_uring_cmd_pdu(
 		struct io_uring_cmd *ioucmd)
 {
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 7323a2f61126..9d3ff6feda06 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -165,6 +165,20 @@ struct nvme_request {
 	struct nvme_ctrl	*ctrl;
 };
 
+/*
+ * This overlays struct io_uring_cmd pdu.
+ * Expect build errors if this grows larger than that.
+ */
+struct nvme_uring_cmd_pdu {
+	union {
+		struct bio *bio;
+		struct request *req;
+	};
+	void *meta; /* kernel-resident buffer */
+	void __user *meta_buffer;
+	u32 meta_len;
+} __packed;
+
 /*
  * Mark a bio as coming in through the mpath node.
  */
-- 
2.25.1

