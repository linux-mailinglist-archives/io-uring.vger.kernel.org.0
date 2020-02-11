Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE63159A87
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 21:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgBKUaM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Feb 2020 15:30:12 -0500
Received: from mail-io1-f54.google.com ([209.85.166.54]:37939 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728019AbgBKUaM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Feb 2020 15:30:12 -0500
Received: by mail-io1-f54.google.com with SMTP id s24so13330464iog.5
        for <io-uring@vger.kernel.org>; Tue, 11 Feb 2020 12:30:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=CWMaLhpkMmlGi2spnbl35WMjZJdbK+TU4yMP85HusPE=;
        b=ewmruG+wji2/6EjpGag74fvvshZJnwWSz8cF6UHfpFGFvIAuNrrrQDV7tpKY/JRnG5
         fT9rkyVVjKitWbfE4dOUc29+Jv2nZZ1928IDRaFg8iOiDzxiznt+BjZR6cB9aflehAz9
         S5oUYRXbnKs6Mr+F5oXsvjgPN1O7akr5ux4JMD7ZKm7jYkC7AyNfHX4jDUGSxiUqO3px
         N6E8xl73tZkqYiDYKFlxxzkJbFj2GzuT7/ZZB60ioLTK9bSU+Cx5pcr8v91uoqIjuYNF
         GE8lkYGBhjc1qkjQDN1Jpdi4w5a6mu8/Bg1bQFcY5TQy2DHqEje9xCgH+a/i68Dik3Nh
         YHIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CWMaLhpkMmlGi2spnbl35WMjZJdbK+TU4yMP85HusPE=;
        b=YUdZP9g+xeM6WV2gdjRxmy0fmllTptYvCIlT1mQyRoqjMnWum5h65zs0liTyjuJwiB
         3QGlfc/cLJXPyXED6kERgE8JpU9RmRpxXOlji4d4Du6tcQoz7uL5Bx57j20b7AlWTy5d
         IHPAYmJkO0clb54O5nNqoF3pB2+MGGXTulU+cbvcRFB7fGhaYQBEQpSXKJQG4+OekMrn
         waS37EThpvK7YHDhvEcswZkZ/QTPk1DVpCHpnD2e9DpKMYKRmdtFmuySfTF5KWjPIPtI
         RxEnFAlOMn2M8PJbcso8ooBrQtoBPEUyf6QadI6SFaKvWVxjaC8rDxG5gUa6cVzsvmML
         PiOw==
X-Gm-Message-State: APjAAAVNWZQPQphCUT5/BzuJBZ5KJasuZ8B0ibD9Hj+jvf89wf+Pxqr2
        QyEbabInLm7xagsHAV5/j2pr6+vg47o=
X-Google-Smtp-Source: APXvYqwpUfNgAWtdByaTbEjGKjSodENHbyC+41Wjt7B0/0DilNOKL8A+B3AhoZPBCqGkv9GYp7QmJg==
X-Received: by 2002:a02:cd12:: with SMTP id g18mr16047967jaq.76.1581453011533;
        Tue, 11 Feb 2020 12:30:11 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d7sm1267599iof.14.2020.02.11.12.30.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 12:30:11 -0800 (PST)
Subject: Re: [RFC] do_hashed and wq enqueue
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <f0662f54-3964-9cef-151d-3102c9280757@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <00a3935a-043a-ee60-2206-2e62ec8c2936@kernel.dk>
Date:   Tue, 11 Feb 2020 13:30:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <f0662f54-3964-9cef-151d-3102c9280757@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/11/20 1:20 PM, Pavel Begunkov wrote:
> Hi,
> 
> I've been looking for hashed io-wq enqueuing, but not fully understand the
> issue. As I remember, it was something about getting around blocking for
> buffered I/O. Is that so? Is there any write-up of a thread for this issue?

Not sure if there's a writeup, but the issue is that buffered writes all
need to grab the per-inode mutex. Hence if you don't serialize these writes,
you end up having potentially quite a few threads banging on the same mutex.
This causes a high level of lock contention (and scheduling). By serializing
by inode hash we avoid that, and yield the same performance.

Dave Chinner is working on lifting this restriction, at which point we'll
have to gate the hashing based on whether or not the fs is smart or dumb
when it comes to buffered writes and locking.

> My case is 2-fd request, and I'm not sure how it should look. For splice() it's
> probably Ok to hash the non-pipe end (if any), but I wonder how it should work,
> if, for example, the restriction will be removed.

Probably just do the same, but for the output fd only (and following the
same restrictions in terms of file type).

-- 
Jens Axboe

