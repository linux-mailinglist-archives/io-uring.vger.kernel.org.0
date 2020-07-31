Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1CEF2343FE
	for <lists+io-uring@lfdr.de>; Fri, 31 Jul 2020 12:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgGaKQy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jul 2020 06:16:54 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:46887 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgGaKQx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jul 2020 06:16:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596190612; x=1627726612;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Nmd3tStm8IGLNMencPLDxyjOyeYYiabulntSB2azMpE=;
  b=jmzvhFROVkutNLIt7Yn6ZoYYrhBueIFHVN6C54Jd8wYuvZibFrZjeb2m
   NrwL+4QMm1JdsGXIWQrIANasUezukvugqj5wS6x6eK1GJ4mYIKA4kyhFK
   RznfG+UXMiqe4859VBRVLY3X1KebRGjJLwFCtwFx1R4Z7ktsMl4Le04wH
   TebTMnO2d9+40E2oiZ7EwhT2bDjAMRvmYfDhH/iePOfhxPMCELBIczWEY
   haGwsW4/UxtmQ4703gkns1tHF5lOxdvAoDZeWmsWPVSBLJxXOxCySUPs1
   2hwCSsoYnMDPqn3wr7sTW8UPjvQHnrOUB15q1DTRnv7YTOWZHiwL7g1GF
   g==;
IronPort-SDR: XUtWyBJNY3Qbg80WUIO7J60qRjjlTJhqACzG3qvGYVlQXZ7LEsbenmHqh/63lL8BKVlJF1gSn7
 CM5qUkrQthOOBmd+cYVi21mr4Q0liZIEzkvb0P84/wZ7bfARRmdF/XdEp2fNWnuPMHge3iNWLA
 v5phXqPCkIqEXeRFLVnZCpM3OI2PpGyjh5pjZgmyXYGLm9xfgo7zd15pOCoJAjlOM597mzKCun
 4pzJ12hRMMz899LXJhMhTiWyrwJb55EqIYqJeS1sWOs/TrAlyg3O3ypre9uC4r1Nl8UH4iGJzW
 USs=
X-IronPort-AV: E=Sophos;i="5.75,418,1589212800"; 
   d="scan'208";a="143830479"
Received: from mail-co1nam11lp2173.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.173])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jul 2020 18:16:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WgP7XC8IE8xePVBpdxZbXIJkOT4cp1KiGt2/U/LnySnbk4T0TCBxQ0o4UfIeK7suVVhgHP21IjetvwJEiNVSObubVkUimUml8Jc+e8Smpkx2gH4xeU8Zvb98Ca3JPHZScRybXEgSSeJ5QkDvCVF2GluEdv54HLp1nKMEvxPExXjpfsaj/FbPwn7Uxt8gjJUuJ4PQH7OZh4od14CM2vnZ+3Illu6F/9qDO9ualx7Y6sUEIlIP1krx16av7br4qAlhannO8ljQTrgLdHbu4gzLAsvPL7TNZGpiWipA7vYL+ZsI9RC5cF5Hc9/77JpgqPu057pSUFIT5/KydmmRScC4YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GEJH4uRAKYW2mBJH4miH2eq7mG/QevBdd7N6GjmMOXI=;
 b=K8XaXocsEbGswajKUA7u1Aie/UgjeQRSV5vCZ1vl4LniClAwDM7BbMHNpifQwheNlG/R8AsLNJGd9O/j7JRYV+90W/dIUH1Jn8bUcwGJjWBJIeukQECB04gJWL7jwgX2EUGPxMKck/0ox0/0s/njPh1/AvtT+zqtypS8YOlHJGIoUEvgMQNBNPBzj6ZEPhpdplECGJjbku2zCIQb/lDvRGQlEXy8rmZbz26x+WAw05LrwydtIvtoNRuqfzvlxX3e5LnjdR2Omzl4GSjcFeOAUo1rzUA2wkQ0UefX2hN1mD51H4bx4RKjvJOHfp1wUf9KqDVYYlMslR4tnx1h/gNBrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GEJH4uRAKYW2mBJH4miH2eq7mG/QevBdd7N6GjmMOXI=;
 b=bION3SPXfAIzEPxWPx6DxJxJKXlwUYFUAqCQ/nViGC4j7sg4AB3/zCnTZhR+UZgLpde/DL0qpxqtrwGcs80T2XnyHAas7BgDORppbhdSYmMOp0FSlleZw+fudbD2T0zTXxqPto5+B+Dfo/kSOAfTzxvf9HMYXSVVyE+3WaM6Fh4=
Received: from MWHPR04MB3758.namprd04.prod.outlook.com (2603:10b6:300:fb::8)
 by MWHPR04MB1039.namprd04.prod.outlook.com (2603:10b6:301:45::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Fri, 31 Jul
 2020 10:16:49 +0000
Received: from MWHPR04MB3758.namprd04.prod.outlook.com
 ([fe80::718a:d477:a4f1:c137]) by MWHPR04MB3758.namprd04.prod.outlook.com
 ([fe80::718a:d477:a4f1:c137%7]) with mapi id 15.20.3239.017; Fri, 31 Jul 2020
 10:16:49 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "hch@infradead.org" <hch@infradead.org>
CC:     Kanchan Joshi <joshiiitr@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        Matthew Wilcox <willy@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Naohiro Aota <Naohiro.Aota@wdc.com>
Subject: Re: [PATCH v4 6/6] io_uring: add support for zone-append
Thread-Topic: [PATCH v4 6/6] io_uring: add support for zone-append
Thread-Index: AQHWYdbcc0q15qREKECGO7brHi6zEg==
Date:   Fri, 31 Jul 2020 10:16:49 +0000
Message-ID: <MWHPR04MB3758A4B2967DB1FABAAD9265E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
References: <CA+1E3rJ3SoLU9aYcugAQgJnSPnJtcCwjZdMREXS3FTmXgy3yow@mail.gmail.com>
 <f030a338-cd52-2e83-e1da-bdbca910d49e@kernel.dk>
 <CA+1E3rKxZk2CatTuPcQq5d14vXL9_9LVb2_+AfR2m9xn2WTZdg@mail.gmail.com>
 <MWHPR04MB3758DC08EA17780E498E9EC0E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731064526.GA25674@infradead.org>
 <MWHPR04MB37581344328A42EA7F5ED13EE74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <CA+1E3rLM4G4SwzD6RWsK6Ssp7NmhiPedZDjrqN3kORQr9fxCtw@mail.gmail.com>
 <MWHPR04MB375863C20C1EF2CB27E62703E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731091416.GA29634@infradead.org>
 <MWHPR04MB37586D39CA389296CE0252A4E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731094135.GA4104@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5410a628-1376-45fc-5312-08d8353ad6a2
x-ms-traffictypediagnostic: MWHPR04MB1039:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR04MB1039C98E3E5DE342D904ED45E74E0@MWHPR04MB1039.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fsug4IDMfZEc83iPSaHW5vCnoF0PX0k4aOM0z0WMdExQOH3Oqpz5NBr27gA//GLHLcHrtZqiDkXjsF4tN0XqQiiaVsyCfIhII9TJlA6JZgYOJt4XEkvLQ2JaobL4i7qOTWdzbYTjtvFVLT73tTwUtFbuTGESL3xeSuJ0Owe6s1L5u/fOaVJF0j15Uh6qfzAyY9qcS4c9KHhdKFTxr1+1ACjBQOuvwuUeuiqF/nsN5d0RqshY07zKAUxEMBktfFxSFlgj+T/I/aOURtS1ydEdGHhaNSnR1t6lZFcZ8z2mz/GDou+i3ibqi/5Vw4XhOwjjsDrl2xg1XQyh06Q3EiTbgw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR04MB3758.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(366004)(136003)(396003)(376002)(4326008)(52536014)(9686003)(5660300002)(53546011)(55016002)(7696005)(26005)(186003)(478600001)(6506007)(33656002)(71200400001)(54906003)(316002)(6916009)(8936002)(66946007)(66476007)(66556008)(64756008)(66446008)(2906002)(83380400001)(91956017)(76116006)(8676002)(7416002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 6kp861OrOsXHmoxRfbSRWad0GW5yTY7jqoHS9XlvDdAO2ru1obTahliKMqKHxdiy4cFWW4BJrqSACEAu4DALt2yA1RAAFkapakfmEGJqVvDE13nZU5K8sKDcmaMnT2K8FWqbJYy1WZi6iTyF57u6f8Wetznic8t9V8USygTTOExvTaDtLXaxJ2oTy8NOUNc8qohFeq7ICg1J7xXm58XBq+9Cg9++a1bTzJWkvqW95SPYEkDP4Y/nnEGbRRdW0RfqhsD56esaByeDorR5d81VQWzbgO5Ci7fR/gGEVPhXUxduK2OQZRmwq3zeN6jjXeTIHOuy9idMVabJLVlhZnK+WeWd0E2ps3ovN8I1jSpjfxJzae8X0WFfO8GV85sbDUqvFOPvktMOer9edpNx1aarPOH/DNf79XS9mGKc6AdEKqa9SeBx2bkn555wuIMkCeAKy5N7jMeiqnqwck+u7k96cfCWE3g9gki4GOQMSOMvRacOg85KNG1j23xy0wJtwdxwpYucvaZTomVi353Jg+0UnSyCzgzzB099woOzXxZFrBWm0jRREC4To14eO5hwsfMQFaNWD/oy6+645rgQXhG3GUK/TK8vEmO60DmlDnEGhq8UFcXAfCCW5abhp0jityIcUAJaq2LsxjIW5yt2tQCffA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR04MB3758.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5410a628-1376-45fc-5312-08d8353ad6a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2020 10:16:49.7513
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v8el+wJ+IbVLJ5V57YDRZXxWa5pGm8yEdr+IHhNaQ8LxKpRKPwEl01npf3WKj3t/eE7ItufmvZzwFvJGy2oGuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR04MB1039
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020/07/31 18:41, hch@infradead.org wrote:=0A=
> On Fri, Jul 31, 2020 at 09:34:50AM +0000, Damien Le Moal wrote:=0A=
>> Sync writes are done under the inode lock, so there cannot be other writ=
ers at=0A=
>> the same time. And for the sync case, since the actual written offset is=
=0A=
>> necessarily equal to the file size before the write, there is no need to=
 report=0A=
>> it (there is no system call that can report that anyway). For this sync =
case,=0A=
>> the only change that the use of zone append introduces compared to regul=
ar=0A=
>> writes is the potential for more short writes.=0A=
>>=0A=
>> Adding a flag for "report the actual offset for appending writes" is fin=
e with=0A=
>> me, but do you also mean to use this flag for driving zone append write =
vs=0A=
>> regular writes in zonefs ?=0A=
> =0A=
> Let's keep semantics and implementation separate.  For the case=0A=
> where we report the actual offset we need a size imitation and no=0A=
> short writes.=0A=
=0A=
OK. So the name of the flag confused me. The flag name should reflect "Do z=
one=0A=
append and report written offset", right ?=0A=
=0A=
Just to clarify, here was my thinking for zonefs:=0A=
1) file open with O_APPEND/aio has RWF_APPEND: then it is OK to assume that=
 the=0A=
application did not set the aio offset since APPEND means offset=3D=3Dfile =
size. In=0A=
that case, do zone append and report back the written offset.=0A=
2) file open without O_APPEND/aio does not have RWF_APPEND: the application=
=0A=
specified an aio offset and we must respect it, write it that exact same or=
der,=0A=
so use regular writes.=0A=
=0A=
For regular file systems, with case (1) condition, the FS use whatever it w=
ants=0A=
for the implementation, and report back the written offset, which  will alw=
ays=0A=
be the file size at the time the aio was issued.=0A=
=0A=
Your method with a new flag to switch between (1) and (2) is OK with me, bu=
t the=0A=
"no short writes" may be difficult to achieve in a regular FS, no ? I do no=
t=0A=
think current FSes have such guarantees... Especially in the case of buffer=
ed=0A=
async writes I think.=0A=
=0A=
> Anything with those semantics can be implemented using Zone Append=0A=
> trivially in zonefs, and we don't even need the exclusive lock in that=0A=
> case.  But even without that flag anything that has an exclusive lock can=
=0A=
> at least in theory be implemented using Zone Append, it just need=0A=
> support for submitting another request from the I/O completion handler=0A=
> of the first.  I just don't think it is worth it - with the exclusive=0A=
> lock we do have access to the zone serialied so a normal write works=0A=
> just fine.  Both for the sync and async case.=0A=
=0A=
We did switch to have zonefs do append writes in the sync case, always. Hmm=
m...=0A=
Not sure anymore it was such a good idea.=0A=
=0A=
> =0A=
>> The fcntl or ioctl for getting the max atomic write size would be fine t=
oo.=0A=
>> Given that zonefs is very close to the underlying zoned drive, I was ass=
uming=0A=
>> that the application can simply consult the device sysfs zone_append_max=
_bytes=0A=
>> queue attribute.=0A=
> =0A=
> For zonefs we can, yes.  But in many ways that is a lot more cumbersome=
=0A=
> that having an API that works on the fd you want to write on.=0A=
=0A=
Got it. Makes sense.=0A=
=0A=
>> For regular file systems, this value would be used internally=0A=
>> only. I do not really see how it can be useful to applications. Furtherm=
ore, the=0A=
>> file system may have a hard time giving that information to the applicat=
ion=0A=
>> depending on its underlying storage configuration (e.g. erasure=0A=
>> coding/declustered RAID).=0A=
> =0A=
> File systems might have all kinds of limits of their own (e.g. extent=0A=
> sizes).  And a good API that just works everywhere and is properly=0A=
> documented is much better than heaps of cargo culted crap all over=0A=
> applications.=0A=
=0A=
OK. Makes sense. That said, taking Naohiro's work on btrfs as an example, z=
one=0A=
append is used for every data write, no matter if it is O_APPEND/RWF_APPEND=
 or=0A=
not. The size limitation for zone append writes is not needed at all by=0A=
applications. Maximum extent size is aligned to the max append write size=
=0A=
internally, and if the application issued a larger write, it loops over mul=
tiple=0A=
extents, similarly to any regular write may do (if there is overwrite etc..=
.).=0A=
=0A=
For the regular FS case, my thinking on the semantic really was: if asked t=
o do=0A=
so, return the written offset for a RWF_APPEND aios. And I think that=0A=
implementing that does not depend in any way on what the FS does internally=
.=0A=
=0A=
But I think I am starting to see the picture you are drawing here:=0A=
1) Introduce a fcntl() to get "maximum size for atomic append writes"=0A=
2) Introduce an aio flag specifying "Do atomic append write and report writ=
ten=0A=
offset"=0A=
3) For an aio specifying "Do atomic append write and report written offset"=
, if=0A=
the aio is larger than "maximum size for atomic append writes", fail it on=
=0A=
submission, no short writes.=0A=
4) For any other aio, it is business as usual, aio is processed as they are=
 now.=0A=
=0A=
And the implementation is actually completely free to use zone append write=
s or=0A=
regular writes regardless of the "Do atomic append write and report written=
=0A=
offset" being used or not.=0A=
=0A=
Is it your thinking ? That would work for me. That actually end up complete=
ly=0A=
unifying the interface behavior for zonefs and regular FS. Same semantic.=
=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
