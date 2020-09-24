Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A51277799
	for <lists+io-uring@lfdr.de>; Thu, 24 Sep 2020 19:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbgIXRT4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Sep 2020 13:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727216AbgIXRT4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Sep 2020 13:19:56 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E3EBC0613CE;
        Thu, 24 Sep 2020 10:19:56 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id s12so4661299wrw.11;
        Thu, 24 Sep 2020 10:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kAbZd3vS2mRaNP4IzKbD5ITPH51zcyuJzcimZuIDrHU=;
        b=qNlQD2VUwuZlfp3QTbChXLwkrg3TPs4FW/cPGjFxkYsyIdgolpsVHCzK+JtmhzuOVy
         pdi0dktqgCnXlIOv5hDbMPTnXdMBVdkZQoe7O2BW6Bbczk9+1s2DIwD9PrSuK6v+sEaF
         DI5dYuyUqGJB5Cqg0RJ5MGE9wp6SI2DQKTHm83cS8wjNJQ+D8i9i22W5Wc0KAEJPt/lI
         lMqIAU3dAoFQknurRyITwbWpD/XwQwQH7f+RMIfkHbp/eYOroyMTFqQ42nmLRTZ0AFEs
         ZImi//w1eD9Vr/kJD930rSvZA6+0qyZXWvUYBdxkM9YPx/4j22h5EaLNGpyTSrXMbCwO
         YKUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kAbZd3vS2mRaNP4IzKbD5ITPH51zcyuJzcimZuIDrHU=;
        b=V21uYvRbHZmmTSh3fWjo8BfbaL41yrIXH/LzNGG90j0d+TEjVPxei13O3cZ/CpZi+w
         dsQ5Rxqv8mfkZ3D/pKzhGpeonQs2ixAtmuCBguC+xWnAICRlXSDVEll/jQrmPgCJYruh
         KllSIWPU7j23jrqZi4AFt2/qZBce5bWkFU9a3e9ODDq1/ml3Fk0EI1QgXibidClGM8OI
         ncDnarO0V5INSytdvFJnjZ4G59CJnm48s5WRI3gvbqYIF7dbkiI5xB80SlFjVubtCGSU
         P9GYtyPCCG2iA5FhX7sSPkgXvlcTSlbcqbHQoXP3lT1DLMkkOzOkXMFH0cm0Akxu2jQv
         TrMw==
X-Gm-Message-State: AOAM530qgixWz+BMK83Ty3+x2kopAJJW9TEPB6zrRV56pBTp1V6WUU8e
        VJqic41txBqV6JiPJvkwadNM0DDkiCM0YaRmwXf1XTevHy6UDYEwhJE=
X-Google-Smtp-Source: ABdhPJxhIbv58SUHooN6WEjrkYW8U18ujKGcxnMYrWPH1bVWcmnQmjph4Yyi6hSpgSDoFyjg4oEh0yHOb+QZtev8xNw=
X-Received: by 2002:adf:dd51:: with SMTP id u17mr834011wrm.355.1600967994708;
 Thu, 24 Sep 2020 10:19:54 -0700 (PDT)
MIME-Version: 1.0
References: <CA+1E3rLM4G4SwzD6RWsK6Ssp7NmhiPedZDjrqN3kORQr9fxCtw@mail.gmail.com>
 <MWHPR04MB375863C20C1EF2CB27E62703E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731091416.GA29634@infradead.org> <MWHPR04MB37586D39CA389296CE0252A4E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731094135.GA4104@infradead.org> <MWHPR04MB3758A4B2967DB1FABAAD9265E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731125110.GA11500@infradead.org> <CY4PR04MB37517D633920E4D31AC6EA0DE74B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200814081411.GA16943@infradead.org> <CA+1E3r+WXC_MK5Zf2OZEv17ddJDjtXbhpRFoeDns4F341xMhow@mail.gmail.com>
 <20200908151801.GA16742@infradead.org>
In-Reply-To: <20200908151801.GA16742@infradead.org>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Thu, 24 Sep 2020 22:49:28 +0530
Message-ID: <CA+1E3r+MSEW=-SL8L+pquq+cFAu+nQOULQ+HZoQsCvdjKMkrNw@mail.gmail.com>
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
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Sep 8, 2020 at 8:48 PM hch@infradead.org <hch@infradead.org> wrote:
>
> On Mon, Sep 07, 2020 at 12:31:42PM +0530, Kanchan Joshi wrote:
> > But there are use-cases which benefit from supporting zone-append on
> > raw block-dev path.
> > Certain user-space log-structured/cow FS/DB will use the device that
> > way. Aerospike is one example.
> > Pass-through is synchronous, and we lose the ability to use io-uring.
>
> So use zonefs, which is designed exactly for that use case.

Not specific to zone-append, but in general it may not be good to lock
new features/interfaces to ZoneFS alone, given that direct-block
interface has its own merits.
Mapping one file to a one zone is good for some use-cases, but
limiting for others.
Some user-space FS/DBs would be more efficient (less meta, indirection)
with the freedom to decide file-to-zone mapping/placement.
- Rocksdb and those LSM style DBs would map SSTable to zone, but
SSTable file may be two small (initially) and may become too large
(after compaction) for a zone.
- The internal parallelism of a single zone is a design-choice, and
depends on the drive. Writing multiple zones parallely (striped/raid
way) can give better performance than writing on one. In that case one
would want to file that seamlessly combines multiple-zones in a
striped fashion.

Also it seems difficult (compared to block dev) to fit simple-copy TP
in ZoneFS. The new
command needs: one NVMe drive, list of source LBAs and one destination
LBA. In ZoneFS, we would deal with N+1 file-descriptors (N source zone
file, and one destination zone file) for that. While with block
interface, we do not need  more than one file-descriptor representing
the entire device. With more zone-files, we face open/close overhead too.

-- 
Joshi
