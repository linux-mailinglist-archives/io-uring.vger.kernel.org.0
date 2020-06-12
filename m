Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5CE51F7A97
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2020 17:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgFLPTX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Jun 2020 11:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgFLPTV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Jun 2020 11:19:21 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661C7C03E96F
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2020 08:19:21 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id jz3so3777905pjb.0
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2020 08:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EEAEfPt+vQiYKjMKNJjnTTZ9Tz6OJ5Xibm/pwWgf6xk=;
        b=yyy0M+d+oSGq4dBQkwYpieQ2FaSnB8PG7ZftQ3YSc+6BzGXaccIlSUf0Ew2jkSEVgu
         MBUZ3JANvGbuNKghZxH+zt2YfvFB8SG/5wYZQiEr2rK14CQ23p2Pq1gdTcw3hmXRN+R0
         jYsIC8x+n1EpXx44jpr96DJCre5gnLLwwSLK0U6GT6Ev9Dkz3zzrIRbfiusl44fFtxLu
         1mTvaiT2avaZwWv98SVyeHw6CrN0JVMWKLvYpU1m+RgIaLAMoNj34ahkFVuEAIRqefE5
         /ipxJ/V7iJVovCMwK/yRNN/3cFZ1g3liph5oDf7cEcEKaiDPdouYGjk9zU8A1I641G4G
         4s1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EEAEfPt+vQiYKjMKNJjnTTZ9Tz6OJ5Xibm/pwWgf6xk=;
        b=sLI/PLx3DYIRG7Rn7QcwclznOAT+K5Q1cmjSgs6ULCE4qaeglGqgQXBCCv+zLFzFi+
         7aVMuGc8vl1nhY6jThwPm8mxenjBd8yFgdi1t4PNgLNygcQsElM7cAtHt0XSsGrtH9/1
         221eUHmoClq0X9dA3ZcgBS/2hg859R7p0mD3OYnS1maW1+PEdXs743eFr7JAMEQrHNZG
         VrY6ryal230YrqJMOY8V5/G9Exv2dmAVFnjUaH3WxCyg+vc1ZaDvnEH/QwSzR2pwf6qR
         fLuFmim1qf4n0/mYm7H/TcOqAv9PEQ6cqbEkSKQi/AFCaZJO8qoSpZKiMAFOafqBzQlt
         6m/A==
X-Gm-Message-State: AOAM533HQjMXGbwQ6WL+2gMzG7/wSC9dLijfOBLUeKEBTWNPXBSESQ3p
        a3TOSlpwYnVy4Yd5hMWt3EcJGjcVCpZESg==
X-Google-Smtp-Source: ABdhPJxFrSNeHeR+bMeJeYGhDYkxX3d/t1xChNw/XbusKUSi0U3fQxgZrNpDgX9TQFa8rcxzzGn+cg==
X-Received: by 2002:a17:902:59c5:: with SMTP id d5mr11420348plj.249.1591975160427;
        Fri, 12 Jun 2020 08:19:20 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id o2sm5608053pjp.53.2020.06.12.08.19.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2020 08:19:19 -0700 (PDT)
Subject: Re: [RFC 2/2] io_uring: report pinned memory usage
From:   Jens Axboe <axboe@kernel.dk>
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     io-uring@vger.kernel.org
References: <1591928617-19924-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1591928617-19924-3-git-send-email-bijan.mottahedeh@oracle.com>
 <b08c9ee0-5127-a810-de01-ebac4d6de1ee@kernel.dk>
Message-ID: <6b2ef2c9-5b58-f83e-b377-4a2e1e3e98e5@kernel.dk>
Date:   Fri, 12 Jun 2020 09:19:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <b08c9ee0-5127-a810-de01-ebac4d6de1ee@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/12/20 9:16 AM, Jens Axboe wrote:
> On 6/11/20 8:23 PM, Bijan Mottahedeh wrote:
>> Long term, it makes sense to separate reporting and enforcing of pinned
>> memory usage.
>>
>> Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
>>
>> It is useful to view
>> ---
>>  fs/io_uring.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 4248726..cf3acaa 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -7080,6 +7080,8 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
>>  static void io_unaccount_mem(struct user_struct *user, unsigned long nr_pages)
>>  {
>>  	atomic_long_sub(nr_pages, &user->locked_vm);
>> +	if (current->mm)
>> +		atomic_long_sub(nr_pages, &current->mm->pinned_vm);
>>  }
>>  
>>  static int io_account_mem(struct user_struct *user, unsigned long nr_pages)
>> @@ -7096,6 +7098,8 @@ static int io_account_mem(struct user_struct *user, unsigned long nr_pages)
>>  			return -ENOMEM;
>>  	} while (atomic_long_cmpxchg(&user->locked_vm, cur_pages,
>>  					new_pages) != cur_pages);
>> +	if (current->mm)
>> +		atomic_long_add(nr_pages, &current->mm->pinned_vm);
>>  
>>  	return 0;
>>  }
> 
> current->mm should always be valid for these, so I think you can skip the
> checking of that and just make it unconditional.

Two other issues with this:

- It's an atomic64, so seems more appropriate to use the atomic64 helpers
  for this one.
- The unaccount could potentially be a different mm, if the ring is shared
  and one task sets it up while another tears it down. So we'd need something
  to ensure consistency here.

-- 
Jens Axboe

