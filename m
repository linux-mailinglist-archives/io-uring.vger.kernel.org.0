Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E86AD560E20
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 02:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbiF3AlQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jun 2022 20:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiF3AlQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jun 2022 20:41:16 -0400
Received: from gw2.atmark-techno.com (gw2.atmark-techno.com [35.74.137.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BAC4D3FBF7
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 17:41:14 -0700 (PDT)
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
        by gw2.atmark-techno.com (Postfix) with ESMTPS id 0714D20D5C
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 09:41:14 +0900 (JST)
Received: by mail-pg1-f197.google.com with SMTP id w191-20020a6382c8000000b0040c9dc669ccso8797665pgd.16
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 17:41:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uYYO3xLi/34pbj25fsC0XnESVSnvhv3I7XLqkZiAGSc=;
        b=BALVc6FKU1QDP1PMAn0I5q18x+zgFHsK6o8CG4COwqEJ5lnziXV4XzHkHebP0m+QuW
         KCB9BtewZOVgbndR9Gh/AQWg0sq1mcaxrwaUiBtyx01RiU3PqhgOpGLyDOVwevmj71yb
         iNHFLGC1pPjCRIAEs0nQfBArY1QQ6uRyQd0B14b7SduzqDLLEnwF+o5bZqI/y3uRzzFM
         OEI4JWRYMIC07dFT0QWeiIw6hzRCQJ6iipgnRz/PNay1UbOoiqOftwvppRnrWG6sJm0f
         jXlp3ERzR+swT3DiaEGUxRf0jbPb3xoUmozXAy+/V+FTFUaVVgzuETPUeGMwJnXPc6+q
         LdUw==
X-Gm-Message-State: AJIora80/AkU3Vq2lIw3L2MPfE9kD06RAsp+eQ+0OlocCYl/67Ge7UF4
        QXKe0Lw0u24b8chiuXytDPPbRCveLth+88ni6Rd4RKzzPoGGrv2PW+mYim7ouKp6QgsyyrP3/Xg
        /FIPI5FXI+GXa/zHQilvU
X-Received: by 2002:a65:5688:0:b0:3c2:1015:988e with SMTP id v8-20020a655688000000b003c21015988emr5141245pgs.280.1656549673575;
        Wed, 29 Jun 2022 17:41:13 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sRocIqlnLYZrVb9ZvwvwRE4CxFf7IEoRSQdugvU1QTuFoMnct0JPCWY6WTapdd0DXdvoq2uQ==
X-Received: by 2002:a65:5688:0:b0:3c2:1015:988e with SMTP id v8-20020a655688000000b003c21015988emr5141227pgs.280.1656549673184;
        Wed, 29 Jun 2022 17:41:13 -0700 (PDT)
Received: from pc-zest.atmarktech (35.112.198.104.bc.googleusercontent.com. [104.198.112.35])
        by smtp.gmail.com with ESMTPSA id p26-20020a634f5a000000b0040dfb0857a0sm6754719pgl.78.2022.06.29.17.41.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Jun 2022 17:41:12 -0700 (PDT)
Received: from martinet by pc-zest.atmarktech with local (Exim 4.95)
        (envelope-from <martinet@pc-zest>)
        id 1o6iF5-00AWBY-6P;
        Thu, 30 Jun 2022 09:41:11 +0900
Date:   Thu, 30 Jun 2022 09:41:01 +0900
From:   Dominique MARTINET <dominique.martinet@atmark-techno.com>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     Nikolay Borisov <nborisov@suse.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: read corruption with qemu master io_uring engine / linux master
 / btrfs(?)
Message-ID: <YrzxHbWCR6zhIAcx@atmark-techno.com>
References: <33cd0f9a-cdb1-1018-ebb0-89222cb1c759@kernel.dk>
 <bd342da1-8c98-eb78-59f1-e3cf537181e3@suse.com>
 <dd55e282-1147-08ae-6b9f-cf3ef672fce8@suse.com>
 <YrueYDXqppHZzOsy@atmark-techno.com>
 <Yrvfqh0eqN0J5T6V@atmark-techno.com>
 <20220629153710.GA379981@falcondesktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220629153710.GA379981@falcondesktop>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Filipe Manana wrote on Wed, Jun 29, 2022 at 04:37:10PM +0100:
> On Wed, Jun 29, 2022 at 02:14:18PM +0900, Dominique MARTINET wrote:
> >  - qemu short read handling was... rather disappointing.
> > Patch should appear here[1] eventually, but as it seems moderated?
> > [1] https://lore.kernel.org/qemu-devel/20220629044957.1998430-1-dominique.martinet@atmark-techno.com
> 
> Btw, the link doesn't work (at least at the moment):
> 
> "Message-ID <20220629044957.1998430-1-dominique.martinet@atmark-techno.com> not found"

Yes, the submitting a patch documentation[1] mentions the lists are
moderated, so it took a bit of time.
It looks like it went through now, and my understanding is further
mails won't be delayed -- but I'll Cc you on v2 after testing it.

[1] https://www.qemu.org/docs/master/devel/submitting-a-patch.html

> >  - comments there also say short reads should never happen on newer
> > kernels (assuming local filesystems?) -- how true is that? If we're
> > doing our best kernel side to avoid short reads I guess we probably
> > ought to have a look at this.
> 
> Short reads can happen, and an application should deal with it.

I definitely agree with this, qemu must be fixed. I don't think anyone
will argue with that.

> If we look at the man page for read(2):
> 
> "
>        On success, the number of bytes read is returned (zero indicates
>        end of file), and the file position is advanced by this number.
>        It is not an error if this number is smaller than the number of
>        bytes requested; this may happen for example because fewer bytes
>        are actually available right now (maybe because we were close to
>        end-of-file, or because we are reading from a pipe, or from a
>        terminal), or because read() was interrupted by a signal.  See
>        also NOTES.
> "
> 
> pread(2) refers to read(2)'s documention about short reads as well.
> I don't think reading with io_uring is an exception, I'm not aware of
> any rules that forbided short reads from happening (even if the offset
> and length don't cross the EOF boundary).

It might be documented, but I was laughed when I said we (9p) were
allowed to return short reads on a whim:

https://lkml.kernel.org/r/20200406164641.GF21484@bombadil.infradead.org

(now that might not be the proudest thing I've allowed for 9p, but it
shows there is some expectation we don't do short reads if we can avoid
it... But yes, that doesn't mean we shouldn't fix broken applications
when we find one)

> As mentioned in the commit pointed before, we recently had a similar
> report with MariaDB, which wasn't dealing with short reads properly
> and got fixed shortly after:
> 
> https://jira.mariadb.org/browse/MDEV-27900?focusedCommentId=216582&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-216582
> 
> In fact not dealing with short reads at all, is not that uncommon
> in applications. In that particular case we could avoid doing the
> short read in btrfs, by returning -EAGAIN and making io_uring use
> a blocking context to do a blocking direct IO read.

Sounds good to me.

> > It can easily be reproduced with a simple io_uring program -- see
> > example attached that eventually fails with the following error on
> > btrfs:
> > bad read result for io 8, offset 792227840: 266240 should be 1466368
> > 
> > but doesn't fail on tmpfs or without O_DIRECT.
> > feel free to butcher it, it's already a quickly hacked downversion of my
> > original test that had hash computation etc so the flow might feel a bit
> > weird.
> > Just compile with `gcc -o shortreads uring_shortreads.c -luring` and run
> > with file to read in argument.
> 
> I just tried your program, against the qemu/vmdk image you mentioned in the
> first message, and after over an hour running I couldn't trigger any short
> reads - this was on the integration misc-next branch.
>
> It's possible that to trigger the issue, one needs a particular file extent
> layout, which will not be the same as yours after downloading and converting
> the file.

Ugh. I've also been unable to reproduce on a test fs, despite filling it
with small files and removing some to artificially fragment the image,
so I guess I really do have something on these "normal" filesystems...

Is there a way to artificially try to recreate weird layouts?
I've also tried btrfs send|receive, but while it did preserve reflinked
extents it didn't seem to do the trick.


> Are you able to apply kernel patches and test? If so I may provide you with
> a patch to try and see if it fixes the problem for you.

Yes, no problem with that; I'm not deleting that file until we've seen
the end of it and will be happy to test anything :)

-- 
Dominique
