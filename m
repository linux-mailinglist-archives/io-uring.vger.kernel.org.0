Return-Path: <io-uring+bounces-655-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A22DE85B4D1
	for <lists+io-uring@lfdr.de>; Tue, 20 Feb 2024 09:20:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19E0DB21C67
	for <lists+io-uring@lfdr.de>; Tue, 20 Feb 2024 08:20:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B7F65C614;
	Tue, 20 Feb 2024 08:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kZklqQWO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="a/lOCN0m"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0245C5F2;
	Tue, 20 Feb 2024 08:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708417219; cv=fail; b=BG6aw6p/pO4ufMMciz6AnAzNZBAvs67M3egQuD8A701+QCsesUT3G+DlxpUNpcJDEFEqvJNuHoDf/KwRRk9N+/o6wCFOtbSyfv8luRr1OxhAmRlrOxueOafHC/vWXVATIu5U+k8X+tQi9RitCgyKSGfNyDjNJXVXgN2r2w3zUpo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708417219; c=relaxed/simple;
	bh=NvpIgePNvmKNrHZZQqziduaReZQlz16EJUx4oEWJUu4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dWfDyfzRxwQcmK+tLwHugvHCNOJAtzbDlouDwkBXR4Nhn53iFjOhNITclKohwRzS/RbJroDthMiVP4570t2SxtSBaKpxZMwhVCKUpy3Os4coM6pF9sLMAiVGB8jiD9lfW2tEDAVaT1qT+azQmJ5UEhW7Jrn3qEJizRY458VhSLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kZklqQWO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=a/lOCN0m; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41K7dIXY028831;
	Tue, 20 Feb 2024 08:19:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=T6zJQu8ujok/GaJNC/5QUzR3oiy0YM/Y8T6jt59IfhU=;
 b=kZklqQWON4rfnOq8eO9KDFnOKJrsh/utY89V1uzQVAObzVIiINOXEYMHs67FqGUcCAwk
 9TqnIsJIwho2ovxz5YwSzq4RjsaFpJpB2LfoZZQJl73X0CvqCw1ObXoVFD15rn8CdOGn
 UaLNasNkAa55xr8aU72B3y5lQZvSklFa6/rwhMjaRU7zk1aPtJjDo5EA2+D0NxdFrkBZ
 YAFtcapdqN8A3dySjBho0QdmuFubFSfFbvGR5Ccn1LPB5SXWWx9agzL0MCiw3aXtk8jm
 FHxTydqu5IWqGoeinn4x6sInxu6EvD5BpXc7x3ftFOuI504JZLsS+bmPPK7JeHczLXWu mg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wamucx1ha-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Feb 2024 08:19:46 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41K8FQ2j013254;
	Tue, 20 Feb 2024 08:19:45 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2168.outbound.protection.outlook.com [104.47.73.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wak86vq76-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Feb 2024 08:19:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cjE+OLaJt6mYQoTYMoGJgy/RF6dD572tGHVzPlmx9tOLmbFCrPTms37SgoQlaby4XpXHaWvf6af0Uacxc0Rpi+CKkV7fHq8RQo050ODUU/4QAajC6C/+gh+E1y2fIOUmrbqo9a35GKU6gSo+6XJpxYIh4hmdp/vK8pxcgudFTN5YO1dvmubwIxHcYzKToNTfDUUSXBtR8vp+e5NVn7v7mZwV1QaXMHISAMJ5OdiniTg+eEUt5qk93pO6oaLdpg8PibdVrSsGGayDhaTZXUeEQOjGR02ahOn8hqC8aZ8wjAG5EawtRZwuQdMp0n3eWfv5h7E19xylp4q7GguPKx0rvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T6zJQu8ujok/GaJNC/5QUzR3oiy0YM/Y8T6jt59IfhU=;
 b=BNOY49G2D6PziVzCzRMabOApmoTPWoAnK5wH080acEbJcVZrD944Wr+RtLJROZ/giUz73hAymJQM8OA7vO6qS2wXlusHJhxLGzJNzCppSTr1BiT5hmGkQ6Z168A7SRD/4RRMfSncSvc1EQ6UvZcNsZpCruI9EWfqg08tr3r9wj5BfIyFbBOgBp7v51/Trwu4hJ5wAMku/MVCkzt3PoRClPLmXC2YX/W5WjrOhWbD7BuQ21SZ8kYshf1cC81GJVZR7Sy57BHQjpnnL2wS/c5XMLPoGaWgO6hUbeCn3y1eijUJOzL8KeaZTu5vdHKJtguBdjjABNb2228PWWizpi6IHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T6zJQu8ujok/GaJNC/5QUzR3oiy0YM/Y8T6jt59IfhU=;
 b=a/lOCN0mliN7CtTRX+gJ2F4S9osw0l8nLwZWx3MtiSS5EH7FDNXlagNMqHemEyy9tPQSJiiHD/vIatDw6Sujq2u4n8cTJv/nifFM5YjDK1rwanAyGALwn75ZB0Ed5W3afUihHWUX7MCddDGC9qGHOo+6jl3QDndJYiYIUIYLttw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH2PR10MB4391.namprd10.prod.outlook.com (2603:10b6:610:7d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.39; Tue, 20 Feb
 2024 08:19:43 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4%4]) with mapi id 15.20.7292.036; Tue, 20 Feb 2024
 08:19:42 +0000
Message-ID: <d27bc0d9-1a7f-4451-83ec-bf24df08f12e@oracle.com>
Date: Tue, 20 Feb 2024 08:19:37 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/11] nvme: Atomic write support
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>
Cc: axboe@kernel.dk, sagi@grimberg.me, jejb@linux.ibm.com,
        martin.petersen@oracle.com, djwong@kernel.org, viro@zeniv.linux.org.uk,
        brauner@kernel.org, dchinner@redhat.com, jack@suse.cz,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
        ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com,
        Alan Adamson <alan.adamson@oracle.com>
References: <20240219130109.341523-1-john.g.garry@oracle.com>
 <20240219130109.341523-11-john.g.garry@oracle.com>
 <ZdOqKr6Js_nlobh5@kbusch-mbp> <20240220065553.GB9289@lst.de>
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240220065553.GB9289@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0021.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::33) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH2PR10MB4391:EE_
X-MS-Office365-Filtering-Correlation-Id: 44ffc693-4d88-4334-d023-08dc31ecb0ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	uM0lkekj5pNWjf5lMT3P5G7huSjm5bArAoZIRvXsRvrsnTiveUU0MUAN9LCpgpyVO5KhcCTXoato05ljVzhjiypbQ7T9oq6ND3m1XWuEeQDqSboGPlrsWjJE2Izu2Hedn5Ej8N1uni6ZNOeF4uP+RI6cGiPO4wRDNJqWbbGtTy6HzgarQW72cPjW9hIbDhrfmx5jlW6zwE9DgDFDK0Q7eJxlGpQvWfZOLCcwEOTmxTcn6K1nLpzth0muhnNirWslD6kNt8bP1JEs4ClvYA80jLaOFUeZRuapEe6aeGGZ7GZSsKQ1DiXkEuqeYmDmhIDhHmU9E7OEO/K+loLg/u0ltGukM+WBdQZfhdsrZ6EimwHQsNKvS2eVtDpWOaZiDEzZBWcSxQciP1lZ/YAlAxPUvYHcdA5xwRy4NABGQngQVHbz2uSNPvH4aXq8NvBZhtAp0dE9LZgin50f2VbPgfGdd6QXJovsMyk95qgfDkQU/KNNpbeumATp0X7rm7BTtK+qm8ew5CRxVta/hJlxDWZnyEXL7W1f+eTsKjAg9OcVI4I=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MmRZT2c4QWRTVWtpS0toMVZpSnR2b3FlckI1K0YzV0x3dWJ4QWM5bEllUnB2?=
 =?utf-8?B?TEdDSnQ3c0V1MjdKL1BzaDEyYkdmV2QrMHpSMGMvdXh0Tjg4Um5aWVppMEY5?=
 =?utf-8?B?aXRKRkF2aWNzSExtQkRmU0F6YXpKYjlrTmc3c2JHQ2VvKzRkRFVnbXJDMENT?=
 =?utf-8?B?MTVxRlA0RnlibW5CYjlNY1hSUWhvd3NrclFqODZjbklMcWFvay8zei8rNmdC?=
 =?utf-8?B?ZFQrWDdoMVdya3RsNURYVUVaT0Y3TVFFb1NjTTVKQXp1d3I4N1lpN2dGTitv?=
 =?utf-8?B?cTZ5QmxXeE84MG9pdk0yeTh5RVlOaVgraTRLZG0rMElxL2Znc1l4UFdBU1Aw?=
 =?utf-8?B?SHVIY0lQWktpMFB0N2JyaURXQnhWSzF5Ry90Tk8wWGpkOHZXNDlleEFNbUxR?=
 =?utf-8?B?NTZ0eTVYSUpjOHV0Uisxalp3c0gyVlVvOUxvL2VHbHJwNjhPQnoyYUVjeEd4?=
 =?utf-8?B?WWNveFJzWU5zb2k4eFZIYkVhanpyeHR1UmRBNEo1Y1c1UHBxVHZNWG9oZGZG?=
 =?utf-8?B?ZUh6cmlGTkZlMWZmN1o1ZkswcTFQRXkvWVR2TzVHdEwraUZ3aW1jeHEvaEIz?=
 =?utf-8?B?M1Q1U1E4dSt4S25OUS9uT1N2WGlyV3dMZU1QV0EvUVg0NVdyTEc2MjV1OVhJ?=
 =?utf-8?B?T0l5MVFmWExrLy93ZmdOSFpHWERWUzFyMDhGZlg5NlJFcXpSZytpUDFjaHlm?=
 =?utf-8?B?M1BSZEdncG82alEycXl3MzFsQ09IUzNxZHdza21zaVNjeVA0SEdWaWdDU3FL?=
 =?utf-8?B?MkZBT3Z3MG1RTzJKMDB6RVRLMTNKaHFJRzc5cTJsaGdsbXpnU2dUMUFRckxT?=
 =?utf-8?B?SWxKTGRuUmhXdnhyNjgvOGRCL29MYm1ZU09ldnV2c1ZvZFJyMldDVDFUaXNn?=
 =?utf-8?B?S1BMdjVCWTJJWU1GRy9pTDJzUlg2ZXVvdERuQnQ5WjVXdFhaNnQ3NnRYcmgw?=
 =?utf-8?B?RjN2NlRHOEFtaUtVMUFPN3ArS0tOZnhYZ0Q1aVJGQU9OY3NFbGtoYU5vazZp?=
 =?utf-8?B?QnY0a005aE84YS94dytwUUJnbTczenFocjRPRVhuNFYyY0ZBSXorV3cvUTFJ?=
 =?utf-8?B?V1pSUkRYVFE2Q3czV0RKVHQyMnZFRVZacGZqOWxVTi9OZ0JoK3lFb1VUMWd0?=
 =?utf-8?B?eGNJNVRzb3NsVjRaV3piVFRNTTJ0ZU9GREEzcFAvSHVzdEMzMWFSbnBPNzJa?=
 =?utf-8?B?RXVVTlBvRDI2V1kzMkJiVG45cFN0d0VIQUUvdWo0WWtDZDlPZ01JeEh0Zkd3?=
 =?utf-8?B?ZmRnWHhzVUV4bVhnY2lIVEpKVFpCLytHL2xOMEhLc1FtV3VINlcvRzhQZDM5?=
 =?utf-8?B?MVZ4NnJYNHNkZmhaRlRsYTVSMmNTKytQVXJJY0JCQnpMaXUxREt1UlhCMnp5?=
 =?utf-8?B?UDFJajFxSDBKRUZqcmYvTk9qWmZRRk5xTXp0QzVFSzNHazZDZmM3NXVFVUV0?=
 =?utf-8?B?RDRtalRYdHE5M0ZzN2lMTkFzUkRTZXp5YkhWdjJWcEJxYzBwZTkxVlVKQ1Qw?=
 =?utf-8?B?YUxZRU5JdVJSM0FTd016akpkY3BKT2xVZW1IRGc2WmFGUnlwMXU4NGk3UVJK?=
 =?utf-8?B?aDRFUjgvMmg1THd2dEpMRDY4UjhIUHBkQmk0V0JhWDRuQUxjMUU0ZzVENVFq?=
 =?utf-8?B?WHN4V3BSUEpQZHR1TFJyank5amIrTk9FRDlSSHRidkdiaTE0UDc1Tkk4bS9I?=
 =?utf-8?B?T05ZRitaa1hKRTFPSDdBSVBDRytnc2tsRGthZ3RTNTlGRHpkcFgxQTJYbXpY?=
 =?utf-8?B?R2dzU05Bam5ILzhUbFh2L25IekU0bUhxT1J0SVhwNW0zbG1XUXVpSWJyYzBr?=
 =?utf-8?B?L3M2VnZ0eUwzcGZMdGJuaTVaZHFaVHZ1d1NXdXJWSkxLWXo3OUlJNmdEUE0w?=
 =?utf-8?B?YmZhTW4zZm15eDZUVG1NWEw0ZGhva3htWXJXRkdHZU9HaUE4NHc1Zmp3MGJ3?=
 =?utf-8?B?NWNBSmtZWXA4VkgwT2U4V2JNSnhpMWpOVDRBbVN0VUpnWjdlbmVKMlB3eS9u?=
 =?utf-8?B?VTd4UEJVQURRR3c1VjZBeGJDT0lhSUpIRXFMckZVcUFWU3hZaGpmWDl6TUR3?=
 =?utf-8?B?cytOWTdoZXVvOWdpcHAwU1NldmwrSXhKMldBVVQyMEF2Z1AzS0c5TUZYOC9s?=
 =?utf-8?B?Mzl1blVkR1ZjZ1BDR0FoZVVJeTd4Unl4K1BQOHkvWExKZjFOck9CWEkxUVc2?=
 =?utf-8?B?TFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	++DEM7JkGJ6npCN+QwHzh4om4PMErtnLSLG6K//qBXkYqW/zje1T8uhS0NzIC1Zg50rX1QQVLr/Ic7W36GPeyj4AaXLL2ZkI/jeje3iTUfVHuwcjiyF/mduBVNQFm08twlE4NSAyGfzHESdj9rm1h6oWpcygiUGccctBE4XFZiEPYD21L27+FKY+EoTL5r7xIysQAreXzqmraCH1zHP/UpeIUOCAW1Urb0aPILEO6FAne09shC+Mf2scxu5fLBloZr/WKDpm1CrtfJMIuq+0Zv5pabF4xocuSnNKhOqHn24y3Yll4Eh4/k9/L22YcEZ0aIQ9SeDZp2PQk0O/JuAQ8AIiaLpZZcbnwzrr4prKrUONr7J9KTq5cCJhlz1b9iM/EgKndmBta3j+TQvKKdK398DtEVkpodBiiiu5LwyhI+QZ+4kfyNMe6VLNSBzKd7C8EjoPl2b95Ll97CCMNylF66VHk2pHScHiKQrPWfJajro5t5CZSEAUXg7ym4+1GBPsk6DjdKLP9Kjh36aNmcG4c5rJdvcsgFHlnzUqy9XiD41s2t6to24EN2vFTPHIXXSnC/pFQROaqjw6QdCt3mKs+P/hqe5r14yTbeB86/lvXEw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44ffc693-4d88-4334-d023-08dc31ecb0ac
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 08:19:42.7810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z/LY2EQRQlz7eUo4fRpz2BgBzFNaEMiGHetTSRLTd5DXgm9DyyWmjVLbAo2ZJ5rpUkmCQ1qLLiw8t8yPr/p0mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4391
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-20_06,2024-02-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402200059
X-Proofpoint-GUID: WrQetJUHALk82U00GBw_Rr-E1eMpmCW-
X-Proofpoint-ORIG-GUID: WrQetJUHALk82U00GBw_Rr-E1eMpmCW-

On 20/02/2024 06:55, Christoph Hellwig wrote:
> On Mon, Feb 19, 2024 at 12:21:14PM -0700, Keith Busch wrote:
>> Maybe patch 11 should be folded into this one. No bigged, the series as
>> a whole looks good.
> 
> I did suggest just that last round already..
> 

I created the helper function and folded it in, but not the callsite. 
Not folding in the callsite change did not make sense to me, but that 
was my understanding of the request. Anyway, I can fold everything into 
this patch.

Thanks,
John

