Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F0970683C
	for <lists+io-uring@lfdr.de>; Wed, 17 May 2023 14:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbjEQMgy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 May 2023 08:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbjEQMgx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 May 2023 08:36:53 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A791B3;
        Wed, 17 May 2023 05:36:50 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-965a68abfd4so122372566b.2;
        Wed, 17 May 2023 05:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684327009; x=1686919009;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mVXu+rteQS86iCuxXHVAWwBavTrAQEhvXfNGezw5HXE=;
        b=F47xH5ZwNk8KAKA4b6HSwJfCK0OF4/0yd4/WBQUHBWc/lfY1sqINI3ZndhSJVrxny7
         Sn5+wHfXOE3XjKyHrgcshVe95+sZ/5rdAJ7cHRBofV729JviZkuQUBEqlADfk8rZMgXu
         TyPDQWaG2eySuRGGDyIy/3glhTyB9iffTU0SHtyuEALraXn8qk4G1b0PoWdFFfYvJ2ri
         n36/1xu9yGZ8iJk6FaaQvBknPlWPqSM0uHg27zbuJ5nwnZbWuX+TgI5+0yIpWh1+c/Fs
         36v+/0PbK7YwviMN8G6/9lf6yfWDbhMEgSZJhAXWVP4I2QNxvw7rY0QM0GJhBKt8HB79
         Tg6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684327009; x=1686919009;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mVXu+rteQS86iCuxXHVAWwBavTrAQEhvXfNGezw5HXE=;
        b=NOzx9zF1+wSrF0T/GMW+wq6sdBZe87ZMVB4Qt4zJMdTOh27s3dwYKtkOwnimJK4/rT
         dOl3oXI7NP/6cjRg2e56P7418RhgD9adf3H58+vkIJk/z0zW4PWM03KCH+uyE8odS7We
         g/rGmOHPe5KTj2N/MeJvEYaZON9hn9d4yQTSIOl5pKyr/u13Nhmr63hpY6JiToPXmE1W
         GCEWAd22ey+p3S4NkWnA1Yago3Yld0LgWqMCvYoFroBdWEWhuD3EOS9FbpSlTPi+Ik2k
         D8yVknuRAJly7dpE0r4Ll2kmYhbIXr6zQ5wfYEjTit2LD/qLHAItRRy4Gq4Tcp1XNRvE
         dW6A==
X-Gm-Message-State: AC+VfDzMxCJbDd1XqYVYWzxsr91AqpWuAVPGWOrHgbPrk5y0KxLhXKz/
        FJ/Au8gwxXRppiRoOjTsJvw=
X-Google-Smtp-Source: ACHHUZ44IAGSpe4GtBP3SUuJx9YtVd77SXRA1VqkKSXfBkBmXTLZU6+r97naLc7ftpDGJHgB/enaoA==
X-Received: by 2002:a17:907:26c6:b0:91f:b13f:a028 with SMTP id bp6-20020a17090726c600b0091fb13fa028mr32696622ejc.34.1684327008360;
        Wed, 17 May 2023 05:36:48 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:46a1])
        by smtp.gmail.com with ESMTPSA id e26-20020a170906845a00b00965cd15c9bbsm12244107ejy.62.2023.05.17.05.36.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 05:36:48 -0700 (PDT)
Message-ID: <9367cc09-c8b4-a56c-a61a-d2c776c05a1c@gmail.com>
Date:   Wed, 17 May 2023 13:32:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH for-next 2/2] nvme: optimise io_uring passthrough
 completion
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, axboe@kernel.dk, kbusch@kernel.org,
        sagi@grimberg.me, joshi.k@samsung.com
References: <cover.1684154817.git.asml.silence@gmail.com>
 <ecdfacd0967a22d88b7779e2efd09e040825d0f8.1684154817.git.asml.silence@gmail.com>
 <20230517072314.GC27026@lst.de>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230517072314.GC27026@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/17/23 08:23, Christoph Hellwig wrote:
> On Mon, May 15, 2023 at 01:54:43PM +0100, Pavel Begunkov wrote:
>> Use IOU_F_TWQ_LAZY_WAKE via iou_cmd_exec_in_task_lazy() for passthrough
>> commands completion. It further delays the execution of task_work for
>> DEFER_TASKRUN until there are enough of task_work items queued to meet
>> the waiting criteria, which reduces the number of wake ups we issue.
> 
> Why wouldn't you just do that unconditionally for
> io_uring_cmd_complete_in_task?

1) ublk does secondary batching and so may produce multiple cqes,
that's not supported. I believe Ming sent patches removing it,
but I'd rather not deal with conflicts for now.

2) Some users may have dependencies b/w requests, i.e. a request
will only complete when another request's task_work is executed.

3) There might be use cases when you don't wont it to be delayed,
IO retries would be a good example. I wouldn't also use it for
control paths like ublk_ctrl_uring_cmd.

Let's better keep io_uring_cmd_complete_in_task() as the default
option for the interface.

-- 
Pavel Begunkov
