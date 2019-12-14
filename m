Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8337E11F20C
	for <lists+io-uring@lfdr.de>; Sat, 14 Dec 2019 15:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbfLNOjR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 Dec 2019 09:39:17 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:39316 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbfLNOjR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 Dec 2019 09:39:17 -0500
Received: by mail-pj1-f67.google.com with SMTP id v93so992415pjb.6
        for <io-uring@vger.kernel.org>; Sat, 14 Dec 2019 06:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=IoBeQA2HlCS9XPEARFkefgYwffEfLh2rpYLRA+Zxnps=;
        b=GE3mP84bz9qJ1PbcGkHSWzDJUvu1LnnOmh0qGPofwkkHMu6viBA7LKUy7ZircRs1ua
         gHYE/tXgDv4mwdGVSAovrT5UzAB1jIa6GmlDc2YovUB8g1GzZ/l0MtXNedMXxhBaRA8r
         /+y6sd9VNaknBBBDU3yhwQYSi1wcyw/T9GyWzrjthejCngdqfY7eXKu55kWCW6mkMhYz
         z0anFk/j3KXsrozEvoWJvlACAxCXErhwQraqSkJ/jEvgtGk4TXkbYVdxXwiHG2LJBvsl
         cy6WXWHbDlygkWDYyoDmBXxR+ggzTzUXCYhkkNfKaJvZZAolWthExZjHRECamC1LqQoX
         Itdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IoBeQA2HlCS9XPEARFkefgYwffEfLh2rpYLRA+Zxnps=;
        b=nM7dYmOWbzSugQ/kf9vA6q5XDQiTzozLgoRDFIiGkET/cqzNM1Ryjbr2PzWwh+xfnt
         44tyZiHUvXA6d4RpxUfoqe9rxkwUn+9hvJrCnMOYtMj/k3tFqlyJKhuqcCnDWZDirKBN
         Ch8BZFawr+lMF/09EToiApZrAwnaKR0ssAJWRvRj06yE0SXK0d2OhsMGHKkdT0bs5Es1
         OCmwWc1XkC0kUt6WybuB9OWmkjuwJ6cCBj2y50gP39Yzw3hHHD1opA17mIzQV9Twge4K
         rxBOoGKeD/8zlbxxmn9aUZZ9DO+/u7p50DBjrlGdpgVtp/HXrwtlC3y1HeibMhCLVK49
         TiSg==
X-Gm-Message-State: APjAAAXKISAWxshxY4rKkJehi03xUH6yjzFkXgvp820OStup/WbtPzD4
        qWfMRGBHIjsEYCGspR8R2gJDxw==
X-Google-Smtp-Source: APXvYqxGx5rkFXq/E1fSuSmmI1/Qmuwn5UJ1p91vjxHKdMebmKLf0SeawkfgmEDLlX184JTBsPtGeQ==
X-Received: by 2002:a17:902:830b:: with SMTP id bd11mr5185121plb.317.1576334356517;
        Sat, 14 Dec 2019 06:39:16 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id q6sm16416468pfq.27.2019.12.14.06.39.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Dec 2019 06:39:15 -0800 (PST)
Subject: Re: [PATCH v2] io_uring: don't wait when under-submitting
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <5caa38be87f069eb4cc921d58ee1a98ff5d53978.1576223348.git.asml.silence@gmail.com>
 <6256169d519f72fe592e70be47a04aa0e9c3b9a1.1576333754.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <55f01a72-fcbc-a3e4-d9db-7dd2a7ef1acd@kernel.dk>
Date:   Sat, 14 Dec 2019 07:39:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <6256169d519f72fe592e70be47a04aa0e9c3b9a1.1576333754.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/14/19 7:31 AM, Pavel Begunkov wrote:
> There is no reliable way to submit and wait in a single syscall, as
> io_submit_sqes() may under-consume sqes (in case of an early error).
> Then it will wait for not-yet-submitted requests, deadlocking the user
> in most cases.
> 
> Don't wait/poll if can't submit all sqes, and return -EAGAIN
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> 
> v2: cap min_complete if submitted partially (Jens Axboe)

Can you update the commit message as well, doesn't really reflect the
current state of it... Apart from that, looks good to me!

-- 
Jens Axboe

