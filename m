Return-Path: <io-uring+bounces-664-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 40BD685B7A7
	for <lists+io-uring@lfdr.de>; Tue, 20 Feb 2024 10:36:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6597D1C224BB
	for <lists+io-uring@lfdr.de>; Tue, 20 Feb 2024 09:36:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13C1B5FDB2;
	Tue, 20 Feb 2024 09:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cjWNuJ6j";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ea/4RYxB"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECD160EDF;
	Tue, 20 Feb 2024 09:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708421758; cv=fail; b=u0gmjs6DHY1JeDrdBJDHGyS+z7g8+v7XHav0rmekeKxIBiigFunx7/rLZrCe86ohB9kLCrgQU63LxpFnyCR3TJh4/58/65jMZ0r/X4eBIoYjB1J0Q7A1KUG3YCwzdxUfHYcuAO7t7MadNFtcUjQrUqOQ+ueHLT3mEdWU+Yk7Tp8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708421758; c=relaxed/simple;
	bh=yP7kpKkbKFnLYxqn5cCT+V0pKL9hOI4MFuIZRmzhFrk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ay+nLxTokzbwZRaOPmAnn0TxtEyz2jHL43KV/cLtavpdahfS5Uc31RcZDyO4VdvXJ4+kYbuz1yQwefb+RZrHhMrbu48Ae+7WOPUQtiwqmszOWGAO4GXH7k+rgDa+/o+niqL4feTst6NDKdL73mWIOAtqJAmuVlaXr+7qqMKoUCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cjWNuJ6j; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ea/4RYxB; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41K8wpEK030922;
	Tue, 20 Feb 2024 09:35:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=Uk6OIf+2Fu31pDoe5pYJ+Tq0Bsh9NOGycmXcG05Nm+E=;
 b=cjWNuJ6ju7TRmZe/DH7ugcfdsj4gqZH84K1h+W1k3QXSv+Tg2jp/XspGHxE/Gd50FDye
 2F1J8K4l4qA0tSRm81LMa/jMM7MMsLl6u5MDHrpZsZl2exmWXGeY8jw/MTbGFJxbbo2d
 87gdPBksA/TNfrutDFOv6KW5c8wpUGq0FMzKMOvshPcE5+BhFPZwJwRqOKWPPkL8kdhE
 Dd0DF/DlvFAf3gF2CZ8G/E6Du6S5lU47t1VcKI+NBoVH9p5FAtzRvX5xRZZerwXxGP91
 nVG1G6SDZe30/KDhIPGVMLOJj5w6F4VUGaJyJvPi25i/qbeh8rgY1PlGk1fO46TuI5j+ EA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wamucx6qy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Feb 2024 09:35:31 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41K8D1Up006745;
	Tue, 20 Feb 2024 09:35:31 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wak877m59-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Feb 2024 09:35:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nunXMpkKFjALgoHjb9K5aZlKgnbSxdzlka499YNhB6nHAWpI60lUkux+ugLGIUEIv9PT678UqygQTVuu+Upu3FVFhUKKgrNiEvRAQdJd5pXOtKcU44b5KZXIlGTHD7TfMPde5M42qRq21Z20oBWRqOyy6qy/Gn8eEhHSC4mpUEBobzGaJQQnF90yQ9tF9s1kETuYr3qp+I1Yubbo213N2wCDZ/LS48PFPRfLoU9k98wI/EkLV8ABL7yKv2vh1DIU2ssJlG5NZuF1N5M8OHxl1mL86Nd09vyW6/PAvznI5/q22pYBu5q+Id/0QUY6ncZUobRQvRmL/IkfMKkQiylbZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uk6OIf+2Fu31pDoe5pYJ+Tq0Bsh9NOGycmXcG05Nm+E=;
 b=hmFlQmmMMR/5o6K8OPDS0rSxziyytmdLGJP3mbghWur0zig+K3jDP7OdMI+DBW72wFFd26Hvq4Yh1y0fiiAPP4x9uT9GrXzArHlXrIgIiJvnGMcP0v14O+nRTgSfLH44rfror0EAOc0O/ofCMe5n3g0iuYGyVhmnr2wAt50pZ7BtiqkwG2PZq9BCPbqxfXWIXNCMELMs2Ff/BE3caZdUNov1TxTj8Dt/pamP9cy4DgM04Zpx/E7io8fClulmknTd/c1y67QlJ7dVZ5RYn2jz18toMMeuD5Tm0JjBXCbXkYPir+03jIKdo60M3+RWf75dNgDOyaiyQsn1CpFS4m+hcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uk6OIf+2Fu31pDoe5pYJ+Tq0Bsh9NOGycmXcG05Nm+E=;
 b=ea/4RYxBtJ0eqJPKMpXVw3gseBzMxZuKToTNRy8wcqxDVWGu4PGl1VqHeCwl+vzsFqa+3JNUnfKfltiLBLntGYfWYRD2rJH61orQWYFy08nhdlhj7UKaBKtajuVaYSHX72LUeIQtL5fBFngky1xqYMZifUcw30EDIx9I/pz/+eY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB6349.namprd10.prod.outlook.com (2603:10b6:a03:477::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.39; Tue, 20 Feb
 2024 09:35:28 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4%4]) with mapi id 15.20.7292.036; Tue, 20 Feb 2024
 09:35:28 +0000
Message-ID: <8b4234f3-3fa7-47ca-bbcf-0198a102f7a9@oracle.com>
Date: Tue, 20 Feb 2024 09:35:22 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/11] block: Add atomic write support for statx
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
 <20240219130109.341523-7-john.g.garry@oracle.com>
 <20240220082902.GC13785@lst.de>
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240220082902.GC13785@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0223.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB6349:EE_
X-MS-Office365-Filtering-Correlation-Id: 16fed12a-5e59-45ee-fd10-08dc31f74631
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	hI956LWUVjwhs7T1GDkNsdHYiiHN7a5s+P72rdUq+NKNtO7Wk/UIW8xFAmWUmSmBOiAFldPNjW35SQlRZFmnZwInQzHZd9rDkifGgnpvRotA685re/aOwTOMwB2kJptBnyjK0Fi4XUnpftbfuoyqxgnW7QzTtkKUNfYr5STN3a1+yZfk5tu4JwoWtRNO+2voQQNXBWWGeRbuAWA/O+1vXaCJUx7phOrPbRx7yZJWua5n0AkGjj2afLxLklXGx6t5kCGxylAgZGo4/FjUbmmvTW6KWHS/12NhIlFnUMh3iUI/PEeGqaGLKPJGVyipDl+B8X/csv8HGHGEHh+1kXA82+q36k0SfwPnFFT/toxMpeu98XRa3UN3zgTvRlKPSRiDOiChaEHYq7U3VQBFRF6P5mrIxhVj4y7Qvf3/sS7Es5v8l7Y1MEkeCwBxj/vllTek1qIeN68BKrT0viUtZ70ulGmp9JZbe3jfKekunOAZc6u3VBqxrFxYEdoZNexyYw11LBf7bkZQhLIP7ahW3/eedl2j4SwfTYC9TDNTux6NFGE=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?cm4wSUFVOHN0Z0FCTGZzeHFWeVFhdlNLUFczYk14UUhtTGdmRTZCakNwbVUw?=
 =?utf-8?B?czh3KzVOSWtIQlZicjRlVFZTUkVBamNvM1NMdXlWcnlLZkJCOXdSUmRFaERQ?=
 =?utf-8?B?RWFiVEJ0d3NJdi9TZlQ0T0xEMEtEc1F6S01zbktxcmNoOVc0alJXSTdCenln?=
 =?utf-8?B?dmFkYU8zR2Zqb2xHSGtCQkhrR2duYkFQZmNFdTJHZk5kTEJpM1I4cVdhTGVh?=
 =?utf-8?B?elVtTE5nTlpjdFlaYUh1d29LU0RiVTF3WVoxS3ovQjBZemU3cVY2dzd3WWRx?=
 =?utf-8?B?aE5nTzZtQXdNaysrMVhTc3N1QVFwQS9zdk54UnVzVDJUaUdQUmdBREFZWnBB?=
 =?utf-8?B?WXplMGRIUWY2ekErWndGbG9LYXlYOXNiQ1VCeDkzYjlBWnc3NndOWEhzUVdE?=
 =?utf-8?B?NTdmTEw0YjJteU1nOUNjQlZXblpZR1B2b1hieHJrd3FLTW5UT2NtWk1jSVBt?=
 =?utf-8?B?U0kwbERkRWN6NjBFYXNhRlVaQkJtTE1nVEZDM1RvN1dwZlhWNXlsRjNGc3Ur?=
 =?utf-8?B?TDZtcUVlZFMzU1VSc1pzakY5QW5NUEVzSGdrcVgwY2liSDNwd2s2bDdPVnJv?=
 =?utf-8?B?SktGTHJ5N21MbGMrZ0NJSEhvM2VyYXQ1YVdQSC9HOU0rOGppemMwcWxXV0lY?=
 =?utf-8?B?cjZOSUNFallUSWZkKzNHSkpOUXNIcytQWjdNa0NQNnNSekVmcmtHWllGQ1RE?=
 =?utf-8?B?bjN5SEk4bytHejN0Y3Y4dzhkR2cwNzJhQ3BaZVN5WFBLaHQ2Y3E5aURvOWFS?=
 =?utf-8?B?ZTlJeVJsVGRvdit1UFpwbzM5dVBZY1l0eUJoZTBoMUdtSCtQRkFZNkdFY2RO?=
 =?utf-8?B?MlJWUXpnU0tSdkdTNERHSk9OYkJkQkRvMkZ1bm5KTmZMVEkrek9id0VIdVJM?=
 =?utf-8?B?N3VtamswQVlPUHd6am5VSDlLMDZYdDZORXZ2WllDNGowTDgycTNmbTJSMU5T?=
 =?utf-8?B?S0dNZGsxdDRWU2MzK2krSXlMRHdZTm9CQk1LTlRLajdZMlY1OE5UVGJWZ0xP?=
 =?utf-8?B?Y09xaUw3clR0bmM4bmtzemRzeXBqZ0g4YzUvenFPNktjSkVhVFlEVE0wZGNZ?=
 =?utf-8?B?RGQ1QkVQTnNhczY0NHlNYmRkcnVObk5FRjIrRUlPWjBNVmFSZWhyc2VsaGFB?=
 =?utf-8?B?bjN6cFBjMzQzdVh6d01YTmh1dXhiamk5cm43WGF1dGNraFo4TzJNNTE1bk42?=
 =?utf-8?B?cUxPeGdyckJZWk1lUjd2TndhN1BLanpXR3ZtS2NoZzQ1ZHBtSUJCcTlOS1pq?=
 =?utf-8?B?SVNZNk9vOEt6SjNXQWtMVll3UGt6WnNKVzc5MTRxbkhyY25RTkxiQm84Y0dB?=
 =?utf-8?B?bU1HRlErbm85Yit0dTNRclM2L1lwck80SXJlUUlhWFFpMlBadWpRQlVjZVNI?=
 =?utf-8?B?dFZZRzUycFBRWHBpZWYyTVpQcDZ1ZUdBalVDK2hwREtwbldIaTE2YVhMUyt5?=
 =?utf-8?B?ZFJ3NTlZNnUyWjl0MUQ5TWp5bGlSa2xUV29pekE2MzdDeE95Z3hHczNCT2Fw?=
 =?utf-8?B?bWgzdGFYTW5nYlFLNlBZMkVzb2wxTy9RQ0lvYkhBdnNXYW9YTEdheG4wWjBp?=
 =?utf-8?B?MW51WjFVdEFUTncwS0xoTFlXMGxGeUwwdTVFYmgvRTNQcDNsNzM5S3BlMTJG?=
 =?utf-8?B?QUY0dVBpdHE0Wld5Z05jVDdycDl2ZDNQVE15U2FOdFFiTnJ2UW9hOHAvNUlw?=
 =?utf-8?B?cGpJcWQ0engydW82ckMxdUVHTEZTUGJTbEgzZmNtSkNsbU9wUWdXL3YxZER1?=
 =?utf-8?B?N3VoRWMwMVFIUGJPQ2tzbzBnRjQ2dHZBaGt4bGExbExrVHJsTUhIaHBia1F5?=
 =?utf-8?B?T2FPSTFsdE5KQTBoelJISWUvaXZvWGpsNVdzZ2RpcVRERXJtN1ZDSEdJMldK?=
 =?utf-8?B?U2NNeGlaemtOU1ZoaHBxd1pGWGhtOXdPZE5XV3MyZ214QUtqMGx5VndEU3VN?=
 =?utf-8?B?NlA4b0lkbkhoM0V2MWVyOXN5SkNPWVhJRW93Z2RFRTNNRmVWRTE4YnBqTTJx?=
 =?utf-8?B?a3h2VEZ0SEUzMmtGcldPMmJMWXZMcTBqUW1CZnBNbTNwTjJ6TnJadGQ3YnBk?=
 =?utf-8?B?YnBLaG9VWVU0VUJjYzNNVnNGLzYrQkx4MXlLYzJvbmRGNXFrRXFLR2xRR3FN?=
 =?utf-8?B?UEdGRXI2aTJxYThHZFZPenRzYmVpTGQyejJCbDkxT2NFTnJmRjRhRTFhT2xZ?=
 =?utf-8?B?WFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	4WVs2YduwC4D7p1F2yCJp1XAM/DC2EUtlRIA30jYt4qll5G85HfkS8Vkil804917hK9TzRqIOFsn/4txx30pCRioTzPzNsEKKlmvrFFdDhHjiBguVihIpbMweT/3kWP97QdnlBNjcksJWhutssUZCJL71JF1tzmiEEOhY74uuREvbhEWogWtDHOpKFI4PxhGpODjGjrwzFKvN89IO6620cmlyQrVdZRj4dP5/g0H9gqVPD1bZKXIQJQj/0yTQwe5imbFs1Pwsr1ZfMmajWFwIBhjKrXAPFVPJx2L8bMUkGEUDk8lrUeTrRSTOeYaXohC2lfH+a5sF/OW8kSaOQP7tHFE2fm3UoYEySLfjLh6AWNvN8upZZw+fm4SCIqdq7XtjKH45YNZzUx3gIKWZi7ZXbqDyC62qaiamoXes861XfB1a4JYbP/ujP7Na5rXMZmLpXGYv3Dcu6ANCJsSSxONHk+yM4NxEn+Cspo2uFRtNg3+cyXPIe+UrigRm0Y+YRwlS+b+yx5cVGs1b1/QDjxeliCXlazlyzAJjsyd9ZQTEzQLo80hnWelOwRLSq8ISE89RVLtmmQW98Li89C7i+mvQZArxpuznZ6DqY/aRFSuAS4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16fed12a-5e59-45ee-fd10-08dc31f74631
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 09:35:28.6120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tuvjv94QQxAjRbpLItJ4dYpYaGW5UzrL+7jalN+96Ety+5KKLkvbIE8cR7B1ijt7X2xVnxAJHoUqx2GwWkBRVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6349
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-20_06,2024-02-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402200067
X-Proofpoint-GUID: ApoltNzY954qP1He8e0bDl9s5XV0K5Yt
X-Proofpoint-ORIG-GUID: ApoltNzY954qP1He8e0bDl9s5XV0K5Yt

On 20/02/2024 08:29, Christoph Hellwig wrote:
>> +#define BDEV_STATX_SUPPORTED_MASK (STATX_DIOALIGN | STATX_WRITE_ATOMIC)
> 
>> +	if (!(request_mask & BDEV_STATX_SUPPORTED_MASK))
>> +		return;
> 
> BDEV_STATX_SUPPORTED_MASK is misleading here.  bdevs support a lot more
> fields, these are just the ones needing special attention.  I'd do away
> with the extra define and just open code it.

ok, fine

> 
>> +	/* If this is a block device inode, override the filesystem
>> +	 * attributes with the block device specific parameters
>> +	 * that need to be obtained from the bdev backing inode
>> +	 */
> 
> This is not the normal kernel multi-line comment format.
> 

will fix

>> +	if (S_ISBLK(d_backing_inode(path.dentry)->i_mode))
>> +		bdev_statx(path.dentry, stat, request_mask);
> 
> I know I touched this last, but does anyone remember why we have
> various random fixups in vfs_statx and not in vfs_getattr_nosec, where
> they we have more of them and also the inode at hand?


