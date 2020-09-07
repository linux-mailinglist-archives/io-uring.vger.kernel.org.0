Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61C425F383
	for <lists+io-uring@lfdr.de>; Mon,  7 Sep 2020 09:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbgIGHCU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Sep 2020 03:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbgIGHCJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Sep 2020 03:02:09 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE63C061574;
        Mon,  7 Sep 2020 00:02:08 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id g4so14563479wrs.5;
        Mon, 07 Sep 2020 00:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ylv/Ec3IQY/nRnVl7KUf4rlIbzcbzilcAdfCxVxqCdM=;
        b=eGZAavdZlKtcT3lSWI7KautQwycdwOhhWwW/QEDVhWUcao0t3/TnmTEfUdfslBudpC
         8nOaO+bFIkEwWAZNjSOuhZ6S26BDST+w8i732lh7nQ3kIYL04wbpYO6FdH0Xvm/2JWaJ
         ySiPaxUHkEGfTtRKfTj2b7T2yXI56gul9vy5dixsvYnOcR6BLkNU5NcTV5022OWDUrso
         uPL9AKxRJWrPp+jiZrtrq8sEq5j4iSINePJYRZ86f9QwUqYx7XzAfdVcV+/qz1oqvkxz
         NHic36LO7xaBXZ7JXPidaQ6oPLkn4BoGtaSdmOAQohYSiqIQdzMaGTWbAUJrsDHKZnGF
         B4dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ylv/Ec3IQY/nRnVl7KUf4rlIbzcbzilcAdfCxVxqCdM=;
        b=kQUDjwR2DxLPzrntfzoR9k/MdjyFt6rlbGZtMCSw5Vt9VpyCtCFFU4semoqizrrweQ
         VUypzNBmKZDVrMZmd0EGCI9UnRTGogBSVjnBKhcbYs+0xk6B9KoC1fpGQ+xIDTLL8QLR
         2mmrM506vf4qZylzZJVelTBeQyroR0tfryYQtBu0eDUUtTNLc0DnM+MDLU0kszCDO+l3
         kZO8cmvGqknukajxJFLlc4u363sH1KpSSVcSnpMwvPVYZ45x9OsHDHJa9qcrTikGFVfE
         xabPK9yEfFvwddCm3whbjkjFAZiMoCR2g6tohykE9gAsB1qX3q87x8LNADmgFN3d74U0
         w4yw==
X-Gm-Message-State: AOAM531PTa1voJrZuf1Y/KWhLy0ldCfaU5mGR2l7OoP42nrrKS+7iTY9
        oeOhqr243+cKS7HFCjoQZR5E+ochjg20EumOTlU=
X-Google-Smtp-Source: ABdhPJw8TAjLd5BYGCY0Tr5/xWkqYwtfubZPgWpkYEtQ1vEu4nZ7Ih5my0t7n5KCYlQdFMaMMGHicv8EGLY6kCKlCsI=
X-Received: by 2002:adf:dd51:: with SMTP id u17mr19759514wrm.355.1599462127129;
 Mon, 07 Sep 2020 00:02:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200731064526.GA25674@infradead.org> <MWHPR04MB37581344328A42EA7F5ED13EE74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <CA+1E3rLM4G4SwzD6RWsK6Ssp7NmhiPedZDjrqN3kORQr9fxCtw@mail.gmail.com>
 <MWHPR04MB375863C20C1EF2CB27E62703E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731091416.GA29634@infradead.org> <MWHPR04MB37586D39CA389296CE0252A4E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731094135.GA4104@infradead.org> <MWHPR04MB3758A4B2967DB1FABAAD9265E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731125110.GA11500@infradead.org> <CY4PR04MB37517D633920E4D31AC6EA0DE74B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200814081411.GA16943@infradead.org>
In-Reply-To: <20200814081411.GA16943@infradead.org>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Mon, 7 Sep 2020 12:31:42 +0530
Message-ID: <CA+1E3r+WXC_MK5Zf2OZEv17ddJDjtXbhpRFoeDns4F341xMhow@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] io_uring: add support for zone-append
To:     "hch@infradead.org" <hch@infradead.org>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Aug 14, 2020 at 1:44 PM hch@infradead.org <hch@infradead.org> wrote:
>
> On Wed, Aug 05, 2020 at 07:35:28AM +0000, Damien Le Moal wrote:
> > > the write pointer.  The only interesting addition is that we also want
> > > to report where we wrote.  So I'd rather have RWF_REPORT_OFFSET or so.
> >
> > That works for me. But that rules out having the same interface for raw block
> > devices since O_APPEND has no meaning in that case. So for raw block devices, it
> > will have to be through zonefs. That works for me, and I think it was your idea
> > all along. Can you confirm please ?
>
> Yes.  I don't think think raw syscall level access to the zone append
> primitive makes sense.  Either use zonefs for a file-like API, or
> use the NVMe pass through interface for 100% raw access.

But there are use-cases which benefit from supporting zone-append on
raw block-dev path.
Certain user-space log-structured/cow FS/DB will use the device that
way. Aerospike is one example.
Pass-through is synchronous, and we lose the ability to use io-uring.

For async uring/aio to block-dev, file-pointer will not be moved to
EoF, but that position was not very important anyway- as with this
interface we expect many async appends outstanding, all with
zone-start.
Do you think RWF_APPEND | RWF_REPORT_OFFSET_DIRECT/INDIRECT is too bad
for direct block-dev. Could you please suggest another way to go about
it?



--
Kanchan
