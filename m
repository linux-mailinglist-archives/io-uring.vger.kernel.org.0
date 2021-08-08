Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725143E3BF6
	for <lists+io-uring@lfdr.de>; Sun,  8 Aug 2021 19:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhHHRbz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 Aug 2021 13:31:55 -0400
Received: from mail-sn1anam02on2061.outbound.protection.outlook.com ([40.107.96.61]:10980
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230201AbhHHRby (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sun, 8 Aug 2021 13:31:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EQuEBTCH1OPBmPLxuXD6fn5K6KwxjEUSYBaqqPMF0+wkroCih4FPF/BW5T97ZPTIkny7mY65OaAOLdApSLlEt5ynoV9xkKHHuQBx1SXi/f8Btgx5Lm2uSPlYEYv8w2vf1ZSzHIB29rhZx3iPcrrztBdZQC3kmM1MZoQUgycYUQyehxhdP7YZsl3YrjP9Th1JdpT67yYvxJE0kIAswwH+SYHxPV2CsCY8AR4lnZu/ib6XLK/dbkCm0qMXXxAb8oVlQEG8BpoZm1SOh9SCy0OWRVyh142cRQXCtbmDcsowlNIbeFRW6YxMSeB0jxH786oJ5hUST9Xzcmzl3Ujg6KK3Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YDwwVtHys/q+bbDpvmh/PVr7w/5MkqhkdQBfFM8ClKU=;
 b=I3sdwm47qIMCNsWSfZ93w1aTe4kVYAh7P8TRZcreYZur1kcGqb/m8elzoASjvfOB8AIsFD+JZSQXgOLefVm6INqhLnU/BO4COVBhq4UZAeA0CSt0CSc+Jyq7zqYh2bUEQKe/ybCBnp/4ywlS3NRBqnzWB1jnShf4Xkyz2ytftx2st6/NQ+6CEcFlOSEmBEZVl8wtSGfy5RX6iwMemllc/Rq1UUc7zR4dTxhlcNfZsW9N775dqlePzfqVBJIHE/UNd4KHMdbkP6E0N6aS5yOJuUNkcb4RwbsJl1ItEkCFk4fd4Uv+ZIPEAaSvx/GVSyApLZitIeMFn0h12GLajx5ufg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YDwwVtHys/q+bbDpvmh/PVr7w/5MkqhkdQBfFM8ClKU=;
 b=dbSswSgOw5e5XK/R/Zx7oFxKBI1bx6t6V/TA2IoVKUflRBzbkKUw9hlaK03+touPTS+qhP82xDDTKTXhps3AQpeEz/QxYHW6pJvDf4JcOD8Eb6G38YJiorkUgaaVov8Oapqjtzrw43T3p0DRKnjxwzW/O/UkmAOv7G8hF/U/9lg=
Received: from BY3PR05MB8531.namprd05.prod.outlook.com (2603:10b6:a03:3ce::6)
 by BYAPR05MB5333.namprd05.prod.outlook.com (2603:10b6:a03:1e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.9; Sun, 8 Aug
 2021 17:31:33 +0000
Received: from BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::c52:f841:f870:86b5]) by BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::c52:f841:f870:86b5%9]) with mapi id 15.20.4415.012; Sun, 8 Aug 2021
 17:31:33 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
CC:     Jens Axboe <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] io_uring: clear TIF_NOTIFY_SIGNAL when running task
 work
Thread-Topic: [PATCH 1/2] io_uring: clear TIF_NOTIFY_SIGNAL when running task
 work
Thread-Index: AQHXjFSzesNuD57xTUuTkIhmri8yNqtp3csA
Date:   Sun, 8 Aug 2021 17:31:32 +0000
Message-ID: <40885F33-F35D-49E9-A79F-DB3C35278F73@vmware.com>
References: <20210808001342.964634-1-namit@vmware.com>
 <20210808001342.964634-2-namit@vmware.com>
 <488f005c-fd92-9881-2700-b2eb1adbb78e@gmail.com>
In-Reply-To: <488f005c-fd92-9881-2700-b2eb1adbb78e@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fcb3e365-f869-4b18-8d38-08d95a925d88
x-ms-traffictypediagnostic: BYAPR05MB5333:
x-microsoft-antispam-prvs: <BYAPR05MB5333958A5CC116B866628C43D0F59@BYAPR05MB5333.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9CaVt3gV6s4hurkwSq6bHqXJ/+3eCnyVuEOJKr9nfDChP4+3cn0xvclufDmzE4axWsEj4Wz7okM60Gnik07AtLEhbSCro0JnBtMdierpDZ/cxVhZ9YMDN5IuGpY1zOdj21OFuT34keoVsPbg2Tj32aNKw+TFbB8m7hYhFMNA2a/7Af+QgKM3e1DduqODfmUvLPGRiHnE7Xj/meBQAFEactpKts5AkFL6elMiqD0wTiaVflq7qVheVzyCFWZwXi1VXEK1WAXouIF2bj8fNDZd9IZZEJ5+p+Epr7z8xgom2T2q71Fo16Hlfn5ewfE+NnwCpuO5IQLTvnKEt4YZEiKmuOUZ9T3sosvYjDchGZZldwGal8x/APvw598sQh7+tKOOKC7CQKqmJlMm1z7pOg57CFHKiMv6Dk5c2oZ3evHxDErz99wbRdHD48TrUJEzr8mhv7UxBzff2Hq02DyhjbZAojdl6gpl2rbkxw7KUa95U00FpdViulGJqJs4iAkgZNDzH7eb7+rdqvO1xRDxcmISWHjHpO1OfZeKbcHaTA3rGsMz2cS7fLXCBymSP/aRga/s4jt1cqM82J+WrCB82pbskcUMHO5Q4qG0AVfq9ihxY+911OfTQwgd5Ygwz0fk2NUo7TFTvn9ybh96A/AXlK9vvMnTlLsPoPfm/n9niE1GzIcwhaCG7z/hAUxvoXvq3SDny0rHbWKoSo7h6IXD42ei80UP9XYHEzqP4x1cKTZnHaA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8531.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(6916009)(2906002)(53546011)(76116006)(8936002)(83380400001)(5660300002)(316002)(122000001)(6486002)(38100700002)(6506007)(54906003)(38070700005)(6512007)(71200400001)(478600001)(2616005)(33656002)(66446008)(86362001)(64756008)(186003)(66946007)(4326008)(66556008)(66476007)(36756003)(26005)(8676002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5pefaw6DAIUki76KDqLIpW09Gf0YSSnx3gwVcWm2Yuq3Hh89XD3N4py8NDza?=
 =?us-ascii?Q?UfhrnIEv+9EKkbPnG7/XZZ/mjZ7qygAEVzaoHlxQhgjxxXHWegNnSUGmFnXq?=
 =?us-ascii?Q?W80eGU21zxqSZXJj8J8ORKyj3JTXeL0VgwjrUTVxUK/Q8NncB0vL/sggtvBG?=
 =?us-ascii?Q?YHoweadUrA+ff3BKwn8dPIcH0nZ3cmHCWXKkddGaI0h2XfiOQGzOf+5Zqxrv?=
 =?us-ascii?Q?c0qq1fexeOHkTk9W5oBvKMExddYFPolrZHyW4/+OGrN+LtSvpcmmNeUChb/M?=
 =?us-ascii?Q?6i7m/kW6dkwBtLHKZ8MT8y292NFU+s2ClfY82LKQej19qHCzKz2HTj2D/XRI?=
 =?us-ascii?Q?LJnJW8fv+4O8mu6FEpws1hZRjU17ilEry1PB8USSttkguEJdY94nw0lzquYn?=
 =?us-ascii?Q?hE95/hUgVaQD76PZql8bzBqCHwKOKY4A+HXBKSAE30mBZjQOmcw/1LwjIy/O?=
 =?us-ascii?Q?AScUfnQil/y+fjN8ylxLp48C9jSnixYKXDM7l0cKqM7G4wzyBbD5SNc63c4U?=
 =?us-ascii?Q?CQo7w1VxhAUKSKalLpAT2JDH2na6xv/a//4LYZNLz1Wv2z6Am4wMQa8EZ7E8?=
 =?us-ascii?Q?ViWeADcrfRSyyPz23jfVH9sltmbKx1+SWw6DJ0i4pSybpnwFt9eVi935pAcF?=
 =?us-ascii?Q?D8iWjVR/HKaXgN8VHP2DD5CBBSnTYVc5kNGiV/k53301TIrXiVYWuCNygIl5?=
 =?us-ascii?Q?HFZ8p+PI89h4zRPGdWpCOABAZqjNhzGQmxe+XiM3W3YYmyhAML6pGWwmiwt7?=
 =?us-ascii?Q?JSvSfmneYhrEynPqosbaPexz2NyBO+DB2F451GTVqdO0vgtvUxU6vHqr9poA?=
 =?us-ascii?Q?ipUT1LJ9AdI78uFBRymfP2gdF8kgeptnvVVrDzkbFxeW/TuHU7xSWmPpcDhk?=
 =?us-ascii?Q?+ErSw0LqPoKyzqxEb0oNs1RyGNwazU6GLB6WCJp7FAWJex5fJLKSkP2Yhq52?=
 =?us-ascii?Q?7tRb9dIw5iSFmuJBuIZTYFj5kRDXkc83GIx+GeTQqTtS1ox8+iKLRVk38ARQ?=
 =?us-ascii?Q?EpFOtaPIf8ZqPmZ/nLktVYqEhltHO0hM4EHAF1/M9OXbyQs+yvWX3Rqat5yi?=
 =?us-ascii?Q?p8dnU6pEz8kyxsxsJrO88kO/ft0+oQmEO85codCHNblvN1FIHaWw7ur1aLQe?=
 =?us-ascii?Q?CHJwEBluQupZwVsqAkBlqgaD5uwanEyHShUsU0KUxJJ+XJ9QVe6cZUnxjJaN?=
 =?us-ascii?Q?tbL6kwdMb4Axn38uN0sahqqA9uRbdl/Sv7y+RfFVgkEUaYY7odpjGijJxM6+?=
 =?us-ascii?Q?JoyL4k2/rBsXnQBqKzPQlkMxgxIvdtD/H6IPlpy+AGin0Ste++pPxYfPTMDu?=
 =?us-ascii?Q?WFXWPP9KQGMqPE6J2sSP/Z4U?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3CAA6656D5C17042841441AA3771FAC3@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8531.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcb3e365-f869-4b18-8d38-08d95a925d88
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2021 17:31:32.8769
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +XOKMXvhv3SN98ojjSB13k+ESERuMEHZHG4zCV63BHgB2MxPt2oGkSpr6JUr5/uMcUOtIeyS+gL9VcxYsvTvtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5333
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



> On Aug 8, 2021, at 5:55 AM, Pavel Begunkov <asml.silence@gmail.com> wrote=
:
>=20
> On 8/8/21 1:13 AM, Nadav Amit wrote:
>> From: Nadav Amit <namit@vmware.com>
>>=20
>> When using SQPOLL, the submission queue polling thread calls
>> task_work_run() to run queued work. However, when work is added with
>> TWA_SIGNAL - as done by io_uring itself - the TIF_NOTIFY_SIGNAL remains
>=20
> static int io_req_task_work_add(struct io_kiocb *req)
> {
> 	...
> 	notify =3D (req->ctx->flags & IORING_SETUP_SQPOLL) ? TWA_NONE : TWA_SIGN=
AL;
> 	if (!task_work_add(tsk, &tctx->task_work, notify))
> 	...
> }
>=20
> io_uring doesn't set TIF_NOTIFY_SIGNAL for SQPOLL. But if you see it, I'm
> rather curious who does.

I was saying io-uring, but I meant io-uring in the wider sense:
io_queue_worker_create().

Here is a call trace for when TWA_SIGNAL is used. io_queue_worker_create()
uses TWA_SIGNAL. It is called by io_wqe_dec_running(), and not shown due
to inlining:

[   70.540761] Call Trace:
[   70.541352]  dump_stack+0x7d/0x9c
[   70.541930]  task_work_add.cold+0x9/0x12
[   70.542591]  io_wqe_dec_running+0xd6/0xf0
[   70.543259]  io_wq_worker_sleeping+0x3d/0x60
[   70.544106]  schedule+0xa0/0xc0
[   70.544673]  userfaultfd_read_iter+0x2c3/0x790
[   70.545374]  ? wake_up_q+0xa0/0xa0
[   70.545887]  io_iter_do_read+0x1e/0x40
[   70.546531]  io_read+0xdc/0x340
[   70.547148]  ? update_curr+0x72/0x1c0
[   70.547887]  ? update_load_avg+0x7c/0x600
[   70.548538]  ? __switch_to_xtra+0x10a/0x500
[   70.549264]  io_issue_sqe+0xd99/0x1840
[   70.549887]  ? lock_timer_base+0x72/0xa0
[   70.550516]  ? try_to_del_timer_sync+0x54/0x80
[   70.551224]  io_wq_submit_work+0x87/0xb0
[   70.552001]  io_worker_handle_work+0x2b5/0x4b0
[   70.552705]  io_wqe_worker+0xd6/0x2f0
[   70.553364]  ? recalc_sigpending+0x1c/0x50
[   70.554074]  ? io_worker_handle_work+0x4b0/0x4b0
[   70.554813]  ret_from_fork+0x22/0x30

Does it answer your question?

