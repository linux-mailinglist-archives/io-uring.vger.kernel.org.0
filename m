Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4A47567A68
	for <lists+io-uring@lfdr.de>; Wed,  6 Jul 2022 00:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiGEWxN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jul 2022 18:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiGEWxK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jul 2022 18:53:10 -0400
Received: from gw2.atmark-techno.com (gw2.atmark-techno.com [35.74.137.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0745F337
        for <io-uring@vger.kernel.org>; Tue,  5 Jul 2022 15:53:08 -0700 (PDT)
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
        by gw2.atmark-techno.com (Postfix) with ESMTPS id 28F6920CF3
        for <io-uring@vger.kernel.org>; Wed,  6 Jul 2022 07:53:08 +0900 (JST)
Received: by mail-pj1-f72.google.com with SMTP id u13-20020a17090a4bcd00b001eefd8fa171so8034736pjl.2
        for <io-uring@vger.kernel.org>; Tue, 05 Jul 2022 15:53:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tFRngjx0G+BZ60t1jmhrF4wtc8rPFWnQu2MVKcY0EpQ=;
        b=70hsJLOjfCAMwfurCQwF/XjOP4J8FMVyLyRTfKHcBPNJim/PsVWm5VLQ3gLPAa6a8j
         cuFRR9E74XANVouSXpwYl/1QHCjd91OOm0cOl0K8hZ7197hqAc2HocRuhhOg5mfQvOn2
         d0mrfMk/j6wgb0gU7PXVohewqOfJMwW8Lrp1LZ9QcGUcQUwEkynY2EkYEyLDSWWBwUBB
         Qrj6JcJcT7PcQ9vIrZL7rWjSk38tpE4TNJ8Y35fLHire5fR02ID+MU67ws4hE7Ul/eJX
         Kcs+qMioM9bMjciPfYiylY1AI9Rlcel0v+T1wE2kjBfMrBkn9NwITQsT3sG2qsvh99TE
         rmzA==
X-Gm-Message-State: AJIora+2K/p6Mun25omkmn0+9YLQSIoR7CAJdMGaf8Qc/RVauZObKn4r
        p28vIOIJEfEd7Tns/8tGeuzSJTwbWM5atLh5P/YdsEvRFJO1cqiQjUFrZE+NlCGTUyI6O3eNNOg
        Av0+28+cjwKCa6l53g5v8
X-Received: by 2002:a17:902:d48a:b0:16b:f0be:4e15 with SMTP id c10-20020a170902d48a00b0016bf0be4e15mr6319005plg.155.1657061587213;
        Tue, 05 Jul 2022 15:53:07 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v2HoMVKLOO/ikgjMgiFEEWpkCT3RdVr6ejaBU1aeirFrwWCEHisk1J+5k1+ZgwhoPkseEeKA==
X-Received: by 2002:a17:902:d48a:b0:16b:f0be:4e15 with SMTP id c10-20020a170902d48a00b0016bf0be4e15mr6318970plg.155.1657061586839;
        Tue, 05 Jul 2022 15:53:06 -0700 (PDT)
Received: from pc-zest.atmarktech (145.82.198.104.bc.googleusercontent.com. [104.198.82.145])
        by smtp.gmail.com with ESMTPSA id x2-20020a170902b40200b001675d843332sm23797882plr.63.2022.07.05.15.53.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Jul 2022 15:53:06 -0700 (PDT)
Received: from martinet by pc-zest.atmarktech with local (Exim 4.95)
        (envelope-from <martinet@pc-zest>)
        id 1o8rPk-004lid-U7;
        Wed, 06 Jul 2022 07:53:04 +0900
Date:   Wed, 6 Jul 2022 07:52:54 +0900
From:   Dominique Martinet <dominique.martinet@atmark-techno.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Aarushi Mehta <mehta.aaru20@gmail.com>,
        Julia Suvorova <jusual@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        qemu-block@nongnu.org, qemu-devel@nongnu.org,
        Filipe Manana <fdmanana@kernel.org>, io-uring@vger.kernel.org
Subject: Re: [PATCH v2] io_uring: fix short read slow path
Message-ID: <YsTAxtvpvIIi8q7M@atmark-techno.com>
References: <20220629044957.1998430-1-dominique.martinet@atmark-techno.com>
 <20220630010137.2518851-1-dominique.martinet@atmark-techno.com>
 <20220630154921.ekl45dzer6x4mkvi@sgarzare-redhat>
 <Yr4pLwz5vQJhmvki@atmark-techno.com>
 <YsQ8aM3/ZT+Bs7nC@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YsQ8aM3/ZT+Bs7nC@stefanha-x1.localdomain>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Stefan Hajnoczi wrote on Tue, Jul 05, 2022 at 02:28:08PM +0100:
> > The older kernel I have installed right now is 5.16 and that can
> > reproduce it --  I'll give my laptop some work over the weekend to test
> > still maintained stable branches if that's useful.
> 
> Linux 5.16 contains commit 9d93a3f5a0c ("io_uring: punt short reads to
> async context"). The comment above QEMU's luring_resubmit_short_read()
> claims that short reads are a bug that was fixed by Linux commit
> 9d93a3f5a0c.
> 
> If the comment is inaccurate it needs to be fixed. Maybe short writes
> need to be handled too.
> 
> I have CCed Jens and the io_uring mailing list to clarify:
> 1. Are short IORING_OP_READV reads possible on files/block devices?
> 2. Are short IORING_OP_WRITEV writes possible on files/block devices?

Jens replied before me, so I won't be adding much (I agree with his
reply -- linux tries hard to avoid short reads but we should assume they
can happen)

In this particular case it was another btrfs bug with O_DIRECT and mixed
compression in a file, that's been fixed by this patch:
https://lore.kernel.org/all/20220630151038.GA459423@falcondesktop/

queued here:
https://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git/commit/?h=dio_fixes&id=b3864441547e49a69d45c7771aa8cc5e595d18fc

It should be backported to 5.10, but the problem will likely persist in
5.4 kernels if anyone runs on that as the code changed enough to make
backporting non-trivial.


So, WRT that comment, we probably should remove the reference to that
commit and leave in that they should be very rare but we need to handle
them anyway.


For writes in particular, I haven't seen any and looking at the code
qemu would blow up that storage (IO treated as ENOSPC would likely mark
disk read-only?)
It might make sense to add some warning message that it's what happened
so it'll be obvious what needs doing in case anyone falls on that but I
think the status-quo is good enough here.

-- 
Dominique
