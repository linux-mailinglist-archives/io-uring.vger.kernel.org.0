Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E750C28F54E
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 16:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389399AbgJOOyJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 10:54:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42154 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388348AbgJOOyI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 10:54:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602773647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z4+pIlbp7Cy6qMJUZsGdnt36WSG6eee++gYbihv/3Cg=;
        b=iLga+9YIStp0YRqL2CgQNmDZ+z51vv8qxcGLx6xCoJuYsYfXt1lHak2RDblJeaulTnwxcu
        5m6POu45Ce0GK1L9cgZVWk72sdoIRbaUckByAFtNgKUVg9ADwjzv3Un03F1thBziQSIHyi
        QReAmfNhPDX15U6Ncv5OfMBTkqMgvmw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-523-RzgRUKdEPCyLDDr0nlz12A-1; Thu, 15 Oct 2020 10:54:03 -0400
X-MC-Unique: RzgRUKdEPCyLDDr0nlz12A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55FAA18A822A;
        Thu, 15 Oct 2020 14:54:02 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.193.8])
        by smtp.corp.redhat.com (Postfix) with SMTP id DAC535C1BD;
        Thu, 15 Oct 2020 14:54:00 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu, 15 Oct 2020 16:54:02 +0200 (CEST)
Date:   Thu, 15 Oct 2020 16:53:59 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH 3/5] kernel: add support for TIF_NOTIFY_SIGNAL
Message-ID: <20201015145359.GA14671@redhat.com>
References: <20201015131701.511523-1-axboe@kernel.dk>
 <20201015131701.511523-4-axboe@kernel.dk>
 <20201015143151.GB24156@redhat.com>
 <5d231aa1-b8c7-ae4e-90bb-211f82b57547@kernel.dk>
 <20201015143728.GE24156@redhat.com>
 <788b31b7-6acc-cc85-5e91-d0c2538341b7@kernel.dk>
 <20201015144713.GJ24156@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015144713.GJ24156@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/15, Oleg Nesterov wrote:
>
> On 10/15, Jens Axboe wrote:
> >
> > That is indeed a worry. From a functionality point of view, with the
> > major archs supporting it, I'm not too worried about that side. But it
> > does mean that we'll be stuck with the ifdeffery forever, which isn't
> > great.
>
> plus we can't kill the ugly JOBCTL_TASK_WORK.

not to mention we can not change freezer/livepatch to use NOTIFY_SIGNAL,
or add new users of set_notify_signal().

Oleg.

