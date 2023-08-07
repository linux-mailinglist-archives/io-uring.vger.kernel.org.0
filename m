Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5879977301C
	for <lists+io-uring@lfdr.de>; Mon,  7 Aug 2023 22:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjHGUGM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Aug 2023 16:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjHGUGL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Aug 2023 16:06:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B149E66
        for <io-uring@vger.kernel.org>; Mon,  7 Aug 2023 13:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691438728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D93mPLQv9uDtXWUvVhscypFR0fb0Op91p97gW9gq6Wc=;
        b=ZKSAvclUCbLo+j3kkGjz6iHJoKh2U5FjSNYVpn3hCf5RePeGlE96rPYcKMn502T0m86oEJ
        0gwGz1cDR9nHjonQYRLxdx0M2nhhm2IXr8M3oPdvYuFNaRTkMQduo0kh5A0HKemUtYPMnS
        pji1ABuxwx+OMCjnQkavATpU/sMtxAc=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-CYWylNudO86VVXtyS1k4jQ-1; Mon, 07 Aug 2023 16:05:26 -0400
X-MC-Unique: CYWylNudO86VVXtyS1k4jQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF76A29AA2C1;
        Mon,  7 Aug 2023 20:05:25 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C5684492C14;
        Mon,  7 Aug 2023 20:05:25 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Pierre Labat <plabat@micron.com>
Cc:     "'io-uring\@vger.kernel.org'" <io-uring@vger.kernel.org>
Subject: Re: FYI, fsnotify contention with aio and io_uring.
References: <SJ0PR08MB6494F5A32B7C60A5AD8B33C2AB09A@SJ0PR08MB6494.namprd08.prod.outlook.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Mon, 07 Aug 2023 16:11:14 -0400
In-Reply-To: <SJ0PR08MB6494F5A32B7C60A5AD8B33C2AB09A@SJ0PR08MB6494.namprd08.prod.outlook.com>
        (Pierre Labat's message of "Fri, 4 Aug 2023 17:47:25 +0000")
Message-ID: <x49pm3y4nq5.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi, Pierre,

Pierre Labat <plabat@micron.com> writes:

> Hi,
>
> This is FYI, may be you already knows about that, but in case you don't....
>
> I was pushing the limit of the number of nvme read IOPS, the FIO + the
> Linux OS can handle. For that, I have something special under the
> Linux nvme driver. As a consequence I am not limited by whatever the
> NVME SSD max IOPS or IO latency would be.
>
> As I cranked the number of system cores and FIO jobs doing direct 4k
> random read on /dev/nvme0n1, I hit a wall. The IOPS scaling slows
> (less than linear) and around 15 FIO jobs on 15 core threads, the
> overall IOPS, in fact, goes down as I add more FIO jobs. For example
> on a system with 24 cores/48 threads, when I goes beyond 15 FIO jobs,
> the overall IOPS starts to go down.
>
> This happens the same for io_uring and aio. Was using kernel version 6.3.9. Using one namespace (/dev/nvme0n1).

[snip]

> As you can see 76% of the cpu on the box is sucked up by
> lockref_get_not_zero() and lockref_put_return().  Looking at the code,
> there is contention when IO_uring call fsnotify_access().

Is there a FAN_MODIFY fsnotify watch set on /dev?  If so, it might be a
good idea to find out what set it and why.

> The filesystem code fsnotify_access() ends up calling dget_parent()
> and later dput() to take a reference on the parent directory (that
> would be /dev/ in our case), and later release the reference.  This is
> done (get+put) for each IO.
>
> The dget increments a unique/same counter (for the /dev/ directory)
> and dput decrements this same counter.
>
> As a consequence we have 24 cores/48 threads fighting to get the same
> counter in their cache to modify it. At a rate of M of iops. That is
> disastrous.
>
> To work around that problem, and continue my scalability testing, I
> acked io_uring and aio to set the flag FMODE_NONOTIFY in the struct
> file->f_mode of the file on which IOs are done.  Doing that forces
> fsnotify to do nothing. The iops immediately went up more than 4X and
> the fsnotify trashing disappeared.
>
> May be it would be a good idea to add an option to FIO to disable
> fsnotify on the file[s] on which IOs are issued?

Maybe I'm wrong, but that sounds like an abuse of the FMODE_NONOTIFY
flag.

> Or to take a reference on the file parent directory only once when fio
> starts?

Let's decide on whether or not the application is following best
practices, first, starting with answering the questions I asked above.

Cheers,
Jeff

