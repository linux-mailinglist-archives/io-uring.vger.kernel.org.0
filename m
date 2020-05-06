Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4151C7D09
	for <lists+io-uring@lfdr.de>; Thu,  7 May 2020 00:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbgEFWM5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 May 2020 18:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728621AbgEFWM4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 May 2020 18:12:56 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAB9C061A0F
        for <io-uring@vger.kernel.org>; Wed,  6 May 2020 15:12:56 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id x25so4220446wmc.0
        for <io-uring@vger.kernel.org>; Wed, 06 May 2020 15:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iRto3Pv0I8PfQscTWb+osH8ceObGXfZ6fyAvXzj7iXQ=;
        b=mFTY4Nsf70+SP7iSIebBKwYzV63EbtvICsNZtTXmKwqFKBQVS+6YRI7oWsdJkbzXnH
         5GYqar/8WI7iETo6omdRj2lpbgGRw8IUQK5wpyJxh+w+dtsWkhyPJ/MW8Q8CBF+wd5FE
         ArbAgjfkTbSje8vlo1w/A4zqGl2GYDlYI2PJ2yGkRLgwpP4n0C8eT4xlM37jFNzwgtzE
         MPse1ESogQw7d6Fd12hO6/8JDDHrkC5rkuUEyV0LEnUzSwNv4W9undFNUgJY9RaQDZrk
         ZoNFgbmyOZ8zEsEzdEKnivphZJkKasH/NrRfY51D10zHaDJ1RATXsHBbpCEZyH6rZQSD
         B/pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=iRto3Pv0I8PfQscTWb+osH8ceObGXfZ6fyAvXzj7iXQ=;
        b=KDRPLFxeNlgMhmUhPEKM4+1Ck+PG3XdGmjYI4e7CIGDmLdGJx29QMjuWy+/F/MHimf
         ZW9/qSPnjkGTCog+M8aZHYtcaLfmsiC51x35PoxGGz+1CcE4g4XmPrgzm/SfZAtVlU6B
         zWhn9C4RD4FsKJCJlsa+PMNYgjJqUSK2u2tUMRSWVqOTzD4bSCW65G3DJHQLr9/iDQZg
         XjhTmB2mO9OuMJEO4umXfcEJ9/vZ7SXPfe4Bqrc5mF6FazE/86kvsSvTQpbuV5QqKUWl
         zdXZusfb2ajxwQNxBP7eaxwiCvETfweQtqFEJVEkdp/DEnfV/BPtZyokfGUJDK7KOW+N
         7LxA==
X-Gm-Message-State: AGi0PuY+NNt0ECRm/zevrlh1RwuK1HtmpmAJr/UHIWGrLhAZdQW4VUXd
        rr8djmgJcGBATBFxYEM0VRI=
X-Google-Smtp-Source: APiQypL5qGRcCUC0rgjV9z8GgLXC7xDvxk9uEn1cMiFICrivAoMKYxOaYfSEoJl3hBnH6HZCpbHBeg==
X-Received: by 2002:a7b:cb86:: with SMTP id m6mr6393254wmi.64.1588803174643;
        Wed, 06 May 2020 15:12:54 -0700 (PDT)
Received: from [192.168.43.168] ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id c83sm5218108wmd.23.2020.05.06.15.12.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 15:12:53 -0700 (PDT)
To:     "Bhatia, Sumeet" <sumee@amazon.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     "Hegde, Pramod" <phegde@amazon.com>, Jens Axboe <axboe@kernel.dk>
References: <1588801562969.24370@amazon.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: Non sequential linked chains and IO_LINK support
Message-ID: <62a52be6-d538-b3ee-a071-4ff45da85a87@gmail.com>
Date:   Thu, 7 May 2020 01:11:46 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1588801562969.24370@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 07/05/2020 00:46, Bhatia, Sumeet wrote:
> Hello everyone,
> 
> I've been exploring iouring to submit disk operations. My application generates disk operations based on some events and operations are unknown until those events occur.  Some of these disk operations are interdependent others are not. 
> 
> Example: Following operations are generated and submitted before any of them are complete
> operation_0 (independent operation)
> operation_1 (independent operation),​
> operation_2 (to be issued only if operation_0 was successful),
> operation_3 (independent operation),
> operation_4 (to be issued only if operation_1 was successful)
> 
> In my example I have two independent link chains, (operation_0, operation_2) and (operation_1, operation_4).  iouring documentation suggests IOSQE_IO_LINK expects link chains to be sequential and will not support my use case. 

First of all, there shouldn't be a submission (i.e. io_uring_enter(to_submit>0))
between adding linked requests to a submission queue (SQ). It'd be racy otherwise.

E.g. you can't do:

add_sqe(op0)
submit(op0)
add_sqe(op2, linked)

Though the following is valid, as we don't submit op0:

add_sqe(opX)
add_sqe(op0)
submit(up until opX)
add_sqe(op2, linked)


And that means you can reorder them just before submitting, or filing them into
the SQ in a better order.

Is it helpful? Let's figure out how to cover your case.


> I explored creating new iouring context for each of these linked chains. But it turns out depending on disk size there can be somewhere between 500-1000 such chains. I'm not sure whether it is prudent to create that many iouring contexts.

Then you would need to wait on them (e.g. epoll or 1000 threads), and that would
defeat the whole idea. In any case even with sharing io-wq and having small CQ
and SQ, it'd be wasteful keeping many resources duplicated.

> 
> I am reaching out to check whether there would be a generic need to support nonsequential linked chains on a single iouring context. Would love to hear all your thoughts.
> 
> Thanks,
> Sumeet
> 

-- 
Pavel Begunkov
