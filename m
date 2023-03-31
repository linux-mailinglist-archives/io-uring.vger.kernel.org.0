Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 183DB6D23CF
	for <lists+io-uring@lfdr.de>; Fri, 31 Mar 2023 17:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbjCaPSM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Mar 2023 11:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbjCaPSL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Mar 2023 11:18:11 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714E42108
        for <io-uring@vger.kernel.org>; Fri, 31 Mar 2023 08:18:10 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so23672209pjt.5
        for <io-uring@vger.kernel.org>; Fri, 31 Mar 2023 08:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1680275890; x=1682867890;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jGf9Ke6hyi1zrPw7y/bgSfULaNauXRdwBBZ93BW0UFo=;
        b=62Cp4IX7lIb21FcLQijDFcnypwkk55LKaHk5Dzg1khoFzy1M4sfueHgIxGJa+5GcqN
         0/gXVgbJmd7CUjZ11wp7WmizldO3nLyehZPz8RmxBu2UOlBVJTdX5kf3+OB3CFF3Gf3e
         0d3uLLctuvDPRUtX63ZRWqy5bgwtjG5Zgox0mjqgC2VFpl6OJfy3haRteglh57I3/eC4
         4g6zspqoqD6Un06Tl5Cq9LHMNwiB4Qvdc8lQtrHCNk+hNh05UbXKGDu3wy9+TaGyE1zy
         HUoNey0KFPZ9zuvQmnWSRZIUv0ygE6nBs7bAq0wd00hw4PkSoEYoyzuMKUjWmsetJMFA
         Zs+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680275890; x=1682867890;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jGf9Ke6hyi1zrPw7y/bgSfULaNauXRdwBBZ93BW0UFo=;
        b=H2y4GG+ZPEINVkRTooYUqQOtu9bw7yCNAWMlzCsTyiXlqa+q0MkOR6319v6RoDFaVq
         Tw436eXd36ZRIXU2JuOJPzc5hKWxHj4OTHVcDIpZq9wBm28q5lZmO2VJpyXByAoxo9on
         gJN21BJ4ehV8xdWS9xlQ13O75AJhunkorufw9dil6x2inXEa/5bxXyA9iCPW3l3nPpCY
         OepKfzdlIszBU5/7JhUcX+hvZ15+BEPydIxjUjxD/h+aymqumv8KXLjozj5ybv1V/tnK
         DgF/aHhEalui/FGwfg+qkb6j0yqBXbQY28QccVRSaGh5M9udz//M5Sm3bPSSiscu45BR
         qF6g==
X-Gm-Message-State: AAQBX9dODwuDgZyaD/kMfFeaNT/HIrSq/ebTlVAMPmr8lEM7Qfzm0cfp
        E0dH4QiEN83vvYgQtA0MChwpG9LOHvO2RAe+KrDEbA==
X-Google-Smtp-Source: AKy350b/VJZeWUJCGjTCUvzHWgLtyLvYuTnW4iqan6UXwl90v3vDFi75PBYrQ6ZGBi8dqnQ0sgAi1g==
X-Received: by 2002:a17:903:1384:b0:19e:94ff:6780 with SMTP id jx4-20020a170903138400b0019e94ff6780mr6645806plb.6.1680275889647;
        Fri, 31 Mar 2023 08:18:09 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id kr15-20020a170903080f00b001a1ca6dc38csm1695215plb.118.2023.03.31.08.18.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 08:18:09 -0700 (PDT)
Message-ID: <57c89d5c-c05d-6be4-0e36-40b4a679983c@kernel.dk>
Date:   Fri, 31 Mar 2023 09:18:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [RFC 00/11] optimise registered buffer/file updates
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <cover.1680187408.git.asml.silence@gmail.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1680187408.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=3.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/30/23 8:53 AM, Pavel Begunkov wrote:
> Updating registered files and buffers is a very slow operation, which
> makes it not feasible for workloads with medium update frequencies.
> Rework the underlying rsrc infra for greater performance and lesser
> memory footprint.
> 
> The improvement is ~11x for a benchmark updating files in a loop
> (1040K -> 11468K updates / sec).
> 
> The set requires a couple of patches from the 6.3 branch, for that
> reason it's an RFC and will be resent after merge.

Looks pretty sane to me, didn't find anything immediately wrong. I
do wonder if we should have a conditional uring_lock helper, we do
have a few of those. But not really related to this series, as it
just moves one around.

-- 
Jens Axboe


