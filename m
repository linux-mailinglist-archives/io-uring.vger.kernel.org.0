Return-Path: <io-uring+bounces-1405-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 24ED9899B6A
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 12:57:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7D04DB20DBD
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 10:57:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B758016ABD3;
	Fri,  5 Apr 2024 10:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L7YzLX9v";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SGpE1Ipa"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5682918659;
	Fri,  5 Apr 2024 10:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712314631; cv=fail; b=QxDoaEdMUjYPRsXaWCE71JhJetEsV7yUdhryygaczQQbPkXMzqShXx2vUk35z2lq590x7jkMjV3ovGg1aCKBcVPdSzoxjvkaaUp/x9ez5SoKVRbV5TWaDpWj+b9SUA1WMo0AA8hsqr4w3axBwwV4gXAOuPYsj2LVyDwxQM8Mvn4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712314631; c=relaxed/simple;
	bh=i4TbR4q/x/6r16MEX1t8uIYWOLfSS+cOm6FYHOs4WN4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RBLSxZEiw4lR8c6aXi2wLj5WbMd13l8Mi5rsF2MIV/KkZ7KAkmJaidAkwR6H6qsYpIChyYhVhGV1Tkcew+4Inan1bPORgU+jfdXaZn0dwFvrcpyS0MxBnFaiVdMYndYUjfX4h6yf8bw2BFJni73W/YuVduVxXthuaOgsfUmgE38=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=L7YzLX9v; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SGpE1Ipa; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4358XqbR031187;
	Fri, 5 Apr 2024 10:56:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=IWXE+WyieNS2ZDhmBq2aXC8QTH4MNK3EcA1kAnqdySs=;
 b=L7YzLX9vf+TtOmHGBac9LNVjtGK2S8Mov501QBpI3FJ/MFciDggU9OAhE9kwmmwPJgz6
 bNj6vhVi2wzAyt8rgkdymeo6b5Au3EzlPmJnkjwUaaTtHOWFd0UKM+JYWrFjnU9v3EE/
 JVMI5/K/BCpfgDpBwoM/ATyRCd/Lx5UT/Wloxfe7vv5iVdOts2wMp4XmpGtNAXN4+oea
 pFasA1XipkLFEX34hTD+1iCK62/CzUH1Uu6Wb6zlllhGS3qZGAPBjKbKaPjAlyCnHo2S
 MpUr+/54yDcjKR1zRkbpVY3zIwZL+x8p5UcFQyw1VmMDn2kJmy+D9k8zEBElgdDfXfw3 2g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x9emtk8qs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Apr 2024 10:55:50 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4359VBHH009246;
	Fri, 5 Apr 2024 10:55:49 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x9emmxp00-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Apr 2024 10:55:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L4otXrpU+mXCYlnobP0nb6q42Hn9diY3R3/k5CRMVjIJjAxFGvjTSyLDxmInT1F2lgRYcCVjwJqI2qX9pbhIai6w24C0sZ6tKZyGoicKmggi8paMRvLQHEdiATb2RQCytaszyN6L6+y9SOBndufPw83zZ6hi7ErdeLnnCxoJzVoqaurDufIGNANCLW1DM2nHW43v8BMr0jUDh6ptmrwXTA+bzCEGti0vkuHob9m3QZym5i7KXYCFnw/5dDw7/SxnyMIgAGT11J2F9+urjtPk0s3kEn2sF21mssufskbp5HhtNoZJ1ynzUQsSs1zBR+IsOl7+jEZvRUjVNAB7iNrmGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IWXE+WyieNS2ZDhmBq2aXC8QTH4MNK3EcA1kAnqdySs=;
 b=Up7DW0Y/F6bForGPhWtyoE5+uwdF2FczQ0tDzyLNIaKwmcjmSrA7yrvWEmrPzNUip5WsAzrPCvnLs5jRZiY4Rr5YGmKvtgQBa2LcZnQ0vu7tptYcCulbc6opnx5KGxjUZbKwVtAdcwEptNBuCrnWn3b8B0uKzmWbl1zZqqmflIWLuqT7WEZQmpV+jEOLfAC3UXioGwWLJOr6yvRnu+5J7yf1nOeGEpqB5Rors9m0CCMT54li6evl9+mxASRy5i90PJtnmq5cT+Wetkl75y0QPHYrirQIepLOxGfT76KHn0djtc9F6RXpmFo5q8xLUD3XvivlrtlH8oool51YY83xLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IWXE+WyieNS2ZDhmBq2aXC8QTH4MNK3EcA1kAnqdySs=;
 b=SGpE1Ipa+ZvhjOgzyMsENhELA3RFUaHEkSAr3kpeExDi8iXpBKuc/Ddg3axQvcUf2QPKWZ6C8xzAnjJgwYkrwDoORS8Hxrv02XgwDJxNBTn+xlLkS9CiOLMMa/Y+Y+2m2c2TGMf/oRF1NLJKJojsGYFY/37hPNE1byyqA2L1hgs=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB4808.namprd10.prod.outlook.com (2603:10b6:510:35::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Fri, 5 Apr
 2024 10:55:47 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.042; Fri, 5 Apr 2024
 10:55:47 +0000
Message-ID: <2e82a05d-f0b4-4967-a6d0-11f9282e3058@oracle.com>
Date: Fri, 5 Apr 2024 11:55:41 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/10] block atomic writes
To: Kent Overstreet <kent.overstreet@linux.dev>,
        Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox <willy@infradead.org>, axboe@kernel.dk, kbusch@kernel.org,
        hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
        martin.petersen@oracle.com, djwong@kernel.org, viro@zeniv.linux.org.uk,
        brauner@kernel.org, dchinner@redhat.com, jack@suse.cz,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
        ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
 <ZgOXb_oZjsUU12YL@casper.infradead.org>
 <ZgSCMXKtcYWhxR7e@dread.disaster.area>
 <62uvkga54im76lnz47nc2znoeayidp2tcwpffseqtl42xdwxlc@hep6ckbgpwqz>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <62uvkga54im76lnz47nc2znoeayidp2tcwpffseqtl42xdwxlc@hep6ckbgpwqz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0114.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB4808:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	dgPIFXGL5PphvCYsJcW/rbn/RU43bBA02TILWRNRA2qo1QyaxqvwLWdspyJY49hYow4r1CYzyF+gdI1XhnZ3474Uv4cZqHGA3D6mAgVTsV/+nPIo8u0AeGk2//Zz37HFc4ndunRnXgp1/yRgiY9dLuMytBlRuWwAgZkQO8XSpOgjPT85iiEyBMaw/ndeUGjqpYLfYQpZWdwhT0F4dIC4HfJNwz8yETqGih+PqB5e3Lj249yFyVF/os6oaP2S5LOKUxhgE05CIFe9PHCQ4HSMWuPLqiRoObCm4UvsfuDBeyTRmLdtIMQkfoYcKPy08oyg047zsXgLujMT8X41ei8SP4rnzgywQ+Of3EA1jB6iSw85esbOf9zf2o5eLHd3sGRnh9KpV1C0j+UattEOvVmAd6I/qv12INxOvXKc/zlny8InLi5T8gtHdkD/g+/uIiVcKuf0qhyNdISbso/YEtiLrrQxxKQpru9BKkmDR6XlRf1jXtS03W+wgHfTQ9waLpj//XFW+hQ1KiRAh56fHC/N6RXOouzcsnf2P7tCwDXcTIo85Jo16RvAB0Vy44dxS2try5TUwUzbb6nHrJVcXGl4s0sqv1mWWAfGHvPABApMumY=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?TWgycTlFNkJXd3ZWVXRyMTJwaE1EVGF4ZUcvREdaYjl1UUlLR1JJRkpicHVw?=
 =?utf-8?B?anV3Y0lZcWQ4T1hndkozaHU1Y3k2aW1JeUFTeHdjS3BCbm0rS2NaTXVXcXU1?=
 =?utf-8?B?b0RHaUREYlFCUnQrUGxQcUc1NTFsMEVGSVZZSGY4Q3dDUG9PdFZhTFg1eTdK?=
 =?utf-8?B?YU51d2k3dHNzcmF6bEo2bGF1VDBjaU1kaTVQUXRKNGwzU2JxRFZMWlV1dUx4?=
 =?utf-8?B?eHgzWVE5ZDJHQ2VKNlVVQVdGMzFNVnFNYnNsSWZVVlp2bGFZdmdzNUV5TmFt?=
 =?utf-8?B?S0VCME5oZTJzZVY5aWZNRWEySmg0bGNvcFNxSThQakQ1UFUrYXRvekVweHcx?=
 =?utf-8?B?UFF1a1Y1SFNXaUFYWDUzSmR5dUpuVC8rVjRWdGQyVjB4cUZ3eU8xS0lJWnJW?=
 =?utf-8?B?VjZNc3pjOFk4WEEybEdDUjFoTkwvVWM4ZjN1ekQvanllbVhzSjhzUU8xcm40?=
 =?utf-8?B?dWt1UUhMQ0pZL3pzOVBSQ1JYTmNtUnRjTmFKWGd3Ui9CaGJYL2F0MDhUZSsx?=
 =?utf-8?B?Q2xzL1UzOFNBR2NGa0c3U0RvcTRBMThSRWlkS1lrWXVBc2s0L21yMndkbVQw?=
 =?utf-8?B?SUYwanhqZFZTcjdmV3AwRWxCS2lMeTdGM1I4Wk5jOCtsMmtSV3h0enM3QW5O?=
 =?utf-8?B?S09Ya2VlRXF4YzdKZWlrVnVNODJqRFFxQTgvT1FCa3RLSTNuZm85N3hVMmJq?=
 =?utf-8?B?MnFuTktockhtWTBURHY2TXdLd0dVSlFmTDF0UmhmdlJBa2dLaXA4OG5rOTZ1?=
 =?utf-8?B?ZU5sQW9SY250WVQxcHFnRW9XSWltSEZDSk1kMGZnenV1dDZzMCtQNDZFU010?=
 =?utf-8?B?YU00TFJ3SmtYcGM3eGg3SGttQkVpNVdRM2xyOE9ER0crdHZJTWpaZVRiMzRQ?=
 =?utf-8?B?VnYxaGtEaGVUL0xUYmdUTk5LSFJLREFGeERFY2E0bHc4c010SU02RGgzUm9z?=
 =?utf-8?B?ZGVqOVF0N2RHaTVMRzlCWWZweDdJcng2TFdFTGU2U3BJYUNkZHRYWGVvdWw4?=
 =?utf-8?B?WmJEWGd1RHNYRDNRV1ZDM3M3N05qN0VqNXZ0bFpDVDluTWtxRlUzNVlNOE84?=
 =?utf-8?B?S1pEU1A2TFBhUXYyRHBWOTVtVmtzUzFkblNYUFpaR2F5Z1d2N1FidEFsdCtj?=
 =?utf-8?B?ZGNCK0Z3S0kvVTlqcE1Hbnd0TndNajJzWWNORUFaQ2RZZUJvN0pDbWZZTldN?=
 =?utf-8?B?K1pGZDNQMWdFN3ZBdVJ3KzRLL2MyenJUL2NOeHBrdzFvRU9wMTY4bmZXL2ty?=
 =?utf-8?B?eVZnbkF3RmRCNnVQVmx4WkpsUDBSTFFJcys5SUE1a0lpNnVlSWlvaDNpeWRt?=
 =?utf-8?B?S2tEZ1FCZTZGNmZpMkxITkF2Q1UrMUxEbWlyMEsxaVhoTFZwdGFQMEpoeEQ4?=
 =?utf-8?B?NmxSZ0N2bjhST0ErUC9TOVdFVTRGUnlGVFhRZlQvTW5PNEsyZnJMNHRNTzZj?=
 =?utf-8?B?UnhrRk0yYlVwdy9udVFqOUdZSUtTdjlJQ1dyQnJFUjlQeERUMWZPemRndjlR?=
 =?utf-8?B?TDEzS1BxV2F5ME5EZW5ZSnY4ZmZOcTVySy9MVjZIa2F0VjZpZS8vcmtnQWdl?=
 =?utf-8?B?YklGVjNRT1pna1ExUlhZbGpVNzVnYm1UaG1aWDlDQXBNZVlBNTNiMXZiSjlB?=
 =?utf-8?B?eGRUMnJPYUp6eGtLTno1NmZYSFgxSll6Zjk2V0dxM2Z4NHAwQmgxbXlIUXZl?=
 =?utf-8?B?eDJuRFU4Q1lGZHlBVHBJVHVmK25ZMzdmdnZKUy9FOWdtdjFDdW43dWJvOXln?=
 =?utf-8?B?N2JDQmw5SVBpcnFVRm9oZWl5eXB1aXJQRWJHK2JPdHJyUnlvajNiM1lGb1Nq?=
 =?utf-8?B?Wldmd3VKdkpNc2dFNVNpY1llK05tVEh4dWVYK0NjZ2VZWk40b3Fud1Yra2J1?=
 =?utf-8?B?cEpNc3BWUVJMcVFiYk1kaTJkOWJTbUZCdnp0TkFsVDArNUEra1VrUmQ1K1li?=
 =?utf-8?B?Q1pGalVyUVp2UlZDalNVZ3R6L2JtOXlEL2ZtQzZSZ1owUUovVTh0ODVzcjJz?=
 =?utf-8?B?MHhYVEg0dG9taTBIb1ErVHA0YmJvdDJGYUZleVlVNk5hcEZiVUZvTjBuTFpk?=
 =?utf-8?B?aSt0Wi9qbGdmY3h0R0Fya2VyczFzd3lKTFEyU0lPeUVldFo4SDh2Tm1hMlJO?=
 =?utf-8?Q?JvMf2wjts72hArLwwXGGuvQ/O?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	e3ge0v7J7OdcUNOhzSW6MEIqOb8Tg/MeOAjnivi9tt17uIrp1q5c7Fut/ruNKmnFlA5QX9ql1O3dzELAf5twjqyNw0PyD0KYXKJRmviJftbRdmFO3OuCM/8R3PVHcQ17f8DkyindF0VTtW/U7tbwi/Ok+mzj0a1auQpvWCbSqTuiljtfKcrae+R2wRV6bsfP9TJA51oc/t98V3e7toHnOxr42pX1U137z4IOZA4dVVxszhaxifcrzskExJimekXf7lRU8YGg1JTWF5v6IC1wd73xx45k8TDifgyRoUOKyD/rVhvWXkjJagWcdTFP9D3Yj1ePIiks/oeGUfuB7itCxOAjUzTs8ldh8xAsFb1LyhhGZjBZ6ArbdN2e5QagwrTVsTrwZk1SFKYbiB5YU4Q254rsEdZkGuiCnXuRSwjgG27IOm6ZmK1w3ZFbBg+b8/S0abfDsetWpw+otdMHRl1cExJjvyD2pYDACOL8yoYcDA+6DU4ysySOJvIaEnz1n3UhT651+A42Po3bPQl7zTf7L2T6vENHb1GmgZAyT3MVpu5kYhQ/vkHH21f2x/jl2lKKJ8DV7Nqtm/d0nN+Out7spNoXdQABqfKXatILslj7zfc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c91553fe-dbfe-458d-2d26-08dc555ef305
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2024 10:55:47.4523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cahxDEK3x8EBo1gJNHutCir5TK+onDXZzkF7DGDT6Jfzrk0vzfY0QFb8aaSlvDAHXtoAd3C6EmxkzXY7AiFmmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4808
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-05_10,2024-04-04_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404050079
X-Proofpoint-GUID: Pxy3z_N-4gG6LrpX2hfgn3WSbHRTXDCU
X-Proofpoint-ORIG-GUID: Pxy3z_N-4gG6LrpX2hfgn3WSbHRTXDCU

On 05/04/2024 11:20, Kent Overstreet wrote:
>>> The thing is that there's no requirement for an interface as complex as
>>> the one you're proposing here.  I've talked to a few database people
>>> and all they want is to increase the untorn write boundary from "one
>>> disc block" to one database block, typically 8kB or 16kB.
>>>
>>> So they would be quite happy with a much simpler interface where they
>>> set the inode block size at inode creation time, and then all writes to
>>> that inode were guaranteed to be untorn.  This would also be simpler to
>>> implement for buffered writes.
>> You're conflating filesystem functionality that applications will use
>> with hardware and block-layer enablement that filesystems and
>> filesystem utilities need to configure the filesystem in ways that
>> allow users to make use of atomic write capability of the hardware.
>>
>> The block layer functionality needs to export everything that the
>> hardware can do and filesystems will make use of. The actual
>> application usage and setup of atomic writes at the filesystem/page
>> cache layer is a separate problem.  i.e. The block layer interfaces
>> need only support direct IO and expose limits for issuing atomic
>> direct IO, and nothing more. All the more complex stuff to make it
>> "easy to use" is filesystem level functionality and completely
>> outside the scope of this patchset....
> A CoW filesystem can implement atomic writes without any block device
> support. It seems to me that might have been the easier place to start -
> start by getting the APIs right, then do all the plumbing for efficient
> untorn writes on non CoW filesystems...

03/10 and 04/10 in this series define the user API, i.e. RWF_ATOMIC and 
statx updates.

Any filesystem-specific changes - like in 
https://lore.kernel.org/linux-xfs/20240304130428.13026-1-john.g.garry@oracle.com/ 
- are just for enabling this API for that filesystem.

