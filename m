Return-Path: <io-uring+bounces-2153-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10F3B901FC8
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 12:49:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E901281860
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 10:49:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6C1713D899;
	Mon, 10 Jun 2024 10:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KjXCX7SU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="azU+s3lS"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE13139583;
	Mon, 10 Jun 2024 10:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718016294; cv=fail; b=cwobYNeRyFCIqEMjSrWB7usSkSJijsZ5Pb2xf8fdO32cOL/2r6igLEnDyq/Hc3ny+ljhOmd9IAtb+9bjHsfjT2+0KryuUvBs6WwNBN6t1f6L3j5BVbYmw9t3kT0Qt1ouTMI9+1cNp5vviOm7MKjrdX++hpz4DKfdtLAQ8ccN+Sg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718016294; c=relaxed/simple;
	bh=iki/1NYZ9YoGpsiuRdEgpVnO8uPeskpeOIqE392MusA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sMMDWB+3ygcYVenZrcIpqOiKjWvG8KUR3QzsNSNQ7rc7xvd9v3DLCL5elTjl+ShBwkDoVL0WcOpD51y/bWAcJLIjtbH9bZplEQaTOr4XxD7AZXB455LVqA/5D41K9fypyrbaVdJf6446VJUZVVM007ZyODdN//EXx+U02+fh0rM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KjXCX7SU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=azU+s3lS; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45A4BRx6024983;
	Mon, 10 Jun 2024 10:44:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=IzYMElQdoafm/KOiCJoqkqo8DHg2mUS9JMz/MJ0HTqY=; b=
	KjXCX7SUri0Sl3DgGrzH5Y6jtNB87c2mdEXOBWob+HIJUVYxKMGp6ELzyiVCl1W/
	btslEEuLhMZmreSn3Slz6d7T4rLkcWIQFUuB8UyetjMQCERmRbnl84L3018hIbOU
	s5FzyqejswV344MQ0r3G+NL0leWo+JE7WmA92d0AntjWRIrKoirFMyCr/BkHJ6q0
	VupPq+Ks1oRlzcZKwg2qWS5HrNpSXLgvItcSbHwr2jktUYJAevPQw74ILvJ/W88J
	/fOZxmeUEROhUI1huL7VqqU+k3YOdDtVZgGISu6fBaLmmTkebDPM7omPygeU4l0I
	bsA8h7qC++yMLWlcqKEyNg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh7dj8j2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 10:44:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45AA4BwO021545;
	Mon, 10 Jun 2024 10:44:14 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yncasuep3-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 10:44:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wtl/DwLov5dVcfFR7HI+E9HK+UepQoYsyZMK6k+/t0/u349WfU0IsgCGI9mCKaKbFNFMNgQJBpjC3tLSq+mbwncw1qPRPL6W16pE+98onf42jQ3ojxtQm9ejIezfj7IaAqea4JRZxUa7BMiDQ8ATLSuynDDw4IlK46muNFhSxohr0eiB+DLD/7Tqdh7f4KpvglBTAVJFW/FcLMYcu7q48Q09J69C5MweRaPOudzsIkQRHT8trNR4x5tlZZJzg32j4J5w1zaRZ63FPgUomREoN6Zz6VEmJGzkxUNbEVLbMJ/AWpaFg9+1jz6ujG/C/ISkZl6BxgcyQRoJ0qtsq3Zygg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IzYMElQdoafm/KOiCJoqkqo8DHg2mUS9JMz/MJ0HTqY=;
 b=W9DEgM4HoBgv33VT2ZQ4OJeVQJBFdMISM028jxgAl++5fPE7/v2/2BxKl8G3wEH91qzNB83l5G7QyWYIpNazkXu+8hFdY+un13R6hMbH/QLnzxK2yHRTED/NIKGKrHf50zzib5AB5pXCcDGvSc/tGWkEdLtL3bv9p4qPWzcA1JiXak7atHehc9kH9gyIhLUruxsGQjPN4/SA8cIlFOOYggr7X9AO2gRua+7gbveER5unt7ar+gNH2ENyEOAifmxD3Xb6qmcy2cVA8PcJ8+WdzR4nxDqZtddiU9OsO/qKD7qfVmGHR5upC6p+mmhaoU4gnYB+eu/AYOrwfPPLNfrfAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IzYMElQdoafm/KOiCJoqkqo8DHg2mUS9JMz/MJ0HTqY=;
 b=azU+s3lSx3xkoKCalq0N0SRq38SrbVfuYYTdH/IW9EgiigKdPYF8XyZfNNURfQ1B7EtwPdfBkOAv0nIAHVC1qVQluAV+vFORoZeQ+WBKpjoBpEy9Aiz2vAOZ4squCZA/8tKne7fMfzTGU6xFykFFl6ttSP4BL94vNUjsFc0P6sw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB5613.namprd10.prod.outlook.com (2603:10b6:a03:3d0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.31; Mon, 10 Jun
 2024 10:44:11 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7633.036; Mon, 10 Jun 2024
 10:44:11 +0000
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
        Alan Adamson <alan.adamson@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v8 10/10] nvme: Atomic write support
Date: Mon, 10 Jun 2024 10:43:29 +0000
Message-Id: <20240610104329.3555488-11-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240610104329.3555488-1-john.g.garry@oracle.com>
References: <20240610104329.3555488-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0036.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ae::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB5613:EE_
X-MS-Office365-Filtering-Correlation-Id: c3f4dc8f-58ea-4540-1aae-08dc893a4341
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230031|7416005|376005|1800799015|366007|921011;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?eVZwQzVLRGtCR1VjSFpVSlBYeVkvbzlZQXE1cjlyNGRBNTUwVnB0YWlJUHRG?=
 =?utf-8?B?SlpubjVQL3Rzcm0rN2YwQy9OTnRoZjJuc1dKRitxYUNERTVPU3VTaXlSbzhh?=
 =?utf-8?B?dnZkZ3c4cjR2RHdtK0pQYk11N0p3YXRPT0tSbndjQTRLMC9zOWNObHlkL0lz?=
 =?utf-8?B?WVVSMlRwOTkycFAxeUx4dmx6NjBoK29Zbm9oZ0NkNjhuMHUwZE9DRnphelQ0?=
 =?utf-8?B?ZWc2YlowRXppNkEvQnVhL3ZmMTNGMWdGTUVtVnNnRm96STFoWWJNY2V4Q3M0?=
 =?utf-8?B?VWNhTnE3MEhycXcyUVFVOE40elo5QndEMWFKSC9tdnd3dHlFSWY4U3dKZHU3?=
 =?utf-8?B?UlVPWUZQSE5ZSFdrdEFaSEdEc1A1a0NDdWJyblVsbEVqOWhxU1lXTjJXK2Yx?=
 =?utf-8?B?d0pweG9WcTQ4NVlNSnB0VUJ3aE5Ba2VoL2VSRHllRk9CRm9NNXdsek5idUxZ?=
 =?utf-8?B?TEpUTDcyNWJ2SWw3L3pML21EOFMxYmpIS0tDZlQvRkJYdDg5aVhxaFZFbWtl?=
 =?utf-8?B?MjY1VVRHaFR2MFhZa0N1M2cvbDE5c0Mza09XUERhYTdDQjhkR0g2eWJ2MGxD?=
 =?utf-8?B?Zk1zRGNuT0dRTU1IR3ZwUEFzOEJxMTViNll5OVpIYnBrUWF4U2JhMWRYbXRS?=
 =?utf-8?B?MFVleU9Mb0FGYjZ2Y1pLQTBjSndzdUlEVnMrdG9ES0pOSTJxT2Nwc0ViZFRa?=
 =?utf-8?B?Wk9JV29LU0t6c05SYWU1UnlnVm1hOCsvSjM1Sjh6NFNHQU9UM1k1cmhYcFJr?=
 =?utf-8?B?S3JKby9tK0lhSnFhY1F5cFl2YStKNHdJZmF5a2k5OEUweVpzSVlZUkEwMWtX?=
 =?utf-8?B?UE50NUFxRWJnZWVQVHdQTnF2Q0g3b0hpamdhdVROMDJzZG4rektranZMMUxK?=
 =?utf-8?B?aC9SSkx5OGJKN25maHhVRFR4WkZYRUhQQUVVR1M4NVRVYW9KSXNRYmc0TzRF?=
 =?utf-8?B?eWtCWHZHWTliVlBLVWlqSWtLTG9OTW5sNjQ4OUpBZExpUFNxcXhUdGIzdUls?=
 =?utf-8?B?a0ZEd1ozN05IczhQVGUzMnM2MEREeFEwMjlWdm5IeUc2YTh5czZRRlhNeU9O?=
 =?utf-8?B?YzZST2o4YWU2bDRxdGh6OGdCUHVvclNxNEYvM3NJZ0RiMWZHZTcvUWxyRzNq?=
 =?utf-8?B?ZW9DVUxmWmduNTFsZjIwZ1J3ZzBkODhnMFhiOXYvTTNnQm5PNGxVMm05R3pP?=
 =?utf-8?B?T3cvQ0VHK25SL3F5MHhVbDFuU0J6ei9hSUZJY3FWR0dOMkFFMzBBaTd2L3NS?=
 =?utf-8?B?MERvTS9mQ0M1ZzJaSWNjZWN1N3gvUFlPYzA2dWQ3YjV1NWFDSWczWElqK3Uz?=
 =?utf-8?B?NlBYVER1R21hcngvdlRxa290ckpoUUl6a0JXUjEvYm1iQ3RRT3VJQ2FpREVy?=
 =?utf-8?B?TnZ4eWNhWDBFSkdUWi9yT05jQjZMWGlzQlVpNWoySHVYWVdWcHRXdk1iUkM0?=
 =?utf-8?B?Tit1QWtDaktKcHVPcDIxbUxHMmU2TmUyRVl6MnBFeDZOTTlZQ2tHUkxlcGd2?=
 =?utf-8?B?ZXoyRUdWTEtkT2tjRWpGeHk0N0orL2VDWTF2OHZ3S05JZ1VkUmZ6alluYTFj?=
 =?utf-8?B?ekN3V3NlR1dNUWhzQ2Erd2VBN05NNFdHMUwyZHpoQUFLNHB6ZFJFRjZ1eVh3?=
 =?utf-8?B?TTN4ZnUzVWlJYTdSblp3WFBZRkhsdUVmSEVEMHdoZUFqRVFPVUtkaUR2REJJ?=
 =?utf-8?B?bmt2TUhKRkhEN1JSL211dlV0TmcyR3IrTEJ0WnJCTzZSSEJvVXRJTTFBY3lr?=
 =?utf-8?B?c2krOGtpVloxNGIyMDdDNm1JTzlTUTRCeWd3MHR0elFCT0hYdGMySkdlUDJT?=
 =?utf-8?Q?6dvPk0biwfYN8vK3U33dHvg80ETJJh2fXdtpA=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?QVBWNkQ0S29KRnV3M2Q5emtvTG9RYWVSVEFoNzUwbzU4WnlQbnViTFJLWDhS?=
 =?utf-8?B?OGFBblZWTXU2SU1YT3RrRWttb1hmaTYzM3VCN0xaU05tUDM2TlhMMW5IdGVD?=
 =?utf-8?B?N1llVWhzMkxqOFNIektHeHBody9BczlzN1p5RTBDTEJNaHVSYitGZDNVZzdW?=
 =?utf-8?B?aTV0TDM5TmEvKzFEcURvb3FMU3YrRTJHSVZycVAvRFQvdUUwTXlQN3k2ZGFH?=
 =?utf-8?B?QTdGUHJqSURVb0tydlgrRnA4b0tveGFBTGNsS3pZUGoremwybnVnNU52dkpN?=
 =?utf-8?B?VkJtdGZVeCt6K0p4aXpYNEtlRW9ndnorR0JucjQvN3FkdVJ6aG84VjV4STRB?=
 =?utf-8?B?N3ozdC9HUWp1a3ZydVNjRmllT3dqQ1hzVndmWWdERWpLbnZnNm8rVVFlaVNh?=
 =?utf-8?B?NlIwZXVPN0p2SGFDRmxOL3NmYjVrYkJWaElNUUpLdHBySmxiUzFDY2UwSVI4?=
 =?utf-8?B?aGJERERJbGp4Q3lQQlpGZC9JTW9ZTCs3WkJOTDlRZXNKci9FK3F2amVoSVRz?=
 =?utf-8?B?azcwSGp4L2V2elo3dnI1emUxanZUTHI0VTI4aHJBb0d2UkxMWjdCMWx2SFk1?=
 =?utf-8?B?anZ0V3FYaGVzU2JmNEowd1U4a0R3L0lIZTQ1T1dHYklIVVp5cWZ6QzlDTGQy?=
 =?utf-8?B?b2VqZDNKWXI2aEhaMnE2U25ZSGJoWHl3T01uL2g5QjNsQk1OdVdFRWtkQVNI?=
 =?utf-8?B?SlVtTkd5VUdVY3cxd2tLRTlQMHlrQ2RjbENUUmZYakFlR01IeWd0dW1hOG4v?=
 =?utf-8?B?WGc2dEtwMmFwMDF3TFJULzZoeDdUY2d5NHNIQUhQVEw0TWxGWXByZTRyZW1C?=
 =?utf-8?B?WEFYQThoRWxxUWVDbGw5Q0JKbENSK25tWnlYSmtDc0pRbDVETERidk9OeG4w?=
 =?utf-8?B?ajJKejI5eHlUUURtVC9hQ0I2Zjk1TTFIb0hNcUxkblFNRmdtc01uMHBIWXFw?=
 =?utf-8?B?d2hZWTFRSjh4d3ZiU3lvR0JDVXl2T1F3NUhtUzkxcWdmb1kyNDRxMG5GVkY2?=
 =?utf-8?B?SEVIOEppU3dwVmZmRDdRVndrbzRQdXJGeHowWkVmYXlidUhVanIzandUMFBu?=
 =?utf-8?B?YkZSRlJuc0xhQVdQVWdJUHZ2T0IzTWV4b2Q5aDVSWWcwZ2hicWJvbmFXSmNP?=
 =?utf-8?B?OWJoUHRnNGZEZkdNRnlaOE0wU2RJTGFsTE10YTB5Mnh3Q1JFYmpCRUlPQ2R5?=
 =?utf-8?B?WnI0cmUwNWs1WWxibXNKN1p1V3NkZnBsVGcyUE1BeDhqbXZkQWc4RlpwbWdz?=
 =?utf-8?B?MWVLTExET2dXeDNIV1dnZk9CT2VWcGVXbE9DM3JNcDZteUI0d0hDOE5oV0cw?=
 =?utf-8?B?UDJHUEEwTTAyRjI4WmR4VytYK3FQdm4wNkVSbkdwVGNVb0duTlp4Qk9ScCtz?=
 =?utf-8?B?Tm1wU2ZrcjByZU9VYTlBcHpYc0FwdjVlOGNGVWMvcmJkMnAyYWU3d2VycGh2?=
 =?utf-8?B?UkpmZTNIcVRjMkJSN0swU0FEZEJ3NGdPNmpJeFZzUXlyOENiK09LMGRDcENK?=
 =?utf-8?B?b0hVaWJQQjRTSXhjRjIrM0FQdHNsYW4vMWxQMHB3cHF5UTZHQWxuS0VQRjJT?=
 =?utf-8?B?KzBLc1MyWDdWR3BjMVliMGNGbUpzUzRNRVVLQk5Rd205MEpvNEtqU0ozVUp5?=
 =?utf-8?B?MUtaRytGSGlYN21OVEZVZ2d4aG1Mc2xqSitYRFFmbVBVWXB1NUpXSVNNVkdW?=
 =?utf-8?B?MEMzczdIaU9aY1Q5MnA3TlZ1QTQ5M3lWYkRPWVIvd0lxVCsxbEcreDVNc2g5?=
 =?utf-8?B?UlVaVVc1QkUreHJROGROcGMvNWZVVUN0ZnJLOE9hYzV4Q2hhdVJPNlpUdnBz?=
 =?utf-8?B?SUE0a0c1ZlZZZndoeDJ0NXIvamJxTUE0djkzbU94SUh6WCtRMG9xQkNBazZQ?=
 =?utf-8?B?b2lPSVM4T2JSMXpSQk56T3E1TDlkUXQ1UmRvbVRDVEZaRms1b29qdzJMREsx?=
 =?utf-8?B?ZW51NXh0alBmZStwVzFCVGNwbGdLS1phWWREVkt2SjNmcG5IMnRseTVwdzNu?=
 =?utf-8?B?cUk1RzVqSCtWS2IyRHNXOWNXVU1vNmxlUC9vaGllV2Q5OVdlenh3b2dDb1Vt?=
 =?utf-8?B?ZUQrVE5RWWxScU1sek5ma2tqM2VKdHhCWHFRQzdISEIzSjBnRVpQV3ZIUVk2?=
 =?utf-8?B?Q05kWlgrUHp5T3RUdzEzLzdGL3cwZlBKUCtYMWhuMzBmT3BmcVZORFg0R1Ay?=
 =?utf-8?B?M3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ak7TbKT66zYXtPBGpHMW4paXrl2ibaiugxnwrEvR6REUEdIKDfnDwEWTqYNXTDTyBTALMXk2r2fpcrsdT5b5fT3J/2SrM5X4kppn4rjOVSOhLYjfMuK4BdU9b/TibkQ3E0+/UwbMlv37SICXNS9N8jSMJst6/mdqODOeNQMqdsdvW28xhIUVC4vof2x8OMkQFRipRoHx9619WPs/FiyerawuITW8xU01Hoi0D/LUSN8B33e+l1VpLo4vshMFOYdh9vMvG+x2fNOeOfcldYSgEGtFeKMR0JSAIMKqKKCGmL69gSF8+D5Oi7PQq2s9Mi7Vwn+xS6aCMPjuavOv/gOhHxBUsVH6gxdFSJW76HYuZmaCiLvlgfqYcoXLdzOFOXgV8U74gRh2gw9VzU5IBvLaTOh9SsWVDo83h7DyV9xkjHG9VKW4sLIj8Arhs613LiHfgnbV26kMtftTntBbLEuCGDO482rcwGbKpXVVoN5Jjcdln3YJCptJ8f2G3+ShgL1GjjlcUbOrekrv7AmMs/+50z41n9wIYwwp3jcDW7O1zBwT+kFobWS/Kjjp3UMu1zsLm/lMxKaQEI7qIXBXAKECU6CIWIc/hEW5C9C2Qg7iYlY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3f4dc8f-58ea-4540-1aae-08dc893a4341
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2024 10:44:11.0211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HyWTxtyrc6n7LDVLpJvs0gKax0gych5oGOvFGySS9EIoJbW2TqetlTxbV488HqVV9WpJ3Pyw9c5kT0eE1NtBqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5613
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-10_02,2024-06-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406100081
X-Proofpoint-GUID: 3oVZGuYJx9fSa9lTTXE_tmRHvvyxknO-
X-Proofpoint-ORIG-GUID: 3oVZGuYJx9fSa9lTTXE_tmRHvvyxknO-

From: Alan Adamson <alan.adamson@oracle.com>

Add support to set block layer request_queue atomic write limits. The
limits will be derived from either the namespace or controller atomic
parameters.

NVMe atomic-related parameters are grouped into "normal" and "power-fail"
(or PF) class of parameter. For atomic write support, only PF parameters
are of interest. The "normal" parameters are concerned with racing reads
and writes (which also applies to PF). See NVM Command Set Specification
Revision 1.0d section 2.1.4 for reference.

Whether to use per namespace or controller atomic parameters is decided by
NSFEAT bit 1 - see Figure 97: Identify – Identify Namespace Data
Structure, NVM Command Set.

NVMe namespaces may define an atomic boundary, whereby no atomic guarantees
are provided for a write which straddles this per-lba space boundary. The
block layer merging policy is such that no merges may occur in which the
resultant request would straddle such a boundary.

Unlike SCSI, NVMe specifies no granularity or alignment rules, apart from
atomic boundary rule. In addition, again unlike SCSI, there is no
dedicated atomic write command - a write which adheres to the atomic size
limit and boundary is implicitly atomic.

If NSFEAT bit 1 is set, the following parameters are of interest:
- NAWUPF (Namespace Atomic Write Unit Power Fail)
- NABSPF (Namespace Atomic Boundary Size Power Fail)
- NABO (Namespace Atomic Boundary Offset)

and we set request_queue limits as follows:
- atomic_write_unit_max = rounddown_pow_of_two(NAWUPF)
- atomic_write_max_bytes = NAWUPF
- atomic_write_boundary = NABSPF

If in the unlikely scenario that NABO is non-zero, then atomic writes will
not be supported at all as dealing with this adds extra complexity. This
policy may change in future.

In all cases, atomic_write_unit_min is set to the logical block size.

If NSFEAT bit 1 is unset, the following parameter is of interest:
- AWUPF (Atomic Write Unit Power Fail)

and we set request_queue limits as follows:
- atomic_write_unit_max = rounddown_pow_of_two(AWUPF)
- atomic_write_max_bytes = AWUPF
- atomic_write_boundary = 0

A new function, nvme_valid_atomic_write(), is also called from submission
path to verify that a request has been submitted to the driver will
actually be executed atomically. As mentioned, there is no dedicated NVMe
atomic write command (which may error for a command which exceeds the
controller atomic write limits).

Note on NABSPF:
There seems to be some vagueness in the spec as to whether NABSPF applies
for NSFEAT bit 1 being unset. Figure 97 does not explicitly mention NABSPF
and how it is affected by bit 1. However Figure 4 does tell to check Figure
97 for info about per-namespace parameters, which NABSPF is, so it is
implied. However currently nvme_update_disk_info() does check namespace
parameter NABO regardless of this bit.

Signed-off-by: Alan Adamson <alan.adamson@oracle.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
jpg: total rewrite
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/core.c | 49 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f5d150c62955..91001892f60b 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -927,6 +927,30 @@ static inline blk_status_t nvme_setup_write_zeroes(struct nvme_ns *ns,
 	return BLK_STS_OK;
 }
 
+static bool nvme_valid_atomic_write(struct request *req)
+{
+	struct request_queue *q = req->q;
+	u32 boundary_bytes = queue_atomic_write_boundary_bytes(q);
+
+	if (blk_rq_bytes(req) > queue_atomic_write_unit_max_bytes(q))
+		return false;
+
+	if (boundary_bytes) {
+		u64 mask = boundary_bytes - 1, imask = ~mask;
+		u64 start = blk_rq_pos(req) << SECTOR_SHIFT;
+		u64 end = start + blk_rq_bytes(req) - 1;
+
+		/* If greater then must be crossing a boundary */
+		if (blk_rq_bytes(req) > boundary_bytes)
+			return false;
+
+		if ((start & imask) != (end & imask))
+			return false;
+	}
+
+	return true;
+}
+
 static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
 		struct request *req, struct nvme_command *cmnd,
 		enum nvme_opcode op)
@@ -941,6 +965,12 @@ static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
 
 	if (req->cmd_flags & REQ_RAHEAD)
 		dsmgmt |= NVME_RW_DSM_FREQ_PREFETCH;
+	/*
+	 * Ensure that nothing has been sent which cannot be executed
+	 * atomically.
+	 */
+	if (req->cmd_flags & REQ_ATOMIC && !nvme_valid_atomic_write(req))
+		return BLK_STS_INVAL;
 
 	cmnd->rw.opcode = op;
 	cmnd->rw.flags = 0;
@@ -1921,6 +1951,23 @@ static void nvme_configure_metadata(struct nvme_ctrl *ctrl,
 	}
 }
 
+
+static void nvme_update_atomic_write_disk_info(struct nvme_ns *ns,
+			struct nvme_id_ns *id, struct queue_limits *lim,
+			u32 bs, u32 atomic_bs)
+{
+	unsigned int boundary = 0;
+
+	if (id->nsfeat & NVME_NS_FEAT_ATOMICS && id->nawupf) {
+		if (le16_to_cpu(id->nabspf))
+			boundary = (le16_to_cpu(id->nabspf) + 1) * bs;
+	}
+	lim->atomic_write_hw_max = atomic_bs;
+	lim->atomic_write_hw_boundary = boundary;
+	lim->atomic_write_hw_unit_min = bs;
+	lim->atomic_write_hw_unit_max = rounddown_pow_of_two(atomic_bs);
+}
+
 static u32 nvme_max_drv_segments(struct nvme_ctrl *ctrl)
 {
 	return ctrl->max_hw_sectors / (NVME_CTRL_PAGE_SIZE >> SECTOR_SHIFT) + 1;
@@ -1967,6 +2014,8 @@ static bool nvme_update_disk_info(struct nvme_ns *ns, struct nvme_id_ns *id,
 			atomic_bs = (1 + le16_to_cpu(id->nawupf)) * bs;
 		else
 			atomic_bs = (1 + ns->ctrl->subsys->awupf) * bs;
+
+		nvme_update_atomic_write_disk_info(ns, id, lim, bs, atomic_bs);
 	}
 
 	if (id->nsfeat & NVME_NS_FEAT_IO_OPT) {
-- 
2.31.1


