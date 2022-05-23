Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A30B530E55
	for <lists+io-uring@lfdr.de>; Mon, 23 May 2022 12:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbiEWKlv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 May 2022 06:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234149AbiEWKlt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 May 2022 06:41:49 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 107D523BC4;
        Mon, 23 May 2022 03:41:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 20E4110E6A09;
        Mon, 23 May 2022 20:41:45 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nt5VQ-00FOzV-BQ; Mon, 23 May 2022 20:41:44 +1000
Date:   Mon, 23 May 2022 20:41:44 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christian Brauner <brauner@kernel.org>,
        Zorro Lang <zlang@redhat.com>,
        fstests <fstests@vger.kernel.org>,
        Eryu Guan <guaneryu@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>, io-uring@vger.kernel.org
Subject: Re: [PATCH v2 00/13] rename & split tests
Message-ID: <20220523104144.GD2306852@dread.disaster.area>
References: <20220512165250.450989-1-brauner@kernel.org>
 <20220521231350.GY2306852@dread.disaster.area>
 <f77e867f-ed7d-85f7-f1e4-b9dc10a6d23b@kernel.dk>
 <84e5e231-7c33-ad0f-fdd5-2d8c1052aa00@kernel.dk>
 <20220523001350.GB2306852@dread.disaster.area>
 <767778c5-ac0e-e798-38e0-199f54853cc6@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <767778c5-ac0e-e798-38e0-199f54853cc6@kernel.dk>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=628b64ea
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
        a=xVhDTqbCAAAA:8 a=7-415B0cAAAA:8 a=RA3iI1Ha_bHnXKmN0oAA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=GrmWmAYt4dzCMttCBZOh:22
        a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, May 22, 2022 at 06:57:04PM -0600, Jens Axboe wrote:
> On 5/22/22 6:13 PM, Dave Chinner wrote:
> > On Sat, May 21, 2022 at 08:19:51PM -0600, Jens Axboe wrote:
> >> On 5/21/22 7:07 PM, Jens Axboe wrote:
> >>> On 5/21/22 5:13 PM, Dave Chinner wrote:
> >>>> [cc io_uring]
> >>>>
> >>>> On Thu, May 12, 2022 at 06:52:37PM +0200, Christian Brauner wrote:
> >>>>> From: "Christian Brauner (Microsoft)" <brauner@kernel.org>
> >>>>>
> >>>>> Hey everyone,
> >>>>>
> >>>>> Please note that this patch series contains patches that will be
> >>>>> rejected by the fstests mailing list because of the amount of changes
> >>>>> they contain. So tools like b4 will not be able to find the whole patch
> >>>>> series on a mailing list. In case it's helpful I've added the
> >>>>> "fstests.vfstest.for-next" tag which can be pulled. Otherwise it's
> >>>>> possible to simply use the patch series as it appears in your inbox.
> >>>>>
> >>>>> All vfstests pass:
> >>>>
> >>>> [...]
> >>>>
> >>>>> #### xfs ####
> >>>>> ubuntu@imp1-vm:~/src/git/xfstests$ sudo ./check -g idmapped
> >>>>> FSTYP         -- xfs (debug)
> >>>>> PLATFORM      -- Linux/x86_64 imp1-vm 5.18.0-rc4-fs-mnt-hold-writers-8a2e2350494f #107 SMP PREEMPT_DYNAMIC Mon May 9 12:12:34 UTC 2022
> >>>>> MKFS_OPTIONS  -- -f /dev/sda4
> >>>>> MOUNT_OPTIONS -- /dev/sda4 /mnt/scratch
> >>>>>
> >>>>> generic/633 58s ...  58s
> >>>>> generic/644 62s ...  60s
> >>>>> generic/645 161s ...  161s
> >>>>> generic/656 62s ...  63s
> >>>>> xfs/152 133s ...  133s
> >>>>> xfs/153 94s ...  92s
> >>>>> Ran: generic/633 generic/644 generic/645 generic/656 xfs/152 xfs/153
> >>>>> Passed all 6 tests
> >>>>
> >>>> I'm not sure if it's this series that has introduced a test bug or
> >>>> triggered a latent issue in the kernel, but I've started seeing
> >>>> generic/633 throw audit subsystem warnings on a single test machine
> >>>> as of late Friday:
> >>>>
> >>>> [ 7285.015888] WARNING: CPU: 3 PID: 2147118 at kernel/auditsc.c:2035 __audit_syscall_entry+0x113/0x140
> >>>
> >>> Does your kernel have this commit?
> >>>
> >>> commit 69e9cd66ae1392437234a63a3a1d60b6655f92ef
> >>> Author: Julian Orth <ju.orth@gmail.com>
> >>> Date:   Tue May 17 12:32:53 2022 +0200
> >>>
> >>>     audit,io_uring,io-wq: call __audit_uring_exit for dummy contexts
> > 
> > No, that wasn't in -rc7.
> > 
> >> I could not reproduce either with or without your patch when I finally
> >> got that test going and figure out how to turn on audit and get it
> >> enabled. I don't run with that.
> > 
> > Ok. Given that this has been broken for over a year and nobody
> > has noticed until late .18-rcX, it might be worth adding an audit
> > enabled VM to your io-uring test farm....
> 
> It was in the 5.16 release, so it's ~4 months ago. Don't disagree on the

Huh. The commit that it fixes is dated Feb 2021:

commit 5bd2182d58e9d9c6279b7a8a2f9b41add0e7f9cb
Author: Paul Moore <paul@paul-moore.com>
Date:   Tue Feb 16 19:46:48 2021 -0500

    audit,io_uring,io-wq: add some basic audit support to io_uring

I guess it must have sat in a tree somewhere for 6 months before
before being merged.

> testing, though I do think that's mostly on the audit side. I had no
> hand in any of that code.

Fair enough.

> From my experience trying to reproduce it yesterday, my test distros
> don't even enable it and you have to both fiddle the config and add a
> boot parameter to even turn it on. And then it still didn't trigger for
> me.

I have machines with audit enabled as it seems to be the debian
default these days. I haven't explicitly turned it on - it's just
there. I guess it came along with selinux being enabled on these
test VMs - I have "selinux=1 security=selinux" on the kernel CLI for
these VMs.

Apart from that, I have no clue as to why this one particular
VM tripped this and none of the others with similar selinux/audit
configs have had any problems...

> I'll see if I can add something to the testing mix for this.

Thanks!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
