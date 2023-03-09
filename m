Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCAB6B2CF1
	for <lists+io-uring@lfdr.de>; Thu,  9 Mar 2023 19:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjCISeP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Mar 2023 13:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjCISeO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Mar 2023 13:34:14 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23E9F289A
        for <io-uring@vger.kernel.org>; Thu,  9 Mar 2023 10:34:12 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id x34so2975188pjj.0
        for <io-uring@vger.kernel.org>; Thu, 09 Mar 2023 10:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678386852;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QsB1+3pSBIJsDZ8Bx8JFWbOIk2kFJcqYOCHnRxX5WEU=;
        b=6qOK9Kk0QaRSTb+ies9OLj1JfuEWnd6f4hwo19Hzfg/0EQYNZJvA/UeQWbr6TEUY4g
         puRZtvUwZS/n5YOdDhVuk2dEX8+dN4jCrfykV6H306d8Yd90UOwWj1cUsk9oqEqDhujt
         A7Klw8lFuderGpzSVYGpshqLyblcRe6P++HG06cHhrO1n6yrPt/s+znCE4P+qLlRzOuH
         Y1ZIrVj6tDJ9KK5hNJkjfDq4sbROV4oFkznKyZD0HIACZ0J9rzelKhdPNtB/ofSv/vLS
         6SwkHNU3XiLAGP5RmEqpQMntpwuJ9rwcUeMLRkxJDuT2y3zbFzqqkrGM5VAcGKjtI83D
         c+3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678386852;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QsB1+3pSBIJsDZ8Bx8JFWbOIk2kFJcqYOCHnRxX5WEU=;
        b=MQZmOgrkoiUAWRufdMTykCaFJ3NGFxydiiSzZueiijxeCHw5HJ43vsLTXxq0G1NOZN
         0/FAMEJEZjHw3OStieCgEKpTx0Wp8h0iZ+Kv1Ywlqfic/cf/XPh9KBNQbuChM/9J66fO
         bH/sCVAsO+puvR8Mdai1+CSMo7hGze1UUmZX4ND8PGWuRkV6QYsOO5nksD/9eYV0rKl2
         8GtCPZHgxln4QY7jc3Z8oWtnYXqf3TZp0KJXCwU+DbnzRBNx7xeFjvsNHdbcfPJMxfLj
         SpnmelWn8dUEEwhEVXgjevaY3ce5DOzj+QwpSR7OhKfcWSyEmwzehcNqNsB8xLZyIU6d
         Uc2A==
X-Gm-Message-State: AO0yUKVzxb+b24l6xfrx4mh+byduq4QNtnXubtbESszSpYkdnng9wN/t
        UnQliERUB/gjdB9FL+KbIITquw==
X-Google-Smtp-Source: AK7set8qmGVXXPyN0b5Pj+QSGajvaDhIgXOKab1EMmFqkwsxKN2O43KCGOcWO2o0/18BNNHy7UzkBA==
X-Received: by 2002:a17:90a:4b8b:b0:22c:64c6:b7c4 with SMTP id i11-20020a17090a4b8b00b0022c64c6b7c4mr16432343pjh.2.1678386852398;
        Thu, 09 Mar 2023 10:34:12 -0800 (PST)
Received: from ?IPV6:2600:380:8729:7f5c:4fae:6d20:b0a3:a792? ([2600:380:8729:7f5c:4fae:6d20:b0a3:a792])
        by smtp.gmail.com with ESMTPSA id bf7-20020a17090b0b0700b00227223c58ecsm240851pjb.42.2023.03.09.10.34.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Mar 2023 10:34:12 -0800 (PST)
Message-ID: <02c05754-d73c-357f-0cda-373b120c8fdc@kernel.dk>
Date:   Thu, 9 Mar 2023 11:34:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gaW9fdXJpbmc6IHNpbGVuY2UgdmFyaWFibGUg4oCY?=
 =?UTF-8?Q?prev=e2=80=99_set_but_not_used_warning?=
To:     Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <f2499a3c-5e15-eecd-2ee8-4a4e3ea4f9ad@kernel.dk>
 <CR20M0PWOJZM.2KMRHEWFCKY5J@vincent-arch>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CR20M0PWOJZM.2KMRHEWFCKY5J@vincent-arch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/9/23 10:06 AM, Vincenzo Palazzo wrote:
>> If io_uring.o is built with W=1, it triggers a warning:
>>
>> io_uring/io_uring.c: In function ?__io_submit_flush_completions?:
>> io_uring/io_uring.c:1502:40: warning: variable ?prev? set but not used [-Wunused-but-set-variable]
>>  1502 |         struct io_wq_work_node *node, *prev;
>>       |                                        ^~~~
>>
>> which is due to the wq_list_for_each() iterator always keeping a 'prev'
>> variable. Most users need this to remove an entry from a list, for
>> example, but __io_submit_flush_completions() never does that.
>>
>> Add a basic helper that doesn't track prev instead, and use that in
>> that function.
>>
>> Reported-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
> 
> Nice, I should pay more attention to the implementation
> and maybe propose the equal patch before.

That's just how it goes sometimes!

> But anyway thanks to rework it.
> 
> Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>

Thanks, added.

-- 
Jens Axboe


