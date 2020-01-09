Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA117135C63
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2020 16:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731037AbgAIPOa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jan 2020 10:14:30 -0500
Received: from mail-pj1-f46.google.com ([209.85.216.46]:35921 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729743AbgAIPOa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jan 2020 10:14:30 -0500
Received: by mail-pj1-f46.google.com with SMTP id n59so1286202pjb.1
        for <io-uring@vger.kernel.org>; Thu, 09 Jan 2020 07:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6Nb9hBUFaTsDu7HHPd6qiMMuTxTsKFpzVgDBCvVDW6E=;
        b=gte0ZBLGkSjw2dYm+xWEcP6TYlhWDn1pDT9SvaHcovdTC8aOezjvH6RSdz6w/Bl4Hs
         KOyny3P1CJ9Gobe6cAVkWLZYDNM1tNFFOh2hLM4xWfKZuWvdfkQA5DLWJTioJdRUBjhY
         3jmJgK/BuSU802OQpD/F05vRKhXEHGklSH6ANopj+jRDc2lEI6LveZc2VzPX+k34CJ25
         OEWudtavW4vlA+P/n9VtafqClLLBYfdopZUHhsWVtBDFQtjlqFHtQkg5NfIoHbBrmQmO
         LuJGPQ4VUuHDHcZUmGNkuNMx5/ht1RGy+jbYWdeprs8BjytNMLMc7p20zYOXejIYOnl4
         50Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6Nb9hBUFaTsDu7HHPd6qiMMuTxTsKFpzVgDBCvVDW6E=;
        b=aU0Nc5taT0kglm8QdsPnLNWrCAOvuQfr7ng/6fObe1jiM8GsoQ5eV2VNP3tvxWnb7Z
         kPLfh6GDsRdK8LrycNpL0rlrsKdRKUpnoYq7fQjLWR013uji78+MfWp8zxANa8Rscr1p
         6bFLNdZPQ4RZFVGyv3GjMmBKpnBgCG1Wuku9hVrb05620hYUBrzarT6T+TA/Lgoi7FJs
         1UJH/E0v1LvyR0MUn2vjKAfPo/CKGqUgRi9E6odGPffnNBLNsVv5dtmpVns9a7GRuHqk
         wP/4JB+qsyzdGTs0Iv3B4axndhrGFvm94dRdb36QKSvawQxpFPj7D+4BPkTJXdCCkWp+
         Imww==
X-Gm-Message-State: APjAAAVB575Ra2L00IN58yE+4N1z/6Kme0DqoqFim2aoruARQpzrt2Nc
        nPAtXwwCdHeVmzFhr8c7DQ5rMEGlg5I=
X-Google-Smtp-Source: APXvYqzGjzXTKEElOcq95iqbwYVXXZTGvF+wOsgzS4hNM9Tw8qd/GgSSvm+Z256aXCeI9I3bdJB6dg==
X-Received: by 2002:a17:902:d918:: with SMTP id c24mr1913476plz.167.1578582868936;
        Thu, 09 Jan 2020 07:14:28 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id d14sm3694626pjz.12.2020.01.09.07.14.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 07:14:28 -0800 (PST)
Subject: Re: io_uring and spurious wake-ups from eventfd
To:     Daurnimator <quae@daurnimator.com>
Cc:     Mark Papadakis <markuspapadakis@icloud.com>,
        io-uring@vger.kernel.org
References: <2005CB9A-0883-4C35-B975-1931C3640AA1@icloud.com>
 <55243723-480f-0220-2b93-74cc033c6e1d@kernel.dk>
 <60360091-ffce-fc8b-50d5-1a20fecaf047@kernel.dk>
 <4DED8D2F-8F0B-46FB-800D-FEC3F2A5B553@icloud.com>
 <d949ea3a-bd24-e597-b230-89b7075544cc@kernel.dk>
 <CAEnbY+fSuT+bBztpOUNJY3cq2pZ6tbFvKkSUeY+mEVwjtdNDow@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fea925d2-b9a2-72e5-d1ed-59c7adf86171@kernel.dk>
Date:   Thu, 9 Jan 2020 08:14:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAEnbY+fSuT+bBztpOUNJY3cq2pZ6tbFvKkSUeY+mEVwjtdNDow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/8/20 11:09 PM, Daurnimator wrote:
> On Thu, 9 Jan 2020 at 03:25, Jens Axboe <axboe@kernel.dk> wrote:
>> I see what you're saying, so essentially only trigger eventfd
>> notifications if the completions happen async. That does make a lot of
>> sense, and it would be cleaner than having to flag this per request as
>> well. I think we'd still need to make that opt-in as it changes the
>> behavior of it.
>>
>> The best way to do that would be to add IORING_REGISTER_EVENTFD_ASYNC or
>> something like that. Does the exact same thing as
>> IORING_REGISTER_EVENTFD, but only triggers it if completions happen
>> async.
>>
>> What do you think?
> 
> 
> Why would a new opcode be cleaner than using a flag for the existing
> EVENTFD opcode?

A few reasons I can think of:

1) We don't consume an IOSQE flag, which is a pretty sparse resource.
2) This is generally behavior where you either want one or the other,
   not a mix. Hence a general setup/modify flag makes more sense to me.

-- 
Jens Axboe

