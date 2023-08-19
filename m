Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94BC0781A4B
	for <lists+io-uring@lfdr.de>; Sat, 19 Aug 2023 17:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbjHSPFL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 19 Aug 2023 11:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233680AbjHSPFL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 19 Aug 2023 11:05:11 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D612F5A5
        for <io-uring@vger.kernel.org>; Sat, 19 Aug 2023 08:05:09 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-68824a0e747so452146b3a.1
        for <io-uring@vger.kernel.org>; Sat, 19 Aug 2023 08:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1692457509; x=1693062309;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2vDJgUdM++UshKGZ77RcRYJHt5jHYKiSTppp5GYtDu0=;
        b=T+qajmGbCt6OUSaU+Ee9TB8DcrUf0EGGPmfwjGqjWghGjQRjX+UKphZzu8lqiDBOrf
         hAHDdf3G04cKhW2D665k31xQysqdD7xZZo0e4sz714xzvzd2BhODpLAVAamrIslEQ899
         5V1OGHp73FLjkKQb1JswCD1Sq0QKpeBZE2B2yJYQB+vwEt46nsrooQ4kXif5t2T6AQA5
         tckPULDSOZJbqJ4j3K7pTzBs99yBzi8wBn0fKyPQZmo0XwvyGEa+1ZSLiXQZx0ptomIO
         sT5YOMqAXo56OSRqnKfiBR91KR5W4Iam9kEvSffH/VAaYwWRgyFamtx36Bv9dvvwKxhI
         Dzbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692457509; x=1693062309;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2vDJgUdM++UshKGZ77RcRYJHt5jHYKiSTppp5GYtDu0=;
        b=gBI3OY/u3ImdjNrk8pCvGnXiWU/UZnR0wiUV0pvZqIK3/hDmdY1Uqa0SwGqX67opWW
         SkRkPcKe+QqiXnN8JQj9CARlHNvyW89X1jEfTwRJaT0oDVKf86Ry2j1zcGndzNfSrrB7
         UC8YMnIR7R27LCOj6+hPomiEpvFQsOB98xzKVE/fLes9M/8OO5cRNtyxuO0rht/aArEg
         W4QKcN87asxDCmXmZEdNnfl0cuqsL38UthI2C4LH0DsLkIPTwbHfzpWoGPcicMNbE/Vt
         +XUitOVi7lNPO8SkzIsIcK9cZ06ASUaPZwPf7Cn6rpMoXYvFYt2Wdtcdn37y5waOiLOn
         BTkg==
X-Gm-Message-State: AOJu0YyF31HsnQvCEuqDQ+t1dvpjav9GqxWi87fnIDgkWABvcCDgjrXf
        65rA8BV/PSuTxW7XXwkwaUK9mP/HN6q3XCOOY8U=
X-Google-Smtp-Source: AGHT+IF0cvQ0xIBXUcBRQtRXSgOlGtf39ybsvu8bqY/IU8fLM+2jPUoIZy3RVsi2Wl6xC8oVxKB+9A==
X-Received: by 2002:a17:903:1d2:b0:1bb:c2b1:9c19 with SMTP id e18-20020a17090301d200b001bbc2b19c19mr2665460plh.6.1692457508608;
        Sat, 19 Aug 2023 08:05:08 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f4-20020a170902ce8400b001bb9f104328sm3769668plg.146.2023.08.19.08.05.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Aug 2023 08:05:07 -0700 (PDT)
Message-ID: <7032cd8d-86ec-4e26-8632-8c3f66ec4db5@kernel.dk>
Date:   Sat, 19 Aug 2023 09:05:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/16] io_uring: compact SQ/CQ heads/tails
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1692119257.git.asml.silence@gmail.com>
 <5e3fade0f17f0357684536d77bc75e0028f2b62e.1692119257.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <5e3fade0f17f0357684536d77bc75e0028f2b62e.1692119257.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/15/23 11:31 AM, Pavel Begunkov wrote:
> Queues heads and tails cache line aligned. That makes sq, cq taking 4
> lines or 5 lines if we include the rest of struct io_rings (e.g.
> sq_flags is frequently accessed).
> 
> Since modern io_uring is mostly single threaded, it doesn't make much
> send to sread them as such, it wastes space and puts additional pressure

"sense to spread". Can fix up while applying. Change itself looks good
to me.

-- 
Jens Axboe

