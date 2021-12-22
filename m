Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4316747D421
	for <lists+io-uring@lfdr.de>; Wed, 22 Dec 2021 16:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237278AbhLVPLf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Wed, 22 Dec 2021 10:11:35 -0500
Received: from usmailhost21.kioxia.com ([12.0.68.226]:30302 "EHLO
        SJSMAIL01.us.kioxia.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234907AbhLVPLf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Dec 2021 10:11:35 -0500
Received: from SJSMAIL01.us.kioxia.com (10.90.133.90) by
 SJSMAIL01.us.kioxia.com (10.90.133.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 22 Dec 2021 07:11:33 -0800
Received: from SJSMAIL01.us.kioxia.com ([fe80::4822:8b9:76de:8b6]) by
 SJSMAIL01.us.kioxia.com ([fe80::4822:8b9:76de:8b6%3]) with mapi id
 15.01.2176.014; Wed, 22 Dec 2021 07:11:33 -0800
From:   Clay Mayers <Clay.Mayers@kioxia.com>
To:     "hch@lst.de" <hch@lst.de>
CC:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "javier@javigon.com" <javier@javigon.com>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>,
        "joshiiitr@gmail.com" <joshiiitr@gmail.com>,
        "pankydev8@gmail.com" <pankydev8@gmail.com>
Subject: RE: [RFC 02/13] nvme: wire-up support for async-passthru on
Thread-Topic: [RFC 02/13] nvme: wire-up support for async-passthru on
Thread-Index: Adf2q4Y1jNlE3svCRZSHuwnlq+XxWAAocZcAAAIa2KA=
Date:   Wed, 22 Dec 2021 15:11:33 +0000
Message-ID: <1ef1f30f1b52498ba10c727a69f7612b@kioxia.com>
References: <2da62822fd56414d9893b89e160ed05c@kioxia.com>
 <20211222080220.GA21346@lst.de>
In-Reply-To: <20211222080220.GA21346@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.90.53.183]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> From: hch@lst.de <hch@lst.de>
> Sent: Wednesday, December 22, 2021 12:02 AM
> 
> On Tue, Dec 21, 2021 at 09:16:27PM +0000, Clay Mayers wrote:
> > Message-ID: <20211220141734.12206-3-joshi.k@samsung.com>
> >
> > On 12/20/21 19:47:23 +0530, Kanchan Joshi wrote:
> > > Introduce handlers for fops->async_cmd(), implementing async
> > > passthru on char device (including the multipath one).
> > > The handlers supports NVME_IOCTL_IO64_CMD.
> > >
> > I commented on these two issues below in more detail at
> > https://github.com/joshkan/nvme-uring-pt/issues
> 
> If you want people to read your comments send them here and not on some
> random website no one is reading.

Of course.  That's the site this patch was staged on before being submitted
here.  The comments there precede the posting here.

