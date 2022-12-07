Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82B1C645DA7
	for <lists+io-uring@lfdr.de>; Wed,  7 Dec 2022 16:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiLGPbS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Dec 2022 10:31:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiLGPbS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Dec 2022 10:31:18 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19C15C0D0
        for <io-uring@vger.kernel.org>; Wed,  7 Dec 2022 07:31:16 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id a18so5458702ilk.9
        for <io-uring@vger.kernel.org>; Wed, 07 Dec 2022 07:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Zf/LXV6tRmTCVpJv/dfLrYLhcBcAeJ4IUPCtFSQeR+0=;
        b=7t6xRFf/tDgq5rMw4Usn9l8814npunY0SMVwmXSwMJ8mNH2OuTVzChJS8+F0Y3/MmC
         J87ds9gbmuafmgR97KVfjTEp5lQ+YslssKWREx65GJtsf+CJxSNuG1fYwJxRgnpOr3tT
         UGlS1Gu+A6jq9lzW2aUh6YCp3VW0rdHdqfZJ1XUl1RuYHkWEJjCqwxEoFvVk7ytrQv44
         B1uIR7qeyb6AaCVYWIUGwd5eykCqROJEN1DEnWq/rW+3HK/DZn6BCt/s38JQaKhIBTl+
         BqS7ftKKwy8+IHiZvg3e9cAG/zwkHbOYlWmVuOJTTz6VcRsP58BOWajuuO0qPGxFfFyO
         j1Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zf/LXV6tRmTCVpJv/dfLrYLhcBcAeJ4IUPCtFSQeR+0=;
        b=gjuq7QKLF0A0QpwOy+RmIReLE9HlSclum5jHtW0MlDnXjJt22gbtD/3GSdroO8QQog
         rt8sx75kLbcuLudgVIc4i18ga42QJLuRrxC/oiDW+7c5LrmVUNMsi6pXNvwSMY9Lnq+t
         ybnNwqwYtkh7V7Uafq2uu1o/3NX9F0MM1xsvv/t6BeWXLxLIkirXUqXWQo9fJJJz2xU0
         +qTKNPIWs6CpAMEdkiZXGkJwhqzIqyUoe/GCxiYA51NjroW4egymn8oDezrAGZ001TFX
         EwWTGGi/SXdgFqWhHxkjnTkmzhHty6P6QbCZyKJagLCHhIeB5dxW1+fnGLoCRT4hSY2t
         SfOw==
X-Gm-Message-State: ANoB5pm/F+Bj9W90i3s9wqBIgy1S810eMQSkkxZy29/z4E8Bx9a33KNa
        f50gONN90Slajybh6ZRln95MRg==
X-Google-Smtp-Source: AA0mqf41aRXUj5zpwOxti45Qw87sZvRYwIl54XBe+sN98o5lGJ17ImT75mo8u5vGBlVzVrl1HiAmQg==
X-Received: by 2002:a92:a814:0:b0:302:be57:41aa with SMTP id o20-20020a92a814000000b00302be5741aamr34323965ilh.231.1670427075892;
        Wed, 07 Dec 2022 07:31:15 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id r10-20020a92d98a000000b00302755f8dc4sm2929179iln.8.2022.12.07.07.31.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 07:31:15 -0800 (PST)
Message-ID: <3957b426-2391-eeaa-9e02-c8e90169ec2e@kernel.dk>
Date:   Wed, 7 Dec 2022 08:31:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH for-next v2 11/12] io_uring: do msg_ring in target task
 via tw
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1670384893.git.asml.silence@gmail.com>
 <4d76c7b28ed5d71b520de4482fbb7f660f21cd80.1670384893.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <4d76c7b28ed5d71b520de4482fbb7f660f21cd80.1670384893.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/6/22 8:53?PM, Pavel Begunkov wrote:
> @@ -43,6 +61,15 @@ static int io_msg_ring_data(struct io_kiocb *req)
>  	if (msg->src_fd || msg->dst_fd || msg->flags)
>  		return -EINVAL;
>  
> +	if (target_ctx->task_complete && current != target_ctx->submitter_task) {
> +		init_task_work(&msg->tw, io_msg_tw_complete);
> +		if (task_work_add(target_ctx->submitter_task, &msg->tw,
> +				  TWA_SIGNAL))
> +			return -EOWNERDEAD;
> +
> +		return IOU_ISSUE_SKIP_COMPLETE;
> +	}
> +

We should probably be able to get by with TWA_SIGNAL_NO_IPI here, no?

-- 
Jens Axboe
