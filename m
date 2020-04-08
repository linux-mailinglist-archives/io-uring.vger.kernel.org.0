Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE5CF1A2A33
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 22:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729171AbgDHURm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 16:17:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20382 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726891AbgDHURl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 16:17:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586377060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lvTUjClSIk6Xg1FhK+FIzfVynQfhbiCCXnBY/h7tDyw=;
        b=OorNDeymrqxa+0POQML7+SAJ0nnCIsqxIvc9apqIpUXVMv3Ol2tULNi7JpoZeFqV8TKMf3
        Hc0BTNsh05hfnTLYkjzpxYnyGNKGaCF5Ajl31F0q83RI7anvxjSFqsVMSKutffXXV5Q1p8
        eB0wbhsx2HN9kRQE2vAu3C8HXvgdUrA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-E3xDWTSeOzGLQTAKTRE2-w-1; Wed, 08 Apr 2020 16:17:38 -0400
X-MC-Unique: E3xDWTSeOzGLQTAKTRE2-w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E5571084426;
        Wed,  8 Apr 2020 20:17:37 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.143])
        by smtp.corp.redhat.com (Postfix) with SMTP id 1762460BFB;
        Wed,  8 Apr 2020 20:17:35 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Wed,  8 Apr 2020 22:17:37 +0200 (CEST)
Date:   Wed, 8 Apr 2020 22:17:35 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, viro@zeniv.linux.org.uk,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4/4] io_uring: flush task work before waiting for ring
 exit
Message-ID: <20200408201734.GA21347@redhat.com>
References: <20200407160258.933-1-axboe@kernel.dk>
 <20200407160258.933-5-axboe@kernel.dk>
 <20200407162405.GA9655@redhat.com>
 <20200407163816.GB9655@redhat.com>
 <4b70317a-d12a-6c29-1d7f-1394527f9676@kernel.dk>
 <20200408184049.GA25918@redhat.com>
 <a31dfee4-8125-a3c1-4be6-bd4a3f71b301@kernel.dk>
 <6d320b43-254d-2d42-cbad-d323f1532e65@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d320b43-254d-2d42-cbad-d323f1532e65@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/08, Jens Axboe wrote:
>
> Here's some more data. I added a WARN_ON_ONCE() for task->flags &
> PF_EXITING on task_work_add() success, and it triggers with the
> following backtrace:
...
> which means that we've successfully added the task_work while the
> process is exiting.

but this is fine, task_work_add(task) can succeed if task->flags & EXITING.

task_work_add(task, work) should only fail if this "task" has already passed
exit_task_work(). Because if this task has already passed exit_task_work(),
nothing else can flush this work and call work->func().

Oleg.

