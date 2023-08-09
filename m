Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4163F776527
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 18:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbjHIQch (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 12:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjHIQcg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 12:32:36 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F5710F3;
        Wed,  9 Aug 2023 09:32:35 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B52B71F390;
        Wed,  9 Aug 2023 16:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1691598754; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7QFcbq83iTfdOitDUN6evIcZyqpeTumZWQXVO5WSyTw=;
        b=w1WP5bAZE/zSuw7kqB93vtowYM7zVuuhl8Rc2SRSan8LvPe8Lfx2xAZ7f327XDzSDFoVOM
        HE+jCPblCOa+kKKjgT5n+lBklNdbXAIipUBF4mp0nnMwXIjyyl/C7J7fjSmb6FaNeYkO/b
        ZxPpcHNe2bgsaMb5k8sMMUurew7OBP0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1691598754;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7QFcbq83iTfdOitDUN6evIcZyqpeTumZWQXVO5WSyTw=;
        b=5O/IJFSzRRrH1RkxV+y6NJZEypfhjSGMjUDCaG74+GsY1CDQkTgw5zNxPnqqCq1bWIWHNY
        XSDjMn6ZbnYO8CCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 60335133B5;
        Wed,  9 Aug 2023 16:32:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id voffEaK/02TLZgAAMHmgww
        (envelope-from <krisman@suse.de>); Wed, 09 Aug 2023 16:32:34 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Breno Leitao <leitao@debian.org>
Cc:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        io-uring@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v2 4/8] io_uring/cmd: Extend support beyond SOL_SOCKET
In-Reply-To: <20230808134049.1407498-5-leitao@debian.org> (Breno Leitao's
        message of "Tue, 8 Aug 2023 06:40:44 -0700")
References: <20230808134049.1407498-1-leitao@debian.org>
        <20230808134049.1407498-5-leitao@debian.org>
Date:   Wed, 09 Aug 2023 12:32:33 -0400
Message-ID: <871qgc89cu.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Breno Leitao <leitao@debian.org> writes:

> Add generic support for SOCKET_URING_OP_SETSOCKOPT, expanding the
> current case, that just execute if level is SOL_SOCKET.
>
> This implementation basically calls sock->ops->setsockopt() with a
> kernel allocated optval;
>
> Since the callback for ops->setsockopt() is already using sockptr_t,
> then the callbacks are leveraged to be called directly, similarly to
> __sys_setsockopt().
>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  io_uring/uring_cmd.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 5404b788ca14..dbba005a7290 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -205,10 +205,14 @@ static inline int io_uring_cmd_setsockopt(struct socket *sock,
>  	if (err)
>  		return err;
>  
> -	err = -EOPNOTSUPP;
>  	if (level == SOL_SOCKET && !sock_use_custom_sol_socket(sock))
>  		err = sock_setsockopt(sock, level, optname,
>  				      USER_SOCKPTR(optval), optlen);
> +	else if (unlikely(!sock->ops->setsockopt))
> +		err = -EOPNOTSUPP;
> +	else
> +		err = sock->ops->setsockopt(sock, level, optname,
> +					    USER_SOCKPTR(koptval), optlen);

Perhaps move this logic into a helper in net/ so io_uring doesn't need
to know details of struct socket and there is no duplication of this code
in __sys_getsockopt.

>  	return err;
>  }

-- 
Gabriel Krisman Bertazi
