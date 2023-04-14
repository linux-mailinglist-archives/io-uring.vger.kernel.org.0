Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D46C6E2B7A
	for <lists+io-uring@lfdr.de>; Fri, 14 Apr 2023 23:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjDNVHn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Apr 2023 17:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjDNVHn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Apr 2023 17:07:43 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C134EDE
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 14:07:39 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-54fc337a650so115396607b3.4
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 14:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681506458; x=1684098458;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+7YotAOSsN1L1yixPPblHhMDbedGAdq/C54x2AQUELU=;
        b=UtsYK2o4ZCM/eM/Hniw7cC31fSva/KWzQuv9GzY2hxrJHSSKvJucHrvK5U2XgmvLFn
         5NyIHyTRP0FbEmXRpE1MZNhb2oMy889wPm2JbpBpSMkgBBgMV+bEkhbtuFYUinV/KU6g
         bSU1PKvl/7C22DCs6x4lNKP89y7GZro6I/fpIS80Q7XM5rV5QtLXoRD/xLmWYzQmL3MA
         8/IeqYvndagzGEHEzT+cKd6b0Ei9XsA/Niy13S3zMEfLT1TT7RN8Z7MP1yVnov6SS2VK
         zRnsDevbYVAzfaWAgOnd9vLffbUmedIV0E5FscnzqTJcV68Oo0l3WzTRL8sZntgIAVXq
         EbVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681506458; x=1684098458;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+7YotAOSsN1L1yixPPblHhMDbedGAdq/C54x2AQUELU=;
        b=bFcoGicL0CQZZPwUz3waKq7G2gDZhbyDpIJcWw7Munq/c+HyEGcd6wjag5LhTzqpQ5
         2wJgwmqUlEVwTHLw7aRBJRzBfiRf+Zahj+wpA7ARY5WqbAnPiJU5edjCkGUrDonb7rUa
         4rpa/RW1mRe97+mJv9uiF1EVh/wCPTUCFt1YTgB7VyK/JCVrNOU3+x4Tiw74rd0X41ZL
         FeLQQEPI+aUuvKi5LxcgSCEIr/awRUFilqU7aQNLkn1KpaxC/LPc/CiW07EoF/rZHTBe
         +/jtfnHs6htH0HDncs2m07VM1YU3XJl+6kanCsCYE3RMt636rZ8v/bsdx3PsnsAA5K4t
         LbbQ==
X-Gm-Message-State: AAQBX9e0LamRmLr/RXVwhKg8TOAoKwUJBJNDCKWsVbBWqYLyBMA8yu/e
        0hZPilbiWhP/gJp8F/5OW8ydQoRTMptbWHr7Er+CBmWGi4o=
X-Google-Smtp-Source: AKy350ZnxXKQohInYOB1xYatbF2/dR7WoS0ryxxcjxVfOBOzTDHL0GErcYZSGge6/LDtI0bla75+s9ekuVjQyGHz02M=
X-Received: by 2002:a81:ae0b:0:b0:54f:8f2e:a03 with SMTP id
 m11-20020a81ae0b000000b0054f8f2e0a03mr4748568ywh.1.1681506458288; Fri, 14 Apr
 2023 14:07:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230414201326.2373944-1-davidhwei@meta.com>
In-Reply-To: <20230414201326.2373944-1-davidhwei@meta.com>
From:   Dylan Yudaken <dyudaken@gmail.com>
Date:   Fri, 14 Apr 2023 22:07:27 +0100
Message-ID: <CAO_YeojHXRtCBRuOOvzcyQ125E3w3hwkFHjS5Z2QhWUiZYqrTQ@mail.gmail.com>
Subject: Re: [PATCH v3] io_uring: add support for multishot timeouts
To:     David Wei <davidhwei@meta.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Apr 14, 2023 at 9:14=E2=80=AFPM David Wei <davidhwei@meta.com> wrot=
e:
>
> A multishot timeout submission will repeatedly generate completions with
> the IORING_CQE_F_MORE cflag set. Depending on the value of the `off'
> field in the submission, these timeouts can either repeat indefinitely
> until cancelled (`off' =3D 0) or for a fixed number of times (`off' > 0).
>
> Only noseq timeouts (i.e. not dependent on the number of I/O
> completions) are supported.
>
> An indefinite timer will be cancelled with EOVERFLOW if the CQ ever
> overflows.
>
> Signed-off-by: David Wei <davidhwei@meta.com>

...

> +static void io_timeout_complete(struct io_kiocb *req, struct io_tw_state=
 *ts)
> +{
> +       struct io_timeout *timeout =3D io_kiocb_to_cmd(req, struct io_tim=
eout);
> +       struct io_timeout_data *data =3D req->async_data;
> +       struct io_ring_ctx *ctx =3D req->ctx;
> +
> +       if (!io_timeout_finish(timeout, data)) {
> +               bool filled;
> +               filled =3D io_aux_cqe(ctx, false, req->cqe.user_data, -ET=
IME,
> +                                   IORING_CQE_F_MORE, false);

I think that the defer parameter (the first false) might want to be ts->loc=
ked.
