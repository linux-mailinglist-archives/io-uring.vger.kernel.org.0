Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A2B6960D3
	for <lists+io-uring@lfdr.de>; Tue, 14 Feb 2023 11:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbjBNKeE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Feb 2023 05:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbjBNKeC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Feb 2023 05:34:02 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3048125978;
        Tue, 14 Feb 2023 02:33:52 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31EAO1qe030270;
        Tue, 14 Feb 2023 10:33:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=tyI5EL2sAtCE0UPmWkfZUWZXRPd+0p7K//yG5LSyn6Q=;
 b=y05vtjSFKqdOINKFGJMQZbW1YzfMK4JSuh13ombXSR3uY5POIcjO8FDmOn6eBmRLhZfW
 iA7CXnUtAhlqXj7rPFn1p3Ek6ojgRsUqsHvmb/wlKCN0Rab6owN2bCmfwcve45cCyHXw
 r/acQqjQpgDGSTEYtQyKIn9op03MH0FJdWZWwgGhFd4+jrFLZ0Jud8dkDfXaJEQuuiFw
 SmPLYGf+tLcoRX0GOZg/CuzURC1/aUC8/hVXoV+nHcILjtf4pPHQM1iPSQCmh3QYA1JT
 0swZB7QErgQFrSCekjez3BwKV9eRxzRH+KswwXaIDbHrkRyu2rc7dgKooOBxMN7sd0pI qg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np2mtd12b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Feb 2023 10:33:30 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31E88G2Y028887;
        Tue, 14 Feb 2023 10:33:29 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f5318q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Feb 2023 10:33:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dZQw5DSkUq7Ng0Ezoi8heFiCVGrhUpgyYn8+S+TRAPoC8CJeQVLplpIY05Ox2lEHYXN3lrTCkP1NXxaZOX91OXbCnCjxym9cWc9fSBAO+dXC8CpMIs7rJCwHQY8RajO3qRVWTPf5xWWVlxCDrgEANLGQYDIboWGP2/bT4Rdx5uCsM10xVJ+xWqm34APTqIXlk2+8VcNthEDwN/xfaioBIw+8r0PBHv1WrbfDG9Q74eCW7kaZti0a4CwRk1tfSZLuLfvwS4qsfqWB+koCPlosLvihd9EUSQGFXG1ykrl7HsGXdfpWWfrFcp02QQYyPPxTIjgnN4NMP7um6ic++wUdBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tyI5EL2sAtCE0UPmWkfZUWZXRPd+0p7K//yG5LSyn6Q=;
 b=lcxr/97HVAGmPWiaA060vapHEYqJ+kow6IviciTElXWMjfGow5Au2J8Zuk1w2B/AIRma5vu3C08EZAALcuHEccZq/8cRlZoTjsgtHahaeEQTrLzCcDZvJzbK35qXHOhvkjdXSiKFQxdQDOYs+7A6WHqImKzCwLzv/1OCB/rF7RGYFhfFq8TwdxjpJ89ocBcHHx61VvtgyPSIvXQ3d9Xa/JczZFS9QHn1RExfRZ/lF7jmK4nlFVlVxk2RAlDFcobIyDpGYRSgJP35dVlPWJGdpJXn5pw2fHvFviL4zbsXOU65y96tj0ZJn31p3ZN1L7aPHNYTfTp7yZmhG2ac4+FbbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tyI5EL2sAtCE0UPmWkfZUWZXRPd+0p7K//yG5LSyn6Q=;
 b=fHAHOaBJu1hWGsoGc5hYP27T0IvA28xRH8LG6k6KN/fvDhmkDXIizzTStP92TyIkeA2ojkuKhtCNqY44SCVI7jA3hFO4w/ZPphTERPBedtDGRmx1CK5lQq2iovKYGlhh23hUF2HI6FGWMHcZSBFW64cQc2Gjm179hq6a2hFNxxM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH8PR10MB6575.namprd10.prod.outlook.com (2603:10b6:510:225::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10; Tue, 14 Feb
 2023 10:33:27 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::fff7:981:3ae6:92eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::fff7:981:3ae6:92eb%5]) with mapi id 15.20.6111.008; Tue, 14 Feb 2023
 10:33:27 +0000
Message-ID: <17020c10-9f2d-29f0-15b6-2c07cf422407@oracle.com>
Date:   Tue, 14 Feb 2023 10:33:21 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [LSF/MM/BPF ATTEND][LSF/MM/BPF Topic] Non-block IO
To:     Bart Van Assche <bvanassche@acm.org>,
        Kanchan Joshi <joshi.k@samsung.com>,
        lsf-pc@lists.linux-foundation.org
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        io-uring@vger.kernel.org, axboe@kernel.dk, hch@lst.de,
        kbusch@kernel.org, ming.lei@redhat.com
References: <CGME20230210180226epcas5p1bd2e1150de067f8af61de2bbf571594d@epcas5p1.samsung.com>
 <20230210180033.321377-1-joshi.k@samsung.com>
 <69443f85-5e16-e3db-23e9-caf915881c92@acm.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <69443f85-5e16-e3db-23e9-caf915881c92@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0183.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:311::6) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH8PR10MB6575:EE_
X-MS-Office365-Filtering-Correlation-Id: 98976e61-2343-4f64-1e5c-08db0e76e859
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jLShdXbRT39fXAEFqpydYMlUzT7wlWnjygy1IBcqpb7RiujwXY79qy71zkR1/OI1l32QrR0x0P1V5MlIOuCJTfispLaVWBG52ylECkIy5dZ70Os5CdsGas1+nc4r7uAMlZTuTRRuKAernVWB4krOsGm1ZUxfvwtUypk1Hn9LOL4J9W1ZxTUI0tVK/XwiCLGEWsD0g1H7j04a5QnbB9x3Slz+u9edlLlAegkyQIA60cSVGZWU2olHAQEmdjBKAk5Mg3pRrDOfJ9I7P+yKaLotMgAzNJsjd0kncvKqV6YCxwcPoLr/VJabGOfEFWTQ2XnSK4I0WbEkty+/yxM5Z2ir4GF63KGL5Wkv1UhkMZDVUIhCLrY/s6beKIXosW3O8PRiCf3otKHqyIvBayUfTmZiPwnxK5FaDuJOgHtDlZ7fkHRw59+kwAFq7wZZQuz7dppTuvqbxwevj5LBZl/T8mZpotRzDc1fFVniulV9hvT4s1VGl7ZfTUn71CSCu+JKcJz73ng+5bN0+qx4QmaH1S/0HIxD8KVUD2iH/mGorDarWZGYblqZMuoH3ZyO1al1UjtZNeTTg1MhG0vqWzZUaZQitkyny4Hcb98xCKNLdfc0wSFG5yLESVvb/kPC+Qa48o8hvSatR0kQq2sNvmqT0shQXx6UqedFR/UUN0bmSRms5uZ1+5RUW5SGZuvloYk7dTnUKeILAdOVPzgea/lh2EtJbhyNO3mkseTxEZxa0tk4M24=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(376002)(346002)(396003)(39860400002)(451199018)(478600001)(36756003)(966005)(6486002)(110136005)(66476007)(66946007)(66556008)(8676002)(8936002)(2616005)(4744005)(53546011)(86362001)(31696002)(36916002)(316002)(6666004)(38100700002)(41300700001)(6506007)(2906002)(31686004)(6512007)(186003)(26005)(5660300002)(4326008)(7416002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aThnMjhwZXMxS1V4THFVVEFoakFGRkNMNUMxY1RnYkVFSGozQkFLdmp6SllE?=
 =?utf-8?B?RFZXNEk1dElud2JiL0tzdnRVdkxKK01xU21TOStsWDhmeUJ5Nzd2QVlWaVZz?=
 =?utf-8?B?Vkdnc1JwamdJZ09uZ3NIWERsL3BOY3NLY0NYTkt4dG1DV09MNm16bDNLVWlt?=
 =?utf-8?B?ZlZaODMyZUxYOW8wMU1kMm83ZlNDaDRmN3kzMFQzS01OS01PaTUzcDl0Q0dT?=
 =?utf-8?B?ak1qOVRKcHFFS1ZsQk9xYldWdU45S0dyY1lhVDA1SkgydFZrSXpQb0x0NUZL?=
 =?utf-8?B?L2xXM3JDU3h3MlgxcVZMZ1c3cERoZ1BUYXRDM282dnBIUnhKMzFnMG5kRFNV?=
 =?utf-8?B?Y1FEYkRPd2d0a0RvZGU3SXUvSGwyQmxyYThic1EwQ3lPVTg4NDc2WWl1QnM4?=
 =?utf-8?B?c2tiVXhEamFVRFl3QWJ4a01TZGIrOGZtWUJlWFNrUjMwYkltQ3VlYTVOUzhQ?=
 =?utf-8?B?bGN1WmxNK080V1ltL20vUFdsZzdvTXBXTzR6QXRBRDYrVFRIQlVPSlQ4MkVW?=
 =?utf-8?B?QnlDT0FlUkI1ZlFDTWdpWTBvS1VPRDlka0FPVitsRVRnWHBzenJkNGpGV2NL?=
 =?utf-8?B?N1U3UEtSNlNZdExNV0d1c2pyeWN4RXNBQURlWVhHdG8yRlg0QVhWMy83V1BN?=
 =?utf-8?B?QWN0U00xUUlLbDh4N0FOVmRKbFQ5UnlFNXdvT1ZlMnFYR0w3eE15R2FFeU80?=
 =?utf-8?B?dVVzT1pFYUJwbEhFcUsraGtQaTgzTjhWSzAwMGpLUVRoUFdhTHpWRVl1YThj?=
 =?utf-8?B?YnRmMHM0OE16T0VnOXNrMlRYMDd6bDltL0wyZEVTQVZCVHU2MisxR1J3VTdU?=
 =?utf-8?B?VWZ1UHhNN0tiS0I1MGh1YnRvSisrbTg3YnlyUUNEWVVZNDAvbHNzRGRKc004?=
 =?utf-8?B?L3BtMWF1Z3pxOG5OZGN0N0hISUNnbVFQZWFReTRiTVNPVzBBd0RUTW5UOWNn?=
 =?utf-8?B?cDlzSGhacFIrenBaUExpM3dPakgxNy9JNG8waGJLQVZHVTdWY2p6TVZCcTk2?=
 =?utf-8?B?YmFzNm9SaGNTeVFwbzhodHR3azljODNpOHpIZ3hFV1Q5OVhVU053d1RYR2V0?=
 =?utf-8?B?MG5YUXBPU05mL3YrQXM5dWpSbnNHVDFaT2NmY1RpcDErTkNyVlBjdXQ5UG5v?=
 =?utf-8?B?a0I2SVlXcjBPMVhEekdyeGRjQmJYRGRUbDBrN25CcklqZjZpT2dvWDlZclhG?=
 =?utf-8?B?Uk9BM09VcWFpNUtaKzVyZENNNTF3ZkpOOVdkWDEwR1BpREF2MkdHd1VGWGU1?=
 =?utf-8?B?TFJtbXJLRy80WkwvWHU5WGxEM1c3Ykd6clY3Q3MxcE9sQWo2NDRTd21KTFNN?=
 =?utf-8?B?dlhzcngrRjhoYnZjVmR2Y1U1K2pGRkRRQUlZV1NjcnJCbHF2S3lvQTkvRmw1?=
 =?utf-8?B?ejJRaWh4MW13THhEZ3JwY0U5VmQwRjZUNGlHRlZNTEJ1alFoZVJsQXRqVms4?=
 =?utf-8?B?RjNDQjlYYnk1OU4vZUN4Mnh1eXlTL3VHZS9jK2ZnZkNmcSt4UUM3NlZSMmxs?=
 =?utf-8?B?blp2Wlp3aEoxbjVNajNZelhSSTVlZkFGY0pqVWw2dXk2eitvVEFLaHFVTnE1?=
 =?utf-8?B?TUlLNlR6Mmc4NTBBNVd0UytUTTRDcmJ2T0Zlejc3Y3E2Wjd0c3Q5WmdQZVdy?=
 =?utf-8?B?T1k1SVBkK0dnVE5OUnlneE5RMjQ4eEdiR1FZNXJOeTVVdGhoZDI3MGlTYW9X?=
 =?utf-8?B?aHRVZGJVRndySGdqZEdhek82aEZrdGozMm0yZlpKQWlEUlFjMXpBRWY0MDdk?=
 =?utf-8?B?V3BHTUNqMGZsV0ZTb0xnZ01lRm9ibUxHTVpFRkR1TnRZSEdUNGgrYnRTcnU0?=
 =?utf-8?B?SW9zQkwyQzFDSzdTY3dHUEdldjdWZjBvYVFsRFVxaTY2WFlDL3Z5R0h6Uytk?=
 =?utf-8?B?cXd3QUM5VExFRmQ3QStUbm55VG5UYTRMYlcxWXFUUlFlZWFxdmZ5TDNnV1VE?=
 =?utf-8?B?N0RqZnZVTVp0WlFNZythOFFqSE16WllLcktBclRYc0tvMlh2SnFvZm9xL0Ex?=
 =?utf-8?B?YXJNQ2drYzcxTFJmalQ0RE1ITkpUNEhOSmtjK2g5WXJmdlNSZ281cUh4aVhQ?=
 =?utf-8?B?Z05LUlFrLzFVQVV0UVJKLzFYTVhaTDd0OEVOakNoQkNCSXRDY014R0ZBUXl5?=
 =?utf-8?B?SWllaW9JUzkzSE9lUk1WQUhlMC90NzEwOHBtbFgvdEVHQ1Bua0VFNVpCNlc0?=
 =?utf-8?B?dFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?MnlkRjBxZTVjdHJ2WWZtSXJTZ0Vpb1dtdU1VUmNrd0pEeVM5bmptdUk4QTZz?=
 =?utf-8?B?TXJMQzZhRitYVzVPSU1reDBzUWpJWGI1RVNlWmdLRnQwekRpRU0rOHBWS0N2?=
 =?utf-8?B?ZzRiTGpFOWdxM0syQW5MZ0w5N0Njck5kdWh6eEFmL2VhOHRsQzRCRXZVUDd5?=
 =?utf-8?B?cXdaTHNOWjlFZXF4M3hVZnRIOUZOZmxPRm9PQWNhUVBic3FHVHJIV2lSVU1z?=
 =?utf-8?B?amIzbUNPOEVQTzc0a05vOGg5QmxLUlFWLzhUUkJRUUlNakE4ZURRa3JVRkJ2?=
 =?utf-8?B?TzRpanFzN3lXZkFra3VmeFQ3cjZPczFQT3RTWk1TUkZUMDNRSXJvVTJBL2NX?=
 =?utf-8?B?a0NGbU1Dd1V4em44ajQ0N1NZdGt2WTBYeDJnSEp2Q0hUMkxxUFlwUXcxSGNN?=
 =?utf-8?B?SU1KcnhTK2V0blVaSEFvUlNCRUllbkF3ZzNweVdtR3NrZjBmMkloRWNFR0Fp?=
 =?utf-8?B?a2ovZ04zQmFsMW1OR3NoRjJnK2RuQmcveS9qNDg0d0k1Q05sNXRCNnd6MFN0?=
 =?utf-8?B?OFFzelBVcDUzVnMzOGtjOGNpN203QnNpRXJJR2svWFhWejBYOTc5S2NnMENX?=
 =?utf-8?B?eFVSanlqdmJ4YVJsRFFla1l5ZTU0T2JWSmR6UG9kcjhZVFFvaUpSV2ZhWTh5?=
 =?utf-8?B?eE9URTk4NVROa3BJNnE0NHRmTmdkaVg5bDFMemNDL21XSjNoVG1IeS93L1RT?=
 =?utf-8?B?ZXRGWTVrMFZMWlZFdTgyYnZzNFgzMVEwZ2NXVGdOYU1pcVhGNEhDR0xXRjhE?=
 =?utf-8?B?OG5jMHNPQkdvZGFTaU4vWHduQU5VaXJxbEs2MGZCSzRGcVF4WUNNcmFQZFVu?=
 =?utf-8?B?QUZHRUxaQk5JcW1BNTVVMis2QWFRYWlTc3owRm9YVS91L3IyY00rb1FFbHFn?=
 =?utf-8?B?WDNQYTdyZjVmSFdjK0F5TnEvVUJlalgzZEJ2eDVmWU9vMkxsME9TUFpKY0xw?=
 =?utf-8?B?SEpXTU1qbEt2WWpnNVJwOXBCNzNiZy9zT0RFRzdhZUtZQ2htTDRNemU5Tjlz?=
 =?utf-8?B?czUwNnh3VXZtOUR3azY4WDlENjlNMit4MjRvME9QZG04c2k0a1Zpd3lTNUZa?=
 =?utf-8?B?empkY0ZXQ0tieHg2dFdBWWczc3ZLYXJERVI0QWlRMkMxdGJQeFp5L0FBemNr?=
 =?utf-8?B?cmdhYTIzNGZqUW1IaExNOEZ0MFFiSTF6Z1dpNFg5azlKc2k0SjI1ME55STV5?=
 =?utf-8?B?ZGExU21ZNkdTS3RoazF4ZEpHMElUYkQwaE02ZTNTK1YzN1NReW9WOUJUWDI3?=
 =?utf-8?B?Kyt5ZU1jVjRxMUlaUE80WFpJZkFGOU9zeTR0Q05Ddm9FVlRJYjF2STlvaW1B?=
 =?utf-8?B?dUIvbnZDZC94YkpkVlFNbWdvU3pKZGNBUmQxZnF2a01mL3M2UEc2WVpJdUdk?=
 =?utf-8?Q?1RfcJXvR9gQVVadKIq8MpPxuMPPbmJ/Y=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98976e61-2343-4f64-1e5c-08db0e76e859
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 10:33:27.2310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x5IL6IELBk8vWjFkp6gyJTW6cV0owM5PU8UBZDOOF21EOaIIZpONc8nBs4p7Ff+pRxfrn45n1Bklr8jlEtzUgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6575
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-14_06,2023-02-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=919 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302140090
X-Proofpoint-GUID: Ko1DnCkifV9HSOoXWWmsnMydB1x9UqKm
X-Proofpoint-ORIG-GUID: Ko1DnCkifV9HSOoXWWmsnMydB1x9UqKm
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/02/2023 18:18, Bart Van Assche wrote:
> On 2/10/23 10:00, Kanchan Joshi wrote:
>> 3. DMA cost: is high in presence of IOMMU. Keith posted the work[1],
>> with block IO path, last year. I imagine plumbing to get a bit simpler
>> with passthrough-only support. But what are the other things that must
>> be sorted out to have progress on moving DMA cost out of the fast path?
> 
> Are performance numbers available?
> 
> Isn't IOMMU cost something that has already been solved? From 
> https://www.usenix.org/system/files/conference/atc15/atc15-paper-peleg.pdf: "Evaluation of our designs under Linux shows that (1)
> they achieve 88.5%–100% of the performance obtained
> without an IOMMU".

That paper is ~8 years old now. Some recommendations are already 
supported in the kernel since then, like per-CPU IOVA caching and 
per-IOMMU domain IOTLB flushing with per-CPU queues (which is relevant 
to lazy mode only).

Thanks,
John
