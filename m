Return-Path: <io-uring+bounces-2067-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 68DDE8D7600
	for <lists+io-uring@lfdr.de>; Sun,  2 Jun 2024 16:12:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E943E1F221A7
	for <lists+io-uring@lfdr.de>; Sun,  2 Jun 2024 14:12:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E8503FE2A;
	Sun,  2 Jun 2024 14:12:09 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08481E501;
	Sun,  2 Jun 2024 14:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717337529; cv=fail; b=Rnln46b7FzjoLQKz6Lf4AtrFVH7a/hKcpw1rdyt/0cLD4XBGxq1QW5cCWQPF4hVvcQbQBZ6Mjvi31KByfaZ83MmYRMglF4LlCmN3hJL3Qp+hqVWBVVb5Te2N3GAwresIpYlAdQlKccqAS5dMuuN948vZiez/yzgWbI7F0m4qZso=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717337529; c=relaxed/simple;
	bh=iki/1NYZ9YoGpsiuRdEgpVnO8uPeskpeOIqE392MusA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UwBg7chmQZ94bXTdaWjbWhuHwo0JWc99K2GXRBN/1p3RHKX7B3VOXGlql8U4a/hiAOdRgZDAAKCvrqc+y0cSRKOrNtYVCVVtHk1L1Fe8MnUUuLwRvJ2uUm5O0K1zv9bF32fX70VreQRJ1iSkrRUFtRhW+m2SNnQAGHVuhBfWmkI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4526h02i027447;
	Sun, 2 Jun 2024 14:09:56 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-transfer-encoding:content-type:date:from:in-reply?=
 =?UTF-8?Q?-to:message-id:mime-version:references:subject:to;_s=3Dcorp-202?=
 =?UTF-8?Q?3-11-20;_bh=3DIzYMElQdoafm/KOiCJoqkqo8DHg2mUS9JMz/MJ0HTqY=3D;_b?=
 =?UTF-8?Q?=3Dg2iZR+YwuB3+lMC6gVdw7mN96JrGDh7pr3jtH86kD8xe5gPaQ8etjrXaoquL?=
 =?UTF-8?Q?mzSQOONA_jyBQLpsQIkDCID0xkpBE9lolMkyjAa+6AQRxJ+IFxQg29M+L4EDDPT?=
 =?UTF-8?Q?BzG9c/ghyhOrFG_/Jwur23sX8gMmz7g4IpeH4KgphAnx6UCKMwvcsiviJhlBjRs?=
 =?UTF-8?Q?x5XuL4+AGeYTBDlmxcqv_sHCzyRKAI8gUC2ZOrBC1yyPpd1CjlsQKvR408JVXdS?=
 =?UTF-8?Q?hG5TPia12b54AfrX6c0YNekTVC_FBXqabSwbl3KhqKY2UZ7x8G6Sg3+bXchB5zT?=
 =?UTF-8?Q?eV1fgqmLy6/HgGgSJbg3D1lJSe7RIQ4W_0Q=3D=3D_?=
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yfuyu1cm3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Jun 2024 14:09:56 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 452CPWHx003823;
	Sun, 2 Jun 2024 14:09:55 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrquhb53-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Jun 2024 14:09:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FbOUvnktf7G36RymcpekUwQgST1bFiio7alGrMFOcTID+P+W1oyWGs1nbJdwlA8eXuqNCf2aGZo6WVy44Doi4kC67gQaOQyI3LKLs84PQXoSowJva5V42zxT1qIlHDSuEZugQaml5H7G1VLJ8a6O1m6qwSXjkDSIq0M/QKhkTR0NSLJEIE1VelCSCxXuz+NrkyIDXTwQt0/g9pxyRTWEXkp2kL3q6X+ZYFZUkbTHnU0pK0UfQlu9HdMWCP+9y5g+0EqAKgYNCQh8pSL2fD9/YAUVvgg9f+fkeL2U8MX7KP6TqauPLfOIqVB7ot0hgkgEyORQPRB2AGiEhw8ca5cCnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IzYMElQdoafm/KOiCJoqkqo8DHg2mUS9JMz/MJ0HTqY=;
 b=jk1TtawiAwT/otFziZOEHetoS1Dtz1Mj/rSQutuCX5BbVcusSOTBHB9d+1xMDEseP4leMtbbMyTKoewRAfWv7w61BihyE1bPbMajf4OzYRs8vSmtl4wPtJvfhh4vRJZbwPCA84i2d3abNe5D2i9NosqtEF9isRdO6gEMdVo9GllwduMgd21pq+AgCDPi3dNToTmIQnWp2X9Yp4Gpl0tBDoEsq9ltSy5qkQUnPo/0KevKOqYKAx5dV7UFh+5iY4sk1zo38UHgTCnlVez5fwOdtGkIm7fmGlVzF3Bxb68qxSHAv/BpY6YxvmnaiAKNXnIf2SHrKfyzTfLUS6VWFsMgjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IzYMElQdoafm/KOiCJoqkqo8DHg2mUS9JMz/MJ0HTqY=;
 b=OmEhPEEAVxq5He0Q4lZfiXFQg+YIdqYhpjpoOrVA3uvEpL8g8H0Yj5RNcywBMQjajH+xi1XjmvTG5qXPRFXcZcw/JPM8JBIKG8kNPNwWApX48gIqdsP3xUhT+VW1gwUVCg3C2KvxVVVn1WSUSI33x8yT9G5rnGES/9RWB9/S5mo=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB8078.namprd10.prod.outlook.com (2603:10b6:8:1fd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Sun, 2 Jun
 2024 14:09:54 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7633.018; Sun, 2 Jun 2024
 14:09:54 +0000
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
        Alan Adamson <alan.adamson@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v7 9/9] nvme: Atomic write support
Date: Sun,  2 Jun 2024 14:09:12 +0000
Message-Id: <20240602140912.970947-10-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240602140912.970947-1-john.g.garry@oracle.com>
References: <20240602140912.970947-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:208:23a::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB8078:EE_
X-MS-Office365-Filtering-Correlation-Id: 28bb8fa2-7cc0-45f5-0ec8-08dc830dacec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230031|366007|7416005|1800799015|376005|921011;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?bzRKUWwzYkdrU0VZVElqNm9yUEJSU21nWVV6OXRYeTAzVlNUUTk2QzUrd3lY?=
 =?utf-8?B?LzUrc3RabVMwRWN5VmpRVmVVNmFCVU9YajdJN0xUc3p2anJka2tlSldYQTVE?=
 =?utf-8?B?aGZnSnViMk5COXhpNk5jS08rV01lS3BkUFNjYWtQVnQvZFU2bFpPZjNaWlF6?=
 =?utf-8?B?ZlJQUENBcjN6VzBobGNMekVTTkQvaXdiV2czY1hwUVQ2NFZsK2dUWE5CNTFS?=
 =?utf-8?B?RlNBVlBOaTIyZlJTaW11K1NkekkrbVdvS3FmRkFEZ2tvM0x5T1MwYUhqV3pi?=
 =?utf-8?B?NDVFRlU4S05ibWNONFMwdmlCOG9rdmdoUGYySEhTSkdpaFdpYms1SlArVDdB?=
 =?utf-8?B?M3o4Z3haaS9tQ3NpT0licU9pUE1ER3RvdHE1dHlKTlB3REVTdUZUVU9BWm1G?=
 =?utf-8?B?M3pHMkUrVzRONVNJWk0zWW0zbm01dlJ4WGhlU1prUE5Wbm1CcFM3UUIzU1hp?=
 =?utf-8?B?VU44Lys3eStRTkZLTlVSL2d6UE5iakxqeTBFcnZ4QlY0M0pnQ3RrRDhLeDQr?=
 =?utf-8?B?RmV4NEtQcDJqeHdjbHNPMkt2a3g5bE0vQWhRc3Q2ZTNJbVJwQUU2aXdpSjZJ?=
 =?utf-8?B?UFNNQVZvM1YvVkozMlEzKysyVFpJQjJQZDRYY3FvakVpQ0ZoTnZDRCt2Qjkw?=
 =?utf-8?B?VXFHeE1uQm9VNTRlcWQ0NFNTN0g0TEdVcC9ETVB3S0hiV3NhQncvTExTeFdB?=
 =?utf-8?B?QW5jc0o4Qlh4Mk5Qc3d3YmZWNXpOYXNLRzVjMTNRY05OZ3FUWWErWWg4bnlG?=
 =?utf-8?B?dEQ1cklkTTFnR1k1TmtDb1pnRU50MTJGK1k1cWg0bWdaY2hwWVdCdG1yb2R4?=
 =?utf-8?B?aXdrZEZhRFVNN1N3NExzNnZFT1g1TDhiVURFaElCS3FMa0xBUkYwVGlQWmtm?=
 =?utf-8?B?ZHF5RTlCTmt0Y0g4dktaZkp0K3dsbk1qUityZHpkYk01clhkckNMc054SE1G?=
 =?utf-8?B?UGhDdFNBWXRGRmN0Tk9LdkxZbEU4djQ5NnBHUzltSnhjUXhzTEpaUHdGdldY?=
 =?utf-8?B?ck5id0FIeVVCSmNJRGpLV0FKYkI0RkFubnBKeThuRzBIamRiUTRzbDlCTGJO?=
 =?utf-8?B?RENpWDg1V2tzY1FSeW1oWE9WbU05SUh5K3pQYXd6Z1BFWi95S3M5cmJHVUxI?=
 =?utf-8?B?NEhpMW9rbHgvWDdJQmFpWjNxL1EwU3ZnaHV1bXJJREM2dzRnUVRFOGt4cGtr?=
 =?utf-8?B?Sk96U2poU1RhVzltbGlIcjc3KzlZWm5QUE1VSm0va0gwVjdvSnN4MkVFeFk3?=
 =?utf-8?B?aDVTNkFlVWxRNzRJUWNURHV1RU9sVU5QRHpCOVRJZmE1UTNrNFlXb0pvSVhM?=
 =?utf-8?B?Z3hhMkduY0lrUWpZc3R0b1BYVVJRNndzOFFvY0xRMWxkN09hS0w4RHFPdTc3?=
 =?utf-8?B?QWxraVkrZmlaMzFQaEZlSTBXbjgxWmswQ3Q4LzA4SytTdm5YdkRxZUtMZmlN?=
 =?utf-8?B?RFRoUnZ2TFRiajgvSlk4dGgxRXJlWCtySWQ1ZmdzRDRudXljNVVTSEFjbHlJ?=
 =?utf-8?B?RGFkRUtZTXVBOERXVzdqbjhwdzJOQzNUMms1cHFXUDVHV2pJRm42am9hMEZE?=
 =?utf-8?B?Um10TE9Cbmpzb3k5WUdHVGd1aFVDa2N2ZzJmMHQxTnc4WlZ1SDRJcFdOVkFm?=
 =?utf-8?B?cUVTK1NlbG1sVWxpaVdNU3lqdGR0SHBpb0NkanFOSUtaMGw0RTBtK1ZtRjJh?=
 =?utf-8?B?ZitNS3U3cmVHcGNOK0xoR1I3MUJvdExscFFrQVlvVVA5cDBleDZsellpZmFM?=
 =?utf-8?Q?bJRIVh658g/EhX5Q26CZk/sc22D7ewhitV47O9/?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?dENjZTZxR0Y4S0IxVSt0RDllc0d2R0JLVmV4bjdDMGdVK2g0a2J3Nm14UWlk?=
 =?utf-8?B?S281Y2Ixck14cDAwYnhIcTRoZXRLdy9mWkRRRVdlK29jbjE3bnpjcGZ0Vnh2?=
 =?utf-8?B?TDd3ZGtYdkpzSEJ5d2ZxK0oxS2cxcVFOWEo1TXNPbFlKZUJscHVPdDZkV3I5?=
 =?utf-8?B?WXFEYXRHWUpVOTlsN2VCRGVTRjRDNnFCa2NPLzJ6YndSRXk4Z2tzdlR3ZGhh?=
 =?utf-8?B?cEQ1RUM3b0ZKZFpIZHBkUGFWNU0zdmlyMWVRRFZyOUZXQnNBWHg0MEJnSkhJ?=
 =?utf-8?B?ZjAwVENySHZjUUxvcDBlLzNXdXZ4U2NJSHJ0VFlyeXdlUUVyaldNQ1FsVTdq?=
 =?utf-8?B?ODFJSHhjMzY3ZDJvVGlDR3JMMW9WNVlXakpMR21NWkRJM1dDRGhKdVVSMFN2?=
 =?utf-8?B?WEE5UFl3cXB5QTRhbVBoM3p4S3dLSnpWd1B0enhVNEE0NnMvZEg0ZVhvemJt?=
 =?utf-8?B?bkp5bTJoYjlHNGhWUlRuelQzTlJHY1MyZU8yeXEyY0RGV3JaYXFTZDlrYUwr?=
 =?utf-8?B?ZTV6NjJTVFRvQ25SaUtPeDdmV3ZVaG00WWVRTU95RzNiWWgwY2QzWG5OVTJW?=
 =?utf-8?B?UjFXZXNzRmMrVFVEZXhMWUNBY3hKZHM4eEtMc2oxVy9wenRkbUo5akF0Slk5?=
 =?utf-8?B?d05qVFBkV09XdkpJcFJ0cVM4V0RXNFFqNDcvaUhyYmZGMnRTSGdaMVJYZFNo?=
 =?utf-8?B?dmpVZS9XbGdDeWdrRGs2dU5Hc0E3TTUrUkdiKzYwN1NqekVsY1JiV2JzekJW?=
 =?utf-8?B?Q1N4WldzVEZpM3p5aVQzMFpobU4zTEd5NE9TWXg0VHVWeWlIQUNmNk9WSmVR?=
 =?utf-8?B?bWpuU2ZSTGl0SnB6Mkt2WVdQMC84QkhLTWJDdGVlNWNUbUdKY3ZJdDNZNEZD?=
 =?utf-8?B?Y0gwTVZkRmdjZGxoQURMcFoyK082T3RmdUc3azQ3VFBlVWtFYmNad0VUdkw5?=
 =?utf-8?B?SXVadnRPN3k0akhwd1FHQThFZm8zenROVDZ1Ym83WVg4cjBhVnlkTEEyRlpC?=
 =?utf-8?B?TFpXbEF3NkpaQW9IMmRDbWZ0NVZwVTVkaHNYRk9XeUJCVElkV0VoVHFiMER6?=
 =?utf-8?B?K0o3OFhtMlY3aWxqc2IzUGRUQnh0YlJlRzNvYm1hSUhyL1hDbVJsT213TjVZ?=
 =?utf-8?B?K3d4bjJ4N0RNZWNHamxQK2FQWVJzTGZKQ3NtQWpOdHFONkU3eGdkNUJ1Mmc0?=
 =?utf-8?B?TURlN0Q2Z2pXcUh1bzVMTUdKK1F6ekpLaHJEYmQ3dVdlTDZ0SzFkcVdZVFdw?=
 =?utf-8?B?WmdZa2JNWmFDYktlSVQzQmRWdEd4UTQ4Y0VuVjJKcG9YbmRVVVovU3NlQUc5?=
 =?utf-8?B?M3JIdDBSREpkSjFKWFhRL2xzV2FuN0dKWVc1SUdsMlQ0L3Z4L0lwQkxaQ25P?=
 =?utf-8?B?T1ZFL0NjcTZzL2VBQUR2a0x2aTdPSUFOUTJ0MVJRejlyekZSdVI0dng1R0dy?=
 =?utf-8?B?U3dJRGlVaDQ2YkdZYlB0OWg3R2ZVOFNVcVNEQ2RzdzdEeUhUWGo4VzhQMzBR?=
 =?utf-8?B?OVpwdXZBRG84QVJ6dU8vSzFTckxSam80NnZtQzIzcTFkaGREMUQxVXZwaW1a?=
 =?utf-8?B?WnZEVDkwTm8reWNDS1JWYmErc09hK0Q1WjBCb3ArSStmVzdONlRqNzg4OTZH?=
 =?utf-8?B?NGtvMm14UTBWYnlNQmdaU0xlNm9NWVNpMGgxK0Q0MitaQm4rWGlDVnhVN2FR?=
 =?utf-8?B?ZzJLL1BZMUxGYklCV09ETW40M2xxaGFjNk9Ra1hxSi9rcFR0UXNRaWZROExX?=
 =?utf-8?B?eTRpcXpLZk5OaklFMWdUODFQSVRyUi83UElkTTY0ckJ2Q0FQdkxtL1BSUGhE?=
 =?utf-8?B?U3hkREppazAwUG5Dd1hFNVh3bzVzbkxrMmFiMStUQ0R4YzR4V1RxYk52M09M?=
 =?utf-8?B?Q0pGUWhRZmJnWlF3dDhXVDJPMzY4N0R0UzAwZS9xTlhjalI5T1JXdmVucEh5?=
 =?utf-8?B?UC92L25RaUFVdEF6UUFLdVVqWFJzVTI5Mm5aT0FicmpQY0tOT1lqNHhya2w5?=
 =?utf-8?B?dUNKQXRIeHpkcWthdjg0NG11bzQ5TGVObnpjS2I4Rk5IM05LemRRb2h2R1pv?=
 =?utf-8?B?bUpYaTNDV0NoZXkrZFdhQUJDbHRXeFhTQTZvMCtHUVRyQThPTnZXMVkxOFBN?=
 =?utf-8?B?R1lPdGpTR1RuTktsL3QrRXpYVGJTUFZOWDFnR01BQVNQQ2tTRE0yK216eHgx?=
 =?utf-8?B?c2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	x3MUx3tISAv8l5+iePx285wQnWl5oZGNY5usGGCzvVjFm+TnFxDmWD4sslg5WBWGV2xt91K1I3kGtt2ro1Owb+LfOREKtsgofD1UxYNt96FlWL7gi8yy09Ceffyj/IIqiInBbuMQmKU3o3kNlkg/osSQVZqwyZvbS07s/pv7715zj7JZbhMjIEl0peH6ByUNySTy+StLsA75XeOc/V+D26FpdHNOAJ2eYqH0vCv0UIBrv+QkeuXM6gjPofayrr+W8tbzgNFESkphliZ/4sJysd2Mk3eTQoYimdYwcUUa4IINmjTIHuIbF7dYY9HzE65T4seeawdJKAs9cbLmOpKZstGUZoqqJzdjS7S4EZ61QlnXZ0vtIap+te1Nh/jSrHc4BWN6umz7HwCY3/MQzWn8A4LqeowMVJlKLK7EGhuEyM3QQRo/MnQOS/EO6qjHH3ywsKicEmYOndGHMCPMYjt+lRLJKi9ioEgu2U2T76/YR0kI9yTYKjKvqx6sTvsA2MlB0hDhFp2asLN/YP9y8qMzEJSxH2CMwTa+Lq1nVdIM32CVzEqTc31HQR/bxdAEg/ybPhdJ942SVTLWcjr8Ly1qqH/Rr73d/LxDcKNLeYDpX9I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28bb8fa2-7cc0-45f5-0ec8-08dc830dacec
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2024 14:09:53.9974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sY8NSjkF2Qo2ntBgspVJEXqJ8kwdPGb4LNkgBHi9mL+2TJW4b4KQ2vm6bD+gYry3JAfHZVJpnXXsPkUWwsxiRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8078
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-02_08,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406020122
X-Proofpoint-GUID: 87tPnG2vNzXvKEi1UDE8LyV5AhLh4oIS
X-Proofpoint-ORIG-GUID: 87tPnG2vNzXvKEi1UDE8LyV5AhLh4oIS

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


