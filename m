Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9D5D1A12DE
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2020 19:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgDGRnP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Apr 2020 13:43:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59541 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726277AbgDGRnP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Apr 2020 13:43:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586281394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fz8RXTxqR4xxIJ+lQRVm0tOodyNrfzxxJL13ceKgfdU=;
        b=UtkTxo5dMfXzLjxlnfndueD7eIWQsY6itmOgGLmRfNanDbZVK60ZjSdin6OD7SOSvzkafa
        FikdKOqxp6YjM2Cw3KC7xLHqcJBHOhzp971rfBHksNCgJOepdgvIJIFsaXjpGhf5HKNhuq
        NLQPDeYQtyxgkOTH20UMCFljhe1+3U0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-M3qpbJ-4M4qxJMqTOCBlZg-1; Tue, 07 Apr 2020 13:43:12 -0400
X-MC-Unique: M3qpbJ-4M4qxJMqTOCBlZg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B12A113FA;
        Tue,  7 Apr 2020 17:43:11 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.40])
        by smtp.corp.redhat.com (Postfix) with SMTP id A44441BC6D;
        Tue,  7 Apr 2020 17:43:10 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Tue,  7 Apr 2020 19:43:11 +0200 (CEST)
Date:   Tue, 7 Apr 2020 19:43:09 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH 2/4] task_work: don't run task_work if task_work_exited
 is queued
Message-ID: <20200407174309.GA11784@redhat.com>
References: <20200406194853.9896-1-axboe@kernel.dk>
 <20200406194853.9896-3-axboe@kernel.dk>
 <20200407113927.GB4506@redhat.com>
 <147b85ab-12f0-49f7-900a-a1cb0182a3f1@kernel.dk>
 <20200407161913.GA10846@redhat.com>
 <8ce5fd3f-2f6b-e0da-9db0-26c09c5320a6@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ce5fd3f-2f6b-e0da-9db0-26c09c5320a6@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens,

I'll read your email tomorrow, just one note for now ...

On 04/07, Jens Axboe wrote:
>
> On 4/7/20 9:19 AM, Oleg Nesterov wrote:
> >
> > but this task has not passed exit_task_work(),
>
> But it's definitely hitting callback->func == NULL, which is the
> exit_work. So if it's not from past exit_task_work(), where is it from?

I guess it comes from task_work_run() added by the next patch ;)

> I see your newer email on this, I'll go read it.

please look at the "bad_work_func" example.

Oleg.

