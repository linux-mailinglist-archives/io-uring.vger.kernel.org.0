Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6427A174973
	for <lists+io-uring@lfdr.de>; Sat, 29 Feb 2020 21:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbgB2Uzs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Feb 2020 15:55:48 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:51968 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbgB2Uzs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Feb 2020 15:55:48 -0500
Received: by mail-pj1-f65.google.com with SMTP id fa20so2744787pjb.1
        for <io-uring@vger.kernel.org>; Sat, 29 Feb 2020 12:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=LfAey+bVZC63MZcRaKrf1wf+n/7HqfzMlziFP/uZ5DA=;
        b=ClhsKX9DW5hTIMiI6HHZ0GUWCxU6QbmOxwbUME6SC+2H4MgVlbEAMmNzWoVHCxtZz4
         jODg4Y20/kt8t5Hi9NP9dV8oxmZ2Grr06rBhEjhVTLCofOWwzlM35aosLDpdH9p0TRrz
         6y2ZA41P832B+JG3r42ZaWntowDOl24cID7FT913bB+SVyj+BbKUgJ+BGzUC0cPibOb0
         Fe60zjQFVT9K3JoX6WnKmFcQXwGtRsM8IgIXy8FOHwuaWTp06Ai01R9BScmI2EfR3InQ
         EK3K2M6kE9dTDpLZj3jvEScnQimKWv1kHMOimtSd/wFbmHFBsKjBTghpKnbJDLCx2QMg
         sZ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LfAey+bVZC63MZcRaKrf1wf+n/7HqfzMlziFP/uZ5DA=;
        b=AMPL9LDNnp2N3GkqNg1Ri0ePrD11YQjTnBJpY+squ8GKQyNMu9TXloQDouiy8jq15X
         N/7c1jMIyFDKYk99biSDe3qolCQLEzGpcAVWxHhZ7345TLNlQr3P40mIBUBNSl8eZAdW
         KoJ9ZnrVkUw6Q8ZSd614CPcShuuraav0l6s4eHyzFZNS01e1kum+SbuZtvK+HevSwIFz
         8ydfMRQe4FnA0nIA8LZxqKtIQjwBRh5KGeOMSKbQ3xdCMdyj8AD3UIk8+OXkSM+8dUTZ
         6cUDu0ab4PB+XbYkrCsSN2/oVQBzlCTs+heBZEnM/dDaaTc8WMRMP6GD3RgcHvuIHQ3W
         lw7w==
X-Gm-Message-State: APjAAAVaFfWFi4fzDDE4BHqgCwL1H5QcFuNtsy3Tm68G7qrXTbGHx/Dn
        I+Y6ol9LNE97nkbLS5OeTyvIBg==
X-Google-Smtp-Source: APXvYqwOVZngKIRetVCWvncT1J21YRIi0aP5gheYzkQNimZI2jAECzbYCrcgakD8LcCfMLaRbWsjuw==
X-Received: by 2002:a17:90a:9ee:: with SMTP id 101mr11994638pjo.74.1583009745793;
        Sat, 29 Feb 2020 12:55:45 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id x4sm10554330pgi.76.2020.02.29.12.55.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Feb 2020 12:55:45 -0800 (PST)
Subject: Re: [PATCH 1/1] io_uring: remove extra nxt check after punt
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <29e9f945f8aa6646186065469ba00c0a4ef5b210.1583005578.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <08e7732a-4a31-424f-ec3f-eba4d753456a@kernel.dk>
Date:   Sat, 29 Feb 2020 13:55:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <29e9f945f8aa6646186065469ba00c0a4ef5b210.1583005578.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/29/20 12:48 PM, Pavel Begunkov wrote:
> After __io_queue_sqe() ended up in io_queue_async_work(), it's already
> known that there is no @nxt req, so skip the check and return from the
> function.
> 
> Also, @nxt initialisation now can be done just before
> io_put_req_find_next(), as there is no jumping until it's checked.

Applied, thanks.

-- 
Jens Axboe

