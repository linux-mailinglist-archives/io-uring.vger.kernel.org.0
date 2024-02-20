Return-Path: <io-uring+bounces-662-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8540085B686
	for <lists+io-uring@lfdr.de>; Tue, 20 Feb 2024 10:03:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC321B26C46
	for <lists+io-uring@lfdr.de>; Tue, 20 Feb 2024 09:03:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53CD15F567;
	Tue, 20 Feb 2024 09:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BSWCBD4+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ltTHO1l+"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981765F54A;
	Tue, 20 Feb 2024 09:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708419741; cv=fail; b=Ja3ankx9VCfYwrm1oEo/6Ej08c0908/4fEytoZS1Up/g5u2L0ZEzxTIu6Blzjmw+EbUABsA/7r0qfTrHR3Lxg/NFaRiViQqG8qUw12j42hjS3VVSectYx9DkyGEyGGaj0Qp4j2usCe733oygTjupplwJzb/gm91rS2nAkhwl8no=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708419741; c=relaxed/simple;
	bh=p67zsteXTeOfmlmjF8A1xR0Q6NP0ONDNGxD0thIm/os=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iXZjeNdaqObDgyIKTGSl41xaVAGgRcgKgV28fG0a1InqI4OD1pj7pat53sBIJG9GXe5wWfF1z/EUFiFRBzv3blqTJQClY/q7/aomNGCfgahZYifrE8H2OgzrZ8/OJBLVY/cgBpMAPtTOtWXn/MK7NCJVCcqdOD51YncyeWvjQvY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BSWCBD4+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ltTHO1l+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41K8wqXM030950;
	Tue, 20 Feb 2024 09:01:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=p67zsteXTeOfmlmjF8A1xR0Q6NP0ONDNGxD0thIm/os=;
 b=BSWCBD4+OSOo5hzCBl30iesuyoGfCmRqE+6/kgu5WuqQZLbiV/u+VYdZAIlYgLgLk3n5
 YMwLgUl2zi/08Sqw6w93yWkuUr99Irn5bw7wQqMCp586D5BZfg63uaDJuF7mE5dDwHaD
 i7hxYlmPJmTT/4PyACGTdZqnmHDaVZUgDFvfg2wDHQh9xTI0aSbIs/pQ+K6heGesYVJw
 4xbIxRSRKG4P7uanfx27oZkz5VSLmeLk7qCgeuteegMGpwuwM0YiLA/hIMdxHxpGPsAl
 zBKnOJb7FFpJfcxRvW2EG3B8AKnPnDGklT7OnY0+uAkIr/pYKIkpOfhgkPumG6cyz0oF 9A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wamucx475-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Feb 2024 09:01:44 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41K7FOpd038036;
	Tue, 20 Feb 2024 09:01:43 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wak86x4vj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Feb 2024 09:01:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=diruRZy+Gp2GMLyaJOgvv1Ujv22LOsVuHcLBoNhYSEv8K0GOD7oIgRCJBDemTfAG9Kmw3NHa2FHBxngq5fJpnKcXw4M/GkJ96Ip/ORP+y1zeX7OtlWjNcBGeWdHCyfXO8oSjv8UfNmV/XWQJzmz7jUMS9nSBRcJuYgl9Aj3Cfn6ziswRhI1IeO9uwbcpKf5aI6PGJXLmDJsvmHIEFyzVc3WtbDa19dHWIPvAchsfnfilz32GzY5fo8gPAjh3Ggu6xC6cQxnHLJ1zZBy/Vy+N7NUJO8E5fZXA4sfgPVbdvz1fQqEoIfl1FYfT/LbUiR7fq0lcEm+ll3+DUo2tcnjLJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p67zsteXTeOfmlmjF8A1xR0Q6NP0ONDNGxD0thIm/os=;
 b=JjaJlzu7CAuasTUcdNdYZXTFLGcVVIckNbix9mLfLmLAo4HqZf2wmqvTXKjlr+RzcxzpR/vnQNNJljPQLHQKnVEINCmmU3ZnWl1HrIXA6LQHL7W8O0H1du2uv7Uy65gE9pAu//xW4LsY77nXd50ltXzXFa+d9mTovbKdnhFh7J6/Y484WTHZg8gDPdK2egwB7wYBAg3hbn6z8VDFWFZwTqFSwfpHkDJFdsLK8DwGnPwc5+cOsfoRSghQWOfEXSQNmcrzEibiZednbFVu3xd1UKmDOK/9HMO4f5PTziScLFfjIxSFupT5kRfJcMYQHqmZpMn1kkZHRZ/OQDCzyABpCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p67zsteXTeOfmlmjF8A1xR0Q6NP0ONDNGxD0thIm/os=;
 b=ltTHO1l+m+bJRe1FjMblmxTPNEvTea2HZlpdjYLch0oZUNoj7KfooGtfhekOXy09Wl8yC1SZQ5Q4bAv19Ljy0BH4uwK1rbmElDW1Qw+N9YWWgh6mtBJE7ZZa5hurHuLkE8Q1l8k5vK8gwbgGcSZxW3GA8zf9QPEep8iAYXf/17Q=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA1PR10MB7312.namprd10.prod.outlook.com (2603:10b6:208:3fc::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.38; Tue, 20 Feb
 2024 09:01:41 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4%4]) with mapi id 15.20.7292.036; Tue, 20 Feb 2024
 09:01:41 +0000
Message-ID: <c8ddaa51-2a47-4142-9fa7-448817eb3386@oracle.com>
Date: Tue, 20 Feb 2024 09:01:37 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/11] fs: Add initial atomic write support info to
 statx
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, kbusch@kernel.org, sagi@grimberg.me, jejb@linux.ibm.com,
        martin.petersen@oracle.com, djwong@kernel.org, viro@zeniv.linux.org.uk,
        brauner@kernel.org, dchinner@redhat.com, jack@suse.cz,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
        ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com,
        Prasad Singamsetty <prasad.singamsetty@oracle.com>
References: <20240219130109.341523-1-john.g.garry@oracle.com>
 <20240219130109.341523-5-john.g.garry@oracle.com>
 <20240220082033.GA13785@lst.de>
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240220082033.GA13785@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0041.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA1PR10MB7312:EE_
X-MS-Office365-Filtering-Correlation-Id: 89b403be-90d7-4cc7-f9b9-08dc31f28dd1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	z2IZXdk+3uVGgAq5d2uA4OMVMR5JCS+eBsFzBPNrptq8STehARx+zfHSiYPbYGif5YIvvIq/8a2LaedrhE9sWuXixesoiceybF1CQQp0RZjDbHXcFOUtQJikDXcvt643LrNNdg1LmfEpaYVu30Hx5DQiEDCUaPYYGmWHu2akul1OrEI9RvxCcz4+23brtfAzWhjXTUxGzSs+r2aIpxVDacgYbtljDMKyU2l/R76Pb1duH7Gma2/eDkkQfPwZOwMQn3wsn8MSxAe3ks1QTFJC2NPWBHqN04hK1CxtXQ2g4agrkwjvLiTIl97MTxrEdrwdGx7CjRWrOi10o3BrjMSKTV5kkA8B3RWFZnJp9xfCVKJDLaXGbTkqd7ZGUZVfN0CaU3S9KJ5mrkhTJQxqlrEHatyMTzJWosrkBzZSzW6nkzrh6A/0nHWKHafklGp+pmDjcqaoStGWqGp6oLmyyB6mIjzQyV8yt+QxSFrozoONbMRaBzg8foDaInsOxc2PyCXUetVhgeAngG4PYRViEc3p8nogsDHKIHAyy52qf6n+EQw=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RW5xUndLdVdNeGtETGhWK1VjUWk0S1hLNWpsT015OXNqOEVNUzBSaHZjd1U2?=
 =?utf-8?B?K1orSzcwdTJZWnc0TGQyNEFoOE1pQnF4OVZqT0FOYWpua2x0aEs5RnNyK0pT?=
 =?utf-8?B?YVhjTW9VVVNGNDNjTmdERUE5bnNJUklHbnZ4WFVjZXhVRmM3R3VZYk1PQm9H?=
 =?utf-8?B?UEZIamQ0TDRuLzBNSHZrRUJTNlNrZFJEVmkyWVd5UDR6aW5tQ2ExejI1M2ZR?=
 =?utf-8?B?bUsvMENkNllkSWYyeUs5VG1QYVp1L0lHS2RNTGRscWdjNDNYWkJOdk1HRzBk?=
 =?utf-8?B?anBpKzUvdXRoaWpVMVdkRXRGUXVkU3loS3JSVXNyTWhMM2ZvbUFtSk1hQlJu?=
 =?utf-8?B?ZXVUS0ZxMVdWU0doWlhGdDQ1d2MrcHkySXZjNU11Z0laRjZiMWRxejVGbkI2?=
 =?utf-8?B?Nm5UNGoyeVVJVmhTRHVrZmNVYkYvL1RxbFBpUXNQRDUzWlhWZ0paaGlWQzBx?=
 =?utf-8?B?eVAwYlhqNFZXL3ZrZlg3eTIxejl1MXdLY25VMENBWC8yOUtSVUR2MjdXR2ZF?=
 =?utf-8?B?emovRDU0NlJJbWY3UTA5dFBseGtDcnFzcWpQRU9sV08yTFRGT0JXYXhZOWFJ?=
 =?utf-8?B?Mk1NMjlabEtrV2V0cjN0U3B2MjVsTGFPR3VCQ2prZHhWTFlvdS8raTFSTUIz?=
 =?utf-8?B?NVlsdXI2WG1DZWdCVDl4cHlZREgyTzRsQW40Qm1Tc2F3L2FzcnRZbFdveG54?=
 =?utf-8?B?NERYRVdpNFNoV2h4TWM2YTlhVmVCUDJ5eXRLQjNHb3dxaWpyU1plWUxyWlpG?=
 =?utf-8?B?WjhadlY0T3JiUktScDFtckQ1WUlVYTJNcWQ0eUtSajdGNVZFN2FmaUlLa1Vr?=
 =?utf-8?B?TGFUd0FIaHVEN0NLVXc0TmhWcDh5Mk5mM3FIcWhIbUsvWGNKRG5hTU5VcUtp?=
 =?utf-8?B?c3h0OWFDYU5vdVF1bWRkZkxnRkVpNmUxR1FZemVHaGF4NEtUYVM1L2dsT0xC?=
 =?utf-8?B?M2lMcmkzRWVmVncxNVZHdFpIU1dTT05VMDVIR2krODJqdi9xb3hZVTE1QWVP?=
 =?utf-8?B?YUo4NXFhaktTY25LTEVGNDNQdDBYZzNyVW9HTFdVWm4zV3YxdFFOWGtoemF0?=
 =?utf-8?B?QVVzUlU2TGlGMlVnZnZLL3ZGcmYzTXZJY0xlQSt0SFdVOTVpQzNNWGZ2WW12?=
 =?utf-8?B?T1h0ZmcxTmJXeUdMNnNKMTRwMWxPMDlBay9oTFkxdWNEejZ5MExvWGhRbUVi?=
 =?utf-8?B?K1RjTVVRS2dZMmg2NHRLdmYzSGFlTkZUdVZVUUxxWHR2czhvdU5RR1p0bWlS?=
 =?utf-8?B?VnJoOFVYY2QyZnZEdmdBMkg0UXlyYmtvK2RvNkRsTm04MWNFNjIxZXJRR3Vt?=
 =?utf-8?B?VTB3amtpU1FHMlI1L1JmVXJqcHpnaHplMW00TnErclNOTkw2ODJCL0JqcWJo?=
 =?utf-8?B?WEd3bWlqWFhxdWpFZ0d2YnBhYXMzL3ZtdisrQklkODdzOFd5MFU1cHVzeE5P?=
 =?utf-8?B?azNxSVRsdE45S20rV0QrWGhyMVRNYlZUVkpLeUtSRDdDQUN6MldZZHZnd3Bo?=
 =?utf-8?B?VkVTLzZxUWlHdi9hcUdTRkx5QW1OeEplMWFxQ1RCUFphbVVUUGJaajdQNzE2?=
 =?utf-8?B?c1phVjVYdk1vSXVUdlVEVllzMzRJYlMvNDBNc05BU0V4UHZhRXJHMnZOYUFk?=
 =?utf-8?B?Yk1zR3BrYXlyR2FzRDFFSjVEN3BCYkp6N1pXSkxISTZiNlZrMGZiYUVaYlg1?=
 =?utf-8?B?cXZvWmxaNG45SDNDLy9nLzJwM3JscXlJK0dabzd6a1EvZFN5RllzRHZjNDV3?=
 =?utf-8?B?STB1UUJ4bVRoSkZZOEd4UWlheC9KWjdYNVUwSkFRMGl5bkFDMUMyNWd1Yndx?=
 =?utf-8?B?M3N1RUdIajVieFZCTlRFbjNxWWFMa1dzbzd0ZmxNVHdNeTEyQ01wQXdlU0N3?=
 =?utf-8?B?MG1tWmF3Qmd1WXJFcCt4ejVXaVRyNUFtMGorWDdqcUJjYUFtbkorUWxqYkZM?=
 =?utf-8?B?VWNEV0dMME5hZGQrS21CdXcyWVU2ZDlyUXo4c202VjJ2M1pVd2VHbTBwVEd0?=
 =?utf-8?B?RE1aVlh2NzhnalNvcGdHUUF0Tm15eGpkQ2V5NXBzdGNHMVB5aDR3NDNzTnJs?=
 =?utf-8?B?eDdmdFlOYndYRVhWVXBzem9FZktnN1ZsQ2pQR21IbzhWZm56UEk1ckdWamtn?=
 =?utf-8?B?bllJU1hieXRtRlErUU9kZkxIQ1FpMmMrWmRIcDBzbitCTEJ2NDR3TEw1V0k0?=
 =?utf-8?B?K3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	JExKD2UNN9rLpFwHLRBukOb5D3LY40Mpl+DzAYaJWmQqgEiBrSf2RwbnabJq9f5TKSxD476jvBh/kRXQ62Embh/P6Ne2THMk1hAZNcb7ypRokM1mVjvb3t93Rn0Xrr+GWgedZfXNA7UtVdcrHn28H/wl2LBCBD+37GTo1biYo20BVO1J7P91j9RD9CEuLN8dGX63siMsB8+veMuwDBTcFyVz6K66tw5FOOpBBgntp5N6qriXp1kJASGUgAZC1R/eCBCWYQW7gZJOYMCSucaxiQ56jPYgKKxbEkR/8qE2COWHtXuEerAmv81fXADFuLETSSADhJYpgUMaSgN2pcOXAErwd664denPYvvefzLEmoJNn4SHFIWSIMFEIkkHWIpON01gGQXg+QAP/m0lIXKoI+tbH0LdTB4v78KJ+hho0bNvdpKHNioa0dG3jP6TdZXW1+kG19tGnfy5yXRbXfp87nHa2EGP0qTOxvg/I8yIo2umb+SEgkDAZJ5WCoPjpnYxhATE294jOVCkiroRCRPF1eKycwy7ydrJcswB2/Hzzyl4+DSzL9ZFO2g7M2pCwUoB34jPsG10A7iyBk120mXschngwEmFuWgqcCJmDG937Vo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89b403be-90d7-4cc7-f9b9-08dc31f28dd1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 09:01:41.3035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LzvW50TAMKkA4xIcpoVLHJlIP6gy/eTl0HSVoKGdOtn/x/N9k6yosjAu1njTRtO7g8p0rAxdTEiw7pPobnjcWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7312
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-20_06,2024-02-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402200064
X-Proofpoint-GUID: H63Sc2dFKxQxAFeaNkq0BQqUYdxkKhej
X-Proofpoint-ORIG-GUID: H63Sc2dFKxQxAFeaNkq0BQqUYdxkKhej

On 20/02/2024 08:20, Christoph Hellwig wrote:
>> +EXPORT_SYMBOL(generic_fill_statx_atomic_writes);
> EXPORT_SYMBOL_GPL for any new feature, please.
ok, thanks.

