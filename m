Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAAC314F92E
	for <lists+io-uring@lfdr.de>; Sat,  1 Feb 2020 18:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgBARjr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 Feb 2020 12:39:47 -0500
Received: from mail-pl1-f172.google.com ([209.85.214.172]:44752 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbgBARjr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 Feb 2020 12:39:47 -0500
Received: by mail-pl1-f172.google.com with SMTP id d9so4091853plo.11
        for <io-uring@vger.kernel.org>; Sat, 01 Feb 2020 09:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=6cgtgmkf7ztW77dSJYzXRSkiP8w6Ro/AFu2uTuQLEh4=;
        b=o62l2kIpvUHI3QKlnTpIDUIJgVPXXQvfV1tQA6QkKjaJhvfOXFNBuMW04JVAiQb/hl
         dzAoUl88X+6Sw9UgNFCXE7vslYWHyyn65ib5SIHdlNBgdaQ+WPTU7bRola8saIisRhRG
         Mt3jsUNoo7GWnMgGfc/gv4EWWP6CQo7rb2Q2O5dOO/i+vgSfVZWoTCYxPodVwlyopOqa
         Zu2oR85vByYnq6WPuNI7O6zV3V39NQpb+iV9WSKmyPcI6wY3lyL0WYVCn6VFQUpaVF4a
         b0ziUnni85NJdUZPPfQxLl/IjrwiAnLBAEhCnEGNoO/ehujIQwityTOKLIgP9t2/qDAw
         Ah2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6cgtgmkf7ztW77dSJYzXRSkiP8w6Ro/AFu2uTuQLEh4=;
        b=mJylp8Q42G1B6Y57ROza7Kt8OqhDe9eM5thaWY6iFFfDGiLgPxSqSH/q4j6Qd/dyID
         CqPLAwXVJRecagF88alopQ/M6Cfpo0Bs2chv44XpZcWjLv1Xsu48bxKVwt3VlvqfJ9k6
         6xZRhic/KjyuwxM6A3rS08LCMqe8yy0H3oR3+egfOkqwNiPezmw4TWvVJGWdJ8P5JxZt
         QviZzIa0FGxv4OhwDAwl2RNj59bztbvX538hiMm3MmbRPxDjY45FoxcFGlubvwEBgeuF
         WtNrv9A+Op4JRkfLkXHsjUIuAxOvFdEWexE2Rs3BbVQjz/j2StrBG10vkLWcvkNOo/p4
         R3XQ==
X-Gm-Message-State: APjAAAWF7EUkomLyxZ+1zKhdPHk5n/GJJMXw8vdaTA/MTQIC7Iv93+2f
        RiuBi0BE4jX0zu33WrOgd7kQyvQ+zKE=
X-Google-Smtp-Source: APXvYqzU8raLe2s3+q7NtiZLlKa3ZrPYr9e/Pd7Su4xCpkvnjjKoTnL3N05tVl14izNHtEZa29MZ9Q==
X-Received: by 2002:a17:90a:cf07:: with SMTP id h7mr19129825pju.66.1580578784512;
        Sat, 01 Feb 2020 09:39:44 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id z64sm14846672pfz.23.2020.02.01.09.39.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2020 09:39:44 -0800 (PST)
Subject: Re: liburing: expose syscalls?
To:     Andres Freund <andres@anarazel.de>, io-uring@vger.kernel.org
References: <20200201125350.vkkhezidm6ka6ux5@alap3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ed2fd00f-b300-6d9d-a6d5-f76bbc26435a@kernel.dk>
Date:   Sat, 1 Feb 2020 10:39:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200201125350.vkkhezidm6ka6ux5@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/1/20 5:53 AM, Andres Freund wrote:
> Hi,
> 
> As long as the syscalls aren't exposed by glibc it'd be useful - at
> least for me - to have liburing expose the syscalls without really going
> through liburing facilities...
> 
> Right now I'm e.g. using a "raw" io_uring_enter(IORING_ENTER_GETEVENTS)
> to be able to have multiple processes safely wait for events on the same
> uring, without needing to hold the lock [1] protecting the ring [2].  It's
> probably a good idea to add a liburing function to be able to do so, but
> I'd guess there are going to continue to be cases like that. In a bit
> of time it seems likely that at least open source users of uring that
> are included in databases, have to work against multiple versions of
> liburing (as usually embedding libs is not allowed), and sometimes that
> is easier if one can backfill a function or two if necessary.
> 
> That syscall should probably be under a name that won't conflict with
> eventual glibc implementation of the syscall.
> 
> Obviously I can just do the syscall() etc myself, but it seems
> unnecessary to have a separate copy of the ifdefs for syscall numbers
> etc.
> 
> What do you think?

Not sure what I'm missing here, but liburing already has
__sys_io_uring_enter() for this purpose, and ditto for the register
and setup functions?

-- 
Jens Axboe

