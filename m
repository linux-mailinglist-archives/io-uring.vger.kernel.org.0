Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7155F5B3B56
	for <lists+io-uring@lfdr.de>; Fri,  9 Sep 2022 16:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbiIIO7T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Sep 2022 10:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbiIIO7N (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Sep 2022 10:59:13 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3505E138E57
        for <io-uring@vger.kernel.org>; Fri,  9 Sep 2022 07:59:11 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id z191so1606181iof.10
        for <io-uring@vger.kernel.org>; Fri, 09 Sep 2022 07:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date;
        bh=PV3BHWcfZU49ISslZOKbxjeWJNJPDF4ANfPnyXvkgEI=;
        b=e4wWHk7YhUMokZHSEkKUMhY8hPUpo48hYk3ZxikY7HLPNwAzud9fnkajprnMu6RxPC
         TuPmDXOrm14TFTTxWz9FN0tU0S9sMWGytFrfrZyrd4E55cNbEI8tQzvGb5cagQM01QQy
         +67OdPcWSfVGgAxlsgG5YggKrbfkduO4+K8s0+rYiVZno0LEo44UW/Fo0pI8dJ63Lbhk
         znX5waenL/9aR3XX8GX6Mnnwgtk/cfRtm5VcO3tEMjOnP/nSyez4n3qcr6LMdPIl+qt1
         aZSBgc2YJvv3aAq3eqm7ccoqzRSlbMgia/atX5UK7J4W97Sb1CnxESIwKGhA63y8luf4
         3nmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=PV3BHWcfZU49ISslZOKbxjeWJNJPDF4ANfPnyXvkgEI=;
        b=uKhy332Npb6I6nEG6C7FdqsfPMutf49/mKxLPbQHbRXPdFs5za0vyFNYfSK5xp68zo
         DHXYm2hHdLYHk2vzWwScyXRy6JxkzXSUfGbPFqc2/1yyeBNiXItcf/qgmDBFTqxBdROo
         M/K7UvDpQ5vkSJ5SBClrBImn4JC/GLt5xo54FAUbPFISSs/HcZEiXn4GtQAy21nVf12S
         uPxfeeug4nWmeQSAetkkEqMt7RTiarkqt+gvS8Fhoirrd4mNoEhn/eAcyUuLbIm+FIvY
         oEmKp3epDCksOxe3eYdJFg5Gg65xKTBPXxPWIPXxJGZGeK0NT+Z8elh/iP+cb3lhSxoS
         sLmg==
X-Gm-Message-State: ACgBeo3T+ux3VKGr9orS1qhbMcJoQm/8b+maj/3GyOQcTa7Cq/EOoIMr
        USouVKHvsTzF5X42lPmWmUprbzlzl8Gs2g==
X-Google-Smtp-Source: AA6agR4X0esRfx9hzjBn1i9Ci1m4q77XJAdPx/xjROhCz2KXZlaK3mKXIjVdc2aegA6aia+LmDF9Pw==
X-Received: by 2002:a6b:e816:0:b0:688:c999:d08c with SMTP id f22-20020a6be816000000b00688c999d08cmr6970851ioh.100.1662735549950;
        Fri, 09 Sep 2022 07:59:09 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b11-20020a02958b000000b003583b855cc6sm259692jai.142.2022.09.09.07.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 07:59:09 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <89473c1a9205760c4fa6d158058da7b594a815f0.1662721607.git.asml.silence@gmail.com>
References: <89473c1a9205760c4fa6d158058da7b594a815f0.1662721607.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-6.0] io_uring/rw: fix short rw error handling
Message-Id: <166273554926.269928.18385968314574414933.b4-ty@kernel.dk>
Date:   Fri, 09 Sep 2022 08:59:09 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-65ba7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 9 Sep 2022 12:11:49 +0100, Pavel Begunkov wrote:
> We have a couple of problems, first reports of unexpected link breakage
> for reads when cqe->res indicates that the IO was done in full. The
> reason here is partial IO with retries.
> 
> TL;DR; we compare the result in __io_complete_rw_common() against
> req->cqe.res, but req->cqe.res doesn't store the full length but rather
> the length left to be done. So, when we pass the full corrected result
> via kiocb_done() -> __io_complete_rw_common(), it fails.
> 
> [...]

Applied, thanks!

[1/1] io_uring/rw: fix short rw error handling
      commit: 4d9cb92ca41dd8e905a4569ceba4716c2f39c75a

Best regards,
-- 
Jens Axboe


