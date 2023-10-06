Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22537BC004
	for <lists+io-uring@lfdr.de>; Fri,  6 Oct 2023 22:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbjJFUJh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Oct 2023 16:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233398AbjJFUJg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Oct 2023 16:09:36 -0400
Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-centralusazon11021020.outbound.protection.outlook.com [52.101.62.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D1FC6;
        Fri,  6 Oct 2023 13:09:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NDQ69YQh2595JTIWCPdALcFWiqVCX2NT1dWF3bc8sN7iub4Ox/b+iVeHULeoWtX/lKHtOWXPw0q58NKlkQEMusXis105LcEPI46SJY2lyjvTkPTMm97V581oxW+ap3cCJZ36Py1eyjs3TzHEjEgRF97e1z4PaBX81FthNi/Fs2h6lpQ3A44CBdCvXavjSUX5lHiCoJslcHYd6hef3GPg6I2kcyyaanD1Iu79MBs4mf6d0IMhz24gORUSVPEeLM8LdIJ+Is5qNcmbQIs6nL8h2RLsUP7F++XvfdrZ+uGb0RtFRBUWEgwrL4AUpmJ/uwXoJvwqwp6HtFUGjPWwNIfkSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tuSP7/jMQrFfYw/fB3SMvIyrvR7F0YRHRqNOOzSoZ5k=;
 b=NFLbOx7Rc00vFWkZ1ge8Yuqf8nqqQ+dmiYqUTS8QgBQDfIkBLXFNlALof1U6SbuUyaTAA66zRy/vOfQ5QNvm3TUcAf5ZQxdLYeviYP6w1ikRIA9Kl4mg5mkWrykd0oH+8DrKGyKF4SnFy6xLRcQXy3/ERwucq3sCs8TN0dYNH3rJOgkybSMsBK0ExwQ4DpMhzjOL3EaM5A2+f9Sb9z3on6vUBjBED+mRUUJN/SI7vTUIfBmOK0VmPOHo1236+pG73wGbP5e3rqQhaiN7t+QjPsHOQ3h0cncWPAlu9P/gW8UlpBT2AAYZ5b4p8W22t56QKQAtdnfBxkjdZD00Em6aFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tuSP7/jMQrFfYw/fB3SMvIyrvR7F0YRHRqNOOzSoZ5k=;
 b=htVhROeFKgssvLEsWe+c2IdXcFN2XI9ylLx6ZOetw5lYV1Q+KG1sY+AXo0PpsFVUWCARX75a1pDZL1uFQiLApO/yCcAVTnuyll6JF985ZdL8KJ4pqwzPl4g+4EDOplYdUcyBOE9BbyNjJylq4fCQxodQjzg1IHI3WvHcrecl4Lk=
Received: from MW2PR2101MB1033.namprd21.prod.outlook.com (2603:10b6:302:4::32)
 by MN0PR21MB3266.namprd21.prod.outlook.com (2603:10b6:208:37e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.11; Fri, 6 Oct
 2023 20:09:30 +0000
Received: from MW2PR2101MB1033.namprd21.prod.outlook.com
 ([fe80::e6d1:7be6:9ded:9b42]) by MW2PR2101MB1033.namprd21.prod.outlook.com
 ([fe80::e6d1:7be6:9ded:9b42%6]) with mapi id 15.20.6886.016; Fri, 6 Oct 2023
 20:09:30 +0000
From:   Dan Clash <Dan.Clash@microsoft.com>
To:     "audit@vger.kernel.org" <audit@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     "paul@paul-moore.com" <paul@paul-moore.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: audit: io_uring openat triggers audit reference count underflow in
 worker thread
Thread-Topic: audit: io_uring openat triggers audit reference count underflow
 in worker thread
Thread-Index: AQHZ+JAylfbNgEMpYU+qEdC5Blzyag==
Date:   Fri, 6 Oct 2023 20:09:30 +0000
Message-ID: <MW2PR2101MB1033FFF044A258F84AEAA584F1C9A@MW2PR2101MB1033.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-10-06T20:09:26.683Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR2101MB1033:EE_|MN0PR21MB3266:EE_
x-ms-office365-filtering-correlation-id: c5adbb83-a827-4de1-a3f3-08dbc6a82637
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rr4oj0kki6I0maPbF5463gnpz16/pYfTgK1ngXw7NznUZJrkGnxvbH+ldmoNw7u0h7CTR+TQnyC9WqOGOkePReS63UopOt05UUwWRtNZrQPTdpXe0obqGfOHZkB245iHqZlfx3quW2KRdf76YUV382eOOeBuX3HYuBuaFq8WRsoEGpNHZEbD+5Zh0kGaFQKYXypMk2smZK4CL5AgJugHl6R4qc6CeW2Rc1PCHF/EvkktJUV1q3bRjNH8THyP2827G5TnGplbc8cZuHADBtBGV7w9N6JrygfG13xqddtfGfdvGnw4gjN2uzKyubFar9AsQq2Kg0n72d4/UfncHfUFE8ht3Q5EDWm5N7NO3ylaLymTKvE2ebJnS8Tnnb6i5tabBO+n6q2Jqv3FUg8w7tNd9YzObpW07Q47UZ/g3eZz4L9WGEPtg15KBbmsl5Oqd347G3O8gN68OcrScf73exNPwl5m4IWJHz4dDhZ6GT/zzR10MqhF3Fe9CxeJoWFar8nRo4EtQH8UHnaUGxXUpGo115zumlwp9d4DsUVjpEWg5fS4+S93fDCrr3b3TwlngTeeWhKPs/uyPpZZ9+s1BG8ZH6ceqOgzqwOfrhXX6aIWeiusI5y7CCG3SNLptvY2+rKnxcWLYwURMjz6VELe61mVX7cmhPL/jT64PFOt3QiLNQiwcu4b6WUYWiXash6rOOVOfs+zeNcpUjfvh4U9R7gWOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1033.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(346002)(376002)(136003)(366004)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(55016003)(7696005)(6506007)(10290500003)(478600001)(71200400001)(38070700005)(86362001)(122000001)(82960400001)(82950400001)(38100700002)(8990500004)(41300700001)(2906002)(9686003)(83380400001)(8936002)(8676002)(4326008)(66556008)(5660300002)(66476007)(91956017)(76116006)(316002)(33656002)(54906003)(66946007)(110136005)(66446008)(64756008)(52536014)(22770500002)(349545003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?ZXTV8TI+9cEKcUjyttGIqV8Unk/z6BqjO7rDJrQ1w9FQX9SdsyYk9L4FCp?=
 =?iso-8859-1?Q?xcC+MryJSrf7PKeUjPW0b/6R7VFdisIeNEsIGsIVJ6SsGPxd62934z4ofV?=
 =?iso-8859-1?Q?2XHvUP3S4902vr3PdK/08mMpnRVZ8S583k69Rvk/MS7FxcIcN6vkDQe9d7?=
 =?iso-8859-1?Q?WJkQtuI2JncwietlgPD34jCgISZ7Q0cpeE1Hg/VU1UtSmv7K5rGTULGOwF?=
 =?iso-8859-1?Q?GDC0ID5KwmLFjqmgRIBdhefzWirmM+ItwM8UPdSyL8RPVO7AbGt4V0eWij?=
 =?iso-8859-1?Q?Cip9yku35TZbnkU33+LfHVf8wfx9S/VoJQ0a4qxubt+eZKnyp0wNkYeAi2?=
 =?iso-8859-1?Q?Z0NyDVU2umzxnsmQObOp+zZoW3F60e7Cnx7KnveH7qo2arBPjmWS5mlb78?=
 =?iso-8859-1?Q?cDdSPe/HJEdOK6+hBAUHg1LWGwM+L3MYcNibHsN+mJlTAiGKf9L2kOYemo?=
 =?iso-8859-1?Q?qotnb9Rs3orTD2M9HKQDRp2JFH4qjdqwjo+wxEmJAB0JO35LGGwgd2usSr?=
 =?iso-8859-1?Q?w9Qtc5jcqo52rJ+5gXy3frkaA5G/WRwPJHIHq+Vm7XScDLvCdxECVg/15O?=
 =?iso-8859-1?Q?8p0m4ky2t/bAt7V/CHjlrU4VkccEYD8qXoKH+LtTIFDfCAcsvsD9Q8buoi?=
 =?iso-8859-1?Q?/C8Toc4CS2eRWkyr8ALYsSUltiAoV07WTX3L7nx63zYN/v9l+p/d8uteQT?=
 =?iso-8859-1?Q?juVvLwwJ4kCnPPhpQlW+Hsr5/Gnh946mHMl/SeAVqtaigKR+qcrB7ELzrt?=
 =?iso-8859-1?Q?5cRIDk7QIl4WwMQ5B73xkBTxSrewDCWuSQVO+8x6mG+/m9hWxzTsQGBX4R?=
 =?iso-8859-1?Q?rOvnkja3FDs0AwiENai8npwhXcwd2YfeFAA+NN1a1Fm0kL7nd7+Ixwi1d9?=
 =?iso-8859-1?Q?1wqwi1ek2JppIEBYZGDAIRNXdLE/VHiN55VXf9i48+DftPdktcLQ+2JBFp?=
 =?iso-8859-1?Q?11WyESCcBQ9kb6YwjkcPoEN5DV8C74zRNKWm62KPZ62HRmEBV6BSq4uvXo?=
 =?iso-8859-1?Q?ZK6EJTPJ6SoQ0e40agzEESBBiHRLxS8zXEAoxidQfZzCkKST/cu2L5Td7i?=
 =?iso-8859-1?Q?lKVmseCS45BSicubgQgIFxpD4Vy7DrfQsgfi0bWiMyvU/OXX2NQV27a6dj?=
 =?iso-8859-1?Q?WpvumiQtEsZ05nqLP+thW54sW7viUWbs+AGGZ0vai6N0KveBLGOpbGM3sU?=
 =?iso-8859-1?Q?5k9PD1+SDsJu4vmTFMaQwNQ0WlWCj+aJl3oq0v+lAQImmGfqvwyLcj5Cmo?=
 =?iso-8859-1?Q?Op+Avgf+m0Fp6ndhKmgydS3kgin6oFv1f/Jc8iEPWlkMMSDsGZ8N+GBx28?=
 =?iso-8859-1?Q?Csiw+fzn3QoEfa2S03ux/0zCDZw4nPKFxjMZrNdpwP2Nloosu3Yb0m121p?=
 =?iso-8859-1?Q?1CllrkyC9f58IBU3lEDOJyyJX9a26b4k3RfIZElgdeeT4iwe1DOSuhGUr5?=
 =?iso-8859-1?Q?WamzjPdPVo8tbYy8W+Sp2PEKxITXKkZ16Wdy5FTbm1nszxw6MoFDbtdjSk?=
 =?iso-8859-1?Q?aOvH/P9iiu3Z/Ac9IG0ydUWHJoUqMfPF5BFAtRW9lJsnQapPoRcpsukT/3?=
 =?iso-8859-1?Q?gB9c++7AA/64FCEmTbI885tbtukbjAqY2IwJuTq0kyYZfuQudvinRfefvT?=
 =?iso-8859-1?Q?eFMD0I180uTL0V0AVNQ/0jS5kYxkQp/Evpxc2H1c+Y8ydFvjRI+uIaeh/7?=
 =?iso-8859-1?Q?VDBPa6Zx93ajOgw4O2b3bozC1i6KNkDotqvnO4hz?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1033.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5adbb83-a827-4de1-a3f3-08dbc6a82637
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2023 20:09:30.0691
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fF+ScyEpp3JLMda3dE+BIcqnGY36Abs993f4oTZ6ljbTXl5vxE6ukqLcShYF/Jkw6+yeDgcV+Mgflt/kSwG6kQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3266
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        LOCALPART_IN_SUBJECT,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE,T_FILL_THIS_FORM_SHORT autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This discussion is about how to fix an audit reference count decrement=0A=
race between two io_uring threads.=0A=
=0A=
Original discussion link:=0A=
https : / / github . com / axboe / liburing / issues / 958=0A=
=0A=
Details:=0A=
=0A=
The test program below hangs indefinitely waiting for an openat cqe.  The=
=0A=
reproduction is with a distro kernel Ubuntu-azure-6.2-6.2.0-1012.12_22.04.1=
.=0A=
However, the bug seems possible with an upstream kernel.  An experiment of=
=0A=
changing the reference count in struct filename from int to refcount_t allo=
ws=0A=
the test program to complete.=0A=
=0A=
The bug did not occur with this test program until a kernel containing=0A=
commit 5bd2182d58e9 was used.  I have not found a matching reported issue=
=0A=
or upstream commit yet.=0A=
=0A=
The dmseg log shows an audit related path:=0A=
=0A=
[27883.992550] kernel BUG at fs/namei.c:262!=0A=
[27883.994051] invalid opcode: 0000 [#15] SMP PTI=0A=
[27883.995719] CPU: 3 PID: 84988 Comm: iou-wrk-84835 Tainted: G      D=0A=
               6.2.0-1012-azure #12~22.04.1-Ubuntu=0A=
[27883.999064] Hardware name: Microsoft Corporation Virtual Machine/Virtual=
 Machine,=0A=
               BIOS Hyper-V UEFI Release v4.1 05/09/2022=0A=
[27884.002734] RIP: 0010:putname+0x68/0x70=0A=
...=0A=
[27884.032893] Call Trace:=0A=
[27884.034032]  <TASK>=0A=
[27884.035117]  ? show_regs+0x6a/0x80=0A=
[27884.036763]  ? die+0x38/0xa0=0A=
[27884.038023]  ? do_trap+0xd0/0xf0=0A=
[27884.039359]  ? do_error_trap+0x70/0x90=0A=
[27884.040861]  ? putname+0x68/0x70=0A=
[27884.042201]  ? exc_invalid_op+0x53/0x70=0A=
[27884.043698]  ? putname+0x68/0x70=0A=
[27884.045076]  ? asm_exc_invalid_op+0x1b/0x20=0A=
[27884.047051]  ? putname+0x68/0x70=0A=
[27884.048415]  audit_reset_context.part.0.constprop.0+0xe1/0x300=0A=
[27884.050511]  __audit_uring_exit+0xda/0x1c0=0A=
[27884.052100]  io_issue_sqe+0x1f3/0x450=0A=
[27884.053702]  ? lock_timer_base+0x3b/0xd0=0A=
[27884.055283]  io_wq_submit_work+0x8d/0x2b0=0A=
[27884.056848]  ? __try_to_del_timer_sync+0x67/0xa0=0A=
[27884.058577]  io_worker_handle_work+0x17c/0x2b0=0A=
[27884.060267]  io_wqe_worker+0x10a/0x350=0A=
[27884.061714]  ? raw_spin_rq_unlock+0x10/0x30=0A=
[27884.063295]  ? finish_task_switch.isra.0+0x8b/0x2c0=0A=
[27884.065537]  ? __pfx_io_wqe_worker+0x10/0x10=0A=
[27884.067215]  ret_from_fork+0x2c/0x50=0A=
[27884.068733] RIP: 0033:0x0=0A=
...=0A=
=0A=
Test program usage:=0A=
=0A=
./io_uring_open_close_audit_hang --directory /tmp/deleteme --count 10000=0A=
=0A=
Test program source:=0A=
=0A=
// Note: The test program is C++ but could be converted to C.=0A=
#include <cassert>=0A=
#include <fcntl.h>=0A=
#include <filesystem>=0A=
#include <getopt.h>=0A=
#include <iostream>=0A=
#include <liburing.h>=0A=
=0A=
// open and close a file.  the file is created if it does not exist.=0A=
=0A=
void=0A=
openClose(struct io_uring& ring, std::string fileName)=0A=
{=0A=
    int ret;=0A=
    struct io_uring_cqe* cqe {};=0A=
    struct io_uring_sqe* sqe {};=0A=
    int fd {};=0A=
    int flags {O_RDWR | O_CREAT};=0A=
    mode_t mode {0666};=0A=
=0A=
    // openat2=0A=
=0A=
    sqe =3D io_uring_get_sqe(&ring);=0A=
    assert(sqe !=3D nullptr);=0A=
=0A=
    io_uring_prep_openat(sqe, AT_FDCWD, fileName.data(), flags, mode);=0A=
    io_uring_sqe_set_flags(sqe, IOSQE_ASYNC);=0A=
=0A=
    ret =3D io_uring_submit(&ring);=0A=
    assert(ret =3D=3D 1);=0A=
=0A=
    ret =3D io_uring_wait_cqe(&ring, &cqe);=0A=
    assert(ret =3D=3D 0);=0A=
=0A=
    fd =3D cqe->res;=0A=
    assert(fd > 0);=0A=
=0A=
    io_uring_cqe_seen(&ring, cqe);=0A=
=0A=
    // close=0A=
=0A=
    sqe =3D io_uring_get_sqe(&ring);=0A=
    assert(sqe !=3D nullptr);=0A=
=0A=
    io_uring_prep_close(sqe, fd);=0A=
    io_uring_sqe_set_flags(sqe, IOSQE_ASYNC);=0A=
=0A=
    ret =3D io_uring_submit(&ring);=0A=
    assert(ret =3D=3D 1);=0A=
=0A=
    // wait for the close to complete.=0A=
    ret =3D io_uring_wait_cqe(&ring, &cqe);=0A=
    assert(ret =3D=3D 0);=0A=
=0A=
    // verify that close succeeded.=0A=
    assert(cqe->res =3D=3D 0);=0A=
=0A=
    io_uring_cqe_seen(&ring, cqe);=0A=
}=0A=
=0A=
// create 100 files and then open each file twice.=0A=
=0A=
void=0A=
openCloseHang(std::string filePath)=0A=
{=0A=
    int ret;=0A=
    struct io_uring ring;=0A=
=0A=
    ret =3D io_uring_queue_init(8, &ring, 0);=0A=
    assert(0 =3D=3D ret);=0A=
=0A=
    int repeat {3};=0A=
    int numFiles {100};=0A=
=0A=
    std::filesystem::create_directory(filePath);=0A=
=0A=
    // files of length 0 are created in the j=3D=3D0 iteration below.=0A=
    // those files are opened and closed during the j>0 iteraions.=0A=
    // a repeat of 3 results in a fairly reliable reproduction.=0A=
=0A=
    for (int j =3D 0; j < repeat; j +=3D 1) {=0A=
        for (int i =3D 0; i < numFiles; i +=3D 1) {=0A=
            std::string fileName(filePath + "/file" + std::to_string(i));=
=0A=
            openClose(ring, fileName);=0A=
        }=0A=
    }=0A=
=0A=
    std::filesystem::remove_all(filePath);=0A=
=0A=
    io_uring_queue_exit(&ring);=0A=
}=0A=
=0A=
int=0A=
main(int argc, char** argv)=0A=
{=0A=
    std::string filePath {};=0A=
    int iterations {};=0A=
=0A=
    struct option options[]=0A=
    {=0A=
        {"help", no_argument, 0, 'h'}, {"directory", required_argument, 0, =
'd'},=0A=
            {"count", required_argument, 0, 'c'},=0A=
        {=0A=
            0, 0, 0, 0=0A=
        }=0A=
    };=0A=
    bool printUsage {false};=0A=
    int val {};=0A=
=0A=
    while ((val =3D getopt_long_only(argc, argv, "", options, nullptr)) !=
=3D -1) {=0A=
        if (val =3D=3D 'h') {=0A=
            printUsage =3D true;=0A=
        } else if (val =3D=3D 'd') {=0A=
            filePath =3D optarg;=0A=
            if (std::filesystem::exists(filePath)) {=0A=
                printUsage =3D true;=0A=
                std::cerr << "directory must not exist" << std::endl;=0A=
            }=0A=
        } else if (val =3D=3D 'c') {=0A=
            iterations =3D atoi(optarg);=0A=
            if (0 =3D=3D iterations) {=0A=
                printUsage =3D true;=0A=
            }=0A=
        } else {=0A=
            printUsage =3D true;=0A=
        }=0A=
    }=0A=
=0A=
    if ((0 =3D=3D iterations) || (filePath.empty())) {=0A=
        printUsage =3D true;=0A=
    }=0A=
=0A=
    if (printUsage || (optind < argc)) {=0A=
        std::cerr << "io_uring_open_close_audit_hang.cc --directory DIR --c=
ount COUNT" << std::endl;=0A=
        exit(1);=0A=
    }=0A=
=0A=
    for (int i =3D 0; i < iterations; i +=3D 1) {=0A=
        if (0 =3D=3D (i % 100)) {=0A=
            std::cout << "i=3D" << std::to_string(i) << std::endl;=0A=
        }=0A=
        openCloseHang(filePath);=0A=
    }=0A=
    return 0;=0A=
}=0A=
=0A=
Changing the reference count from int to refcount_t allows the test program=
=0A=
to complete using the v6.2 distro kernel.  The patch applies and builds on =
the=0A=
upstream v6.1.55 kernel.=0A=
=0A=
Signed-off-by: Dan Clash <dan.clash@microsoft.com>=0A=
---=0A=
diff --git a/fs/namei.c b/fs/namei.c=0A=
index 2a8baa6ce3e8..4f7ac131c9d1 100644=0A=
--- a/fs/namei.c=0A=
+++ b/fs/namei.c=0A=
@@ -187,7 +187,7 @@ getname_flags(const char __user *filename, int flags, i=
nt *empty)=0A=
 		}=0A=
 	}=0A=
=0A=
-	result->refcnt =3D 1;=0A=
+	refcount_set(&result->refcnt, 1);=0A=
 	/* The empty path is special. */=0A=
 	if (unlikely(!len)) {=0A=
 		if (empty)=0A=
@@ -248,7 +248,7 @@ getname_kernel(const char * filename)=0A=
 	memcpy((char *)result->name, filename, len);=0A=
 	result->uptr =3D NULL;=0A=
 	result->aname =3D NULL;=0A=
-	result->refcnt =3D 1;=0A=
+	refcount_set(&result->refcnt, 1);=0A=
 	audit_getname(result);=0A=
=0A=
 	return result;=0A=
@@ -259,9 +259,10 @@ void putname(struct filename *name)=0A=
 	if (IS_ERR(name))=0A=
 		return;=0A=
=0A=
-	BUG_ON(name->refcnt <=3D 0);=0A=
+	BUG_ON(refcount_read(&name->refcnt) =3D=3D 0);=0A=
+	BUG_ON(refcount_read(&name->refcnt) =3D=3D REFCOUNT_SATURATED);=0A=
=0A=
-	if (--name->refcnt > 0)=0A=
+	if (!refcount_dec_and_test(&name->refcnt))=0A=
 		return;=0A=
=0A=
 	if (name->name !=3D name->iname) {=0A=
diff --git a/include/linux/fs.h b/include/linux/fs.h=0A=
index d0a54e9aac7a..8217e07726d4 100644=0A=
--- a/include/linux/fs.h=0A=
+++ b/include/linux/fs.h=0A=
@@ -2719,7 +2719,7 @@ struct audit_names;=0A=
 struct filename {=0A=
 	const char		*name;	/* pointer to actual string */=0A=
 	const __user char	*uptr;	/* original userland pointer */=0A=
-	int			refcnt;=0A=
+	refcount_t		refcnt;=0A=
 	struct audit_names	*aname;=0A=
 	const char		iname[];=0A=
 };=0A=
diff --git a/kernel/auditsc.c b/kernel/auditsc.c=0A=
index 37cded22497e..232e0be9f6d9 100644=0A=
--- a/kernel/auditsc.c=0A=
+++ b/kernel/auditsc.c=0A=
@@ -2188,7 +2188,7 @@ __audit_reusename(const __user char *uptr)=0A=
 		if (!n->name)=0A=
 			continue;=0A=
 		if (n->name->uptr =3D=3D uptr) {=0A=
-			n->name->refcnt++;=0A=
+			refcount_inc(&n->name->refcnt);=0A=
 			return n->name;=0A=
 		}=0A=
 	}=0A=
@@ -2217,7 +2217,7 @@ void __audit_getname(struct filename *name)=0A=
 	n->name =3D name;=0A=
 	n->name_len =3D AUDIT_NAME_FULL;=0A=
 	name->aname =3D n;=0A=
-	name->refcnt++;=0A=
+	refcount_inc(&name->refcnt);=0A=
 }=0A=
=0A=
 static inline int audit_copy_fcaps(struct audit_names *name,=0A=
@@ -2349,7 +2349,7 @@ void __audit_inode(struct filename *name, const struc=
t dentry *dentry,=0A=
 		return;=0A=
 	if (name) {=0A=
 		n->name =3D name;=0A=
-		name->refcnt++;=0A=
+		refcount_inc(&name->refcnt);=0A=
 	}=0A=
=0A=
 out:=0A=
@@ -2474,7 +2474,7 @@ void __audit_inode_child(struct inode *parent,=0A=
 		if (found_parent) {=0A=
 			found_child->name =3D found_parent->name;=0A=
 			found_child->name_len =3D AUDIT_NAME_FULL;=0A=
-			found_child->name->refcnt++;=0A=
+			refcount_inc(&found_child->name->refcnt);=0A=
 		}=0A=
 	}=0A=
=0A=
