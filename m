Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 739821567A9
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2020 21:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgBHUPX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 8 Feb 2020 15:15:23 -0500
Received: from mail-pl1-f171.google.com ([209.85.214.171]:45840 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727478AbgBHUPX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 8 Feb 2020 15:15:23 -0500
Received: by mail-pl1-f171.google.com with SMTP id b22so1153336pls.12
        for <io-uring@vger.kernel.org>; Sat, 08 Feb 2020 12:15:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=QWTprz7MJDSuhV/nNtMPbf814NLnHAq1OY6NLW3mXrk=;
        b=vNx2Q4ECsF7hLLYbd2WA/AjwSMFhw7YJ2os6t+2WgnQuIwrCrsDoR08rFTaUCHHy52
         5XSuzhUWur7oYUcCEfz+5t26L+iB1Jueo1prWiYTMfyqC2qiwQ3I/M0vvnnbm6vYCCMW
         8dRj4WLh4CjX639APusaUTG+FgNVWNasZkIY07rQVXAx8sBHyh2SAFqOyPl1+3IBZZNa
         +RKStlwr41adlkP4sAAkkcXoVXULQSFheLS6ibqwU6dXoNWjwud6S/DtmlYdLnm+tf7A
         vdRV/xVDNafAIY2wZWuLLQlgTeYfhLEShO+wPiPnVKXG37Fzvx0tL49nLIGpVGSOTrrD
         BQnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QWTprz7MJDSuhV/nNtMPbf814NLnHAq1OY6NLW3mXrk=;
        b=lng0Wy8kerUyU4CTT0x9qMR7I0jLztcYsW6iPEPPeGNv7+S/bBc3ZedPiToJPbtuxt
         5hy870V3BTnUIYQZQL5aJlULY0NoCK3eNPrILIWExFxAfuRm4d/wdHpHkTyXRqopJxuj
         boqNiKnG2YdjgVC1s6OGXuNYV2whO39tiLs7Dtk431voUqr3puHiuUC9rIKTvPLsnR3i
         XwgnHvE6vCsnfTQAgTnTkmRWeFH7FiVvj3QLUbW+eYpzJLp3Xe3tfRx1PnyqxDotpgAw
         Nowe+wCoS9Hil2nxnPfDT6bB2I0SeQC5zUKwLpdVIcW9Yy8PyXiAvj3z+wvOlSU/SmlJ
         Gv0Q==
X-Gm-Message-State: APjAAAVgoZGk/rw/fBBlgHjxLf9qFRtT/ptCOJK9ch/8rZEYI/7nLBPi
        ObB10b24tm1tak4pSfgFopieuACsKAw=
X-Google-Smtp-Source: APXvYqwRey0JfKJ7srgBZVpviXIRsaOjU0U80c+KOAd/F5XYnSNXGCP+17aB+dy66wqMyzcbjAVBCw==
X-Received: by 2002:a17:90a:2808:: with SMTP id e8mr11800242pjd.63.1581192921236;
        Sat, 08 Feb 2020 12:15:21 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id 26sm6905595pjk.3.2020.02.08.12.15.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Feb 2020 12:15:20 -0800 (PST)
Subject: Re: [RFC] fixed files
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <ace72a3f-0c25-5d53-9756-32bbdc77c844@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ea5059d0-a825-e6e7-ca06-c4cc43a38cf4@kernel.dk>
Date:   Sat, 8 Feb 2020 13:15:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <ace72a3f-0c25-5d53-9756-32bbdc77c844@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/8/20 6:28 AM, Pavel Begunkov wrote:
> Hi,
> 
> As you remember, splice(2) needs two fds, and it's a bit of a pain
> finding a place for the second REQ_F_FIXED_FILE flag. So, I was
> thinking, can we use the last (i.e. sign) bit to mark an fd as fixed? A
> lot of userspace programs consider any negative result of open() as an
> error, so it's more or less safe to reuse it.
> 
> e.g.
> fill_sqe(fd) // is not fixed
> fill_sqe(buf_idx | LAST_BIT) // fixed file

Right now we only support 1024 fixed buffers anyway, so we do have some
space there. If we steal a bit, it'll still allow us to expand to 32K of
fixed buffers in the future.

It's a bit iffy, but like you, I don't immediately see a better way to
do this that doesn't include stealing an IOSQE bit or adding a special
splice flag for it. Might still prefer the latter, to be honest...

-- 
Jens Axboe

