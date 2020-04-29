Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95BBB1BE90F
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2020 22:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgD2UsR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Apr 2020 16:48:17 -0400
Received: from static-213-198-238-194.adsl.eunet.rs ([213.198.238.194]:44064
        "EHLO fx.arvanta.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726511AbgD2UsR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Apr 2020 16:48:17 -0400
Received: from arya.arvanta.net (arya.arvanta.net [10.5.1.6])
        by fx.arvanta.net (Postfix) with ESMTP id 54E253801;
        Wed, 29 Apr 2020 22:48:16 +0200 (CEST)
Date:   Wed, 29 Apr 2020 22:48:16 +0200
From:   Milan =?utf-8?Q?P=2E_Stani=C4=87?= <mps@arvanta.net>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>, io-uring@vger.kernel.org
Subject: Re: Build 0.6 version fail on musl libc
Message-ID: <20200429204816.GA26371@arya.arvanta.net>
References: <04edfda7-0443-62e1-81af-30aa820cf256@kernel.dk>
 <20200429152646.GA17156@infradead.org>
 <e640dbcc-b25d-d305-ac97-a4724bd958e2@kernel.dk>
 <6528f839-274d-9d46-dea6-b20a90ac8cf8@kernel.dk>
 <20200429193315.GA31807@arya.arvanta.net>
 <4f9df512-75a6-e4ca-4f06-21857ac44afb@kernel.dk>
 <20200429200158.GA3515@arya.arvanta.net>
 <962a1063-7986-fba9-f64e-05f6770763bc@kernel.dk>
 <20200429203844.GA25859@arya.arvanta.net>
 <bcfe40db-ebcd-df5c-ca18-4a867c9d1e1e@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bcfe40db-ebcd-df5c-ca18-4a867c9d1e1e@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 2020-04-29 at 14:43, Jens Axboe wrote:
> On 4/29/20 2:38 PM, Milan P. Stanić wrote:
> > On Wed, 2020-04-29 at 14:08, Jens Axboe wrote:
> >> On 4/29/20 2:01 PM, Milan P. Stanić wrote:
> >>> On Wed, 2020-04-29 at 13:38, Jens Axboe wrote:
> >>>> On 4/29/20 1:33 PM, Milan P. Stanić wrote:
> >>>>> On Wed, 2020-04-29 at 10:14, Jens Axboe wrote:
> >>>>>> On 4/29/20 9:29 AM, Jens Axboe wrote:
> >>>>>>> On 4/29/20 9:26 AM, Christoph Hellwig wrote:
> >>>>>>>> On Wed, Apr 29, 2020 at 09:24:40AM -0600, Jens Axboe wrote:
> >>>>>>>>>
> >>>>>>>>> Not sure what the best fix is there, for 32-bit, your change will truncate
> >>>>>>>>> the offset to 32-bit as off_t is only 4 bytes there. At least that's the
> >>>>>>>>> case for me, maybe musl is different if it just has a nasty define for
> >>>>>>>>> them.
> >>>>>>>>>
> >>>>>>>>> Maybe best to just make them uint64_t or something like that.
> >>>>>>>>
> >>>>>>>> The proper LFS type would be off64_t.
> >>>>>>>
> >>>>>>> Is it available anywhere? Because I don't have it.
> >>>>>>
> >>>>>> There seems to be better luck with __off64_t, but I don't even know
> >>>>>> how widespread that is... Going to give it a go, we'll see.
> >>>>>
> >>>>> AFAIK, __off64_t is glibc specific, defined in /usr/include/fcntl.h:
> >>>>> ------
> >>>>> # ifndef __USE_FILE_OFFSET64
> >>>>> typedef __off_t off_t;
> >>>>> # else
> >>>>> typedef __off64_t off_t;
> >>>>> # endif
> >>>>> ------
> >>>>>
> >>>>> So, this will not work on musl based Linux system, git commit id
> >>>>> b5096098c62adb19dbf4a39b480909766c9026e7 should be reverted. But you
> >>>>> know better what to do.
> >>>>>
> >>>>> I come with another quick and dirty patch attached to this mail but
> >>>>> again  I think it is not proper solution, just playing to find (maybe)
> >>>>> 'good enough' workaround.
> >>>>
> >>>> Let's just use uint64_t.
> >>>
> >>> This works. Thanks.
> >>>
> >>> Next issue is this:
> >>> ----
> >>> make[1]: Entering directory '/work/devel/liburing/src'
> >>>      CC setup.ol
> >>>      CC queue.ol
> >>>      CC syscall.ol
> >>> In file included from syscall.c:9:
> >>> include/liburing/compat.h:6:2: error: unknown type name 'int64_t'
> >>>     6 |  int64_t  tv_sec;
> >>>       |  ^~~~~~~
> >>> make[1]: *** [Makefile:43: syscall.ol] Error 1
> >>> make[1]: Leaving directory '/work/devel/liburing/src'
> >>> make: *** [Makefile:12: all] Error 2
> >>> ----
> >>>
> >>> I fixed it with this patch:
> >>> --
> >>> diff --git a/configure b/configure
> >>> index 30b0a5a..4b44177 100755
> >>> --- a/configure
> >>> +++ b/configure
> >>> @@ -301,6 +301,7 @@ EOF
> >>>  fi
> >>>  if test "$__kernel_timespec" != "yes"; then
> >>>  cat >> $compat_h << EOF
> >>> +#include <stdint.h>
> >>>  struct __kernel_timespec {
> >>>   int64_t   tv_sec;
> >>>   long long tv_nsec;
> >>> --
> >>>
> >>> but not sure will that work on glibc.
> >>
> >> That should work fine on glibc. Care to send as an actual
> >> patch, with commit message and signed-off-by? Then I'll add
> >> it to liburing.
> > 
> > patch is attached.
> 
> Great thanks, I added a bit to your commit message. Here it is:
> 
> https://git.kernel.dk/cgit/liburing/commit/?id=8171778c835b6be517c314cf23dd1f5ae061a117

Nice. I'm bad in writing commit messages. Thanks
 
-- 
regards
