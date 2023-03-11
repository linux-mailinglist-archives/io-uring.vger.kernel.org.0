Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D85826B60C0
	for <lists+io-uring@lfdr.de>; Sat, 11 Mar 2023 21:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjCKU5a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Mar 2023 15:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbjCKU5a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Mar 2023 15:57:30 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A6065C73;
        Sat, 11 Mar 2023 12:57:18 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id v16so8101802wrn.0;
        Sat, 11 Mar 2023 12:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678568237;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8YvT7mGTykzHxDGiJlJKvQFfC0q2gGOitUi56P8Lu7g=;
        b=eGhGvUyRkh4USjMDXXEMntvv69BwvCjop85Dsf0okBUEbtqz4hFQ6Sn6r2/rnWcwJw
         a2DG1SwraA8YuDBdOVcrj3QoxztRtlIwOOz4MTs4D9uEulV/wguAABoGVAqcPUxPewvb
         0DyD+pJ3osZCHhhYY9ErcDwJN1bKCikMTqvAW0ZDjxhMDZnP3flQQXCQgHeR99eHZn2y
         6qY+hbc3uI38n+Na4iKHJIpYsyoHonANZ5d2znXdDZl5x/NycYhpfxloiuP/BgkJO21+
         9g+BJH9vKJACcZvwYWH4ETBy5jrZsBOR1mzGbUPG39gr2SFF3J91QZO+0qtkyKYxjvZH
         fpxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678568237;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8YvT7mGTykzHxDGiJlJKvQFfC0q2gGOitUi56P8Lu7g=;
        b=Yt5FAN57S1A9Fe2g2urQyOZC/6yhEiruFgKjAZs0Ae1uF6YZt0lHvlkrhyhXVX7To1
         FV1RXlrDmbvb4E6FYeQfjWOf3VzQHvPp/cFDNYf/8mjA1o2b/mYf8/fd3u/XCm1ZSork
         ILnhE0JgJsJR8qJmMtTFTIu1MjrTeMlFBFijPu/RFhoE6dNDPnHynGds181RLjYSU1wq
         ykcGZ1Nk7tMCPwDj3yJwoqW5MC0Ubgscq72gyRCbSoT2JvGCMf1MZLjmJ+VIDV5C/Vv7
         EdCZtU4l9Yk2RB39iX/PY28attZIGf1j2ZH0J7SoI9+anV/Fxo9Y5G4IRpHkq8scQ/Op
         5Vyw==
X-Gm-Message-State: AO0yUKWffWCc2IvWz+OWy9w8xGgULWYmgsvMzyvRvuSw5zL0JdgvRVxK
        CunGeVh8+KtiFSx1pX7r04s=
X-Google-Smtp-Source: AK7set9uhUUd22EMnqGoqZWlPJKltvF0fyM67G/d/Trple9uMgIv+MqHrlmssbTNbQ99rJEOKXV20A==
X-Received: by 2002:a05:6000:c3:b0:2c5:c4c9:515a with SMTP id q3-20020a05600000c300b002c5c4c9515amr18498163wrx.51.1678568237271;
        Sat, 11 Mar 2023 12:57:17 -0800 (PST)
Received: from [192.168.8.100] (188.30.129.33.threembb.co.uk. [188.30.129.33])
        by smtp.gmail.com with ESMTPSA id w10-20020a5d608a000000b002c5493a17efsm3330637wrt.25.2023.03.11.12.57.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Mar 2023 12:57:17 -0800 (PST)
Message-ID: <94795ed1-f7ac-3d1c-9bd6-fcaaaf5f1fd4@gmail.com>
Date:   Sat, 11 Mar 2023 20:56:16 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH] io_uring: One wqe per wq
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Breno Leitao <leitao@debian.org>,
        io-uring@vger.kernel.org
Cc:     leit@fb.com, linux-kernel@vger.kernel.org
References: <20230310201107.4020580-1-leitao@debian.org>
 <ac6a2da7-aa88-b119-6a44-01d2f2ec9b6d@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ac6a2da7-aa88-b119-6a44-01d2f2ec9b6d@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/10/23 20:38, Jens Axboe wrote:
> On 3/10/23 1:11 PM, Breno Leitao wrote:
>> Right now io_wq allocates one io_wqe per NUMA node.  As io_wq is now
>> bound to a task, the task basically uses only the NUMA local io_wqe, and
>> almost never changes NUMA nodes, thus, the other wqes are mostly
>> unused.
> 
> What if the task gets migrated to a different node? Unless the task
> is pinned to a node/cpumask that is local to that node, it will move
> around freely.

In which case we're screwed anyway and not only for the slow io-wq
path but also with the hot path as rings and all io_uring ctx and
requests won't be migrated locally.

It's also curious whether io-wq workers will get migrated
automatically as they are a part of the thread group.

> I'm not a huge fan of the per-node setup, but I think the reasonings
> given in this patch are a bit too vague and we need to go a bit
> deeper on what a better setup would look like.

-- 
Pavel Begunkov
