Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5715862492B
	for <lists+io-uring@lfdr.de>; Thu, 10 Nov 2022 19:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbiKJSQM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Nov 2022 13:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbiKJSQM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Nov 2022 13:16:12 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326D320BFC
        for <io-uring@vger.kernel.org>; Thu, 10 Nov 2022 10:16:11 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id z9so1400059ilu.10
        for <io-uring@vger.kernel.org>; Thu, 10 Nov 2022 10:16:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WqXDyseogDTLpFF0eQHv9pOMaqFVWgVUbVjrKvFMsy0=;
        b=5ycQ1sacv7ViSywRAaNstwvoGkdomC5JIRvZIkKbU9rck8mmh3GieD2uo/M4nG261Z
         vLI8kNdoBruGSniE5hS6Q2HKx3gNULA/IsVx6DseuhOXHBdqxyIItoOhVs5Fr348bUEg
         uPvZAAqzh98Y092uZs+LfzrG2YoRfvEKEmUpoDiBy98sgY8S0SMBL9GTDx0R3jyBmFYf
         iHbhizld9PESZraYOU9OPtQ1YZrwwoUMNT1Y10lzqX3Tb2yiZ7I+R7t8wsXwjTiHjyTJ
         dKvwF5X/gV53zx4r+2UBR9mS2SkTxFvo7EXjoTESAJuKLva+E7r+DAdGcCCZ7WrOSmdX
         L76g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WqXDyseogDTLpFF0eQHv9pOMaqFVWgVUbVjrKvFMsy0=;
        b=MNaEE7WT5C7E9DundC8nmps/5VT4ceMZmgoSJP+4fv+J9TfpugRpF/kP7UnyiFwg2h
         NB5np+H41RzBuYxbNWd1bMl4T2fp5JVcFDG9vHJ7wZ2UW3jHRy9UnVJBoADG5sQNgHCX
         5d6gJJ0ZJUJFuiU8VB/kfsdK78g/RdcsM0UsH7WYBDtg5Pg+uswFDbLipHCf1ZamDCBL
         9unC2Hp9RdkMH+WE9qu1lOKM4jwUV4DBdrVheHDDAfCBn7+qPd2g1C9vI9IBxaHvGY3o
         37W03FToBMyfwMlZJpmfF8y4ZlFkvfUVirKRU17T+8/IgRUF1zBRliUoYqBKkkBAb06m
         /xdA==
X-Gm-Message-State: ACrzQf0du2KOtxEn13rL/bQLE64uiDFNCjF86rHxBNhAwCABk1QvsZ4U
        1ktJNSLe0fbVj2RM+kcWiB8Xf66zd3JzKA==
X-Google-Smtp-Source: AMsMyM7wUzyJCMy2ly1qpNqkFird1qvyTn2mB5jZlKmwnt+SUAUKAgFGKJ0Y/tZ8LeRzzgTrXsVB7w==
X-Received: by 2002:a92:d84a:0:b0:300:bee0:1468 with SMTP id h10-20020a92d84a000000b00300bee01468mr3307519ilq.129.1668104170287;
        Thu, 10 Nov 2022 10:16:10 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s2-20020a02b142000000b00363cce75bffsm31120jah.151.2022.11.10.10.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 10:16:09 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lin Ma <linma@zju.edu.cn>, asml.silence@gmail.com
In-Reply-To: <20221110060313.16303-1-linma@zju.edu.cn>
References: <20221110060313.16303-1-linma@zju.edu.cn>
Subject: Re: [PATCH v1] io_uring: remove outdated comments of caching
Message-Id: <166810416930.167294.6129265009506240894.b4-ty@kernel.dk>
Date:   Thu, 10 Nov 2022 11:16:09 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 10 Nov 2022 14:03:13 +0800, Lin Ma wrote:
> Previous commit 13a99017ff19 ("io_uring: remove events caching
> atavisms") entirely removes the events caching optimization introduced
> by commit 81459350d581 ("io_uring: cache req->apoll->events in
> req->cflags"). Hence the related comment should also be removed to avoid
> misunderstanding.
> 
> 
> [...]

Applied, thanks!

[1/1] io_uring: remove outdated comments of caching
      commit: ff611c848d0fd408ce90ef93a09ea0a70400cd86

Best regards,
-- 
Jens Axboe


