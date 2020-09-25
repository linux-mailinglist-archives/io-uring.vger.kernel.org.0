Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0AA27846F
	for <lists+io-uring@lfdr.de>; Fri, 25 Sep 2020 11:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbgIYJxI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Sep 2020 05:53:08 -0400
Received: from mail-shaon0155.outbound.protection.partner.outlook.cn ([42.159.164.155]:32738
        "EHLO CN01-SHA-obe.outbound.protection.partner.outlook.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727346AbgIYJxI (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 25 Sep 2020 05:53:08 -0400
X-Greylist: delayed 961 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Sep 2020 05:53:06 EDT
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ObReHnidu7aciwPzGIpY1nwZo3lbzflLlPCiiI6rt1iZ7jTC5uidWPSsD1lr5ANLFmU1a5YEWKNPMWxl4ahYxYhffv2GeIwCjySC+zzoTKzFSS787Ehb8MnUTwAAPDzygt8xEPGyn8KYIj4IatMzNJc22HGYhZMzQjkKUH7Drn2OdF7n5fGNMh5srlWdbOc+CjypxXAL3HAyVN6fQsBwHjj119t2aUY1JriIhWVdAgWKsC/I+6M6QSM9om0Eya3oRu8GgVgYD7eIvjYWBY/Ulfo/k6dmrLPP74Om9rA9YoRZeA2NYEpJRA6tiehVSyN3V8dSKCfLrV0QKEyn2KEqkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=za1ZULfhavWrzGcxP+yOr62moeXcHP0/dnjs4zfogzA=;
 b=C4qM/9kOEE3bB5gMRdG0W28fVnez8zWlb5NQO3gNItxbiTivnGc0LGfUjlIk+3LljerXTjSctx7sRDpNUXAuIBWIhMcxVyt+DcpBximqWxW9dhnxPHyRkNkjPfs96oSPSptWljFMd/2RxFBPpck+LaY/8nZ/O/aDsYDbx9MCRfjEsnM7W8coGmJsedGrn/PS2dtpjPac6VM6TMQ5ravEGIE70yZE1MOpsmN/feHrh434fv+SSmAhRBJJQuhNdPLT5wkLmXb2vi+6u6lbhcdOMjR64Yj8jnrmMc1vPwo2QoqN9AgWq6pV1FPe+iKXLtOHChRrRLK0V7XDS+8w/eepVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eoitek.com; dmarc=pass action=none header.from=eoitek.com;
 dkim=pass header.d=eoitek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=eoitek.partner.onmschina.cn; s=selector1-eoitek-partner-onmschina-cn;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=za1ZULfhavWrzGcxP+yOr62moeXcHP0/dnjs4zfogzA=;
 b=a2EXgo+TTepc1jNcui1VxKIJUxhYEIcoB0kuKbEudD5uRKUuBJl14aQ7nc0HtNrSpAqXX7broU5Rix4woebnC6XLN8tzd5CXI6CKTkcOOtOFk9p3lpfIJDhsEeqBjOkBob/+R/bDGcZxjeJAedD43/Me1SLSkbCrRHNR/5zZgnI=
Received: from SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn (10.43.110.79) by
 SHXPR01MB0720.CHNPR01.prod.partner.outlook.cn (10.43.107.16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3412.22; Fri, 25 Sep 2020 09:37:02 +0000
Received: from SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn ([10.43.110.79])
 by SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn ([10.43.110.79]) with mapi
 id 15.20.3412.025; Fri, 25 Sep 2020 09:37:02 +0000
From:   =?iso-2022-jp?B?Q2FydGVyIExpIBskQk17REw9JxsoQg==?= 
        <carter.li@eoitek.com>
To:     io-uring <io-uring@vger.kernel.org>
Subject: Short read handling inconsistency for IOSQE_IO_LINK
Thread-Topic: Short read handling inconsistency for IOSQE_IO_LINK
Thread-Index: AQHWkx9sqPZjJAw6qE6Ukjtsci7xfg==
Date:   Fri, 25 Sep 2020 09:37:02 +0000
Message-ID: <87153725-2567-48F7-B810-293977C5C65E@eoitek.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=eoitek.com;
x-originating-ip: [180.167.157.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e26a92ec-bc6d-418d-39d7-08d861368ec8
x-ms-traffictypediagnostic: SHXPR01MB0720:
x-microsoft-antispam-prvs: <SHXPR01MB0720A30C4CAD54ED11B8DCB794360@SHXPR01MB0720.CHNPR01.prod.partner.outlook.cn>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: faTftZX47dS0AaPB3U4K71Vhz9uWHj2nRDu3UhnU6FRURGlp6gIEK51i+Wmi6YZnwfSotd7ad8VQ3YPhLRkFFoimI9A5GNidJNeGm0BExd7Phj8UIQXMwoOenW5QbOfnUui/4QgLtoKmNpcwU4Ndl2EY5iR9AlwGtmC8wgWBfS6qCGSLumgWlw0zWiwJ/Dzqd464PIQ1stX/6ixyNcFJUxmxtNfdbIzQm0Ew0TPLLk2bAso+Nfzp8WPiVxWn/UuHGe2JvA71L2Zy8QN5zD18GPJmCvXlIegZ7vIbm5+EJbHlRY8TVkOzWTgiyJ4+uRACz0qia6RD8XcZisiDQ66AcYB6lxvq7Q1Ysa26ORI5OPakoc9IWIoLhJMob1rh8Tdm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(329002)(328002)(66556008)(66476007)(5660300002)(66946007)(64756008)(6916009)(66446008)(85182001)(508600001)(4744005)(33656002)(63696004)(36756003)(8936002)(8676002)(71200400001)(76116006)(186003)(26005)(2616005)(95416001)(2906002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: bNnDUFMdn71wUWupB3VCVhsl2h8v3lB5a3x4qIfILAexKbWNY5RSYqwvGdGC+KcnpJ3YYLq0U40iFm9DMbIAG+IF5+nIKHy+v58U2aKcYkVgjQbfUEK1iEelIZ7e9YTJdUXTvrjSOhKoQ0sOoIf/8SkARj7vjSLm3fLMdeFGMC6zQLVnDkQ5cnm8HXXjJVFDWTIX56VBlhoKm4So6+8ufti8yQINBo9WmstxL2ZLFPNvWC7Ye+vXP7PdxYWHEoOvwJHIZveODXqN+w8rudhzl5e17qdo0GUO0XCYw3xnxH8etyUAt5Qo0DwAympERiMarH8c9D1vvM4XVVui3cAkpOq/OCOihip2WFcIiItfN0p8h3n0sblbVfizEMUgNRUft1aw99C/nhElP54/+svfvLx9n7nlG1f3/ZhGCzvAbhqQVRdWoFK38QN9Ct3xLAmmVEV4blae+yNEdgEX6eSid79ykxivOkgbcN92bNC3iyWRka0/ef3GwTQzwO127clL2MIXEiYGa/5T1V2QGFo1QSy6IsY6/Vv3CcPeB5nIWLoChFX2W0r3ADr/sHoVhSPZKj4eZwDXiXJUTvfKbsIi1Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <B11995CA6382464BAB828B0F604DB5E3@CHNPR01.prod.partner.outlook.cn>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: eoitek.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-Network-Message-Id: e26a92ec-bc6d-418d-39d7-08d861368ec8
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2020 09:37:02.2891
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e3e4d1ca-338b-4a22-bdef-50f88bbc88d8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dwvhyjs6TDgKX2o/xhbPQcxkISYjrwBiJovWyUfOEiRobnB+kbhe1PlOnBu0/1qNBwO4/2S3RGWafdi3KdUjKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SHXPR01MB0720
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi all,

Short read of IORING_OP_READ in a link chain is considered an error, becaus=
e it
will break READ-WRITE chain, which is good.

The problems are:

1. Short read of IORING_OP_RECV in a link chain is *NOT* considered an erro=
r,
which is odd and not consistant with IORING_OP_READ. Is it a bug or by desi=
gn?

2. Short read of IORING_OP_SPLICE in a link chain is considered an error. I=
t is
consistant with IORING_OP_READ, but not very useful because the link
   1) splice(fd1, NULL, pfd1, NULL, -1, 0)
   2) splice(pfd2, NULL, fd2, NULL, -1, 0)
is a valid operation since the kernel knows how much data can be read in a =
pipe.

Any thoughts?

Regards,
Carter

