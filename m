Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01317415F2
	for <lists+io-uring@lfdr.de>; Wed, 28 Jun 2023 18:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbjF1QAT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Jun 2023 12:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbjF1QAN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Jun 2023 12:00:13 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5499D1737
        for <io-uring@vger.kernel.org>; Wed, 28 Jun 2023 09:00:12 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id ada2fe7eead31-440db8e60c8so1865970137.0
        for <io-uring@vger.kernel.org>; Wed, 28 Jun 2023 09:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1687968011; x=1690560011;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GPpb/2tnOaLvPcmNVC1FnQTKYAdbc3TLfcGD1phxugk=;
        b=RM6YXUlfektq2rACsksmLN0SLB0ejuekQ0cyrqoilALSH+BUs94SmOewnpgIehcjxe
         QhmTftymAmG5Pu1NN2z9GuPb9+KLM54AlZb9kiNTdlP7KByTT2jsaMTy/AVAp+r+0Dgt
         7rt1IPGbXDhzGCh+wmiE8VKIeNhBuGBgaX680=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687968011; x=1690560011;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GPpb/2tnOaLvPcmNVC1FnQTKYAdbc3TLfcGD1phxugk=;
        b=SIqgKTrNKFfi1dDz+cMILq5deYVypiz4V9tzNKJnJdttsV4aF5IGbVWBZ3zZDBwZmt
         kCzoaJDocEZa024GIYMlVxmVIhNaA9zpK2byi4FAcQsT2ZSLKnAWLv3/d5qaXBd53nqy
         /aDdX+OAPLGu2a5Dcd7nIuK43icPWa/DSG95hhkMAnk+dd7J70PUHnNnIMbsaqHsJo2U
         aWCOa7IhMMBZerfFMDBbJsCKkP3k6R8qWxsDzXHbuR+lH2Vettx8+RpOxThVbiqwHV1Y
         pKCF4pxSeUrgjll33az76M/zCrazEvis3IyxfHIS5qLeTBMIg/GUtFpS+QaJ7R5k5TzI
         R3SA==
X-Gm-Message-State: AC+VfDy2DIVfs++rQfwkA6sW0fNT8UQ9UBVqF5k2xX6u1N/9WTgFpSgp
        M/axfHecDbmrqXZpp673ALtR1WaG/MrYng7QIyWRNg==
X-Google-Smtp-Source: ACHHUZ7srQlp7DIkDBVl1VNgP4nOj2nvihouiFdOS7wrMCmh/+lAFnbavY7RjBrRnZEqnwuRgvYMyg==
X-Received: by 2002:a05:6102:367a:b0:440:b1f3:b476 with SMTP id bg26-20020a056102367a00b00440b1f3b476mr15912838vsb.17.1687968011530;
        Wed, 28 Jun 2023 09:00:11 -0700 (PDT)
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com. [209.85.222.43])
        by smtp.gmail.com with ESMTPSA id f5-20020a67e085000000b00440aaaf18efsm1978595vsl.19.2023.06.28.09.00.11
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jun 2023 09:00:11 -0700 (PDT)
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-791a0651fa3so1807606241.0
        for <io-uring@vger.kernel.org>; Wed, 28 Jun 2023 09:00:11 -0700 (PDT)
X-Received: by 2002:a67:f998:0:b0:443:6ad6:7915 with SMTP id
 b24-20020a67f998000000b004436ad67915mr5063977vsq.27.1687968010482; Wed, 28
 Jun 2023 09:00:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230627120058.2214509-1-matteorizzo@google.com>
 <20230627120058.2214509-2-matteorizzo@google.com> <e8924389-985a-42ad-9daf-eca2bf12fa57@acm.org>
 <CAHKB1wJANtT27WM6hrhDy_x9H9Lsn4qRjPDmXdKosoL93TJRYg@mail.gmail.com>
 <CANiDSCvjCoj3Q3phbmdhdG-veHNRrfD-gBu=FuZkmrgJ2uxiJg@mail.gmail.com> <CAHKB1w+UyOnC_rOBABVhmzG+XeePaWYgPJWxX9NUeqnAi9WcgA@mail.gmail.com>
In-Reply-To: <CAHKB1w+UyOnC_rOBABVhmzG+XeePaWYgPJWxX9NUeqnAi9WcgA@mail.gmail.com>
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Wed, 28 Jun 2023 17:59:59 +0200
X-Gmail-Original-Message-ID: <CANiDSCtu1OvoRe0ReqBVctzd8euZDt-h7dyx+xACWzdQeHkxBA@mail.gmail.com>
Message-ID: <CANiDSCtu1OvoRe0ReqBVctzd8euZDt-h7dyx+xACWzdQeHkxBA@mail.gmail.com>
Subject: Re: [PATCH 1/1] Add a new sysctl to disable io_uring system-wide
To:     Matteo Rizzo <matteorizzo@google.com>
Cc:     Bart Van Assche <bvanassche@acm.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        jordyzomer@google.com, evn@google.com, poprdi@google.com,
        corbet@lwn.net, axboe@kernel.dk, asml.silence@gmail.com,
        akpm@linux-foundation.org, keescook@chromium.org,
        rostedt@goodmis.org, dave.hansen@linux.intel.com,
        chenhuacai@kernel.org, steve@sk2.org, gpiccoli@igalia.com,
        ldufour@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

HI Matteo

On Wed, 28 Jun 2023 at 17:12, Matteo Rizzo <matteorizzo@google.com> wrote:
>
> On Wed, 28 Jun 2023 at 13:44, Ricardo Ribalda <ribalda@chromium.org> wrote:
> >
> > Have you considered that the new sysctl is "sticky like kexec_load_disabled.
> > When the user disables it there is no way to turn it back on until the
> > system is rebooted.
>
> Are you suggesting making this sysctl sticky? Are there any examples of how to
> implement a sticky sysctl that can take more than 2 values in case we want to
> add an intermediate level that still allows privileged processes to use
> io_uring? Also, what would be the use case? Preventing privileged processes
> from re-enabling io_uring?

Yes, if this sysctl is accepted, I think it would make sense to make it sticky.

For more than one value take a look to  kexec_load_limit_reboot and
kexec_load_limit_panic

Thanks!

>
> Thanks!
> --
> Matteo



-- 
Ricardo Ribalda
