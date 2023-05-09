Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6348F6FCBCE
	for <lists+io-uring@lfdr.de>; Tue,  9 May 2023 18:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234636AbjEIQxo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 May 2023 12:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234559AbjEIQxg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 May 2023 12:53:36 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4854C1D
        for <io-uring@vger.kernel.org>; Tue,  9 May 2023 09:53:13 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-9659f452148so1077545866b.1
        for <io-uring@vger.kernel.org>; Tue, 09 May 2023 09:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1683651187; x=1686243187;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9W37NhXu6wJIBmLbeQ87YSwN8pbxoXa2SKsX9DQFeng=;
        b=chpgdPd8dmW2Dvefw6SjayiN805bdKRypAVECSUlEcAO+4Lr/k0NSFPjrHZKhP1UjV
         cEWGXpVIgsChcv/G901EaUmMnFoaQ2VLuSl7KXbQW5flgfOkhWrQsOeXCEBHRRN+cch8
         6V0A3FZnwfa+pA8Zd4f0LqRfo5ZCtzchGl1mQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683651187; x=1686243187;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9W37NhXu6wJIBmLbeQ87YSwN8pbxoXa2SKsX9DQFeng=;
        b=AAEnQWC0NX/CWyWzO/5/fK5ab5TNksJ3gTj6A7zdDV3HBQzp10shsLVGh/dXD4ZkCT
         kBMIpg8R03bAjVz5tXS/I3SDB6yu3IuFtOB2yQnedT8ZKFxLkhKXvs6/cCEF8FyYM9A8
         gCrYtvdgW5H8zdZ3E7gvBRFI4hVnrsxkgIy95i8bHbvAaMNLCqHjbbdeVWw449jz4iDu
         acwIrO6dkVUlkIbR8zr3s2bzkyCBzujFTtGgp3Ocu7cS54x7X+UbBGRuD3HnC1FbXJlx
         yY6Qp30RQKZ5cqWyEsdH2CA0IExP7dzN4LzziCaYT8ve0L+rbK3gGhbDiohswaCPTDn6
         LrJw==
X-Gm-Message-State: AC+VfDzk4IsC4qCBsN9XiS/xUq0DnttMismynex2PsMf8zCLkuuHeAzv
        XrO4W4pWamcP3AbzWl3vAmYZrh7RbZjTIIXiofAs5g==
X-Google-Smtp-Source: ACHHUZ7KScOzbmFfHPKp+HMz8/kmr44q9Ng5C/afHsQMebVH8WqiJ/ZF+6u7D+13piDEsGJtmbZbQQ==
X-Received: by 2002:a17:906:730c:b0:969:19ca:b856 with SMTP id di12-20020a170906730c00b0096919cab856mr6329310ejc.54.1683651187654;
        Tue, 09 May 2023 09:53:07 -0700 (PDT)
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com. [209.85.218.41])
        by smtp.gmail.com with ESMTPSA id md1-20020a170906ae8100b0094b5ce9d43dsm1526065ejb.85.2023.05.09.09.53.06
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 May 2023 09:53:06 -0700 (PDT)
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-959a3e2dd27so1076246966b.3
        for <io-uring@vger.kernel.org>; Tue, 09 May 2023 09:53:06 -0700 (PDT)
X-Received: by 2002:a17:907:1687:b0:94e:1764:b0b5 with SMTP id
 hc7-20020a170907168700b0094e1764b0b5mr15546777ejc.69.1683651185901; Tue, 09
 May 2023 09:53:05 -0700 (PDT)
MIME-Version: 1.0
References: <9b2e791d-aeba-a2c7-1877-797ff5c680a3@kernel.dk>
 <20230508031852.GA4029098@google.com> <fb84f054-517c-77d4-eb11-d3df61f53701@kernel.dk>
 <CAGXv+5GpeJ8hWt2Sc6L+4GB-ghA4vESobEaFGpo1_ZyPhOvW0g@mail.gmail.com> <6d6a494b-3c1a-2bf6-79e3-0ccc81166a67@kernel.dk>
In-Reply-To: <6d6a494b-3c1a-2bf6-79e3-0ccc81166a67@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 9 May 2023 09:52:48 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjspoBCSrwL2s=qof3GFnZ4BmMzFbCcEx3VpVP81zXwrg@mail.gmail.com>
Message-ID: <CAHk-=wjspoBCSrwL2s=qof3GFnZ4BmMzFbCcEx3VpVP81zXwrg@mail.gmail.com>
Subject: Re: [GIT PULL] Final io_uring updates for 6.4-rc1
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Chen-Yu Tsai <wenst@chromium.org>,
        io-uring <io-uring@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 9, 2023 at 6:59=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> Oops yes, thanks for noticing. I'll correct that and add your tested-by.

.. this build problem isn't caught by Guenter's build testing, but can
we please make sure that it's fixed in my tree by -rc2?

It would be lovely to have a release that doesn't end up having silly
build problems pending for too long. Even if they might be unusual
configs.

             Linus
