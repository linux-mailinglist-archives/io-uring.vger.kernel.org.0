Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93207506BA0
	for <lists+io-uring@lfdr.de>; Tue, 19 Apr 2022 14:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242849AbiDSMDZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Apr 2022 08:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349748AbiDSMBZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Apr 2022 08:01:25 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239831EAEB
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 04:57:39 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id g18so32357245ejc.10
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 04:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:organization:in-reply-to:content-transfer-encoding;
        bh=i2ckW4P2m1fbKVgJ61SAJEb5hQpE5GDbYOrNZXitmjc=;
        b=vVkitVr5R2uBkK6oY8Slss+jRB722udsr6GvDYFjN4vZtpqw2GH3gFDPESqPrQjGZJ
         qOkT+6n8vzT7O0URgMMFGOqutdBMYfW2PzaY6mjxjSJTWHXTxeF9VzXQFMGFe8xs6jjy
         lEfNSkfVo+bJtWHNiUTzXSKNetyDgzqTlLYKVMYaJKFvRJiWT4gL4/CwvMQVirbkwjFw
         mC4/T5AoPUe0Emzfys+Zf5bPTSkXMVhP/tTueQrQLbqXwcHqCK9UAdz6ndsmNDREo7J4
         jgH8P7s45tNNbv+u++AwJW/HJuiBX77blIdorIvx+wZZQspExzQrf/umMPJYeT+vRU+N
         +fIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=i2ckW4P2m1fbKVgJ61SAJEb5hQpE5GDbYOrNZXitmjc=;
        b=oS/JlyW1D+vuxbRBCyCBeib8X18keeImBktWIF1BKxNCzYkqWJR+Moxezw7Z+8Fzpw
         q6I9QkRPbv7k3lVHqXWzwRXo1OXxr7oNLFIotcKWtXkf/CG16DzUY11GlMKrsXIiOSlr
         uL/5C58M1e8oHcNegklg/H2Fg9lx5tFWQpVkMnRj4WYBfakL1ENPiW8IWZEZDwnFkd+p
         pm/gqvLUdCoQGl5gyWvFfPUQFFZ/bxi16BmmkJg/BMn5QlqjxqWNRcMBaC47ZfW3EDI2
         vtHHBNq3DseWMNfEosf8HxDn6C1U885oQnGP805YrjY+LQ1xNylPZtWOHt8k+ZToGXAU
         szvA==
X-Gm-Message-State: AOAM533+c9LHsMiRpjKz6bUfW+939yW0oPH6sIDxoGdVHANeWhpa7GB3
        NovGH1F51Tk7s4CCtu9AgVjGcaqo71L3MA==
X-Google-Smtp-Source: ABdhPJwFTHDiu9WAYHUya5TNvlrvZ7vcLxdQSo82FyeC0L48Zke1w1nOGG27FW2vuoQUlXpAtLjTqg==
X-Received: by 2002:a17:907:6e92:b0:6e4:de0d:464 with SMTP id sh18-20020a1709076e9200b006e4de0d0464mr13187900ejc.348.1650369457562;
        Tue, 19 Apr 2022 04:57:37 -0700 (PDT)
Received: from [10.0.0.1] (system.cloudius-systems.com. [199.203.229.89])
        by smtp.gmail.com with ESMTPSA id br14-20020a170906d14e00b006e88db05620sm5676791ejb.146.2022.04.19.04.57.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 04:57:36 -0700 (PDT)
Message-ID: <e7ffdf1e-b6a8-0e46-5879-30c25446223d@scylladb.com>
Date:   Tue, 19 Apr 2022 14:57:35 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: IORING_OP_POLL_ADD slower than linux-aio IOCB_CMD_POLL
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <9b749c99-0126-f9b2-99f5-5c33433c3a08@scylladb.com>
 <9e277a23-84d7-9a90-0d3e-ba09c9437dc4@kernel.dk>
From:   Avi Kivity <avi@scylladb.com>
Organization: ScyllaDB
In-Reply-To: <9e277a23-84d7-9a90-0d3e-ba09c9437dc4@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 19/04/2022 14.38, Jens Axboe wrote:
> On 4/19/22 5:07 AM, Avi Kivity wrote:
>> A simple webserver shows about 5% loss compared to linux-aio.
>>
>>
>> I expect the loss is due to an optimization that io_uring lacks -
>> inline completion vs workqueue completion:
> I don't think that's it, io_uring never punts to a workqueue for
> completions.


I measured this:



  Performance counter stats for 'system wide':

          1,273,756 io_uring:io_uring_task_add

       12.288597765 seconds time elapsed

Which exactly matches with the number of requests sent. If that's the 
wrong counter to measure, I'm happy to try again with the correct counter.


>   The aio inline completions is more of a hack because it
> needs to do that, as always using a workqueue would lead to bad
> performance and higher overhead.
>
> So if there's a difference in performance, it's something else and we
> need to look at that. But your report is pretty lacking! What kernel are
> you running?


5.17.2-300.fc36.x86_64


> Do you have a test case of sorts?


Seastar's httpd, running on a single core, against wrk -c 1000 -t 4 
http://localhost:10000/.


Instructions:

   git clone --recursive -b io_uring https://github.com/avikivity/seastar

   cd seastar

   sudo ./install-dependencies.sh  # after carefully verifying it, of course

   ./configure.py --mode release

   ninja -C build/release apps/httpd/httpd

   ./build/release/apps/httpd/httpd --smp 1 [--reactor-backing 
io_uring|linux-aio|epoll]


and run wrk againt it.


> For a performance oriented network setup, I'd normally not consider data
> readiness poll replacements to be that interesting, my recommendation
> would be to use async send/recv for that instead. That's how io_uring is
> supposed to be used, in a completion based model.
>

That's true. Still, an existing system that evolved around poll will 
take some time and effort to migrate, and have slower IORING_OP_POLL 
means it cannot benefit from io_uring's many other advantages if it 
fears a regression from that difference.


Note that it's not just a matter of converting poll+recvmsg to 
IORING_OP_RECVMSG. If you support many connections, one must migrate to 
internal buffer selection, otherwise the memory load with a large number 
of idle connections is high. The end result is wonderful but the road 
there is long.


