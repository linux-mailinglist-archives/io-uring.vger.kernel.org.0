Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9869279B549
	for <lists+io-uring@lfdr.de>; Tue, 12 Sep 2023 02:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237987AbjIKWKJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Sep 2023 18:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242599AbjIKPyF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Sep 2023 11:54:05 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221B4193;
        Mon, 11 Sep 2023 08:54:01 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D02C021858;
        Mon, 11 Sep 2023 15:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1694447639; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w1hU2rySzchPvfa0Wrv+/KzNAllK1m5RVyNxjuW0p78=;
        b=P/ihoVSGa95xiemo3MTPD96SZx5qps7CdKbeHaotHJ6dKb/WrX1hQ8UmJu5t30xLUrQkdf
        ZaMsiNXgVEyNOHEQYTMGlkEz/CaYvaoXL2hK56fFN8mlphFYmgk8/f+oxK8saKV1VYUsju
        E0zpK/64S1G4tobdIazXal9MXF+1ar8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1694447639;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w1hU2rySzchPvfa0Wrv+/KzNAllK1m5RVyNxjuW0p78=;
        b=hz1uI0y1MedAGwyeWiiY5Eh+W+SEWc3LQ//38EsqFtkHMtSJe2vSwvuhfRefgC/GZIaKTR
        D4LHrr/4TDlgi8Ag==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9920013780;
        Mon, 11 Sep 2023 15:53:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id kmfoHxc4/2S/dwAAMHmgww
        (envelope-from <krisman@suse.de>); Mon, 11 Sep 2023 15:53:59 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Breno Leitao <leitao@debian.org>
Cc:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        martin.lau@linux.dev, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        io-uring@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v5 5/8] io_uring/cmd: return -EOPNOTSUPP if net is disabled
In-Reply-To: <20230911103407.1393149-6-leitao@debian.org> (Breno Leitao's
        message of "Mon, 11 Sep 2023 03:34:04 -0700")
Organization: SUSE
References: <20230911103407.1393149-1-leitao@debian.org>
        <20230911103407.1393149-6-leitao@debian.org>
Date:   Mon, 11 Sep 2023 11:53:58 -0400
Message-ID: <87ledc904p.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Breno Leitao <leitao@debian.org> writes:

> Protect io_uring_cmd_sock() to be called if CONFIG_NET is not set. If
> network is not enabled, but io_uring is, then we want to return
> -EOPNOTSUPP for any possible socket operation.
>
> This is helpful because io_uring_cmd_sock() can now call functions that
> only exits if CONFIG_NET is enabled without having #ifdef CONFIG_NET
> inside the function itself.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  io_uring/uring_cmd.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 60f843a357e0..a7d6a7d112b7 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -167,6 +167,7 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
>  }
>  EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
>  
> +#if defined(CONFIG_NET)
>  int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
>  {
>  	struct socket *sock = cmd->file->private_data;
> @@ -193,3 +194,10 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
>  	}
>  }
>  EXPORT_SYMBOL_GPL(io_uring_cmd_sock);
> +#else
> +int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
> +{
> +	return -EOPNOTSUPP;
> +}
> +#endif
> +

Is net/socket.c even built without CONFIG_NET? if not, you don't even need
the alternative EOPNOTSUPP implementation.

-- 
Gabriel Krisman Bertazi
