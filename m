Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC16792A54
	for <lists+io-uring@lfdr.de>; Tue,  5 Sep 2023 18:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344964AbjIEQey convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Tue, 5 Sep 2023 12:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354096AbjIEJgr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Sep 2023 05:36:47 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A041AE
        for <io-uring@vger.kernel.org>; Tue,  5 Sep 2023 02:36:41 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mtapsc-5-RE-OIzy8PuGpYbXqCyuTRw-1; Tue, 05 Sep 2023 10:36:38 +0100
X-MC-Unique: RE-OIzy8PuGpYbXqCyuTRw-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 5 Sep
 2023 10:36:34 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Tue, 5 Sep 2023 10:36:34 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Breno Leitao' <leitao@debian.org>,
        "sdf@google.com" <sdf@google.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "martin.lau@linux.dev" <martin.lau@linux.dev>,
        "krisman@suse.de" <krisman@suse.de>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>, Song Liu <song@kernel.org>,
        Yonghong Song <yonghong.song@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        "KP Singh" <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        "Alexander Mikhalitsyn" <alexander@mihalicyn.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David Howells" <dhowells@redhat.com>,
        Jason Xing <kernelxing@tencent.com>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>
Subject: RE: [PATCH v4 04/10] net/socket: Break down __sys_getsockopt
Thread-Topic: [PATCH v4 04/10] net/socket: Break down __sys_getsockopt
Thread-Index: AQHZ30xphJKGpfy/Z06Weh22EiUUErAL+aYg
Date:   Tue, 5 Sep 2023 09:36:34 +0000
Message-ID: <b9d56ef784ad436c8cb60c4c9fd2d786@AcuMS.aculab.com>
References: <20230904162504.1356068-1-leitao@debian.org>
 <20230904162504.1356068-5-leitao@debian.org>
In-Reply-To: <20230904162504.1356068-5-leitao@debian.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Breno Leitao
> Sent: 04 September 2023 17:25
> 
> Split __sys_getsockopt() into two functions by removing the core
> logic into a sub-function (do_sock_getsockopt()). This will avoid
> code duplication when doing the same operation in other callers, for
> instance.

Although a lot more work, I think (others may disagree) that
the internal getsockopt() functions should be changed to take
the length as a parameter and return the positive value
to write back.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

