Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 935C718513A
	for <lists+io-uring@lfdr.de>; Fri, 13 Mar 2020 22:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgCMVdQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Mar 2020 17:33:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23310 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726480AbgCMVdQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Mar 2020 17:33:16 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 02DLNlHw008775;
        Fri, 13 Mar 2020 14:33:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=9eot6XuRO9xzJK5tkc47l+yTmb1JYsicJZJXW3GFXKE=;
 b=KbHhbruP9ukZyEE+CmCKmX7ZrZjOdjVE+t+wxXtWIsLb0m8DMb4Yqvhq4EqLhea/pcoJ
 dq5i11rMwcsED4dhodFpPXIqAldE95BUmQpO58p9s3mBvG5uWe6VNgdC3WYCZ5wwpuFo
 g/qFdzDadfS6uKv2qY4Sp0EO5Pa5KxP3ddg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2yqt7eefxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Mar 2020 14:33:13 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 13 Mar 2020 14:33:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vo0Ky02LHQ/RnUQfubjwVL9K14YJtvLIksL9G83i9OdGh7EKPud1fwX3ppVao0AdrVvH2ZzuqMcD2+xkteBRc3G34SgsezaC6WHWE/Ot+cCvJNT1ng1bTAiUANdHyDiQTRLrC5jqb0HJRWwSMLNJ00pUl68PMkJVTJN9F+fyUbtwEckIPwt1CQI4QRmfyapYbRM8RP1eDUrucSB+nHEniBKYHiR0AHHzIk/LKLa3H3bxEg02geY8O+a4fc8UkslZr6NYRHizrguczgwaYdjVsl5sceHRq/EojTxASPj0GvUHfpVxG5kXcGjckgGpHhnHjfoBPo8eVrnvTpDvlTiN5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9eot6XuRO9xzJK5tkc47l+yTmb1JYsicJZJXW3GFXKE=;
 b=AA/SobSVzMqoaqKis8Hzv4GR5jVRHaf47gPeWr+l8LKPUu6Ap5p23IoLEcMFQwOzYcf2RshyA2fOGiiBGUS8WijjHncHPgDoB3z+6GCCe4WfZmT6tcRAn983MYlpe64k6edZ06BmtBJjO8xc5F1TnP7IeCekUZWBqD1VpVyMy05NiXd+EvbOGDHkhCwSVA941GEgVKHe5b1WgbPhTJqQcOXuDmQb4fAJTafUvvzBF0bPD/McTa5KX0Nqvx5/UyhEA5AD4+xFDjLZ6QwtBEa6QcQSIGBJO/gpQYQf+4ldaCa31QALv+J4XXyyDudDYoKo6Gq256hKOqis26CMgpTSjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9eot6XuRO9xzJK5tkc47l+yTmb1JYsicJZJXW3GFXKE=;
 b=lJMf5S7XGdF4/EfJWGSWQXZvXwcj4bK8Ld5ZE4tS94oXqSLjNcVF1ts5hoVX7C/s/044h4hzBZpXXwkFZP2/f9/hYkhQ94iVJ1LYABs0xoMD0GS8nz6YIIfWqJY9AnGAV8yOsYMq9QsfTPBiSVKW+aGheumkyO6USa0pkhR4rHE=
Received: from BYAPR15MB2790.namprd15.prod.outlook.com (2603:10b6:a03:15a::31)
 by BYAPR15MB2599.namprd15.prod.outlook.com (2603:10b6:a03:15a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.18; Fri, 13 Mar
 2020 21:33:11 +0000
Received: from BYAPR15MB2790.namprd15.prod.outlook.com
 ([fe80::4c56:ea:2fa5:88f5]) by BYAPR15MB2790.namprd15.prod.outlook.com
 ([fe80::4c56:ea:2fa5:88f5%2]) with mapi id 15.20.2814.007; Fri, 13 Mar 2020
 21:33:11 +0000
Subject: Re: [GIT PULL] io_uring fixes for 5.6-rc
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@kernel.org>, Tejun Heo <tj@kernel.org>
CC:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <00e5ab7d-f0ad-bc94-204a-d2b7fb88f594@fb.com>
 <CAHk-=wgGN-9dmso4L+6RWdouEg4zQfd74m23K6c9E_=Qua+H1Q@mail.gmail.com>
From:   Jens Axboe <axboe@fb.com>
Message-ID: <cb853c40-820a-b05e-1a1b-50770565e69c@fb.com>
Date:   Fri, 13 Mar 2020 15:33:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <CAHk-=wgGN-9dmso4L+6RWdouEg4zQfd74m23K6c9E_=Qua+H1Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0075.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::16) To BYAPR15MB2790.namprd15.prod.outlook.com
 (2603:10b6:a03:15a::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.188] (66.219.217.145) by BYAPR07CA0075.namprd07.prod.outlook.com (2603:10b6:a03:12b::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.18 via Frontend Transport; Fri, 13 Mar 2020 21:33:10 +0000
X-Originating-IP: [66.219.217.145]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31260096-3f88-403d-c3aa-08d7c7962116
X-MS-TrafficTypeDiagnostic: BYAPR15MB2599:
X-Microsoft-Antispam-PRVS: <BYAPR15MB25997B75CFA7C7844B4351ADC0FA0@BYAPR15MB2599.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-Forefront-PRVS: 034119E4F6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(396003)(136003)(376002)(346002)(39860400002)(366004)(199004)(956004)(6486002)(16526019)(4326008)(31696002)(186003)(31686004)(86362001)(36756003)(26005)(2616005)(5660300002)(54906003)(478600001)(110136005)(8676002)(2906002)(81166006)(52116002)(53546011)(16576012)(316002)(81156014)(66556008)(66476007)(8936002)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2599;H:BYAPR15MB2790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8fSTk2lrt6/O8CaR+eeU1BEhkA9KrL4LcahSln61E4Dk1j5SNKLaruAKXxuFoyly+Phsu4jkKoZGXvNg2eddNOFuwWASNP8/RIFDSCKh3V1Y1NzAmXrDzq8O00Lf1QaoHSuDX+ADsQvlP+FeNhiMFfIMk4fIM5u6quakvYnEc1cKJHNK+6Jm9Irl26/4yy7JQwkzpMrCoRxF+BKrD7JVagfeN0zM9Gsis3hmzIKd7F2XiD0nIpANb/ljPcCswwNBa34U4YXtAXDwstBXaDNgnON+osMggXnPAEztmTnKCy8Yizm1kGEGLbZ7+71Gc0k593rderz6GRYAk/26F9deLFYneDEqVcJa9haMm36eTYqgi7CpwtulDgJp2bbn80q8d4JvCLHj89LJVrXnYk9a+Wch+F0ADjiWyX8j+431iYh1gb2WRmcLS5t+IOjfS8GW
X-MS-Exchange-AntiSpam-MessageData: XjqIu85qzosJ3bKpE+VdYJH/Xvue5fVxVB8mEuBPSmMv4Tvlwzitl0svBLGn0+6xUiuZYZih02PCiIe2QICMJFDwzkH48bISMdmGBCBDOObJVCkCGTk9IJjMtF3S1x2S3UA5KTPhDwtcq6IY7+Xy+g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 31260096-3f88-403d-c3aa-08d7c7962116
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2020 21:33:11.1935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EHKdrm88yxiE+is5mt+6bnzIRCNIfcwpOonavSvG2oQq5p+Ko59MAbH2BWv9ZoEp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2599
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_09:2020-03-12,2020-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 phishscore=0 bulkscore=0 clxscore=1011
 adultscore=0 impostorscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003130096
X-FB-Internal: deliver
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/13/20 2:18 PM, Linus Torvalds wrote:
> On Fri, Mar 13, 2020 at 10:50 AM Jens Axboe <axboe@fb.com> wrote:
>>
>> Just a single fix here, improving the RCU callback ordering from last
>> week. After a bit more perusing by Paul, he poked a hole in the
>> original.
> 
> Ouch.
> 
> If I read this patch correctly, you're now adding a rcu_barrier() onto
> the system workqueue for each io_uring context freeing op.

It's actually not quite that bad, it's for every context that's used
registered file. That will generally be long term use cases, like server
backend kind of stuff, not for short lived or "normal" use cases.

> This makes me worry:
> 
>  - I think system_wq is unordered, so does it even guarantee that the
> rcu_barrier happens after whatever work you're expecting it to be
> after?

The ordering is wrt an rcu callback that's already queued. So we don't
care about ordering of other work at all, we just care about issuing
that rcu_barrier() before we exit + free, so we know that the existing
(if any) rcu callback has run.

> Or is it using a workqueue not because it wants to serialize with any
> other work, but because it needs to use rcu_barrier in a context where
> it can't sleep?

Really just using a workqueue because we already have one for this
particular item, and that takes the latency of needing the rcu barrier
out of the fast path for the application.

> But the commit message does seem to imply that ordering is important..

Only for a previous rcu callback, not for work items!

>  - doesn't this have the potential to flood the system_wq be full of
> flushing things that all could take a while..
> 
> I've pulled it, and it may all be correct, just chalk this message up
> to "Linus got nervous looking at it".

All good, always appreciate extra eyes on it! We could do the
rcu_barrier() inline and just take the hit there, and there's also room
to be a bit smarter and only do the barrier if we know we have to. But
since this is 5.6 material, I didn't want to complicate things further.

-- 
Jens Axboe

