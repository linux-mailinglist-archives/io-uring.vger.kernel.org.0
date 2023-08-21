Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB8A78260C
	for <lists+io-uring@lfdr.de>; Mon, 21 Aug 2023 11:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbjHUJJf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Aug 2023 05:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbjHUJJf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Aug 2023 05:09:35 -0400
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D6FC6;
        Mon, 21 Aug 2023 02:09:32 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-99bcc0adab4so393699666b.2;
        Mon, 21 Aug 2023 02:09:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692608971; x=1693213771;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G3IanIreuKKd6oid8gIK418X48snCHg9yrUKvAdOxbs=;
        b=DGSA6iIKmEi0XFRKPjUlW15ZAdIzDaYKw00Kw5JCLXjH6n6/U9R+TBQ55sohWID3uE
         I60//7k5i5/6nr64r5xBnS+M7NXAZ3fJ5D0Ctiwa1HsQBZb/p6mUwiHyIUur96jzY0un
         uK+mi69O7Gtuj9T3UbwKj2m8Dmq6jCzbkOuRi8Wh6D1arsgHtbmekjmi32r+TDtHntRq
         GbRw2tBYys7+3CbiT0I9UyssO/Ar8tCZ9969k67AtP55+UvhFg5JYWIMlJ00isharuP0
         ANUpPNf4kc1DlR9pxfqndaOpFshlVIbaDihEQX7Mu+5YNVlp8HrqVNM3X5Dtg9IFtr0H
         FTaQ==
X-Gm-Message-State: AOJu0YzqT6UOUisyR/GQMYLbQ4jaPcXk+vxTwmpnIReW+89Q9oc2lLIn
        tGs25vLHWI8G3qaIha4vn+s=
X-Google-Smtp-Source: AGHT+IETWV8T6vtneT+4l5a1uiQOc2A3mGi8+jnIWL6WwJCuN7klY8X0PX9zHVVOsWlY5Px9lJnhCg==
X-Received: by 2002:a17:906:224e:b0:9a1:68ff:a161 with SMTP id 14-20020a170906224e00b009a168ffa161mr5036529ejr.52.1692608970347;
        Mon, 21 Aug 2023 02:09:30 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-009.fbsv.net. [2a03:2880:31ff:9::face:b00c])
        by smtp.gmail.com with ESMTPSA id h2-20020a170906828200b00977cad140a8sm6161655ejx.218.2023.08.21.02.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Aug 2023 02:09:29 -0700 (PDT)
Date:   Mon, 21 Aug 2023 02:09:26 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, martin.lau@linux.dev,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: Re: [PATCH v3 6/9] io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
Message-ID: <ZOMpxrTzvSGQRwYi@gmail.com>
References: <20230817145554.892543-1-leitao@debian.org>
 <20230817145554.892543-7-leitao@debian.org>
 <87zg2p345l.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zg2p345l.fsf@suse.de>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Gabriel,

On Thu, Aug 17, 2023 at 02:38:46PM -0400, Gabriel Krisman Bertazi wrote:
> Breno Leitao <leitao@debian.org> writes:
> 
> > +#if defined(CONFIG_NET)
> >  int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
> >  {
> >  	struct socket *sock = cmd->file->private_data;
> > @@ -189,8 +219,16 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
> >  		if (ret)
> >  			return ret;
> >  		return arg;
> > +	case SOCKET_URING_OP_GETSOCKOPT:
> > +		return io_uring_cmd_getsockopt(sock, cmd, issue_flags);
> >  	default:
> >  		return -EOPNOTSUPP;
> >  	}
> >  }
> > +#else
> > +int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
> > +{
> > +	return -EOPNOTSUPP;
> > +}
> > +#endif
> >  EXPORT_SYMBOL_GPL(io_uring_cmd_sock);
> 
> The CONFIG_NET guards are unrelated and need to go in a separate commit.
> Specially because it is not only gating getsockopt, but also the already
> merged SOCKET_URING_OP_SIOCINQ/_OP_SIOCOUTQ.

Well, so far, if CONFIG_NET is disable, and you call
io_uring_cmd_getsockopt, the callbacks will be called and returned
-EOPNOTSUPP.

With this new patch, it will eventually call sk_getsockopt which does
not exist in the CONFIG_NET=n world. That is why I have this
protection now. I.e, this `#if defined(CONFIG_NET)` is only necessary now,
since it is the first time this function (io_uring_cmd_sock) will call a
function that does not exist if CONFIG_NET is disabled.

I can split it in a different patch, if you think it makes a difference.
