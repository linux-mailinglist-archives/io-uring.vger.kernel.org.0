Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 864CC4B7724
	for <lists+io-uring@lfdr.de>; Tue, 15 Feb 2022 21:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235488AbiBOSUS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Feb 2022 13:20:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243023AbiBOSUR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Feb 2022 13:20:17 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D258119F49;
        Tue, 15 Feb 2022 10:20:05 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21FHtOKZ007513;
        Tue, 15 Feb 2022 10:20:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=4yGuBoTrxciYMAnux0OWiDxZpeVXzopSiRw0yJJetGo=;
 b=FNQKV4Zf+8l10Z32LBL7ENxgXPrz5oXdgAJcHSkBxzY/WJV/STKK0/x+594Vppgb5kZl
 W/qufyxClPTidfMOzStu1H0cxNUWv8UyRSKiJtVo1O5CHnJ355dAnu5z/cMlZz8LMDiZ
 f5R1PevLWcdEXnXLdSb3x9qz79Rr6R5Rv+g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e89cnuqgq-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 15 Feb 2022 10:20:05 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Feb 2022 10:20:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gPBECd9LqULZIT4WnU4hXoHk+sYXzsDRBbokK3QMpQwmYMDdt1F/7VAcEqbbC41T8nWj0baPFsRnm7yjlYg62cZA0AJ1qgiREabdshy7GGjSVkqme6mV2STjSvvev22x0vm5nCAmxTyimo85c4/bLEdvodqLCcqO7PozKXnl9+0CqdFeIaMwOVv8f/OGbLL4h4HzwhAqUdngXSUhKSPWWWfjbMzuKBF/kw68/Xmy/Vw/Lvm/10vwG2clZbDSPZ/l1Z42JfqpDL0aaFraVAZylVKhV7PyPxiniTc1Xac26ZdL7a1O+s+SOcuB6ywPeHTOGnSGfGMpdr3hPbnrZnxBLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4yGuBoTrxciYMAnux0OWiDxZpeVXzopSiRw0yJJetGo=;
 b=JDfZuXJkWKupGyVwtfQh4geRNGRFaKhSQeW20xH+DvNXpX8IqqFrx3CpDjLosdbf5R46DqnDW91PrIWQrg0arQAw6rHEZNI/hXhbI9AW5IN1l/dZqX6pbBNGBLgUsCOdkd5Z0sq654+pyeFIoSjaHul68Ec9HLHSIN9A/kdMTkKLzcDqsOF/QGB26HV2h2a++IRejN/RBzdBhO1tjP386iSCFNB7WfLoddbpnDT9LGxerLnqyqlKMK05KWayEZhdUj4pdQZQ3cZZMLzBvuL5ZSz3beLWuDULM7hfYAr4UBEcSqnvfmGkV54sgKyg+j4+38+uaVq1PCkDEpTVlGyFcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from PH0PR15MB4413.namprd15.prod.outlook.com (2603:10b6:510:9f::16)
 by BN8PR15MB3474.namprd15.prod.outlook.com (2603:10b6:408:a5::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Tue, 15 Feb
 2022 18:20:02 +0000
Received: from PH0PR15MB4413.namprd15.prod.outlook.com
 ([fe80::981b:4822:be55:e113]) by PH0PR15MB4413.namprd15.prod.outlook.com
 ([fe80::981b:4822:be55:e113%5]) with mapi id 15.20.4975.019; Tue, 15 Feb 2022
 18:20:02 +0000
Message-ID: <6f3ce12b-b8d6-f1f8-ae35-64b6295f6f04@fb.com>
Date:   Tue, 15 Feb 2022 10:19:59 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH v2 1/2] fs: replace const char* parameter in vfs_statx and
 do_statx with struct filename
Content-Language: en-US
To:     Al Viro <viro@zeniv.linux.org.uk>
CC:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
References: <20220215002121.2049686-1-shr@fb.com>
 <20220215002121.2049686-2-shr@fb.com>
 <Ygr+nzDK6ft6LXfG@zeniv-ca.linux.org.uk>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <Ygr+nzDK6ft6LXfG@zeniv-ca.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0020.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::25) To PH0PR15MB4413.namprd15.prod.outlook.com
 (2603:10b6:510:9f::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a416376b-8a83-4a69-00fb-08d9f0afc864
X-MS-TrafficTypeDiagnostic: BN8PR15MB3474:EE_
X-Microsoft-Antispam-PRVS: <BN8PR15MB3474A0BE58F52108928D9FB2D8349@BN8PR15MB3474.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aK8Rpvx0hecM7+PlxNP/nAuNHS6HO5TqF4pVx9Nbzw6ktVum3odjnRLJLJnLFwCnrEldZILC5HIuoHtF+pJ5CRwuZlvc064EW2J4JbuQrjmci75M4+ky8Du9M+WJhJZGc/brTBkQ6OO/5HMnxI7bh78c/zTM43U314hovzYuSxtIyCJp+NNsyVNOs8wThgWIPNxk7ZV2d6VgouaYVEgGVepQR8CSf7/JNogAf6mybOuF+yA32zI3ylETMlBNJtroWz4X6isfvMKwd6Lio52vNbvkHtvb/h2coyeUirpZrqoB+rSsYhMJ2naRl3u/fgW6k9XsmBoTzNokLKAJSf59y56PWiv8a3aa6T0DrXWLMURyBrCOeWsD4PWm7dM2M9qGMrU2qJe4N25eOp3XTG2A2BMVkj/V7rhyuNbUhig10X7KojeS86uDdtns49XB8kufXviXhy4hTYDHOFv20kF5qhodg5uyl42w1HfgWxOHFdx4PZFuktQYuiPuFoua3Al8BbD5gLzJXH4ZOvcMem5oBK/VJpcO3XgcPqxvmFXZoDxQCnIxg+F7wvCOmZsU0DJWXpggov3J43RzM6ciOL9qVq/+DLnUvhW8mBG0Rhqdq2CNmHHrqSkMHPXh65l5t8kA1WLp5qA8blM4TlOvqxhW4wMB1pabpcJTG0+efNJlR0LPNrfsyQ8nFqk9+sD+beD7OI6XoffP0CCuhZKm2WFmBse5hpYJ4/iug/51VEsVEfsvJQNxEI5xl64gOCvZnXCU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR15MB4413.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(66476007)(66556008)(66946007)(8676002)(5660300002)(6506007)(6666004)(31686004)(36756003)(4744005)(83380400001)(4326008)(186003)(8936002)(38100700002)(86362001)(2906002)(31696002)(2616005)(316002)(508600001)(6916009)(6512007)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmdpbmZuZFVxSnprYjBVc2k1aWtsOVVzR3BRa29sb0hHeS82U1IwS0lVU1hS?=
 =?utf-8?B?N2VVM0MxOUgxWUxEYkxIMnJwWStROGNYMnRMeElDR0pqTTZIOWsrSWVuU1Vr?=
 =?utf-8?B?akFnYTgzVHkvNVMwNTFReERzUSttakhXVHpMMGZHOHQzMGlnbDYvZlVGdjFq?=
 =?utf-8?B?VE5ibWlCZURndG9YQ3NCaWUrSUJCdWYyc0NHd2dMczB6bXBQOWdFU3llUkRk?=
 =?utf-8?B?THJnRHBnSzFrYkZwQ2hvV0RNRkN4SmRPaXJEWW9FaFlzMkdNcFpsc0hNSUxr?=
 =?utf-8?B?Z0ZVNklsTUVSSW44OS8xWkNvZ1FXSFA3ZTNOQ0trcVhEMEhMdk5qRCtEVm52?=
 =?utf-8?B?NHdEQVdtNlBMdXF6cFhZMEFleVRNekl3L2libG1SRnBENmo5UDEwUjlnTWxF?=
 =?utf-8?B?a05zTFduRnJIOGdqdnBCNGZ4ZjY3Z0Z1WUoybW1OZFJYM2dFZEZrN29nN1Ez?=
 =?utf-8?B?cWUvZlFjbmFBYXREQ2ptZ3RoVjdqUWtaSmF2L3BhSVVjb21DWkNPajFlOXlv?=
 =?utf-8?B?VEpiMzVwYVhZb1BKTndxaGZUelU2TGR6ZThDL0x3L24zQTlGdEpnZS9WWm56?=
 =?utf-8?B?Uk9neHFEV3VjcVpqdHRTM0pqN05kNVk4UmRqK3Mwc081cFZEQVlrOXlrVzdM?=
 =?utf-8?B?NVZUZUh5dk9tSFdCdm5QWCtKWjFmNjdpZVEyUFU1T05pTzBveGN2MUVJaFlR?=
 =?utf-8?B?eS81dEhhUGdEU21mekNDaFV4NWJXaHdySWp2bDVjTEhIdUp1aG4zRlJmZ1ZU?=
 =?utf-8?B?SVpJNk8wTmNhMlZuWTJNem9iaVR6SEdSQVFGbVcyeDFIYlYvVFR0aWRIWFpz?=
 =?utf-8?B?Y0lUdW91YkZZRndnTmZrYmRibjFZTTFhNDAvNUtndFV0bVhwZWpWZkJ1dC9U?=
 =?utf-8?B?bWZrYWh1WXNoTGZBdlY3Q1NTOFhWa3BscGM2TXFhUXpnRXp4MXNlalhLRXgx?=
 =?utf-8?B?RjNlaFJyby84UVU1aTM4eG9vSnRWTEg1anJqRkkxTVBLNGM0bnNkdzNrRmVs?=
 =?utf-8?B?enVYWlNzNmJFUFRPbW80UGcwc2RDbm1yQ3VmWit0S1lONU1LU2tCYU9XeCsv?=
 =?utf-8?B?V1JDMExQWURXZWtyOE1QOTJhZ1ZaeTQwTUlka2NZYVFnKzBJUW8yU1BMZ0Rh?=
 =?utf-8?B?MHRGUGxXZFNaUWp3c2VmdlhMeThrejdRdTloTHd1OUhoTTY0RURtOTZ2MGZa?=
 =?utf-8?B?UUF3SU9ybmF0SFJlODh5Y21Ed2NON252NHlPRU5lSXQ2SGV1TEZzalB4YVlz?=
 =?utf-8?B?Q1lVeHUxQW1GSGVLQlRYMFBOdExXWDBWNEE2cTdBbzY0eWJhaW82Y2h2b09I?=
 =?utf-8?B?TnJzb0hVOGRQa0h0cFBJMTFCb3NjL3RqRUZZcHZ3YXFXcDh0TWFUbXduSXdS?=
 =?utf-8?B?clN4ZFF1UkFhSVE4VW50NXk3dWdicExYb3FrOUFzcU1HRisyRlhrWHJvQkEx?=
 =?utf-8?B?WW9PaUx0dUxzMmMxMHJHQTBpVGZJUVZkTDNTRzA0eEJPdkNHL3d2dGwwQlZO?=
 =?utf-8?B?YjBOOGd2SnVUUkVmYnNlVHJhcVhMWnJZenJhVVlJZEtFUlRtUkRDLzlBNjdw?=
 =?utf-8?B?dFRUci9UTWFIcUtiSTBPWE92VDZidnh0UURyVCtQZjkwS096S1pnV2t0Sys2?=
 =?utf-8?B?ekNMSmE3ZUtOdWVMQmJLNzMrOHZyem9GUlZ0Tk5rVnphZExDVWFDaEJ3M1du?=
 =?utf-8?B?TFMrT0F4N29HZWVXa3Y1OUdiUlFvQ1hBRGlGd3hFeU4rZzVTOE9UYzdJSTZY?=
 =?utf-8?B?YjFJdmM2Zkg3UWo1TFUzWmZhMDQwbThHS1VDa25BcEtoSExKT1ZYMUJJL3k0?=
 =?utf-8?B?K3VkNzRBYVIvbUpIYTI3cnFLTzJsWGVlcGJSeE5sY1F2MSsvdmQwakZkUWlH?=
 =?utf-8?B?QTJJbkxmWVdJajJOWVZwQzF1c0JONzdlRlNZWGFpQ1FMVW9sM29aWVUyOGFR?=
 =?utf-8?B?TVY5SE5sUEFBNm5zS2N6NnVFc1FTeHY1SnI0S055dVI5a2RQTEhYREg3UnZv?=
 =?utf-8?B?ZlFOcDJwdjBtZnYzWllBWkxnQVVNYW4yRnFlZ0YyWHZGcDdBR1A0bVBYWHRt?=
 =?utf-8?B?OUxhOEFRR3VvQlRjbGpiT2xiWDdLY0wwSStXWHBwYjBLd3BCMkN4TFFZUzJF?=
 =?utf-8?B?SXRaeFRUV2VyT2JRdWJMaSs5aUJuNFNseDV6bjRXQ0xnSml2MDB4TTQxV0hp?=
 =?utf-8?B?YkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a416376b-8a83-4a69-00fb-08d9f0afc864
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB4413.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 18:20:02.3606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vEsQ8KXDgpnzk24CjIqLPg9LUyxDMbl55t6UUk+++Kqtp3pOvBw/zp7aUxn8xKBw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3474
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: Vp8Gp2SF12ruL6xcEns9J6bY2yKcPp95
X-Proofpoint-ORIG-GUID: Vp8Gp2SF12ruL6xcEns9J6bY2yKcPp95
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-15_05,2022-02-14_04,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 bulkscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 lowpriorityscore=0
 mlxscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=670
 suspectscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202150106
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2/14/22 5:15 PM, Al Viro wrote:
> On Mon, Feb 14, 2022 at 04:21:20PM -0800, Stefan Roesch wrote:
>>  {
>> -	return do_statx(dfd, filename, flags, mask, buffer);
>> +	int ret;
>> +	struct filename *name;
>> +
>> +	name = getname_flags(filename, getname_statx_lookup_flags(flags), NULL);
>> +	ret = do_statx(dfd, name, flags, mask, buffer);
>> +	if (name)
>> +		putname(name);
> 
> ... and the same comment goes for this one - getname... does *not*
> report a failure as NULL; it's ERR_PTR(), and putname(ERR_PTR(...))
> is an explicit no-op.

I addressed this with v3 of the patch.
