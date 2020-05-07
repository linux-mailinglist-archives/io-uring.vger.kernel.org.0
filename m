Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2DD1C9A28
	for <lists+io-uring@lfdr.de>; Thu,  7 May 2020 20:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgEGS6K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 May 2020 14:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726926AbgEGS6K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 May 2020 14:58:10 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D281CC05BD43
        for <io-uring@vger.kernel.org>; Thu,  7 May 2020 11:58:09 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id s10so3754649iln.11
        for <io-uring@vger.kernel.org>; Thu, 07 May 2020 11:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DQ2fRmSsYR8QxZExpNvs+J6T/j4NBo+77TrT19T8b1o=;
        b=criEGrIxTbs3pcTAzl1VVJFPPTMm+hj/dlBpfzOWpe/SJnFzFlDOX+TBsWRZS7H9Zf
         Joaei8Sad7raGclrkzfIaqbiay6zOJHf8A4jdBOGqOw77nB1+902iQqShxvIG6VURvcX
         lDnyTqJd0zDmgPpgMZspNs2KrYlzJAQHlvnRkTwUKsLRHeX3a601N7wyWpS0JwChRgFq
         IvIRNfOkrbPD/YSFEag9evFFVPxBjy1SJTb1tJXAGxpxkusuKmwjuEWjkNB1POs9y2OR
         1au4TktrfK7XuKjzkIfwTCPgY/uz2RRXvNnvXsQp6gc9DzFOd0FcAfx5uZJgrq68XRPj
         YOPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DQ2fRmSsYR8QxZExpNvs+J6T/j4NBo+77TrT19T8b1o=;
        b=WCqlaL2Q99i4jSYEYLQBy9gGbbL1NctOHp7Px3feg7KdXQKVYX/YMzUZwlbj/iefs1
         hhtDsGwOVgzKrcUA8ZvXn6W+WTAAJteXmymzrbuWyC52Fo9uTLlws8OGJoQ6yQvu6zaZ
         PlGe0Zt6Q1HfRvYiUj1bjvAEouNjOvo7/TIkQg6li8jt1aKe1GbheIiAVtW5dfnkdDyt
         Ok637iRsPNBXvZFuuRqayyiDoER2/VgOSUt8N/+q9242r+40PxjnN3ehoQ8xRpf7/0fS
         msnPQXh/O2OdQ4vNBDzurZqNAeSMCHG9WiUSQyyvoCTdiW7jpNjCCRz9oVsMZ1cx6sAM
         guWQ==
X-Gm-Message-State: AGi0PuYuPw14/nyXcVPvS1Od2e6/fux5ut53FzARxAxV9TqwJna+ytv9
        VUmo7te0P9R8oesgfBKUBc4rZZSjKlE=
X-Google-Smtp-Source: APiQypL7bdm+URYteCaMctnOtFVvumzG/T2YOByZiG3jCI5ZxJiZh3/a1qLq8GT+fL8/sfZrQwJ+rQ==
X-Received: by 2002:a92:c845:: with SMTP id b5mr15089082ilq.63.1588877888990;
        Thu, 07 May 2020 11:58:08 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id q29sm3110861ill.65.2020.05.07.11.58.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 11:58:08 -0700 (PDT)
Subject: Re: Data Corruption bug with Samba's vfs_iouring and Linux
 5.6.7/5.7rc3
To:     Jeremy Allison <jra@samba.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        Samba Technical <samba-technical@lists.samba.org>
References: <cd53de09-5f4c-f2f0-41ef-9e0bfca9a37d@kernel.dk>
 <a8152d38-8ad4-ee4c-0e69-400b503358f3@samba.org>
 <6fb9286a-db89-9d97-9ae3-d3cc08ef9039@gmail.com>
 <9c99b692-7812-96d7-5e88-67912cef6547@samba.org>
 <117f19ce-e2ef-9c99-93a4-31f9fff9e132@gmail.com>
 <97508d5f-77a0-e154-3da0-466aad2905e8@kernel.dk>
 <20200507164802.GB25085@jeremy-acer>
 <01778c43-866f-6974-aa4a-7dc364301764@kernel.dk>
 <20200507183140.GD25085@jeremy-acer>
 <3130bca5-a2fb-a703-4387-65348fe1bdc8@kernel.dk>
 <20200507185507.GF25085@jeremy-acer>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c28c40aa-9241-8cdc-92d4-027ab91702de@kernel.dk>
Date:   Thu, 7 May 2020 12:58:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200507185507.GF25085@jeremy-acer>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/7/20 12:55 PM, Jeremy Allison wrote:
> On Thu, May 07, 2020 at 12:35:42PM -0600, Jens Axboe wrote:
>> On 5/7/20 12:31 PM, Jeremy Allison wrote:
>>>
>>> Look at how quickly someone spotted disk corruption
>>> because of the change in userspace-visible behavior
>>> of the io_uring interface. We only shipped that code
>>> 03 March 2020 and someone *already* found it.
>>
>> I _think_ that will only happen on regular files if you use RWF_NOWAIT
>> or similar, for regular blocking it should not happen. So I don't think
>> you're at risk there, though I do think that anyone should write
>> applications with short IOs in mind or they will run into surprises down
>> the line. Should have been more clear!
> 
> Well we definitely considered short IOs writing the
> server code, but as the protocol allows that to be
> visible to the clients (in fact it has explicit
> fields meant to deal with it) it wasn't considered
> vital to hide them from clients.

Yes, and in case my reply wasn't totally clear, it was more of a general
observation, not directed at Samba specifically!

> We'll certainly fix up short reads for the iouring
> module, but it's less clear we should mess with
> our existing blocking threaded pread/pwrite code
> to deal with them. Possibly goes into the bucket
> of "belt and braces, couldn't possibly hurt" :-).

Agree, belts and suspenders for the regular pread/pwrite, that's a fair
position.

> Thanks for the clarification !

Thanks for getting this fleshed out! Impressed with the speed at which
we got to the bottom of this.

-- 
Jens Axboe

