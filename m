Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17F461A1149
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2020 18:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgDGQYM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Apr 2020 12:24:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50982 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727874AbgDGQYM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Apr 2020 12:24:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586276651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0cW5+OaXkZPixGyu9jS2mPJ5HByo6pm2DkGA2XGFbEk=;
        b=LZ8ruKhqU7IoA6Ux/k8DePWhiKmo/juH6qQ8/fu/j8L8tkG+EgdxPvuofTaX3t0gTJgjrV
        lgmDUeCTZQPcNYOi78qHhf66zNH8ORMBA5+mKQ46qlh+lwZPwEgw7K4VN5T9GlEr6zfqlG
        iKsgsCk0ZAuWaYaR4zI70Zke2pL8zEI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-WW5sadF0Mnesu9_aIlutKA-1; Tue, 07 Apr 2020 12:24:09 -0400
X-MC-Unique: WW5sadF0Mnesu9_aIlutKA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DE8410CE784;
        Tue,  7 Apr 2020 16:24:08 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.40])
        by smtp.corp.redhat.com (Postfix) with SMTP id 5E14EC0D89;
        Tue,  7 Apr 2020 16:24:07 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Tue,  7 Apr 2020 18:24:08 +0200 (CEST)
Date:   Tue, 7 Apr 2020 18:24:06 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, viro@zeniv.linux.org.uk,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4/4] io_uring: flush task work before waiting for ring
 exit
Message-ID: <20200407162405.GA9655@redhat.com>
References: <20200407160258.933-1-axboe@kernel.dk>
 <20200407160258.933-5-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407160258.933-5-axboe@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/07, Jens Axboe wrote:
>
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7293,10 +7293,15 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
>  		io_wq_cancel_all(ctx->io_wq);
>  
>  	io_iopoll_reap_events(ctx);
> +	idr_for_each(&ctx->personality_idr, io_remove_personalities, ctx);
> +
> +	if (current->task_works != &task_work_exited)
> +		task_work_run();

this is still wrong, please see the email I sent a minute ago.

Oleg.

