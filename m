Return-Path: <io-uring+bounces-869-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76ED48768EA
	for <lists+io-uring@lfdr.de>; Fri,  8 Mar 2024 17:53:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E3D7283A84
	for <lists+io-uring@lfdr.de>; Fri,  8 Mar 2024 16:53:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D6A41BDED;
	Fri,  8 Mar 2024 16:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZespFzph";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PdelfOB7"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8A115D0;
	Fri,  8 Mar 2024 16:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709916776; cv=fail; b=kUqj7RUO7Lpo1h/zaR+a9LffnqQfmOm8QR2voiZQe1pxXmfW5KeZxLJlNkjvLybUUXE1rNzTTnzYsUSIGMiBu+PJHU7DIyQStJSulKNIdxiECHp8nZA45tPolC2e1u8E+0Tw0lucnuK5DoRwhzNyQ/xtA7Vmujer7bQXCX/NgZY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709916776; c=relaxed/simple;
	bh=RvYBdJy86SubqcnLV2FvBuSPGcCGVrmuoLtv6kqRYiA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=q0KW5hc8KumLKCdmSqt1/cc7crQuenkiAJde+4z+H9VzHwxK8eV35hlPWkrIZgarJfA/g56VmJBr0zStzxvn9m5opbC0UXpw5eeQXP926ZtQ/poGuL++zJn7DwxMA5QEEl72ZRqwulfMFcujENlCrNHlNcAGW/xrlUXYsY4F0wU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZespFzph; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PdelfOB7; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 428DTZJB013833;
	Fri, 8 Mar 2024 16:52:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=wNELWB2/uo+vBt8EnoTsat0LHCpZq/2Xu0BwLJzsegE=;
 b=ZespFzphKvzoksT5K7npDiM9yLrfO3xeC/9pcLGVNTUH7QBWw9LoOTToviyJ8P+PAIzQ
 zmPHlHr2Fesge0rExFWnFX7CQESO+x23QeCQh69+EoXsaOLw65sNPLAnhsdDgTppe5Zl
 gLRFv49B+Gnu5khYIiN+eE3eTETejtbqIBFo8czkAbSWrOIewP6DhEWTVVXV/sKrtZy8
 EwUmV8Js4Nopx8vn+kfJQ034PzQ9TGGyDUrbP5xQJ9DEVd+JfRatshneqbcToUT9q+BA
 y0X53NNoma2goMxQxEmVk9F7s+O1gxTZszyGCx0+OvOmf6/5Quzzdy36I1rI/YNgXIzn Mg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wkvnv6d2b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Mar 2024 16:52:26 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 428GhO7s013856;
	Fri, 8 Mar 2024 16:52:24 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2041.outbound.protection.outlook.com [104.47.57.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wktjcugvr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Mar 2024 16:52:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k+elzCzZbwpF+OdBXm8cdUonf1SfWcZfkHAsKrpZa+vq0MvXKn2/JFRYT+XiLTXmU1PNovBKJarxNUgzPC4+1GnDqGSriTWhP36mfz8F8RIVV1tOSJ49GNNyfGu7R7wvDuz5ht9gbk5WYFo/5IxCsNse3dwABqULNJYtE+arXaa+U0r4CPjHN411NvAQdeWGFMqvp4DnINQlvgBSF3Z2UPTpaSvUHEfImVyi4Ht1gIcUw5Pp+xo9g6uR5yOFdT5gPp2LHLVKsS/08ETRujnoE3x2jIgTnwyKkSItjaO7iEMZ54CZZfNBbIEroHrXX1aOXAql8jxQ/Ok21AxmcPsa7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wNELWB2/uo+vBt8EnoTsat0LHCpZq/2Xu0BwLJzsegE=;
 b=hmUBXwcqtU7O8AVFBDWObgFYZPrufeYxRHbbv+Xr5tS26iLsovV3n0iEeE1yMrQurL7Rg16lG4Aodl3cfvQ8Xn5Et+hP37bBRsIxl9oLgn2eEG1bboTSD+Fjt5nG+EV5tSOpAQrikMH0gXqw089eMyJGoacotNRhe8OYaYTmcPe4cSAQSB9UEZepTisbHVC5+8QlxIcwGNfrVr0ZTWN7PhdH3LkOH7aTq/moKYn0DhRtSQAk7rnb639CK2TTdN/shxZggERfxjI5e9ysOIF6ssPKXAWa0juLaa/Nghih5hxNJb62EVF6SZmxEDI0p/uP9zt1qFy2f2R8PH04fqyt5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNELWB2/uo+vBt8EnoTsat0LHCpZq/2Xu0BwLJzsegE=;
 b=PdelfOB7skRNm6xFA14L8EOuWfCFMKGmMUv2hGdn4pE2HdwbxPAeCgX8XSrUOjlc7lqPPiIgo7wOj0k+oP+Og9+1HocUPiutxX09eQ8OTpONdUTaBfTPM/Vb3IFE23mja7W3z38VCIu2W+hMx3Ri6OMmE6VLoukqaQm+7q+acNQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB6103.namprd10.prod.outlook.com (2603:10b6:8:c8::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7362.26; Fri, 8 Mar 2024 16:52:22 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7362.019; Fri, 8 Mar 2024
 16:52:22 +0000
Message-ID: <67aa0476-e449-414c-8953-a5d3d0fe6857@oracle.com>
Date: Fri, 8 Mar 2024 16:52:16 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/10] fs: Initial atomic write support
To: Jens Axboe <axboe@kernel.dk>, kbusch@kernel.org, hch@lst.de,
        sagi@grimberg.me, jejb@linux.ibm.com, martin.petersen@oracle.com,
        djwong@kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org,
        dchinner@redhat.com, jack@suse.cz
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
        ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com,
        Prasad Singamsetty <prasad.singamsetty@oracle.com>
References: <20240226173612.1478858-1-john.g.garry@oracle.com>
 <20240226173612.1478858-4-john.g.garry@oracle.com>
 <1f68ab8c-e8c2-4669-a59a-65a645e568a3@kernel.dk>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <1f68ab8c-e8c2-4669-a59a-65a645e568a3@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0127.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::6) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB6103:EE_
X-MS-Office365-Filtering-Correlation-Id: acb233fe-1d5e-48f7-4385-08dc3f901fab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	0XzTsJ+ldbI7tTGRJOknshaIuzJA7R4slqXq50HPzfWHPk1axZjHnwm6xRVqQPAM9e+0dO3IKP5zMqmGpeu4NMjCqM4ww3xJCfcJi/rn6BAW12qsNJqNyhyIgUbuU/SPXBaBGPrTZbssutg0yL10RmsOl+d83V3593B9lacomw/LV8CLAiz5VjteaqDEJ3eMc5imPYu33ESs/xKhuvsGRIkTWf9pxyXGdgUfBonepLlWm7Js1foXeqOF+fugHsOSGbKgyV8wZc/kpLyn71pBLmnpTjzFjZ2eCmo6uTr5tl1e/QQF5nWekrlARZy+arV1rS9DxEw+UG21NPY2HeGtTaqzWXqmxkQHPZuRwaqlrRvTik8TyF8u2rM0jVlMQv8EoDIBS6u6bgORq/sdKpu2x3ckoBe/VchazsNmJyW8FZ+ZFfcz/r3RwRj/QIjRyadFeysyi362UuNLtiDXz7hARf9NVevfgKbisrDpKEzo969RA6RH8HVWEHheMxOQXYtAugGOevCFbEi4k/6qNxr0LXc6/l/djoK+BCOZsyobxVPP6afj5cwGVqytQotCoefxkmdqoMgB9R3edUuZGTR54gnqFz9w7tF1NT+MbTCXcSjZ0zgX3/ZnbnLlE9GqixIKKzMcGgviR8ZDK55PNiK8bydMHrg8y4XsU0EkMzzU6jJfBRsnxIUMmHI/X12NhjrPxwlWsfBHlz4PvlEJ7QxyXg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?cDIwcU82aHZYaUhLcjdPREwwNHZlekduSERSdHJ2bGhNT0JxcHdGc1R0Q1lk?=
 =?utf-8?B?TjhTN2FTQlJGWWppdHk5cFFOa1k0WEpHbVZLWFEvdWZvY0tzU1h4YkY4Y09a?=
 =?utf-8?B?TzJtd1YwNmUyNGxVaW1EeDNQcW5aUGt6SW5PNmc5a1o5RUFLRFd2T3F1VTJa?=
 =?utf-8?B?TEF6TE5kQU9LcVRWcGNzVUdPN1FZcU8vZytSZEpIWkhsalVXUWhYczFDK3M5?=
 =?utf-8?B?dFVBS2RpM0xrL2gyVi93amxtU0x3eGtSSDlSc2dIeHBnMUU1MWVSbnlkNldF?=
 =?utf-8?B?M1BYYjd5RStoU0p1eGVhSXVXSVdETFNERlZIVXB4emw0QUxKa1pQRWREOXp6?=
 =?utf-8?B?a3FrNUkzb1A5U2ZIWGxWNTRydnVnWk8vUlRjQllncy9Ea2dzRWRBUmZub3NB?=
 =?utf-8?B?MFlnV083SHlYai9kL045aWFMNzFhUkdnZjRFS1I4M0pINmVKMjZmc2ZGZlQy?=
 =?utf-8?B?RDRnTnZ1MktjT2dUVFBNN2xKL2hNYUM2TjFSK2d5Zzd3b2Ywc1ZQdjBEVDJn?=
 =?utf-8?B?ZjBNMTlGcnBuRUdwWjNZT0lLWStsNUUyZ1lTWlNxTlFLbGFKTkxHdm9abTVw?=
 =?utf-8?B?YkVReGM1bm5GbUp1Q1UydHc4czdaaHJIaXZRdUhPd1B1SEM1VisrMmFwL1A2?=
 =?utf-8?B?Q3VNaks1cVA4WUhOVkpQL0c1eXh6NFdsdElzYVJPcUx6KzdxVi9KWmszeEwy?=
 =?utf-8?B?OUNLUjRZSkxSTmY4Y1lnMi85N0QxNEYyL0l3b25sWUV6MlFWMFdHWVljYUZE?=
 =?utf-8?B?RVRPNmdTdXdvMjVjR3o3QmNLYUwyOHNEWjRTT2tjdWJwSXl4V0U2b216Nnpl?=
 =?utf-8?B?L3FCbnhZNVRYTmE0MThxNUlLSEgvd2pmaXRiZ2RJbEtWZG5zS2dMWGx2MDZ4?=
 =?utf-8?B?VlRleFNyU1R6OXZ6blZqbmt1V242L2FXWG1FenNkSmNPMVdOREwvM0tUYkNV?=
 =?utf-8?B?dk5pYVAxdEJPbVRTN21wZ2NZMUxIU0pYSzZxNnJ1Yldrdk5NOTUyWGFXOTlY?=
 =?utf-8?B?NWtCNFhZRXdneVRMd2lSdzJLZGxlbDJ2UnNib3dlbXdDZWlQMTQvYUhtc0Zj?=
 =?utf-8?B?blhxLzdQb1lBOStIdkZEbGl5d0dXWWxhNE9GMUNHNzJJK2xVeG55V3ZQZGFL?=
 =?utf-8?B?aDMrYzRxTFUvcHVnV1dFdUw3ejZqSUZSRXVMa2JmeExiUDdLM2phWXFNSm5W?=
 =?utf-8?B?RFh4T1JheUUycUUyL3lsSHpsV21YQXlaMkJycEp1dFIyTGxaM0g4ZGhjSUdN?=
 =?utf-8?B?M3lwRGFjWDZ6VnZpQ0xkVHIrS1BKbG9FcWNrWGx0SGpxRnhwRlEvbU1vbWVa?=
 =?utf-8?B?WFNuN2d1TkZzN01mNk91Nm1lVGtjbE5ZSW9PNDFycHJiTUd5WlBrZ0hoTEdx?=
 =?utf-8?B?VTUzMnNlaVRJZThlRWs3VVYxRWtwdTdTUFVmc1k5a3VRek5zMVhUWW8vT1FV?=
 =?utf-8?B?RWlBeVU5OUo5TjdGUFVqUHBDekpIWmJuL2dZU1ltL1lwQUJtK0toSXhNcnc5?=
 =?utf-8?B?cDJ5WUhhNmY0d0NVV0c4VzZZYlA3dW5kMVR1eW5yTzd0VDZJaWlSWGs5OWlX?=
 =?utf-8?B?dE4xS1REcjZtREtES2dHaEFkU0ZGTWZXL2I5SW1QUTNtVzU0UnRoNjFnZU1E?=
 =?utf-8?B?K3d3cmNYNE5hMFBFNU5OSmhGWkV5OXloTThoaFRINFRFay9oTFFPdnp6RnRR?=
 =?utf-8?B?QXBTdGEvcVJLbDlTaG41OTVHTkRna1VFVTJiMlJKSzl4UG1seERmYXR6V0pp?=
 =?utf-8?B?Qlh5MUhmM0wrNVVJbjRxUC94SG4yQTk5SjVjK1o3ZDFMZnJ6YVZ3Z2lkcG55?=
 =?utf-8?B?ejlpYVgrRlRPRC9EeUYzN2dVeTUrVzhkbGgxTCtEcy9BZE9IaUN0SExBWUpN?=
 =?utf-8?B?ZFROOG5vOStSc1U4VEJnR0hzQzZXbklPMUhYb1JaL1dxcWIxaVUvVFd3ajlH?=
 =?utf-8?B?RG9sbWJMUHJLY1M4aTNGTUlRM2hhNWNPcDgwVEltdHhINFIrUzA0Q3BmWmxL?=
 =?utf-8?B?czgxT1pySTJEN3NRTmtLZHVEZE4xUFJoQTdvSERVUytlZU1FMC9seHhHTlZi?=
 =?utf-8?B?TjVYNHJOOFRvWUFlakx0aUIxOUY2bFlxR2NoK08vcmhMZUFjZmQ2c0JFZjB4?=
 =?utf-8?Q?TDcqUMu/am0BADZuJkAr8E7Wp?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	o5FTYdO17qic26cnr8XA9S0P0yn1EXTAnHb6LyYNfbmaExFugKorewyDmii/XFrKayQVPLa/M/tXtvYFynE2BT4heiq2uI/QZaN4SCTsuuVaKDfj+pNNKL9xQLjZlNxkuO3F7nsCP60RFhB9vWRpz7LH1+kRL19OMWbyM2m3NhoDnPfuxHf8NMkOAjyDv73/+88GZ4p96GPXngy+fdBxVRI1njcIs9hDEXmRPZfskQCfqzBiMMj3h5nS5vG+R2TW5wVfeRfODI1rbbmtNzOJCAlff13CiU4YqiE67VdLftVsxReuWfbX7oDNeDO25cQqu2ZrkuXEEBH2wnW2c+HrcQR7zdzO0UCbRiVLdHL7z3mAbRca3vhiiP2RERjrDX4XTd9atR1ZcAmxxEPB1WD9QUDk7wnVZZQY6bhmrzCsqlJz5bWVSqan4XGHypHQ3L4h4u6awXST6peNdFYTVPpGkJX9t+AKPKvqWQsZW2qJZDScsdgJcM+OI3P/qtXdcMOmHDuIp75ZL1US6ZxdfTWqxqA4EsALMObfPFUwh8vAAJd3Q/MPW72iM46mMwIy8latTMlKWUNP4oFaFhtvcC/0SfvZ8xmUIexqf7FFEytqMsw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acb233fe-1d5e-48f7-4385-08dc3f901fab
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2024 16:52:22.0970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wKu3pZWmtKQXXPzAn90lPQd3qJTnuAw2LvdnffEbbfolRsX0lMDcQUjfW3Uy98gaJS0sMn9/XtO6XtqFmvyFEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6103
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-08_08,2024-03-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2403080134
X-Proofpoint-ORIG-GUID: PkyvtIplIwiCo8UOrXD0ZlbfgYlbvmfL
X-Proofpoint-GUID: PkyvtIplIwiCo8UOrXD0ZlbfgYlbvmfL

On 08/03/2024 16:34, Jens Axboe wrote:
> On 2/26/24 10:36 AM, John Garry wrote:
>> diff --git a/io_uring/rw.c b/io_uring/rw.c
>> index d5e79d9bdc71..099dda3ff151 100644
>> --- a/io_uring/rw.c
>> +++ b/io_uring/rw.c
>> @@ -719,7 +719,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
>>   	struct kiocb *kiocb = &rw->kiocb;
>>   	struct io_ring_ctx *ctx = req->ctx;
>>   	struct file *file = req->file;
>> -	int ret;
>> +	int ret, rw_type = (mode == FMODE_WRITE) ? WRITE : READ;
>>   
>>   	if (unlikely(!file || !(file->f_mode & mode)))
>>   		return -EBADF;
>> @@ -728,7 +728,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
>>   		req->flags |= io_file_get_flags(file);
>>   
>>   	kiocb->ki_flags = file->f_iocb_flags;
>> -	ret = kiocb_set_rw_flags(kiocb, rw->flags);
>> +	ret = kiocb_set_rw_flags(kiocb, rw->flags, rw_type);
>>   	if (unlikely(ret))
>>   		return ret;
>>   	kiocb->ki_flags |= IOCB_ALLOC_CACHE;
> Not sure why you took the lazy way out here rather than just pass it in,
> now there's another branhc in the hot path. NAK.

Are you saying to change io_rw_init_file() to this:

io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)

And the callers can hardcode rw_type?

Thanks,
John

