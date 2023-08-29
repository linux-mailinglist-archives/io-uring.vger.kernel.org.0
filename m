Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF6478CF01
	for <lists+io-uring@lfdr.de>; Tue, 29 Aug 2023 23:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238081AbjH2VzT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Aug 2023 17:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238391AbjH2Vyy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Aug 2023 17:54:54 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2073.outbound.protection.outlook.com [40.107.96.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0319DCCE
        for <io-uring@vger.kernel.org>; Tue, 29 Aug 2023 14:54:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JW5nJNArXtWw767hRhfzxkBguUaxEEkTT//Yz6rgukNX45tlKFpUsqVxQA+cf5xjynqqg7aixWUJyNYZN+G48dp0/hwobV3LiqhWgaG9OsSsl/No3Vv5xOjZEcJik22QKBawQWyF0LRT9evyEdDNTepBrSjJ+M5r3hoteOd0rTriKOG6RdzxDRHP0caGdMaRz4hfod6r06FXBV4dTPuM65STaTdinWBT54S9nMR0geGHE0KXJORmrIypMkyZYeIkNplEPPfGA5Eg+MAWzYR+fsdhPFISQqWsxjLGwQnINfQ9usOW6kBzU32FOgNzH4zFRioTOX2hZGCqsaJ4xp3o7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WE5A9oBcICSgy5jvFcj+IDGIPMfBHcOKsaNfVifOavc=;
 b=fUDA+/kY3KmOmYbJzabdUjKUyfzbkcgBbTaan7okt1oKWeFOgVQMAbk7HVUaYstj/4VxDsXiYXa6xjdJObQEah6TZtsPOqz/Sc5/PsCFGrb+Ecz7evHNR3i3VikRXIY1fQWFyVFUCp1k5ZOGvztygoq3i1iwCYJmfjmKP5SoHtyyESUnEk2uODhHthO4/fhOwiCXNUyJI8Q9Dc7hQ1t8uHoKbMfO3ygNRqZeQqTU1sEF8gRCzsS1i8TJi/KR+bAocaPb8ozSKtdAGGdezswYalpLfDt7KdSv/pHAH9O0ocFdFvZ0sHxJqgpcosiCIi88sl4IhIBggP+E7I2CRCvJFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WE5A9oBcICSgy5jvFcj+IDGIPMfBHcOKsaNfVifOavc=;
 b=XzA5sAG2CwXK9miuH8uHJTVm5k86sE/AlEzvFjqZGhp4V89JS8yPhDTijdCHy/rW5Sv3C/o/jUJikPlVx+15JKjzUmslWofqTfP1wqcgx/G2lZ8YwRI0J8g4C+7w9S3tH/LNlqve8HG6SPM9ZYjnrypQpP+dPWve5Jf5Zbuk/kuphUl16OqCBpKBZhTdfex+gY/gayf/C5RTsFBY/25Zl5nKzZujiw4EhPxKqsu3kg6BnOIREMl4KGzEO3Fhqtu+sTT4Tu7TLSXEwSACc3bqMLLuiyKBwKyycitxBtQfZ2GtgS41tTOS31DnkkO7FxJqRU4F0UGcHfkPo09xb8UPSg==
Received: from SJ0PR08MB6494.namprd08.prod.outlook.com (2603:10b6:a03:2d9::14)
 by DS0PR08MB8980.namprd08.prod.outlook.com (2603:10b6:8:1a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.18; Tue, 29 Aug
 2023 21:54:43 +0000
Received: from SJ0PR08MB6494.namprd08.prod.outlook.com
 ([fe80::2fe7:998b:e139:81b2]) by SJ0PR08MB6494.namprd08.prod.outlook.com
 ([fe80::2fe7:998b:e139:81b2%4]) with mapi id 15.20.6745.015; Tue, 29 Aug 2023
 21:54:43 +0000
From:   Pierre Labat <plabat@micron.com>
To:     'Jeff Moyer' <jmoyer@redhat.com>
CC:     'Jens Axboe' <axboe@kernel.dk>,
        "'io-uring@vger.kernel.org'" <io-uring@vger.kernel.org>
Subject: RE: [EXT] Re: FYI, fsnotify contention with aio and io_uring.
Thread-Topic: [EXT] Re: FYI, fsnotify contention with aio and io_uring.
Thread-Index: AdnG+3NTgdyJzbysQdOcb9jFxiDj+QCbxOsqADWgZoAAJlCnoAACfIv7APoCCEAC+nH6wA==
Date:   Tue, 29 Aug 2023 21:54:42 +0000
Message-ID: <SJ0PR08MB64949350D2580D27863FBFDFABE7A@SJ0PR08MB6494.namprd08.prod.outlook.com>
References: <SJ0PR08MB6494F5A32B7C60A5AD8B33C2AB09A@SJ0PR08MB6494.namprd08.prod.outlook.com>
        <x49pm3y4nq5.fsf@segfault.boston.devel.redhat.com>
        <65911cc1-5b3f-ff5f-fe07-2f5c7a9c3533@kernel.dk>
        <SJ0PR08MB649422919BA3E86C48E83340AB12A@SJ0PR08MB6494.namprd08.prod.outlook.com>
 <x49o7jg2l4c.fsf@segfault.boston.devel.redhat.com>
 <SJ0PR08MB6494678810F31652FA65854CAB17A@SJ0PR08MB6494.namprd08.prod.outlook.com>
In-Reply-To: <SJ0PR08MB6494678810F31652FA65854CAB17A@SJ0PR08MB6494.namprd08.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_ActionId=062319c7-fe15-49e3-8b63-012941a22099;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_ContentBits=0;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_Enabled=true;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_Method=Privileged;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_Name=Public;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_SetDate=2023-08-14T16:28:29Z;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_SiteId=f38a5ecd-2813-4862-b11b-ac1d563c806f;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=micron.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR08MB6494:EE_|DS0PR08MB8980:EE_
x-ms-office365-filtering-correlation-id: 550596fa-dd52-497e-71f9-08dba8da8d4a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +Hz5frsYrNvkJd61duMkqE4wgu2LutJehM09dWsgkAZO+wlkEpNE14mjoJw8o6/PHXTSQnB2CTTmK9Ja8Rzq57nRVoEa3RhIS5oW524N5tqlP9IfAMUaYgxqhVsHa8A4AspOxb51+xcE4f42hYvQV2Qs9xnfrOipZFWD65WqA8bgcg6u+TgJA424YYUyuc+qg2i0hze5udFy6M0hOT2XFBcIOJu/SeGR1J+Y8TjX8UJpiuqs9aKjx4XNGAXlCRTfpgeySDlLErnEqTijypLB04LUYATjVhMNUYlIrKkPjbEstzaTR4w2TQtoGtonBAaeG5iPqlapgkPToN9AA3ASWpa/3YUaQ/ofnILCcLVczBS6/9BRw2En+c9E2WL79QGXx3yiisjmUJDFLvotJIGKGlZDExmg+pDqizeXCnbs/vh4LTVSO0M3w53dHnryEBLejWYXgU0nTG4Ti0iHl+NQhEV41ZliAzJHLm+4R9pwc+ZP0K2H4J4KW418LR/D72j/RjRffcnD+RTN9HQmeyouOg9r+45s9pr8RE5b2aI1wPvRds5eaquONhoL9DVt1VsV0Y3p5A0PSs31IV5wTsMAtbaOkj1XDCJ8lCHjw0GLjQk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR08MB6494.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(396003)(346002)(39860400002)(366004)(1800799009)(186009)(451199024)(8936002)(122000001)(53546011)(478600001)(76116006)(6506007)(66556008)(7696005)(71200400001)(66946007)(64756008)(66476007)(66446008)(54906003)(966005)(6916009)(38070700005)(316002)(38100700002)(41300700001)(9686003)(26005)(8676002)(5660300002)(2906002)(83380400001)(52536014)(86362001)(55016003)(33656002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?A7OxDOGHcrHNm78KCeFd4zovFZF5je5B55Txv2OsNzUnZ4M5OijwCRC8VWDK?=
 =?us-ascii?Q?gaSc/KgEOOQ3hR8jva9G7k9cvTDieNRP+wuOewtfsNXKJLx2YmLKb2rOUACF?=
 =?us-ascii?Q?S8U5m4ceN2leyYSSeenEm8Svkd1e/mruUuoouB9Tcayi0knUPxWZDzPQBBU/?=
 =?us-ascii?Q?765Mph7k4k3wJJ06tcB2ibR47VVQf0eCOV+IDAF1q7COWvi0Qy6B17Cq4Fs+?=
 =?us-ascii?Q?N5AXslEOAz9hZCKlndHoQE1r9nS6qpVpU7BorPGsI0hyQ5HCMshu4ZJ4g1nk?=
 =?us-ascii?Q?a5F8uOD+iW6Tzg4o6SwRWJERencpkd9HLzzinghL7q2VAB+hQFVSRFINIxhH?=
 =?us-ascii?Q?Z2ZbByg7GGE/7v1bJm79lTykI5mJ+p5obZMCljQEy6risNVstsieVZpHyp4G?=
 =?us-ascii?Q?ot6H3QzzRDgqDvsgRGXfMXFDVbaKcvcUE1vypawsGS7r9TdNgv/d0Bm+U7E5?=
 =?us-ascii?Q?gXVqm+c3JwFumuus2sd8yHnz7IpCwPFDg3giXtodd8uIMUwTb5cc5za8TYjl?=
 =?us-ascii?Q?t284D9ZLgjVQw2ah2Hi5/TNOyTbPqP4I8yD0Ur3hgn5et6MrZSgoHbF9Jf4c?=
 =?us-ascii?Q?Dg7ZJvG2pDmGYcRbuTpGB8HkwipFW4MbWuP84iL4GGEEMau/pGC2wxiC5ZH1?=
 =?us-ascii?Q?KMrTMKpEX+PyZe6fzavEaxezz84d7OdHyS9xd+D55Jb1zgs/K3BxFxZGGSJ9?=
 =?us-ascii?Q?4gWXAyC/Kws6pwyPSHmru23qPcJhfBXemOrcCkXvqY0DJCTukpUzJRcWKp7l?=
 =?us-ascii?Q?p8D1QGIsYCQdR/PMSedFlWxGF6WbkmBpjofVrStdhZVMdvUNkX9fC/cua9z7?=
 =?us-ascii?Q?eJ0ltpFRBNZQPTQZuvikFanHoJVxRh/RtWIgupLgRg4WFVAMqRJh/9gnijPD?=
 =?us-ascii?Q?fQ//mu5zSbjA4KpnLek3Z3Pd1Q9eSvvmJFDVb9QhARsho7ozDyAD2IjtVnS8?=
 =?us-ascii?Q?JttOyAcNVR5ree5+gkgpEXcag24AxP9CUnSZ7RugfVLA/vJHSOWQu3RKmoJP?=
 =?us-ascii?Q?Tpv9A6X4nyna8NUFukCqF0lNQ0SU95KXkZaOxHS94gWIDWHRb4PWz+xdu7F3?=
 =?us-ascii?Q?F5J+5dmc4ncRIPZ2ApUe6Krb+gIu0CuM7Qtj4KCmvpx/Op/32ijqzKw/3/HO?=
 =?us-ascii?Q?WLX88AAlBnHFMB2JDGbl52mOsPp7o9fcl/WaPxSgoqAtN/jAdkVFPTDp4+hV?=
 =?us-ascii?Q?HfAEStZZ3auTUBsmZxgDv0hZlc2DCNgPgcpVblcqxGXbIdE78c67zlY0jcgV?=
 =?us-ascii?Q?JAxtJDhkPFS6nlWL5nmteYiQ/9Crj28ERO880qzet92MgprmF07JOW0RXCZU?=
 =?us-ascii?Q?JaG2lNmEfc+1qNDBFIrvJYbTMbcf2Fc7P1NjlS5h1yg+G8gxDD8olUfOH4z/?=
 =?us-ascii?Q?wf/PDWaxrODoMmDIzaAmAZAiQ87GI92D/P35+EWifCqPR9C+PJ0KI5O+/G4Q?=
 =?us-ascii?Q?NheQtgdJUWoMnoRenIyn99wNCiI+PD45e8+2VRbaJbwFtAEFUWJU2ZWZo54/?=
 =?us-ascii?Q?Yb/dBua2myFfKc6COLz8EFx6HyGJ2x+STpR6vwPr5HZcK3VayRpJ1WgR4RzS?=
 =?us-ascii?Q?XetNk+2JTz4GLZH1RPI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR08MB6494.namprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 550596fa-dd52-497e-71f9-08dba8da8d4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2023 21:54:42.9339
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DztJuv02mQAu5/1WdqGtwjwbbAxWF8rhqcnUsbePLTwUNSNrXGoRxfi8LFr4/R12Sn8CBltc8id9Q2hsubP4JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR08MB8980
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Had some time to re-do some testing.

1) Pipewire (its wireplumber deamon) set a watch on the children of the dir=
ectory /dev via inotify.
I removed that (disabled pipewire), but still had the fsnotify overhead whe=
n using aio/io_ring at high IOPS across several threads on several cores.

2) I then noticed that udev set a watch (via inotify) on the files in /dev.
This is due to a rule in /usr/lib/udev/rules.d/60-block.rules
# watch metadata changes, caused by tools closing the device node which was=
 opened for writing
ACTION!=3D"remove", SUBSYSTEM=3D=3D"block", \
  KERNEL=3D=3D"loop*|mmcblk*[0-9]|msblk*[0-9]|mspblk*[0-9]|nvme*|sd*|vd*|xv=
d*|bcache*|cciss*|dasd*|ubd*|ubi*|scm*|pmem*|nbd*|zd*", \
  OPTIONS+=3D"watch"
I removed "nvme*" from this rule (I am testing on /dev/nvme0n1), then final=
ly the fsnotify overhead disappeared.

3) I think there is nothing wrong with Pipewire and udev, they simply want =
to watch what is going on in /dev.
I don't think they are interested in (and it is not the goal/charter of fsn=
otify) quantifying millions of read/write accesses/sec to a file they watch=
. There are other tools for that, that are optimized for that task.

I think to avoid the overhead, the fsnotify subsystem should be refined to =
factor high frequency read/write file access.
Or piece of code (like aio/io_uring) doing high frequency fsnotify should d=
o the factoring themselves.
Or the user should be given a way to turn off fsnotify calls for read/write=
 on specific file.


Now, the only way to work around the cpu overhead without hacking, is to di=
sable services watching /dev.
That means people can't use these services anymore. Doesn't seem right.

Regards,

Pierre


> -----Original Message-----
> From: Pierre Labat
> Sent: Monday, August 14, 2023 9:31 AM
> To: Jeff Moyer <jmoyer@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>; 'io-uring@vger.kernel.org' <io-
> uring@vger.kernel.org>
> Subject: RE: [EXT] Re: FYI, fsnotify contention with aio and io_uring.
>=20
> Hi Jeff,
>=20
> Indeed, by default, in my configuration, pipewire is running.
> When I can re-test, I'll disabled it and see if that remove the problem.
> Thanks for the hint!
>=20
> Pierre
>=20
> > -----Original Message-----
> > From: Jeff Moyer <jmoyer@redhat.com>
> > Sent: Wednesday, August 9, 2023 10:15 AM
> > To: Pierre Labat <plabat@micron.com>
> > Cc: Jens Axboe <axboe@kernel.dk>; 'io-uring@vger.kernel.org' <io-
> > uring@vger.kernel.org>
> > Subject: Re: [EXT] Re: FYI, fsnotify contention with aio and io_uring.
> >
> > CAUTION: EXTERNAL EMAIL. Do not click links or open attachments unless
> > you recognize the sender and were expecting this message.
> >
> >
> > Pierre Labat <plabat@micron.com> writes:
> >
> > > Micron Confidential
> > >
> > > Hi Jeff and Jens,
> > >
> > > About "FAN_MODIFY fsnotify watch set on /dev".
> > >
> > > Was using Fedora34 distro (with 6.3.9 kernel), and fio. Without any
> > particular/specific setting.
> > > I tried to see what could watch /dev but failed at that.
> > > I used the inotify-info tool, but that display watchers using the
> > > inotify interface. And nothing was watching /dev via inotify.
> > > Need to figure out how to do the same but for the fanotify interface.
> > > I'll look at it again and let you know.
> >
> > You wouldn't happen to be running pipewire, would you?
> >
> > https://urldefense.com/v3/__https://gitlab.freedesktop.org/pipewire/pi
> > pewir
> > e/-
> > /commit/88f0dbd6fcd0a412fc4bece22afdc3ba0151e4cf__;!!KZTdOCjhgt4hgw!6E
> > 063jj
> > -_XK1NceWzms7DaYacILy4cKmeNVA3xalNwkd0zrYTX-IouUnvJ8bZs-RG3YSdk5XpFoo$
> >
> > -Jeff
> >
> > >
> > > Regards,
> > >
> > > Pierre
> > >
> > >
> > >
> > > Micron Confidential
> > >> -----Original Message-----
> > >> From: Jens Axboe <axboe@kernel.dk>
> > >> Sent: Tuesday, August 8, 2023 2:41 PM
> > >> To: Jeff Moyer <jmoyer@redhat.com>; Pierre Labat
> > >> <plabat@micron.com>
> > >> Cc: 'io-uring@vger.kernel.org' <io-uring@vger.kernel.org>
> > >> Subject: [EXT] Re: FYI, fsnotify contention with aio and io_uring.
> > >>
> > >> CAUTION: EXTERNAL EMAIL. Do not click links or open attachments
> > >> unless you recognize the sender and were expecting this message.
> > >>
> > >>
> > >> On 8/7/23 2:11?PM, Jeff Moyer wrote:
> > >> > Hi, Pierre,
> > >> >
> > >> > Pierre Labat <plabat@micron.com> writes:
> > >> >
> > >> >> Hi,
> > >> >>
> > >> >> This is FYI, may be you already knows about that, but in case
> > >> >> you
> > >> don't....
> > >> >>
> > >> >> I was pushing the limit of the number of nvme read IOPS, the FIO
> > >> >> + the Linux OS can handle. For that, I have something special
> > >> >> under the Linux nvme driver. As a consequence I am not limited
> > >> >> by whatever the NVME SSD max IOPS or IO latency would be.
> > >> >>
> > >> >> As I cranked the number of system cores and FIO jobs doing
> > >> >> direct 4k random read on /dev/nvme0n1, I hit a wall. The IOPS
> > >> >> scaling slows (less than linear) and around 15 FIO jobs on 15
> > >> >> core threads, the overall IOPS, in fact, goes down as I add more
> > >> >> FIO jobs. For example on a system with 24 cores/48 threads, when
> > >> >> I goes beyond 15 FIO jobs, the overall IOPS starts to go down.
> > >> >>
> > >> >> This happens the same for io_uring and aio. Was using kernel
> > >> >> version
> > >> 6.3.9. Using one namespace (/dev/nvme0n1).
> > >> >
> > >> > [snip]
> > >> >
> > >> >> As you can see 76% of the cpu on the box is sucked up by
> > >> >> lockref_get_not_zero() and lockref_put_return().  Looking at the
> > >> >> code, there is contention when IO_uring call fsnotify_access().
> > >> >
> > >> > Is there a FAN_MODIFY fsnotify watch set on /dev?  If so, it
> > >> > might be a good idea to find out what set it and why.
> > >>
> > >> This would be my guess too, some distros do seem to do that. The
> > >> notification bits scale horribly, nobody should use it for anything
> > >> high performance...
> > >>
> > >> --
> > >> Jens Axboe

