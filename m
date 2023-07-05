Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74D30748BE1
	for <lists+io-uring@lfdr.de>; Wed,  5 Jul 2023 20:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjGEScJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Jul 2023 14:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbjGEScI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Jul 2023 14:32:08 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29D911D
        for <io-uring@vger.kernel.org>; Wed,  5 Jul 2023 11:32:06 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1b867f9198dso7045685ad.0
        for <io-uring@vger.kernel.org>; Wed, 05 Jul 2023 11:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1688581926; x=1691173926;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QL0zl5fFqIkBuU2DH7xBNsBVYZc2Kn+5XphF3I9Ar7s=;
        b=G8DvW2uCT/mh19L/JzU9XYEW3imDLPvaXp1M/7t8ALqlyouVSashpsNGtIn3GIyNzZ
         2WduZMXay/LHvUoxsGnia05JgDFu2OZAnu7Yaa/XIfEyB49QJ03oBjAzyqL3Cl2Aj3W9
         bHByEJRAMEzEo5OA0T48RHArBUTxUR/p91fOdHj9eQW3Zyc+UbRtw6JueQkEK3j9mMAs
         g954qIyq0U+u7A2qnWBErnOCHg2KAKXht7ovhhhy4PYqLCC0eNn/1Kbp0bL8qdx/8kb7
         3dnbgaNEnsbQKcmTSP4d6ooG2fXAdWvnpJWutDtFsNn50bWaCo+fq58S/PdHOg1fQMfd
         7cUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688581926; x=1691173926;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QL0zl5fFqIkBuU2DH7xBNsBVYZc2Kn+5XphF3I9Ar7s=;
        b=aGzj75LjNkH8Vs+1V5st+Nzz6fPbRctMY9znc0BZDCN7Rd61trCI1keEzM3P17UsVg
         gdDObLyoQlE6RvfZCi0a7ddKYhy/OsU+/n/qLgk90OMEYdYIqSGNoYDzpqpPfZLrZLQF
         EgtvhdDhs95WV9+a0U3WASpq/aRKw7xqn0442yC9njrqkG8SJeQg0/DbLu/T1B3dJ0Hc
         4Z+xbFGSHpvxHJLGD3Biah5CGE4aMV2hfrZHNRtAEWQbWrICc5Is+sjMfH05aOtDmJbF
         BUm8CrkXq07j1xhmVPWxnpbBj/0CTi+BeXw5pQk7AOumYC/5FdVPNuJS8KBHKQ9faDQY
         A3fg==
X-Gm-Message-State: ABy/qLYWu/+Apebz+G4YPiKk87kwc5H8bLgt2r9AxJovU670C87lza0w
        tErNEIg2bpW5U7X/jW8BQ4V1+P1U1gtTyUWOn00=
X-Google-Smtp-Source: APBJJlH+c3ZF2ZhABVeEsn6PcTh1A0zFxmQS5CEGlEX2SirN8JhRHzQiZcooYVdWEGwTK4vhUdJIxQ==
X-Received: by 2002:a17:902:ec88:b0:1a6:6bdb:b548 with SMTP id x8-20020a170902ec8800b001a66bdbb548mr16812261plg.1.1688581926309;
        Wed, 05 Jul 2023 11:32:06 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s18-20020a170902a51200b001b7fb1a8200sm17601840plq.258.2023.07.05.11.32.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jul 2023 11:32:05 -0700 (PDT)
Message-ID: <225f5595-bd8a-aeb9-049a-d8879d619a1d@kernel.dk>
Date:   Wed, 5 Jul 2023 12:32:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: Allow IORING_OP_ASYNC_CANCEL to cancel requests on other rings
Content-Language: en-US
To:     Artyom Pavlov <newpavlov@gmail.com>, io-uring@vger.kernel.org
References: <62f84473-f398-fb00-84c0-711c59bd9961@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <62f84473-f398-fb00-84c0-711c59bd9961@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/5/23 10:44?AM, Artyom Pavlov wrote:
> Greetings!
> 
> Right now when I want to cancel request which runs on a different ring
> I have to use IORING_OP_MSG_RING with a special len value. CQEs with
> res equal to this special value get intercepted by my code and
> IORING_OP_ASYNC_CANCEL SQE gets created in the receiver ring with
> user_data taken from the received message. This approach kind of
> works, but not efficient (it requires additional round trip through
> the ring) and somewhat fragile (it relies on lack of collisions
> between the special value and potential error codes).
> 
> I think it should be possible to add support for cancelling requests
> on other rings to IORING_OP_ASYNC_CANCEL by introducing a new flag. If
> the flag is enabled, then the fd field would be interpreted as fd of
> another ring to which cancellation request should be sent. Using the
> fd field would mean that the new flag would conflict with
> IORING_ASYNC_CANCEL_FD, so it could be worth to use a different field
> for receiver ring fd.

This could certainly work, though I think it'd be a good idea to use a
reserved field for the "other ring fd". As of right now, the
'splice_fd_in' descriptor field is not applicable to cancel requests, so
that'd probably be the right place to put it.

Some complications around locking here, as we'd need to grab the other
ring lock. If ring A and ring B both cancel requests for each other,
then there would be ordering concerns. But nothing that can't be worked
around.

Let me take a quick look at that.

-- 
Jens Axboe

