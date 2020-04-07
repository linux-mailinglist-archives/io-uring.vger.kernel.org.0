Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96C1F1A0CD1
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2020 13:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgDGL2j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Apr 2020 07:28:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33331 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725883AbgDGL2j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Apr 2020 07:28:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586258918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cpd+xhU6qMBhiuoJBRL8dJdN/rks+u1ZmPO56qAh7EI=;
        b=A4pbu6QMVB2ZFwGF4WBMB5I1I0i+rwLOzWnGm9ynOchVpjeAKP3YhUS7MyiT8mG8S8BZAb
        d2hvpOPG35drjrApIyXTMe5vwJD+gXyYyBgf+krq870rOWmtOShH4p/CLJ3q4lMIQBTe3a
        Kb8PjeSlV94K1kQR3y6qPtHXkjdY+ns=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-EfYDYnavNxygGxPYPcQWiw-1; Tue, 07 Apr 2020 07:28:36 -0400
X-MC-Unique: EfYDYnavNxygGxPYPcQWiw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 435808017F6;
        Tue,  7 Apr 2020 11:28:35 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.196.88])
        by smtp.corp.redhat.com (Postfix) with SMTP id 31EB79D359;
        Tue,  7 Apr 2020 11:28:33 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Tue,  7 Apr 2020 13:28:35 +0200 (CEST)
Date:   Tue, 7 Apr 2020 13:28:33 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH 1/4] task_work: add task_work_pending() helper
Message-ID: <20200407112833.GA4506@redhat.com>
References: <20200406194853.9896-1-axboe@kernel.dk>
 <20200406194853.9896-2-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200406194853.9896-2-axboe@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/06, Jens Axboe wrote:
>
> +static inline bool task_work_pending(void)
> +{
> +	return current->task_works;
> +}
> +
> +static inline void task_work_run(void)
> +{
> +	if (task_work_pending())
> +		__task_work_run();
> +}

No, this is wrong. exit_task_work() must always call __task_work_run()
to install work_exited.

This helper (and 3/4) probably makes sense but please change exit_task_work()
to use __task_work_run() then.

Oleg.

