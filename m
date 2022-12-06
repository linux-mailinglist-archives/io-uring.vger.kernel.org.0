Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64DFB644321
	for <lists+io-uring@lfdr.de>; Tue,  6 Dec 2022 13:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbiLFMaO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Dec 2022 07:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiLFMaN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Dec 2022 07:30:13 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E8129374
        for <io-uring@vger.kernel.org>; Tue,  6 Dec 2022 04:30:10 -0800 (PST)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20221206123008epoutp014c42a7a7385e0fbdee6dcf22b3c64554~uNBx4OOiP0685806858epoutp017
        for <io-uring@vger.kernel.org>; Tue,  6 Dec 2022 12:30:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20221206123008epoutp014c42a7a7385e0fbdee6dcf22b3c64554~uNBx4OOiP0685806858epoutp017
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1670329808;
        bh=OJyToWtcKodjEuLVkIZoffzPAVSa14wd4sffaYSQvnU=;
        h=From:To:Cc:Subject:Date:References:From;
        b=afSGOdMDKYCNRw9kVwsVHa4Huho/grZgC+zd2RO304tB8GRWBrww8mQH98wNtKFaV
         fLnPiKVewKDHiw1aCSsSP3l1m9hcM9qoeMQB966OSjKcMQWANJjmb0czPsq6JRmHqe
         f5GIMrBNjFGETb/SA5RVRFlGr2dIvqBEBFW8Ffjg=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20221206123008epcas5p4d2882596b2cbdf2e9100ad43e5a78da1~uNBxW7wZD0906209062epcas5p41;
        Tue,  6 Dec 2022 12:30:08 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4NRKW26Vt5z4x9Pp; Tue,  6 Dec
        2022 12:30:06 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3E.FF.01710.DC53F836; Tue,  6 Dec 2022 21:30:05 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20221206123005epcas5p474a1374f850c47f2c9af5ef8c8cc6509~uNButNXYL1128511285epcas5p4p;
        Tue,  6 Dec 2022 12:30:05 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221206123005epsmtrp297551b292d0c35fdad63f67e081793f1~uNBuslq-Z1795117951epsmtrp2R;
        Tue,  6 Dec 2022 12:30:05 +0000 (GMT)
X-AuditID: b6c32a49-a41ff700000006ae-c6-638f35cdb65b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E3.33.14392.DC53F836; Tue,  6 Dec 2022 21:30:05 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221206123004epsmtip2a83b5a6bd3fb74c06587e1804df56f93~uNBt_eDH_2684326843epsmtip2k;
        Tue,  6 Dec 2022 12:30:03 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH liburing 0/2] passthrough test fix and cleanup
Date:   Tue,  6 Dec 2022 17:48:29 +0530
Message-Id: <20221206121831.5528-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMKsWRmVeSWpSXmKPExsWy7bCmuu5Z0/5kg1m75CxW3+1ns3jXeo7F
        4uj/t2wOzB6Xz5Z69G1ZxejxeZNcAHNUtk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6h
        pYW5kkJeYm6qrZKLT4CuW2YO0B4lhbLEnFKgUEBicbGSvp1NUX5pSapCRn5xia1SakFKToFJ
        gV5xYm5xaV66Xl5qiZWhgYGRKVBhQnbG/7XHmQt+MlVcmdjO2sC4iamLkZNDQsBE4vLM5Ywg
        tpDAbkaJk7O1uxi5gOxPjBIr2vqZIBLfGCUOnpOAaZjTeoEJomgvo0T/7gWMEM5nRokjWz+w
        dzFycLAJaEpcmFwK0iAiICyxv6OVBSTMLOAosf6YKkhYWMBOYuLdn2wgNouAqsTK2xfBdvEK
        mEtcuPCeEWKXvMTMS9/ZIeKCEidnPmEBsZmB4s1bZzODrJUQmMcucXzXRlaQ+RICLhJ///pC
        9ApLvDq+hR3ClpL4/G4vG4SdLHFp5jmo50skHu85CGXbS7Se6meGOFNTYv0ufYhVfBK9v58w
        QUznlehoE4KoVpS4N+kpK4QtLvFwxhIo20Oi+cINaKjFSjxae5RtAqPcLCQPzELywCyEZQsY
        mVcxSqYWFOempxabFhjmpZbD4zE5P3cTIzh1aXnuYLz74IPeIUYmDsZDjBIczEoivC829iYL
        8aYkVlalFuXHF5XmpBYfYjQFhupEZinR5Hxg8swriTc0sTQwMTMzM7E0NjNUEuddOqUjWUgg
        PbEkNTs1tSC1CKaPiYNTqoGpbUb5+egFFbv/l3uZuiybN2vfPKf8h/9n9Jf5+v6watH8O/Nw
        F7Mya0jMbSuWRQbh1rWbPPe+8ry81X135LyD15Q26CgJnZHK7VrqckajN+P0T+MPryxEmWTN
        l86WT6yI61vr/PftQh4l89DMFadn6T91vGh3yNQl75TomyRxGdtIiYUr7ti6Rf43/MCmWyLV
        Urq16cr8FYumGqe+9P7OUWRqPtGxfP/+4LPzNGPUZT9EJ/6beUqPTSb3ZoGuVfDC5cLJfqfv
        5Ea0OIRtOSnFmcCofsXlqfTXJ08mzBN8kDPXrXyyCyvX8iLtPafnZptILfv+dOmbs5xeDrPn
        ua0zbRLeqz3jSLmmzc2i5jglluKMREMt5qLiRADVS3So5gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnluLIzCtJLcpLzFFi42LZdlhJXvesaX+ywf5XHBar7/azWbxrPcdi
        cfT/WzYHZo/LZ0s9+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+P/2uPMBT+ZKq5MbGdtYNzE
        1MXIySEhYCIxp/UCkM3FISSwm1Hi9+GV7BAJcYnmaz+gbGGJlf+es0MUfWSU+PNpJlAHBweb
        gKbEhcmlIDUiQDX7O1pZQGxmAWeJSX9fMYLYwgJ2EhPv/mQDsVkEVCVW3r4ItphXwFziwoX3
        jBDz5SVmXvrODhEXlDg58wnUHHmJ5q2zmScw8s1CkpqFJLWAkWkVo2RqQXFuem6xYYFhXmq5
        XnFibnFpXrpecn7uJkZwmGlp7mDcvuqD3iFGJg7GQ4wSHMxKIrwvNvYmC/GmJFZWpRblxxeV
        5qQWH2KU5mBREue90HUyXkggPbEkNTs1tSC1CCbLxMEp1cC0MeloxltevghJL+33S38Zqpyx
        2BU1M2fZNMEp5j6v3kh8dGxP9efZfD/Dx2JXxZXNSkGzJTnEjj28o8qa/0zGs9NSdvKe0CMB
        swz1rfr44swM7zlsPb1ET3rJSpX2z/kMB/4GZ0YaReduLNkp9MMvpUJOoyWt+WzsS9lLEuxS
        v19wCUZ+tV4m4qR0Mc1Lzf3IaqtNm4yazk6p3Lh94YdlxzyuXPH+3Lvv9dy46jOxd+r/na1j
        sPzDclT3x/9zbc6Xgz5s4MyfZsDxcpmRCre1t6KRw5zl99a1GOg93r2H8XLUb6UrVe/l1hRk
        6eoWudRydjCUuf07vFLhRG6bz2rGJYwcZUqrFz6WtWoMnKHEUpyRaKjFXFScCAD62Ar7ogIA
        AA==
X-CMS-MailID: 20221206123005epcas5p474a1374f850c47f2c9af5ef8c8cc6509
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221206123005epcas5p474a1374f850c47f2c9af5ef8c8cc6509
References: <CGME20221206123005epcas5p474a1374f850c47f2c9af5ef8c8cc6509@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

This series does a fix in test/io_uring_passthrough.c and a minor
cleanup too.
Please take a look.

Kanchan Joshi (2):
  test/io_uring_passthrough: fix iopoll test
  test/io_uring_passthrough: cleanup invalid submission test

 test/io_uring_passthrough.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

-- 
2.25.1

