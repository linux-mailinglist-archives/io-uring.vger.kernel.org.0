Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDCD1748CD
	for <lists+io-uring@lfdr.de>; Sat, 29 Feb 2020 20:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbgB2TAP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Feb 2020 14:00:15 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46214 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727258AbgB2TAP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Feb 2020 14:00:15 -0500
Received: by mail-pg1-f195.google.com with SMTP id y30so3250238pga.13
        for <io-uring@vger.kernel.org>; Sat, 29 Feb 2020 11:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=sac+PmgYd9Ne11i2xBwpQkfiU9kowkipYWbptuvvnFw=;
        b=R4z/DKbtXdeAv/OuQ9d9v1ISo1ATLBmrv2aWuysEW6ooe9h/rTPgAsDKZ2YC/SI2qN
         MQzEDeoyWr9YLkRgu2iMAlzPXKvIs4/CjfAq61jcEa/CievVDrR/url1Bb+Rin1TSzU1
         u+Cm0F73kwxd1TyaVA4Xb8DLPHSJoEUJ18h83f8DqYsirz+SnSvlvpfLUOyFldACkYbF
         6F87gV4d9DhZ4D/mvb35oAPn6GgBhAti0rvCO0XtrVwKd8pazmiJ89kDrFIcRQ4e0ON5
         hU1kGTLpQ8c1YF9C4N2odM2ewfayyryKsJexxp5nENCpyvJAt01Ye47aO4ZH8oLHjW4+
         TgIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sac+PmgYd9Ne11i2xBwpQkfiU9kowkipYWbptuvvnFw=;
        b=c397wB+BSGrR3PqRXVIQFmT0AnKNBwSavdfKZfoLZlUo50Ym7IVANPyxm8B7ua+e9O
         knU2UBs+0cdQd2JSDhohX3OvuxjARhiTExw8rOAcuMnNQ03/KatCVAgDpUN7BP3+/iP1
         Y5ngr2A1HGlu3sHDarVjTB9l0cFM4UJobILiFKOR7dSoIP1MGDB+wJd5BwMyogP5M/6R
         uo0F6jYlJUcm8u2rKpozNgBSQhcrBT7dKDF8wzBvRzVYTD42kVa7P9N9TTTMXB1BNfu3
         5Kkw06nLuI7RvRxQl4MdeyVV+JX9lJscnhJbHSe7nxSQRLxnB9lxfdbJCevDpGruBfCS
         oGmw==
X-Gm-Message-State: APjAAAVom8ocQ0p+ArXk1rTLu8NV0sCJR+h2sfnyqIy4rdAGWHzM0/nX
        MpE3wO/jtWAXgNxBUTxf2Oo80w==
X-Google-Smtp-Source: APXvYqz90h5w4fCAbtOaE+wTOBQxEsX0PHZKmmlOg/XiBkFXddKf8Ow0liaSJQeYrTlCAmaJcIIPpg==
X-Received: by 2002:a63:214e:: with SMTP id s14mr10713408pgm.428.1583002814148;
        Sat, 29 Feb 2020 11:00:14 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id q12sm15368255pfh.158.2020.02.29.11.00.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Feb 2020 11:00:13 -0800 (PST)
Subject: Re: [PATCH REBASE v2 0/5] return nxt propagation within io-wq ctx
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1582932860.git.asml.silence@gmail.com>
 <fc951f93-9d46-d94d-35af-4c91a2326a0b@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5b366775-6d00-3353-995f-d284d78e9a4e@kernel.dk>
Date:   Sat, 29 Feb 2020 12:00:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <fc951f93-9d46-d94d-35af-4c91a2326a0b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/29/20 11:44 AM, Pavel Begunkov wrote:
> On 29/02/2020 02:37, Pavel Begunkov wrote:
>> After io_put_req_find_next() was patched, handlers no more return
>> next work, but enqueue them through io_queue_async_work() (mostly
>> by io_put_work() -> io_put_req()). The patchset fixes that.
>>
>> Patches 1-2 clean up and removes all futile attempts to get nxt from
>> the opcode handlers. The 3rd one moves all this propagation idea into
>> work->put_work(). And the rest ones are small clean up on top.
> 
> And now I'm hesitant about the approach. It works fine, but I want to
> remove a lot of excessive locking from io-wq, and it'll be in the way.
> Ignore this, I'll try something else
> 
> The question is whether there was a problem with io_req_find_next() in
> the first place... It was stealing @nxt, when it already completed a
> request and were synchronous to the submission ref holder, thus it
> should have been fine.

There was only a problem with it if we have multiple calls of
io_put_req_find_next(), so it was a bit fragile. That was the only
issue, but that's big enough imho.

I'll ignore this series for now, you can always rebase on top of the
other stuff if you want to.

-- 
Jens Axboe

