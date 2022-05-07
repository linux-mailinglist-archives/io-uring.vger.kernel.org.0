Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8EBB51E83A
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 17:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377641AbiEGPmM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 11:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242869AbiEGPmL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 11:42:11 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565DC419A6
        for <io-uring@vger.kernel.org>; Sat,  7 May 2022 08:38:24 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id x12so8475472pgj.7
        for <io-uring@vger.kernel.org>; Sat, 07 May 2022 08:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=iW+xuwi9GjKsQKztoza/I6BqdqWQumP2VpSCZrUbboc=;
        b=A4AoqMht5A35+l+JOZ9w6u/pQWgJqgySLRk13szh9hQiupLiYJan2peyR1PHoWXqbA
         KXyNbUQ2r7VIy6XRnhjLnmG1f5mu7D4eBnHv9CvUZGiNgWN1ISt56KI7EsnBmv5jZkJX
         UFWemVNe20zXjfe8H/DBTGfRwzkh163h3KM8gMiUIy2DDbO/PDd7I9lw5F2BrWCpMoyf
         DsHpOejJ5bSILZJziqcE4O/j56/vj9KTWREt+I26UoFoqS07X3V6He9IyqZrRe0Dl70q
         JXr0jTKZI8VQl1yZK5PeaTnZZ4aO01ylQE1mZiFE1at0SLOPHpixyIzCR/cAWiEJvhHt
         32yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iW+xuwi9GjKsQKztoza/I6BqdqWQumP2VpSCZrUbboc=;
        b=4LDgGN7zKJZPr/9vgHs84yaf08C38Z0ZtTRFhhrkmolARebqXHAwpmaVNLqOB//BtD
         eOWOjs8jceuihPL4sITaXfgZgK+sHSnVsGd2fUJk7kWPemNbBDw9NZeNfsVAB6cjHW+g
         /q7IlnMj1A+NwdDN5oRXScd6ZTO67WfNhhbOBG6lsPPaVfDkFask6sQIPkT7TiiKmB9i
         HyZjCCBGXhx67I4uZRQTpe0Fo+JFA+pvXYcHlE9XRdmxBqjp8MBG3AB7abnfyKDxEwIM
         E0G9mMKErxmmufNKV5wV+QiwMUX7nGZNekN/azGyVYzhdjkWL4SqrJyx54oBvd5fcCEO
         sztg==
X-Gm-Message-State: AOAM531XX1ZGGjvJn0PBfegtE/mNgObkxTS9HJNDG+o3p2Ooo5VnSm7Y
        03s0uMEbkYCVzg5QZAGWKhFeAgjzY+rXKA==
X-Google-Smtp-Source: ABdhPJylUzDkAA95vrZWbJ9NhQQpUcTXF2BzWw1znP+C6BwqmrCb4rR6QSI6/1M6BivM/yqq9Nt60w==
X-Received: by 2002:a63:64c2:0:b0:3c6:2d70:9188 with SMTP id y185-20020a6364c2000000b003c62d709188mr6859960pgb.186.1651937903114;
        Sat, 07 May 2022 08:38:23 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id 30-20020a17090a19de00b001dc8eca6536sm5564919pjj.4.2022.05.07.08.38.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 May 2022 08:38:22 -0700 (PDT)
Message-ID: <0145cd16-812b-97eb-9c6f-4338fc25474a@kernel.dk>
Date:   Sat, 7 May 2022 09:38:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 1/4] io_uring: add IORING_ACCEPT_MULTISHOT for accept
Content-Language: en-US
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20220507140620.85871-1-haoxu.linux@gmail.com>
 <20220507140620.85871-2-haoxu.linux@gmail.com>
 <21e1f932-f5fd-9b7e-2b34-fc3a82bbb297@kernel.dk>
 <c55de4df-a1a8-b169-8a96-3db99fa516bb@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c55de4df-a1a8-b169-8a96-3db99fa516bb@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/7/22 9:31 AM, Hao Xu wrote:
> ? 2022/5/7 ??10:16, Jens Axboe ??:
>> On 5/7/22 8:06 AM, Hao Xu wrote:
>>> From: Hao Xu <howeyxu@tencent.com>
>>>
>>> add an accept_flag IORING_ACCEPT_MULTISHOT for accept, which is to
>>> support multishot.
>>>
>>> Signed-off-by: Hao Xu <howeyxu@tencent.com>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> Heh, don't add my SOB. Guessing this came from the folding in?Nop, It is in your fastpoll-mshot branch
> https://git.kernel.dk/cgit/linux-block/commit/?h=fastpoll-mshot&id=e37527e6b4ac60e1effdc8aaa1058e931930af01

But that's just a stand-alone fixup patch to be folded in, the SOB
doesn't carry to other patches. So for all of them, just strip that for
v4. If/when it gets applied, my SOB will get attached at that point.

-- 
Jens Axboe

