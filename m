Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEDDA560F26
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 04:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbiF3C3D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jun 2022 22:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbiF3C3A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jun 2022 22:29:00 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B60286EE;
        Wed, 29 Jun 2022 19:28:58 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id m14so15778360plg.5;
        Wed, 29 Jun 2022 19:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:date:subject:from:to:cc:message-id:thread-topic
         :references:in-reply-to:mime-version:content-transfer-encoding;
        bh=Nz7YaeC1RqAbaDnJaLInZJQMb1KtakdskR8mdlJ2eZs=;
        b=jsm031dLci7T7xfCZcrxJhGLtC6qdMG+XFDOjS91O+0PTxyTPg6Tgsp7CJWAWom6Yn
         xb8hw0Is5Dk2T4f49NY/ux4KjdKtUiJREN/KvaBQGaQ19AS2MEMARARAyrRNb9JOqZAL
         Dx3dktkJUd82MFNM+RXIpYA4f1a8Pv5ZDwJ4+yfmb+JEVNNXObf32DGghug1CxMfUkWc
         rL67Yhybom1DcsvUVv5HrFImv7uJg4oaBes53eNsfdr4HGN45qvE+kZlc7nZ9HlCIGZq
         krOXWHRwem/L+agyuMjxJfqquOnKugILanTkspN7KfaF6JZ1wnuMrYl1Eb8CUfM9BV2+
         J8dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:user-agent:date:subject:from:to:cc:message-id
         :thread-topic:references:in-reply-to:mime-version
         :content-transfer-encoding;
        bh=Nz7YaeC1RqAbaDnJaLInZJQMb1KtakdskR8mdlJ2eZs=;
        b=D0wzqlZe9AtpMeHXeEOUaafshMDdIKZqXD5A9tajIVDF4KU5B0bijQa1BbXRXC/203
         YUgfsHS+ENhAadusnd5+evCAc83G8yEEHrRj8kQoe+5P3M0SiZestGTdc3y4BGv9tJcP
         A+ogqpB7dBpf0zljcagc47hAxzDzF1OSgIZcNAyDSBgaULq/O2a23Xd8+x7H/kcgCYDu
         QmXTMavgLOD3GVcKZaiEwCSk+o7mC6OnqBadf42QTESUwPNTr0wfaddRmaqLDJhxDro+
         yCyH06sB0pAFoSsEXoVSxcGjfjpnWW3VXi9npWOtHaX/apAzMZJCrv0RFBYzTvm8F9VR
         aZfA==
X-Gm-Message-State: AJIora90dwlCiEKTGhj/I4QRQr35Lvt6SIa5BEggM2zE8lv9NX/mSnzU
        Y0pi0gDhEEU161CLuJkYKmy+BKYEdT5IK9aT
X-Google-Smtp-Source: AGRyM1soUQnGfT6x10p2b8f9dl2vSYJYj8xGd7hmWu1NjaMILpUv08tAeyvig421grqAoYoamW+voQ==
X-Received: by 2002:a17:902:dac1:b0:16a:3ebe:c722 with SMTP id q1-20020a170902dac100b0016a3ebec722mr12736695plx.169.1656556138140;
        Wed, 29 Jun 2022 19:28:58 -0700 (PDT)
Received: from [10.80.23.34] ([203.205.141.116])
        by smtp.gmail.com with ESMTPSA id f8-20020a17090ace0800b001eee6b107fasm2901560pju.39.2022.06.29.19.28.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Jun 2022 19:28:57 -0700 (PDT)
User-Agent: Microsoft-MacOutlook/16.62.22061100
Date:   Thu, 30 Jun 2022 10:28:55 +0800
Subject: Re: [PATCH] io_uring: fix a typo in comment
From:   Xinghui Li <korantwork@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xinghui Li <korantli@tencent.com>
Message-ID: <FA9C6A6C-C02F-4CEE-A423-E4A7BBA61C23@gmail.com>
Thread-Topic: [PATCH] io_uring: fix a typo in comment
References: <20220629144301.9308-1-korantwork@gmail.com>
 <4768f72e-6c23-b2ac-d446-b69ded9c19a1@kernel.dk>
In-Reply-To: <4768f72e-6c23-b2ac-d446-b69ded9c19a1@kernel.dk>
Mime-version: 1.0
Content-type: text/plain;
        charset="UTF-8"
Content-transfer-encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,MIME_QP_LONG_LINE,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2022/6/29 22:46=EF=BC=8C=E2=80=9CJens Axboe=E2=80=9D<axboe@kernel.dk> wrote:
>
>    On 6/29/22 8:43 AM, korantwork@gmail.com wrote:
>    > From: Xinghui Li <korantli@tencent.com>
>    >=20
>    > fix a typo in comment in io_allocate_scq_urings.
>    > sane -> same.
>    >=20
>    > Signed-off-by: Xinghui Li <korantli@tencent.com>
>    > ---
>    >  fs/io_uring.c | 2 +-
>    >  1 file changed, 1 insertion(+), 1 deletion(-)
>    >=20
>    > diff --git a/fs/io_uring.c b/fs/io_uring.c
>    > index d3ee4fc532fa..af17adf3fa79 100644
>    > --- a/fs/io_uring.c
>    > +++ b/fs/io_uring.c
>    > @@ -12284,7 +12284,7 @@ static __cold int io_allocate_scq_urings(str=
uct io_ring_ctx *ctx,
>    >  	struct io_rings *rings;
>    >  	size_t size, sq_array_offset;
>    > =20
>    > -	/* make sure these are sane, as we already accounted them */
>    > +	/* make sure these are same, as we already accounted them */
>    >  	ctx->sq_entries =3D p->sq_entries;
>    >  	ctx->cq_entries =3D p->cq_entries;

>    That's not really a typo, though I can see why you'd think so. It's
>    trying to say that we need to ensure that the ctx entries are sane,
>    as they have already been accounted. This means that if we teardown
>    past this point, they need to be assigned (eg sane) so that we undo
>    that accounting appropriately.

Thanks a lot for your reply and I am sorry about wasting your effort. I wil=
l try to submit some valuable patches. : - )

--=20
Xinghui Li



