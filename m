Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C91761FB3
	for <lists+io-uring@lfdr.de>; Tue, 25 Jul 2023 19:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbjGYRCo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Jul 2023 13:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbjGYRCo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Jul 2023 13:02:44 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9132E3
        for <io-uring@vger.kernel.org>; Tue, 25 Jul 2023 10:02:42 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-55b2ab496ecso2950661a12.2
        for <io-uring@vger.kernel.org>; Tue, 25 Jul 2023 10:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690304562; x=1690909362;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aEq9wvoOmb79sxPImc43/8dWbsrHxgBnwc9vx2sbv8Q=;
        b=VWIQdXO6C9fKgtTrf5l5sGCGnOSCXxT0RK4teBxBlWjA45NvBd2W2NUCMBvJqd1LuQ
         +Ddme/UZOrkRccSEBHud08r7Hp2GlWNzroFWlyPl9a0XN1yaKOt47BItrQIH7itgaZ8L
         7CtNgDjtQGmkhgbXcJKsSXADLMCaG9OXG3B/pCyg44pBrE8DUcsdx625AOB1ywFHFJWk
         EVZCqM+29RfY09tnPa6AzfJ6TqZ3OX1xIi7nA+XQvQYYGtNtozEioR+Cj1IXxlTSyzX8
         ydYByI9q5vC/t0bcAbs5zfmRgTZcIcMmZSWRvoBzoDE3/5ywsADDG9JPeOFXHIcXarLI
         u7JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690304562; x=1690909362;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aEq9wvoOmb79sxPImc43/8dWbsrHxgBnwc9vx2sbv8Q=;
        b=DDIxVuDmUx5MkDc8wJDVMBqD8TQyJa7KNfKN81izSRSrB3tEQ5HRHeiNtENxbmP2nO
         KmOHqme3J33yPrnJVVpJ8Kop7AMCygdY23AUKfHClY3wHd2Z7/+oA5S04+8oZqmfSTbJ
         yyu9XlWL7DIv+RQjAnAuiVQ8htdd03tPxM6khQ2nlCo/pIK88s/GMajN22V1kktT6pQk
         5FA4H3NCFgDA7XfOw06eO8+KKwKAH9b50CW9J0GI0hx2JIiqsaDA5d+zZFMqr1UK4h1I
         pUVrEEohReb06qJhQG4zzfCczzLYqaXtmfJrWNDfFCuDo61yWWlRrEY7G2VKJY7z6D4+
         bx3w==
X-Gm-Message-State: ABy/qLa6lU5K3tzwpo9OTjMXl1PHQod9Zk1FwX+K2RGfg67ENhPuYvbk
        qMnryoZuvKGGPiHbuR50hEKIfmk=
X-Google-Smtp-Source: APBJJlG+EQC6OFCeDlua8rQI6GRdjTdr0NTozio16Zq//4slIvlC7h02qvfKRrly0F7zWE7386X2IpM=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a63:7d12:0:b0:55a:12cf:3660 with SMTP id
 y18-20020a637d12000000b0055a12cf3660mr52472pgc.1.1690304562245; Tue, 25 Jul
 2023 10:02:42 -0700 (PDT)
Date:   Tue, 25 Jul 2023 10:02:40 -0700
In-Reply-To: <ZL+VfRiJQqrrLe/9@gmail.com>
Mime-Version: 1.0
References: <20230724142237.358769-1-leitao@debian.org> <20230724142237.358769-3-leitao@debian.org>
 <ZL61cIrQuo92Xzbu@google.com> <ZL+VfRiJQqrrLe/9@gmail.com>
Message-ID: <ZMAAMKTaKSIKi1RW@google.com>
Subject: Re: [PATCH 2/4] io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
From:   Stanislav Fomichev <sdf@google.com>
To:     Breno Leitao <leitao@debian.org>
Cc:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, leit@meta.com, bpf@vger.kernel.org,
        ast@kernel.org, martin.lau@linux.dev
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 07/25, Breno Leitao wrote:
> On Mon, Jul 24, 2023 at 10:31:28AM -0700, Stanislav Fomichev wrote:
> > On 07/24, Breno Leitao wrote:
> > > Add support for getsockopt command (SOCKET_URING_OP_GETSOCKOPT), where
> > > level is SOL_SOCKET. This is leveraging the sockptr_t infrastructure,
> > > where a sockptr_t is either userspace or kernel space, and handled as
> > > such.
> > > 
> > > Function io_uring_cmd_getsockopt() is inspired by __sys_getsockopt().
> > 
> > We probably need to also have bpf bits in the new
> > io_uring_cmd_getsockopt?
> 
> It might be interesting to have the BPF hook for this function as
> well, but I would like to do it in a following patch, so, I can
> experiment with it better, if that is OK.

We are not using io_uring, so fine with me. However, having a way to bypass
get/setsockopt bpf might be problematic for some other heavy io_uring
users.

Lemme CC a bunch of Meta folks explicitly. I'm not sure what that state
of bpf support in io_uring.
