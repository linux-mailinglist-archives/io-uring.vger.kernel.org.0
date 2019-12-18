Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E66B31244D6
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 11:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbfLRKlU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Dec 2019 05:41:20 -0500
Received: from mail-lj1-f179.google.com ([209.85.208.179]:43490 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfLRKlU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Dec 2019 05:41:20 -0500
Received: by mail-lj1-f179.google.com with SMTP id a13so1550912ljm.10;
        Wed, 18 Dec 2019 02:41:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RFlrnbafUoOgoYreP9Bk4IUKE+yM7F9agS4DNHCp3HE=;
        b=Tb9iZILusjmJ+e8Xj8MMGFG4Qz27MiWpYhWKE6kab+K6EY2nLVgDoTXrMRod8Rj4GG
         Ba9JNIJR4dmXwq/tfH4AVH0Q/naiQzaohNIqFVUxEhvCl+wdY98cddlQSJVOJAMKXYPv
         QTMFlCFlvbLavgxaA8sGzNw5jTiqutV3uiMZ98GxPZWcdI+yaPbpCrZn2YiM5rDAzoMX
         VrptnnC7aXX1tUxxLKMEL4S/FhtLXsK3VDlwKXvLuUMj+UsGznpdbYR+GptDzYdb2sv8
         YVDxUwzrFWUe9n/kXKTd9lTqErmU+dQcYc7qky+zoDurFsq9tyHbMxND/jopOuAjBWeu
         OwOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RFlrnbafUoOgoYreP9Bk4IUKE+yM7F9agS4DNHCp3HE=;
        b=eK3AM1Ff36odLEsfmRNBqNp1Yaq/0wMH1tXqq+GzBWUnU5EfPZ2T8vtboZMYRN9QzU
         ICr8IK6+g8kndbOUA3RmP9SIN+Aj7TdLeIuMcUmWTWr76zjnJn4Pd9oa0FVcINjdpyY1
         kKakXd7vVa5BtONuRPxy1dhK+GdJFpeuU0MmPhauQkvC9ZPwhEj/ogdd44j5AM76YsMT
         WgESmMOFL0SFSnRAfgSvEBD5VTUztOSWWFhIQO88DAUpqyACXbfbPR1UpY548Nd24l74
         2XvpH+ZZ9I3ohNS8n0v15dBl22+g3XYzeEENEm89+I8cKFPCGHuxiU9uqTxDleCk2RI2
         Qf+w==
X-Gm-Message-State: APjAAAUc4kY0lUVjYnkrwC+WsJ6zGGWVmVx5S+ksPqEtv0BMdscXk0qt
        Tv8/VJp519sMsjJBKwIxj7WJSInSams=
X-Google-Smtp-Source: APXvYqzayPELPRKJAZ6ALuxcdIEdWN23CQtjaI65AzAvNQxJwW9Ng/YaWDimDn5iRZPw0/hnBFKv7w==
X-Received: by 2002:a2e:a37c:: with SMTP id i28mr1249073ljn.118.1576665677442;
        Wed, 18 Dec 2019 02:41:17 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id d11sm931887lfj.3.2019.12.18.02.41.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Dec 2019 02:41:15 -0800 (PST)
Subject: Re: [PATCH 2/2] io_uring: batch getting pcpu references
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1576621553.git.asml.silence@gmail.com>
 <b72c5ec7f6d9a9881948de6cb88d30cc5e0354e9.1576621553.git.asml.silence@gmail.com>
 <6ae04c15-e410-5ecc-660a-389fbb03d8ea@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <660821b5-5b7b-aa76-0990-a37f1bdc17b4@gmail.com>
Date:   Wed, 18 Dec 2019 13:41:14 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <6ae04c15-e410-5ecc-660a-389fbb03d8ea@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/18/2019 3:02 AM, Jens Axboe wrote:
> On 12/17/19 3:28 PM, Pavel Begunkov wrote:
>> percpu_ref_tryget() has its own overhead. Instead getting a reference
>> for each request, grab a bunch once per io_submit_sqes().
>>
>> basic benchmark with submit and wait 128 non-linked nops showed ~5%
>> performance gain. (7044 KIOPS vs 7423)
> 
> Confirmed about 5% here as well, doing polled IO to a fast device.
> That's a huge gain!
> 
Great that you got it for a real drive!
As mentioned, after we are done with this one, I have an idea how to
optimise it even further, which would work for small QD as well.

-- 
Pavel Begunkov
