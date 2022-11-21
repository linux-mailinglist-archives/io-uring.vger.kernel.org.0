Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18508632D6D
	for <lists+io-uring@lfdr.de>; Mon, 21 Nov 2022 20:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbiKUTyW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Nov 2022 14:54:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbiKUTx1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Nov 2022 14:53:27 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA57C72C7;
        Mon, 21 Nov 2022 11:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PWapQM2+2A3fsvM5vU867mCtB6N1Jd/oW1Tp2ds4SpQ=; b=hrHLYysjL1XIOj8C1g+7hKi6aJ
        agwPJmePC/RD8zF83QJ9ElMQmWok8ZkuSu5eQZ/zDeMRY/ECtOL9lcayTYUmOzzp0otyqgJKiG/yb
        JlZ73+d5jcluh9K+slFj25mVz6IrH+2p/uVa2CU/8XvRL6Zs9NTuvPm1BuqyEUHaXnRD6udh3bHbg
        DO3fqmTcVr8UBPfjjFY9cKUlM3vLr6AGZnqsqtRyoJ8CqlKahMo0ncNRjrq/kA7EL6sLqNum0NmaD
        txSnE1JvzA7NxAzfCF9vAn0f8Ahnubn/rkfYwaXnp4y5tXKE/Fd9r1ErJ5t/ShoQkinSPp/O7xqba
        MdZ3g3Eg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oxCqz-00HLjH-Gq; Mon, 21 Nov 2022 19:53:17 +0000
Date:   Mon, 21 Nov 2022 11:53:17 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Joel Granados <j.granados@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>, ddiss@suse.de,
        linux-security-module@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC 1/1] Use ioctl selinux callback io_uring commands that
 implement the ioctl op convention
Message-ID: <Y3vXLQz1k8E/qu5A@bombadil.infradead.org>
References: <20221116125051.3338926-1-j.granados@samsung.com>
 <CGME20221116125431eucas1p1dfd03b80863fce674a7c662660c94092@eucas1p1.samsung.com>
 <20221116125051.3338926-2-j.granados@samsung.com>
 <20221116173821.GC5094@test-zns>
 <CAHC9VhSVzujW9LOj5Km80AjU0EfAuukoLrxO6BEfnXeK_s6bAg@mail.gmail.com>
 <20221117094004.b5l64ipicitphkun@localhost>
 <CAHC9VhSa3Yrjf9z5L0oS8Cx=20gUrgfA8evizoVjBNs4AB_cXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhSa3Yrjf9z5L0oS8Cx=20gUrgfA8evizoVjBNs4AB_cXg@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Nov 17, 2022 at 05:10:07PM -0500, Paul Moore wrote:
> On Thu, Nov 17, 2022 at 4:40 AM Joel Granados <j.granados@samsung.com> wrote:
> > On Wed, Nov 16, 2022 at 02:21:14PM -0500, Paul Moore wrote:
> 
> ...
> 
> > > * As we discussed previously, the real problem is the fact that we are
> > > missing the necessary context in the LSM hook to separate the
> > > different types of command targets.  With traditional ioctls we can
> > > look at the ioctl number and determine both the type of
> > > device/subsystem/etc. as well as the operation being requested; there
> > > is no such information available with the io_uring command
> > > passthrough.  In this sense, the io_uring command passthrough is
> > > actually worse than traditional ioctls from an access control
> > > perspective.  Until we have an easy(ish)[1] way to determine the
> > > io_uring command target type, changes like the one suggested here are
> > > going to be doomed as each target type is free to define their own
> > > io_uring commands.
> >
> > The only thing that comes immediately to mind is that we can have
> > io_uring users define a function that is then passed to the LSM
> > infrastructure. This function will have all the logic to give relative
> > context to LSM. It would be general enough to fit all the possible commands
> > and the logic would be implemented in the "drivers" side so there is no
> > need for LSM folks to know all io_uring users.
> 
> Passing a function pointer to the LSM to fetch, what will likely be
> just a constant value, seems kinda ugly, but I guess we only have ugly
> options at this point.

I am not sure if this helps yet, but queued on modules-next we now have
an improvement in speed of about 1500x for kallsyms_lookup_name(), and
so symbol lookups are now fast. Makes me wonder if a type of special
export could be drawn up for specific calls which follow a structure
and so the respective lsm could be inferred by a prefix instead of
placing the calls in-place. Then it would not mattter where a call is
used, so long as it would follow a specific pattern / structure with
all the crap you need on it.

  Luis
