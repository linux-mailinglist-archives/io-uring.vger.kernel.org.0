Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B3D288AE2
	for <lists+io-uring@lfdr.de>; Fri,  9 Oct 2020 16:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388727AbgJIOaR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Oct 2020 10:30:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45433 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728934AbgJIOaQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Oct 2020 10:30:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602253815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VZwi1PuAHHUonkjQhC6XnnNKvufbOcpHYJxIfyAttlM=;
        b=c6lbCxk10TEhVuBKIFeyIATZ9nqXL+Jlg6l+RAFnrNuf8lGxqU4LrepQcCmOva4m0FiYKj
        5eVPNdfeNuMZ90q4BqY3bIius86nt5cy6rOj5G2pYPN0racs+aeqB5/Q/zkX+YrLd0hOgZ
        bgpRIHj+KytD28ej2EqhrMSTp4Gnwcc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-E31mPg-WMJ2_5nnlADFGsg-1; Fri, 09 Oct 2020 10:30:13 -0400
X-MC-Unique: E31mPg-WMJ2_5nnlADFGsg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C01018FE860;
        Fri,  9 Oct 2020 14:30:12 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.195.138])
        by smtp.corp.redhat.com (Postfix) with SMTP id DA6226EF7B;
        Fri,  9 Oct 2020 14:30:10 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Fri,  9 Oct 2020 16:30:12 +0200 (CEST)
Date:   Fri, 9 Oct 2020 16:30:09 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Subject: Re: [PATCHSET v4] Add support for TIF_NOTIFY_SIGNAL
Message-ID: <20201009143009.GA14523@redhat.com>
References: <20201008152752.218889-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008152752.218889-1-axboe@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/08, Jens Axboe wrote:
>
> Changes since v3:
> 
> - Drop not needed io_uring change
> - Drop syscall restart split, handle TIF_NOTIFY_SIGNAL from the arch
>   signal handling, using task_sigpending() to see if we need to care
>   about real signals.
> - Fix a few over-zelaous task_sigpending() changes
> - Cleanup WARN_ON() in restore_saved_sigmask_unless()

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

but let me comment 3/4...

