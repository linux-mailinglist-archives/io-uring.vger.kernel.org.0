Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB856FCBA6
	for <lists+io-uring@lfdr.de>; Tue,  9 May 2023 18:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjEIQtS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 May 2023 12:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233293AbjEIQtR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 May 2023 12:49:17 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A361E4486
        for <io-uring@vger.kernel.org>; Tue,  9 May 2023 09:49:13 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-50b37f3e664so11094063a12.1
        for <io-uring@vger.kernel.org>; Tue, 09 May 2023 09:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1683650952; x=1686242952;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5PRE+dkDR3gLcpcvdOpvwUpbudiHQbrnvpo0QdDymSM=;
        b=U/ZMOS0M7Vb1HWrW5LOymh9H44fOBBDyKltkgHrsr9MitOt9D15Jh55eWg8EhtIuis
         0AafEHgTUtms7TZuHI8QSJonyzxS4x2s2PzmUogU835+/zo+PqLDak7E2zvFPq9Uz3Yk
         sfbvFYclGMSv53h9xC6Qpx0nJqv1b6bv0fKfo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683650952; x=1686242952;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5PRE+dkDR3gLcpcvdOpvwUpbudiHQbrnvpo0QdDymSM=;
        b=auirDBx0UeZgjyX0G9qquX0/Cxw3IQIHOgDEiD1j2kEDYKfn8e2ILxfgh3hHoKUccS
         nuc9fYL0cGGWot1OpTYcEpk1N8RzZ3P0IxvpG3iQROOdgcn9Zax+JKvhtn2gEEzjuBXB
         9a8hojApwPb/vh6Bn/NVdEYxCIuVfZYQF/fnDVsFCoOBYYNtSR2b2C+EEAWeUDqYknLO
         xTxN4uTNr4FJCrw2xqV6PrmKkbLZSqyoCYFh5nBDGMZPunsnHLWPNysTCOdS55di5wnH
         YtZTjUUBEoacheOpcMC2/NUQ0cZxFj3gpHfmciiok22eBG62JLLT2kM6tC5ftDde2iwb
         xH3Q==
X-Gm-Message-State: AC+VfDxoOMkuL9/rRCq2vfRV3ZNZoGP3I6111DqA7aeKmtwCZpBMUAst
        Bdgq1uGwzKylDcL2QBPD6tCjpPzhbEEJViG8xIiTUw==
X-Google-Smtp-Source: ACHHUZ70dVxCPim5e1Bm6vWgv0WBO54bAqrJFu3e/Gv21UGMfyND7ukSZpoXZKvSyaEVOiJLi9UxEw==
X-Received: by 2002:aa7:d59a:0:b0:50b:5dbe:e0f6 with SMTP id r26-20020aa7d59a000000b0050b5dbee0f6mr12580345edq.25.1683650951850;
        Tue, 09 May 2023 09:49:11 -0700 (PDT)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com. [209.85.218.42])
        by smtp.gmail.com with ESMTPSA id m24-20020aa7d358000000b0050bc6c04a66sm951608edr.40.2023.05.09.09.49.11
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 May 2023 09:49:11 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-94a34a14a54so1213355866b.1
        for <io-uring@vger.kernel.org>; Tue, 09 May 2023 09:49:11 -0700 (PDT)
X-Received: by 2002:a17:907:2d09:b0:966:4d75:4a44 with SMTP id
 gs9-20020a1709072d0900b009664d754a44mr8104241ejc.24.1683650950936; Tue, 09
 May 2023 09:49:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230509151910.183637-1-axboe@kernel.dk> <20230509151910.183637-4-axboe@kernel.dk>
In-Reply-To: <20230509151910.183637-4-axboe@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 9 May 2023 09:48:53 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiH+DopCnUphGEywi-=k=LXmF91YcH4=qsz2qA-a5bpaQ@mail.gmail.com>
Message-ID: <CAHk-=wiH+DopCnUphGEywi-=k=LXmF91YcH4=qsz2qA-a5bpaQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] io_uring: rely solely on FMODE_NOWAIT
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
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

On Tue, May 9, 2023 at 8:19=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> Now that we have both sockets and block devices setting FMODE_NOWAIT
> appropriately, we can get rid of all the odd special casing in
> __io_file_supports_nowait() and rely soley on FMODE_NOWAIT and
> O_NONBLOCK rather than special case sockets and (in particular) bdevs.

Yup, looks good to me. Thanks.

               Linus
