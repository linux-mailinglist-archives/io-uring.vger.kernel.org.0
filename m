Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1CD46444F5
	for <lists+io-uring@lfdr.de>; Tue,  6 Dec 2022 14:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbiLFNw0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Dec 2022 08:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbiLFNwZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Dec 2022 08:52:25 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E792A96A;
        Tue,  6 Dec 2022 05:52:22 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B6DotCi016969;
        Tue, 6 Dec 2022 13:52:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=bR2dVZehYECQPaAqnmMZnoH72EcOW7AVYzZfrmVbPnk=;
 b=osXCbVs4Zpd87abvu0cRA5mhpFhJx+GuhA1W88BiqUNZiHf3lKGA5+budwnah7FsbhyW
 qn7tG1Y9J9nP2QwZv3XtOgStgUpKBU77We09voSTqQzVOD2cfkWS5xBYL4swGLKdrNG4
 GJolP7Gnbvd3yapaznoCqA5yfnmItZMv//DY/q/q+xeLY2emHCsSB7+oEOJO5EBYeEwr
 WLxQIS37dLB2tp0mb21MY2AbhlCWp+SzIs06SeI7eyjVpaYW8gp96jv+12a0Ot1lqvCg
 yH9lLA2nAgN0dgGS+ABXEK8q4oNQRGChxGhL7nTBYzlNadC98aZME/mFiYBtEyEeoapW 7Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7ydjfnsw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 13:52:18 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B6CMEqV001299;
        Tue, 6 Dec 2022 13:52:17 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3m8ucf4sd1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 13:52:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lt8Fbu7roDK71ON5on0+wxnYj3dOe7v5RrS2mj/VIMmN28UelhHjFL3kjk8ZWNqV8an0vYKD5WEIMscPmgfE440zlynE+9B/bl45rPjbWy2CIPMNQUJL7hpjPKItpiR53SAXvLfDBqi1PttFYm3MHlXcug5RWkvXhEUQrhRJHLG9xrcK9qlJmfuTenn+creIj5ck9K/ntEaRpV/Ef78g0J00PfXbLpjnbzB6G2Nra9iG6ROMJCPFU+P6Gbid76C8PBj8dG/hhg0eEE3MQYBrWz9Mw2m91Ax1MhAkzZzuK+8JspF8FKZ/V8nKiUCdrXgl3fjGrpLjN5pLVPUXhY4NeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bR2dVZehYECQPaAqnmMZnoH72EcOW7AVYzZfrmVbPnk=;
 b=fXRFFRrR1EPCEq8h5T9LE9BrRjNFkROzLADVWNmPnSiPgtaBDTfQQqsOV08Io5aLTJbTFlcVKzrgBRh5inIzpDmATQQSybcKwXcuBZO+GU3kaMumW9NNPaFdyj5BqHlNP0u5jTeebBkTLqN9BCR6zE605RLhL8enjWkvlaXFniXZVpK/HHxb8D5dz8CFoZhC1Idzv4H6QxCsxsFQvicHwG19m/Y+bdnXdKAApNVoD1qY3QLUi6tgAKHCbOrrHFAx+/sXHWLM14D1YS7NPrzfKtQwwt10yJVBe4HWXD796T7NbAbLqnt2iaQfDzaKam6w96TLMT6DqNq62OgWSLQEFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bR2dVZehYECQPaAqnmMZnoH72EcOW7AVYzZfrmVbPnk=;
 b=kcNhDdHZ6SE+kHHc08KBwc9Jo9yzMA+3rvCKXjN/msKyopnR9MZp6xCT436q6e3fpzq9NY6eNg8zFnpd6wLXx9Vm323uaiaKIB58ZkagCQ2Ydvq7XBiUSo31gmiSTTHeOOWUPrZuUmxjhb3GAlyK6wseFxMp33w9Ft8f3279twE=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by CH0PR10MB4939.namprd10.prod.outlook.com (2603:10b6:610:c0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 13:52:15 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::4dd1:d0d0:e361:aed]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::4dd1:d0d0:e361:aed%8]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 13:52:15 +0000
Message-ID: <dc288698-cd1a-9068-63d1-ee2efccf59ea@oracle.com>
Date:   Tue, 6 Dec 2022 14:52:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] io_uring: Fix a null-ptr-deref in io_tctx_exit_cb()
Content-Language: en-US
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     harshit.m.mogalapalli@gmail.com, george.kennedy@oracle.com,
        darren.kenny@oracle.com, syzkaller <syzkaller@googlegroups.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221206093833.3812138-1-harshit.m.mogalapalli@oracle.com>
From:   Vegard Nossum <vegard.nossum@oracle.com>
In-Reply-To: <20221206093833.3812138-1-harshit.m.mogalapalli@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0039.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:34b::8) To PH0PR10MB5433.namprd10.prod.outlook.com
 (2603:10b6:510:e0::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5433:EE_|CH0PR10MB4939:EE_
X-MS-Office365-Filtering-Correlation-Id: 10de286a-a077-4d41-aba6-08dad79114f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ybw+qP5GWBACT7nRN2/HWFHYTNqOG1VxfTr5FZhyeIpcmvfmiEUeGAZYLnXyeNljkWX64uNifS+AnR+zKSvOPZpzzio191oHRQ/5/ruvwCVHvawSNioSaoRlwkmK9k3mv25UgIBHoMnd8lvX+20nrbvay9hxL0069FNwaEkdQ+3W3F37GV9aVdhCGTrsPdkXoVkbUSiNrBgsCMjQWhnOwTcSP1QNHwgwUpusWx/DBj8fdxFEYgd2MZVZD7pvijHaIdhla0CLFzdfzZHAoCcoeT5ozFC+eD5pm18akFtQReugzjKTajDHRy+5f09SuPbIBoJ19dn/utt/kt3z7DpPNDsngsUOHa73J7zvt1/DhPUTczDDyUKyOWrgnD9qKUNuhE8UcA513nCSqqIixKePgRpsNl0BtTrzyMgy8cpnAYU6A8oUR/D3koDk1fb9FPyKQowKRVXU0qklQ+oN5FOiu6OKteNhZqlF4Dr+5cSwQPJjqbhjG3KQ3U4dZrhyPh2m7ZnZYdjM+68lBeBKS92fJdi0wR7JLCb05VTWtqa02eb5mHGdC3+V/gl7jY9nrfd9eudAmo5LZ8And2ooh5d85TmT/plOa/av1eAUFDw3rrBdJqC3qT1//nEk8RF/o3DVUyg9A0o+y83+m0iZy5CMGtJbFBQs7+t2Y6ZfnzCWKctLqA0dv6x6oo7iv0t+Ktam+4HhV0YsR474+0/7f9zgo7tfssmdedcO4n83Cafxy7o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(346002)(396003)(366004)(136003)(451199015)(83380400001)(31696002)(86362001)(8936002)(44832011)(5660300002)(4326008)(2906002)(6862004)(41300700001)(478600001)(8676002)(26005)(186003)(53546011)(6506007)(6666004)(6512007)(6636002)(37006003)(2616005)(66556008)(66946007)(6486002)(54906003)(316002)(66476007)(38100700002)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U1FkUHhsV1BjVEpLOHN2Mkg5SExLK0o2MDd1MUVrbWEzZ0JVbjFkUVMrU1ZW?=
 =?utf-8?B?WUJIN2xXdldOUWVQZll6YkRlWGdyUVNSS2VySkcyL3hTYmJMMjF4OHg2QU9u?=
 =?utf-8?B?TXFhSEpnMGs5b2xEelhhaGp3TlFuQnVtVGkvcFM3OWNScU1NN3YrUlNuZ1BS?=
 =?utf-8?B?M0x1akVDT0tPeDVMYlpjM0NLdDhGbExqdnpjSldhTHlXdmFWcXk0YUs4Ui9J?=
 =?utf-8?B?b2xyajdaMXdUQWNIa2MvTE9xMjVaTlNOTlBxTnAvTks2SXQxM1piVVdGVUhW?=
 =?utf-8?B?UUNlU2poUmNNWkYwM0w3V1BRQWZqSEl4SEZBYVNXQTEzVFRrNDhPbkUvKzhC?=
 =?utf-8?B?UHJsbDhIcjlLNVpsVHBMQkNxNG5rQVloR3lMSkhrSHV4SVZjR3R6dVJ4cnNL?=
 =?utf-8?B?UXlTUzRJWVlVSVVnYmhMeDNNcXZHL0pYeUg5bGxkOEpTTGpNWWQ4d2w3L3F6?=
 =?utf-8?B?czFLV3NCWTF6WTVHbllzZHJTWklvRjM0Yko0U29USFFMT1Q1bkRodXpRY0tw?=
 =?utf-8?B?NDB3UW9takF5eWdFVjV2OWFubERTQUtHWURYMGNFMmdaaHZ1UVhVNnpvK3Zy?=
 =?utf-8?B?Y1RDN0pRd0FsRThxZGdvOGNFL2I3b2hPQmRZWGw1ZWNyQSt2Zlk0elM3ZkFv?=
 =?utf-8?B?TEk1K092TytWUnJoQSswdk9GZkJ1TTZlU1VuTlBSZVNyelQzbWhpbDZyVjFF?=
 =?utf-8?B?dWh6cWovdVY4TTJDSjIxRjRDSGs2UDZhRWg1Z0FBZkZWSUJhZlZ1Q25VWmlJ?=
 =?utf-8?B?SXlnNms3bUdtVWJNK2JkQmdmdXRxRVZ4SEwwSmZSZ29EblRsdXg2WkVLejNz?=
 =?utf-8?B?UUNweW5sdTJoUlErdTFtQTlyTjExUDIzb0lOUnp5VVIzQnhPWHllSlFkdHhk?=
 =?utf-8?B?eUo5M1NHZjJPTldKTTcxcG9uVVhMZlR3eDR4emdJSG1CRjFyWUt4dDY5WTV6?=
 =?utf-8?B?U0x1dXpYZjY1WG1NYktiWU5wWlNGOFZtVG5BeGNsMFFaa09yWG0rZk9zUk91?=
 =?utf-8?B?dmJ1MlJyeUpWMVNDNU13aUtqTmhDS28xVEtXRHhWNkZZNjF5SENFbGdhcHJm?=
 =?utf-8?B?UGkvVHFjL3JaWVdWdThvOFhzQjc2eEttd1lNdVd6M1JaNlNReGRqeWdoKy9z?=
 =?utf-8?B?WGNkWVRSbXZsZFhaQ0dnRHU3MFFaZk1mTkFuVEhDQTVVekd4bTRIZlJzZ3Jx?=
 =?utf-8?B?SUgwK3lkdzdETUU1bFMyUEY1T3NUZXIxTFZuUWZCRm5ZY1ZZeXJsbDIwK2VU?=
 =?utf-8?B?c1UxUW1sTGhvUWdpaFFMdGZCMk1ybW4rdkFrQmhvY1Q4NUpaRjd3cTFPMThR?=
 =?utf-8?B?MVRWS29rV3pscjhtdWcrWnBML1F2QmxPb05hTjdtTGhTR2JqRlVRSy9Ed3NU?=
 =?utf-8?B?YTNqaTRPamtsRDZ6djFtT2RIMS94SVgvTDR3bzNES0FaS3dXUGtlQ2k4VW5s?=
 =?utf-8?B?allmWStWRk5QMC9XZE5zV3d0OEVnZEpIdjUvKzZ3d1BCbGoxa25HLzI3U0J6?=
 =?utf-8?B?elpONEJ6S0gwV2VXNnVNTnNHL2JwclZNNEJhY3JwOHl6Y3grdWRTQ2VWWlBD?=
 =?utf-8?B?S3BSM2R6R3ExeDl3RmFUQW55Z0ZLdldpbG9CdldGbitZdVhoMFdTalY4WXJY?=
 =?utf-8?B?cDYrQ2dQMThnRnd6NSs5Z3hPcEJSL1RQeitiSlVGL2orcFVIZC9MbEZWTkxY?=
 =?utf-8?B?L0ZjLzlIenNhbUlra29oSUV1bW0rZXBuVTFBM0xKVDRYZnVvOVJoMm1Fb3VP?=
 =?utf-8?B?bldYMnI0N0VsRUtxeXkrWVVSQ0JDR2FtcE16cVYwNmtZaFNKTG5EZnBRaEtE?=
 =?utf-8?B?a2kwRklLTkNRWk1nUXc3a0Y4TTlkS08raGdaNWVtUnVSL1BwWkt0aVFXS2cv?=
 =?utf-8?B?MVU3SmJLVlFXRmcvd1A2NTErUExwZ3VVeHhPWlhRODdqdmEyWE1GNnExd0M3?=
 =?utf-8?B?ZFcvMnlKRFE2WEZ4S21vZ21VUmwyeTE4NVE0M04wZXgwTGdEeDFNVEx3cjFK?=
 =?utf-8?B?QkVYWk5CVWVHS3cxMXM0emtQSURQTHhFaSt6aStJTXFjMmhKRnJqMEwvUlZj?=
 =?utf-8?B?aUZtVXJIS3JEWXltYUdZV0VpVkpTSnVkVVkvOWw5NjZvcVFYQXhpRkh5aVcw?=
 =?utf-8?B?ZjNFUmR0alRvVXVYYXZNVFhSUHQrUFhOZU5HS3NYUm50NnVhM3JTS1Vhb3NF?=
 =?utf-8?B?aVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: cqtf6HiMT2DlQ04loJL0qz+1wzCux7w9xlajNtLCkGcSnTrx31KGoCLQKnkEoMH9s5nXabxDcrXgfoAxyHWzJHNJuDvGPUiqVLlo40poPNVirQVZddHIGCm9Rw47R22k6lFIPfj/2p2v+FqtzjIKUFlhTmQLQN3uOJnMdDXsVF+pfqy6sNQI6Z468Mp1QIS5kfRbaQM2OjlAj/zlTSQWC0WzNlU/cSI0Qhr1Lf01dEJZq82d0HgWrV6uHzqnAnvS6N7Bszt6zy368RXcF1uDg0u8NCjcDFqjlKatM0jcRpTYva8Wiipw11DVUiP9yEFLGhLjHdhs7krAbcgX8n7rWkbVU3FWCveVnx6XVj6vemt+Ucb03Zb5ulk175ANCa/5iJ24QG8nWRgLIKzZMtJ+oLT4TgLtFLtyKQxGMaz9tOROzq2jb9mwq1jC7BiN1daMyKtKhqU1B37daqrhE59SNFG0uZaHt0sLBGQPaIDJphglFIvPEYFC34A/jPkQRP3eP/449jgSJE0VV3hqDmWBWXcgJZFUGlqOUwpNm0n9GxOSdCMwtM3+edE83kuqK0o//r4ZjFWdT+jZzmXdPY6KqiwLn64XK14Y9x0gUoo/J2iECUA0k2cDPjN/2goLTIqTJAdXaqgZ1s0VB1gxuMq9GxBtXkmOF/KXDiorgQg09QQf8HqQEXJcXDVblbDYZWr2TlBZbe+rSJeArv8zfAilDFMWJ+RLr8McIaot9YKt51yJ3pkLLyKmhm5tpuIFEALcrdkf+FwN20Wjj/c8Mk9A5EHPBDWDPcw6HiL6FrnZugit9+ZTcY0weW/dUcrQuQcRCcYXsl/89IAapk/HLrJfcXp7IP5kQ6Gtx3Vc/HC1IgyySAKfki57kWytVUyeJ2xQC5PIgDRwzTN9BcVcxyLlqRK1IgdXL2nH2g+4CeCKbpI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10de286a-a077-4d41-aba6-08dad79114f7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 13:52:15.1333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SyLJBjCHSAfnQEt/NsF6bvQeGriHJ/N+b2w1taYuhEBPgiZvKtbGQpLO4KfHPcWLqjrYf+uq9RQUKSctcE3SADZdWD2NT3DEGBY8fxc9V4c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4939
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_09,2022-12-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212060113
X-Proofpoint-ORIG-GUID: rd-ADXQjj88tjiEL1RuRhF1aCt2XAJpz
X-Proofpoint-GUID: rd-ADXQjj88tjiEL1RuRhF1aCt2XAJpz
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/6/22 10:38, Harshit Mogalapalli wrote:
> Syzkaller reports a NULL deref bug as follows:
> 
>   BUG: KASAN: null-ptr-deref in io_tctx_exit_cb+0x53/0xd3

[...]

> Add a NULL check on tctx to prevent this.
> 
> Fixes: d56d938b4bef ("io_uring: do ctx initiated file note removal")
> Reported-by: syzkaller <syzkaller@googlegroups.com>
> Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> ---
> Could not find the root cause of this.

Hi,

I don't think the patch is correct as-is -- we should in any case
probably understand better what's going on.

I think what's happening is something like this, where tsk->io_uring is
set to NULL in begin_new_exec() while we have a pending callback:

fd = io_uring_setup()
[...]

close(fd) ?
- __fput()
   - io_uring_release()
     - io_ring_ctx_wait_and_kill()
       - init_task_work(..., io_tctx_exit_cb) // callback posted

exec()
- begin_new_exec()
   - io_uring_task_cancel()
     - __io_uring_cancel()
       - io_uring_cancel_generic()
         - __io_uring_free()
           - tsk->io_uring = NULL // pointer nulled
- syscall_exit_to_user_mode()
   - [...]
     - task_work_run()
       - io_tctx_exit_cb()
         - *current->io_uring // callback runs: oops

As far as I can tell, whatever is happening in io_ring_exit_work() is
happening too late, as task->io_uring has already been set to NULL.

It looks a bit like this is supposed to be handled in
io_uring_cancel_generic() already where it tries to cancel and wait for
all the outstanding work items to finish, but maybe that is not taking
into account the fact that the exit callback is still pending? Should
io_ring_ctx_wait_and_kill() bump the inflight counter..?

It's unclear to me whether the io_ring_ctx_wait_and_kill() call is
coming through close(), dup2(), or simply exec(), but it looks like this
could potentially get delayed (from the current syscall) and thus pushed
into the exec() call. Maybe flush_delayed_fput() needs to be called
somewhere..?

Anyway, I could be completely off base here as I'm not really familiar
with the code, just wanted to share my notes.


Vegard
