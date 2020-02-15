Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 686DA15FEEB
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2020 16:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbgBOPLH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Feb 2020 10:11:07 -0500
Received: from mail-pj1-f53.google.com ([209.85.216.53]:53515 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgBOPLH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Feb 2020 10:11:07 -0500
Received: by mail-pj1-f53.google.com with SMTP id n96so5291473pjc.3
        for <io-uring@vger.kernel.org>; Sat, 15 Feb 2020 07:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4Jxb1UpfzlD6F3odi0TQX/DW9qRQlAcKGJRT1a7Lhv0=;
        b=fEsC37jSQcaPVN8NkDNptFGey8TyJdecvFNCTT6F1UyWb6MGvY2dvbXa6q191UJmgj
         2MdrfYDdQxsQVsC7yorzzmKMx7Y3cXOpVcszVQRyD01LuFRgOGf6R8a4Y48ee3xJeBzL
         B6C6DfdZd/LUQS31MYUWA4RzUWLQavMwByjmy7AQ97jwgicp2texa7kzvpMwPu+BGFM2
         D+fg5PEcOzBjiC5tvFwCyVwuiABCk4nOA3HH+Ri8H9Nr0o3kYaLS5uAakq6Izk0yeCzB
         W5/F+TZpcsH43EmXDLmMhtHBBS8FSUBMTMjC231mh1QaWbV1r3xC5zRtOp3i0XSiq8Yb
         bBZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4Jxb1UpfzlD6F3odi0TQX/DW9qRQlAcKGJRT1a7Lhv0=;
        b=oKQIhA4l58lyC01UXqFjrpjl6ZgFmDK4ZWSVdGwGyl6g2UyO2LPvbeIZZzL9c3eRKr
         HKFwIU/WB8XzFEPJjq/llhAEyu5AdummuZHQ/F9Pb0ziuf0FXX7yO7cdb7q1g/RFiZzG
         rNy3KcHwDFgfseoSIznfv1h7wHyJToH0t4azQY+s2VaYlm2Kn4YW59pqSL4zRRRrxSjz
         3fBC0vb90srY+PuP8mI/e3FlbB6eboBV70GYYY5f3+53MbQ/081mED/lxWks5VEpJXyx
         /Gk6Pd7f+dQlO+IwrFicH/Mei/VnswDkGu7kr5NPB1Pe/7+Iw1YN42mMW7XdpgTRYGGJ
         /VJQ==
X-Gm-Message-State: APjAAAWemuyOVVmLchT67/CJN3GU5X8awNZiqeTOeBX8acbuwBDgxR6R
        AadzwzOmVuOTY/YzL+2KQiNOnnVlynA=
X-Google-Smtp-Source: APXvYqyo8MPjMyqxTlP3GOQFPc06rSY4fNxJvrWDbOFsLY9Yi+o43ZKune0dab79QnNalymCEEKL/w==
X-Received: by 2002:a17:902:204:: with SMTP id 4mr8600697plc.266.1581779466341;
        Sat, 15 Feb 2020 07:11:06 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id w14sm11062100pgi.22.2020.02.15.07.11.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Feb 2020 07:11:05 -0800 (PST)
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
To:     =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <9FEF0D34-A012-4505-AA4E-FF97CC302A33@eoitek.com>
 <ADF462D7-A381-4314-8931-DDB0A2C18761@eoitek.com>
 <9a8e4c8a-f8b2-900d-92b6-cc69b6adf324@gmail.com>
 <5f09d89a-0c6d-47c2-465c-993af0c7ae71@kernel.dk>
 <7E66D70C-BE4E-4236-A49B-9843F66EA322@eoitek.com>
 <671A3FE3-FA12-43D8-ADF0-D1DB463B053F@eoitek.com>
 <217eda7b-3742-a50b-7d6a-c1294a85c8e0@kernel.dk>
 <1b9a7390-7539-a8bc-d437-493253b13d77@kernel.dk>
 <20200214153218.GM14914@hirez.programming.kicks-ass.net>
 <5995f84e-8a6c-e774-6bb5-5b9b87a9cd3c@kernel.dk>
 <7c4c3996-4886-eb58-cdee-fe0951907ab5@kernel.dk>
 <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
 <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
 <FA1CECBA-FBFE-4228-BA5C-1B8A4A2B3534@eoitek.com>
 <f1610a65-0bf9-8134-3e8d-72cccd2f5468@kernel.dk>
 <72423161-38EF-49D1-8229-18C328AB5DA1@eoitek.com>
 <3124507b-3458-48da-27e0-abeefcd9eb08@kernel.dk>
 <5cba3020-7d99-56b0-8927-f679118c90e9@kernel.dk>
 <2DA8FE8A-220F-4741-829E-24D0F9EF906B@eoitek.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a079a1c4-c1b4-437d-cfdc-c8c17a12ab72@kernel.dk>
Date:   Sat, 15 Feb 2020 08:11:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <2DA8FE8A-220F-4741-829E-24D0F9EF906B@eoitek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/14/20 11:32 PM, Carter Li 李通洲 wrote:
> Really appreciate it! Looking forward to getting it merged into mainline!

I'm very excited about it too, I'll keep hammering on it to flesh it
out. I'll only be sporadically available next week though, but we'll
see how it turns out.

> By the way, what time is it now in your city? ;-)

It was 11PM when that went out, could be worse :-)

-- 
Jens Axboe

