Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEBCF1655DE
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 04:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbgBTDxJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Feb 2020 22:53:09 -0500
Received: from mail-pl1-f177.google.com ([209.85.214.177]:35821 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727370AbgBTDxJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Feb 2020 22:53:09 -0500
Received: by mail-pl1-f177.google.com with SMTP id g6so1001455plt.2
        for <io-uring@vger.kernel.org>; Wed, 19 Feb 2020 19:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l+m1QqZLp0jnVcmSXEkIZ6vSbIUvZ5AOqDjjrXzqTM0=;
        b=19p4UK5kcWU8ZZmbXym+Zwtmf6n7nziVg9dXRY6IQrJycoSx5vWmCp034L+eGqOEMI
         YSXVIeIZceYm8IC3/js1Ad/WVqj2KOMP7ap88wxdgR49iWi+KxWOvwM+1EBcwsHJRwB0
         V+ngrOhkl6KFziObxwKOR2Vo27IS/Km08Fe1D4+mPhloiLwJxrjkPwjf6kIvH/9JEi6o
         Ayp1ZFuxAmQcAYtGq+yRLw5PBO3m6P1LP1T21uuGsdifCxvhgReFbdqjuteMO9yuDdJq
         0XjqaJaaUvCzS8TL53Hr52crzWSccfNFghVmjJNYIZegpAXX0LsZ3K/eD8pIntQZLYIu
         kuUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l+m1QqZLp0jnVcmSXEkIZ6vSbIUvZ5AOqDjjrXzqTM0=;
        b=UpwRmF0Zeyrk2wFDsHOvid1P6zIAMglCQAZ5F4W19G58q8gxkOOpqFKzQpJ227WAvq
         Opv3N46aITp2J7pot8cFoRITmTK/m8hnEpGGFuFAGB+jcwXW1hAWGXf31dnffFg4mZOJ
         jHVZbepg5ryoWgZITOJeXr4Ecno/QsPujwGWRLc/JoHCTuEGFT5Hx6tfe8EwfgTXTFIR
         Oj/+Jsq1w9RWCUNuS4FX/TgM0f6BgOafMHrJO4P5i8Lfpjf5nWao8BDfQVzcBAKh62Lf
         OSh2SwtbJWfDO8CWmVCzqwV+Xe1u99mWy2BcgvPJY3Lh0E2Ir9S42T/61BMg8Rt70+x2
         Xe5A==
X-Gm-Message-State: APjAAAVrKqE4ODt8OzohUrY30kkFXmUCv9I7FLlMz65GkLn1dTjxAdRW
        xo/hpt2PsHf0CSYsXWid8PbTI9LBAVY=
X-Google-Smtp-Source: APXvYqwOKugkLNrX/s/GctAr0LATf/VxPqORceZekzbw6JOaJ/rAhrgpfz716OkrzynyQ6UmTEXlnA==
X-Received: by 2002:a17:90a:5d85:: with SMTP id t5mr1213825pji.126.1582170787791;
        Wed, 19 Feb 2020 19:53:07 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:54cb:52c5:6d91:1922? ([2605:e000:100e:8c61:54cb:52c5:6d91:1922])
        by smtp.gmail.com with ESMTPSA id g19sm1104636pfh.134.2020.02.19.19.53.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2020 19:53:07 -0800 (PST)
Subject: Re: crash on accept
To:     Glauber Costa <glauber@scylladb.com>
Cc:     Avi Kivity <avi@scylladb.com>, io-uring@vger.kernel.org
References: <CAD-J=zZnmnjgC9Epd5muON2dx6reCzYMzJBD=jFekxB9mgp6GA@mail.gmail.com>
 <ec98e47f-a08f-59ba-d878-60b8cd787a1f@kernel.dk>
 <CAD-J=zbm3a4nYvUo83UL706nhOicRC8LUh=iphWwL6inAa37RA@mail.gmail.com>
 <f74646a0-72a2-a14c-f6fd-8be4c8d87894@kernel.dk>
 <CAD-J=zb2Y_U3W6=8RUfX_zSP7YbdYLxFY0UDcmCqKRH8Jin4bQ@mail.gmail.com>
 <fba5b599-3e07-5e35-3d44-3018be19309f@scylladb.com>
 <20ab3016-9964-9811-c5b9-be848f072764@kernel.dk>
 <3e5c6df3-c4ab-1cd5-5bb1-e1a5d44180ad@kernel.dk>
 <CAD-J=zYcT6VSGhu81e=UJ3SrjfuPJLF9qB5T176OhZjfEpS26g@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <923b26bd-4f1d-3fa7-8578-b35a63ba2a59@kernel.dk>
Date:   Wed, 19 Feb 2020 19:53:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAD-J=zYcT6VSGhu81e=UJ3SrjfuPJLF9qB5T176OhZjfEpS26g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/19/20 7:52 PM, Glauber Costa wrote:
> I don't see a crash now, thanks.

Updated again, should be more solid now. Just in case you run into
issues.

> I can now go back to trying to figure out why the test is just hanging
> forever, as I was doing earlier =)
> (99.9% I broke something with the last rework).
> 
> Out of curiosity, as it may help me with the above: I notice you
> didn't add a patch on top, but rather rebased the tree.

Yeah, the poll based async bits are very much a work in progress,
and I'll just fold fixes for now.

> What was the problem leading to the crash ?

It had to do with repeated retry. Eg we want to read from something,
we try and get -EAGAIN. Arm the poll handler, poll results says we're
good to go. Retry, get -EAGAIN again. Now we give up, but the state
wasn't restored properly.

-- 
Jens Axboe

