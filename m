Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D745154D3B8
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 23:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345012AbiFOVad (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 17:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245104AbiFOVac (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 17:30:32 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF8F562CD
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 14:30:31 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id f65so12527227pgc.7
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 14:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=Q3ctwpOVXgOge5Z4dYI4HCHXl52SZI7LhI6V7iwVL88=;
        b=AQshWtAJsKctEsOAg8pqEpRFnHz+hB4JqzD1CMtHeCQXfPB1LtOMV4qaMHgZFa5SCO
         n5K72KnLmpvkDHPU3GOlf/LlaELMJIql3jZ4o7Gor0ZF5y6aoQz454P2AXjEvgLe+yg3
         Z1Mj9aEmjuvokH3j4V3zXOMu25pwQ3KnJ1alnU1mVWbIkZ/3UuetkD93Y+9IYMQaM9gk
         W8+liasbVHZclo0Rs/9CXM1jUz845kCoXUBB8OlIiM/gpCKq7WkAvu+biv57KV1JleeV
         iOGmXlADRgI8qHzBWc+sNDTO9rFkcg7+Zq3a5XBPSU5gBqEIhZiNSHKxDK0SsGjpIVfc
         AIBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=Q3ctwpOVXgOge5Z4dYI4HCHXl52SZI7LhI6V7iwVL88=;
        b=hMcfA9z6KOQPSwoJwK9qqb6VTh93vi1ZfPUOk4bsNTeehr2GBO6ptkmoL5R7d2G0ZY
         SbYaSudlTRXy4/U/1NhDDdxmyw+7svPu4FrsP87lNh0MOJZUZvfUNr3VN9nyDB+nwpui
         4CgTbbvqBhgtXPx404afRyfUSOj/qLjAKub6uXQpUMVwpV5tajFxZeQtwbIdlMKvLvoI
         qyAuQM4glKs35ySi1WuuabrYPmBas+doa+36Pxto+8/wn4lHn75Hl5kSjld+hfOOSVJ5
         Y/s+kLBMv1qwmvvXpch7W9H52ixBqUq0qD/HVrQgx4CasP4Zao1QIgDJn8fsJypBM+Iv
         XfIw==
X-Gm-Message-State: AJIora8g1Xk6Znd3XbZd/2T4TbYstvn9GyW8WDdr29FUWhv13C1StaVl
        hzBzCW6P+VJt1nt6d+ge++28Slsyh5NdIQ==
X-Google-Smtp-Source: AGRyM1usKpw/CdYzcOLzECj/Gdt+i5Q55EqoQR4dJ18x0Hnzb7n7//rMuL5ThmozKTJwo9jLd/BR9g==
X-Received: by 2002:a63:b516:0:b0:408:c56d:ecc0 with SMTP id y22-20020a63b516000000b00408c56decc0mr1511543pge.261.1655328631363;
        Wed, 15 Jun 2022 14:30:31 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b11-20020a17090a5a0b00b001e858081882sm2232870pjd.27.2022.06.15.14.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 14:30:30 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, io-uring@vger.kernel.org
In-Reply-To: <cover.1655310733.git.asml.silence@gmail.com>
References: <cover.1655310733.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 00/10] 5.20 cleanups
Message-Id: <165532863069.858238.3952793587863469883.b4-ty@kernel.dk>
Date:   Wed, 15 Jun 2022 15:30:30 -0600
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

On Wed, 15 Jun 2022 17:33:46 +0100, Pavel Begunkov wrote:
> Simple cleanups split off from a larger series.
> 
> Pavel Begunkov (10):
>   io_uring: make reg buf init consistent
>   io_uring: move defer_list to slow data
>   io_uring: better caching for ctx timeout fields
>   io_uring: refactor ctx slow data placement
>   io_uring: move small helpers to headers
>   io_uring: explain io_wq_work::cancel_seq placement
>   io_uring: inline ->registered_rings
>   io_uring: never defer-complete multi-apoll
>   io_uring: remove check_cq checking from hot paths
>   io_uring: don't set REQ_F_COMPLETE_INLINE in tw
> 
> [...]

Applied, thanks!

[01/10] io_uring: make reg buf init consistent
        commit: 8c81b9a8afeb9bf9a77ed7b8ae18fdcdd5e8738c
[02/10] io_uring: move defer_list to slow data
        commit: 2946124bd54c6bde7d8223764f9e29ee5e9c2872
[03/10] io_uring: better caching for ctx timeout fields
        commit: fee5d8c21d58b32c0e7f4dbddfa79ea2badfe080
[04/10] io_uring: refactor ctx slow data placement
        commit: 5545259f66477791ead5305d080e7315ab93e1d2
[05/10] io_uring: move small helpers to headers
        commit: 8f056215cea9a0b8a86d980c71da5587291f11c8
[06/10] io_uring: explain io_wq_work::cancel_seq placement
        commit: 588383e3417729d24c804d43d9f08f3b1756c5cf
[07/10] io_uring: inline ->registered_rings
        commit: 9d0222c4d9d1de014fea4ef151e6743b8eb30e8a
[08/10] io_uring: never defer-complete multi-apoll
        commit: 5bbc2038f4d8f3de273c74779882ecb9a959a46d
[09/10] io_uring: remove check_cq checking from hot paths
        commit: bc132bba5459cb501737c5793d1a273354dbf8db
[10/10] io_uring: don't set REQ_F_COMPLETE_INLINE in tw
        commit: 01955c135f1753e60587fc28679fc1fab8ebc4d4

Best regards,
-- 
Jens Axboe


