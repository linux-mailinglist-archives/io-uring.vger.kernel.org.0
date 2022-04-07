Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0EFA4F86AA
	for <lists+io-uring@lfdr.de>; Thu,  7 Apr 2022 19:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346653AbiDGR4X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Apr 2022 13:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346008AbiDGR4W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Apr 2022 13:56:22 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B246AB91
        for <io-uring@vger.kernel.org>; Thu,  7 Apr 2022 10:54:21 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id b16so7752553ioz.3
        for <io-uring@vger.kernel.org>; Thu, 07 Apr 2022 10:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=gce78jy4LuJXmzrEfmUS2jGwihrvhMnszOmcrlZBqNI=;
        b=d6IeYbQHnMu6FVEnUYwYGD5x0q9GHHVuw85i74Aq57JyVISTsi1qhLIqC4LL5h3CDL
         iiY3IF/9d50EqmTNsw34OlE+bP2n/bYZziqKU2u6XoXQLYjtItoMDdxBAvnsYtCgtTis
         XfQM6VzXkwkMy6rUCllB5mix9aY3gM9KgO/1jEu3NSFW1xrR6q7btFR1SmgjVRSOVnoT
         nx2j28mpda0PELd13edMjk2RQdbBYtxIM9UJEULoGpjHmZnhpv/1yYa4RBnqQba9elUg
         G57vpR1IGPCYDwB/+/W2IPQUeqIS8VfEmG0AXrbWlfWBWfTJch6xCUfcOotQzj+Pgyh3
         +Y5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gce78jy4LuJXmzrEfmUS2jGwihrvhMnszOmcrlZBqNI=;
        b=jY4LDXOp+V8+5aNlj5alVucxMuB5thxsy10//bnUI41d/fvm45iPkQBOMOjUAPPzWF
         XHg6QBB7bxy5b6WnQjG11pG9ioLsYus+998Y+UiU31DqjOArOMKw9ZTON++YoKGNVqxo
         cSK09A8uw9lY2LfY4yQqhptg8jEy1TcE2WL6xRM3SwranXQ8fB2YLxXJcLQkrXuC46V+
         B2H+KHs9mgE4WNoEnU9zjPlLt63Ae/DFraANFmCmVriNjWq9bgnHBYCdL25WYv9F7BFZ
         cLRlFfo5aezLopeQCfMAR0Tml2potJH9B2l0ONj3tomTU/RdwzS/mQSxg3M816jypjO0
         hzoA==
X-Gm-Message-State: AOAM530AQUW8ETYBbtxehVkgTUDpyygBxfUSFGDROL6J9fA/WzgnYL8J
        1cWSrmkN/Il7yIwHHfYjnqHNIA==
X-Google-Smtp-Source: ABdhPJwGM6IIAVplmv9354x9+aASPByV/YYBienPlxZV6azSpyy2jQBGLS9G3l5cVL3KGsSxvs0i2Q==
X-Received: by 2002:a02:a702:0:b0:323:8dca:8506 with SMTP id k2-20020a02a702000000b003238dca8506mr7860237jam.96.1649354057669;
        Thu, 07 Apr 2022 10:54:17 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s5-20020a056602168500b0064c82210ce4sm13584723iow.13.2022.04.07.10.54.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 10:54:16 -0700 (PDT)
Message-ID: <3996f4d0-dd11-712c-0792-f52a2c6ae370@kernel.dk>
Date:   Thu, 7 Apr 2022 11:54:15 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH next 0/5] simplify SCM accounting
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1649334991.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1649334991.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/7/22 6:40 AM, Pavel Begunkov wrote:
> Just a refactoring series killing some lines of the SCM registration
> side and making it simpler overall.
> 
> Pavel Begunkov (5):
>   io_uring: uniform SCM accounting
>   io_uring: refactor __io_sqe_files_scm
>   io_uring: don't pass around fixed index for scm
>   io_uring: deduplicate SCM accounting
>   io_uring: rename io_sqe_file_register
> 
>  fs/io_uring.c | 227 ++++++++++++++------------------------------------
>  1 file changed, 63 insertions(+), 164 deletions(-)

Looks good to me, and a nice cleanup.

-- 
Jens Axboe

