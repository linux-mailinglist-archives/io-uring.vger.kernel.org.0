Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C813E6EB08E
	for <lists+io-uring@lfdr.de>; Fri, 21 Apr 2023 19:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbjDUR2u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Apr 2023 13:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbjDUR2t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Apr 2023 13:28:49 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12hn2207.outbound.protection.outlook.com [52.100.165.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C0912C96
        for <io-uring@vger.kernel.org>; Fri, 21 Apr 2023 10:28:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LrvJoX1PVyxGKJgamJioEgH2NAwupCyCjhiebyxzrEX5v5oDzBDu6XSPBFQsjI1I6oIz05Q2jyO1TjOUiwPFELCdEQWZil2oPg+spGuUOM+zybtzzTNZxWUSOjmLQ7iipssHVT0uqd9uAv9a9wuL3i64afMnwuK0k47D0+hsqiFJNAQCqKppd/CCWNnb/3zCQhPTrBZ9YroK3sZgU9Gx75sH+YgLjrGVm6xBqtbmvx3b77Wo+vzStQjvPciE4aa5gIhb1Znamzb1IPfuB0RSMybJPdNtXO9Ru45Cial/rwynYqyOfaNnysavmjtIRAPo1ftnHGC37IELxnTP+Re2+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WydmrbgLt/V7s5q9zqNPyPvQvvv2NAJ7xKabZfxBehQ=;
 b=ZRuPgL2k9zH8ZMVHQoV2UzBF2JtnuFYHit2C1dpaSnK+lD0hjBvnjKwgJ4iTYMHwcdgnnNX1/63U8oL+LcYtbW4kvWyzgMfGk87yqbj0WC47pOYGUm/N4QGqeX1XoWhKJSJDyiuA1+S2R+4UeLwwM42L5x/idMoX4IFtHfaLU7qm0JzK/FQPJ6ZnneFypzVzoz5gN3VyzVZhZEyFYCtTru4NmiIhLY14j5Wwq7pg4v+IrbfZ7Xe57RPjp/t88wrgxBYpYnObQIXqktEuYmla1ZJntjtbcayGzk7xJ5EegZlHnw7gY8+dXL3GBKcANRrres4s7oidtiB+BlFxQEROiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WydmrbgLt/V7s5q9zqNPyPvQvvv2NAJ7xKabZfxBehQ=;
 b=PiAztDm7UOYiq/XIh+PoF5Wwlnq5IAGJmM3qACr4Xvjnqt+scQBctL4QLcCw6pg+x5OOaW03KrXbacesPb6MZn66OjM9BCPuWdgQKl/v2AaeV2tqoSWZ9XCAtXOIgxFCSkofg9zqpFS6WxYILUZ6or3I2VKycshHiUpBsgvojDgI5aHeJy/TN4uutqk7qxOLVOgXT6Ud6YGrgFcIh90xr1BtC0LPVcqAIuOg9B5pUMbb5eISFdNROFhSMQUCo5nBg6U4yhiUodlRK1qF51ekxE6bSHY/WxKah2YNhw7RsIhsq+NiF3yXXxyP571hQAQwZxSNWl3tF8dcal0Ewg68UQ==
Received: from DM6PR13CA0018.namprd13.prod.outlook.com (2603:10b6:5:bc::31) by
 MW4PR12MB7014.namprd12.prod.outlook.com (2603:10b6:303:218::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.21; Fri, 21 Apr 2023 17:28:46 +0000
Received: from DM6NAM11FT097.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:bc:cafe::72) by DM6PR13CA0018.outlook.office365.com
 (2603:10b6:5:bc::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.14 via Frontend
 Transport; Fri, 21 Apr 2023 17:28:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT097.mail.protection.outlook.com (10.13.172.72) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.27 via Frontend Transport; Fri, 21 Apr 2023 17:28:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 21 Apr 2023
 10:28:34 -0700
Received: from dev.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 21 Apr
 2023 10:28:34 -0700
From:   Chaitanya Kulkarni <kch@nvidia.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        Chaitanya Kulkarni <kch@nvidia.com>
Subject: [RFC PATCH 0/1] io_uring: honor I/O nowait flag for read/write
Date:   Fri, 21 Apr 2023 10:28:21 -0700
Message-ID: <20230421172822.8053-1-kch@nvidia.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT097:EE_|MW4PR12MB7014:EE_
X-MS-Office365-Filtering-Correlation-Id: f27e3af2-80f9-439a-461a-08db428ddc70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IquX6zSPhmTXDMkRZtjO+sIDFQ9hlEXQ36ih56C8cS4UrKhLSnPzVUxXmzNBRFcsd1vtilRU2Uhm6kbAWp3n/BqyvyF+nnD85Vf9ayrWHIR12Uhfyj4GvaRwlCDuOdzbdqgNBFXRPuJ7oGue3Kb27l2rEAZl3avP7W5+tFf/Zg1va8/4ua+8Zm1q9wq7wHywd0Q+SaU0RBiLqmqtj551pzVaEe/dYRZTPCgx8V1EAcZDZBOdbziJbIVxsgo/4TuodSi3qryXTH/X5ekdCo6YQzvt3tvqTwUmcSB8QY3hbchjWgvmQm4iHalhBKJQqftrTlTOKrr/Zp4L7mmYC+faM8KeX2lX7sr1EYZByIN+NScIshWbdygE+pq3vsDeVyPA1IqauFn+g1ct6a9Ww4gVW84YHvKRLvMO0s/ynEGx8bXrROG8u+XytHIBcq6zLffz9stdh/3BdnZz9KCyu83Xgijt/0nppPEMI71P82wfJDSiaKexAnBFDyRVQt3NRLQxU36tQnl4TGUHaJiYMVT/61CpuzD8iIHjWPURr2i6ZeOhEdrtZRRXXsqRe/mcAFzsP6cnmB6ybiHDfCuJaVOx0DMiQpxAvmQZSnaFwEvuqONSePJbV0c7WNji+kss+cTjLRlZF6bj5bCzHmDMVPctaasbFNvBgXBxLVa1jVqSJlVqTfLjGXC538sUsltFX4G+sYOSvvjSOr3+hS97eDAaOIXIP2L5M2qIOeYnQGuC7CcrfQ7wSLMe0xNV3qr4cg+VEUys27FXPWv3aejc2UaKsOgUvVz+2NC+OMTsHVAPoeQJ4Ib1Z1EvIloF0Earr856
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(39860400002)(396003)(451199021)(5400799015)(46966006)(36840700001)(40470700004)(40480700001)(40460700003)(6916009)(316002)(70206006)(34020700004)(4326008)(41300700001)(2906002)(8676002)(426003)(356005)(5660300002)(70586007)(8936002)(107886003)(83380400001)(336012)(7696005)(6666004)(26005)(186003)(1076003)(2616005)(36860700001)(54906003)(47076005)(478600001)(16526019)(82310400005)(36756003)(7636003)(82740400003)(12100799030);DIR:OUT;SFP:1501;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 17:28:45.7818
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f27e3af2-80f9-439a-461a-08db428ddc70
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT097.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7014
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

Hi,

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

Below is the deatailed testing log.

-ck

Chaitanya Kulkarni (1):
  io_uring: honor I/O nowait flag for read/write

 io_uring/rw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

$ sh test-iouring-no-wait
* Without this patch :-
#######################
-------------------libaio nowait = 0--------------------------

++ grep -e ioengine -e rw -e nowait fio/randwrite-libaio-nowait-0.fio
ioengine=libaio
rw=randwrite
nowait=0   <-----------------------------
overwrite=0
++ fio fio/randwrite-libaio-nowait-0.fio --filename=/dev/nullb0
++ grep err
RANDWRITE: (groupid=0, jobs=1): err= 0: pid=40835: Thu Apr 20 21:31:09 2023
++ dmesg -c
[17978.613789] null_blk: disk nullb0 created
[17978.613814] null_blk: module loaded
__________________________________________________________________________
[17978.796560] null_blk: fio:null_handle_rq 1288 *NOWAIT=FALSE* REQ_OP_WRITE

-------------------libaio nowait = 1--------------------------

++ blkdiscard /dev/nullb0
++ grep -e ioengine -e rw -e nowait fio/randwrite-libaio-nowait-1.fio
ioengine=libaio
rw=randwrite
nowait=1   <-----------------------------
overwrite=0
++ fio fio/randwrite-libaio-nowait-1.fio --filename=/dev/nullb0
++ grep err
RANDWRITE: (groupid=0, jobs=1): err= 0: pid=40842: Thu Apr 20 21:31:09 2023
++ dmesg -c
__________________________________________________________________________
[17979.019595] null_blk: fio:null_handle_rq 1288 *NOWAIT=TRUE* REQ_OP_WRITE

-------------------iouring nowait = 0--------------------------

++ blkdiscard /dev/nullb0
++ grep -e ioengine -e rw -e nowait fio/randwrite-iouring-nowait-0.fio
ioengine=io_uring
rw=randwrite
nowait=0   <-----------------------------
overwrite=0
++ fio fio/randwrite-iouring-nowait-0.fio --filename=/dev/nullb0
++ grep err
RANDWRITE: (groupid=0, jobs=1): err= 0: pid=40849: Thu Apr 20 21:31:10 2023
++ dmesg -c
__________________________________________________________________________
[17979.242849] null_blk: fio:null_handle_rq 1288 *NOWAIT=TRUE* REQ_OP_WRITE

-------------------iouring nowait = 1--------------------------

++ blkdiscard /dev/nullb0
++ grep -e ioengine -e rw -e nowait fio/randwrite-iouring-nowait-1.fio
ioengine=io_uring
rw=randwrite
nowait=1   <-----------------------------
overwrite=0
++ fio fio/randwrite-iouring-nowait-1.fio --filename=/dev/nullb0
++ grep err
RANDWRITE: (groupid=0, jobs=1): err= 0: pid=40856: Thu Apr 20 21:31:10 2023
++ dmesg -c
__________________________________________________________________________
[17979.454102] null_blk: fio:null_handle_rq 1288 *NOWAIT=TRUE* REQ_OP_WRITE

* With this patch :-
####################
-------------------iouring nowait = 0--------------------------
+ blkdiscard /dev/nullb0
+ grep -e ioengine -e rw -e nowait fio/randwrite-iouring-nowait-0.fio
ioengine=io_uring
rw=randwrite
nowait=0   <-----------------------------
overwrite=0
+ fio fio/randwrite-iouring-nowait-0.fio --filename=/dev/nullb0
+ grep err
RANDWRITE: (groupid=0, jobs=1): err= 0: pid=2788: Thu Apr 20 23:35:40 2023
+ dmesg -c
__________________________________________________________________________
[  164.255136] null_blk: fio:null_handle_rq 1307 *REQ_NOWAIT=FALSE* WRITE
-------------------iouring nowait = 1--------------------------
+ blkdiscard /dev/nullb0
+ grep -e ioengine -e rw -e nowait fio/randwrite-iouring-nowait-1.fio
ioengine=io_uring
rw=randwrite
nowait=1   <-----------------------------
overwrite=0
+ fio fio/randwrite-iouring-nowait-1.fio --filename=/dev/nullb0
+ grep err
RANDWRITE: (groupid=0, jobs=1): err= 0: pid=2795: Thu Apr 20 23:35:41 2023
+ dmesg -c
__________________________________________________________________________
[  164.467420] null_blk: fio:null_handle_rq 1307 *REQ_NOWAIT=TRUE* WRITE


-- 
2.40.0

