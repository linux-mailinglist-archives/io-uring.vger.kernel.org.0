Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF72757D61
	for <lists+io-uring@lfdr.de>; Tue, 18 Jul 2023 15:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbjGRNZY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Jul 2023 09:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbjGRNZQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Jul 2023 09:25:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEE6D1
        for <io-uring@vger.kernel.org>; Tue, 18 Jul 2023 06:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689686672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dgledF1WRoLwrfDvjbydZH7nQLxGFefypqZhBkMsdxg=;
        b=JbtM9jiBJvSJJeW2EOW85Wzert9tpZG5fev0BV7dVyx+omX11G5irSBWEYUi8F6PpQ7i3R
        aG3jm4ul21dJZDpYlGRQyXU6QOlN7RI/nHfpu9Wpfor0xaVhf08knKi29cv1Nh03UqUJQ7
        irbTE7acMOOCjyNazPoRzOIEMJkllY4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-241-Tkt302CUP3iz11o0VtpMww-1; Tue, 18 Jul 2023 09:24:28 -0400
X-MC-Unique: Tkt302CUP3iz11o0VtpMww-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6965A8D168D;
        Tue, 18 Jul 2023 13:24:28 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E9E42166B25;
        Tue, 18 Jul 2023 13:24:28 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] io_uring: don't audit the capability check in io_uring_create()
References: <20230718115607.65652-1-omosnace@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Tue, 18 Jul 2023 09:30:18 -0400
In-Reply-To: <20230718115607.65652-1-omosnace@redhat.com> (Ondrej Mosnacek's
        message of "Tue, 18 Jul 2023 13:56:07 +0200")
Message-ID: <x49lefd4aad.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi, Ondrej,

Ondrej Mosnacek <omosnace@redhat.com> writes:

> The check being unconditional may lead to unwanted denials reported by
> LSMs when a process has the capability granted by DAC, but denied by an
> LSM. In the case of SELinux such denials are a problem, since they can't
> be effectively filtered out via the policy and when not silenced, they
> produce noise that may hide a true problem or an attack.
>
> Since not having the capability merely means that the created io_uring
> context will be accounted against the current user's RLIMIT_MEMLOCK
> limit, we can disable auditing of denials for this check by using
> ns_capable_noaudit() instead of capable().

Could you add a comment, or add some documentation to
ns_capable_noaudit() about when it should be used?  It wasn't apparent
to me, at least, before this explanation.

> Fixes: 2b188cc1bb85 ("Add io_uring IO interface")
> Link: https://bugzilla.redhat.com/show_bug.cgi?id=2193317
> Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
> ---
>  io_uring/io_uring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 7505de2428e03..a9923676d16d6 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3870,7 +3870,7 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
>  		ctx->syscall_iopoll = 1;
>  
>  	ctx->compat = in_compat_syscall();
> -	if (!capable(CAP_IPC_LOCK))
> +	if (!ns_capable_noaudit(&init_user_ns, CAP_IPC_LOCK))
>  		ctx->user = get_uid(current_user());
>  
>  	/*

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

