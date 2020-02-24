Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEF4D16ACF7
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 18:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgBXRT3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 12:19:29 -0500
Received: from mail-il1-f170.google.com ([209.85.166.170]:38754 "EHLO
        mail-il1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727359AbgBXRT2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 12:19:28 -0500
Received: by mail-il1-f170.google.com with SMTP id f5so8382447ilq.5
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 09:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=04A6AdJoGXZIwfLiQYjQ51ucn0+w868Hn2fYQ56uES4=;
        b=f/x0nZrgoRnLWAyt+qSFtI8/eQw6cm7a2wgRoTl5XuZpieaa9c5tv4NIS7lkODg8Vo
         RMCHIVIlfP/GjDjGZ9yssXF2/CCFh/6AtPwB1x1EssoVyHLJJ3k18SQAs8KOtgbmDKSu
         WoQRT2drSt0P9hxYJ7dxzlp/xk8x8lFEY+a86edGjLl4Jgp5UGzgSWhGWD5IUWuMvvnI
         GFhLeZhT7Lz6FfsqJK9QrAu+Lo0VMcnX7dHQPTqA2VIpKfkHUxxEZy6iH+2qCEwbhKSM
         3cX8pj1p41INUzvUgV69px+CNe7hex0KpFRL7Mrn3nyisNhK3bl6tFQBUCi/giLquXfL
         FlFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=04A6AdJoGXZIwfLiQYjQ51ucn0+w868Hn2fYQ56uES4=;
        b=scbXqHNGFmZ4eLGrHztXeWxG0R5oOMSYZPwkKTyd5fdfN9Z/HN/oPxMAz/WKzVee9o
         ttwUJZ5VptOvIkVqKSSBsZAN7f1Ng6zBFlMQf3T4QnN8IDEpU8DAyxQVbkTD0k9EpSEW
         y57BcHGdlmNMAWEtbl+kxwXoQ1S+oV+HR/+4H3Ihps3p4OYoy6+NwOsoIHD7cdeuUzT7
         uGY2yyApih8lj7vE7350naK7qdEOJZP9drlsxEpRAyQarkGDgyoIHeg207h1BJoksmne
         oMveFPrggUcWvdQfLrlPzX7hd+LHKWiGnKlAln9fTGHQa7sex5opToRvldlqHHtjxlGE
         oaNw==
X-Gm-Message-State: APjAAAXSJZYyD/YqsQLGzpeTF7n0zRA1xdM4z/TJjm3K0WN88j6Y6aik
        PklILzUS2boZewHQAX1QLos03OqYpCU=
X-Google-Smtp-Source: APXvYqxyxWLge8jZWhTGdsGzHwHklpDTYxIkPGgqQzFeNfLWJQd7fpBDPI4urj4LA9wozU48XwS29A==
X-Received: by 2002:a92:af46:: with SMTP id n67mr62614281ili.195.1582564766039;
        Mon, 24 Feb 2020 09:19:26 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v4sm3102218ioh.87.2020.02.24.09.19.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 09:19:25 -0800 (PST)
Subject: Re: Deduplicate io_*_prep calls?
To:     Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org
References: <20200224010754.h7sr7xxspcbddcsj@alap3.anarazel.de>
 <b3c1489a-c95d-af41-3369-6fd79d6b259c@kernel.dk>
 <20200224033352.j6bsyrncd7z7eefq@alap3.anarazel.de>
 <90097a02-ade0-bc9a-bc00-54867f3c24bc@kernel.dk>
 <20200224071211.bar3aqgo76sznqd5@alap3.anarazel.de>
 <933f2211-d395-fa84-59ae-0b2e725df613@kernel.dk>
 <20200224165334.tvz5itodcizpfkmw@alap3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <14eb8dcb-d5ba-9e0a-697d-e4b8fbad3f08@kernel.dk>
Date:   Mon, 24 Feb 2020 10:19:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200224165334.tvz5itodcizpfkmw@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/20 9:53 AM, Andres Freund wrote:
> Hi,
> 
> On 2020-02-24 08:40:16 -0700, Jens Axboe wrote:
>> Agree that the first patch looks fine, though I don't quite see why
>> you want to pass in opcode as a separate argument as it's always
>> req->opcode. Seeing it separate makes me a bit nervous, thinking that
>> someone is reading it again from the sqe, or maybe not passing in
>> the right opcode for the given request. So that seems fragile and it
>> should go away.
> 
> Without extracting it into an argument the compiler can't know that
> io_kiocb->opcode doesn't change between the two switches - and therefore
> is unable to merge the switches.
> 
> To my knowledge there's no easy and general way to avoid that in C,
> unfortunately. const pointers etc aren't generally a workaround, even
> they were applicable here - due to the potential for other pointers
> existing, the compiler can't assume values don't change.  With
> sufficient annotations of pointers with restrict, pure, etc. one can get
> it there sometimes.
> 
> Another possibility is having a const copy of the struct on the stack,
> because then the compiler often is able to deduce that the value
> changing would be undefined behaviour.
> 
> 
> I'm not sure that means it's worth going for the separate argument - I
> was doing that mostly to address your concern about the duplicated
> switch cost.

Yeah I get that, but I don't think that's worth the pain. An alternative
solution might be to make the prep an indirect call, and just pair it
with some variant of INDIRECT_CALL(). This would be trivial, as the
arguments should be the same, and each call site knows exactly what
the function should be.

-- 
Jens Axboe

