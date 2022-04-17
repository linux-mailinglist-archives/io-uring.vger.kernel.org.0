Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A5450480B
	for <lists+io-uring@lfdr.de>; Sun, 17 Apr 2022 16:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234232AbiDQOlo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Apr 2022 10:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiDQOln (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Apr 2022 10:41:43 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A544413D22
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 07:39:07 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id k29so14533687pgm.12
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 07:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=+c5bQA2c7ipx6WjQtw3y8SJmAhHJmN5ycEIOz8nML/E=;
        b=bxG6cDxeVUJxkxwTp/SDf4rpH1D7PmVlSCFYwAjoZcw3QwdnU34EXI/fasU9pGzAkb
         SjMQLXi0UAMLr8dnW5LKAD12RMCWDyze6YEwLwIYb6EMkPMfeXLLGOs5N+xXFwlVoOxp
         ylfETl9eo8X5EyBr03ejTL6PVlyUpBC4Wlkfq4GWkFUkxmN51eKIXUTRpvtTNaUWY3wa
         8OM0BPcWoEGlD0mFA8942Fnej3z3yOCe594wON6ieVc2PClfDLXnnD38tuW4QNj17yPA
         mPcRqh+snd7QP5U56XDg6d1dYm/qjjNxo74ZKIkauF1LdDpGoX+hpGxzbpLOKsnQ3VAO
         q4bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=+c5bQA2c7ipx6WjQtw3y8SJmAhHJmN5ycEIOz8nML/E=;
        b=10K0Akhd0UUN11OBi9Dy4BYOIC2iQnvTRub9Q6zOA2+1sUYLE12xvsXXsWQgNbF9EL
         AvIP4HO6AnlqDIeXvpDj5p1hjPh4rLp0f3BV1aLqz+HelrA36X6CUlhlQBbkbWDjzlRQ
         C994KUkYxAlQp3MmJrbfdJeUGwsXrx7+9PeqOXxmqHFH/KCU4BvCA8BAY67eP2ACU57E
         IKsecILDf04mw/S3+VDKG7P+bfssjAzGupgxeLFCdA28Q/y05l86NhEajkf2vHw7zLLn
         YiwS0Aqw0kGEIg7QedcnzHjx4HW66HtkRaR9+d3XIx8FkFYqn1vubrPCR1C91+m7ZjS7
         xvTA==
X-Gm-Message-State: AOAM530PYRH9v8eXaH1DXZ06dB1qlAJXb0AVltX9YgPCwxxprsqGcXYX
        tnA8ttns31P8iCwAnG6BYvG84fmlsKevSzx2
X-Google-Smtp-Source: ABdhPJzSpw1/W0YijzB6lZ49d5qLCBZ++z/dDGwgcWw6I6YNwCKO0nVnY45VuBChK0B/dLkzJq2W1w==
X-Received: by 2002:a05:6a00:2489:b0:50a:754c:c557 with SMTP id c9-20020a056a00248900b0050a754cc557mr606645pfv.37.1650206346978;
        Sun, 17 Apr 2022 07:39:06 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h189-20020a636cc6000000b0039841f669bcsm10178605pgc.78.2022.04.17.07.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 07:39:06 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, asml.silence@gmail.com
In-Reply-To: <b868cdd8d996a53a196e9cfb8807d07d318ef876.1650205541.git.asml.silence@gmail.com>
References: <b868cdd8d996a53a196e9cfb8807d07d318ef876.1650205541.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing v2 1/1] tests: add more file registration tests
Message-Id: <165020634582.44701.4913543269306468944.b4-ty@kernel.dk>
Date:   Sun, 17 Apr 2022 08:39:05 -0600
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

On Sun, 17 Apr 2022 15:29:27 +0100, Pavel Begunkov wrote:
> Add tests for file registration failing in the middle of the fd set, and
> mixing files that need and don't SCM accounting + checking for
> underflows.
> 
> 

Applied, thanks!

[1/1] tests: add more file registration tests
      commit: da2f4ce1722b38fcf72641fea0bf6a296f0cfdc0

Best regards,
-- 
Jens Axboe


