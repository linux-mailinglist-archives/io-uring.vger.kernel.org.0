Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4405404902
	for <lists+io-uring@lfdr.de>; Thu,  9 Sep 2021 13:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234819AbhIILNq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Sep 2021 07:13:46 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:40548 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234473AbhIILNp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Sep 2021 07:13:45 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 189AgCOc013638;
        Thu, 9 Sep 2021 11:12:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=s5YNY0McrCKxdw78+dPxUNdahNLiiatDXOEv5KptOi0=;
 b=mu8hzqO/8mihBepPdyiduiGcWr360XKbfCBX0XS7+ZcVHKcJq/Cqm7c07lGcV+OFi4jp
 gXpGtJXCN/hPzpqdRSpZLuGdhTIpObDLVGKhNPVZdgqxwPNicEvUuzlCS0Lw++v858bp
 HEgCmlzo1bWYe3Me/iDRSm0EN7rRnJXVtv16Z7pxYCfYP0Yu6icMJEV0bXD77o3KYk74
 A69+vakUAeVUoyG3OFUgtCY2SjzMmiG5xs2JSVpbajvrfSiJiAG5JRa8Gzj55mpDt4wi
 xNw15OzuW0N1w7TgXBe+JEZGm7dZXtByXpufwXyjH4UXQtDCmxuj89HU1L9MYlekMTes vA== 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2042.outbound.protection.outlook.com [104.47.74.42])
        by mx0a-0064b401.pphosted.com with ESMTP id 3ayaf2r7w6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Sep 2021 11:12:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S6qhM5vQcXEsD2fCWdHqKsU0Qqn65nPgn4MCCaDOUUeW7CvsMqMqMPxvEOyamj2wuGHvb8Dd6Qb1ZnFKCgp7TNnHDHQZdYFqv3ldgRPgTeKjpE2nh4+YUQb6fqnTGqujGzVtxve9yDvIau65SjYfk+6wwOyEkS4Z+KQb5/EfoesW5OvqRcFhUnXNZsyDmNzGRx4c0a31mQgGwBzkWoqUucnIPb+hdYWZrXXsB9Fqpv3Y+7G51NmWx6MzujrskUn1B4D645n5WIUja5hiX5wqpKcG1F+kH3mea1nWJ2AtkwcoQds6j4yQYhNSQsb/ITZvGMw8FkTvF1+oj8IXYe5zfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=s5YNY0McrCKxdw78+dPxUNdahNLiiatDXOEv5KptOi0=;
 b=PWHgS2Vdxi99JoLjxAjc4ADSic8GKf3EGR51mrdP2MAqQNP4CY+6i1XF0W91afnHvA8E+ndiEgmXVbDohAO8Yb9zedHUWQB1uqIBy+WcW6lHKIABOoOzqmqWfsDPCR/kam39WuVIQh2cLLmv2194NHO3TvlcV7khU32Jzk+vmbvTSd3GB7fnwAZCsSmKtueAUiv55JFH5OziOMAQiOYTnGcVrA6eZ2ukVLXgmtPAtxvzpIYUMk1yeJoXm4UfI93K+DKMhgp3P+Jr4xFASyb56Dj1GDY8FutjVtVaTT9rPb/Vi+1FsGMf8UNif64E0hs8hV0gJUoF1apGcKhzqj6S+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from BL1PR11MB5478.namprd11.prod.outlook.com (2603:10b6:208:31d::12)
 by BL1PR11MB5478.namprd11.prod.outlook.com (2603:10b6:208:31d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.25; Thu, 9 Sep
 2021 11:12:30 +0000
Received: from BL1PR11MB5478.namprd11.prod.outlook.com
 ([fe80::19db:ee0e:abd0:df6d]) by BL1PR11MB5478.namprd11.prod.outlook.com
 ([fe80::19db:ee0e:abd0:df6d%8]) with mapi id 15.20.4478.025; Thu, 9 Sep 2021
 11:12:30 +0000
From:   "Zhang, Qiang" <Qiang.Zhang@windriver.com>
To:     syzbot <syzbot+65454c239241d3d647da@syzkaller.appspotmail.com>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>
Subject: Re: [syzbot] memory leak in create_io_worker
Thread-Topic: [syzbot] memory leak in create_io_worker
Thread-Index: AQHXpQ74hjG4Ai1gV0euxmu1iU3xwaubi3YW
Date:   Thu, 9 Sep 2021 11:12:29 +0000
Message-ID: <BL1PR11MB5478F0F0CD982C78CA72C0EFFFD59@BL1PR11MB5478.namprd11.prod.outlook.com>
References: <0000000000004fe6b105cb84cf1e@google.com>
In-Reply-To: <0000000000004fe6b105cb84cf1e@google.com>
Accept-Language: en-001, zh-CN, en-US
Content-Language: aa
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 09c6136c-d499-684e-4eb6-b29cef889fee
authentication-results: syzkaller.appspotmail.com; dkim=none (message not
 signed) header.d=none;syzkaller.appspotmail.com; dmarc=none action=none
 header.from=windriver.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 04cf3819-9a7e-42bd-d427-08d97382b6e1
x-ms-traffictypediagnostic: BL1PR11MB5478:
x-microsoft-antispam-prvs: <BL1PR11MB5478E6641EF60906F1B09776FFD59@BL1PR11MB5478.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9ZvsshFpW7s+aVo89OLN4uTRfIEt6vlQqFHX2TKobE/DZ5W1DuVKN8wCjzn5IV0RDKDxtmYsQIZczaAxmEvv9uA1vAs47lLoYc98sOMJou6qNOjGwB6o74or8bbBjrrEJ2nXPldbu5/UeP8IGhKfeeHOCs87r3EIXl1FK8rRQDmaG17a/JBBzT+dHhQBbrgT5ntgkYVhFadejwsLPMRd+O7YHktd/XD9QERhT9OBeGgz0VCbLy76DE04x5400xz8AWpDs5LqLTjt0DAqGeCu+9ftdx4+SNLT/4lB5SwewnNlbe1Vix7S5FMqwV1F+jo2Mw4qwEIgtqerKZq4nfj60T+AkVFNZ4iNxjNcG70JoZoQiaVmslN+ISI+H0hCgzhOMcmjZcrSYqQWNZPZzzyBxqUB4RyPsXSLz9A6fsUDpf68kCS7Xm0Og0NHaD1Aduaz/uiXNmhOzIEslRI643kpwzMh+08y1URyF7UpRMHme0BwgCDOlueZKhQuroLcpA2ScEfdhHpImcEAm/Q8H6zQtEY/nEVvOZ+TinzeTonqnmmBHUdSqnzV6Wfnv4TxWfDtag9nVj2+BP4kktBzgSsl24dOP4U5ytBb0vW0RvC5QEhfSrGwOtiMA92nsyC9P/N7Tz4ctERmh20wFfYWIl1i7lQ0HQ4JhYOkiCixAFRElz2OInyuUOuncFmAEhhiQSUsNoyXcyLJ7pmfHpWAl4Cdj32if8uPBz51Vw7gUB7UK6uqmcndogYHDi7GXph+xGHEs5BKij8Ufiu6+02d0VX6cHrRVWGLstIFfEgHR5Jodf6Xf5RUnBJsgwKLzp8DiPiO+XDFs4bso9ZKAzkGIonJOWyKQrs2vV5vW5s65pyhnDKnXV9u1DYYkKp4grGbAcTxvoJ1M/J0GG9A6vm4MjSnyQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5478.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(39850400004)(376002)(346002)(71200400001)(966005)(478600001)(8936002)(6506007)(53546011)(66476007)(38100700002)(52536014)(186003)(91956017)(64756008)(66556008)(86362001)(9686003)(38070700005)(8676002)(110136005)(33656002)(316002)(122000001)(76116006)(7696005)(55016002)(66946007)(5660300002)(83380400001)(66446008)(2906002)(586874002)(99710200001)(505234006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FpaxHUIIInA7UC9YiZP1OTSYwmDTRbTW5NsUTs0ETyBV07hb8hWvk4uuGIie?=
 =?us-ascii?Q?d+OOSeJuIwD3VjHdFBQcv/b0sKFT+WgHZIarkxMbaxIgE3J4z3ExWqDxCXFT?=
 =?us-ascii?Q?uS6u3w7ia4poLXWfGosfDBHOvwV/0q1/MtXG57Aig34WoQE1ZFXbH8xPR91k?=
 =?us-ascii?Q?3fGE6dY3FTnxKSQV8Ega8XKTssTam+ulL4fmdXvsn4C33m89K44Z8tB89ZAj?=
 =?us-ascii?Q?AkhksR8pbnrszFYpH+FfnzJrP4Td+s0InS51t/rEALzh63xPT7+dHB0fvZAO?=
 =?us-ascii?Q?OIIwCJkiaAkqkPs2YpVzYkZQZHUXPhCxgZKvWcBjlHSmCbMccQIo3YvpPxy5?=
 =?us-ascii?Q?UhlkBvAdB9eZyzvkZXBvATffg5yXAmv4jvou3ALZtywxDzpb+/m5/qO6see3?=
 =?us-ascii?Q?DjBTrwjda5x4sxqTgHtosARiQebJ3+siudVnWyVWXwTetXY1RuyV/xY31TBY?=
 =?us-ascii?Q?Y13Y1PzA1+q1oOSFyn46Z5M8/lv4qcidCkWggpSfynf9c9UuoNFyQCpRbA1q?=
 =?us-ascii?Q?S2sul49Sfw2CWvRFCykBSqbPYL4enulYh5/HZpLZZRMTMiuMkbzAzmTzOtdY?=
 =?us-ascii?Q?oJAWa98dVH8+9qKdzRl9AHWtZvZSpYsfJ2jUokmViv5kSaIu3y7mGLzGAsnY?=
 =?us-ascii?Q?dPUtHytvQ5zAGa5Rp9BdLvgy2zMnlDc2biYndZyeu+NQiKEJUUVZ0Quv4Jm8?=
 =?us-ascii?Q?Q8vB+NrwhKXTa3OyK9Y+bMTPMPnGIUodrNG84B9WfkHsY/uywQzJnDe3aOMl?=
 =?us-ascii?Q?KgWEvw0PegZdR90kD13J9hOdpTGDzWXunfcR3kfSH6SWzaUs7uqrtmdIQkq0?=
 =?us-ascii?Q?UogbGrOf3u/qbRARQLw6PUZk/FIsCuhhoPOH80TRfTiezsX/hDquRv++fsvu?=
 =?us-ascii?Q?MlTXwsmjgiTBhGpkjTcOnNAkFd0coFTL6UV9aMrkdX92m21kA/59SKzPwsp3?=
 =?us-ascii?Q?iOSziH94vkk7c/e9t1JXynGczHMnuYyvh0kAcvWVNzr7UI+5HhHOdFmWF8H8?=
 =?us-ascii?Q?009Lnk+ZAhysJM63yxV7KTZ6HHznfCqn76tzlHFCIDxsDLHHHWnBQIXONnw/?=
 =?us-ascii?Q?VsibJ3IawJSrnzfyhyxD4G4byRwZA3yRJdV+v6IAjmMDbrTdduObxQOwQaUa?=
 =?us-ascii?Q?Dj/AfBSOZO4o1zWcUDZwlilej9vbXr5qLXGVza2XppnAc6/M8jsCiE4Gae7R?=
 =?us-ascii?Q?iV70JjcX+JDOIM8D/9aQ0PrmAEFzD50L3kYmSgMed1wDvzjuDUyZSQ2b+mR1?=
 =?us-ascii?Q?nkUzum6wnI1jVlabxOLpgkgv6CAlC4Exss+sqsQ+CatHI0/rf9Izf864mlyj?=
 =?us-ascii?Q?URKwMYVPBMNJEyP4GNlnEsJ4YFz03xbJxn5qAmnc26zx4xhngcOVRuVFMnaQ?=
 =?us-ascii?Q?XinmSIQ=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5478.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04cf3819-9a7e-42bd-d427-08d97382b6e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2021 11:12:29.8472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X/9H+QfqhVpvxgQF1LZFY+yR+l0ZgUIjwI/ny77FWK9S7swI4ciFtzngLIy4rWITOGC7DhoEIPn8n/b1YT8cAw6FUZxVRreJv6iJ5IqXnc8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5478
X-Proofpoint-GUID: 17A6z4WXGANFx2a0NfL-OaHlndIF7ADK
X-Proofpoint-ORIG-GUID: 17A6z4WXGANFx2a0NfL-OaHlndIF7ADK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-09_03,2021-09-09_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 phishscore=0 priorityscore=1501
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109090068
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

=0A=
=0A=
________________________________________=0A=
From: syzbot <syzbot+65454c239241d3d647da@syzkaller.appspotmail.com>=0A=
Sent: Thursday, 9 September 2021 08:09=0A=
To: asml.silence@gmail.com; axboe@kernel.dk; io-uring@vger.kernel.org; linu=
x-kernel@vger.kernel.org; syzkaller-bugs@googlegroups.com=0A=
Subject: [syzbot] memory leak in create_io_worker=0A=
=0A=
[Please note: This e-mail is from an EXTERNAL e-mail address]=0A=
=0A=
Hello,=0A=
=0A=
syzbot found the following issue on:=0A=
=0A=
HEAD commit:    0bcfe68b8767 Revert "memcg: enable accounting for pollfd a.=
.=0A=
git tree:       upstream=0A=
console output: https://syzkaller.appspot.com/x/log.txt?x=3D152ccba3300000=
=0A=
kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dc2f4c21cbd29de3=
d=0A=
dashboard link: https://syzkaller.appspot.com/bug?extid=3D65454c239241d3d64=
7da=0A=
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils=
 for Debian) 2.35.1=0A=
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D123d31b330000=
0=0A=
=0A=
IMPORTANT: if you fix the issue, please add the following tag to the commit=
:=0A=
Reported-by: syzbot+65454c239241d3d647da@syzkaller.appspotmail.com=0A=
=0A=
2021/09/08 01:29:02 executed programs: 33=0A=
2021/09/08 01:29:08 executed programs: 42=0A=
2021/09/08 01:29:15 executed programs: 62=0A=
2021/09/08 01:29:21 executed programs: 82=0A=
BUG: memory leak=0A=
unreferenced object 0xffff888126fcd6c0 (size 192):=0A=
  comm "syz-executor.1", pid 11934, jiffies 4294983026 (age 15.690s)=0A=
  hex dump (first 32 bytes):=0A=
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................=0A=
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................=0A=
  backtrace:=0A=
    [<ffffffff81632c91>] kmalloc_node include/linux/slab.h:609 [inline]=0A=
    [<ffffffff81632c91>] kzalloc_node include/linux/slab.h:732 [inline]=0A=
    [<ffffffff81632c91>] create_io_worker+0x41/0x1e0 fs/io-wq.c:739=0A=
    [<ffffffff8163311e>] io_wqe_create_worker fs/io-wq.c:267 [inline]=0A=
    [<ffffffff8163311e>] io_wqe_enqueue+0x1fe/0x330 fs/io-wq.c:866=0A=
    [<ffffffff81620b64>] io_queue_async_work+0xc4/0x200 fs/io_uring.c:1473=
=0A=
    [<ffffffff8162c59c>] __io_queue_sqe+0x34c/0x510 fs/io_uring.c:6933=0A=
    [<ffffffff8162c7ab>] io_req_task_submit+0x4b/0xa0 fs/io_uring.c:2233=0A=
    [<ffffffff8162cb48>] io_async_task_func+0x108/0x1c0 fs/io_uring.c:5462=
=0A=
    [<ffffffff816259e3>] tctx_task_work+0x1b3/0x3a0 fs/io_uring.c:2158=0A=
    [<ffffffff81269b43>] task_work_run+0x73/0xb0 kernel/task_work.c:164=0A=
    [<ffffffff812dcdd1>] tracehook_notify_signal include/linux/tracehook.h:=
212 [inline]=0A=
    [<ffffffff812dcdd1>] handle_signal_work kernel/entry/common.c:146 [inli=
ne]=0A=
    [<ffffffff812dcdd1>] exit_to_user_mode_loop kernel/entry/common.c:172 [=
inline]=0A=
    [<ffffffff812dcdd1>] exit_to_user_mode_prepare+0x151/0x180 kernel/entry=
/common.c:209=0A=
    [<ffffffff843ff25d>] __syscall_exit_to_user_mode_work kernel/entry/comm=
on.c:291 [inline]=0A=
    [<ffffffff843ff25d>] syscall_exit_to_user_mode+0x1d/0x40 kernel/entry/c=
ommon.c:302=0A=
    [<ffffffff843fa4a2>] do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86=
=0A=
    [<ffffffff84600068>] entry_SYSCALL_64_after_hwframe+0x44/0xae=0A=
=0A=
=0A=
=0A=
Hello Pavel=0A=
=0A=
This looks like  io-worker create fail trigger memleak. =0A=
=0A=
diff --git a/fs/io-wq.c b/fs/io-wq.c=0A=
index 35e7ee26f7ea..27fa0506c1a6 100644=0A=
--- a/fs/io-wq.c=0A=
+++ b/fs/io-wq.c=0A=
@@ -709,6 +709,7 @@ static void create_worker_cont(struct callback_head *cb=
)=0A=
                }=0A=
                raw_spin_unlock(&wqe->lock);=0A=
                io_worker_ref_put(wqe->wq);=0A=
+               kfree(worker);=0A=
                return;=0A=
        }=0A=
=0A=
@@ -725,6 +726,7 @@ static void io_workqueue_create(struct work_struct *wor=
k)=0A=
        if (!io_queue_worker_create(worker, acct, create_worker_cont)) {=0A=
                clear_bit_unlock(0, &worker->create_state);=0A=
                io_worker_release(worker);=0A=
+               kfree(worker);=0A=
        }=0A=
 }=0A=
=0A=
@@ -759,6 +761,7 @@ static bool create_io_worker(struct io_wq *wq, struct i=
o_wqe *wqe, int index)=0A=
        if (!IS_ERR(tsk)) {=0A=
                io_init_new_worker(wqe, worker, tsk);=0A=
        } else if (!io_should_retry_thread(PTR_ERR(tsk))) {=0A=
+               kfree(worker);=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
---=0A=
This report is generated by a bot. It may contain errors.=0A=
See https://goo.gl/tpsmEJ for more information about syzbot.=0A=
syzbot engineers can be reached at syzkaller@googlegroups.com.=0A=
=0A=
syzbot will keep track of this issue. See:=0A=
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.=0A=
syzbot can test patches for this issue, for details see:=0A=
https://goo.gl/tpsmEJ#testing-patches=0A=
