Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3B0F58F289
	for <lists+io-uring@lfdr.de>; Wed, 10 Aug 2022 20:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbiHJSwe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Aug 2022 14:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiHJSwd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Aug 2022 14:52:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273F882FA4;
        Wed, 10 Aug 2022 11:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=30VFo5a7JeVy/w8TY1J+NJC1egtewPVjD1FM6RGYwBg=; b=s6a64YP8QczXD0JIqbxeiDGFqS
        Sb/NlyQn4cZX6wLkeYRRQJZ5VKHXw5xK4FKWP00CCewYp9T3RgVmy9/p3NDkxPaQgwaTy6Ds4i8My
        bNzcWFX0WFEIzg18D3mehTWJSl0H3V/YCa3T1RzgQSsGvoZAxvCgQciLnCn1FOT9JxTYPOUkp5AkH
        WaSAhTo2r/YXVFA2Di8jdzsQsz8Wo1ZabEUXKjvIrsu9PazM6slOdEANhDJcHgrJuEPmEMXv2ScT2
        rtb7kwooxIN0gRkh3xIyHPaN4Shz2qMltQj/+wXHU8/KjiUdflrMV6X1IH/BAScfYYMVLzKE1Licv
        8wwjLBdw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oLqoc-00DuFN-CR; Wed, 10 Aug 2022 18:52:26 +0000
Date:   Wed, 10 Aug 2022 11:52:26 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        casey@schaufler-ca.com, joshi.k@samsung.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-security-module@vger.kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        a.manzanares@samsung.com, javier@javigon.com
Subject: Re: [PATCH v2] lsm,io_uring: add LSM hooks for the new uring_cmd
 file op
Message-ID: <YvP+aiGcBsik+v3y@bombadil.infradead.org>
References: <20220715191622.2310436-1-mcgrof@kernel.org>
 <a56d191e-a3a3-76b9-6ca3-782803d2600c@kernel.dk>
 <YvP1jK/J4m8TE8BZ@bombadil.infradead.org>
 <CAHC9VhQnQqP1ww7fvCzKp_o1n7iMyYb564HSZy1Ed7k1-nD=jQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhQnQqP1ww7fvCzKp_o1n7iMyYb564HSZy1Ed7k1-nD=jQ@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 10, 2022 at 02:39:54PM -0400, Paul Moore wrote:
> On Wed, Aug 10, 2022 at 2:14 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > On Fri, Jul 15, 2022 at 01:28:35PM -0600, Jens Axboe wrote:
> > > On 7/15/22 1:16 PM, Luis Chamberlain wrote:
> > > > io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
> > > > add infrastructure for uring-cmd"), this extended the struct
> > > > file_operations to allow a new command which each subsystem can use
> > > > to enable command passthrough. Add an LSM specific for the command
> > > > passthrough which enables LSMs to inspect the command details.
> > > >
> > > > This was discussed long ago without no clear pointer for something
> > > > conclusive, so this enables LSMs to at least reject this new file
> > > > operation.
> > >
> > > From an io_uring perspective, this looks fine to me. It may be easier if
> > > I take this through my tree due to the moving of the files, or the
> > > security side can do it but it'd have to then wait for merge window (and
> > > post io_uring branch merge) to do so. Just let me know. If done outside
> > > of my tree, feel free to add:
> > >
> > > Acked-by: Jens Axboe <axboe@kernel.dk>
> >
> > Paul, Casey, Jens,
> >
> > should this be picked up now that we're one week into the merge window?
> 
> Your timing is spot on!  I wrapped up a SELinux/SCTP issue by posting
> the patches yesterday and started on the io_uring/CMD patches this
> morning :)
> 
> Give me a few days to get this finished, tested, etc. and I'll post a
> patchset with your main patch, the Smack patch from Casey, the SELinux
> patch, and the /dev/null patch so we can all give it a quick sanity
> check before I merge it into the LSM/stable branch and send it to
> Linus.  Does that sound okay?

Works with me! But just note I'll be away on vacation starting tomorrow
in the woods looking for Bigfoot with my dog, so I won't be around. And
I suspect Linus plans to release 6.0 on Sunday, if the phb-crystall-ball [0]
is still as accurate.

[0] http://deb.tandrin.de/phb-crystal-ball.htm

  Luis
