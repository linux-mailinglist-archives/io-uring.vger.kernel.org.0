Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253E128F4C4
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 16:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388354AbgJOOb7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 10:31:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49341 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387910AbgJOOb7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 10:31:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602772318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E7gZT/uq+bbgZGNzQ217HS7XAdR8J53BAoSax/kSLy4=;
        b=AQMnVaxqmYs06mGPb5fIKxAulv2YA/Y0QdJUU7vTEis8+vJVwCcwlN3sg+SLTmNQ5rbl6S
        ZyfCZsrfL/rU0XbSiMbgiOODsFsd72P7KvI8/DanQqdXUi3RblQIbeYBNGP3HFRHeDmlzb
        ZHXGP4h/Dhs2eTjbk8S2E+KFmZv9WLg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-FWJ9mjH8NVKEn0P7rLPMxw-1; Thu, 15 Oct 2020 10:31:56 -0400
X-MC-Unique: FWJ9mjH8NVKEn0P7rLPMxw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBDDF80365E;
        Thu, 15 Oct 2020 14:31:54 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.193.8])
        by smtp.corp.redhat.com (Postfix) with SMTP id 5BFBB76677;
        Thu, 15 Oct 2020 14:31:53 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu, 15 Oct 2020 16:31:54 +0200 (CEST)
Date:   Thu, 15 Oct 2020 16:31:52 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH 3/5] kernel: add support for TIF_NOTIFY_SIGNAL
Message-ID: <20201015143151.GB24156@redhat.com>
References: <20201015131701.511523-1-axboe@kernel.dk>
 <20201015131701.511523-4-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015131701.511523-4-axboe@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/15, Jens Axboe wrote:
>
>  static inline int signal_pending(struct task_struct *p)
>  {
> +#if defined(CONFIG_GENERIC_ENTRY) && defined(TIF_NOTIFY_SIGNAL)
> +	/*
> +	 * TIF_NOTIFY_SIGNAL isn't really a signal, but it requires the same
> +	 * behavior in terms of ensuring that we break out of wait loops
> +	 * so that notify signal callbacks can be processed.
> +	 */
> +	if (unlikely(test_tsk_thread_flag(p, TIF_NOTIFY_SIGNAL)))
> +		return 1;
> +#endif
>  	return task_sigpending(p);
>  }

I don't understand why does this version requires CONFIG_GENERIC_ENTRY.

Afaics, it is very easy to change all the non-x86 arches to support
TIF_NOTIFY_SIGNAL, but it is not trivial to change them all to use
kernel/entry/common.c ?

Oleg.

