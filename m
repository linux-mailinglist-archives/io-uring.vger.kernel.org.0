Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36CE17802F0
	for <lists+io-uring@lfdr.de>; Fri, 18 Aug 2023 03:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356807AbjHRBQY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Aug 2023 21:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356870AbjHRBQJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Aug 2023 21:16:09 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FE5421F
        for <io-uring@vger.kernel.org>; Thu, 17 Aug 2023 18:15:26 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-5657659a8a1so81289a12.1
        for <io-uring@vger.kernel.org>; Thu, 17 Aug 2023 18:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1692321310; x=1692926110;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m0OZI4NJnVebNM6+xyzwnKsD1iMAOA59kDaPSqooa2s=;
        b=o63LFo902MW3jOMihEhTthkAapz32a8B14io7B4LRVjqDuG13Ue5OxpXnJBUZGVnyG
         03RA88lMAR6UKQX8vGB8lj0F+tLePgx5ynoUORrZAD4gY//TsVr38UUC9Z3rpPKj8JQ4
         Lt2gngGzRIE7p0mXq4yTNP2tRoTWKjfs0Ncp8lPvTnaz0WT/ZRucUlCIWeutorLT8uQS
         YqzndBepB4nOWt85vsREbBi/5VuL0m95ikk1N4tNtynrlrEixZ9SCMAXKFQmAx4trnWQ
         BH8LNsc/8cHblRZ8LRtHSkm+6meWhuMs/a63NmbNMPyKyf2OWcfJV3u9ElV1sOOWVXqt
         urfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692321310; x=1692926110;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m0OZI4NJnVebNM6+xyzwnKsD1iMAOA59kDaPSqooa2s=;
        b=XlKKLLymOjUM0oAfD3+t2IFB++GedXnPhJsSMgjTbZEs1Nm8dnYbwqt30tjZBYdYrO
         jGxZfdQJyw2hcZPsfFJeSDZiGbEMZTdy8A6sJ5k1B00cgd9Q9FlmM2gqP+GHNI2fT+UH
         CoDC6vYItPBtQVUc7QLFf+vsCOux7yeazXIAVA/jQ9Y8DZ50ZDdsc3sgGv/NIK8AZT9o
         BZ60AGJzlf3FIRarW7QsW+obhaXmk0VCI4RWukFX/23VgZBJCzlAM5D/43rw53AIda4u
         wGv4VTy6x37s7DtIcIoUTbr/hEYx/jpPZ3muKlf3RiAupRmbzx936guQzFfkKaV/xdPc
         tv0Q==
X-Gm-Message-State: AOJu0Yxr0Bir5CwKrCHNsgvoeh1w1A/etieOCTl6O2FnE8fwy6bhujZl
        dQOu/LvcpKxPL/iKaSLi90mBpw==
X-Google-Smtp-Source: AGHT+IGQubHAAfLcM9gFxNKvlfXNaq4wEeNmXlj6d+JqwuLxwHoSVzghFX4bWwVbT5cYfcDW4zVlnQ==
X-Received: by 2002:a05:6a00:1d85:b0:681:9fe0:b543 with SMTP id z5-20020a056a001d8500b006819fe0b543mr1234120pfw.2.1692321310699;
        Thu, 17 Aug 2023 18:15:10 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j12-20020aa7800c000000b0068842ebfd10sm358490pfi.160.2023.08.17.18.15.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Aug 2023 18:15:09 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Kees Cook <keescook@chromium.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, linux-hardening@vger.kernel.org
In-Reply-To: <20230817212146.never.853-kees@kernel.org>
References: <20230817212146.never.853-kees@kernel.org>
Subject: Re: [PATCH] io_uring/rsrc: Annotate struct io_mapped_ubuf with
 __counted_by
Message-Id: <169232130924.700993.10043093294166679219.b4-ty@kernel.dk>
Date:   Thu, 17 Aug 2023 19:15:09 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-034f2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Thu, 17 Aug 2023 14:21:47 -0700, Kees Cook wrote:
> Prepare for the coming implementation by GCC and Clang of the __counted_by
> attribute. Flexible array members annotated with __counted_by can have
> their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
> (for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
> functions).
> 
> As found with Coccinelle[1], add __counted_by for struct io_mapped_ubuf.
> 
> [...]

Applied, thanks!

[1/1] io_uring/rsrc: Annotate struct io_mapped_ubuf with __counted_by
      commit: 04d9244c9420db33149608a566399176d57690f8

Best regards,
-- 
Jens Axboe



