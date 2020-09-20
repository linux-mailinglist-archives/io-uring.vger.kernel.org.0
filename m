Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA3127178C
	for <lists+io-uring@lfdr.de>; Sun, 20 Sep 2020 21:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgITT2f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Sep 2020 15:28:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgITT2f (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sun, 20 Sep 2020 15:28:35 -0400
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D71372311D
        for <io-uring@vger.kernel.org>; Sun, 20 Sep 2020 19:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600630114;
        bh=MvoJlqBNzeGMhQj08qmauzE2jefx91WtS5O4xpiUc2w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JjkWdzs8l4VG7axJD8j1N7zsDNyHx01VvIoenQP0XrkbTc8PSIPFDC+ocOwK5vc2K
         RrxibNtkQ6Bu2l0c6FA8qAmsm6Zk+9gHRRr0jrtaswknN6/RVSUvSl9tUHIGyxATeV
         mD5rOKF8ZZ6lwaLYgtTds2laysQr8iIjXXnAGF54=
Received: by mail-wr1-f54.google.com with SMTP id c18so10566714wrm.9
        for <io-uring@vger.kernel.org>; Sun, 20 Sep 2020 12:28:33 -0700 (PDT)
X-Gm-Message-State: AOAM5310FR0Kjequq/jbp9HUb8YLPZo1qW7G0cucCUkGvyyo2Z6lsQDw
        VuO69ihj7gQcVpB7Ch3eu5yaYAQGV0aKHEjjf3zgMA==
X-Google-Smtp-Source: ABdhPJyGRJyXPIIAcXrNp8ibkDlg/u7fNSqAcKhSzeIjm5dJtxkt9PxOngbofryv0JcZUoQWH7pgaf1q3lhvPecaOZc=
X-Received: by 2002:a5d:6a47:: with SMTP id t7mr48111800wrw.75.1600630112287;
 Sun, 20 Sep 2020 12:28:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200918124533.3487701-1-hch@lst.de> <20200918124533.3487701-2-hch@lst.de>
 <20200920151510.GS32101@casper.infradead.org> <20200920180742.GN3421308@ZenIV.linux.org.uk>
 <20200920190159.GT32101@casper.infradead.org> <20200920191031.GQ3421308@ZenIV.linux.org.uk>
 <20200920192259.GU32101@casper.infradead.org>
In-Reply-To: <20200920192259.GU32101@casper.infradead.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sun, 20 Sep 2020 12:28:20 -0700
X-Gmail-Original-Message-ID: <CALCETrXVtBkxNJcMxf9myaKT9snHKbCWUenKHGRfp8AOtORBPg@mail.gmail.com>
Message-ID: <CALCETrXVtBkxNJcMxf9myaKT9snHKbCWUenKHGRfp8AOtORBPg@mail.gmail.com>
Subject: Re: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>, io-uring@vger.kernel.org,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Network Development <netdev@vger.kernel.org>,
        keyrings@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Sep 20, 2020 at 12:23 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Sun, Sep 20, 2020 at 08:10:31PM +0100, Al Viro wrote:
> > IMO it's much saner to mark those and refuse to touch them from io_uring...
>
> Simpler solution is to remove io_uring from the 32-bit syscall list.
> If you're a 32-bit process, you don't get to use io_uring.  Would
> any real users actually care about that?

We could go one step farther and declare that we're done adding *any*
new compat syscalls :)



-- 
Andy Lutomirski
AMA Capital Management, LLC
