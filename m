Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F37344AFA
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 17:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbhCVQSs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Mar 2021 12:18:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29242 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231605AbhCVQSa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Mar 2021 12:18:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616429909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i5OZl+2uG3qd5KjzQMzycc1zUhTUOaFHbDQTpG9xOvc=;
        b=YPQWy7RiWrSQ84GUsoPNWAssobf5RwLsgA9twwDowp1BDwq+WKQEDrRm635zepBCF5GoZI
        potBOyuFoVvymwBBlaN4QiKEmmTnjjhH7YlEukewlvXTVV9njsFERG7Krw2q4W8B0Tkz93
        ubC0csPNZY7d5pzUnTfBR1JSNfptJS4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-KLWOxJSgNQazoZUoCy9bjw-1; Mon, 22 Mar 2021 12:18:27 -0400
X-MC-Unique: KLWOxJSgNQazoZUoCy9bjw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45A6785EE8B;
        Mon, 22 Mar 2021 16:18:26 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.194.114])
        by smtp.corp.redhat.com (Postfix) with SMTP id 540E160C0F;
        Mon, 22 Mar 2021 16:18:24 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Mon, 22 Mar 2021 17:18:25 +0100 (CET)
Date:   Mon, 22 Mar 2021 17:18:23 +0100
From:   Oleg Nesterov <oleg@redhat.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH 2/2] signal: don't allow STOP on PF_IO_WORKER threads
Message-ID: <20210322161822.GC20390@redhat.com>
References: <20210320153832.1033687-1-axboe@kernel.dk>
 <20210320153832.1033687-3-axboe@kernel.dk>
 <m1sg4paj8h.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1sg4paj8h.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 03/20, Eric W. Biederman wrote:
>
> But please tell me why is it not the right thing to have the io_uring
> helper threads stop?  Why is it ok for that process to go on consuming
> cpu resources in a non-stoppable way.

Yes, I have the same question ;)

Oleg.

