Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111B5782EFF
	for <lists+io-uring@lfdr.de>; Mon, 21 Aug 2023 19:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236832AbjHURDO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Aug 2023 13:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236867AbjHURDN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Aug 2023 13:03:13 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFFAEE;
        Mon, 21 Aug 2023 10:03:11 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 13DAC22C36;
        Mon, 21 Aug 2023 17:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1692637390; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SLJykvxuZvqJ+C4mN0x9FvUi2rRqmrHd1orjK7FFMsI=;
        b=fr+7s4BC6VeEFmYTKeLSlLmCmG4kqom83BSHYONhbsPm/dy0Z7tC+7gbjWSoPBFyHpycNq
        efbc0AwMv4JeFOILdc4qEKvaUHA7b1ZXRdhGl+jtrsv8DOjWFdCh6ihMNpuWM7zsGxE7ew
        rcedEbMxJUH31F6sEzqcihuDPleH9n0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1692637390;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SLJykvxuZvqJ+C4mN0x9FvUi2rRqmrHd1orjK7FFMsI=;
        b=cMNGb62gPZo/M23xiXN3LVNbAaeKgjjWWp6dJudi7Q3YjsA/Fh7TOX31foIq4KAURCLVgm
        naLMFN4SvWRf5sAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CF9FA13421;
        Mon, 21 Aug 2023 17:03:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id YTjtLM2Y42TsSAAAMHmgww
        (envelope-from <krisman@suse.de>); Mon, 21 Aug 2023 17:03:09 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Breno Leitao <leitao@debian.org>
Cc:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, martin.lau@linux.dev,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: Re: [PATCH v3 8/9] io_uring/cmd: BPF hook for getsockopt cmd
In-Reply-To: <ZOMrD1DHeys0nFwt@gmail.com> (Breno Leitao's message of "Mon, 21
        Aug 2023 02:14:55 -0700")
Organization: SUSE
References: <20230817145554.892543-1-leitao@debian.org>
        <20230817145554.892543-9-leitao@debian.org> <87pm3l32rk.fsf@suse.de>
        <ZOMrD1DHeys0nFwt@gmail.com>
Date:   Mon, 21 Aug 2023 13:03:08 -0400
Message-ID: <875y58nx9v.fsf@suse.de>
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

> On Thu, Aug 17, 2023 at 03:08:47PM -0400, Gabriel Krisman Bertazi wrote:
>> Breno Leitao <leitao@debian.org> writes:
>> 
>> > Add BPF hook support for getsockopts io_uring command. So, BPF cgroups
>> > programs can run when SOCKET_URING_OP_GETSOCKOPT command is executed
>> > through io_uring.
>> >
>> > This implementation follows a similar approach to what
>> > __sys_getsockopt() does, but, using USER_SOCKPTR() for optval instead of
>> > kernel pointer.
>> >
>> > Signed-off-by: Breno Leitao <leitao@debian.org>
>> > ---
>> >  io_uring/uring_cmd.c | 18 +++++++++++++-----
>> >  1 file changed, 13 insertions(+), 5 deletions(-)
>> >
>> > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>> > index a567dd32df00..9e08a14760c3 100644
>> > --- a/io_uring/uring_cmd.c
>> > +++ b/io_uring/uring_cmd.c
>> > @@ -5,6 +5,8 @@
>> >  #include <linux/io_uring.h>
>> >  #include <linux/security.h>
>> >  #include <linux/nospec.h>
>> > +#include <linux/compat.h>
>> > +#include <linux/bpf-cgroup.h>
>> >  
>> >  #include <uapi/linux/io_uring.h>
>> >  #include <uapi/asm-generic/ioctls.h>
>> > @@ -184,17 +186,23 @@ static inline int io_uring_cmd_getsockopt(struct socket *sock,
>> >  	if (err)
>> >  		return err;
>> >  
>> > -	if (level == SOL_SOCKET) {
>> > +	err = -EOPNOTSUPP;
>> > +	if (level == SOL_SOCKET)
>> >  		err = sk_getsockopt(sock->sk, level, optname,
>> >  				    USER_SOCKPTR(optval),
>> >  				    KERNEL_SOCKPTR(&optlen));
>> > -		if (err)
>> > -			return err;
>> >  
>> > +	if (!(issue_flags & IO_URING_F_COMPAT))
>> > +		err = BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock->sk, level,
>> > +						     optname,
>> > +						     USER_SOCKPTR(optval),
>> > +						     KERNEL_SOCKPTR(&optlen),
>> > +						     optlen, err);
>> > +
>> > +	if (!err)
>> >  		return optlen;
>> > -	}
>> 
>> Shouldn't you call sock->ops->getsockopt for level!=SOL_SOCKET prior to
>> running the hook?
>> Before this patch, it would bail out with EOPNOTSUPP,
>> but now the bpf hook gets called even for level!=SOL_SOCKET, which
>> doesn't fit __sys_getsockopt. Am I misreading the code?
>
> Not really, sock->ops->getsockopt() does not suport sockptr_t, but
> __user addresses, differently from setsockopt()
>
>           int             (*setsockopt)(struct socket *sock, int level,
>                                         int optname, sockptr_t optval,
>                                         unsigned int optlen);
>           int             (*getsockopt)(struct socket *sock, int level,
>                                         int optname, char __user *optval, int __user *optlen);
>
> In order to be able to call sock->ops->getsockopt(), the callback
> function will need to accepted sockptr.

So, it seems you won't support !SOL_SOCKETs here.  Then, I think you
shouldn't call the hook for those sockets. My main concern is that we
remain compatible to __sys_getsockopt when invoking the hook.

I think you should just have the following as the very first thing in
the function (but after the security_ check).

if (level != SOL_SOCKET)
   return -EOPNOTSUPP;

-- 
Gabriel Krisman Bertazi
