Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1320534858
	for <lists+io-uring@lfdr.de>; Thu, 26 May 2022 03:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236677AbiEZBtQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 May 2022 21:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235790AbiEZBtO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 May 2022 21:49:14 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7318DDD2
        for <io-uring@vger.kernel.org>; Wed, 25 May 2022 18:49:13 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-f1d5464c48so662075fac.6
        for <io-uring@vger.kernel.org>; Wed, 25 May 2022 18:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DpFXJWBWMU2S173dU5ZmNlrwItye5+CaS7bedaWyo2c=;
        b=PAnCv/I+GkBzHlxI9nIgirJwBjXk9Mox2CN6yfpYINh6xweRPIsgOnq8Om+MPvtE/v
         62WE4LNscyajsRTylf+MQYqkRqaa7wr0ONXiZLKoAjuOSn5zznwfN7OgLGlB4VP3D30A
         x7u0i/P/NgB2ITVLLCzZH5WCQbo/FhWYpk1rZRHowuwBkD56eJQmLjkHY+FBeWpTWXVA
         7w1wwpdJ0gwNrlNX92q4oXFlOtHIas1usUEitf61QDMkzXOrHDsEcUP0rw4hmJUn3C76
         cd4JeUEx2SnX315iIcMUbqMHaIVGFJ5ZFhGIst3UGqaR2gKi7qw/ruOdM2kC1ew0CbVf
         M0hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DpFXJWBWMU2S173dU5ZmNlrwItye5+CaS7bedaWyo2c=;
        b=H/TBGj8ZGMiT8MXeFcWcSzEvP1VFZHpXhwG7hnsb83jE8VlFIgjJ6SiYYJ5AuHOntF
         wpSquUuJk2m3zIJ/FgxVFwpvP6xZwaQIfDHrLb9pnWeji/k+oW8LqYtVeoR5ww+mihms
         u+c6ViH2sp4C+Y/GJuLSI91ZzB4OAIoKZe0TmkFyVyQwVDHlPkKc6b9kG1NQMV1u/Bpa
         KlLiGTuVlR6Zbv5vRzRjP4GLWAsOu5DILEbMTr0YUElt8fCDlFX4saQVL4Mzxu/kqsl/
         4PUMoJnk0lsTe/nfGMdW4h8+OMvXtBoQFTI94IVbMPksIKKJHxyY7oN0dPmJcmcmkwbz
         80Cg==
X-Gm-Message-State: AOAM532pjRMxD1SP/c9dRFTEsFPzsMeNRTJhD2W7AI3bXTlMku4GYpGA
        bCIQoBMGoW88WCCeCXkg5DnnBecdggoYes/VD3g=
X-Google-Smtp-Source: ABdhPJyssQsyTmeeKTi3G3EF7NIHMJXK1AZl+6w39qdXtZfTgz2SDONWSg6GptLnagOCoMwUgnMSocu7CilvMGwwR/0=
X-Received: by 2002:a05:6871:295:b0:f2:cd84:9c3e with SMTP id
 i21-20020a056871029500b000f2cd849c3emr13619oae.284.1653529752570; Wed, 25 May
 2022 18:49:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAN863PsXgkvi-NLhyLy-M+iQgaWeXtjM_MBoRc0H0fq2jTfU1w@mail.gmail.com>
 <921eb447-d3f8-95d3-4ed7-c087bbcfd44c@kernel.dk>
In-Reply-To: <921eb447-d3f8-95d3-4ed7-c087bbcfd44c@kernel.dk>
From:   Changman Lee <cm224.lee@gmail.com>
Date:   Thu, 26 May 2022 10:49:01 +0900
Message-ID: <CAN863Pv6zVTvgZA30VcuSvPZojUCvNCB3We--Na8ZPNQjA_9Jg@mail.gmail.com>
Subject: Re: io uring support for character device
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
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

I have both ->read() and ->read_iter(). I'll negate a ->read() and
a_ops->direct_IO() because those were for testing.
I'll go over my io_uring test code in user space.
Thanks for your advice.

2022=EB=85=84 5=EC=9B=94 25=EC=9D=BC (=EC=88=98) =EC=98=A4=ED=9B=84 12:00, =
Jens Axboe <axboe@kernel.dk>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> On 5/24/22 6:56 PM, Changman Lee wrote:
> > Hi List,
> >
> > I'm CM Lee. I'm developing a custom character device managing pcie dma.
> > I've tried to use io uring for the char device which supports readv
> > and writev with synchronous and blocking manner and seek.
> > When I use a io uring with IORING_SETUP_IOPOLL and IORING_SETUP_SQPOLL
> > for reducing syscall overhead, a readv of the char device driver seems
> > to be not called. So I added a_ops->direct_IO when the device is
> > opened with O_DIRECT. But the result was the same.
> > This is my question.
> > Q1: Does io uring support a character device ?
> > Q2: Is it better to reimplement a device driver as block device type ?
>
> io_uring doesn't care what file type it is, I suspect your problem lies
> elsewhere. Do you have a ->read() defined as well? If you do, the vfs
> will pick that over ->read_iter().
>
> If regular read/write works with O_DIRECT and reading from the device in
> general, then io_uring will too.
>
> --
> Jens Axboe
>
