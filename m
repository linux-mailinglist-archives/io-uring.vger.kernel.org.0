Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3374B9028
	for <lists+io-uring@lfdr.de>; Wed, 16 Feb 2022 19:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237629AbiBPS1F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Feb 2022 13:27:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237621AbiBPS1E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Feb 2022 13:27:04 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5534524F37;
        Wed, 16 Feb 2022 10:26:51 -0800 (PST)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 21GFiDkX024056;
        Wed, 16 Feb 2022 10:26:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=kkI4SICX0TRVmVPYuv1VN5LpsOWuHDrCvxYKfI55rN8=;
 b=U6dbXwEN4lTSMTYRejzxRzF6bputNp07PnsY1BpJxl0tWM/OajpHKcb92hVmV3uW2N9w
 mnLkY2Vr63DO3APyBnvScUcPiG8C0P4ycEpM7a38KXIKoOzj8EY5mA7LYf178LXYvgvD
 /oqJ3H/M/eCWz9qzjCXBsGO/auvHhe7tiPQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3e8n41ph3j-19
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 16 Feb 2022 10:26:35 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Feb 2022 10:26:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CUZ2VBD5e0lpjTt3Od0gEOAxU0E3nWHoPEHBCG3KNeDg7Unub1Py+asOGxpoTsxFrw09MOSZXPVkR1Dfyt6sNT+qI5Xoni73bP3tL2SSKiECWZ9VWXBdhgEn9PlHnktCc6gIqOIo5EYL6fb96rlTjacMh5g/cqQmdboxWd8cqC60RnDQ8ESmGJa8Mn/Qxp4zIBZvijM+ygBwbBZ1uxWI+HigceqpO1wcSxJ6ETkGC1qP0cEyflHDM4pnRqakuX115HwJz7HysP9ad65j3v03VASwoNniaBRZqzuO3foCMnH+/tpeLUe9FugQpD8qmA42sVXJeoKqe5T3bSeQXrrHgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kkI4SICX0TRVmVPYuv1VN5LpsOWuHDrCvxYKfI55rN8=;
 b=Z8hdRg/X30KMqLqFG6+x13AxHojfPD41OccNtzPZdmUa8oRyFuP6+RbngdXjyjTZHKWKyWKwKPm9b7GxKup3D5XilOpkkRi2ljwdvge2PGUE+t8YFsAe4XDYgBCQ2yOcBy7crAeDNkemn2l8vcPvPdHcVVDtttUhF1bQIt296ccNjmvYltfyIvIfYut64yuHelCF13dO4h9zd5fNcrN38xUCnZv4F19nehP0VhQktV+xafXG7zk13FR778X8psD+E398jNxkbloMGJ/2t5W0fiKkM9BGgWSxB+xxcSQl313d2SeCiQqgZzXN4znwpjrwUFnf+g5z4uV7Sq44C0EEhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by DM6PR15MB3959.namprd15.prod.outlook.com (2603:10b6:5:295::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 16 Feb
 2022 18:26:31 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f06e:4aba:69a7:6b91]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f06e:4aba:69a7:6b91%6]) with mapi id 15.20.4995.015; Wed, 16 Feb 2022
 18:26:31 +0000
Message-ID: <bca8a1dc-8366-fa19-4edf-819ecbb8cd84@fb.com>
Date:   Wed, 16 Feb 2022 10:26:29 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH v1 03/14] mm: add noio support in filemap_get_pages
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>
CC:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <kernel-team@fb.com>
References: <20220214174403.4147994-1-shr@fb.com>
 <20220214174403.4147994-4-shr@fb.com> <YgqucLAFESyBSD+G@casper.infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YgqucLAFESyBSD+G@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR04CA0053.namprd04.prod.outlook.com
 (2603:10b6:300:6c::15) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96614cf5-434b-41d4-fab4-08d9f179da68
X-MS-TrafficTypeDiagnostic: DM6PR15MB3959:EE_
X-Microsoft-Antispam-PRVS: <DM6PR15MB395901DFBFC1919EB7308692D8359@DM6PR15MB3959.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: awSw59TGylP4DTCiWfP8QC1SMWBSeGf9j5u4OUbppPS3BMpaNC2RzlvLXigoTtlV2Epgx8SIiztKANrLeI1mLMrq8x6h9MqKtFT3C5Iy9qET8FaCpccq15Lduo5baHLsYGkYjyKY2VAZIaVaPRafAyUJTuyInCiY9cZHPXFWmne+u5mzu/OI0+8ebfGH1iBdeYUfAH4FOAADis4ds0x07awtIWfHYSvw3rGIQ6sDIZepYe4eNQwOCdh4YF2tzUlRaSnN0bqBrmUijy0j1+/drXdTR5Q7sj8eXpPPthDXRL1XBdaUo5zhKbfJNfKjrv1kDFKEpDO0uBFACFC28+H35IjEJSaeMQzevF4ostOQLfYqJ9GHsN3gfFMWu8aWQjBMjCNHcOtWqRpe+vbrA/kLQXTyS8POpDaBJCQtkJssQC25DYLR9KKsOhoA6K7NMFzgIh6ijbBr7JXFeoJb1fQKRpYHUXB227L0fScedRkwJK5b7hg5pKOExbqpjUhcoPWHJlnjCV+UW09MdfiKXUc6oPP3FoRVr+Xp3BEmyihVyNT1hVugK1jVCsBPyO8JJnkNPzKr/tpNQwvqRRtFX4ieD6JlzoU2ZavMY6rKDGBWAFX0oV7s9NifcOqPX7Ve7aKRlZ7mhtMmUZzuiRN0KLzBFdG/LLhCE+lKcbeWQu0jA6SI6ItGY7ZOsNaCmKr4CMqZBr+ryXX3pIZ0iuFPee32Q1xhdYPqOvd6OeGXtEkrx/U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(66556008)(66946007)(31696002)(86362001)(316002)(83380400001)(6506007)(6512007)(6486002)(508600001)(38100700002)(8676002)(4326008)(66476007)(53546011)(31686004)(36756003)(2906002)(4744005)(5660300002)(8936002)(186003)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YmlabDEyUnE1R2dzTHJjK2g4ZVdpakZKNHZwRVZMQm1lUVhoaE1yZUN1TG1T?=
 =?utf-8?B?T1pjaGFxcnhaQkliUjlDRlRHY2FpMkF3aVg1cHBqVWEvTk03Z2NnOVo3OGI2?=
 =?utf-8?B?ODVsS3RkV2crOUF4MTB2UWkyMUgwaGVQaVoxRXZUb3RZdEFIYmtNRmsyVTNR?=
 =?utf-8?B?SUlKOWxSWXR3SzlyM3BCRXc3M08rT0xiWWIzQy94UGVOM0h3YWFIUi80ZDJa?=
 =?utf-8?B?M0Q4ZUVGK0tqWG9ybFEzVlZBQlZBK0Nwem4wVENHL3FvLzlFbktGbE1zSTRl?=
 =?utf-8?B?Q2R5RUlxWlArTU1GM210ZHhMTjZoV2ZGZ2RibkIyZFIwd0FMNUZrc3FETmds?=
 =?utf-8?B?VUNYSXZ5dnBCMzkrRkdmZEEzZmgxVk5oV3NRYnVvcDJaQjRkUlFGcG1YbThD?=
 =?utf-8?B?ZDExTHhUMDdMcWJOQVl1Mk9iNWpQUWZ4enJlTGJmcE5EOEljeko1L25qNkN6?=
 =?utf-8?B?UEFKb3Q4c2ZWQm5STXAxOCtWM0Yvd1pEUnRYcWxxbmdvZnNycXUwNlFnVTFr?=
 =?utf-8?B?L3N1Nk5LbzlzOFVPQWwrMFJERDZSUHozTlBQcXdPdUxZUjRMZU1RbmtHNXo2?=
 =?utf-8?B?ZXo3UWk3YjEzb3hTNE8xcUxqeGxWSUxpaXY1ZFJZV0NzeDl5UnA5Q21jWFg2?=
 =?utf-8?B?UDRIbTBIZm95Nnp5WGVmL3hhN3NmMkVqamdOUFRzSUZiTUlZYWd1MnNrRW9J?=
 =?utf-8?B?a09hV2hWbG5qemJaeEtNWmJUL09KYnZJOTNKYTFJZmgyYnhVeDRXdk5acFJp?=
 =?utf-8?B?U0JHTERoWFJKcncxT2tUUEF5MXJJdDMxVUo4YTFyQ3ZrQjF0UFRuMmJRd0xN?=
 =?utf-8?B?NTBQUVNGYWZRdFo0a1hhNDJldnFmaTh3MmVFMUxiNURNWjNOZnVBWmRvZHJt?=
 =?utf-8?B?alZiTVZjMXhDQmhza0dyL2lXNDc5cWlnZHVHM0QyUEFhUEZwMDFnemVUUHhx?=
 =?utf-8?B?WHpiWXYzM0tMUlNYWTlySERwNWxMZi84Y1dESzNLZEFuZTh5VTE2V0V3c1Ew?=
 =?utf-8?B?U1laaUxwMHBLczdCcXhveTh5VmVyK1lsUDFkaDY5TEFwZENJSVM3UlQwZFZ2?=
 =?utf-8?B?V2krNDF0SWFOVWx3SEF1Sm1ySFJwQmwxNlg0OGdXUDl3aFpVdW1Ub2gyU1ph?=
 =?utf-8?B?YzVUc2h5M1NoTkhPUU14dytub000Vnh0dVJCSE15c2NGbUhNdndvTW01eFNr?=
 =?utf-8?B?enZmYnlMSmg0N0x0SVlYKzBUS3NwdEh5cDBWMWtWcVY1SDVzd3pQWlBOdGtB?=
 =?utf-8?B?ajZoS01kLzZpaVp5Y243emYrc0ZyVkkrbitWRzRRWkNMcGZkeTc1bU9JcE1R?=
 =?utf-8?B?TFY5NFBHdllPVGwwWU1CK25rMkVjZmVSREwzazJabHdzbEN2MXhsQXJ2d2Vn?=
 =?utf-8?B?NVlBdEpXOWxNenJkc0lpZWtUYWhXSnlqQ2ZEUE5mTUVGd0xYUTQxWXhtaDh5?=
 =?utf-8?B?QmpMSUt2Z2FNZkRyZmpURlpZQnNyZnArOHppcDcycnUzL2c4bGVoWUlqd09N?=
 =?utf-8?B?Qm5OUlkzZkpQemJsa1lRd0oyS3BvbDJVM1dyV29CUlhuS0lGeWhROFdxb3k1?=
 =?utf-8?B?OUVFY1lJTCtqQWN3amt6ME1tNjdIdTNVK0JTb2NYMEMvWGRic1dXeWtEQnFY?=
 =?utf-8?B?TEdLOHdzOHhhVktoazN4QlhIMGZxelBFdkFadDJyd0Z5eXIrcjJNRW5FZ1c1?=
 =?utf-8?B?a0QybXhPa3pZZEtxMkFLQUptbHIyRHkyVmhwVWtDZGZIcG9ydkpsSFVLQ2JJ?=
 =?utf-8?B?WU9Tc1ZzdExIZjYvdzBYRkI3ZXExcFU2bENWVEVqN0xwWnBxQ2t2RDZYOEw5?=
 =?utf-8?B?RGxlUzQxQUVXRnprYWVBcVRwVU9KdTRybXh0S05Zekg0akhaTmVNb2JIekRu?=
 =?utf-8?B?d2tKYWU2TlM5YVp2eW83TkZPV1hlZ0lhMkNSWmN3SXk0d1UrSFdXRkxMY1B3?=
 =?utf-8?B?eHNXUmJjSm5RWWFtTHFMa25oSGJXMm1zSk12cHZtcWVPWDUxMFAvQkpWRlFD?=
 =?utf-8?B?dGRneGVaYVZER1RBR0FFemVKUzNFcS9KdzduUVg0bzk4SW4vNzF1UG9iUjgx?=
 =?utf-8?B?TmI0NG90QUYxNXpZNDNDMFk5dHlQTFJKb1N6ZVp3MVZId3VVUEY0TksxbmM2?=
 =?utf-8?Q?7Mv18eSRigxIihVHztle/R5ey?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 96614cf5-434b-41d4-fab4-08d9f179da68
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 18:26:31.2128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: caVgEVKhcfyHld+ogAH7cIrzcQHf5tVSGfJfdu+fR6sq7kzUQeSozaembm9oHgqx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3959
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: OHXkCIX52Ugn3Ua8-tj9CCPvAGtHbE4n
X-Proofpoint-ORIG-GUID: OHXkCIX52Ugn3Ua8-tj9CCPvAGtHbE4n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-16_08,2022-02-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0 bulkscore=0
 impostorscore=0 clxscore=1011 phishscore=0 spamscore=0 mlxlogscore=762
 adultscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202160103
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

This patch will be removed from the next version.

On 2/14/22 11:33 AM, Matthew Wilcox wrote:
> On Mon, Feb 14, 2022 at 09:43:52AM -0800, Stefan Roesch wrote:
>> This adds noio support for async buffered writes in filemap_get_pages.
>> The idea is to handle the failure gracefully and return -EAGAIN if we
>> can't get the memory quickly.
> 
> I don't understand why this helps you.  filemap_get_pages() is for
> reads, not writes.
