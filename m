Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C9D1E2F9E
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 21:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390705AbgEZT5n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 15:57:43 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5920 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389442AbgEZT5m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 15:57:42 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04QJnDEs011172;
        Tue, 26 May 2020 12:57:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 mime-version; s=facebook; bh=eMG9lHG3IOuhOz7NnllvpNvp1QEdyjbUEuwtGDVOhkc=;
 b=M5tWjRXfQBKGPCkpXoRkhrOm7LI1g/8b+/HhqRMPwj7hRlcoiJXaXiX8Ucxn0dja3wZe
 LDWB3NY19V/gtlN9gWaIJXbBeXt9iLlwJo4F80W3XrFPetkDOoDgbdjEGT5KO99AxErm
 RH8soMLwHSU28OrlJim0e7XcHdUuKvyihAs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3171jpkk7u-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 26 May 2020 12:57:39 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 26 May 2020 12:57:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VhLkaouoQYBzSCmW1Xy2F4VldmN3Y+Su0vunp0HtJnIxjh5JV2Fm2T5pl5ece33h5PT4NLcyZ1bdwZMvMxxtFEgQX4MEIPttnwLJRaZmry83/OFt3gpuQ95Pzaq36WWJ+JQriK3+M7htgVggqAUAE22uIhx+uFteVaONQVUliEhr+hmKlJFdFAjLtVbLwk4fv8HEEcHoanSbrAwk3agPRyn2F0KdnZS8mfaAftxxxv1/fjwDddT8MlfD/0hMW5UeCoBQ9VEc/ANVmUjjrhayEsQ9kmNLPnZBQoPfG026gNy4QQGtbpsok32IaNdaomVDhYK+V5k/Gt5jUTLlNUgT+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eMG9lHG3IOuhOz7NnllvpNvp1QEdyjbUEuwtGDVOhkc=;
 b=WVBYebz7h1XPkyT7vsb6q7lbApGmcX+bBHmaommLzY72bf4/HkTKFHaKqvFMK0QfHgAzV1MfzMlk/vDd+5dSPRGVGhipOLP0wi2nx/5ZZhvZOLnNmFlstsahIhrTh5z1PKWoqTp0WVrfkzldC5gBixu4qUYhvEnwrMG78I6uUbPRA+kpbrjKEyU/MuOA9pjMrkeFin6YdsiMAYtQkhesxqTJ17NgcZnNk5/aTChFx7Xei5Xhqqad4TbeXnF1rHoZDycZPozSDp5nK58axDgGpH/jRvKuFKt0pUsIwFURhSeVO2/PODVO6oOw17TQSNUHo6B2uioOYz02v5BPCJbI3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eMG9lHG3IOuhOz7NnllvpNvp1QEdyjbUEuwtGDVOhkc=;
 b=aAtuAwpk+nrUemSXPQ1TtQRRJQlT5BoUwcb1+qFPfk/fMI6HjRE0dBsGJd4TBRqBAJBeUOkhEVzNgpCStQo100GcSwgYnR7/WSa3L08mVqCXqceccFf+gAjlqkmHzGCyL0dPrbxB3kKnaXKm2rBntDoQRv7Os0V++s4j9jFJvRw=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
Received: from CH2PR15MB3608.namprd15.prod.outlook.com (2603:10b6:610:12::11)
 by CH2PR15MB3607.namprd15.prod.outlook.com (2603:10b6:610:a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Tue, 26 May
 2020 19:57:36 +0000
Received: from CH2PR15MB3608.namprd15.prod.outlook.com
 ([fe80::5800:a4ef:d5b3:4dd1]) by CH2PR15MB3608.namprd15.prod.outlook.com
 ([fe80::5800:a4ef:d5b3:4dd1%5]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 19:57:36 +0000
From:   "Chris Mason" <clm@fb.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <akpm@linux-foundation.org>
Subject: Re: [PATCH 10/12] btrfs: flag files as supporting buffered async
 reads
Date:   Tue, 26 May 2020 15:57:33 -0400
X-Mailer: MailMate (1.13.1r5671)
Message-ID: <2C2CDFF4-F736-4B19-B00F-D9244CDB3E21@fb.com>
In-Reply-To: <20200526195123.29053-11-axboe@kernel.dk>
References: <20200526195123.29053-1-axboe@kernel.dk>
 <20200526195123.29053-11-axboe@kernel.dk>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0015.namprd16.prod.outlook.com
 (2603:10b6:208:134::28) To CH2PR15MB3608.namprd15.prod.outlook.com
 (2603:10b6:610:12::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [100.109.101.106] (2620:10d:c091:480::1:f13c) by MN2PR16CA0015.namprd16.prod.outlook.com (2603:10b6:208:134::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.26 via Frontend Transport; Tue, 26 May 2020 19:57:35 +0000
X-Mailer: MailMate (1.13.1r5671)
X-Originating-IP: [2620:10d:c091:480::1:f13c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc0d8129-11f9-4b81-c774-08d801af0939
X-MS-TrafficTypeDiagnostic: CH2PR15MB3607:
X-Microsoft-Antispam-PRVS: <CH2PR15MB3607D9DE5536DD4DB810EF17D3B00@CH2PR15MB3607.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:962;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lqDQxuEgtoDUVPIG6FDWFK1AtYj4MXHZRISHfj+FlbZbKZQWBu1+YZO1knhCpf84YH6BdY9bpc9Ca9NA4tPtmRrVp7L9nWPt2F9R9GKwZ0qqFXZkLgWEUVEdw5w4pyDmkNOmuLPEdhYYNHdxHpzildlgyDpl37XMg41SrDNa8S2bTj0SE7KntmM2y8xYrd63usar7Hx6gyiK/upxM3l1irmarRk8UEian2imjf8iBk99JU3k96/9Wv1ufnlpk/gtK0aTbaHih/o90tCKlbL/nXuBY+yRjA5Z58lJX9pgcT0can4NIWTdjbgDkftdgILemNRKJo6U2uH8phIQRv90QCW39QolsM3JCGleflCWxDqsEbKLH1dKmexQNYYwNpYrU9Dc3dOLiwHEuoModw7aoH4Q8cFNUoaSfJflgSdsEko=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR15MB3608.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(396003)(39860400002)(346002)(376002)(366004)(186003)(16526019)(2906002)(86362001)(8936002)(36756003)(478600001)(33656002)(66476007)(66556008)(66946007)(53546011)(52116002)(316002)(8676002)(558084003)(6916009)(956004)(2616005)(5660300002)(4326008)(6486002)(78286006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: T2LslvBluQ3bjsHzwY81J+BRNRSeQuOr7cb0ewHM2rWed2WrjSC0t2BvmuCvkfTZT6faMLZbnE5MyQnZGg3WU1M5+aBXnpmPWHyNJrVHg9M9RxN86/xvfMLM0mQODYMWBWMptb29BF0IpxuMR+VUaXl/EbD0WV3PRmLbbWgHlyPGznfLQ5UbBIcxsksVBPF8UkzcB0M/s6QvzzkpOxIxyXYerTEqdNx95cgOR/yzqLt8+6StvRg8ULkTCBYIeqF0EMabb4rVFLU8dUrf6vvcfae2Hm+USn58w+G+egbxcexcUwuVM6v7Cx315i5OTHLIaQzs/2bL2/m8ghwHQJyjhhawxG/tZiw/Q5kvvBZV2FJ4uSLZ57o1I09QdE4tTqHk0kWnOcNJe5awBBN73evQZe563B2UmMfrckOupn8NI6zEMArRgF0STyEP52I7g9fm6v/ne698T37yRVqugAoQGw0gCP+6Q7BcR3O8rVXnn4H4kY8t/nA9fPdRL56Mfw4pmif8PKs4WN6FJaBMb5fczQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: dc0d8129-11f9-4b81-c774-08d801af0939
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 19:57:36.0320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iC603E26yZbOsLXjrB5carCscG0KTlaJcbtsV8//zBvCCCejzJGvfTa/ijbspSrY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3607
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-26_02:2020-05-26,2020-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 spamscore=0
 suspectscore=0 phishscore=0 priorityscore=1501 adultscore=0 malwarescore=0
 mlxscore=0 clxscore=1011 impostorscore=0 mlxlogscore=663
 cotscore=-2147483648 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005260155
X-FB-Internal: deliver
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 26 May 2020, at 15:51, Jens Axboe wrote:

> btrfs uses generic_file_read_iter(), which already supports this.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Really looking forward to this!

Acked-by: Chris Mason <clm@fb.com>
