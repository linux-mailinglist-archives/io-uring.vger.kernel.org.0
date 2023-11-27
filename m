Return-Path: <io-uring+bounces-156-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DE3C47FA60D
	for <lists+io-uring@lfdr.de>; Mon, 27 Nov 2023 17:18:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 493EAB211DE
	for <lists+io-uring@lfdr.de>; Mon, 27 Nov 2023 16:18:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3407435F16;
	Mon, 27 Nov 2023 16:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RDetjsoN"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CF4CE;
	Mon, 27 Nov 2023 08:18:14 -0800 (PST)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ARGAmYN028142;
	Mon, 27 Nov 2023 16:17:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Nuqo+n/8UjwMTVEGeTCKZXosXYxmJFELkiNy1EQyEtU=;
 b=RDetjsoNSqPUBKvTXa+yBZv9cgM4/tRINJ+ZyFlcz1qb0NPkwaJ9GrMBibq2hn3f/5CW
 ND1Z7IaAgMUmx8uAabK1Nl5ilpXMpDVf5OETx+5lnUl5qjNiC64q4PtX+8SqtYwOBCmV
 cCdB5Av3LEQ8B9AclxR0DdyVukfpIFH1S5BSEVkhag7d6PmJLZ/11f75vPfjUtjUQPYI
 jOo6tGPT4DyW3BR3TU2aC4jIDdJImhwHQ23EQAgB/MazLxGxSnFqR3kagn1nPRlsiNCG
 WCPnPGg83TnSm3tABpWGa1/oTgd04gU/8Zbwm9/NU76VRx9DKmCqXe7D4H0BVmUgqgtH kg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3umxd509yt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Nov 2023 16:17:19 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3ARGCcKr005148;
	Mon, 27 Nov 2023 16:17:18 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3umxd509xr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Nov 2023 16:17:18 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AREJqSO025580;
	Mon, 27 Nov 2023 16:17:17 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ukvrk9n1b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Nov 2023 16:17:17 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3ARGHGcJ22413978
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Nov 2023 16:17:16 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 15FA45805A;
	Mon, 27 Nov 2023 16:17:16 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3A9CF5803F;
	Mon, 27 Nov 2023 16:17:11 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.23.212])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 27 Nov 2023 16:17:11 +0000 (GMT)
Message-ID: <403a25d73a752da129affe0092e5b85a179f827b.camel@linux.ibm.com>
Subject: Re: [PATCH v2 2/4] eventfd: simplify eventfd_signal()
From: Eric Farman <farman@linux.ibm.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
        Vitaly
 Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org,
        David Woodhouse
 <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>,
        Oded Gabbay
 <ogabbay@kernel.org>, Wu Hao <hao.wu@intel.com>,
        Tom Rix <trix@redhat.com>, Moritz Fischer <mdf@kernel.org>,
        Xu Yilun <yilun.xu@intel.com>, Zhenyu
 Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Jani
 Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen
 <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie
 <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky
 <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Frederic Barrat
 <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>, Arnd
 Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter
 <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian
 Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne
 <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Diana Craciun
 <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>, Fei Li <fei1.li@intel.com>,
        Benjamin
 LaHaise <bcrl@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal
 Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <muchun.song@linux.dev>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fpga@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-rdma@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-usb@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-aio@kvack.org, cgroups@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov
 <asml.silence@gmail.com>, io-uring@vger.kernel.org
Date: Mon, 27 Nov 2023 11:17:10 -0500
In-Reply-To: <20231122-vfs-eventfd-signal-v2-2-bd549b14ce0c@kernel.org>
References: <20231122-vfs-eventfd-signal-v2-0-bd549b14ce0c@kernel.org>
	 <20231122-vfs-eventfd-signal-v2-2-bd549b14ce0c@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XoaaD6-mJ7FXgBebGO5fJDYPNfCOc-S6
X-Proofpoint-GUID: dFRt_wiBkITiSbtkagN5iZ6G9Z4ZE_Ku
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-27_14,2023-11-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 phishscore=0
 mlxlogscore=786 impostorscore=0 spamscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311060000 definitions=main-2311270111

T24gV2VkLCAyMDIzLTExLTIyIGF0IDEzOjQ4ICswMTAwLCBDaHJpc3RpYW4gQnJhdW5lciB3cm90
ZToKPiBFdmVyIHNpbmNlIHRoZSBldmVuZmQgdHlwZSB3YXMgaW50cm9kdWNlZCBiYWNrIGluIDIw
MDcgaW4gY29tbWl0CgpzL2V2ZW5mZC9ldmVudGZkLwoKPiBlMWFkNzQ2OGM3N2QgKCJzaWduYWwv
dGltZXIvZXZlbnQ6IGV2ZW50ZmQgY29yZSIpIHRoZQo+IGV2ZW50ZmRfc2lnbmFsKCkKPiBmdW5j
dGlvbiBvbmx5IGV2ZXIgcGFzc2VkIDEgYXMgYSB2YWx1ZSBmb3IgQG4uIFRoZXJlJ3Mgbm8gcG9p
bnQgaW4KPiBrZWVwaW5nIHRoYXQgYWRkaXRpb25hbCBhcmd1bWVudC4KPiAKPiBTaWduZWQtb2Zm
LWJ5OiBDaHJpc3RpYW4gQnJhdW5lciA8YnJhdW5lckBrZXJuZWwub3JnPgo+IC0tLQo+IMKgYXJj
aC94ODYva3ZtL2h5cGVydi5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCB8wqAgMiArLQo+IMKgYXJjaC94ODYva3ZtL3hlbi5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgMiArLQo+IMKgZHJpdmVycy9hY2NlbC9oYWJhbmFs
YWJzL2NvbW1vbi9kZXZpY2UuY8KgIHzCoCAyICstCj4gwqBkcml2ZXJzL2ZwZ2EvZGZsLmPCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCAyICstCj4gwqBk
cml2ZXJzL2dwdS9kcm0vZHJtX3N5bmNvYmouY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAg
NiArKystLS0KPiDCoGRyaXZlcnMvZ3B1L2RybS9pOTE1L2d2dC9pbnRlcnJ1cHQuY8KgwqDCoMKg
wqAgfMKgIDIgKy0KPiDCoGRyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L2RldnguY8KgwqDCoMKg
wqDCoMKgwqAgfMKgIDIgKy0KPiDCoGRyaXZlcnMvbWlzYy9vY3hsL2ZpbGUuY8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgIDIgKy0KPiDCoGRyaXZlcnMvczM5MC9jaW8vdmZp
b19jY3dfY2hwLmPCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgMiArLQo+IMKgZHJpdmVycy9zMzkw
L2Npby92ZmlvX2Njd19kcnYuY8KgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCA0ICsrLS0KPiDCoGRy
aXZlcnMvczM5MC9jaW8vdmZpb19jY3dfb3BzLmPCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgNiAr
KystLS0KPiDCoGRyaXZlcnMvczM5MC9jcnlwdG8vdmZpb19hcF9vcHMuY8KgwqDCoMKgwqDCoMKg
wqAgfMKgIDIgKy0KCkFja2VkLWJ5OiBFcmljIEZhcm1hbiA8ZmFybWFuQGxpbnV4LmlibS5jb20+
ICAjIHMzOTAKCg==


