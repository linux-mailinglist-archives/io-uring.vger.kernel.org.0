Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF2D56E3C8D
	for <lists+io-uring@lfdr.de>; Mon, 17 Apr 2023 00:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjDPWHX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Apr 2023 18:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjDPWHW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Apr 2023 18:07:22 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31CF2133;
        Sun, 16 Apr 2023 15:07:19 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id E7085C01E; Mon, 17 Apr 2023 00:07:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1681682836; bh=xwB+nzBQW7d8TFoIztbHD75zt+9iiLx/9rkexbbWi80=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aR0/GeKZkEj80qvbNPgpHjKuZpudBE+0lJIURKv0KNQC+IzV9xJPxekEN/6UvlDpw
         lsvv/AAfiJemDgUDxMC5PMG8HqpjIEasaJ5d65UDf66jkMN2U4UNxlp6cGMRxoGELE
         fgiXyTKdDyUjoeTAabCIGWBJihvZapQtmQJ0vmJXW4TCN0ZIP42Tq0Iftm9+D6yegH
         W8QdqZqxy2KY8FrZwNSr3rOsSOjFa3Hths41R5YPKY+jYmPje0WgWQOy251Nd0iV7m
         QuzBM1XcNSuV2Fl2HTDaOJ94iWBOHtQSv5DrEc58nnbDV/4IYsLVVHhRFb50OwoX/c
         sOYC7k+SdPFHg==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id EDF64C01A;
        Mon, 17 Apr 2023 00:07:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1681682836; bh=xwB+nzBQW7d8TFoIztbHD75zt+9iiLx/9rkexbbWi80=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aR0/GeKZkEj80qvbNPgpHjKuZpudBE+0lJIURKv0KNQC+IzV9xJPxekEN/6UvlDpw
         lsvv/AAfiJemDgUDxMC5PMG8HqpjIEasaJ5d65UDf66jkMN2U4UNxlp6cGMRxoGELE
         fgiXyTKdDyUjoeTAabCIGWBJihvZapQtmQJ0vmJXW4TCN0ZIP42Tq0Iftm9+D6yegH
         W8QdqZqxy2KY8FrZwNSr3rOsSOjFa3Hths41R5YPKY+jYmPje0WgWQOy251Nd0iV7m
         QuzBM1XcNSuV2Fl2HTDaOJ94iWBOHtQSv5DrEc58nnbDV/4IYsLVVHhRFb50OwoX/c
         sOYC7k+SdPFHg==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 95555fd8;
        Sun, 16 Apr 2023 22:07:09 +0000 (UTC)
Date:   Mon, 17 Apr 2023 07:06:54 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        torvalds@linux-foundation.org, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v7 0/3] io_uring: add getdents64 support
Message-ID: <ZDxxfpADz6-T4-tS@codewreck.org>
References: <20211221164004.119663-1-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211221164004.119663-1-shr@fb.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Stefan Roesch wrote on Tue, Dec 21, 2021 at 08:40:01AM -0800:
> This series adds support for getdents64 in liburing. The intent is to
> provide a more complete I/O interface for io_uring.

[reminder: This series was dropped a year ago after Al Viro rightly
pointed out that we can't just pass an arbitrary offset to iterate_dir
as offset validation is costly and not always possible at all]

I'm digging an old topic here because I was looking at trying io_uring
on a toy project (specifically, exporting infos out of /sys/fs/cgroup
recursively), but was partly held back by the lack of getdents or
equivalent interface for the crawler part -- and existing bricks like
fts or nftw predate openat interfaces and just didn't appeal to me, but
in general just mixing in io_uring and synchronous getdents sounded a
bit of a pain.

Given it's been over a year I guess it's not such a much needed feature,
but when you're centering your program loop around the ring having the
occasional getdents/readdir call is a bit cumbersome.


This is probably a naive idea, but would it make sense discussing just
making it fit the current getdents API:
Given the problem seems to be revalidating the offset, since the main
usecase is probably to just go through a directory, perhaps the file's
offset could be updated just like the real call and offset validation be
skipped if the parameter is equal to the file's offset?
Giving a different offset would be equivalent to lseek + getdents and
update the position as well, so e.g. rewinding the directory with a seek
0 would work if an application needs to check a directory's content
multiple times.

Heck, seek to any offset other than 0 could just be refused for any sane
usage, it just doesn't make sense to use anything else in practice;
that'd make it a defacto "dumb getdents + rewinddir".
The API could be made simpler to use/clear about expectations by making
the last parameter "bool rewind_first" instead of an offset (or I guess
a flag with just a single valid bit if we were to really implement this)


This isn't very io_uring-like, but it'd allow for an io_uring-centric
program to also handle some directory processing, and wouldn't expose
anything that's not currently already possible to do (as long as each
processed op brings in its own context, the only "race" I can see in
iterate_dir is that file->f_pos can go back to a previously also valid
position if some iterations are faster than others, assuming it's an
atomic access, and that'd probably warrant a READ/WRITE_ONCE or
something.. but that's not a new problem, user threads can already
hammer getdents in parallel on a single fd if they want useless results)


What do you think?


I'm just asking with a toy in mind so it's not like I have any strong
opinion, but I'd be happy to rework Stefan's patches if it looks like it
might make sense.
(And if the consensus is that this will make hell break loose I'll just
forget about it before sinking more time in it, just catching up was fun
enough!)

Cheers,
-- 
Dominique Martinet | Asmadeus
