Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDE81A1117
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2020 18:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgDGQTU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Apr 2020 12:19:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23187 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726840AbgDGQTU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Apr 2020 12:19:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586276359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dhbqGHFXDy82pRnNwaVgdnhasKMp9NRZeIKtdS8n57Q=;
        b=bxT6UzAHVvZM7olSpI0goA+uTrPjUv1UKHbYplmy0w2udx1d3dMQn4//3F38mRlOjH0tRv
        MZ1dGhpnlSm1udK3WoeyamTBbxqYM/IM00H/Tq/rUZigsh/yOHXj3Gkn0BqRj6daBmGMUV
        +c/BF+BZRoHQcj+d6QJ/UlV878RHKxA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-wYU4n4QiNdyAcW9HpBTH7w-1; Tue, 07 Apr 2020 12:19:17 -0400
X-MC-Unique: wYU4n4QiNdyAcW9HpBTH7w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 60AB31922966;
        Tue,  7 Apr 2020 16:19:16 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.40])
        by smtp.corp.redhat.com (Postfix) with SMTP id 4D2FC19C70;
        Tue,  7 Apr 2020 16:19:14 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Tue,  7 Apr 2020 18:19:16 +0200 (CEST)
Date:   Tue, 7 Apr 2020 18:19:13 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH 2/4] task_work: don't run task_work if task_work_exited
 is queued
Message-ID: <20200407161913.GA10846@redhat.com>
References: <20200406194853.9896-1-axboe@kernel.dk>
 <20200406194853.9896-3-axboe@kernel.dk>
 <20200407113927.GB4506@redhat.com>
 <147b85ab-12f0-49f7-900a-a1cb0182a3f1@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147b85ab-12f0-49f7-900a-a1cb0182a3f1@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/07, Jens Axboe wrote:
>
> On 4/7/20 4:39 AM, Oleg Nesterov wrote:
> >
> > IIUC, this is needed for the next change which adds task_work_run() into
> > io_ring_ctx_wait_and_kill(), right?
>
> Right - so you'd rather I localize that check there instead? Can certainly
> do that.

I am still not sure we need this check at all... probably this is because
I don't understand the problem.

> > could you explain how the exiting can call io_ring_ctx_wait_and_kill()
> > after it passed exit_task_work() ?
>
> Sure, here's a trace where it happens:

but this task has not passed exit_task_work(),

>  __task_work_run+0x66/0xa0
>  io_ring_ctx_wait_and_kill+0x14e/0x3c0
>  io_uring_release+0x1c/0x20
>  __fput+0xaa/0x200
>  __task_work_run+0x66/0xa0
>  do_exit+0x9cf/0xb40

So task_work_run() is called recursively from exit_task_work()->task_work_run().
See my another email, this is wrong with or without this series. And that is
why I think task_work_run() hits work_exited.

Could you explain why io_ring_ctx_wait_and_kill() needs task_work_run() ?

Oleg.

