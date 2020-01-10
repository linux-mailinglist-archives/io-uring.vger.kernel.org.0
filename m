Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 263B91377F1
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2020 21:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgAJUcQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jan 2020 15:32:16 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:37124 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbgAJUcQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jan 2020 15:32:16 -0500
Received: by mail-io1-f68.google.com with SMTP id k24so3461304ioc.4
        for <io-uring@vger.kernel.org>; Fri, 10 Jan 2020 12:32:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qEC7yVfgKuYy2kpMZheE6vrn93L8OuQRkXeMaIIjYlg=;
        b=0i6BCuDshs5SPqsuOtebS5iwpamV6T9il774mFWHK0YzpnqpYPqNF6QbbVYCZCgxul
         Brft2Ojiqoil6OzconwsEk3VKw3VQZIv8TSjtGEjnMyHoWNcVWvbzP8gKWUola6HVPtr
         ZgIV752OTU4uXm8XnG/vDkz8vTYcRMoS68MaP0zAII+T1z/UqjDt92YBSjUsRFTdzrjA
         QAKErIOIUzz5w3a4S9eUhE4Ku84PVTDaHxw+9FP24UECA2Ay9Tdwy1wehpRNTOXL8CTB
         NzcbIpdC9PjOoCGAiu2++6HxN3Q9Szs+ic2f+vNvzEq6ONlLfp3e7s5fT3LBxO8pdMxI
         ptpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qEC7yVfgKuYy2kpMZheE6vrn93L8OuQRkXeMaIIjYlg=;
        b=PDhNf3eLMLUSpw/HtFPrGqRUbMFWLN1nJIQm2ATndyPE2bh7uAQ3TIvDfnGDlznxFM
         qZVuMdxDeQLhI7QpU94fQd0KXYEr5TmDP86fdtyzJ9nuD7yneduqeCg/1tUH4byd7gl5
         KyhWuEPsHQxgvP2fDs6rGBmBAp0jJaZJ8sfZEEDq23WiM/h/ucKG1+Uki/yK/GOwDAyY
         pMx14bIoJ/PbN1f43ZKckNSDTC80V8t8ORTYUQTMzBuSjZI5+SUNdwb3JvLVuABXOjJv
         GxBaf0Wsb/JoHamKl6Gl6U1JFK9N/4CC/kp03Yi9urC9Bny7HFk62pradbltBqUoLyxB
         y49A==
X-Gm-Message-State: APjAAAWSSAlcY+5WxmM0X+QcG1DbF9Fwg3wW9EYRB7TWsjZxuzqLrTQf
        GuF8QxN26RfYOa9yl9oTelaCjumfvug=
X-Google-Smtp-Source: APXvYqwcwD6a/NsIX+wybYf12vK3HC4ylPSHDcOgUU3P4r+tWbRKCxXbHsiTXmpRuK+HdVb8fGN32g==
X-Received: by 2002:a5e:da42:: with SMTP id o2mr3926426iop.125.1578688335178;
        Fri, 10 Jan 2020 12:32:15 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a12sm793295ion.73.2020.01.10.12.32.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2020 12:32:14 -0800 (PST)
Subject: Re: [GIT PULL] io_uring fix for 5.5-rc
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <4f9e9ba4-4963-52d3-7598-b406b3a4ed35@kernel.dk>
 <CAHk-=wgLX0Axk+3Gd6YeRcXkW6GHOk0_CSpp3fJGgmmbN8_BMA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5b093882-16dd-0bcb-79b6-0f37be77a03c@kernel.dk>
Date:   Fri, 10 Jan 2020 13:32:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAHk-=wgLX0Axk+3Gd6YeRcXkW6GHOk0_CSpp3fJGgmmbN8_BMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/10/20 1:26 PM, Linus Torvalds wrote:
> On Fri, Jan 10, 2020 at 10:07 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Single fix for this series, fixing a regression with the short read
>> handling. This just removes it, as it cannot safely be done for all
>> cases.
> 
> Hmm. The io_uring list is apparently not on lore. So you don't get
> pr-tracker-bot responses.
> 
> Maybe add lkml to the cc for pull requests unconditionally?

Yeah I think I'll do that - I did ask Konstantin to add it, but
apparently he's not adding new lists, but rather working on something
that'll track all of them.

In any case, I've sent the io_uring one with others that are tracked
every time, so my logic has been:

- If I get a pr tracker response on one of the other ones, AND no Linus
  complaints on the io_uring pull, then I know it's in.

That's had a 100% success rate so far ;-)

-- 
Jens Axboe

