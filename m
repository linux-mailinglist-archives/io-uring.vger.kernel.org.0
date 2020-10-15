Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5848028F4DA
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 16:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728888AbgJOOhL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 10:37:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41874 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726925AbgJOOhL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 10:37:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602772630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8D+jKZOPdRlEHQps569knoTqeoIFuK+hHSLLdva6RMw=;
        b=JsLODh9ZyPnxVVUYV4wGaTqgxpEp/8jLyUb4AsN16LvrF1KYxAjeusk5T1RWJLWyJYmzuR
        R3X44V1ftSZAsHB5zNs7zAkeizKVmId2uzZNjGTAzyscImLFjWeK4reiUd0sm1IOpY3D3a
        UsCXhDgWlyPb/d2MOrlo99C7cYl6vAs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-DySHVaUXNh6v_r4_2D9xRA-1; Thu, 15 Oct 2020 10:37:05 -0400
X-MC-Unique: DySHVaUXNh6v_r4_2D9xRA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E800D88C783;
        Thu, 15 Oct 2020 14:36:19 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.193.8])
        by smtp.corp.redhat.com (Postfix) with SMTP id 77F9A6EF52;
        Thu, 15 Oct 2020 14:36:18 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu, 15 Oct 2020 16:36:19 +0200 (CEST)
Date:   Thu, 15 Oct 2020 16:36:17 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH 4/5] x86: wire up TIF_NOTIFY_SIGNAL
Message-ID: <20201015143616.GD24156@redhat.com>
References: <20201015131701.511523-1-axboe@kernel.dk>
 <20201015131701.511523-5-axboe@kernel.dk>
 <87o8l3a8af.fsf@nanos.tec.linutronix.de>
 <da84a2a7-f94a-d0aa-14e0-3925f758aa0e@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da84a2a7-f94a-d0aa-14e0-3925f758aa0e@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/15, Jens Axboe wrote:
>
> static void handle_signal_work(ti_work, regs)
> {
> 	if (ti_work & _TIF_NOTIFY_SIGNAL)
>         	tracehook_notify_signal();
>
> 	if (ti_work & _TIF_SIGPENDING)
>         	arch_do_signal(regs);
> }
>
> and then we can skip modifying arch_do_signal() all together, as it'll
> only be called if _TIF_SIGPENDING is set.

No, this can't work. We need to restart the syscall if TIF_NOTIFY_SIGNAL.

Oleg.

