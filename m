Return-Path: <io-uring+bounces-2293-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 86B0A9104CB
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 14:57:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2784F286389
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 12:57:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC9931ACE92;
	Thu, 20 Jun 2024 12:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FJ8o0SxO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Oxq0luYp"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2511AE85C;
	Thu, 20 Jun 2024 12:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718888110; cv=fail; b=FRI569PKouSmq9P/ofdS5OgJk992/WmIknsLZV49lDRwQqwVWig6AtTf9YQgledqT8Ns8690eRSHh522tSqFr/Z82ociZSo6hhGGzcqewzjSyinwRfpHWURY9x3sESgEszfgUXQCVyiovZbS4MrPursJKNuTgpzWIvssFNHrY0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718888110; c=relaxed/simple;
	bh=ftZ6f1r38ryoe1kq99PhyTkR16LpBz0DXyC9/QcgzD0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PSMq3nh1qCoaaiOVZxVFqHTmfRpA2Na8FqNBMe3+dWkS7MTA9qeijFA1t+NA3SHMnduYhdxkYsENySomLvRqnJM5oUdMrojpGeMPNTYzgxivLf0tgCEclXh//6uAaXwwx1rc/vZiRwgPLctXnteR1FeAXUtUQxy4B4dmP5dOXck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FJ8o0SxO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Oxq0luYp; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45K5FTrN002262;
	Thu, 20 Jun 2024 12:54:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=CNSOjZF84UFsx4hF5jDDwIFhmDDOPLzERuihDLak5GI=; b=
	FJ8o0SxO5dXwHBXkyiiPmCvUeFEFeKR2i+hcze33/vxOzYXEyZhqB5w1Cg/glfi+
	oCYufyoTDNBeKh7Erj26fU/RfHb0B3aq5NnxyoE/FsQc4KmsjE+3faKAh2p+5EAr
	gf42EzfLBmG/nixuJrTlIM3TMKhcyde8D+GrMefnacoDrGuOWNZkOGYX25r6PVJM
	7dbcVPYnEYmbtIqFkGLt05UNHWe/+SGr+GWsu9N6iv15HTzc89fqFT+Qwpy+GOgg
	GkbDPduO1t2QA+PPOix0zRZmGqVaMBg06YmWrGboYV43HpMZHZ5NAtMpck1/tVNV
	0q0nBLT5WdC5zEGh7cH6cQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yuj9r34gv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 12:54:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45KC2M1v034751;
	Thu, 20 Jun 2024 12:54:37 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1dap46t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 12:54:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JPA4qor1TE3ZGhQn+gt9ekyaOVYGNQQYE5AT936iusCG6Vg57CMQ3NzKtosD4lv3GxusF2hbvSWuEsYsd3aYazJDmubAAJqJ9vSfeIuzbLR1WAS0bW7vZiNWe7f/WQp8OaY3vw8eq2X+9nXLYzjnqIhcAoaDEYKugtKX9VPhI8vvVvDObhU9TuP2UbIpsJTRwhvYTBiHRYdykbaiTAPZiaAwn3ELVG3f23AZrCPbZTJ9G2VEf92bERNsUjbIuNPN765Y/6k9dM3K1+Bkyv5f2PSqVB6x0eu41xLEl7HyVlNXvPxKgu4ehnxZV2o954iiKpEnxhOCH/cig2If2+LgNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CNSOjZF84UFsx4hF5jDDwIFhmDDOPLzERuihDLak5GI=;
 b=iEqfnCIjfo3q/0pMN0Zql02hUI4EqGOwQvDAjFBfYrfyOe1rgvO0Jui7+xheetaRwc1CzpCbtdt2ODv4zyvxfrWVOAhvgHF2AKnhUT7QXSfrXYZ93NKXFYkLeTcGrKlvhVJfHh+3M1xBBJzCiuIDcUPmR/SlpQuQvnA7GToxAQzMzlX2YIT/4neTYpgpA2fBY75gZ8eK05rR4Unwur+LHjBhB/lYrloi79tzfMIore2XbZrEt6i+NhbER2TLTSyXglWnWLO5qRrdvrbf+qmqQkFZ/Ks91cFzIdXsovMzwlPRIeJkyzUYcUQtb7xxD5XX9XJf8sYlpcrwrbN5JzfeXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CNSOjZF84UFsx4hF5jDDwIFhmDDOPLzERuihDLak5GI=;
 b=Oxq0luYpB2IwHroyNEGNPLs463M7OGNmLzHGxAVcRXwLS7xuMoAoME4JNoXbu/NUV3ffZQax+DJsp05s+ZNn6+/HGQedszdl25cVy1Cbt0CmNHlQsra370DDNGYbfvre4gzBNOA15IB7J+2BQWMLSjZIVzqAje4pAMxmI61rIy0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB7695.namprd10.prod.outlook.com (2603:10b6:510:2e5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Thu, 20 Jun
 2024 12:54:34 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7698.020; Thu, 20 Jun 2024
 12:54:34 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz
Cc: djwong@kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org,
        agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
        dm-devel@lists.linux.dev, hare@suse.de,
        John Garry <john.g.garry@oracle.com>
Subject: [Patch v9 07/10] block: Add fops atomic write support
Date: Thu, 20 Jun 2024 12:53:56 +0000
Message-Id: <20240620125359.2684798-8-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240620125359.2684798-1-john.g.garry@oracle.com>
References: <20240620125359.2684798-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0042.namprd03.prod.outlook.com
 (2603:10b6:208:32d::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB7695:EE_
X-MS-Office365-Filtering-Correlation-Id: cf398931-1ff3-4b6e-3194-08dc91282295
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230037|376011|7416011|1800799021|366013|921017;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?ks4momK4XuKL1S+xPs83twmwqVqf41MVW3m1+olbfKB8WBNCDv60fwGLXCRo?=
 =?us-ascii?Q?w+aRPOprD5G654p3J39rdH9jNtpOqcmAormVU0wcK7OS8JPvRbiguWbUK1M+?=
 =?us-ascii?Q?JlCVJpzojUxMOBjcNX5QzyAACOl5teF0N8pGvIVC/Mu7n0SdJC+jyTv/Z3Kd?=
 =?us-ascii?Q?OqAUkojKUOUi7fbvMWfjcLuwpZU9O6OSRBHk9mJc5gLcJSPu6Z1TWd3ECjFB?=
 =?us-ascii?Q?xcO0JwlCRlwf05rzdGid7yRj4hgaop5Mvndl6Ibub4Uu1KQseWIGqYHZHaw6?=
 =?us-ascii?Q?X5tzC/JWdkoKeNvbxDyb8dwShtkHOb0aetYUzWlPrY4NpYd8Y24sRiztrcnN?=
 =?us-ascii?Q?cKetELU/4SCnQfErjI+wOCM1C7B4t+ZzKzOFLxPzUIibS9yRpkv7oKkVs3Oq?=
 =?us-ascii?Q?j4AjRpjC3kBVAAz55lTdMo1Rq6BQZA2p/EmztQb/SWor9NuB2aWQuvyhYVwj?=
 =?us-ascii?Q?FUXSBpJw2J1jPnMani9IeMP6L0R6R90Y0MvLLx1ppZ63u+gJlNSlYV0GWjV4?=
 =?us-ascii?Q?vvs4pkYWWLEt0m/Sym+N0PZaflQkf/xmvoErT2YOZs9TRDBrmT5hNwZsD+ee?=
 =?us-ascii?Q?wTSRqR4Rx52wEAgEK4UkGDWY4GJN5CSuD2s5xFjfUL4ANhovQQRsEJ6hfAlr?=
 =?us-ascii?Q?PtXv/rae9FZQoo9PKaU/eaAbjb1mlIE5UcbyfVAT3H/plPHHkXWzVYaT2yCf?=
 =?us-ascii?Q?FaoG0uPFaUWyHW08UaQylbdAjgqcQIxwTWuvEY9wh/P23+REKuNhdOddwvjX?=
 =?us-ascii?Q?vdWTmBRl1BkePID/q8Soz0V8SWwfmu05DBT+e9Es3yLSATxGIl1v7SCbDwLy?=
 =?us-ascii?Q?QkYeoPu7nrodKI30+VPn8rl/ljDh/OxF8C+gmBLtK5eAelM9oL3+Pg3cBJTu?=
 =?us-ascii?Q?Tk99hX+1S3c4AzbEsndUOZRPpQ8Jw3o7lentl4r88cH6QBcr/LQUwr8x4uwQ?=
 =?us-ascii?Q?bUb3od8TSgsaJG898eMIJypbS3vzTS5yaLq47rWxy7vFcyEQViNIvBs1RbC7?=
 =?us-ascii?Q?jF50nQwmrcFOtasvXhMnN33dAfHpQsf91VfHXFnrH0z4M8CNoutVDAU+dItp?=
 =?us-ascii?Q?GS6QGvOvX1qb7BSor8NNc2ESkpTBhQmSodjqXwmpvwbyaSCN3FZ7L8VLsNoE?=
 =?us-ascii?Q?2UC3veoYRPMBEOjHgiPh/UWgaYTKeuACzMs28rK+3kIIWQGJ6hJL4RsNU6ov?=
 =?us-ascii?Q?rQeFBSEIl3/x+rrI7hT4MLyRvShwvhXKiovuqh4X5dlHV+Z1iMFzBphyjk0H?=
 =?us-ascii?Q?HYcoRYqW0qK7Z5JnWBni9CBmYirNytVQEEYNqp+Qx9pazIkFw3LVWPmLKutQ?=
 =?us-ascii?Q?dcNOeUYbZY5I1Sy6pXDAg19XgoGoNfOtTP3/mtxJvGGzYxjlpvneYcoow3j7?=
 =?us-ascii?Q?+6lsrNs=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(7416011)(1800799021)(366013)(921017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?qyGnuDXHUrllO1U04ZYNhwFRIQgWK4uwdldZVJOSW7CBylU/IDRBjO/doxe9?=
 =?us-ascii?Q?HnxwjQUZ2BhP/WO8ETYOnkne7kws9m4u/TmcBgZTSxDS2d735gZM3KnnZ9LY?=
 =?us-ascii?Q?Yambs0NT3zZQrgv3nwPNTZmihRccm2Ag51w4k+XPPF0pregNqKpJExz3Y91x?=
 =?us-ascii?Q?ZUymD0+VvFrWUKia/5qkfi1Dst+IVQczuIsw5BArjEkYcIjR4w8wFrdOq4sV?=
 =?us-ascii?Q?ShNTu+CkZqHn3sV2qK0m8lM4Qy0hFEKoERMKgJAZNJaRPmqGhgceD0+WoX6H?=
 =?us-ascii?Q?zovZQmi8U3KWg5waWRdcOmCwId91yVkxXA2Qzv7QFr8ZekF5RelirUExZhST?=
 =?us-ascii?Q?Xw6FiiYvEnBGzi4mcYIgmbBK521iZJVM2uZD5V2+dHT5VebskGdvgldIMn1O?=
 =?us-ascii?Q?rshQuzlXZIOxqJ5BMv+yxZKmk/1SKQ0iEQI1vwMNfqJ2DrTmhpJf+TbE0f+9?=
 =?us-ascii?Q?imC/vQy2fgnjPwxl65wSPI5lPqZNdpBGpQVRfSMZrfLDuAiYTOaO1ee3btsp?=
 =?us-ascii?Q?kl/O3i6q0sdG1iIYfpcpbfQQga/iW8v3AzW/xi8K7Ly1wg02g7dQct2/e0vE?=
 =?us-ascii?Q?JXwP7UhNYubTtUOqClxjUKO9M4xSSE55GfihbUWxIy6BF9uWdFDRpIPAHlgw?=
 =?us-ascii?Q?yRYtho9Lut0fSsAKIo227ASqbUdOt4eRGHKGeoDWmusQXLPBQbFrQoEpyCST?=
 =?us-ascii?Q?fO2YPLMuboqxyJqkEKLg5lbcZA0rQdLoD/EwILwGRIunUUGbz25vfQ8ktYeJ?=
 =?us-ascii?Q?aPU8kmObeJxCSLHXNg6svLPPQF7mJOVSmwrZsgZtBPNUOlqikrhZ6z8OQ5dx?=
 =?us-ascii?Q?LdkDoYV/+UjNaS8zQOGgwLbL0BsJWpUMDY+Bwk4e3lz0srN2E//5GPV8bxN9?=
 =?us-ascii?Q?eMneb3oGg9w34IIgeIoY5lCewat/0QgHdEx4o9TzRazPFKMgdXn9WAm6ogR4?=
 =?us-ascii?Q?CEV2V1rawhIkWjjC3RDxlWrZlcAQRY64NeadJnnyZ9xiH+rNsWyrh6IBdz0D?=
 =?us-ascii?Q?XJTo1FkDhCxj8+LJL1+prx+hUN8Fxm9b0A7neYR45N7smIyOxnalEX09jBwL?=
 =?us-ascii?Q?BfOTc5CbnjoadO148dxwyz+3pKgGCloB+YHXkF9JLYG1iphm8+uIM8CTQxCE?=
 =?us-ascii?Q?vB83QZRM0G4FSr+kxQsBGQxZmdslKfo7/5HYNKw4dVcQJhCiLF/cGLBUJ+Wk?=
 =?us-ascii?Q?OZsby9jsuxMh7/j4k+A2kDP2ho+dGazecQkU5B1Zo3v4t3R7nnVV7Yo4aZqL?=
 =?us-ascii?Q?jN20i9y+WZ8xZhNMgN72jhz95oj6cYtxp/FNQ/hUAbhQ6K9iuYIxKPjSQg4C?=
 =?us-ascii?Q?yq9jQ5zo2aul36gzJhl+i5wX1udoqJqEHUqEgB+XOckzNF85i07cDntMVkI9?=
 =?us-ascii?Q?UL3djSd46j2r9Q9HUsvl/tz5HTc5WbEGsLRXI2jIpByckY8sbuF2e+QFapaL?=
 =?us-ascii?Q?eG/+R5EaE6vm/ctPea2OXnrkAziARhJ/lD9rCGjx1Mh1WZXoRWUnj6dHcvPY?=
 =?us-ascii?Q?TB1OJs9pGfE8dIMU/TEVEN5a4HD73GYwjF6UF7EQGP8701V1vRlHooL5EFWt?=
 =?us-ascii?Q?7y67vlppZ+cJjc/viUNJnhHZCJ6ri5XUd83eHSZvCmQ+rNa+w3GPYtpKAaVW?=
 =?us-ascii?Q?2A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	UFw3m3kaolm0N4xRIYjGN+/xbMebR2onp6joSHb36tuY/CAFPb88smgfYodmvCwb2p+vteWrBYhAK6yY8myGGOEcpiMbLBGFyg/C29frSthvuEwww5pb1ug+89MkMuVvwRajPba0PnwwuQ2EExckqwyoNrRizoN75XtljDKdeQXRiYGB43CgYvCOBN/FcKbLUASH6ppEDiNEpD5jENIQnqa+/8HpWR3JqhUWkpUXixwysESNpcxgPscR219R2GbpPks3ma0yHRSvDSlSxf/N9e4zWWlLUbv5ntXeHshwpKPGZ9Xo2WehPhf0FVjBYdZfayqO3TQtemodnNIKuyFt/r8Auq765mGoftSWr2GmcS0E3tsGTMbDSk4DaE2CtOnTe2EPF0KwOVJSy6avD025u9EPLtY8BEiKxz1rWPFvJUEgtuOGFZWIagfoWasZo42Wcjz9wpvpbuD9IUN1uThSyQvAGc6d89g4OfMlZTjL+Lll3/V5GC6zMps9i1n3FgVisLnEV/fnryhqrA1nO4lcuXKD2NAr5/DYYDwqtG11Pa/S7OsffWTizmpWe5u+1+zGp9l41HgiWGntCSOxFn5tNvLMc2TcscnberNFm995kq0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf398931-1ff3-4b6e-3194-08dc91282295
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 12:54:34.5998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pBo9x3CcerkNrXrRvAGvyWqaTCdAvcbl3oYbKOtc64g20/Y3nnXnfuc48i7ajc6bW7FirCDTA/4BWdC170/QnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7695
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_07,2024-06-20_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406200092
X-Proofpoint-GUID: a1uH6-wMwzJj73xKkqNZklMoaHtOr2DA
X-Proofpoint-ORIG-GUID: a1uH6-wMwzJj73xKkqNZklMoaHtOr2DA

Support atomic writes by submitting a single BIO with the REQ_ATOMIC set.

It must be ensured that the atomic write adheres to its rules, like
naturally aligned offset, so call blkdev_dio_invalid() ->
blkdev_atomic_write_valid() [with renaming blkdev_dio_unaligned() to
blkdev_dio_invalid()] for this purpose. The BIO submission path currently
checks for atomic writes which are too large, so no need to check here.

In blkdev_direct_IO(), if the nr_pages exceeds BIO_MAX_VECS, then we cannot
produce a single BIO, so error in this case.

Finally set FMODE_CAN_ATOMIC_WRITE when the bdev can support atomic writes
and the associated file flag is for O_DIRECT.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/fops.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 376265935714..be36c9fbd500 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -34,9 +34,12 @@ static blk_opf_t dio_bio_write_op(struct kiocb *iocb)
 	return opf;
 }
 
-static bool blkdev_dio_unaligned(struct block_device *bdev, loff_t pos,
-			      struct iov_iter *iter)
+static bool blkdev_dio_invalid(struct block_device *bdev, loff_t pos,
+				struct iov_iter *iter, bool is_atomic)
 {
+	if (is_atomic && !generic_atomic_write_valid(iter, pos))
+		return true;
+
 	return pos & (bdev_logical_block_size(bdev) - 1) ||
 		!bdev_iter_is_aligned(bdev, iter);
 }
@@ -72,6 +75,8 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
 	bio.bi_iter.bi_sector = pos >> SECTOR_SHIFT;
 	bio.bi_write_hint = file_inode(iocb->ki_filp)->i_write_hint;
 	bio.bi_ioprio = iocb->ki_ioprio;
+	if (iocb->ki_flags & IOCB_ATOMIC)
+		bio.bi_opf |= REQ_ATOMIC;
 
 	ret = bio_iov_iter_get_pages(&bio, iter);
 	if (unlikely(ret))
@@ -343,6 +348,9 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 		task_io_account_write(bio->bi_iter.bi_size);
 	}
 
+	if (iocb->ki_flags & IOCB_ATOMIC)
+		bio->bi_opf |= REQ_ATOMIC;
+
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		bio->bi_opf |= REQ_NOWAIT;
 
@@ -359,12 +367,13 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
+	bool is_atomic = iocb->ki_flags & IOCB_ATOMIC;
 	unsigned int nr_pages;
 
 	if (!iov_iter_count(iter))
 		return 0;
 
-	if (blkdev_dio_unaligned(bdev, iocb->ki_pos, iter))
+	if (blkdev_dio_invalid(bdev, iocb->ki_pos, iter, is_atomic))
 		return -EINVAL;
 
 	nr_pages = bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS + 1);
@@ -373,6 +382,8 @@ static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 			return __blkdev_direct_IO_simple(iocb, iter, bdev,
 							nr_pages);
 		return __blkdev_direct_IO_async(iocb, iter, bdev, nr_pages);
+	} else if (is_atomic) {
+		return -EINVAL;
 	}
 	return __blkdev_direct_IO(iocb, iter, bdev, bio_max_segs(nr_pages));
 }
@@ -612,6 +623,9 @@ static int blkdev_open(struct inode *inode, struct file *filp)
 	if (!bdev)
 		return -ENXIO;
 
+	if (bdev_can_atomic_write(bdev) && filp->f_flags & O_DIRECT)
+		filp->f_mode |= FMODE_CAN_ATOMIC_WRITE;
+
 	ret = bdev_open(bdev, mode, filp->private_data, NULL, filp);
 	if (ret)
 		blkdev_put_no_open(bdev);
-- 
2.31.1


