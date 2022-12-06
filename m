Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE6A9644323
	for <lists+io-uring@lfdr.de>; Tue,  6 Dec 2022 13:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiLFMaV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Dec 2022 07:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbiLFMaS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Dec 2022 07:30:18 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316DB2934F
        for <io-uring@vger.kernel.org>; Tue,  6 Dec 2022 04:30:17 -0800 (PST)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20221206123015epoutp01df22eb1f995cbcee06d1cfeb9a83549d~uNB4dj2v50685806858epoutp01A
        for <io-uring@vger.kernel.org>; Tue,  6 Dec 2022 12:30:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20221206123015epoutp01df22eb1f995cbcee06d1cfeb9a83549d~uNB4dj2v50685806858epoutp01A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1670329815;
        bh=2mwn0Fqg5PmBYIXzudnNDG+eIKTOhTt9uKD8uPipNso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MrFwRCddNSop7DKhGbFl8d17Y4qM/pXAX67iOyQKPenJs6WjLzIkSbGMH1odQFfW/
         l76VgNtZ+1EsSTT3d8CC6hd88kRaP4l0fQ5NPBHt8hfzFMiQdbosEI7RgXNUf2nvPe
         wpGMoQDVJjTleOTN2FKX9gUzAisuiyn2st9cj4S0=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20221206123015epcas5p343f0b0efb06c6243e9848f9936698a97~uNB362XGP1347113471epcas5p3S;
        Tue,  6 Dec 2022 12:30:15 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4NRKWB0VnHz4x9Pp; Tue,  6 Dec
        2022 12:30:14 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4F.67.39477.4D53F836; Tue,  6 Dec 2022 21:30:12 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20221206123012epcas5p33de3600bbc6effa8e2a08f748cb0eee4~uNB1XkfnM1401814018epcas5p3G;
        Tue,  6 Dec 2022 12:30:12 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221206123012epsmtrp2cca541f76ded66a7caac13381cb55709~uNB1W87zz1795117951epsmtrp2X;
        Tue,  6 Dec 2022 12:30:12 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-05-638f35d45493
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F5.9E.18644.4D53F836; Tue,  6 Dec 2022 21:30:12 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221206123011epsmtip20a86e2ef526cbd9b81e522cc5a89ac2b~uNB0rrXc03142431424epsmtip2Y;
        Tue,  6 Dec 2022 12:30:11 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH liburing 2/2] test/io_uring_passthrough: cleanup invalid
 submission test
Date:   Tue,  6 Dec 2022 17:48:31 +0530
Message-Id: <20221206121831.5528-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221206121831.5528-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsWy7bCmpu4V0/5kg6vP9S1W3+1ns3jXeo7F
        4uj/t2wOzB6Xz5Z69G1ZxejxeZNcAHNUtk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6h
        pYW5kkJeYm6qrZKLT4CuW2YO0B4lhbLEnFKgUEBicbGSvp1NUX5pSapCRn5xia1SakFKToFJ
        gV5xYm5xaV66Xl5qiZWhgYGRKVBhQnbGowebWQv62CrmrLzL1MA4gbWLkZNDQsBEor91HVMX
        IxeHkMBuRolJy06zQTifGCV+bngL5XxmlHh65wBzFyMHWMvCHzkQ8V2MEpf+9rKBjAIr+nmA
        A6SGTUBT4sLkUpCwiICwxP6OVhaQMLOAo8T6Y6ogYWGBKInLHfPAwiwCqhIP39eAhHkFzCX6
        32xkgrhNXmLmpe/sICWcAhYSTR8tIUoEJU7OfMICYjMDlTRvnc0McoyEwDZ2iQNr5jJC9LpI
        bNq+HcoWlnh1fAs7hC0l8fndXjYIO1ni0sxzULtKJB7vOQhl20u0nupnhrhYU2L9Ln2IXXwS
        vb+fMEHCgFeio00IolpR4t6kp9DQFJd4OGMJlO0hMa31GDMknLoZJXbO+cE8gVF+FpIXZiF5
        YRbCtgWMzKsYJVMLinPTU4tNC4zyUsvhcZqcn7uJEZzStLx2MD588EHvECMTB+MhRgkOZiUR
        3hcbe5OFeFMSK6tSi/Lji0pzUosPMZoCQ3gis5Rocj4wqeaVxBuaWBqYmJmZmVgamxkqifMu
        ndKRLCSQnliSmp2aWpBaBNPHxMEp1cDktqN7qcXMewePx3ub7PwUc1jmvKND3l6+vYorl6+y
        qV0pv8Wz5UKpHKNL4pJgEaVTRyqS1cLfRm7Tqbi1Z1XohhkNPzjnBlVucV364ukx78hQu17R
        sw5HTMXcJENYS4o2hOn6qLNlvDkRnn7q0lJetwSdXW3Zed/D2HrTntdZVTCfZbh6R+1W2tPO
        m6XvSldLczvrvZw7ecetp45pVZ/uHJ13VZlBWV5jckGD+7Up7Cq2ts/OPBHa6N3C8vThxoz6
        VplHAWqJ1jPc3pT6tBluvh6quezNPTfxyQ5r80+uvbr6gPr78FT1nLbVM3fMmWcm73/XYF78
        NiGdoPZpnabrLLSjl3EJWxlfO71CRl6JpTgj0VCLuag4EQDsUI1l8gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrELMWRmVeSWpSXmKPExsWy7bCSvO4V0/5kg+1ThS1W3+1ns3jXeo7F
        4uj/t2wOzB6Xz5Z69G1ZxejxeZNcAHMUl01Kak5mWWqRvl0CV8ajB5tZC/rYKuasvMvUwDiB
        tYuRg0NCwERi4Y+cLkZODiGBHYwSb69IgdgSAuISzdd+sEPYwhIr/z1nh6j5yCgxt7EWpJVN
        QFPiwuRSkLAIUMn+jlYWEJtZwFli0t9XjCC2sECExLQXe9hAylkEVCUevq8BCfMKmEv0v9nI
        BDFdXmLmpe/sICWcAhYSTR8tIRaZS5y+tJQRolxQ4uTMJ1DT5SWat85mnsAoMAtJahaS1AJG
        plWMkqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMHBqKW1g3HPqg96hxiZOBgPMUpwMCuJ
        8L7Y2JssxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdC18l4IYH0xJLU7NTUgtQimCwTB6dUA9Py
        b42VgeIBy+aWnZGVtHz2Qi9q+yyDZ4uU5PUtWrgVgpo2yXEk8Be/WlBzwdD/1ZPzCy8uNKny
        djjFfmFrzcGald//nDrDo2IatNKlU//FxJVFpk3/DqYvrm5lubXJUUrn56/fz9sPzl94pvvl
        l4e7M7vkKlQez/OZe+pxj5ne+l0KvPpMMz/rfa1zeMLrXPW7ZkLF+p1HmyUnPF5f/XF/95Hr
        /fqPZ7VsuLVuvz7TDKsX2osXbTyzVv1wREnDrbKUXaF//n5MY21XUd0se91hWdA+GTPNhbv+
        HrqWd3fe7TcvK2VFXY5uNlgwcZKkoFlk/uYEy+vb9PxvTlx++lL6u+ZTaZ87mSQfMy/hMHB8
        rMRSnJFoqMVcVJwIAKWmXB21AgAA
X-CMS-MailID: 20221206123012epcas5p33de3600bbc6effa8e2a08f748cb0eee4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221206123012epcas5p33de3600bbc6effa8e2a08f748cb0eee4
References: <20221206121831.5528-1-joshi.k@samsung.com>
        <CGME20221206123012epcas5p33de3600bbc6effa8e2a08f748cb0eee4@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Just do away with setting IOPOLL as this is not necessary for the test.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 test/io_uring_passthrough.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/test/io_uring_passthrough.c b/test/io_uring_passthrough.c
index b58feae..7efdba1 100644
--- a/test/io_uring_passthrough.c
+++ b/test/io_uring_passthrough.c
@@ -286,8 +286,7 @@ static int test_invalid_passthru_submit(const char *file)
 	struct io_uring_sqe *sqe;
 	struct nvme_uring_cmd *cmd;
 
-	ring_flags = IORING_SETUP_IOPOLL | IORING_SETUP_SQE128;
-	ring_flags |= IORING_SETUP_CQE32;
+	ring_flags = IORING_SETUP_CQE32 | IORING_SETUP_SQE128;
 
 	ret = t_create_ring(1, &ring, ring_flags);
 	if (ret != T_SETUP_OK) {
-- 
2.25.1

