Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83202251D6D
	for <lists+io-uring@lfdr.de>; Tue, 25 Aug 2020 18:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgHYQrH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Aug 2020 12:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgHYQrG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Aug 2020 12:47:06 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85025C061574
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 09:47:06 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id h4so13179101ioe.5
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 09:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=83jcsvxBe5kJpk0efrvhZzhqUr+BG7E7jxQd0SMchGc=;
        b=dm7IwWbu4JrZg+E87GaKNWNdP8HDFuRw7undPGvU2PKF+Vzps6vhKzv48o5tn/iJ2X
         Qc6nD40xLP7q2XPYGfRYuw4BTrEqeN9enQsoAHEDQPWZlHbK7yHLvOJATwecIxt0NsRD
         yawCTUHDYXs/FJbDIbg+6F8vvRx/WlJc2EUC9777vHnleB0oVxfLnHBOry1t+5guj5tB
         tYwdRL69dsteACHEAInlhSFRb5ezXgHxIfNHmioZCWM5bR2BMKO8EyHkzLt6KfXeSMNn
         GHPoQlCktaehi3KhiXK9am/jQJ6bjmynGK5Z3jkCNORbOghi8Iy3jilMQKC8UaFXsmz9
         NyFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=83jcsvxBe5kJpk0efrvhZzhqUr+BG7E7jxQd0SMchGc=;
        b=Uo8Ut9TwHo+4eIPlhkPjnytEf7olhwMmw+owGxchPG65lZudtlqrH417iyYTLRCaZQ
         ATg481InGU16IpMS0Yf+x8hWXVH9bWffByIDtxkahh4VnEJRxWG43z9wrPyKqhi8grY0
         +ptt5UsU9ThoTGEFtKAIlrjB3AsJcpF5nABFM3my2y9g/ygtrwFqFK5iRL7hkWw54Zl0
         GoJJ5ALdeUVSNTnat8vTDO9WtmYJRxkrGoe4QeJKqyNOSQmnkwq8Pe+XZ1tStccOw85Q
         JFwMUfpsjeomE/8/w9iTpN3H1odkwsAjtyZWqhb5h9ANmwu6Gcl3UyL+9DwRIIsqIKFP
         XIag==
X-Gm-Message-State: AOAM531MotO1+Odvu0OqSnqfl6wsw+h0Jd7Q/Ku6maiS7BKAwXA3t0b4
        DZ3VBLh3Wog7CZNoJ944ZJwR/g==
X-Google-Smtp-Source: ABdhPJwaRif2Si3VsLT32Zj6Uw3pu39Pp0Uj+u65uKVxOVtE/qWbxHgTT6fO0KWOmrhYVJAQA8nkyQ==
X-Received: by 2002:a5d:888b:: with SMTP id d11mr9573726ioo.188.1598374024747;
        Tue, 25 Aug 2020 09:47:04 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p6sm9362571ilm.55.2020.08.25.09.47.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2020 09:47:04 -0700 (PDT)
Subject: Re: io_uring file descriptor address already in use error
To:     Josef <josef.grieb@gmail.com>, io-uring@vger.kernel.org
Cc:     norman@apache.org
References: <CAAss7+o=0zd9JQj+B0Fe1cONCtMJdKkfQuT+Hzx9X9jRigrfZQ@mail.gmail.com>
 <639db33b-08f2-4e10-8f06-b6d345677df8@kernel.dk>
 <308222a7-8bd2-44a6-c46c-43adf5469fa3@kernel.dk>
 <c07b29d1-fff4-3019-4cba-0566c8a75fd0@kernel.dk>
 <CAAss7+rKt6Eh7ozCz5syJSOjVVaZnrVSXi8zS8MxuPJ=kcUwCQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ab3ddb12-c3ca-5ebb-32ff-d041f8eb20d1@kernel.dk>
Date:   Tue, 25 Aug 2020 10:47:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAAss7+rKt6Eh7ozCz5syJSOjVVaZnrVSXi8zS8MxuPJ=kcUwCQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/25/20 10:38 AM, Josef wrote:
>> Not sure this is an actual bug, but depends on how you look at it. Your
>> poll command has a reference to the file, which means that when you close
>> it here:
>>
>>     assert(close(sock_listen_fd1) == 0);
>>
>> then that's not the final close. If you move the io_uring_queue_exit()
>> before that last create_server_socket() it should work, since the poll
>> will have been canceled (and hence the file closed) at that point.
>>
>>  That said, I don't believe we actually need the file after arming the
>>  poll, so we could potentially close it once we've armed it. That would
>>  make your example work.
> 
> 
> ah okay that makes sense
> 
>> Actually we do need the file, in case we're re-arming poll. But as stated
>> in the above email, this isn't unexpected behavior. You could cancel the
>> poll before trying to setup the new server socket, that'd close it as
>> well. Then the close() would actually close it. Ordering of the two
>> operations wouldn't matter.
>>
>> Just to wrap this one up, the below patch would make it behave like you
>> expect, and still retain the re-poll behavior we use on poll armed on
>> behalf of an IO request. At this point we're not holding a reference to
>> the file across the poll handler, and your close() would actually close
>> the file since it's putting the last reference to it.
>>
>> But... Not actually sure this is warranted. Any io_uring request that
>> operates on a file will hold a reference to it until it completes. The
>> poll request in your example never completes. If you run poll(2) on a
>> file and you close that file, you won't get a poll event triggered.
>> It'll just sit there and wait on events that won't come in. poll(2)
>> doesn't hold a reference to the file once it's armed the handler, so
>> your example would work there.
> 
> oh thanks I'm gonna test that :) yeah I expected exactly the same
> behaviour as in epoll(2) & pol(2) that's why I'm asking
> to be honest it would be quite handy to have this patch(for netty), so
> I don't have to cancel a poll or close ring file descriptor(I do of
> course understand that if you won't push this patch)

In order for the patch to be able to move ahead, we'd need to be able
to control this behavior. Right now we rely on the file being there if
we need to repoll, see:

commit a6ba632d2c249a4390289727c07b8b55eb02a41d
Author: Jens Axboe <axboe@kernel.dk>
Date:   Fri Apr 3 11:10:14 2020 -0600

    io_uring: retry poll if we got woken with non-matching mask

If this never happened, we would not need the file at all and we could
make it the default behavior. But don't think that's solvable.

> is there no other way around to close the file descriptor? Even if I
> remove the poll, it doesn't work

If you remove the poll it should definitely work, as nobody is holding a
reference to it as you have nothing else in flight. Can you clarify what
you mean here?

I don't think there's another way, outside of having a poll (io_uring
or poll(2), doesn't matter, the behavior is the same) being triggered in
error. That doesn't happen, as mentioned if you do epoll/poll on a file
and you close it, it won't trigger an event.

> btw if understood correctly poll remove operation refers to all file
> descriptors which arming a poll in the ring buffer right?
> Is there a way to cancel a specific file descriptor poll?

You can cancel specific requests by identifying them with their
->user_data. You can cancel a poll either with POLL_REMOVE or
ASYNC_CANCEL, either one will find it. So as long as you have that, and
it's unique, it'll only cancel that one specific request.

-- 
Jens Axboe

