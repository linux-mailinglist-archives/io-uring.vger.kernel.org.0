Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E638581255
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 13:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbiGZLvF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 07:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbiGZLvE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 07:51:04 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBEE32EC3
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 04:50:58 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220726115055epoutp02f1ad338b3a6d8cd1c388bf0077c6c609~FXskclHID1333813338epoutp02P
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 11:50:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220726115055epoutp02f1ad338b3a6d8cd1c388bf0077c6c609~FXskclHID1333813338epoutp02P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1658836255;
        bh=BbbSWEM1xsOG1dLNo8znd6zXYJk4jY/HHeirk2IeknA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MM3leesZpAyOXUuyL4aoFvOWs26VQUw792EEZGo27o941QpSzIhdD93C/Pi9e5qDV
         OXW47ydOrpRNovnrvi1JxBfGrTsJdwp7W6iZAuGA3De66kt1eoG3ESNWyHhLMz0O73
         FF5UhlHIMCxwuSCuWiGdAv2cf8sy+5xUQDPzp/6c=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220726115055epcas5p1683dafeac76e0faefc591bfd66392d4d~FXskKY1tS2883728837epcas5p1I;
        Tue, 26 Jul 2022 11:50:55 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4LsZx82lDPz4x9Q9; Tue, 26 Jul
        2022 11:50:52 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D6.D9.09639.715DFD26; Tue, 26 Jul 2022 20:50:47 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220726105814epcas5p4b454a04c6f7befa23788b5a6bf3031c3~FW_kf06oc1109211092epcas5p4B;
        Tue, 26 Jul 2022 10:58:14 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220726105814epsmtrp202dbfe63d8a56e1d3669a898fa36c6ae~FW_kea03G3043430434epsmtrp2X;
        Tue, 26 Jul 2022 10:58:14 +0000 (GMT)
X-AuditID: b6c32a4b-e6dff700000025a7-cb-62dfd517b511
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        31.6E.08802.6C8CFD26; Tue, 26 Jul 2022 19:58:14 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220726105813epsmtip14c47e17146478e3c5d65bcf811ede824~FW_jydzvg1956919569epsmtip10;
        Tue, 26 Jul 2022 10:58:13 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH liburing v2 2/5] io_uring.h: sync sqe entry with 5.20
 io_uring
Date:   Tue, 26 Jul 2022 16:22:27 +0530
Message-Id: <20220726105230.12025-3-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220726105230.12025-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsWy7bCmuq741ftJBgc/SVusufKb3WL13X42
        i3et51gsjv5/y+bA4nH5bKlH35ZVjB6fN8kFMEdl22SkJqakFimk5iXnp2TmpdsqeQfHO8eb
        mhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYALVNSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2Cql
        FqTkFJgU6BUn5haX5qXr5aWWWBkaGBiZAhUmZGdM33WKqaCDo+L2pFPsDYyT2boYOTkkBEwk
        NjVdYgWxhQR2M0r8OBDWxcgFZH9ilOjft5IRwvnMKDF1YQMLTMeq9plsEIldjBJXHu5khXBa
        mSTaZ95hAqliE9CWePX2BjOILSIgLLG/oxWsm1kgSmLNq7OMILawQIDExXtHwGpYBFQlft1c
        DHYTr4CNxNRLrVD3yUus3nAArIZTwFai6eUUsGUSAvPYJW4+WMAOUeQi8fbMeqgGYYlXx7dA
        xaUkPr/bCxXPltj08CcThF0gceRFLzOEbS/ReqofyOYAOk5TYv0ufYiwrMTUU+uYIG7mk+j9
        /QSqlVdixzwYW1Xi773b0FCRlrj57iqU7SHRNWclNFAmMEr0dfewTmCUm4WwYgEj4ypGydSC
        4tz01GLTAuO81HJ4rCXn525iBCcoLe8djI8efNA7xMjEwXiIUYKDWUmENyH6fpIQb0piZVVq
        UX58UWlOavEhRlNgAE5klhJNzgemyLySeEMTSwMTMzMzE0tjM0MlcV6vq5uShATSE0tSs1NT
        C1KLYPqYODilGpgOnY5J37qkMGpFNIdQwxfreS2r9WtKZa+IT3v04fzFnfNKEyIqj+9uXfrn
        +7GOv0vPhnHsvHj9/py23kQtm4YlnsnCG7LuveN6uurdmr0Gyg/7n+VN+b/EtOdAso2XKoOZ
        3tuPObPS0r5wRbe/ZD3Y8K43bMnj4q/PFKdGXMr0YDJYKi1mpRap8v2I8C2fghtXpiicOVPo
        ejJ2juOE/XoX/KJm8WzZrNIas+Lxr1cFPyRml3TN7zJXnNbaviehofnSqwjRzJ2Pq5z2y617
        aeK89HBm7tEOwdnJ62718rI7XZuTuiiM6Szn59c84bxnbicv/sOf+uzXyQ6/Gz9SfT7+Ufzk
        N1+NNZFz+yHZS4G9SizFGYmGWsxFxYkANjbrq9kDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNJMWRmVeSWpSXmKPExsWy7bCSnO6xE/eTDLr3yFmsufKb3WL13X42
        i3et51gsjv5/y+bA4nH5bKlH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZUzfdYqpoIOj4vak
        U+wNjJPZuhg5OSQETCRWtc8Es4UEdjBKdG4V72LkAIpLSyxcnwhRIiyx8t9z9i5GLqCSZiaJ
        Ra8Os4Ik2AS0JV69vcEMYosAFe3vaGUBsZkFYiSmHjkMZgsL+ElsuPoezGYRUJX4dXMx2C5e
        ARuJqZdaoW6Ql1i94QDYHE4BW4mml1NYIe6xkfh76BjbBEa+BYwMqxglUwuKc9Nziw0LjPJS
        y/WKE3OLS/PS9ZLzczcxgsNHS2sH455VH/QOMTJxMB5ilOBgVhLhTYi+nyTEm5JYWZValB9f
        VJqTWnyIUZqDRUmc90LXyXghgfTEktTs1NSC1CKYLBMHp1QDk5mv8weOO7+Ph+m5CzUpPPmm
        GezixKUVeyusJZLtQ6JMWs1GLunsDyo+C/6IWf77JSy6rcy8r4LlmddfxYnT5dtF7A2zxfXd
        XmxdafeWQSrxkNing/JrBSRtkhneVNiyFHWsPj79t0b6zCDuy7Oq98917erX1bwh4LTolXfl
        +r0hLAFt1a95vnedqRFf+9xmXWa90P4H9xbwW9avknjgufBR+a09yeIizO5vGVKfb8u2Lvvx
        c9clrQVv0mJOf3kgZpmzZP2vk/N/+ixNj+vnTiydrxtu4qq5J6dvoebNIyYqGzZeDLY2398W
        fvS8tMoW983/FH48WMNUOC/h+pebW1XTX8Q6z/j73sndXbVQiaU4I9FQi7moOBEAbVBA8I4C
        AAA=
X-CMS-MailID: 20220726105814epcas5p4b454a04c6f7befa23788b5a6bf3031c3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220726105814epcas5p4b454a04c6f7befa23788b5a6bf3031c3
References: <20220726105230.12025-1-ankit.kumar@samsung.com>
        <CGME20220726105814epcas5p4b454a04c6f7befa23788b5a6bf3031c3@epcas5p4.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

