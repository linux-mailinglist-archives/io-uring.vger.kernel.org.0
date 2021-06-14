Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F6E3A6C8E
	for <lists+io-uring@lfdr.de>; Mon, 14 Jun 2021 18:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234873AbhFNRBe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Jun 2021 13:01:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52721 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234771AbhFNRBd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Jun 2021 13:01:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623689970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A1DiCAo4wwoXOYCvkCpDxMFPghUwqg5DmekoJo7gNLs=;
        b=LscqaFy+VDwHmV7SYAbkRbnopWGuotkDYhJQVMyB5q8jfHDwSMV88rt7eIggPQ39tkTxQD
        0kwnKb5z5bQpNyYTcpoVP79pZ30IMWob7zE2D8+5IzEYaBkHC64fFxfF2OZ7j0tAS/L9q7
        PE4qW+2nlA1eWGWQz0UsXmdgxLK9sxQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-DvzPQ2bSMkywCqnS2oZ3RQ-1; Mon, 14 Jun 2021 12:59:26 -0400
X-MC-Unique: DvzPQ2bSMkywCqnS2oZ3RQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A11A10B7462;
        Mon, 14 Jun 2021 16:59:25 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.47])
        by smtp.corp.redhat.com (Postfix) with SMTP id DEF2810023B5;
        Mon, 14 Jun 2021 16:59:22 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Mon, 14 Jun 2021 18:59:24 +0200 (CEST)
Date:   Mon, 14 Jun 2021 18:59:21 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Olivier Langlois <olivier@trillion01.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        "Pavel Begunkov>" <asml.silence@gmail.com>
Subject: Re: [PATCH] coredump: Limit what can interrupt coredumps
Message-ID: <20210614165920.GD13677@redhat.com>
References: <87eeda7nqe.fsf@disp2133>
 <b8434a8987672ab16f9fb755c1fc4d51e0f4004a.camel@trillion01.com>
 <87pmwt6biw.fsf@disp2133>
 <87czst5yxh.fsf_-_@disp2133>
 <CAHk-=wiax83WoS0p5nWvPhU_O+hcjXwv6q3DXV8Ejb62BfynhQ@mail.gmail.com>
 <87y2bh4jg5.fsf@disp2133>
 <CAHk-=wjPiEaXjUp6PTcLZFjT8RrYX+ExtD-RY3NjFWDN7mKLbw@mail.gmail.com>
 <87sg1p4h0g.fsf_-_@disp2133>
 <20210614141032.GA13677@redhat.com>
 <87o8c8tnae.fsf@disp2133>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o8c8tnae.fsf@disp2133>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 06/14, Eric W. Biederman wrote:
>
> I would very much like some clarity on TIF_NOTIFY_SIGNAL.  At the very
> least it would be nice if it could get renamed TIF_NOTIFY_TASK_WORK.

No, no, no ;)

I think that, for example, freezer should be changed to use
set_notify_signal() rather than fake_signal_wake_up(). Livepatch.
And probably it will have more users.

> I don't understand the logic with well enough of adding work to
> non-io_uring threads with task_work_add to understand why that happens
> in the first place.

Same here.

Oleg.

