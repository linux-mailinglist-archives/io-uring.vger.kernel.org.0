Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 340E94F16B8
	for <lists+io-uring@lfdr.de>; Mon,  4 Apr 2022 16:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376846AbiDDOGZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Apr 2022 10:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244291AbiDDOGX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Apr 2022 10:06:23 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14A317E2C
        for <io-uring@vger.kernel.org>; Mon,  4 Apr 2022 07:04:27 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-deb9295679so10748414fac.6
        for <io-uring@vger.kernel.org>; Mon, 04 Apr 2022 07:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/SbAzH3xxHfsnOuEfuoDs7VQok5qMMxv9ZS9+FtaRqs=;
        b=n3MNB9JA16J1JQj8A7WXDMqRIqAKP9AbCjODGm/XgtwuQry6UG17h92DVxby/QEbvf
         kO/Pjo4UlA5UVFueaweJ4uQsxUjXPkreja5974FnkSi4YDogMo5PXgTYVkcG34IM9653
         Ubl7CzZFe+O5f192kVNkOs0gzxWpBsnkRPgrX1wXmu7ZKUuUZxMcjpvKA0XgyZDOy5O4
         hzn+4I/VM2aPcEjGKMZnfnRx6JrJgy1/XALZtLpreIuDYkxvOWkvu3QzUfxNnplnam0/
         hL7Z1h6Bp5wTqD6t3hz1NLVcjKoxnIElrKlQoRw2+IBP4tzZPvreH27bbBAJ5yDZghIw
         vtog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/SbAzH3xxHfsnOuEfuoDs7VQok5qMMxv9ZS9+FtaRqs=;
        b=Gazllwc9rPMXdCxYuLX8A4PMQ2s/+KkgQdp0ViooMCLrzKNDcGW8jnJKorRZa39Fxr
         fpt+VusvyORvJTB0cV1tCiLi3+7jiu1/k8vkqFGH/XvbveJRNfYKBjcuF6iCLBsaLwuT
         2Qd4h61oJ69+TgS6r9lbOOgSFSJi0QOi+RFUEv5LVek1Kv0lrK30UsvUSGQftGdAbNu0
         x/9h22K9IU4LEl7dtXLrcbRFBvrk0bMBKI+qfD9AFOTzAogpp/Xo91PZ6SrVeQ7iGieg
         i1GSUqlCth+xU1VM+0tb9XOSFoE5Mr8gUqhI+nU4vMaJBqFaOWcLyCLdVgqgTdPV3XMi
         hXdg==
X-Gm-Message-State: AOAM5338HPUIgrQ5c81b3pWWfLWYUD2wiy4DZWO0kKwWCDLZ+Zq+U3ad
        OX5OuQHy9T6tJHqTJPCmGQZfS768G1p1JoBRors=
X-Google-Smtp-Source: ABdhPJw++xsLKeC4RPlQi91nltgMnj8F1eq4rOEJG5SkSUXjqjki4+76JjU6juaE5GXsqxhQhjZX+rQTXp2TyrKBGE0=
X-Received: by 2002:a05:6870:d18b:b0:d9:f452:be90 with SMTP id
 a11-20020a056870d18b00b000d9f452be90mr10461898oac.15.1649081067354; Mon, 04
 Apr 2022 07:04:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220401110310.611869-1-joshi.k@samsung.com> <CGME20220401110836epcas5p37bd59ab5a48cf77ca3ac05052a164b0b@epcas5p3.samsung.com>
 <20220401110310.611869-5-joshi.k@samsung.com> <20220404070747.GA444@lst.de>
In-Reply-To: <20220404070747.GA444@lst.de>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Mon, 4 Apr 2022 19:34:03 +0530
Message-ID: <CA+1E3rLPRJmDVuNeRQpbJ9svsKawOCSYg8cLeHjjOYZUbYDD4g@mail.gmail.com>
Subject: Re: [RFC 4/5] io_uring: add support for big-cqe
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Pankaj Raghav <pankydev8@gmail.com>,
        =?UTF-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 4, 2022 at 12:37 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Fri, Apr 01, 2022 at 04:33:09PM +0530, Kanchan Joshi wrote:
> > Add IORING_SETUP_CQE32 flag to allow setting up ring with big-cqe which
> > is 32 bytes in size. Also modify uring-cmd completion infra to accept
> > additional result and fill that up in big-cqe.
>
> This should probably be patch 2 in the series.

Yes, indeed. Thought (for the next version) is placing this
immediately after big-sqe. And make uring-cmd infrastructure to be on
the top.
