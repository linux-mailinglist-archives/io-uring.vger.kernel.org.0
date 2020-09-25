Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C65277E39
	for <lists+io-uring@lfdr.de>; Fri, 25 Sep 2020 04:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgIYCwv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Sep 2020 22:52:51 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:47250 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbgIYCwv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Sep 2020 22:52:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1601002370; x=1632538370;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=18SQ0G1YpXb3pkcs5CP9xC7lBAzkKN5ZI6TjyfXbJ2U=;
  b=QPKHphyR5U1n0p0D0sKvoOhvVyv/wCBJyQ8F/1KKVNlte6jukqARSdom
   /pauds7YMdUnLxxb1i8oql10X2n5bGd9dMa3Nnkt12a0WPYM2x4XpSnL3
   XNrnb2jU5Ae7AXQtAB1KEOZXK28Bt0WH8eCFB5i3iIpuCxBivGMrQmpEs
   nRXrbkbnu2bau6XBqcR5BDsQgExCXZYjg6yAfQNc3QGadYpZ1K2PDQwb/
   srOW7JQT4wS6hEgQIlhLKfx+5tajMZenA+82BMSsmwQebRhEzEP0b4PYe
   uxmyIIf8kGXKRRvao0Df6zJ8+YWh1F9S3lh98fYza1fiviRTjdvnZWoA8
   g==;
IronPort-SDR: apmrPU3XlbZkWZkyH4Oo9ZJnLsxVDhqd7mYsg7EqPNvuzIEC0IVeFCiqbBYP3mFFSOrdIKeBL1
 /vq66CWXm6uZg3D9833mWzCpIew4Q1sCRRoP/oaZiabQeZ8sgPPxAbwR8ghbrbjwCj+jrXtSXP
 ZKtK2TQLXz1bEqVuqCQgfXl6W47EX/kzBDumdlXucQGYu5eE3iEOKOHBoKuC2ERjFtPzf+RQZm
 W5Cr4dnmguKvihylIEWW+GEWH2C8HifaI0mcX6cpbv3ncdW1W/04AFeqb2HmyYV+VIoc7fUySS
 TbU=
X-IronPort-AV: E=Sophos;i="5.77,300,1596470400"; 
   d="scan'208";a="257948027"
Received: from mail-dm6nam12lp2176.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.176])
  by ob1.hgst.iphmx.com with ESMTP; 25 Sep 2020 10:52:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jj7s86LZl1kq5JzlBkgrss8h9BUuU2A8Mm8Uci+Ch7BnPepNMxkVjnIiHdzliuFD6+lSw9kMB8/tVDTPHzHJVS8ie7v2EHIazrt9pp407cZDOBtsWoIK6jYXhtA7ZOWBdwqJROhkWbcl3zaOABmJtxjGntRK5Mx982y7bClJn3gUAUbrxe4Udj0sZ/0oO3oM5DUmwXgxN5rAV48JecZI28Ep99EX8LCWetMxv/r+JfJjQAtVdJm9tqe2vTlBLRVIhUG1p/JXVfqTNAuaPKgNst4k2uk2Mlae+qs750x9yN9proZOh8KjK3Dz/5rPVEqF9KXNNzvbz7NjL8m1DR7Y5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+PcJoikJ62zQjjfYccg+O2GcJQygmhxhLlIQ4QxluA=;
 b=TnC4FRheec4f9dIe89bkUv12emfSOePZqBFO9V7NJa+Gk30b6PIpWP47QJIG57tN7xgCMI8EiNqiwQjNAEYxx1l2VXRAlZoxfcfQHI/smyZzbPdv+XLbSVbNrJ9rOsPlOfzOXpVHaK/VlN7hzBo6hev9wwZX2S+vqs8BUgFw6VkMC4mbd5XNrc9SSPlC86I5Ys18Gyl8XketQyntF1ebTGl5THvO2f8Lhan3pmcjjsgUMnqFw7qqdSV77JnyE32uInzgatw9Spqwl5eBweKkam+yEmcbvGlODwzp3xpYEwAkdP56QaC3nRXMuEitvO8mJmnSuePjZhy8XbuMF2UHTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+PcJoikJ62zQjjfYccg+O2GcJQygmhxhLlIQ4QxluA=;
 b=ofuMjJ/BnIJAHduiI3O/j2jLiu2rrtvXhDLsKvf2OHdiZImjSbeVGT7GGS6ts0tefPWvU8V3K1Qjp4MbGXP96IVLmDDd2jdcRcv4sIw+CEz0Zj0xBQ+5+QnWSllan+EDxOAhfoyHKULR852TvwzuJS+ENlo8b2BQQRTbVHHKYxg=
Received: from MWHPR04MB3758.namprd04.prod.outlook.com (2603:10b6:300:fb::8)
 by MWHPR04MB0369.namprd04.prod.outlook.com (2603:10b6:300:70::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Fri, 25 Sep
 2020 02:52:48 +0000
Received: from MWHPR04MB3758.namprd04.prod.outlook.com
 ([fe80::30a6:9f87:e223:6468]) by MWHPR04MB3758.namprd04.prod.outlook.com
 ([fe80::30a6:9f87:e223:6468%6]) with mapi id 15.20.3412.021; Fri, 25 Sep 2020
 02:52:48 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Kanchan Joshi <joshiiitr@gmail.com>,
        "hch@infradead.org" <hch@infradead.org>
CC:     Jens Axboe <axboe@kernel.dk>,
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
Date:   Fri, 25 Sep 2020 02:52:47 +0000
Message-ID: <MWHPR04MB3758A78AFAED3543F8D38266E7360@MWHPR04MB3758.namprd04.prod.outlook.com>
References: <CA+1E3rLM4G4SwzD6RWsK6Ssp7NmhiPedZDjrqN3kORQr9fxCtw@mail.gmail.com>
 <MWHPR04MB375863C20C1EF2CB27E62703E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731091416.GA29634@infradead.org>
 <MWHPR04MB37586D39CA389296CE0252A4E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731094135.GA4104@infradead.org>
 <MWHPR04MB3758A4B2967DB1FABAAD9265E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731125110.GA11500@infradead.org>
 <CY4PR04MB37517D633920E4D31AC6EA0DE74B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200814081411.GA16943@infradead.org>
 <CA+1E3r+WXC_MK5Zf2OZEv17ddJDjtXbhpRFoeDns4F341xMhow@mail.gmail.com>
 <20200908151801.GA16742@infradead.org>
 <CA+1E3r+MSEW=-SL8L+pquq+cFAu+nQOULQ+HZoQsCvdjKMkrNw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:61d4:c443:7ba:718]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e261d011-e004-447a-82c3-08d860fe161c
x-ms-traffictypediagnostic: MWHPR04MB0369:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR04MB03699AE76B5D2E4BA1AEF23BE7360@MWHPR04MB0369.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T+U3gwRB1AYK19h6liB6rsuZRUjomEK9FAJ0IhrIpRoKLYAWizTthPZqcvffS2snkd9tgT5U7KtM/ZyAZu7898bjCzwEr5TaAn8C7m7StZRPqbEdcdHT7ft1/YUKKlKgbICXpS1NIUWbFz6rUY/tCGgnSsk1VmCejv16oilWvesfVq6leb9q6/3su+FPmmYZUQgU0tN7MTdLGyi/iJu6xO6YMm3d42ePNtgEeeYetLWRfnE06X4NEbQv8sw6toSdGDqnk3vfnBJ6frpmtAbJT8fOGc6lyndyr+PGQV5Cbw+JqyZWOOrDfP7P1Ve9fz+fJHmXhDdPtGr2axedmg2FE6glIIYCPD1Sc3hX86Lw32CFjOGxNnfnPjBb1d9K07AK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR04MB3758.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(136003)(396003)(366004)(5660300002)(54906003)(186003)(316002)(4326008)(33656002)(66946007)(110136005)(8936002)(6506007)(8676002)(71200400001)(66446008)(76116006)(7696005)(53546011)(7416002)(91956017)(478600001)(66476007)(83380400001)(52536014)(2906002)(55016002)(86362001)(66556008)(9686003)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: JOpDsIdi+mJDrNAR7sqQwfMHSq5GlkEKr84A7U8MEelb/64sUSwS0RZOd+aUVy029nNuBOC8ybaGdnMf20k86fudJzzfNQCjhUwvfLfXwjwSrMn+yxHHoPOqDmzp8ZzNsg/GeaRlHvyRyGNXGtP3x48+diOt3N3Sp3S31JbvTBlt6GUNtZ1tF8SFY+ec/6inXGelv1ziFSIgzoY7uvYEonCEvvxGTFukYvJtaVgozHtPebagSSOa4AGiwzjpilfMmL3rJs8A3LDyNgUcLsvFIhBw5uDtABg+xkJplsrnAa0RYc0mcqPJs1cBjgT70tDep24YvUJWxUeCXG/sGF7yQUGAJeOXLxB6Ze6CZycy1AHAsD3lxEMrceUNtNC7REJdDtrRzF9v7nU4inrigzmoVucU/6LM9kLav1kNuICbJpqcKa4pshS3OiS/u34rwBZ5t24ddiVHbyyIEtjzPKJc0MLYVLD8QQwVrE3OOWCl43Zg0ftmVN5heHHUmXJzTM7Ekbyi4xMXpZgjDdLEMx2wh/zWpZun6LkVrqh/eMG1QbTDtBq0ClDZ9qBWnlmOloIQjtmRm4DcCugxlLhlO7Dplhj/08kAy7qWlKnfCkkaqeeopY8l84esSbangGW0NnXE+kRj2Wj4llLFe+6oHrZrX0JqgQYquluQbFMEkv+oYgUvT3H+PnzlcpGxoGf0efj4nYcbsGCF8LwqvEfZRfN9nA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR04MB3758.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e261d011-e004-447a-82c3-08d860fe161c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2020 02:52:48.0182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5ggSE7SrYqdR+YW1kI6XE5qJq8dEm7o/OTOg2oEOZ2t9Gc+OFH/9DCkZf/0FxvO6nTlUSL+62Bv7z3OXsJGAbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR04MB0369
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020/09/25 2:20, Kanchan Joshi wrote:=0A=
> On Tue, Sep 8, 2020 at 8:48 PM hch@infradead.org <hch@infradead.org> wrot=
e:=0A=
>>=0A=
>> On Mon, Sep 07, 2020 at 12:31:42PM +0530, Kanchan Joshi wrote:=0A=
>>> But there are use-cases which benefit from supporting zone-append on=0A=
>>> raw block-dev path.=0A=
>>> Certain user-space log-structured/cow FS/DB will use the device that=0A=
>>> way. Aerospike is one example.=0A=
>>> Pass-through is synchronous, and we lose the ability to use io-uring.=
=0A=
>>=0A=
>> So use zonefs, which is designed exactly for that use case.=0A=
> =0A=
> Not specific to zone-append, but in general it may not be good to lock=0A=
> new features/interfaces to ZoneFS alone, given that direct-block=0A=
> interface has its own merits.=0A=
> Mapping one file to a one zone is good for some use-cases, but=0A=
> limiting for others.=0A=
> Some user-space FS/DBs would be more efficient (less meta, indirection)=
=0A=
> with the freedom to decide file-to-zone mapping/placement.=0A=
=0A=
There is no metadata in zonefs. One file =3D=3D one zone and the mapping be=
tween=0A=
zonefs files and zones is static, determined at mount time simply using rep=
ort=0A=
zones. Zonefs files cannot be renamed nor deleted in anyway. Choosing a zon=
efs=0A=
file *is* the same as choosing a zone. Zonfes is *not* a POSIX file system =
doing=0A=
dynamic block allocation to files. The backing storage of files in zonefs i=
s=0A=
static and fixed to the zone they represent. The difference between zonefs =
vs=0A=
raw zoned block device is the API that has to be used by the application, t=
hat=0A=
is, file descriptor representing the entire disk for raw disk vs file descr=
iptor=0A=
representing one zone in zonefs. Note that the later has *a lot* of advanta=
ges=0A=
over the former: enables O_APPEND use, protects against bugs with user writ=
e=0A=
offsets mistakes, adds consistency of cached data against zone resets, and =
more.=0A=
=0A=
> - Rocksdb and those LSM style DBs would map SSTable to zone, but=0A=
> SSTable file may be two small (initially) and may become too large=0A=
> (after compaction) for a zone.=0A=
=0A=
You are contradicting yourself here. If a SSTable is mapped to a zone, then=
 its=0A=
size cannot exceed the zone capacity, regardless of the interface used to a=
ccess=0A=
the zones. And except for L0 tables which can be smaller (and are in memory=
=0A=
anyway), all levels tables have the same maximum size, which for zoned driv=
es=0A=
must be the zone capacity. In any case, solving any problem in this area do=
es=0A=
not depend in any way on zonefs vs raw disk interface. The implementation w=
ill=0A=
differ depending on the chosen interface, but what needs to be done to map=
=0A=
SSTables to zones is the same in both cases.=0A=
=0A=
> - The internal parallelism of a single zone is a design-choice, and=0A=
> depends on the drive. Writing multiple zones parallely (striped/raid=0A=
> way) can give better performance than writing on one. In that case one=0A=
> would want to file that seamlessly combines multiple-zones in a=0A=
> striped fashion.=0A=
=0A=
Then write a FS for that... Or have a library do it in user space. For the=
=0A=
library case, the implementation will differ for zonefs vs raw disk due to =
the=0A=
different API (regular file vs block devicer file), but the principles to f=
ollow=0A=
for stripping zones into a single storage object remain the same.=0A=
=0A=
> Also it seems difficult (compared to block dev) to fit simple-copy TP=0A=
> in ZoneFS. The new=0A=
> command needs: one NVMe drive, list of source LBAs and one destination=0A=
> LBA. In ZoneFS, we would deal with N+1 file-descriptors (N source zone=0A=
> file, and one destination zone file) for that. While with block=0A=
> interface, we do not need  more than one file-descriptor representing=0A=
> the entire device. With more zone-files, we face open/close overhead too.=
=0A=
=0A=
Are you expecting simple-copy to allow requests that are not zone aligned ?=
 I do=0A=
not think that will ever happen. Otherwise, the gotcha cases for it would b=
e far=0A=
too numerous. Simple-copy is essentially an optimized regular write command=
.=0A=
Similarly to that command, it will not allow copies over zone boundaries an=
d=0A=
will need the destination LBA to be aligned to the destination zone WP. I h=
ave=0A=
not checked the TP though and given the NVMe NDA, I will stop the discussio=
n here.=0A=
=0A=
filesend() could be used as the interface for simple-copy. Implementing tha=
t in=0A=
zonefs would not be that hard. What is your plan for simple-copy interface =
for=0A=
raw block device ? An  ioctl ? filesend() too ? As as with any other user l=
evel=0A=
API, we should not be restricted to a particular device type if we can avoi=
d it,=0A=
so in-kernel emulation of the feature is needed for devices that do not hav=
e=0A=
simple-copy or scsi extended copy. filesend() seems to me like the best cho=
ice=0A=
since all of that is already implemented there.=0A=
=0A=
As for the open()/close() overhead for zonefs, may be some use cases may su=
ffer=0A=
from it, but my tests with LevelDB+zonefs did not show any significant=0A=
difference. zonefs open()/close() operations are way faster than for a regu=
lar=0A=
file system since there is no metadata and all inodes always exist in-memor=
y.=0A=
And zonefs() now supports MAR/MOR limits for O_WRONLY open(). That can simp=
lify=0A=
things for the user.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
