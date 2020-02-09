Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8C5E156BAC
	for <lists+io-uring@lfdr.de>; Sun,  9 Feb 2020 18:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbgBIREe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 9 Feb 2020 12:04:34 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35433 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727386AbgBIREd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 9 Feb 2020 12:04:33 -0500
Received: by mail-pg1-f196.google.com with SMTP id l24so2583689pgk.2
        for <io-uring@vger.kernel.org>; Sun, 09 Feb 2020 09:04:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ZiRi3Cb7wV78LWI9BhcziGqKCUsH+whDtvIQJLVLHgA=;
        b=1XWkTYT0qnxnXZaiVETyt6BeHDR7Ql0nRcaDf17XZVBBzmFvHirsKDBgAAZLuJQwEi
         wqSGOIVJqX8phZaPujBidWMAIwdF6wIRO3AEj4Ebt/BqE2gOmoC4n1gE70UPHcQR08kV
         YlXVefXjzAoKnZFIJ77/7h8I6H60xg/m8yYvfZJTKDSZgudYEGTp1EwlPZ88Kqa4crel
         4aNZsquEehtB13KlMg09MyRz42DIP3QXDoDcFrYPjbLoyY/F694lMz5iRJrSz39hCJde
         m3L1jvw7A5aEzR4pYm5XN16cvfAIPW1RK/s4lG/Pze2wrGcVKoUjdBRSSS5/szlqSWR9
         M8vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZiRi3Cb7wV78LWI9BhcziGqKCUsH+whDtvIQJLVLHgA=;
        b=XEL6DNFOmmJOxnQsuS2OeFuluGWBQBjYxhjlrJUd0mJwcAL7KE9vHfuCm7plhICIHx
         otsRLuegSH51HR7GlIuwrVsrEamcBzaPAmwZKBUYE8jsLL18cYAJzANDYuJBaOpQptgl
         AKab+4xAAL8ZLlvu7u9CO2JtGHOlbee3ayDU+zpt9LZWs9WkKSzAnCotl9nOCBqMGWQ7
         CLvaEWQ8mKzEbV8wTqjF736/q2x52dVf7itME+vsCDR1MrUtwkwMiRnyTwHtaOVK0inr
         lqkRSSmK49ocqVoLz72hJ87nVxsC12xQiCZF8ex3ZeGy4GlCIkh9gy+5cAeIlOm2d/XT
         ZB0A==
X-Gm-Message-State: APjAAAUUp0xAAk8oafJ/d6WGALCG6uzzFD73i4QtntxrP5xO9bnSd3JW
        DGszBgOJJwkY31YlLhJazNFMsEXAiWY=
X-Google-Smtp-Source: APXvYqxW4EVLx9KY1jQa9TTq+taa0MKJs6TgQaf5r+OTONPjZufr1diQGyP2rd4Xq/KxNx6Yehg3nw==
X-Received: by 2002:a65:4486:: with SMTP id l6mr9277993pgq.1.1581267872418;
        Sun, 09 Feb 2020 09:04:32 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id ci5sm8939762pjb.5.2020.02.09.09.04.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Feb 2020 09:04:31 -0800 (PST)
Subject: Re: [RFC] fixed files
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <ace72a3f-0c25-5d53-9756-32bbdc77c844@gmail.com>
 <ea5059d0-a825-e6e7-ca06-c4cc43a38cf4@kernel.dk>
 <8ac7e520-c94e-22e1-3518-db8432debb6b@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f4956223-0aa0-5157-6964-28e934595d20@kernel.dk>
Date:   Sun, 9 Feb 2020 10:04:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <8ac7e520-c94e-22e1-3518-db8432debb6b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/9/20 5:18 AM, Pavel Begunkov wrote:
> On 2/8/2020 11:15 PM, Jens Axboe wrote:
>> On 2/8/20 6:28 AM, Pavel Begunkov wrote:
>>> Hi,
>>>
>>> As you remember, splice(2) needs two fds, and it's a bit of a pain
>>> finding a place for the second REQ_F_FIXED_FILE flag. So, I was
>>> thinking, can we use the last (i.e. sign) bit to mark an fd as fixed? A
>>> lot of userspace programs consider any negative result of open() as an
>>> error, so it's more or less safe to reuse it.
>>>
>>> e.g.
>>> fill_sqe(fd) // is not fixed
>>> fill_sqe(buf_idx | LAST_BIT) // fixed file
>>
>> Right now we only support 1024 fixed buffers anyway, so we do have some
>> space there. If we steal a bit, it'll still allow us to expand to 32K of
>> fixed buffers in the future.
>>
>> It's a bit iffy, but like you, I don't immediately see a better way to
>> do this that doesn't include stealing an IOSQE bit or adding a special
>> splice flag for it. Might still prefer the latter, to be honest...
> 
> "fixed" is clearly a per-{fd,buffer} attribute. If I'd now design it
> from the scratch, I would store fixed-resource index in the same field
> as fds and addr (but not separate @buf_index), and have per-resource
> switch-flag somewhere. And then I see 2 convenient ways:
> 
> 1. encode the fixed bit into addr and fd, as supposed above.
> 
> 2. Add N generic IOSQE_FIXED bits (i.e. IOSQE_FIXED_RESOURSE{1,2,...}),
> which correspond to resources (fd, buffer, etc) in order of occurrence
> in an sqe. I wouldn't expect having more than 3-4 flags.
> 
> And then IORING_OP_{READ,WRITE}_FIXED would have been the same opcode as
> the corresponding non-fixed version. But backward-compatibility is a pain.

It's always much easier looking back, hindsight is much clearer. I'd also
expand the sqe flags bits to 16 at least, but oh well.

I do think that for this particular case we add a SPLICE_F_FD1_FIXED and
ditto for fd2, and just have the direct splice/vmsplice syscalls reject
them as invalid. Both splice and vmsplice -EINVAL for unknown flags,
which makes this possible.

That seems cleaner to me than trying to shoe-horn this information into
the sqe itself, and it can easily be done as a prep patch to adding
splice support.

-- 
Jens Axboe

