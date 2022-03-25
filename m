Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B77174E7461
	for <lists+io-uring@lfdr.de>; Fri, 25 Mar 2022 14:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245324AbiCYNot (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Mar 2022 09:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233213AbiCYNot (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Mar 2022 09:44:49 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B030617E3E
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 06:43:14 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id w4so8030900ply.13
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 06:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=yL4mtLtjyCmQLkHI5xldz1FMW5K+et4WK1NPY9mi2Kk=;
        b=7mwyAVwIi1lbST5V8lxzIwfVxqhhglUn2t+o+lrw89q1xiP6p7/76Hq3cziTtJkxpz
         qk7sO+7eHfAeqDCFM3zSyv6u0t1xrKRtXd5OxDG+4olImrvhduX34FYYpvoRHXxNTCep
         DqoADzyo8jQ+6aS6ycRpQ42YKwRvPLChwgnZgvSytb4Jq/29uyhNHRve2VE/nMCMcD2E
         0B7nEy6SlmPPWPcjYtV+90u8XxJeVHcoqwvsXu2PnwwYAB92f02qWGDZB7Zrm0GQFzjR
         Yrt0yzxnnYddJpQ11nj6YAB+zP0ZyabYIkdlxxBCfDHcrJyI49NGMqj0rfTK7iRlwIgz
         ZU9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yL4mtLtjyCmQLkHI5xldz1FMW5K+et4WK1NPY9mi2Kk=;
        b=rMySF7SvdQs8/UiUhRWl7CkdxQJ66ILKC9b/GkXKBGKPcS8vmMuuz/gwCWYJytsge2
         vxN5DoMiBbzwvKW+yi4Ft9fySaGLfDHLWYiACX4gbDsoBhxU5VhD0ED7VGr+LPp88kEr
         s6TfRQ7cKy10TPv0nEOGSNnNxv2e+z3cxkwQPOri94KnLmkMi3Dy7k9CGH8IRDxkhZZ+
         JgAqtyt232oeD6DRc+ab6HFBdG5vPS/J0HtgnShp9ZbpmUXa6lD22ylrecAdptHYC9sr
         fYJIc9/Q9D1atMmygPRSX5/aTC+AFTMWGoD1APxAcBrFLfD2k1lsDBArPVQ6x55F9RpB
         NzKA==
X-Gm-Message-State: AOAM5335mE5Y/c5KZzdVzJ+AOLe5xa0LghYtHZq71XG5Na7B8K1v2857
        D7Zwm9lYIMG9GXT0vrxeOc5atURyPnKJBKpL
X-Google-Smtp-Source: ABdhPJzREKpDr2RnOXJfZsxTPjFg48DKE/p7PsS23YRyiOg3rqD5nkuyzFoySb4Rc0rIZcLNzfLABw==
X-Received: by 2002:a17:90a:7:b0:1c7:c286:abc2 with SMTP id 7-20020a17090a000700b001c7c286abc2mr9446942pja.65.1648215794136;
        Fri, 25 Mar 2022 06:43:14 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id pg14-20020a17090b1e0e00b001c75634df70sm13113543pjb.31.2022.03.25.06.43.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 06:43:13 -0700 (PDT)
Message-ID: <d8a659f8-7a0b-03a3-8045-9d3f5bb412ee@kernel.dk>
Date:   Fri, 25 Mar 2022 07:43:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.18 0/2] selected buffers recycling fixes
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1648212967.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1648212967.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/25/22 7:00 AM, Pavel Begunkov wrote:
> Fix two locking problems with new buffer recycling.
> 
> Jens, could you help to test it properly and with lockdep enabled?

Yep, I'll run them through the testing, thanks!

-- 
Jens Axboe

