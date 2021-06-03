Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D2F39A9AA
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 20:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhFCSDv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 14:03:51 -0400
Received: from mail-io1-f44.google.com ([209.85.166.44]:33280 "EHLO
        mail-io1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbhFCSDu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 14:03:50 -0400
Received: by mail-io1-f44.google.com with SMTP id a6so7332192ioe.0
        for <io-uring@vger.kernel.org>; Thu, 03 Jun 2021 11:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DfpqVKDN7hOtEa+CuSVevXQHMmCHrLQiuvdpBtZOZ8M=;
        b=M2Y+kaVRop9BeW/zQOdqXE7OlrPIo+DeLCK0kXyWT5hIsfnDdyfeuKHRsfgEWLyzSf
         I4s+W8zvZxfFaRyrugpnW2euJE3ji8x6NDnEikYU1H8KeYyUJNSrMlQCgdEnQWqni8i+
         DXupAiWWy4+Kher7Sih5Dyu+N5gncmchdFglZqHtQois9OKAwJy74rljW4J7fcvBliI6
         ntMWwn6VczYMs7FjpTYCbUzmhD1nTfNAw8wZlXbPmJ6UvfXkrkk+tKvXCkpSzjcz4Nt6
         6W/RmVUtFW0y7KXXK6Vz2boPLybCJT+r1i5tISi8J+3vZNC9zV+WRZLPxQ4KeO0BlbHA
         9s/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DfpqVKDN7hOtEa+CuSVevXQHMmCHrLQiuvdpBtZOZ8M=;
        b=J+BFtTMqqfIUjVQZuPZpSUjT9KzKvGeYya/23rATj65ZgyAcpTGbISCYydEF07tGkl
         Pz0CkrkR5Q/aNN+54K8sK1DEgikqfjPHpdZcAsrwHH9nobfmAxP7cof4X30jqzNUYzSC
         aJC8ulcYqMzURwtg51/VfZkmtKPFGcOYmzHZGvRA9eU5PMlK/5UjhuXzCc9bxZaFaNm/
         L7QPf0EPmzbWxWrGYUnJcXWfVliGz8YtX/DcQOAFLz+A8d6GAQzGPxNA4vXjxOcsg4c8
         wceBYlSsLwZCFl9RvnRKelDyeKVZO8DgoA1sqGtO3bE0q8ZVuVuVId8I7o2VYa9gyE5v
         lLiw==
X-Gm-Message-State: AOAM532rafIyJ0HbJZpmoRTU4cGD3UwD0Y92yehTFzcP07aj1ZKCI4Vx
        H/paHlGI3MfW0doGOZ/dUfrKE1VltjxZb3Cw
X-Google-Smtp-Source: ABdhPJwOlwBYAUJ5vzbhsqb+fsBpQUXSyqbZoapqxwIsWiYn+ynJ2iQplXxmBmtW9tKyfiAaSihqVw==
X-Received: by 2002:a02:c73a:: with SMTP id h26mr217519jao.95.1622743265479;
        Thu, 03 Jun 2021 11:01:05 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id q11sm2088488ilj.80.2021.06.03.11.01.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 11:01:05 -0700 (PDT)
Subject: Re: Question about poll_multi_file
To:     Hao Xu <haoxu@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <e90a3bdd-d60c-9b82-e711-c7a0b4f32c09@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f2fa9534-e07c-fd18-759e-b3ca99b714a7@kernel.dk>
Date:   Thu, 3 Jun 2021 12:01:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e90a3bdd-d60c-9b82-e711-c7a0b4f32c09@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/3/21 6:53 AM, Hao Xu wrote:
> Hi Jens,
> I've a question about poll_multi_file in io_do_iopoll().
> It keeps spinning in f_op->iopoll() if poll_multi_file is
> true (and we're under the requested amount). But in my
> understanding, reqs may be in different hardware queues
> for blk-mq device even in this situation.
> Should we consider the hardware queue number as well? Some
> thing like below:

That looks reasonable to me - do you have any performance
numbers to go with it?

-- 
Jens Axboe

