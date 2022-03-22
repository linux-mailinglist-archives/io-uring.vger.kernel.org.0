Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 538FD4E449B
	for <lists+io-uring@lfdr.de>; Tue, 22 Mar 2022 17:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239325AbiCVQ7C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Mar 2022 12:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239326AbiCVQ7A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Mar 2022 12:59:00 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596E964E5;
        Tue, 22 Mar 2022 09:57:32 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id c15so24781352ljr.9;
        Tue, 22 Mar 2022 09:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TWipBvtrLS7SDRJREmYi7xhXNmXrdgMxstsUKJVGDuE=;
        b=G7IqZ71UBXpyaD09zRRZv35E6IQjNOWS/SSNBW5UAnfM4GHf9uJT4rJj3b/YDCt3A+
         6eis8nStO2jnaTjbRwXLsthm2oDAB3vwvYcHsQy54d1OOvn13oAOwbLL5SYVeiqXhmHQ
         ERQ3VR5V83EjdMqE+ZTZlOjQ5QGITMqwqCdktKtWbO3SyGTtX+6bVbpw2Lsg06JKKVKC
         r/ZN3ShnOKZdPM3dvYaSh+DKYbB5CdqqLSfucplI2CFshpcz3/lIVs+Yp2Wy88eIrcqK
         hQFNaTZGtb7w5wT2JEonDuxMgomo5atJQ7aid05aXQG97yQyTvuiekPUGJvXkrK0qulS
         PnYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TWipBvtrLS7SDRJREmYi7xhXNmXrdgMxstsUKJVGDuE=;
        b=XJFVChJo2TTyvo+2zLt2iD3ur+s8Rig/Vrek89p8z+cyh98e/vBBTrsMrzhdOAKCre
         awCeGauZD2RNZg/c2bJms2zqnhu3Xn86vBdKhffB/7HikG/evES46rsPh/6vyDGwi4Yi
         XmG6X+rCcXV9X7icq8/ENJfiCWrBkU/vIO7DFLPEXAjqyNS3Xi0hbj3Hs4mcXdmsA3RP
         8bWfn2Yn3ciOAuo7bf4NgoyhTM34tmebg/NR2OTLwuUX3R6jyHTI0UJuyorumkh9BcI7
         xEfmF7kDDwBK47FM0qEB52J98mf7FCvlzzMVgM+XBLfXmQotUIZrU7TVuNeUHKV4/v+F
         JNvA==
X-Gm-Message-State: AOAM530GKCLvkWQKhQnE7s0XIvi61QsSERP9qFLh4CbLp54h95r+cI9s
        I1bIofJe/uM7FrPdvc1vhIop4s3QO3nLJXt5xs8=
X-Google-Smtp-Source: ABdhPJypKsaffUKrJLUbPFtEm8ZS8M14Y/ZHi1ZyW8gvPWJb8Da3NB80ZPwSsX4MEjwRtEjI3cuSkXUCCALqZo+EQq0=
X-Received: by 2002:a2e:9990:0:b0:249:88f6:f637 with SMTP id
 w16-20020a2e9990000000b0024988f6f637mr6185841lji.14.1647968248527; Tue, 22
 Mar 2022 09:57:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152702epcas5p1eb1880e024ac8b9531c85a82f31a4e78@epcas5p1.samsung.com>
 <20220308152105.309618-6-joshi.k@samsung.com> <d66a6bb2d0974171b44777dd07889473@kioxia.com>
In-Reply-To: <d66a6bb2d0974171b44777dd07889473@kioxia.com>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Tue, 22 Mar 2022 22:27:02 +0530
Message-ID: <CA+1E3rL=Wt=sorCOXxGJ5MJXW+9Pbayy+S2+EuS3tzFh2yGNXg@mail.gmail.com>
Subject: Re: [PATCH 05/17] nvme: wire-up support for async-passthru on char-device.
To:     Clay Mayers <Clay.Mayers@kioxia.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "sbates@raithlin.com" <sbates@raithlin.com>,
        "logang@deltatee.com" <logang@deltatee.com>,
        "pankydev8@gmail.com" <pankydev8@gmail.com>,
        "javier@javigon.com" <javier@javigon.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "a.manzanares@samsung.com" <a.manzanares@samsung.com>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>
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

> > +
> > +     if (!status && pdu->meta_buffer) {
> > +             if (copy_to_user(pdu->meta_buffer, pdu->meta, pdu-
> > >meta_len))
>
> This copy is incorrectly called for writes.

Indeed. Will fix this up in v2, thanks.

-- 
Kanchan
