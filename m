Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F7A79B830
	for <lists+io-uring@lfdr.de>; Tue, 12 Sep 2023 02:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358416AbjIKWKp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Sep 2023 18:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243064AbjIKQq7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Sep 2023 12:46:59 -0400
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315DEE3;
        Mon, 11 Sep 2023 09:46:54 -0700 (PDT)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-52e297c7c39so5868206a12.2;
        Mon, 11 Sep 2023 09:46:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694450812; x=1695055612;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fz0qgG1xAQKjyAXZ1F3HGmELYa8PYKoGe3IryD6lsZo=;
        b=s5RVSmQLJqz8+OiqDIN1LxVChoA5KOHTVWvtEZPg2RyF+bBuNP94pnUquLrSWAaDJk
         fZvZ7jA7mYsaSAYDA/2tdV/xzrICaOJLlBGGCs0gamcpdPgZybrGYotZppsL7A/jpTlh
         yMdm53+MeZBKx2Tk8KRKkLQyhm8lNPuKqI5HsmByi2RLXFnppWdF8nqhJkcNlQZaTpiD
         U3PGWTZAl5fhzwebX9ycxBThtvkzAmwRbv5nvCEyeMDNfAnO+smSntP6y3q/RdNyuwgu
         szpp+vMx2E2dPBxaMgctmL8LbgngyS23uYpxAA59nkave2vR7cvypaTpJbZLQxFQetHK
         ZXgA==
X-Gm-Message-State: AOJu0Yzlg7DgwwyP5whvYAqsZnowsF4Rp7C8hw3OmPk/hwgAM2l3wcWw
        ylBp9qBby5JnmD2LcMB6iCk=
X-Google-Smtp-Source: AGHT+IGbKXR5utsZSAcjo25hC+LWL6BmnRTWGZSSZF/5ZDH7OKutTBo9ihUXtpcWszGOcfOQii6Fxg==
X-Received: by 2002:aa7:c1d5:0:b0:522:2f8c:8953 with SMTP id d21-20020aa7c1d5000000b005222f8c8953mr7573057edp.39.1694450812406;
        Mon, 11 Sep 2023 09:46:52 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-017.fbsv.net. [2a03:2880:31ff:11::face:b00c])
        by smtp.gmail.com with ESMTPSA id i23-20020a0564020f1700b0052f8c67a399sm538287eda.37.2023.09.11.09.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 09:46:51 -0700 (PDT)
Date:   Mon, 11 Sep 2023 09:46:50 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        martin.lau@linux.dev, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        io-uring@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v5 5/8] io_uring/cmd: return -EOPNOTSUPP if net is
 disabled
Message-ID: <ZP9EeunfcbWos80w@gmail.com>
References: <20230911103407.1393149-1-leitao@debian.org>
 <20230911103407.1393149-6-leitao@debian.org>
 <87ledc904p.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ledc904p.fsf@suse.de>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Sep 11, 2023 at 11:53:58AM -0400, Gabriel Krisman Bertazi wrote:
> Breno Leitao <leitao@debian.org> writes:
> 
> > Protect io_uring_cmd_sock() to be called if CONFIG_NET is not set. If
> > network is not enabled, but io_uring is, then we want to return
> > -EOPNOTSUPP for any possible socket operation.
> >
> > This is helpful because io_uring_cmd_sock() can now call functions that
> > only exits if CONFIG_NET is enabled without having #ifdef CONFIG_NET
> > inside the function itself.
> >
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> > ---
> >  io_uring/uring_cmd.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > index 60f843a357e0..a7d6a7d112b7 100644
> > --- a/io_uring/uring_cmd.c
> > +++ b/io_uring/uring_cmd.c
> > @@ -167,6 +167,7 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
> >  }
> >  EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
> >  
> > +#if defined(CONFIG_NET)
> >  int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
> >  {
> >  	struct socket *sock = cmd->file->private_data;
> > @@ -193,3 +194,10 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
> >  	}
> >  }
> >  EXPORT_SYMBOL_GPL(io_uring_cmd_sock);
> > +#else
> > +int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
> > +{
> > +	return -EOPNOTSUPP;
> > +}
> > +#endif
> > +
> 
> Is net/socket.c even built without CONFIG_NET? if not, you don't even need
> the alternative EOPNOTSUPP implementation.

It seems so. net/socket.o is part of obj-y:

https://github.com/torvalds/linux/blob/master/net/Makefile#L9
