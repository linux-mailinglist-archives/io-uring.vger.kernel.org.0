Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567E6287651
	for <lists+io-uring@lfdr.de>; Thu,  8 Oct 2020 16:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730353AbgJHOpr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Oct 2020 10:45:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28460 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729828AbgJHOpq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Oct 2020 10:45:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602168345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X1kaHWBHLF6as3Dsn7xHzXIh9cJ3AkogIyQtrQFgTrw=;
        b=f3s8mUoMcTxcPFJVet/Z5GTWi/zO0YAMcHIGU04XruHp7jQ3wmr+LSbji8mgIRNMrIAQQt
        9+oh0IXfEIGvwnP58pM8HPVcaaEuExPcYcRDCUPozhXEBjEjK1pUkpUChLJzEgV9nRR7H3
        4PV/OGmIzrUsk/+fq1N11mQHMtv1G6o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-iuDgOWNRPRyInvvnGfhOxw-1; Thu, 08 Oct 2020 10:45:44 -0400
X-MC-Unique: iuDgOWNRPRyInvvnGfhOxw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE42D18BE169;
        Thu,  8 Oct 2020 14:45:42 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.132])
        by smtp.corp.redhat.com (Postfix) with SMTP id 4FA9376648;
        Thu,  8 Oct 2020 14:45:41 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu,  8 Oct 2020 16:45:42 +0200 (CEST)
Date:   Thu, 8 Oct 2020 16:45:40 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH 3/6] kernel: split syscall restart from signal handling
Message-ID: <20201008144539.GJ9995@redhat.com>
References: <20201005150438.6628-1-axboe@kernel.dk>
 <20201005150438.6628-4-axboe@kernel.dk>
 <20201008142135.GH9995@redhat.com>
 <de00f13d-9ff0-6955-5d37-557f044ce2aa@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de00f13d-9ff0-6955-5d37-557f044ce2aa@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/08, Jens Axboe wrote:
>
> On 10/8/20 8:21 AM, Oleg Nesterov wrote:
> > 
> > Can't we avoid this patch and the and simplify the change in
> > exit_to_user_mode_loop() from the next patch? Can't the much more simple
> > patch below work?
> > 
> > Then later we can even change arch_do_signal() to accept the additional
> > argument, ti_work, so that it can use ti_work & TIF_NOTIFY_SIGNAL/SIGPENDING
> > instead of test_thread_flag/task_sigpending.
> 
> Yeah I guess that would be a bit simpler, maybe I'm too focused on
> decoupling the two. But if we go this route, and avoid sighand->lock for
> just having TIF_NOTIFY_SIGNAL set, then that should be functionally
> equivalent as far as I'm concerned.

Not sure I understand... I think that the change I propose is functionally
equivalent or I missed something.

> I'll make the reduction, I'd prefer to keep this as small/simple as
> possible initially.

Great, thanks.

Oleg.

