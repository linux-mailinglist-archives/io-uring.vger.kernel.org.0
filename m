Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD3CC5890BB
	for <lists+io-uring@lfdr.de>; Wed,  3 Aug 2022 18:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235039AbiHCQo5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Aug 2022 12:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiHCQo5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Aug 2022 12:44:57 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4718C402E5
        for <io-uring@vger.kernel.org>; Wed,  3 Aug 2022 09:44:56 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id c24so1711270ejd.11
        for <io-uring@vger.kernel.org>; Wed, 03 Aug 2022 09:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=oiZPPs5MYI4/+W8yBMwCWKj6VS0spM9Blj9rVuT6y0o=;
        b=RSE84gDSPn39xr+1byZPyrJwh4O8nimo8zEb56V2vpcURL8cR/iKnRrj5KqE46OWG3
         0JgOT/61TRpBg4ovhC5wHfMEinnsqdEek0C6UqOArCWCF25O7lTJ9XofEXMVX/6sU++H
         JkOrPY9idXwhzAvQUNzMTWyybEgQodqSjd7/A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=oiZPPs5MYI4/+W8yBMwCWKj6VS0spM9Blj9rVuT6y0o=;
        b=xkUULYOqpgb5WFgrVh1cLR938FXJBMhG4aG3v4MtEUnxiUFbiFaSa+iZS9NPN3siot
         eVM5YhCsmNYZE4/rHgYqIXAWQnF1oHZPtyUMc7oFCVMVyiB6vpN5bIHS/tZ2YdSTa5DI
         y05m9QAqdHebrfS1iXWTpEmi65/iCZoN7BPJpvC+xOttqAccyEPE3KPOyylIxKoQ1pK1
         FoMtDdeuZsJ+1I6G2tJisoIV0P0PUi9ANZyW6poQne+J6i8Vx2Vj1ZauwOnVaTPC6dld
         kbA7PdiNKMTnY1dq8gd9UqajZQoB1NHDsLNDw48lbcmxNnifLin0/3oI98xTwAI+79FE
         F9nw==
X-Gm-Message-State: AJIora9S8vB3qvAikbNd0VN326odvScL62OYpz8q2jDgyw8Izk5SB8DO
        axmhUua++SCk9ZUkH+tluxb2YMcDSrefesM6
X-Google-Smtp-Source: AGRyM1t/qliNIrlR1jdrfNp1FB7x7o9kH5pxuD8hAnqau2UruPvbl2oHu5RsAE7pLYh7WXXI1YUYTA==
X-Received: by 2002:a17:907:9612:b0:72e:56bd:2b9a with SMTP id gb18-20020a170907961200b0072e56bd2b9amr20733114ejc.526.1659545094559;
        Wed, 03 Aug 2022 09:44:54 -0700 (PDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com. [209.85.221.42])
        by smtp.gmail.com with ESMTPSA id r9-20020a17090609c900b00722bc0aa9e3sm7414012eje.162.2022.08.03.09.44.53
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 09:44:54 -0700 (PDT)
Received: by mail-wr1-f42.google.com with SMTP id l4so22250113wrm.13
        for <io-uring@vger.kernel.org>; Wed, 03 Aug 2022 09:44:53 -0700 (PDT)
X-Received: by 2002:a05:6000:1a88:b0:21d:aa97:cb16 with SMTP id
 f8-20020a0560001a8800b0021daa97cb16mr16942311wry.97.1659545093700; Wed, 03
 Aug 2022 09:44:53 -0700 (PDT)
MIME-Version: 1.0
References: <d5568318-39ea-0c39-c765-852411409b68@kernel.dk>
 <CAHk-=wjh91hcEix55tH7ydTLHbcg3hZ6SaqgeyVscbYz57crfQ@mail.gmail.com> <1bbb9374-c503-37c6-45d8-476a8b761d4a@kernel.dk>
In-Reply-To: <1bbb9374-c503-37c6-45d8-476a8b761d4a@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 3 Aug 2022 09:44:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=whxqSBtkvr4JijDBQ-yDrE91rFHt9D9b0jj=OMYL8mEsg@mail.gmail.com>
Message-ID: <CAHk-=whxqSBtkvr4JijDBQ-yDrE91rFHt9D9b0jj=OMYL8mEsg@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring support for zerocopy send
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 3, 2022 at 9:39 AM Jens Axboe <axboe@kernel.dk> wrote:
>
>      If you look at the numbers Pavel posted, it's
> definitely firmly in benchmark land, but I do think the goals of
> breaking even with non zero-copy for realistic payload sizes is the real
> differentiator here.

Well, a big part of why I wrote the query email was exactly because I
haven't seen any numbers, and the pull request didn't have any links
to any.

So you say "the numbers Pavel posted" and I say "where?"

It would have been good to have had a link in the pull request (and
thus in the merge message).

               Linus
