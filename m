Return-Path: <io-uring+bounces-654-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E48D85B4AD
	for <lists+io-uring@lfdr.de>; Tue, 20 Feb 2024 09:14:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 16180B20CC4
	for <lists+io-uring@lfdr.de>; Tue, 20 Feb 2024 08:14:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBB155C5F9;
	Tue, 20 Feb 2024 08:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="itZPB41x";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RxV7VhKZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD10F5C8E1;
	Tue, 20 Feb 2024 08:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708416883; cv=fail; b=GbgxA+SvIgG7CMxI/6NmanZXL9KHGxW0EB7IfhF0kbPxdjb49O3aNNPof9xDNWW6tUcjDIwjbe5cc5pFcgpqAs1eU3LhFq4c8FXbxCyH607mN9egqm2RftHCRMcXGkRCrzMUk0tUqzsnTpc1kcU3gVJmRf2wlPyFUIO58iP4+hE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708416883; c=relaxed/simple;
	bh=6TYt4XWKVEFpFOqT8bEc3ma1YCKhPpzv7Qpqec+LdX4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YdC18xHpu4Iz4TewlXOejh+zeHZOLc4Ce1Br/ZA/+411biSUPTy58mqqKJp6dF6/FBfR1lXGblrmv1AxqG9ip4in6TFRNZIM8BoQaaDoIGm+DIZjpksPdmouNhEMzAphJX5wEXiuuEQHS+uwxY37OaEiJYnNnmvdCccLt98vJJw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=itZPB41x; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RxV7VhKZ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41K7dRNs010850;
	Tue, 20 Feb 2024 08:14:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=g3qLshKIssI3U9aIJjoynWS6RImN5PmOcTe89FPL7DI=;
 b=itZPB41xn3Q/LySmFK09tOOTwAQsFmcDHwC5U+iUxudeXv7KLmsViUC87H9uiUc8E7XI
 i93uJATn213MMefr5/7ucq42+WeR2lmSjCkzyrtZYD6gruwrfdSXKFM0yosmr/VuABfS
 TSLO1umBRkOnAgX89qvdMvlDWIijnHHuQD/I975RaOhwiyRMPQ0bBaDK4Mi4OTY0kF3M
 DNGZQXyTnLmZAVlSGTJB3F7jRrvQCSX3r8ReCf3eXsBy9+UntSpyKllu8Ja/CG076vzl
 BKKcpsx0K/rUdlZ3ivPgvBgOzJG99xIWb+A5fcFRtP+G6vrEocpKlIoVoAO1TFpya7ka eg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wampawxkd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Feb 2024 08:14:10 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41K6tuWk021006;
	Tue, 20 Feb 2024 08:14:10 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2169.outbound.protection.outlook.com [104.47.73.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wak8732cr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Feb 2024 08:14:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nq9co4D8Q+KLy+6MKFJhd+qSpBJNeSAmjeqB8AKMrg+d9qZq1SRbYa6vu5be3WLj9YXT+puS756jz6lfSE5Re2Zwij0n3ITrWUmBEboG5ALOFpy77SnW09hy3Mzq9bbRcBK1Y30iqFO6h/EdUNoq1QjfWN0cYmimNDcOgb0+g5iNXDzDIDcsFk61HzoRzSbP73QXGHq98JcNx2OtdU+BITYBtNSbxEbir7EnEbkwtbyaKwfkoHU98jmppeQu2vrTgiQpKzEzSncVVgtS0Sx9udS2tKmQ3Ct+Iu9o+nu+uCo6Qo14VMGOXjfwVhZBsxQhKlNGVskSnQCu7wh1OZiiAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g3qLshKIssI3U9aIJjoynWS6RImN5PmOcTe89FPL7DI=;
 b=RBoKf8OQiBwxG/hlByGjkxWm6cvrNFICcnLtg386aCQFS4cNk0VgxptFGB+nxOrbNW1YDQn3DT3qHKfsB1lNaV/SvVXKm366Zq8thDoopZGCfZXIH9hMg/sSAuY91Oe7R45+yg9Qi2SkUM5qSod/rQP6iOJgyV01Mc/13Uqxzofv+sNSrJj1LH3VCGFVpJQaHiELlOckq6kjOXaxFqbr9TYxhcOgceBURLBtYZnd5OvUGxLNrXFS/A41HsyZJ1fcoHavlGWFVRmelLBg0XWQPYihh2iYyFQWZEuCvpLF28laddyvOoMFoZ8XdD0tvFGIKts1LsQlMcpHRD165qwK9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g3qLshKIssI3U9aIJjoynWS6RImN5PmOcTe89FPL7DI=;
 b=RxV7VhKZvZjwfaLPGHzb0m1UaxgGTwWv9Po06DugH6v65lndNJIRzIB+wnPf1BZXsyCIhD/Ykz40N1DaVGUwyHeRR5kC6pfV88wkc/TER8bVfG2c2o/gFYqL+W9e1GWhRB8+pg+KcPlOZYA6KZ0h9aj3zCLFl3p1H8XLp8wFTQo=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH2PR10MB4391.namprd10.prod.outlook.com (2603:10b6:610:7d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.39; Tue, 20 Feb
 2024 08:14:05 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4%4]) with mapi id 15.20.7292.036; Tue, 20 Feb 2024
 08:14:05 +0000
Message-ID: <de554783-f9da-4fc5-aaa5-6fde74c1c728@oracle.com>
Date: Tue, 20 Feb 2024 08:13:59 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/11] fs: Initial atomic write support
To: dsterba@suse.cz
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com,
        Prasad Singamsetty <prasad.singamsetty@oracle.com>
References: <20240219130109.341523-1-john.g.garry@oracle.com>
 <20240219130109.341523-4-john.g.garry@oracle.com>
 <20240219191634.GY355@twin.jikos.cz>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240219191634.GY355@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0318.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::18) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH2PR10MB4391:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b586e4c-12ff-4e05-a441-08dc31ebe774
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	bcwoqS/Vg8qTmO++SJ/lEd8rpkmgYLtudDFifclLFudWXL1ptM8VR/JIRsFEdtxBifDmUeLirJen4OWQUBbhTDQ93jaOb+EmnDEA5vhoU8t4msj7ZvH3j/Fz2IhZayqDz7f0YkiZhsHaoSwhn536+ptQYskQNqzbAwschecZnT/bUC56MshLKjJoaV+S6jCj9BhJzcR/dxU2qvEItNaVs3PgN1eDsYa5GAdnsol+1Dm7WrTo1f6AhGoWrnf8DhUoNk9a03QXbEGpTgpbqzh0Xc0XHO3T1Kjx14QBFrS50LE9oKVL8t+IYlHGKA5Wh0yDVoZbxeNhpOEq15dvncbqcZg02w4KVXeD3Lz7wP8lFBXtis4HGK1NnYjwmXeXn+9ZoUgww7wywynXXU4+akoE3bct8UF9gcESM081sPByKAbzXfw7UjZttOsGYYPCV1bra8onwjljPYhaDRwIwUgWNW3WuO8le0f6ZNES3vMwVfQUYaQdZLDRi/sfTMSKXMXDiA2Kkr4qdf5pwH7wKkqVurKUNha7mT6sHzcV8+Pt+Jw=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MmFrT0t4TDNKZ21uTFlOL0g0K29ibS82cFNQejdpb1lNVTd2SkRFQXBneW9s?=
 =?utf-8?B?SmFmVFlyRGxjdWJtWDd5MW8rOXZmMUFMMXlnYXJMODRrTlE5N1dNb2lHVnRE?=
 =?utf-8?B?bmhxZ2ZXY3lpL3REdUx0SW5vQnB6NHo1RVZIZXRSVC92eE4rQnJPaUNOOVps?=
 =?utf-8?B?bXJZUXViVEV6K0VJMFgzRFNhVjMydnVOa25JOTA0bVBPdFhqdnZYZkhpdjB3?=
 =?utf-8?B?QXBUYmJoZzFacGp1d3g2UmNoWnBJSUs4QStBVVBmUFFQdzg1T0c5aFZQRFpV?=
 =?utf-8?B?eVZxM0NkSjk2NUVhWFhiQVJnMDJjNmE1V01WNzVNbWJFbHk0ZkF2YXJEMWhO?=
 =?utf-8?B?c1QyQTRQc00zc29IUVZyaEVLejJ0UE45ZlovQjhZK1BWcC9JSkFhdTJMUFJO?=
 =?utf-8?B?dkdxUFZCQjJFZ2NjQXE3ZWdua3ltMDBvL1hTMTEyOUYxN21IcDhUME90WTU4?=
 =?utf-8?B?QVBJcmdqaUhKc3JrZUJqUG9MOHFYMklmSGg4WGxRY3FreEVEd1p2VEJVenRn?=
 =?utf-8?B?aTdxN3QyNmpjcFowcEVqWGNRbm9KaEhscEdOblBHOXpMWVVacTdFZVVXK1lM?=
 =?utf-8?B?NENFd3RaU1ljUlZWQ09yWTRlNjR3cnY3RmpNK1R2UkpCdWlzYVQ5SE05RVNu?=
 =?utf-8?B?T1lkZUoyRGN4NXB3dXFjeExoWUJZWVhjNUJVblBwRU1EUk5tTVJuQ0JsK2hD?=
 =?utf-8?B?MkVRR1hNQ0xlWHZmUnZwNFhQdVNLbWVPSVRiT3krVmZoUmMvb3IzQlpDb0NB?=
 =?utf-8?B?aERZRlN3NHZCUVNjMlFHaGwvYUZyOWd5VGRHTkFxSVFXSDZvUzhua2ZsaE5x?=
 =?utf-8?B?MzNLSE02UXhVNnhGLy9kd2MrMkd0SThrdTVZcjFFc2ZzaUFGZHVtUDIxSjV4?=
 =?utf-8?B?Sk1vaERUM1lCNlJQS0NVMmU2MTVCRk1PTHA0SXdQb1puekp0ZFNqL21US2gx?=
 =?utf-8?B?dkdERmV0SHQweXpKQlBLOVY3ZE9LZmdCUkk2UDF2M1BmTHhXdG9IeUd6M2RY?=
 =?utf-8?B?RSswRjFCOGx5MHYyZXhacjB4RUJidW9hUDNJSCtLZ0t5OExObzR4OHNXSmFM?=
 =?utf-8?B?L3Vnc0t3TGtGMStIQ0dQcFhqSFJKVTlna21zU05NeDF0c3Z6L0k2V21hMll1?=
 =?utf-8?B?YkprMnllTUM0blBGMWR4NWo1TVhJTHZicVVKOWVVd3FCbkRXZHh4YlZiL2Ri?=
 =?utf-8?B?Z3R0eTNjcVAycTZHOStoY1djTGNyd0tyKzVDYURieEZtcGw2SjdLeWRYZDdB?=
 =?utf-8?B?akhzNWYxQ1Rrc1dEZkFqaXc0bm9jV1FWaGZtK0o0WVJQR3R6blVHTnpTbExV?=
 =?utf-8?B?MzFhemxLQTV2UGhmbU9iSjY4UkxGYlFlYi9oM0V6TEU3SUt5YXRJZm9YeTYw?=
 =?utf-8?B?Rk9OT3VCSVp4UENMcnUxeHhEUnRFZUZLZkJuNHF3c0V2cSt0SlVGQWFNbHZ1?=
 =?utf-8?B?NW9kdS9uVjhHamUwWXBZUXY1VVptWlhMQ2cxZ2NXbEdlcjFYNHgrSVpPZmdP?=
 =?utf-8?B?VGdVUXZyU202LzNnNlUxZXFqQUpBYm5BaU1renMzZnEvbTBBWmJtdmlFNkh3?=
 =?utf-8?B?cWdZVUE1bnQyTGwxVlFROEFQQVZ2RkYzb1VtSFRtYXdvSE5IQ2tmYUYvanM4?=
 =?utf-8?B?UjlCTERIMThLK3FNNjdOVG9TSnV2Ym1IWVIvVzRCZkxJVVY3dlhrWFZiT1pi?=
 =?utf-8?B?NTFVd3Bia0R6aUJEdXAzbVBTZW9IVTBUMm9tdll4NWh0T0VvRUttcU45OTQ3?=
 =?utf-8?B?TzJYU2xIZUVHT29TaGJSTGVmdStRaEFYWktjU3pZV0gvckM5SDVkZWt6TTA1?=
 =?utf-8?B?dTFzenlyUGNRTlRXUEQ5clF6eUsyS0lSd1R6b2xwR1VmLzZ6c1hNVnZ2QWlt?=
 =?utf-8?B?M3ZUZWUvVEhGcmprS3gxaVAyeEdLdlU3alF0b0diM2d5MHpvTmcrS3gxV0cy?=
 =?utf-8?B?Z2xHbTZLZ2QxRXdoRllTUEhnTmxLYkpQa1J5Qkc2eXZRTmd0V0J2aE9VQVJa?=
 =?utf-8?B?TFlMZjA5Qk15MWlTdStIck4xcktScEk5Q0FTU3lXOVlhSlltd0tqTFNEaWMx?=
 =?utf-8?B?TEtPS0VBUit5VG5WOUhyQ2Z2dDg4enpyZDFoN2M5bksvL2ZpUmZZaGN1N051?=
 =?utf-8?B?SDVFczlxM1F5VkNWNlJ4MTVuaFFzeFp2Z2hMTGNXZWZydEI1UVhUWjNIYVFO?=
 =?utf-8?B?RlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	PdtfroX0xnD3p3rcSoC9BAxLCOfC3nTs/PnAiYDmaLSBBYTiW+clYXBTLdAQQLCtmwNjx+Fxk6/PukKkGiTdV4cmaKupoF9R8lcTqKjIoIKmdQ97qDTMhpz77nq5NaTl2DxKkps7Sq9IV50XMMRz4j5KbLzr1/vfq26YAIIyho11pI0wyiVlulRBc82pg81LzEhROv4mmVisZGa9f++wHLy4IlNQyOw8IcALrXiet+28XYmhCI/fctYyR/QQrr1fl38rpr41TnpFy2q9ASqDQ+MEyBIT07zQF2TY3333+fI0/0g/jP5hyub9wn7enMaWjdOsmFZtr7cjO9UCqRpmJa0KeoATNn5gEJbLqUqIMy2DjRPbuYBtXYmHOhdeZRILrG8/d/SvVuC0z0GdizWuOEZZ8X/RYDPp5UaGnu39T/wlBBLKV8Q18wr37Sg7mHUk42gEXb9ZPtJNVLXp20Vc7KbxOg7P0oLlCCyCgj2IGXNyQ2piMkgJlZ1h2xg8bgLYAd8CHXomZ/DtTPt6K2l7zE6mhVLrZ7jtFNPQXOtOlMLxJJbz2ZkfyNxxHUSZVqEKs4thyQakyEE2Rep07iIT+M479/GiFR9/6FFuei09Xc8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b586e4c-12ff-4e05-a441-08dc31ebe774
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 08:14:05.2703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EGLtLwmXy+k8xzdq6BqpgeeO3uhCoaNaGO2FQNx78upXMIh/zGBmg4QLcygCHoFLwo0Ekz9vEuZMoqvaoRkIuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4391
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-20_06,2024-02-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402200058
X-Proofpoint-GUID: FnTaSnPjP2TPx9dYhN_nBgE0j6MZzcRA
X-Proofpoint-ORIG-GUID: FnTaSnPjP2TPx9dYhN_nBgE0j6MZzcRA

On 19/02/2024 19:16, David Sterba wrote:
> On Mon, Feb 19, 2024 at 01:01:01PM +0000, John Garry wrote:
>> From: Prasad Singamsetty<prasad.singamsetty@oracle.com>
>> --- a/include/uapi/linux/fs.h
>> +++ b/include/uapi/linux/fs.h
>> @@ -301,9 +301,12 @@ typedef int __bitwise __kernel_rwf_t;
>>   /* per-IO O_APPEND */
>>   #define RWF_APPEND	((__force __kernel_rwf_t)0x00000010)
>>   
>> +/* Atomic Write */
>> +#define RWF_ATOMIC	((__force __kernel_rwf_t)0x00000040)
> Should this be 0x20 so it's the next bit after RWF_APPEND?

Support for new flag RWF_NOAPPEND - which has value 0x20 - has been 
picked up on the vfs tree for 6.9 .

I had been just basing my series on Linus' release so far while also 
trying to anticipate any merge issue.

Thanks,
John

