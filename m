Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED1E24E655
	for <lists+io-uring@lfdr.de>; Sat, 22 Aug 2020 10:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgHVILV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Sat, 22 Aug 2020 04:11:21 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3142 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726970AbgHVILR (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 22 Aug 2020 04:11:17 -0400
Received: from dggeme702-chm.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 897D2AC60E35EE4E8B24;
        Sat, 22 Aug 2020 16:11:12 +0800 (CST)
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme702-chm.china.huawei.com (10.1.199.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Sat, 22 Aug 2020 16:11:12 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1913.007;
 Sat, 22 Aug 2020 16:11:12 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
CC:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] io_uring: Convert to use the fallthrough macro
Thread-Topic: [PATCH] io_uring: Convert to use the fallthrough macro
Thread-Index: AdZ4W7N8nOD9lXUkSISaAM7ee6MjIA==
Date:   Sat, 22 Aug 2020 08:11:12 +0000
Message-ID: <078dc0918bf34ddb8259e6dabb5394ac@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Friendly ping :)

>From: Miaohe Lin <linmiaohe@huawei.com>
>
>Convert the uses of fallthrough comments to fallthrough macro.
>
>Signed-off-by: Hongxiang Lou <louhongxiang@huawei.com>
>Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
>---
> fs/io_uring.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/fs/io_uring.c b/fs/io_uring.c index 2a3af95be4ca..77e932c25312 100644
>--- a/fs/io_uring.c
>+++ b/fs/io_uring.c
>@@ -2516,7 +2516,7 @@ static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
> 		 * IO with EINTR.
> 		 */
> 		ret = -EINTR;
>-		/* fall through */
>+		fallthrough;
> 	default:
> 		kiocb->ki_complete(kiocb, ret, 0);
> 	}
>--
>2.19.1
>
