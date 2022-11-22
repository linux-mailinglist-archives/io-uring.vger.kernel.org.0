Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD38633E6F
	for <lists+io-uring@lfdr.de>; Tue, 22 Nov 2022 15:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbiKVOGl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Nov 2022 09:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233639AbiKVOGB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Nov 2022 09:06:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B070E67F53
        for <io-uring@vger.kernel.org>; Tue, 22 Nov 2022 06:04:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669125859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fNxu/C/JN8LiF9RXqMVhFG/8p1moQ0Wo3Ndszkw34Og=;
        b=TSDW/u9V1r21XNeEuqKIdX94Y47NiVDN/QMFfQuyODxfPeyvwrl14/+E/Ga6QaVcB5JQvK
        UWeustLM0NrUrOCWJGl2OIpNgjLlEfUII+eJqVHb65wVOcSq5+voSU7KLw2Qc7IAXRxn/3
        JbkIdMrbjc/4o7s8vEB1cOnk8Mx7UEM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-a6IkOR07PsmZwpwzjD7j7Q-1; Tue, 22 Nov 2022 09:04:14 -0500
X-MC-Unique: a6IkOR07PsmZwpwzjD7j7Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7A35934F04;
        Tue, 22 Nov 2022 14:04:13 +0000 (UTC)
Received: from T590 (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9326F2027062;
        Tue, 22 Nov 2022 14:04:08 +0000 (UTC)
Date:   Tue, 22 Nov 2022 22:04:03 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Joel Granados <j.granados@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>, ddiss@suse.de,
        linux-security-module@vger.kernel.org, io-uring@vger.kernel.org,
        ming.lei@redhat.com
Subject: Re: [RFC 1/1] Use ioctl selinux callback io_uring commands that
 implement the ioctl op convention
Message-ID: <Y3zW02nH1LQhb/qz@T590>
References: <20221116125051.3338926-1-j.granados@samsung.com>
 <CGME20221116125431eucas1p1dfd03b80863fce674a7c662660c94092@eucas1p1.samsung.com>
 <20221116125051.3338926-2-j.granados@samsung.com>
 <20221116173821.GC5094@test-zns>
 <CAHC9VhSVzujW9LOj5Km80AjU0EfAuukoLrxO6BEfnXeK_s6bAg@mail.gmail.com>
 <20221117094004.b5l64ipicitphkun@localhost>
 <CAHC9VhSa3Yrjf9z5L0oS8Cx=20gUrgfA8evizoVjBNs4AB_cXg@mail.gmail.com>
 <Y3vXLQz1k8E/qu5A@bombadil.infradead.org>
 <CAHC9VhR+RFqJ7c6mFhnMFdDXPcCBg-pnAzEuyOc-TX5hmsubwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhR+RFqJ7c6mFhnMFdDXPcCBg-pnAzEuyOc-TX5hmsubwg@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Nov 21, 2022 at 04:05:37PM -0500, Paul Moore wrote:
> On Mon, Nov 21, 2022 at 2:53 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> > On Thu, Nov 17, 2022 at 05:10:07PM -0500, Paul Moore wrote:
> > > On Thu, Nov 17, 2022 at 4:40 AM Joel Granados <j.granados@samsung.com> wrote:
> > > > On Wed, Nov 16, 2022 at 02:21:14PM -0500, Paul Moore wrote:
> > >
> > > ...
> > >
> > > > > * As we discussed previously, the real problem is the fact that we are
> > > > > missing the necessary context in the LSM hook to separate the
> > > > > different types of command targets.  With traditional ioctls we can
> > > > > look at the ioctl number and determine both the type of
> > > > > device/subsystem/etc. as well as the operation being requested; there
> > > > > is no such information available with the io_uring command
> > > > > passthrough.  In this sense, the io_uring command passthrough is
> > > > > actually worse than traditional ioctls from an access control
> > > > > perspective.  Until we have an easy(ish)[1] way to determine the
> > > > > io_uring command target type, changes like the one suggested here are
> > > > > going to be doomed as each target type is free to define their own
> > > > > io_uring commands.
> > > >
> > > > The only thing that comes immediately to mind is that we can have
> > > > io_uring users define a function that is then passed to the LSM
> > > > infrastructure. This function will have all the logic to give relative
> > > > context to LSM. It would be general enough to fit all the possible commands
> > > > and the logic would be implemented in the "drivers" side so there is no
> > > > need for LSM folks to know all io_uring users.
> > >
> > > Passing a function pointer to the LSM to fetch, what will likely be
> > > just a constant value, seems kinda ugly, but I guess we only have ugly
> > > options at this point.
> >
> > I am not sure if this helps yet, but queued on modules-next we now have
> > an improvement in speed of about 1500x for kallsyms_lookup_name(), and
> > so symbol lookups are now fast. Makes me wonder if a type of special
> > export could be drawn up for specific calls which follow a structure
> > and so the respective lsm could be inferred by a prefix instead of
> > placing the calls in-place. Then it would not mattter where a call is
> > used, so long as it would follow a specific pattern / structure with
> > all the crap you need on it.
> 
> I suspect we may be talking about different things here, I don't think
> the issue is which LSM(s) may be enabled, as the call is to
> security_uring_cmd() regardless.  I believe the issue is more of how
> do the LSMs determine the target of the io_uring command, e.g. nvme or
> ublk.
> 
> My understanding is that Joel was suggesting a change to the LSM hook
> to add a function specific pointer (presumably defined as part of the
> file_operations struct) that could be called by the LSM to determine
> the target.
> 
> Although now that I'm looking again at the file_operations struct, I
> wonder if we would be better off having the LSMs inspect the
> file_operations::owner field, potentially checking the module::name
> field.  It's a little painful in the sense that it is potentially
> multiple strcmp() calls for each security_uring_cmd() call, but I'm
> not sure the passed function approach would be much better.  Do we
> have a consistent per-module scalar value we can use instead of a
> character string?

In future there may be more uring_cmd kernel users, maybe we need to
consider to use one reserved field in io_uring_sqe for describing the
target type if it is one must for security subsystem, and this way
will be similar with traditional ioctl which encodes this kind of
info in command type.


Thanks,
Ming

