Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01810175DE2
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2020 16:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgCBPI6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Mar 2020 10:08:58 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39127 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbgCBPI6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Mar 2020 10:08:58 -0500
Received: by mail-lf1-f67.google.com with SMTP id n30so8370740lfh.6;
        Mon, 02 Mar 2020 07:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=sfUf1waMQYKph0mACgZyY9wVCX/jwqNxyvaWkVwoqfY=;
        b=sa2zSwuSAKZAU7PqaPC4vxnxtSZXckB1JTWR3UdITGxBXX6cJw0hwGma9voKKWeYpR
         b8CZPncsjhqSY+En+2BMiy+SC3o431Y29TdlBTK97xni0DUgco5Ajwxh3EFHfKQaXJBl
         LkBwLu0a/QF19HGrY7doo1zhAZvOWO0o+lwMEj1k/GwaaqMsK0eN10cyi1d65op0K1yq
         r9joBKkgI/Bf0U/8rydAdKFz6FrLx7RinDwxnfDmF9onV8kB/AyBJd1LQCYCzaafdmOJ
         Ptiz46Mjs+09uIDKOX/ZTgVBf7ip1AtRURe+MFeFT/LYUFmElP9O1a4HbltyGO5tPFul
         C9oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sfUf1waMQYKph0mACgZyY9wVCX/jwqNxyvaWkVwoqfY=;
        b=ftgEl6KMYbadgksKxbZ+itfdzqgTvTL2QW1Becv6zWrfQZbp0s3e2uu7lXMseQ0iiV
         z2FACkZA5dnFaXDN3LHR3N6/mPXR0yw7E/rLd14MWvXu1aOMzSSrgHSzlG6K1q4pJxL8
         5LAvEgg4iYdv1jmMck4+9dde+DPuZTUZbv+6hkR7zxHdG/c6ACxkzBRDANq/k2OOoZLg
         YEtrXCn9B1yXKd0BYgWfAg+q62jIMtt5EF7I6J6DzpYDhTRT9lxkWOEcUwqdunIKdKXp
         8Xn9zs/cQzaqwDhxkAhRPBpJeWKt5SCTwO57Ka+nxtKYVardCvpYZc3QQXRRgDfcFwE4
         Xuqg==
X-Gm-Message-State: ANhLgQ0dJkOzmldL9qpcKbql48LyTA39ZfLZ84QbHj4xsb1P2s3qhiju
        TQ1ed0rxCOdLf0ziNwrDWkeyMVLbOLE=
X-Google-Smtp-Source: ADFU+vsJgs9RmQXV6kOAxM20AZAwdaBWyBkoJh9YrvZ0ip/Nkmc79bnso1cJO6v9VHpFqzjs+7ZUMA==
X-Received: by 2002:ac2:4857:: with SMTP id 23mr11027243lfy.200.1583161735860;
        Mon, 02 Mar 2020 07:08:55 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id s1sm546922ljj.86.2020.03.02.07.08.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 07:08:55 -0800 (PST)
Subject: Re: [PATCH 9/9] io_uring: pass submission ref to async
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1583078091.git.asml.silence@gmail.com>
 <29efa25e63ea86b9b038fff202a5f7423b5482c8.1583078091.git.asml.silence@gmail.com>
 <fb27a289-717c-b911-7981-db72cbc51c26@gmail.com>
Message-ID: <fab1f954-98f0-3576-9142-966982988bc0@gmail.com>
Date:   Mon, 2 Mar 2020 18:08:54 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <fb27a289-717c-b911-7981-db72cbc51c26@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/2/2020 12:39 AM, Pavel Begunkov wrote:
> On 01/03/2020 19:18, Pavel Begunkov wrote:
>> Currenlty, every async work handler accepts a submission reference,
>> which it should put. Also there is a reference grabbed in io_get_work()
>> and dropped in io_put_work(). This patch merge them together.
>>
>> - So, ownership of the submission reference passed to io-wq, and it'll
>> be put in io_put_work().
>> - io_get_put() doesn't take a ref now and so deleted.
>> - async handlers don't put the submission ref anymore.
>> - make cancellation bits of io-wq to call {get,put}_work() handlers
> 
> Hmm, it makes them more like {init,fini}_work() and unbalanced/unpaired. May be
> no a desirable thing.

Any objections against replacing {get,put}_work() with
io_finilise_work()? It will be called once and only once, and a work
must not go away until it happened. It will be enough for now, but not
sure whether you have some plans for this get/put pinning.

-- 
Pavel Begunkov
