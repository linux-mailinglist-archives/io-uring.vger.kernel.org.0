Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960E52907C3
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 16:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407807AbgJPOvs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 10:51:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21478 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2409240AbgJPOvs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 10:51:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602859907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kBtWUw3GIVsSeyCo9bJLswKdHG8dpp1UAeDuAGGyOhU=;
        b=Pu8yEIgUI4BXlTPlC0NJ0egti+7zTjeOsMmSUsU72tu3Jvbgasm51Zvkt/l8/aGDaNTLNw
        Og5x9Ekk4xTdua9KMfVr4FRFZ2TxCEu8AKACKDuCWsYFSnkb+/wTaCpWhNIIpc4A6HWVKc
        0jhI2AVwFGz4O3QxZx3hsFc7cmmh0zk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-zcry8vEoOc6_vqJsH77Lrg-1; Fri, 16 Oct 2020 10:51:43 -0400
X-MC-Unique: zcry8vEoOc6_vqJsH77Lrg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE8BE80365F;
        Fri, 16 Oct 2020 14:51:41 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.149])
        by smtp.corp.redhat.com (Postfix) with SMTP id 1885C5B4A2;
        Fri, 16 Oct 2020 14:51:39 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Fri, 16 Oct 2020 16:51:41 +0200 (CEST)
Date:   Fri, 16 Oct 2020 16:51:38 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, peterz@infradead.org,
        Roman Gershman <romger@amazon.com>
Subject: Re: [PATCH 5/5] task_work: use TIF_NOTIFY_SIGNAL if available
Message-ID: <20201016145138.GB21989@redhat.com>
References: <20201015131701.511523-1-axboe@kernel.dk>
 <20201015131701.511523-6-axboe@kernel.dk>
 <20201015154953.GM24156@redhat.com>
 <e17cd91e-97b2-1eae-964b-fc90f8f9ef31@kernel.dk>
 <87a6wmv93v.fsf@nanos.tec.linutronix.de>
 <871rhyv7a8.fsf@nanos.tec.linutronix.de>
 <fbaab94b-dd85-9756-7a99-06bf684b80a4@kernel.dk>
 <87a6wmtfvb.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a6wmtfvb.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/16, Thomas Gleixner wrote:
>
> With moving the handling into get_signal() you don't need more changes
> to arch/* than adding the TIF bit, right?

we still need to do something like

	-	if (thread_flags & _TIF_SIGPENDING)
	+	if (thread_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
			do_signal(...);

and add _TIF_NOTIFY_SIGNAL to the WORK-PENDING mask in arch/* code.

Oleg.

