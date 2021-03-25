Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E4F349B05
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 21:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbhCYUc4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 16:32:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47363 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230290AbhCYUcX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 16:32:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616704342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GPeAC2SU3JAKEkwGdDypjlr3Iu8SDL5k3qtAn7Yo0i8=;
        b=Owqc452d+tF6dVwWmC4DKYCYCzbhAFTnKfiHspjHHfrm4UTxvKV2KHcD4MKd748MV+WKta
        I8qevfj1WSARyZkY+Qlt1K9BTasMVeqlLpUR45B6EyY//xznCm+pdLva5x7PCFZWza7tlM
        FE+lvRwBqEiF7VGFbdnnvpIbMJ6dl64=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564--UhNXdL_PEmlrwUDqHWcxw-1; Thu, 25 Mar 2021 16:32:18 -0400
X-MC-Unique: -UhNXdL_PEmlrwUDqHWcxw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C56388018A1;
        Thu, 25 Mar 2021 20:32:17 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with SMTP id DF09A1000324;
        Thu, 25 Mar 2021 20:32:15 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu, 25 Mar 2021 21:32:17 +0100 (CET)
Date:   Thu, 25 Mar 2021 21:32:14 +0100
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        io-uring@vger.kernel.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, metze@samba.org
Subject: Re: [PATCH 0/2] Don't show PF_IO_WORKER in /proc/<pid>/task/
Message-ID: <20210325203214.GC28349@redhat.com>
References: <20210325164343.807498-1-axboe@kernel.dk>
 <m1ft0j3u5k.fsf@fess.ebiederm.org>
 <5ee8ad82-e145-3ed6-1421-eede1ada0d7e@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ee8ad82-e145-3ed6-1421-eede1ada0d7e@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I didn't even try to read this series yet, will try tomorrow.

But sorry, I can't resist...

On 03/25, Jens Axboe wrote:
>
> On 3/25/21 1:33 PM, Eric W. Biederman wrote:
> > Jens Axboe <axboe@kernel.dk> writes:
> >
> >> Hi,
> >>
> >> Stefan reports that attaching to a task with io_uring will leave gdb
> >> very confused and just repeatedly attempting to attach to the IO threads,
> >> even though it receives an -EPERM every time.

Heh. As expected :/

> And arguably it _is_ a gdb bug, but...

Why do you think so?

Oleg.

