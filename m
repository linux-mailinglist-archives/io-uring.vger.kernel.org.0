Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5639477BE25
	for <lists+io-uring@lfdr.de>; Mon, 14 Aug 2023 18:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjHNQcv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Aug 2023 12:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbjHNQcZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Aug 2023 12:32:25 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2052.outbound.protection.outlook.com [40.107.95.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47571BC0
        for <io-uring@vger.kernel.org>; Mon, 14 Aug 2023 09:31:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LKmQfo8CqPMJlpM3+zsYh9D2+3X887O8hjb37wZ3X8s6Tta/Z3RsKjJXxY44Zwrj4iYWTo2Ss4/fX5pzTpFe+HO8a5mdFDv4YIHXclI+HqjB8qPNrXBHRUlx94I7MY6G3OyQ0IVkspXriuwjqv1CgFhX4UaDJI7wDZo9x4Sp/DdEhfV4oHzXZvGsjveEPfZVUB885N9vRjczHoMkwqhloVJIES/2Nt2MqL+F9BQ50U8jXb0llm2LZMqEX09lpNPxJKoZ/8uoIIHtkPPvbGh2cg98PefwPtZ8N+scNiUfuKGhzm7lHee+1gT4yQ8X507cStFGFNoHDMFyZedOgg/Epw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5kCJM6EggsOSiJQejrb/TMW9H4iQcCXR32Ot4DVA7Vo=;
 b=n6MjRC5m5kL2ihCPCN4loTPd+uObWzjO1WKoj/YD9g2RCgmkrLz4n8OeEEsSG7iz3JxzkbApawel7BlGlSrMjNT+LvidWhYd2ZKTQuFmB6S/2WaKL01MVnKhxnDaMnPFZ6/dIBciE+gq5dj04xPFGbvjS+hu8m0Mjvpcqyt2agvkRjXZWG4UQEMbdK1Sy8USGRWocuk8ckpIPHgQYlG5n3buRps2uWu6bwfk5fb4Kjv0oVtfqmpANjHylyEHIngL14WnBQ2zKo0RQQgFbOK1rcA/LPmm9VafY8fosJdLIDszGyUDwUKslv+aRk7uZ503w8t74RVLb/8hFFqPczOY5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5kCJM6EggsOSiJQejrb/TMW9H4iQcCXR32Ot4DVA7Vo=;
 b=Z7M8s53LTNya6MA7WlcDPOJeynlZOjWfLTmLc44/4sBR+eS6wg+KAvfPbC40VXy98suuHKMW6Vm04S8/RsR+XYs0tT2/HvNz/oNgozt9bBoJXU6d2G2V51jn7nWMs7m5t1/rCalvAIoQOrtQ76wZBqMKCwy2btbB6jUOpvEsAhzKyGcYXCVlRGnXSUh5icEFLjwY9Ciaqx5wqObBf7kBSamzOLoN8vAqeoVH7HxvsdpJTLjQpJSbkmNJDx/+wuLN00DuEwIiaGtw/90/rbByAGkVF3el8FehUYWOf7QCT/YyZgnMp/zPZJ+bY7VnD4axFmL7b32BQu9vFPErLmNu7A==
Received: from SJ0PR08MB6494.namprd08.prod.outlook.com (2603:10b6:a03:2d9::14)
 by PH0PR08MB6693.namprd08.prod.outlook.com (2603:10b6:510:37::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Mon, 14 Aug
 2023 16:30:46 +0000
Received: from SJ0PR08MB6494.namprd08.prod.outlook.com
 ([fe80::740c:1e14:1fe3:f59b]) by SJ0PR08MB6494.namprd08.prod.outlook.com
 ([fe80::740c:1e14:1fe3:f59b%6]) with mapi id 15.20.6652.029; Mon, 14 Aug 2023
 16:30:46 +0000
From:   Pierre Labat <plabat@micron.com>
To:     Jeff Moyer <jmoyer@redhat.com>
CC:     Jens Axboe <axboe@kernel.dk>,
        "'io-uring@vger.kernel.org'" <io-uring@vger.kernel.org>
Subject: RE: [EXT] Re: FYI, fsnotify contention with aio and io_uring.
Thread-Topic: [EXT] Re: FYI, fsnotify contention with aio and io_uring.
Thread-Index: AdnG+3NTgdyJzbysQdOcb9jFxiDj+QCbxOsqADWgZoAAJlCnoAACfIv7APoCCEA=
Date:   Mon, 14 Aug 2023 16:30:46 +0000
Message-ID: <SJ0PR08MB6494678810F31652FA65854CAB17A@SJ0PR08MB6494.namprd08.prod.outlook.com>
References: <SJ0PR08MB6494F5A32B7C60A5AD8B33C2AB09A@SJ0PR08MB6494.namprd08.prod.outlook.com>
        <x49pm3y4nq5.fsf@segfault.boston.devel.redhat.com>
        <65911cc1-5b3f-ff5f-fe07-2f5c7a9c3533@kernel.dk>
        <SJ0PR08MB649422919BA3E86C48E83340AB12A@SJ0PR08MB6494.namprd08.prod.outlook.com>
 <x49o7jg2l4c.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49o7jg2l4c.fsf@segfault.boston.devel.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_ActionId=062319c7-fe15-49e3-8b63-012941a22099;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_ContentBits=0;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_Enabled=true;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_Method=Privileged;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_Name=Public;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_SetDate=2023-08-14T16:28:29Z;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_SiteId=f38a5ecd-2813-4862-b11b-ac1d563c806f;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=micron.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR08MB6494:EE_|PH0PR08MB6693:EE_
x-ms-office365-filtering-correlation-id: fb9710c7-3bd9-40f3-0d31-08db9ce3cfd7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XEkZ9PCnWuToBm1d/7HnNAjrmFXet8yI2kijn5JHDCGxNVxy7Vg5FRUldXdyNKocg5KQNnVy+zbUtpMaA4bceqeBEZRuYSdT9Q9h7uXkuxCY6obeSczXWCIa5aajRwJxSkgILhu2DLA87/cX9fGtXotCnIyt3n5jOwQl8Sze1e46bHHh6YkZCm/EzxOndn4AKqGeV9mXhU/jyp3BIDWZg2cx8ZUdLvbKB297WmpiDAJJ2jpg/PQ6av00DnIaOtWq9A4hRcE8f2REdXSzkDKpqJ8ZFH1+aCIDrMUYxX7th9UDVDmCjWRxjRzFd212YKlgUSp+d/G1k1mhpL+Yi6Bw0zn7hoE2JSuW9veUIxliNhOVWjFEuHSlzXcySybS7Zl2yYwe9PygxhSBbGi5xC7EVQnvk3xS4f2ZL62SZ2gK+5q5Mxkno00jOrok7ZbttkANlBulkObf40VYMZVxgT0kSc4wfrb+oZT6pghNf3ZWDzSS/nssRDpvdBHWKhiDzezHKraOYZXv1yZoMtLsOgj7jijW2YdgaJ/tCf6fQK2sj3vPUWCDyRTCoScjlxTO/401SyVDv1LXuXGpQ3rSoHAD9Oi/1YuUNeUd8gas3M2XF3I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR08MB6494.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(376002)(346002)(136003)(396003)(451199021)(1800799006)(186006)(38100700002)(55016003)(54906003)(7696005)(71200400001)(478600001)(122000001)(52536014)(38070700005)(5660300002)(2906002)(33656002)(86362001)(6916009)(4326008)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(41300700001)(8936002)(8676002)(316002)(6506007)(53546011)(26005)(83380400001)(9686003)(966005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?14GQsIFKJDlavR61fD+6Y2r/ZQalaiYC01Gu288xSNd22mt9BICSudRVQqpl?=
 =?us-ascii?Q?x7CPVRMVlBl5nfiKKF1cXa33q6hGbdLY3ypHzOdnZmcCG0GMq+ccrvnbfA2r?=
 =?us-ascii?Q?f6Ma4B0lJ2CC4ySO0IZ8JacXm3E522BPpcVo+xCA0+w9hgQJL6iCU5IuKf3y?=
 =?us-ascii?Q?j7WSHO4rewGOedghZYilxXVhefmGxkCdgwzv7+4V+sSikor+/QnrYZvOGpQ3?=
 =?us-ascii?Q?1eXK77AlkVPlXSpOJyQaqL//Ln6+FzMju1G6YbpZeT5pzWS1x3WDYXATYra5?=
 =?us-ascii?Q?qV0nqwMDFgS1oJpVF62/tFMR7Y//3SpcZlu6RKshHnJjohALyeG9kZxpZnA/?=
 =?us-ascii?Q?ofYLOkc/1kyec2G6stMGEMSPT23vG83H36QAAE+wW7cuSWfUrtsAFcSmX4EH?=
 =?us-ascii?Q?jRGF5xT0IOWaR/V8NPJT6y84iPXOm7old7mMWu0HyCg4Ks5Ti1EDQrpDN4gx?=
 =?us-ascii?Q?6sZ6jROcLyha0NsYFnCoDN15oVrp5BRXaXRBn/x8Fw9DusT0l7vOYYXLzkhp?=
 =?us-ascii?Q?ehCAEIHYmq7mLIaNnJHT7XshHmBE3eyV8jkv3FPJTJxjqghXuip4eKclPGz/?=
 =?us-ascii?Q?txkcx7lajf0syxW6o0EPISS2HjVBDX9K0oYeVJnhR9mxI5dZVPNjVR4lJxWP?=
 =?us-ascii?Q?/1ecmUgsCVPyMJsAJY7biOMK5WA/ACGjeL33pSn+hbMw2Kb6c20TSJMqox2p?=
 =?us-ascii?Q?vmLuqjs3J2AbbgTA+fjlRU+/CsQDc8eAZr+BgnbfiG3iiGmQP7dB8EIn4Yo5?=
 =?us-ascii?Q?ba4UHg4xnMXSG8urU6Ns8jmXyea2MAtseSvM5KL5EzD7MUv88jLWjRNL6IVB?=
 =?us-ascii?Q?AqY5/rSSjJeNkOA+WGGVj64mA4/Du6jDmPj5V9cQbSvsw3BBxewzB1Gbt0yU?=
 =?us-ascii?Q?fymzNzWIjt4Q+oflc2znbE/rnhwkQl6Ajt3d2H7M3BUwLN3eaJ5+CU0axjek?=
 =?us-ascii?Q?iKi1hr9CN4YnipYi0zrfDl28S+E4FZxLmPLpj4uUcTs05Zd2rgBaIKw/aKbV?=
 =?us-ascii?Q?GUB04wZqjnqA0Ww4hQQAaegLp/89OtLqOu7S/ph7Lw4QdaRAbl/azKTTMxm/?=
 =?us-ascii?Q?Z7kx1cM966ZovA/QcesJqqtO1uWat+pVY5bbjXlMqdnqf6yH34d7Bk1DQLes?=
 =?us-ascii?Q?qELup0rQKYV0YV0wkAPn//ihezwXADXqkKpzr5sPbrQOs6niFjw+m332HchO?=
 =?us-ascii?Q?H+XE2z9FS7X9aqY/WbQVNZATkfiDYQ5j67KkDPbjrg1PVGLYOkm8ORZCbWfI?=
 =?us-ascii?Q?v89IH6bC5shGqGOUwjmbIqKMRL+UodjP6aH430PKNO383Sd5aXm2inmvDAxf?=
 =?us-ascii?Q?7ZMTSNtF4ooTmPqvGUyU5yqOsn3JMtijWXds5VLUuaDTzIRopB7G1EbtLYOS?=
 =?us-ascii?Q?Yg+9n/kjQ2g5SyMrxZ2fn3PgKeC3IKT3Fgo1ecpWAIfcBh+np9stZnCkz+w5?=
 =?us-ascii?Q?/4f4m5ZDevl7sWjiL2QWDM7kD8FxI2ygKzn8rNhIUpS3LXyCTLWwWwBmGSm1?=
 =?us-ascii?Q?8BvWE4n0P+FNKUsG0MQYaYWNdy8Qp3Clta/yxyFx02u5auPOlruI3oozY64Z?=
 =?us-ascii?Q?gwCPAk3TBFV0CPOz0jg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR08MB6494.namprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb9710c7-3bd9-40f3-0d31-08db9ce3cfd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2023 16:30:46.0962
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IM0MNUmce1IzDFnMIWdcu4P5sVugu/D+pilZEA5Cm6iEeUcWvw42e954iEm2W+prAU9Ee5ftiou+FELFFVsvPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR08MB6693
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jeff,

Indeed, by default, in my configuration, pipewire is running.
When I can re-test, I'll disabled it and see if that remove the problem.
Thanks for the hint!

Pierre

> -----Original Message-----
> From: Jeff Moyer <jmoyer@redhat.com>
> Sent: Wednesday, August 9, 2023 10:15 AM
> To: Pierre Labat <plabat@micron.com>
> Cc: Jens Axboe <axboe@kernel.dk>; 'io-uring@vger.kernel.org' <io-
> uring@vger.kernel.org>
> Subject: Re: [EXT] Re: FYI, fsnotify contention with aio and io_uring.
>=20
> CAUTION: EXTERNAL EMAIL. Do not click links or open attachments unless yo=
u
> recognize the sender and were expecting this message.
>=20
>=20
> Pierre Labat <plabat@micron.com> writes:
>=20
> > Micron Confidential
> >
> > Hi Jeff and Jens,
> >
> > About "FAN_MODIFY fsnotify watch set on /dev".
> >
> > Was using Fedora34 distro (with 6.3.9 kernel), and fio. Without any
> particular/specific setting.
> > I tried to see what could watch /dev but failed at that.
> > I used the inotify-info tool, but that display watchers using the
> > inotify interface. And nothing was watching /dev via inotify.
> > Need to figure out how to do the same but for the fanotify interface.
> > I'll look at it again and let you know.
>=20
> You wouldn't happen to be running pipewire, would you?
>=20
> https://urldefense.com/v3/__https://gitlab.freedesktop.org/pipewire/pipew=
ir
> e/-
> /commit/88f0dbd6fcd0a412fc4bece22afdc3ba0151e4cf__;!!KZTdOCjhgt4hgw!6E063=
jj
> -_XK1NceWzms7DaYacILy4cKmeNVA3xalNwkd0zrYTX-IouUnvJ8bZs-RG3YSdk5XpFoo$
>=20
> -Jeff
>=20
> >
> > Regards,
> >
> > Pierre
> >
> >
> >
> > Micron Confidential
> >> -----Original Message-----
> >> From: Jens Axboe <axboe@kernel.dk>
> >> Sent: Tuesday, August 8, 2023 2:41 PM
> >> To: Jeff Moyer <jmoyer@redhat.com>; Pierre Labat <plabat@micron.com>
> >> Cc: 'io-uring@vger.kernel.org' <io-uring@vger.kernel.org>
> >> Subject: [EXT] Re: FYI, fsnotify contention with aio and io_uring.
> >>
> >> CAUTION: EXTERNAL EMAIL. Do not click links or open attachments
> >> unless you recognize the sender and were expecting this message.
> >>
> >>
> >> On 8/7/23 2:11?PM, Jeff Moyer wrote:
> >> > Hi, Pierre,
> >> >
> >> > Pierre Labat <plabat@micron.com> writes:
> >> >
> >> >> Hi,
> >> >>
> >> >> This is FYI, may be you already knows about that, but in case you
> >> don't....
> >> >>
> >> >> I was pushing the limit of the number of nvme read IOPS, the FIO +
> >> >> the Linux OS can handle. For that, I have something special under
> >> >> the Linux nvme driver. As a consequence I am not limited by
> >> >> whatever the NVME SSD max IOPS or IO latency would be.
> >> >>
> >> >> As I cranked the number of system cores and FIO jobs doing direct
> >> >> 4k random read on /dev/nvme0n1, I hit a wall. The IOPS scaling
> >> >> slows (less than linear) and around 15 FIO jobs on 15 core
> >> >> threads, the overall IOPS, in fact, goes down as I add more FIO
> >> >> jobs. For example on a system with 24 cores/48 threads, when I
> >> >> goes beyond 15 FIO jobs, the overall IOPS starts to go down.
> >> >>
> >> >> This happens the same for io_uring and aio. Was using kernel
> >> >> version
> >> 6.3.9. Using one namespace (/dev/nvme0n1).
> >> >
> >> > [snip]
> >> >
> >> >> As you can see 76% of the cpu on the box is sucked up by
> >> >> lockref_get_not_zero() and lockref_put_return().  Looking at the
> >> >> code, there is contention when IO_uring call fsnotify_access().
> >> >
> >> > Is there a FAN_MODIFY fsnotify watch set on /dev?  If so, it might
> >> > be a good idea to find out what set it and why.
> >>
> >> This would be my guess too, some distros do seem to do that. The
> >> notification bits scale horribly, nobody should use it for anything
> >> high performance...
> >>
> >> --
> >> Jens Axboe

