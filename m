Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4091E467BAC
	for <lists+io-uring@lfdr.de>; Fri,  3 Dec 2021 17:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382158AbhLCQok (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Dec 2021 11:44:40 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60516 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1382161AbhLCQoj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Dec 2021 11:44:39 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B3A98Tc006301;
        Fri, 3 Dec 2021 08:41:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=cHN1Fk410IVGzEAu/UP5SliHLZAmhXp58W/dV4+vaIs=;
 b=a6AuqnLvTcuYZMoWK40s9My+L+MdKeI8Q+Iec1QxVEaXS1hrRSw5tmwpcXaKlOHDpfSG
 DboZK0ygaXNlj0yQAoVspaD94UHIS7qYk9lNuZc30ZUBhvCEMHr4nN3BZeB+CXXs7jx4
 v034whynZJW96Ha2qzELxQZkhTcw7LGVkIc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3cqh7ptktf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 03 Dec 2021 08:41:13 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 08:41:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cY2brwjCe0+zLacIfBmUfdzocByo9sosMImVySXqZnVAIJ53BzZLg4pLsQMUo1qeAPHSoEkQG6HtWJ1hyYGilHfYlOMqEncnF3u9nXGxsJcftURZRPjbJC+z6BkzJh2n048tNoacryPLcphNeLCrln/3XsZHx+JYzQbZlFxkwJawDVY+b6fPZCsI9+unUpulzH6tZzx3rZzrVzrdVFp9zU1gy1DCb1ubhzy+BYNbg87XNrwqSc7d8QRTgDywMMv+LyvB96mDw/yj/ZTmAh7WfIAgQlR1uLdj9T161EsfHZMlkwFr8MwU0TIO/oWbrD7fuONfscatjxqPZx3fxogBxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cHN1Fk410IVGzEAu/UP5SliHLZAmhXp58W/dV4+vaIs=;
 b=jejatdHA0bFz5pCKMLqL2CLigOHK31OUH4vn0EwluRsvTJloyZqh+NBJZuU/JOH4Q77qDf5nTRRzslVO7qro2KnlwD2j44a3b4dum15FIyqMOpc4WOVqkXxv+bxg+6NL6ppjSHGC4oPVuDN6zc7dAr20MSCr5vFUT6jTkhWXqS+zGKl+JOL2v9AY/WYTSp6oXa+6DjK8v+33C+nFJtc3BtEpQTNfSynZunx9cF0WmWeZaycNFYLBPaFXjbLb9UgGff5Ii71LZJJIGMgATmclJIXk7HImNAF3DNaApazwD+UY4g9Rzl3pDb+wRohNEI65k6KAOElBOIs7g9DTUX5zWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by MW4PR15MB4777.namprd15.prod.outlook.com (2603:10b6:303:10b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16; Fri, 3 Dec
 2021 16:41:11 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f8de:1089:be1d:7bf]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f8de:1089:be1d:7bf%8]) with mapi id 15.20.4713.031; Fri, 3 Dec 2021
 16:41:11 +0000
Message-ID: <5ac261e2-f2fc-c98e-10c3-e94b822c4acf@fb.com>
Date:   Fri, 3 Dec 2021 08:41:09 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH v2 4/5] io_uring: add fsetxattr and setxattr support
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
References: <20211201055144.3141001-1-shr@fb.com>
 <20211201055144.3141001-5-shr@fb.com>
 <ed683410-92bd-fecf-c52a-32c865b13ae4@gmail.com>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <ed683410-92bd-fecf-c52a-32c865b13ae4@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0264.namprd03.prod.outlook.com
 (2603:10b6:303:b4::29) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21d6::1400] (2620:10d:c090:400::5:8022) by MW4PR03CA0264.namprd03.prod.outlook.com (2603:10b6:303:b4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend Transport; Fri, 3 Dec 2021 16:41:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21fa35d0-ec55-4c6f-596a-08d9b67bb697
X-MS-TrafficTypeDiagnostic: MW4PR15MB4777:
X-Microsoft-Antispam-PRVS: <MW4PR15MB477745082C4C5C17214FF55FD86A9@MW4PR15MB4777.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pksj7/04Z6MNJCPOERxlxWpHnVFBK65q2WXlNv7TcWIRxYFut0Ee0oJKjXqlmCznRSDJVnLI0hc8p2Z77rUMAoEV0NSQIYZsl91iqU1E24BnoPRH/gTIUMLE2VnyirZURpWWp9LNO5fTA97UypeELvXSd+yRw3QJ4Gyz3heXaVzVDwHQCK6wwVmHx4Gz/7jzqFVCXjgdGkd/Q6mrCKZa1nQ3KRvT8/cpxUDbrmNEQy9e9yylifcpTUh/UaxQ9vQW2yKbV67AX2ueEO3o2alUuvs4qPTmgXb7uDo5qBY4KyXgH8WhosIKDM2YwYKDIeJDG1wY7bu0KpTFY/3sSlFRF9XL99wZQ5+jzdFG6fJmb7Bh0umAM/JObpEQmKbY5HWPeUd5Y9wVJJH4grYndWFuJhdOwJbDEIOfQPRQ0mxPE0iKMuJThqo8hsxCORWsGCjG+x5MBOnHgt/a3W7F/4yomY5MqrUnwNBFeoGm+qNvZ4Bi79bWFpY4mzgnW5QvceEii8rpTd0b7eBh5OcKfF/JKd+kFRvJMwIlD42V8ZWF7d2Yr5FLg4mZW+LNASEKcRGfx9fZL29XsL6bgqjiv2bNwEnVC1eoVWTb1kcOvi9omDJ/CEnAEiYCgw3XSAa7uygHaPUuuk3WXKvEPH+ZcjcQBREZ0M6Y9g0amSIu9opeObOKsZi+/F3OoHkDP4XO7S2r7N8Rd7+XRVDFIHiEafCN+Uxssi+Nopl3KyESQz/h9ow=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(31696002)(4744005)(6486002)(6636002)(86362001)(53546011)(83380400001)(38100700002)(2906002)(8936002)(66556008)(2616005)(66946007)(31686004)(36756003)(8676002)(316002)(66476007)(186003)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2laTTUyRmlxTE1GOHEyUXpxZFl1UHpqVlI4MjQ5UjVUV2UybDJValUxZ29m?=
 =?utf-8?B?NmptTWlIUjNQQlovTzJJalgzTDFhaG9XdVFET3NiZnJyN2ZIcnA2eW5sMWJG?=
 =?utf-8?B?eGxYaXp2YWtCTWhzSjBDcnM3bStTWnRwcVM5RTU5TFc0ZGs0WDdTZlo5eXNE?=
 =?utf-8?B?RDFEZVZldTlZZDN0RWhWd2ovK1BRUk5tdHJ0Qk1JMXFuSVljbFdTV0U1ak9x?=
 =?utf-8?B?R2RLQTdzdm81bFFxbGpDMUduUjJBU3VyR3NqWEpLOXNINkxBZ1lTdy9RdWtZ?=
 =?utf-8?B?S0tCUnIwYW8vZzZEOXlFZ1pUSzljc3hCWGVzQ0JYZFd5OVR0R1l5ZEFvclVQ?=
 =?utf-8?B?bHQ2dkZ1VTVOaW1WQTRZdWVtdEkyc3ZqTlRFRUZsaUNmWlJBWCtrMWErRWdn?=
 =?utf-8?B?QWNwa1plUS90eHZoWVZRL2o0aHpobnk3eEV6T2FNS25EN2JPQWZLOFVJYzhi?=
 =?utf-8?B?U0ozS3hiRWNpa1phSURYaGdaeWFEZng1M1M4Y0N0aFNmbmhvSGc2ZW5GWjRT?=
 =?utf-8?B?SFcyNTc0WnNmWVlWa0tTYXpJMnhxallJWFB3dVdDK1VZMElGZGlnd1V6K295?=
 =?utf-8?B?UytwcWo3Tmw4KzBOdmZNQUhLQS9vY1ZlaGszNml2OFR1ZStmTDNyWWVpS2pI?=
 =?utf-8?B?NFYvd2pmTWtyaHlYTWpDYjgzcDduemovMEVROXV5d3ZWRHcvYUtraWRWWUVT?=
 =?utf-8?B?amczSFV0UUw3RytZSU5EbjA5VHBySy94YTdKVE4rV0ZFL0dwSjcyVy9QdlB3?=
 =?utf-8?B?UWsrVGRUMjlmWTYwRFRnS0NUZ0NuekZZcmQ0MVNhbUw3TU9NRTIxZ3ZkRlE4?=
 =?utf-8?B?SUpJZlU2K0hLQWVobDFIKzhuWFZhcDZTT2RjNWwydVVPQkIzVzV3TlNrMDU3?=
 =?utf-8?B?RUs2Y1IxSy9NY01pVFFPWm5hU3NvVmQ5WGJXYi9HWW9XMkdYSk9XMWlhNVQ4?=
 =?utf-8?B?NnNWT1FoRnRCN3NsK3RudSsxL3MrR0VDRVJPbVlGMlZPak52SWtpcmZxUEF1?=
 =?utf-8?B?d0FvVHpMai9BdHBHNFhnZDYrQThHRUtrVG5tMHBFOXdsZ004ZFA5SEVaMU9J?=
 =?utf-8?B?MHhIT04zeVNMMkE0SDNjamlYR3JNK0ppVzVZNkYvRFVHa1BGT1F5b0Z1VmhI?=
 =?utf-8?B?dW9jRTM2VVM1blc2UCtLSmwwU1pwY3QrU0ZNcXNyeWRRL2RHd1gxOHBWT1dw?=
 =?utf-8?B?RWx2ak1uNlFmMmIxNzBFRHpSam9Ubk94VTVtc0QrZmZhY0h3amNQUnkzQ3R2?=
 =?utf-8?B?REhKa09tTDdBVjJSU3pqKzMzcnpJQ01ZT0lWL2haZ2VuTFM4ZjYwNFZ0Y1F2?=
 =?utf-8?B?d0ZLNFJoWWErTnZkTXBlWnUydTJyNnNWRzQvMUM1MDVRaGw5RE1xc2F1cEl5?=
 =?utf-8?B?T1VQMVA3UlVEUzU0bGtmQnpndVZ6emJ5bHQ2Y1VKY2R6ejBqRXJ2Qm5LVVll?=
 =?utf-8?B?eVFBV2FiMVZHY0lqUnFHTklkdm5mbm8xYXFab29jZnluMFNBZXJmd3IwV25k?=
 =?utf-8?B?RkdZbEZHL0s4Mk91NTYvRG1UUkp2aW1LSFJBNE5lR0V3QVA2dFRUTEFDQk8r?=
 =?utf-8?B?MDZCZ3J2eFp3c25WRGZ3N0FJdFp5K0JnbDBoeW53SkVZdXJEVk5rc2pYenpZ?=
 =?utf-8?B?KzVvZEt6WFdCRFRadEFkQzRMV3JESUdPb0VBajhrK1V5bTBnbGR5QWkrKzVR?=
 =?utf-8?B?VUhNNGFGOUhnWXNKMzh0L2dUVnR3M2ExZXczMksrbFlEMms2eW1ydWtKeHEv?=
 =?utf-8?B?R3ZUWGFtdFRCWUcwenJlRkJ5WHo2cU52K2JtUXg2VXdUb2dHWFNwYjlZeXY1?=
 =?utf-8?B?MmJ0UVdOUHV2UTFabkdmL3dJUG1VOHhuckdja09hVldjd1JrdGVGMk1wb0Z5?=
 =?utf-8?B?U3ZCYUFIcmdKUFJlMlcvNmdRNDk0ZXVDU0RXVkl2TzJBKzV6Y3JHdmR1NWpw?=
 =?utf-8?B?eGxwM3ZGOUJEYzh2emt3VlBLSlI4djYvcHl1UUNzbEpONFlOVFpQWlVBVitr?=
 =?utf-8?B?NjZhMXlyT2Rsc0JyaVkwM1lWUG5uZUY1K28zNElER2lrM2Z1TFpOcVBXRUpS?=
 =?utf-8?B?djlGQ1l0elM5MDFDQVR0c1hpalM0Ulp4ejNVNmI2NkhUR2pHK09mNlpKQXhv?=
 =?utf-8?Q?pupbY561xUI8CgjszBi1stmO4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 21fa35d0-ec55-4c6f-596a-08d9b67bb697
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 16:41:11.3327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dji+cbiB5DglXtgiYEfMshN2q66rSJ/9vSdHQ6SMfkZlA9VRGY9/eUTqnaJHkCY9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4777
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: A2Chsgjtz8c1Q7-di4tN7BixPvtf9Bhy
X-Proofpoint-ORIG-GUID: A2Chsgjtz8c1Q7-di4tN7BixPvtf9Bhy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-03_07,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 clxscore=1015 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112030106
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 12/2/21 7:55 PM, Pavel Begunkov wrote:
> On 12/1/21 05:51, Stefan Roesch wrote:
>> This adds support to io_uring for the fsetxattr and setxattr API.
> 
> io_uring part (4/5 and 5/5) look sane, just one comments below
> 
>  
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> ---
>>   fs/io_uring.c                 | 174 ++++++++++++++++++++++++++++++++++
>>   include/uapi/linux/io_uring.h |   6 +-
>>   2 files changed, 179 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 568729677e25..9d977bf243fd 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
> [...]
>> +static int io_fsetxattr_prep(struct io_kiocb *req,
>> +            const struct io_uring_sqe *sqe)
>> +{
>> +    if (!req->file)
>> +        return -EBADF;
> 
> No need, io_init_req() will fail the request if it can't get a file.
> Same for fgetxattr.

Thanks for the review Pavel, I'll make the change.

> 
> 
>> +
>> +    return __io_setxattr_prep(req, sqe, file_mnt_user_ns(req->file));
>> +}
>> +
> 
