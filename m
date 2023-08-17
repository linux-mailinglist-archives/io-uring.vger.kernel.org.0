Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB9677FDFE
	for <lists+io-uring@lfdr.de>; Thu, 17 Aug 2023 20:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354502AbjHQSjL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Aug 2023 14:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354572AbjHQSi7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Aug 2023 14:38:59 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4133AB7;
        Thu, 17 Aug 2023 11:38:50 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id EDA212185F;
        Thu, 17 Aug 2023 18:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1692297528; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xiRLnWYooWdIse820sUkn3VOskBnTLuUjpNFT0aca9A=;
        b=xXQBljOhpGUYUdIAM2snwHchjIJcRKxh2WSkKbzoCROp7glu49dqSlslONL4Xj6SKzYUl8
        LYfbTRuwYfn0Z6Rxe3aqAAIEniz37WZTuUg5erHnqtPGBOvdIOswhYYakdx9h140Vz9vkk
        w6CJEr84wwdOPFM9J4ZeZYjItwIm7sI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1692297528;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xiRLnWYooWdIse820sUkn3VOskBnTLuUjpNFT0aca9A=;
        b=BLrE5EHyIFHBOzEPUzpJHXObnqJqzU+c4bj8RR0I/52qH2n2XSLEsDCXAUDzDjIkoHtF2J
        Z7KT1eP5u1LdD9DA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B15FC1358B;
        Thu, 17 Aug 2023 18:38:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id bB9VIjhp3mRvLQAAMHmgww
        (envelope-from <krisman@suse.de>); Thu, 17 Aug 2023 18:38:48 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Breno Leitao <leitao@debian.org>
Cc:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, martin.lau@linux.dev,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: Re: [PATCH v3 6/9] io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
In-Reply-To: <20230817145554.892543-7-leitao@debian.org> (Breno Leitao's
        message of "Thu, 17 Aug 2023 07:55:51 -0700")
Organization: SUSE
References: <20230817145554.892543-1-leitao@debian.org>
        <20230817145554.892543-7-leitao@debian.org>
Date:   Thu, 17 Aug 2023 14:38:46 -0400
Message-ID: <87zg2p345l.fsf@suse.de>
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

> +#if defined(CONFIG_NET)
>  int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
>  {
>  	struct socket *sock = cmd->file->private_data;
> @@ -189,8 +219,16 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
>  		if (ret)
>  			return ret;
>  		return arg;
> +	case SOCKET_URING_OP_GETSOCKOPT:
> +		return io_uring_cmd_getsockopt(sock, cmd, issue_flags);
>  	default:
>  		return -EOPNOTSUPP;
>  	}
>  }
> +#else
> +int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
> +{
> +	return -EOPNOTSUPP;
> +}
> +#endif
>  EXPORT_SYMBOL_GPL(io_uring_cmd_sock);

The CONFIG_NET guards are unrelated and need to go in a separate commit.
Specially because it is not only gating getsockopt, but also the already
merged SOCKET_URING_OP_SIOCINQ/_OP_SIOCOUTQ.

-- 
Gabriel Krisman Bertazi
