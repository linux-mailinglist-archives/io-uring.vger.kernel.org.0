Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF4F47B8B3
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 03:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbhLUC5D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Dec 2021 21:57:03 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:13212 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234113AbhLUC4z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Dec 2021 21:56:55 -0500
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20211221025653epoutp010d4683f75e7e620ef1f3f12b325d28d6~CpbWW2jLq1841718417epoutp01i
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 02:56:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20211221025653epoutp010d4683f75e7e620ef1f3f12b325d28d6~CpbWW2jLq1841718417epoutp01i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1640055413;
        bh=+fDobuNhmEqQD9o52/bcCFNDtnitrCw7j/s7XoX46j8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vYMuC7Ji92/wGbuXh0N6aoOoCzKlQCbvPlnRSfbYgvzveVkI8pdtChvQD8crKSJge
         Asn5AeimNgJPOFkUxMvbHVzKEUdkBpz86vVmd3lJ/Mlgy/pTGaf647suWgrJvGcqob
         HCSqxKYDXbuRjQUR03GGZgJZg/s26gJzqPM68wmk=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20211221025653epcas5p1719e87d09bfb48d21593ff5bce4a3e67~CpbV1OSFi0291802918epcas5p1c;
        Tue, 21 Dec 2021 02:56:53 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4JJ1M333RCz4x9Pp; Tue, 21 Dec
        2021 02:56:47 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        57.66.06423.C6241C16; Tue, 21 Dec 2021 11:56:44 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20211220142244epcas5p2f311ed168b8f31b9301bcc2002076db4~CfI4p3oaf1916119161epcas5p22;
        Mon, 20 Dec 2021 14:22:44 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211220142244epsmtrp11934831347aefccf2553b5dc3795b983~CfI4o8_Sa2445924459epsmtrp1i;
        Mon, 20 Dec 2021 14:22:44 +0000 (GMT)
X-AuditID: b6c32a49-b01ff70000001917-87-61c1426c83c5
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        86.65.08738.4B190C16; Mon, 20 Dec 2021 23:22:44 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20211220142242epsmtip19aa44cf774b51f0552270d47f9c773b1~CfI2s34xu0040000400epsmtip1g;
        Mon, 20 Dec 2021 14:22:42 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, javier@javigon.com,
        anuj20.g@samsung.com, joshiiitr@gmail.com, pankydev8@gmail.com
Subject: [RFC 08/13] io_uring: plug for async bypass
Date:   Mon, 20 Dec 2021 19:47:29 +0530
Message-Id: <20211220141734.12206-9-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211220141734.12206-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFJsWRmVeSWpSXmKPExsWy7bCmhm6O08FEg8ktahZNE/4yW6y+289m
        sXL1USaLd63nWCw6T19gsjj/9jCTxaRD1xgt9t7Stpi/7Cm7xZqbT1kcuDx2zrrL7tG84A6L
        x+WzpR6bVnWyeWxeUu+x+2YDm0ffllWMHp83yQVwRGXbZKQmpqQWKaTmJeenZOal2yp5B8c7
        x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gBdqKRQlphTChQKSCwuVtK3synKLy1JVcjILy6x
        VUotSMkpMCnQK07MLS7NS9fLSy2xMjQwMDIFKkzIzri4eD1bwUaWirv7vrM0MK5g7mLk5JAQ
        MJHoXnGFrYuRi0NIYDejxJZn79lBEkICnxgl1vQVQSQ+M0p8XLKYBabj1JXHjBCJXYwSpx+v
        ZoToAKpaMcO7i5GDg01AU+LC5FKQsIhAtMSF59fYQGxmgQ5GiZ3dtiC2MNCcbSeug8VZBFQl
        5s2ZDLaYV8BC4s+WK4wQu+QlZl76DhbnFLCUODx7GRtEjaDEyZlPWCBmyks0b53NDHKPhEAv
        h8SK20dYIZpdJA5/WwP1prDEq+Nb2CFsKYmX/W1QdrHErztHoZqBjrveMBPqS3uJi3v+MoE8
        wwz0zPpd+hBhWYmpp9YxQSzmk+j9/YQJIs4rsWMejK0ocW/SU6gbxCUezlgCZXtIrNg4FRrU
        PYwS/2btYZnAqDALyUOzkDw0C2H1AkbmVYySqQXFuempxaYFhnmp5fBITs7P3cQITrRanjsY
        7z74oHeIkYmD8RCjBAezkgjvltn7E4V4UxIrq1KL8uOLSnNSiw8xmgJDfCKzlGhyPjDV55XE
        G5pYGpiYmZmZWBqbGSqJ855O35AoJJCeWJKanZpakFoE08fEwSnVwMSvv65sbuTUG4ah/Gu+
        TfG18HS8F7VWwGnrq7A4vV1Lrl3OqanTXqIfmb7Cqnqt36mDP7S4fs7d/Mexsme214XVoTlF
        9/eq7TqzqTlOwY6ZRSOw67jBHGf7+9znXk/uVFf/9sLkEdsMRuH/T+OaX+9lMkn9qLX8+KPm
        xp1t4nyPt1qcX/L1jHGEi+aJ6/3/03es3TpnPw/QEXFOTav3+ASFri1fes7u0Z4UuaVrVCZ6
        TeAxm/fjSdGa/lsHcwvXeJcy7Pj262DjtgVXZ509GKmmxG6cFsL+7ur/pt3McT/FZ9/mWXHV
        9Ezagx8T1Eyaq8pYlmiescg/fbAqdYOb4mPNaO5HzC/Fyqw8XBiPliuxFGckGmoxFxUnAgBr
        jbdBPQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsWy7bCSnO6WiQcSDW5d57JomvCX2WL13X42
        i5WrjzJZvGs9x2LRefoCk8X5t4eZLCYdusZosfeWtsX8ZU/ZLdbcfMriwOWxc9Zddo/mBXdY
        PC6fLfXYtKqTzWPzknqP3Tcb2Dz6tqxi9Pi8SS6AI4rLJiU1J7MstUjfLoEr4+Li9WwFG1kq
        7u77ztLAuIK5i5GTQ0LAROLUlceMXYxcHEICOxglrq1oYoRIiEs0X/vBDmELS6z895wdougj
        o8SkI71MXYwcHGwCmhIXJpeC1IgIxEp8+HWMCaSGWWASo8SG/gdgzcJAG7aduM4GYrMIqErM
        mzMZLM4rYCHxZ8sVqGXyEjMvfQeLcwpYShyevQysXgio5sSHLywQ9YISJ2c+AbOZgeqbt85m
        nsAoMAtJahaS1AJGplWMkqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMHRoKW1g3HPqg96
        hxiZOBgPMUpwMCuJ8G6ZvT9RiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2amp
        BalFMFkmDk6pBqYGSUFBzXv/hY5udP1t0/Chwnx20xzzg1e8lsWvNDszdyPD7m+/n3i8DpFw
        +ROQrZ9VHunUJGH7+nrxkjmX9wW58d+pfBopO0N21Tn7vzstTDkVH39uCqxfzcL4b2nPrYBt
        MT5lEst+7zd8IziDiSEv7I/rTb92z9aTVpNvXbx7r+B9oe1MduVm418TlzHLLppx2+vwy0M7
        ZhSclX61x7RQVnV22dk2sZui2zgt87P+Njz9zFy1gm9Rp2LAApvU66uM9T7PN3u2a0LUeSfR
        lJr6Zu/saAHpMpXdh16l3bO8EsTrxCfytenFqw4+a9UpjKKsAvom3Szcmb9jBFJbNCQ6xbYv
        VmyapxB7YPOPi0osxRmJhlrMRcWJAC+rRI/1AgAA
X-CMS-MailID: 20211220142244epcas5p2f311ed168b8f31b9301bcc2002076db4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211220142244epcas5p2f311ed168b8f31b9301bcc2002076db4
References: <20211220141734.12206-1-joshi.k@samsung.com>
        <CGME20211220142244epcas5p2f311ed168b8f31b9301bcc2002076db4@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2870a891e441..f77dde1bdc75 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1121,10 +1121,12 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_URING_CMD] = {
 		.needs_file		= 1,
 		.offsets		= 1,
+		.plug			= 1,
 	},
 	[IORING_OP_URING_CMD_FIXED] = {
 		.needs_file		= 1,
 		.offsets		= 1,
+		.plug			= 1,
 	},
 };
 
-- 
2.25.1

