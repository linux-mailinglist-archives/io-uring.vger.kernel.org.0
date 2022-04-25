Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650CC50EC42
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 00:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbiDYWuW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 18:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiDYWuV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 18:50:21 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D92113CA0
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 15:47:16 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id j17so16193473pfi.9
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 15:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qsn7IgujsIjOg8YIG1JS0NVZ0dElgmLNnO5DgD8nQjk=;
        b=wQUy+tHLT69mC8g6JnsPx6vDw3MFBMZar0/DdrcfRZoPF4bCfHnqjsdKSodsgv92Ef
         OauwMIv+kHOKuCFnRawQxg3ttdNz4qRqHD0D1Zoavy7x8rFNYEBpufP0dCNPnCjHMVgd
         HfC/Z2tM4xhjsi3bDj7HQ+i1699MZtLRLNZioZJ8/sd0BbNvSKsW4vb+s+Or2Ec2fQwG
         xW7lv0ueLqjoSRibBtUycKRZJYb09JlHIB2Jxs+wf8///Z4qdNwBgnK7eh4mC2LZ1LML
         YSrXyAzHvoBz4S7BDy9rm64Zgqz3ItvdkBRXpSBifAwqwpXkFHHN52wFHM6Rdz6wgHHm
         8JEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qsn7IgujsIjOg8YIG1JS0NVZ0dElgmLNnO5DgD8nQjk=;
        b=7mgzJJ0Z+E9BGc2tAyD5gwSWWJe2UOYQ3+vzmxhIKrjFRFf/BCD/h8jIlG10exY8YA
         9nlh5A9c5+BZlv83y+UDQ+EfiGox1tYVWqSMpC7I0Zc8KpjGddfwZ23Zm26kEJjtLHou
         86dQwAVBPM67rdRimUu2LH7iieP0A5KFAlulOXuG294hg8jpJ7K0PWsSwAqE/9rctmTW
         84Zph2RmSRdaWimFTJj4rJmA4ZyPsbeBL5paVTuOvPJ3uzY5vPG3YrCgKnE0yIE0zxaY
         cKiIQAth5zhmhArP3fM+gHE+ZYTUAc1vsrA+RPi8JziHbKjOSuSFM4qXMcgJVf9/zUFY
         ybVQ==
X-Gm-Message-State: AOAM530H4Hfekm5Wj+pGcAiHlVc7XrCyD4iMvuFr+yl4P10qiC9ZCQTx
        WGgeEgOOWWUBmggik2UQbvAifm1bXpC5qnOR
X-Google-Smtp-Source: ABdhPJwdBA9ScfQsOsCFQJoiNq8hyYFv9z50BhHttKjnMsNYQ3lX9OkFCANQYNO1qW0qqzL7/2tGSw==
X-Received: by 2002:a63:5907:0:b0:382:2f93:5467 with SMTP id n7-20020a635907000000b003822f935467mr16698091pgb.460.1650926835804;
        Mon, 25 Apr 2022 15:47:15 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i5-20020a62c105000000b0050d46c15da4sm3399361pfg.89.2022.04.25.15.47.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Apr 2022 15:47:14 -0700 (PDT)
Message-ID: <3fb298f3-c3a9-0240-5bc6-9ea84739e915@kernel.dk>
Date:   Mon, 25 Apr 2022 16:47:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 0/4] io_uring: text representation of opcode in trace
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Kernel-team@fb.com
References: <20220425150740.2826784-1-dylany@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220425150740.2826784-1-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/25/22 9:07 AM, Dylan Yudaken wrote:
> 
> This series adds the text representation of opcodes into the trace. This
> makes it much quicker to understand traces without having to translate
> opcodes in your head.
> 
> Patch 1 adds a type to io_uring opcodes
> Patch 2 is the translation function.
> Patch 3 is a small cleanup
> Patch 4 uses the translator in the trace logic

Sorry forgot, one last request - can you make this against the
for-5.19/io_uring-socket branch? That'll include the opcodes added for
5.19, otherwise we'll most likely end up in a situation where it'll
merge cleanly but trigger a warning at build time. Also avoids having to
fix those up after the fact in any case.

-- 
Jens Axboe

