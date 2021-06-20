Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAF93AE025
	for <lists+io-uring@lfdr.de>; Sun, 20 Jun 2021 22:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhFTULK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Jun 2021 16:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbhFTULK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Jun 2021 16:11:10 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37AA5C061574;
        Sun, 20 Jun 2021 13:08:57 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id c9so17194262wrt.5;
        Sun, 20 Jun 2021 13:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=K6hP8zxpxK6evZOXHpF0z21aotgESEZI1DXffVp/DBY=;
        b=YC898T3SQGIirS1uD8L0AnCX+DWO4XWC68WnN2GjV9aNqSnTq/P15BYRYoHhXgbpRy
         ynipamEhRPZDNSaOjM2IYDUTwjXjf5uIvq6l9W108ShDpfwRzjtz8p2B6zkeCnJt6hR0
         chRg6nDYprd3+Y+sakEFiyMacATfnAmnpMbKDbU5nzBAl4MSLAeOfAhi4Ciliu/Tw/pG
         I3JJJpNOEkO1ltDDBVjN5GWCoSfbD9rMlHosK7DcFBFAKzsO1VxV5gmiRc+0w9y46gsv
         G/vo5Ff/695Ot8EkAOYJPzv8YMN8M7EGRQ86Fn7llmO/xXXduIX2earZeU2nXqCJ7Nqt
         2PMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K6hP8zxpxK6evZOXHpF0z21aotgESEZI1DXffVp/DBY=;
        b=Zdjn0bDXkiBSdaUUB1WunwjUoYQTMDwPhrOZvhYyO0HuT2kkYvIrIf8afnDD2hly/9
         sx2tCiYz5NBYQZ3TF6L1EaWyy9eZt9ztpPL4np+3GBSRMmSPylSKPDl5PHQmv+KlKUJ4
         H6zkpU3tMxLq6xl/AoTcSOFb9ePWSRhkvELGxAjSdQY9kDKSQdLiNH13nWV4qEGR4rQT
         NlGo1qo604f+bSxzj3V7tmK/FuhaFDHJSVSXBt7LPRhGaBRzzXYAxni+IPYzNE/YPUjH
         Ws3McYtqyVWsg1pPy5QFMoXST+JaIuPORdfUscuslvQcaznywQo1S/GnCOb2UguINQud
         YqQQ==
X-Gm-Message-State: AOAM533dKxOeWsH9QvzKBk0+267SOPs6DRw74BPzDXs41e+YbhEcsXFA
        Hh4GoWdRgJJnKdx5OeOb3C3njwnN3M3VmQ==
X-Google-Smtp-Source: ABdhPJzn5/YEzv8Z7SNheBcsvYqdTTqE1FRL2YE5/sj7Yjjc7n2deCAvwcqNYHRWMcqEFhobfY2RVw==
X-Received: by 2002:a5d:6485:: with SMTP id o5mr24229204wri.91.1624219735538;
        Sun, 20 Jun 2021 13:08:55 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.72])
        by smtp.gmail.com with ESMTPSA id d15sm15038687wri.58.2021.06.20.13.08.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Jun 2021 13:08:55 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: reduce latency by reissueing the operation
To:     Randy Dunlap <rdunlap@infradead.org>,
        Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <e4614f9442d971016f47d69fbcba226f758377a8.1624215754.git.olivier@trillion01.com>
 <c5394ace-d003-df18-c816-2592fc40bf08@infradead.org>
 <b0c5175177af0bfd216d45da361e114870f07aad.camel@trillion01.com>
 <4578f817-c920-85f1-91af-923d792fc912@infradead.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <7ad30cb0-3322-6c40-2a1b-27308aa757d8@gmail.com>
Date:   Sun, 20 Jun 2021 21:08:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <4578f817-c920-85f1-91af-923d792fc912@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/20/21 9:01 PM, Randy Dunlap wrote:
> On 6/20/21 12:28 PM, Olivier Langlois wrote:
>> On Sun, 2021-06-20 at 12:07 -0700, Randy Dunlap wrote:
>>> On 6/20/21 12:05 PM, Olivier Langlois wrote:
>>>> -               return false;
>>>> +               return ret?IO_ARM_POLL_READY:IO_ARM_POLL_ERR;
>>>
>>> Hi,
>>> Please make that return expression more readable.
>>>
>>>
>> How exactly?
>>
>> by adding spaces?
>> Changing the define names??
> 
> Adding spaces would be sufficient IMO (like Pavel suggested also).

Agree. That should be in the code style somewhere

-- 
Pavel Begunkov
