Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04DD115FB5F
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2020 01:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbgBOAQP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Feb 2020 19:16:15 -0500
Received: from mail-bjbon0156.outbound.protection.partner.outlook.cn ([42.159.36.156]:5830
        "EHLO CN01-BJB-obe.outbound.protection.partner.outlook.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726079AbgBOAQP (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 14 Feb 2020 19:16:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EYqJPfe7rYvkkGBOGtO3qXl99Cm1ERY/zEBLj53EtyxMnn33Kr4veldzu5t4C8lSdpdZfa0H8XG6QZQvhvywCixzeUD0H2cgFUkScnuIOk8wxrq03hxJfdTbJ8jvhaXB3yjOACirS4GM4ahMlRI+6DDj0Esv1BRVouqwv5Fi4YGVL+oP6IcBdT1gcnJxYBBuip8D/KWRaRBsrGKSje6q7CYoF+uIBLLIVzH63DTqOke/Izwalw3DLoEoxZaV3JAXy41/wLEHZQG1fMIvKLPY62QjFOsJdEP7KvaM6OVA7avTqn30J517OsFHi+hLelcI3NUYnTQsKrrxH22WoTVd5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oiq14Jg+i0AKvMWP4KLFsNIPg/ZIExCfnHyKxWQV/xE=;
 b=m+T7bevwHNCDs00lBuC+7MeNl5Pzivtnos76a6YyyP1/BYXY0T4+38hXg9oV4L+pNmoUh5lUBiotLAb8WG/oJP0guz5XI7/PGFJK/9Wfq6yHZ5BjJWpwNezn48eK614l8lh/VF0844FgddOqWp9UbXYZPgp5/hgRKoBiCI6zaxg+wnLc5YBNPRJuvrJxD7FGpgHerEdzWSY8BqtPRi2wSUiU19IQ3WK6K3NaVvYETsvzop9pz6bsyrcVYAmLvQ6SnWFzsJDYNW+jhhikO5hBZiQT+XtK56Hq0pC2F6XhEyG21N3+3dXaX0ir+Te5jtT2e7VP2WOB+U0TZyIElb93/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eoitek.com; dmarc=pass action=none header.from=eoitek.com;
 dkim=pass header.d=eoitek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=eoitek.partner.onmschina.cn; s=selector1-eoitek-partner-onmschina-cn;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oiq14Jg+i0AKvMWP4KLFsNIPg/ZIExCfnHyKxWQV/xE=;
 b=r0mPS/c3F0ene6OP+hrh8u4WXC0BLH/dwS2lVLiACTHQdb2lIYal2BphonAACC0SwIVDz5MDtCeNVWEJ2qn8HextSl5BO7/lNGQP3wN80qbtD4MIj4lnr+QmBBHUWNnAwMdy0jl+1+RPYzV4M/3edkthvmRo5Z8xCpMsiIWauaY=
Received: from SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn (10.43.108.138)
 by SH0PR01MB0570.CHNPR01.prod.partner.outlook.cn (10.43.108.139) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.23; Sat, 15 Feb
 2020 00:16:09 +0000
Received: from SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn ([10.43.108.138])
 by SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn ([10.43.108.138]) with mapi
 id 15.20.2729.021; Sat, 15 Feb 2020 00:16:09 +0000
From:   =?utf-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     Peter Zijlstra <peterz@infradead.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
Thread-Topic: [ISSUE] The time cost of IOSQE_IO_LINK
Thread-Index: AQHV4cHhpj4vlwaolEOmZJk1sNu8q6gXy2CAgAB7iICAAPRcgIAAAeCAgAAKIQCAAKCdAIAAFkwAgAAmnQCAAK+SAIAABF8AgAAIjwCAABpOgIAAMAEAgAA7HwA=
Date:   Sat, 15 Feb 2020 00:16:09 +0000
Message-ID: <FA1CECBA-FBFE-4228-BA5C-1B8A4A2B3534@eoitek.com>
References: <9FEF0D34-A012-4505-AA4E-FF97CC302A33@eoitek.com>
 <8a3ee653-77ed-105d-c1c3-87087451914e@kernel.dk>
 <ADF462D7-A381-4314-8931-DDB0A2C18761@eoitek.com>
 <9a8e4c8a-f8b2-900d-92b6-cc69b6adf324@gmail.com>
 <5f09d89a-0c6d-47c2-465c-993af0c7ae71@kernel.dk>
 <7E66D70C-BE4E-4236-A49B-9843F66EA322@eoitek.com>
 <671A3FE3-FA12-43D8-ADF0-D1DB463B053F@eoitek.com>
 <217eda7b-3742-a50b-7d6a-c1294a85c8e0@kernel.dk>
 <1b9a7390-7539-a8bc-d437-493253b13d77@kernel.dk>
 <20200214153218.GM14914@hirez.programming.kicks-ass.net>
 <5995f84e-8a6c-e774-6bb5-5b9b87a9cd3c@kernel.dk>
 <7c4c3996-4886-eb58-cdee-fe0951907ab5@kernel.dk>
 <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
 <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
In-Reply-To: <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=carter.li@eoitek.com; 
x-originating-ip: [183.200.9.149]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3496595-ba2a-4f8e-5b0d-08d7b1ac41c5
x-ms-traffictypediagnostic: SH0PR01MB0570:
x-microsoft-antispam-prvs: <SH0PR01MB0570E0A3BC0DDA863E57CF1894140@SH0PR01MB0570.CHNPR01.prod.partner.outlook.cn>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 03142412E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(346002)(328002)(189003)(329002)(199004)(66476007)(66556008)(5660300002)(508600001)(8936002)(71200400001)(63696004)(2616005)(36756003)(4744005)(76116006)(26005)(186003)(2906002)(64756008)(66446008)(66946007)(95416001)(54906003)(8676002)(81166006)(81156014)(6916009)(33656002)(86362001)(4326008)(85182001);DIR:OUT;SFP:1102;SCL:1;SRVR:SH0PR01MB0570;H:SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: eoitek.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4z0Xp6S3aMKsby3rmj7jp80ah5Amg2sxd2wxCdEdUhu6TJB/QoSUjcBrCW9KURSPXBQjjbhrBZk5uZuREkR1wF+9XxbO1S6TO5195HykfWHNrRxXS7acjY2cIjbCVnkdexzJgrtWYv/EHnc/ofXQgQBL0zS1tJJHXL7Ar8tyfEVoCpoet9JMPtusQu+5+hNV+ZUeN9Or7qwSmSPuvVI6Rj9g4RBCuT+wM5mnssLMwcF9Fb7/G8bS7dRa0uSEZyEeQwaW29z8G6aNILJBGWJcIzmTwb3c4M5qs4FgqjW+KXR9pYiq7lMP5pzHVr5SsdeICAsLDFPeGk3EC8LD5lv55gjyvIRy3c7k+rCsPgRBWOETSJzCpnEjR+xfHlPx0Su9YnWA9S0alyo7Tb/TepoJRNeLoZ1g3UNUDucFapQmz1K9A6WtpMiK+8bCwJVQZ3IO
x-ms-exchange-antispam-messagedata: napGfBnZAVeQsZsDpcYnq2xF6ZIEPNpJNmhjZa+y4IZvTOUuti+l+B8YK+nQX9hXO2dnekGouorXK5+514IzrlB4cpyXWtGO65NJFwrmzkpt95BUKQfWS0aEH9SyOHLC6GC+iIFWftG2j3K3Cq3EdA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D410EE5EA361149A8D375ABEE3C938F@CHNPR01.prod.partner.outlook.cn>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: eoitek.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3496595-ba2a-4f8e-5b0d-08d7b1ac41c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2020 00:16:09.1698
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e3e4d1ca-338b-4a22-bdef-50f88bbc88d8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 62T5TDa9nb1pjMdRsiPtzuOz28dzWGeIxGT7oYUJIjxJFathdDQf14iK+MHg519ySQaseaVABB5tJ4lGOrblsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SH0PR01MB0570
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

SGVsbG8gSmVucywNCg0KDQo+IEl0J3Mgbm93IHVwIHRvIDMuNXggdGhlIG9yaWdpbmFsIHBlcmZv
cm1hbmNlIGZvciB0aGUgc2luZ2xlIGNsaWVudCBjYXNlLg0KPiBIZXJlJ3MgdGhlIHVwZGF0ZWQg
cGF0Y2gsIGZvbGRlZCB3aXRoIHRoZSBvcmlnaW5hbCB0aGF0IG9ubHkgd2VudCBoYWxmDQo+IHRo
ZSB3YXkgdGhlcmUuDQoNCg0KSeKAmW0gbG9va2luZyBmb3J3YXJkIHRvIGl0Lg0KDQpBbmQgcXVl
c3Rpb24gYWdhaW46IHNpbmNlIFBPTEwtPlJFQUQvUkVDViBpcyBtdWNoIGZhc3RlciB0aGVuIFJF
QUQvUkVDViBhc3luYywNCmNvdWxkIHdlIGltcGxlbWVudCBSRUFEL1JFQ1YgdGhhdCB3b3VsZCBi
bG9jayBhcyBQT0xMLT5SRUFEL1JFQ1Y/IE5vdCBvbmx5IGZvcg0KbmV0d29ya2luZywgYnV0IGFs
c28gZm9yIGFsbCBwb2xsYWJsZSBmZHMuDQoNCkNhcnRlcg==
