Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D482C3B111A
	for <lists+io-uring@lfdr.de>; Wed, 23 Jun 2021 02:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhFWAn1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Jun 2021 20:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhFWAn1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Jun 2021 20:43:27 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2BEC061574
        for <io-uring@vger.kernel.org>; Tue, 22 Jun 2021 17:41:10 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id a11so993710ilf.2
        for <io-uring@vger.kernel.org>; Tue, 22 Jun 2021 17:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VeZ0EFjONvffJ5nrLTjLY2ZtISSusUKqsUEboNLHDIw=;
        b=m2QtKIBDwKTDpWl1+AjNrhQcA0Q70ZZIDCMtbHN04QlwPrRzaFcMKds7POOJJPB2vM
         KXx0pH10Q9kjvJkLA3KO7o1bCFuFlgZxZT1JqpcE2QSEMQzaOQaDZnYt8dm+h4CgLFqT
         s+iX555QqrM2hwr9Bf5y/g18XNyrcWxXDtzv45NGmSC22a194iIqnxAd0xcWvHMfk+CE
         kL2rKh8tsVzxwJBhXHNwUtDcS0M5K23cRoDy6RRuhmhZGNDZTKJXAfhau5zTyvfFzsQ2
         LbQawnVyh+UnL5J8esMWhXSsEC6k6M7OFzyZbSNs5sK2tWhgTUzto1g86SzcsjkSUu+2
         aFsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VeZ0EFjONvffJ5nrLTjLY2ZtISSusUKqsUEboNLHDIw=;
        b=kDLdONwn3kMDqny4Nrfj3GIlYmduo+8/V31OYUpjfF2T6wDSfjyBJ6dG+Gi6J7B0ki
         MO1XrFcCVnha2FPAUH7yRWUAwP3vnZzQcYpqI/q2CQdf3tHl7mxa69gJtNln88quvLOh
         kvGdWhAS6EdtSmWaJQnZTtf7ljJVwGCjEP4mHUP2vT3pIrP+y3/xNtbTkmCOkHF5Np+Z
         S0h/9L5OTXV3cGdRDdRFq+vYyBwkkkFyCvFZMjosbPKJgL1e+4HuClP3HzBxrRkliimF
         pTzLJpIefI0TsQYC5t/ewM6vbWNBVu47vgF9ccuCSTQWiXNS1iy06jeHORBlNnK2vLnx
         yShg==
X-Gm-Message-State: AOAM533wqn9wS0vq/Vq28K0g8v2DB3dbNu+zUXJsHQQqahZATQh6pfAN
        FlECs+zC5V/ypKwWoZAn2ejq4hetx+ycIA==
X-Google-Smtp-Source: ABdhPJwMb84Z4hdLdAKh9Fi3ooQEQiKpeEw+bERxzUlBGQDcG7LAc4BnbD8KUukaTh3gKwu6vB6VHA==
X-Received: by 2002:a92:d24d:: with SMTP id v13mr939016ilg.165.1624408869154;
        Tue, 22 Jun 2021 17:41:09 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id q26sm10829303ioi.25.2021.06.22.17.41.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 17:41:08 -0700 (PDT)
Subject: Re: [PATCH v5 02/10] io_uring: add support for IORING_OP_MKDIRAT
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dmitry Kadashev <dkadashev@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
References: <20210603051836.2614535-1-dkadashev@gmail.com>
 <20210603051836.2614535-3-dkadashev@gmail.com>
 <f45781a8-234e-af92-e73d-a6453bd24f16@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8ba54fef-6291-47b3-4a49-03ac6e684030@kernel.dk>
Date:   Tue, 22 Jun 2021 18:41:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f45781a8-234e-af92-e73d-a6453bd24f16@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/22/21 11:41 AM, Pavel Begunkov wrote:
> On 6/3/21 6:18 AM, Dmitry Kadashev wrote:
>> IORING_OP_MKDIRAT behaves like mkdirat(2) and takes the same flags
>> and arguments.
> 
> Jens, a fold-in er discussed, and it will get you
> a conflict at 8/10

Folded in, thanks.

-- 
Jens Axboe

