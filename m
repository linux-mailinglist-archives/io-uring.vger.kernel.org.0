Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 766D33A68BC
	for <lists+io-uring@lfdr.de>; Mon, 14 Jun 2021 16:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbhFNOMp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Jun 2021 10:12:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24040 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232745AbhFNOMp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Jun 2021 10:12:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623679841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5VrGrghkNvFrliY5Q4Xm/jGj5MiDa9nv/G4jvjsxRj0=;
        b=gqjxYoG6bfPwx9u6hcUxHmZUGrwhCwovKi1jy+Jf1msb1igFqH0fi4p3WEWbLOMj7QvPUs
        0NAOVcBqvIHGkZ4eUeuoloZYz11ILtwO4tMs75bRDXhAsTnLw80l9jBF7+wSu+sczzWzLh
        zw3lV/9pHEdGKw3O2k1x4IKUf0xFgcc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-ZJLCkTrfMUCtFHKrFfLamQ-1; Mon, 14 Jun 2021 10:10:37 -0400
X-MC-Unique: ZJLCkTrfMUCtFHKrFfLamQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 683AECC628;
        Mon, 14 Jun 2021 14:10:36 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.47])
        by smtp.corp.redhat.com (Postfix) with SMTP id 2A7005D6A8;
        Mon, 14 Jun 2021 14:10:33 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Mon, 14 Jun 2021 16:10:36 +0200 (CEST)
Date:   Mon, 14 Jun 2021 16:10:33 +0200
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
Message-ID: <20210614141032.GA13677@redhat.com>
References: <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
 <198e912402486f66214146d4eabad8cb3f010a8e.camel@trillion01.com>
 <87eeda7nqe.fsf@disp2133>
 <b8434a8987672ab16f9fb755c1fc4d51e0f4004a.camel@trillion01.com>
 <87pmwt6biw.fsf@disp2133>
 <87czst5yxh.fsf_-_@disp2133>
 <CAHk-=wiax83WoS0p5nWvPhU_O+hcjXwv6q3DXV8Ejb62BfynhQ@mail.gmail.com>
 <87y2bh4jg5.fsf@disp2133>
 <CAHk-=wjPiEaXjUp6PTcLZFjT8RrYX+ExtD-RY3NjFWDN7mKLbw@mail.gmail.com>
 <87sg1p4h0g.fsf_-_@disp2133>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sg1p4h0g.fsf_-_@disp2133>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Eric, et al, sorry for delay, I didn't read emails several days.

On 06/10, Eric W. Biederman wrote:
>
> v2: Don't remove the now unnecessary code in prepare_signal.

No, that code is still needed. Otherwise any fatal signal will be
turned into SIGKILL.

> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -519,7 +519,7 @@ static bool dump_interrupted(void)
>  	 * but then we need to teach dump_write() to restart and clear
>  	 * TIF_SIGPENDING.
>  	 */
> -	return signal_pending(current);
> +	return fatal_signal_pending(current) || freezing(current);
>  }


Well yes, this is what the comment says.

But note that there is another reason why dump_interrupted() returns true
if signal_pending(), it assumes thagt __dump_emit()->__kernel_write() may
fail anyway if signal_pending() is true. Say, pipe_write(), or iirc nfs,
perhaps something else...

That is why zap_threads() clears TIF_SIGPENDING. Perhaps it should clear
TIF_NOTIFY_SIGNAL as well and we should change io-uring to not abuse the
dumping threads?

Or perhaps we should change __dump_emit() to clear signal_pending() and
restart __kernel_write() if it fails or returns a short write.

Otherwise the change above doesn't look like a full fix to me.

Oleg.

