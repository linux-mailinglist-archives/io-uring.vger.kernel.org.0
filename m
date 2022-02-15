Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD8F4B79CB
	for <lists+io-uring@lfdr.de>; Tue, 15 Feb 2022 22:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239197AbiBOV20 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Feb 2022 16:28:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233069AbiBOV20 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Feb 2022 16:28:26 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA8FC24A9
        for <io-uring@vger.kernel.org>; Tue, 15 Feb 2022 13:28:15 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id 24so30516ioe.7
        for <io-uring@vger.kernel.org>; Tue, 15 Feb 2022 13:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=TVxWEGcfCbi1M719NahdGHtaD+pm+hes3/++d+n/l4g=;
        b=zX5CyrW4TzeZiLbmDDazf1luRyRVoXBEeK53My2OdUIl/TVNsyoTqf5LvT3jIFpY5X
         fi0STrGADLVwYLMJ2/YbwDl4IBRcg1H64ZY0Jf0xOoDRIcx3fSdB+0XngUzVtZ97GI/n
         YMBWiWja9FiHD/GiEZS0+nJYGvTT4dq0pXauDA4oEBK6B2u7aAYE4OeWL7bQfvdBsLmS
         hozNEXVrdcs/S//Zz8yLX5AhI3/dilyacexs10MivNKLop7Azw5tFDtrPx0Ua8Bt5d+P
         Ip27LmBql2KYsCXo482BbQzlrTE9xt3HtTucBLIPXTKnpzdypWtZz8yBJ9V/Csdv1B4y
         zECg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=TVxWEGcfCbi1M719NahdGHtaD+pm+hes3/++d+n/l4g=;
        b=gvCB4IWFWm2luwbCety+Eyfu6TzepEQa5IXMA5yWdExefmgx7BHOddgssV0gSVtchp
         cMTNudLk1dSknFwWLjVTOygmI/N+mrC3KPYE7C+NgcN1OjaFjoMGzsDBskwXkIrYMUmG
         9qj57cMbfr4a/5GUUvOvIuJWtw7T6GlW5bDaxAu6W0EB1hPemSL0v7+FjC+powKOCvCh
         aNeAVOcZm8ctEXOcm6arTn0YHj7p2bhIgbnqFtAgapXrc4xE3/vUAd/rHJq3bWLnSOxO
         NZYc7ITAALCktkKE2TcinVwvNlknuzZLtBrQkM1TjjZfsfY6tNgCE1HffV+bXcvWScj3
         8Srw==
X-Gm-Message-State: AOAM530mduQ1qiaiM23JjbEoTr+PG5ZA3CNp/F7RJyG50UgqpCctxD+1
        XoknJf2UO+J/ObP+nWPwZIT6UnU9NAa8aQ==
X-Google-Smtp-Source: ABdhPJx9xvkAcrWvIk1MzgZOQgQq7sBQZbbyL7YrQ9jLkApUqrnf4rAZyn4/nO7BLFJK8H4NmY4QNg==
X-Received: by 2002:a05:6638:210d:: with SMTP id n13mr582500jaj.60.1644960494874;
        Tue, 15 Feb 2022 13:28:14 -0800 (PST)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c2sm19843107ilh.43.2022.02.15.13.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 13:28:14 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Stefan Roesch <shr@fb.com>,
        kernel-team@fb.com
In-Reply-To: <20220214180430.70572-1-shr@fb.com>
References: <20220214180430.70572-1-shr@fb.com>
Subject: Re: [PATCH v1 0/2] io-uring: use consisten tracepoint format
Message-Id: <164496049438.9528.3864389411204852885.b4-ty@kernel.dk>
Date:   Tue, 15 Feb 2022 14:28:14 -0700
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

On Mon, 14 Feb 2022 10:04:28 -0800, Stefan Roesch wrote:
> So far the tracepoints haven't used a consistent format. This change
> adds consistent formatting for the io-uring tracepoints. This makes it
> easier to follow individual requests.
> 
> Where it makes sense it uses the following format:
> - context structure pointer
> - request structure pointer
> - user data
> - opcode.
> 
> [...]

Applied, thanks!

[1/2] io-uring: add __fill_cqe function
      commit: 8592d34e8ffa738e4dec7edae3b39055d4215a7e
[2/2] io-uring: Make tracepoints consistent.
      commit: b57d34f5cc694761d9ab89e519cf41045a174a07

Best regards,
-- 
Jens Axboe


