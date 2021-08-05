Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B433E1581
	for <lists+io-uring@lfdr.de>; Thu,  5 Aug 2021 15:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241669AbhHENQW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Aug 2021 09:16:22 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:48290 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241675AbhHENQV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Aug 2021 09:16:21 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210805131606epoutp0460f5b5378abacd18c9f2d1c5580f9ae0~Ya2l7BWv21865918659epoutp04S
        for <io-uring@vger.kernel.org>; Thu,  5 Aug 2021 13:16:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210805131606epoutp0460f5b5378abacd18c9f2d1c5580f9ae0~Ya2l7BWv21865918659epoutp04S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1628169366;
        bh=vQdZkBPLhY0UzukDC9s83ji74Yy5SNNf5rbTZ2kjsBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rMN7hLyOYu+sqO86+dnEJ16N5Cquk7lCMKCHDXpwRZE1EZERcdac+0fr75Bdrm4zV
         04TwJ8Bb6YjRFaJH9M8qugnE6ZKMkI6pvoWDEv7+syFVs/8TDg1V8kUAT/evRTnse9
         8YxuG2Q1DNwdn08T/CffXi4mGztHqlrZUFyKO3L0=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20210805131605epcas5p37413044dc12b751595cdbf7524c89a01~Ya2lRfmHv2675826758epcas5p3j;
        Thu,  5 Aug 2021 13:16:05 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4GgTdD74Z5z4x9Pq; Thu,  5 Aug
        2021 13:16:00 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4A.FB.40257.094EB016; Thu,  5 Aug 2021 22:16:00 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20210805125927epcas5p28f3413fe3d0a2baed37a05453df0d482~YaoEHTENx0613106131epcas5p2G;
        Thu,  5 Aug 2021 12:59:27 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210805125927epsmtrp12132f641dd0fdbcb2ad3b935b88e53c8~YaoEGczGu3021830218epsmtrp1V;
        Thu,  5 Aug 2021 12:59:27 +0000 (GMT)
X-AuditID: b6c32a49-ee7ff70000019d41-27-610be49023da
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        ED.84.32548.FA0EB016; Thu,  5 Aug 2021 21:59:27 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210805125926epsmtip1229841f11550310f64c942f9f168645c~YaoCppCuA1080510805epsmtip1A;
        Thu,  5 Aug 2021 12:59:26 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, javier.gonz@samsung.com, hare@suse.de
Subject: [RFC PATCH 3/6] io_uring: mark iopoll not supported for uring-cmd
Date:   Thu,  5 Aug 2021 18:25:36 +0530
Message-Id: <20210805125539.66958-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210805125539.66958-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAJsWRmVeSWpSXmKPExsWy7bCmuu6EJ9yJBncOyVg0TfjLbLH6bj+b
        xZ5Fk5gsVq4+ymTxrvUci8XjO5/ZLSYdusZoMX/ZU3aLK1MWMTtwelw+W+qxaVUnm8fmJfUe
        u282sHn0bVnF6LH5dLXH501yAexR2TYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbm
        Sgp5ibmptkouPgG6bpk5QHcpKZQl5pQChQISi4uV9O1sivJLS1IVMvKLS2yVUgtScgpMCvSK
        E3OLS/PS9fJSS6wMDQyMTIEKE7Iz7lxqZCl4yVoxdcps9gbG5yxdjJwcEgImEo9vrWXsYuTi
        EBLYzSix+9h1FgjnE6PExxfz2CGcz4wS2/7eZodpWXH6ATNEYhejRP/yPja4qmmrfgEN4+Bg
        E9CUuDC5FKRBRMBIYv+nk6wgNrNAtcTtB8vYQGxhAS+JtZ3dYDaLgKrEo+8nwGp4BSwk5q+e
        CHWfvMTMS9/BFnMKWEp8PrQXqkZQ4uTMJywQM+UlmrfOZoaob+WQ+Lk9DsJ2kfjdsYYNwhaW
        eHV8C9QDUhIv+9ug7GKJX3eOgj0jIdDBKHG9YSbUYnuJi3v+MoH8wgz0y/pd+hBhWYmpp9Yx
        Qezlk+j9/YQJIs4rsWMejK0ocW/SU1YIW1zi4YwlULaHxMdXq8BqhAR6GCXm7FCYwKgwC8k7
        s5C8Mwth8wJG5lWMkqkFxbnpqcWmBYZ5qeXwSE7Oz93ECE6qWp47GO8++KB3iJGJg/EQowQH
        s5IIb/JirkQh3pTEyqrUovz4otKc1OJDjKbA8J7ILCWanA9M63kl8YYmlgYmZmZmJpbGZoZK
        4rzs8V8ThATSE0tSs1NTC1KLYPqYODilGpiSln93OvLWRMzghgSv9O8z2S1pJuVSWcf8GQ8s
        /KkkkPF4c1LOvj2pyUzqAhaTS3+tmeV17fSkExfLW9/bbDxSNKXjRpjPEaEXq7tmCFxQmyVV
        dKYo7nggy/fHIXe4D2qx5Xyds0TzVd4OxRlfJL4YTbPfsG4Gk/G6Q10R6zmYjr1Vfn4xunVB
        4PzJhlcCPfhLHqcqRu/eLm+4k+fb62fHyi50Xixv4QyPiPp/YP2lKcs9M6Y3OzJ2RU3yf6HU
        vaC7Xs3+RNCi08XH1X8sbzoRe7PT8od8vW99nsLN/76biru35n1ecHeTe/eqrjALz+d3VMr5
        jl1OnJ30UlOjM0Gf//COR637/LZJKei/sLihxFKckWioxVxUnAgAZcgvpjMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsWy7bCSnO76B9yJBvM+qlo0TfjLbLH6bj+b
        xZ5Fk5gsVq4+ymTxrvUci8XjO5/ZLSYdusZoMX/ZU3aLK1MWMTtwelw+W+qxaVUnm8fmJfUe
        u282sHn0bVnF6LH5dLXH501yAexRXDYpqTmZZalF+nYJXBl3LjWyFLxkrZg6ZTZ7A+Nzli5G
        Tg4JAROJFacfMHcxcnEICexglHg2aQ1UQlyi+doPdghbWGLlv+fsEEUfGSVuvZvM2MXIwcEm
        oClxYXIpSI2IgJnE0sMgvVwczAKNjBLTn4BM5eQQFvCSWNvZzQZiswioSjz6foIVxOYVsJCY
        v3oi1DJ5iZmXvoMt4xSwlPh8aC8ryHwhoJqZWyMgygUlTs58AlbODFTevHU28wRGgVlIUrOQ
        pBYwMq1ilEwtKM5Nzy02LDDKSy3XK07MLS7NS9dLzs/dxAgOey2tHYx7Vn3QO8TIxMF4iFGC
        g1lJhDd5MVeiEG9KYmVValF+fFFpTmrxIUZpDhYlcd4LXSfjhQTSE0tSs1NTC1KLYLJMHJxS
        DUzdvSx2lcyKEuHCbK/nbk4pPlP0ZJJoaP5y32ZuE4tr03fGL5Pe+7HnZi7r82sbPwk/uyMU
        +1VGZfofhkVGHI6hk/fEeL5USNly6eLGQEXly4W/Ay5rNt/a5LH5RdOabw8Cmc6XqKhrGXnb
        LVi7689zB22Te8da94XWdTundh91CdIQ4fuV7qy+Q/Jzf98anj+lSZFLY8v4nY8tKbt+9v19
        /xzdz4ePaq58kBEStXh9S8mGI+2fXt2fUcgTdLOVdcaP/B37E+JO72nViDvXf7Al68BxhsjJ
        82r4f+XsUjx3/8dB0w+tO6OaPrI8mSqgN9Fm7mffb+kLvbfUrbLbceOM0ffmFoG3tgaTvHdH
        aWcrsRRnJBpqMRcVJwIAq6c4reoCAAA=
X-CMS-MailID: 20210805125927epcas5p28f3413fe3d0a2baed37a05453df0d482
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210805125927epcas5p28f3413fe3d0a2baed37a05453df0d482
References: <20210805125539.66958-1-joshi.k@samsung.com>
        <CGME20210805125927epcas5p28f3413fe3d0a2baed37a05453df0d482@epcas5p2.samsung.com>
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
index b73bc16c3e70..3361056313a7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3587,6 +3587,11 @@ static int io_uring_cmd_prep(struct io_kiocb *req,
 	if (!req->file->f_op->uring_cmd)
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

