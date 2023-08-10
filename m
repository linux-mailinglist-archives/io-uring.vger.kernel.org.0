Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6752977784B
	for <lists+io-uring@lfdr.de>; Thu, 10 Aug 2023 14:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235246AbjHJM2I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Aug 2023 08:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235199AbjHJM2I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Aug 2023 08:28:08 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EC81B4;
        Thu, 10 Aug 2023 05:28:07 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id 46e09a7af769-6bca66e6c44so849184a34.0;
        Thu, 10 Aug 2023 05:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691670487; x=1692275287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iZ5e6iHymhzYgHWJ9Iho76Ykmmu5+XifAghQRovvEwQ=;
        b=VcdExpqHQyymIYvXS7iHoWNsQS8udm/Z/6xOHf2gx7FZy4MvvRPNP3MeBoDFsq2aVw
         PQFBWU5ZrhDpC0OeVxCGJOkSDtm0rrEiZYojw9c71s2hLUgrhuPJrnyGyhzAPBNKmW/8
         wDOfQIXnSUU5HJ1cOHBPJwPiS2oI+EdS+CLHwbFi0vWZLbnH6XvGg2ZsEHbHPN0fcEQu
         s9uc/LfTCV8mpzGSjjPLQeIFhe4Q5i5oNJWWDWdeCnYZ5IZJhM7LJk8mhZ9ZCQ2t5H9e
         JwXt3MQX0lqRldlU0fpsA0yZhciPFpPmRKIVgXS6vDGZuBzTXpF2xmFsyKoZirTxMhQo
         ujTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691670487; x=1692275287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iZ5e6iHymhzYgHWJ9Iho76Ykmmu5+XifAghQRovvEwQ=;
        b=TK2EnPHhczPkDGDIKI42HN4qZzec1NIS42XH0j1u7GQcKB97GNLmw6lV+dSsHDn3QT
         Ftx8Y29bJXgOQlCzxAngZAwOGHYHWv+W1C09VOtBm/ewaUmQ0rr8rE/X4JPfZjw8ulIm
         4reB1RD6q37PuIrdWYlTnPFvVDLEl31k56IEfHwg9qw+J0rr6emb9ta8qbakaUeSpUWX
         XQiy+CTaoI6PcPcXpBMqsUH29ZmiDanbtFHz22vh+KkR3SnruSjNepcLnaqkHQZicEaJ
         fygz/tYHAMygvCig9eSQn5z8SRMNIjzncS4P+DZCbFvccnsrK85V3HA7k0/NK6HQwrRx
         7lZQ==
X-Gm-Message-State: AOJu0YwxDqVa0mhR98/fZUM9mZjQkcG8Bhr/f1iZn5nUBvzHKKT4dYek
        hdWE/093Sets5RmYPOSA12V+9AAtkduiG3Sm1Naz1c5u
X-Google-Smtp-Source: AGHT+IFryjaMoJoCHESoJ6S4U2w2WXnvQnzGOtocx2Aaq82gMMjPYovQPIjWKOl8VJrPvTnY6YPxl1J5FqFGJioZhAo=
X-Received: by 2002:a9d:7517:0:b0:6bc:f276:717f with SMTP id
 r23-20020a9d7517000000b006bcf276717fmr2741648otk.13.1691670486788; Thu, 10
 Aug 2023 05:28:06 -0700 (PDT)
MIME-Version: 1.0
References: <20221107205754.2635439-1-cukie@google.com> <CAHC9VhTLBWkw2XzqdFx1LFVKDtaAL2pEfsmm+LEmS0OWM1mZgA@mail.gmail.com>
 <CABXk95ChjusTneWJgj5a58CZceZv0Ay-P-FwBcH2o4rO0g2Ggw@mail.gmail.com>
 <CAHC9VhRTWGuiMpJJiFrUpgsm7nQaNA-n1CYRMPS-24OLvzdA2A@mail.gmail.com>
 <54c8fd9c-0edd-7fea-fd7a-5618859b0827@semihalf.com> <CAHC9VhS9BXTUjcFy-URYhG=XSxBC+HsePbu01_xBGzM8sebCYQ@mail.gmail.com>
 <d2eaa3f8-cca6-2f51-ce98-30242c528b6f@semihalf.com> <CAHC9VhQDAM8X-MV9ONckc2NBWDZrsMteanDo9_NS4SirdQAx=w@mail.gmail.com>
 <dc055b47-b868-7f5d-98bf-51e27df6b2d8@semihalf.com> <6c5157fd-0feb-bce0-c160-f8d89a06f640@semihalf.com>
In-Reply-To: <6c5157fd-0feb-bce0-c160-f8d89a06f640@semihalf.com>
From:   Stephen Smalley <stephen.smalley.work@gmail.com>
Date:   Thu, 10 Aug 2023 08:27:55 -0400
Message-ID: <CAEjxPJ7xiqKAbfX2JhN2NBbWsdgEesE18RG4d81ELyee6bfOkQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] Add LSM access controls for io_uring_setup
To:     Dmytro Maluka <dmy@semihalf.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Jeffrey Vander Stoep <jeffv@google.com>,
        Gil Cukierman <cukie@google.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Eric Paris <eparis@parisplace.org>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        Joel Granados <j.granados@samsung.com>,
        Jeff Xu <jeffxu@google.com>,
        Takaya Saeki <takayas@chromium.org>,
        Tomasz Nowicki <tn@semihalf.com>,
        Matteo Rizzo <matteorizzo@google.com>,
        Andres Freund <andres@anarazel.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Aug 10, 2023 at 5:08=E2=80=AFAM Dmytro Maluka <dmy@semihalf.com> wr=
ote:
>
> On 8/9/23 19:28, Dmytro Maluka wrote:
> >   So one of the questions I'm wondering about is: if Android implemente=
d
> >   preventing execution of any io_uring code by non-trusted processes
> >   (via seccomp or any other way), how much would it help to reduce the
> >   risk of attacks, compared to its current SELinux based solution?
>
> And why exactly I'm wondering about that: AFAICT, Android folks are
> concerned about the high likelihood of vulnerabilities in io_uring code
> just like we (ChromeOS folks) are, and that is the main reason why
> Android takes care of restricting io_uring usage in the first place.

I think if you audit the io_uring syscalls and find a code path that
is not already mediated by a LSM hook (potentially at an earlier point
during setup / fd creation) that accesses any shared resource or
performs a privileged action, we would be open to adding a LSM hook to
cover that code path. But you'd have to do the work to identify and
propose such cases.
