Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C37782CB3
	for <lists+io-uring@lfdr.de>; Mon, 21 Aug 2023 16:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234951AbjHUOxB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Aug 2023 10:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbjHUOxB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Aug 2023 10:53:01 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F132CE7;
        Mon, 21 Aug 2023 07:52:59 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B5ABE206BB;
        Mon, 21 Aug 2023 14:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1692629578; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QCjXCnPDxOs923ALySYO+egjUMFkHrYnb55t/mqxA30=;
        b=V1XTWVeOOeVuqsNjcIbWLkgmI9dPJjxKdT4XVaUFHawfixjrskStbJgu9oQtrFO4Bc67bT
        2oJhmuPjIuzmhVnNUyYXRiwTbQErsY55Btk0bdUEgp2KeHX/RQonZiQIkXQytUaX5aFKU5
        YZ/dmNV0YVmsR6n+tEhrHZ8AbImN4Vs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1692629578;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QCjXCnPDxOs923ALySYO+egjUMFkHrYnb55t/mqxA30=;
        b=fLW8urHOpCj8AN47m9hJpBCuC2pv1VSxqCNUFa7EfIe6j0uavttXOFx4GTXhoX/sJHU0lS
        T2rTtIwR2T95rUBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 75D1C13421;
        Mon, 21 Aug 2023 14:52:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7J/qFkp642TLDAAAMHmgww
        (envelope-from <krisman@suse.de>); Mon, 21 Aug 2023 14:52:58 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Breno Leitao <leitao@debian.org>
Cc:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, martin.lau@linux.dev,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: Re: [PATCH v3 6/9] io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
In-Reply-To: <ZOMpxrTzvSGQRwYi@gmail.com> (Breno Leitao's message of "Mon, 21
        Aug 2023 02:09:26 -0700")
Organization: SUSE
References: <20230817145554.892543-1-leitao@debian.org>
        <20230817145554.892543-7-leitao@debian.org> <87zg2p345l.fsf@suse.de>
        <ZOMpxrTzvSGQRwYi@gmail.com>
Date:   Mon, 21 Aug 2023 10:52:57 -0400
Message-ID: <87fs4co3au.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Breno Leitao <leitao@debian.org> writes:

> Hello Gabriel,
>
> On Thu, Aug 17, 2023 at 02:38:46PM -0400, Gabriel Krisman Bertazi wrote:
>> Breno Leitao <leitao@debian.org> writes:
>> 
>> > +#if defined(CONFIG_NET)
>> >  int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
>> >  {
>> >  	struct socket *sock = cmd->file->private_data;
>> > @@ -189,8 +219,16 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
>> >  		if (ret)
>> >  			return ret;
>> >  		return arg;
>> > +	case SOCKET_URING_OP_GETSOCKOPT:
>> > +		return io_uring_cmd_getsockopt(sock, cmd, issue_flags);
>> >  	default:
>> >  		return -EOPNOTSUPP;
>> >  	}
>> >  }
>> > +#else
>> > +int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
>> > +{
>> > +	return -EOPNOTSUPP;
>> > +}
>> > +#endif
>> >  EXPORT_SYMBOL_GPL(io_uring_cmd_sock);
>> 
>> The CONFIG_NET guards are unrelated and need to go in a separate commit.
>> Specially because it is not only gating getsockopt, but also the already
>> merged SOCKET_URING_OP_SIOCINQ/_OP_SIOCOUTQ.
>
> Well, so far, if CONFIG_NET is disable, and you call
> io_uring_cmd_getsockopt, the callbacks will be called and returned
> -EOPNOTSUPP.

I'm not talking about io_uring_cmd_getsockopt; that would obviously
return -EOPNOTSUPP before as well.  But you are changing
io_uring_cmd_sock, which does more things:

int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
{
        [...]
	if (!prot || !prot->ioctl)
		return -EOPNOTSUPP;

	switch (cmd->sqe->cmd_op) {
	case SOCKET_URING_OP_SIOCINQ:
		ret = prot->ioctl(sk, SIOCINQ, &arg);
		if (ret)
			return ret;
		return arg;
	case SOCKET_URING_OP_SIOCOUTQ:
		ret = prot->ioctl(sk, SIOCOUTQ, &arg);
		if (ret)
			return ret;

With your patch, these two cmd_op, are now being gated by CONFIG_NET.  I
think it makes sense for them to be gated by it, But it should
be in a separated change, or at least explained in your commit message.

> With this new patch, it will eventually call sk_getsockopt which does
> not exist in the CONFIG_NET=n world. That is why I have this
> protection now. I.e, this `#if defined(CONFIG_NET)` is only necessary now,
> since it is the first time this function (io_uring_cmd_sock) will call a
> function that does not exist if CONFIG_NET is disabled.
>
> I can split it in a different patch, if you think it makes a difference.

-- 
Gabriel Krisman Bertazi
