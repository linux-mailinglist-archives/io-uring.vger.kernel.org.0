Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F2E34A8EF
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 14:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhCZNt1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 09:49:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27809 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230226AbhCZNtV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 09:49:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616766561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wftucUMFQaOllmombeSNT//n1WKcSqJM+IZ/swXQYUo=;
        b=ZvQPfMZgnQ7ms/mxiGZ/3CtAD5atccgOC5WAXoh/iztj9oNUbUVVDVBz1PstdgAcd5v6uW
        ywxFVCsEFSh+4hLZsev/fIACwtofoo3XUCWrbDhlmBq9zk+TedlveexoPfuJRtrjJdEXw+
        MaUAwwVs3XzM6SHfkoTeTD2v1+Vlvsk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-lziEHDBGP-CIEoy5rswQLQ-1; Fri, 26 Mar 2021 09:49:16 -0400
X-MC-Unique: lziEHDBGP-CIEoy5rswQLQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 270B796DD14;
        Fri, 26 Mar 2021 13:48:45 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.194.37])
        by smtp.corp.redhat.com (Postfix) with SMTP id BB21A6062F;
        Fri, 26 Mar 2021 13:48:42 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Fri, 26 Mar 2021 14:48:44 +0100 (CET)
Date:   Fri, 26 Mar 2021 14:48:41 +0100
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, torvalds@linux-foundation.org,
        ebiederm@xmission.com, metze@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] kernel: unmask SIGSTOP for IO threads
Message-ID: <20210326134840.GA1290@redhat.com>
References: <20210326003928.978750-1-axboe@kernel.dk>
 <20210326003928.978750-3-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326003928.978750-3-axboe@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens, sorry, I got lost :/

On 03/25, Jens Axboe wrote:
>
> With IO threads accepting signals, including SIGSTOP,

where can I find this change? Looks like I wasn't cc'ed...

> unmask the
> SIGSTOP signal from the default blocked mask.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  kernel/fork.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index d3171e8e88e5..d5a40552910f 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -2435,7 +2435,7 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
>  	tsk = copy_process(NULL, 0, node, &args);
>  	if (!IS_ERR(tsk)) {
>  		sigfillset(&tsk->blocked);
> -		sigdelsetmask(&tsk->blocked, sigmask(SIGKILL));
> +		sigdelsetmask(&tsk->blocked, sigmask(SIGKILL)|sigmask(SIGSTOP));

siginitsetinv(blocked, sigmask(SIGKILL)|sigmask(SIGSTOP)) but this is minor.

To remind, either way this is racy and can't really help.

And if "IO threads accepting signals" then I don't understand why. Sorry,
I must have missed something.

Oleg.

