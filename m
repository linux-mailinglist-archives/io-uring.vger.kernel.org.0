Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 022CB703C37
	for <lists+io-uring@lfdr.de>; Mon, 15 May 2023 20:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234345AbjEOSPB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 May 2023 14:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245179AbjEOSO2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 May 2023 14:14:28 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36DF299D5
        for <io-uring@vger.kernel.org>; Mon, 15 May 2023 11:11:33 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f42397f41fso380195e9.1
        for <io-uring@vger.kernel.org>; Mon, 15 May 2023 11:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684174292; x=1686766292;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XxBHcmYEEGMHA9ad0xOI/PjCS69JbEHkdxMGDWsLPjU=;
        b=JFDWQv8EVHGSRLtPEQA12I9SLzZbF6NYDfvptDyQD0hdSBVCIqkBNIxqGS1MNHIUc6
         NK03522G1HEGD/5rNy1RXV4bn7hj0455dCsotIumzmTby74qspiRcF8Wbi4+JuAWqHr0
         wl+W2FeCqsPhqT1NfhViU5k7rT59tkopoKsckaki8F8/516N2XzuWpbM2tdK0PPCnKjF
         dvJNqBdoJbhZ5hx0ggvpKiBePZucGByiTIGMUm5gBNwS2FpsQKpjRyHCgWpxB/WYauMA
         nfgp3tg+gEZmEAJXJLV9RUisXUeykmSEGyU7i4yOZctadsmHhz9rl+FenhejLq+wszWR
         jccQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684174292; x=1686766292;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XxBHcmYEEGMHA9ad0xOI/PjCS69JbEHkdxMGDWsLPjU=;
        b=aAY/G8WO8Y2Hna8i1PARnHAWNh8xLRFYONPl/QszdVIY0LKbu9A+rxGQqcjREgGmmS
         jKTXKp3Bl9cmpcTtCTiGBBt0Gym1tmQJGnSjMuz44jSEz5tRfcqwjWup9lOytPZ+ll+g
         NI/9a1zdwUsbpfYQkoMxfCAu3kHB96R1Byl8l8/bVrMsOQGBeQRLdWfiebjQliDQkbJm
         rNrkEe73oz6PFQvZLwT7lcYD+szpqOtcscXW1+z/rzk6BUhv4nSDYNOTcAMaCqWsH4r4
         WgOHz3H/uaxPXmV7WGPznxBDcdkeduxIwZ++nW6RXnGYhzckL5XRoe/6RG8FknUWgiEv
         Q6Kg==
X-Gm-Message-State: AC+VfDw2ZtXGB5buToZwHlARgtW4BpR4c0/wdrHf/ePXcSXtYrS/8D7F
        e5E2xkalt+yqNGwS8hy1Pj3R35ZgsMFIS1kFxwnWLw==
X-Google-Smtp-Source: ACHHUZ4ovwt5ahjBafldIK4jYLlMK+Cfyhj/ba0xTxh2Wksh897OhkKZeE+AKtkBz2SUXQDjDPg4bCjirF7o+n+xj2U=
X-Received: by 2002:a05:600c:3547:b0:3f4:1dce:3047 with SMTP id
 i7-20020a05600c354700b003f41dce3047mr6173wmq.2.1684174292101; Mon, 15 May
 2023 11:11:32 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1684166247.git.asml.silence@gmail.com> <d49262a8a39c995cd55f89d1f6fd39cd4346f528.1684166247.git.asml.silence@gmail.com>
 <1d9f84b1-debb-d92a-9f91-4ff9650ef6e0@kernel.org>
In-Reply-To: <1d9f84b1-debb-d92a-9f91-4ff9650ef6e0@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 15 May 2023 20:11:18 +0200
Message-ID: <CANn89iLPMhmWAHcbs2PtB6frzZjPUTGRRmnLUxtzspikaUba9g@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net/tcp: don't peek at tail for io_uring zc
To:     David Ahern <dsahern@kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 15, 2023 at 7:27=E2=80=AFPM David Ahern <dsahern@kernel.org> wr=
ote:
>
> On 5/15/23 10:06 AM, Pavel Begunkov wrote:
> > Move tcp_write_queue_tail() to SOCK_ZEROCOPY specific flag as zerocopy
> > setup for msghdr->ubuf_info doesn't need to peek into the last request.
> >
> > Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > ---
> >  net/ipv4/tcp.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
>
> Reviewed-by: David Ahern <dsahern@kernel.org>


Reviewed-by: Eric Dumazet <edumazet@google.com>
