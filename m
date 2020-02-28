Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69CE1174289
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2020 23:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgB1WxT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 17:53:19 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34858 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgB1WxT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 17:53:19 -0500
Received: by mail-wm1-f66.google.com with SMTP id m3so5089333wmi.0
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2020 14:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d0Bc9mq+Yn5jjtulmZbfXZOJxGrxDQKg4YGKk3YvZHM=;
        b=ohxuIUMA/W8NI0TKHJU7kagQ4y1q1spWP/zKQowxwilbwz7b5vCc18ZhgR2Vifkz4F
         N4qN5terflh8JuRUKopOLxKRn0gUIfj0K+TbeVXcS0Ahaxxe+HVUfyV1kyryqdpW7NaF
         /xBKV9zNcmw+W68V4irYuIdhDvgS9CXX1MfhgQ2g5Od7DHUMD3Ftti81s5qqJB+TnvqQ
         Dnrh9YW6N5nXUP/VRYwrOqKLAfkExDD08UPkH3xspUQO+rF/BHdB8RxPgFqgiCvmwOHR
         peIjDNEskYhpw1ipmoqd4Q9CS49I3t9gLcyQ2ahGyKjVCOymFC7qJWrA67f2pjBjkBR5
         smPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d0Bc9mq+Yn5jjtulmZbfXZOJxGrxDQKg4YGKk3YvZHM=;
        b=EuVFIVGtG24tQ3DoVQ7I65BYhq6dcXT1Z/gveU6utkIyC7w1FQd+QdFhlIZFxu85vY
         l5EajIjsSGVc3nMluXBHPsUK5ofO9S+1TOjUuZxzKFmCEtPsZiyKSNW6R2C3U2WIvjwk
         kMU23Re5I4apIRlRZ0m2+DO1U+Sjh0vaSOsgJ57cRDelEzwd9w/5CTfIt6gjlZRkxi93
         e0Je1EkqwGrGj9J6ojRVJS6Hkp+R3w1jSdbTsv1lb4IWHLeWp2fEQJ63gWD/Ia2e3Fmd
         Zwha8wBOa1XvXfe01FH4ZfiTkh2FACzYCnnjyc+TwpQAKUyAhV6xyXZXakvdFp0p4Bn6
         80/Q==
X-Gm-Message-State: APjAAAVO7WRstf+InlOFmAj3c5ha8wlUMP/GBl5rN/8qhPM/EQcveW0s
        g4+KGsM82m/1rgzzXHf1Cv7hML9j
X-Google-Smtp-Source: APXvYqxBY1QyYuWheCerZpPov/0k+UBpTyiKlm1KfsbIIrsakoKtXq87smYipmZRLHlFoLpmmi4HZQ==
X-Received: by 2002:a1c:4341:: with SMTP id q62mr6721462wma.107.1582930396563;
        Fri, 28 Feb 2020 14:53:16 -0800 (PST)
Received: from [192.168.43.88] ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id v131sm4208565wme.23.2020.02.28.14.53.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 14:53:16 -0800 (PST)
Subject: Re: Issue with splice 32-bit compatability?
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <ea81e4f4-59d2-fa8e-2b5c-0c215c378850@kernel.dk>
 <1f39b13b-d3c0-d731-35f7-0aaadec1c14e@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <d37666a6-05c7-ba4b-e0e9-7995da300b2c@gmail.com>
Date:   Sat, 29 Feb 2020 01:52:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1f39b13b-d3c0-d731-35f7-0aaadec1c14e@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 28/02/2020 18:25, Jens Axboe wrote:
> On 2/28/20 8:16 AM, Jens Axboe wrote:
>> Hey Pavel,
>>
>> Since I yesterday found that weirdness with networking and using
>> a separate flag for compat mode, I went to check everything else.
>> Outside of all the syzbot reproducers not running in 32-bit mode,
>> the only other error was splice:
>>
>> splice: returned -29, expected 16384
>> basic splice-copy failed
>> test_splice failed -29 0
>> Test splice failed with ret 227
>>
>> Can you take a look? I just edit test/Makefile and src/Makefile and
>> add -m32 to the CFLAGS for testing.
> 
> It's in the liburing prep, fixed it:
> 
> https://git.kernel.dk/cgit/liburing/commit/?id=566180209fc4d9e3ee8852315a4411ee0c3d5510

A subtle one, great you found it!

-- 
Pavel Begunkov
