Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE334632A6A
	for <lists+io-uring@lfdr.de>; Mon, 21 Nov 2022 18:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiKURKK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Nov 2022 12:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiKURKJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Nov 2022 12:10:09 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336F5DED0
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 09:10:09 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id x13so2642891ilp.8
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 09:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EtkWtcbaJkBmtGU/sjvsDJMEYXWMEHtOYjWjLql/jWM=;
        b=u6ToD3K3HLr55Fbq2ZXMTEjJ8SI6oftuawXhN0txHczgJ5WrclEks6mjqNgtmvdKlW
         +/Z4Q4bTIKHYV/fopN124P4hSUd7gloi9W+DBe3/looaRetKHQhaik0YXD495IzeYjDT
         OPaLi+GQrsdlKVaWjiIiXvGsplurb/F5bPQK41uoDRjuUhl5xmOLZe6VTltd+zY12JBS
         Y5mw2cOoudnoYEcdf1c/4TONiORWUR7TtgM0dv3UvxJWKECVPIh9vqv9eq2DoQptfnPi
         THgem2JoHOtFOLCmrf6oPbM9HWFKhXWQx7LcTi7ZzSouJShftc5Qz1jAjCHD78XcUwLR
         ttzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EtkWtcbaJkBmtGU/sjvsDJMEYXWMEHtOYjWjLql/jWM=;
        b=Y/Bo0TUxKle4KLUJRrKbHYZj3LXN/LA+Ml78aPtMsmUPgc4NHk7XAaeAtVewItWCNf
         MhrLKZnS/EBkMJBLzQxMADjyUpuLGZMlzfuWjtjHT33uBo+JhrQg9gUjIq63FL0pglG9
         QPHsgqh2synqAp/UTd/6z34EwiSVYTsiOvzTyRKixm2uiacdkEZgsiVEYUt23jsMc1bx
         t2+scOOG/yoIP/tdJtj+Srh1kFxu4Z90ynR86wvFKHU+K8ap8acNfrMsZ6ohRiGhXSl3
         /oJozAJH5Wee7sVRsOAh6vTjIPpAnJSodIr4QnR1BILIca69+PLWop4j2iDBJRQElIpe
         bjzA==
X-Gm-Message-State: ANoB5pkT/besM/Tb0BoN3vToQgZTEF6XiBVB3gvpvpYaWAy9XjlWTSUy
        3xoFUS5CDHvtuqUe19cO07o382SKrjJ6tQ==
X-Google-Smtp-Source: AA0mqf4cb2uK7GeXDDGUND89K6QVwZwgZLU7lN7UBQDMLHHHYlo8vg2f1rqXaKSs4w8hyyeYaTLy/g==
X-Received: by 2002:a05:6e02:1210:b0:2f9:aecd:6397 with SMTP id a16-20020a056e02121000b002f9aecd6397mr8680225ilq.100.1669050608247;
        Mon, 21 Nov 2022 09:10:08 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f9-20020a056e0204c900b002f916f15625sm4056414ils.23.2022.11.21.09.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 09:10:07 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <cover.1668963050.git.asml.silence@gmail.com>
References: <cover.1668963050.git.asml.silence@gmail.com>
Subject: Re: [PATCH v3 0/2] poll_refs armoring
Message-Id: <166905060765.3007.1682250454703276983.b4-ty@kernel.dk>
Date:   Mon, 21 Nov 2022 10:10:07 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-28747
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, 20 Nov 2022 16:57:40 +0000, Pavel Begunkov wrote:
> Make poll_refs more robust and protected from overflows. The mechanism
> description is in 2/2. 1/2 helps to make the second patch a little bit
> cleaner by tunnelling all edge cases from arming to a tw.
> 
> A good way to test is to set IO_POLL_REF_BIAS to 0 and 1. 0 will make
> the slowpath to be hit every single time, and 1 triggers it in case of
> races.
> 
> [...]

Applied, thanks!

[1/2] io_uring: cmpxchg for poll arm refs release
      (no commit info)
[2/2] io_uring: make poll refs more robust
      (no commit info)

Best regards,
-- 
Jens Axboe


