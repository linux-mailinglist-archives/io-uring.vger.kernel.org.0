Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028F56EB08F
	for <lists+io-uring@lfdr.de>; Fri, 21 Apr 2023 19:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbjDUR3B (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Apr 2023 13:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbjDUR27 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Apr 2023 13:28:59 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11hn2240.outbound.protection.outlook.com [52.100.172.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451B212C96
        for <io-uring@vger.kernel.org>; Fri, 21 Apr 2023 10:28:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ma/+6+K6EWanfJiDQ3iAF9GdVzQe96IljEUtd4ZcH8lBTme9lu7WivK3TD0mCozWnmBzCfzzT4muWC0f2ZWHJSrdDLLTsxAwTY5z9bc0P8Z7GgDaeMysNmQLiNvL4rV27/pnHFu/aHIVbykzbT5+H7DzKvFcNv0vDJ6TlSmG68krpFInp20r2DlU2JP6k5KUsE59JSVyuqMNYpQZ0ThD2dkl2fxXTdWZ+Zc5dWO2sgjWMwMmnoNVTbXD6t/Q/YvfLpRzW44bc6/UrAgdvYMDF0w86Efg3MIChSVCMwNZhQbXZWxjZtIUArrmyLJaWj8ahTHiXb7pfcU42ooUwunAIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8SCQpTpx/F5s9XjbpvvhyhUH25AOIwzSAYoqJ9tdsNs=;
 b=nCQS/d2k9dBSQEBU4KqL1Xw4u2BoIFjk3oxt9E60n5AcT0aJ0BcWPNbmEBPq74v9aVqveEH1DhLajXwu9N04faxCgUEMWkST31YaqiZNIUfa7EMO9htxFEGd+qE0Gn4h1B/oOi45soQam8ZHMizxTG2oEy6NN4QilE7eI0tB3SJwXVwq8GGjXF/NMRUmz5i5mAkSnCqI3OwXP4C5rTpKzqttfjZeYdsZ8Zx3266jL/uKUTFNI/JXyPKxXFt8VRHGLy8To/8Shnev1yoeLfccQsNXFN5rCMhZT+IBZ/EYgXY0NV3K1EAIXcPShJ/JXnpAncsshY7NA6QjU8+3Uj8EtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8SCQpTpx/F5s9XjbpvvhyhUH25AOIwzSAYoqJ9tdsNs=;
 b=ZwP8OyMDKtXQkRJjsNE5lK1GbdJPXm9qcqdHpWbrvMpeOlGFIGJIUo+I07lzgFUpINuwvsdXdlfp3ZTBBLfoENRlOddCthqdz9qR80uyQ+VdW4Fvmob0NyThmYTQVdi2jNMBQZD0XFOlQmaMHTfASfK4IAHlsvnxouzMdQHzqwl+rRQ1NqluxzSXj02XyhMNSEmlW+ERtQnFYVfJBJT36fPJACFpPxFHq3nQUTxhPySHozFK6nJVMmiIeD/YLj70+kjC01N+NnIlzGbpNUm70HJuIv3X0WSoTnD/ISnkrFNGOyz3hMqOZ6YEISaQViCpvMNTHgds16GDd4iDgP594A==
Received: from BN8PR15CA0023.namprd15.prod.outlook.com (2603:10b6:408:c0::36)
 by DS7PR12MB5814.namprd12.prod.outlook.com (2603:10b6:8:76::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.22; Fri, 21 Apr 2023 17:28:56 +0000
Received: from BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:c0:cafe::68) by BN8PR15CA0023.outlook.office365.com
 (2603:10b6:408:c0::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.25 via Frontend
 Transport; Fri, 21 Apr 2023 17:28:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT028.mail.protection.outlook.com (10.13.176.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.31 via Frontend Transport; Fri, 21 Apr 2023 17:28:55 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 21 Apr 2023
 10:28:46 -0700
Received: from dev.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 21 Apr
 2023 10:28:45 -0700
From:   Chaitanya Kulkarni <kch@nvidia.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        Chaitanya Kulkarni <kch@nvidia.com>
Subject: [RFC PATCH 1/1] io_uring: honor I/O nowait flag for read/write
Date:   Fri, 21 Apr 2023 10:28:22 -0700
Message-ID: <20230421172822.8053-2-kch@nvidia.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230421172822.8053-1-kch@nvidia.com>
References: <20230421172822.8053-1-kch@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT028:EE_|DS7PR12MB5814:EE_
X-MS-Office365-Filtering-Correlation-Id: e474d960-d985-4235-b9db-08db428de283
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5jIH6Y33oYXS9J50BZm3seBGlvhKKc086nMUZsdbfUzTBz6630cU/YVpKW+NOlF6hm4HFlDOv2GSPJcRYnheBi873Xg4SnwFxHy7P2XOjqrm0gW5QeXmCi3WptT7QhvZS2r1U0n/7nWT8qx9g0LgE5W16ioauHruR/XnFL4hHRqOZDwjmHqxps9tMDCpRe6Wg63Ii+zqQ+QyxbiUmhRkK2XUecSxwCNghYCFcQ2cXH/ycMS2RhsjBRV+tXtuFY5TpJvp2FAirQ4njTtw1Dqp1ON+Zo02KJ895/ZpTiK6fv/eTkG8/Ge6e/8piuKauvjuyr+sYS1mfTC5ik0idRsekehEoklJ0S9f2bTrt0nBAZBHmQ9dI5BNggX1xWfzTVYyXqy/p4/1RVgo7GSmMMSJkO5OUMYxGQmJYdo3qJbLUEfWfAXnjMyUldDB+tHnG8Q0ImzsDCZJgJ/nmg2xbGdNew7XjpcdO0KNuG/GIyu43XaL0JzwiFwd8ybsXB/A2BG7sJIsrjgUgHiI4rR/SbUyUGPkEPjzJSozdJ4kcADpti71wmmoKx6uNbaYaLjtK0+FsBrDEKb3yrBLzHkgFCsZ5yKExef7fFUHGZKC5nLTiPJrL7vqMOQg6nfEZt90EPAkPA1YorXdGDHsbtZDg06wckwXCVoEbZR2pt+mk/LepAOjOeApAfHYg0qs8G86x1plNEXbHiOIwh5b+LxtmMWhPKMr6Tbul3oz2c9KRVwjLa224XYgjUzZFjWwQV9HlHALgmZ4WueJ7M3Zb8ZjAYT2oZZFUfThtJxffFA+ZzshMdrdb59nD7W6lDOagOWE/ZQT
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(39860400002)(376002)(136003)(451199021)(5400799015)(40470700004)(36840700001)(46966006)(4326008)(70206006)(54906003)(6916009)(316002)(70586007)(478600001)(6666004)(7696005)(40480700001)(82310400005)(8936002)(41300700001)(8676002)(5660300002)(2906002)(7636003)(356005)(34020700004)(82740400003)(36756003)(2616005)(426003)(336012)(16526019)(26005)(40460700003)(1076003)(36860700001)(186003)(107886003)(47076005)(83380400001)(12100799030);DIR:OUT;SFP:1501;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 17:28:55.9131
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e474d960-d985-4235-b9db-08db428de283
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5814
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When IO_URING_F_NONBLOCK is set on io_kiocb req->flag in io_write() or
io_read() IOCB_NOWAIT is set for kiocb when passed it to the respective
rw_iter callback. This sets REQ_NOWAIT for underlaying I/O. The result
is low level driver always sees block layer request as REQ_NOWAIT even
if user has submitted request with nowait = 0 e.g. fio nowait=0.

That is not consistent behaviour with other fio ioengine such as
libaio as it will issue non REQ_NOWAIT request with REQ_NOWAIT:-

libaio nowait = 0:-
null_blk: fio:null_handle_rq 1288 *NOWAIT=FALSE* REQ_OP_WRITE

libaio nowait = 1:-
null_blk: fio:null_handle_rq 1288 *NOWAIT=TRUE* REQ_OP_WRITE

* Without this patch with fio ioengine io_uring :-
---------------------------------------------------

iouring nowait = 0:-
null_blk: fio:null_handle_rq 1288 *NOWAIT=TRUE* REQ_OP_WRITE

iouring nowait = 1:-
null_blk: fio:null_handle_rq 1288 *NOWAIT=TRUE* REQ_OP_WRITE

* With this patch with fio ioengine io_uring :-
---------------------------------------------------

iouring nowait = 0:-
null_blk: fio:null_handle_rq 1307 *REQ_NOWAIT=FALSE* WRITE

iouring nowait = 1:
null_blk: fio:null_handle_rq 1307 *REQ_NOWAIT=TRUE* WRITE

Instead of only relying on IO_URING_F_NONBLOCK blindly in io_read() and
io_write(), also make sure io_kiocb->io_rw->flags is set to RWF_NOWAIT
before we mark kiocb->ki_flags = IOCB_NOWAIT.

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 io_uring/rw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 3f118ed46e4f..4b3a2c1df5f2 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -745,7 +745,7 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	}
 	req->cqe.res = iov_iter_count(&s->iter);
 
-	if (force_nonblock) {
+	if (force_nonblock && (rw->flags & RWF_NOWAIT)) {
 		/* If the file doesn't support async, just async punt */
 		if (unlikely(!io_file_supports_nowait(req))) {
 			ret = io_setup_async_rw(req, iovec, s, true);
@@ -877,7 +877,7 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	}
 	req->cqe.res = iov_iter_count(&s->iter);
 
-	if (force_nonblock) {
+	if (force_nonblock && (rw->flags & RWF_NOWAIT)) {
 		/* If the file doesn't support async, just async punt */
 		if (unlikely(!io_file_supports_nowait(req)))
 			goto copy_iov;
-- 
2.40.0

