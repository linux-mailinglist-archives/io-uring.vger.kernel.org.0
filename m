Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4C61A39FF
	for <lists+io-uring@lfdr.de>; Thu,  9 Apr 2020 20:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgDISus (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Apr 2020 14:50:48 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37235 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725987AbgDISus (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Apr 2020 14:50:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586458247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0FI6+zx4SVRbHJj7p6NeuCLtnSETKk6g+UvcxgUhHPw=;
        b=EQ2IsB99zUlPbhtRMdwqIuRU1iVqqO/8KHFNjlN/uYTq9dlXejvgc1Wz20KHPIAg8fMJux
        gGFEhv4ka9ec6uChIqXoGATHJyuwO/TyeSje3agjAqnRG3KsMG02qpc4rGaYQntG8ZV0Wh
        RsW9AmoLKH91vKdir9RYzNAZHCJxtLg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-15qLXLnqPrC9cfEhwj1iDQ-1; Thu, 09 Apr 2020 14:50:45 -0400
X-MC-Unique: 15qLXLnqPrC9cfEhwj1iDQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65189800D5B;
        Thu,  9 Apr 2020 18:50:44 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.42])
        by smtp.corp.redhat.com (Postfix) with SMTP id E6CBF272AA;
        Thu,  9 Apr 2020 18:50:42 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu,  9 Apr 2020 20:50:44 +0200 (CEST)
Date:   Thu, 9 Apr 2020 20:50:41 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, viro@zeniv.linux.org.uk,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4/4] io_uring: flush task work before waiting for ring
 exit
Message-ID: <20200409185041.GA14251@redhat.com>
References: <20200407160258.933-1-axboe@kernel.dk>
 <20200407160258.933-5-axboe@kernel.dk>
 <20200407162405.GA9655@redhat.com>
 <20200407163816.GB9655@redhat.com>
 <4b70317a-d12a-6c29-1d7f-1394527f9676@kernel.dk>
 <20200408184049.GA25918@redhat.com>
 <a31dfee4-8125-a3c1-4be6-bd4a3f71b301@kernel.dk>
 <6d320b43-254d-2d42-cbad-d323f1532e65@kernel.dk>
 <20200408201734.GA21347@redhat.com>
 <884c70e0-2ec5-7ae6-7484-2bbbf4aa3e5d@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <884c70e0-2ec5-7ae6-7484-2bbbf4aa3e5d@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/08, Jens Axboe wrote:
>
> So the question remains, we basically have this:
>
> A			B
> task_work_run(tsk)
> 			task_work_add(tsk, io_poll_task_func())
> process cbs
> wait_for_completion()
>
> with the last wait needing to flush the work added on the B side, since
> that isn't part of the initial list.

I don't understand you, even remotely :/

maybe you can write some pseudo-code ?

who does wait_for_completion(), a callback? or this "tsk" after it does
task_work_run() ? Who does complete() ? How can this wait_for_completion()
help to flush the work added on the B side? And why do you need to do
something special to flush that work?

Could you also explain the comment above task_work_add() in
__io_async_wake() ?


	If this fails, then the task is exiting.

OK,

	If that is the case, then the exit check

which exit check?

	will ultimately cancel these work items.

what does this mean? there is nothing to cancel if task_work_add() fails,
I guess this means something else...

Oleg.

