Return-Path: <io-uring+bounces-2314-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93641911D0F
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 09:43:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B3CC282D9F
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 07:43:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1B8C16D4CD;
	Fri, 21 Jun 2024 07:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gse5B5fj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oBb54ui9"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0158616C695;
	Fri, 21 Jun 2024 07:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718955783; cv=fail; b=iSZCyzo4/shl/lPuWVICbX/6ob02Fr7IsB8Cdr5iGJ8VWw30pgO5wss1odFdhAOVvadtgNRaaJeXfxpgAuBZyK0t3Im8y//6PCeGexs8+oiST2kGbghdLY9SHA0wm5Yn+TRosSHBUIexRQooHwkwMvMeySlZJyYeuTl527e1n6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718955783; c=relaxed/simple;
	bh=UB/HFxeFRVIJFArJub1ABetMe+g16tUy24EwmdAaML8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kyBEPRayNfWl4LIYXuJ2dUMT7WABGso4Z7jtNoe+Di1XWU7AX+r1UcORYIJE7w4nn/a9mFNd0MC2Qxg3LC5J0nTRdOD331Y9s7gvDARyNCQ6htBbTBCCJ6JKRRQKj6zu4LJWKLpMrEuuNyKnKGgS4b+NtEeju/bFhk+lhY3GuEU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gse5B5fj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oBb54ui9; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45L7gQ5H013807;
	Fri, 21 Jun 2024 07:42:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=ymSwsf/qbxk77nGbNdEl2vPalyVQOeT5EqZmjyhSRI8=; b=
	gse5B5fj3mQrwA+r0UVk5JFA3S7DCKOEKan8Tas0NQa8DC5Pm7Z21O2+lHkN1tZa
	LQeGqlihjSBNtPyEEzoOO6mdIRHsbgVI+no+dyBEW+UrKBurKgJ6WtaY160SnqPa
	tj7WTVJpZQsy1V9XcSb8SkqzTY0Z58TZjOh6w7X+fwZgmbUfCZXdUYxnYuc9vlxq
	uVQCX9ru9+/oo43H8evqDQcXfuuhIe9lJ7FVMFdEC9w71FhnaO/7d1dfJhzoQhNo
	dJp7O50Nfwc4WEcEWgkTfegK98CkremC1GFxPuc5iv1ImGFo6XeIyphGc/lvY/oq
	fs7dpN+al9q/JkIMNGhrbA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yvrka16tf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Jun 2024 07:42:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45L6o50K023589;
	Fri, 21 Jun 2024 07:42:26 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yvrn89auw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Jun 2024 07:42:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k49OrNd/lOHjXoJsbhd7viNrXj+OtlPk6SVJHQ3gTNf+0HtkM4+7ToP9LQeWO707w9mqaqdni6vtAAUh7rOu4rurWIALRGQCj6yGDkprQ083OlfIwxsf7hBil5LrXWsYFQYJ08KZadHh0Oocv5HhYrTKjbqLpneIpA7H4HioP+TGy0zlz3E/wRORHICD/VoYE25o+fjXpCuhEvmR6+GkIBQiuSdIRlo6jBhDMZq8hYzfDuUw7XzJa2WnqB1/vEIOK4Mf9I+XPwt8oBAv648nXCG0k7zVmoUKyzIW01u7K9AcD+LtZh6dzNiqoJa85XzMev6iylpQyT0SXIv+kENOwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ymSwsf/qbxk77nGbNdEl2vPalyVQOeT5EqZmjyhSRI8=;
 b=g3x706N5PDfKfQFBaQkKEvNY/4/rfkYnEHfAeQNB5NgJwG3LOEowUcJcE6qgNSoLkCVf1E271N0mx0JD2msoZp0atVNv0FH3QLi0wX7mHgAIZsjVkMxeADw6oXY4LUinasFEcbZFw9yyIdH4j+FXaZB0PPaRg6Aok9d/v5nrLpqrKibqeiY2uYWABRBVUiqT1+PYC8XXZ4bDTgSQLSYVTf617APJ7fQdo58u4kpkxZXH8DAnaSLgV1lTLFsfDpKFPXvfEMGbw5EWJyWizqhBFcToRTC4XZLHoDUy6+AJTIpK3+hMw6Q0nU7UlvLiBI9tmFPjsVJtqpgFItNFgMZd7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ymSwsf/qbxk77nGbNdEl2vPalyVQOeT5EqZmjyhSRI8=;
 b=oBb54ui9QE/aU/Apla0DF4uiY4JkSEens1rwY9ZJ7ZlPJeGhb+jSWaQZ65Ad4yTIY1ONVPmaP6UnzLMqA41aD0cNLpmC0mO1442MZKASxdTBMudFLPFsRY/0CnlVv+ccfrM57FnGJsd9AZfhdtb/i48z62i0PZjLA5UURzys7qk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY8PR10MB7378.namprd10.prod.outlook.com (2603:10b6:930:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Fri, 21 Jun
 2024 07:42:06 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7698.020; Fri, 21 Jun 2024
 07:42:06 +0000
Message-ID: <1e821eb1-652e-43ce-b1c2-3990a43ed4ba@oracle.com>
Date: Fri, 21 Jun 2024 08:41:56 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v9 05/10] block: Add core atomic write support
To: Hannes Reinecke <hare@suse.de>, axboe@kernel.dk, kbusch@kernel.org,
        hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
        martin.petersen@oracle.com, viro@zeniv.linux.org.uk,
        brauner@kernel.org, dchinner@redhat.com, jack@suse.cz
Cc: djwong@kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org,
        agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
        dm-devel@lists.linux.dev,
        Himanshu Madhani <himanshu.madhani@oracle.com>
References: <20240620125359.2684798-1-john.g.garry@oracle.com>
 <20240620125359.2684798-6-john.g.garry@oracle.com>
 <222b6963-4728-4005-871f-40d761e133bd@suse.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <222b6963-4728-4005-871f-40d761e133bd@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0332.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::13) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY8PR10MB7378:EE_
X-MS-Office365-Filtering-Correlation-Id: 6404e180-cd57-492d-0a9d-08dc91c5a5f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230037|7416011|376011|1800799021|366013|921017;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?bFdCMzhLcnZNR0I5UW12Z3ZHb2JMTmE5b1lnWHhoa0JocndLYlBoQ2dyL0Ni?=
 =?utf-8?B?M3grclYzZm9rOExFaVRYMGV0NWRnTmdRRzB4WHBUL0xSdjI0b1k3QlFmZHFi?=
 =?utf-8?B?K25XS3lCV2J1eUpLOVV2MFh6b1NjTCtsa2JHdURzZko5dHY3cHE0TkU2OVAy?=
 =?utf-8?B?Zlhha0kxSGZwbjIzQ2lxOGROVSs0Z092cDhicUpzblA5SnpnbXVtU3lHclZv?=
 =?utf-8?B?d1FOOE1leUUwemdTb0VKM1FDTEdqNWpXWHJram80dzNKL0cveVd2Q3lmMzBm?=
 =?utf-8?B?WlJTekhiYkN4OWhKdUJGRTlkMnU1Sk02QnFoOVlCelZMQk9XTWFOTjM4WUJM?=
 =?utf-8?B?SkdWeXZXT3dHVDBBZjNEaXNneGlpSm1naDVmU09aL1BFSHlCbkQ3Q0NLNDFi?=
 =?utf-8?B?bmc1cnZCWTBMbjdrRGRwVlE2aUc2c2xJWGJSYkdOUGZsbVFNdDlhNzRnelF6?=
 =?utf-8?B?V2NWZmcrYTVJaER4NWlqU1BaMjBTbTFjZVRpTTBxVlRYc25rcjAyYk5XdTgr?=
 =?utf-8?B?amRoM243bTJzTG1ZcDNqWSs3WVpWUys4OThDSGFwSWJvNlhnNnhqbnVMRFBQ?=
 =?utf-8?B?UzF4M2YwM01YMXdianAvUHRZVnRSTGFuS1NuWmpRZ2tpY0dDZHowQi9IK2JJ?=
 =?utf-8?B?TXpFY3FjUTlEdk9yK3FkdWtpMy9BZnNmM2c5eVZaWUhsQ2N0QmlnTk54YzZE?=
 =?utf-8?B?TXhHTmIrSkM0STRtUnVtUGI2THRma1V3VzJnUUNGQ1VjYjRISjhnNXNKRmlj?=
 =?utf-8?B?Yzh6RnhBSlFqUVh6MEF5TlcwRjlCdU5uNG9wcmRnRzk1QVFsSHBFNEszQkpn?=
 =?utf-8?B?dzhINkhMSmJ6RW14T3hEU2djdmtSQ3FoQ2owb3JUUXFnWVMyTWw0ZzNDTHdr?=
 =?utf-8?B?YUp4QUVXdjd1TCt4OHZiZ3NJZGEvREtDaEpUQXlxT3RSMUtFSXdISDgweGVF?=
 =?utf-8?B?bEREdmhMTmRHeWFYTHk1cFA1THBrVWwxZGlCRldrYmdhd01mcTFvRHpaRGJ4?=
 =?utf-8?B?ZHpOeGExNWNacWlPSEp5ZHFtZ2h0NlBBZi8yNXdpQ2JMRkNWZHJKSGlQL25r?=
 =?utf-8?B?S2gyTFNudzNCdTdaeWxINEN3WWlvdGovZkFsd2FjRzhJVTBDRy96dTR5bS9i?=
 =?utf-8?B?NG9WR3Jmd0F2TEpWblA5ZzIraWhDNXVhRE9YUnQya2ZtejNUMGprSEdFS3VS?=
 =?utf-8?B?eVVia2lmaVMwVnRmcFljRS9kUGJSUjhMNkE5eUNONndjelBBdGFERk9GWjhZ?=
 =?utf-8?B?azJaZnpFK3lLZytzL1NFdWZIaXRDaldRZ2h2RUdXN3pjTmpBbFVuQm53S2JG?=
 =?utf-8?B?L1NMYXMxVENZaHpVTW9vTnd2WUlzSkhQM09kanJrOThKMmxSV0lUZXhlQ2U4?=
 =?utf-8?B?djRlc2E2U1d6WXk1ODdYSFRFUzRjVXZ2VFQxbU9kUDB0RVdJQlY3aFh6Sklr?=
 =?utf-8?B?c3p1ZENkUkNib0MyTzgzRzJ6SkR3LzB5UGpKQ0dXNk8rTDRGaWFBeWsreWtE?=
 =?utf-8?B?dkE0MG5OOW1YRVV4VWZ0cTVyYWV6cjlMM0pxa003dWI4SnJXVkhER1FxMzhn?=
 =?utf-8?B?T1NOejBpeEp6WXpxNXdlSjN6bXFNZHZacG1BMFJvY1lZLzlwNmdrM0xtS1Zh?=
 =?utf-8?B?Vks4TGs5SHRrak42dURJS2RtcDhPUVR1eXhNendIUGlUcHYyaVE3bXJmeGV1?=
 =?utf-8?B?Zi9pRlhDK3l4aGExcllDK0QyNVorVTFKdU1SQ2xoNlFLTCtDc000N3pRelFF?=
 =?utf-8?B?SEpTa3VkL0JqVTdpTzZNeWZ1cC9Nc0tvdU9xWGRjTmtubi9ESUVpUnVIM0Z0?=
 =?utf-8?Q?bmFh0Z6Dk+2rAakxb9dmFaQ/6c3IhZ9/GyOXo=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(376011)(1800799021)(366013)(921017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RXNwSEdTTzQwR0NYeERLV0g1YUg3ZTdLQVZFbW1lckQ4RUhUa2cwWUtYbjAx?=
 =?utf-8?B?NWdYUGNLSlUza29RMG9hK0pYdENEZ254RkJGSmdHY25wTy9mY3UwZVZnemZz?=
 =?utf-8?B?akt1QkltNkpUNmE1OUZ2bUxRdmhWU0lRcnBYNkpIQzlTR09ITUo3NjUyM0Fn?=
 =?utf-8?B?dEJ0WWRFVm4yY3huK3RFQlQrWTZ1NVh2L28wTzFVNGt3TVIxZzRNbm44WHBU?=
 =?utf-8?B?VC9NVE5sTHRReFV4dVJiOVMzaHN0cUc0L0ZqQ0JSbzZTeGgzYS9yUXgzZ2hC?=
 =?utf-8?B?ZktZVEJ1eXdFaytBQ0hqalpWRzY3c3N1dDV0dmZER2cyS0xEbHpaRDBrNGRw?=
 =?utf-8?B?VjhHNWI2MGZHT2ZoSzhIakVndGZWMDIrV2tJQWM1dE5DQm1CS1N2alFVNlZz?=
 =?utf-8?B?RkE4YlJ4VGhQNVB1N3lZTUtjTUd3SG8wMmRwcGFVNWZNZ2ZqU3RtRVowUWJx?=
 =?utf-8?B?K0NIamFsVTZkcm9Kd0JRUFhFU2RPbG01RWhOMzZ4K0xUR1pQYjJjZ2FmSW1X?=
 =?utf-8?B?V1NWaFN2cEpjTDFORVVzWVl4eC96MzlZbjZSeVR1WEJOQlVUZkdTdzlGQ0xr?=
 =?utf-8?B?Q3dRWnZ5Y3VEVGJJY2RPU1c4NHdSck91YzcwN0xoeXhYWUxDME94ekZzN2Ra?=
 =?utf-8?B?dy90NHhsTG9NRWY0a2hOY1dMb3ZmUnZFbU1MWm9McTJ5Q0xmMjhnWWxWd05p?=
 =?utf-8?B?elZuYjE0NmthbFMxTUx0dG1NbU9lRElrLy82bGRuaVB1UWR5d25QMmVrTzlI?=
 =?utf-8?B?SFZNeUh5QUtqZVlpREp3bXpIbFhUWXpGdlhIaWNRaldGL0RDRzBMcEgyUEVV?=
 =?utf-8?B?dWk5MWV1Z3pZa0tYdVhvN1UvSFltbzFDbHNGYlZPRlNweEhpZmk3Z0ZxYnRL?=
 =?utf-8?B?MzAvanppNkhtVVhyek9kbXZFYWJLbW5ML0NPYXFXams0WFVsejBEbkFiUDBo?=
 =?utf-8?B?dXJCcXFlNUhHbWM0Qkk1aElYOGloU01hVVRZU0h4UXRmeUQ1enVMck4zZGgx?=
 =?utf-8?B?MjZuSC8xamUzdXJiWDI3SnJmK2FyNU1XcW9NOExZd29kV1RLeEdoZUlPM3Nv?=
 =?utf-8?B?NW9zYW0vd3U2TERZNUphQS90L1IwVUJnc3cybXA0cm5OV1YzVnVaRENlYWwr?=
 =?utf-8?B?WENZS3BrdDBZeExpVy9NMGo1bkFKR3NhZVYrMERWbUs4QXE0bHRmSlkzTVhK?=
 =?utf-8?B?YmdLQ0J6QVFON1A1N0lLZk5hbURDVkpjWlhuTStNTU9oUm1lMmxKeVU5b3Ni?=
 =?utf-8?B?WWE3cVgxbkYrT0daK21iQ3E4bmF4YXFnN0w3T3AzWGQwc0pSa0NLaG9NU0V3?=
 =?utf-8?B?c0t1Z3Q4VEtyVkZlNTVZMS9RYVQ0MjUrSGxPbms1VnRWWnRUd1Y0WWtScUF4?=
 =?utf-8?B?NTNEVzA1T3FTRVdDY2VNeXlXMGs1K1J0dHFxNUUzTmd3cFJkTUpRb3hTZ2Jk?=
 =?utf-8?B?cU00d3ZZZTI0KzlPMlRwZGZvbi91M1RtM2tBK1dOV1ZXTXp0UTJSMGRmM01H?=
 =?utf-8?B?Z2FjZE42ZTBGdGUxTmhTWHVieW9iYlJpMExEd1loZTJ4Unl6OSs2R2lyUnAz?=
 =?utf-8?B?NEZuOWE5SU53VUlzZGFURE0zdjVyTml5eTR4OXZFSGt1dE0yam9zQmtYY2lU?=
 =?utf-8?B?ZGt6dnJtcmNSU1BKdngrYStvdXZvNDdZVk1IckowZDdneWwxcWdiRm8yQ20v?=
 =?utf-8?B?T0JOSlg4NHVrazZOVS9DZVdJRHo4T2xxVHJQZllSaUgrYU9BVE00V0FsNVRQ?=
 =?utf-8?B?QnllYVdBZVNpMm53NEdqelkxTGNiR2l2dTNLRWNYU2R5TExEbmh5Y2d3bXZW?=
 =?utf-8?B?YjA2bGoyMTIvbkswK3FsTENlUUZpS3UzY3BuMUxVbTdyeVlpZ1hFMTVaVnBF?=
 =?utf-8?B?dWkvYXJ6U2laMEJrSmZLWlFZS3lsbExQMmlTL0NmSFlHZERVRjgvRUQzb3pR?=
 =?utf-8?B?R1ZYMXNkZzcxWm9kTUZCUzF5QUl2cUpLTS9TQXlXb0VQQ2VIYU94M3Q4WTdR?=
 =?utf-8?B?SzdhU1h2Yk1kWkhtUkcwaFZuN1Q2V0IrWlRIYU5XaTkwVWRCQ3Rqa1ppbWtw?=
 =?utf-8?B?RUhCN25ZOHpxVjlpcUY2ZFBOdFV6VEZudTA2ZXdOR0VGSGVvNEd3dS9zZ2N3?=
 =?utf-8?B?dnZFa0o5dVprSlFQRktEWm8rNE5BNmNMdTgrSENlUkxFajc5cnZDUGxVWXFu?=
 =?utf-8?B?SHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	DDeCF/nvm08K+mKHPVRRBmlcGvfj5RN0jDA+MMUGLiJnfYwPiRNM0ZX2VW6bTaFdoU68rWykB91yx5OS2EJXJG1W8ZGS+AwpUV94vwvUP9lqXPdjM7PWil85qH9LoGM7OOdvUEC5E2cGnNjwZfLh3TiK1+VtXNsAx+1bndhhsgqI/73WxAfEzYl0Ut2lN1IlNQ76/MDVv0iMCtft8+ObLNezYyVRflH/PDIQF+9LDxQW2jlXhpFnXbL4P/Hcwqlx1fPTiIKzmJxO/iV8Wd21/2WDQMh0DP1UfqrK/Pen8CuvTBPvvNGXOk2AyC3Y7oUBb++P/K9rrmpMugo9deDTtOgLQESEp/B6sRD8Jv+PMjUAFcmq3J9N5FzqzvaWQXer3vz5zUB72jGZP75jRAjJjfi9NUuv8cQYbOs9iyyT5MVFtTVh69CIDlx+N1pPY57QHt6V4y/K0Eh6GsZgZTeD/h5aKstaNQr6I6TWPxmTqEQm8F8DkoxFJBlrgL+Iep/yQHOv4TeBvmJANEJ9NrAjGwF2ytInqtOJHKAVAn7hC1cG7zHfX1pL8NjBtv3gns9Mxx0k6B/f5fGmlIBopqtkfZ1eQYcINycAcDUlyjNMyFE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6404e180-cd57-492d-0a9d-08dc91c5a5f1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 07:42:06.0392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U+fSWwwS/RU1sLldpRZfxunSQfyS8lHXIYFgoARR9WJNb5waCcFzsb2ptZGSVtaQtWRDXDdGeN3WhYq/Ax5NSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7378
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-21_02,2024-06-20_04,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2406210056
X-Proofpoint-GUID: 6_oadOnrqEtCZ_siN-ccFI-rLfXOkwlB
X-Proofpoint-ORIG-GUID: 6_oadOnrqEtCZ_siN-ccFI-rLfXOkwlB

On 21/06/2024 07:09, Hannes Reinecke wrote:
> On 6/20/24 14:53, John Garry wrote:
> [ .. ]
>> +/*
>> + * Returns max guaranteed bytes which we can fit in a bio.
>> + *
>> + * We request that an atomic_write is ITER_UBUF iov_iter (so a single 
>> vector),
>> + * so we assume that we can fit in at least PAGE_SIZE in a segment, 
>> apart from
>> + * the first and last segments.
>> + */
>> +static
>> +unsigned int blk_queue_max_guaranteed_bio(struct queue_limits *lim)
>> +{
>> +    unsigned int max_segments = min(BIO_MAX_VECS, lim->max_segments);
>> +    unsigned int length;
>> +
>> +    length = min(max_segments, 2) * lim->logical_block_size;
>> +    if (max_segments > 2)
>> +        length += (max_segments - 2) * PAGE_SIZE;
>> +
>> +    return length;
>> +}
>> +
> Now you got me confused.
> 
> Why is the length of an atomic write two times the logical block size?

It's not just that.

> And even if it does, shouldn't an atomic write be aligned to the logical 
> block size, so why would you need to add two additional PAGE_SIZE worth
> of length?
> And even if _that_ would be okay, why PAGE_SIZE? We're trying really 
> hard to get away from implicit PAGE_SIZE assumptions when doing I/O ...
> 

We need to know what is the maximum size which we can guarantee not to 
need to split. And we work on basis of worst case scenario, i.e. least 
efficient packing of data into iovec[]. However we require a UBUF iter 
and that iter will be aligned to LBS, that would mean that first and 
last segment would be at least logical block size and middle segments 
would be at least PAGE_SIZE.

Thanks,
John


