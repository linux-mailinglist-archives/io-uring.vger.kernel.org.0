Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04B72583F3F
	for <lists+io-uring@lfdr.de>; Thu, 28 Jul 2022 14:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236790AbiG1MwP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jul 2022 08:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiG1MwN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jul 2022 08:52:13 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240761025
        for <io-uring@vger.kernel.org>; Thu, 28 Jul 2022 05:52:09 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220728125203epoutp02932a78c1ce4ed05b9d985c24ad02c150~F-0gjgXMu0683306833epoutp02h
        for <io-uring@vger.kernel.org>; Thu, 28 Jul 2022 12:52:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220728125203epoutp02932a78c1ce4ed05b9d985c24ad02c150~F-0gjgXMu0683306833epoutp02h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1659012723;
        bh=BbbSWEM1xsOG1dLNo8znd6zXYJk4jY/HHeirk2IeknA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DDWDFIptYCTIgwCctt8/GOtAWPLgFZZc9sGHX9IOEMEgK2ON78//BYF/p+k4e5fBB
         +ke7UYujMy1Rv23LwGdxLHFiacrrOcjo3B30RnCdhA6ehfNvUM791/G7j+RM8twb30
         R6G75mu6v+D6FjfxDSmFQvDN2Ilh+dh19NswG/Fk=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220728125201epcas5p400ddd320bb71973ba88aa64b5a3845f9~F-0fSrx880610606106epcas5p4z;
        Thu, 28 Jul 2022 12:52:01 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4LtrBl13whz4x9Pr; Thu, 28 Jul
        2022 12:51:59 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1D.B1.09662.E6682E26; Thu, 28 Jul 2022 21:51:59 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220728093905epcas5p22963dd2dadb73bdabfaffc55cb2edef5~F9MCBS9LL0479104791epcas5p2y;
        Thu, 28 Jul 2022 09:39:05 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220728093905epsmtrp1ceeedb8ccc72254eddf632d252b0df3f~F9MCAqeTn1674116741epsmtrp1b;
        Thu, 28 Jul 2022 09:39:05 +0000 (GMT)
X-AuditID: b6c32a49-86fff700000025be-de-62e2866e327e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        D6.7B.08802.93952E26; Thu, 28 Jul 2022 18:39:05 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220728093904epsmtip127c37e59f1e1c68e8d0ce6e4676f72cd~F9MBLVjNg1442314423epsmtip1N;
        Thu, 28 Jul 2022 09:39:04 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH liburing v3 2/5] io_uring.h: sync sqe entry with 5.20
 io_uring
Date:   Thu, 28 Jul 2022 15:03:24 +0530
Message-Id: <20220728093327.32580-3-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220728093327.32580-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsWy7bCmhm5+26Mkg83zmSzWXPnNbrH6bj+b
        xbvWcywWR/+/ZXNg8bh8ttSjb8sqRo/Pm+QCmKOybTJSE1NSixRS85LzUzLz0m2VvIPjneNN
        zQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAlikplCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVS
        C1JyCkwK9IoTc4tL89L18lJLrAwNDIxMgQoTsjOm7zrFVNDBUXF70in2BsbJbF2MnBwSAiYS
        z9+eYOli5OIQEtjNKLH0wmtGCOcTo8TEy19YIZzPjBLzW2fCtcxecAeqZRejxNtdZ9kgnFYm
        iSVzXzCDVLEJaEu8ensDzBYREJbY39HKAmIzC0RJrHl1lhHEFhYIkOhZ+pcVxGYRUJX4Mv89
        E4jNK2AjceTsISaIbfISqzccAJvDKWAr8enRCbD7JAQWsUs8mvIAqJkDyHGRaF+bCVEvLPHq
        +BZ2CFtK4mV/G5SdLbHp4U+omQUSR170MkPY9hKtp/qZQcYwC2hKrN+lDxGWlZh6ah0TxMl8
        Er2/n0C18krsmAdjq0r8vXebBcKWlrj57iqU7SHRNm0C2HghgQmMEg8fCE5glJuFsGEBI+Mq
        RsnUguLc9NRi0wLDvNRyeKQl5+duYgSnJy3PHYx3H3zQO8TIxMF4iFGCg1lJhDch+n6SEG9K
        YmVValF+fFFpTmrxIUZTYPBNZJYSTc4HJsi8knhDE0sDEzMzMxNLYzNDJXFer6ubkoQE0hNL
        UrNTUwtSi2D6mDg4pRqYWqaf95C2ma6QnLZXeq+pPM+BTT9OzBUsEa94ZpuVe+WTc8vn91PW
        f2o3PF14pDWMd8vZCvu5pk7fJojovF7hI/iaze+HksBpJ6cV3h31Vb+WmmeXvtp+kmVSo/O9
        +lLXm2Y3+RgWLWO88awp0cdoqVfQFrZ9aX0bHV/3BV4pm9B+QlD0etfXrusiRtmxHj23BWLv
        Mf6XUX4urDnrlVjOoa8PZ5/j4YzydrO7WXKtfeaLLzcfS/z038S4/tF3ntTZG2IvLysLbL+d
        +WayI3dkZD+ju66S4M67Fk/P3JyXxiJYpPjF9dYnmVb2PmkrhoiI5UfkavIX7POotNdx2jBt
        mfJSpwWLPRbsaI1W8H6qxFKckWioxVxUnAgA98JGt9gDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDJMWRmVeSWpSXmKPExsWy7bCSnK5l5KMkg0P3RCzWXPnNbrH6bj+b
        xbvWcywWR/+/ZXNg8bh8ttSjb8sqRo/Pm+QCmKO4bFJSczLLUov07RK4MqbvOsVU0MFRcXvS
        KfYGxslsXYycHBICJhKzF9xh6WLk4hAS2MEoMf3RaqYuRg6ghLTEwvWJEDXCEiv/PWeHqGlm
        klj2YDoLSIJNQFvi1dsbzCC2CFDR/o5WsDizQIzE1COHwWxhAT+J309XgdWwCKhKfJn/ngnE
        5hWwkThy9hATxAJ5idUbDoDVcArYSnx6dIIRxBYCqnk9aTvTBEa+BYwMqxglUwuKc9Nziw0L
        jPJSy/WKE3OLS/PS9ZLzczcxggNIS2sH455VH/QOMTJxMB5ilOBgVhLhTYi+nyTEm5JYWZVa
        lB9fVJqTWnyIUZqDRUmc90LXyXghgfTEktTs1NSC1CKYLBMHp1QDU233rJWt617zxm7auaD0
        a/u2Ux/V0mwK356Q1uX6wK92vkXG6SrXUsm1cq/Yf3Mx6PH27tEqrCi3aGg9+GMWv9LpmITe
        pNm/ZHIT0s9+u5JjNm3f6TnZ56/dOSu7cJqh+znZyXO+cBlHqV9d+nzF0eJfMbVHeMN4XaqD
        V0Qn8y5LumH64+zn/U0MhpJbP3ZI57rIGT+MeBtrWVPGWRjxzOXX4V8mP1osb/1vPGS+X+v/
        ttsnuPfMfKie+HVxi9Qex41GmybfFrrx7en/HK8PT4xlS+uPspp+v2V6r2/Wy+xLug93fNGN
        rBaWu++8syp6627+XJ/uyK/MSnud33mXiazRWFUTpdgWP29yzzvJbUosxRmJhlrMRcWJAElw
        CHaPAgAA
X-CMS-MailID: 20220728093905epcas5p22963dd2dadb73bdabfaffc55cb2edef5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220728093905epcas5p22963dd2dadb73bdabfaffc55cb2edef5
References: <20220728093327.32580-1-ankit.kumar@samsung.com>
        <CGME20220728093905epcas5p22963dd2dadb73bdabfaffc55cb2edef5@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a few missing fields which was added for uring command

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 src/include/liburing/io_uring.h | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 3953807..c923f5c 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -26,6 +26,10 @@ struct io_uring_sqe {
 	union {
 		__u64	off;	/* offset into file */
 		__u64	addr2;
+		struct {
+			__u32	cmd_op;
+			__u32	__pad1;
+		};
 	};
 	union {
 		__u64	addr;	/* pointer to buffer or iovecs */
@@ -69,8 +73,17 @@ struct io_uring_sqe {
 			__u16	addr_len;
 		};
 	};
-	__u64	addr3;
-	__u64	__pad2[1];
+	union {
+		struct {
+			__u64	addr3;
+			__u64	__pad2[1];
+		};
+		/*
+		 * If the ring is initialized with IORING_SETUP_SQE128, then
+		 * this field is used for 80 bytes of arbitrary command data
+		 */
+		__u8	cmd[0];
+	};
 };
 
 /*
-- 
2.17.1

