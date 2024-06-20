Return-Path: <io-uring+bounces-2292-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DD7C69104C2
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 14:56:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 714EB285EE8
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 12:56:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED3211AE096;
	Thu, 20 Jun 2024 12:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LKLijo/E";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JTj+qG+h"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9331AD9EC;
	Thu, 20 Jun 2024 12:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718888107; cv=fail; b=ZaAkDPUFr66VUaRyxxe9VSpnRlCZGNHTLx1Pkr0gPNjIqBZ8FPOmia1VG9XV7F2m0jz3XiD8lMohP4Em7FlPVXhXcWf+OQSAzOKDJmvrUkgy19zzgk7wT86czhUS+Xw3WqKL09zKdZvwwge31e/3Pe9OckVZwcSP+XKNhIDwVcQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718888107; c=relaxed/simple;
	bh=zo1VPvvNMgXffWxDXx04IopaqeZsCW8bBIoNJev3Kg8=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=XR15954KyuvrTCWHa8iTB+JIxsDD2XFcvchXjVHT5x7dhPprTkBoc/ZYfeYqWV2XImb36ucslu+BO2HwyLj3htXF66Q+NpiZwHtdGdE/XA1YGQwsDUrm4NUIzZctbwWvlQ1bWwbLHwWqPD5inTYdgM/sIwXdSPth9HZr3swjJ5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LKLijo/E; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JTj+qG+h; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45K5FZf4005063;
	Thu, 20 Jun 2024 12:54:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:content-type
	:content-transfer-encoding:mime-version; s=corp-2023-11-20; bh=A
	zgUYOkgZ+rfcONPzMauL3woRe2UU3yUOfpvrHo3/zw=; b=LKLijo/EnO6LtNFvg
	Lds08avBVQ+UDWkBXtCa8dYLvAB6HWh9dcBUjm9OBHmXnQrsfI/FmNBQZjA7xVET
	znY/dEL3od6qUEPeZWNbMOtiNArUO2mFnaCGN0MdL/bNeOcRGfBzrrjSnyVqXcla
	bpNFQ3Ri9VwA8y8yo5lUzvCrzo+j4nMewN2uuN31exBIGGwkVQD2NZuhl8n+2bZR
	a97tnK4NABiOEt25D+UTXl7f+WFoj0ed735jpMZ48sCR/Xb3UXBPuvwXU5zcF/p2
	XpYDNkNzZjOoVFNmifdaVCs/fs1S2+4sgNrhYvdyEY/jZD/ef/bl3eWDq92n1i9y
	kYjwg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yuj9ju2u9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 12:54:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45KC7utX032824;
	Thu, 20 Jun 2024 12:54:26 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1dae6dx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 12:54:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SnjnG+K7cTml3vUECNdfmDMyrNdKGV2I4y9pMaD357zjFq7Iobw7xZg1EJnH7ENKP2khaYSckDiyH/i43wLBhQZMl50KRrUSPoVzDtSImoWBqmLhFnS9EgQCWfcbztWN3c+4zTFDB6R3i91+/CrRv/u3Fet4cXE9glTtFB0WuDfv4KMBxEKlW3leudaCce2ID7Ld5KATGbbY+LALc+V7U/xD5kgCFzW/x+YbQ2+GCojQZyKcOp40eyIo3zNjmcsSSLydYtPZ+rrRlRm+JysCosW81HQcXdyozJE10h+ewnxqostYPaDsZVT31cswTjU5bDFzUIrGIKpzQvks0ynKIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AzgUYOkgZ+rfcONPzMauL3woRe2UU3yUOfpvrHo3/zw=;
 b=iJVtCcYyAlHF0E+0sFI2iMt7vmCjmrF4JlN5ZP4PPPfKlChWtTlyIDPkoUedD9VaIjm9ocfywxUi6wRsJb+RqKk5+++JqQLoNVsv691I4HphQ097Q7IVvDwl6iXAxVqj2pFcuprAQdsE/5UV5IvruRRU7g9MJdyKnIbyuFtf1obZ4OeEaEzNPOV1ZiBCs6ur8aniNREluOzhxTjFoxy8WER+jv4LYDVOSMeH1npjN9MHoNZEHLAlMOtLsXbjm0HIpgX3+bNANqqsELYLD+aZ+ASdOS6JKwPyibz4CBTmGho4gV+CHxQtbovrjVer6uM/sFV8t1T2EBM8BBDpO2rB8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AzgUYOkgZ+rfcONPzMauL3woRe2UU3yUOfpvrHo3/zw=;
 b=JTj+qG+hyGWrZfBunKHvyEQKdpitpZwIczF84lcg2NYK1BIFgIduM2/L/q+WMdxKLx8+qMZyMOfnn50ubbYwjIAJfzIdx6ASTruNSjeeQv1WCSgas0JJp+6M84IyEb/Nc7GnYzEFXVjOZu9a/TuqcPzOuCZviVM/XsM0RVh0f4c=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB7695.namprd10.prod.outlook.com (2603:10b6:510:2e5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Thu, 20 Jun
 2024 12:54:23 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7698.020; Thu, 20 Jun 2024
 12:54:23 +0000
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
Subject: [Patch v9 00/10] block atomic writes
Date: Thu, 20 Jun 2024 12:53:49 +0000
Message-Id: <20240620125359.2684798-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR02CA0005.namprd02.prod.outlook.com
 (2603:10b6:207:3c::18) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB7695:EE_
X-MS-Office365-Filtering-Correlation-Id: ed406428-5f39-4a13-a135-08dc91281c2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230037|376011|7416011|1800799021|366013|921017;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?M1RzekhnY3Uxa2E4RmhPbFFkQUJOR1RaeEczbG5meWJWQTZHV3ROSzZFOWIy?=
 =?utf-8?B?L3BsbkRxTDg2cnFsNHRETkp2dGswa0tnK09TK04zQVNkbStaY3FQQ1B0WXp6?=
 =?utf-8?B?V0hYVUVOaTZQU2NvSkpDM3RzbjVRbUI3blhOZmJsRDBSK1AzNlZXellrTkFJ?=
 =?utf-8?B?MllKZWJUWlVUY2pPZVdPSGdkUHRWQzltK1o4a1hkTjUyK04rU201SndjSTc0?=
 =?utf-8?B?VVR2RkNjdUY3bWZoZUZFUzJXcEhpcmZhREtHbnAwZW5PQXh0YjVydmErSmJ6?=
 =?utf-8?B?akVCYk1aZGxsTEZIT2JzQlFhQkxFNWd3QnNVSDRaYWxoSy9xV0tYbW9ia0h1?=
 =?utf-8?B?d0kxemd2clZGTE5XTlZGMDA5dUc2ak5XZDZUbnNxNy81YUI4dktwY3VQWCtN?=
 =?utf-8?B?RklHc2t4Qy9ocmJpVDRyQkZCdjdiakJVS0VmZmdXSHRjZDVmdlhWZ1Z0UEJp?=
 =?utf-8?B?MGdhZlBocEFib1IxODM0T1c4TVU5RXZZR0g5YnBCVjhTTkFSTk53aE16dGhP?=
 =?utf-8?B?K1V5YlNkOGhWZ29jQ1lwcndEblF2R3VTOTdJbjMxU2hFWXp4VElqMlA3c2k0?=
 =?utf-8?B?aWw1LzZwdXpRNHlaNVFFa1Y1MkF0VnBIeVp4VlhTWHZ6V3pYRUgvRkQzYXFC?=
 =?utf-8?B?ODBrT2hBQ3hhTTd5WTAvekl0Z3FUN255SXBNVExKOU8zNHVSODdUbmRVeXBp?=
 =?utf-8?B?dnhiRjBDbVpPblpLallHaWpjM0t5UnoxRDVPb0VUTGhzd1YzQUhZNkdGSmdm?=
 =?utf-8?B?a2dVNjNpYjRKRTc1SncvdE5uSWNYbnBIQW8vaXNuRG1ycERPRGhFeGRUUzhI?=
 =?utf-8?B?cnRlenE3OXNmc21hWXZwbDFCRWM5UXpKM0RtMjZnSGNIVmlPdGVWcVYyMW1Q?=
 =?utf-8?B?S2lqNVVpbUx1T3R0RkNyN1BnYXJHRHBZRkQ5eXZ2TXBWNmw3SDE0bFBmZDVN?=
 =?utf-8?B?Wit2WHM2R2F3TlJybWtuSHB3djFhejVlVWR1SUtCK3RMRVBxdUNhTmNGbWpa?=
 =?utf-8?B?dGl5emZCVHByZ29MNG1LZzVZTld6SHN4K01MV0FLRVV3bWx0bklUL0orVFlh?=
 =?utf-8?B?K1VTaXp0VGhCcTBaSHNMaFlJOHF4YWo3cVFZZ3NOMXMrWUZCdzlMK1JSZkxa?=
 =?utf-8?B?b0hnakNuQkwyb09iejVvV0hrVUViSzRQY1RCdmdGajlIZlZVWU5kQTJtL3Iy?=
 =?utf-8?B?a3NQZ0U1UU9tenR6OCthdnZ4OTJlQk9zUlcxTW5OL0tYM2ErYUQ5UVVZWUJU?=
 =?utf-8?B?bmRvN0xrc3h5ZmdRQ0hLOHZGaVRnOU5tcEZvVk9wNFlTVCt0eEVjdzAvb2k0?=
 =?utf-8?B?RWk4ajkzeWw3YVlmbmZPTUlNcGZmQU9XZU11WmFzYmNVaTEvdlNuS29FS2pj?=
 =?utf-8?B?YmRGRkcrYVlvajdCMFZoMjJNUWluR2l3bWRsT3IycTNRUXRyVk41Zy9QZ0RV?=
 =?utf-8?B?UTNrSnBtdUZOS0lFS3cxMmt1aWNSL1ZCdGg4enlER1NJYWRZY09lb2FvTFB3?=
 =?utf-8?B?RDQvT3lQbi9wOFB5MmQwVWVPRHNVYlJtR0RnNmg1WExkYWJjYlNoS0xJSXp3?=
 =?utf-8?B?R0lHaVV1c3lwR0czc2NnK0tXRkhqenhzc0JNeW1RbmFWWTVSclpSbHZKcUdZ?=
 =?utf-8?B?RlZLcnAwcXVORTQvR25lcUsvR3Z4cDNpVWVlNmFnTFUvZE9tTUNJQlFHcU9w?=
 =?utf-8?B?Wm1kZXA0ODl3TlhIazZ1RUVyYi9ieHUwbkN6YWJFMFJqb2FRcnhtOEMvZUdL?=
 =?utf-8?Q?T75r4bhI2nh+zguTUfGZYrM9j03GrCHyTxP+Ql3?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(7416011)(1800799021)(366013)(921017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RnkraGVrdDRaQ0pLYUlRbVpxMkFQc3VZVmI0VHc3NlpkTEQxMHMybDdtcWxH?=
 =?utf-8?B?TnRNK0laMXpDWDlxbWRwaFpUSjZ4aEF3NStvWkJDT1FXdllpZHN4OERTU0JY?=
 =?utf-8?B?MFR3ODB2aXdrVXYyN2pWemFwTmo0aUpyNUhhZzNHUEpsQU1yOGJ3c1hhODI1?=
 =?utf-8?B?V0xLd3AxTkhIODlyMzhuaGc4bXhlbi9sd3NUTkVKa3d5OWNhRER4MEFJbmRi?=
 =?utf-8?B?OTVUdzMxL2NtT216VDlTcEdicjJMZEhlcG9hZlc1SkNGRDErMG1zaFVhUENF?=
 =?utf-8?B?b1hEOVN3Y0w1Yld5ZThRTGpmeHZOOFVvNHgwbnZXZHBONXdNYUo3dTNhWnpm?=
 =?utf-8?B?dFYrU2FXd0FFYzVuM0tTNVRqb2d3MFlMRkUwWEFRaXduN3RZTlduSHV1c2xV?=
 =?utf-8?B?OWVVdjd4VGlDT3RheTBqdm1uY0l1dHlLWnowVWpaamJyT3RxVkhnRVpPMGdP?=
 =?utf-8?B?dHFuTHRQMWFMekppbEF0U3d3WkwycmhqNUlucExhaTFtWHErME16cG1oUEg2?=
 =?utf-8?B?enNxNHlGamdHZTlSMCtybjVHVUQyeVVSNzVJZE56SmhPYmxrTXlIOTdvS3g2?=
 =?utf-8?B?MkhEbVByb0U5R2VzYjhXYmJNOFhNd2NTVm1kYlZiTU8xZjZIeGMzMjVLV21M?=
 =?utf-8?B?Tnk5dEVlU09aL09QbFVBd3dtam5hU0RqNjBTK0VjVGE3WlRiQlpJTFA5S2Jx?=
 =?utf-8?B?L1NNMDFRTWV0TEFMd3dMbXRhN0JGenI3SDA3SVhlUTNSR25aY2NTWlNEd3Fp?=
 =?utf-8?B?QlRCQWpwY2lLYXNScGJDK2JtYjR4M01Ubk1qRzFUMVQ5OGR2anZtRVBiMkhG?=
 =?utf-8?B?TnB1L0M5K1lHRVgwNFlmWGlXdExHQjBON3dyWG52cStOd0ZwRmhVbEhxOXQ1?=
 =?utf-8?B?QS9iYVFCaXBrWDl2S1paZ0J0L05xc3FacWJVdlRNRS9QcW5PQnRZQTgzRE1z?=
 =?utf-8?B?RDR4aGg3REN5VkFaV2tkdG9EUWEyT2VmR2szVERaV1krb3VrV2tGSWNDd3ky?=
 =?utf-8?B?OXpUQ3JPZVJOcGI1b0wvcjczVjJxOWdFNlVvbXg5WjRxa3E3dzRiSk9IOHZ3?=
 =?utf-8?B?WnZTZHEzLzFSM2hDT3VPSW94K1dRZUlPZmM4STZVNzlpZlNIc1J1ODlWd2Vv?=
 =?utf-8?B?YXZ3Z1Y3UnNDbDh5S3hhMkJnM0JneXlYSVZXeU55MytQZnNScC9EYTI4MEZZ?=
 =?utf-8?B?aFlzcmJWZXdLRmNrK1ZuN1g4SVJrZ2hnV2c2M2oxc2x6T1dzcWtuNDJ1R3Iy?=
 =?utf-8?B?ek1FbGRXZmJ4RC9wSTlqcHM0Z1paRGphSkZBRzRpblMvS0cwcURSa25tUGZV?=
 =?utf-8?B?cFh5ZjFWZXFlQWhqRWxBbUtQbDIvL0J6SlRYY2thTnZhTllvcmV2bmpSTHJj?=
 =?utf-8?B?WHExVEJxNExOb2FrdFAvQ3pkem9BcGR0aDlBRklVVFFQWUwrZTRQVDlrK1Rp?=
 =?utf-8?B?TUFwQUN1REN4S2FVbWN0cjJaL1pXSUtBd05CNWlNUGtxWGpPekJQV1AyWXpY?=
 =?utf-8?B?WFNadE95TjFZcndSV3BTSS9SdnpZRTFjanlaTVRjVWZYbmIxWmJEWjRoWWUz?=
 =?utf-8?B?SkJaT09nYmVFT1Bpbm5Ob3RJeWJaaFBIcDhyQWhhRDNOd2JJWld1WEMzNWg5?=
 =?utf-8?B?U2NDdjEyTDNlUXdFdHc3dVZ1VEJSYXFWdncvaVFlSmhhWlY4ejAxQkVyTXc4?=
 =?utf-8?B?eVRkK01mMXhMc3pEbnlmckVaeVlWSitROXUvcVVMNkMwRmw2d1lZTEd5SEN2?=
 =?utf-8?B?bmhPQ3dzN2M2ZFNrQ2pjNHNmY05yMTZZcmJaSXI0dDQwaUIyTG11MkEzTFBy?=
 =?utf-8?B?UGZuQU1iYnFYV0hmYnJiUXZ2bDJNVnczVFNRMmIyZkVVcXJQWGNnSVRQOGIy?=
 =?utf-8?B?UEpDeG1RN214cjlldk1JdktGZXRYMVl3MEdLcFNZZ05kV1V4dVp3MGRESkp1?=
 =?utf-8?B?WER1M21nM2tjMUtwWUV4WHQ4WXBGZ0M1bmdzS292UkY1Z2NDZnpIQ1hpL2dQ?=
 =?utf-8?B?SkU5TENGZUkvMnRERXlMS2hMcE9jVDV5VlZjRGJ3SHZwWE13RGZiZXZxNWgz?=
 =?utf-8?B?d1FJS0E2Qmw1djlIUTdqWWFvTkZQVnhkSGhkbEJ4ekd4eUdybDdiY0dibzFE?=
 =?utf-8?B?MkN2OWtpNk1zV3dKSEg1ZkNrQkRWV3VFTjdaZm9UVkdZUzNsSVExMkxyaDl1?=
 =?utf-8?B?SUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	MQ96v4ROxGOAYkdQRaIS431EZ0blQlO413kqwYo+zFSVHsmg0B8NeM2sOZZ5FQA/MjPU70TtriUjwvSVHYjsdLCDRAkP3hCWi+EpWOjcLqVhSaQbNPn9ExxEz96Tnpi8fIF2fQSFJA8zNTVm3JNFOCNSDO8KwP7ZCGyKWo2oicXwgC1PAbc5KltOHi+c8XdMCBKiIphC50VZWVloigtsn6a2q01NNhqUZQcEXlrySEIi6riVMb1cZCt2+555gPVSCoV7JDzSmQe4dRz8wPEEgq3cKodMdV2gjFx5zjIf87+hn1LMWArJKXCoFbCAoaP5KGkohhRs1ocRWDZb7iEHuyJN5Kgi68ZQcaJEUcgKFt+k31XU2F9G2R4y6fGQ7ed8K7VSnacJITWwOi2e0UBZ0zw7VwFMgioFe88ozF6WpHB7Ae8BOhcTBAipBjjOOEzXiEblWDWT/jSGRpfczVGOVM2Ji8AHAkbTNgePxQoMko4fNrZ4Lh2SjihfnTvu4x3MUnIxbZbugtUSVb/WhytPpLQMEWEvUHEor4Gv8qWKbFudLBLlGIhuCHF2TcxN56+t5Whz8p8WLMrQNet5dHbLJP5/dJzAoDD3WsFWATsn47U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed406428-5f39-4a13-a135-08dc91281c2e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 12:54:23.8404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gysIAwzLlRj1Z+b8mdSRW/MhWILPte6flMSsGe70fMzCLXjLqY5P5uk3sHYwZk0ifqmuXnRPvIVrZWCKv1856Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7695
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_07,2024-06-20_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406200092
X-Proofpoint-ORIG-GUID: hrm27mvGUQFHCLeRO1eykvOdgNR6WCNi
X-Proofpoint-GUID: hrm27mvGUQFHCLeRO1eykvOdgNR6WCNi

This series introduces a proposal to implementing atomic writes in the
kernel for torn-write protection.

This series takes the approach of adding a new "atomic" flag to each of
pwritev2() and iocb->ki_flags - RWF_ATOMIC and IOCB_ATOMIC, respectively.
When set, these indicate that we want the write issued "atomically".

Only direct IO is supported and for block devices here. For this, atomic
write HW is required, like SCSI ATOMIC WRITE (16).

XFS FS support has previously been posted at:
https://lore.kernel.org/linux-xfs/20240607143919.2622319-1-john.g.garry@oracle.com/T/#t

Updated man pages have been posted at:
https://lore.kernel.org/lkml/20240124112731.28579-1-john.g.garry@oracle.com/T/#m520dca97a9748de352b5a723d3155a4bb1e46456

The goal here is to provide an interface that allows applications use
application-specific block sizes larger than logical block size
reported by the storage device or larger than filesystem block size as
reported by stat().

With this new interface, application blocks will never be torn or
fractured when written. For a power fail, for each individual application
block, all or none of the data to be written. A racing atomic write and
read will mean that the read sees all the old data or all the new data,
but never a mix of old and new.

Three new fields are added to struct statx - atomic_write_unit_min,
atomic_write_unit_max, and atomic_write_segments_max. For each atomic
individual write, the total length of a write must be a between
atomic_write_unit_min and atomic_write_unit_max, inclusive, and a
power-of-2. The write must also be at a natural offset in the file
wrt the write length. For pwritev2, iovcnt is limited by
atomic_write_segments_max.

There has been some discussion on untorn buffered writes support at:
https://lore.kernel.org/linux-fsdevel/20240601093325.GC247052@mit.edu/T/#t

That conversation continues.

SCSI sd.c and scsi_debug and NVMe kernel support is added.

This series is based on Jens' for-6.11/block-limits branch at commit
339d3948c07b ("block: move the bounce flag into the features field").

Patches can be found at:
https://github.com/johnpgarry/linux/commits/atomic-writes-v6.10-v9

Changes since v8:
- Rebase
- Update comment on nvme_valid_atomic_write()
- Update chunk sectors vs atomic boundary support
- Add Martin and Darrick's review tags (thanks!)

Changes since v7:
- Generalize block chunk_sectors support (Hannes)
- Relocate and reorder args for generic_atomic_write_valid (Christoph)
- Drop rq_straddles_atomic_write_boundary()

Alan Adamson (1):
  nvme: Atomic write support

John Garry (6):
  block: Pass blk_queue_get_max_sectors() a request pointer
  block: Generalize chunk_sectors support as boundary support
  block: Add core atomic write support
  block: Add fops atomic write support
  scsi: sd: Atomic write support
  scsi: scsi_debug: Atomic write support

Prasad Singamsetty (3):
  fs: Initial atomic write support
  fs: Add initial atomic write support info to statx
  block: Add atomic write support for statx

 Documentation/ABI/stable/sysfs-block |  53 +++
 block/bdev.c                         |  36 +-
 block/blk-core.c                     |  19 +
 block/blk-merge.c                    |  67 ++-
 block/blk-mq.c                       |   2 +-
 block/blk-settings.c                 |  88 ++++
 block/blk-sysfs.c                    |  33 ++
 block/blk.h                          |   9 +-
 block/fops.c                         |  20 +-
 drivers/md/dm.c                      |   2 +-
 drivers/nvme/host/core.c             |  52 +++
 drivers/scsi/scsi_debug.c            | 588 +++++++++++++++++++++------
 drivers/scsi/scsi_trace.c            |  22 +
 drivers/scsi/sd.c                    |  93 ++++-
 drivers/scsi/sd.h                    |   8 +
 fs/aio.c                             |   8 +-
 fs/btrfs/ioctl.c                     |   2 +-
 fs/read_write.c                      |  18 +-
 fs/stat.c                            |  50 ++-
 include/linux/blk_types.h            |   8 +-
 include/linux/blkdev.h               |  74 +++-
 include/linux/fs.h                   |  20 +-
 include/linux/stat.h                 |   3 +
 include/scsi/scsi_proto.h            |   1 +
 include/trace/events/scsi.h          |   1 +
 include/uapi/linux/fs.h              |   5 +-
 include/uapi/linux/stat.h            |  12 +-
 io_uring/rw.c                        |   9 +-
 28 files changed, 1111 insertions(+), 192 deletions(-)

-- 
2.31.1


