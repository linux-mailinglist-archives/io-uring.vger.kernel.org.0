Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8266558AC73
	for <lists+io-uring@lfdr.de>; Fri,  5 Aug 2022 16:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbiHEOmC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Aug 2022 10:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240958AbiHEOmA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Aug 2022 10:42:00 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8D95C34B
        for <io-uring@vger.kernel.org>; Fri,  5 Aug 2022 07:41:58 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id x64so2065223iof.1
        for <io-uring@vger.kernel.org>; Fri, 05 Aug 2022 07:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc;
        bh=CNWmpGenZ4D4EVN2XGPr2IxRT7UKlPqdE7XvQmEe4vU=;
        b=xhK3JZRfJmFe7uZI22ExX6aAjY3sM0mLDlPWaQQZrej2+ppmjio7MEVTrU5TCcS2OZ
         jUReVVgFU24tgzdhUSTVBhu3D+dEf1ingtXtFuKquukKhFp0QD5v25tb8en1PnVevf6M
         22aoBne4OanH1nWSJu53nN73bIbcBHYba5VJoTPl/R7a5+ST5SXQNIRp62pB7FO0NLcT
         CaP1blMowgEL6bTLxWg3gL1gnKLkCd1JrCEAWhWOl++/y9reAe+n1d0xRNIQOGMqavfp
         e+Fe6iWdLqgIrzuB6K0yaN5O80ItiJnmKpst4yj6PJVD2GfpaFAR0zfLsiNI5luOCQyJ
         oh2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc;
        bh=CNWmpGenZ4D4EVN2XGPr2IxRT7UKlPqdE7XvQmEe4vU=;
        b=Y1+Z/NeANAZkcYlw5ozOepByBUwAIGp2zadCV0xYdwOUpLx2p1rORRk36bF59ENrxo
         6LhIWf/CQULV7fKNsECzWM50zIuyly9gHNifqsnqUJnBsIbceLOl1sKeJ3i9DQ0pMr3s
         KkLzl0YQVHaUETkrsgSVXrAqSwbOVy07eejvbZU64pYZhc9segcRSmVbz/msyXfxn6hl
         fRivhphtNQQahIEFy2C3WvJDnZ+h7jc+oGYV3r+3zLGwv/6w7lqXT9Tbe5pNk8xQFg4p
         8+E7uy4ebof/7FLxukz9TbClR2vy0Cnhzt7T3g1+Gkza082LAvfW8fPU3TlwrDQi+7zL
         KCdw==
X-Gm-Message-State: ACgBeo1IWZ55dg5FJfMcHlW0mEumPPxEyWmNzWI9bWodMptOTFYjsVE5
        UT97l481gpueHQO0rWLb8ANJ/w==
X-Google-Smtp-Source: AA6agR6n3ZR59c47DNsX3mVP6Po55ltr4LdA3c2eemSFjWVqvoGWinHiXEvlKA5g8CuFR9wF7ikCQQ==
X-Received: by 2002:a05:6638:24cd:b0:342:afb5:8c34 with SMTP id y13-20020a05663824cd00b00342afb58c34mr2968971jat.117.1659710517953;
        Fri, 05 Aug 2022 07:41:57 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a13-20020a02ac0d000000b0033f5e8dab90sm1752374jao.143.2022.08.05.07.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 07:41:57 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, asml.silence@gmail.com, dylany@fb.com
Cc:     Kernel-team@fb.com, lkp@intel.com
In-Reply-To: <20220805115450.3921352-1-dylany@fb.com>
References: <20220805115450.3921352-1-dylany@fb.com>
Subject: Re: [PATCH] io_uring: fix io_recvmsg_prep_multishot casts
Message-Id: <165971051691.381116.14198500482205549150.b4-ty@kernel.dk>
Date:   Fri, 05 Aug 2022 08:41:56 -0600
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

On Fri, 5 Aug 2022 04:54:50 -0700, Dylan Yudaken wrote:
> Fix casts missing the __user parts. This seemed to only cause errors on
> the alpha build, but it was definitely an oversight.
> 
> 

Applied, thanks!

[1/1] io_uring: fix io_recvmsg_prep_multishot casts
      commit: d1f6222c4978817712e0f2825ce9e830763f0695

Best regards,
-- 
Jens Axboe


