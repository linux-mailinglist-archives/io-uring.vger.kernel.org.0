Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB93C47B8A6
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 03:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbhLUC4Y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Dec 2021 21:56:24 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:14346 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234062AbhLUC4Y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Dec 2021 21:56:24 -0500
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20211221025622epoutp04e355c7096f154adb4f51b7994dee3341~Cpa5n1pco1357613576epoutp04Z
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 02:56:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20211221025622epoutp04e355c7096f154adb4f51b7994dee3341~Cpa5n1pco1357613576epoutp04Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1640055382;
        bh=qQzwQeVQ/rdLDuaJEMVGex5uan9oUlYhMcsCMT4pHTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iICAsI8DuKsC4HnxcA9MaNABeW26BnhwRk5VMoa1I/xSM543bwArrco7Iq3mJHRnK
         nkggI/9eknIZ3v4ncEHIdrTvMuA3Cn4OPyJpi3Nebt9Zhc6KXICqRCVSHdqkQjr8Oa
         xzSYoAL3oYgYN5hXnXMXRRLou8fK/5aYa+39yoiI=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20211221025622epcas5p26a3cf5e78abbd536c0cd175200d05009~Cpa5Mihas2587925879epcas5p2W;
        Tue, 21 Dec 2021 02:56:22 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4JJ1LV4CKSz4x9Q5; Tue, 21 Dec
        2021 02:56:18 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        57.26.06423.25241C16; Tue, 21 Dec 2021 11:56:18 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20211220142233epcas5p3b54aa591fb7b81bfb58bc33b5f92a2d3~CfIuf3uti0906209062epcas5p31;
        Mon, 20 Dec 2021 14:22:33 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211220142233epsmtrp17a48a03437f0a58e0662ed249523ee12~CfIueRL9p2445924459epsmtrp1Y;
        Mon, 20 Dec 2021 14:22:33 +0000 (GMT)
X-AuditID: b6c32a49-b13ff70000001917-0c-61c142525b00
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        64.85.29871.9A190C16; Mon, 20 Dec 2021 23:22:33 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20211220142231epsmtip1c9366a0b7d0e3606cbcec7cdeb8c370e~CfIsWcVoS0637406374epsmtip1r;
        Mon, 20 Dec 2021 14:22:31 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, javier@javigon.com,
        anuj20.g@samsung.com, joshiiitr@gmail.com, pankydev8@gmail.com
Subject: [RFC 03/13] io_uring: mark iopoll not supported for uring-cmd
Date:   Mon, 20 Dec 2021 19:47:24 +0530
Message-Id: <20211220141734.12206-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211220141734.12206-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNJsWRmVeSWpSXmKPExsWy7bCmpm6Q08FEg66pChZNE/4yW6y+289m
        sXL1USaLd63nWCw6T19gsjj/9jCTxaRD1xgt9t7Stpi/7Cm7xZqbT1kcuDx2zrrL7tG84A6L
        x+WzpR6bVnWyeWxeUu+x+2YDm0ffllWMHp83yQVwRGXbZKQmpqQWKaTmJeenZOal2yp5B8c7
        x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gBdqKRQlphTChQKSCwuVtK3synKLy1JVcjILy6x
        VUotSMkpMCnQK07MLS7NS9fLSy2xMjQwMDIFKkzIzpjcdImx4CVrxdJN21kbGJ+zdDFyckgI
        mEhs/vmdqYuRi0NIYDejxK8LKxkhnE+MEntXn2CGcL4xSuzrfcsG07Km4ykrRGIvo8Ssy5NZ
        IJzPjBIdB3cCtXBwsAloSlyYXArSICIQLXHh+TWwZmaBDkaJnd22ILawgJvE4+fvWUDKWQRU
        JaYszwIJ8wpYSByZ0cgMsUteYual7+wgNqeApcTh2cvYIGoEJU7OfMICMVJeonnrbLBDJQQm
        ckhMev4A6lAXiba/P9khbGGJV8e3QNlSEi/726DsYolfd45CNQPddr1hJjRg7CUu7vnLBHIc
        M9Av63fpQ4RlJaaeWscEsZhPovf3EyaIOK/EjnkwtqLEvUmgAAKxxSUezlgCZXtIfHt5BBpW
        PYwSvz9NYJ3AqDALyUOzkDw0C2H1AkbmVYySqQXFuempxaYFhnmp5fBYTs7P3cQITrVanjsY
        7z74oHeIkYmD8RCjBAezkgjvltn7E4V4UxIrq1KL8uOLSnNSiw8xmgIDfCKzlGhyPjDZ55XE
        G5pYGpiYmZmZWBqbGSqJ855O35AoJJCeWJKanZpakFoE08fEwSnVwKQ5/TTzmvzjf107Phbm
        Pk5RO5IldeduzI/QW9M6lqjMkSwNTOZXk1jAWdVf5fKu5pflbiWzgP1XD3wNna+3eetrLt/c
        zvTChzMKdsl273ZM+H7jRXzJyp2rtwfKC/kley3XfX9YPzfgX+aL535XVnsFbrm4/jdf4/Wj
        fhsn3ZjNbr3iWFTsM7fOvq6qU/0T5ywOzXtg8Si84H+T/uVZx97+0Z6m759y2XmX7MLJqcJ9
        teKHL+hlHym913u16cmS+anrJ87n+88n8DVjVui9fPtVG+3eJjNV9Mb9vO54/ZxwfIrKKYm1
        W9vPJxe6KJ7a8N30XJWo6ItplU/d9xol7/g2M9Voa5Lcnsrg5lW1+w4rsRRnJBpqMRcVJwIA
        SNOzMz4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWy7bCSnO7KiQcSDdbu4bVomvCX2WL13X42
        i5WrjzJZvGs9x2LRefoCk8X5t4eZLCYdusZosfeWtsX8ZU/ZLdbcfMriwOWxc9Zddo/mBXdY
        PC6fLfXYtKqTzWPzknqP3Tcb2Dz6tqxi9Pi8SS6AI4rLJiU1J7MstUjfLoErY3LTJcaCl6wV
        SzdtZ21gfM7SxcjJISFgIrGm4ylrFyMXh5DAbkaJL9ua2SAS4hLN136wQ9jCEiv/PWeHKPrI
        KLHl0RugDg4ONgFNiQuTS0FqRARiJT78OsYEUsMsMIlRYkP/A7BmYQE3icfP37OA1LMIqEpM
        WZ4FEuYVsJA4MqORGWK+vMTMS9/ByjkFLCUOz14GdoMQUM2JD19YIOoFJU7OfAJmMwPVN2+d
        zTyBUWAWktQsJKkFjEyrGCVTC4pz03OLDQsM81LL9YoTc4tL89L1kvNzNzGCY0FLcwfj9lUf
        9A4xMnEwHmKU4GBWEuHdMnt/ohBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeC10n44UE0hNLUrNT
        UwtSi2CyTBycUg1MjqLWNZtYlVV9kryiz/v+ymMJCpBkPlkacMGW5ejhPKXbYQuX+rEzP2Y9
        ut8zs+fEFV1PmfsZMsc+ZfxJL5vlVhL5o92Nd1vn5/P5W3JrOFLfBqw68Pzj7btnWySZClRq
        PrIZvjN987tV/i136m+XoC0vGExX11+t3ZK4a/P8qZrcXe1m7fGG/CXx5w8ttsnrv1//cpe9
        zcG1BovEXA8fOXdz4gw1nr8zolNsHB7L7WEI5H6q3HvlxhZr/mf7u7Of9S1tWfU3WKLKjuF3
        9ZcPZ10ZftexG8tPE5A3jfxax9unx72wa17uAfYLW5esdyxqazmXr8U9id0smmtVy3fzd3Vv
        P+isWOho1VjU/FyJpTgj0VCLuag4EQBUGjSQ9AIAAA==
X-CMS-MailID: 20211220142233epcas5p3b54aa591fb7b81bfb58bc33b5f92a2d3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211220142233epcas5p3b54aa591fb7b81bfb58bc33b5f92a2d3
References: <20211220141734.12206-1-joshi.k@samsung.com>
        <CGME20211220142233epcas5p3b54aa591fb7b81bfb58bc33b5f92a2d3@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Anuj Gupta <anuj20.g@samsung.com>

Currently uring-passthrough doesn't support iopoll. Bail out to avoid
the panic.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/io_uring.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 246f1085404d..1061b4cde4be 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4131,6 +4131,11 @@ static int io_uring_cmd_prep(struct io_kiocb *req,
 	if (!req->file->f_op->async_cmd)
 		return -EOPNOTSUPP;
 
+	if (req->ctx->flags & IORING_SETUP_IOPOLL) {
+		printk_once(KERN_WARNING "io_uring: iopoll not supported!\n");
+		return -EOPNOTSUPP;
+	}
+
 	cmd->op = READ_ONCE(csqe->op);
 	cmd->len = READ_ONCE(csqe->len);
 
-- 
2.25.1

