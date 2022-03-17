Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287A74DC976
	for <lists+io-uring@lfdr.de>; Thu, 17 Mar 2022 16:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235593AbiCQPBz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Mar 2022 11:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233694AbiCQPBy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Mar 2022 11:01:54 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7692042A5
        for <io-uring@vger.kernel.org>; Thu, 17 Mar 2022 08:00:37 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id z7so6203679iom.1
        for <io-uring@vger.kernel.org>; Thu, 17 Mar 2022 08:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=J4VwOjzZ+LY9+GtUO8xpCDXQDKcYNJ7STh7gQt1of2U=;
        b=TIMGZkF1w2ezQRvollXGduqDIIdAODt6pKyg7VN7Y9MFI8gB5AEI8B/la5og7KiZTh
         V3I7AS2RViBVCgPbvyfVyra51Pb0fiqNfPyF/fNbG7TBk8wQrPeqjfEGgeYZF909HxQk
         46rjpKKfFBD8I7VNoDA+EZlMbzRiBDfKGJR0c9+MSsu/Hpwb0wflWtUacz6iItatLxhl
         XtIrxQRgklhagAOq3JqAE1jLnYyOpJcqq6b7L3Wg+DWMOC8h5h9vWGF0towr+XqnLte9
         RjbFql89xCkm/PakD5sB8ZxPaE0EmP9tNgBbPqbY85ttkHJJKzImIB5p1TOO4N1wz5oA
         Q7Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=J4VwOjzZ+LY9+GtUO8xpCDXQDKcYNJ7STh7gQt1of2U=;
        b=3THQpu4g8yWvO1DJKJFqwY9KiyIJpV34sfTEg/1QX4ZuRwU61MCAPimKE84/0l8MwV
         tERMl214/1T3kgX9gozxIPLoxugol31AbkVFn61ury+wT0YXlLwiR/7THvk6OqMvc1vl
         Jb+0TpJI70x3T22prskPb+fQ6PCm4ZwobmsymYrIpwsh/bGFROoZd3ZB0EBPfd7OVCXY
         EJZ0H8UJHQhzj8DQiD8MFCewN1CrU9/r2ONwmZ8oL+eeVol1Pky68F3z2gPmKJ/ydxns
         0yDC1Ldrhp0mVX1TEITsDw0Yz4ktZLzEuWnSumLLYVvG+NcwXh+atywXwtH8onSwrDYR
         1D/w==
X-Gm-Message-State: AOAM532+zBhfH7+MIoAYorwbkDMV9J+3s77EheGUhA8zKG09LYcttaHu
        L54nW6zTtlzuilaMJ8ric1AAfHJ+n+2h95EP
X-Google-Smtp-Source: ABdhPJwP/HArQRL2cGtG00RPR9de3+5KtlkCd49Acrx+H7Vm7OCoXgb06c5Z+NOKGryztg09Oi5hjw==
X-Received: by 2002:a05:6602:160a:b0:648:cf59:3613 with SMTP id x10-20020a056602160a00b00648cf593613mr2318985iow.163.1647529236969;
        Thu, 17 Mar 2022 08:00:36 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id n25-20020a6bf619000000b00640dc440799sm2814910ioh.50.2022.03.17.08.00.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 08:00:36 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <16780e103cfd395ad380bab4dbe6cf35cb581d98.1647527537.git.asml.silence@gmail.com>
References: <16780e103cfd395ad380bab4dbe6cf35cb581d98.1647527537.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] tests: don't sleep too much for rsrc tags
Message-Id: <164752923635.67374.16812721047342854913.b4-ty@kernel.dk>
Date:   Thu, 17 Mar 2022 09:00:36 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 17 Mar 2022 14:35:22 +0000, Pavel Begunkov wrote:
> check_cq_empty() sleeps for a second, and it's called many times
> throughout the test. It's too much, reduced it to 1ms. Even if there is
> a false negative, we don't care and next check_cq_empty() will fail.
> 
> 

Applied, thanks!

[1/1] tests: don't sleep too much for rsrc tags
      commit: 77e374c9c1a04578b845ccdac9773c779aa1518a

Best regards,
-- 
Jens Axboe


