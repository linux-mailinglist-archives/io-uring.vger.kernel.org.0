Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251F5557D64
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 15:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbiFWN7J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 09:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbiFWN7I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 09:59:08 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252173B031
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 06:59:08 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id k7so6573573ils.8
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 06:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=IqSSfCXsViRxOovSp5l6sru8BMugICn/TP1Rcaxbzuo=;
        b=adqPcLUSlqHsgVAqNSABdHx9Bql2qRjtsg23aOekDeU9Dz7rK1URmsJPPkSrJfkl7e
         mFWS8aPcnBr0fDBQo2XMrbldKuHwIuc7H7e5aiGPnceWxqe/oo3A+lG26Tf5LPiUJz7d
         Mtqh8C+0xW2FxPW76Nx7rG5sN3P4d6fdo/oDNc64EQvWlm9s/NhgXxnS1yBXjGSx9mrz
         PTvmLuyCzubz8jT6pjZnGLh6t4pc+GD807Pdcc8wqYW8aiYoGa6rC6QMG805EEbaj4+N
         148zDNEizXyKGkwbM+j29lmeaPHON0bNFpqqznV+Vx/u2zH1gGs+icXqszoF3eqhZ4p5
         ANow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=IqSSfCXsViRxOovSp5l6sru8BMugICn/TP1Rcaxbzuo=;
        b=vy8OKjBfvJ06h39IqWHQCVj6dtpxWAM3JyobfrDr70nUHEEq8keCr8Dv5cX2log23o
         cVnY8uA8ezRQuMbmWGJfPB1ErnATDv9Qwh30QxlupNF9YTBSVBBHtlSle5CsngUauDGa
         ApISYcEpmTqzC7c4TprxOtHZaoWiTsY6dH1cGVzGu04IG8gxQUzHy94My9TFvuYnuBjf
         t5FO7VJ4IBogdI9BhlK+1Od1Hm7ra/YiYotbOnm4QEA2ntRiLd/0QzS3PjRTcOaqilo4
         Cf7zSXL10O0+rlkrNlVBVcuKRMjmG4hzonbYvkRXmImC14JSaZhFQl2zKyXXGEoOJWuu
         0F9Q==
X-Gm-Message-State: AJIora+VNkdD+Eu1W5J39+D38NjpHLp38AERxogXsyeYMo68OdasDbBh
        8eFTsIjbn4NBQw/c8CWysRY0+J0HXeSLNA==
X-Google-Smtp-Source: AGRyM1u5vFakbAD8mHRfeTKifvr9VB602/pFSMKfTQzGfVk/Q0m1JocJWN7uLPikqm0PanxUh8RlqQ==
X-Received: by 2002:a92:cb45:0:b0:2d9:873:bf80 with SMTP id f5-20020a92cb45000000b002d90873bf80mr5445319ilq.91.1655992747523;
        Thu, 23 Jun 2022 06:59:07 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p192-20020a0229c9000000b003317fc4aa87sm9855119jap.150.2022.06.23.06.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 06:59:07 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, io-uring@vger.kernel.org
In-Reply-To: <cover.1655990418.git.asml.silence@gmail.com>
References: <cover.1655990418.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next v2 0/6] poll cleanups and optimisations
Message-Id: <165599274699.473609.6271610572105303867.b4-ty@kernel.dk>
Date:   Thu, 23 Jun 2022 07:59:06 -0600
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

On Thu, 23 Jun 2022 14:24:43 +0100, Pavel Begunkov wrote:
> 1-5 are clean ups, can be considered separately.
> 
> 6 optimises the final atomic_dec() in __io_arm_poll_handler(). Jens
> measured almost the same patch imrpoving some of the tests (netbench?)
> by ~1-1.5%.
> 
> v2: fix inverted EPOLLET check
> 
> [...]

Applied, thanks!

[1/6] io_uring: clean poll ->private flagging
      commit: ca8aab2d93e54d0bfdc64fbfa7c37240a203b10a
[2/6] io_uring: remove events caching atavisms
      commit: 9d58ea28872333759105106ed61c425297a6161d
[3/6] io_uring: add a helper for apoll alloc
      commit: 2ab0dcbeb5ac1ac3293cff63588fc942374575f2
[4/6] io_uring: change arm poll return values
      commit: ee97dcc84c31a7613c6fe1325cb1fa4d5a6ff7a9
[5/6] io_uring: refactor poll arm error handling
      commit: d62352aaf4e0edf33afcf4dfb5ad60fe323153fd
[6/6] io_uring: optimise submission side poll_refs
      commit: eb4301033a2ce2a234f2e36d59b6ee761d5dd76b

Best regards,
-- 
Jens Axboe


