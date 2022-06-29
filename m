Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 167DD55F275
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 02:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiF2AgA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 20:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiF2Af7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 20:35:59 -0400
Received: from gw2.atmark-techno.com (gw2.atmark-techno.com [35.74.137.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E1AA2FFDD
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 17:35:58 -0700 (PDT)
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
        by gw2.atmark-techno.com (Postfix) with ESMTPS id C61A920D6D
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 09:35:57 +0900 (JST)
Received: by mail-pj1-f70.google.com with SMTP id ie11-20020a17090b400b00b001eccac2af53so8810881pjb.9
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 17:35:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:in-reply-to;
        bh=sg/FIMb0Y22XOeDUVyJPVEEncgDb3cHZBiniEEmzce0=;
        b=hyYfw+LSmrzAkuiAZa17558cm4uzw+xX04aJQSnnj2SZjhI0rVmghLQYNdgQvppr0P
         MPlYj59Ns24rxVRvgzJ/KcAZtqi1fkBNQr5R2GvAfvTltLR/8IvL6h0RC6ZDwIb36EoS
         R4TmHsB0pMsVekZ8x/Os75vY8ve9N8KpdV1EsJL7Oyksxd+JEMpbu3Fw1o1SW/JtJKdP
         MKLVoMvbNAThaKCyQrubISx4zHewjI+Vql/sMi7cosw1XQO0v+5dtounX/atNDQYUn2U
         Qclf3kctrRopMi8yYE2z561uQmd5kiuIWrwYg0Od5HrIV9mWEUMfdxR0vxSCDnMzhqUP
         vyjg==
X-Gm-Message-State: AJIora87Eedy0shl7tpRAw6Se7Py4MTEDtws8nYyegBehFbsyyhfH7V1
        hOmxDxEmcjjtl2GxCP87kFUby9xKLMFpZV6VLv2WZgXJTnGmD3kKCKM1sUBm3D243z364eADiY9
        FTWhjs4xLnX5YRqZQzfix
X-Received: by 2002:a17:903:41cd:b0:16b:880a:8757 with SMTP id u13-20020a17090341cd00b0016b880a8757mr6398832ple.93.1656462956879;
        Tue, 28 Jun 2022 17:35:56 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vCGtD4SY7W6GWH0/Kvp3LVt2NcY4okLANBHyVAh9pXB99m07Os1CgwttUHJ0gmPk+RIDarEA==
X-Received: by 2002:a17:903:41cd:b0:16b:880a:8757 with SMTP id u13-20020a17090341cd00b0016b880a8757mr6398820ple.93.1656462956611;
        Tue, 28 Jun 2022 17:35:56 -0700 (PDT)
Received: from pc-zest.atmarktech (76.125.194.35.bc.googleusercontent.com. [35.194.125.76])
        by smtp.gmail.com with ESMTPSA id a4-20020a62bd04000000b00525714c3e07sm10006096pff.48.2022.06.28.17.35.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jun 2022 17:35:56 -0700 (PDT)
Received: from martinet by pc-zest.atmarktech with local (Exim 4.95)
        (envelope-from <martinet@pc-zest>)
        id 1o6LgQ-007pyp-TN;
        Wed, 29 Jun 2022 09:35:54 +0900
Date:   Wed, 29 Jun 2022 09:35:44 +0900
From:   Dominique MARTINET <dominique.martinet@atmark-techno.com>
To:     Nikolay Borisov <nborisov@suse.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: read corruption with qemu master io_uring engine / linux master
 / btrfs(?)
Message-ID: <YrueYDXqppHZzOsy@atmark-techno.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <33cd0f9a-cdb1-1018-ebb0-89222cb1c759@kernel.dk>
 <bd342da1-8c98-eb78-59f1-e3cf537181e3@suse.com>
 <dd55e282-1147-08ae-6b9f-cf3ef672fce8@suse.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Thanks for the replies.

Nikolay Borisov wrote on Tue, Jun 28, 2022 at 10:03:20PM +0300:
> >    qemu-system-x86_64 -drive file=qemu/atde-test,if=none,id=hd0,format=raw,cache=none,aio=io_uring \
> >        -device virtio-blk-pci,drive=hd0 -m 8G -smp 4 -serial mon:stdio -enable-kvm
> 
> So cache=none means O_DIRECT and using io_uring. This really sounds similar
> to:
> 
> ca93e44bfb5fd7996b76f0f544999171f647f93b

That looks close, yes...

> This commit got merged into v5.17 so you shouldn't be seeing it on 5.17 and
> onwards.
> 
> <snip>
> 
> > 
> > Perhaps at this point it might be simpler to just try to take qemu out
> > of the equation and issue many parallel reads to different offsets
> > (overlapping?) of a large file in a similar way qemu io_uring engine
> > does and check their contents?
> 
> Care to run the sample program in the aforementioned commit and verify it's
> not failing

But unfortunately it seems like it is properly fixed on my machines:
---
io_uring read result for file foo:

  cqe->res == 8192 (expected 8192)
  memcmp(read_buf, write_buf) == 0 (expected 0)
---

Nikolay Borisov wrote on Tue, Jun 28, 2022 at 10:05:39PM +0300:
> Alternatively change cache=none (O_DIRECT) to cache=writeback (ordinary
> buffered writeback path) that way we'll know if it's related to the
> iomap-based O_DIRECT code in btrfs.

Good idea; I can confirm this doesn't reproduce without cache=none, so
O_DIRECT probably is another requirement here (probably because I
haven't been able to reproduce on a freshly created fs either, so not
being able to reproducing in a few tries is no guarantee...)


Jens Axboe wrote on Tue, Jun 28, 2022 at 01:12:54PM -0600:
> Not sure what's going on here, but I use qemu with io_uring many times
> each day and haven't seen anything odd. This is on ext4 and xfs however,
> I haven't used btrfs as the backing file system. I wonder if we can boil
> this down into a test case and try and figure out what is doing on here.

Yes I'd say it's fs specific, I've not been able to reproduce on ext4 or
xfs -- but then again I couldn't reproduce with btrfs on a new
filesystem so there probably are some other conditions :/

I also agree writing a simple program like the io_uring test in the
above commit that'd sort of do it like qemu and compare contents would
be ideal.
I'll have a stab at this today.

-- 
Dominique
