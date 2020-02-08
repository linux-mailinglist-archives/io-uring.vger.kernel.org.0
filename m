Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6451564C4
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2020 15:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbgBHO0T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 8 Feb 2020 09:26:19 -0500
Received: from mail-lj1-f178.google.com ([209.85.208.178]:34666 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbgBHO0T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 8 Feb 2020 09:26:19 -0500
Received: by mail-lj1-f178.google.com with SMTP id x7so2349228ljc.1
        for <io-uring@vger.kernel.org>; Sat, 08 Feb 2020 06:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=PAyGmNjIc0itlqmYnDzKd6MlLElnXkGphOwdfhPBos8=;
        b=S4H82biEzaYeFMvQN9RF6a7bcq5NExR6eY216tPeBb0msBIIBPXRf+9amyCxF+untu
         TRL72U05fjhTlC+2Tbd6z48JVU9mSAgOn8ReqW+cJ4g1y29rfvHMyShR9wvLTzR1wt76
         E2hKkWzUKXta0Ltl3TmMZXIfSJrcVFXlWyu1e/KT8nXL04AzfZ7BW8ZGXhcWQ9C48EVb
         2jsK8V8j+UllsFeQgeB0cd43H1dUkbXwd/SNeg+4ujfF1Unufrmk6bhMgkCUF8nR1M4w
         5VWvWGhQGM18F8tJqUXHSBbFGDVMY+lu7xkNse6qhUuqfJF1/GhBqiQi7uk/NmSqtHP7
         1XGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PAyGmNjIc0itlqmYnDzKd6MlLElnXkGphOwdfhPBos8=;
        b=h1YqMtdAxfjVBM7cymouFvJQiCx4JKVpnJM/acNVI0q0OLtydwHPS8HNaR6A1UWYwQ
         92jMt4QOEs0zu/Be7yq215hKnRMzr6vSShg9Uya4vr5m19fTNS/R7h4Wa7ZjubiqsCSz
         FGoz4WPuesTtHh796TWADuSrfoW2tOXyDWpZiLzd6KODykP9ky41CJe2jW46FgyN0AJa
         MfKjVtj605nLFPZFpd1PwXbEUCffYVnqxTVXEnIAw00kFVsLKWLqIfw/Igq4st6Je/9s
         rTy2dk7bowsqaojVOdgN/X+vrnc60G9ZooDt0d6S6RintYiF03iCOmvDjiQAUh8S03h0
         0Udw==
X-Gm-Message-State: APjAAAU3fFDHjGOo+zzsSjDgw6Zv0cFk4C0Zn3qi5AfIOG0VlOGQ+Ra7
        NOSHXxW1E3p4qZK8JNyRMTs=
X-Google-Smtp-Source: APXvYqzO3eggByQboxLmsUC2aPafmpNj2sdkkpS24G1RwDzVYt7F6iuuS7HoZI/iFbM1rq/g/izgSA==
X-Received: by 2002:a2e:9596:: with SMTP id w22mr2698935ljh.21.1581171977381;
        Sat, 08 Feb 2020 06:26:17 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id z8sm3167655ljk.13.2020.02.08.06.26.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Feb 2020 06:26:16 -0800 (PST)
Subject: Re: shutdown not affecting connection?
To:     Glauber Costa <glauber@scylladb.com>, io-uring@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Avi Kivity <avi@scylladb.com>
References: <CAD-J=zaQ2hCBKYCgsK8ehhzF4WgB0=1uMgG=p1BQ1V1YsN37_A@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <cfc6191b-9db3-9ba7-9776-09b66fa56e76@gmail.com>
Date:   Sat, 8 Feb 2020 17:26:15 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <CAD-J=zaQ2hCBKYCgsK8ehhzF4WgB0=1uMgG=p1BQ1V1YsN37_A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi

On 2/8/2020 4:55 PM, Glauber Costa wrote:
> Hi
> 
> I've been trying to make sense of some weird behavior with the seastar
> implementation of io_uring, and started to suspect a bug in io_uring's
> connect.
> 
> The situation is as follows:
> 
> - A connect() call is issued (and in the backend I can choose if I use
> uring or not)
> - The connection is supposed to take a while to establish.
> - I call shutdown on the file descriptor
> 
> If io_uring is not used:
> - connect() starts by  returning EINPROGRESS as expected, and after
> the shutdown the file descriptor is finally made ready for epoll. I
> call getsockopt(SOL_SOCKET, SO_ERROR), and see the error (104)
> 
> if io_uring is used:
> - if the SQE has the IOSQE_ASYNC flag on, connect() never returns.
> - if the SQE *does not* have the IOSQE_ASYNC flag on, then most of the
> time the test works as intended and connect() returns 104, but
> occasionally it hangs too. Note that, seastar may choose not to call
> io_uring_enter immediately and batch sqes.
> 
> Sounds like some kind of race?
> 
> I know C++ probably stinks like the devil for you guys, but if you are
> curious to see the code, this fails one of our unit tests:
> 
> https://github.com/scylladb/seastar/blob/master/tests/unit/connect_test.cc
> See test_connection_attempt_is_shutdown
> (above is the master seastar tree, not including the io_uring implementation)
> 
Is this chaining with connect().then_wrapped() asynchronous? Like kind
of future/promise stuff? I wonder, if connect() and shutdown() there may
be executed in the reverse order.

The hung with IOSQE_ASYNC sounds strange anyway.


> Please let me know if this rings a bell and if there is anything I
> should be verifying here
> 

-- 
Pavel Begunkov
