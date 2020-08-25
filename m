Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F494251BF2
	for <lists+io-uring@lfdr.de>; Tue, 25 Aug 2020 17:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgHYPMn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Aug 2020 11:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbgHYPMW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Aug 2020 11:12:22 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B8FC061574
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 08:12:22 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id p18so10690940ilm.7
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 08:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2BBt5aHNaD7AtRsqS/X3dr6c/TNIUFTn2N9yZNjntAI=;
        b=WxLSgmdPLR5nUXMNMka0xBFDMlv9GzksP+0r/p3cwPXx5LEIAXJVMZg9KiIDdL1DDy
         SqEYy8NsOXR7ejWU8I5j2WUTPrIDjb3NbhZV3o/x43+jc7+tv4UrPGL+K+kFeeNGuX25
         h+7juq9BnfPUdm8tWnUAMOwBi65nhxJodOYuire7OPpFLySaXo01O8p87ewIj+ZCZQSI
         B0hrd9nwSaHbYt23w3cCb+jv0IqbdemAegd7SxAjfIxPx1BspHpbB6Crm+j1j3kLLm+3
         sbzMMHQp008NeRhBTTvHpd7zX4CXEtY2Kgu6rHRZ2v8IWydFtdIaY1zxQMwRugxnDXsZ
         KFag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2BBt5aHNaD7AtRsqS/X3dr6c/TNIUFTn2N9yZNjntAI=;
        b=tI9vojyAz3EyITTz76tmATjg7X42P4DtAnV4FIbi/DUut6dWegmtQ6duZ9mLkXesHL
         HGjjxVlJn9SNJmT3p5m9EBVw+wIrih9duR6eWLAwTrbVwEk8YdVT1765TGXZ0rbgsKqE
         aF+EdvkT/L0AX1Hlc/9nIjZVhihYBFiHB5Oj2VR8jePoBVTD0AT91itF2BQ6Z+U0UjW9
         hf92ILqk5OP1Y6z7oiNNiLP7HORm9sYckkIM35oBq7A4JVvsh6DRKyrYD4Q09yDseoUW
         qXvbwyN2S0z+hS8iCSmXWHD6/UNDabU8mI2RND/BZ+c/ZjyrqaSELpl5CGDrDV4lZXVv
         Xw3A==
X-Gm-Message-State: AOAM531arpqJGZhgHtnrr9UoYOb0rpUGjsWKkUMu+L/9ozjrGmjpfDIT
        CCmhsCK0RaDuTapZPwmIqdsYjA==
X-Google-Smtp-Source: ABdhPJwvz8thmxL49RA9WQu2J5FMnPKeKfL65vkT7WugvM8WGoDHrFDRg8Rd95qIq4yy+M48Y5+3kA==
X-Received: by 2002:a05:6e02:1352:: with SMTP id k18mr9251573ilr.276.1598368338896;
        Tue, 25 Aug 2020 08:12:18 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k7sm8696831iow.21.2020.08.25.08.12.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2020 08:12:17 -0700 (PDT)
Subject: Re: io_uring file descriptor address already in use error
To:     Josef <josef.grieb@gmail.com>, io-uring@vger.kernel.org
Cc:     norman@apache.org
References: <CAAss7+o=0zd9JQj+B0Fe1cONCtMJdKkfQuT+Hzx9X9jRigrfZQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <639db33b-08f2-4e10-8f06-b6d345677df8@kernel.dk>
Date:   Tue, 25 Aug 2020 09:12:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAAss7+o=0zd9JQj+B0Fe1cONCtMJdKkfQuT+Hzx9X9jRigrfZQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/25/20 9:00 AM, Josef wrote:
> Hi,
> 
> I found a bug submitting a server socket poll in io_uring. The file
> descriptor is not really closed when calling close(2), if I bind a new
> socket with the same address & port I'll get an "Already in use" error
> message
> 
> example to reproduce it
> https://gist.github.com/1Jo1/3ace601884b86f7495fd5241190494dc

Not sure this is an actual bug, but depends on how you look at it. Your
poll command has a reference to the file, which means that when you close
it here:

    assert(close(sock_listen_fd1) == 0); 

then that's not the final close. If you move the io_uring_queue_exit()
before that last create_server_socket() it should work, since the poll
will have been canceled (and hence the file closed) at that point.

That said, I don't believe we actually need the file after arming the
poll, so we could potentially close it once we've armed it. That would
make your example work.

-- 
Jens Axboe

