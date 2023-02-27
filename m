Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E066E6A3B34
	for <lists+io-uring@lfdr.de>; Mon, 27 Feb 2023 07:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjB0GXN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Feb 2023 01:23:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjB0GXM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Feb 2023 01:23:12 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD81A5DD;
        Sun, 26 Feb 2023 22:23:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=InxDJX40QFoE1hiU37FLCLR3c1abU+pFzflV74pP79BZPx7iWLoprOHaQIy5PyVj5Xli+zxfOI0IlmJ/K+sC6VQaXn75MC4zFj3NBDgLByla6As2aqQaWRg3S7dLQQ+3LHNeq9gzFH935mvVYRffpJa6owqJcNs/0k+apzdL8XuMM9H4Pj3MbVpoUAwS5LLWlFaeoIWUAeu7Xuarb7rgE0q1Aga+mNAFhnYF5k+VzCIWvm9j/5SdLS/eGslAlF3sbi1yLSSDw6gGTocjWhCXA3wsEpmDURl1/7atrnE8NzIqYeuAdMMqixcnTUupWI2+P+4uEQtJubx6MGAjh1dYwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=llflnuB1mSBf2wNPkK5xIEJm0NtSCc+q0JQyG/xVlSQ=;
 b=Yn52M24WupTdJZ1totLL8DAeEUg9K1P85VzgabEVe65N8hi5PaISi5Xod544OiiXGosOWbbXuWWdCTZKv4fN5/oCdQi6CELPDbWPbgASmaMrnBHCJhLnO41pNnM7ItOA/j1qgk8Y/vCMirtLndjw+TwOAM2kT8E+Hpk5TmSeXLQew1HPCdi79qWyI5oVYIYcqQxPGnNt6J2q24x2TmSEL70k8kYPGZiltkqikveEpkIoqx4j+uy2J5QGXkntWPXp9pkD9Aw1Dw6foTHz5bPpV7jo6dQH7NPiTyGcNVuJ86F3H3S+fZwu6qJu5U7aWkoaIKHvESnwVXjoMNGtY6anzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=knights.ucf.edu; dmarc=pass action=none
 header.from=knights.ucf.edu; dkim=pass header.d=knights.ucf.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=knightsucfedu39751.onmicrosoft.com;
 s=selector2-knightsucfedu39751-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=llflnuB1mSBf2wNPkK5xIEJm0NtSCc+q0JQyG/xVlSQ=;
 b=RBAVJIDFLgs4g1uYKM8qvIAim8Jyjg16wLrb4nrdE6Z7zS+puYBG0s6gRJ5UB9BADZalV+4FcNehcrRpO4Z8Q1s19dJ/sfOYl1wkNCPx+/0uT7rMb6Zewn5LsbIB4hFccUhK40ozADS4bqaVtbhWLLCIaydadfcssnI8GWSSTQs=
Received: from IA1PR07MB9830.namprd07.prod.outlook.com (2603:10b6:208:44b::14)
 by SJ0PR07MB9123.namprd07.prod.outlook.com (2603:10b6:a03:3f8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.27; Mon, 27 Feb
 2023 06:23:02 +0000
Received: from IA1PR07MB9830.namprd07.prod.outlook.com
 ([fe80::d883:f078:37f:dace]) by IA1PR07MB9830.namprd07.prod.outlook.com
 ([fe80::d883:f078:37f:dace%4]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 06:23:02 +0000
From:   Sanan Hasanov <sanan.hasanov@Knights.ucf.edu>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>,
        "contact@pgazz.com" <contact@pgazz.com>
Subject: INFO: task hung in io_ring_exit_work
Thread-Topic: INFO: task hung in io_ring_exit_work
Thread-Index: AQHZSm5R7ehLbvb9SU2e/Nc1TT/1hg==
Date:   Mon, 27 Feb 2023 06:23:02 +0000
Message-ID: <IA1PR07MB9830E72E8A3426B8151185BAABAF9@IA1PR07MB9830.namprd07.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=Knights.ucf.edu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR07MB9830:EE_|SJ0PR07MB9123:EE_
x-ms-office365-filtering-correlation-id: 7ec303cc-e95f-4056-7758-08db188b142c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K0D9NhCkxIrsEhOIm75VKxU+ttCOhJH+lx3w+1uguhjUXJXtiU2PeLHEOI8vcdOMfay2KiVVSRz2eNGL3qf/tB0lkDiwWiwCoFVwZpOHWarOHuohbuvcjWyWKWZgnVAfpV8SsGKPrFnorUmPwfWMoeRbvtLph9B+EkID8CM4nxdTY0LYW0OSXjjp78KfdMXJDWIoIutFwwinnW24kT7RkRZwkyHEP9bFO3BiWqIcPD5H0hBFh2qs1bH8ygdzpz3Gr/LYdhK6nWE+K0SQRr77VlY35ncO0dLWVoXtBQoZkDiwjxCSB/5PMXLnn6PeC/8+FqwU5mRAOUz3uPe224bi83xXtNpMhI5EDeaAEnTnuR2RICU3GupCwp4/h9/Z23PmWkIaJ2dhpvFReJefJ8/iCGeJNnU46wjHpv7e4kJ8I2Rqoi6aF8/wQJcpfuSFXU+egBK03zLejbSJrH0Ug/fGBMBlPFpLvEoEm0HMrDBqQq/mZETjlKoWKWBCxCjT5rMYqBKpgdiOZcyXGOJA//Sl+yhMFM8DLIJH61A6W4h70G3jb8bQiaCIi+/FkTsa/vfmslcG8DTTSYMximxrSpK1m4EFdks14WaOWc1XwOQtWrU2MrwE0O6BXTRuy3lH4iA8DWNZc2Hc5cHNJAXjoVAVZtJZF/jMmKb7szzfMYi4cpt30pD58ZlVgBu7oTJF/J/LsUxwD0PLFy2ihtCfXzZoFA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR07MB9830.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(451199018)(83380400001)(30864003)(52536014)(44832011)(8936002)(2906002)(5660300002)(122000001)(55016003)(38070700005)(41300700001)(76116006)(64756008)(66446008)(66476007)(66556008)(91956017)(66946007)(5930299012)(8676002)(38100700002)(4326008)(7696005)(966005)(86362001)(41320700001)(9686003)(186003)(26005)(6506007)(71200400001)(478600001)(75432002)(33656002)(316002)(786003)(110136005)(54906003)(579004)(559001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?rwdGbXk1ykJbVC3DlZURaqCLYu3A9EoJtzHA/MvPNUVnt61ckmc7ePK/Av?=
 =?iso-8859-1?Q?7lwjKEeHMCGPsMkyEtS2PKnKn/w3fATFAcISWur/WaSD63/KtDgLSn9TLL?=
 =?iso-8859-1?Q?tL6d+vaEw+YFUyb0mx/9rTSx8sD8PhXv4bv1s88A15TWi3sU4D4R/CMPzu?=
 =?iso-8859-1?Q?IOP6bW4yDuvRLKqbQB0eHvlVQQKjtYelMywDMlNrNwOiU1OT7gR3qmyhxu?=
 =?iso-8859-1?Q?fD9b6wFmAeqotlQw+FHoqquBa3wpmjxPhWrTx54H9ih8Etio2Nxvuw4EUz?=
 =?iso-8859-1?Q?mlifsr4BVzg3Blkzbe/69wzkmRAxIDUxZ7yFCoDSI0S9gZX0EsO0a/h9su?=
 =?iso-8859-1?Q?zo0q0aI2fSxZ/YUSZUiVkwR706tNgfg2g7Kc/1UypEw+HKQTQ6KphGxjJt?=
 =?iso-8859-1?Q?5TV0GiR0nMPhHla7CZHSIk7yo0cgvdMejTRD3TddI8v1kZUSA9BUJ192VZ?=
 =?iso-8859-1?Q?KDwGYSgnuMuv6YTqSPHvSxMbC2zJ6g1IjepAikG11caI8P64rbyt4PscDy?=
 =?iso-8859-1?Q?SKJ7ar8nB/PmZYzz7LFfSMzKYpF/E8RjwP+IC6tgtkbF0UuZzDQeeitKVc?=
 =?iso-8859-1?Q?HsoFZsOGaimkXwtb7KRxGNUBtuCdH5lh3pjRlkxmNRV2p3zFBw/Y+daxUd?=
 =?iso-8859-1?Q?BdHvO5GusX+77vS18dnMuTNqr4GVGICatk7fgTB2dIMumu3uRnMnaN+th1?=
 =?iso-8859-1?Q?u35zdUCDPZMUysBqhZ957ieRhdzc5uYra1yY8oN51zWg8v++lVT94Au1iF?=
 =?iso-8859-1?Q?3lZv4f2WTV2P9rJpajlfBouNFF16LUOvIECavLX6Aq+LBW3xFLQhPCJfVk?=
 =?iso-8859-1?Q?PwCm0mf537xaLrFx0UiT+JidwNwMK88Sggh/ofVQ6I1N9SKnXFD0rtJGXj?=
 =?iso-8859-1?Q?vquQ/PU4xBjz0R69w5H2g0OXnGQFlpsHZg78iRIz1wC2Wwya1n11DsEqtb?=
 =?iso-8859-1?Q?LY0yI+7n4eOxbzc4+E5NGmrRwma+erczew8CwwjnAaUYBq6amRGcrdCHqO?=
 =?iso-8859-1?Q?s4rLQviLssHGyKxWy4ajjJaUkGYrOdt5wXwfcV/DZ89RR04q9PoQLyv1uG?=
 =?iso-8859-1?Q?plWw1dXTeik+JKqW4fLtNCdcDNvpEIrSXDd9EznwviY/tbjgadlxhAI0Nc?=
 =?iso-8859-1?Q?A5a7jOWAqThg6F6CNeYoHs/2Odsw609uhlkEjfqDU8ilzOoXA7K1OVO9iy?=
 =?iso-8859-1?Q?FYv99gk5Dklrm3Bil9RtHcg4OK1NgIVllSfxT7OupW5+ZOadv/J0HWpsfx?=
 =?iso-8859-1?Q?0gWWn16ta5PI2dW8zTQQFZTnNTHWf5TXa68IBlPqc/URm1rjCkvjwsdeiN?=
 =?iso-8859-1?Q?G2TskDDwo5SYZ6PQBmFnwMheI7arHbhrSJdQBZdIBEvHWFIDrTHmCLxreL?=
 =?iso-8859-1?Q?FFG6dhU4I1O74ia5SY22NZW1q85gjWIpnqwwn2LiPTp1IMeADtRzLkMklm?=
 =?iso-8859-1?Q?vlkaI7HhmVI1ASZ+8x3bR3JQD0jUyLQbUDZM0rXCjz3ZtqUCJ9MgKG98yE?=
 =?iso-8859-1?Q?BDW7Hp4nwl0x50gKTPN7rzv3OP0Zaedv33P8de5Z3bsiOLRsh8pEuEZVNB?=
 =?iso-8859-1?Q?s6e+cBGaQsDI3TpucUPWLZwY/UL2CMjYQwOV9M1Q+EHF2WZ4DneVEkcunH?=
 =?iso-8859-1?Q?jjQ0WmNv0jE3JNjIg7yoSKHKmKhtnIvJPQ?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: knights.ucf.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR07MB9830.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ec303cc-e95f-4056-7758-08db188b142c
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2023 06:23:02.0567
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5b16e182-78b3-412c-9196-68342689eeb7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tqzqrmxkIA1/oKsl9/45k+g5AaHfm8FE7EFVWOwqTePw0cgwUwuaobAFQmkjo2ynQ1+kxuXNZ86H8z4eLOT6fjW74H3pOWd9cZTkRHMo5i8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR07MB9123
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Good day, dear maintainers,=0A=
=0A=
We found a bug using a modified kernel configuration file used by syzbot.=
=0A=
=0A=
We enhanced the coverage of the configuration file using our tool, klocaliz=
er.=0A=
=0A=
Kernel Branch: 6.2.0-next-20230225=0A=
Kernel config:=A0https://drive.google.com/file/d/1NS9N8rvftQ7BouImn2OVnC96q=
rNhAeuO/view?usp=3Dshare_link=0A=
C Reproducer:=A0Unfortunately, there is no reproducer for this bug yet.=0A=
=0A=
Thank you!=0A=
=0A=
Best regards,=0A=
Sanan Hasanov=0A=
=0A=
INFO: task kworker/u16:20:839 blocked for more than 143 seconds.=0A=
=A0 =A0 =A0 Not tainted 6.2.0-next-20230225 #1=0A=
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.=
=0A=
task:kworker/u16:20 =A0state:D stack:25504 pid:839 =A0 ppid:2 =A0 =A0 =A0fl=
ags:0x00004000=0A=
Workqueue: events_unbound io_ring_exit_work=0A=
Call Trace:=0A=
=A0<TASK>=0A=
=A0context_switch kernel/sched/core.c:5304 [inline]=0A=
=A0__schedule+0x24bc/0x5a60 kernel/sched/core.c:6622=0A=
=A0schedule+0xe7/0x1b0 kernel/sched/core.c:6698=0A=
=A0schedule_timeout+0x26e/0x2b0 kernel/time/timer.c:2143=0A=
=A0do_wait_for_common kernel/sched/completion.c:85 [inline]=0A=
=A0__wait_for_common+0x1ce/0x5d0 kernel/sched/completion.c:106=0A=
=A0io_ring_exit_work+0x543/0x13c0 io_uring/io_uring.c:3027=0A=
=A0process_one_work+0x9ba/0x1820 kernel/workqueue.c:2390=0A=
=A0worker_thread+0x669/0x1090 kernel/workqueue.c:2537=0A=
=A0kthread+0x2e8/0x3a0 kernel/kthread.c:376=0A=
=A0ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308=0A=
=A0</TASK>=0A=
INFO: task kworker/u16:24:842 blocked for more than 143 seconds.=0A=
=A0 =A0 =A0 Not tainted 6.2.0-next-20230225 #1=0A=
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.=
=0A=
task:kworker/u16:24 =A0state:D stack:25472 pid:842 =A0 ppid:2 =A0 =A0 =A0fl=
ags:0x00004000=0A=
Workqueue: events_unbound io_ring_exit_work=0A=
Call Trace:=0A=
=A0<TASK>=0A=
=A0context_switch kernel/sched/core.c:5304 [inline]=0A=
=A0__schedule+0x24bc/0x5a60 kernel/sched/core.c:6622=0A=
=A0schedule+0xe7/0x1b0 kernel/sched/core.c:6698=0A=
=A0schedule_timeout+0x26e/0x2b0 kernel/time/timer.c:2143=0A=
=A0do_wait_for_common kernel/sched/completion.c:85 [inline]=0A=
=A0__wait_for_common+0x1ce/0x5d0 kernel/sched/completion.c:106=0A=
=A0io_ring_exit_work+0x543/0x13c0 io_uring/io_uring.c:3027=0A=
=A0process_one_work+0x9ba/0x1820 kernel/workqueue.c:2390=0A=
=A0worker_thread+0x669/0x1090 kernel/workqueue.c:2537=0A=
=A0kthread+0x2e8/0x3a0 kernel/kthread.c:376=0A=
=A0ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308=0A=
=A0</TASK>=0A=
INFO: task kworker/u16:27:845 blocked for more than 143 seconds.=0A=
=A0 =A0 =A0 Not tainted 6.2.0-next-20230225 #1=0A=
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.=
=0A=
task:kworker/u16:27 =A0state:D stack:25120 pid:845 =A0 ppid:2 =A0 =A0 =A0fl=
ags:0x00004000=0A=
Workqueue: events_unbound io_ring_exit_work=0A=
Call Trace:=0A=
=A0<TASK>=0A=
=A0context_switch kernel/sched/core.c:5304 [inline]=0A=
=A0__schedule+0x24bc/0x5a60 kernel/sched/core.c:6622=0A=
=A0schedule+0xe7/0x1b0 kernel/sched/core.c:6698=0A=
=A0schedule_timeout+0x26e/0x2b0 kernel/time/timer.c:2143=0A=
=A0do_wait_for_common kernel/sched/completion.c:85 [inline]=0A=
=A0__wait_for_common+0x1ce/0x5d0 kernel/sched/completion.c:106=0A=
=A0io_ring_exit_work+0x543/0x13c0 io_uring/io_uring.c:3027=0A=
=A0process_one_work+0x9ba/0x1820 kernel/workqueue.c:2390=0A=
=A0worker_thread+0x669/0x1090 kernel/workqueue.c:2537=0A=
=A0kthread+0x2e8/0x3a0 kernel/kthread.c:376=0A=
=A0ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308=0A=
=A0</TASK>=0A=
INFO: task kworker/u16:57:870 blocked for more than 143 seconds.=0A=
=A0 =A0 =A0 Not tainted 6.2.0-next-20230225 #1=0A=
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.=
=0A=
task:kworker/u16:57 =A0state:D stack:25120 pid:870 =A0 ppid:2 =A0 =A0 =A0fl=
ags:0x00004000=0A=
Workqueue: events_unbound io_ring_exit_work=0A=
Call Trace:=0A=
=A0<TASK>=0A=
=A0context_switch kernel/sched/core.c:5304 [inline]=0A=
=A0__schedule+0x24bc/0x5a60 kernel/sched/core.c:6622=0A=
=A0schedule+0xe7/0x1b0 kernel/sched/core.c:6698=0A=
=A0schedule_timeout+0x26e/0x2b0 kernel/time/timer.c:2143=0A=
=A0do_wait_for_common kernel/sched/completion.c:85 [inline]=0A=
=A0__wait_for_common+0x1ce/0x5d0 kernel/sched/completion.c:106=0A=
=A0io_ring_exit_work+0x543/0x13c0 io_uring/io_uring.c:3027=0A=
=A0process_one_work+0x9ba/0x1820 kernel/workqueue.c:2390=0A=
=A0worker_thread+0x669/0x1090 kernel/workqueue.c:2537=0A=
=A0kthread+0x2e8/0x3a0 kernel/kthread.c:376=0A=
=A0ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308=0A=
=A0</TASK>=0A=
INFO: task kworker/u16:58:871 blocked for more than 143 seconds.=0A=
=A0 =A0 =A0 Not tainted 6.2.0-next-20230225 #1=0A=
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.=
=0A=
task:kworker/u16:58 =A0state:D stack:24624 pid:871 =A0 ppid:2 =A0 =A0 =A0fl=
ags:0x00004000=0A=
Workqueue: events_unbound io_ring_exit_work=0A=
Call Trace:=0A=
=A0<TASK>=0A=
=A0context_switch kernel/sched/core.c:5304 [inline]=0A=
=A0__schedule+0x24bc/0x5a60 kernel/sched/core.c:6622=0A=
=A0schedule+0xe7/0x1b0 kernel/sched/core.c:6698=0A=
=A0schedule_timeout+0x26e/0x2b0 kernel/time/timer.c:2143=0A=
=A0do_wait_for_common kernel/sched/completion.c:85 [inline]=0A=
=A0__wait_for_common+0x1ce/0x5d0 kernel/sched/completion.c:106=0A=
=A0io_ring_exit_work+0x543/0x13c0 io_uring/io_uring.c:3027=0A=
=A0process_one_work+0x9ba/0x1820 kernel/workqueue.c:2390=0A=
=A0worker_thread+0x669/0x1090 kernel/workqueue.c:2537=0A=
=A0kthread+0x2e8/0x3a0 kernel/kthread.c:376=0A=
=A0ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308=0A=
=A0</TASK>=0A=
INFO: task kworker/u16:60:874 blocked for more than 143 seconds.=0A=
=A0 =A0 =A0 Not tainted 6.2.0-next-20230225 #1=0A=
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.=
=0A=
task:kworker/u16:60 =A0state:D stack:24784 pid:874 =A0 ppid:2 =A0 =A0 =A0fl=
ags:0x00004000=0A=
Workqueue: events_unbound io_ring_exit_work=0A=
Call Trace:=0A=
=A0<TASK>=0A=
=A0context_switch kernel/sched/core.c:5304 [inline]=0A=
=A0__schedule+0x24bc/0x5a60 kernel/sched/core.c:6622=0A=
=A0schedule+0xe7/0x1b0 kernel/sched/core.c:6698=0A=
=A0schedule_timeout+0x26e/0x2b0 kernel/time/timer.c:2143=0A=
=A0do_wait_for_common kernel/sched/completion.c:85 [inline]=0A=
=A0__wait_for_common+0x1ce/0x5d0 kernel/sched/completion.c:106=0A=
=A0io_ring_exit_work+0x543/0x13c0 io_uring/io_uring.c:3027=0A=
=A0process_one_work+0x9ba/0x1820 kernel/workqueue.c:2390=0A=
=A0worker_thread+0x669/0x1090 kernel/workqueue.c:2537=0A=
=A0kthread+0x2e8/0x3a0 kernel/kthread.c:376=0A=
=A0ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308=0A=
=A0</TASK>=0A=
INFO: task kworker/u16:62:875 blocked for more than 143 seconds.=0A=
=A0 =A0 =A0 Not tainted 6.2.0-next-20230225 #1=0A=
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.=
=0A=
task:kworker/u16:62 =A0state:D stack:24864 pid:875 =A0 ppid:2 =A0 =A0 =A0fl=
ags:0x00004000=0A=
Workqueue: events_unbound io_ring_exit_work=0A=
Call Trace:=0A=
=A0<TASK>=0A=
=A0context_switch kernel/sched/core.c:5304 [inline]=0A=
=A0__schedule+0x24bc/0x5a60 kernel/sched/core.c:6622=0A=
=A0schedule+0xe7/0x1b0 kernel/sched/core.c:6698=0A=
=A0schedule_timeout+0x26e/0x2b0 kernel/time/timer.c:2143=0A=
=A0do_wait_for_common kernel/sched/completion.c:85 [inline]=0A=
=A0__wait_for_common+0x1ce/0x5d0 kernel/sched/completion.c:106=0A=
=A0io_ring_exit_work+0x543/0x13c0 io_uring/io_uring.c:3027=0A=
=A0process_one_work+0x9ba/0x1820 kernel/workqueue.c:2390=0A=
=A0worker_thread+0x669/0x1090 kernel/workqueue.c:2537=0A=
=A0kthread+0x2e8/0x3a0 kernel/kthread.c:376=0A=
=A0ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308=0A=
=A0</TASK>=0A=
INFO: task kworker/u16:63:876 blocked for more than 143 seconds.=0A=
=A0 =A0 =A0 Not tainted 6.2.0-next-20230225 #1=0A=
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.=
=0A=
task:kworker/u16:63 =A0state:D stack:24272 pid:876 =A0 ppid:2 =A0 =A0 =A0fl=
ags:0x00004000=0A=
Workqueue: events_unbound io_ring_exit_work=0A=
Call Trace:=0A=
=A0<TASK>=0A=
=A0context_switch kernel/sched/core.c:5304 [inline]=0A=
=A0__schedule+0x24bc/0x5a60 kernel/sched/core.c:6622=0A=
=A0schedule+0xe7/0x1b0 kernel/sched/core.c:6698=0A=
=A0schedule_timeout+0x26e/0x2b0 kernel/time/timer.c:2143=0A=
=A0do_wait_for_common kernel/sched/completion.c:85 [inline]=0A=
=A0__wait_for_common+0x1ce/0x5d0 kernel/sched/completion.c:106=0A=
=A0io_ring_exit_work+0x543/0x13c0 io_uring/io_uring.c:3027=0A=
=A0process_one_work+0x9ba/0x1820 kernel/workqueue.c:2390=0A=
=A0worker_thread+0x669/0x1090 kernel/workqueue.c:2537=0A=
=A0kthread+0x2e8/0x3a0 kernel/kthread.c:376=0A=
=A0ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308=0A=
=A0</TASK>=0A=
INFO: task kworker/u16:64:877 blocked for more than 143 seconds.=0A=
=A0 =A0 =A0 Not tainted 6.2.0-next-20230225 #1=0A=
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.=
=0A=
task:kworker/u16:64 =A0state:D stack:25008 pid:877 =A0 ppid:2 =A0 =A0 =A0fl=
ags:0x00004000=0A=
Workqueue: events_unbound io_ring_exit_work=0A=
Call Trace:=0A=
=A0<TASK>=0A=
=A0context_switch kernel/sched/core.c:5304 [inline]=0A=
=A0__schedule+0x24bc/0x5a60 kernel/sched/core.c:6622=0A=
=A0schedule+0xe7/0x1b0 kernel/sched/core.c:6698=0A=
=A0schedule_timeout+0x26e/0x2b0 kernel/time/timer.c:2143=0A=
=A0do_wait_for_common kernel/sched/completion.c:85 [inline]=0A=
=A0__wait_for_common+0x1ce/0x5d0 kernel/sched/completion.c:106=0A=
=A0io_ring_exit_work+0x543/0x13c0 io_uring/io_uring.c:3027=0A=
=A0process_one_work+0x9ba/0x1820 kernel/workqueue.c:2390=0A=
=A0worker_thread+0x669/0x1090 kernel/workqueue.c:2537=0A=
=A0kthread+0x2e8/0x3a0 kernel/kthread.c:376=0A=
=A0ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308=0A=
=A0</TASK>=0A=
INFO: task kworker/u16:0:28836 blocked for more than 143 seconds.=0A=
=A0 =A0 =A0 Not tainted 6.2.0-next-20230225 #1=0A=
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.=
=0A=
task:kworker/u16:0 =A0 state:D stack:25472 pid:28836 ppid:2 =A0 =A0 =A0flag=
s:0x00004000=0A=
Workqueue: loop2 loop_rootcg_workfn=0A=
Call Trace:=0A=
=A0<TASK>=0A=
=A0context_switch kernel/sched/core.c:5304 [inline]=0A=
=A0__schedule+0x24bc/0x5a60 kernel/sched/core.c:6622=0A=
=A0schedule+0xe7/0x1b0 kernel/sched/core.c:6698=0A=
=A0io_schedule+0xbe/0x130 kernel/sched/core.c:8884=0A=
=A0folio_wait_bit_common+0x390/0x9b0 mm/filemap.c:1301=0A=
=A0__folio_lock mm/filemap.c:1664 [inline]=0A=
=A0folio_lock include/linux/pagemap.h:952 [inline]=0A=
=A0folio_lock include/linux/pagemap.h:948 [inline]=0A=
=A0__filemap_get_folio+0xb13/0xd20 mm/filemap.c:1936=0A=
=A0shmem_get_folio_gfp+0x41e/0x1960 mm/shmem.c:1880=0A=
=A0shmem_get_folio mm/shmem.c:2071 [inline]=0A=
=A0shmem_file_read_iter+0x569/0xa50 mm/shmem.c:2748=0A=
=A0call_read_iter include/linux/fs.h:1845 [inline]=0A=
=A0do_iter_readv_writev+0x2df/0x3b0 fs/read_write.c:733=0A=
=A0do_iter_read+0x2f2/0x750 fs/read_write.c:796=0A=
=A0vfs_iter_read+0x74/0xa0 fs/read_write.c:838=0A=
=A0lo_read_simple drivers/block/loop.c:290 [inline]=0A=
=A0do_req_filebacked drivers/block/loop.c:500 [inline]=0A=
=A0loop_handle_cmd drivers/block/loop.c:1879 [inline]=0A=
=A0loop_process_work+0x15a8/0x2130 drivers/block/loop.c:1914=0A=
=A0process_one_work+0x9ba/0x1820 kernel/workqueue.c:2390=0A=
=A0worker_thread+0x669/0x1090 kernel/workqueue.c:2537=0A=
=A0kthread+0x2e8/0x3a0 kernel/kthread.c:376=0A=
=A0ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308=0A=
=A0</TASK>=0A=
Future hung task reports are suppressed, see sysctl kernel.hung_task_warnin=
gs=0A=
=0A=
Showing all locks held in the system:=0A=
1 lock held by rcu_tasks_kthre/12:=0A=
=A0#0: ffffffff8bf915f0 (rcu_tasks.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tas=
ks_one_gp+0x2e/0xd90 kernel/rcu/tasks.h:510=0A=
1 lock held by rcu_tasks_trace/13:=0A=
=A0#0: ffffffff8bf912f0 (rcu_tasks_trace.tasks_gp_mutex){+.+.}-{3:3}, at: r=
cu_tasks_one_gp+0x2e/0xd90 kernel/rcu/tasks.h:510=0A=
1 lock held by khungtaskd/59:=0A=
=A0#0: ffffffff8bf92140 (rcu_read_lock){....}-{1:2}, at: debug_show_all_loc=
ks+0x55/0x340 kernel/locking/lockdep.c:6495=0A=
1 lock held by in:imklog/7366:=0A=
=A0#0: ffff88811488a168 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe7/=
0x100 fs/file.c:1046=0A=
1 lock held by syz-fuzzer/7263:=0A=
2 locks held by kworker/u16:20/839:=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: at=
omic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_data kernel/workqueue.c:639 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: pr=
ocess_one_work+0x868/0x1820 kernel/workqueue.c:2361=0A=
=A0#1: ffffc90007487da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, a=
t: process_one_work+0x89c/0x1820 kernel/workqueue.c:2365=0A=
2 locks held by kworker/u16:24/842:=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: at=
omic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_data kernel/workqueue.c:639 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: pr=
ocess_one_work+0x868/0x1820 kernel/workqueue.c:2361=0A=
=A0#1: ffffc900074b7da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, a=
t: process_one_work+0x89c/0x1820 kernel/workqueue.c:2365=0A=
2 locks held by kworker/u16:27/845:=0A=
=A0#0: =0A=
ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atom=
ic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]=0A=
ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atom=
ic_long_set include/linux/atomic/atomic-long.h:41 [inline]=0A=
ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_lo=
ng_set include/linux/atomic/atomic-instrumented.h:1280 [inline]=0A=
ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_=
data kernel/workqueue.c:639 [inline]=0A=
ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_=
pool_and_clear_pending kernel/workqueue.c:666 [inline]=0A=
ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_o=
ne_work+0x868/0x1820 kernel/workqueue.c:2361=0A=
=A0#1: ffffc900074e7da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, a=
t: process_one_work+0x89c/0x1820 kernel/workqueue.c:2365=0A=
2 locks held by kworker/u16:57/870:=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: at=
omic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_data kernel/workqueue.c:639 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: pr=
ocess_one_work+0x868/0x1820 kernel/workqueue.c:2361=0A=
=A0#1: ffffc900076bfda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, a=
t: process_one_work+0x89c/0x1820 kernel/workqueue.c:2365=0A=
2 locks held by kworker/u16:58/871:=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: at=
omic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_data kernel/workqueue.c:639 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: pr=
ocess_one_work+0x868/0x1820 kernel/workqueue.c:2361=0A=
=A0#1: ffffc900076cfda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, a=
t: process_one_work+0x89c/0x1820 kernel/workqueue.c:2365=0A=
2 locks held by kworker/u16:60/874:=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: at=
omic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_data kernel/workqueue.c:639 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: pr=
ocess_one_work+0x868/0x1820 kernel/workqueue.c:2361=0A=
=A0#1: ffffc9000775fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, a=
t: process_one_work+0x89c/0x1820 kernel/workqueue.c:2365=0A=
2 locks held by kworker/u16:62/875:=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: at=
omic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_data kernel/workqueue.c:639 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: pr=
ocess_one_work+0x868/0x1820 kernel/workqueue.c:2361=0A=
=A0#1: ffffc9000776fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, a=
t: process_one_work+0x89c/0x1820 kernel/workqueue.c:2365=0A=
2 locks held by kworker/u16:63/876:=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: at=
omic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_data kernel/workqueue.c:639 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: pr=
ocess_one_work+0x868/0x1820 kernel/workqueue.c:2361=0A=
=A0#1: ffffc9000777fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, a=
t: process_one_work+0x89c/0x1820 kernel/workqueue.c:2365=0A=
2 locks held by kworker/u16:64/877:=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: at=
omic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_data kernel/workqueue.c:639 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: pr=
ocess_one_work+0x868/0x1820 kernel/workqueue.c:2361=0A=
=A0#1: ffffc9000781fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, a=
t: process_one_work+0x89c/0x1820 kernel/workqueue.c:2365=0A=
2 locks held by kworker/u16:0/28836:=0A=
=A0#0: ffff8880458e9938 ((wq_completion)loop2){+.+.}-{0:0}, at: arch_atomic=
64_set arch/x86/include/asm/atomic64_64.h:34 [inline]=0A=
=A0#0: ffff8880458e9938 ((wq_completion)loop2){+.+.}-{0:0}, at: arch_atomic=
_long_set include/linux/atomic/atomic-long.h:41 [inline]=0A=
=A0#0: ffff8880458e9938 ((wq_completion)loop2){+.+.}-{0:0}, at: atomic_long=
_set include/linux/atomic/atomic-instrumented.h:1280 [inline]=0A=
=A0#0: ffff8880458e9938 ((wq_completion)loop2){+.+.}-{0:0}, at: set_work_da=
ta kernel/workqueue.c:639 [inline]=0A=
=A0#0: ffff8880458e9938 ((wq_completion)loop2){+.+.}-{0:0}, at: set_work_po=
ol_and_clear_pending kernel/workqueue.c:666 [inline]=0A=
=A0#0: ffff8880458e9938 ((wq_completion)loop2){+.+.}-{0:0}, at: process_one=
_work+0x868/0x1820 kernel/workqueue.c:2361=0A=
=A0#1: ffffc90009aa7da8 ((work_completion)(&lo->rootcg_work)){+.+.}-{0:0}, =
at: process_one_work+0x89c/0x1820 kernel/workqueue.c:2365=0A=
2 locks held by syz-executor.2/6115:=0A=
=A0#0: ffff8881128c00e0 (&type->s_umount_key#73/1){+.+.}-{3:3}, at: alloc_s=
uper+0x22e/0xb60 fs/super.c:228=0A=
=A0#1: ffff8881128b5090 (&nilfs->ns_sem){++++}-{3:3}, at: init_nilfs+0x7d/0=
x1300 fs/nilfs2/the_nilfs.c:630=0A=
2 locks held by kworker/u16:1/6137:=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: at=
omic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_data kernel/workqueue.c:639 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: pr=
ocess_one_work+0x868/0x1820 kernel/workqueue.c:2361=0A=
=A0#1: ffffc90003a0fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, a=
t: process_one_work+0x89c/0x1820 kernel/workqueue.c:2365=0A=
2 locks held by kworker/u16:2/6138:=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: at=
omic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_data kernel/workqueue.c:639 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: pr=
ocess_one_work+0x868/0x1820 kernel/workqueue.c:2361=0A=
=A0#1: ffffc90003887da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, a=
t: process_one_work+0x89c/0x1820 kernel/workqueue.c:2365=0A=
2 locks held by kworker/u16:3/6139:=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: at=
omic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_data kernel/workqueue.c:639 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: pr=
ocess_one_work+0x868/0x1820 kernel/workqueue.c:2361=0A=
=A0#1: ffffc90003a2fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, a=
t: process_one_work+0x89c/0x1820 kernel/workqueue.c:2365=0A=
2 locks held by kworker/u16:4/6140:=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: at=
omic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_data kernel/workqueue.c:639 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: pr=
ocess_one_work+0x868/0x1820 kernel/workqueue.c:2361=0A=
=A0#1: ffffc90003677da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, a=
t: process_one_work+0x89c/0x1820 kernel/workqueue.c:2365=0A=
2 locks held by kworker/u16:5/6141:=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: at=
omic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_data kernel/workqueue.c:639 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: pr=
ocess_one_work+0x868/0x1820 kernel/workqueue.c:2361=0A=
=A0#1: ffffc90003847da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, a=
t: process_one_work+0x89c/0x1820 kernel/workqueue.c:2365=0A=
2 locks held by kworker/u16:6/6142:=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: at=
omic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_data kernel/workqueue.c:639 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: pr=
ocess_one_work+0x868/0x1820 kernel/workqueue.c:2361=0A=
=A0#1: ffffc90003a3fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, a=
t: process_one_work+0x89c/0x1820 kernel/workqueue.c:2365=0A=
2 locks held by kworker/u16:7/6143:=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: at=
omic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_data kernel/workqueue.c:639 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: pr=
ocess_one_work+0x868/0x1820 kernel/workqueue.c:2361=0A=
=A0#1: ffffc90003a4fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, a=
t: process_one_work+0x89c/0x1820 kernel/workqueue.c:2365=0A=
2 locks held by kworker/u16:8/6144:=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: at=
omic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_data kernel/workqueue.c:639 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: pr=
ocess_one_work+0x868/0x1820 kernel/workqueue.c:2361=0A=
=A0#1: ffffc90003a5fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, a=
t: process_one_work+0x89c/0x1820 kernel/workqueue.c:2365=0A=
2 locks held by kworker/u16:9/6145:=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: at=
omic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_data kernel/workqueue.c:639 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: pr=
ocess_one_work+0x868/0x1820 kernel/workqueue.c:2361=0A=
=A0#1: ffffc90003a6fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, a=
t: process_one_work+0x89c/0x1820 kernel/workqueue.c:2365=0A=
2 locks held by kworker/u16:10/6146:=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: at=
omic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_data kernel/workqueue.c:639 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: pr=
ocess_one_work+0x868/0x1820 kernel/workqueue.c:2361=0A=
=A0#1: ffffc90003a7fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, a=
t: process_one_work+0x89c/0x1820 kernel/workqueue.c:2365=0A=
2 locks held by kworker/u16:11/6147:=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: at=
omic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_data kernel/workqueue.c:639 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]=0A=
=A0#0: ffff888100081138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: pr=
ocess_one_work+0x868/0x1820 kernel/workqueue.c:2361=0A=
=A0#1: ffffc90003a8fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, a=
t: process_one_work+0x89c/0x1820 kernel/workqueue.c:2365=0A=
=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
