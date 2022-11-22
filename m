Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C190633A50
	for <lists+io-uring@lfdr.de>; Tue, 22 Nov 2022 11:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiKVKlu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Nov 2022 05:41:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232870AbiKVKkz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Nov 2022 05:40:55 -0500
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8DC5DBBD
        for <io-uring@vger.kernel.org>; Tue, 22 Nov 2022 02:35:39 -0800 (PST)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20221122103537euoutp01107f279b67efc5fe802b99f5e8d68162~p4bya6plF1716017160euoutp01d
        for <io-uring@vger.kernel.org>; Tue, 22 Nov 2022 10:35:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20221122103537euoutp01107f279b67efc5fe802b99f5e8d68162~p4bya6plF1716017160euoutp01d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1669113337;
        bh=ukr95FvjHp9T4vWMYC+S93/K/TYCn3nOZHCdPWgfXB0=;
        h=From:To:CC:Subject:Date:References:From;
        b=fRi7s+c4VAWITiWgnWCv/MiQMILKHmR+o9Ta969RQwQb5ntHTZKsHliWsDo9MZehZ
         TveDPlDqsuxWewNFFfA1l5YTIHwGxFgPG9lW12ap04Ymz6ZzuKWN8cBJRkulHAbHpG
         Y0H5awFQ2R/0wTsELKpYEakAOBnMlvk9rqMCwHas=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20221122103536eucas1p17457201f2e5ed32f8fcc0b0b7e47f4b7~p4byNtDXa0149301493eucas1p1m;
        Tue, 22 Nov 2022 10:35:36 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 00.2E.09561.8F5AC736; Tue, 22
        Nov 2022 10:35:36 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20221122103536eucas1p2a0bc5ebdf063715f063e5b6254d0b058~p4bx4dqCf0354803548eucas1p22;
        Tue, 22 Nov 2022 10:35:36 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221122103536eusmtrp265da2d93bc9e98274bb4427a31be3183~p4bx33Kdj1081210812eusmtrp2_;
        Tue, 22 Nov 2022 10:35:36 +0000 (GMT)
X-AuditID: cbfec7f2-0b3ff70000002559-f0-637ca5f8de50
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id C5.0D.08916.8F5AC736; Tue, 22
        Nov 2022 10:35:36 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221122103536eusmtip2bc320b9a6f1b2dfbda748f2aee0ecbbc~p4bxr5LH52937029370eusmtip2P;
        Tue, 22 Nov 2022 10:35:36 +0000 (GMT)
Received: from localhost (106.110.32.33) by CAMSVWEXC02.scsc.local
        (2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Tue, 22 Nov 2022 10:35:28 +0000
From:   Joel Granados <j.granados@samsung.com>
To:     <mcgrof@kernel.org>, <ddiss@suse.de>, <joshi.k@samsung.com>,
        <paul@paul-moore.com>
CC:     <ming.lei@redhat.com>, <linux-security-module@vger.kernel.org>,
        <axboe@kernel.dk>, <io-uring@vger.kernel.org>,
        Joel Granados <j.granados@samsung.com>
Subject: [RFC v2 0/1] RFC on how to include LSM hooks for io_uring commands
Date:   Tue, 22 Nov 2022 11:31:43 +0100
Message-ID: <20221122103144.960752-1-j.granados@samsung.com>
X-Mailer: git-send-email 2.30.2
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [106.110.32.33]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
        CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42LZduzned0fS2uSDR5uNbBYfbefzeLr/+ks
        Fu9az7FYfOh5xGZxY8JTRotDk5uZLG5Pms7iwO5x+Wypx6ZVnWwea/e+YPR4v+8qm8fm09Ue
        nzfJBbBFcdmkpOZklqUW6dslcGU8n/GcrWAjX8XPfrsGxuXcXYycHBICJhKX3vWzdjFycQgJ
        rGCUeDptHytIQkjgC6PEzefCEInPjBK7Zq9m72JkB+v4EwFRspxR4tb1UAgbqGTTHWWI8s2M
        Eo82rWQDSbAJ6Eicf3OHGcQWEYiQ2PTmFztIEbPAXEaJux9ugSWEBbwljq1bALaYRUBV4uGv
        RSwgNq+AjcTT7R/YIC6Vl2i7Pp2xi5EDqFlTYv0ufYgSQYmTM5+AlTMDlTRvnc0MUa4osWXO
        d1YIu1bi1JZbTCB7JQTucEj8OLUFqshFYsvyQ1DzhSVeHd/CDmHLSPzfOZ8Jws6W2DllF1R9
        gcSsk1PZQG6QELCW6DuTAxF2lNi5sREqzCdx460gxDl8EpO2TWeGCPNKdLQJQVSrSexo2so4
        gVF5FsIvs5D8MgvJLwsYmVcxiqeWFuempxYb5qWW6xUn5haX5qXrJefnbmIEppnT/45/2sE4
        99VHvUOMTByMhxglOJiVRHjrPWuShXhTEiurUovy44tKc1KLDzFKc7AoifOyzdBKFhJITyxJ
        zU5NLUgtgskycXBKNTBN7V72YxLHpJULdhuG7/9ScDpwleLe9UqLyqeorb6e1TXzxqvjvQx7
        hNvtOJdtSI/NzP55tYH/f2TbDr5co8k37pl6Fkpt5XrMHPnkygTtiR9sf2w8vGvVe0N25w31
        go4dj/S+Hjn9yr3qwmOxmmxptY2vdpxQuDB99fa9ov7R13WmzemV7L4/wcz78ZOzM6x06u7r
        l0wOZH3VZCFXP3V+QJQ2M4NTrORni0uaKUlinu4FTefvMT2s4/pwQ3u9ruJ9ddWXcX/5M3My
        /zodU43Zt9Kjh4//0deAGYdZN96PLO79/Ihn1hoN9ZlPXhhqdr+8aXCdrVc2cKZ7alAJX8yR
        WEbr898ttn4wZ/q8y0dTiaU4I9FQi7moOBEAjSukraIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsVy+t/xe7o/ltYkGzw4IGGx+m4/m8XX/9NZ
        LN61nmOx+NDziM3ixoSnjBaHJjczWdyeNJ3Fgd3j8tlSj02rOtk81u59wejxft9VNo/Np6s9
        Pm+SC2CL0rMpyi8tSVXIyC8usVWKNrQw0jO0tNAzMrHUMzQ2j7UyMlXSt7NJSc3JLEst0rdL
        0Mt4PuM5W8FGvoqf/XYNjMu5uxjZOSQETCT+RHQxcnIICSxllPjyzQPElhCQkfh05SM7hC0s
        8edaF1sXIxdQzUdGid6/yxghnM2MEnPefGICqWIT0JE4/+YOM4gtIhAhsenNL3aQImaBuYwS
        dz/cAksIC3hLHFu3gBXEZhFQlXj4axELiM0rYCPxdPsHNoh18hJt16cDbeAAataUWL9LH6JE
        UOLkzCdg5cxAJc1bZzNDlCtKbJnznRXCrpX4/PcZ4wRGoVkI3bOQdM9C0r2AkXkVo0hqaXFu
        em6xoV5xYm5xaV66XnJ+7iZGYGxtO/Zz8w7Gea8+6h1iZOJgPMQowcGsJMJb71mTLMSbklhZ
        lVqUH19UmpNafIjRFOibicxSosn5wOjOK4k3NDMwNTQxszQwtTQzVhLn9SzoSBQSSE8sSc1O
        TS1ILYLpY+LglGpg4jQXynxztuTIw/uqm4I5HzTdW2VbWbJFdEvDNhZ+D/464a8C29MW6Lsz
        Njr1K7Y+VI64znmAZyPrx7v3FLS4jkWcSjdwEzih0Z60SGJJ3YlpSscvxa6Ss0y2efTxmm9l
        /S3v/GAfrtT0grPfLl1P/Rco8GZ9yFGBRiYl8TNHck+tsDEparP8ujHyjqVhY6qycnnI0tUH
        Hc67X9p6dl/o+clLeyRePsncbmpVUzhpeazRd9EXm5az+ofKBqZ8mSBlXDB/djpv+KadH1ZM
        Nr+yRFy3/vT7FfPP9a3N4Eze7eZwQrffSc/SrPB+Rvte29lvZZv53Fv1+X0yjmyr31IzoTXP
        TiD/0rFid0Gb5wpKLMUZiYZazEXFiQBuYmKPNgMAAA==
X-CMS-MailID: 20221122103536eucas1p2a0bc5ebdf063715f063e5b6254d0b058
X-Msg-Generator: CA
X-RootMTR: 20221122103536eucas1p2a0bc5ebdf063715f063e5b6254d0b058
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20221122103536eucas1p2a0bc5ebdf063715f063e5b6254d0b058
References: <CGME20221122103536eucas1p2a0bc5ebdf063715f063e5b6254d0b058@eucas1p2.samsung.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The motivation for this patch is to continue the discussion around how to
include LSM callback hooks in the io_uring infrastructure. This is the
second version of the RFC and is meant to elicit discussion. I'll leave
general questions and the descriptions of the different approaches.
Comments are greatly appreciated

Approaches:
V2: I add a callback to the file_operations struct that will set a
security_uring structure with all the elements needed for LSMs to make a
decision. io_uring is still agnostic as it will just pass the callback
along and LSM can just focus on getting the data they need in the uring
security struct. When security is not defined in CONFIG the
security_uring_cmd can just be a noop (or itself be in an ifdef).

V1: I take the nvme io_uring passthrough and try to include it in the
already existing LSM infrastructure that is there for ioctl. This is far
from a general io_uring approach, but its a start :)

Questions:
1. Besides what is contained in the patch, would there be something
additional to plumb in LSM?

2. Is this general enough to fit all io_uring passthrough commands?

3. I'm trying to separate responsabilities. The LSM folks can take care of
LSM stuff and the io_uring users can take care of their specific domain.
Does this patch fulfill this?

4. Are there other approaches to solve this problem?

Joel Granados (1):
  Use a fs callback to set security specific data

 drivers/nvme/host/core.c      | 10 ++++++++++
 include/linux/fs.h            |  2 ++
 include/linux/lsm_hook_defs.h |  3 ++-
 include/linux/security.h      | 16 ++++++++++++++--
 io_uring/uring_cmd.c          |  3 ++-
 security/security.c           |  5 +++--
 security/selinux/hooks.c      | 16 +++++++++++++++-
 7 files changed, 48 insertions(+), 7 deletions(-)

-- 
2.30.2

