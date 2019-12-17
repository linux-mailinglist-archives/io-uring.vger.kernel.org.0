Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5A1123474
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 19:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbfLQSJY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 13:09:24 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:42923 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727858AbfLQSJY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 13:09:24 -0500
Received: by mail-il1-f193.google.com with SMTP id a6so9128402ili.9
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 10:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=0QP0bNN7yAk9S0VSL+bDYhT11IE+1HUbY9Rj0py1yCE=;
        b=p2BA0wU8M/ya6yrzSkxIH8TVd9h1XiBbINW+Huy2NFmyXElYd9Ia1D/NubOVDh1Kdv
         MQzNQ1pcGc/s/T/a7H34WnfNU2OrpHngWKY5K9JDXNLtRN4CAUShGQaEV7HcucxfZULJ
         /Xl+9X8Ms4lkoXXdnCQzfeJ8egxbdxgGEdSjWeOoLpK1eGfIYcpqvSMmjgbmn8Jxo5o3
         HaHSNhhqNux4rLEzbvbyR4vk24bgbdRH9nKQzCyc4DNMp1bQ6q/k0x54f18ToB0NBDEz
         WawJBKQIfVG9/FX+P/7OGGqeqPIBXEJ7vjTeup8usTBfs4khn6gdldLVwQPQaQ7vYtLs
         qpOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0QP0bNN7yAk9S0VSL+bDYhT11IE+1HUbY9Rj0py1yCE=;
        b=Zf1jjseXzwlrMBQYj8OYfzmZdSMKXvDArCU2iuL9n3rtG0NAwVK4Rsz96/fUkMP/x4
         TTs7+3G/e8puSVm5zQmQUU3tgAKNAkM3L+YvS0TXyrC2yXDAUMA2UkAI3Nl0JcYVaQdL
         K1UDephbqM7RDQFf7xFdBOEchO/+ukSG2WdMZ7xTZqz1hg4FifpJSPIzEPqrdBIBwf3b
         2YCVg5ZCDQ3QvRs8wnrvLn5fnaukxBWAjJhw0PsNl+2ETO6eOd63vSgskPpLamkKoHWl
         Cm06trwGDmK/LNLsNqyOSt8wqoLyT9Sus/Dj6XLiva3EmU/jjLGVSGhZ5WGFvkgECjYb
         RRVA==
X-Gm-Message-State: APjAAAXBGSmcCy3A7hIPKrQ+5ZSFo/2s4vbRFYMbSsVkgDuILKOqG8mx
        vBiHpkrjg+L0f7ZL7W/KqS8F/Q==
X-Google-Smtp-Source: APXvYqzygSEbeuLKhJwgREmiPZE43+M37DDkao0wUrn9tOxKO0Bs/tSa8+mexekGEomP2+Y30lr4fg==
X-Received: by 2002:a92:d3c6:: with SMTP id c6mr18655191ilh.228.1576606163657;
        Tue, 17 Dec 2019 10:09:23 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g62sm2809294ile.39.2019.12.17.10.09.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 10:09:23 -0800 (PST)
Subject: Re: [PATCH for-5.5] io_uring: make HARDLINK imply LINK
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1576605351.git.asml.silence@gmail.com>
 <4d08ae851e48c030b726e00def4451466475b7e9.1576605351.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <30c12b37-997c-6625-50a1-1ed0e8bad2f9@kernel.dk>
Date:   Tue, 17 Dec 2019 11:09:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <4d08ae851e48c030b726e00def4451466475b7e9.1576605351.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/17/19 10:57 AM, Pavel Begunkov wrote:
> The rules are as follows, if IOSQE_IO_HARDLINK is specified, then it's a
> link and there is no need in IOSQE_IO_LINK, though it could be there.
> Add proper check.

Applied, thanks.

-- 
Jens Axboe

