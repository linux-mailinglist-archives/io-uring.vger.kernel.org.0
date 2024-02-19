Return-Path: <io-uring+bounces-625-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E2FB85A409
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 14:02:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CDA571F24637
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 13:02:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1657F360AE;
	Mon, 19 Feb 2024 13:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cR+VZN0f";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BF7UJ9cn"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5BA34CD5;
	Mon, 19 Feb 2024 13:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708347749; cv=fail; b=gGef/uBgCjU+YD7d/KKevjY1QhzmVsbzR+M0QEJzVVsT0YsEDShTGdes5XbpGpGhGbDDUJPbj0zYHd482QDtv4ZDK4gJSwxfhj3gR6K77RPNZRYXG/i60O4bkFpZWscx8I8gDmNnNP4J0OmVHuXOxlJdhPzbP+fINlNAu9zTYs4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708347749; c=relaxed/simple;
	bh=/XDbGSPxXRb3BgsqsxCGzUAcfFLjBJQ90yiCcXhgpY8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fl00m0tn9fUaIfBci6GHgWZJMJGFsH6Xk4IGU8gKWk7aznn6Z1tTCb6+lb4FugPJOnmwKdtzlbxO8KhS7mZvKbedhblV+rg5Dv/O16zXsoxe+qE0dfp4Qo8yjlEb1oIeQqHUdSGGHmHVnA1yCiTVQUOfVdrDvkHyvQDM2JA9RjI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cR+VZN0f; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BF7UJ9cn; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41J8ODx8003498;
	Mon, 19 Feb 2024 13:01:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=xJPyAoV/WNCncgHbIvf5WfTTIdJC1btdqvIFzgu70DQ=;
 b=cR+VZN0fn0S+F7bJr3rYSNpFx+uUav04C7k7sjSt9JSKG6y9nXtlqs2ptRn7MgYSyASd
 ZkUN+mmSbNxMJXUDuvpm5CgBZxb0ZzYiSrBrhuq0fO65lheuUt+tul1HYiv56I1IuO4m
 KGpLbRiwNBD0J6yUmk9Uijr23rWPozhurlowNxvZWETt/ALBXxr3/C/K8/tYCz53Jb2k
 j9ccAt3jau8FJLa47BLfSRM0eVs3G+9vpdQzU1hU6TgYz0hh46T837XrOFa7ao9v3uBQ
 ppLV+zo7FlTaEL+uH02PO3dwETRh36lVsabYxQyLSZ67y5XKhZMmYhzxFLNPGtCyGBJj zA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wamucv419-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Feb 2024 13:01:58 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41JCPCax021143;
	Mon, 19 Feb 2024 13:01:57 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wak860wh1-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Feb 2024 13:01:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eFvWLurDJJz/whovRDVZf96SNtYNfYrd6I7FUz8wZslioj/k1owPMmVnAYYJkuARewJ09yo1K1DSNE6rB9Sk347+U0UXVqKQYHvkBjQVs/+u+JHxD40epr0vMUEawrxERAFrfbUE4lbn5/bhL+khq2EuJMKSGCxvAlUd9nlCvert24Uflc8ECbICbPiqKLXsdO5JrR2ycEmpk0Uiko9cIBtTLEyq4f30XRvJBPHdyZlwU+v5k/XjroQqrDy9IcpZ56NPBcAUrars+YKIKNMoZLMH7va/LKI8MDFQK6cykO6vY9KjxFN69xSeBv3Ea5d44cpIKAr8DkH7xCeS/Xg//Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xJPyAoV/WNCncgHbIvf5WfTTIdJC1btdqvIFzgu70DQ=;
 b=epyuNEb4ru/6w6S8MsrsnRY47UAuVjhkf3dj5rS37Pq8rG8m6e2qdFHECvZN/d4IRhxwFopePWYjLYGDX+AruTDkijZctfB3B5K/6UZc4WRkVXNhvB2ol3OIfJBrtJjqriKNVTXwOQWez4nNt7QltYiooj8EcMYB5BSvPULrelfxhqImrGvQfQRLPqyQ6Ew2tyFsNLOAuRkam3q4Q2DuDF783dnWzeY9PaXsn5cAczcQfQQVVcUO5ItC7cRsG2ymGMxb8hJwqz/w9QTbyRlGHUkS0inyqDzHQeYdigGIwxDoPn90oQ1sRDgpH3zKFeFt9rYKz1qR1SX7kejjwEGycQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xJPyAoV/WNCncgHbIvf5WfTTIdJC1btdqvIFzgu70DQ=;
 b=BF7UJ9cnlbo8pyxWhdbgVOhPNV5krSqQOZP2wZEwqZY6YjzF5UFPa09ht4VomAxpZIoq9zgaI9ql5AZP5HfpQb8meQsl/x2b2L3NLqsENgd+w6tZxtzb8SnCxrKS22uwE34lk02vN62ela9I4RONXvZG+nneNRdZtdC6XNZiF6g=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB6894.namprd10.prod.outlook.com (2603:10b6:8:134::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.38; Mon, 19 Feb
 2024 13:01:55 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4%4]) with mapi id 15.20.7292.036; Mon, 19 Feb 2024
 13:01:55 +0000
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
        nilay@linux.ibm.com, ritesh.list@gmail.com,
        Alan Adamson <alan.adamson@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 11/11] nvme: Ensure atomic writes will be executed atomically
Date: Mon, 19 Feb 2024 13:01:09 +0000
Message-Id: <20240219130109.341523-12-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240219130109.341523-1-john.g.garry@oracle.com>
References: <20240219130109.341523-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0230.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::25) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB6894:EE_
X-MS-Office365-Filtering-Correlation-Id: 39963917-5704-4e0a-c591-08dc314af2b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	6oN5og6jJZihqd4MY59jSNYztU8S7Ol2hh12EIVANnvFY0bXiUmm7NUoWSnsC40skcZw5fxL4oqb/acajwX9Bqc9AV8vZn0eMuTIT9oelecgW1ediwb6eKAfBhheImqIjZVJssACFmeuo3HEdyRc15ujIwg408QLywlgxIvPwW6a5/39y3/c3UrhTEX2HJmIEd8z5mKVsaeSac8QzzRtPb+hfZtQYHhs6mrIXxcj3f4bxer2RbZvST6YAq+LsPXXImwifuT8FNu9eYU38wtpkPcXAR+Xa9FTeWWvxA2qKpOLb778K3WBJGkrEM4+rzx129UnAI8gIQHbi4gftNUY7hndAp58QnMfevJWAJIJeCfgfGnbkbOVuCKU/iictMr9X3VSkHhu/KJr43iYNb42kfSG4nJDOjgvrOkU6etoCxoZcsBhPiprA7jr1i1yfN96kn/5JMdGB5Y0cxwDnSWpcwD9+pF8xxqpNAyOQuXXyj88zJgQ485/MhXaa3fjPrA+a9g5jrxs/RGLKLg4OMg+mSnaf4hJ9xBTxvDtg+aG3hVGG36MznMB8A0ZBR8d9mkrS0CtGD6KaGxJZ5GSWFka6qv7A1no+VjUyz61h67nUAQ=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?52BT1/Vjy9/oCAFNga18jhnT+8ceUr07IszLJmI/JRBgfY4AbpVrFwcfKo+m?=
 =?us-ascii?Q?eHbD0MaJ18kzVYQ32YdHBDoFEJNQiDG5lq6jqvtwEwdDZJByioasDCNFGG0z?=
 =?us-ascii?Q?XGtiqF8CWbrPD9Z6tdlOS8Fa6QZ9safR563N+/fVYWuYHLow9LrRjoWHwsWf?=
 =?us-ascii?Q?eYv34VoYWiR0/7vKzJeld2nJE+HsQ5Indx0REa6oxgUTU3Q+fdsiYRrsM1NU?=
 =?us-ascii?Q?nv5gYF1Wjv50USEcCm1IXEKb5oeykM3+vmp5hvQPs9xfsRonnU6Xe7Wjz1Mg?=
 =?us-ascii?Q?SFR7kEcjm9KlErkYjWeP/nFhE3eiiRFsxDtL8tvnyW1YFykENXLeyHArB+Op?=
 =?us-ascii?Q?/xpBnUCT0mroD+XU68/kNzl1SfSpO+1iFnjbKyolkqGRES4hWIT7sYK65UDd?=
 =?us-ascii?Q?f3Go9dtCj3KUlU3xjmLwauQ67PekgtqFypntKI5Z3E80JUHXKpFn9+Izn20D?=
 =?us-ascii?Q?IJiO2WGi3p1FaqjLGeOCA5iRegLFiJ+kANmtldC7HRXLE60Q4bbuW8fMp5kr?=
 =?us-ascii?Q?f8GlstGvRPNRRS9iV3is9W1EUmBH+HmXFk+DETNQv3mj4e+hCVFhOOvJ4TRg?=
 =?us-ascii?Q?TKFHWDG6ExeYqLGk3xW/40BBaG7RztuOC4xXFnvKqVvTPOHXL7TbiqH1lIXt?=
 =?us-ascii?Q?cma2oQOUytR4oF95ycM5Px07hySRPPsxmixL4eq58G0eGrBg+qdtExaCjFSj?=
 =?us-ascii?Q?x0NCcTnCgsl2TjCMRMJVmYoaIgR2CxCXRUdcZajL2umb/6MwhPPp4xvQvnZ5?=
 =?us-ascii?Q?yOVWWyOww/SOqgaaw8XXRM/mXpqa+4cpBDLmkU9n3P1l23pM6dieWCWdYKUn?=
 =?us-ascii?Q?4/8weYHPWPwFdJ897iLkGVZPRmR9vtdis7GrRhGXol12qPI6ArHecw/CrJ69?=
 =?us-ascii?Q?HRSszNen33cR6pEaY+CqLtFlBgKZl+fibMmVn70VAY33szhaepL7YjMLm0G2?=
 =?us-ascii?Q?6/2mrNi4+p0xgO5EtS/0rgrWRlo7eqNl9FBpDYTnqe2HmN0Iu5iNrupIMApv?=
 =?us-ascii?Q?+RfTwXyYu7tpFSOpAPA3c+56prLbJbo+T/aaWREsckCQ0l3AvwkzMu5qXLVQ?=
 =?us-ascii?Q?a/3ELg5/Z1QJVHJrPI+2uW5pwlBQjjdtMrHI/qpJ9Ea54hrThfEDDxfr2WgX?=
 =?us-ascii?Q?lUYPTKJ0k+Crb2ftHaHECcbJoUAuUe7FCKrXMCtzjtZJnXBgdG9azZnySsda?=
 =?us-ascii?Q?eDAQ2KCW7cL2vWx1PxVLA1YkvrVVn8riUBCrpZPWfCcxi3NDbYrfoMIUCuwr?=
 =?us-ascii?Q?0jHLglzOTGL2QZP6j7nkeevGk9z5b76A43fz1lLE6PWtm5cJNTttdQ1galJ+?=
 =?us-ascii?Q?b9g1O30zZ3QhVvHhGX3k3Mcg6rf2sewjja/fVKPMYunu1xcr98VY0S3aNWP9?=
 =?us-ascii?Q?K4AazYZmNedyHVu7A42Af69m/Aj4IaTtE3onM6El5sDKmv+s8Z/MO/NFpQMA?=
 =?us-ascii?Q?n8gFrqBDkeNT2CsHRO+idglntqorsy7R6UIvb2h0PfYu0du7tQd479tJ6Che?=
 =?us-ascii?Q?yfDgKKYzatJGcx+328Po1u3vR2hF3UJVzsbclGXecAtze2fKCxdna9S1Pdwi?=
 =?us-ascii?Q?XE1Z/s/nipw83n9uQ7HJaG6Y+9gpsu7RUDVShdwgTpgNHSKZxDYZxPiUxP+T?=
 =?us-ascii?Q?sA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	klHZ8YQcAJ5fG4l8JkUgi2AncrXn/XTAuqlJmhu3+xxuAvmtF+MwbMyVsnS0UUFIgoN41WY/L6MONSdFLG08CGXddB5c1B2twcMYuiiv39eosibqiMYetHy3hTH/4oaoh3vdxb89SgmHkunGkFuCamX6YCVkBM2jFu6c6l7sE/T9f93AKVP14z/XJAep6qf/XQxyis/AqA23Tsy4l90ZZ/QcRh6tBQzjdD3Bar/I535OKn3X6FhhC2vGI+GRmWUtWJE+thEVsBX+gX1nCYRlOadXUhj4BHDbvuOAqy+W/8FEVgmUEZ3q0LlGO2MhxprG3fdId90NIb2ukSXFTTrmm+2dX9G9+X6DRy905xjW8rBSzBP3y66xWvJ9H5d68TIUwlMeIijico7QHtojwSW1Y/zECbWkeasDDdv+svF3vKJ9DQwsEXpD+atUIBKI55Az0WGQZf+ClGLALJmYEuZfKDqA/Q+aIYa2wCWmI4ezCVwiWJkDg/Y/aJK15x6VjMWGOZFKmf9eTKrMMPzPyeVCewEWfOurFqXEAWdaJEO0PaGYBsGoGd5H3oH/eTb8MkmacfQTfks/nDndjUmdSeyX1OAl3NH+EZmRSP8vugkMHuY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39963917-5704-4e0a-c591-08dc314af2b0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2024 13:01:54.9879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xa8exxh5V1UwYXu7I3dS6GBcolNohW/gEQZKzfsAD3eTsn8NSUutP402dVid9XWic8rWWcr3z25Pq2ELXSUtXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6894
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-19_09,2024-02-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402190096
X-Proofpoint-GUID: bWRih8MirKmFmlHhAO3NbO1J--fnOv9t
X-Proofpoint-ORIG-GUID: bWRih8MirKmFmlHhAO3NbO1J--fnOv9t

From: Alan Adamson <alan.adamson@oracle.com>

There is no dedicated NVMe atomic write command (which may error for a
command which exceeds the controller atomic write limits).

As an insurance policy against the block layer sending requests which
cannot be executed atomically, add a check in the queue path.

Signed-off-by: Alan Adamson <alan.adamson@oracle.com>
#jpg: some rewrite
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index c5bc663c8582..60dc20864dc7 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -934,7 +934,6 @@ static inline blk_status_t nvme_setup_write_zeroes(struct nvme_ns *ns,
 	return BLK_STS_OK;
 }
 
-__maybe_unused
 static bool nvme_valid_atomic_write(struct request *req)
 {
 	struct request_queue *q = req->q;
@@ -974,6 +973,13 @@ static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
 	if (req->cmd_flags & REQ_RAHEAD)
 		dsmgmt |= NVME_RW_DSM_FREQ_PREFETCH;
 
+	/*
+	 * Ensure that nothing has been sent which cannot be executed
+	 * atomically.
+	 */
+	if (req->cmd_flags & REQ_ATOMIC && !nvme_valid_atomic_write(req))
+		return BLK_STS_IOERR;
+
 	cmnd->rw.opcode = op;
 	cmnd->rw.flags = 0;
 	cmnd->rw.nsid = cpu_to_le32(ns->head->ns_id);
-- 
2.31.1


