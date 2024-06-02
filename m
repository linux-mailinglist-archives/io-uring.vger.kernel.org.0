Return-Path: <io-uring+bounces-2071-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85E748D7617
	for <lists+io-uring@lfdr.de>; Sun,  2 Jun 2024 16:14:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CEA82826E2
	for <lists+io-uring@lfdr.de>; Sun,  2 Jun 2024 14:14:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFE0840862;
	Sun,  2 Jun 2024 14:13:53 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B7A4086A;
	Sun,  2 Jun 2024 14:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717337633; cv=fail; b=X6+SkGOZSG/bt4bvMxycxuuiipYcvD2gMj2edSeSPcbGghqzDiiHs1cZpiDPOXEaLB1bAhBIo+g6EIGuAmv4Su5qGMWU/RGNG8XLFMQ5rrNHr0aK7nKrWxZo+70Anyc+TQVCwWhk+0l2sdtIfqF+8Ml3W1xMDZlYgsFPtdTEHIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717337633; c=relaxed/simple;
	bh=fpBs8Q05QP9h8997Tapg+W+QlIARQJ0aVgGpHmiprEA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dmOeUWMbjeAk466rgT4wY/mFITuU2o9KaydYvMXWFpded2OxrzZ/sYliPJ570mIAHxMyPA09+RzYbDScP3ivAhgyUfb6Suw7GVeG/mlIid73zfNLw5pON4Bpwvkh7QGq9PofQOBaDcwOtkCDqMQaBlaMjsS504EfYdIM505Ob2g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4525x9wN006406;
	Sun, 2 Jun 2024 14:09:53 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-transfer-encoding:content-type:date:from:in-reply?=
 =?UTF-8?Q?-to:message-id:mime-version:references:subject:to;_s=3Dcorp-202?=
 =?UTF-8?Q?3-11-20;_bh=3DtZ9etgNWFzxoGl6vttrRSkXH0odkInGHkvSdo8PtLNI=3D;_b?=
 =?UTF-8?Q?=3DcyniTPf8e4YGRhZ0NLfV2gq2ON1qQxs1Bo7Zv/RL0MZhIvv8fCaeMDNLTZaK?=
 =?UTF-8?Q?bXdbSSd1_nPANsV3liPOdztnn592ErHFW/jOI6aBWVE+JnMTk5rXiwEHswyUUUC?=
 =?UTF-8?Q?MUak4R3BsjZiwX_SKcsm7f11qDBWGp8abaqFxYWQNrfiGrArT8TQc7mWoJtw25M?=
 =?UTF-8?Q?lpd7HPugEz0LUR9wM4ru_8bgM23K9aBuYouDHazAqFDt9NAqNUBg+2hcCyk7Qwl?=
 =?UTF-8?Q?z1y3QQ+u9LYFvMaOrZjCCBbriX_haJ3wsBKGnQTyNBJwcOt4yYYbBoyDJUCH5mg?=
 =?UTF-8?Q?rGb5LOlDqg3yvt6SGezK0MRxQGda0HUf_+A=3D=3D_?=
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yfv07sd0m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Jun 2024 14:09:53 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 452CDYtZ037809;
	Sun, 2 Jun 2024 14:09:52 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrja1h81-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Jun 2024 14:09:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SE3CoqgECrCbzVXuPs6kWyzK9V29USCMAwCn1H5NZ37kHqIZC0tUWBiPx4WUpToBN+RewTQk2Sp1/QTRQF058f0nI3rg4okH4Bc8xCYsw+jbfnYZ415Wc99u6TRJN3plOb+nInMt0v4cnC6923zLehQ4b2y2z+6ybhVEBm1OAcauwGFjCRBTJIjQYzd8g2p9rzsw0LhmlQaHrwcKRZ5sg0ZNnIn5GZFRWYCKdo37bV+XRf5hMQbHl2PffeAntBmr83pRG9G4llsn+1llkh/n/AfR5Zik20gvwcGQ6R0zKV+Nl1LnOUyq8Q26omG5M3Wo2meVdE2E05EpQP05jSdgDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tZ9etgNWFzxoGl6vttrRSkXH0odkInGHkvSdo8PtLNI=;
 b=I/C+usNUiZVqiJutbiYi+ulODvSLdH8EypHS/PBW/dx28f4izxJtyDeRivjGEdTwAe+1qvZoBoYa06FwR2G1sun4tsXA8Ka+CNkzGbxaT4ZIUAIf23AI9Z1DvmWI90ewZ1C9AQrdxXVK0p1QM1gduKhyfh84EvPpnnRTRDYXmsit9tWfntuOEIowuS1xTIlNKrfRvZ0Azg3V8irHJjVPOLP7U3uGxjC5I05yx2jNsFwCFLqQNJ5HO+C9jm6jYZAxb1vdySgcz5TaYo8yY6lOrBRDQQRd6OosRgYhQlHOrnwhBZtX93XOR+XngKV1JsIN1EpPyshtb/b3g2xWA+jKMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tZ9etgNWFzxoGl6vttrRSkXH0odkInGHkvSdo8PtLNI=;
 b=yHKPrq4hiZ+ayfeLpD5ub+Aumd7HWaAIeoDokm/tjkPXCCU0/RUd1/Vk7CpYB4hzq3HNhsoU8gnAKkv7TEYVuCaN3Gl7QCLtyrU6WNRvW9+jsRI/qizYtEX7bxoduBj/r0NBP4N+CbcSPr5b2CBcTDwPNo2GCU56icnMdv043NM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB8078.namprd10.prod.outlook.com (2603:10b6:8:1fd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Sun, 2 Jun
 2024 14:09:50 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7633.018; Sun, 2 Jun 2024
 14:09:50 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
        ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v7 7/9] scsi: sd: Atomic write support
Date: Sun,  2 Jun 2024 14:09:10 +0000
Message-Id: <20240602140912.970947-8-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240602140912.970947-1-john.g.garry@oracle.com>
References: <20240602140912.970947-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR01CA0003.prod.exchangelabs.com (2603:10b6:208:71::16)
 To DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB8078:EE_
X-MS-Office365-Filtering-Correlation-Id: 22e55e9d-9c6e-4760-98aa-08dc830daaa3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230031|366007|7416005|1800799015|376005|921011;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?YWTRmgALqIvmLKvWjhDFORpUrCfy7uH1jVUAjSyik8jtfcaS8+6TCmsnZwGN?=
 =?us-ascii?Q?y3PbFMImSEYD3KnmutC+w5n80jk7XGpWvchYvWvJhcJ9SDt3zsfrsu0UBNHU?=
 =?us-ascii?Q?TF9VXYTCDQ2DAngMitI+zFRwnTgiZ1vnb/EFCeMjna5dDCkxvzj2zZEqNfuJ?=
 =?us-ascii?Q?DbhJefD8Big5VgnfLmMN7kWNz+ur3FokD+GopJsMRFYpsUifipkI5I2sMM8m?=
 =?us-ascii?Q?KR950ohNQc4aCaR9S3RsJeDz2IEogZJPnqo+pVeCnCG+yOW/4l4ZlprcDCgt?=
 =?us-ascii?Q?Phk79jxqD3yr+tK1JXr7lyXsCHFVi6yFt0wgpqqEjXDZFjh+bzXJGt4rGU02?=
 =?us-ascii?Q?Jh8jA8C/BhHbDy3kKtPMhei5cZJe4w5vWEUjYfH69xThSKny6kNuN/Y84eDO?=
 =?us-ascii?Q?gONsvBI1XYjGsmAD60i2ArOXKxwmh0eCX7rqvxR0oS8jiurjbNunCndTrmyn?=
 =?us-ascii?Q?gUPg5VP67x7iUTAAps20CslKGnE6nYW4/h2oyVRo2rNdt585drFNuGywmA9b?=
 =?us-ascii?Q?mey9wWNUzsmvkYz4avUB42ZZ0YPpo7ak9cuJFdO7MNV/svdh4RkB4gkNeiVP?=
 =?us-ascii?Q?pNG8SGOrwcDqrx60iXqBPcokfEIclR1SlKOFEBjg3DqXhRgevXcx90WeT9Tj?=
 =?us-ascii?Q?XIBus92M5oZZxXy2UGIbjLueuceKf2rEZcN2+ZoO36OQvP1mtlTV3OJELFMW?=
 =?us-ascii?Q?X32HDJf8jOtDdiN0pOj3cKNnjc1AexRdtXN+3dE4gF8X0XTAutX7IfkeL1I4?=
 =?us-ascii?Q?9wrFGdLZIoVWmBZtRERfbDye+ADJAO8ejKazCfQ+D4cXRNzKQoP+dBJ57HCB?=
 =?us-ascii?Q?2fUXA+IWj5bbO2LRrVYCYTS7SfocHoG9EbRqzgm/mRGrxqDIYqLWvwOR5Pmm?=
 =?us-ascii?Q?UuhTa+r9p6zEHVadG/O/qcEZ8CrfVz38BHUaqtfbXkXVqK47ysXLAJRlqZe4?=
 =?us-ascii?Q?aPC3qB0iBMGdfBqrxFS9Gvj2lKYP6rRo5LAnAu62U8b3M2Yf7IOLEx8sguri?=
 =?us-ascii?Q?X2exTb5k0UjsgyjKhOuQ3hlum8b10b4CtkhIRC/KLRc91i5LMdiheOiyLKiU?=
 =?us-ascii?Q?Rvxlr9JCQvIQMHOdxwx/doFhopB9engsBo2jyeYAzXxxodfQazl+v20GhyT6?=
 =?us-ascii?Q?S967t6pWE4+bFnTN3mcLEssKddN8zEJspb81XCsNhJy+EtL/nHO8kWxL61Yi?=
 =?us-ascii?Q?xxxwHQSFH/hR0kv111kzLNv4efLop8WKwDCoXv2rk5LmzL7Egk1shI4+2gZJ?=
 =?us-ascii?Q?O3S2lpDz5uYx5W8y7I6eoly/b8qDVp9Nd66D0IyfQdqHz0Z0LcMLn//Jhm4L?=
 =?us-ascii?Q?vLVIt8ZSblMHrN/edaAtIIsd?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?JJWsYdFkj0/WabvIexxy6MyOr3mfpR5r6G787ex3WYsyEAv6M3NcrRUcYIV3?=
 =?us-ascii?Q?Res0EiovA/B7DxYB4IfwTL/5LSycByX6e55eGknTAuVK4M5k/oYcrinZqVaA?=
 =?us-ascii?Q?6vc48lS4JyxX1Y8lMuFSIs9PEhat1/26EOrryAd/qlTfsVo4lKIPB1egd3QA?=
 =?us-ascii?Q?btYNJ9GiFV8IW+eZblTU0ZVaH6e3s9nq5vK9GsZuiuvV4tTDyayRXiSRxr0o?=
 =?us-ascii?Q?0m3rzEqcMhA2XRvVGJAh3D4U0xIOVlPwG72bq1N7joG5xttgSfzIjOssDz0i?=
 =?us-ascii?Q?csCU7Af8jyM15Ip6PqISNeauG8eynAHkXJMP1C8HSIbeB8biz6cQSvjHEi9b?=
 =?us-ascii?Q?/w4/4ctGpg3H2zaDYD7M31bB7UGb5MR3R4fvC6hRqO2uKoU03LMDvyP3zY6n?=
 =?us-ascii?Q?KIYJrN3Gj+LB2dy0tsoSJxYkG4LBB6A7S6es5TcoUpzdPyyAn0lY30HuJywd?=
 =?us-ascii?Q?dYXTVNX3kt/w8j/U+Svg+ZHWtJPqRO0hcaXJ7YR1VrYorss566wBHkM0KJbz?=
 =?us-ascii?Q?o+s+bPbdSfv7gkKsT2Z8Q3muqSAF4/fGoWj3AhluBRj00RXSr8y4AnoZdKwL?=
 =?us-ascii?Q?fc9f3TFB2uAbxwwAz6wGCGerGJ1f7GSqqFSXWC6sNAXYicCLfszYKNs0E7XL?=
 =?us-ascii?Q?SAq0iCURbhQnDFgw8PGKNOGhuWRX2cMiTEAfCGwIS3Fc0/LQHc00t75n3Yp6?=
 =?us-ascii?Q?PHDM/vLSr1mMSVPHYAOUuaFLJoWJQF8bK9fkorZEaqRWk1shrO04wqeyomau?=
 =?us-ascii?Q?XQayRMo8/r1JBYmGenVm1Q7Lp857Yi5dB65ixmE+qTgS4G6qJNcWXixs+Yg6?=
 =?us-ascii?Q?gdcIQUJRaG6R1j1b3NEE9cFN5sjHffeQLUgziYUP3j2TswnuyokqLAuN61Xe?=
 =?us-ascii?Q?ya/ZiXyMK6D+8xRb3lACmRbT8QyLjlsgL9+Fnls7GMDvRSyJm23e81EApe2I?=
 =?us-ascii?Q?pG+mPpxJBcJhjQAdQvxkI+vuRHSwVFy2HWgaOlugoIu/ifZrySq2RWqadr6V?=
 =?us-ascii?Q?zEtBma4i5ufoxdrShWk0MbsrZc+vB3iRP0HenbkTtB2mNEII6QHOtiEH14EZ?=
 =?us-ascii?Q?aM5ra2Ca+9sAXO2i/yq3T6Ayw943qRGnnWGc60MpSK95yFTqf3Qut0Mcsq1a?=
 =?us-ascii?Q?/qTSqn7yWcIetbQyDsDBIXH+xe/PQHnikQbq94vz8+GvGrfmOfT7ruD8CAce?=
 =?us-ascii?Q?zjdh9WAJAps+WVmpp2WDVmNcrg5qw4YCMRYL1q7FjDgunv0545Yj6zbZ3mOl?=
 =?us-ascii?Q?sRotpWCSTbN6GDp8enUQOetzCdzuytEx43R+WuZ8JU2BwSM70vvQ5MbN6Zj+?=
 =?us-ascii?Q?UW9ccOfzJ30lbY5iS5BXMm1Kjl3qg1CBWaFN+Nelb6XSIBop05Xke2QuPR7w?=
 =?us-ascii?Q?4AuN6KNyfCgxUZJLl2xtJCNh9n26EzH9q81b62AseRAwaLWD6457u7usGMRN?=
 =?us-ascii?Q?ZN5JPmEDRvGLVoL7LG7iIim/IWTKal7EdfjyHHvHZ3K6WRaa77yPh+9LCObK?=
 =?us-ascii?Q?PiNS/K/rk5SspXinuBe6W8Xk/YUwj1xNyccQRcFcf1Rs6Ve92x6Wkja0yqpV?=
 =?us-ascii?Q?peeHUUajJouYN4p/54BhO/nFVYvy6rdNTSJ5ss/CFjsGOXS9xLkjlVADneTH?=
 =?us-ascii?Q?RQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	sgvK5BEa9cdQHRCqL8zECpUn3r12B+K8Ldw7Nv2XEI0WPmK/oa2CYZpbY6nBQwo787gyxcRLvQrkekDbaVDv2cAsfuvpCLUXcQibE52tnI/vmDdePO4K3RQ1DjsV6oUJ+1ikKhqmPOXMh52+0UXE8TVueNwufgP7cUyOkxyMNukMT5/C/9qcR2k7aGYGoahVfUFTgL2/qZNoFIbSUeFt5NPaxisTU3it/Ds5yqrvCK0geifYVVkuIrWgv6UZbe2DqGel5EYhSx0RCFH6mx6Vjdjg7qn7aIVlKYPJ2t7RvccRYFtdVndZfNlB5qpT3EQsf+XsLVWYvG9sfQRVrAivkVmYIc05nCwHmWXAy3Jp49UrMnpjLWwl5YjQ4Dbvejvf8DjRGou/0Vb9cqIXUU3FlaLKdk+H01dCfDP+UZ0KBy55Vs49lwF7JYChIaKnQ+WVWCcdPnpYv1sAvqrP/3L5oTbe0IfccLBRrz50gJz+0PKRjgiXMUEOp6KGtFyNT78fd5dUoatrh8ZAuRcU+UcyDOtAjxv1kznFc88yWEl07ooXSgfsTyu2QXdUQDGFgjrl8iZEhTbS2xeQaLSICxEeuZ3uJMuWdgzXw99V0rpg9r0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22e55e9d-9c6e-4760-98aa-08dc830daaa3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2024 14:09:50.1891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q+Vcz7xDs2KwmSoMhTThOI7MJGYw4lmVaVdYHiSoVOPFAIkNJVS5BjJ1Bdx5cHgLU8zo4sJ02i2aqkLoBB5QVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8078
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-02_08,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406020122
X-Proofpoint-GUID: l-msDISvh_vgTiuaMAtkQmpxhYayU2Fs
X-Proofpoint-ORIG-GUID: l-msDISvh_vgTiuaMAtkQmpxhYayU2Fs

Support is divided into two main areas:
- reading VPD pages and setting sdev request_queue limits
- support WRITE ATOMIC (16) command and tracing

The relevant block limits VPD page need to be read to allow the block layer
request_queue atomic write limits to be set. These VPD page limits are
described in sbc4r22 section 6.6.4 - Block limits VPD page.

There are five limits of interest:
- MAXIMUM ATOMIC TRANSFER LENGTH
- ATOMIC ALIGNMENT
- ATOMIC TRANSFER LENGTH GRANULARITY
- MAXIMUM ATOMIC TRANSFER LENGTH WITH BOUNDARY
- MAXIMUM ATOMIC BOUNDARY SIZE

MAXIMUM ATOMIC TRANSFER LENGTH is the maximum length for a WRITE ATOMIC
(16) command. It will not be greater than the device MAXIMUM TRANSFER
LENGTH.

ATOMIC ALIGNMENT and ATOMIC TRANSFER LENGTH GRANULARITY are the minimum
alignment and length values for an atomic write in terms of logical blocks.

Unlike NVMe, SCSI does not specify an LBA space boundary, but does specify
a per-IO boundary granularity. The maximum boundary size is specified in
MAXIMUM ATOMIC BOUNDARY SIZE. When used, this boundary value is set in the
WRITE ATOMIC (16) ATOMIC BOUNDARY field - layout for the WRITE_ATOMIC_16
command can be found in sbc4r22 section 5.48. This boundary value is the
granularity size at which the device may atomically write the data. A value
of zero in WRITE ATOMIC (16) ATOMIC BOUNDARY field means that all data must
be atomically written together.

MAXIMUM ATOMIC TRANSFER LENGTH WITH BOUNDARY is the maximum atomic write
length if a non-zero boundary value is set.

For atomic write support, the WRITE ATOMIC (16) boundary is not of much
interest, as the block layer expects each request submitted to be executed
atomically. However, the SCSI spec does leave itself open to a quirky
scenario where MAXIMUM ATOMIC TRANSFER LENGTH is zero, yet MAXIMUM ATOMIC
TRANSFER LENGTH WITH BOUNDARY and MAXIMUM ATOMIC BOUNDARY SIZE are both
non-zero. This case will be supported.

To set the block layer request_queue atomic write capabilities, sanitize
the VPD page limits and set limits as follows:
- atomic_write_unit_min is derived from granularity and alignment values.
  If no granularity value is not set, use physical block size
- atomic_write_unit_max is derived from MAXIMUM ATOMIC TRANSFER LENGTH. In
  the scenario where MAXIMUM ATOMIC TRANSFER LENGTH is zero and boundary
  limits are non-zero, use MAXIMUM ATOMIC BOUNDARY SIZE for
  atomic_write_unit_max. New flag scsi_disk.use_atomic_write_boundary is
  set for this scenario.
- atomic_write_boundary_bytes is set to zero always

SCSI also supports a WRITE ATOMIC (32) command, which is for type 2
protection enabled. This is not going to be supported now, so check for
T10_PI_TYPE2_PROTECTION when setting any request_queue limits.

To handle an atomic write request, add support for WRITE ATOMIC (16)
command in handler sd_setup_atomic_cmnd(). Flag use_atomic_write_boundary
is checked here for encoding ATOMIC BOUNDARY field.

Trace info is also added for WRITE_ATOMIC_16 command.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_trace.c   | 22 +++++++++
 drivers/scsi/sd.c           | 93 ++++++++++++++++++++++++++++++++++++-
 drivers/scsi/sd.h           |  8 ++++
 include/scsi/scsi_proto.h   |  1 +
 include/trace/events/scsi.h |  1 +
 5 files changed, 124 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
index 41a950075913..3e47c4472a80 100644
--- a/drivers/scsi/scsi_trace.c
+++ b/drivers/scsi/scsi_trace.c
@@ -325,6 +325,26 @@ scsi_trace_zbc_out(struct trace_seq *p, unsigned char *cdb, int len)
 	return ret;
 }
 
+static const char *
+scsi_trace_atomic_write16_out(struct trace_seq *p, unsigned char *cdb, int len)
+{
+	const char *ret = trace_seq_buffer_ptr(p);
+	unsigned int boundary_size;
+	unsigned int nr_blocks;
+	sector_t lba;
+
+	lba = get_unaligned_be64(&cdb[2]);
+	boundary_size = get_unaligned_be16(&cdb[10]);
+	nr_blocks = get_unaligned_be16(&cdb[12]);
+
+	trace_seq_printf(p, "lba=%llu txlen=%u boundary_size=%u",
+			  lba, nr_blocks, boundary_size);
+
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+
 static const char *
 scsi_trace_varlen(struct trace_seq *p, unsigned char *cdb, int len)
 {
@@ -385,6 +405,8 @@ scsi_trace_parse_cdb(struct trace_seq *p, unsigned char *cdb, int len)
 		return scsi_trace_zbc_in(p, cdb, len);
 	case ZBC_OUT:
 		return scsi_trace_zbc_out(p, cdb, len);
+	case WRITE_ATOMIC_16:
+		return scsi_trace_atomic_write16_out(p, cdb, len);
 	default:
 		return scsi_trace_misc(p, cdb, len);
 	}
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d957e29b17a9..a79da08d3cce 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -933,6 +933,64 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 	return scsi_alloc_sgtables(cmd);
 }
 
+static void sd_config_atomic(struct scsi_disk *sdkp, struct queue_limits *lim)
+{
+	unsigned int logical_block_size = sdkp->device->sector_size,
+		physical_block_size_sectors, max_atomic, unit_min, unit_max;
+
+	if ((!sdkp->max_atomic && !sdkp->max_atomic_with_boundary) ||
+	    sdkp->protection_type == T10_PI_TYPE2_PROTECTION)
+		return;
+
+	physical_block_size_sectors = sdkp->physical_block_size /
+					sdkp->device->sector_size;
+
+	unit_min = rounddown_pow_of_two(sdkp->atomic_granularity ?
+					sdkp->atomic_granularity :
+					physical_block_size_sectors);
+
+	/*
+	 * Only use atomic boundary when we have the odd scenario of
+	 * sdkp->max_atomic == 0, which the spec does permit.
+	 */
+	if (sdkp->max_atomic) {
+		max_atomic = sdkp->max_atomic;
+		unit_max = rounddown_pow_of_two(sdkp->max_atomic);
+		sdkp->use_atomic_write_boundary = 0;
+	} else {
+		max_atomic = sdkp->max_atomic_with_boundary;
+		unit_max = rounddown_pow_of_two(sdkp->max_atomic_boundary);
+		sdkp->use_atomic_write_boundary = 1;
+	}
+
+	/*
+	 * Ensure compliance with granularity and alignment. For now, keep it
+	 * simple and just don't support atomic writes for values mismatched
+	 * with max_{boundary}atomic, physical block size, and
+	 * atomic_granularity itself.
+	 *
+	 * We're really being distrustful by checking unit_max also...
+	 */
+	if (sdkp->atomic_granularity > 1) {
+		if (unit_min > 1 && unit_min % sdkp->atomic_granularity)
+			return;
+		if (unit_max > 1 && unit_max % sdkp->atomic_granularity)
+			return;
+	}
+
+	if (sdkp->atomic_alignment > 1) {
+		if (unit_min > 1 && unit_min % sdkp->atomic_alignment)
+			return;
+		if (unit_max > 1 && unit_max % sdkp->atomic_alignment)
+			return;
+	}
+
+	lim->atomic_write_hw_max = max_atomic * logical_block_size;
+	lim->atomic_write_hw_boundary = 0;
+	lim->atomic_write_hw_unit_min = unit_min * logical_block_size;
+	lim->atomic_write_hw_unit_max = unit_max * logical_block_size;
+}
+
 static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
 		bool unmap)
 {
@@ -1231,6 +1289,26 @@ static int sd_cdl_dld(struct scsi_disk *sdkp, struct scsi_cmnd *scmd)
 	return (hint - IOPRIO_HINT_DEV_DURATION_LIMIT_1) + 1;
 }
 
+static blk_status_t sd_setup_atomic_cmnd(struct scsi_cmnd *cmd,
+					sector_t lba, unsigned int nr_blocks,
+					bool boundary, unsigned char flags)
+{
+	cmd->cmd_len  = 16;
+	cmd->cmnd[0]  = WRITE_ATOMIC_16;
+	cmd->cmnd[1]  = flags;
+	put_unaligned_be64(lba, &cmd->cmnd[2]);
+	put_unaligned_be16(nr_blocks, &cmd->cmnd[12]);
+	if (boundary)
+		put_unaligned_be16(nr_blocks, &cmd->cmnd[10]);
+	else
+		put_unaligned_be16(0, &cmd->cmnd[10]);
+	put_unaligned_be16(nr_blocks, &cmd->cmnd[12]);
+	cmd->cmnd[14] = 0;
+	cmd->cmnd[15] = 0;
+
+	return BLK_STS_OK;
+}
+
 static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 {
 	struct request *rq = scsi_cmd_to_rq(cmd);
@@ -1296,6 +1374,10 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	if (protect && sdkp->protection_type == T10_PI_TYPE2_PROTECTION) {
 		ret = sd_setup_rw32_cmnd(cmd, write, lba, nr_blocks,
 					 protect | fua, dld);
+	} else if (rq->cmd_flags & REQ_ATOMIC && write) {
+		ret = sd_setup_atomic_cmnd(cmd, lba, nr_blocks,
+				sdkp->use_atomic_write_boundary,
+				protect | fua);
 	} else if (sdp->use_16_for_rw || (nr_blocks > 0xffff)) {
 		ret = sd_setup_rw16_cmnd(cmd, write, lba, nr_blocks,
 					 protect | fua, dld);
@@ -3256,7 +3338,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp,
 		sdkp->max_ws_blocks = (u32)get_unaligned_be64(&vpd->data[36]);
 
 		if (!sdkp->lbpme)
-			goto out;
+			goto config_atomic;
 
 		lba_count = get_unaligned_be32(&vpd->data[20]);
 		desc_count = get_unaligned_be32(&vpd->data[24]);
@@ -3271,6 +3353,15 @@ static void sd_read_block_limits(struct scsi_disk *sdkp,
 				get_unaligned_be32(&vpd->data[32]) & ~(1 << 31);
 
 		sd_config_discard(sdkp, lim, sd_discard_mode(sdkp));
+
+config_atomic:
+		sdkp->max_atomic = get_unaligned_be32(&vpd->data[44]);
+		sdkp->atomic_alignment = get_unaligned_be32(&vpd->data[48]);
+		sdkp->atomic_granularity = get_unaligned_be32(&vpd->data[52]);
+		sdkp->max_atomic_with_boundary = get_unaligned_be32(&vpd->data[56]);
+		sdkp->max_atomic_boundary = get_unaligned_be32(&vpd->data[60]);
+
+		sd_config_atomic(sdkp, lim);
 	}
 
  out:
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index b4170b17bad4..c7ee1e9c2ba4 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -115,6 +115,13 @@ struct scsi_disk {
 	u32		max_unmap_blocks;
 	u32		unmap_granularity;
 	u32		unmap_alignment;
+
+	u32		max_atomic;
+	u32		atomic_alignment;
+	u32		atomic_granularity;
+	u32		max_atomic_with_boundary;
+	u32		max_atomic_boundary;
+
 	u32		index;
 	unsigned int	physical_block_size;
 	unsigned int	max_medium_access_timeouts;
@@ -148,6 +155,7 @@ struct scsi_disk {
 	unsigned	security : 1;
 	unsigned	ignore_medium_access_errors : 1;
 	unsigned	rscs : 1; /* reduced stream control support */
+	unsigned	use_atomic_write_boundary : 1;
 };
 #define to_scsi_disk(obj) container_of(obj, struct scsi_disk, disk_dev)
 
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index 843106e1109f..70e1262b2e20 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -120,6 +120,7 @@
 #define WRITE_SAME_16	      0x93
 #define ZBC_OUT		      0x94
 #define ZBC_IN		      0x95
+#define WRITE_ATOMIC_16	0x9c
 #define SERVICE_ACTION_BIDIRECTIONAL 0x9d
 #define SERVICE_ACTION_IN_16  0x9e
 #define SERVICE_ACTION_OUT_16 0x9f
diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index 8e2d9b1b0e77..05f1945ed204 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -102,6 +102,7 @@
 		scsi_opcode_name(WRITE_32),			\
 		scsi_opcode_name(WRITE_SAME_32),		\
 		scsi_opcode_name(ATA_16),			\
+		scsi_opcode_name(WRITE_ATOMIC_16),		\
 		scsi_opcode_name(ATA_12))
 
 #define scsi_hostbyte_name(result)	{ result, #result }
-- 
2.31.1


