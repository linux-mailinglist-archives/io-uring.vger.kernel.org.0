Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4D868706E
	for <lists+io-uring@lfdr.de>; Wed,  1 Feb 2023 22:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjBAVS7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Feb 2023 16:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbjBAVS6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Feb 2023 16:18:58 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7C46DB37
        for <io-uring@vger.kernel.org>; Wed,  1 Feb 2023 13:18:57 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id a184so13530211pfa.9
        for <io-uring@vger.kernel.org>; Wed, 01 Feb 2023 13:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=F3Si1tu8Y5DMEWT7C6ejyq5oRsygCb4wYMBHPF2K2lA=;
        b=SW5j2FTMCq4xN/ZHt8opiZ+KLLwOWAJ2FnVwcGrxqL1LQjt4qD+GAWqwZW6er0NX2O
         Pdtc9A5zDHYYC2x0fjlAHZlSJqUjKGIh8CxzCeK+CObDVQzhduFhHLbErmg/T8Aueed/
         KozoCFOGKaqhpemc7wgDLauGzMe0PV2oK6Z3db1qldLWQnxiPv1LyaZCvvtPz0zZ+DR6
         m6/qAnPgfuV8ddKoYakO7sMiOyjb+O4RVeOPhNdyGgs+1/k5oXwIGkVaCVqpwBZtoVoO
         GyFmg4o8F2FGuwNlMFsUf7bBc+s2DVTtiexVEUQDNn8n8a6mB1aApdyWzbufQBf8UM15
         bvlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F3Si1tu8Y5DMEWT7C6ejyq5oRsygCb4wYMBHPF2K2lA=;
        b=4EmZEKzvGuIf6A/CwY/wwispdfc8AKzUFFpi4zIS2CqIXNXn1ESNLqZcrr0VtZMNJh
         0PV5HCezNvWJlJH0pSPf4my8jUBfZpajlJ/kZvCLPqaSVZAyT8B6O4SC5XxaZBviHoTP
         ssPZcPZtan56FoKQlUDhumMXfLAM3hDw9gQQXGzPqQ6MmyOhx6obL2FVWdCDo4h55fw0
         pB4C2RA737wGtU2VOQlwDHerWVnHnSidSttbfq+IyG/VYmAVy3oykVHd5gXsx4GpMNzG
         QJu0zfhl83ANdjDztpYNjhI6h4791jfyjNOq898WtVv2BYol5v568Dxmefmm7e7tWkoI
         9ydQ==
X-Gm-Message-State: AO0yUKW5xU/K8bnGjHbPeUIhEvibmg1cMTi3T8nHyyCEs2x9UuLTfH1O
        hrlf2WI/YmNkQDv1uXymkeNLlHyJf95jqH3a3MU3
X-Google-Smtp-Source: AK7set8KFiT3geprutCvgeL1UVJzcV0oWaLCKtVMWA4z7XEEhBP6lnqjZbY8983tNJa3ZMbsaFJBUBd95GbvabSseFU=
X-Received: by 2002:a05:6a00:bd1:b0:593:b491:40ba with SMTP id
 x17-20020a056a000bd100b00593b49140bamr914989pfu.7.1675286337234; Wed, 01 Feb
 2023 13:18:57 -0800 (PST)
MIME-Version: 1.0
References: <b5dfdcd541115c86dbc774aa9dd502c964849c5f.1675282642.git.rgb@redhat.com>
In-Reply-To: <b5dfdcd541115c86dbc774aa9dd502c964849c5f.1675282642.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 1 Feb 2023 16:18:46 -0500
Message-ID: <CAHC9VhS0rPfkwUT1WMfqsTF-qYXdbbhHAfVPs=d3ZQVgbXBHnw@mail.gmail.com>
Subject: Re: [PATCH v2] io_uring,audit: don't log IORING_OP_MADVISE
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Stefan Roesch <shr@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Feb 1, 2023 at 3:34 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> fadvise and madvise both provide hints for caching or access pattern for
> file and memory respectively.  Skip them.

You forgot to update the first sentence in the commit description :/

I'm still looking for some type of statement that you've done some
homework on the IORING_OP_MADVISE case to ensure that it doesn't end
up calling into the LSM, see my previous emails on this.  I need more
than "Steve told me to do this".

I basically just want to see that some care and thought has gone into
this patch to verify it is correct and good.

> Fixes: 5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit support to io_uring")
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
> changelog
> v2:
> - drop *GETXATTR patch
> - drop FADVISE hunk
>
>  io_uring/opdef.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> index 3aa0d65c50e3..d3f36c633ceb 100644
> --- a/io_uring/opdef.c
> +++ b/io_uring/opdef.c
> @@ -312,6 +312,7 @@ const struct io_op_def io_op_defs[] = {
>                 .issue                  = io_fadvise,
>         },
>         [IORING_OP_MADVISE] = {
> +               .audit_skip             = 1,
>                 .name                   = "MADVISE",
>                 .prep                   = io_madvise_prep,
>                 .issue                  = io_madvise,
> --
> 2.27.0

-- 
paul-moore.com
