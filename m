Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3142D59EAA8
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 20:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbiHWSNR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 14:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbiHWSMp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 14:12:45 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537329C2E7
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 09:25:18 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220823162513epoutp0118912721fa60a1b16346807d3d5f3e97~OBgDdjda10451204512epoutp01e
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 16:25:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220823162513epoutp0118912721fa60a1b16346807d3d5f3e97~OBgDdjda10451204512epoutp01e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1661271913;
        bh=Vlg7RjwsSm838OJBc8ZvpdV0ePSO3S5EX14/Jkn77YA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VwRaGtrGd9mjEJqk8GJCaoRWG4V97ksKrzNEeag0WS3Cl363K8GFR/4QcwlHN7j5z
         pSLnh3IVytG8JhDIRw48EU8pQUN1jiT/gOw8ln0/QK2X0Zu55zKQirCHP9e3PlPEZw
         VKFKCJVKLUCqBuRwX9cLCAMCxAEbKPlXjRAG6d70=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220823162512epcas5p2399704c8759e8de5eb9dba160180c223~OBgCuW6N_1154711547epcas5p2C;
        Tue, 23 Aug 2022 16:25:12 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4MBvhj1Bq7z4x9Pw; Tue, 23 Aug
        2022 16:25:09 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        69.15.18001.56FF4036; Wed, 24 Aug 2022 01:25:09 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220823162508epcas5p3ae39903d3ee1079134fb70ed675159fc~OBf-RSsx52674026740epcas5p37;
        Tue, 23 Aug 2022 16:25:08 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220823162508epsmtrp1f5707276f5118361bd3228cdf2339b3c~OBf-QWshH2270522705epsmtrp1H;
        Tue, 23 Aug 2022 16:25:08 +0000 (GMT)
X-AuditID: b6c32a4a-2c3ff70000004651-f0-6304ff65fc0d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        91.A2.18644.46FF4036; Wed, 24 Aug 2022 01:25:08 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220823162507epsmtip2cc532be7b3229f2cf757628788163b72~OBf93tghM3113431134epsmtip2V;
        Tue, 23 Aug 2022 16:25:07 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v3 1/4] fs: add file_operations->uring_cmd_iopoll
Date:   Tue, 23 Aug 2022 21:44:40 +0530
Message-Id: <20220823161443.49436-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220823161443.49436-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHJsWRmVeSWpSXmKPExsWy7bCmhm7qf5Zkg6NP2SzmrNrGaLH6bj+b
        xc0DO5ksVq4+ymTxrvUci8XR/2/ZLCYdusZosfeWtsX8ZU/ZLQ5NbmZy4PLYOesuu8fls6Ue
        m1Z1snlsXlLvsftmA5vH+31X2Tz6tqxi9Pi8SS6AIyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzje
        Od7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoQiWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJ
        rVJqQUpOgUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsb/9ltsBXtYK15dPcHUwHiUpYuRk0NC
        wESiZXsHYxcjF4eQwG5GiVfXV7FCOJ8YJZ4sfc8M4XxmlDjzfSpcy+XN69ghErsYJf6v7mWH
        q7py6ypQPwcHm4CmxIXJpSANIgJeEvdvvwcbyyywllHi9N4vTCAJYaDEwcXLwWwWAVWJaTMu
        s4LYvAIWEv9eb2CE2CYvMfPSd3aQmZwClhKnD8pBlAhKnJz5BOwgZqCS5q2zwS6VEJjIIdHf
        sp8ZotdF4vnhuWwQtrDEq+Nb2CFsKYmX/W1QdrLEpZnnmCDsEonHew5C2fYSraf6mUH2MgP9
        sn6XPsQuPone30+YQMISArwSHW1CENWKEvcmPWWFsMUlHs5YAmV7SFy5sQcaoj2MEg/X9LNO
        YJSfheSFWUhemIWwbQEj8ypGydSC4tz01GLTAqO81HJ4xCbn525iBCdULa8djA8ffNA7xMjE
        wXiIUYKDWUmE1+oYS7IQb0piZVVqUX58UWlOavEhRlNgEE9klhJNzgem9LySeEMTSwMTMzMz
        E0tjM0Mlcd4p2ozJQgLpiSWp2ampBalFMH1MHJxSDUzTDnyPfDhn8a6/D/Keifz8N7uryyfp
        Q6bAQZGWjXYWxRd5Jxd0v7YMOPy97oDJctO/W/XM5K4oryiOljO4Yl/lGDtBWfS8pHDE7/W5
        v5e6sEyet+bHqTauSENxx7nREj27FgUoPZK9JSb7mXnthCK+9D/zvVdrr3X3mHn9xQztvj23
        fqpPr41X7ZM8oLJ3f0PFh5SrTHx+n7RzGxLecNedUGX3DHx+6tXvr3HTalWuLVJImF7GPbNv
        0zyv1+rJLja+0yMzyyYYBTx5N6N81rvUj9P8VE/vzLnInLCSO1Dl6rnpkzk2CcZ8mic4y6ey
        ZaHiGw7W/YaX3CYy2VbyBdZkZfKdW/v/2LlZYqc/Cv9QYinOSDTUYi4qTgQAducbzTEEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWy7bCSvG7Kf5Zkg6ZGPYs5q7YxWqy+289m
        cfPATiaLlauPMlm8az3HYnH0/1s2i0mHrjFa7L2lbTF/2VN2i0OTm5kcuDx2zrrL7nH5bKnH
        plWdbB6bl9R77L7ZwObxft9VNo++LasYPT5vkgvgiOKySUnNySxLLdK3S+DK+N9+i61gD2vF
        q6snmBoYj7J0MXJySAiYSFzevI69i5GLQ0hgB6PEk427mCAS4hLN136wQ9jCEiv/PYcq+sgo
        cfv+J+YuRg4ONgFNiQuTS0FqRAQCJA42XgarYRbYzCjx6fQxZpCEsICXxMHFy8GGsgioSkyb
        cZkVxOYVsJD493oDI8QCeYmZl76zg8zkFLCUOH1QDiQsBFTyZ1MDG0S5oMTJmU/AjmYGKm/e
        Opt5AqPALCSpWUhSCxiZVjFKphYU56bnFhsWGOWllusVJ+YWl+al6yXn525iBMeCltYOxj2r
        PugdYmTiYDzEKMHBrCTCa3WMJVmINyWxsiq1KD++qDQntfgQozQHi5I474Wuk/FCAumJJanZ
        qakFqUUwWSYOTqkGpviVd4KK04ujNJeZsgctl188/1tqALN9v8rcsBkqZ1SWsp9s5RO3DJ2w
        tt1mv+ShrhXzJi8NenZS/NP7EnnXcCGr27cex15lar3Bf69XTLp6EYPr2v/xQfddp7YzTfrp
        HrqKk1t4ic7pDzmfuU3+vvqwdU/q7CivzDUfLt1ztbB1vfT/3YNzR813N+VsznmSmlS8uYEr
        96+NHFNDLRN/Bl/lXdP9+6++y2jsCY7+byCou2TtjNiT55dv3q6z/JJ5hbCRto/c4mtCqwX6
        zko8zNR6vcNAIeFgJN9VdqYclukxa2pubtmU0elXoKN1Mros4fqq4PO5Blmx+4rLvh9YUnb3
        CKesddWUYzHyLNteK7EUZyQaajEXFScCAO91dEb0AgAA
X-CMS-MailID: 20220823162508epcas5p3ae39903d3ee1079134fb70ed675159fc
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220823162508epcas5p3ae39903d3ee1079134fb70ed675159fc
References: <20220823161443.49436-1-joshi.k@samsung.com>
        <CGME20220823162508epcas5p3ae39903d3ee1079134fb70ed675159fc@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring will invoke this to do completion polling on uring-cmd
operations.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/linux/fs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9eced4cc286e..d6badd19784f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2132,6 +2132,7 @@ struct file_operations {
 				   loff_t len, unsigned int remap_flags);
 	int (*fadvise)(struct file *, loff_t, loff_t, int);
 	int (*uring_cmd)(struct io_uring_cmd *ioucmd, unsigned int issue_flags);
+	int (*uring_cmd_iopoll)(struct io_uring_cmd *ioucmd);
 } __randomize_layout;
 
 struct inode_operations {
-- 
2.25.1

