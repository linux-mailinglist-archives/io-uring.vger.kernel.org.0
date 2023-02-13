Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38CEE694493
	for <lists+io-uring@lfdr.de>; Mon, 13 Feb 2023 12:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjBMLcb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Feb 2023 06:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjBMLca (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Feb 2023 06:32:30 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2042.outbound.protection.outlook.com [40.107.95.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C858C4ECF;
        Mon, 13 Feb 2023 03:32:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yu3wReix/6wrH+G7k4LUuOs757B0YBQ86tp3NtiGMix1TUlc6iu4B37pAEWpsglOKRBN/C6bwLfQJsegtbqVo8yDR3WBhA7Bx0RRTXKu8n4XCG1Wg+AU5ncHsqJdjJ1Xr9tDyl229x9LhnPGmGWyCT2q3zVEYIXo6Tu66xU73xw4yn/ICuymA1D4Lp1qsHhGLJYgc7j/19py8X7LvIlOYPdkca5XPUtsP5U8X6LZP/e7OHXjcnRIC3uYUkMh1fFiqusyz9d1pZa9mV+MhhE0T3GXL9RMZjma12paeBdBAwjuvoBIBfqadeqAsKhqaJilrHW2QVOaPghoJAIYcrsDiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=btLVYfIKNnZxSevx6q+E+h9eoZUw7/7Y+cNxUcIKQyE=;
 b=DqKrtt5bk3wBVK5byqiJ1yVHS32UISYc2Q5GmSYeBoWO7GCE/0EybchEhQR6JpOeNvDOfo+0W/NOhVKk4FzUuhe9D2L6/F7WLa7KeZlnNUkNN+AvbGoB0t51NF5ao/AoO3bQ30yOFSIWOJg+f2ReZ00L5NUZeqi/rAt0358YgZApY42N1tabRAXCVhaRShbhoK4PcmDmGIhSEPLvSw48SBTWWW7hFJxUYnwk4IDCpFVJXRjV1P41M73jKBXtb5Vz0IsQAcH6YOu/pzlQ1TRbyoNk3m/+R3EuCGle+x+fHhsBtI6oBJkyUY2g+HLYTlE9gc7JCuOaaZuxiCrVB/fxtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=btLVYfIKNnZxSevx6q+E+h9eoZUw7/7Y+cNxUcIKQyE=;
 b=d4MJhPJ1CovhcKa/Grfh7FHWAeTHCNKWJbijzt9JOxNwbmWgqQSeLMUEm1Zs+mp/b4IbYfOqoWCMOvRE2c006u7EvbNiQyxLfKYJe4h89RoPPW9i8VvwuuaKuHbWkWm+4x0MPCYztz4Y3FpUtAswgpvt7J+OM+KkYDE5ytKHdNEssLCuVXIxhlArnEtb2kZnolBVOi1jY+0eC5LOFa6sUjSiNi7HFDtSOO6HLdxN/RPRUGgKEoq8645ILg8UM0/+T9xWT62v0gfseawejSFemieDhAgxzbyW2+zbydFhV2C7krRm6F6Pg0p+KbFcs9cyadoS7fvDN3JlzzxDVSx/4Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by IA1PR12MB7565.namprd12.prod.outlook.com (2603:10b6:208:42f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Mon, 13 Feb
 2023 11:32:26 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4bd4:de67:b676:67df]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4bd4:de67:b676:67df%6]) with mapi id 15.20.6086.019; Mon, 13 Feb 2023
 11:32:26 +0000
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
 <44e6ead48bc53789191b22b0e140aeb82459e75f.1675669136.git-series.apopple@nvidia.com>
 <52d41a7e-1407-e74f-9206-6dd583b7b6b5@kernel.dk>
 <87k00unusm.fsf@nvidia.com>
 <eff3cc48-7279-2fbf-fdbd-f35eff2124d0@kernel.dk>
 <Y+JmdMJhPEGN0Zw+@nvidia.com>
 <53816439-6473-1c4f-2134-02cd1c46cfe8@kernel.dk>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhubbard@nvidia.com, tjmercier@google.com, hannes@cmpxchg.org,
        surenb@google.com, mkoutny@suse.com, daniel@ffwll.ch,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Subject: Re: [PATCH 09/19] io_uring: convert to use vm_account
Date:   Mon, 13 Feb 2023 22:30:42 +1100
In-reply-to: <53816439-6473-1c4f-2134-02cd1c46cfe8@kernel.dk>
Message-ID: <87edqt243d.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::31) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|IA1PR12MB7565:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b228acf-9532-4b7f-9fc8-08db0db5fb22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U2ZCppw5OcGTlEAga3JDY0KU9gTL/AbFb1EOxhVz63c8cnr+4mbUCv4plM5d6wOljOFYMArOmU0cE/yKN4gZnEtA8+Kc+YfFH+PrnsCAdtdgCrk0qaWM/nRQ7h29HuoZqGwp/yEHI4c44xnKfhJJSE3kOwsL5V455hJknoje67/Gn267baoy6xhMg6RPO9kav6ebIGrRZB9Zuo4EoE9z+ZZvaZb8xPXLMvbFH7Ega1yolbR03OnUajyI+X3ALmVtgsspg8Qz1ZOeHTtn1QI6S9ZJKUMAGgUhk2yRXFdIiFIdWTlBYYqDqs43rOwTXb+M2zEpTm63BrhoaK0OUkjuYbpb0oRSDBbUNAbRy7MlxiCgWDBm1DZrdJWxuoDRSpJ40qif99sJlYHlMFg7Pp8OV16p3wU3N6bF5m80gVSvpffR0kdUkuu5xQcgAtWxpi2EW2RHgMyYTEECDTkijhkZL12dvK3N7EWnYGDyKVDO0ZPETujEanocM75cG5R4sm+LPzBkKuDWHXwvwmeWGwuCeq4A959g4C5WA6s90y5PURBEqvbwd4sTEA1M1uxSunkMoFaSM6Ews8/etrbIojzfnpeCB3aFo/lETSDyXmG5BBAAy4ZJAqAsi3V6InOf9yLuRtpniByQNsDH1GYvOIg8gA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(136003)(396003)(39860400002)(346002)(451199018)(8676002)(7416002)(8936002)(2906002)(38100700002)(2616005)(6486002)(36756003)(5660300002)(86362001)(26005)(186003)(54906003)(6506007)(6512007)(6666004)(41300700001)(478600001)(316002)(66899018)(66556008)(4326008)(6916009)(66476007)(66946007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uULDRm+rMwtycwowVJGitE2mrRvX5Cjts2EV9FX+S1YoXxFzUSOvQwrYJMoA?=
 =?us-ascii?Q?1DOYSiiIOSETufJcr2cXzqt61gT5W+JjWuzV/Li9NfdcuSLw+HpOi1OUnXcs?=
 =?us-ascii?Q?AOZNtU4KHhPfc0MZJh99zD47HcVgjAoLSkcQfUP+SzWwtnr2UpOEbjqCMJ69?=
 =?us-ascii?Q?Mv3WQkv4Sa2z7t0OsBHrcWixDygxFFnfrCM6HSDT3YDBM9FXuuA+Dh+GFrAX?=
 =?us-ascii?Q?ufs/8P98IKhrSZQPiMkg+GTigiwacit28bb6Q/CS4UewZ2rJ3LKi0RRYPvFU?=
 =?us-ascii?Q?7BKhepBbmvtezE7Fz+vjJX4a4c4wbBcuXns/57s8AJQo0d/zPYWzZ5+Nf2kf?=
 =?us-ascii?Q?4+YD1dIppO+lYgtDd4tIeV51K1coTe2/v7NYLP/CMNjdnvF5gZgJ93YVrAgX?=
 =?us-ascii?Q?TBbPpZgB8DBjJVeCJzqxvhvR2+O9hXoLI8Ec+CKpwWCdr4W/nSDUHxcvDrwx?=
 =?us-ascii?Q?vNOrApqiF6TyX8qg5sdHKcWOYWe0N8OTalIT2skTE64kw0bML/CLyRYy+g45?=
 =?us-ascii?Q?XIuRNJW1BYF7Z0y4bg8HD36bTos9YEejruTH36/bdDLEAVIulztD0CSajLAF?=
 =?us-ascii?Q?aO0Pq1l4gwNgHM6LUqdTdEPUoWVJjOvIPK6qh9k6NX2iEr78P96hBp8D2fgu?=
 =?us-ascii?Q?0WiWhnenEgU8HnV/qKQHHVXYuBZa9vKUXJ6LLLvZTklysZTxGbiT0bwk4zrN?=
 =?us-ascii?Q?RI/HDxN/vF/oQei8wk5V0NhQt1r3YqKI0D/GGt5rlX8BKgNlp3Sw2HU2z6zs?=
 =?us-ascii?Q?VzyWZj49nPFdxLqh+bI3dxes+QkcjKUwe5vDjyMuuQ2giHr9jfSbQdtdmPZs?=
 =?us-ascii?Q?udexUdwwpvQBP1vKOl5i0pNYObznNCBk9uS/E57uNV62knrj1+9TMhBkscMM?=
 =?us-ascii?Q?XLkhgXhbzXpq6JJrT0SAv3kzNRscPeLDTzdZrFsNeCYB/uJlMzfRPWfJ1nEu?=
 =?us-ascii?Q?CzTYsw/zL6qf6n26XJre/7WYz4iqWhMZksfqHsC3ER/TrdN6xG7PYS3oz1KN?=
 =?us-ascii?Q?/jqYroajY18uWB3A6HDb9omyoyW89GfDnAzY37AioX8Qreltmrul+X50pYMe?=
 =?us-ascii?Q?+7T3JkrMCtp2cf1YP+28ntLTwMJPLhHZjN+c+pAbBrNDBVv+blU/pgV+D6qO?=
 =?us-ascii?Q?pgsP1TJzfnl5TuJncrZw7mr5KRwidaUu+dmF/vthJhYFTWxoiRpydX+24SpM?=
 =?us-ascii?Q?nr9Iuev6IXTi2+TfI6qz7+QgLuJskbZMbihJkSjbA1IwFTah3M9xvNiyjnD8?=
 =?us-ascii?Q?wUPDfUFPQAl+wGTmlyxs2fBy9UV3IuEbjcreDwFUwQIxr2W2l94gt3RykDgs?=
 =?us-ascii?Q?6CQrfuekZSStM22iuT+lZt3lrWystvjdVDajUlgSHTJL3TFHU57m01QORPJ6?=
 =?us-ascii?Q?b+mHAk2i6GHLAaiHE+dtQ/ljyoOHmqt6Cw9vTKE06SjWIYCUN+hKyhTULFF5?=
 =?us-ascii?Q?9NMjVeEu+yaazZ7deFgLKq8XDYlPLoZ7EP9X8Du5ZfnBUZdJHZV2WNOGfSBW?=
 =?us-ascii?Q?OiJhQchN83SDNyXcbVmg1TrdnV4XCo9LgG1dLDHWaay+nHykAtXB8JtnodM3?=
 =?us-ascii?Q?cnOSbHRVp5MpUxf7R5mPgYkqmD6KCiuH6HA3V38R?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b228acf-9532-4b7f-9fc8-08db0db5fb22
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 11:32:25.8680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ZrVFgFnplDZoq0jWMlqXW0dOPWSB9+JZMPqFFK9UtOCJtxZKczNyT5TcXoCv+5I+ktKiVwLrwjmjUpIL1HnFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7565
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Jens Axboe <axboe@kernel.dk> writes:

> On 2/7/23 7:55?AM, Jason Gunthorpe wrote:
>> On Tue, Feb 07, 2023 at 07:28:56AM -0700, Jens Axboe wrote:
>> 
>>> Outside of that, we're now doubling the amount of memory associated with
>>> tracking this. That isn't necessarily a showstopper, but it is not
>>> ideal. I didn't take a look at the other conversions (again, because
>>> they were not sent to me), but seems like the task_struct and flags
>>> could just be passed in as they may very well be known to many/most
>>> callers?
>> 
>> For places doing the mm accounting type it cannot use the task struct
>> as the underlying mm can be replaced and keep the task, IIRC.
>> 
>> We just had a bug in VFIO related to this..
>> 
>> If we could go back from the mm to the task (even a from a destroyed
>> mm though) that might work to reduce storage?

Yes, it's the going back from a destroyed mm that gets a bit murky. I
don't think it's a showstopper as we could probably keep track of that
when we destroy the mm but it seems like a fair amount of complexity to
save a smallish amount of memory.

However if we end up tacking this onto memcg instead then we could use
that to go back to the task and move any charges when the mm moves.

> Then maybe just nest them:
>
> struct small_one {
> 	struct mm_struct *mm;
> 	struct user_struct *user;
> };
>
> struct big_one {
> 	struct small_one foo;
> 	struct task_struct *task;
> 	enum vm_account_flags flags;
> };
>
> and have the real helpers deal with small_one, and wrappers around that
> taking big_one that just passes in the missing bits. Then users that
> don't need the extra bits can just use the right API.

Thanks for the suggestion, it should work noting that we will have to
add a struct pins_cgroup pointer to struct small_one. It may also help
with a similar problem I was having with one of the networking
conversions.
