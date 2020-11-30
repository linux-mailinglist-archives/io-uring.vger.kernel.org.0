Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27612C8E01
	for <lists+io-uring@lfdr.de>; Mon, 30 Nov 2020 20:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388334AbgK3TYK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Nov 2020 14:24:10 -0500
Received: from mail-bn8nam12on2088.outbound.protection.outlook.com ([40.107.237.88]:64609
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388323AbgK3TYE (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 30 Nov 2020 14:24:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ptvz8o41XDPGUGLBkt05lC2FAf3/MIZr0jI1WQgOWZXDNWIwETjo8SBWhhubm/kSBQQnZB5bEKP065tX7bg7TGWzUMZ0FKlbi6PH2+JNfwR/l0Gh2d28yviRVPMhmLbHEe8iI2W9VzwrFYPSO17aG6jVZQPWaiOxDsXMJHJUFURx+pJVqSpzkUL156dSr6G2ePm0bt76037OeMnD27geSuXy8caTh4t2oHRPNg5OK67wF10OoEA2Xr7kJtfycbP1YJENdCFcRi3gMSnm+iTaazTsL1bMrKwPh9BMcNpVuMqfqdCl1U0Rcr7LTlbb8wrFAsrpE9uYASRM4L+QQh+VHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ip6xsBvrbVD3lidOCeGff53tUNmM/bcLvaSMYZmPzZk=;
 b=EF2vEfHO8AHcY78C5uEbtHbk1sO5ysa/7XWsuhYKX6j+eRLGLrsRL34aHb5n0ybt9lU8PlVDxjvdMY4LzFjursY1m2J4TK8Bg8WA6oVD465BQ/y33KqjYxY0Tcupx/ry715EzNvHZ8d/ytXi2PA4hLlhcP8RoxxPgVRBrf3M7W4w1boT2fE4pvIpg7ASdbsuRa92kcuzR2ys5eBUEvOktRbL8feFlv3jl88o4ZKaisRZG0tuFG6HrMbuV8HIRdtvjSQnE90soexG3HKDliQ7gDCTtlWaIbd25Gq14yFDW9dG/u5bBhJYsVF+cCXmmJ5Jl+2PUVBmtDV0geAYQw1UvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ip6xsBvrbVD3lidOCeGff53tUNmM/bcLvaSMYZmPzZk=;
 b=N5VWmdBjQTcLAIQ5LwNPXd8gvdJbc3HblBddefVmNnvu9n4+aTmPjNr0NiXQkSWPLpAPtxB+Ufu27c5acP4VPuCVubPOEEVFX990oDcOLrnZM0pdOwNMk9HVWWaAxSZ2Li5IAzSfhk9N/GSXukDOcbMBgF4ONwvfDuloKciTqEA=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (2603:10b6:a03:4a::18)
 by BY5PR05MB6996.namprd05.prod.outlook.com (2603:10b6:a03:1bf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.9; Mon, 30 Nov
 2020 19:23:08 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::d421:f99:8921:1ee7]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::d421:f99:8921:1ee7%6]) with mapi id 15.20.3632.006; Mon, 30 Nov 2020
 19:23:08 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC PATCH 07/13] fs/userfaultfd: support read_iter to use
 io_uring
Thread-Topic: [RFC PATCH 07/13] fs/userfaultfd: support read_iter to use
 io_uring
Thread-Index: AQHWx0V+iaqy58g/+UWI/jFzvM4pnanhDeuA
Date:   Mon, 30 Nov 2020 19:23:07 +0000
Message-ID: <3634A0BA-888F-445B-84A2-D7F7C957FFA8@vmware.com>
References: <20201129004548.1619714-1-namit@vmware.com>
 <20201129004548.1619714-8-namit@vmware.com>
 <dcf0ca71-c3e3-a813-b04f-d3e86bcddd48@kernel.dk>
In-Reply-To: <dcf0ca71-c3e3-a813-b04f-d3e86bcddd48@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:647:4700:9b2:b484:b377:b015:2fad]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 89af1875-c15e-44d3-cba5-08d895655e68
x-ms-traffictypediagnostic: BY5PR05MB6996:
x-microsoft-antispam-prvs: <BY5PR05MB6996EB414BC29FB6B5DAC669D0F50@BY5PR05MB6996.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8P3PpfDwaYHDwou+iNGLG7BXY5G4OFTlUroFWmbiaHlzdbPtTvv0GU1Gio8x20fgoPHRsMJPO58HgLwBFpRo/azsthUbRGHxaaKUOCLADROYu/ev8LJoEKpBdQy0JviqSVwdCd9aIeEci9lFPoHkJ+hwpJYiQUZOWZfQqeIciWyKVD6F6avW471dz7XCsREdWEgfrLj/KM5cJLUGZ448SKe5IXYJmV0llfG6KtlfB4OKhqjIe6j3sJoJy++gzyxvNpztB4LEhBF2Nb/8G3jSY905I1LxZFvP0RRe/8/KTICATDnduWlK0HoTkggYAZWe
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4776.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(376002)(346002)(39860400002)(6916009)(6506007)(8676002)(6486002)(54906003)(316002)(2906002)(4326008)(33656002)(53546011)(8936002)(6512007)(186003)(36756003)(66446008)(5660300002)(86362001)(478600001)(2616005)(66556008)(64756008)(71200400001)(83380400001)(66946007)(76116006)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?5REbMPAn+zK01kf4YTjdyL4Q+zCVSYU+r8ahn9/mUNQt7a/vft3QLMRjdiwc?=
 =?us-ascii?Q?fku2D2wgTMEZlmB+z9a/UJ1Hn08qyrOen1fn0gUpNniwBiVKdatYXuvtkkig?=
 =?us-ascii?Q?nTEfkXwfUelEEkL+aecZC6bWsBYYK6I+PaGbdajy26YkrmIuJAibYQ6kuKc/?=
 =?us-ascii?Q?vF/xW2cw/V/ULW66wtVGreghA+cbsjsag2XN8elq1WdkvyggqfxzcaEYGWc3?=
 =?us-ascii?Q?C3M18L4R8lGSQ5cntPpthjgr6V8CgN+I9TKKONwl6mcuFhQypm1oKkCshRpE?=
 =?us-ascii?Q?CLVA89J29krnm9bRvXEP40KRxBCqMjidJCjodBDIkkYO4ZXVNDVzLmgUHNHH?=
 =?us-ascii?Q?thIfHk8yUeJgqF6DNXUDfHqs6t1cxevZjmsYz521gqpiC26TIFr1V3qMRSyi?=
 =?us-ascii?Q?eB5ZUoqrANlFSQxjVFstPMqBhXHvQh7sGtAE0SS0CoUSaGI7Kf0I+P8wtGLb?=
 =?us-ascii?Q?sEQhPUS/q6Gc91A4UtwLOFDjYXAATPMlnnbksnI+9D9h7L3eD6yxA6En/70r?=
 =?us-ascii?Q?PmpJwwMUfb4HIg+FPOtpiaexP6qvwAHI/gX9m7JSNXcR2GpUiqiPzATTcVv2?=
 =?us-ascii?Q?9uapiGvml+KWfzCDrkwbzQJ+RfIPwIKihPS0U74z/PWSSrVGU0JuDsOlwYg7?=
 =?us-ascii?Q?RhcwlHuBUxRMVPy+agwNwFJTasMX9E0BM3OJV9mFHWIGLEUGgKIdqy6zgqBo?=
 =?us-ascii?Q?ORvQ4T614sY+2eWqfZrIq1IIXEe6DHQjeZEvfRLpZcX2d6cqW4iI9SCKgk69?=
 =?us-ascii?Q?9gcvsXuzumN0rg0HJ35qlgxcNUdg1HmAUfwXBkzsZfu058jHxFssJT/DLdll?=
 =?us-ascii?Q?MOLemWl/iChCmQTRKZpTv8CBKAKbstVLWFtgPiYYrZi/pOZs8WrA9vNNJMbv?=
 =?us-ascii?Q?L8R0QcANN61agLK5YNPMTYLpRZYdYwF/a6uHh+1RIXbFQRp0L6e7Weckuxlv?=
 =?us-ascii?Q?jxRdOmOaCf9CpuDa4kFB3H07VnDu1U449NsvSKljZXKlfS7UCyf5w12gHPGv?=
 =?us-ascii?Q?LKt2GrQVEN7IzQ2B0XYBYw2eMAeeEdQr2CFf60XL7QfCj2keHFHlfOI65N2h?=
 =?us-ascii?Q?/N3wEIqa?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <32C21D8337B41F498DAD794931CE541A@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4776.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89af1875-c15e-44d3-cba5-08d895655e68
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2020 19:23:07.9627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2LxzhfolBxpxjQYB/mB5uSLbwf/FxWHoQNWjTbqzPO5plJYS9gj5YmabTsnd0g55Rn2CcaG4Wbsochv3rXERKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR05MB6996
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> On Nov 30, 2020, at 10:20 AM, Jens Axboe <axboe@kernel.dk> wrote:
>=20
> On 11/28/20 5:45 PM, Nadav Amit wrote:
>> From: Nadav Amit <namit@vmware.com>
>>=20
>> iouring with userfaultfd cannot currently be used fixed buffers since
>> userfaultfd does not provide read_iter(). This is required to allow
>> asynchronous (queued) reads from userfaultfd.
>>=20
>> To support async-reads of userfaultfd provide read_iter() instead of
>> read().
>>=20
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Cc: Andrea Arcangeli <aarcange@redhat.com>
>> Cc: Peter Xu <peterx@redhat.com>
>> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
>> Cc: io-uring@vger.kernel.org
>> Cc: linux-fsdevel@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: linux-mm@kvack.org
>> Signed-off-by: Nadav Amit <namit@vmware.com>
>> ---
>> fs/userfaultfd.c | 18 ++++++++++--------
>> 1 file changed, 10 insertions(+), 8 deletions(-)
>>=20
>> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
>> index b6a04e526025..6333b4632742 100644
>> --- a/fs/userfaultfd.c
>> +++ b/fs/userfaultfd.c
>> @@ -1195,9 +1195,9 @@ static ssize_t userfaultfd_ctx_read(struct userfau=
ltfd_ctx *ctx, int no_wait,
>> 	return ret;
>> }
>>=20
>> -static ssize_t userfaultfd_read(struct file *file, char __user *buf,
>> -				size_t count, loff_t *ppos)
>> +static ssize_t userfaultfd_read_iter(struct kiocb *iocb, struct iov_ite=
r *to)
>> {
>> +	struct file *file =3D iocb->ki_filp;
>> 	struct userfaultfd_ctx *ctx =3D file->private_data;
>> 	ssize_t _ret, ret =3D 0;
>> 	struct uffd_msg msg;
>> @@ -1207,16 +1207,18 @@ static ssize_t userfaultfd_read(struct file *fil=
e, char __user *buf,
>> 		return -EINVAL;
>>=20
>> 	for (;;) {
>> -		if (count < sizeof(msg))
>> +		if (iov_iter_count(to) < sizeof(msg))
>> 			return ret ? ret : -EINVAL;
>> 		_ret =3D userfaultfd_ctx_read(ctx, no_wait, &msg);
>=20
> 'no_wait' should be changed to factor in iocb->ki_flags & IOCB_NOWAIT as =
well,
> not just f_flags & O_NONBLOCK.
>=20
> I didn't check your write_iter, but if appropriate, that should do that
> too.

Thanks, I completely missed this point and will fix it in v1 (if I get
a positive feedback on the rest from the userfaultfd people).

