Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC79A57A122
	for <lists+io-uring@lfdr.de>; Tue, 19 Jul 2022 16:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235886AbiGSOTg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jul 2022 10:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238680AbiGSOSp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jul 2022 10:18:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E1E7DAE
        for <io-uring@vger.kernel.org>; Tue, 19 Jul 2022 06:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658238906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O/FvAWLla+1Wk19cGVtJlLnIWGf+0LUDeRirr49qjb4=;
        b=SjqgqRBc4jiKBkt+1GLDwrcvdqjAyCliIpdxGje/KopogKdIDJwBEhiDW1rUfy3twhadmk
        5PM4zCfvgl92jjukUsCqreVDyoQcSJ0QHJuwFDq1v6TAUH4NUZk0VpWaoNhCAB/cghEjpN
        qiyvavNs+kUXCD9g0jvvkbdiW6ztc6M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-412-PkzAgNblNLyduQFKc5j3NA-1; Tue, 19 Jul 2022 09:55:01 -0400
X-MC-Unique: PkzAgNblNLyduQFKc5j3NA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B6658039A5;
        Tue, 19 Jul 2022 13:55:00 +0000 (UTC)
Received: from T590 (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 72E7140CF8E5;
        Tue, 19 Jul 2022 13:54:52 +0000 (UTC)
Date:   Tue, 19 Jul 2022 21:54:47 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Jens Axboe <axboe@kernel.dk>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-security-module@vger.kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        a.manzanares@samsung.com, javier@javigon.com,
        ankit.kumar@samsung.com, ming.lei@redhat.com
Subject: Re: [PATCH v2] lsm,io_uring: add LSM hooks for the new uring_cmd
 file op
Message-ID: <Yta3pzbOTgdFp+yV@T590>
References: <20220715191622.2310436-1-mcgrof@kernel.org>
 <a56d191e-a3a3-76b9-6ca3-782803d2600c@kernel.dk>
 <CAHC9VhRzm=1mh9bZKEdLSG0vet=amQDVpuZk+1shMuXYLV_qoQ@mail.gmail.com>
 <CAHC9VhQm3CBUkVz2OHBmuRi1VDNxvfWs-tFT2UO9LKMbO7YJMg@mail.gmail.com>
 <e139a585-ece7-7813-7c90-9ffc3a924a87@schaufler-ca.com>
 <CGME20220718215605epcas5p4332ce1e7321243d7052834b0804c91c6@epcas5p4.samsung.com>
 <CAHC9VhRzjLFg9B4wL7GvW3WY-qM4BoqqcpyS0gW8MUbQ9BD2mg@mail.gmail.com>
 <20220719044717.GA22571@test-zns>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719044717.GA22571@test-zns>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 19, 2022 at 10:17:17AM +0530, Kanchan Joshi wrote:
> On Mon, Jul 18, 2022 at 05:52:01PM -0400, Paul Moore wrote:
> > On Mon, Jul 18, 2022 at 1:12 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> > > On 7/15/2022 8:33 PM, Paul Moore wrote:
> > > > On Fri, Jul 15, 2022 at 3:52 PM Paul Moore <paul@paul-moore.com> wrote:
> > > >> On Fri, Jul 15, 2022 at 3:28 PM Jens Axboe <axboe@kernel.dk> wrote:
> > > >>> On 7/15/22 1:16 PM, Luis Chamberlain wrote:
> > > >>>> io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
> > > >>>> add infrastructure for uring-cmd"), this extended the struct
> > > >>>> file_operations to allow a new command which each subsystem can use
> > > >>>> to enable command passthrough. Add an LSM specific for the command
> > > >>>> passthrough which enables LSMs to inspect the command details.
> > > >>>>
> > > >>>> This was discussed long ago without no clear pointer for something
> > > >>>> conclusive, so this enables LSMs to at least reject this new file
> > > >>>> operation.
> > > >>> From an io_uring perspective, this looks fine to me. It may be easier if
> > > >>> I take this through my tree due to the moving of the files, or the
> > > >>> security side can do it but it'd have to then wait for merge window (and
> > > >>> post io_uring branch merge) to do so. Just let me know. If done outside
> > > >>> of my tree, feel free to add:
> > > > I forgot to add this earlier ... let's see how the timing goes, I
> > > > don't expect the LSM/Smack/SELinux bits to be ready and tested before
> > > > the merge window opens so I'm guessing this will not be an issue in
> > > > practice, but thanks for the heads-up.
> > > 
> > > I have a patch that may or may not be appropriate. I ran the
> > > liburing tests without (additional) failures, but it looks like
> > > there isn't anything there testing uring_cmd. Do you have a
> > > test tucked away somewhere I can use?
> 
> Earlier testing was done using fio. liburing tests need a formal review
> in list. Tree is here -
> https://github.com/ankit-sam/liburing/tree/uring-pt
> It adds new "test/io_uring_passthrough.t", which can be run this way:
> 
> ./test/io_uring_passthrough.t /dev/ng0n1
> 
> Requires nvme device (/dev/ng0n1). And admin-access as well, as this
> is raw open. FWIW, each passthrough command (at nvme driver level) is
> also guarded by admin-access.
> 
> Ankit (CCed) has the plans to post it (will keep you guys in loop) after
> bit more testing with 5.20 branch.

Another candidate is ublksrv[1] which doesn't require any device and
is pretty easy to setup. However, the kernel side driver(ublk_drv) isn't
merged to linus tree yet, but has been in for-5.20/block.

And io_uring command is sent to both /dev/ublk-control and /dev/ublkcN.

[1] https://github.com/ming1/ubdsrv.git


Thanks,
Ming

