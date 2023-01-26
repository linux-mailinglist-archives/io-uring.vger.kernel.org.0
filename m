Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE3067CB63
	for <lists+io-uring@lfdr.de>; Thu, 26 Jan 2023 13:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235812AbjAZMzt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 Jan 2023 07:55:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbjAZMzs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 Jan 2023 07:55:48 -0500
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EA22D65340;
        Thu, 26 Jan 2023 04:54:58 -0800 (PST)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 30QCsXqS006038;
        Thu, 26 Jan 2023 13:54:33 +0100
Date:   Thu, 26 Jan 2023 13:54:33 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        nbd@other.debian.org
Subject: Re: ublk-nbd: ublk-nbd is avaialbe
Message-ID: <20230126125433.GA4368@1wt.eu>
References: <Y8lSYBU9q5fjs7jS@T590>
 <4f22f15f-c15f-5fba-1569-3da8c0f37f0e@kernel.dk>
 <Y9Huqg9HeU3+Ki1H@T590>
 <20230126040822.GA2858@1wt.eu>
 <Y9JnBDrm0V1ZdWK6@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y9JnBDrm0V1ZdWK6@T590>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jan 26, 2023 at 07:41:56PM +0800, Ming Lei wrote:
> On Thu, Jan 26, 2023 at 05:08:22AM +0100, Willy Tarreau wrote:
> > Hi,
> > 
> > On Thu, Jan 26, 2023 at 11:08:26AM +0800, Ming Lei wrote:
> > > Hi Jens,
> > > 
> > > On Thu, Jan 19, 2023 at 11:49:04AM -0700, Jens Axboe wrote:
> > > > On 1/19/23 7:23 AM, Ming Lei wrote:
> > > > > Hi,
> > > > > 
> > > > > ublk-nbd[1] is available now.
> > > > > 
> > > > > Basically it is one nbd client, but totally implemented in userspace,
> > > > > and wrt. current nbd-client in [2], the transmission phase is done
> > > > > by linux block nbd driver.
> > > > > 
> > > > > The handshake implementation is borrowed from nbd project[2], so
> > > > > basically ublk-nbd just adds new code for implementing transmission
> > > > > phase, and it can be thought as moving linux block nbd driver into
> > > > > userspace.
> > > > > 
> > > > > The added new code is basically in nbd/tgt_nbd.cpp, and io handling
> > > > > is based on liburing[3], and implemented by c++20 coroutine, so
> > > > > everything is done in single pthread totally lockless, meantime turns
> > > > > out it is pretty easy to design & implement, attributed to ublk framework,
> > > > > c++20 coroutine and liburing.
> > > > > 
> > > > > ublk-nbd supports both tcp and unix socket, and allows to enable io_uring
> > > > > send zero copy via command line '--send_zc', see details in README[4].
> > > > > 
> > > > > No regression is found in xfstests by using ublk-nbd as both test device
> > > > > and scratch device, and builtin test(make test T=nbd) runs well.
> > > > > 
> > > > > Fio test("make test T=nbd") shows that ublk-nbd performance is
> > > > > basically same with nbd-client/nbd driver when running fio on real
> > > > > ethernet link(1g, 10+g), but ublk-nbd IOPS is higher by ~40% than
> > > > > nbd-client(nbd driver) with 512K BS, which is because linux nbd
> > > > > driver sets max_sectors_kb as 64KB at default.
> > > > > 
> > > > > But when running fio over local tcp socket, it is observed in my test
> > > > > machine that ublk-nbd performs better than nbd-client/nbd driver,
> > > > > especially with 2 queue/2 jobs, and the gap could be 10% ~ 30%
> > > > > according to different block size.
> > > > 
> > > > This is pretty nice! Just curious, have you tried setting up your
> > > > ring with
> > > > 
> > > > p.flags |= IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN;
> > > > 
> > > > and see if that yields any extra performance improvements for you?
> > > > Depending on how you do processing, you should not need to do any
> > > > further changes there.
> > > > 
> > > > A "lighter" version is just setting IORING_SETUP_COOP_TASKRUN.
> > > 
> > > IORING_SETUP_COOP_TASKRUN is enabled in current ublksrv.
> > > 
> > > After disabling COOP_TASKRUN and enabling SINGLE_ISSUER & DEFER_TASKRUN,
> > > not see obvious improvement, meantime regression is observed on 64k
> > > rw.
> > 
> > Does it handle network errors better than the default nbd client, i.e.
> > is it able to seamlessly reconnect after while keeping the same device
> > or do you end up with multiple devices ? That's one big trouble I faced
> > with the original nbd client, forcing you to unmount and remount
> > everything after a network outage for example.
> 
> All kinds of ublk disk supports such seamlessly recovery which is
> provided by UBLK_CMD_START_USER_RECOVERY/UBLK_CMD_END_USER_RECOVERY.
> During user recovery, the bdev and gendisk instance won't be gone,
> and will become fully functional after the recovery(such as reconnect)
> is successful.
> 
> So yes for this seamlessly reconnect error handling.

Nice, it's tempting to give it a try then ;-)

Willy
