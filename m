Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE836DF780
	for <lists+io-uring@lfdr.de>; Wed, 12 Apr 2023 15:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbjDLNl7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Apr 2023 09:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjDLNl5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Apr 2023 09:41:57 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2043.outbound.protection.outlook.com [40.107.96.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525FE5B93;
        Wed, 12 Apr 2023 06:41:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S7dQ6i8ERKm5Nihj9NtJILKzULilYBipSU0X37XbCA2UW/yFRZ5y5FTdkZA7c1MQfeeUGmFkMqvgs7gvt3U2CyusgPSNoeVI68ivfEIKv8vLG4O05MPnoml4c+p7/dfGfOHf+eky8iRsmm6YxF43dxyMcWsUxxnvmal8xZNePRGTCKrFJDi3tM4eqpGwVCrq5Qs17uVheWYU6LpIUHMO6XKCqBVOtIvXkUZ/eQZDeoiJAiV5XVkBaleaSdvLYR64plwPVeZ9WD2Plq+A+pc2zy3ZeV9s8VOjy3p+raAU/Z4P1hL5fGfD7sSs85GofPsfxYDIbmvWiftx+4UcR+M5mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6NtRM6foZVF7dirdFvnADX4sX/vedPPdl7yQXNLwDEw=;
 b=a+ZMLE2eG94509lG88G2rYPVgIv3Ozz3B7WVBYOiHodhJX31O0IorKQRgIAVpXuSu/XZXYbc336qDWskrgOGsOH+lKFbHIclBCUV1wfan4F+rdM0k5hxvO1kpXGcnz7eMZgKDccvxoYNMvEMy97auZIx1KMxFON6XSH4Q8LMhy3AbCTFnKf6nEi5lVMOrnZPSzHm8TQ19g8Gb3ADOGRxYdzrk8ox102a86uw1b9BKkOn+wqt6J2AowoWCFTm6t0B6QDJgwxgGc0SzpnNgOChhxuYMwVvYrg9DiqyR5nD5BGm1nsM5AVRZuu40dew9Ry3AShPSMiKAMaBU5ydGfuaVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6NtRM6foZVF7dirdFvnADX4sX/vedPPdl7yQXNLwDEw=;
 b=Sm8tLO4sZMy+nvNoH3FlqqNXdZ6rZv8Wtu0ovdakcNunjEVu8H6U+Vnab6NrJHKJaAgHNgQ4J2ZS6SyWdNZg95DUlr6wqFWBlTbe/BObdetfFNN8gnz5pwIeQMgB61Sw+yOl07GYzFY3cAs1HdjJ+k6WSLOiNHo+g8D6BFCoHgs=
Received: from DM6PR07CA0108.namprd07.prod.outlook.com (2603:10b6:5:330::14)
 by SN7PR19MB6879.namprd19.prod.outlook.com (2603:10b6:806:260::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Wed, 12 Apr
 2023 13:41:42 +0000
Received: from DM6NAM04FT062.eop-NAM04.prod.protection.outlook.com
 (2603:10b6:5:330:cafe::77) by DM6PR07CA0108.outlook.office365.com
 (2603:10b6:5:330::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.40 via Frontend
 Transport; Wed, 12 Apr 2023 13:41:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mx01.datadirectnet.com; pr=C
Received: from uww-mx01.datadirectnet.com (50.222.100.11) by
 DM6NAM04FT062.mail.protection.outlook.com (10.13.158.72) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.31 via Frontend Transport; Wed, 12 Apr 2023 13:41:41 +0000
Received: from localhost (unknown [10.68.0.8])
        by uww-mx01.datadirectnet.com (Postfix) with ESMTP id 4C8B920C687A;
        Wed, 12 Apr 2023 07:42:49 -0600 (MDT)
From:   Bernd Schubert <bschubert@ddn.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        dsingh@ddn.com, bschubert@ddn.com
Subject: [PATCH 1/2] fs: add FMODE_DIO_PARALLEL_WRITE flag
Date:   Wed, 12 Apr 2023 15:40:57 +0200
Message-Id: <20230412134057.381941-1-bschubert@ddn.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230307172015.54911-2-axboe@kernel.dk>
References: <20230307172015.54911-2-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM04FT062:EE_|SN7PR19MB6879:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: f40167ea-4c4d-43fa-c74e-08db3b5ba633
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dz7Tqvn2HDepCbqgEBoyFPVHorpGCDi1kxQKIufW+IHlhsdGDvJZvVvWOX60rfAl0murbmLVm5CTL8KQKZVNQl3ce0xGoJ+gSvRfFCWuOv/254Y8OfWDi2Q5yltMq8KooaEhu3TfkedqNyXBQvfGXihEuNPtCos69hxN2Ewb39UVyFmbEhMhsSl2pTKw7NV/mUrDZye5drQFfwrIuQbJeQIciEk366s0zd7TcpAGMa/rALPSt00byBwb6Ngc32UujVYedGnZ7q22jg0YJFlOAiqODpNFJwUW0GlytDyKpBu4UxyR6KnxYN1f9FHXEeeK0A1Ms8t3uYOW3+uTxHqiRtLp8isb3tD/EZrKYrIuv/kxnloa6UkoOYftsTjcl0vNd36qY0WpU5Y1ht7iNJow2GSmiuzSnM8HTip3GRK1ExcPlL7aBW0U3ImwTsq4V0oHJdTcNu8466kvs44SL3DxEDnasCxMkOUxs8P5BIE3Uj3w9qrb/8/g7rjnvxMoA4PNkSVqc2wxvQzF8gOO4AqWNlP9c+6NTq5qohwKsQUMhOqpc5sIi/YTJhlj3c6Hi+z3q5yun8IV7kiu74ojA8tsMB1SJSRQdD7DncIt4wXGsK43pMsQ8XanQEHhxqE4XkgRt8kU5PUqSSSu0ywW63X+wmHfILAg0F0060EqvgSo5fC5zsh1wuRn7gTV6L4pXL/r63/BB6zx5ZYPilF8V28Kqg==
X-Forefront-Antispam-Report: CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mx01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(39850400004)(346002)(376002)(136003)(451199021)(46966006)(36840700001)(36860700001)(6666004)(70586007)(82740400003)(81166007)(5660300002)(4744005)(2906002)(8676002)(316002)(8936002)(40480700001)(86362001)(36756003)(82310400005)(4326008)(356005)(70206006)(6916009)(41300700001)(26005)(336012)(2616005)(47076005)(1076003)(6266002)(478600001)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 13:41:41.8749
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f40167ea-4c4d-43fa-c74e-08db3b5ba633
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mx01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM04FT062.eop-NAM04.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR19MB6879
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Miklos, Jens,

could we please also set this flag for fuse?


Thanks,
Bernd


fuse: Set FMODE_DIO_PARALLEL_WRITE flag

From: Bernd Schubert <bschubert@ddn.com>

Fuse can also do parallel DIO writes, if userspace has enabled it.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/file.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 875314ee6f59..46e7f1196fd1 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -215,6 +215,9 @@ void fuse_finish_open(struct inode *inode, struct file *file)
 	}
 	if ((file->f_mode & FMODE_WRITE) && fc->writeback_cache)
 		fuse_link_write_file(file);
+
+	if (ff->open_flags & FOPEN_PARALLEL_DIRECT_WRITES)
+		file->f_mode |= FMODE_DIO_PARALLEL_WRITE;
 }
 
 int fuse_open_common(struct inode *inode, struct file *file, bool isdir)
