Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDAAB1D365D
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2020 18:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbgENQVr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 May 2020 12:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgENQVq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 May 2020 12:21:46 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3EBDC061A0C
        for <io-uring@vger.kernel.org>; Thu, 14 May 2020 09:21:45 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id q9so979398pjm.2
        for <io-uring@vger.kernel.org>; Thu, 14 May 2020 09:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A+cd7TmUeMbuYfUNYXAH2YnFWikyl7ZGXznHXC7CsZI=;
        b=VsOZOk5U6NOlqf+OEIOVGd02OdcEg5OkaC0nWcMAEqOhsl0XjQZ/eED0g09M3Lzw2f
         jmSpR/4xxtriDehd90cuLHYG9KKYFIDZojhQj+r1UU0VSY/8cPyecwXvQgvuCylPa9wO
         hn/pUbeOCp5F4JJhq922985STRNtJF3L8o8v8XJ61zeYGrNSrjSnWQQ3dNBL6PkBZepK
         A1LIQIqElRFewwFQ7/KudR9+by0ya07iQLERmAXKrLkVGypaQamuxISdBuZj50biUZ5U
         b5CIFkMeCA7RZENShz6TzQvgiPpZNM4fC409jxSQrpB1MqS5HrG6zukB8O+s/31DBeq1
         BVsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A+cd7TmUeMbuYfUNYXAH2YnFWikyl7ZGXznHXC7CsZI=;
        b=dbNmJRiR8u1PmKKMLxlEIS5NYMhQ5cZjpXglDBUoZA1MtMYY1QX5bzK0wFZW0k9dqM
         rtqsCNSfLIp6HFntNHUA8zRKlR2Y2gnC5+7pPKG8B3aQ5qJnBwXOQTxdRUfy2RF62D9M
         3aS4zx2mjqPJLaUT1N0WaDbqgG1CIpGICxxh3lsR4esR4NJvkzlcGqrxlCMQv4yeVhLa
         gI1WqVtJeMPAWaoTyKENJESAiLpwqrLDOE6tqWDXwECFYFggsZctXxnKsjqKzJycN/rh
         l9JOkwnN/gqgoiudHaL3dxUinJ9Rn4WiKVxAwgbLnBrABS7kUAr5iDTdBePp/x4VjQwK
         Diig==
X-Gm-Message-State: AOAM5326k1p1at4vL7DCL/5WmcdYsghyi0nO2xDxck3N/Vwh8c/aHPEO
        1fJOBkUB9SuAJiqX6KwHwNa0kg==
X-Google-Smtp-Source: ABdhPJxNMftelLuPwcHCKLTaBDKeLcJH72TeyERVIC6kI0KkNb+EdzQVK4oMVerERT+lLVVr2SxA9w==
X-Received: by 2002:a17:90a:26a7:: with SMTP id m36mr3979476pje.28.1589473305151;
        Thu, 14 May 2020 09:21:45 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:85e7:ddeb:bb07:3741? ([2605:e000:100e:8c61:85e7:ddeb:bb07:3741])
        by smtp.gmail.com with ESMTPSA id x10sm2312493pgr.65.2020.05.14.09.21.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2020 09:21:43 -0700 (PDT)
Subject: Re: [PATCH RFC} io_uring: io_kiocb alloc cache
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     joseph qi <joseph.qi@linux.alibaba.com>,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>
References: <492bb956-a670-8730-a35f-1d878c27175f@kernel.dk>
 <dc5a0caf-0ba4-bfd7-4b6e-cbcb3e6fde10@linux.alibaba.com>
 <70602a13-f6c9-e8a8-1035-6f148ba2d6d7@kernel.dk>
 <a68bbc0a-5bd7-06b6-1616-2704512228b8@kernel.dk>
 <0ec1b33d-893f-1b10-128e-f8a8950b0384@gmail.com>
 <a2b5e500-316d-dc06-1a25-72aaf67ac227@kernel.dk>
 <d6206c24-8b4d-37d3-56bd-eac752151de9@gmail.com>
 <b7e7eb5e-cbea-0c59-38b1-1043b5352e4d@kernel.dk>
 <8ddf1d04-aa4a-ee91-72fa-59cb0081695c@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a87adbe8-9c71-0c7b-1a34-faf3d259fdba@kernel.dk>
Date:   Thu, 14 May 2020 10:21:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <8ddf1d04-aa4a-ee91-72fa-59cb0081695c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/14/20 10:18 AM, Pavel Begunkov wrote:
> On 14/05/2020 18:53, Jens Axboe wrote:
>> On 5/14/20 9:37 AM, Pavel Begunkov wrote:
>> Hmm yes good point, it should work pretty easily, barring the use cases
>> that do IRQ complete. But that was also a special case with the other
>> cache.
>>
>>> BTW, there will be a lot of problems to make either work properly with
>>> IORING_FEAT_SUBMIT_STABLE.
>>
>> How so? Once the request is setup, any state should be retained there.
> 
> If a late alloc fails (e.g. in __io_queue_sqe()), you'd need to file a
> CQE with an error. If there is no place in CQ, to postpone the
> completion it'd require an allocated req. Of course it can be dropped,
> but I'd prefer to have strict guarantees.
> 
> That's the same reason, I have a patch stashed, that grabs links from
> SQ atomically (i.e. take all SQEs of a link or none).

OK, I see what you mean. Yeah there's definitely some quirkiness
associated with deferring the allocation. I'm currently just working off
the idea that we just need to fix the refcounts, using a relaxed
version for the cases where we don't have shared semantics. We basically
only need that for requests with out-of-line completions, like irq
completions or async completions.

-- 
Jens Axboe

