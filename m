Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFACA522C5B
	for <lists+io-uring@lfdr.de>; Wed, 11 May 2022 08:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241191AbiEKGb7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 May 2022 02:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239665AbiEKGb4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 May 2022 02:31:56 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE493ED19
        for <io-uring@vger.kernel.org>; Tue, 10 May 2022 23:31:55 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220511063153epoutp04a4a575fa5cc5063012fa6db72fc0d8e4~t_UUa9NHT1623716237epoutp04c
        for <io-uring@vger.kernel.org>; Wed, 11 May 2022 06:31:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220511063153epoutp04a4a575fa5cc5063012fa6db72fc0d8e4~t_UUa9NHT1623716237epoutp04c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1652250713;
        bh=8xiYrko6rIA/t1XZ8brbc5BcZyXVArJHEmfIcGi7GXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OKZvw5k2MgD0dt07ylW+XkTNE6mH7Yg0JJc/neQGP2KXnrAPArBETof7HFlhRhdh7
         d9kSgOJRNylUu8Q5lHkTgTqxdYwDpPv4y8WPV6C2sPyTYvwCFO3Yh9W7uhUIE3F4nF
         HfBdsQmBLm7/Lvr9Qsc1UOmuhbRCZMTzG5xIZL6I=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220511063152epcas5p1117b324bfab9f8ac49aeb900ae0c9661~t_UT41WE91834918349epcas5p10;
        Wed, 11 May 2022 06:31:52 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4KylS33zsCz4x9QK; Wed, 11 May
        2022 06:31:47 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        8F.86.09827.F485B726; Wed, 11 May 2022 15:31:43 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220511055320epcas5p2457aaf8e7405387282f60831f5a4eca9~t9yqoJiH92174421744epcas5p2c;
        Wed, 11 May 2022 05:53:20 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220511055320epsmtrp28b603b78544cb81e37bf42afd406d4d8~t9yqnGLdN1209712097epsmtrp2D;
        Wed, 11 May 2022 05:53:20 +0000 (GMT)
X-AuditID: b6c32a4a-b51ff70000002663-d6-627b584fd7fb
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        59.28.11276.05F4B726; Wed, 11 May 2022 14:53:20 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220511055319epsmtip1931e81a5c413546407ba038c230268c1~t9ypAEq_H2389123891epsmtip1M;
        Wed, 11 May 2022 05:53:19 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        shr@fb.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
Subject: [PATCH v5 6/6] io_uring: finish IOPOLL/ioprio prep handler removal
Date:   Wed, 11 May 2022 11:17:50 +0530
Message-Id: <20220511054750.20432-7-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220511054750.20432-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMJsWRmVeSWpSXmKPExsWy7bCmuq5/RHWSwfNbxhZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi/NvDzNZzF/2lN3ixoSnjBaHJjczWVx9eYDdgdtjYvM7
        do+ds+6ye1w+W+qxaVUnm8fmJfUeu282sHm833eVzaNvyypGj8+b5AI4o7JtMlITU1KLFFLz
        kvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COVVIoS8wpBQoFJBYXK+nb
        2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZ7y4uZyx4BxfxdEj
        a1kaGL9ydzFycEgImEi0XBDuYuTiEBLYzSix4mcjWxcjJ5DziVFi5zl1CPsbo8TK+2ogNkj9
        uhst7BANexkl7m7pY4RwPgN1377BCDKVTUBT4sLkUpAGEQF5iS+317KA1DALnGWUmHbrECtI
        QljAW+LHhh/sIDaLgKrEtwdPGUFsXgELiU1PbjNCbJOXmHnpO1gNp4ClxJbN89ghagQlTs58
        wgJiMwPVNG+dzQyyQEJgIYfElMadTBDNLhJ3zrxjhrCFJV4d38IOYUtJfH63lw3CTpZo3X6Z
        HRIUJRJLFqhDhO0lLu75ywQSZgb6Zf0ufYiwrMTUU+uYINbySfT+fgK1iVdixzwYW1Hi3qSn
        rBC2uMTDGUugbA+Jq3NWQcOqh1Fi6eoepgmMCrOQvDMLyTuzEFYvYGRexSiZWlCcm55abFpg
        lJdaDo/i5PzcTYzg1KvltYPx4YMPeocYmTgYDzFKcDArifDu76tIEuJNSaysSi3Kjy8qzUkt
        PsRoCgzvicxSosn5wOSfVxJvaGJpYGJmZmZiaWxmqCTOezp9Q6KQQHpiSWp2ampBahFMHxMH
        p1QDE4fEdB77h0pLw6Lfq86b9DpxT+EJhjs8rwQfbljOeM15yo2SFzfebL57e2rZAsHWyM42
        iS9s2/tskjWDd2nE36mf6FHQeml9tW30xeWnGrfdLTGM3LKtx8tin2fRu0mVNd/n3vjw6L3H
        28SV7adqnfJ0De5pa+g9zNi0P6a4p1f2j0GCQKCrXl3DAxO/P3lWF+9PmRVhV37i3beYxU9V
        7wi1nn1clPDM/tGrE1ILDx69NG9FUOjqNnk1nTm11eknF1Wnz/J/+eSZ0KdAweu+5yrDpTb9
        6P+hfeyg4sTGoPT9Zw/0GR8/4/l2atm+uT7PPJSNY/zSjDVyzX6GOokIBR14+Y+7IvL0wY+Z
        /DqS25RYijMSDbWYi4oTAdIiqUtGBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsWy7bCSnG6Af3WSwbE5hhZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi/NvDzNZzF/2lN3ixoSnjBaHJjczWVx9eYDdgdtjYvM7
        do+ds+6ye1w+W+qxaVUnm8fmJfUeu282sHm833eVzaNvyypGj8+b5AI4o7hsUlJzMstSi/Tt
        ErgyXtxczlhwjq/i6JG1LA2MX7m7GDk5JARMJNbdaGHvYuTiEBLYzSjxZ+N0JoiEuETztR/s
        ELawxMp/z6GKPjJK3P18k62LkYODTUBT4sLkUpAaEQFFiY0fmxhBapgFbjJKPG69xgySEBbw
        lvixAWIQi4CqxLcHTxlBbF4BC4lNT24zQiyQl5h56TtYDaeApcSWzfPAbCGgmqNLJrJB1AtK
        nJz5hAXEZgaqb946m3kCo8AsJKlZSFILGJlWMUqmFhTnpucWGxYY5qWW6xUn5haX5qXrJefn
        bmIEx4iW5g7G7as+6B1iZOJgPMQowcGsJMK7v68iSYg3JbGyKrUoP76oNCe1+BCjNAeLkjjv
        ha6T8UIC6YklqdmpqQWpRTBZJg5OqQYmGeH5SfMTDRdvZ33He+nhqudlk9tuXj5orfT17orA
        IvMc08D6Xr6TV9NPazDrP1n+SXWlwuN2w6vtIhs6NaJbF0wuF99R+Gn7469/n4mbmGmvuuEd
        GVvPbHPf//rDwN2mB40XNOx598cn/PmC64Ufw6NOhHzf/ryrj12m+5f9jrvt29Wbo6aLn/l2
        ozIofbvgT/PZB3Zsb+eRuOPw5KhhkqVIwZ9/q2fd2+zywfTOq6y7LGu0sx4eWFW7crGI+Vn5
        WSnh00xvHekUfHdakqGKsWkr/xL9bc25bFp3E80O7FZSe69iX27n/uF0nOWZ4O4N58vyt+kd
        Yp54fgVvfG7T5B3COhOf7be3OvimsK0oXYmlOCPRUIu5qDgRANfl9XEAAwAA
X-CMS-MailID: 20220511055320epcas5p2457aaf8e7405387282f60831f5a4eca9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220511055320epcas5p2457aaf8e7405387282f60831f5a4eca9
References: <20220511054750.20432-1-joshi.k@samsung.com>
        <CGME20220511055320epcas5p2457aaf8e7405387282f60831f5a4eca9@epcas5p2.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

Commit 73911426aaaa unified the checking of this, but was done before we
had a few new opcode handlers.

Finish the job and apply it to the xattr/socket/uring_cmd handlers as
well so we check and use this fully consistently.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 592be5b89add..44c57dca358d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4517,10 +4517,6 @@ static int __io_getxattr_prep(struct io_kiocb *req,
 	const char __user *name;
 	int ret;
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (unlikely(sqe->ioprio))
-		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
 
@@ -4630,10 +4626,6 @@ static int __io_setxattr_prep(struct io_kiocb *req,
 	const char __user *name;
 	int ret;
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (unlikely(sqe->ioprio))
-		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
 
@@ -4968,7 +4960,7 @@ static int io_uring_cmd_prep(struct io_kiocb *req,
 {
 	struct io_uring_cmd *ioucmd = &req->uring_cmd;
 
-	if (sqe->ioprio || sqe->rw_flags)
+	if (sqe->rw_flags)
 		return -EINVAL;
 	ioucmd->cmd = sqe->cmd;
 	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
@@ -6405,9 +6397,7 @@ static int io_socket_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_socket *sock = &req->sock;
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->addr || sqe->rw_flags || sqe->buf_index)
+	if (sqe->addr || sqe->rw_flags || sqe->buf_index)
 		return -EINVAL;
 
 	sock->domain = READ_ONCE(sqe->fd);
-- 
2.25.1

