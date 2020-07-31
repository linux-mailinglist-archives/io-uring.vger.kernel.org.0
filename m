Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF4C233F39
	for <lists+io-uring@lfdr.de>; Fri, 31 Jul 2020 08:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731440AbgGaGmP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jul 2020 02:42:15 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:22257 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731369AbgGaGmO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jul 2020 02:42:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596177734; x=1627713734;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=uqTSbiptzfAu35CoUfRZXU8DMGBvPTZ8tA0pjheJ85U=;
  b=VYZT0wQC7ZeUX8Lh1gN8H6NlJa79Xus5323Yszoaba+C8t3tGknLmhys
   0kq7QZ3ZiC4UkfPIfgOq5K3NWTkWGGji3MGia1x39yGsAYevFIT4MuOcS
   Njf6cKPPdjKN+hZaxvgMaQ4iP66l7T7R5XRBYqBZYCtw/Eqlq4oHmjGwk
   YWUBgYon4kxBG90RODbV7PskD/tZYJ4sbQ0VNZDfeDwR+ZAcmyAVg7w5D
   pZh3R+KKZkmTEAV34Frp0BXoAjhIqSeUv/gLA5dg9gS4oUT2gyJCYZYRx
   5wjbVgHz8BzrHMUlcZzntgYGUIZvfdMqLP4NUFtYc5ZXcBQKBIpoKW+Xv
   A==;
IronPort-SDR: VfaPZ8ppI0pX9TuiFPGp06D0k3ZGusbrhjYqgLdvUAnSg1lXk24axPeuWqdIiB+jmy8qdlrhFk
 Dz2ELiyvWF7hP9qO/Oe+ZeNgjem/cwcGVYajGAHpp5oz4Nq9IXAq16xpivWtqV/a+DfPu5dzzz
 euP6/5GEEcojqQxAUYvyyN9n2zr4qO1uU6dpUqYfyjuvgJex+DmODZ5tMiogN+XzP6KVwUAqO1
 sjNdlJaOVkF2/Qpt3ZgoQ6my4ncbKk2bmiwn79CCUSvEPTgYGbpfVPUcRoUnnOlG2lnnTb4O5K
 NZU=
X-IronPort-AV: E=Sophos;i="5.75,417,1589212800"; 
   d="scan'208";a="143902749"
Received: from mail-bl2nam02lp2051.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.51])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jul 2020 14:42:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L0Vt7aAuVOiZibmsGuQl24bHdfxz0fPQfVHzoVjmSeBpMjq+DG9ff+6oupsMVGmwNigLDkTX67FiWn73rjfYuOpW1ULSaVr3pCOmrNnk5vBHgXLT4jAgh7bma8aTVhFTOUnxmTZT/y947tCEzWGysEkq9g0FErm6vDw10pYNwFmK8z/lZisAzItsc96e7W5tKycNQoc2XDdZ1DtXRly+B4tkjQk2eqkGZiiLpCfpOAx5t0GaKUcMYFxJ4qwIUUuge4o/Eh3yQ6sj5bkYZFIUjiRbgz4agv5SQGzcPr1bS3pJ0aaahGSvsv6t43sFk9IsJbdjOq5Akm6q/SM2dyVptA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ATQNZMnxK/mkw0R2lZ3DdZrmx2mcsRAAQFbSCRZGuLA=;
 b=QMWFdZiHrQfDKjU2gFma/UAq0g7MCHRBEb7STIZk2xwRLwP0ofUKAX4mQr49pWOCXJaw47HswaQM7HJw64etiY98rkEU4sqBbTGGm1SdFh3uTUTd/vE+vnqXoAormaY/PZgyThuWzk/OMc2ZSWVlU0jde5jaAZLCAdl3TOvRTBRDnKSAuUrod+UGo8xgUCaN5voH0lxOedPUqK28o0TUpIDGLA4SQssp8BynX4ianvPW38sDmcJvLxE7n/nwqVG/QTEvlVLl/M63q5meWil6KspqF6ZxWd2id9bINB+0fwh8B+e6u1d1d33AmeHAEeBk97VqV42zr/hbw3YuPL2xqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ATQNZMnxK/mkw0R2lZ3DdZrmx2mcsRAAQFbSCRZGuLA=;
 b=PcInR7CWbF/e/DdS02CrnzvjYr8EJBF5GFj1mMw6p3cmcZnq08o9A3YEcoOLb4vjSz9bLGwxqI6y2sn8L5+rFFNv9Ip/aUNYG/rKOrrjyp9lrLbARGVd7RiqhFLUrX3IeTMUAEPlOBKAgTWMJFuR+3d1ra825dcEEIuli2QgWFU=
Received: from MWHPR04MB3758.namprd04.prod.outlook.com (2603:10b6:300:fb::8)
 by MWHPR04MB0878.namprd04.prod.outlook.com (2603:10b6:301:3c::38) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17; Fri, 31 Jul
 2020 06:42:10 +0000
Received: from MWHPR04MB3758.namprd04.prod.outlook.com
 ([fe80::718a:d477:a4f1:c137]) by MWHPR04MB3758.namprd04.prod.outlook.com
 ([fe80::718a:d477:a4f1:c137%7]) with mapi id 15.20.3239.017; Fri, 31 Jul 2020
 06:42:10 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Kanchan Joshi <joshiiitr@gmail.com>, Jens Axboe <axboe@kernel.dk>
CC:     Pavel Begunkov <asml.silence@gmail.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        Matthew Wilcox <willy@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH v4 6/6] io_uring: add support for zone-append
Thread-Topic: [PATCH v4 6/6] io_uring: add support for zone-append
Thread-Index: AQHWYdbcc0q15qREKECGO7brHi6zEg==
Date:   Fri, 31 Jul 2020 06:42:10 +0000
Message-ID: <MWHPR04MB3758DC08EA17780E498E9EC0E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
References: <1595605762-17010-1-git-send-email-joshi.k@samsung.com>
 <CGME20200724155350epcas5p3b8f1d59eda7f8fbb38c828f692d42fd6@epcas5p3.samsung.com>
 <1595605762-17010-7-git-send-email-joshi.k@samsung.com>
 <f5416bd4-93b3-4d14-3266-bdbc4ae1990b@kernel.dk>
 <CA+1E3rJAa3E2Ti0fvvQTzARP797qge619m4aYLjXeR3wxdFwWw@mail.gmail.com>
 <b0b7159d-ed10-08ad-b6c7-b85d45f60d16@kernel.dk>
 <e871eef2-8a93-fdbc-b762-2923526a2db4@gmail.com>
 <80d27717-080a-1ced-50d5-a3a06cf06cd3@kernel.dk>
 <da4baa8c-76b0-7255-365c-d8b58e322fd0@gmail.com>
 <65a7e9a6-aede-31ce-705c-b7f94f079112@kernel.dk>
 <d4f9a5d3-1df2-1060-94fa-f77441a89299@gmail.com>
 <CA+1E3rJ3SoLU9aYcugAQgJnSPnJtcCwjZdMREXS3FTmXgy3yow@mail.gmail.com>
 <f030a338-cd52-2e83-e1da-bdbca910d49e@kernel.dk>
 <CA+1E3rKxZk2CatTuPcQq5d14vXL9_9LVb2_+AfR2m9xn2WTZdg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0ce9f775-50d2-4bf4-a8b4-08d8351cd9d2
x-ms-traffictypediagnostic: MWHPR04MB0878:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <MWHPR04MB0878A6BD1FB00356F600926AE74E0@MWHPR04MB0878.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gSJCj1fCSL7KHNYNxLrdTy7isffHy73gqT8ZBWF7OF2DqrfGptgEk5U/CXZHOg82o1y8JPJzf/qM2P6KR9pNzO7UKx1bg/0FpvW9VKPYhH274EelHcIIGrra27NBsRYa3o1K/JWfMfUHiXXmcPLlJJKT/cc6NxKr863AUMKgTLXH/OHxqOofX9gpuUvNi+UEWy9GbfmEJuitpMEpuWYDMUCGLscwQnkelx13ZAJFQXcv5l8mWLBCwDwd7Sk2LLDr+S1n1L+dmjXeQPs2tUPqiVmM6Ds2Y+u/mYUH9Ha8x6/rYNkDHs8v1Y8sDNV+VLuC9PoiwxhT5c2zWlrIgZuKcA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR04MB3758.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(9686003)(55016002)(83380400001)(8676002)(86362001)(8936002)(4326008)(7416002)(76116006)(66476007)(66556008)(64756008)(66446008)(52536014)(66946007)(316002)(5660300002)(91956017)(71200400001)(33656002)(186003)(2906002)(26005)(6506007)(53546011)(54906003)(110136005)(478600001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 4gVl1pcaA+Tu/efXfhRUgtLwJWvovfh+Vc086UtiQeOMKwi0ZktZ2YCQfSb7i3AoBY31uh3QAC480WdCWAfHHM53sRmIFxMMnReABYZ9f72rH/gk4KwVJ6BrNowoK44Jpror1lwImMZX4eBMo36EOKhwtta4TjF8eFe8jLqAgadFgh25bl5I/qc6oV7sb24ZBskf7k86Ryi1jCkymvsF3aLo5szaL/XGAlB9CNBfc6ncI+MVabBFRQeBQB0JCrWmrREh25fXgK39l3qBhQ/cxb0LjHq1u7dJQMd1Nxsv1647he7aJ2RRYJyqVvWxcuT6GOhXH0jN77GOUI0xj5pilSVL6U7ZRapcwQ76HTIlhxRPKWI9xJFlN7rvcz6IU3DBuPDO6FtNpm1ToMIFmw+uFIcPi8KYm0fZhY6rVLV3+VGn6ZCOb5Y2nM1bh07HBsUW7w7eU6dqoJ4d+svJIvtjBC2D2m0VaRCpycqK4SA7b9YSgV1z3+lDf6psRgX8dbOmUNWVeiffo8WZ0pG8HfzahNJOnbCL/uGKxmS8xc+R5jbHsPO66bh3E+9uJIHNqiAy71TW21FMwaxNP48iosoBmiIuuvWfzHKk61ujfEaHrwLsa6pMrQFpIdYE0ytPQNi/Xj655OLGdb9fBxlQ7RuDtg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR04MB3758.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ce9f775-50d2-4bf4-a8b4-08d8351cd9d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2020 06:42:10.1183
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V4CyTjRU7rYsLZ1QI4Ubv9Tl9o6SyM+LM2otU4GJjBq5i+uD872wjfQX8kTZrpBsTdsy6P0klJBnp5a5QfmdaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR04MB0878
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020/07/31 3:26, Kanchan Joshi wrote:=0A=
> On Thu, Jul 30, 2020 at 11:24 PM Jens Axboe <axboe@kernel.dk> wrote:=0A=
>>=0A=
>> On 7/30/20 11:51 AM, Kanchan Joshi wrote:=0A=
>>> On Thu, Jul 30, 2020 at 11:10 PM Pavel Begunkov <asml.silence@gmail.com=
> wrote:=0A=
>>>>=0A=
>>>> On 30/07/2020 20:16, Jens Axboe wrote:=0A=
>>>>> On 7/30/20 10:26 AM, Pavel Begunkov wrote:=0A=
>>>>>> On 30/07/2020 19:13, Jens Axboe wrote:=0A=
>>>>>>> On 7/30/20 10:08 AM, Pavel Begunkov wrote:=0A=
>>>>>>>> On 27/07/2020 23:34, Jens Axboe wrote:=0A=
>>>>>>>>> On 7/27/20 1:16 PM, Kanchan Joshi wrote:=0A=
>>>>>>>>>> On Fri, Jul 24, 2020 at 10:00 PM Jens Axboe <axboe@kernel.dk> wr=
ote:=0A=
>>>>>>>>>>>=0A=
>>>>>>>>>>> On 7/24/20 9:49 AM, Kanchan Joshi wrote:=0A=
>>>>>>>>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c=0A=
>>>>>>>>>>>> index 7809ab2..6510cf5 100644=0A=
>>>>>>>>>>>> --- a/fs/io_uring.c=0A=
>>>>>>>>>>>> +++ b/fs/io_uring.c=0A=
>>>>>>>>>>>> @@ -1284,8 +1301,15 @@ static void __io_cqring_fill_event(stru=
ct io_kiocb *req, long res, long cflags)=0A=
>>>>>>>>>>>>       cqe =3D io_get_cqring(ctx);=0A=
>>>>>>>>>>>>       if (likely(cqe)) {=0A=
>>>>>>>>>>>>               WRITE_ONCE(cqe->user_data, req->user_data);=0A=
>>>>>>>>>>>> -             WRITE_ONCE(cqe->res, res);=0A=
>>>>>>>>>>>> -             WRITE_ONCE(cqe->flags, cflags);=0A=
>>>>>>>>>>>> +             if (unlikely(req->flags & REQ_F_ZONE_APPEND)) {=
=0A=
>>>>>>>>>>>> +                     if (likely(res > 0))=0A=
>>>>>>>>>>>> +                             WRITE_ONCE(cqe->res64, req->rw.a=
ppend_offset);=0A=
>>>>>>>>>>>> +                     else=0A=
>>>>>>>>>>>> +                             WRITE_ONCE(cqe->res64, res);=0A=
>>>>>>>>>>>> +             } else {=0A=
>>>>>>>>>>>> +                     WRITE_ONCE(cqe->res, res);=0A=
>>>>>>>>>>>> +                     WRITE_ONCE(cqe->flags, cflags);=0A=
>>>>>>>>>>>> +             }=0A=
>>>>>>>>>>>=0A=
>>>>>>>>>>> This would be nice to keep out of the fast path, if possible.=
=0A=
>>>>>>>>>>=0A=
>>>>>>>>>> I was thinking of keeping a function-pointer (in io_kiocb) durin=
g=0A=
>>>>>>>>>> submission. That would have avoided this check......but argument=
 count=0A=
>>>>>>>>>> differs, so it did not add up.=0A=
>>>>>>>>>=0A=
>>>>>>>>> But that'd grow the io_kiocb just for this use case, which is arg=
uably=0A=
>>>>>>>>> even worse. Unless you can keep it in the per-request private dat=
a,=0A=
>>>>>>>>> but there's no more room there for the regular read/write side.=
=0A=
>>>>>>>>>=0A=
>>>>>>>>>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linu=
x/io_uring.h=0A=
>>>>>>>>>>>> index 92c2269..2580d93 100644=0A=
>>>>>>>>>>>> --- a/include/uapi/linux/io_uring.h=0A=
>>>>>>>>>>>> +++ b/include/uapi/linux/io_uring.h=0A=
>>>>>>>>>>>> @@ -156,8 +156,13 @@ enum {=0A=
>>>>>>>>>>>>   */=0A=
>>>>>>>>>>>>  struct io_uring_cqe {=0A=
>>>>>>>>>>>>       __u64   user_data;      /* sqe->data submission passed b=
ack */=0A=
>>>>>>>>>>>> -     __s32   res;            /* result code for this event */=
=0A=
>>>>>>>>>>>> -     __u32   flags;=0A=
>>>>>>>>>>>> +     union {=0A=
>>>>>>>>>>>> +             struct {=0A=
>>>>>>>>>>>> +                     __s32   res;    /* result code for this =
event */=0A=
>>>>>>>>>>>> +                     __u32   flags;=0A=
>>>>>>>>>>>> +             };=0A=
>>>>>>>>>>>> +             __s64   res64;  /* appending offset for zone app=
end */=0A=
>>>>>>>>>>>> +     };=0A=
>>>>>>>>>>>>  };=0A=
>>>>>>>>>>>=0A=
>>>>>>>>>>> Is this a compatible change, both for now but also going forwar=
d? You=0A=
>>>>>>>>>>> could randomly have IORING_CQE_F_BUFFER set, or any other futur=
e flags.=0A=
>>>>>>>>>>=0A=
>>>>>>>>>> Sorry, I didn't quite understand the concern. CQE_F_BUFFER is no=
t=0A=
>>>>>>>>>> used/set for write currently, so it looked compatible at this po=
int.=0A=
>>>>>>>>>=0A=
>>>>>>>>> Not worried about that, since we won't ever use that for writes. =
But it=0A=
>>>>>>>>> is a potential headache down the line for other flags, if they ap=
ply to=0A=
>>>>>>>>> normal writes.=0A=
>>>>>>>>>=0A=
>>>>>>>>>> Yes, no room for future flags for this operation.=0A=
>>>>>>>>>> Do you see any other way to enable this support in io-uring?=0A=
>>>>>>>>>=0A=
>>>>>>>>> Honestly I think the only viable option is as we discussed previo=
usly,=0A=
>>>>>>>>> pass in a pointer to a 64-bit type where we can copy the addition=
al=0A=
>>>>>>>>> completion information to.=0A=
>>>>>>>>=0A=
>>>>>>>> TBH, I hate the idea of such overhead/latency at times when SSDs c=
an=0A=
>>>>>>>> serve writes in less than 10ms. Any chance you measured how long d=
oes it=0A=
>>>>>>>=0A=
>>>>>>> 10us? :-)=0A=
>>>>>>=0A=
>>>>>> Hah, 10us indeed :)=0A=
>>>>>>=0A=
>>>>>>>=0A=
>>>>>>>> take to drag through task_work?=0A=
>>>>>>>=0A=
>>>>>>> A 64-bit value copy is really not a lot of overhead... But yes, we'=
d=0A=
>>>>>>> need to push the completion through task_work at that point, as we =
can't=0A=
>>>>>>> do it from the completion side. That's not a lot of overhead, and m=
ost=0A=
>>>>>>> notably, it's overhead that only affects this particular type.=0A=
>>>>>>>=0A=
>>>>>>> That's not a bad starting point, and something that can always be=
=0A=
>>>>>>> optimized later if need be. But I seriously doubt it'd be anything =
to=0A=
>>>>>>> worry about.=0A=
>>>>>>=0A=
>>>>>> I probably need to look myself how it's really scheduled, but if you=
 don't=0A=
>>>>>> mind, here is a quick question: if we do work_add(task) when the tas=
k is=0A=
>>>>>> running in the userspace, wouldn't the work execution wait until the=
 next=0A=
>>>>>> syscall/allotted time ends up?=0A=
>>>>>=0A=
>>>>> It'll get the task to enter the kernel, just like signal delivery. Th=
e only=0A=
>>>>> tricky part is really if we have a dependency waiting in the kernel, =
like=0A=
>>>>> the recent eventfd fix.=0A=
>>>>=0A=
>>>> I see, thanks for sorting this out!=0A=
>>>=0A=
>>> Few more doubts about this (please mark me wrong if that is the case):=
=0A=
>>>=0A=
>>> - Task-work makes me feel like N completions waiting to be served by=0A=
>>> single task.=0A=
>>> Currently completions keep arriving and CQEs would be updated with=0A=
>>> result, but the user-space (submitter task) would not be poked.=0A=
>>>=0A=
>>> - Completion-code will set the task-work. But post that it cannot go=0A=
>>> immediately to its regular business of picking cqe and updating=0A=
>>> res/flags, as we cannot afford user-space to see the cqe before the=0A=
>>> pointer update. So it seems completion-code needs to spawn another=0A=
>>> work which will allocate/update cqe after waiting for pointer-update=0A=
>>> from task-work?=0A=
>>=0A=
>> The task work would post the completion CQE for the request after=0A=
>> writing the offset.=0A=
> =0A=
> Got it, thank you for making it simple.=0A=
> Overall if I try to put the tradeoffs of moving to indirect-offset=0A=
> (compared to current scheme)=96=0A=
> =0A=
> Upside:=0A=
> - cqe res/flags would be intact, avoids future-headaches as you mentioned=
=0A=
> - short-write cases do not have to be failed in lower-layers (as=0A=
> cqe->res is there to report bytes-copied)=0A=
=0A=
I personally think it is a super bad idea to allow short asynchronous appen=
d=0A=
writes. The interface should allow the async zone append write to proceed o=
nly=0A=
and only if it can be stuffed entirely into a single BIO which necessarilly=
 will=0A=
be a single request on the device side. Otherwise, the application would ha=
ve no=0A=
guarantees as to where a split may happen, and since this is zone append, t=
he=0A=
next async append will not leave any hole to complete a previous short writ=
e.=0A=
This will wreak the structure of the application data.=0A=
=0A=
For the sync case, this is fine. The application can just issue a new appen=
d=0A=
write with the remaining unwritten data from the previous append write. But=
 in=0A=
the async case, if one write =3D=3D one data record (e.g. a key-value tuple=
 for an=0A=
SSTable in an LSM tree), then allowing a short write will destroy the recor=
d:=0A=
the partial write will be garbage data that will need garbage collection...=
=0A=
=0A=
> =0A=
> Downside:=0A=
> - We may not be able to use RWF_APPEND, and need exposing a new=0A=
> type/flag (RWF_INDIRECT_OFFSET etc.) user-space. Not sure if this=0A=
> sounds outrageous, but is it OK to have uring-only flag which can be=0A=
> combined with RWF_APPEND?=0A=
=0A=
Why ? Where is the problem ? O_APPEND/RWF_APPEND is currently meaningless f=
or=0A=
raw block device accesses. We could certainly define a meaning for these in=
 the=0A=
context of zoned block devices.=0A=
=0A=
I already commented on the need for first defining an interface (flags etc)=
 and=0A=
its semantic (e.g. do we allow short zone append or not ? What happens for=
=0A=
regular files ? etc). Did you read my comment ? We really need to first agr=
ee on=0A=
something to clarify what needs to be done.=0A=
=0A=
=0A=
> -  Expensive compared to sending results in cqe itself. But I agree=0A=
> that this may not be major, and only for one type of write.=0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
