Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7962077EA8A
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 22:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235946AbjHPUPU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 16:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346088AbjHPUOu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 16:14:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F226E1BF7
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 13:14:48 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37GJKOVI013698;
        Wed, 16 Aug 2023 20:14:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=5DRJRGu/ORqc1CH4fk7iCF8KoqI2HAiadwKFd7BR1ao=;
 b=1dWWSxLPgK+fVAvVBprDlBOmInuGist60Wv/4DDwtHyNfG5PCEcoBHx0OKU1te5bNZv/
 FwoiMQqvHYLmxm9u2BeLZ5uhMzv7RQaKP4g4YrZAh5NrfrE8Audx8I1WS6ypSaKEddJA
 wsh8mL5tI1mgsM4bNc03doTPqlFvIYWTt7jmMxH7WlyYnt1dfFa9YpdIdXnw2iooag4d
 Ew164MPouhACofoxxAV0B83uQydfoPW03Dn3yODnq7IV4/IhRiRGvtGOXxiu//dTwNbP
 2SJnygbuQ9uUaZewtNs59xMfUlY4DrgQIQkaYlK8NlTK46/laJqr7m+UcGwreYOAVudc Ew== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3se31482ca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Aug 2023 20:14:26 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37GIrsFX019869;
        Wed, 16 Aug 2023 20:14:24 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sey3x7yuf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Aug 2023 20:14:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YdHsqUgq9eF598ZLhBB8hidBobohmUCUDN3XLEBSDGKA9uKJMGqttD7mOnbYtl8xBfA3a/XbLEDUnkVFxHSNbxhHU1UQCRDbp6FwgTQGSTJj9GkAd9H+cYnP4wD3L7PwpOWwDN8ldy/986DP/JL6v3QRD06UuOGoSDbgpdKslAOBgH6h+jNM7UnYgEprIfPGke9yzQdmhXlzXNCPJgfRIemo8/M2L1Q6O1FPuGOO7mr+VBsa4/5Kh6HRkgl+9CCR50YCwd/s2ElEpAwoMs0Boqcu8k5gTiLUBVVoprDHx0Z1Vop4aua4rzpxEqOJjJ1NimhPLQFJaydVusaAMxfYwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5DRJRGu/ORqc1CH4fk7iCF8KoqI2HAiadwKFd7BR1ao=;
 b=MbOh4Sri6ruFfi3ozPZl1M+83YpzYfxVU3o8m80/lW3D1u5vouJaE5HZ546ZB/K5Dw76UP6Yd0S/AwzwOj6ogueS7jO4Ys0WkJjfByHzKOcRfYEm5K2W/de9qGJfK0MfRDjWSPc/HoZG5gHtsja9zlNQvJEOpNgZZ8uE4OnuTMLpJCBlIS3XJWd5YMwnB3WHNtK+DBxP/qesby9W/ufWJ/A/jzzTr81xFkp7QBw2Q4I3BrTyLSTyrnUEHdGCXR1Ou7wAaXbvjCRYB5akiqj726rf5rxb8GHSY9cmG2C+6AFWHXrgf95XXk0PYA9gfYAvVSSMfkFVqd7qvoGIf5GUAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5DRJRGu/ORqc1CH4fk7iCF8KoqI2HAiadwKFd7BR1ao=;
 b=dDuz9PgdoUvUh1I1Av3oUllxl/rlXtj9+6WfVb1PmLdqjm3td+wcyFhlQFVoLhi22th7UZWkwiJYLvVpk9rJWO9F/YQLN2+TpkkRbc5jg3/wnFM4GsBHCANUzW5tBflUqNmngrmH31YrP1U2TyAjuJfIXazY5ALIt8Vzs/UOlVI=
Received: from CH0PR10MB5113.namprd10.prod.outlook.com (2603:10b6:610:c9::8)
 by DS7PR10MB5071.namprd10.prod.outlook.com (2603:10b6:5:3a1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.30; Wed, 16 Aug
 2023 20:14:21 +0000
Received: from CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::6bff:7715:4210:1e52]) by CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::6bff:7715:4210:1e52%7]) with mapi id 15.20.6678.022; Wed, 16 Aug 2023
 20:14:21 +0000
Message-ID: <09f25cc6-175c-cf50-dc5f-88733118636f@oracle.com>
Date:   Wed, 16 Aug 2023 13:14:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 03/13] mm: Convert free_huge_page() to
 free_huge_folio()
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org, Yanteng Si <siyanteng@loongson.cn>
References: <20230816151201.3655946-1-willy@infradead.org>
 <20230816151201.3655946-4-willy@infradead.org>
Content-Language: en-US
From:   Sidhartha Kumar <sidhartha.kumar@oracle.com>
In-Reply-To: <20230816151201.3655946-4-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR17CA0057.namprd17.prod.outlook.com
 (2603:10b6:a03:167::34) To CH0PR10MB5113.namprd10.prod.outlook.com
 (2603:10b6:610:c9::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5113:EE_|DS7PR10MB5071:EE_
X-MS-Office365-Filtering-Correlation-Id: 3702c845-4c54-4bc2-2017-08db9e956080
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5674b4FmbPdV0oxcqZXc6Fs0fsus0Cx8Yy8lg374e/A3sudBBQV31txW49DN1LssJesyGggkmWd2AD2fKtB4+mId74IIDjms8oP55+Qr+/RHMqIRkASzFoIjIg4HqNo2rtss1r84n1R+xYR0PUvZZBocdQrIcjbkcFr3ZlfagqE9BkuX0nZxL4HmUhXr1YaCBNbN4pJzVedxpYKv1ujmD/FGozolbvhW30fhZ09wbUOsucKhfzAKxNDdE6oyqx5NWK7YRA1635iQLeTx22FhG86/9ucszu4v5pYJaLnaHBValPYSCxHlzLjxNp+OdtZ2DCwe1BS+8ofc62e+0ai3o1U+AAzudlGT6plw9FdPh5g8rwhLYdnynxJONGkR9+h+q9ABI3WLwMMEpPu/uFDIgktCTALEbdBnyZXwKB0mkBy5L3YZwgZvSAr/BPHibOuv1MKzrvUdX7oky1KNBk+EX3GTc5dylxCHMrogakcHMyX25IHst+gM5S/50Sa053I38zfEjz861YGxVfAZHeH/2IYEgaXgzu41ZLhjKIb0/g+Qwxl6tijjiBVh4hiWo3HGcwmXLMWWpnKIZLBC1bOlZRv73wiKLxobCUoJ6Rdzc7wVquFCesxJXo0cMbqsV/tJ8Vdwmmk9lpHFC9tHxgdIdbBXEPwAIBWnZW0agSq3iDM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5113.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(346002)(136003)(366004)(396003)(451199024)(1800799009)(186009)(316002)(54906003)(66946007)(66556008)(66476007)(110136005)(5660300002)(41300700001)(44832011)(38100700002)(31686004)(8676002)(4326008)(8936002)(66899024)(30864003)(2906002)(567974003)(83380400001)(478600001)(86362001)(53546011)(6512007)(31696002)(6506007)(36756003)(6666004)(2616005)(6486002)(14583001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b2FMTi9lTTlyZHZ0T2YyL1RBSnJkRVJZdGlOODVnSXRuSG5TNDVZcWxXZFRx?=
 =?utf-8?B?dmJ0RVhmdUdvYmYzRWhaV255c0EvY01ORkhpdTRkWGRXbWhvWDBybzBhbXJk?=
 =?utf-8?B?RVNhMGhkNlBSMXR0eFpqYkc0OVhWU1UwZ2tlTXVoc1NxRzIrQ2JWRVcxOEhU?=
 =?utf-8?B?b1d0azNYb0NRTDczb1lNU0ZIRk1lcnIzTDFEbjN5ZTNPdWY4eW96YXFJUjNI?=
 =?utf-8?B?Vzl5dmUvUVJRcDQxUXFQeXorT3pZd0ZaeDFCZkdteURWeDI5UUxjSm4zU1FI?=
 =?utf-8?B?ZzBvdFV1d1hRaytnby9Sd1pORFU3Z3VTRmEzaGVTS053N1d4VFRwOWJEZ2pJ?=
 =?utf-8?B?a2FRVUl5WmtQa0ZmckdYckVnb3Ayc3dJc1ZCd2ROVnhWU2tTRVpvZWt2aHh5?=
 =?utf-8?B?Y0pUNVNZbkdJaVR3RFVJUTQ2eDRkdks2bnlKdGxpcDJCT2VhZVhZcStBUEhY?=
 =?utf-8?B?eDcwQVhKd1E1Rk5odHUxSWpqWEo0U3ZtbVpWRytXZS9RL0RJT25aYTFVUFdY?=
 =?utf-8?B?WGx3eW1vd2xIYVVQSzdzdlllMVpkZE1YR3RJdGhSZEd5NXdpTElHcmRpMkRL?=
 =?utf-8?B?NnhoblA2MksxSC9hbGxvVHhpTHVFQ1F1Y3QzdU1wY1UzQitZcXRXOEE0L2JD?=
 =?utf-8?B?Y2poZkg1UWh3V2xPcmtmd0ppenRXNnRMZWU1bUgvVGh5cWhveExXalY5YUhu?=
 =?utf-8?B?Ry85ZHR5MTI4TnM0d05pNjVBMVJ5dkkyc0I0bWN1cFFSVzV4c1dsc0lWeGVN?=
 =?utf-8?B?aFFOUFB3MkxrV0tzdE9tZ3dZRUFzQXFZeWNDTXhIK0dMOXJBN2lPbDF2MmVH?=
 =?utf-8?B?bHpmbU9IaEttaTFYTWtTTEN1KzR0Wm5ZYXRyRjAzWFpEczNOdDltNDMxRkk4?=
 =?utf-8?B?Z1J6dms4NWN5QXlYWVJnNGtMWWcrM2ZwNE45ZU1aSmtXN2luNDJzdURkYk9j?=
 =?utf-8?B?akhMMFhHczlyOXRrOVRjY1N6c3JqRnF1MDZsdi9taWUvMkl3c1JjeGtjOUFW?=
 =?utf-8?B?bnZ2NEdCMlNDNCs3VXFibmYxOHpOSDJJRkNTQ0h6cHdoK25OSG51eFhGaEJM?=
 =?utf-8?B?OHB5a3lqcG1YbzBmeFF6TWExWTNJSlRjaVJWWmY1WTZ4Z2tSaWVVU05TVmJ3?=
 =?utf-8?B?eklYbmZ6NTFBaEVUWjhrZ1VseEMrMGJIRWMrV1dxUERuZkFsK2EvOGJ0RU9s?=
 =?utf-8?B?T1d4eTJmQlRzUFBpL2pLOUVIREZiT3FNNmdDOUZHa3podUxWU1J4TTVubTZi?=
 =?utf-8?B?QWdzSXQ2TFVFcGFmdHVOWEFiNjU3ZmZOWUxOb3BsQmxzRG4ycUpYQjFjUXM5?=
 =?utf-8?B?YXppOEtla2RkTTJpclBtWmRNK0xUY05WMjJhKy9vUGMvbHN1dzcrKzlvV2JF?=
 =?utf-8?B?UDN5Y3lIL1lrRFd0Q05xQVBBNDJmckNlc3pIbWdpRzk1VzRiRkIreEhJREc3?=
 =?utf-8?B?Q1pJeUU3SGptUlQ1dTdDRXdtZ3FvcjlsNExtRytobG9xSnRIbStxQ0FIQk1Z?=
 =?utf-8?B?aTk0Y2NscGo0dkIzTjU2elVNaTJSa0t0M2pYbGpraVdqM25zakVGM0pVaTdG?=
 =?utf-8?B?TFhFVlk2UHI0emhMWFhubWpzUExiVm5LaTRZdUtlYlNIMm5uREUyeitrbjFU?=
 =?utf-8?B?TmF0TU0yUFZtemRDRjVEa2FJdUx2WkdoSEc5ZnpIanlyMFpMaEtzV3B0UE1x?=
 =?utf-8?B?bFRmSk9vL09qdkR0ZlUwRExmdEhqQ0lsdTZUdC9FNnFuUWlQdEtrb0dJWmFq?=
 =?utf-8?B?SWdVT3B0N0l6Rzh6R3FqeXBQbitXcnVtSVh1RmxNdTVENTVsSlEzRnFhWTJO?=
 =?utf-8?B?dGJhdGZ1eTJaYkRLVytYZk9DSWRBcXBXZm5oMUQrSHFVaDJpU2J2YkFLU3oz?=
 =?utf-8?B?S3VQZGJLbDJKL0FSWGFFQjVnMWF3Y1RPOUFMZ2Z6dFppam5PeFhadEVMczgy?=
 =?utf-8?B?NEZsRjhtQzhOUXo1MEZzeHpzMWV2Vm1QeVAwUEZWY1lrS3ZtTW1uTFdVQnRN?=
 =?utf-8?B?R1VmSTI2aDhIbC9nMXNLWjU1NVdUenptVlZic3ZPQnVaTURTYWsvV0tMeDNV?=
 =?utf-8?B?cTF6ZkZZOUF5NUtTa1ExRmRqeGZlcGE5WTJxalNmL29TMWo2OXhKKzUzRlpm?=
 =?utf-8?B?TVhQS2J3Vk14UnRxbXpCMXZ0SGp3YUxDTUhjNkEzb09jMFVMV2htT2xkR3Rv?=
 =?utf-8?Q?qfQBCr3OdVfaBjvKiUFOuEE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?d0FFWENOaVRIc3NDakNYT0VYbHlHaU1xc2d3a2sveXgvbDZRbzlvZlNTSXR3?=
 =?utf-8?B?cHhvTTlxaFNBMUV2TmRVbDdMaTNSMU9vSjUrNENvM2RYU2dMM0pLdW93T1dR?=
 =?utf-8?B?UHE5MjhwQlJSakRaSm5kb2c0M2lPZThFTGxZM1NkeDUvOHhXKzFmZnhtYWI4?=
 =?utf-8?B?TTBlVlNCdEZyK0prNTRFczRPQXhkdjYxcGc2RWUxSGVxSU1kK1FGNWgwTjA1?=
 =?utf-8?B?b2RoU3krSjZZS2M2RXcvaEpnVlVzK2hUN1YzeFYyS2xHdUlETDZ1alQzSU9y?=
 =?utf-8?B?dG9aTHFnZlFNWDdOT2lTUTBodDhTU1NiUk94VGsrU2RZcGdwbU9oVEpPMVc0?=
 =?utf-8?B?a0svdjhzOVpIdXFxdDk3NWdQY1BjdlZVenhIbEFJemZaVFhxTlNnbFJaUXlG?=
 =?utf-8?B?Mnhsci9GOGFvZWhFVUwrZDIvNk9hcnAvc29pRlJMODl0M2ljdFBrVWhibzhN?=
 =?utf-8?B?UHFud0xuZmNrcmFqYzJ2dkVINmVXcUhkMjk1K3A3aVdjU3JKU2FMcnBPTFZP?=
 =?utf-8?B?d3V2OVcyWUlqSmVGemVxTFpMcytxdElxY3FPUDJLTFpySXd4ZDlYenpaV1A5?=
 =?utf-8?B?dVVmNFBXcVYvSW5iMDJqY2MxckJjTmloRVYzcGs0c3JPVEkvb1JUNGFuY213?=
 =?utf-8?B?MFRYblNNRDYydnhyMDU1NnQ4S3JjWlR5djlHZEJNNlRxYjZ0ZjkzY3o2Vy91?=
 =?utf-8?B?cXhKYlBSTTl4b1VYMFlKV2x1YkJ2S2ZPbW1tRFdGN05FS3J2MTQ5RytwSldk?=
 =?utf-8?B?ZjIwL0NnbUJQS3JRb0ZOYk1nV3hpdXFUUkxmcGFQejMyZ3JQRVJPS01OYzF5?=
 =?utf-8?B?bHZQUDhJdkxMZ3lLc1lMVUp5T01taTJ1bFNFTXdrb3NUQzViTEdoMzhOa0J5?=
 =?utf-8?B?T01EeHkzUU1SQ3hpWjAwV0ZkRWZ1UVdtczQyRDk1N21XbE5ZVjEzVWgrM28r?=
 =?utf-8?B?Y1g1eHNKcmdLdjhEK2tsN0pDNDdDQm9kUlpPZVRibHptWTRqQ2h3ZG5sc25P?=
 =?utf-8?B?VHAwNTQ1SGJEcWxlS2Y0akVLcXRIM1dMYVhQUGVXSEhFRnVKWnh3TjZUczVZ?=
 =?utf-8?B?NktpeSs4cmhhS2h1UlJXVk1NMUkway9hMmlCRnJtWS9wajZlZjFpMTdBOG9o?=
 =?utf-8?B?YlhOQXUzTkVtblFMR1BjV09GRVJxRzhkZHRUU1VNb3kreTZSMUc2QVN3OTNy?=
 =?utf-8?B?T25rcnJlTmhVU1hlLzgrdTRCUUZ0R0pMWUlBbFdqV2tDRkh6K3JzV1JzemVW?=
 =?utf-8?Q?G4MtJ7zPNW57ohu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3702c845-4c54-4bc2-2017-08db9e956080
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5113.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2023 20:14:21.1487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UAaYMs3WmFP9Ls3PJLa8KQ5B1kTO9NP2lfoC0RGgdxvRRXxy2YQhzFPqECDSj55QIASlxUmR4rNWnwaifdW6Ggehb6/5tPIjHlWvESlw8M0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5071
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-16_18,2023-08-15_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308160179
X-Proofpoint-GUID: lgU9FZeZqy4udi_bxT7IkYpqmXRHMucg
X-Proofpoint-ORIG-GUID: lgU9FZeZqy4udi_bxT7IkYpqmXRHMucg
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/16/23 8:11 AM, Matthew Wilcox (Oracle) wrote:
> Pass a folio instead of the head page to save a few instructions.
> Update the documentation, at least in English.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Yanteng Si <siyanteng@loongson.cn>
> ---
>   Documentation/mm/hugetlbfs_reserv.rst         | 14 +++---
>   .../zh_CN/mm/hugetlbfs_reserv.rst             |  4 +-
>   include/linux/hugetlb.h                       |  2 +-
>   mm/hugetlb.c                                  | 48 +++++++++----------
>   mm/page_alloc.c                               |  2 +-
>   5 files changed, 34 insertions(+), 36 deletions(-)
> 

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>

> diff --git a/Documentation/mm/hugetlbfs_reserv.rst b/Documentation/mm/hugetlbfs_reserv.rst
> index d9c2b0f01dcd..4914fbf07966 100644
> --- a/Documentation/mm/hugetlbfs_reserv.rst
> +++ b/Documentation/mm/hugetlbfs_reserv.rst
> @@ -271,12 +271,12 @@ to the global reservation count (resv_huge_pages).
>   Freeing Huge Pages
>   ==================
>   
> -Huge page freeing is performed by the routine free_huge_page().  This routine
> -is the destructor for hugetlbfs compound pages.  As a result, it is only
> -passed a pointer to the page struct.  When a huge page is freed, reservation
> -accounting may need to be performed.  This would be the case if the page was
> -associated with a subpool that contained reserves, or the page is being freed
> -on an error path where a global reserve count must be restored.
> +Huge pages are freed by free_huge_folio().  It is only passed a pointer
> +to the folio as it is called from the generic MM code.  When a huge page
> +is freed, reservation accounting may need to be performed.  This would
> +be the case if the page was associated with a subpool that contained
> +reserves, or the page is being freed on an error path where a global
> +reserve count must be restored.
>   
>   The page->private field points to any subpool associated with the page.
>   If the PagePrivate flag is set, it indicates the global reserve count should
> @@ -525,7 +525,7 @@ However, there are several instances where errors are encountered after a huge
>   page is allocated but before it is instantiated.  In this case, the page
>   allocation has consumed the reservation and made the appropriate subpool,
>   reservation map and global count adjustments.  If the page is freed at this
> -time (before instantiation and clearing of PagePrivate), then free_huge_page
> +time (before instantiation and clearing of PagePrivate), then free_huge_folio
>   will increment the global reservation count.  However, the reservation map
>   indicates the reservation was consumed.  This resulting inconsistent state
>   will cause the 'leak' of a reserved huge page.  The global reserve count will
> diff --git a/Documentation/translations/zh_CN/mm/hugetlbfs_reserv.rst b/Documentation/translations/zh_CN/mm/hugetlbfs_reserv.rst
> index b7a0544224ad..0f7e7fb5ca8c 100644
> --- a/Documentation/translations/zh_CN/mm/hugetlbfs_reserv.rst
> +++ b/Documentation/translations/zh_CN/mm/hugetlbfs_reserv.rst
> @@ -219,7 +219,7 @@ vma_commit_reservation()之间，预留映射有可能被改变。如果hugetlb_
>   释放巨页
>   ========
>   
> -巨页释放是由函数free_huge_page()执行的。这个函数是hugetlbfs复合页的析构器。因此，它只传
> +巨页释放是由函数free_huge_folio()执行的。这个函数是hugetlbfs复合页的析构器。因此，它只传
>   递一个指向页面结构体的指针。当一个巨页被释放时，可能需要进行预留计算。如果该页与包含保
>   留的子池相关联，或者该页在错误路径上被释放，必须恢复全局预留计数，就会出现这种情况。
>   
> @@ -387,7 +387,7 @@ region_count()在解除私有巨页映射时被调用。在私有映射中，预
>   
>   然而，有几种情况是，在一个巨页被分配后，但在它被实例化之前，就遇到了错误。在这种情况下，
>   页面分配已经消耗了预留，并进行了适当的子池、预留映射和全局计数调整。如果页面在这个时候被释放
> -（在实例化和清除PagePrivate之前），那么free_huge_page将增加全局预留计数。然而，预留映射
> +（在实例化和清除PagePrivate之前），那么free_huge_folio将增加全局预留计数。然而，预留映射
>   显示报留被消耗了。这种不一致的状态将导致预留的巨页的 “泄漏” 。全局预留计数将比它原本的要高，
>   并阻止分配一个预先分配的页面。
>   
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 5a1dfaffbd80..5b2626063f4f 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -26,7 +26,7 @@ typedef struct { unsigned long pd; } hugepd_t;
>   #define __hugepd(x) ((hugepd_t) { (x) })
>   #endif
>   
> -void free_huge_page(struct page *page);
> +void free_huge_folio(struct folio *folio);
>   
>   #ifdef CONFIG_HUGETLB_PAGE
>   
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index e327a5a7602c..086eb51bf845 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1706,10 +1706,10 @@ static void add_hugetlb_folio(struct hstate *h, struct folio *folio,
>   	zeroed = folio_put_testzero(folio);
>   	if (unlikely(!zeroed))
>   		/*
> -		 * It is VERY unlikely soneone else has taken a ref on
> -		 * the page.  In this case, we simply return as the
> -		 * hugetlb destructor (free_huge_page) will be called
> -		 * when this other ref is dropped.
> +		 * It is VERY unlikely soneone else has taken a ref
> +		 * on the folio.  In this case, we simply return as
> +		 * free_huge_folio() will be called when this other ref
> +		 * is dropped.
>   		 */
>   		return;
>   
> @@ -1875,13 +1875,12 @@ struct hstate *size_to_hstate(unsigned long size)
>   	return NULL;
>   }
>   
> -void free_huge_page(struct page *page)
> +void free_huge_folio(struct folio *folio)
>   {
>   	/*
>   	 * Can't pass hstate in here because it is called from the
>   	 * compound page destructor.
>   	 */
> -	struct folio *folio = page_folio(page);
>   	struct hstate *h = folio_hstate(folio);
>   	int nid = folio_nid(folio);
>   	struct hugepage_subpool *spool = hugetlb_folio_subpool(folio);
> @@ -1936,7 +1935,7 @@ void free_huge_page(struct page *page)
>   		spin_unlock_irqrestore(&hugetlb_lock, flags);
>   		update_and_free_hugetlb_folio(h, folio, true);
>   	} else {
> -		arch_clear_hugepage_flags(page);
> +		arch_clear_hugepage_flags(&folio->page);
>   		enqueue_hugetlb_folio(h, folio);
>   		spin_unlock_irqrestore(&hugetlb_lock, flags);
>   	}
> @@ -2246,7 +2245,7 @@ static int alloc_pool_huge_page(struct hstate *h, nodemask_t *nodes_allowed,
>   		folio = alloc_fresh_hugetlb_folio(h, gfp_mask, node,
>   					nodes_allowed, node_alloc_noretry);
>   		if (folio) {
> -			free_huge_page(&folio->page); /* free it into the hugepage allocator */
> +			free_huge_folio(folio); /* free it into the hugepage allocator */
>   			return 1;
>   		}
>   	}
> @@ -2429,13 +2428,13 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
>   	 * We could have raced with the pool size change.
>   	 * Double check that and simply deallocate the new page
>   	 * if we would end up overcommiting the surpluses. Abuse
> -	 * temporary page to workaround the nasty free_huge_page
> +	 * temporary page to workaround the nasty free_huge_folio
>   	 * codeflow
>   	 */
>   	if (h->surplus_huge_pages >= h->nr_overcommit_huge_pages) {
>   		folio_set_hugetlb_temporary(folio);
>   		spin_unlock_irq(&hugetlb_lock);
> -		free_huge_page(&folio->page);
> +		free_huge_folio(folio);
>   		return NULL;
>   	}
>   
> @@ -2547,8 +2546,7 @@ static int gather_surplus_pages(struct hstate *h, long delta)
>   	__must_hold(&hugetlb_lock)
>   {
>   	LIST_HEAD(surplus_list);
> -	struct folio *folio;
> -	struct page *page, *tmp;
> +	struct folio *folio, *tmp;
>   	int ret;
>   	long i;
>   	long needed, allocated;
> @@ -2608,21 +2606,21 @@ static int gather_surplus_pages(struct hstate *h, long delta)
>   	ret = 0;
>   
>   	/* Free the needed pages to the hugetlb pool */
> -	list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
> +	list_for_each_entry_safe(folio, tmp, &surplus_list, lru) {
>   		if ((--needed) < 0)
>   			break;
>   		/* Add the page to the hugetlb allocator */
> -		enqueue_hugetlb_folio(h, page_folio(page));
> +		enqueue_hugetlb_folio(h, folio);
>   	}
>   free:
>   	spin_unlock_irq(&hugetlb_lock);
>   
>   	/*
>   	 * Free unnecessary surplus pages to the buddy allocator.
> -	 * Pages have no ref count, call free_huge_page directly.
> +	 * Pages have no ref count, call free_huge_folio directly.
>   	 */
> -	list_for_each_entry_safe(page, tmp, &surplus_list, lru)
> -		free_huge_page(page);
> +	list_for_each_entry_safe(folio, tmp, &surplus_list, lru)
> +		free_huge_folio(folio);
>   	spin_lock_irq(&hugetlb_lock);
>   
>   	return ret;
> @@ -2836,11 +2834,11 @@ static long vma_del_reservation(struct hstate *h,
>    * 2) No reservation was in place for the page, so hugetlb_restore_reserve is
>    *    not set.  However, alloc_hugetlb_folio always updates the reserve map.
>    *
> - * In case 1, free_huge_page later in the error path will increment the
> - * global reserve count.  But, free_huge_page does not have enough context
> + * In case 1, free_huge_folio later in the error path will increment the
> + * global reserve count.  But, free_huge_folio does not have enough context
>    * to adjust the reservation map.  This case deals primarily with private
>    * mappings.  Adjust the reserve map here to be consistent with global
> - * reserve count adjustments to be made by free_huge_page.  Make sure the
> + * reserve count adjustments to be made by free_huge_folio.  Make sure the
>    * reserve map indicates there is a reservation present.
>    *
>    * In case 2, simply undo reserve map modifications done by alloc_hugetlb_folio.
> @@ -2856,7 +2854,7 @@ void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
>   			 * Rare out of memory condition in reserve map
>   			 * manipulation.  Clear hugetlb_restore_reserve so
>   			 * that global reserve count will not be incremented
> -			 * by free_huge_page.  This will make it appear
> +			 * by free_huge_folio.  This will make it appear
>   			 * as though the reservation for this folio was
>   			 * consumed.  This may prevent the task from
>   			 * faulting in the folio at a later time.  This
> @@ -3232,7 +3230,7 @@ static void __init gather_bootmem_prealloc(void)
>   		if (prep_compound_gigantic_folio(folio, huge_page_order(h))) {
>   			WARN_ON(folio_test_reserved(folio));
>   			prep_new_hugetlb_folio(h, folio, folio_nid(folio));
> -			free_huge_page(page); /* add to the hugepage allocator */
> +			free_huge_folio(folio); /* add to the hugepage allocator */
>   		} else {
>   			/* VERY unlikely inflated ref count on a tail page */
>   			free_gigantic_folio(folio, huge_page_order(h));
> @@ -3264,7 +3262,7 @@ static void __init hugetlb_hstate_alloc_pages_onenode(struct hstate *h, int nid)
>   					&node_states[N_MEMORY], NULL);
>   			if (!folio)
>   				break;
> -			free_huge_page(&folio->page); /* free it into the hugepage allocator */
> +			free_huge_folio(folio); /* free it into the hugepage allocator */
>   		}
>   		cond_resched();
>   	}
> @@ -3542,7 +3540,7 @@ static int set_max_huge_pages(struct hstate *h, unsigned long count, int nid,
>   	while (count > persistent_huge_pages(h)) {
>   		/*
>   		 * If this allocation races such that we no longer need the
> -		 * page, free_huge_page will handle it by freeing the page
> +		 * page, free_huge_folio will handle it by freeing the page
>   		 * and reducing the surplus.
>   		 */
>   		spin_unlock_irq(&hugetlb_lock);
> @@ -3658,7 +3656,7 @@ static int demote_free_hugetlb_folio(struct hstate *h, struct folio *folio)
>   			prep_compound_page(subpage, target_hstate->order);
>   		folio_change_private(inner_folio, NULL);
>   		prep_new_hugetlb_folio(target_hstate, inner_folio, nid);
> -		free_huge_page(subpage);
> +		free_huge_folio(inner_folio);
>   	}
>   	mutex_unlock(&target_hstate->resize_lock);
>   
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 548c8016190b..b569fd5562aa 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -620,7 +620,7 @@ void destroy_large_folio(struct folio *folio)
>   	enum compound_dtor_id dtor = folio->_folio_dtor;
>   
>   	if (folio_test_hugetlb(folio)) {
> -		free_huge_page(&folio->page);
> +		free_huge_folio(folio);
>   		return;
>   	}
>   

