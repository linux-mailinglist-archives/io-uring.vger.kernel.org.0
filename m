Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F976234838
	for <lists+io-uring@lfdr.de>; Fri, 31 Jul 2020 17:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728961AbgGaPKW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jul 2020 11:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728697AbgGaPKV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jul 2020 11:10:21 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF859C061574
        for <io-uring@vger.kernel.org>; Fri, 31 Jul 2020 08:10:21 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id l1so31942766ioh.5
        for <io-uring@vger.kernel.org>; Fri, 31 Jul 2020 08:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=c31zs78jkbEDcaAEozn9jB01elDvx98vBlez8NhPw+w=;
        b=AAEAVeSeZ1ySeSQ/D4kbj7FnBIbjhRT3/zYqQOAwcxJtswLItoccGSGuHARDh7qWHX
         mX8qnJizZcG0woNqTMGwEQKFAj0RyhuN6vHBnsWtUjhoxAtnMqAJMNzqGEF27wjw55lR
         /UK0XDE5PLoD70cE0Scng0hzWA6oE4q4W4lNhlTLcDuaJY3XraExZ+kyB2n3EZ3SzCOn
         DNrR4MqOt9jnEmOQjU5rARL+i8r5jlhftCD5O0m507Qwwa2zuOvx4sfXfN43w7DGy+UB
         Ty7QM5bQbd+FVdSW5WX/XhpUqb6VVfUYYT+9XKmWwEe+Mp2S6OUBiN5jXrsH7eHMaVWw
         233w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c31zs78jkbEDcaAEozn9jB01elDvx98vBlez8NhPw+w=;
        b=Z/j9RH2fUwr2fuNxcLdt05bkmZlPGS8I8ChsST0sRo0EsieQATvOjFFgPgiJmJGpbZ
         XElMJ2ZzvR+FM+5rWsVo9Bgh1Tt9FiW6x2TeCiBaMTQWV8rqz+CGjje/TVK2s7m2CS7H
         qwc7oQWECiOqOW4Iy04hSXFZUPsRy5/ldleR1L2hxDNRnKwfP5V2XxT+8lbeqU7U2b3J
         EeNPyLf8VFFhAXIuZ3WPUzmifRIvlYjf33XXTMfq32E1tlbpRzaWSVsRCM8TatIprkl4
         N7fwVQbcRLIJfQcOmQCzIBiNcWMcKxID5ldr1cuEe5jg3TK2U79vTyV00unrhaxAt6xa
         Hc7A==
X-Gm-Message-State: AOAM532CyQI8tPsyUAMAHzMh6fiSFsQ36LCQzkt0yY3uIKNKAjC4iaea
        JdMW3Z0qq0cTJzLMhlWQGjlygFx1wGg=
X-Google-Smtp-Source: ABdhPJz3kNGjJdbotqsutuQHf4kH/HX/VLK7TUtT0HmpbHEFhDMoOyq8VAXjwjwsXWC3bDViD5WiVQ==
X-Received: by 2002:a6b:7610:: with SMTP id g16mr4049888iom.115.1596208220646;
        Fri, 31 Jul 2020 08:10:20 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w15sm4905945ila.65.2020.07.31.08.10.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2020 08:10:20 -0700 (PDT)
Subject: Re: [PATCH 0/6] 5.9 small cleanups/fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1596123376.git.asml.silence@gmail.com>
 <3f481017-bfc8-d0ac-fbb1-b4fbac781eb1@kernel.dk>
 <ccea0f83-8ef3-018f-a590-ef8fad255b94@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d894ebc4-2e54-3eb5-ba21-dff42b022e7f@kernel.dk>
Date:   Fri, 31 Jul 2020 09:10:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ccea0f83-8ef3-018f-a590-ef8fad255b94@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/31/20 8:28 AM, Pavel Begunkov wrote:
> On 30/07/2020 21:08, Jens Axboe wrote:
>> On 7/30/20 9:43 AM, Pavel Begunkov wrote:
>>> [1/1] takes apart the union, too much trouble and there is no reason
>>> left for keeping it. Probably for 5.10 we can reshuffle the layout as
>>> discussed.
>>
>> Let's hope so, because I do think this is the safest option, but it does
>> incur a 5% drop for me.
> 
> Hmm, any ideas why? If your test doesn't use neither apoll/poll/io-wq,
> then it looks like either something related to slab (e.g. partial zeroing),
> or magic with @task_work moved from 4th to 3rd cacheline.

Was looking into it just now, but I think it was just a bad test run. Checked
out and ran a new test, and then just with #1 applied which would be the only
one that should impact things. And it's pretty close, so I'm going to call
it a wash.

So nothing to worry about I think.

-- 
Jens Axboe

