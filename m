Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4EDA349B2B
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 21:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhCYUoy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 16:44:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40779 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230263AbhCYUoj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 16:44:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616705078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QRNZIFWxRM57bHTCCTJ1A2JvKV0FOZM1E6K3THZHiOg=;
        b=K2QSliinGuCnIHmQDOKWd8xLRI4nn+v0fFHZJTclMJ0dABmnmHF5CJ8Z/ftNUfL4UUT6RE
        QhEyfm4iKmIkWqmIoI3FUAq4+zFBv2V6kPBAGCZy86tgvh0IZfe2uvMoH79zXdx24CU+fe
        euI3ASRtpLjpJ0M+tFCy5fEpaMt/psM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-xis2Tf1rPa2feoa4YPKEnQ-1; Thu, 25 Mar 2021 16:44:34 -0400
X-MC-Unique: xis2Tf1rPa2feoa4YPKEnQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B265E88127C;
        Thu, 25 Mar 2021 20:44:33 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with SMTP id 10BF813470;
        Thu, 25 Mar 2021 20:44:31 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu, 25 Mar 2021 21:44:33 +0100 (CET)
Date:   Thu, 25 Mar 2021 21:44:30 +0100
From:   Oleg Nesterov <oleg@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Jens Axboe <axboe@kernel.dk>,
        io-uring <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH 0/2] Don't show PF_IO_WORKER in /proc/<pid>/task/
Message-ID: <20210325204430.GE28349@redhat.com>
References: <20210325164343.807498-1-axboe@kernel.dk>
 <m1ft0j3u5k.fsf@fess.ebiederm.org>
 <CAHk-=wjOXiEAjGLbn2mWRsxqpAYUPcwCj2x5WgEAh=gj+o0t4Q@mail.gmail.com>
 <CAHk-=wg1XpX=iAv=1HCUReMbEgeN5UogZ4_tbi+ehaHZG6d==g@mail.gmail.com>
 <CAHk-=wgUcVeaKhtBgJO3TfE69miJq-krtL8r_Wf_=LBTJw6WSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgUcVeaKhtBgJO3TfE69miJq-krtL8r_Wf_=LBTJw6WSg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 03/25, Linus Torvalds wrote:
>
> The whole "signals are very special for IO threads" thing has caused
> so many problems, that maybe the solution is simply to _not_ make them
> special?

Or may be IO threads should not abuse CLONE_THREAD?

Why does create_io_thread() abuse CLONE_THREAD ?

One reason (I think) is that this implies SIGKILL when the process exits/execs,
anything else?

Oleg.

