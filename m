Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5A64109A5
	for <lists+io-uring@lfdr.de>; Sun, 19 Sep 2021 06:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhISEZU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Sep 2021 00:25:20 -0400
Received: from shells.gnugeneration.com ([66.240.222.126]:35712 "EHLO
        shells.gnugeneration.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhISEZT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Sep 2021 00:25:19 -0400
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Sep 2021 00:25:19 EDT
Received: by shells.gnugeneration.com (Postfix, from userid 1000)
        id CE0BC1A545A2; Sat, 18 Sep 2021 21:15:46 -0700 (PDT)
Date:   Sat, 18 Sep 2021 21:15:46 -0700
From:   Vito Caputo <vcaputo@pengaru.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Subject: Re: [BUG? liburing] io_uring_register_files_update with liburing 2.0
 on 5.13.17
Message-ID: <20210919041546.bbs5u45pyythmwvj@shells.gnugeneration.com>
References: <CAM1kxwjCjo9u5AwAn0UANCWkahkUYz8PwHkWgF0U83ue=KbfTA@mail.gmail.com>
 <a1010b67-d636-9672-7a21-44f7c4376916@kernel.dk>
 <CAM1kxwj2Chak===QoOzNBAUMhymyXM3T6o_zwPdwqN7MzQ25zw@mail.gmail.com>
 <c0de93f7-abf4-d2f9-f64d-376a9c987ac0@kernel.dk>
 <7bfd2fdd-15ba-98e3-7acc-cecf2a42e157@kernel.dk>
 <CAM1kxwi6EMGZeNW_imNZq4jMkJ3NeuDdkeGBkRMKpwJPQ8Rxmw@mail.gmail.com>
 <36866fef-a38f-9d7d-0c85-b4c37a8279ce@kernel.dk>
 <CAM1kxwgA7BtaPYhkeHFnqrgLHs31LrOCiXcMEiO9Y8GU22KNfQ@mail.gmail.com>
 <d0cbd186-b721-c7ca-f304-430e272a78f4@kernel.dk>
 <3df95a9f-7a5a-14bd-13e4-cef8a3f58dbd@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3df95a9f-7a5a-14bd-13e4-cef8a3f58dbd@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Sep 18, 2021 at 05:40:51PM -0600, Jens Axboe wrote:
> On 9/18/21 5:37 PM, Jens Axboe wrote:
> >> and it failed with the same as before...
> >>
> >> io_uring_register(13, IORING_REGISTER_FILES, [-1, -1, -1, 3, 4, 5, 6, 7, 8,
> >> 9, 10, 11, 12, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
> >> -1, -1, -1, -1,
> >> -1, ...], 32768) = -1 EMFILE (Too many open files)
> >>
> >> if you want i can debug it for you tomorrow? (in london)
> > 
> > Nah that's fine, I think it's just because you have other files opened
> > too. We bump the cur limit _to_ 'nr', but that leaves no room for anyone
> > else. Would be my guess. It works fine for the test case I ran here, but
> > your case may be different. Does it work if you just make it:
> > 
> > rlim.rlim_cur += nr;
> > 
> > instead?
> 
> Specifically, just something like the below incremental. If rlim_cur
> _seems_ big enough, leave it alone. If not, add the amount we need to
> cur. And don't do any error checking here, let's leave failure to the
> kernel.
> 
> diff --git a/src/register.c b/src/register.c
> index bab42d0..7597ec1 100644
> --- a/src/register.c
> +++ b/src/register.c
> @@ -126,9 +126,7 @@ static int bump_rlimit_nofile(unsigned nr)
>  	if (getrlimit(RLIMIT_NOFILE, &rlim) < 0)
>  		return -errno;
>  	if (rlim.rlim_cur < nr) {
> -		if (nr > rlim.rlim_max)
> -			return -EMFILE;
> -		rlim.rlim_cur = nr;
> +		rlim.rlim_cur += nr;
>  		setrlimit(RLIMIT_NOFILE, &rlim);
>  	}
>  
> 

Perhaps it makes more sense to only incur the getrlimit() cost on the
errno=EMFILE path?  As in bump the ulimit and retry the operation on
failure, but when things are OK don't do any of this.

Regards,
Vito Caputo
