Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC45277568A
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 11:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjHIJjI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 05:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjHIJjI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 05:39:08 -0400
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FAF8E5F;
        Wed,  9 Aug 2023 02:39:07 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-986d8332f50so912091466b.0;
        Wed, 09 Aug 2023 02:39:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691573946; x=1692178746;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DIkFfaj4OAeDDESwBeOen//2HaiO3PbzcC4EQH4IqvE=;
        b=PMvoExvnS7OPAlVdXJwgRRlm9y/1LxODI0kBX+KtTQEd5LLG030nb6n4h4ArqSK3jf
         WMsXnPwIpdK1tHoZxz07rek3i6XiEkSIJT6mVYl9S0KDNSmkTR+xuc10fsfBkGxTEfH/
         KuV/qkVYVGgEDpIIiBgUN/QsUYPVhuJwsepX+7lDX1pKEtGFQ+2rfgnxe8nnK/j/0CHS
         AdTcFL2BqUjlxLYBKtzXu6DNs2CSrmA1S3AKkkbDhFKNwyXuxO7ervdogxYpRi+M7xyL
         u14/JY9sfmIdK9KvOa8uIGQToqrSJGoznSEszBi/ZR59NLKgen5cmNxNOgvcsudTC2he
         6HMQ==
X-Gm-Message-State: AOJu0Yyz1kwshfqdBw2C9qN+pnVGsb/oINg2Qp5vyrrrX9oeOS5QYZ2g
        ZFih1jmy2rXfLh7eif81hZ4X0Z6js18=
X-Google-Smtp-Source: AGHT+IGfAbsBfnp3P7bXGK6TzLo/SGeVnRggqirUCWXrKF05+SKTYowdguI3ePfHWhjuf/SwT9Zwlg==
X-Received: by 2002:a17:906:5393:b0:99c:7915:b844 with SMTP id g19-20020a170906539300b0099c7915b844mr1676896ejo.57.1691573945734;
        Wed, 09 Aug 2023 02:39:05 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-004.fbsv.net. [2a03:2880:31ff:4::face:b00c])
        by smtp.gmail.com with ESMTPSA id y16-20020a170906071000b00992d122af63sm7779296ejb.89.2023.08.09.02.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 02:39:05 -0700 (PDT)
Date:   Wed, 9 Aug 2023 02:39:03 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Hugo Villeneuve <hugo@hugovil.com>
Cc:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: Re: [PATCH v2 1/8] net: expose sock_use_custom_sol_socket
Message-ID: <ZNNet67Om0uGmpXj@gmail.com>
References: <20230808134049.1407498-1-leitao@debian.org>
 <20230808134049.1407498-2-leitao@debian.org>
 <20230808121323.bc144c719eba5979e161aac6@hugovil.com>
 <ZNJ5f1hR3cre0IPd@gmail.com>
 <20230808134647.3e0e702f54ef5e5b4378ff98@hugovil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230808134647.3e0e702f54ef5e5b4378ff98@hugovil.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FSL_HELO_FAKE,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 08, 2023 at 01:46:47PM -0400, Hugo Villeneuve wrote:
> On Tue, 8 Aug 2023 10:21:03 -0700
> Breno Leitao <leitao@debian.org> wrote:
> 
> > Hello  Hugo,
> > 
> > On Tue, Aug 08, 2023 at 12:13:23PM -0400, Hugo Villeneuve wrote:
> > > On Tue,  8 Aug 2023 06:40:41 -0700
> > > Breno Leitao <leitao@debian.org> wrote:
> > > 
> > > > Exposing function sock_use_custom_sol_socket(), so it could be used by
> > > > io_uring subsystem.
> > > > 
> > > > This function will be used in the function io_uring_cmd_setsockopt() in
> > > > the coming patch, so, let's move it to the socket.h header file.
> > > 
> > > Hi,
> > > this description doesn't seem to match the code change below...
> > 
> > I re-read the patch comment and it seems to match what the code does,
> > so, probably this description only makes sense to me (?).
> > 
> > That said, hat have you understood from reading the description above?
> > socket.h
> > Thanks for the review,
> 
> Hi Breno,
> your comments says "move it to the socket.h header file" but it seems
> to be moved to the net.h header file?

Gotcha. Thanks. I will update.
