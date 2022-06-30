Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEBDD5613CE
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 09:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbiF3H4x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 03:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233227AbiF3H4w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 03:56:52 -0400
Received: from gw2.atmark-techno.com (gw2.atmark-techno.com [35.74.137.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9D35E403DA
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 00:56:51 -0700 (PDT)
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
        by gw2.atmark-techno.com (Postfix) with ESMTPS id E25F020D57
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 16:56:50 +0900 (JST)
Received: by mail-pf1-f198.google.com with SMTP id c77-20020a624e50000000b00525277a389bso7419849pfb.14
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 00:56:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F9tsQZpz4WXfPjbCLjHObeiUz+3sf+6cNHEEIAsk+90=;
        b=azzvNP+iYld0ktRotjztP+swIBcIQ1fHSpLS4zbGna3MCGqfM9kmJ+bM5T0dXtTsk8
         aucq0Y1TFR4NPh6NJDs9GC6hCO9+gSQ1YXH87TEub1OQ6ImNVfASCsAnmKF15fGaFtYL
         KDAMMdvFGYc6o2xXtoveS71R1JeDQYIqzYiDCyCOnA13HTj51USoUsVKjF/l/pZT00OR
         H+oRH1+eH6L/nSM69B1x8eytkblNjvyjn0gjZ1P72x8kGKOcULY8dclvXmPD79K/w13Q
         d3UauikiftmSFmz/jwHYBaHoW8dk2RqC3YQ+6aFky4CGJYLHi5o/5GsNlslVHFrwxovM
         V4UQ==
X-Gm-Message-State: AJIora+Teehqm/HKAFKGOddT447GwOsFlT91ygMHqU9rtA0fNwsHfJ6R
        BVGrzqEwQwKfQ9ZN8RKOJSuhJq+TNK0uBwV2PyNZaAI/cpjGDqzlJNr3anu2LeoLwY1Ma1gaZ3j
        tQ4NOdxGfIb27CRWi4bsQ
X-Received: by 2002:a05:6a00:b43:b0:525:2a02:8bdc with SMTP id p3-20020a056a000b4300b005252a028bdcmr13048103pfo.28.1656575809965;
        Thu, 30 Jun 2022 00:56:49 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u9TO3Nut4uWam12T1dirwyrKo9EzD2QIjRE5kZjH/GMiseR2RSj/EpQ6fNmXLD298a94jMzw==
X-Received: by 2002:a05:6a00:b43:b0:525:2a02:8bdc with SMTP id p3-20020a056a000b4300b005252a028bdcmr13048062pfo.28.1656575809393;
        Thu, 30 Jun 2022 00:56:49 -0700 (PDT)
Received: from pc-zest.atmarktech (103.131.189.35.bc.googleusercontent.com. [35.189.131.103])
        by smtp.gmail.com with ESMTPSA id t16-20020aa79390000000b0052521fd273fsm12835562pfe.218.2022.06.30.00.56.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jun 2022 00:56:48 -0700 (PDT)
Received: from martinet by pc-zest.atmarktech with local (Exim 4.95)
        (envelope-from <martinet@pc-zest>)
        id 1o6p2d-00BfJF-Ds;
        Thu, 30 Jun 2022 16:56:47 +0900
Date:   Thu, 30 Jun 2022 16:56:37 +0900
From:   Dominique MARTINET <dominique.martinet@atmark-techno.com>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     Nikolay Borisov <nborisov@suse.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: read corruption with qemu master io_uring engine / linux master
 / btrfs(?)
Message-ID: <Yr1XNe9V3UY/MkDz@atmark-techno.com>
References: <33cd0f9a-cdb1-1018-ebb0-89222cb1c759@kernel.dk>
 <bd342da1-8c98-eb78-59f1-e3cf537181e3@suse.com>
 <dd55e282-1147-08ae-6b9f-cf3ef672fce8@suse.com>
 <YrueYDXqppHZzOsy@atmark-techno.com>
 <Yrvfqh0eqN0J5T6V@atmark-techno.com>
 <20220629153710.GA379981@falcondesktop>
 <YrzxHbWCR6zhIAcx@atmark-techno.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YrzxHbWCR6zhIAcx@atmark-techno.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Dominique MARTINET wrote on Thu, Jun 30, 2022 at 09:41:01AM +0900:
> > I just tried your program, against the qemu/vmdk image you mentioned in the
> > first message, and after over an hour running I couldn't trigger any short
> > reads - this was on the integration misc-next branch.
> >
> > It's possible that to trigger the issue, one needs a particular file extent
> > layout, which will not be the same as yours after downloading and converting
> > the file.
> 
> Ugh. I've also been unable to reproduce on a test fs, despite filling it
> with small files and removing some to artificially fragment the image,
> so I guess I really do have something on these "normal" filesystems...
> 
> Is there a way to artificially try to recreate weird layouts?
> I've also tried btrfs send|receive, but while it did preserve reflinked
> extents it didn't seem to do the trick.

I take that one back, I was able to reproduce with my filesystem riddled
with holes.
I was just looking at another distantly related problem that happened
with cp, but trying with busybox cat didn't reproduce it and got
confused:
https://lore.kernel.org/linux-btrfs/Yr1QwVW+sHWlAqKj@atmark-techno.com/T/#u


Anyway, here's a pretty ugly reproducer to create a file that made short
reads on a brand new FS:

# 50GB FS -> fill with 50GB of small files and remove 1/10
$ mkdir /mnt/d.{00..50}
$ for i in {00000..49999}; do
	dd if=/dev/urandom of=/mnt/d.${i:0:2}/test.$i bs=1M count=1 status=none;
  done
$ rm -f /mnt/d.*/*2
$ btrfs subvolume create ~/sendme
$ cp --reflink=always bigfile ~/sendme/bigfile
$ btrfs property set ~/sendme ro true
$ btrfs send ~/sendme | btrfs receive /mnt/receive

and /mnt/receive/bigfile did the trick for me.
This probably didn't need the send/receive at all, I just didn't try
plain copy again.

Anyway, happy to test any patch as said earlier, it's probably not worth
spending too much time on trying to reproduce on your end at this
point...

-- 
Dominique
