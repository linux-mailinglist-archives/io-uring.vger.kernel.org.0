Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E737645B6D
	for <lists+io-uring@lfdr.de>; Wed,  7 Dec 2022 14:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbiLGNxC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Dec 2022 08:53:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbiLGNw7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Dec 2022 08:52:59 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7934649083
        for <io-uring@vger.kernel.org>; Wed,  7 Dec 2022 05:52:58 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id k7so17069020pll.6
        for <io-uring@vger.kernel.org>; Wed, 07 Dec 2022 05:52:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NvChQNyZiJo76W9BoUG4roBpASZzSfm6UugnKtAwipk=;
        b=B9pgE8+jmwz3iue0VuJvWnn7V1phl+qjg41RIZVlw7L3D6MUGz6XQftI4olrpiCpPz
         2z6caI7AqVNyxBT8sEOkIKY2bVnEnrtmKpj8u8xPw315N0Xw8QOa2bZgSOdLyacQicU0
         DZxnCDY5w1pUIsP7tUbzZIn/2A5gf746Whzvsuk7C+RQ4CWy16I4ddOdw4JVKP0Qonid
         KDsGYRguy2TDNDbaWRNzqDBjMazTFmXArSCGDBDp1jzMZtaPmqQ5FS/8MBHIVFGWdR77
         4ZvytoRRbbkXu0mWDBfjEHruTKMjVwTqH6aW20vDZPOY3R0uZnkdWqqWL39N2ZyyJf0Z
         XfBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NvChQNyZiJo76W9BoUG4roBpASZzSfm6UugnKtAwipk=;
        b=czX/9tXoFvPF82id2AqiYVXIDmQovqRLbVViAmnHzyjw7kves+f6N+jimS9zlQ5g9u
         1Z8fDT4fbg/2gfkSUnaEIOSS4wEv4+PJcYI/JgC5xbbFGBYY+AzuCbIH+2YTZctKf1tT
         XGRGVHMkGAgQwWVScPUesZOTKm2ivmqa46CqIfU1uo6Xs+9qvk7xj5TNASVgqjy7BYV4
         PlWhRFPxZwfgOOTU9cniJZY45YAaC0dn/aSr7gErAoYFN9ndm/orySubHPlCh1M0fqpC
         l5QeZD9xiR09uySsviJ1Dww7pXu4KXAdR3A95A3X175ItI93ygQ5sBsB4arzFDmLmPtB
         ZnXQ==
X-Gm-Message-State: ANoB5pmH5346NIkGT5LDZqddXuk2uolTZ52XMEKtzSixXdDzNfEvKOZQ
        4pq9V7DUQ3K+98l9MXaEogPn4A==
X-Google-Smtp-Source: AA0mqf5Imadl/ojA8ODBjeAklDO12k5zcLPxEuNXrcZEyDtmsoc+DZtotZ3vwnoyez7IPSDW2xlNcA==
X-Received: by 2002:a17:902:bc44:b0:189:b15e:a35d with SMTP id t4-20020a170902bc4400b00189b15ea35dmr32155142plz.112.1670421177807;
        Wed, 07 Dec 2022 05:52:57 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j10-20020a17090276ca00b001894881842dsm14653237plt.151.2022.12.07.05.52.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 05:52:57 -0800 (PST)
Message-ID: <bc422c44-b723-8b6e-0d21-980539cd4f6d@kernel.dk>
Date:   Wed, 7 Dec 2022 06:52:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH for-next v2 01/12] io_uring: dont remove file from
 msg_ring reqs
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1670384893.git.asml.silence@gmail.com>
 <e5ac9edadb574fe33f6d727cb8f14ce68262a684.1670384893.git.asml.silence@gmail.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e5ac9edadb574fe33f6d727cb8f14ce68262a684.1670384893.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/6/22 8:53 PM, Pavel Begunkov wrote:
> We should not be messing with req->file outside of core paths. Clearing
> it makes msg_ring non reentrant, i.e. luckily io_msg_send_fd() fails the
> request on failed io_double_lock_ctx() but clearly was originally
> intended to do retries instead.

That's basically what I had in my patch, except I just went for the
negated one instead to cut down on churn. Why not just do that?

-- 
Jens Axboe


